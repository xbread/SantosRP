--[[
	Name: ferrari.lua
	For: TalosLife
	By: Bradley
]]--

local Car = {}
Car.VIP = true
Car.Make = "Ferrari"
Car.Name = "Ferrari 458 Spider"
Car.UID = "ferrari_458"
Car.Desc = "A drivable Ferrari 458 Spider by TheDanishMaster"
Car.Model = "models/tdmcars/fer_458spid.mdl"
Car.Script = "scripts/vehicles/TDMCars/fer458spid.txt"
Car.Price = 240000
Car.FuellTank = 67
Car.FuelConsumption = 12.5
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "Ferrari"
Car.Name = "Ferrari LaFerrari"
Car.UID = "ferrari_LaFerrari"
Car.Desc = "La Ferrari"
Car.Model = "models/tdmcars/fer_lafer.mdl"
Car.Script = "scripts/vehicles/TDMCars/laferrari.txt"
Car.Price = 1750000
Car.FuellTank = 162
Car.FuelConsumption = 8.125
GM.Cars:Register( Car )

local Car = {}
Car.Make = "Ferrari"
Car.Name = "Ferrari F12 Berlinetta"
Car.UID = "ferrari_f12"
Car.Desc = "A drivable Ferrari F12 Berlinetta by TheDanishMaster"
Car.Model = "models/tdmcars/fer_f12.mdl"
Car.Script = "scripts/vehicles/TDMCars/fer_f12.txt"
Car.Price = 232000
Car.FuellTank = 112
Car.FuelConsumption = 21
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "Ferrari"
Car.Name = "Ferrari F430"
Car.UID = "ferrari_f430"
Car.Desc = "A drivable Ferrari F430 by TheDanishMaster"
Car.Model = "models/tdmcars/fer_f430.mdl"
Car.Script = "scripts/vehicles/TDMCars/fer_f430.txt"
Car.Price = 120000
Car.FuellTank = 112
Car.FuelConsumption = 21
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "Ferrari"
Car.Name = "Ramp car"
Car.UID = "smc_flipcar"
Car.Desc = "Flip cars"
Car.Model = "models/steelemancars/flipcar/flipcar.mdl"
Car.Script = "scripts/vehicles/steelemancars/flipcar.txt"
Car.Price = 17500000
Car.FuellTank = 162
Car.FuelConsumption = 8.125
GM.Cars:Register( Car )