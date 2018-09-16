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
		self:SetModel( "models/props_junk/garbage_bag001a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:PhysWake()

		self:SetFluidID( "Dirt" )
		self:SetEffect( "dirtFx", Vector(-7.283790, -2.089086, -1.120362), Color(60, 25, 0, 255) )
		self:SetCarryAngles( Angle(-90, 180, 0), Angle(15, 180, 0) )
	end
end