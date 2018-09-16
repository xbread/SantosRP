--[[
	Name: fire_cars.lua
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.Make = "MTL"
Car.Name = "GTA V Firetruck"
Car.UID = "fire_truck"
Car.Job = "JOB_FIREFIGHTER"
Car.Desc = "A fire truck."
Car.Model = "models/sentry/aerial.mdl"
Car.Script = "scripts/vehicles/sentry/aerial.txt"
Car.FuellTank = 120
Car.FuelConsumption = 20
GM.Cars:RegisterJobCar( Car )

local Car = {}
Car.Make = "Ford"
Car.Name = "Ford F150 Police"
Car.UID = "fire_first"
Car.Job = "JOB_FIREFIGHTER"
Car.Desc = "A fire truck."
Car.Model = "models/talonvehicles/tal_f150_pol.mdl"
Car.Script = "scripts/vehicles/tal_f150pol.txt"
Car.FuellTank = 120
Car.FuelConsumption = 20
GM.Cars:RegisterJobCar( Car )
