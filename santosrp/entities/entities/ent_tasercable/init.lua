AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

local sndOnline = Sound( "hl1/fvox/activated.wav" )

function ENT:Initialize()
	self:PhysicsInitBox( Vector(-2, -2, -2), Vector(2, 2, 2) )
	self:DrawShadow( false )
	self:GetPhysicsObject():SetMass( 1 )
end

function ENT:OnHitFloor()
	self.HasHit = true
	self:SetMoveType( MOVETYPE_NONE )

	timer.Simple( 1, function()
		if IsValid( self ) then self:Remove() end
	end )
end

function ENT:PhysicsCollide( other )
	if self.HasHit then return end
	local hit = other.HitEntity
	if not IsValid( hit ) then self:OnHitFloor() return end
	
	if hit:GetClass() == "ent_tasercable" then return end
	if not hit:IsPlayer() then self:OnHitFloor() return end
	
	--we hit a player
	local wep = self:GetOwner():GetActiveWeapon()
	if IsValid( wep ) and wep.OnHit then
		wep:OnHit( hit )
		self.HasHit = true
	end
end