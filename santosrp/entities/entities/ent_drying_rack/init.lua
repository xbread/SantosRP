--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local itemSlots = {
	{ Vector(21.419914, -0.123292, 16.649986), Angle(0, 90, 0) },
	{ Vector(7.197754, -0.123291, 16.649986), Angle(0, 90, 0) },
	{ Vector(-7.024399, -0.123291, 16.649986), Angle(0, 90, 0) },
	{ Vector(-21.246552, -0.123290, 16.649986), Angle(0, 90, 0) },
	{ Vector(-21.246552, -0.123290, 38.709885), Angle(0, 90, 0) },
	{ Vector(-7.024399, -0.123291, 38.709885), Angle(0, 90, 0) },
	{ Vector(7.197754, -0.123291, 38.709885), Angle(0, 90, 0) },
	{ Vector(21.419914, -0.123292, 38.709885), Angle(0, 90, 0) },
	{ Vector(21.419914, -0.123292, 77.959785), Angle(0, 90, 0) },
	{ Vector(7.197754, -0.123291, 77.959785), Angle(0, 90, 0) },
	{ Vector(-7.024399, -0.123291, 77.959785), Angle(0, 90, 0) },
	{ Vector(-21.246552, -0.123290, 77.959785), Angle(0, 90, 0) },
}
local acceptedItems = {
	["Fresh Cannabis (Low Quality)"] = true,
	["Fresh Cannabis (Medium Quality)"] = true,
	["Fresh Cannabis (High Quality)"] = true,
}

function ENT:Initialize()
	self.m_tblSlots = {}
	self:SetModel( "models/props_wasteland/kitchen_shelf001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetTrigger( true )
	self:PhysWake()

	self:NextThink( CurTime() +1 )
end

function ENT:Think()
	for k, v in pairs( self.m_tblSlots ) do
		if v.isdry then continue end
		if CurTime() > v.time +v.drytime then
			self:RemoveItem( k )
			self:AddItem( v.giveitem, k )
			self.m_tblSlots[k].isdry = true
		end
	end

	self:NextThink( CurTime() +1 )
	return
end

function ENT:AddItem( strItemID, intSlotID )
	local itemData = GAMEMODE.Inv:GetItem( strItemID )
	if not itemData then return end
	
	local slotData = itemSlots[intSlotID]
	local ent = ents.Create( "prop_dynamic" )
	ent:SetMoveType( MOVETYPE_NONE )
	ent:SetModel( itemData.Model )
	ent:SetPos( self:LocalToWorld(slotData[1]) )
	ent:SetAngles( self:LocalToWorldAngles(slotData[2]) )
	ent:SetUseType( SIMPLE_USE )
	ent:Spawn()
	ent:Activate()
	ent:SetParent( self )
	self:DeleteOnRemove( ent )

	self.m_tblSlots[intSlotID] = {
		ent = ent,
		time = CurTime(),
		drytime = itemData.DryingRackTime,
		itemID = strItemID,
		giveitem = itemData.DryingRackGiveItem,
	}
end

function ENT:RemoveItem( intSlotID )
	local data = self.m_tblSlots[intSlotID]
	if not data then return end
	
	if IsValid( data.ent ) then
		data.ent:Remove()
	end

	self.m_tblSlots[intSlotID] = nil
end

function ENT:StartTouch( entOther )
	if entOther.m_bTouchHandled then return end
	if not acceptedItems[entOther.ItemID] then return end
	
	local foundSlot, dist = nil, math.huge
	for k, v in pairs( itemSlots ) do
		if self.m_tblSlots[k] then continue end

		if v[1]:Distance( entOther:GetPos() ) < dist then
			foundSlot = k
			dist = v[1]:Distance( entOther:GetPos() )
		end
	end

	if not foundSlot then return end
	self:AddItem( entOther.ItemID, foundSlot )
	entOther:Remove()
	entOther.m_bTouchHandled = true
end

function ENT:Use( pPlayer )
	if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_POLICE then
		if self:GetPlayerOwner() ~= pPlayer and not GAMEMODE.Buddy:IsItemShared( pPlayer, self:GetPlayerOwner() ) then
			self:Remove()
			local rand = math.random( GAMEMODE.Config.MinDrugConfiscatePrice, GAMEMODE.Config.MaxDrugConfiscatePrice )
			pPlayer:AddNote( "You confiscated illegal drug equipment!" )
			pPlayer:AddNote( "A $".. string.Comma(rand).. " bonus has been transferred to your bank account." )
			pPlayer:AddBankMoney( rand )
			return
		end
	end
	
	for k, v in pairs( self.m_tblSlots ) do
		if v.isdry then
			if GAMEMODE.Inv:GivePlayerItem( pPlayer, v.itemID, 1 ) then
				pPlayer:AddNote( "You collected 1 ".. v.itemID.. " from the drying rack." )
				self:RemoveItem( k )
				return
			end
		end
	end
end

function ENT:CanPlayerPickup( pPlayer, bCanUse )
	if table.Count( self.m_tblSlots ) > 0 then
		return false
	end
	
	return bCanUse
end

function ENT:CanPlayerUse( pPlayer )
	return true
end

function ENT:CanSendToLostAndFound()
	return true
end