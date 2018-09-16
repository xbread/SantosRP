--[[
	Name: holden.lua
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.VIP = true
Car.Make = "Pontiac"
Car.Name = "Pontiac Firebird Trans Am"
Car.UID = "pontiac_firebird"
Car.Desc = "The Pontiac Firebird Trans Am, gmod-able by TDM"
Car.Model = "models/tdmcars/pon_firetransam.mdl"
Car.Script = "scripts/vehicles/TDMCars/pon_firetransam.txt"
Car.Price = 29000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )