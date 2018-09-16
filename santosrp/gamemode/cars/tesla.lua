--[[
	Name: tesla.lua
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.Make = "Tesla"
Car.Name = "Tesla Model S"
Car.UID = "tesla_model"
Car.Desc = "A drivable Tesla Model S by TheDanishMaster"
Car.Model = "models/tdmcars/tesla_models.mdl"
Car.Script = "scripts/vehicles/TDMCars/teslamodels.txt"
Car.Price = 71000
Car.FuellTank = 80000
Car.FuelConsumption = 14.375
GM.Cars:Register( Car )