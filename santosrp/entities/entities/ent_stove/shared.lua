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
ENT.BurnerFuelPerTick 	= 0.005
ENT.BurnerPos = {
	{pos = Vector(4.900319, 11.280236, 46.5), fxPos = Vector(4.900319, 11.280236, 40.031254), ang = Angle(0, 90, 0) },
	{pos = Vector(-8.558583, 11.280236, 46.5), fxPos = Vector(-8.558583, 11.280236, 40.031254), ang = Angle(0, 90, 0) },
	{pos = Vector(-8.558583, 25.288284, 46.5), fxPos = Vector(-8.558583, 25.288284, 40.031258), ang = Angle(0, 90, 0) },
	{pos = Vector(4.900319, 25.288284, 46.5), fxPos = Vector(4.900319, 25.288284, 40.031258), ang = Angle(0, 90, 0) },
}

function ENT:SetupDataTables()
	for i = 1, 4 do
		self:NetworkVar( "Bool", i -1, "Burner".. i.. "On" )
	end

	for i = 5, 8 do
		self:NetworkVar( "Bool", i -1, "HasPot".. (i -4) )
	end

	self:NetworkVar( "Bool", 8, "OvenOn" )
	self:NetworkVar( "Float", 0, "BurnerFuel" )
	self:NetworkVar( "Float", 1, "OvenProgress" )
	self:NetworkVar( "String", 0, "OvenID" )
end

function ENT:GetLitBurnerNum()
	local count = 0
	for i = 1, 4 do
		if self:GetBurnerOn( i ) then
			count = count +1
		end
	end

	return count
end

function ENT:GetBurnerOn( intIDX )
	return self["GetBurner".. intIDX.. "On"]( self )
end

if SERVER then
	function ENT:SetBurnerOn( intIDX, bOn )
		self["SetBurner".. intIDX.. "On"]( self, bOn )
	end

	function ENT:TurnOffAllBurners()
		for i = 1, 4 do
			self:SetBurnerOn( i, false )
		end
	end
end