--[[
	Name: cooking_items.lua
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

local Item = {}
Item.Name = "Stove"
Item.Desc = "A large gas range stove with built in oven."
Item.Type = "type_food"
Item.Model = "models/props_interiors/stove03_industrial.mdl"
Item.Weight = 75
Item.Volume = 60
Item.HealthOverride = 1000
Item.CanDrop = true
Item.LimitID = "stove"
Item.DropClass = "ent_stove"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1, { ["vip"] = 1 } )


local Item = {}
Item.Name = "Coffee Maker"
Item.Desc = "A basic coffee maker."
Item.Type = "type_food"
Item.Model = "models/props_unique/coffeemachine01.mdl"
Item.Weight = 8
Item.Volume = 12
Item.HealthOverride = 250
Item.CanDrop = true
Item.LimitID = "coffee maker"
Item.DropClass = "ent_coffee_maker"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1, { ["vip"] = 1 } )


local Item = {}
Item.Name = "Cooking Pot"
Item.Desc = "A large pot for cooking a variety of items in."
Item.Type = "type_food"
Item.Model = "models/props_c17/metalPot001a.mdl"
Item.Weight = 15
Item.Volume = 15
Item.CanDrop = true
Item.LimitID = "cooking pot"
Item.DropClass = "ent_cooking_pot"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 4, { ["vip"] = 2 } )


--[[ Raw Meats ]]--
local Item = {}
Item.Name = "Uncooked Beef"
Item.Desc = "An uncooked serving of beef."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/bacon_2.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanCook = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Uncooked Bacon"
Item.Desc = "An uncooked serving of bacon."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/bacon.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanCook = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Uncooked Bass"
Item.Desc = "An uncooked bass."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/fishbass.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanCook = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Uncooked Catfish"
Item.Desc = "An uncooked catfish."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/fishcatfish.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanCook = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Uncooked Rainbow Trout"
Item.Desc = "An uncooked rainbow trout."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/fishrainbow.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanCook = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Uncooked Lobster"
Item.Desc = "An uncooked lobster."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/lobster.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanCook = true
Item.DropClass = "prop_physics"
GM.Inv:RegisterItem( Item )


--[[ Drinks ]]--
local Item = {}
Item.Name = "Vinegar"
Item.Desc = "A jar of vinegar."
Item.Type = "type_food"
Item.Model = "models/props_junk/glassjug01.mdl"
Item.Weight = 2
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.LimitID = "vinegar"
Item.DropClass = "ent_fluid_vinegar"

Item.StillVars = {
	FluidAmountPerItem = 500, --amount of processed fluid needed to give the player an item
	FluidStillRate = 5, --amount of fluid to process each interval
	FluidStillInterval = 0.5, --Time until the next fluid processing

	GiveItem = "Acetic Acid", --item to give when fluidamount is reached
	GiveAmount = 1, --amount of the item to give each time
}
Item.GiveThirst = 0
Item.OnUse = PlayerDrinkItem
Item.PlayerCanUse = PlayerCanDrinkItem
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )


local Item = {}
Item.Name = "Sugar"
Item.Desc = "A box of sugar."
Item.Type = "type_food"
Item.Model = "models/props_lab/box01a.mdl"
Item.Weight = 2
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.LimitID = "sugar"
Item.DropClass = "ent_fluid_sugar"
Item.GiveThirst = -150
Item.GiveStamina = 15
Item.OnUse = PlayerDrinkItem
Item.PlayerCanUse = PlayerCanDrinkItem
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )


local Item = {}
Item.Name = "Jo Jo's Cola"
Item.Desc = "A 2 liter bottle of Jo Jo's Cola."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/colabig.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.LimitID = "soda"
Item.DropClass = "ent_fluid_cola_jojo"
Item.GiveThirst = 150
Item.GiveStamina = 15
Item.OnUse = PlayerDrinkItem
Item.PlayerCanUse = PlayerCanDrinkItem
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )


local Item = {}
Item.Name = "Sprunk Cola"
Item.Desc = "A 2 liter bottle of Sprunk Cola."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/sprunk2.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.LimitID = "soda"
Item.DropClass = "ent_fluid_cola_sprunk"
Item.GiveThirst = 150
Item.GiveStamina = 15
Item.OnUse = PlayerDrinkItem
Item.PlayerCanUse = PlayerCanDrinkItem
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )


local Item = {}
Item.Name = "Orange Juice"
Item.Desc = "A carton of orange juice."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/juice.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.LimitID = "juice"
Item.DropClass = "ent_fluid_orange_juice"
Item.GiveThirst = 150
Item.GiveStamina = 10
Item.OnUse = PlayerDrinkItem
Item.PlayerCanUse = PlayerCanDrinkItem
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )


local Item = {}
Item.Name = "Milk"
Item.Desc = "A carton of milk."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/milk.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.LimitID = "milk"
Item.DropClass = "ent_fluid_milk"
Item.GiveThirst = 150
Item.GiveStamina = 10
Item.OnUse = PlayerDrinkItem
Item.PlayerCanUse = PlayerCanDrinkItem
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )


local Item = {}
Item.Name = "Coffee"
Item.Desc = "A cup of hot coffee."
Item.Type = "type_food"
Item.Model = "models/shibcuppyhold.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.LimitID = "coffee"
Item.DropClass = "ent_fluid_coffee"
Item.GiveThirst = 300
Item.GiveStamina = 35
Item.OnUse = PlayerDrinkItem
Item.PlayerCanUse = PlayerCanDrinkItem
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )


local Item = {}
Item.Name = "Salt"
Item.Desc = "A container of salt."
Item.Type = "type_food"
Item.Model = "models/props_junk/GlassBottle01a.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.LimitID = "salt"
Item.DropClass = "ent_fluid_salt"
Item.GiveThirst = -200
Item.OnUse = PlayerDrinkItem
Item.PlayerCanUse = PlayerCanDrinkItem
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )


local Item = {}
Item.Name = "Cooking Oil"
Item.Desc = "A container of cooking oil."
Item.Type = "type_food"
Item.Model = "models/props_junk/garbage_plasticbottle003a.mdl"
Item.Weight = 2
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.LimitID = "cooking oil"
Item.DropClass = "ent_fluid_cooking_oil"
Item.GiveThirst = 25
Item.OnUse = PlayerDrinkItem
Item.PlayerCanUse = PlayerCanDrinkItem
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )


local Item = {}
Item.Name = "Ground Coffee"
Item.Desc = "A container of ground coffee."
Item.Type = "type_food"
Item.Model = "models/props_c17/pottery01a.mdl"
Item.Weight = 2
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.LimitID = "coffee grain"
Item.DropClass = "ent_fluid_coffee_grain"
Item.GiveThirst = -150
Item.GiveStamina = 10
Item.OnUse = PlayerDrinkItem
Item.PlayerCanUse = PlayerCanDrinkItem
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )


local Item = {}
Item.Name = "Filtered Water"
Item.Desc = "A gallon jug of pure water."
Item.Type = "type_food"
Item.Model = "models/props_junk/garbage_milkcarton001a.mdl"
Item.Weight = 10
Item.Volume = 8
Item.CanDrop = true
Item.CanUse = true
Item.LimitID = "filtered water"
Item.DropClass = "ent_fluid_water"
Item.GiveThirst = 150
Item.OnUse = PlayerDrinkItem
Item.PlayerCanUse = PlayerCanDrinkItem
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 4 )


--[[ Other ]]--
local Item = {}
Item.Name = "Doritos - Nacho Cheese"
Item.Desc = "A bag of nacho cheese flavor Doritos."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/chipsdoritos.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Fritos - Original"
Item.Desc = "A bag of original flavor Fritos."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/chipsfritos.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Fritos - BBQ"
Item.Desc = "A bag of BBQ flavor Fritos."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/chipsfritosbbq.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Fritos - BBQ Hoops"
Item.Desc = "A bag of BBQ flavor Fritos hoops."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/chipsfritoshoops.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Lays - Classic"
Item.Desc = "A bag of classic flavor Lays."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/chipslays.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Lays - Salt & Vinegar"
Item.Desc = "A bag of salt & vinegar flavor Lays."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/chipslays2.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Lays - Barbecue"
Item.Desc = "A bag of barbecue flavor Lays."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/chipslays3.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Lays - Sour Cream & Onion"
Item.Desc = "A bag of sour cream & onion flavor Lays."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/chipslays4.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Lays - Dill Pickle"
Item.Desc = "A bag of dill pickle flavor Lays."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/chipslays5.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Lays - Flamin' Hot"
Item.Desc = "A bag of flamin' hot flavor Lays."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/chipslays6.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Apple Jacks"
Item.Desc = "A box of Apple Jacks cereal."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/applejacks.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 250
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Honey Nut Cheerios"
Item.Desc = "A box of Honey Nut Cheerios cereal."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/cheerios.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 250
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Corn Flakes"
Item.Desc = "A box of Corn Flakes cereal."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/kellogscornflakes.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 250
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Panda Puffs"
Item.Desc = "A box of Panda Puffs cereal."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/pandapuffs.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 250
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Frosted Mini-Wheats"
Item.Desc = "A box of Frosted Mini-Wheats cereal."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/miniwheats.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 250
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Toblerone"
Item.Desc = "A Toblerone candy bar."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/toblerone.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 75
Item.GiveStamina = 5
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Jar of Pickles"
Item.Desc = "A jar of pickles."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/picklejar.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.CanCook = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Kinder Surprise"
Item.Desc = "A Kinder Surprise candy egg."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/kindersurprise.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 75
Item.GiveStamina = 5
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Cookies"
Item.Desc = "A package of cookies."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/cookies.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Watermelon"
Item.Desc = "A watermelon."
Item.Type = "type_food"
Item.Model = "models/props_junk/watermelon01.mdl"
Item.Weight = 5
Item.Volume = 6
Item.CanDrop = true
Item.CanUse = true
Item.CanCook = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 250
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Orange"
Item.Desc = "An orange."
Item.Type = "type_food"
Item.Model = "models/props/cs_italy/orange.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.CanCook = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Banana"
Item.Desc = "A banana."
Item.Type = "type_food"
Item.Model = "models/props/cs_italy/bananna.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.CanCook = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 100
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Bunch of Bananas"
Item.Desc = "A bunch of bananas."
Item.Type = "type_food"
Item.Model = "models/props/cs_italy/bananna_bunch.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = true
Item.CanUse = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 250
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Potato"
Item.Desc = "A fresh potato."
Item.Type = "type_food"
Item.Model = "models/props_phx/misc/potato.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.CanCook = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 50
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Egg"
Item.Desc = "A fresh chicken egg."
Item.Type = "type_food"
Item.Model = "models/props_phx/misc/egg.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.CanCook = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 25
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Cheese"
Item.Desc = "A box of cheese."
Item.Type = "type_food"
Item.Model = "models/props_lab/box01a.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.CanCook = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 75
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Lettuce"
Item.Desc = "A head of lettuce."
Item.Type = "type_food"
Item.Model = "models/foodnhouseholditems/cabbage1.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.CanCook = true
Item.DropClass = "prop_physics"
Item.GiveHunger = 50
Item.OnUse = PlayerEatItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Box of Flour"
Item.Desc = "A box of flour."
Item.Type = "type_food"
Item.Model = "models/props_lab/box01a.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.CanCook = true
Item.DropClass = "prop_physics"
Item.GiveThirst = -125
Item.OnUse = PlayerDrinkItem
Item.PlayerCanUse = PlayerCanEatItem
GM.Inv:RegisterItem( Item )