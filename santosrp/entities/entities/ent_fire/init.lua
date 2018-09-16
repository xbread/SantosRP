--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	local fireSize = Vector( 1, 1, 1 ) *52

	self:SetModel( "models/props_wasteland/kitchen_counter001c.mdl" )
	self:PhysicsInitBox( -fireSize, fireSize )

	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetCollisionBounds( -fireSize, fireSize )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_BBOX )
	self:DrawShadow( false )
	self:SetTrigger( true )
	--self:SetCustomCollisionCheck( true )

	self.m_intSpawnTime = CurTime()
	self.m_intLastBurn = 0
	self.m_intBurnInterval = 2
	self.m_intBurnDamage = 10
	--self.m_intLifeTime = math.random( 45, 80 )
	self.m_intWaterHit = 0
	self.m_intHitsToRemove = 9

	self.m_tblBurning = {}

	self.m_pSound = CreateSound( self, "interior_fire01_stereo.wav" )
	if self.m_pSound then
		self.m_pSound:Play()
		self.m_pSound:ChangeVolume( 0.15, 0 )
	end

	self.AdminPhysGun = true
end

function ENT:StartTouch( eEnt )
	if not IsValid( eEnt ) or eEnt:IsVehicle() then return end
	if eEnt:IsPlayer() and eEnt:InVehicle() then return end
	self.m_tblBurning[eEnt] = true
	self:Burn( eEnt )
end

function ENT:EndTouch( eEnt )
	if not IsValid( eEnt ) then return end
	self.m_tblBurning[eEnt] = nil
end

function ENT:Think()
	--if CurTime() > self.m_intSpawnTime +self.m_intLifeTime then
	--	self:Remove()
	--	return
	--end

	if CurTime() < self.m_intLastBurn then return end
	for k, v in pairs( self.m_tblBurning ) do
		if not IsValid( k ) then self.m_tblBurning[k] = nil continue end
		self:Burn( k )
	end

	self.m_intLastBurn = CurTime() +self.m_intBurnInterval
end

function ENT:Burn( eEnt )
	--eEnt:Ignite( eEnt:IsPlayer() and self.m_intBurnInterval or 60 )
	eEnt.m_bIsOnFire = true

	local dmgInfo = DamageInfo()
	dmgInfo:SetAttacker( self )
	dmgInfo:SetInflictor( self )
	dmgInfo:SetDamage( 2 )
	dmgInfo:SetDamageType( DMG_BURN )
	eEnt:TakeDamageInfo( dmgInfo )

	--eEnt:StopParticles()
	--ParticleEffectAttach( "fire_medium_01", PATTACH_ABSORIGIN_FOLLOW, eEnt, 0 )
end

function ENT:WaterHit( pPlayer )
	self.m_intWaterHit = self.m_intWaterHit +1

	if self.m_intWaterHit >= self.m_intHitsToRemove then
		if self.m_bRemoved then return end
		self:Remove()
		self.m_bRemoved = true

		if not IsValid( pPlayer ) then return end
		if not pPlayer.m_intFireExtinguishCount then
			pPlayer.m_intFireExtinguishCount = 0
		end
		pPlayer.m_intFireExtinguishCount = pPlayer.m_intFireExtinguishCount +1

		if pPlayer.m_intFireExtinguishCount >= GAMEMODE.Config.FireExtinguishBonusCount then
			pPlayer:AddBankMoney( GAMEMODE.Config.FireBonus )
			pPlayer:AddNote( "You earned a $".. GAMEMODE.Config.FireBonus.. " bonus for fighting a fire!" )
			pPlayer:AddNote( "This bonus has been sent to your bank account." )
			pPlayer.m_intFireExtinguishCount = 0
		end
	end
end

function ENT:OnRemove()
	--self:StopParticles()
	if self.m_pSound then
		self.m_pSound:Stop()
	end
end

--timer.Create( "UpdateBurningEnts", 1, 0, function() 
--	for k, v in pairs( ents.GetAll() ) do
--		if not v:IsOnFire() and v.m_bIsOnFire then
--			v:StopParticles()
--			v.m_bIsOnFire = false
--		end
--	end
--end )