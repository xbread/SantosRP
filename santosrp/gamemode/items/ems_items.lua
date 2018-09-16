--[[
    Name: ems_items.lua
    For: TalosLife
    By: TalosLife
]]--
 
local Item = {}
Item.Name = "Government Issue First Aid Kit"
Item.Desc = "A first aid kit, consumes Medical Supplies from your inventory."
Item.Type = "type_weapon"
Item.Model = "models/Items/HealthKit.mdl"
Item.JobItem = "JOB_EMS" --This item can only be possessed by by players with this job
Item.Weight = 7
Item.Volume = 10
Item.CanDrop = false
Item.CanEquip = true
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_fas2_iafk_custom_gov"

Item.CanPlayerEquip = function( tblItem, pPlayer )
	if GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, "Government Issue Medical Supplies" ) > 0 then return true end
	return GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, "Medical Supplies" ) > 0
end
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Morphine Applicator"
Item.Desc = "A morphine applicator, heals broken limbs, consumes Medical Supplies."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_pistol.mdl"
Item.JobItem = "JOB_EMS" --This item can only be possessed by by players with this job
Item.Weight = 9
Item.Volume = 8
Item.CanDrop = false
Item.CanEquip = true
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_medshot_morphine"

Item.CanPlayerEquip = function( tblItem, pPlayer )
	if GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, "Government Issue Medical Supplies" ) > 0 then return true end
	return GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, "Medical Supplies" ) > 0
end
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Blood Draw Syringe"
Item.Desc = "A reusable blood draw kit, consumes Medical Supplies."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_pistol.mdl"
Item.JobItem = "JOB_EMS" --This item can only be possessed by by players with this job
Item.Weight = 9
Item.Volume = 8
Item.CanDrop = false
Item.CanEquip = true
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_medshot_blooddraw"

Item.CanPlayerEquip = function( tblItem, pPlayer )
	if GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, "Government Issue Medical Supplies" ) > 0 then return true end
	return GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, "Medical Supplies" ) > 0
end
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Patient Clipboard"
Item.Desc = "A clipboard for looking at patient files."
Item.Type = "type_weapon"
Item.Model = "models/props_lab/clipboard.mdl"
Item.JobItem = "JOB_EMS" --This item can only be possessed by by players with this job
Item.Weight = 2
Item.Volume = 3
Item.CanDrop = false
Item.CanEquip = true
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "weapon_ems_clipboard"
GM.Inv:RegisterItem( Item )