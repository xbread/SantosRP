--[[
	Name: holden.lua
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.Make = "Hummer"
Car.Name = "Hummer H1 Open Top"
Car.UID = "hummer_h1_top"
Car.Desc = "The Hummer H1, gmod-able by TDM"
Car.Model = "models/tdmcars/hummerh1_open.mdl"
Car.Script = "scripts/vehicles/TDMCars/h1.txt"
Car.Price = 63000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )

local Car = {}
Car.Make = "Hummer"
Car.Name = "Hummer H1"
Car.UID = "hummer_h1"
Car.Desc = "The Hummer H1, gmod-able by TDM"
Car.Model = "models/tdmcars/hummerh1.mdl"
Car.Script = "scripts/vehicles/TDMCars/h1.txt"
Car.Price = 68000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )