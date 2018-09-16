
-----------------------------------------------------
--[[
	Name: job_weapons_fire.lua
	For: SantosRP
	By: Ultra
]]--

local Item = {}
Item.Name = "Fire Extinguisher"
Item.Desc = "A fire extinguisher."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_fire_extinguisher.mdl"
Item.JobItem = "JOB_FIREFIGHTER" --This item can only be possessed by by players with this job
Item.Weight = 12
Item.Volume = 10
Item.CanDrop = false
Item.CanEquip = true
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "weapon_extinguisher_custom"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Fire Axe"
Item.Desc = "A fire axe, used to break items or force open doors."
Item.Type = "type_weapon"
Item.Model = "models/props_forest/axe.mdl"
Item.JobItem = "JOB_FIREFIGHTER" --This item can only be possessed by by players with this job
Item.Weight = 15
Item.Volume = 11
Item.CanDrop = false
Item.CanEquip = true
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "weapon_fireaxe"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "FD Issue First Aid Kit"
Item.Desc = "A first aid kit, consumes Medical Supplies from your inventory."
Item.Type = "type_weapon"
Item.Model = "models/Items/HealthKit.mdl"
Item.JobItem = "JOB_FIREFIGHTER" --This item can only be possessed by by players with this job
Item.Weight = 7
Item.Volume = 10
Item.CanDrop = false
Item.CanEquip = true
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_fas2_iafk_custom_fire"

Item.CanPlayerEquip = function( tblItem, pPlayer )
	if GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, "FD Issue Medical Supplies" ) > 0 then return true end
	return GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, "Medical Supplies" ) > 0
end
GM.Inv:RegisterItem( Item )