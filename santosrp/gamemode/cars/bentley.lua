--[[
	Name: bentley.lua
	For: Argon Gamilng Network
	By: Cheese
]]--

local Car = {}
Car.VIP = true
Car.Make = "Bentley"
Car.Name = "Platnum Motorsports Continental GT"
Car.UID = "bently_pmcontinental"
Car.Desc = "Bentley Continental GT"
Car.Model = "models/lonewolfie/bently_pmcontinental.mdl"
Car.Script = "scripts/vehicles/lwcars/bently_pmcontinental.txt"
Car.Price = 1500000
Car.FuellTank = 800
Car.FuelConsumption = 8
GM.Cars:Register( Car )

local Car = {}
Car.Make = "Bentley"
Car.Name = "4 1/2 Liter Blower"
Car.UID = "bently_bowler"
Car.Desc = "Bentley Blower"
Car.Model = "models/lonewolfie/bentley_blower.mdl"
Car.Script = "scripts/vehicles/lwcars/bentley_blower.txt"
Car.Price = 750000
Car.FuellTank = 800
Car.FuelConsumption = 4
GM.Cars:Register( Car )
