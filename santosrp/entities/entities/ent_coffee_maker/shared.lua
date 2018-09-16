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
ENT.MaxCoffeeAmount 	= 500
ENT.MaxWaterAmount		= 1000
ENT.MaxCoffeeGrainAmount = 500

ENT.UseWaterPerTick = 1
ENT.UseCoffeeGrainPerTick = 1
ENT.MakeCoffeePerTick = 1
ENT.CoffeeAmountPerItem = 125

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "On" )

	self:NetworkVar( "Int", 0, "WaterAmount" )
	self:NetworkVar( "Int", 1, "CoffeeGrainAmount" )
	self:NetworkVar( "Int", 2, "CoffeeAmount" )
end