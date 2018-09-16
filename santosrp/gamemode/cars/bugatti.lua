--[[
	Name: bugatti.lua
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.Make = "Bugatti"
Car.Name = "Veyron"
Car.UID = "bugatti_veyron"
Car.Desc = "The Bugatti Veyron, gmod-able by TDM"
Car.Model = "models/tdmcars/bug_veyron.mdl"
Car.Script = "scripts/vehicles/TDMCars/veyron.txt"
Car.Price = 2000000
Car.FuellTank = 150
Car.FuelConsumption = 12.125
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "Bugatti"
Car.Name = "Veyron SS"
Car.UID = "bugatti_veyron_ss"
Car.Desc = "The Bugatti Veyron SS, gmod-able by TDM"
Car.Model = "models/tdmcars/bug_veyronss.mdl"
Car.Script = "scripts/vehicles/TDMCars/veyronss.txt"
Car.Price = 2800000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )

local Car = {}
Car.VIP = false
Car.Make = "Bugatti"
Car.Name = "EB110"
Car.UID = "bugatti_eb110"
Car.Desc = "The Bugatti Veyron SS, gmod-able by TDM"
Car.Model = "models/tdmcars/bug_eb110.mdl"
Car.Script = "scripts/vehicles/TDMCars/eb110.txt"
Car.Price = 456000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "Bugatti"
Car.Name = "Chiron"
Car.UID = "bugatti_chiron"
Car.Desc = "The Bugatti Chiron"
Car.Model = "models/skyautomotive/bugatti_chiron.mdl"
Car.Script = "scripts/vehicles/skyautos/bugatti_chiron.txt"
Car.Price = 3000000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )
