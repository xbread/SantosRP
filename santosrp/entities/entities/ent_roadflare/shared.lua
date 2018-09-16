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
ENT.BurnTime 		= 3 *60

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Lit" )
end