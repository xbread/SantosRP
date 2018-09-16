--[[
	Name: lexus
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.Make = "Lexus"
Car.Name = "Lexus IS 300"
Car.UID = "lexus_300"
Car.Desc = "A drivable Lexus 300 by TheDanishMaster"
Car.Model = "models/tdmcars/lex_is300.mdl"
Car.Script = "scripts/vehicles/TDMCars/lex_is300.txt"
Car.Price = 41000
Car.FuellTank = 80
Car.FuelConsumption = 14.375
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "Lexus"
Car.Name = "Lexus IS F"
Car.UID = "lexus_isf"
Car.Desc = "A drivable Lexus ISF by TheDanishMaster"
Car.Model = "models/tdmcars/lex_isf.mdl"
Car.Script = "scripts/vehicles/TDMCars/lex_isf.txt"
Car.Price = 67000
Car.FuellTank = 80
Car.FuelConsumption = 8
GM.Cars:Register( Car )