--[[
	Name: misc_jobcars.lua
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.Make = "Ford"
Car.Name = "Crown Victoria Taxi"
Car.UID = "taxi_cab"
Car.Job = "JOB_TAXI"
Car.Desc = "A taxi cab."
Car.Model = "models/tdmcars/crownvic_taxi.mdl"
Car.Script = "scripts/vehicles/TDMCars/crownvic_taxi.txt"
Car.FuellTank = 100
Car.FuelConsumption = 20
GM.Cars:RegisterJobCar( Car )

local Car = {}
Car.Make = "Dodge"
Car.Name = "Flatbed Tow Truck"
Car.UID = "tow_flatbed"
Car.Job = "JOB_TOW"
Car.Desc = "A tow truck."
Car.Model = "models/sentry/flatbed.mdl"
Car.Script = "scripts/vehicles/TDMCars/peterbilt_579.txt"
Car.FuellTank = 65
Car.FuelConsumption = 28
GM.Cars:RegisterJobCar( Car )

local Car = {}
Car.Make = "Mercedes"
Car.Name = "Sprinter SWB"
Car.UID = "mail_truck"
Car.Job = "JOB_MAIL"
Car.Desc = "A mail truck."
Car.Model = "models/tdmcars/courier_truck.mdl"
Car.Script = "scripts/vehicles/TDMCars/courier_truck.txt"
Car.FuellTank = 200
Car.FuelConsumption = 20
GM.Cars:RegisterJobCar( Car )

local Car = {}
Car.Make = "Mercedes"
Car.Name = "Sprinter SWB"
Car.UID = "sales_truck"
Car.Job = "JOB_SALES_TRUCK"
Car.Desc = "A mail truck."
Car.Model = "models/LoneWolfie/merc_sprinter_swb.mdl"
Car.Script = "scripts/vehicles/LWCars/merc_sprinter_swb.txt"
Car.FuellTank = 200
Car.FuelConsumption = 20
GM.Cars:RegisterJobCar( Car )

local Car = {}
Car.Make = "TDM"
Car.Name = "Bus"
Car.UID = "gta_bus"
Car.Job = "JOB_BUS_DRIVER"
Car.Desc = "A city bus."
Car.Model = "models/tdmcars/gtav/bus.mdl"
Car.Script = "scripts/vehicles/TDMCars/gtav/bus.txt"
Car.FuellTank = 200
Car.FuelConsumption = 20
GM.Cars:RegisterJobCar( Car )