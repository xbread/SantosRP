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
		self:SetModel( "models/shibcuppyhold.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:PhysWake()

		self:SetFluidID( "Coffee" )
		self:SetEffect( "waterFx", Vector(-0.088151, -0.650788, 8.061775), Color(60, 25, 0, 255) )
		self:SetCarryAngles( Angle(0, 180, 0), Angle(90, 180, 0) )
	end
	
	if CLIENT then self:SetPourSound( "ambient/water/leak_1.wav" ) end
end