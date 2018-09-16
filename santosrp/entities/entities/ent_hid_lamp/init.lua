--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props_c17/light_decklight01_off.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()

	self:NextThink( CurTime() +1 )
end

function ENT:Toggle( bOn )
	if bOn ~= nil then
		self:SetOn( bOn )
	else
		self:SetOn( not self:GetOn() )
	end
	self:SetModel( self:GetOn() and "models/props_c17/light_decklight01_on.mdl" or "models/props_c17/light_decklight01_off.mdl" )
end

function ENT:Think()
	self:TraceLight()
	self:NextThink( 0 )
	return
end

function ENT:TraceLight()
	if not self.m_intLastTrace then
		self.m_intLastTrace = 0
	end
	if not self:GetOn() then return end
	
	if CurTime() < self.m_intLastTrace then return end
	self.m_intLastTrace = CurTime() +0.5

	local tr = util.TraceLine{
		start = self:GetPos(),
		endpos = self:GetPos() +(self:GetForward() *512),
		filter = self,
	}

	if IsValid( tr.Entity ) and tr.Entity.ReceiveLight then
		tr.Entity:ReceiveLight( 100 )
	end
end

function ENT:Use( pPlayer )
	self:Toggle()
end