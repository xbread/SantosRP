--[[
	Name: masarater.lua
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.VIP = true
Car.Make = "Maserati"
Car.Name = "Maserati Ghibli S"
Car.UID = "maserati_ghibli"
Car.Desc = "The Maserati Ghibli S, gmod-able by TDM"
Car.Model = "models/tdmcars/mas_ghibli.mdl"
Car.Script = "scripts/vehicles/TDMCars/mas_ghibli.txt"
Car.Price = 130000
Car.FuellTank = 150
Car.FuelConsumption = 12.125
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "Maserati"
Car.Name = "Maserati Quattroporte Sport GT S"
Car.UID = "maserati_quattro"
Car.Desc = "The Maserati Quattroporte Sport GT S, gmod-able by TDM"
Car.Model = "models/tdmcars/mas_quattroporte.mdl"
Car.Script = "scripts/vehicles/TDMCars/mas_quattroporte.txt"
Car.Price = 152000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )