--[[
	Name: jaguar.lua
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.VIP = true
Car.Make = "Jaguar"
Car.Name = "Jaguar F-Type"
Car.UID = "jaguar_f_type"
Car.Desc = "The Jaguar F-Type V12, gmod-able by TDM"
Car.Model = "models/tdmcars/jag_ftype.mdl"
Car.Script = "scripts/vehicles/TDMCars/jag_ftype.txt"
Car.Price = 142000
Car.FuellTank = 150
Car.FuelConsumption = 12.125
GM.Cars:Register( Car )