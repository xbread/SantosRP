--[[
	Name: sv_cars.lua
	
		
]]--

GM.Cars = {}
GM.Cars.m_tblRegister = {}
GM.Cars.m_tblRegisterByMake = {}
GM.Cars.m_tblJobRegister = {}
GM.Cars.SPAWN_ERR_NOT_IN_BBOX = 0
GM.Cars.SPAWN_ERR_NO_SPAWNS = 1

--Loads all cars from the cars folder
function GM.Cars:LoadCars()
	GM:PrintDebug( 0, "->LOADING CARS" )

	local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "cars/*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( GM.Config.GAMEMODE_PATH.. "cars/".. v )
		AddCSLuaFile( GM.Config.GAMEMODE_PATH.. "cars/".. v )
	end

	GM:PrintDebug( 0, "->CARS LOADED" )
end

--Registers a car with the gamemode
function GM.Cars:Register( tblCar )
	self.m_tblRegister[tblCar.UID] = tblCar
	self.m_tblRegisterByMake[tblCar.Make] = self.m_tblRegisterByMake[tblCar.Make] or {}
	self.m_tblRegisterByMake[tblCar.Make][tblCar.UID] = tblCar
	--util.PrecacheModel( tblCar.Model )
end

--Registers a job car with the gamemode
function GM.Cars:RegisterJobCar( tblCar )
	self.m_tblJobRegister[tblCar.UID] = tblCar
	--util.PrecacheModel( tblCar.Model )
end

--Returns a car data table for the given uid
function GM.Cars:GetCarByUID( strCarUID )
	return self.m_tblRegister[strCarUID]
end

--Returns a table of cars by manufacturer
function GM.Cars:GetCarsByMake( strMake )
	return self.m_tblRegisterByMake[strMake]
end

--Returns all cars registered, sorted by manufacturer
function GM.Cars:GetAllCarsByMake()
	return self.m_tblRegisterByMake
end

--Returns all cars registered, sorted by uid
function GM.Cars:GetAllCarsByUID()
	return self.m_tblRegister
end

--Returns a car data table for the given uid (job cars only)
function GM.Cars:GetJobCarByUID( strCarUID )
	return self.m_tblJobRegister[strCarUID]
end

--Returns all job cars registered, sorted by uid
function GM.Cars:GetAllJobCars()
	return self.m_tblJobRegister
end

--Returns the total value of the given vehicle
function GM.Cars:CalcVehicleValue( entCar )
	local data = self:GetCarByUID( entCar.UID )
	if not data or not data.Price or data.Job then return end
	
	local ret = { BasePrice = data.Price, Value = data.Price }
	hook.Call( "GamemodeCalcVehicleValue", GAMEMODE, entCar, ret )

	return ret.Value
end

function GM.Cars:PlayerEnteredVehicle( pPlayer, entCar )
	if not entCar.UID then return end
	entCar:Fire( "TurnOff", "1" )
	self:UpdateFuelPlayerEnteredVehicle( pPlayer, entCar )
end

function GM.Cars:EntityTakeDamage( eEnt, pDamageInfo )
	if not eEnt:IsVehicle() then return end
	self:CarTakeDamage( eEnt, pDamageInfo )
end

function GM.Cars:ShouldCollide( eEnt1, eEnt2 )
	if eEnt1:IsVehicle() then
		if eEnt2.IsItem then return eEnt2.ItemData.CollidesWithCars or false end
	elseif eEnt2:IsVehicle() then
		if eEnt1.IsItem then return eEnt1.ItemData.CollidesWithCars or false end
	end

	return true
end

--[[ Car Damage ]]--
-- ----------------------------------------------------------------
GM.Cars.m_intDamageSpeedFactor = 0.000032
GM.Cars.m_intSmokeStart = 0.4
GM.Cars.m_intEngineDmgStart = 0.66
GM.Cars.m_strSmokeEffect = "smoke_exhaust_01a"
GM.Cars.m_tblImpactSounds = {
	Heavy = {
		Impact = {
			"ambient/materials/cartrap_explode_impact2.wav",
			"vehicles/v8/vehicle_rollover2.wav",
		},
		Glass = {
			"physics/glass/glass_sheet_break1.wav",
			"physics/glass/glass_sheet_break2.wav",
		},
	},
	Moderate = {
		Impact = {
			"ambient/materials/metal_stress1.wav",
			"ambient/materials/metal_stress2.wav",
			"ambient/materials/metal_stress4.wav",
			"ambient/materials/metal_stress5.wav",
		},
	}
}

PrecacheParticleSystem( GM.Cars.m_strSmokeEffect )
sound.Add{
	name = "engine_hiss",
	channel = CHAN_STATIC,
	volume = 0.75,
	level = 58,
	pitch = { 40, 45 },
	sound = "ambient/machines/gas_loop_1.wav"
}
sound.Add{
	name = "engine_broken1",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = 40,
	sound = "vehicles/v8/v8_idle_loop1.wav"
}

--Initializes vehicle health and registers physics callback
function GM.Cars:InitCarHealth( entCar, tblCarData )
	self:ResetCarHealth( entCar, true )
	entCar.VC_Health = GAMEMODE.Config.MaxCarHealth --VCMOD Compat
	entCar.VC_MaxHealth = GAMEMODE.Config.MaxCarHealth --VCMOD Compat
	entCar:SetNWInt( "VC_MaxHealth", GAMEMODE.Config.MaxCarHealth ) --VCMOD Compat

	if tblCarData and tblCarData.SavedHealth then
		self:SetCarHealth( entCar, tblCarData.SavedHealth, true )
	end

	if not GAMEMODE.Config.UseCustomVehicleDamage then return end
	entCar:AddCallback( "PhysicsCollide", function( ... ) self:OnVehicleCollide( ... ) end )
	entCar:CallOnRemove( "StopDamageSounds", function( ent )
		ent:StopSound( "engine_hiss" )
		ent:StopSound( "engine_broken1" )
	end )
end

--Sets a vehicles health back to max health
function GM.Cars:ResetCarHealth( entCar, bNoSave )
	self:SetCarHealth( entCar, self:GetCarMaxHealth(entCar), bNoSave )
end

--Sets the health of the given vehicle
function GM.Cars:SetCarHealth( entCar, intNewHealth, bNoSave )
	local oldHealth
	intNewHealth = math.Clamp( intNewHealth, 0, self:GetCarMaxHealth(entCar) )

	if GAMEMODE.Config.UseCustomVehicleDamage then
		oldHealth = entCar.m_intHealth or 0
		entCar.m_intHealth = intNewHealth
		entCar:SetNWInt( "CarHealth", entCar.m_intHealth )
		entCar:SetNWInt( "VC_Health", entCar.m_intHealth ) --VCMOD Compat

		self:UpdateCarEffects( entCar, intNewHealth )
		self:UpdateCarSounds( entCar, intNewHealth )
	else
		if VC_RepairHealth then VC_RepairHealth( entCar, intNewHealth ) end
	end

	self:UpdateCarEngineDamage( entCar )

	if not bNoSave and IsValid( entCar:GetPlayerOwner() ) then
		self:SaveCarStats( entCar:GetPlayerOwner(), entCar )
	end
	hook.Call( "GamemodeCarHealthChanged", GAMEMODE, entCar, oldHealth, intNewHealth )
end

--Returns the health of the given vehicle
function GM.Cars:GetCarHealth( entCar )
	return GAMEMODE.Config.UseCustomVehicleDamage and (entCar.m_intHealth or 0) or entCar.VC_Health
end

--Returns the max health of the given vehicle
function GM.Cars:GetCarMaxHealth( entCar )
	return GAMEMODE.Config.UseCustomVehicleDamage and GAMEMODE.Config.MaxCarHealth or entCar.VC_MaxHealth
end

--Physics collide callback for a vehicle, computes damage (if any) and calls EntityTakeDamage
function GM.Cars:OnVehicleCollide( entCar, tblData, physObj )
	if IsValid( tblData.HitEntity ) and (tblData.HitEntity:IsRagdoll() or tblData.HitEntity:IsPlayer()) then return end
	if tblData.HitEntity.DisableVehicleDamage then return end

	--local velNorm = (tblData.OurOldVelocity +tblData.TheirOldVelocity):GetNormalized()
	--local angVel = math.acos( tblData.HitNormal:Dot(velNorm) )
	--local dmgAngScalar = math.Clamp( 1 -((1.5 -angVel) /1.5), 0, 1 )

	local theirImpactSpeed = tblData.TheirOldVelocity:LengthSqr()
	local impactSpeed = tblData.OurOldVelocity:LengthSqr() +theirImpactSpeed
	if impactSpeed < 250000 then return end
	
	local newImpactSpeed = entCar:GetVelocity():LengthSqr() +tblData.HitEntity:GetVelocity():LengthSqr()
	local impactSpeedDelta = impactSpeed -newImpactSpeed
	if impactSpeedDelta < 25000 then return end
	impactSpeed = impactSpeed -250000

	local dmg = (impactSpeedDelta +impactSpeed *0.33) *self.m_intDamageSpeedFactor --*Lerp(dmgAngScalar, 1, 0.915))
	if dmg < 1 then return end
	
	local dmgInfo = DamageInfo()
	dmgInfo:SetDamage( dmg )
	dmgInfo:SetDamageType( DMG_CRUSH )
	hook.Call( "EntityTakeDamage", GAMEMODE, entCar, dmgInfo )
end

--Manages all damage for a vehicle, calls damage effect events and applies damage values to vehicle health
--Passes bullet damage to occupants and wheels
function GM.Cars:CarTakeDamage( entCar, pDamageInfo )
	if not GAMEMODE.Config.UseCustomVehicleDamage then
		if pDamageInfo:IsDamageType( DMG_BULLET ) then
			self:ProcessWheelDamage( entCar, pDamageInfo )
		end
		return
	end

	if pDamageInfo:IsDamageType( DMG_BULLET ) or pDamageInfo:IsDamageType( DMG_BUCKSHOT ) then
		if not self:ProcessWheelDamage( entCar, pDamageInfo ) then
			--self:BulletHitOccupant( entCar, pDamageInfo, pDamageInfo:GetAttacker() )
			self:SetCarHealth( entCar, math.max(self:GetCarHealth(entCar) -(pDamageInfo:GetDamage() *1250), 0) )
		end
	elseif pDamageInfo:IsDamageType( DMG_CRUSH ) then
		if pDamageInfo:GetDamage() >= 15 then
			self:HeavyDamageEvent( entCar, pDamageInfo )
		elseif pDamageInfo:GetDamage() >= 5 then
			self:ModerateDamageEvent( entCar, pDamageInfo )
		end

		if pDamageInfo:GetDamage() >= 5 then
			self:SetCarHealth( entCar, math.max(self:GetCarHealth(entCar) -pDamageInfo:GetDamage(), 0) )
		end
	else
		if pDamageInfo:GetDamage() >= 5 then
			self:SetCarHealth( entCar, math.max(self:GetCarHealth(entCar) -pDamageInfo:GetDamage(), 0) )
		end
	end

	if self:GetCarHealth( entCar ) <= 0 then
		entCar:StartEngine( false )
	end
end

--Sound and effects event for heavy crash events
function GM.Cars:HeavyDamageEvent( entCar, pDamageInfo )
	local snd, _ = table.Random( self.m_tblImpactSounds.Heavy.Impact )
	entCar:EmitSound( snd, 80, math.random(80, 130) )

	if math.random( 1, 2 ) == 1 then
		snd, _ = table.Random( self.m_tblImpactSounds.Heavy.Glass )
		entCar:EmitSound( snd, 65, math.random(90, 105) )
	end

	entCar:StartEngine( false )
	entCar:EmitSound( "vehicles/junker/jnk_stop1.wav" )

	if VC_HazardLightsOn then
		VC_HazardLightsOn( entCar )
	end
end

--Sound and effects event for normal crash events
function GM.Cars:ModerateDamageEvent( entCar, pDamageInfo )
	local snd, _ = table.Random( self.m_tblImpactSounds.Moderate.Impact )
	entCar:EmitSound( snd, 70, math.random(95, 105) )
end

--Update damage effects for a given car according to the health of the car
function GM.Cars:UpdateCarEffects( entCar, intHealth )
	local attachIDX = entCar:LookupAttachment( "vehicle_engine" )
	if attachIDX then
		if intHealth <= (GAMEMODE.Config.MaxCarHealth or 100) *self.m_intSmokeStart then
			if not entCar.m_bHasSmokeEmitter then
				entCar.m_bHasSmokeEmitter = true
				ParticleEffectAttach( self.m_strSmokeEffect, PATTACH_POINT_FOLLOW, entCar, attachIDX )
			end
		else
			if entCar.m_bHasSmokeEmitter then
				entCar:StopParticles()
				entCar.m_bHasSmokeEmitter = false
			end
		end
	end
end

--Update sound loops for the current car according to the health of the car
function GM.Cars:UpdateCarSounds( entCar, intHealth )
	if intHealth <= (GAMEMODE.Config.MaxCarHealth or 100) *self.m_intSmokeStart then
		if not entCar.m_bPlayingEngDmgSound then
			entCar.m_bPlayingEngDmgSound = true
			entCar:EmitSound( "engine_hiss" )
			entCar:EmitSound( "engine_broken1" )
		end
	else
		if entCar.m_bPlayingEngDmgSound then
			entCar.m_bPlayingEngDmgSound = false
			entCar:StopSound( "engine_hiss" )
			entCar:StopSound( "engine_broken1" )
		end
	end
end

--Updates the engine performance de-buff for the given vehicle according to the vehicle's health
function GM.Cars:UpdateCarEngineDamage( entCar )
	local health = self:GetCarHealth( entCar )
	local maxHealth = self:GetCarMaxHealth( entCar )
	if health > maxHealth *self.m_intEngineDmgStart then
		if self:GetVehicleParams( entCar, "EngineDamage" ) then
			self:RemoveVehicleParams( entCar, "EngineDamage" )
		end

		if entCar.m_intHorsepowerScalar then
			entCar.m_intHorsepowerScalar = nil
			self:InvalidateVehicleParams( entCar )
		end
		
		return
	end

	local endmin = maxHealth *0.1
	local start = maxHealth *self.m_intEngineDmgStart
	local scalar = ((start -endmin) -(health -endmin)) /(start -endmin)
	entCar.m_intHorsepowerScalar = scalar
	self:InvalidateVehicleParams( entCar )
end

--[[ Bullet Damage for Occupants ]]-- This is broken for now (not finished - the hit-boxes for a player need to be rotated correctly)
-- ----------------------------------------------------------------
function GM.Cars:BulletHitOccupant( entCar, pDamageInfo, pPlayer )
	local posDamage = pDamageInfo:GetDamagePosition()
	local posShootStart = pPlayer:GetShootPos()
	local normAttackDir = (posDamage -posShootStart):GetNormalized()

	--Test passengers
	local obbMins, obbMaxs, pl, angSeatForward
	local hitPos, vecNorm, rayFrac
	for k, v in pairs( entCar.VC_SeatTable or {} ) do
		if not IsValid( v ) or not IsValid( v:GetDriver() ) then continue end
		angSeatForward = v:GetAngles() +Angle( 0, 90, 0 )
		pl = v:GetDriver()

		local root = IsValid( v:GetParent() ) and v:GetParent() or v

		hitPos, vecNorm, rayFrac = util.IntersectRayWithOBB(
			posShootStart,
			normAttackDir *1e9,
			pl:GetPos(),
			angSeatForward,
			pl:OBBMins(),
			pl:OBBMaxs()
		)
		debugoverlay.Line( posShootStart, posShootStart +(normAttackDir *1e9), 10, Color(0, 255, 0), true ) 
		
		if not hitPos then continue end
		local mins, maxs, offset, ang
		local hitPos, vecNorm, rayFrac
		local origin, foundHitGroup = v:GetPos(), nil

		for groupIDX = 0, pl:GetHitBoxGroupCount() -1 do
			for hitIDX = 0, pl:GetHitBoxCount( groupIDX ) -1 do
				offset, ang = pl:GetBonePosition( pl:GetHitBoxBone(hitIDX, groupIDX) )
				mins, maxs = pl:GetHitBoxBounds( hitIDX, groupIDX )
				hitPos, vecNorm, rayFrac = util.IntersectRayWithOBB(
					posShootStart,
					normAttackDir *1e9,
					offset,
					ang,
					mins,
					maxs
				)

				debugoverlay.BoxAngles( offset, mins, maxs, ang, 20, Color(not hitPos and 255 or 0, hitPos and 255 or 0, 0, 200) )

				if hitPos then
					if not foundHitGroup then
						print( "FOUND HIT BONE = ".. hitIDX )
						foundHitGroup = groupIDX
					end
					--break
				end
			end

			if foundHitGroup then
				--break
			end
		end

		if foundHitGroup then
			print( "FOUND HIT GROUP = ".. foundHitGroup )
			--STUFF
			local dmgInfo = DamageInfo()
			dmgInfo:SetDamageType( pDamageInfo:GetDamageType() )
			dmgInfo:SetDamage( pDamageInfo:GetDamage() *(GAMEMODE.Config.CarBulletDmgFactor or 0.8) )
			dmgInfo:SetInflictor( pDamageInfo:GetInflictor() )
			dmgInfo:SetAttacker( pDamageInfo:GetAttacker() )
			hook.Call( "ScalePlayerDamage", GAMEMODE, pl, foundHitGroup, dmgInfo )
			pl:TakeDamageInfo( dmgInfo )
			break
		end
	end
end

--[[ Wheel Damage ]]-- Original script obtained from script fodder, integrated with gamemode for efficiency
-- ----------------------------------------------------------------
function GM.Cars:ProcessWheelDamage( entCar, pDamageInfo )
	local damage = pDamageInfo:GetDamage() *2500
	local position = pDamageInfo:GetDamagePosition()
	local distance = 0

	for i = 0, entCar:GetWheelCount() -1 do
		local wheel = entCar:GetWheel( i )

		if IsValid( wheel ) then
			distance = wheel:GetPos():Distance( position )

			if distance <= 20 and distance > 12 then
				entCar.m_tblWheelHealth = entCar.m_tblWheelHealth or {}
				entCar.m_tblWheelHealth[i] = (entCar.m_tblWheelHealth[i] or 10) -damage

				if entCar.m_tblWheelHealth[i] > 0 then
					entCar:EmitSound( "physics/rubber/rubber_tire_impact_bullet".. math.random(1, 3).. ".wav" )
					return
				end

				entCar:EmitSound( "ambient/materials/clang1.wav", 150, math.random(120, 150) )
					
				local hissing = CreateSound( entCar, "ambient/gas/cannister_loop.wav" )
				hissing:PlayEx( 0.5, 250 )
				hissing:FadeOut( 2 )
				timer.Simple( 2, function()
					if hissing then
						hissing:Stop()
						hissing = nil
					end
				end )

				local effect = EffectData()
				effect:SetStart( position )
				effect:SetOrigin( position )
				effect:SetScale( 30 )
				util.Effect( "GlassImpact", effect, true, true )

				self:PopVehicleWheel( entCar, i )
				return true
			end
		end
	end
end

function GM.Cars:PopVehicleWheel( eEnt, intIndex )
	local wheel = eEnt:GetWheel( intIndex )
	
	if IsValid( wheel ) then
		eEnt.m_tblOldDampingData = eEnt.m_tblOldDampingData or {}
		eEnt.m_tblOldDampingData[intIndex] = eEnt.m_tblOldDampingData[intIndex] or {}
		eEnt.m_tblOldDampingData[intIndex].m_intOldDamping = wheel:GetDamping()
		eEnt.m_tblOldDampingData[intIndex].m_intOldRotDamping = wheel:GetRotDamping()
		wheel:SetDamping( 2.5, 2.5 )
	end
	
	eEnt:SetSpringLength( intIndex, 499.9 )
end

function GM.Cars:FixVehicleWheels( eEnt )
	if not eEnt.m_tblWheelHealth then return false end
	eEnt.m_tblWheelHealth = nil

	local bRepaired = false
	for i = 0, eEnt:GetWheelCount() -1 do
		local wheel = eEnt:GetWheel( i )
		if IsValid( wheel ) then
			local data = eEnt.m_tblOldDampingData and eEnt.m_tblOldDampingData[i] or nil
			if data then
				wheel:SetDamping( data.m_intOldDamping or 0, data.m_intOldRotDamping or 0 )
			else
				wheel:SetDamping( 0, 0 )
			end
		end
		
		eEnt:SetSpringLength( i, 500.2 )
		bRepaired = true
	end

	if bRepaired and IsValid( eEnt:GetPlayerOwner() ) then
		self:SaveCarStats( eEnt:GetPlayerOwner(), eEnt )
	end

	self:InvalidateVehicleParams( eEnt )

	return bRepaired
end

function GM.Cars:HasDamagedWheels( eEnt )
	if not eEnt.m_tblWheelHealth then return false end
	for k, v in pairs( eEnt.m_tblWheelHealth ) do
		if v > 0 then continue end
		return true
	end

	return false
end

--[[ Car Fuel ]]-- 
-- ----------------------------------------------------------------
--Update the fuel status for cars owned by all players
function GM.Cars:TickCarFuel()
	local car
	for k, v in pairs( player.GetAll() ) do
		car = self:GetCurrentPlayerCar( v )
		if not IsValid( car ) then continue end

		if not car.Driven then car.Driven = 0 end
		local EngineOn = car:IsEngineStarted()
		if EngineOn then car.Driven = car.Driven +car:GetVelocity():Length() end
		if GAMEMODE.Util:ConvertUnitsToKM( car.Driven ) > car:GetFuelConsumption() then
			car.Driven = 0
			car:AddFuel( -1 )
			
			if car:GetFuel() <= 0 and EngineOn then
				car:Fire( "TurnOff", "1" )
				v:AddNote( "This car is out of fuel." )
			end
		end
	end
end

--Network current fuel state to the player entering this vehicle
function GM.Cars:UpdateFuelPlayerEnteredVehicle( pPlayer, entCar )
	if not entCar.m_intFuel then return end
	if entCar.m_intFuel <= 0 then pPlayer:AddNote( "This car is out of fuel." ) end
	GAMEMODE.Net:SendCarFuelUpdate( entCar, pPlayer )
end

local carMeta = debug.getregistry().Vehicle
function carMeta:GetFuel()
	return self.m_intFuel or 10
end

function carMeta:GetMaxFuel()
	return self.m_intMaxFuel or 10
end

function carMeta:GetFuelConsumption()
	return (self.m_intFuelConsumption or 0) +GAMEMODE.Config.BaseCarFuelConsumption
end

function carMeta:SetFuel( intFuel )
	self.m_intFuel = math.Clamp( intFuel, 0, self.m_intMaxFuel )
	GAMEMODE.Net:SendCarFuelUpdate( self )
end

function carMeta:AddFuel( intFuel )
	self:SetFuel( math.Clamp(self:GetFuel() +intFuel, 0, self:GetMaxFuel()) )
end

--[[ Vehicle Params ]]--
-- ----------------------------------------------------------------
--Grabs the un-modified vehicle params, fixes the units and stores the params for reuse
function GM.Cars:InitBaseVehicleParams( entCar )
	if not entCar.m_tblInitialParams then
		local params = entCar:GetVehicleParams() or {}
		self:FixVehicleParams( params )
		entCar.m_tblInitialParams = params
		entCar.m_tblParams = {}
	end
end

--Returns the fixed initial params for a spawned vehicle
function GM.Cars:GetBaseVehicleParams( entCar )
	return entCar.m_tblInitialParams
end

--Returns the table of applied params for the given id
function GM.Cars:GetVehicleParams( entCar, strParamID )
	return entCar.m_tblParams[strParamID]
end

--Returns all the registered vehicle params for a car
function GM.Cars:GetAllVehicleParams( entCar )
	return entCar.m_tblParams
end

--Applied a table of vehicle param data to a car
function GM.Cars:ApplyVehicleParams( entCar, strParamID, tblParams )
	entCar.m_tblParams[strParamID] = tblParams
	self:InvalidateVehicleParams( entCar )
end

--Removes a table of vehicle param data from a car
function GM.Cars:RemoveVehicleParams( entCar, strParamID )
	if entCar.m_tblParams[strParamID] then
		entCar.m_tblParams[strParamID] = nil
		self:InvalidateVehicleParams( entCar )
	end
end

--Called to rebuild the vehicle params for a car
function GM.Cars:InvalidateVehicleParams( entCar )
	local baseParams = table.Copy( self:GetBaseVehicleParams(entCar) )
	if not baseParams then return end
	
	for strID, params in pairs( entCar.m_tblParams ) do
		self:ApplyVehicleUpgradeParams( params, baseParams )
	end

	self:FinalizeNewVehicleParams( entCar, baseParams )
	entCar:SetVehicleParams( baseParams )
end

--Use this function to update values that rely on other values
function GM.Cars:FinalizeNewVehicleParams( entCar, tblNewParams )
	--Set the boost speed
	tblNewParams.engine.boostMaxSpeed = tblNewParams.engine.boostMaxSpeed +tblNewParams.engine.maxSpeed

	--Calc damage
	if entCar.m_intHorsepowerScalar then
		local minHP = math.min( 175, tblNewParams.engine.horsepower )
		local targetHP = -(tblNewParams.engine.horsepower -minHP)
		tblNewParams.engine.horsepower = tblNewParams.engine.horsepower -Lerp( entCar.m_intHorsepowerScalar, 0, tblNewParams.engine.horsepower -minHP )
	end
end

--Convert units from initial params to valid units for setting the params again
function GM.Cars:FixVehicleParams( tblParams )
	if not tblParams.engine then return end
	if tblParams.engine.boostMaxSpeed > 0 then
		tblParams.engine.boostMaxSpeed = tblParams.engine.boostMaxSpeed /17.6
	end

	if tblParams.engine.maxRevSpeed > 0 then
		tblParams.engine.maxRevSpeed = tblParams.engine.maxRevSpeed /17.6
	end

	if tblParams.engine.maxSpeed > 0 then
		tblParams.engine.maxSpeed = tblParams.engine.maxSpeed /17.6
	end
end

--Recursive + additive table merge
function GM.Cars:ApplyVehicleUpgradeParams( tblParams, tblApplyTo )
	for k, v in pairs( tblParams ) do
		if type( v ) == "table" then
			tblApplyTo[k] = tblApplyTo[k] or {}
			self:ApplyVehicleUpgradeParams( v, tblApplyTo[k] )
			continue
		end

		if type( v ) == "number" then
			tblApplyTo[k] = (tblApplyTo[k] or 0) +v
		else
			tblApplyTo[k] = v
		end
	end
end

--[[ Car Spawning ]]--
-- ----------------------------------------------------------------
--Initializes the vehicles health, fuel and various damage states, also networks info about this data to clients
function GM.Cars:SetupCarStats( entCar, tblData )
	local data = entCar.CarData
	if not data then return end

	entCar:SetNWString( "VC_Name", data.Make.. " ".. data.Name ) --VCMod Compat
	entCar.m_intMaxFuel = data.FuelTank or 10
	entCar.m_intFuelConsumption = data.FuelConsumption or 10
	entCar.m_intFuel = tblData and tblData.SavedFuel or (data.FuelTank or 10)
	entCar.m_tblWheelHealth = tblData and tblData.SavedWheelData or nil

	self:InitCarHealth( entCar, tblData )

	if not GAMEMODE.Config.UseCustomVehicleDamage then
		if tblData and tblData.SavedHealth then --I thought vcmod was pretty nice.
			VC_Initialize( entCar ) --why don't you just use EntityCreated... WHY THINK ENTITY LOOKUP YOU FUCK
			entCar.VC_Initialized = true --SEE ABOVE
			VC_HandleHealth( entCar ) --ARE YOU KIDDING ME INIT DOESN'T HANDLE THIS SHIT?

			if tblData.SavedHealth <= 0 then
				entCar.VC_EBroke = true --STOP FUCKING EXPLODING
				entCar.VC_TBESDO = -1 --STOP FUCKING BURNING
			end
			
			entCar.VC_Health = tblData.SavedHealth
			entCar:SetNWInt( "VC_Health", entCar.VC_Health )
		end
	end --I thought wrong...
	
	if tblData and tblData.SavedWheelData then
		for k, v in pairs( tblData.SavedWheelData ) do
			if v > 0 then continue end
			self:PopVehicleWheel( entCar, k )		
		end
	end

	GAMEMODE.Net:SendCarFuelUpdate( entCar )
end

--Saves health, fuel and damage states for the owner of a vehicle
function GM.Cars:SaveCarStats( pPlayer, entCar, bNoSave )
	if entCar.Job then return end
	if not entCar.UID or not self:PlayerOwnsCar( pPlayer, entCar.UID ) then return end
	if entCar:GetPlayerOwner() ~= pPlayer then return end
	
	local data = self:GetPlayerCarData( pPlayer, entCar.UID ) or {}
	data.SavedFuel = entCar.m_intFuel
	data.SavedHealth = self:GetCarHealth( entCar )
	data.SavedWheelData = entCar.m_tblWheelHealth

	if not bNoSave then
		GAMEMODE.SQL:MarkDiffDirty( pPlayer, "vehicles" )
	end
end

--Checks if the player has spawned a valid car
function GM.Cars:PlayerHasCar( pPlayer )
	return IsValid( pPlayer.m_entCurrentCar )
end

--Returns the players currently spawned car (if any)
function GM.Cars:GetCurrentPlayerCar( pPlayer )
	return pPlayer.m_entCurrentCar
end

--Checks if the player's currently spawned car belongs to the provided job id
function GM.Cars:IsPlayerCarForJob( pPlayer, intJobID )
	if not self:PlayerHasCar( pPlayer ) then return false end
	return pPlayer.m_entCurrentCar.Job == intJobID
end

--Spawns a car from the given car data table and sets the owner to the provided player
--funcPostCreated: callback run after the car is initialized but before PlayerSpawnedVehicle is run
function GM.Cars:SpawnPlayerVehicle( pOwner, tblCarData, vecPos, vecAngs, funcPostCreated )
	local car = ents.Create( "prop_vehicle_jeep" ) 
	car:SetModel( tblCarData.Model ) 
	car:SetKeyValue( "vehiclescript", tblCarData.Script )
	car:DrawShadow( false )
	car:SetPos( vecPos )
	car:SetAngles( vecAngs )

	car.AdminPhysGun = true
	car.CarData = tblCarData
	car.UID = tblCarData.UID
	car.Job = tblCarData.Job and _G[tblCarData.Job] or nil
	car.VehicleTable = tblCarData.VehicleTable and list.Get( "Vehicles" )[tblCarData.VehicleTable] or nil

	car:Spawn()
	car:Activate()
	car:SetCustomCollisionCheck( true )
	car:SetPlayerOwner( pOwner )
	self:InitBaseVehicleParams( car )

	if funcPostCreated then
		funcPostCreated( pOwner, car, tblCarData )
	end

	if IsValid( pOwner ) then
		self:SetupCarStats( car, self:GetPlayerCarData(pOwner, tblCarData.UID) )
		hook.Call( "PlayerSpawnedVehicle", GAMEMODE, pOwner, car )
	end
	
	timer.Simple( 0, function() --fucking vcmod
		car.IsLocked = true
		car.IsTrunkLocked = true
		car.VC_Locked = true
		car:Fire( "Lock" )
		for k, v in pairs( car.VC_SeatTable or {} ) do
			v.IsLocked = true
			v.VC_Locked = true
			v:Fire( "Lock" )
		end
	end )

	car:SetNWString( "UID", tblCarData.UID )

	return car
end

--Called when a player spawns a car they own from the garage
function GM.Cars:PlayerSpawnCar( pPlayer, strCarUID )
	local newCar = self:GetCarByUID( strCarUID )
	if not newCar then return false end
	if not self:PlayerOwnsCar( pPlayer, strCarUID ) then return false end

	if hook.Call( "GamemodePlayerCanSpawnCar", GAMEMODE, pPlayer, strCarUID ) == false then
		return
	end
	
	local curCar = self:GetCurrentPlayerCar( pPlayer )
	if IsValid( curCar ) then
		if not GAMEMODE.Util:VectorInRange( curCar:GetPos(), GAMEMODE.Config.CarGarageBBox.Min, GAMEMODE.Config.CarGarageBBox.Max ) then
			pPlayer:AddNote( "Your current car is not in the garage zone!" )
			return false
		else
			self:SaveCarStats( pPlayer, curCar )
			curCar:Remove()
		end
	end

	local spawnPos, spawnAngs = GAMEMODE.Util:FindSpawnPoint( GAMEMODE.Config.CarSpawns, 80 )
	if not spawnPos then
		pPlayer:AddNote( "Unable to find a spawn point for your car." )
		pPlayer:AddNote( "Wait for the area to clear and try again." )
		return false
	end
	
	local car = self:SpawnPlayerVehicle( pPlayer, newCar, spawnPos, spawnAngs, function( pOwner, entCar, tblData )
		pOwner.m_entCurrentCar = entCar
		pOwner:SetNWEntity( "CurrentCar", entCar )
		pOwner:AddNote( "You spawned your car!" )
	end )

	return true
end

--Called when a player spawns a car tied to a specific job (ex: police car/firetruck)
function GM.Cars:PlayerSpawnJobCar( pPlayer, strJobCarID, tblSpawnPoints, tblStowBox )
	local newCar = self:GetJobCarByUID( strJobCarID )
	if not newCar then return false end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, _G[newCar.Job] ) then return false end

	local curCar = self:GetCurrentPlayerCar( pPlayer )
	if IsValid( curCar ) then
		if tblStowBox then
			if not GAMEMODE.Util:VectorInRange( curCar:GetPos(), tblStowBox.Min, tblStowBox.Max ) then
				pPlayer:AddNote( "Your current car is not in the garage zone!" )
				return false, self.SPAWN_ERR_NOT_IN_BBOX
			else
				self:SaveCarStats( pPlayer, curCar )
				curCar:Remove()
			end
		else
			self:SaveCarStats( pPlayer, curCar )
			curCar:Remove()
		end
	end

	local spawnPos, spawnAngs = GAMEMODE.Util:FindSpawnPoint( tblSpawnPoints, 80 )
	if not spawnPos then
		pPlayer:AddNote( "Unable to find a spawn point for your car." )
		pPlayer:AddNote( "Wait for the area to clear and try again." )
		return false, self.SPAWN_ERR_NO_SPAWNS
	end

	local car = self:SpawnPlayerVehicle( pPlayer, newCar, spawnPos, spawnAngs, function( pOwner, entCar, tblData )
		pOwner.m_entCurrentCar = entCar
		pOwner:SetNWEntity( "CurrentCar", entCar )
	end )

	return car
end

--[[ Car ownership ]]--
-- ----------------------------------------------------------------
--Checks if a player owns the provided car uid
function GM.Cars:PlayerOwnsCar( pPlayer, strCarUID )
	return pPlayer:GetCharacter().Vehicles[strCarUID] and true or false
end

--Returns the meta-data for a saved car a player owns (if any)
function GM.Cars:GetPlayerCarData( pPlayer, strCarUID )
	return pPlayer:GetCharacter().Vehicles[strCarUID]
end

--Called when a player tries to buy a new car
function GM.Cars:PlayerBuyCar( pPlayer, strCarUID, intCarColor )
	local car = self:GetCarByUID( strCarUID )
	if not car then return false end
	if car.VIP and not pPlayer:CheckGroup( "vip" ) then return false end

	local colCarColor = Color( 255, 255, 255, 255 )
	local idx = 0
	for k, v in pairs( GAMEMODE.Config.StockCarColors ) do
		idx = idx +1
		if idx == intCarColor then
			colCarColor = v
		end
	end
	
	if self:PlayerOwnsCar( pPlayer, strCarUID ) then return false end
	local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", car.Price )

	if not pPlayer:CanAfford( price ) then
		pPlayer:AddNote( "You can't afford that car!" )
		return false
	end

	pPlayer:TakeMoney( price )
	pPlayer:GetCharacter().Vehicles[strCarUID] = {
		color = colCarColor or Color( 255, 255, 255, 255 ),
	}
	GAMEMODE.Player:SetGameVar( pPlayer, "vehicles", pPlayer:GetCharacter().Vehicles )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "vehicles" )

	pPlayer:AddNote( "You purchased a new vehicle!" )
	pPlayer:AddNote( "Go to the garage to spawn it." )
end

--Called when a player tries to sell a car they own
function GM.Cars:PlayerSellCar( pPlayer, strCarUID )
	local car = self:GetCarByUID( strCarUID )
	if not car then return false end
	if not self:PlayerOwnsCar( pPlayer, strCarUID ) then return false end

	local price = car.Price *(pPlayer:CheckGroup("vip") and 0.75 or 0.6)
	pPlayer:AddMoney( price )
	pPlayer:GetCharacter().Vehicles[strCarUID] = nil
	GAMEMODE.Player:SetGameVar( pPlayer, "vehicles", pPlayer:GetCharacter().Vehicles )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "vehicles" )

	local curCar = self:GetCurrentPlayerCar( pPlayer )
	if IsValid( curCar ) and curCar.UID == strCarUID then
		curCar:Remove()
	end

	pPlayer:AddNote( "You sold a car for $".. string.Comma(price).. "!" )
end

--Called when a player wants to store their car in the garage
function GM.Cars:PlayerStowCar( pPlayer )
	if not self:PlayerHasCar( pPlayer ) then return false end

	local curCar = self:GetCurrentPlayerCar( pPlayer )
	if not IsValid( curCar ) then return false end
	if not GAMEMODE.Util:VectorInRange( curCar:GetPos(), GAMEMODE.Config.CarGarageBBox.Min, GAMEMODE.Config.CarGarageBBox.Max ) then
		pPlayer:AddNote( "Your current car is not in the garage zone!" )
		return false, self.SPAWN_ERR_NOT_IN_BBOX
	else
		self:SaveCarStats( pPlayer, curCar )
		curCar:Remove()
	end	

	pPlayer:AddNote( "You stored your active car in the garage." )
end

--Called when a player wants to return a job vehicle
function GM.Cars:PlayerStowJobCar( pPlayer, tblStowBox )
	local curCar = self:GetCurrentPlayerCar( pPlayer )
	if not IsValid( curCar ) then return false end
	if not GAMEMODE.Util:VectorInRange( curCar:GetPos(), tblStowBox.Min, tblStowBox.Max ) then
		pPlayer:AddNote( "Your current car is not in the garage zone!" )
		return false, self.SPAWN_ERR_NOT_IN_BBOX
	else
		curCar:Remove()
	end

	pPlayer:AddNote( "You stored your active car in the garage." )
end