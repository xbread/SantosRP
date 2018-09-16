--[[
	Name: scion.lua
	For: TalosLife
	By: TalosLife
]]--

local Car = {}
Car.Make = "Scion"
Car.Name = "Scion xD"
Car.UID = "scion_xd"
Car.Desc = "The Scion xD, gmod-able by TDM"
Car.Model = "models/tdmcars/scion_xd.mdl"
Car.Script = "scripts/vehicles/TDMCars/scionxd.txt"
Car.Price = 15000
Car.FuellTank = 150
Car.FuelConsumption = 12.125
GM.Cars:Register( Car )

local Car = {}
Car.VIP = true
Car.Make = "Scion"
Car.Name = "Scion FR-S"
Car.UID = "scion_fr_s"
Car.Desc = "The Scion FR-S, gmod-able by TDM"
Car.Model = "models/tdmcars/scion_frs.mdl"
Car.Script = "scripts/vehicles/TDMCars/scionfrs.txt"
Car.Price = 27000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )

local Car = {}
Car.Make = "Scion"
Car.Name = "Scion tC"
Car.UID = "scion_tc"
Car.Desc = "The Scion tC, gmod-able by TDM"
Car.Model = "models/tdmcars/scion_tc.mdl"
Car.Script = "scripts/vehicles/TDMCars/sciontc.txt"
Car.Price = 21000
Car.FuellTank = 88
Car.FuelConsumption = 8.75
GM.Cars:Register( Car )