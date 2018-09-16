--[[
	Name: shared.lua
	For: SantosRP
	By: TalosLife
]]--

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Purpose			= "Clothing Locker"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "JobID" )
end