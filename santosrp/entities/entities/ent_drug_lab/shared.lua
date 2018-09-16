--[[
	Name: shared.lua
	For: SantosRP
	By: TalosLife
]]--

ENT.Type 				= "anim"
ENT.Base 				= "base_anim"
ENT.PrintName			= ""
ENT.Author				= ""
ENT.Purpose				= ""
ENT.BurnerMaxFuel 		= 4
ENT.BurnerHeatPerTick	= 1
ENT.BurnerFuelPerTick 	= 0.005

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "BurnerOn" )
	self:NetworkVar( "Bool", 1, "BlenderOn" )

	self:NetworkVar( "Float", 0, "BurnerFuel" )
	self:NetworkVar( "Float", 1, "BlenderProgress" )

	self:NetworkVar( "String", 0, "BlendingID" )
end