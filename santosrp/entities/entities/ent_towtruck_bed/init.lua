--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local winchOffset = Vector( 0.499179, 27.095013, 77.564430 )
local minWinchLen, maxWinchLen = 5, 768

function ENT:Initialize()
	self:SetModel( "models/sentry/flatbed_bed.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:EnableCustomCollisions( true )

	self.m_tblPhysShadow = {}
	self.m_tblPhysShadowCar = {}
	self.IsTowBed = true

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableDrag( true )
		phys:EnableGravity( false )
		phys:SetDamping( 15, 0 )
		phys:SetMass( 128 )
	end
	
	self.m_vecHookPos = Vector( 0.5, -28.619274, 66.765739 )
	self.m_angHookAng = Angle( 89.421, 119.091, 42.143 )
	self.m_vecCarPos = Vector( 0, -93.275040, 68 )
	self.m_vecCarSpawnPos = Vector( 0, -93.275040, 75 )

	self.m_entHook = ents.Create( "ent_towtruck_hook" )
	self.m_entHook:EnableCustomCollisions( true )
	self.m_entHook:SetPos( self:LocalToWorld(self.m_vecHookPos) )
	self.m_entHook:SetAngles( self:LocalToWorldAngles(self.m_angHookAng) )
	self.m_entHook:Spawn()
	self.m_entHook:Activate()
	self.m_entHook.Vehicle = self.m_entVeh
	self:DeleteOnRemove( self.m_entHook )

	self.m_entHook.m_funcOnAttach = function( entHook, varOld, varNew )
		entHook:SetCollisionGroup( IsValid(varNew) and COLLISION_GROUP_DEBRIS_TRIGGER or COLLISION_GROUP_NONE )
		entHook:SetSolid( IsValid(varNew) and SOLID_NONE or SOLID_VPHYSICS )

		if IsValid( varNew ) then
			--
		elseif IsValid( varOld ) then
			for i = 1, varOld:GetPhysicsObjectCount() do
				local phys = varOld:GetPhysicsObjectNum( i -1 )
				if IsValid( phys ) then
					phys:EnableCollisions( true )
					phys:RecheckCollisionFilter()
				end
			end
		end
	end

	self.m_entHook.m_funcOnRelease = function( entHook, entVeh )
		entHook:SetCollisionGroup( COLLISION_GROUP_NONE )
		entHook:SetSolid( SOLID_VPHYSICS )
		entVeh:SetCollisionGroup( COLLISION_GROUP_VEHICLE )

		for i = 1, entVeh:GetPhysicsObjectCount() do
			local phys = entVeh:GetPhysicsObjectNum( i -1 )
			if IsValid( phys ) then
				phys:EnableCollisions( true )
				phys:RecheckCollisionFilter()
			end
		end
	end

	local physHook = self.m_entHook:GetPhysicsObject()
	if IsValid( physHook ) then
		physHook:SetMass( 10 )
	end

	self.m_pConst, self.m_pRope = constraint.Elastic(
		self.m_entHook, self,
		0, 0,
		Vector( 0, 0, 0 ),
		winchOffset,
		100000, 0.75, 0.2,
		"cable/cable",
		2,
		true
	)
	
	self.m_intRopeLen = 70
	self.m_pConst:Fire( "SetSpringLength", tostring(self.m_intRopeLen), 0 )
	self.m_pRope:Fire( "SetLength", tostring(self.m_intRopeLen), 0 )

	self.m_pNocollideBedWorld = constraint.NoCollide( self, game.GetWorld(), 0, 0 )
end

function ENT:OnRemove()
	if IsValid( self.m_pNocollideBedWorld ) then self.m_pNocollideBedWorld:Remove() end
	if IsValid( self.m_pNocollideBed ) then self.m_pNocollideBed:Remove() end
	if IsValid( self.m_pConst ) then self.m_pConst:Remove() end
	if IsValid( self.m_pRope ) then self.m_pRope:Remove() end
	if IsValid( self.m_pWeldBed ) then self.m_pWeldBed:Remove() end

	if self.m_sndWinch then
		self.m_sndWinch:Stop()
		self.m_sndWinch = nil
	end
	
	if self.m_sndMove then
		self.m_sndMove:Stop()
		self.m_sndMove = nil
	end
end

function ENT:SetTruck( eEnt, vecOffsetLocal, angOffsetLocal )
	self.m_entVeh = eEnt
	self.m_vecOffset = vecOffsetLocal
	self.m_angOffset = angOffsetLocal

	self:SetBedPos( self.m_vecOffset )
	self:SetBedAngles( self.m_angOffset )

	if self.m_entHook then
		self.m_entHook.Vehicle = eEnt
	end

	self.m_pNocollideBed = constraint.NoCollide( self, self.m_entVeh, 0, 0 )
	self:LockBed( true )
end

function ENT:SetBedPos( vecPosLocal )
	self.m_vecBedPos = vecPosLocal
end

function ENT:GetBedPos()
	return self.m_vecBedPos
end

function ENT:SetBedAngles( angAngLocal )
	self.m_angBedAng = angAngLocal
end

function ENT:GetBedAngles()
	return self.m_angBedAng
end

function ENT:SetCarryingVehicle( entVeh )
	self.m_entCarryingVeh = entVeh
	self.m_entCarryingVeh:StartMotionController()
end

--TODO: CLEANME
local bedMinX, bedMaxX = -128, 2
local bedMinY, bedMaxY = -160, -2.197299
local bedMinZ, bedMaxZ = -128, 2
local bedMinPos = Vector( bedMinX, bedMinY +1, bedMinZ )
local bedMaxPos = Vector( bedMaxX, bedMaxY -1, bedMaxZ )

local bedMinP, bedMaxP = -180, 180
local bedMinAY, bedMaxAY = -180, 180
local bedMinR, bedMaxR = 0, 15
local bedMinAng = Angle( bedMinP +1, bedMinAY +1, bedMinR +1 )
local bedMaxAng = Angle( bedMaxP -1, bedMaxAY -1, bedMaxR -1 )
function ENT:PhysicsSimulate( pPhys, intDeltaTime )
	if not IsValid( self.m_entVeh ) then return end

	if IsValid( self.m_entVehHoldPos ) then
		self.m_entVehHoldPos:SetPos( self.m_entVeh:LocalToWorld(self.m_vecCarSpawnPos) )

		if CurTime() > self.m_intVehHoldStart then
			self.m_entVehHoldPos = nil
			self.m_intVehHoldStart = nil
		end
	end

	-- !!!!! HACK !!!!!!
	-- We can't have a PhysicsSimulate event on the engine entity, but applying the shadow physics to it from this entity seems to work fine
	if self:IsBedLocked() then
		if not IsValid( self.m_entCarryingVeh ) then return end

		local phys = self.m_entCarryingVeh:GetPhysicsObject()
		if not IsValid( phys ) then return end

		phys:Wake()
		pPhys:Wake()
		self.m_tblPhysShadowCar.secondstoarrive = 0.0000001 // How long it takes to move to pos and rotate accordingly - only if it could move as fast as it want - damping and max speed/angular will make this invalid ( Cannot be 0! Will give errors if you do )
		self.m_tblPhysShadowCar.pos = self.m_entVeh:LocalToWorld( self.m_vecCarPos ) // Where you want to move to
		self.m_tblPhysShadowCar.angle = self.m_entVeh:GetAngles() // Angle you want to move to
		self.m_tblPhysShadowCar.maxangular = 1000000000 //What should be the maximal angular force applied
		self.m_tblPhysShadowCar.maxangulardamp = 500000000 // At which force/speed should it start damping the rotation
		self.m_tblPhysShadowCar.maxspeed = 1000000000 // Maximal linear force applied
		self.m_tblPhysShadowCar.maxspeeddamp = 500000000// Maximal linear force/speed before damping
		self.m_tblPhysShadowCar.dampfactor = 0.2 // The percentage it should damp the linear/angular force if it reaches it's max amount
		self.m_tblPhysShadowCar.teleportdistance = 0 // If it's further away than this it'll teleport ( Set to 0 to not teleport )
		self.m_tblPhysShadowCar.deltatime = intDeltaTime // The deltatime it should use - just use the PhysicsSimulate one
		phys:ComputeShadowControl( self.m_tblPhysShadowCar )

		return
	end

	local angWorld = self.m_entVeh:LocalToWorldAngles( self:GetBedAngles() )
	local btnDown, moved = false, false
	local tiltBack

	--Forward and back motion
	if IsValid( self.m_entMoveBackBtn ) and self.m_entMoveBackBtn:GetOn() then
		btnDown = true
		local curPos = self:GetBedPos()
		local moveVec = self.m_angOffset:Right() *-15

		if self:GetBedAngles().r ~= 0 then
			tiltBack = true
		else
			if not moved and GAMEMODE.Util:VectorInRange( curPos, bedMinPos, bedMaxPos ) then
				moved = true
			end

			self:SetBedPos( Vector(
				math.Clamp( curPos.x +(moveVec.x *intDeltaTime), bedMinX, bedMaxX ),
				math.Clamp( curPos.y +(moveVec.y *intDeltaTime), bedMinY, bedMaxY ),
				math.Clamp( curPos.z +(moveVec.z *intDeltaTime), bedMinZ, bedMaxZ )
			) )
		end
	end
	if IsValid( self.m_entMoveForwardBtn ) and self.m_entMoveForwardBtn:GetOn() then
		btnDown = true
		local curPos = self:GetBedPos()
		local moveVec = self.m_angOffset:Right() *15

		if not moved and GAMEMODE.Util:VectorInRange( curPos, bedMinPos, bedMaxPos ) then
			moved = true
		end

		self:SetBedPos( Vector(
			math.Clamp( curPos.x +(moveVec.x *intDeltaTime), bedMinX, bedMaxX ),
			math.Clamp( curPos.y +(moveVec.y *intDeltaTime), bedMinY, bedMaxY ),
			math.Clamp( curPos.z +(moveVec.z *intDeltaTime), bedMinZ, bedMaxZ )
		) )
	end

	--Tilit
	if self:GetBedPos().y <= -128 and self.m_entMoveForwardBtn:GetOn() then
		btnDown = true
		local curAng = self:GetBedAngles()
		local moveAng = Angle( 0, 0, 5 )

		if not moved and GAMEMODE.Util:AngleInRange( curAng, bedMinAng, bedMaxAng ) then
			moved = true
		end

		self:SetBedAngles( Angle(
			math.Clamp( curAng.p +(moveAng.p *intDeltaTime), bedMinP, bedMaxP ),
			math.Clamp( curAng.y +(moveAng.y *intDeltaTime), bedMinAY, bedMaxAY ),
			math.Clamp( curAng.r +(moveAng.r *intDeltaTime), bedMinR, bedMaxR )
		) )
	end
	if tiltBack then
		btnDown = true
		local curAng = self:GetBedAngles()
		local moveAng = Angle( 0, 0, -5 )

		if not moved and GAMEMODE.Util:AngleInRange( curAng, bedMinAng, bedMaxAng ) then
			moved = true
		end

		self:SetBedAngles( Angle(
			math.Clamp( curAng.p +(moveAng.p *intDeltaTime), bedMinP, bedMaxP ),
			math.Clamp( curAng.y +(moveAng.y *intDeltaTime), bedMinAY, bedMaxAY ),
			math.Clamp( curAng.r +(moveAng.r *intDeltaTime), bedMinR, bedMaxR )
		) )
	end

	if btnDown then
		if moved then
			if not self.m_sndMove then self.m_sndMove = CreateSound( self, "plats/crane/vertical_start.wav" ) end
			if not self.m_sndMove:IsPlaying() then self.m_sndMove:Play() end
		else
			if self.m_sndMove and self.m_sndMove:IsPlaying() then
				self.m_sndMove:Stop()
				self.m_sndMove = nil
				self:EmitSound( "plats/crane/vertical_stop.wav" )
			end
		end
	else
		if self.m_sndMove then
			self.m_sndMove:Stop()
			self.m_sndMove = nil
			self:EmitSound( "plats/crane/vertical_stop.wav" )
		end
	end

	pPhys:Wake()
	self.m_tblPhysShadow.secondstoarrive = 0.0000001 // How long it takes to move to pos and rotate accordingly - only if it could move as fast as it want - damping and max speed/angular will make this invalid ( Cannot be 0! Will give errors if you do )
	self.m_tblPhysShadow.pos = self.m_entVeh:LocalToWorld( self:GetBedPos() ) // Where you want to move to
	self.m_tblPhysShadow.angle = self.m_entVeh:LocalToWorldAngles( self:GetBedAngles() ) // Angle you want to move to
	self.m_tblPhysShadow.maxangular = 1000000000 //What should be the maximal angular force applied
	self.m_tblPhysShadow.maxangulardamp = 500000000 // At which force/speed should it start damping the rotation
	self.m_tblPhysShadow.maxspeed = 1000000000 // Maximal linear force applied
	self.m_tblPhysShadow.maxspeeddamp = 500000000// Maximal linear force/speed before damping
	self.m_tblPhysShadow.dampfactor = 0.5 // The percentage it should damp the linear/angular force if it reaches it's max amount
	self.m_tblPhysShadow.teleportdistance = 200 // If it's further away than this it'll teleport ( Set to 0 to not teleport )
	self.m_tblPhysShadow.deltatime = intDeltaTime // The deltatime it should use - just use the PhysicsSimulate one
	pPhys:ComputeShadowControl( self.m_tblPhysShadow )
end

function ENT:Think()
	if (self.m_intLastThink or 0) > CurTime() then return end
	self.m_intLastThink = CurTime() +0.1

	if not IsValid( self.m_entVeh ) then return end
	if self:IsBedLocked() then return end

	local winchMoved
	if IsValid( self.m_entWinchForwardBtn ) and self.m_entWinchForwardBtn:GetOn() then
		if self.m_intRopeLen < maxWinchLen then
			self.m_intRopeLen = math.min( self.m_intRopeLen +10, maxWinchLen )
			self.m_pConst:Fire( "SetSpringLength", tostring(self.m_intRopeLen), 0 )
			self.m_pRope:Fire( "SetLength", tostring(self.m_intRopeLen), 0 )
			winchMoved = true
		end
	end
	if IsValid( self.m_entWinchBackBtn ) and self.m_entWinchBackBtn:GetOn() then
		if self.m_intRopeLen > minWinchLen then
			self.m_intRopeLen = math.max( self.m_intRopeLen -10, minWinchLen )
			self.m_pConst:Fire( "SetSpringLength", tostring(self.m_intRopeLen), 0 )
			self.m_pRope:Fire( "SetLength", tostring(self.m_intRopeLen), 0 )
			winchMoved = true
		end	
	end

	if winchMoved then
		if not self.m_sndWinch then self.m_sndWinch = CreateSound( self, "vehicles/tank_turret_loop1.wav" ) end
		if not self.m_sndWinch:IsPlaying() then
			self.m_sndWinch:Play()
			self:EmitSound( "vehicles/tank_turret_start1.wav" )
		end
	else
		if self.m_sndWinch and self.m_sndWinch:IsPlaying() then
			self.m_sndWinch:Stop()
			self.m_sndMove = nil
			self:EmitSound( "vehicles/tank_turret_stop1.wav" )
		end
	end
end

function ENT:OnBedLocked()
	self:EmitSound( "buttons/lever7.wav" )
	self:SetPos( self.m_entVeh:LocalToWorld(self.m_vecOffset) )
	self:SetAngles( self.m_entVeh:LocalToWorldAngles(self.m_angOffset) )
	
	if not IsValid( self.m_entHook:GetAttachedTo() ) or not self.m_entHook:GetAttachedTo():IsVehicle() then
		self.m_entHook:SetDisabled( true )
		self.m_entHook:SetPos( self:LocalToWorld(self.m_vecHookPos) )
		self.m_entHook:SetAngles( self:LocalToWorldAngles(self.m_angHookAng) )
	else
		self.m_intRopeLen = 150
		self.m_pConst:Fire( "SetSpringLength", tostring(self.m_intRopeLen), 0 )
		self.m_pRope:Fire( "SetLength", tostring(self.m_intRopeLen), 0 )

		local att = self.m_entHook:GetAttachedTo()
		for i = 1, att:GetPhysicsObjectCount() do
			local phys = att:GetPhysicsObjectNum( i -1 )
			if IsValid( phys ) then
				phys:EnableCollisions( false )
				phys:RecheckCollisionFilter()
			end
		end

		--MORE hacks
		--stop the wheels from revving up while locked
		att:SetHandbrake( true )
		self.m_tblSavedWheelDamping = {}
		for i = 1, att:GetWheelCount() do
			local wheel = att:GetWheel( i -1 )
			if IsValid( wheel ) then
				self.m_tblSavedWheelDamping[i -1] = { wheel:GetDamping(), wheel:GetRotDamping() }
				wheel:SetDamping( 1, 50 )
			end
		end
	end
	
	constraint.RemoveConstraints( self, "Weld" )
		self.m_pWeldBed = constraint.Weld( self, self.m_entVeh, 0, 0, 0 )
	constraint.AddConstraintTable( self, self.m_pWeldBed )

	self:GetPhysicsObject():SetMass( 128 )
	self:GetPhysicsObject():Wake()

	self.m_entVeh:SetMaxThrottle( 1 )
	self.m_entVeh:SetMaxReverseThrottle( -1 )
end

function ENT:OnBedUnLocked()
	self:EmitSound( "buttons/lever3.wav" )
	constraint.RemoveConstraints( self, "Weld" )
	self.m_entHook:SetDisabled( false )

	self:StartMotionController()
	self:GetPhysicsObject():SetMass( 16384 )
	self:GetPhysicsObject():RecheckCollisionFilter()
	self:GetPhysicsObject():Wake()

	self.m_entVeh:SetMaxThrottle( 0.25 )
	self.m_entVeh:SetMaxReverseThrottle( 0.66 )

	self.m_entHook:GetPhysicsObject():Wake()

	if IsValid( self.m_entCarryingVeh ) then
		self.m_entCarryingVeh:StopMotionController()
		self.m_entCarryingVeh:SetPos( self.m_entVeh:LocalToWorld(self.m_vecCarSpawnPos) )

		for i = 1, self.m_entCarryingVeh:GetPhysicsObjectCount() do
			local phys = self.m_entCarryingVeh:GetPhysicsObjectNum( i -1 )
			if IsValid( phys ) then
				phys:EnableCollisions( true )
				phys:RecheckCollisionFilter()
			end
		end

		--wheel hax
		for k, v in pairs( self.m_tblSavedWheelDamping or {} ) do
			local wheel = self.m_entCarryingVeh:GetWheel( k )
			if IsValid( wheel ) then
				wheel:SetDamping( v[1], v[2] )
			end
		end
		GAMEMODE.Cars:InvalidateVehicleParams( self.m_entCarryingVeh )
		self.m_tblSavedWheelDamping = nil

		--more hacks...
		self.m_entVehHoldPos = self.m_entCarryingVeh
		self.m_intVehHoldStart = CurTime() +1
		--do this to allow for enough time to pass so that the car can collide with everything again

		self.m_entCarryingVeh:SetHandbrake( false )
		self.m_entCarryingVeh = nil
		self.m_intRopeLen = 70
	else
		self.m_intRopeLen = 70
	end

	self.m_pConst:Fire( "SetSpringLength", tostring(self.m_intRopeLen), 0 )
	self.m_pRope:Fire( "SetLength", tostring(self.m_intRopeLen), 0 )
end

function ENT:CanLockBed( pPlayer )
	if self.m_intRopeLen > minWinchLen then
		pPlayer:AddNote( "You must reel the winch in completely before locking the bed." )
		return false
	end

	if self:GetBedPos().y < bedMaxY -0.1 then
		pPlayer:AddNote( "You must slide the bed back completely before locking the bed." )
		return false
	end

	if IsValid( self.m_entHook:GetAttachedTo() ) and self.m_entHook:GetAttachedTo().IsTow then
		pPlayer:AddNote( "You may not load a tow truck onto the bed of another truck, sorry!" )
		return false
	end

	return true
end

function ENT:LockBed( bLock )
	if bLock then
		if self.m_bBedLocked then return end
		if IsValid( self.m_entHook:GetAttachedTo() ) and self.m_entHook:GetAttachedTo():IsVehicle() then
			if self.m_intRopeLen <= 32 then
				self:SetCarryingVehicle( self.m_entHook:GetAttachedTo() )

				timer.Simple( 0, function()
					if not IsValid( self ) or not IsValid( self.m_entCarryingVeh ) or not IsValid( self.m_entVeh ) then return end
					self:OnBedLocked()
				end )
			else
				return
			end
		else
			self:OnBedLocked()
		end
	else
		self:OnBedUnLocked()
	end

	self.m_bBedLocked = bLock
end

function ENT:IsBedLocked()
	return self.m_bBedLocked
end

function ENT:SetBedLockButton( entBtn )
	self.m_entBtnLock = entBtn
	entBtn:SetIsToggle( true )
	entBtn:SetOn( true )
	entBtn:SetCallback( function( entBtn, pPlayer, bOn )
		if self.m_intVehHoldStart then return end
		
		if not self:IsBedLocked() and not self:CanLockBed( pPlayer ) then
			self:EmitSound( "buttons/latchunlocked2.wav" )
			self.m_bBedLocked = false
			return
		end

		self:LockBed( not self:IsBedLocked() )
	end )
end

function ENT:SetTranslateForwardButton( entBtn )
	self.m_entMoveBackBtn = entBtn
end

function ENT:SetTranslateBackButton( entBtn )
	self.m_entMoveForwardBtn = entBtn
end

function ENT:SetWinchForwardButton( entBtn )
	self.m_entWinchForwardBtn = entBtn
end

function ENT:SetWinchBackButton( entBtn )
	self.m_entWinchBackBtn = entBtn
end

function ENT:SetWinchReleaseButton( entBtn )
	self.m_entBtnWinchRel = entBtn
	entBtn:SetCallback( function( entBtn, pPlayer, bOn )
		if self.m_intVehHoldStart then return end
		if self:IsBedLocked() then return end
		if bOn then
			self.m_entHook:Release()
		end
	end )
end

local function shouldBedCollide( entBed, entOther )
	if entOther.IsTow or (IsValid(entBed.m_entHook) and entOther == entBed.m_entHook:GetAttachedTo() and entBed:IsBedLocked()) then
		return false
	end

	return true
end

hook.Add( "ShouldCollide", "TowtruckBedCollisionRule", function( eEnt1, eEnt2 )
	--nocollide the bed with hooked stuff when locked
	if eEnt1:GetClass() == "ent_towtruck_bed" then
		return shouldBedCollide( eEnt1, eEnt2 )
	elseif eEnt2:GetClass() == "ent_towtruck_bed" then
		return shouldBedCollide( eEnt2, eEnt1 )
	end

	--nocollide the hook with the parent vehicle, but not the bed
	if eEnt1.IsTow and eEnt1.BedEnt then
		if eEnt2 == eEnt1.BedEnt.m_entHook then
			return false
		end
	elseif eEnt2.IsTow and eEnt2.BedEnt then
		if eEnt1 == eEnt2.BedEnt.m_entHook then
			return false
		end
	end
end )