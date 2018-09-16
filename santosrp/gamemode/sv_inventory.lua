--[[
	Name: sv_inventory.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Inv = (GAMEMODE or GM).Inv or {}
GM.Inv.m_tblItemRegister = (GAMEMODE or GM).Inv.m_tblItemRegister or {}
GM.Inv.m_tblItemLimits = (GAMEMODE or GM).Inv.m_tblItemLimits or {}
GM.Inv.m_tblEquipmentSlots = {
	["Head"] = { Type = "Head", KeepOnDeath = true },
	["Face"] = { Type = "Face", KeepOnDeath = true },
	["Eyes"] = { Type = "Eyes", KeepOnDeath = true },
	["Neck"] = { Type = "Neck", KeepOnDeath = true },
	["Back"] = { Type = "Back", KeepOnDeath = true },

	["PrimaryWeapon"] = { Type = "PrimaryWeapon" },
	["SecondaryWeapon"] = { Type = "SecondaryWeapon" },
	["AltWeapon"] = { Type = "AltWeapon" },
}

function GM.Inv:Initialize()
	self.m_tblCachedAmmoTypes = game.BuildAmmoTypes()
end

--[[ Item Management ]]--
function GM.Inv:LoadItems()
	GM:PrintDebug( 0, "->LOADING ITEMS" )

	local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "items/*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( GM.Config.GAMEMODE_PATH.. "items/".. v )
		AddCSLuaFile( GM.Config.GAMEMODE_PATH.. "items/".. v )
	end

	GM:PrintDebug( 0, "->ITEMS LOADED" )
end

function GM.Inv:RegisterItem( tblItem )
	self.m_tblItemRegister[tblItem.Name] = tblItem
	GM:PrintDebug( 0, "\t\tRegistered item ".. tblItem.Name )
end

function GM.Inv:RegisterItemLimit( strLimitID, intMaxLimit, tblGroupExtras )
	if not strLimitID or self.m_tblItemLimits[strLimitID] then return end
	self.m_tblItemLimits[strLimitID] = { Base = intMaxLimit or 1, Groups = tblGroupExtras or {} }
end

function GM.Inv:GetItem( strItemName )
	return self.m_tblItemRegister[strItemName]
end

function GM.Inv:GetItems()
	return self.m_tblItemRegister
end

function GM.Inv:ValidItem( strItemName )
	return self.m_tblItemRegister[strItemName] and true or false
end

function GM.Inv:PlayerUse( pPlayer, eEnt )
	if not eEnt.IsItem then return end
	if not pPlayer:KeyDown( IN_WALK ) then return end
	if eEnt.ItemTakeBlocked then return end

	local itemData = self:GetItem( eEnt.ItemID )
	if not itemData then return end

	if pPlayer.m_intLastItemTakeTime and pPlayer.m_intLastItemTakeTime > CurTime() then return false end
	pPlayer.m_intLastItemTakeTime = CurTime() +0.5
	
	if hook.Call( "GamemodePlayerPickupItem", GAMEMODE, pPlayer, eEnt ) == false then
		return false
	end

	--police should confiscate and destroy these items
	--if they aren't currently sharing prop protection with the owner, destroy it
	if itemData.Illegal and GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_POLICE then
		if eEnt:GetPlayerOwner() ~= pPlayer and not GAMEMODE.Buddy:IsItemShared( eEnt:GetPlayerOwner(), pPlayer ) then
			eEnt:Remove()
			pPlayer:AddNote( "You destroyed an illegal item." )
			return
		end
	end

	if not GAMEMODE.PropProtect:PlayerUse( pPlayer, eEnt ) and self:PlayerPickupItem( pPlayer, eEnt ) then
		return true
	end
end

function GM.Inv:PlayerSpawn( pPlayer )
	self:UpdatePlayerMoveSpeed( pPlayer )
	self:RestoreSavedAmmo( pPlayer )
end

function GM.Inv:PlayerDeath( pPlayer )
	self:PlayerAbortCraft( pPlayer )
end

function GM.Inv:GamemodeOnCharacterDeath( pPlayer )
	self:RemoveJobItems( pPlayer )
	self:DropItemsOnDeath( pPlayer )
	self:RemoveIllegalItems( pPlayer )

	pPlayer:StripAmmo()
	pPlayer:StripWeapons()

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if saveTable then
		saveTable.SavedAmmo = {}
	end
	
	self:InvalidateSavedPlayerAmmo( pPlayer )
end

function GM.Inv:PlayerDisconnected( pPlayer )
end

function GM.Inv:PlayerLoadout( pPlayer )
	self:ValidateJobItems( pPlayer ) --Look for and remove job items that don't match the player's job
	self:EquipCharacterItemsOnSpawn( pPlayer )
end

function GM.Inv:EntityRemoved( eEnt )
	if not eEnt.IsItem then return end
	if eEnt.ItemID and IsValid( eEnt.CreatedBy ) then
		self:RemovePlayerItemLimit( eEnt.CreatedBy, eEnt.ItemID, 1 )
	end
end

function GM.Inv:ValidateJobItems( pPlayer )
	for itemName, itemAmount in pairs( pPlayer:GetInventory() ) do
		local itemData = self:GetItem( itemName )
		if not itemData then pPlayer:GetInventory()[itemName] = nil continue end
		if not itemData.JobItem then continue end
		if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= _G[itemData.JobItem] then --Player is not allowed to have this item
			pPlayer:GetInventory()[itemName] = nil

			GAMEMODE.Net:SendInventoryUpdate( pPlayer, itemName, 0 )
			GAMEMODE.SQL:MarkDiffDirty( pPlayer, "inventory", itemName )
		end
	end

	for slotName, itemID in pairs( pPlayer:GetEquipment() ) do
		local itemData = self:GetItem( itemID )
		if not itemData or not itemData.JobItem then continue end

		if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= _G[itemData.JobItem] then --Player is not allowed to have this item
			GAMEMODE.Player:SetSharedGameVar( pPlayer, "eq_slot_".. slotName, "" )
			GAMEMODE.SQL:MarkDiffDirty( pPlayer, "equipped", slotName )
		end
	end
end

--[[ Item Limits ]]--
function GM.Inv:GetTotalPlayerItemCount( pPlayer )
	local count = 0
	for k, v in pairs( pPlayer.m_tblGamemodeItemLimits or {} ) do
		count = count +v
	end

	return count
end

function GM.Inv:GetTotalMaxItems( pPlayer )
	local extra = 0
	for k, v in pairs( GAMEMODE.Config.GroupExtraMaxItems ) do
		if not pPlayer:CheckGroup( k ) then continue end
		extra = extra +v
	end

	return GAMEMODE.Config.MaxItemLimit +extra
end

function GM.Inv:GetMaxItemLimit( strItemID, pPlayer )
	local itemData = self:GetItem( strItemID )
	if not itemData or not itemData.LimitID then return self:GetTotalMaxItems( pPlayer ) end

	local extra = 0
	for k, v in pairs( self.m_tblItemLimits[itemData.LimitID].Groups ) do
		if not pPlayer:CheckGroup( k ) then continue end
		extra = extra +v
	end

	return self.m_tblItemLimits[itemData.LimitID].Base +extra
end

function GM.Inv:GetPlayerItemCount( pPlayer, strItemID )
	if not pPlayer.m_tblGamemodeItemLimits then return 0 end
	local itemData = self:GetItem( strItemID )
	if not itemData then return 0 end
	local tbl, keyName = pPlayer.m_tblGamemodeItemLimits, itemData.LimitID or strItemID	

	return tbl[keyName] or 0
end

function GM.Inv:GetPlayerDiffToMaxLimit( pPlayer, strItemID )
	local itemData = self:GetItem( strItemID )
	if not itemData then return end

	if not itemData.LimitID then
		return self:GetTotalMaxItems( pPlayer ) -self:GetTotalPlayerItemCount( pPlayer )
	else
		return self:GetMaxItemLimit( strItemID, pPlayer ) -self:GetPlayerItemCount( pPlayer, strItemID )
	end
end

function GM.Inv:PlayerLimitHitNotice( pPlayer, strItemID, intAmount )
	local itemData = self:GetItem( strItemID )
	if not itemData then return end
	intAmount = intAmount or 1
	local limit = self:GetMaxItemLimit( strItemID, pPlayer )

	local maxItems = self:GetTotalMaxItems( pPlayer )
	if self:GetTotalPlayerItemCount( pPlayer ) +intAmount > maxItems then
		pPlayer:AddNote( "You have hit the maximum item limit! (".. maxItems.. ")" )
		return true
	end

	if itemData.LimitID then
		local tbl, keyName = pPlayer.m_tblGamemodeItemLimits or {}, itemData.LimitID or strItemID
		tbl[keyName] = tbl[keyName] or 0

		if tbl[keyName] +intAmount > limit then
			pPlayer:AddNote( "You have hit the ".. itemData.LimitID.. " limit! (".. limit.. ")" )
			return true
		end
	end	
end

function GM.Inv:AddPlayerItemLimit( pPlayer, strItemID, intAmount )
	if not pPlayer.m_tblGamemodeItemLimits then
		pPlayer.m_tblGamemodeItemLimits = {}
	end

	local itemData = self:GetItem( strItemID )
	if not itemData then return end
	local tbl, keyName = pPlayer.m_tblGamemodeItemLimits, itemData.LimitID or strItemID
	tbl[keyName] = tbl[keyName] or 0

	if self:PlayerLimitHitNotice( pPlayer, strItemID, intAmount ) then
		return false
	end

	tbl[keyName] = tbl[keyName] +intAmount
	return true
end

function GM.Inv:RemovePlayerItemLimit( pPlayer, strItemID, intAmount )
	if not pPlayer.m_tblGamemodeItemLimits then return end
	
	local itemData = self:GetItem( strItemID )
	if not itemData then return end
	local tbl, keyName = pPlayer.m_tblGamemodeItemLimits, itemData.LimitID or strItemID
	if not tbl[keyName] then return end
	
	tbl[keyName] = tbl[keyName] -intAmount
	if tbl[keyName] <= 0 then
		tbl[keyName] = nil
	end
end

--[[ Inventory Management ]]--
function GM.Inv:ComputeWeight( tblInventory )
	local weight = 0
	for itemName, itemAmount in pairs( tblInventory ) do
		weight = weight +(self:GetItem( itemName ).Weight *itemAmount)
	end

	return weight
end

function GM.Inv:ComputeVolume( tblInventory )
	local volume = 0
	for itemName, itemAmount in pairs( tblInventory ) do
		volume = volume +(self:GetItem( itemName ).Volume *itemAmount)
	end

	return volume
end

function GM.Inv:ComputeWeightAndVolume( tblInventory )
	local weight, volume = 0, 0
	local curItem

	for itemName, itemAmount in pairs( tblInventory ) do
		curItem = self:GetItem( itemName )
		weight = weight +(curItem.Weight *itemAmount)
		volume = volume +(curItem.Volume *itemAmount)
	end

	return weight, volume
end

function GM.Inv:ComputePlayerInventorySize( pPlayer )
	local weight, volume = GAMEMODE.Config.MaxCarryWeight, GAMEMODE.Config.MaxCarryVolume

	local item
	for slotID, itemName in pairs( pPlayer:GetEquipment() ) do
		item = self:GetItem( itemName )

		if item and item.EquipBoostCarryWeight then
			weight = weight +item.EquipBoostCarryWeight
		end
		if item and item.EquipBoostCarryVolume then
			volume = volume +item.EquipBoostCarryVolume
		end
	end

	return weight, volume
end

function GM.Inv:PlayerHasItem( pPlayer, strItemID, intAmount )
	local inv = pPlayer:GetInventory()
	if not inv then return false end
	if not inv[strItemID] then return false end
	if inv[strItemID] < (intAmount or 1) then return false end
	return true
end

function GM.Inv:GetPlayerItemAmount( pPlayer, strItemID )
	local inv = pPlayer:GetInventory()
	if not inv then return 0 end
	if not inv[strItemID] then return 0 end
	return inv[strItemID]
end

function GM.Inv:GivePlayerItem( pPlayer, strItemID, intAmount )
	if not pPlayer:Alive() then return false end
	local inv = pPlayer:GetInventory()
	if not inv then return false end
	
	local itemData = self:GetItem( strItemID )
	if not itemData then return false end
	
	intAmount = intAmount or 1
	local curWeight, curVolume = self:ComputeWeightAndVolume( inv )
	local addWeight, addVolume = itemData.Weight *intAmount, itemData.Volume *intAmount
	local maxWeight, maxVolume = self:ComputePlayerInventorySize( pPlayer )

	if curWeight +addWeight > maxWeight then
		pPlayer:AddNote( "You are at your max carry weight!" )
		return false
	end

	if curVolume +addVolume > maxVolume then
		pPlayer:AddNote( "You are at your max carry volume!" )
		return false
	end

	if not inv[strItemID] then
		inv[strItemID] = 0
	end

	inv[strItemID] = inv[strItemID] +intAmount
	GAMEMODE.Net:SendInventoryUpdate( pPlayer, strItemID, inv[strItemID] )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "inventory", strItemID )
	self:UpdatePlayerMoveSpeed( pPlayer )
	hook.Call( "GamemodePlayerItemGiven", GAMEMODE, pPlayer, strItemID, intAmount )

	return true
end

function GM.Inv:TakePlayerItem( pPlayer, strItemID, intAmount )
	local inv = pPlayer:GetInventory()
	if not inv then return false end
	if not inv[strItemID] then return false end

	intAmount = intAmount or 1
	if inv[strItemID] -intAmount < 0 then return false end
	inv[strItemID] = inv[strItemID] -intAmount
	GAMEMODE.Net:SendInventoryUpdate( pPlayer, strItemID, inv[strItemID] )

	if inv[strItemID] == 0 then
		inv[strItemID] = nil
	end

	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "inventory", strItemID )
	self:UpdatePlayerMoveSpeed( pPlayer )
	hook.Call( "GamemodePlayerItemTaken", GAMEMODE, pPlayer, strItemID, intAmount )

	return true
end

function GM.Inv:UpdatePlayerMoveSpeed( pPlayer )
	local inv = pPlayer:GetInventory()
	if not inv then return end

	local maxWeight, maxVolume = self:ComputePlayerInventorySize( pPlayer )
	local weight = self:ComputeWeight( inv )

	if weight > maxWeight *0.5 then
		local min = maxWeight *0.5
		local max = (maxWeight *0.9) -min
		local scalar = 1 -math.Clamp( (max -(weight -min)) /max, 0, 1 )
		GAMEMODE.Player:ModifyMoveSpeed( pPlayer, "Inventory", 0, Lerp(scalar, 0, -35) )
	elseif weight <= maxWeight *0.5 then
		if GAMEMODE.Player:IsMoveSpeedModifierActive( pPlayer, "Inventory" ) then
			GAMEMODE.Player:RemoveMoveSpeedModifier( pPlayer, "Inventory" )
		end
	end
end

function GM.Inv:MakeItemDrop( pOwner, strItemID, intAmount, bOwnerless )
	local itemData = self:GetItem( strItemID )
	if not itemData or not itemData.CanDrop then return false end

	local tr = util.TraceLine{
		start = pOwner:GetShootPos(),
		endpos = pOwner:GetShootPos() +pOwner:GetAimVector() *150,
		filter = pOwner,
	}
	local spawnPos = tr.HitPos

	for i = 1, intAmount do
		if itemData.DropFunction then
			itemData.DropFunction( pOwner, spawnPos, Angle(0, pOwner:GetAimVector():Angle().y, 0), bOwnerless )
		end

		local ent = ents.Create( itemData.DropClass or "prop_physics" )
		ent:SetAngles( Angle(0, pOwner:GetAimVector():Angle().y, 0) )
		ent:SetModel( itemData.Model )
		if itemData.Skin then ent:SetSkin( itemData.Skin ) end
		ent.IsItem = true
		ent.ItemID = strItemID
		ent.ItemData = itemData
		ent.CreatedBy = pOwner
		ent.CreatedBySID = pOwner:SteamID()
		ent:Spawn()
		ent:Activate()
		ent:SetPos( spawnPos )
		if not bOwnerless then ent:SetPlayerOwner( pOwner ) end

		local vFlushPoint = spawnPos -(tr.HitNormal *512)
		vFlushPoint = ent:NearestPoint( vFlushPoint )
		vFlushPoint = ent:GetPos() -vFlushPoint
		vFlushPoint = spawnPos +vFlushPoint +Vector(0, 0, 2)
		ent:SetPos( vFlushPoint )
		
		if itemData.SetupEntity then
			itemData:SetupEntity( ent )
		end

		hook.Call( "PlayerDroppedItem", GAMEMODE, pPlayer, strItemID, bOwnerless, ent )
	end

	return true
end

function GM.Inv:PlayerDropItem( pPlayer, strItemID, intAmount, bOwnerless )
	if pPlayer:IsIncapacitated() then return false end
	if pPlayer:InVehicle() then return false end
	if not self:PlayerHasItem( pPlayer, strItemID, intAmount ) then return false end
	
	local itemData = self:GetItem( strItemID )
	if not itemData or not itemData.CanDrop then return false end

	local amount = math.min( self:GetPlayerDiffToMaxLimit(pPlayer, strItemID), intAmount )
	if self:PlayerLimitHitNotice( pPlayer, strItemID, amount > 0 and amount or 1 ) then
		return false
	end

	if self:TakePlayerItem( pPlayer, strItemID, amount ) then
		if self:MakeItemDrop( pPlayer, strItemID, amount, bOwnerless ) then
			self:AddPlayerItemLimit( pPlayer, strItemID, intAmount )
			return true
		end
	end
end

function GM.Inv:PlayerPickupItem( pPlayer, eEnt )
	if pPlayer:IsIncapacitated() then return false end
	if pPlayer:InVehicle() then return false end
	
	if IsValid( eEnt:GetPlayerOwner() ) then
		if eEnt:GetPlayerOwner() ~= pPlayer and not GAMEMODE.Buddy:IsItemShared( pPlayer, eEnt:GetPlayerOwner() ) then
			if eEnt.CanPlayerPickup and not eEnt:CanPlayerPickup( pPlayer, false ) then
				return false
			end
		else
			if eEnt.CanPlayerPickup and not eEnt:CanPlayerPickup( pPlayer, true ) then
				return false
			end
		end
	else
		if eEnt.CanPlayerPickup and not eEnt:CanPlayerPickup( pPlayer, true ) then
			return false
		end
	end

	if self:GivePlayerItem( pPlayer, eEnt.ItemID, 1 ) then
		eEnt:Remove()
		return true
	end

	return false
end

function GM.Inv:PlayerUseItem( pPlayer, strItemID )
	if pPlayer:IsIncapacitated() then return false end
	if pPlayer:InVehicle() then return false end
	if not self:PlayerHasItem( pPlayer, strItemID, 1 ) then return false end
	
	local itemData = self:GetItem( strItemID )
	if not itemData or not itemData.CanUse then return false end
	if type( itemData.OnUse ) ~= "function" then return false end
	
	if type( itemData.PlayerCanUse ) == "function" then
		if itemData:PlayerCanUse( pPlayer ) == false then return false end
	end

	if self:TakePlayerItem( pPlayer, strItemID, 1 ) then
		itemData:OnUse( pPlayer )
		return true
	end

	return false
end

function GM.Inv:MakeItemBox( pOwner, vecPos, angAngs, tblItems )
	local ent = ents.Create( "ent_itembox" )
	ent:SetAngles( angAngs )
	ent.CreatedBy = pOwner
	ent:SetItems( tblItems )
	ent:Spawn()
	ent:Activate()
	ent:SetPos( vecPos +Vector(0, 0, ent:OBBMaxs().z) )
	pOwner:DeleteOnRemove( ent )

	pOwner.m_tblItemBoxes = pOwner.m_tblItemBoxes or {}
	if #pOwner.m_tblItemBoxes >= 3 then
		local box = pOwner.m_tblItemBoxes[1]
		if IsValid( box ) then box:Remove() end
		table.remove( pOwner.m_tblItemBoxes, 1 )
	end

	table.insert( pOwner.m_tblItemBoxes, ent )
end

--[[ Equipment Management ]]--
function GM.Inv:RegisterEquipSlot( strSlotID, tblSlotData )
	self.m_tblEquipmentSlots[strSlotID] = tblSlotData
end

function GM.Inv:DeletePlayerEquipItem( pPlayer, strSlot )
	if pPlayer:GetEquipment()[strSlot] then
		local itemID = pPlayer:GetEquipment()[strSlot]
		pPlayer:GetEquipment()[strSlot] = nil
		GAMEMODE.Player:SetSharedGameVar( pPlayer, "eq_slot_".. strSlot, "" )
		GAMEMODE.SQL:MarkDiffDirty( pPlayer, "equipped", strSlot )

		local itemData = self:GetItem( itemID or "" )
		if not itemData then return end
		if itemData.EquipGiveClass then
			pPlayer:StripWeapon( itemData.EquipGiveClass )
		end
	end
end

function GM.Inv:DropItemsOnDeath( pPlayer )
	local items = {}
	local data

	for slotName, itemID in pairs( pPlayer:GetEquipment() or {} ) do
		if self.m_tblEquipmentSlots[slotName].KeepOnDeath then continue end
		data = self:GetItem( itemID )
		if not data then continue end

		if not data.JobItem then
			items[itemID] = items[itemID] or 0
			items[itemID] = items[itemID] +1
		end
		self:DeletePlayerEquipItem( pPlayer, slotName )
	end

	for itemID, num in pairs( pPlayer:GetInventory() or {} ) do
		data = self:GetItem( itemID )
		if not data or not data.Illegal then continue end
		if self:TakePlayerItem( pPlayer, itemID, num ) then
			if not data.JobItem then
				items[itemID] = items[itemID] or 0
				items[itemID] = items[itemID] +num
			end
		end
	end

	if table.Count( items ) <= 0 then return end
	GAMEMODE.Inv:MakeItemBox( pPlayer, pPlayer:GetPos() +Vector(0, 0, 2), Angle(0, 0, 0), items )
end

function GM.Inv:RemoveJobItems( pPlayer )
	local itemData
	for itemID, num in pairs( pPlayer:GetInventory() or {} ) do
		itemData = self:GetItem( itemID )
		if itemData then
			if itemData.JobItem then
				GAMEMODE.Inv:TakePlayerItem( pPlayer, itemID, num )
			end
		end
	end

	--Look for spawned items as well...
	for k, v in pairs( ents.GetAll() ) do
		if not v.IsItem then continue end
		itemData = self:GetItem( v.ItemID )
		if not itemData then continue end
		if itemData.RemoveDropOnDeath then
			if v:GetPlayerOwner() == pPlayer then
				v:Remove()
			end
		end
	end

	--Remove anything equipped
	for slotName, itemID in pairs( pPlayer:GetEquipment() or {} ) do
		itemData = self:GetItem( itemID )
		if itemData and itemData.JobItem then
			self:DeletePlayerEquipItem( pPlayer, slotName )
		end
	end
end

function GM.Inv:RemoveIllegalItems( pPlayer )
	local itemData
	for itemID, num in pairs( pPlayer:GetInventory() ) do
		itemData = self:GetItem( itemID )
		if itemData then
			if itemData.Illegal then
				GAMEMODE.Inv:TakePlayerItem( pPlayer, itemID, num )
			end
		end
	end
end

function GM.Inv:EquipCharacterItemsOnSpawn( pPlayer )
	for slotName, itemID in pairs( pPlayer:GetEquipment() ) do
		local itemData = self:GetItem( itemID )
		if itemData and itemData.EquipGiveClass then
			pPlayer:Give( itemData.EquipGiveClass )
		end		
	end
end

function GM.Inv:PlayerHasItemEquipped( pPlayer, strItemID )
	for slotName, itemID in pairs( pPlayer:GetEquipment() ) do
		if itemID == strItemID then
			return true, slotName
		end
	end
	return false
end

function GM.Inv:SetPlayerEquipSlotValue( pPlayer, strSlot, strValue )
	pPlayer:GetEquipment()[strSlot] = strValue
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "eq_slot_".. strSlot, strValue )
end

function GM.Inv:PlayerEquipItem( pPlayer, strSlot, strItemID )
	if pPlayer:IsIncapacitated() then return false end
	if not self.m_tblEquipmentSlots[strSlot] then return false end
	if self.m_tblEquipmentSlots[strSlot].Internal then return false end
	
	--This slot already has an item in it, remove it and place it back in their inventory
	if pPlayer:GetEquipSlot( strSlot ) then
		if self:GivePlayerItem( pPlayer, pPlayer:GetEquipSlot(strSlot) ) then
			local itemData = self:GetItem( pPlayer:GetEquipSlot(strSlot) )
			pPlayer:GetEquipment()[strSlot] = nil
			if itemData and itemData.EquipGiveClass then
				pPlayer:StripWeapon( itemData.EquipGiveClass )
			end
		else
			pPlayer:AddNote( "You have no space to unequip this item!" )
			pPlayer:AddNote( "Drop some things first and try again." )
			
			return false
		end
	end

	if not strItemID then
		GAMEMODE.Player:SetSharedGameVar( pPlayer, "eq_slot_".. strSlot, "" )
		GAMEMODE.SQL:MarkDiffDirty( pPlayer, "equipped", strSlot )

		return true
	end

	if not self:PlayerHasItem( pPlayer, strItemID ) then return false end
	local itemData = self:GetItem( strItemID )
	if not itemData or not itemData.CanEquip then return false end
	if itemData.EquipSlot ~= strSlot then return false end
	if itemData.CanPlayerEquip and not itemData:CanPlayerEquip( pPlayer ) then return false end

	if self:TakePlayerItem( pPlayer, strItemID, 1 ) then
		if itemData.EquipGiveClass then
			pPlayer:Give( itemData.EquipGiveClass )
		end
		
		self:SetPlayerEquipSlotValue( pPlayer, strSlot, strItemID )
		GAMEMODE.SQL:MarkDiffDirty( pPlayer, "equipped", strSlot )
	end
end

--[[ Crafting ]]--
function GM.Inv:PlayerAbortCraft( pPlayer )
	if pPlayer.m_bIsCrafting then
		pPlayer:Freeze( false )
		timer.Destroy( "CraftEmitSound_".. pPlayer:EntIndex() )
		timer.Destroy( "PlayerCraftItem_".. pPlayer:EntIndex() )
		GAMEMODE.Net:SendPlayerCraftEnd( pPlayer, pPlayer.m_strCraftingItemID )
	end

	pPlayer.m_bIsCrafting = false
end

function GM.Inv:PlayerCraftItem( pPlayer, strItemID )
	if pPlayer:IsIncapacitated() then return false end
	if pPlayer:InVehicle() then return false end
	if pPlayer.m_bIsCrafting then return false end
	
	local itemData = self:GetItem( strItemID )
	if not itemData then return false end
	if not itemData.CraftRecipe then return false end

	if not IsValid( pPlayer.m_entUsedCraftingEnt ) then return false end
	if pPlayer.m_entUsedCraftingEnt:GetClass() ~= itemData.CraftingEntClass then return false end
	if pPlayer.m_entUsedCraftingEnt:GetPos():Distance( pPlayer:GetPos() ) > 200 then return false end
	
	if GAMEMODE.Skills:GetPlayerLevel( pPlayer, itemData.CraftSkill ) < itemData.CraftSkillLevel then
		return false
	end

	for k, v in pairs( itemData.CraftRecipe ) do
		if not self:PlayerHasItem( pPlayer, k, v ) then
			return false
		end
	end

	pPlayer:Freeze( true )
	pPlayer.m_bIsCrafting = true
	pPlayer.m_intStartCraftTime = CurTime()
	pPlayer.m_strCraftingItemID = strItemID

	local craftDurationScalar = GAMEMODE.Skills:GetReductionFactor( pPlayer, itemData.CraftSkill, itemData.CraftSkillLevel )
	local craftDuration = itemData.CraftDuration or 10
	craftDuration = math.max( 1, craftDuration -(craftDuration *craftDurationScalar) )

	local timerID = "CraftEmitSound_".. pPlayer:EntIndex()
	if not itemData.NoCraftSounds then
		local snd, _ = table.Random( GAMEMODE.Config.CraftingSounds )
		pPlayer.m_entUsedCraftingEnt:EmitSound( snd )
		
		timer.Create( timerID, 2, 0, function()
			if not IsValid( pPlayer ) or not pPlayer.m_bIsCrafting then timer.Destroy( timerID ) return end
			if not IsValid( pPlayer.m_entUsedCraftingEnt ) then timer.Destroy( timerID ) return end

			local snd, _ = table.Random( GAMEMODE.Config.CraftingSounds )
			pPlayer.m_entUsedCraftingEnt:EmitSound( snd )
		end )
	end
	
	local craftTimerID = "PlayerCraftItem_".. pPlayer:EntIndex()
	timer.Create( craftTimerID, craftDuration, 1, function()
		if not IsValid( pPlayer ) then return end
		if not pPlayer.m_bIsCrafting then return end
		pPlayer.m_bIsCrafting = false
		pPlayer:Freeze( false )
		if not IsValid( pPlayer.m_entUsedCraftingEnt ) then return end
		if pPlayer.m_entUsedCraftingEnt:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end

		for k, v in pairs( itemData.CraftRecipe ) do
			if not self:PlayerHasItem( pPlayer, k, v ) then
				return false
			end
		end

		for k, v in pairs( itemData.CraftRecipe ) do
			self:TakePlayerItem( pPlayer, k, v )
		end

		if not self:GivePlayerItem( pPlayer, strItemID, 1 ) then
			self:MakeItemDrop( pPlayer, strItemID, 1 )
		end

		GAMEMODE.Skills:GivePlayerXP( pPlayer, itemData.CraftSkill, itemData.CraftSkillXP )
		GAMEMODE.Net:SendPlayerCraftEnd( pPlayer, strItemID )
		pPlayer:AddNote( "You crafted 1 ".. strItemID )
	end )

	GAMEMODE.Net:SendPlayerCraftData( pPlayer, strItemID, pPlayer.m_intStartCraftTime )

	return true
end

--[[ Money Drops ]]--
function GM.Inv:PlayerDropMoney( pPlayer, intAmount, bOwnerless )
	if not pPlayer:GetCharacterID() then return false end
	if pPlayer:IsIncapacitated() then return false end
	if pPlayer:InVehicle() then return false end
	if pPlayer:IsRagdolled() then return false end

	if not pPlayer:CanAfford( intAmount ) then
		intAmount = pPlayer:GetMoney()
	end
	if intAmount <= 0 then return false end
	pPlayer:TakeMoney( intAmount )

	local ent = ents.Create( "ent_money" )
	ent:SetAngles( Angle(0, pPlayer:GetAimVector():Angle().y, 0) )
	ent:SetAmount( intAmount )
	ent:SetPos( ent:SpawnFunction(pPlayer) )
	ent:Spawn()
	ent:Activate()
	ent:PhysWake()

	if not bOwnerless then ent:SetPlayerOwner( pPlayer ) end	
end

--[[ Active ammo saving ]]--
function GM.Inv:RestoreSavedAmmo( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.SavedAmmo then return end
	
	pPlayer:StripAmmo()
	for k, v in pairs( saveTable.SavedAmmo ) do
		if v <= 0 then continue end
		pPlayer:GiveAmmo( v, k, true )
	end
end

function GM.Inv:InvalidateSavedPlayerAmmo( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	saveTable.SavedAmmo = saveTable.SavedAmmo or {}

	for k, v in pairs( self.m_tblCachedAmmoTypes ) do
		saveTable.SavedAmmo[v.name] = pPlayer:GetAmmoCount( v.name )
	end

	for k, v in pairs( pPlayer:GetWeapons() ) do
		if v.Primary and v.Primary.Ammo and v.Primary.Ammo ~= "none" and v:Clip1() > 0 then
			saveTable.SavedAmmo[v.Primary.Ammo] = (saveTable.SavedAmmo[v.Primary.Ammo] or 0) +v:Clip1()
		end

		if v.Secondary and v.Secondary.Ammo and v.Secondary.Ammo ~= "none" and v:Clip2() > 0 then
			saveTable.SavedAmmo[v.Secondary.Ammo] = (saveTable.SavedAmmo[v.Secondary.Ammo] or 0) +v:Clip2()
		end
	end

	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "SavedAmmo" )
end

do
	local pmeta = debug.getregistry().Player

	g_realRemoveAmmo = g_realRemoveAmmo or pmeta.RemoveAmmo
	pmeta.RemoveAmmo = function( pPlayer, intAmount, varAmmoID, ... )
		g_realRemoveAmmo( pPlayer, intAmount, varAmmoID, ... )
		if type( varAmmoID ) ~= "string" then return end
		GAMEMODE.Inv:InvalidateSavedPlayerAmmo( pPlayer )
	end

	local wmeta = debug.getregistry().Weapon
	g_realSetClip1 = g_realSetClip1 or wmeta.SetClip1
	wmeta.SetClip1 = function( entWep, intAmmo )
		g_realSetClip1( entWep, intAmmo )
		if IsValid( entWep.Owner ) then
			GAMEMODE.Inv:InvalidateSavedPlayerAmmo( entWep.Owner )
		end
	end

	g_realSetClip2 = g_realSetClip2 or wmeta.SetClip2
	wmeta.SetClip2 = function( entWep, intAmmo )
		g_realSetClip2( entWep, intAmmo )
		if IsValid( entWep.Owner ) then
			GAMEMODE.Inv:InvalidateSavedPlayerAmmo( entWep.Owner )
		end
	end
end

-- ----------------------------------------------------------

--[[hook.Add( "GamemodePlayerSelectCharacter", "UpdatePlayerItemLimits", function( pPlayer )
	for k, v in pairs( ents.GetAll() ) do
		if not v.IsItem or not v.CreatedBySID then continue end
		if v.CreatedBySID ~= pPlayer:SteamID() then continue end
		GAMEMODE.Inv:AddPlayerItemLimit( pPlayer, v.ItemID, 1 )
		v.CreatedBy = pPlayer
	end
end )]]--

concommand.Add( "srp_dev_give_item", function( pPlayer, strCmd, tblArgs )
	if not pPlayer:IsSuperAdmin() then return end
	local itemName = tostring( tblArgs[1] )

	if not GAMEMODE.Inv:ValidItem( itemName ) then
		return
	end

	GAMEMODE.Inv:GivePlayerItem( pPlayer, itemName, tonumber(tblArgs[2] or 1) )
end )