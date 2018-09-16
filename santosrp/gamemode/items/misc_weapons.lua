--[[
	Name: misc_weapons.lua
	For: TalosLife
	By: TalosLife
]]--

--[[local Item = {}
Item.Name = "Civ Radio"
Item.Desc = "Civ Radio"
Item.Type = "type_weapon"
Item.Model = "models/gspeak/funktronics.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanEquip = true
Item.Illegal = true
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "swep_radio"
Item.DropClass = "swep_radio"
GM.Inv:RegisterItem( Item )]]

local Item = {}
Item.Name = "Flash Grenade"
Item.Desc = "A flash bang."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_eq_flashbang.mdl"
Item.Weight = 3
Item.Volume = 3
Item.CanDrop = true
Item.CanEquip = true
Item.Illegal = true
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_fas_grenadeflash"
Item.DropClass = "weapon_fas_grenadeflash"

Item.CraftingEntClass = "ent_assembly_table"
Item.CraftingTab = "Weapons"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 23
Item.CraftSkillXP = 2
Item.CraftRecipe = {
	["Metal Bracket"] = 4,
	["Metal Plate"] = 8,
	["Smokeless Gunpowder"] = 4,
}
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Lockpick"
Item.Desc = "A lockpick. Can unlock doors and free handcuffed players."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_crowbar.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanEquip = true
Item.Illegal = true
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_lockpick"
Item.DropClass = "weapon_lockpick"

Item.CraftingEntClass = "ent_assembly_table"
Item.CraftingTab = "Weapons"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 1
Item.CraftSkillXP = 2
Item.CraftRecipe = {
	["Metal Bracket"] = 1,
	["Metal Plate"] = 2,
	["Crowbar"] = 1,
}
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Zip Tie"
Item.Desc = "A zip tie. Can restrain other players."
Item.Type = "type_weapon"
Item.Model = "models/katharsmodels/handcuffs/handcuffs-1.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanEquip = true
Item.Illegal = true
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_ziptie"
Item.DropClass = "weapon_ziptie"

Item.CraftingEntClass = "ent_assembly_table"
Item.CraftingTab = "Weapons"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 3
Item.CraftSkillXP = 2
Item.CraftRecipe = {
	["Chunk of Plastic"] = 8,
	["Metal Bracket"] = 2,
	["Pliers"] = 3,
}
GM.Inv:RegisterItem( Item )