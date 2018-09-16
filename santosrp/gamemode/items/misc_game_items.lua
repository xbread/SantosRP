--[[
	Name: misc_game_items.lua
	For: TalosLife
	By: TalosLife
]]--

local Item = {}
Item.Name = "Casino Chips"
Item.Desc = "Chips for use in a casino."
Item.Model = "models/props_phx/games/chess/black_dama.mdl"
Item.Weight = 0
Item.Volume = 0
Item.CanDrop = true
Item.DropCombined = true --Make only 1 item when dropping many, allows for items to drop stacked
Item.UI_DropMany = true --Enable dropping many items in the item card ui
Item.LimitID = "casino chips"
Item.DropClass = "ent_money_chips"
Item.SetupEntity = function( _, eEnt, intAmount )
	eEnt:SetAmount( intAmount )
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 10 )

local Item = {}
Item.Name = "Lawn Mower"
Item.Desc = "Mows grass, pretty simple."
Item.Model = "models/props/de_overpass/lawn_mower.mdl"
Item.Weight = 35
Item.Volume = 50
Item.HealthOverride = 3000
Item.JobItem = "JOB_ROADWORKER"
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.LimitID = "lawn mower"
Item.DropClass = "road_mower"
Item.SetupEntity = function( _, entItem )
-- stuff
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Medical Supplies"
Item.Desc = "A vial of essential medical supplies, consumed by the first aid kit."
Item.Model = "models/healthvial.mdl"
Item.Type = "type_ammo"
Item.Weight = 2
Item.Volume = 2
Item.CanDrop = true
Item.LimitID = "medical supplies"
 
Item.CraftingEntClass = "ent_crafting_table"
Item.CraftSkill = "Crafting"
Item.CraftSkillLevel = 5
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Plate"] = 2,
	["Cloth"] = 4,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 12 )


local Item = {}
Item.Name = "Government Issue Medical Supplies"
Item.Desc = "A vial of essential medical supplies, consumed by the first aid kit."
Item.Model = "models/healthvial.mdl"
Item.Type = "type_ammo"
Item.JobItem = "JOB_EMS" --This item can only be possessed by by players with this job
Item.Weight = 2
Item.Volume = 2
Item.CanDrop = false
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Fuel Can"
Item.Desc = "A can of fuel."
Item.Model = "models/props_junk/gascan001a.mdl"
Item.Weight = 10
Item.Volume = 8
Item.CanDrop = true
Item.LimitID = "fuel can"
Item.DropClass = "ent_fuelcan"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )


local Item = {}
Item.Name = "Storage Chest"
Item.Desc = "A large chest for storing items temporally."
Item.Model = "models/Items/ammocrate_smg1.mdl"
Item.Weight = 45
Item.Volume = 70
Item.HealthOverride = 1000
Item.CanDrop = true
Item.LimitID = "storage chest"
Item.DropClass = "ent_storage_chest"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )


local Item = {}
Item.Name = "Road Flare"
Item.Desc = "A road flare, drop and press E on to ignite."
Item.Model = "models/props_junk/flare.mdl"
Item.Weight = 2
Item.Volume = 1
Item.CanDrop = true
Item.LimitID = "road flare"
Item.DropClass = "ent_roadflare"
Item.DrugLab_BlenderVars = {
	BlendProgress = 10,
	BlendAmountPerTick = 0.15,
	GiveItem = "Red Phosphorous",
	GiveAmount = 4,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 3 )


local Item = {}
Item.Name = "Engine Overhaul"
Item.Desc = "A complete engine overhaul kit. Used on vehicles that have 0 health."
Item.Model = "models/props_c17/TrapPropeller_Engine.mdl"
Item.Weight = 100
Item.Volume = 80
Item.CanDrop = true
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_high"

Item.CraftingEntClass = "ent_crafting_table"
Item.CraftSkill = "Crafting"
Item.CraftSkillLevel = 15
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Engine Block"] = 1,
	["Car Battery"] = 1,
	["Metal Plate"] = 2,
	["Metal Pipe"] = 1,
	["Crowbar"] = 1,
	["Wrench"] = 2,
	["Pliers"] = 1,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )


local Item = {}
Item.Name = "Vehicle Repair Kit"
Item.Desc = "Tools and components for repairing general vehicle damage."
Item.Model = "models/props/cs_office/Cardboard_box01.mdl"
Item.Weight = 80
Item.Volume = 25
Item.CanDrop = true
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_medium"

Item.CraftingEntClass = "ent_crafting_table"
Item.CraftSkill = "Crafting"
Item.CraftSkillLevel = 1
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Car Battery"] = 8,
	["Metal Plate"] = 10,
	["Metal Pipe"] = 5,
	["Crowbar"] = 5,
	["Wrench"] = 5,
	["Pliers"] = 1,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )


local Item = {}
Item.Name = "Roadside Quick-Fix Kit"
Item.Desc = "A small set of parts and a few tools for fixing light damage to vehicles."
Item.Model = "models/props_c17/BriefCase001a.mdl"
Item.Weight = 30
Item.Volume = 10
Item.CanDrop = true
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_light"

Item.CraftingEntClass = "ent_crafting_table"
Item.CraftSkill = "Crafting"
Item.CraftSkillLevel = 1
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Plate"] = 2,
	["Metal Pipe"] = 4,
	["Wrench"] = 3,
	["Pliers"] = 3,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )


local Item = {}
Item.Name = "Spare Tire Kit"
Item.Desc = "A replacement set of tires for any vehicle."
Item.Model = "models/props_vehicles/carparts_wheel01a.mdl"
Item.Weight = 60
Item.Volume = 80
Item.CanDrop = true
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_wheels"

Item.CraftingEntClass = "ent_crafting_table"
Item.CraftSkill = "Crafting"
Item.CraftSkillLevel = 1
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Plate"] = 2,
	["Metal Bracket"] = 4,
	["Wrench"] = 1,
	["Rubber Tire"] = 4,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )


local Item = {}
Item.Name = "Police Issue Roadside Quick-Fix Kit"
Item.Desc = "A small set of parts and a few tools for fixing light damage to vehicles."
Item.Model = "models/props_c17/BriefCase001a.mdl"
Item.Weight = 30
Item.Volume = 10
Item.CanDrop = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_light"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )


local Item = {}
Item.Name = "Police Issue Spare Tire Kit"
Item.Desc = "A replacement set of tires for any vehicle."
Item.Model = "models/props_vehicles/carparts_wheel01a.mdl"
Item.Weight = 60
Item.Volume = 80
Item.CanDrop = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_wheels"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )

------------------------------------------------------



local Item = {}
Item.Name = "Police Issue Spare Tire Kit"
Item.Desc = "A replacement set of tires for any vehicle."
Item.Model = "models/props_vehicles/carparts_wheel01a.mdl"
Item.Weight = 60
Item.Volume = 80
Item.CanDrop = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_wheels"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )

local Item = {}
Item.Name = "Police Issue Traffic Cone"
Item.Desc = "A traffic cone."
Item.Model = "models/props_junk/TrafficCone001a.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.CollidesWithCars = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "traffic cone"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 10 )

local Item = {}
Item.Name = "Police Issue Traffic Board"
Item.Desc = "A traffic trailer board."
Item.Model = "models/noble/trailermessageboard/trailermessageboard.mdl"
Item.Weight = 2
Item.Volume = 8
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.CollidesWithCars = true
Item.HealthOverride = 3000
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "traffic board"
Item.SetupEntity = function( _, eEnt )
	local phys = eEnt:GetPhysicsObject()
	if IsValid( phys ) then
		phys:SetMass( 100 )
	end

	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )

local Item = {}
Item.Name = "Police Issue Traffic Barrel"
Item.Desc = "A traffic trailer barrel."
Item.Model = "models/noble/trafficbarrel/traffic_barrel.mdl"
Item.Weight = 2
Item.Volume = 8
Item.HealthOverride = 1500
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.CollidesWithCars = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "traffic barrel"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 10 )

local Item = {}
Item.Name = "Police Issue Checkpoint"
Item.Desc = "A traffic checkpoint"
Item.Model = "models/noble/checkpoint.mdl"
Item.Weight = 2
Item.Volume = 8
Item.HealthOverride = 3000
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.CollidesWithCars = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "checkpoint"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )

local Item = {}
Item.Name = "Police Issue Roadside Quick-Fix Kit"
Item.Desc = "A small set of parts and a few tools for fixing light damage to vehicles."
Item.Model = "models/props_c17/BriefCase001a.mdl"
Item.Weight = 30
Item.Volume = 10
Item.CanDrop = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_light"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )

local Item = {}
Item.Name = "Police Issue Spare Tire Kit"
Item.Desc = "A replacement set of tires for any vehicle."
Item.Model = "models/props_vehicles/carparts_wheel01a.mdl"
Item.Weight = 60
Item.Volume = 80
Item.CanDrop = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_wheels"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )

local Item = {}
Item.Name = "Police Issue Engine Overhaul"
Item.Desc = "A complete engine overhaul kit. Used on vehicles that have 0 health."
Item.Model = "models/props_c17/TrapPropeller_Engine.mdl"
Item.Weight = 50
Item.Volume = 30
Item.CanDrop = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_high"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )

local Item = {}
Item.Name = "Goverment Issue Engine Overhaul"
Item.Desc = "A complete engine overhaul kit. Used on vehicles that have 0 health."
Item.Model = "models/props_c17/TrapPropeller_Engine.mdl"
Item.Weight = 50
Item.Volume = 30
Item.CanDrop = true
Item.JobItem = "JOB_SSERVICE" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_high"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )

local Item = {}
Item.Name = "EMS Issue Engine Overhaul"
Item.Desc = "A complete engine overhaul kit. Used on vehicles that have 0 health."
Item.Model = "models/props_c17/TrapPropeller_Engine.mdl"
Item.Weight = 50
Item.Volume = 30
Item.CanDrop = true
Item.JobItem = "JOB_EMS" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_high"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )

local Item = {}
Item.Name = "EMS Issue Vehicle Repair Kit"
Item.Desc = "Tools and components for repairing general vehicle damage."
Item.Model = "models/props/cs_office/Cardboard_box01.mdl"
Item.Weight = 50
Item.Volume = 30
Item.CanDrop = true
Item.JobItem = "JOB_EMS" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_medium"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )

local Item = {}
Item.Name = "Goverment Issue Vehicle Repair Kit"
Item.Desc = "Tools and components for repairing general vehicle damage."
Item.Model = "models/props/cs_office/Cardboard_box01.mdl"
Item.Weight = 50
Item.Volume = 30
Item.CanDrop = true
Item.JobItem = "JOB_SSERVICE" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_medium"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )


local Item = {}
Item.Name = "Police Issue Vehicle Repair Kit"
Item.Desc = "Tools and components for repairing general vehicle damage."
Item.Model = "models/props/cs_office/Cardboard_box01.mdl"
Item.Weight = 50
Item.Volume = 30
Item.CanDrop = true
Item.JobItem = "JOB_POLICE" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_medium"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )

local Item = {}
Item.Name = "EMS Issue Spare Tire Kit"
Item.Desc = "A replacement set of tires for any vehicle."
Item.Model = "models/props_vehicles/carparts_wheel01a.mdl"
Item.Weight = 50
Item.Volume = 30
Item.CanDrop = true
Item.JobItem = "JOB_EMS" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_wheels"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )

local Item = {}
Item.Name = "Goverment Issue Spare Tire Kit"
Item.Desc = "A replacement set of tires for any vehicle."
Item.Model = "models/props_vehicles/carparts_wheel01a.mdl"
Item.Weight = 50
Item.Volume = 30
Item.CanDrop = true
Item.JobItem = "JOB_SSERVICE" --This item can only be possessed by by players with this job
Item.LimitID = "car repair kit"
Item.DropClass = "ent_carfix_wheels"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2 )


local Item = {}
Item.Name = "EMS Issue Traffic Cone"
Item.Desc = "A traffic cone."
Item.Model = "models/props_junk/TrafficCone001a.mdl"
Item.Weight = 1
Item.Volume = 1
Item.HealthOverride = 5000
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.JobItem = "JOB_EMS" --This item can only be possessed by by players with this job
Item.LimitID = "traffic cone"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 10 )
Item.CollidesWithCars = true