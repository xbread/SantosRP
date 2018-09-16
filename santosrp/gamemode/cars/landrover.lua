--[[
	Name: landrover.lua
	For: TalosLife
	By: Bradley
]]--

local Car = {}
Car.Make = "Land Rover"
Car.Name = "Range Rover 08"
Car.UID = "land_rover_range_rover"
Car.Desc = "The Land Rover Range Rover 08, gmod-able by TDM"
Car.Model = "models/tdmcars/landrover.mdl"
Car.Script = "scripts/vehicles/TDMCars/landrover.txt"
Car.Price = 70000
Car.FuellTank = 150
Car.FuelConsumption = 12.125
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "Land Rover"
Car.Name = "Range Rover Supercharged 2012"
Car.UID = "land_rover_range_rover_supercharged"
Car.Desc = "The Land Rover Range Rover Supercharged 2012, gmod-able by TDM"
Car.Model = "models/tdmcars/landrover12.mdl"
Car.Script = "scripts/vehicles/TDMCars/landrover12.txt"
Car.Price = 100000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )