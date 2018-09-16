--[[
	Name: gun_parts.lua
	For: TalosLife
	By: TalosLife
]]--

local Item = {}
Item.Name = "Firing Pin"
Item.Desc = "A firing pin for a firearm."
Item.Model = "models/props_lab/pipesystem03c.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.DropClass = "prop_physics"

Item.CraftingEntClass = "ent_gunsmithing_table"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 5
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Bracket"] = 1,
	["Metal Plate"] = 1,
}
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Bolt"
Item.Desc = "A bolt for a firearm."
Item.Model = "models/props_c17/TrapPropeller_Lever.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.DropClass = "prop_physics"

Item.CraftingEntClass = "ent_gunsmithing_table"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 5
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Bracket"] = 2,
	["Metal Plate"] = 1,
	["Metal Bar"] = 1,
}
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Trigger"
Item.Desc = "A trigger for a firearm."
Item.Model = "models/gibs/metal_gib1.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.DropClass = "prop_physics"

Item.CraftingEntClass = "ent_gunsmithing_table"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 5
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Bracket"] = 1,
	["Metal Plate"] = 1,
	["Metal Bar"] = 1,
}
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Stock"
Item.Desc = "A stock for a firearm."
Item.Model = "models/props_junk/wood_pallet001a_chunka1.mdl"
Item.Weight = 2
Item.Volume = 3
Item.CanDrop = true
Item.DropClass = "prop_physics"

Item.CraftingEntClass = "ent_gunsmithing_table"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 5
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Bracket"] = 1,
	["Wood Plank"] = 4,
}
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Slide"
Item.Desc = "A slide for a firearm."
Item.Model = "models/gibs/metal_gib2.mdl"
Item.Weight = 2
Item.Volume = 2
Item.CanDrop = true
Item.DropClass = "prop_physics"

Item.CraftingEntClass = "ent_gunsmithing_table"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 5
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Bracket"] = 2,
	["Metal Plate"] = 3,
	["Metal Bar"] = 2,
}
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Cylinder"
Item.Desc = "A cylinder for a firearm."
Item.Model = "models/Items/combine_rifle_ammo01.mdl"
Item.Weight = 2
Item.Volume = 2
Item.CanDrop = true
Item.DropClass = "prop_physics"

Item.CraftingEntClass = "ent_gunsmithing_table"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 5
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Bracket"] = 1,
	["Metal Plate"] = 4,
	["Metal Bar"] = 1,
}
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Handle Grip"
Item.Desc = "A handle grip for a firearm."
Item.Model = "models/gibs/metal_gib5.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.DropClass = "prop_physics"

Item.CraftingEntClass = "ent_gunsmithing_table"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 5
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Wood Plank"] = 2,
	["Metal Bracket"] = 1,
	["Metal Plate"] = 2,
}
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Short Barrel"
Item.Desc = "A short barrel for a firearm."
Item.Model = "models/gibs/metal_gib3.mdl"
Item.Weight = 2
Item.Volume = 2
Item.CanDrop = true
Item.DropClass = "prop_physics"

Item.CraftingEntClass = "ent_gunsmithing_table"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 5
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Bracket"] = 1,
	["Metal Plate"] = 2,
	["Metal Bar"] = 2,
}
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Long Barrel"
Item.Desc = "A long barrel for a firearm."
Item.Model = "models/props_c17/signpole001.mdl"
Item.Weight = 4
Item.Volume = 4
Item.CanDrop = true
Item.DropClass = "prop_physics"

Item.CraftingEntClass = "ent_gunsmithing_table"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 5
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Bracket"] = 2,
	["Metal Plate"] = 4,
	["Metal Bar"] = 4,
}
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Lower Receiver"
Item.Desc = "A lower receiver for a firearm."
Item.Model = "models/items/battery.mdl"
Item.Weight = 2
Item.Volume = 2
Item.CanDrop = true
Item.DropClass = "prop_physics"

Item.CraftingEntClass = "ent_gunsmithing_table"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 5
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Bracket"] = 5,
	["Metal Plate"] = 8,
	["Metal Bar"] = 3,
}
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Upper Receiver"
Item.Desc = "An upper receiver for a firearm."
Item.Model = "models/items/battery.mdl"
Item.Weight = 2
Item.Volume = 2
Item.CanDrop = true
Item.DropClass = "prop_physics"

Item.CraftingEntClass = "ent_gunsmithing_table"
Item.CraftSkill = "Gun Smithing"
Item.CraftSkillLevel = 5
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Bracket"] = 4,
	["Metal Plate"] = 10,
	["Metal Bar"] = 1,
}
GM.Inv:RegisterItem( Item )