--[[
	Name: shared.lua
	For: SantosRP
	By: TalosLife
]]--

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Purpose			= ""

ENT.MaxDirt 		= 400
ENT.MaxWater		= 250
ENT.MaxNutrients	= 150
ENT.MaxLight 		= 100
ENT.MaxWind 		= 100

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Water" )
	self:NetworkVar( "Int", 1, "Dirt" )
	self:NetworkVar( "Int", 2, "Nutrients" )
	self:NetworkVar( "Int", 3, "Light" )
	self:NetworkVar( "Int", 4, "Wind" )
	self:NetworkVar( "Int", 5, "PlantHealth" )
	self:NetworkVar( "String", 0, "GrowingID" )
end