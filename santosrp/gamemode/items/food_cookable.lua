--[[
	Name: food_cookable.lua
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
local function DeclareCookableFood( tblFoodProto, tblCookingPotVars )
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
		Item.CanCook = tblFoodProto.CanCook
		Item.DropClass = tblFoodProto.DropClass
		Item.GiveHunger = tblFoodProto.GiveHunger[i]
		Item.OnUse = PlayerEatItem
		Item.PlayerCanUse = PlayerCanEatItem

		if i == 1 then
			Item.CookingPotVars = tblCookingPotVars
		end

		if tblFoodProto.GiveStamina then
			Item.GiveStamina = tblFoodProto.GiveStamina[i]
		end

		GM.Inv:RegisterItem( Item )
	end
end

DeclareCookableFood( {
	Name = "Cooked Bacon",
	Desc = "A serving of cooked bacon.",
	Type = "type_food",
	Model = "models/foodnhouseholditems/baconcooked.mdl",
	Weight = 1,
	Volume = 2,
	CanDrop = true,
	CanUse = true,
	CanCook = true,
	DropClass = "prop_physics",
	GiveHunger = { 75, 100, 150 },
	GiveStamina = { 5, 8, 10 },
},
{
	Skill = "Cooking",
	SkillWeight = 0.25, --max % to remove from the score in the worst case

	--Only displayed if over time explode/fire are both off and item is grabbed before it reaches the max time cap
	--anything catches fire past the max time cap (set in the cooking pot shared file)
	OverCookMsg = "You burnt your bacon to a crisp!",
	OverTimeExplode = false, --Explode and start a fire if the item goes over max time
	OverTimeStartFire = false, --Start a fire if the item goes over max time

	MinTime = 30,
	MaxTime = 90,
	TimeWeight = -0.33, --the closer this number is to 0, the less impact time has on the end score (-4 = 0/100% impact do not go below)
	IdealTimePercent = 0.66, --% from min to max time to consider ideal

	Items = {
		["Uncooked Bacon"] = { IdealAmount = 1, MaxAmount = 1, MinAmount = 1 },
	},
	Fluids = {
		["Cooking Oil"] = { IdealAmount = 25, MaxAmount = 750, MinAmount = 25 },
	},
	GiveItems = { --In order from low quality to high quality (enter only 1 for no quality)
		{ MinQuality = 0, GiveItem = "Cooked Bacon (Disgusting Quality)", GiveAmount = 1 },
		{ MinQuality = 0.61, GiveItem = "Cooked Bacon (Average Quality)", GiveAmount = 1 },
		{ MinQuality = 0.825, GiveItem = "Cooked Bacon (Delicious Quality)", GiveAmount = 1 },
	},
	GiveXP = { --In order from 0 score up
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.61, GiveAmount = 7 },
		{ MinQuality = 0.825, GiveAmount = 9 },
	}
} )

DeclareCookableFood( {
	Name = "Cooked Lobster",
	Desc = "A serving of cooked lobster.",
	Type = "type_food",
	Model = "models/foodnhouseholditems/lobster.mdl",
	Weight = 1,
	Volume = 2,
	CanDrop = true,
	CanUse = true,
	DropClass = "prop_physics",
	GiveHunger = { 100, 250, 450 },
	GiveStamina = { 5, 8, 10 },
},
{
	Skill = "Cooking",
	SkillWeight = 0.5, --max % to remove from the score in the worst case

	--Only displayed if over time explode/fire are both off and item is grabbed before it reaches the max time cap
	--anything catches fire past the max time cap (set in the cooking pot shared file)
	OverCookMsg = "You overcooked your lobster!",
	OverTimeExplode = false, --Explode and start a fire if the item goes over max time
	OverTimeStartFire = false, --Start a fire if the item goes over max time

	MinTime = 120,
	MaxTime = 220,
	TimeWeight = -0.85, --the closer this number is to 0, the less impact time has on the end score (-4 = 0/100% impact do not go below)
	IdealTimePercent = 0.6895, --% from min to max time to consider ideal

	Items = {
		["Uncooked Lobster"] = { IdealAmount = 1, MaxAmount = 1, MinAmount = 1 },
	},
	Fluids = {
		["Salt"] = { IdealAmount = 50, MaxAmount = 750, MinAmount = 25 },
		["Water"] = { IdealAmount = 350, MaxAmount = 750, MinAmount = 25 },
	},
	GiveItems = { --In order from low quality to high quality (enter only 1 for no quality)
		{ MinQuality = 0, GiveItem = "Cooked Lobster (Disgusting Quality)", GiveAmount = 1 },
		{ MinQuality = 0.61, GiveItem = "Cooked Lobster (Average Quality)", GiveAmount = 1 },
		{ MinQuality = 0.825, GiveItem = "Cooked Lobster (Delicious Quality)", GiveAmount = 1 },
	},
	GiveXP = { --In order from 0 score up
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.61, GiveAmount = 7 },
		{ MinQuality = 0.825, GiveAmount = 9 },
	}
} )

DeclareCookableFood( {
	Name = "Cooked Bass",
	Desc = "A serving of cooked bass.",
	Type = "type_food",
	Model = "models/foodnhouseholditems/fishbass.mdl",
	Weight = 1,
	Volume = 2,
	CanDrop = true,
	CanUse = true,
	DropClass = "prop_physics",
	GiveHunger = { 100, 200, 350 },
	GiveStamina = { 5, 8, 10 },
},
{
	Skill = "Cooking",
	SkillWeight = 0.275, --max % to remove from the score in the worst case

	--Only displayed if over time explode/fire are both off and item is grabbed before it reaches the max time cap
	--anything catches fire past the max time cap (set in the cooking pot shared file)
	OverCookMsg = "You overcooked your bass!",
	OverTimeExplode = false, --Explode and start a fire if the item goes over max time
	OverTimeStartFire = false, --Start a fire if the item goes over max time

	MinTime = 50,
	MaxTime = 200,
	TimeWeight = -0.4, --the closer this number is to 0, the less impact time has on the end score (-4 = 0/100% impact do not go below)
	IdealTimePercent = 0.45, --% from min to max time to consider ideal

	Items = {
		["Uncooked Bass"] = { IdealAmount = 1, MaxAmount = 1, MinAmount = 1 },
	},
	Fluids = {
		["Salt"] = { IdealAmount = 50, MaxAmount = 750, MinAmount = 25 },
		["Water"] = { IdealAmount = 350, MaxAmount = 750, MinAmount = 25 },
	},
	GiveItems = { --In order from low quality to high quality (enter only 1 for no quality)
		{ MinQuality = 0, GiveItem = "Cooked Bass (Disgusting Quality)", GiveAmount = 1 },
		{ MinQuality = 0.61, GiveItem = "Cooked Bass (Average Quality)", GiveAmount = 1 },
		{ MinQuality = 0.825, GiveItem = "Cooked Bass (Delicious Quality)", GiveAmount = 1 },
	},
	GiveXP = { --In order from 0 score up
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.61, GiveAmount = 7 },
		{ MinQuality = 0.825, GiveAmount = 9 },
	}
} )

DeclareCookableFood( {
	Name = "Cooked Catfish",
	Desc = "A serving of cooked catfish.",
	Type = "type_food",
	Model = "models/foodnhouseholditems/fishcatfish.mdl",
	Weight = 1,
	Volume = 2,
	CanDrop = true,
	CanUse = true,
	DropClass = "prop_physics",
	GiveHunger = { 100, 200, 350 },
	GiveStamina = { 5, 8, 10 },
},
{
	Skill = "Cooking",
	SkillWeight = 0.275, --max % to remove from the score in the worst case

	--Only displayed if over time explode/fire are both off and item is grabbed before it reaches the max time cap
	--anything catches fire past the max time cap (set in the cooking pot shared file)
	OverCookMsg = "You overcooked your catfish!",
	OverTimeExplode = false, --Explode and start a fire if the item goes over max time
	OverTimeStartFire = false, --Start a fire if the item goes over max time

	MinTime = 60,
	MaxTime = 180,
	TimeWeight = -0.4, --the closer this number is to 0, the less impact time has on the end score (-4 = 0/100% impact do not go below)
	IdealTimePercent = 0.75, --% from min to max time to consider ideal

	Items = {
		["Uncooked Catfish"] = { IdealAmount = 1, MaxAmount = 1, MinAmount = 1 },
	},
	Fluids = {
		["Salt"] = { IdealAmount = 75, MaxAmount = 750, MinAmount = 25 },
		["Water"] = { IdealAmount = 350, MaxAmount = 750, MinAmount = 25 },
	},
	GiveItems = { --In order from low quality to high quality (enter only 1 for no quality)
		{ MinQuality = 0, GiveItem = "Cooked Catfish (Disgusting Quality)", GiveAmount = 1 },
		{ MinQuality = 0.61, GiveItem = "Cooked Catfish (Average Quality)", GiveAmount = 1 },
		{ MinQuality = 0.825, GiveItem = "Cooked Catfish (Delicious Quality)", GiveAmount = 1 },
	},
	GiveXP = { --In order from 0 score up
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.61, GiveAmount = 7 },
		{ MinQuality = 0.825, GiveAmount = 9 },
	}
} )

DeclareCookableFood( {
	Name = "Cooked Rainbow Trout",
	Desc = "A serving of cooked rainbow trout.",
	Type = "type_food",
	Model = "models/foodnhouseholditems/fishrainbow.mdl",
	Weight = 1,
	Volume = 2,
	CanDrop = true,
	CanUse = true,
	DropClass = "prop_physics",
	GiveHunger = { 100, 200, 350 },
	GiveStamina = { 5, 8, 10 },
},
{
	Skill = "Cooking",
	SkillWeight = 0.33, --max % to remove from the score in the worst case

	--Only displayed if over time explode/fire are both off and item is grabbed before it reaches the max time cap
	--anything catches fire past the max time cap (set in the cooking pot shared file)
	OverCookMsg = "You overcooked your trout!",
	OverTimeExplode = false, --Explode and start a fire if the item goes over max time
	OverTimeStartFire = false, --Start a fire if the item goes over max time

	MinTime = 80,
	MaxTime = 220,
	TimeWeight = -0.45, --the closer this number is to 0, the less impact time has on the end score (-4 = 0/100% impact do not go below)
	IdealTimePercent = 0.77, --% from min to max time to consider ideal

	Items = {
		["Uncooked Rainbow Trout"] = { IdealAmount = 1, MaxAmount = 1, MinAmount = 1 },
	},
	Fluids = {
		["Salt"] = { IdealAmount = 25, MaxAmount = 750, MinAmount = 25 },
		["Water"] = { IdealAmount = 350, MaxAmount = 750, MinAmount = 25 },
	},
	GiveItems = { --In order from low quality to high quality (enter only 1 for no quality)
		{ MinQuality = 0, GiveItem = "Cooked Rainbow Trout (Disgusting Quality)", GiveAmount = 1 },
		{ MinQuality = 0.61, GiveItem = "Cooked Rainbow Trout (Average Quality)", GiveAmount = 1 },
		{ MinQuality = 0.825, GiveItem = "Cooked Rainbow Trout (Delicious Quality)", GiveAmount = 1 },
	},
	GiveXP = { --In order from 0 score up
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.61, GiveAmount = 7 },
		{ MinQuality = 0.825, GiveAmount = 9 },
	}
} )

DeclareCookableFood( {
	Name = "Cheese Burger",
	Desc = "A simple cheese burger.",
	Type = "type_food",
	Model = "models/foodnhouseholditems/burgersims2.mdl",
	Weight = 1,
	Volume = 2,
	CanDrop = true,
	CanUse = true,
	DropClass = "prop_physics",
	GiveHunger = { 100, 200, 350 },
	GiveStamina = { 5, 8, 10 },
},
{
	Skill = "Cooking",
	SkillWeight = 0.25, --max % to remove from the score in the worst case

	--Only displayed if over time explode/fire are both off and item is grabbed before it reaches the max time cap
	--anything catches fire past the max time cap (set in the cooking pot shared file)
	OverCookMsg = "You overcooked your burger!",
	OverTimeExplode = false, --Explode and start a fire if the item goes over max time
	OverTimeStartFire = false, --Start a fire if the item goes over max time

	MinTime = 30,
	MaxTime = 120,
	TimeWeight = -0.25, --the closer this number is to 0, the less impact time has on the end score (-4 = 0/100% impact do not go below)
	IdealTimePercent = 0.35, --% from min to max time to consider ideal

	Items = {
		["Uncooked Beef"] = { IdealAmount = 1, MaxAmount = 1, MinAmount = 1 },
		["Cheese"] = { IdealAmount = 1, MaxAmount = 1, MinAmount = 1 },
		["Wheat Bread"] = { IdealAmount = 2, MaxAmount = 2, MinAmount = 1 },
	},
	Fluids = {
		["Salt"] = { IdealAmount = 25, MaxAmount = 750, MinAmount = 25 },
	},
	GiveItems = { --In order from low quality to high quality (enter only 1 for no quality)
		{ MinQuality = 0, GiveItem = "Cheese Burger (Disgusting Quality)", GiveAmount = 1 },
		{ MinQuality = 0.61, GiveItem = "Cheese Burger (Average Quality)", GiveAmount = 1 },
		{ MinQuality = 0.825, GiveItem = "Cheese Burger (Delicious Quality)", GiveAmount = 1 },
	},
	GiveXP = { --In order from 0 score up
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.61, GiveAmount = 7 },
		{ MinQuality = 0.825, GiveAmount = 9 },
	}
} )

DeclareCookableFood( {
	Name = "Double Cheese Burger",
	Desc = "A double cheese burger.",
	Type = "type_food",
	Model = "models/foodnhouseholditems/mcdburger.mdl",
	Weight = 2,
	Volume = 2,
	CanDrop = true,
	CanUse = true,
	DropClass = "prop_physics",
	GiveHunger = { 100, 275, 400 },
	GiveStamina = { 5, 8, 10 },
},
{
	Skill = "Cooking",
	SkillWeight = 0.33, --max % to remove from the score in the worst case

	--Only displayed if over time explode/fire are both off and item is grabbed before it reaches the max time cap
	--anything catches fire past the max time cap (set in the cooking pot shared file)
	OverCookMsg = "You overcooked your burger!",
	OverTimeExplode = false, --Explode and start a fire if the item goes over max time
	OverTimeStartFire = false, --Start a fire if the item goes over max time

	MinTime = 30,
	MaxTime = 120,
	TimeWeight = -0.275, --the closer this number is to 0, the less impact time has on the end score (-4 = 0/100% impact do not go below)
	IdealTimePercent = 0.35, --% from min to max time to consider ideal

	Items = {
		["Uncooked Beef"] = { IdealAmount = 2, MaxAmount = 2, MinAmount = 2 },
		["Cheese"] = { IdealAmount = 2, MaxAmount = 2, MinAmount = 2 },
		["Wheat Bread"] = { IdealAmount = 3, MaxAmount = 3, MinAmount = 2 },
	},
	Fluids = {
		["Salt"] = { IdealAmount = 50, MaxAmount = 750, MinAmount = 25 },
	},
	GiveItems = { --In order from low quality to high quality (enter only 1 for no quality)
		{ MinQuality = 0, GiveItem = "Double Cheese Burger (Disgusting Quality)", GiveAmount = 1 },
		{ MinQuality = 0.61, GiveItem = "Double Cheese Burger (Average Quality)", GiveAmount = 1 },
		{ MinQuality = 0.825, GiveItem = "Double Cheese Burger (Delicious Quality)", GiveAmount = 1 },
	},
	GiveXP = { --In order from 0 score up
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.61, GiveAmount = 7 },
		{ MinQuality = 0.825, GiveAmount = 9 },
	}
} )

DeclareCookableFood( {
	Name = "French Fries",
	Desc = "A serving of fries.",
	Type = "type_food",
	Model = "models/foodnhouseholditems/mcdfrenchfries.mdl",
	Weight = 1,
	Volume = 1,
	CanDrop = true,
	CanUse = true,
	DropClass = "prop_physics",
	GiveHunger = { 75, 150, 200 },
	GiveStamina = { 5, 8, 10 },
},
{
	Skill = "Cooking",
	SkillWeight = 0.25, --max % to remove from the score in the worst case

	--Only displayed if over time explode/fire are both off and item is grabbed before it reaches the max time cap
	--anything catches fire past the max time cap (set in the cooking pot shared file)
	OverCookMsg = "You overcooked your fries!",
	OverTimeExplode = false, --Explode and start a fire if the item goes over max time
	OverTimeStartFire = false, --Start a fire if the item goes over max time

	MinTime = 30,
	MaxTime = 120,
	TimeWeight = -0.25, --the closer this number is to 0, the less impact time has on the end score (-4 = 0/100% impact do not go below)
	IdealTimePercent = 0.35, --% from min to max time to consider ideal

	Items = {
		["Potato"] = { IdealAmount = 2, MaxAmount = 2, MinAmount = 2 },
	},
	Fluids = {
		["Salt"] = { IdealAmount = 100, MaxAmount = 750, MinAmount = 25 },
		["Cooking Oil"] = { IdealAmount = 350, MaxAmount = 750, MinAmount = 100 },
	},
	GiveItems = { --In order from low quality to high quality (enter only 1 for no quality)
		{ MinQuality = 0, GiveItem = "French Fries (Disgusting Quality)", GiveAmount = 1 },
		{ MinQuality = 0.61, GiveItem = "French Fries (Average Quality)", GiveAmount = 1 },
		{ MinQuality = 0.825, GiveItem = "French Fries (Delicious Quality)", GiveAmount = 1 },
	},
	GiveXP = { --In order from 0 score up
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.61, GiveAmount = 7 },
		{ MinQuality = 0.825, GiveAmount = 9 },
	}
} )