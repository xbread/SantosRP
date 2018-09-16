--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props/cs_office/radio.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
end

function ENT:AcceptInput( strName, entActivator, entCaller )
	if not IsValid( entCaller ) or not entCaller:IsPlayer() or strName ~= "Use" then return end

	if CurTime() > (self.m_intLastUsed or 0) then
		GAMEMODE.Net:NetworkOpenRadioMenu( entCaller )
		self.m_intLastUsed = CurTime() +1
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end