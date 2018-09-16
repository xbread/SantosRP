--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/freeman/ventfan.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()

	self:NextThink( CurTime() +1 )
end

function ENT:OnRemove()
	if self.m_sndFanHum then
		self.m_sndFanHum:Stop()
	end
end

function ENT:Toggle( bOn )
	if bOn ~= nil then
		self:SetOn( bOn )
	else
		self:SetOn( not self:GetOn() )
	end
	self:SetModel( self:GetOn() and "models/freeman/ventfan_2.mdl" or "models/freeman/ventfan.mdl" )
end

function ENT:Think()
	self:TraceWind()
	self:NextThink( 0 )
	return
end

function ENT:TraceWind()
	if not self.m_intLastTrace then
		self.m_intLastTrace = 0
	end
	if not self:GetOn() then return end
	
	if CurTime() < self.m_intLastTrace then return end
	self.m_intLastTrace = CurTime() +0.5

	local tr = util.TraceLine{
		start = self:GetPos(),
		endpos = self:GetPos() +(self:GetForward() *256),
		filter = self,
	}

	if IsValid( tr.Entity ) and tr.Entity.ReceiveWind then
		tr.Entity:ReceiveWind( 100 )
	end
end

function ENT:Use( pPlayer )
	self:Toggle()
end