--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/alyx.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetSolid( SOLID_BBOX ) 
	self:SetMoveType( MOVETYPE_STEP )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE +CAP_TURN_HEAD )

	self:SetMaxYawSpeed( 5000 )
	
	self:SetUseType( SIMPLE_USE )
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:AcceptInput( strName, entActivator, entCaller )
	if not IsValid( entCaller ) or not entCaller:IsPlayer() then return end
	if strName ~= "Use" then return end
	if not self.m_tblNPCData then return end

	entCaller.m_entTalkingNPC = self
	self.m_tblNPCData:OnPlayerTalk( self, entCaller )
end