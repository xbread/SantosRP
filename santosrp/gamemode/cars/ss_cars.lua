--[[
	Name: cop_cars.lua
	For: TalosLife
	By: TalosLife
]]--

local Car = {} -- fixed
Car.Make = "Cadillac"
Car.Name = "2011 Cadillac CTS-V Coupe Undercover"
Car.UID = "cadcts_ss"
Car.Job = "JOB_SSERVICE"
Car.Desc = ""
Car.Model = "models/sentry/ctsv_uc.mdl"
Car.Script = "scripts/vehicles/TDMCars/vw_golfr32.txt"
Car.FuellTank = 120
Car.FuelConsumption = 20
GM.Cars:RegisterJobCar( Car )

local Car = {}
Car.Make = "Lincoln"
Car.Name = "2010 Lincoln Town Car Limo"
Car.UID = "limo_mayor"
Car.Job = "JOB_SSERVICE"
Car.Desc = ""
Car.Model = "models/sentry/static/lincolntclimo.mdl"
Car.Script = "scripts/vehicles/TDMCars/vw_golfr32.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )

local Car = {} --done
Car.Make = "Chevy"
Car.Name = "Chevy Tahoe"
Car.UID = "chevy_tahoe_uc_ss"
Car.Job = "JOB_SSERVICE"
Car.Desc = ""
Car.Model = "models/lonewolfie/chev_tahoe_police.mdl"
Car.Script = "scripts/vehicles/lwcars/chev_tahoe.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )

local Car = {} --done
Car.Make = "Chevy"
Car.Name = "Chevrolet Tahoe Secret Service"
Car.UID = "chevy_tahoe_uc_ss_cevrolet"
Car.Job = "JOB_SSERVICE"
Car.Desc = ""
Car.Model = "models/LoneWolfie/chev_tahoe_police.mdl"
Car.Script = "scripts/vehicles/LWCars/chev_tahoe.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )

local Car = {} -- done
Car.Make = "Chevrolet"
Car.Name = "Chevrolet Suburban Secret Service"
Car.UID = "chevrolet_suburban_ss_undercover"
Car.Job = "JOB_SSERVICE"
Car.Desc = ""
Car.Model = "models/LoneWolfie/chev_suburban_pol_und.mdl"
Car.Script = "scripts/vehicles/LWCars/chev_suburban.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )