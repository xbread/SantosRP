AddCSLuaFile"cl_init.lua"
AddCSLuaFile"shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/statetrooper/ram_tow_hook.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetTrigger( true )

	self.TargetLength = 10
	self.Length = 5	

	self.Phys = self:GetPhysicsObject()
	self.Phys:SetMass( 100 )
	self.Phys:SetDamping( 4, 4 )
	self.Phys:Wake()

	self.AdminPhysGun = true
end

function ENT:SetExtended( b )
	if b then
		--Extend
		self:SetLength( 300 )
	else
		--Retract
		self:SetLength( 5 )
	end
end

function ENT:Think()
	if not IsValid( self.constraint ) or not IsValid( self.rope ) then return end
	
	if self.TargetLength > self.Length then
		self.Length = math.Approach( self.Length, self.TargetLength, 50 )
	elseif self.TargetLength < self.Length then
		self.Length = math.Approach( self.Length, self.TargetLength, -15 )
	end

	self.constraint:Fire( "SetSpringLength", tostring(self.Length), 0 )
	self.rope:Fire( "SetLength", tostring(self.Length), 0 )
	self:NextThink( CurTime() +0.1 )
end

function ENT:PhysicsCollide( entOther )
	if self.m_bDisabled then return end
	if self.Last then return end
	
	entOther = entOther.HitEntity
	if entOther == self.Vehicle then return end

	if IsValid( entOther ) and entOther:IsVehicle() and not IsValid( entOther:GetDriver() ) then
		if entOther.CarData and entOther.UID then
			if not IsValid( self:GetAttachedTo() ) then
				if entOther ~= self.Last then
					--Garry: Tried to activate constraint in physics callback! This could cause crashes! Ignoring!
					timer.Simple( 0, function()
						if not IsValid( self ) or not IsValid( entOther ) then return end
						self:SetAttachedTo( entOther )
					end )
				end
			end
		end
	end
end

function ENT:SetLength( len )
	self.TargetLength = len
end 

function ENT:SetDisabled( b )
	self.m_bDisabled = b
end

function ENT:Release()
	if not IsValid( self:GetAttachedTo() ) then return end
	self:EmitSound( "weapons/crowbar/crowbar_impact1.wav" )

	if IsValid( self.m_pWeld ) then
		self.m_pWeld:Remove()
	end

	if IsValid( self:GetAttachedTo() ) then
		self:GetAttachedTo():SetHandbrake( false )
	end

	if self.m_funcOnRelease then self.m_funcOnRelease( self, self:GetAttachedTo() ) end
	self:GetPhysicsObject():SetMass( 64 )
	self:SetAttachedTo( NULL )
	
	self:GetPhysicsObject():RecheckCollisionFilter()

	timer.Simple( 4, function()
		if not IsValid( self ) then return end
		self.Last = nil
	end )
end

function ENT:AttachChanged( s, old, new )
	if IsValid( new ) then
		new:SetHandbrake( false )
		self:EmitSound( "weapons/crossbow/hit1.wav" )
		self:GetPhysicsObject():SetMass( 64 )

		constraint.RemoveConstraints( new, "Weld" )
			self.m_pWeld = constraint.Weld( new, self, 0, 0, 0 )
		constraint.AddConstraintTable( new, self.m_pWeld )

		self.Last = new
		new:CallOnRemove( "UnHook", function()
			if IsValid( self ) and self.Last == new then
				self:Release()
			end
		end )
	else
		if IsValid( old ) then
			old:SetHandbrake( false )
			old:RemoveCallOnRemove( "UnHook" )
		end
	end

	if self.m_funcOnAttach then self.m_funcOnAttach( self, old, new ) end
	self:GetPhysicsObject():RecheckCollisionFilter()
end