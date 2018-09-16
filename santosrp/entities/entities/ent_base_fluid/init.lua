--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self.m_vecEffectPos = Vector( -7.283790, -2.089086, -1.120362 )
	self.m_tblShadowParams = {}

	self:SetModel( "models/props_junk/garbage_bag001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()

	self:SetCarryAngles( Angle(-90, 180, 0), Angle(15, 180, 0) )
	if self.ConfigInit then
		self:ConfigInit()
	end

	self.Phys = self:GetPhysicsObject()
	self:NextThink( CurTime() +1 )
	self:StartMotionController()
end

function ENT:SetFluidID( strFluid )
	self.m_strFluid = strFluid
	self.m_intCurFluid = self.MaxFluid
	self:SetDisplayText( strFluid )
end

function ENT:SetEffect( strEffectName, vecPos, colColor )
	self.m_strEffectName = strEffectName
	self.m_vecEffectPos = vecPos

	if colColor then self.m_colEffectColor = colColor end
end

function ENT:SetCarryAngles( angHolding, angPouring )
	self.m_angHold = angHolding
	self.m_angPour = angPouring
end

function ENT:Think()
	local Hold = IsValid( self.m_pPlayerHolding )
	if Hold then
		if self.m_bUseBlock and not self.m_pPlayerHolding:KeyDown( IN_USE ) then
			self.m_bUseBlock = false
		end

		if not self.m_pPlayerHolding:Alive() then
			self.m_pPlayerHolding = nil
			return
		end

		if self.m_pPlayerHolding:KeyDown( IN_ATTACK2 ) then
			self:ThinkEffect()
			self:TraceFluid()

			if self.m_intCurFluid <= 0 then
				if self:GetPouring() then self:SetPouring( false ) end
			else
				if not self:GetPouring() then self:SetPouring( true ) end
			end
		else
			if self:GetPouring() then self:SetPouring( false ) end
		end
	else
		if self.Phys:IsAsleep() and self.m_intCurFluid <= 0 then
			self:Remove()
		end
	end
end

function ENT:PhysicsSimulate( phys, intDeltaTime )
	local Hold = IsValid( self.m_pPlayerHolding )

	if Hold and IsValid( phys ) then
		local eyeAng = self.m_pPlayerHolding:EyeAngles()
		eyeAng.p = eyeAng.p *-1

		if self.m_pPlayerHolding:KeyDown( IN_ATTACK2 ) then
			self.m_tblShadowParams.angle = eyeAng -self.m_angPour
		else
			self.m_tblShadowParams.angle = eyeAng -self.m_angHold
		end

		phys:Wake()

		local newpos = self.m_pPlayerHolding:GetShootPos() +self.m_intHeldDistance *self.m_pPlayerHolding:GetAimVector()
		self.m_tblShadowParams.secondstoarrive = 0.1
		self.m_tblShadowParams.pos = newpos
		self.m_tblShadowParams.maxangular = 1000000
		self.m_tblShadowParams.maxangulardamp = 1000000
		self.m_tblShadowParams.maxspeed = 1000000
		self.m_tblShadowParams.maxspeeddamp = 1000000
		self.m_tblShadowParams.dampfactor = 0.8
		self.m_tblShadowParams.teleportdistance = 0
		self.m_tblShadowParams.deltatime = intDeltaTime
		phys:ComputeShadowControl( self.m_tblShadowParams )
	end

	return
end

function ENT:ThinkEffect()
	if not self.m_intLastEffect then
		self.m_intLastEffect = 0
	end

	if CurTime() > self.m_intLastEffect then
		self.m_intLastEffect = CurTime() +0.1
		if self.m_intCurFluid <= 0 then return end

		local effectData = EffectData()
		effectData:SetOrigin( self:LocalToWorld(self.m_vecEffectPos) )
		effectData:SetNormal( Vector(0, 0, -1) )
		effectData:SetStart( self.m_colEffectColor and Vector(self.m_colEffectColor.r, self.m_colEffectColor.g, self.m_colEffectColor.b) or Vector(255, 255, 255) ) --hax
		util.Effect( self.m_strEffectName, effectData )
	end
end

function ENT:TraceFluid()
	if not self.m_intLastTrace then
		self.m_intLastTrace = 0
	end

	if CurTime() < self.m_intLastTrace then return end
	self.m_intLastTrace = CurTime() +0.5

	if self.m_intCurFluid <= 0 then return end
	
	local tr = util.TraceLine{
		start = self:GetPos(),
		endpos = self:GetPos() +Vector(0, 0, -256),
		filter = { self, self.m_pPlayerHolding },
	}

	local take = math.min( self.m_intCurFluid, 25 )
	self.m_intCurFluid = math.max( self.m_intCurFluid -take, 0 )

	if IsValid( tr.Entity ) and tr.Entity.ReceiveFluid then
		tr.Entity:ReceiveFluid( self.m_strFluid, take )
	end

	self.ItemTakeBlocked = self.m_intCurFluid ~= self.MaxFluid
end

function ENT:Use( pPlayer )
	if self.m_pPlayerHolding and not self.m_bUseBlock then
		if pPlayer ~= self.m_pPlayerHolding then return end
		
		self.m_pPlayerHolding = nil
		pPlayer.m_bHoldingBaseFluid = false
		self.m_bUseBlock = true
		self.ItemTakeBlocked = self.m_intCurFluid ~= self.MaxFluid

		return
	end

	if pPlayer.m_bHoldingBaseFluid then return end

	pPlayer.m_bHoldingBaseFluid = true
	self.m_pPlayerHolding = pPlayer
	self.m_bUseBlock = true
	self.ItemTakeBlocked = true

	self.m_angHeldOffsetAngle = self:WorldToLocalAngles( self:GetAngles() )
	self.m_intHeldDistance = (self:GetPos() -pPlayer:GetPos()):Length()
	self.Phys:Wake()
end

function ENT:CanSendToLostAndFound()
	if self.ItemTakeBlocked then
		return false
	end

	return true
end