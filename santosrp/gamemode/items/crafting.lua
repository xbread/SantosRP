--[[
	Name: crafting.lua
	For: TalosLife
	By: TalosLife
]]--

local Item = {}
Item.Name = "Crafting Table"
Item.Desc = "A crafting table for making items."
Item.Model = "models/props_wasteland/controlroom_desk001b.mdl"
Item.Weight = 50
Item.Volume = 45
Item.HealthOverride = 3000
Item.CanDrop = true
Item.LimitID = "crafting table"
Item.DropClass = "ent_crafting_table"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )

local Item = {}
Item.Name = "Gun Smithing Table"
Item.Desc = "A gun smithing table for making gun parts."
Item.Model = "models/props/CS_militia/table_shed.mdl"
Item.Weight = 50
Item.Volume = 45
Item.HealthOverride = 3000
Item.CanDrop = true
Item.DropClass = "ent_gunsmithing_table"
Item.LimitID = "gun smithing table"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )

local Item = {}
Item.Name = "Assembly Table"
Item.Desc = "An assembly table for putting together items."
Item.Model = "models/props/CS_militia/table_kitchen.mdl"
Item.Weight = 50
Item.Volume = 45
Item.HealthOverride = 3000
Item.CanDrop = true
Item.DropClass = "ent_assembly_table"
Item.LimitID = "assembly table"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )

local Item = {}
Item.Name = "Food-Prep Table"
Item.Desc = "A large kitchen table suitable for preparing food on."
Item.Type = "type_food"
Item.Model = "models/props_wasteland/kitchen_counter001a.mdl"
Item.Weight = 50
Item.Volume = 45
Item.HealthOverride = 3000
Item.CanDrop = true
Item.LimitID = "food-prep table"
Item.DropClass = "ent_foodprep_table"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1, { ["vip"] = 1 } )