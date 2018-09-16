--[[
	Name: semis.lua
	For: ArgonGamingNetwork
	By: Cheese
]]--

local Car = {}
Car.VIP = true
Car.Make = "Semi Trucks"
Car.Name = "kenworth 800"
Car.UID = "kwt_800"
Car.Desc = "A drivable Kenworth 800 by TheDanishMaster"
Car.Model = "models/TDMCars/trucks/kenworth_t800.mdl"
Car.Script = "scripts/vehicles/tdmcars/kwt800.txt"
Car.Price = 500000
Car.FuellTank = 100
Car.FuelConsumption = 15
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "Semi Trucks"
Car.Name = "peterbilt 579 Medium Cab"
Car.UID = "peterbilt_579med"
Car.Desc = "A drivable Peterbilt 579 by TheDanishMaster"
Car.Model = "models/TDMCars/trucks/peterbilt_579_med.mdl"
Car.Script = "scripts/vehicles/tdmcars/peterbilt_579.txt"
Car.Price = 500000
Car.FuellTank = 100
Car.FuelConsumption = 15
GM.Cars:Register( Car )
