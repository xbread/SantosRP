--[[
	Name: cl_inventory.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Inv = (GAMEMODE or GM).Inv or {}
GM.Inv.m_tblItemRegister = (GAMEMODE or GM).Inv.m_tblItemRegister or {}
GM.Inv.m_tblItemLimits = (GAMEMODE or GM).Inv.m_tblItemLimits or {}
GM.Inv.m_tblEquipmentSlots = {
	["Head"] = { Type = "Head", PacEnabled = true },
	["Face"] = { Type = "Face", PacEnabled = true },
	["Eyes"] = { Type = "Eyes", PacEnabled = true },
	["Neck"] = { Type = "Neck", PacEnabled = true },
	["Back"] = { Type = "Back", PacEnabled = true },

	["PrimaryWeapon"] = { Type = "PrimaryWeapon", PacEnabled = true },
	["SecondaryWeapon"] = { Type = "SecondaryWeapon", PacEnabled = true },
	["AltWeapon"] = { Type = "AltWeapon", PacEnabled = true },
}

--[[ Item Management ]]--
function GM.Inv:LoadItems()
	GM:PrintDebug( 0, "->LOADING ITEMS" )

	local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "items/*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( GM.Config.GAMEMODE_PATH.. "items/".. v )
	end

	GM:PrintDebug( 0, "->ITEMS LOADED" )
end

function GM.Inv:RegisterItem( tblItem )
	self.m_tblItemRegister[tblItem.Name] = tblItem
	GM:PrintDebug( 0, "\t\tRegistered item ".. tblItem.Name )
end

function GM.Inv:RegisterItemLimit( strLimitID, intMaxLimit )
	if not strLimitID or self.m_tblItemLimits[strLimitID] then return end
	self.m_tblItemLimits[strLimitID] = intMaxLimit or 1
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

function GM.Inv:ComputeInventorySize()
	local weight, volume = GAMEMODE.Config.MaxCarryWeight, GAMEMODE.Config.MaxCarryVolume
	local pl = LocalPlayer()
	
	local item, slotData
	for slotID, _ in pairs( self:GetEquipmentSlots() ) do
		slotData = GAMEMODE.Player:GetSharedGameVar( pl, "eq_slot_".. slotID, "" )
		item = self:GetItem( slotData )

		if item and item.EquipBoostCarryWeight then
			weight = weight +item.EquipBoostCarryWeight
		end
		if item and item.EquipBoostCarryVolume then
			volume = volume +item.EquipBoostCarryVolume
		end
	end

	return weight, volume
end

function GM.Inv:GetCurrentWeight()
	return self.m_intCurrentWeight or 0
end

function GM.Inv:GetCurrentVolume()
	return self.m_intCurrentVolume or 0
end

function GM.Inv:GetCurrentWeightAndVolume()
	return self:GetCurrentWeight(), self:GetCurrentVolume()
end

function GM.Inv:PlayerHasItem( strItemID, intAmount )
	return LocalPlayer():GetInventory()[strItemID] and LocalPlayer():GetInventory()[strItemID] >= intAmount
end

function GM:GamemodeOnInventoryUpdated( tblLocalInventory )
	self.Inv.m_intCurrentWeight, self.Inv.m_intCurrentVolume = self.Inv:ComputeWeightAndVolume( tblLocalInventory )

	if ValidPanel( self.m_pnlQMenu ) then
		self.m_pnlQMenu:Refresh()
	end
end

--[[ Equipment Management ]]--
function GM.Inv:RegisterEquipSlot( strSlotID, tblSlotData )
	self.m_tblEquipmentSlots[strSlotID] = tblSlotData
end

function GM.Inv:GetEquipmentSlots()
	return self.m_tblEquipmentSlots
end

function GM.Inv:PlayerHasItemEquipped( pPlayer, strItemID )
	local slotData
	for slotName, data in pairs( self.m_tblEquipmentSlots ) do
		slotData = GAMEMODE.Player:GetSharedGameVar( pPlayer, "eq_slot_".. slotName, "" )
		if slotData == strItemID then
			return true, slotName
		end
	end
	return false
end

function GM.Inv:PlayerEquipSlotChanged( pPlayer, strVar, vaOld, vaNew )
	for k, v in pairs( self.m_tblEquipmentSlots ) do
		if "eq_slot_".. k == strVar then
			if not v.PacEnabled then return end
			if v.Type == "GAMEMODE_INTERNAL_PAC_ONLY" then
				GAMEMODE.PacModels:InvalidatePlayerOutfits( pPlayer )
				return
			end

			break
		end
	end

	if not self:GetItem( vaNew or "" ) or not self:GetItem( vaNew or "" ).PacOutfit then
		if not self:GetItem( vaOld or "" ) or not self:GetItem( vaOld or "" ).PacOutfit then
			return
		end
	end

	GAMEMODE.PacModels:InvalidatePlayerOutfits( pPlayer )
end

function GM.Inv:ApplyPACModels( pPlayer )
	for k, v in pairs( pPlayer.pac_parts or {} ) do
		v:Remove()
	end

	if not pPlayer.AttachPACPart then
		pac.SetupENT( pPlayer )

		if pPlayer.SetPACDrawDistance then
			pPlayer:SetPACDrawDistance( GetConVarNumber("srp_pac_drawrange") )
		end
		
		pPlayer.m_tblEquipPACOutfits = {}
	end

	if pPlayer.m_tblEquipPACOutfits then
		for name, data in pairs( self.m_tblEquipmentSlots ) do
			local pdata = pPlayer.m_tblEquipPACOutfits[name] or {}
			if not pPlayer.m_tblEquipPACOutfits[name] then pPlayer.m_tblEquipPACOutfits[name] = pdata end

			if data.Type == "GAMEMODE_INTERNAL_PAC_ONLY" then
				local outfitID = GAMEMODE.Player:GetSharedGameVar( pPlayer, "eq_slot_".. name ) or ""
				if outfitID == "" then
					pdata.CurPacPart = nil
				else
					pdata.CurPacPart = GAMEMODE.PacModels:GetOutfitForModel( outfitID, pPlayer:GetModel() )
				end
			else
				local item = self:GetItem( GAMEMODE.Player:GetSharedGameVar(pPlayer, "eq_slot_".. name) or "" )
				if item and item.PacOutfit then
					pdata.CurPacPart = GAMEMODE.PacModels:GetOutfitForModel( item.PacOutfit, pPlayer:GetModel() )
				else
					pdata.CurPacPart = nil
				end
			end

			if pdata.CurPacPart then
				pPlayer:AttachPACPart( pdata.CurPacPart, nil, true )
			end
		end
	end
end