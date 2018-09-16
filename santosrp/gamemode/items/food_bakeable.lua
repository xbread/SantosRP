--[[
	Name: food_bakeable.lua
	For: TalosLife
	By: TalosLife
]]--

local function PlayerEatItem( tblItem, pPlayer )
	if tblItem.GiveHunger >= 0 then
		GAMEMODE.Needs:AddPlayerNeed( pPlayer, "Hunger", tblItem.GiveHunger )
	else
		GAMEMODE.Needs:TakePlayerNeed( pPlayer, "Hunger", math.abs(tblItem.GiveHunger) )
	end

	if tblItem.GiveStamina then
		if tblItem.GiveStamina >= 0 then
			GAMEMODE.Needs:AddPlayerNeed( pPlayer, "Stamina", tblItem.GiveStamina )
		else
			GAMEMODE.Needs:TakePlayerNeed( pPlayer, "Stamina", math.abs(tblItem.GiveStamina) )
		end
	end
	
	pPlayer:EmitSound( "taloslife/eating.mp3" )
end

local function PlayerDrinkItem( tblItem, pPlayer )
	if tblItem.GiveThirst >= 0 then
		GAMEMODE.Needs:AddPlayerNeed( pPlayer, "Thirst", tblItem.GiveThirst )
	else
		GAMEMODE.Needs:TakePlayerNeed( pPlayer, "Thirst", math.abs(tblItem.GiveThirst) )
	end

	if tblItem.GiveStamina then
		if tblItem.GiveStamina >= 0 then
			GAMEMODE.Needs:AddPlayerNeed( pPlayer, "Stamina", tblItem.GiveStamina )
		else
			GAMEMODE.Needs:TakePlayerNeed( pPlayer, "Stamina", math.abs(tblItem.GiveStamina) )
		end
	end
	
	pPlayer:EmitSound( "npc/barnacle/barnacle_gulp".. math.random(1, 2).. ".wav", 60, math.random(70, 130) )
end

local function PlayerCanEatItem( tblItem, pPlayer )
	if GAMEMODE.Needs:GetPlayerNeed( pPlayer, "Hunger" ) >= GAMEMODE.Needs:GetNeedData( "Hunger" ).Max then
		return tblItem.GiveHunger <= 0
	end
end

local function PlayerCanDrinkItem( tblItem, pPlayer )
	if GAMEMODE.Needs:GetPlayerNeed( pPlayer, "Thirst" ) >= GAMEMODE.Needs:GetNeedData( "Thirst" ).Max then
		return tblItem.GiveThirst <= 0
	end
end

local qualityLevels = { "Disgusting", "Average", "Delicious" }
local function DeclareBakedFood( tblFoodProto )
	for i = 1, 3 do
		local Item = {}
		Item.Name = tblFoodProto.Name.. (" (%s Quality)"):format( qualityLevels[i] )
		Item.Desc = tblFoodProto.Desc
		Item.Type = tblFoodProto.Type
		Item.Model = tblFoodProto.Model
		Item.Weight = tblFoodProto.Weight
		Item.Volume = tblFoodProto.Volume
		Item.CanDrop = tblFoodProto.CanDrop
		Item.CanUse = tblFoodProto.CanUse
		Item.DropClass = tblFoodProto.DropClass
		Item.GiveHunger = tblFoodProto.GiveHunger[i]
		Item.OnUse = PlayerEatItem
		Item.PlayerCanUse = PlayerCanEatItem

		if tblFoodProto.GiveStamina then
			Item.GiveStamina = tblFoodProto.GiveStamina[i]
		end

		GM.Inv:RegisterItem( Item )
	end
end

DeclareBakedFood{
	Name = "Toast",
	Desc = "A serving of toasted bread.",
	Type = "type_food",
	Model = "models/foodnhouseholditems/toast.mdl",
	Weight = 1,
	Volume = 2,
	CanDrop = true,
	CanUse = true,
	DropClass = "prop_physics",
	GiveHunger = { 50, 100, 200 },
	GiveStamina = { 3, 5, 8 },
}
local Item = {}
Item.Name = "Wheat Bread"
Item.Desc = "A serving of wheat bread."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/toast.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.CanCook = true
Item.DropClass = "prop_physics"
Item.Cooking_OvenVars = {
	Skill = "Cooking",
	SkillWeight = 0.175, --max % to remove from the score in the worst case

	OvenProgress = 7,
	OvenAmountPerTick = 0.1,
	OvenMaxOverTime = 60, --Max time after being done before starting a fire
	GiveItem = "Toast",
	GiveItems = {
		{ MinQuality = 0, GiveItem = "Toast (Disgusting Quality)", GiveAmount = 1 },
		{ MinQuality = 0.61, GiveItem = "Toast (Average Quality)", GiveAmount = 1 },
		{ MinQuality = 0.825, GiveItem = "Toast (Delicious Quality)", GiveAmount = 1 },
	},

	GiveXP = { --In order from 0 score up
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.61, GiveAmount = 7 },
		{ MinQuality = 0.825, GiveAmount = 9 },
	},
}
Item.GiveHunger = 50
Item.GiveStamina = 3
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

DeclareBakedFood{
	Name = "Cake",
	Desc = "A freshly baked cake.",
	Type = "type_food",
	Model = "models/foodnhouseholditems/cake.mdl",
	Weight = 1,
	Volume = 2,
	CanDrop = true,
	CanUse = true,
	DropClass = "prop_physics",
	GiveHunger = { 50, 200, 350 },
	GiveStamina = { 3, 20, 35 },
}
local Item = {}
Item.Name = "Cake Batter"
Item.Desc = "A tray of cake batter, ready to bake."
Item.Type = "type_food"
Item.Model = "models/props_c17/metalPot002a.mdl"
Item.Weight = 4
Item.Volume = 3
Item.CanDrop = true
Item.CanUse = true
Item.CanCook = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 50
Item.GiveStamina = 3
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem

Item.CraftingEntClass = "ent_foodprep_table"
Item.CraftSkill = "Cooking"
Item.CraftSkillLevel = 3
Item.CraftSkillXP = 2
Item.NoCraftSounds = true
Item.CraftRecipe = {
	["Box of Flour"] = 1,
	["Egg"] = 2,
	["Milk"] = 1,
	["Salt"] = 1,
	["Filtered Water"] = 1,
	["Sugar"] = 1,
}
Item.Cooking_OvenVars = {
	Skill = "Cooking",
	SkillWeight = 0.4, --max % to remove from the score in the worst case

	OvenProgress = 10,
	OvenAmountPerTick = 0.1,
	OvenMaxOverTime = 60, --Max time after being done before starting a fire
	GiveItem = "Cake",
	GiveItems = {
		{ MinQuality = 0, GiveItem = "Cake (Disgusting Quality)", GiveAmount = 1 },
		{ MinQuality = 0.61, GiveItem = "Cake (Average Quality)", GiveAmount = 1 },
		{ MinQuality = 0.825, GiveItem = "Cake (Delicious Quality)", GiveAmount = 1 },
	},

	GiveXP = { --In order from 0 score up
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.61, GiveAmount = 7 },
		{ MinQuality = 0.825, GiveAmount = 9 },
	},
}
GM.Inv:RegisterItem( Item )