--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local acceptedItems = {
	["Dry Cannabis (Low Quality)"] = true,
	["Dry Cannabis (Medium Quality)"] = true,
	["Dry Cannabis (High Quality)"] = true,
}

function ENT:Initialize()
	self:SetModel( "models/props_junk/MetalBucket02a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetTrigger( true )
	self:PhysWake()

	self.m_entWeed = ents.Create( "prop_dynamic" )
	self.m_entWeed:SetModel( "models/freeman/drugbale_large.mdl" )
	self.m_entWeed:SetPos( self:LocalToWorld(Vector(-0.090304, -0.291238, -1.003891)) )
	self.m_entWeed:SetAngles( self:LocalToWorldAngles(Angle(-0.137, -83.112, -0.461)) )
	self.m_entWeed:SetNoDraw( true )
	self.m_entWeed:SetParent( self )

	self:DeleteOnRemove( self.m_entWeed )
	self:NextThink( CurTime() +1 )
end

function ENT:Think()
	if not self.m_intStartTrimTime then return end
	if CurTime() > self.m_intStartTrimTime +self.TrimTime then
		self.m_intGiveAmount = GAMEMODE.Inv:GetItem( self.m_strItemID ).TrimmerGiveAmount or 1
		self.m_strItemID = GAMEMODE.Inv:GetItem( self.m_strItemID ).TrimmerGiveItem
		self.m_intStartTrimTime = nil
		self:SetRunning( false )
		self.m_entWeed:SetNoDraw( false )
	end

	self:NextThink( 0 )
	return
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

	if self.m_strItemID and not self.m_intStartTrimTime then
		if GAMEMODE.Inv:GivePlayerItem( pPlayer, self.m_strItemID, self.m_intGiveAmount ) then
			pPlayer:AddNote( "You collected ".. self.m_intGiveAmount.. " ".. self.m_strItemID.. " from the trimmer." )
			self.m_strItemID = nil
			self.m_intGiveAmount = nil
			self.m_entWeed:SetNoDraw( true )
		end
	end
end

function ENT:StartTouch( entOther )
	if self.m_strItemID then return end
	
	if entOther.m_bTouchHandled then return end
	if not entOther.ItemID then return end
	if not acceptedItems[entOther.ItemID] then return end
	
	self.m_strItemID = entOther.ItemID
	self.m_intStartTrimTime = CurTime()
	
	self:SetRunning( true )
	entOther:Remove()
	entOther.m_bTouchHandled = true
end

function ENT:CanPlayerPickup( pPlayer, bCanUse )
	if self.m_strItemID then
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