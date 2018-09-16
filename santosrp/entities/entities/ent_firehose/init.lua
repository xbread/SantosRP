--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local MAX_HOSE_DISTANCE = 2048

function ENT:Initialize()
	self:SetModel( "models/props_lab/tpplug.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

	self.Phys = self:GetPhysicsObject()
	self.Phys:EnableGravity( false )
	
	self.LastTouch = CurTime()
	self.m_intLastFire = 0
	self.m_intLastCheck = 0
	self.m_intCheckInterval = 0.1
	self.m_intFireInterval = 0.1
	self.m_bPosSet = true
	
	self:NextThink( CurTime() +1 )
	self.AdminPhysGun = true
end

function ENT:Think()
	if not IsValid( self:GetOwner() ) then self:Remove() end
	local Hold = IsValid( self.m_pPlayerHolding )
	local Parent = self:GetParent()

	if not Hold and self.m_bPosSet then
		local HosePos, HoseAng = self:GetOwner():GetHoseSlot()
		if self:GetPos():Distance( HosePos ) > 8 then --what the fuck
			self.m_bPosSet = false
		end
	elseif not Hold and (not self.m_bPosSet or not self.Phys:IsAsleep()) then	
		self.Phys:Sleep()
		self.Phys:EnableMotion( false )
		
		local HosePos, HoseAng = self:GetOwner():GetHoseSlot()
			
		self:SetPos( HosePos )
		self:SetAngles( HoseAng )
		
		self:SetParent( self:GetOwner() )

		self.m_bUseBlock = false
		self.m_bPosSet = true
	elseif Hold then
		if self:GetPos():Distance( self:GetOwner():GetPos() ) > MAX_HOSE_DISTANCE or self.m_pPlayerHolding:InVehicle() or not self.m_pPlayerHolding:Alive() then
			self.m_pPlayerHolding = nil
			return
		end

		self.m_bPosSet = false
		if self.m_bUseBlock and not self.m_pPlayerHolding:KeyDown( IN_USE ) then
			self.m_bUseBlock = false
		end

		if self.m_pPlayerHolding:KeyDown( IN_ATTACK2 ) then
			self:FireWater()
			if not self:GetOn() then self:SetOn( true ) end
		else
			self.m_intLastCheck = CurTime()
			if self:GetOn() then self:SetOn( false ) end
		end

		local eyeAng = self.m_pPlayerHolding:EyeAngles()
		eyeAng.p = eyeAng.p *-1
		self:SetAngles( eyeAng -Angle(0, 180, 0) )
		self:SetPos( self.m_pPlayerHolding:GetShootPos() +
			(self.m_pPlayerHolding:GetAimVector() *48) +
			self:GetAngles():Right() *-6 +
			self:GetAngles():Up() *-4
		)
		
	end
	
	self:NextThink( CurTime() )

	return true
end

function ENT:Use( user )
	if self.m_pPlayerHolding and not self.m_bUseBlock then
		self.m_pPlayerHolding = nil
		self.m_bUseBlock = true
		return
	end

	self.LastTouch = CurTime() +1
	self:SetParent( nil )
	self.Phys:EnableMotion( true )
	self.Phys:Wake()
	
	self.m_pPlayerHolding = user
	self.m_bUseBlock = true
end

local waterSize = 6
function ENT:FireWater()
	if CurTime() > self.m_intLastCheck +self.m_intCheckInterval then
		local tr = util.TraceLine{
			start = self:GetPos(),
			endpos = self:GetPos() +self:GetAngles():Forward() *-2100,
			filter = { self.m_pPlayerHolding, self },
			--mins = Vector(1, 1, 1) *-waterSize,
			--maxs = Vector(1, 1, 1) *waterSize,
		}

		if IsValid( tr.Entity ) then
			if tr.Entity:GetClass() == "ent_fire" then
				tr.Entity:WaterHit( self.m_pPlayerHolding )
			elseif tr.Entity:IsOnFire() then
				tr.Entity:Extinguish()
			else
				local found = ents.FindInSphere( tr.Entity:GetPos(), 32 )
				for k, v in pairs( found ) do
					if not IsValid( v ) or v:GetClass() ~= "ent_fire" then continue end
					v:WaterHit( self.m_pPlayerHolding )
					break
				end
			end
		end

		self.m_intLastCheck = CurTime()
	end
end