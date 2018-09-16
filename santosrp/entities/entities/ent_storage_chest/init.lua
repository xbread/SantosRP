--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local openSound = Sound( "AmmoCrate.Open" )
local closeSound = Sound( "AmmoCrate.Close" )

function ENT:Initialize()
	self:SetModel( "models/Items/ammocrate_smg1.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()

	self:SetMaxVolume( 1000 )
	self.m_tblItems = {}
end

function ENT:SetItems( tblItems )
	self.m_tblItems = tblItems
end

function ENT:Use( pPlayer )
	self:NetworkItems( pPlayer )
	self:EmitSound( openSound )
	pPlayer.m_entLastUsedStorageChest = self

	local seq = self:LookupSequence( "Close" )
	if seq then
		self:ResetSequence( seq )
		self.m_bOpen = true

		timer.Simple( 2, function()
			if not IsValid( self ) then return end
			if not self.m_bOpen then return end
			
			local seq = self:LookupSequence( "Open" )
			if not seq then return end
			self:ResetSequence( seq )
			self:EmitSound( closeSound )
			self.m_bOpen = false
		end )
	end
end

function ENT:OnPlayerTake( pPlayer, strItemID, intAmount )
	if not self.m_tblItems then self.m_bRemoved = true self:Remove() return end
	if not self.m_tblItems[strItemID] then return end
	
	intAmount = math.min( intAmount, self.m_tblItems[strItemID] )
	if intAmount <= 0 then return end
	
	if GAMEMODE.Inv:GivePlayerItem( pPlayer, strItemID, intAmount ) then
		self.m_tblItems[strItemID] = self.m_tblItems[strItemID] -intAmount

		if self.m_tblItems[strItemID] <= 0 then
			self.m_tblItems[strItemID] = nil
		end
	end
end

function ENT:CanPlayerPickup( pPlayer, bCanUse )
	if table.Count( self.m_tblItems ) > 0 then return false end
	return bCanUse
end

function ENT:CanPlayerUse( pPlayer )
	return true
end

function ENT:OnAddToLostAndFound( pPlayer )
	--Add all the stuff inside to lost and found when this is called!
	for k, v in pairs( self.m_tblItems ) do
		GAMEMODE.BankStorage:AddToLostAndFound( pPlayer, k, v, true, true )
	end
end

function ENT:NetworkItems( pPlayer )
	GAMEMODE.Net:NewEvent( "ent", "str_chst_o" )
		net.WriteEntity( self )
		net.WriteTable( self.m_tblItems )
	GAMEMODE.Net:FireEvent( pPlayer )
end

GAMEMODE.Net:RegisterEventHandle( "ent", "str_chst_t", function( intMsgLen, pPlayer )
	local ent = net.ReadEntity()
	if not IsValid( ent ) or ent:GetClass() ~= "ent_storage_chest" then return end
	if not pPlayer.m_entLastUsedStorageChest or pPlayer.m_entLastUsedStorageChest ~= ent then return end
	if ent:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end

	if pPlayer:IsIncapacitated() then return end
	if pPlayer:InVehicle() then return end

	ent:OnPlayerTake( pPlayer, net.ReadString(), net.ReadUInt(16) )
	ent:NetworkItems( pPlayer )
end )

GAMEMODE.Net:RegisterEventHandle( "ent", "str_chst_d", function( intMsgLen, pPlayer )
	local ent = net.ReadEntity()
	if not IsValid( ent ) or ent:GetClass() ~= "ent_storage_chest" then return end
	if not pPlayer.m_entLastUsedStorageChest or pPlayer.m_entLastUsedStorageChest ~= ent then return end
	if ent:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end

	if pPlayer:IsIncapacitated() then return end
	if pPlayer:InVehicle() then return end

	local itemID = net.ReadString()
	if ent.m_tblItems[itemID] then
		ent.m_tblItems[itemID] = nil
		ent:NetworkItems( pPlayer )
	end
end )

GAMEMODE.Net:RegisterEventHandle( "ent", "str_chst_a", function( intMsgLen, pPlayer )
	local ent = net.ReadEntity()
	if not IsValid( ent ) or ent:GetClass() ~= "ent_storage_chest" then return end
	if not pPlayer.m_entLastUsedStorageChest or pPlayer.m_entLastUsedStorageChest ~= ent then return end
	if ent:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end

	if pPlayer:IsIncapacitated() then return end
	if pPlayer:InVehicle() then return end

	local itemID, amount = net.ReadString(), net.ReadUInt( 16 )
	local itemData = GAMEMODE.Inv:GetItem( itemID )
	if not itemData or amount == 0 then return end
	if itemData.JobItem then return end
	
	local hasNum = GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, itemID )
	if not hasNum or hasNum <= 0 then return end
	amount = math.min( amount, hasNum )

	local curSize = GAMEMODE.Inv:ComputeVolume( ent.m_tblItems or {} )
	if curSize +(itemData.Volume *amount) > ent:GetMaxVolume() then
		pPlayer:AddNote( "This container is full!" )
		return
	end
	
	if GAMEMODE.Inv:TakePlayerItem( pPlayer, itemID, amount ) then
		ent.m_tblItems[itemID] = ent.m_tblItems[itemID] or 0
		ent.m_tblItems[itemID] = ent.m_tblItems[itemID] +amount
		ent:NetworkItems( pPlayer )
	end
end )