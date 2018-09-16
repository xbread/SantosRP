--[[
	Name: mclaren.lua
	For: TalosLife
	By: Rui Sti
]]--

local Car = {}
Car.Make = "McLaren"
Car.Name = "McLaren F1"
Car.UID = "mclaren_f1"
Car.Desc = "The F1, gmod-able by TDM"
Car.Model = "models/tdmcars/mclaren_f1.mdl"
Car.Script = "scripts/vehicles/TDMCars/mclarenf1.txt"
Car.Price = 2862000
Car.FuellTank = 150
Car.FuelConsumption = 12.125
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "McLaren"
Car.Name = "McLaren P1"
Car.UID = "mclaren_p1"
Car.Desc = "The Mclarenp1, gmod-able by TDM"
Car.Model = "models/tdmcars/mclaren_p1.mdl"
Car.Script = "scripts/vehicles/TDMCars/mclarenp1.txt"
Car.Price = 1750000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )