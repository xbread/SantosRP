-----------------------------------------------------
--[[

    Name: fas2_misc.lua

    For: SantosRP

    By: Rustic7

]]--

 

local Item = {}

Item.Name = "DV2"

Item.Desc = "A DV2 knife"

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_dv2.mdl"

Item.Weight = 7

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_dv2"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "AltWeapon"

Item.EquipGiveClass = "fas2_dv2"

 

Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 19

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Metal Bar"] = 5,

    ["Metal Pipe"] = 2,

    ["Chunk of Plastic"] = 1,

	["Paint Bucket"] = 1,

}

GM.Inv:RegisterItem( Item )



local Item = {}

Item.Name = "Machete"

Item.Desc = "A machete"

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_machete.mdl"

Item.Weight = 7

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_machete"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "AltWeapon"

Item.EquipGiveClass = "fas2_machete"

 

Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 19

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Metal Bar"] = 5,

    ["Metal Pipe"] = 2,

    ["Chunk of Plastic"] = 2,

	["Wrench"] = 2,

	["Paint Bucket"] = 1,

}

GM.Inv:RegisterItem( Item )



local Item = {}

Item.Name = "First Aid Kit"

Item.Desc = "A first aid kit, consumes Medical Supplies from your inventory."

Item.Type = "type_weapon"

Item.Model = "models/Items/HealthKit.mdl"

Item.Weight = 7

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "weapon_fas2_iafk_custom"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "AltWeapon"

Item.EquipGiveClass = "weapon_fas2_iafk_custom"

Item.CanPlayerEquip = function( tblItem, pPlayer )

	if GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, "Government Issue Medical Supplies" ) > 0 then return true end

	return GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, "Medical Supplies" ) > 0

end

GM.Inv:RegisterItem( Item )

local Item = {}

Item.Name = "Katana"

Item.Desc = "A Katana"

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_wakizast.mdl"

Item.Weight = 7

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_wakizashi"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "AltWeapon"

Item.EquipGiveClass = "fas2_wakizashi"

 

Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 19

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Metal Bar"] = 10,

    ["Metal Pipe"] = 4,

    ["Chunk of Plastic"] = 2,

	["Wrench"] = 2,

	["Paint Bucket"] = 1,

}

GM.Inv:RegisterItem( Item )

--[[
local Item = {}

Item.Name = "M79"

Item.Desc = "An M79"

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_rif_ak47.mdl"

Item.Weight = 7

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_m79"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_m79"

 

Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 25

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 4,

    ["Bolt"] = 5,

    ["Trigger"] = 8,

    ["Stock"] = 8,

    ["Handle Grip"] = 8,

    ["Long Barrel"] = 81,

    ["Lower Receiver"] = 112,

    ["Upper Receiver"] = 121,

}

GM.Inv:RegisterItem( Item )
--]]