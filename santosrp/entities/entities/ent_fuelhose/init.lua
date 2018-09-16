--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props_equipment/gas_pump_p16.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:PhysWake()
	self:SetTrigger( true )

	self.m_intLastTouch = 0
	self.Phys = self:GetPhysicsObject()
	self:NextThink( CurTime() )

	self.AdminPhysGun = true
end

function ENT:Think()
	local Owner = self:GetOwner()
	if not IsValid( Owner ) then self:Remove() end

	local Hold = self:IsPlayerHolding()
	local Parent = self:GetParent()
	
	if not IsValid( self.Phys ) then return end

	if (not Hold and not self.Phys:IsAsleep()) or (self:GetPos():Distance( Owner:GetPos() ) > 200) then   
		self.Phys:Sleep()
		self.Phys:EnableMotion( false )

		if not IsValid( Parent ) then
			local HosePos, HoseAng = Owner:GetHoseSlot( 1 )
			
			self:SetPos( HosePos )
			self:SetAngles( HoseAng )
			self:SetParent( Owner )
		end
	end
	
	if IsValid( Parent ) then
		if self:GetPos():Distance( Owner:GetPos() ) > 200 then
			self:SetParent( nil )
		end
	end

	self:NextThink( CurTime() +0.1 )
	return true
end

function ENT:Use( pPlayer )
    if self:IsPlayerHolding() then
    	return
    end
    
    self.m_intLastTouch = CurTime() +1
    self:SetParent( nil )
    self.Phys:EnableMotion( true )
    self.Phys:Wake()
    self.m_pHoldingPlayer = pPlayer
    
    pPlayer:PickupObject( self )
end

function ENT:StartTouch( eEnt )
	if eEnt:IsVehicle() and self:IsPlayerHolding() and not self.Phys:IsAsleep() and self.m_intLastTouch < CurTime() then
		if self:GetPos():Distance( self:GetOwner():GetPos() ) > 200 then return end
		self.Phys:Sleep()
		self.Phys:EnableMotion( false )

		self:SetParent( eEnt )
		
		if IsValid( eEnt.Hose ) and eEnt.Hose ~= self then 
			self:SetParent( nil )
		end

		eEnt.Hose = self
	end
end

hook.Add( "GetPreferredCarryAngles", "CarryGasPump", function( eEnt )
	if eEnt:GetClass() ~= "ent_fuelhose" then return end
	return Angle( -22.5, 180, 0 )
end )