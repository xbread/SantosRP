
-----------------------------------------------------
--[[
	Name: job_items_fire.lua
	For: SantosRP
	By: Ultra
]]--

local Item = {}
Item.Name = "FD Issue 10ft. Ladder"
Item.Desc = "Huge ladder"
Item.Model = "models/props/de_train/ladderaluminium.mdl"
Item.Weight = 8
Item.Volume = 25
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.CollidesWithCars = true
Item.JobItem = "JOB_FIREFIGHTER"
Item.LimitID = "small ladder"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 4 )

local Item = {}
Item.Name = "FD Issue 50ft. Ladder"
Item.Desc = "Huge ladder"
Item.Model = "models/props_c17/metalladder003.mdl"
Item.Weight = 30
Item.Volume = 125
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.CollidesWithCars = false
Item.JobItem = "JOB_FIREFIGHTER"
Item.LimitID = "huge ladder"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )

local Item = {}
Item.Name = "FD Issue Traffic Cone"
Item.Desc = "A traffic cone."
Item.Model = "models/props_junk/TrafficCone001a.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.CollidesWithCars = true
Item.JobItem = "JOB_FIREFIGHTER"
Item.LimitID = "traffic cone"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 10 )

local Item = {}
Item.Name = "FD Issue Traffic Barrel"
Item.Desc = "A traffic trailer barrel."
Item.Model = "models/noble/trafficbarrel/traffic_barrel.mdl"
Item.Weight = 2
Item.Volume = 8
Item.HealthOverride = 1500
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.CollidesWithCars = true
Item.JobItem = "JOB_FIREFIGHTER" --This item can only be possessed by by players with this job
Item.LimitID = "traffic barrel"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 10 )

local Item = {}
Item.Name = "FD Issue Medical Supplies"
Item.Desc = "A vial of essential medical supplies, consumed by the first aid kit."
Item.Model = "models/healthvial.mdl"
Item.Type = "type_ammo"
Item.JobItem = "JOB_FIREFIGHTER" --This item can only be possessed by by players with this job
Item.Weight = 2
Item.Volume = 2
Item.CanDrop = false
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "FD Issue Concrete Barrier"
Item.Desc = "A concrete barrier."
Item.Model = "models/props_c17/concrete_barrier001a.mdl"
Item.JobItem = "JOB_FIREFIGHTER" --This item can only be possessed by by players with this job
Item.Weight = 34
Item.Volume = 28
Item.HealthOverride = 2500
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.CollidesWithCars = true
Item.DropClass = "prop_physics_multiplayer"
GM.Inv:RegisterItem( Item )