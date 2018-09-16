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
ENT.MaxTankFluid 		= 1000

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "ChamberOn" )

	self:NetworkVar( "String", 0, "FluidID1" )
	self:NetworkVar( "String", 1, "FluidID2" )
	self:NetworkVar( "String", 2, "FluidID3" )

	self:NetworkVar( "Int", 0, "FluidAmount1" )
	self:NetworkVar( "Int", 1, "FluidAmount2" )
	self:NetworkVar( "Int", 2, "FluidAmount3" )

	self:NetworkVar( "String", 3, "OutputFluidID" )
	self:NetworkVar( "Int", 3, "OutputFluidAmount" )
end

function ENT:GetTankAmount( intTankID )
	return self["GetFluidAmount".. intTankID]( self )
end

function ENT:GetFreeTankID()
	for i = 1, 3 do
		if self["GetFluidAmount".. i]( self ) <= 0 then
			return i
		end
	end
end

function ENT:HasEmptyTank()
	return self:GetFluidAmount1() <= 0 or self:GetFluidAmount2() <= 0 or self:GetFluidAmount3() <= 0
end

function ENT:HasTankFluid()
	for i = 1, 3 do
		if self:GetTankAmount( i ) > 0 then
			return true
		end
	end
end

function ENT:HasFluidID( strFluid, intAmount )
	for i = 1, 3 do
		if self:GetTankFluidType( i ) == strFluid then
			if intAmount then
				return self:GetTankAmount( i ) >= intAmount
			else
				return true
			end
		end
	end
end

function ENT:GetFluidTankID( strFluidID )
	for i = 1, 3 do
		if self:GetTankFluidType( i ) == strFluidID then
			return i
		end
	end
end

function ENT:GetTankFluidType( intTankID )
	return self["GetFluidID".. intTankID]( self )
end