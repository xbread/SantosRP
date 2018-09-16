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
ENT.MaxFluid 		= 500

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Pouring" )
	self:NetworkVar( "String", 0, "DisplayText" )
end