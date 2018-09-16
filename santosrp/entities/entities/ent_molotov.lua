if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= ""
ENT.Author			= "RedMist"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

if CLIENT then return end

function ENT:Initialize()
	self:SetModel( "models/props_junk/garbage_glassbottle003a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetAngles( Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)) )
	
	local Phys = self:GetPhysicsObject()
	if not Phys or not Phys:IsValid() then return end
	self:GetPhysicsObject():Wake()
	self.What = CurTime()
end

function ENT:Explode( pos )
	sound.Play( "physics/glass/glass_cup_break".. math.random(1, 2).. ".wav", self:GetPos(), 150, 150 )

	local Fire = ents.Create( "ent_fire" )
	Fire:SetPos( pos )
	Fire:Spawn()
	self:Remove()
end

function ENT:Think()
	local Trace = {}
	Trace.start = self:GetPos()
	Trace.endpos = self:GetPos() +self:GetVelocity() *5
	Trace.filter = self
	
	if self.What +10 < CurTime() then
		self:Explode( self:GetPos() )
		return false
	end
	
	local TR = util.TraceLine( Trace )
	if TR.Hit and TR.HitPos:Distance( self:GetPos() ) < 75 then
		self:Explode( TR.HitPos )
	end
end