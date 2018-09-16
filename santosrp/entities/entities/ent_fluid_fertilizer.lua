--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_base_fluid"

function ENT:ConfigInit()
	if SERVER then
		self:SetModel( "models/props_junk/plasticbucket001a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:PhysWake()

		self:SetFluidID( "Nutrients" )
		self:SetEffect( "dirtFx", Vector(-3.104821, 1.613948, 14.434947), Color(110, 60, 50, 255) )
		self:SetCarryAngles( Angle(0, 180, 0), Angle(80, 180, 0) )
	end
end