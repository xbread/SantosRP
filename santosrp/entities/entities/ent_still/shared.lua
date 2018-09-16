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
ENT.MaxProgress 		= 500
ENT.MaxFluid			= 500

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "StillOn" )
	self:NetworkVar( "Int", 0, "Progress" )
	self:NetworkVar( "Int", 1, "FluidAmount" )
	self:NetworkVar( "String", 0, "ItemID" )
end