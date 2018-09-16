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
ENT.MaxCookingTime 	= 5 *60
ENT.MaxFluidAmount	= 750
ENT.MaxNumFluids 	= 3
ENT.MaxItemAmount 	= 8
ENT.MaxNumItems 	= 3

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "IsCooking" )
	self:NetworkVar( "Float", 0, "Progress" )
	self:NetworkVar( "String", 0, "ItemID" )
	
	if SERVER then
		self:NetworkVarNotify( "IsCooking", self.OnCookingStatusChanged )
	end
end