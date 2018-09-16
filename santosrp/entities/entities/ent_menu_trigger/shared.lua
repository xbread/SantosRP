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
ENT.m_intMaxRenderRange = 512

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "Text" )
end