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
ENT.TrimTime 		= 30

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Running" )
end