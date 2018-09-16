--[[
	Name: hardware.lua
	For: TalosLife
	By: TalosLife
]]--

local Item = {}
Item.Name = "Wood Plank"
Item.Desc = "A piece of wood."
Item.Model = "models/props_debris/wood_board04a.mdl"
Item.Weight = 5
Item.Volume = 3
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Paint Bucket"
Item.Desc = "A bucket of paint."
Item.Model = "models/props_junk/metal_paintcan001a.mdl"
Item.Weight = 7
Item.Volume = 4
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Metal Bracket"
Item.Desc = "A metal mounting bracket."
Item.Model = "models/gibs/metal_gib3.mdl"
Item.Weight = 5
Item.Volume = 3
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Metal Bar"
Item.Desc = "A metal bar."
Item.Model = "models/gibs/metal_gib2.mdl"
Item.Weight = 5
Item.Volume = 3
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Metal Plate"
Item.Desc = "A metal plate."
Item.Model = "models/gibs/metal_gib4.mdl"
Item.Weight = 5
Item.Volume = 3
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Metal Pipe"
Item.Desc = "A metal pipe."
Item.Model = "models/props_canal/mattpipe.mdl"
Item.Weight = 5
Item.Volume = 3
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Metal Hook"
Item.Desc = "A metal hook."
Item.Model = "models/props_junk/meathook001a.mdl"
Item.Weight = 8
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Metal Bucket"
Item.Desc = "A metal bucket."
Item.Model = "models/props_junk/MetalBucket01a.mdl"
Item.Weight = 5
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Plastic Bucket"
Item.Desc = "A plastic bucket."
Item.Model = "models/props_junk/plasticbucket001a.mdl"
Item.Weight = 4
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Wrench"
Item.Desc = "A wrench."
Item.Model = "models/props_c17/tools_wrench01a.mdl"
Item.Weight = 4
Item.Volume = 2
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Pliers"
Item.Desc = "A pair of pliers."
Item.Model = "models/props_c17/tools_pliers01a.mdl"
Item.Weight = 3
Item.Volume = 2
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Car Battery"
Item.Desc = "A car battery."
Item.Model = "models/Items/car_battery01.mdl"
Item.Weight = 7
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Circular Saw"
Item.Desc = "A circular saw."
Item.Model = "models/props/CS_militia/circularsaw01.mdl"
Item.Weight = 7
Item.Volume = 4
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Cinder Block"
Item.Desc = "A cinder block."
Item.Model = "models/props_junk/cinderblock01a.mdl"
Item.Weight = 15
Item.Volume = 6
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Bleach"
Item.Desc = "A bottle of bleach."
Item.Model = "models/props_junk/garbage_plasticbottle001a.mdl"
Item.Weight = 6
Item.Volume = 4
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Radiator"
Item.Desc = "A radiator."
Item.Model = "models/props_wasteland/prison_heater001a.mdl"
Item.Weight = 20
Item.Volume = 14
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Crowbar"
Item.Desc = "A crowbar."
Item.Model = "models/weapons/w_crowbar.mdl"
Item.Weight = 8
Item.Volume = 6
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Engine Block"
Item.Desc = "An engine block for an old car."
Item.Model = "models/props_c17/TrapPropeller_Engine.mdl"
Item.Weight = 100
Item.Volume = 40
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Large Cardboard Box"
Item.Desc = "A large cardboard box."
Item.Model = "models/props_junk/cardboard_box001a.mdl"
Item.Weight = 4
Item.Volume = 15
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Plastic Crate"
Item.Desc = "A plastic milk crate."
Item.Model = "models/props_junk/PlasticCrate01a.mdl"
Item.Weight = 3
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Chunk of Plastic"
Item.Desc = "A simple chunk of recycled plastic."
Item.Model = "models/Gibs/helicopter_brokenpiece_02.mdl"
Item.Weight = 3
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Cloth"
Item.Desc = "A piece of cloth."
Item.Model = "models/props/cs_office/paper_towels.mdl"
Item.Weight = 2
Item.Volume = 3
Item.CanDrop = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Bucket of Fertilizer"
Item.Desc = "A bucket of plant fertilizer."
Item.Model = "models/props_junk/plasticbucket001a.mdl"
Item.Weight = 14
Item.Volume = 25
Item.CanDrop = true
Item.LimitID = "bucket of fertilizer"
Item.DropClass = "ent_fluid_fertilizer"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 4 )


local Item = {}
Item.Name = "Potting Soil"
Item.Desc = "A bag of potting soil."
Item.Model = "models/props_junk/garbage_bag001a.mdl"
Item.Weight = 14
Item.Volume = 12
Item.CanDrop = true
Item.LimitID = "potting soil"
Item.DropClass = "ent_fluid_dirt"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 4 )


local Item = {}
Item.Name = "Terracotta Pot"
Item.Desc = "A terracotta pot."
Item.Model = "models/props_junk/terracotta01.mdl"
Item.Weight = 4
Item.Volume = 14
Item.HealthOverride = 1500
Item.CanDrop = true
Item.LimitID = "terracotta pot"
Item.DropClass = "ent_plant_pot"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 2 } )


local Item = {}
Item.Name = "Rubber Tire"
Item.Desc = "An old rubber tire."
Item.Model = "models/props_vehicles/carparts_tire01a.mdl"
Item.Weight = 15
Item.Volume = 18
Item.CanDrop = true
GM.Inv:RegisterItem( Item )