--[[
	Name: Alfa
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.Make = "Alfa"
Car.Name = "Alfa Romeo Giulietta"
Car.UID = "alfa_romeo"
Car.Desc = "A drivable Aston Martin DBS by TheDanishMaster"
Car.Model = "models/tdmcars/alfa_giulietta.mdl"
Car.Script = "scripts/vehicles/TDMCars/alfa_giulietta.txt"
Car.Price = 28000
Car.FuellTank = 80
Car.FuelConsumption = 14.375
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "Alfa"
Car.Name = "Alfa Romeo 33 Stradale"
Car.UID = "alfa_romeo_33"
Car.Desc = "A drivable Aston Martin DBS by TheDanishMaster"
Car.Model = "models/tdmcars/alfa_stradale.mdl"
Car.Script = "scripts/vehicles/TDMCars/alfa_stradale.txt"
Car.Price = 2000000
Car.FuellTank = 80
Car.FuelConsumption = 8
GM.Cars:Register( Car )