--[[
	Name: ems_cars.lua
	For: SantosRP
	By: Ultra
]]--

local Car = {}
Car.Make = "Ford"
Car.Name = "Ford Crown Victoria"
Car.UID = "ems_firstrespond"
Car.Job = "JOB_EMS"
Car.Desc = "A first responder vehicle."
Car.Model = "models/tdmcars/emergency/for_crownvic.mdl"
Car.Script = "scripts/vehicles/TDMCars/for_crownvic.txt"
Car.FuellTank = 65
Car.FuelConsumption = 20
GM.Cars:RegisterJobCar( Car )

local Car = {}
Car.Make = "Ford"
Car.Name = "F350 Ambulance"
Car.UID = "ems_ambulance"
Car.Job = "JOB_EMS"
Car.Desc = "An ambulance."
Car.Model = "models/lonewolfie/ford_f350_ambu.mdl"
Car.Script = "scripts/vehicles/lwcars/ford_f350_ambu.txt"
Car.FuellTank = 65
Car.FuelConsumption = 20
GM.Cars:RegisterJobCar( Car )

local Car = {}
Car.Make = "Ford"
Car.Name = "2013 Explorer"
Car.UID = "ford_explorer_2013_ems"
Car.Job = "JOB_EMS"
Car.Desc = ""
Car.Model = "models/sentry/explorer.mdl"
Car.Script = "scripts/vehicles/TDMCars/jag_ftype.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )

--[[
scripts/vehicles/sentry/explorer.txt
--]]
