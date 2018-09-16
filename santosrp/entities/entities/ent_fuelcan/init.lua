--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props_junk/gascan001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetTrigger( true )
	self:PhysWake()
end

function ENT:StartTouch( eEnt )
	if self.m_bTouched then return end
	if not IsValid( eEnt ) or not eEnt:IsVehicle() or not eEnt.UID then return end
	if eEnt:GetFuel() < eEnt:GetMaxFuel() then
		eEnt:AddFuel( 1 )
		eEnt:EmitSound( "ambient/water/water_spray1.wav", 70, 70 )

		self.m_bTouched = true
		self:Remove()
	end
end