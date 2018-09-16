--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props_junk/flare.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
end

function ENT:Use( pPlayer )
	if self:GetLit() then return end
	self:SetLit( true )
	self.m_intLitTime = CurTime()
	self:EmitSound( "weapons/flaregun/fire.wav", 65, 150 )

	self.m_entFlare = ents.Create( "env_flare" )
	self.m_entFlare:SetPos( self:LocalToWorld(Vector(0, 0, 6)) )
	self.m_entFlare:SetAngles( self:LocalToWorldAngles(Angle(90, 0, 0)) )
	self.m_entFlare:SetKeyValue( "spawnflags", 4 )
	self.m_entFlare:Spawn()
	self.m_entFlare:Activate()
	self.m_entFlare:SetParent( self )
	self:DeleteOnRemove( self.m_entFlare )
end

function ENT:Think()
	if not self:GetLit() then return end
	
	if CurTime() > self.m_intLitTime +self.BurnTime then
		self:Remove()
	end
end

function ENT:CanPlayerPickup( pPlayer, bCanUse )
	if self:GetLit() then return false end
	return bCanUse
end

function ENT:CanSendToLostAndFound()
	return not self:GetLit()
end