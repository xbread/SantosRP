--[[
	Name: building_supplies.lua
	For: TalosLife
	By: TalosLife
]]--

local Item = {}
Item.Name = "Concrete Barrier"
Item.Desc = "A concrete barrier."
Item.Model = "models/props_c17/concrete_barrier001a.mdl"
Item.Weight = 34
Item.Volume = 28
Item.HealthOverride = 2500
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Wire Fence 01"
Item.Desc = "A section of wire fence."
Item.Model = "models/props_c17/fence01a.mdl"
Item.Weight = 30
Item.Volume = 50
Item.HealthOverride = 500
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Wire Fence 02"
Item.Desc = "A short section of wire fence."
Item.Model = "models/props_c17/fence01b.mdl"
Item.Weight = 20
Item.Volume = 35
Item.HealthOverride = 250
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Wire Fence 03"
Item.Desc = "A long section of wire fence."
Item.Model = "models/props_c17/fence03a.mdl"
Item.Weight = 50
Item.Volume = 95
Item.HealthOverride = 750
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Large Blast Door"
Item.Desc = "A large blast door."
Item.Model = "models/props_lab/blastdoor001c.mdl"
Item.Weight = 180
Item.Volume = 95
Item.HealthOverride = 2500
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Blast Door"
Item.Desc = "A blast door."
Item.Model = "models/props_lab/blastdoor001b.mdl"
Item.Weight = 90
Item.Volume = 45
Item.HealthOverride = 1000
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Large Wood Plank"
Item.Desc = "A long wooden plank."
Item.Model = "models/props_wasteland/dockplank01b.mdl"
Item.Weight = 40
Item.Volume = 40
Item.HealthOverride = 250
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Large Wood Fence"
Item.Desc = "A large wooden Fence."
Item.Model = "models/props_wasteland/wood_fence01a.mdl"
Item.Weight = 40
Item.Volume = 45
Item.HealthOverride = 250
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Wood Fence"
Item.Desc = "A wooden Fence."
Item.Model = "models/props_wasteland/wood_fence02a.mdl"
Item.Weight = 20
Item.Volume = 25
Item.CanDrop = true
Item.CollidesWithCars = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )