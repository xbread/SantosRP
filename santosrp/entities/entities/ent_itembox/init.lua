--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

util.AddNetworkString "ItemBox"

function ENT:Initialize()
	self:SetModel( "models/props_junk/cardboard_box003a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
end

function ENT:SetItems( tblItems )
	self.m_tblItems = tblItems
end

function ENT:Use( pPlayer )
	if self.m_bRemoved then return end
	net.Start( "ItemBox" )
		net.WriteEntity( self )
		net.WriteTable( self.m_tblItems )
	net.Send( pPlayer )
end

function ENT:OnPlayerTake( pPlayer, strItemID )
	if not self.m_tblItems then self.m_bRemoved = true self:Remove() return end
	if not self.m_tblItems[strItemID] then return end
	
	if GAMEMODE.Inv:GivePlayerItem( pPlayer, strItemID, self.m_tblItems[strItemID] ) then
		self.m_tblItems[strItemID] = nil

		if table.Count( self.m_tblItems ) <= 0 then
			self.m_bRemoved = true
			self:Remove()
		end
	end
end

function ENT:CanPlayerUse( pPlayer )
	return true
end

net.Receive( "ItemBox", function( intMsgLen, pPlayer )
	local ent = net.ReadEntity()
	if not IsValid( ent ) or ent:GetClass() ~= "ent_itembox" then return end
	if ent:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end

	if pPlayer:IsIncapacitated() then return end
	if pPlayer:InVehicle() then return end
	
	if net.ReadBit() == 1 then --take items
		ent:OnPlayerTake( pPlayer, net.ReadString() )

		if not ent.m_bRemoved then
			net.Start( "ItemBox" )
				net.WriteEntity( ent )
				net.WriteTable( ent.m_tblItems )
			net.Send( pPlayer )
		end
	else --destroy items
		local itemID = net.ReadString()
		if ent.m_tblItems[itemID] then
			ent.m_tblItems[itemID] = nil

			if table.Count( ent.m_tblItems ) <= 0 then
				ent.m_bRemoved = true
				ent:Remove()
			else
				net.Start( "ItemBox" )
					net.WriteEntity( ent )
					net.WriteTable( ent.m_tblItems )
				net.Send( pPlayer )
			end
		end
	end
end )