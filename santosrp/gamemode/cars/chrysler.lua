--[[
	Name: Chrysler
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.VIP = true
Car.Make = "Chrysler"
Car.Name = "Chrysler 300C SRT-8 2012"
Car.UID = "chrysler_300c_srt8"
Car.Desc = "A drivable Chrysler 300C SRT-8 2012 by TheDanishMaster"
Car.Model = "models/tdmcars/chr_300c_12.mdl"
Car.Script = "scripts/vehicles/TDMCars/chr_300c_12.txt"
Car.Price = 69000
Car.FuellTank = 80
Car.FuelConsumption = 14.375
GM.Cars:Register( Car )

local Car = {}
Car.Make = "Chrysler"
Car.Name = "Chrysler 300c"
Car.UID = "chrysler_300c"
Car.Desc = "A drivable Chrysler 300c by TheDanishMaster"
Car.Model = "models/tdmcars/chr_300c.mdl"
Car.Script = "scripts/vehicles/TDMCars/300c.txt"
Car.Price = 39000
Car.FuellTank = 80
Car.FuelConsumption = 8
GM.Cars:Register( Car )

local Car = {}
Car.Make = "Chrysler"
Car.Name = "Chrysler PT Cruiser"
Car.UID = "chrysler_crusierpt"
Car.Desc = "A drivable Chrysler PT by TheDanishMaster"
Car.Model = "models/tdmcars/chr_ptcruiser.mdl"
Car.Script = "scripts/vehicles/TDMCars/ptcruiser.txt"
Car.Price = 8000
Car.FuellTank = 80
Car.FuelConsumption = 8
GM.Cars:Register( Car )