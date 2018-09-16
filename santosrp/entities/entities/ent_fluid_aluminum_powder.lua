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
		self:SetModel( "models/props_lab/jar01b.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:PhysWake()

		self:SetFluidID( "Aluminum Powder" )
		self:SetEffect( "dirtFx", Vector(-7.283790, -2.089086, -1.120362) )
		self:SetCarryAngles( Angle(0, 180, 0), Angle(80, 180, 0) )
	end
end