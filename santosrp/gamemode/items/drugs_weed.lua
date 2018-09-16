--[[

	Name: drugs_weed.lua

		

		

]]--



local weedGrowModels = {

	[1] = {

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(8.5, 0, 7),

			ang = "random_yaw",

			bgroups = { [1] = 0, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(0, 8.5, 7),

			ang = "random_yaw",

			bgroups = { [1] = 0, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(0, -8.5, 7),

			ang = "random_yaw",

			bgroups = { [1] = 0, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(-8.5, 0, 7),

			ang = "random_yaw",

			bgroups = { [1] = 0, },

		},

	},



	[2] = {

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(8.5, 0, 7),

			ang = "random_yaw",

			bgroups = { [1] = 1, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(0, 8.5, 7),

			ang = "random_yaw",

			bgroups = { [1] = 1, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(0, -8.5, 7),

			ang = "random_yaw",

			bgroups = { [1] = 1, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(-8.5, 0, 7),

			ang = "random_yaw",

			bgroups = { [1] = 1, },

		},

	},



	[3] = {

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(8.5, 0, 7),

			ang = "random_yaw",

			scale = 2,

			bgroups = { [1] = 2, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(0, 8.5, 7),

			ang = "random_yaw",

			scale = 2,

			bgroups = { [1] = 2, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(0, -8.5, 7),

			ang = "random_yaw",

			scale = 2,

			bgroups = { [1] = 2, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(-8.5, 0, 7),

			ang = "random_yaw",

			scale = 2,

			bgroups = { [1] = 2, },

		},

	},



	[4] = {

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(8.5, 0, 7),

			ang = "random_yaw",

			scale = 2.5,

			bgroups = { [1] = 3, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(0, 8.5, 7),

			ang = "random_yaw",

			scale = 2.5,

			bgroups = { [1] = 3, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(0, -8.5, 7),

			ang = "random_yaw",

			scale = 2.5,

			bgroups = { [1] = 3, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(-8.5, 0, 7),

			ang = "random_yaw",

			scale = 2.5,

			bgroups = { [1] = 3, },

		},

	},



	[5] = {

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(8.5, 0, 7),

			ang = "random_yaw",

			scale = 3,

			bgroups = { [1] = 4, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(0, 8.5, 7),

			ang = "random_yaw",

			scale = 3,

			bgroups = { [1] = 4, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(0, -8.5, 7),

			ang = "random_yaw",

			scale = 3,

			bgroups = { [1] = 4, },

		},

		{

			mdl = "models/gonzo/weed/weed.mdl",

			pos = Vector(-8.5, 0, 7),

			ang = "random_yaw",

			scale = 3,

			bgroups = { [1] = 4, },

		},

	},

}





--[[ Misc Items ]]--

local Item = {}

Item.Name = "Drying Rack"

Item.Desc = "A drying rack for cannabis."

Item.Type = "type_drugs"

Item.Model = "models/props_wasteland/kitchen_shelf001a.mdl"

Item.Weight = 15

Item.Volume = 50

Item.HealthOverride = 2500

Item.CanDrop = true

Item.Illegal = true

Item.DropClass = "ent_drying_rack"

Item.LimitID = "drying rack"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Machines"

Item.CraftSkill = "Crafting"

Item.CraftSkillLevel = 1

Item.CraftSkillXP = 5

Item.CraftRecipe = {

	["Box Fan"] = 2,

	["Metal Bracket"] = 4,

	["Metal Plate"] = 3,

	["Metal Pipe"] = 2,

}

GM.Inv:RegisterItem( Item )

GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )





local Item = {}

Item.Name = "Trimming Machine"

Item.Desc = "An automatic trimming machine for dry cannabis."

Item.Type = "type_drugs"

Item.Model = "models/props_junk/MetalBucket02a.mdl"

Item.Weight = 12

Item.Volume = 15

Item.HealthOverride = 1000

Item.CanDrop = true

Item.Illegal = true

Item.DropClass = "ent_weed_trimmer"

Item.LimitID = "trimming machine"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Machines"

Item.CraftSkill = "Crafting"

Item.CraftSkillLevel = 1

Item.CraftSkillXP = 5

Item.CraftRecipe = {

	["Metal Bucket"] = 3,

	["Wrench"] = 3,

	["Pliers"] = 2,

	["Circular Saw"] = 1,

	["Metal Plate"] = 4,



}

GM.Inv:RegisterItem( Item )

GM.Inv:RegisterItemLimit( Item.LimitID, 3, { ["vip"] = 1 } )



-- ----------------------------------------------------------------

-- Low Quality Weed

-- ----------------------------------------------------------------

local Item = {}

Item.Name = "Cannabis Seeds (Low Quality)"

Item.Desc = "A box of low quality marijuana seeds."

Item.Type = "type_drugs"

Item.Model = "models/freeman/seedbox.mdl"

Item.Weight = 2

Item.Volume = 2

Item.CanDrop = true

Item.Illegal = true

Item.LimitID = "cannabis seeds"



--Vars used by the plant pot entity to configure growth params

Item.CanPlant = true

Item.DrugGrowthVars = {

	GrowModels = weedGrowModels, --Models for each growth stage

	GrowStageTime = 210, --Time between growth stages

	PlantHealth = 100,



	GiveItem = "Fresh Cannabis (Low Quality)",

	GiveItemAmount = 2,



	WaterDecay = 5, --Amout of water to consume per water decay tick

	WaterDecayTime = 15, --Time in seconds before WaterDecay water is taken from the plant

	WaterDamageAmount = 1, --Amount of damage to deal to the plant when out of water

	WaterDamageInterval = 2, --Time in seconds per damage event from lack of water

	WaterRequirement = 0.25, --Min % of total possible water this plant needs to grow



	LightDecay = 10, --Amount of light to consume per light decay tick

	LightDecayTime = 4, --Time in seconds before LightDecay light is taken from the plant

	LightDamageAmount = 1, --Amount of damage to deal to the plant when out of light

	LightDamageInterval = 2, --Time in seconds per damage event from lack of light

	LightRequirement = 0.25, --Min % of total possible light this plant needs to grow



	NutrientDecay = 3, --Amount of nutrients to consume per nutrient decay tick

	NutrientDecayTime = 35, --Time in seconds before NutrientDecay nutrients are taken from the plant

	NutrientDamageAmount = 1, --Amount of damage to deal to the plant when out of nutrients

	NutrientDamageInterval = 2, --Time in seconds per damage event from lack of nutrients

	NutrientRequirement = 0.25, --Min % of total possible nutrients this plant needs to grow

}



Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )

GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 2 } )



local Item = {}

Item.Name = "Fresh Cannabis (Low Quality)"

Item.Desc = "Low grade marijuana, ready to dry."

Item.Type = "type_drugs"

Item.Model = "models/freeman/drugbale_large.mdl"

Item.Weight = 1

Item.Volume = 1

Item.CanDrop = true

Item.Illegal = true

Item.LimitID = "fresh cannabis"



Item.DryingRackTime = 30

Item.DryingRackGiveItem = "Dry Cannabis (Low Quality)"



Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )

GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )



local Item = {}

Item.Name = "Dry Cannabis (Low Quality)"

Item.Desc = "Low grade marijuana, ready to trim."

Item.Type = "type_drugs"

Item.Model = "models/freeman/drugbale_large.mdl"

Item.Weight = 1

Item.Volume = 1

Item.CanDrop = true

Item.Illegal = true

Item.LimitID = "dry cannabis"



Item.TrimmerGiveItem = "Cannabis (Low Quality)"

Item.TrimmerGiveAmount = 4



Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )

GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )



local Item = {}

Item.Name = "Cannabis (Low Quality)"

Item.Desc = "Low grade marijuana"

Item.Type = "type_drugs"

Item.Model = "models/freeman/smalldrugbag.mdl"

Item.Weight = 1

Item.Volume = 1

Item.CanDrop = true

Item.CanUse = true

Item.Illegal = true

Item.LimitID = "cannabis"



Item.OnUse = function( _, pPlayer )

	GAMEMODE.Drugs:PlayerApplyEffect( pPlayer, "weed", 2 *60, 1 )

end

Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )

GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )



-- ----------------------------------------------------------------

-- Medium Quality Weed

-- ----------------------------------------------------------------

local Item = {}

Item.Name = "Cannabis Seeds (Medium Quality)"

Item.Desc = "A box of medium quality marijuana seeds."

Item.Type = "type_drugs"

Item.Model = "models/freeman/seedbox.mdl"

Item.Weight = 2

Item.Volume = 2

Item.CanDrop = true

Item.Illegal = true

Item.LimitID = "cannabis seeds"



--Vars used by the plant pot entity to configure growth params

Item.CanPlant = true

Item.DrugGrowthVars = {

	GrowModels = weedGrowModels, --Models for each growth stage

	GrowStageTime = 210, --Time between growth stages

	PlantHealth = 75,



	GiveItem = "Fresh Cannabis (Medium Quality)",

	GiveItemAmount = 2,



	WaterDecay = 5, --Amout of water to consume per water decay tick

	WaterDecayTime = 15, --Time in seconds before WaterDecay water is taken from the plant

	WaterDamageAmount = 1, --Amount of damage to deal to the plant when out of water

	WaterDamageInterval = 2, --Time in seconds per damage event from lack of water

	WaterRequirement = 0.33, --Min % of total possible water this plant needs to grow



	LightDecay = 10, --Amount of light to consume per light decay tick

	LightDecayTime = 4, --Time in seconds before LightDecay light is taken from the plant

	LightDamageAmount = 1, --Amount of damage to deal to the plant when out of light

	LightDamageInterval = 2, --Time in seconds per damage event from lack of light

	LightRequirement = 0.33, --Min % of total possible light this plant needs to grow



	NutrientDecay = 3, --Amount of nutrients to consume per nutrient decay tick

	NutrientDecayTime = 35, --Time in seconds before NutrientDecay nutrients are taken from the plant

	NutrientDamageAmount = 1, --Amount of damage to deal to the plant when out of nutrients

	NutrientDamageInterval = 2, --Time in seconds per damage event from lack of nutrients

	NutrientRequirement = 0.33, --Min % of total possible nutrients this plant needs to grow

}



Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "Fresh Cannabis (Medium Quality)"

Item.Desc = "Medium grade marijuana, ready to dry."

Item.Type = "type_drugs"

Item.Model = "models/freeman/drugbale_large.mdl"

Item.Weight = 1

Item.Volume = 1

Item.CanDrop = true

Item.Illegal = true

Item.LimitID = "fresh cannabis"



Item.DryingRackTime = 30

Item.DryingRackGiveItem = "Dry Cannabis (Medium Quality)"



Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "Dry Cannabis (Medium Quality)"

Item.Desc = "Medium grade marijuana, ready to trim."

Item.Type = "type_drugs"

Item.Model = "models/freeman/drugbale_large.mdl"

Item.Weight = 1

Item.Volume = 1

Item.CanDrop = true

Item.Illegal = true

Item.LimitID = "dry cannabis"



Item.TrimmerGiveItem = "Cannabis (Medium Quality)"

Item.TrimmerGiveAmount = 4



Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "Cannabis (Medium Quality)"

Item.Desc = "Medium grade marijuana"

Item.Type = "type_drugs"

Item.Model = "models/freeman/smalldrugbag.mdl"

Item.Weight = 1

Item.Volume = 1

Item.CanDrop = true

Item.CanUse = true

Item.Illegal = true

Item.LimitID = "cannabis"



Item.OnUse = function( _, pPlayer )

	GAMEMODE.Drugs:PlayerApplyEffect( pPlayer, "weed", 3 *60, 3 )

end

Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )





-- ----------------------------------------------------------------

-- High Quality Weed

-- ----------------------------------------------------------------

local Item = {}

Item.Name = "Cannabis Seeds (High Quality)"

Item.Desc = "A box of high quality marijuana seeds."

Item.Type = "type_drugs"

Item.Model = "models/freeman/seedbox.mdl"

Item.Weight = 2

Item.Volume = 2

Item.CanDrop = true

Item.Illegal = true

Item.LimitID = "cannabis seeds"



--Vars used by the plant pot entity to configure growth params

Item.CanPlant = true

Item.DrugGrowthVars = {

	GrowModels = weedGrowModels, --Models for each growth stage

	GrowStageTime = 210, --Time between growth stages

	PlantHealth = 50,



	GiveItem = "Fresh Cannabis (High Quality)",

	GiveItemAmount = 2,



	WaterDecay = 5, --Amout of water to consume per water decay tick

	WaterDecayTime = 15, --Time in seconds before WaterDecay water is taken from the plant

	WaterDamageAmount = 1, --Amount of damage to deal to the plant when out of water

	WaterDamageInterval = 2, --Time in seconds per damage event from lack of water

	WaterRequirement = 0.525, --Min % of total possible water this plant needs to grow



	LightDecay = 10, --Amount of light to consume per light decay tick

	LightDecayTime = 4, --Time in seconds before LightDecay light is taken from the plant

	LightDamageAmount = 1, --Amount of damage to deal to the plant when out of light

	LightDamageInterval = 2, --Time in seconds per damage event from lack of light

	LightRequirement = 0.525, --Min % of total possible light this plant needs to grow



	NutrientDecay = 3, --Amount of nutrients to consume per nutrient decay tick

	NutrientDecayTime = 35, --Time in seconds before NutrientDecay nutrients are taken from the plant

	NutrientDamageAmount = 1, --Amount of damage to deal to the plant when out of nutrients

	NutrientDamageInterval = 2, --Time in seconds per damage event from lack of nutrients

	NutrientRequirement = 0.525, --Min % of total possible nutrients this plant needs to grow

}



Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "Fresh Cannabis (High Quality)"

Item.Desc = "High grade marijuana, ready to dry."

Item.Type = "type_drugs"

Item.Model = "models/freeman/drugbale_large.mdl"

Item.Weight = 1

Item.Volume = 1

Item.CanDrop = true

Item.Illegal = true

Item.LimitID = "fresh cannabis"



Item.DryingRackTime = 30

Item.DryingRackGiveItem = "Dry Cannabis (High Quality)"



Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "Dry Cannabis (High Quality)"

Item.Desc = "High grade marijuana, ready to trim."

Item.Type = "type_drugs"

Item.Model = "models/freeman/drugbale_large.mdl"

Item.Weight = 1

Item.Volume = 1

Item.CanDrop = true

Item.Illegal = true

Item.LimitID = "dry cannabis"



Item.TrimmerGiveItem = "Cannabis (High Quality)"

Item.TrimmerGiveAmount = 4



Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "Cannabis (High Quality)"

Item.Desc = "High grade marijuana"

Item.Type = "type_drugs"

Item.Model = "models/freeman/smalldrugbag.mdl"

Item.Weight = 1

Item.Volume = 1

Item.CanDrop = true

Item.CanUse = true

Item.Illegal = true

Item.LimitID = "cannabis"



Item.OnUse = function( _, pPlayer )

	GAMEMODE.Drugs:PlayerApplyEffect( pPlayer, "weed", 3.5 *60, 5 )

end

Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )





--[[ Weed Effect ]]--

local weedEffect = {}

weedEffect.Name = "weed"

weedEffect.NiceName = "Cannabis"

weedEffect.MaxPower = 50



function weedEffect:OnStart( pPlayer )

	if SERVER then

		pPlayer:EmitSound( "ambient/voices/cough".. math.random(1, 4)..".wav", 75, 95 )

		pPlayer:ViewPunch( Angle(math.random(6, 12), 0, 0) )

	end

end



function weedEffect:OnStop( pPlayer )

end



if CLIENT then

	function weedEffect:RenderScreenspaceEffects()

		local pow = math.min( GAMEMODE.Drugs:GetEffectPower(self.Name), self.MaxPower )

		local darkenMin = 0.5

		local darkenMax = 0.33

		local darken = Lerp( pow /self.MaxPower, darkenMin, darkenMax )



		DrawBloom(

			darken,

			1.3,

			10,

			10,

			1,

			1.3,

			1,

			1,

			1

		)

		DrawToyTown( Lerp(pow /self.MaxPower, 1, 3), ScrH() *Lerp(pow /self.MaxPower, 0.5, 1) )

	end



	function weedEffect:GetMotionBlurValues( intW, intH, intForward, intRot )

		local pow = math.min( GAMEMODE.Drugs:GetEffectPower(self.Name), self.MaxPower )

		local speed = Lerp( pow /self.MaxPower, 0, 5 )

		local strength = Lerp( pow /self.MaxPower, 0.01, 0.1 )

		intRot = intRot +math.sin( CurTime() *speed ) *strength

		return intW, intH, intForward, intRot

	end

end



weedEffect.PacOutfit = "drug_weed"

weedEffect.PacOutfitSlot = {

	Name = "int_drug_weed",

	Data = {

		Type = "GAMEMODE_INTERNAL_PAC_ONLY",

		Internal = true,

		KeepOnDeath = false,

		PacEnabled = true,

	},

}

GM.PacModels:Register( weedEffect.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

				},

				["self"] = {

					["Velocity"] = 5,

					["UniqueID"] = "1447211353",

					["StickToSurface"] = false,

					["EndSize"] = 40,

					["Material"] = "particle/particle_smokegrenade1",

					["NumberParticles"] = 6,

					["AirResistance"] = 20,

					["RandomColour"] = false,

					["Collide"] = false,

					["Position"] = Vector(0.62043762207031, -6.2371215820313, 0.0017318725585938),

					["Sliding"] = false,

					["DieTime"] = 20,

					["Lighting"] = false,

					["AlignToSurface"] = false,

					["RandomRollSpeed"] = 0.1,

					["Bounce"] = 0,

					["ClassName"] = "particles",

					["FireDelay"] = 20,

					["Spread"] = 0.8,

					["Gravity"] = Vector(0, 0, 0.80000001192093),

					["Angles"] = Angle(9.3488211859949e-005, -84.328323364258, -2.4172466510208e-005),

					["StartSize"] = 0,

					["RollDelta"] = 0.2,

				},

			},

			[2] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Angles"] = Angle(-90, -0.00044594760402106, 0.00046106442459859),

							["ClassName"] = "clip",

							["UniqueID"] = "2534860599",

							["Position"] = Vector(0.0009307861328125, -0.0106201171875, -0.82891845703125),

						},

					},

					[2] = {

						["children"] = {

							[1] = {

								["children"] = {

								},

								["self"] = {

									["ClassName"] = "effect",

									["UniqueID"] = "314179253",

									["Effect"] = "barrel_smoke_trailb",

								},

							},

						},

						["self"] = {

							["UniqueID"] = "2451388655",

							["Name"] = "cherry",

							["Scale"] = Vector(1, 1, 0.10000000149012),

							["ClassName"] = "model",

							["Size"] = 0.09,

							["Material"] = "models/weapons/v_crossbow/rebar_glow",

							["Position"] = Vector(0, 0, 0.0099999997764826),

							["Model"] = "models/props_junk/PopCan01a.mdl",

							["EditorExpand"] = true,

						},

					},

					[3] = {

						["children"] = {

						},

						["self"] = {

							["UniqueID"] = "3577223228",

							["Name"] = "ash",

							["Scale"] = Vector(1, 1, 0.30000001192093),

							["ClassName"] = "model",

							["Size"] = 0.1,

							["Material"] = "models/props_canal/rock_riverbed01a",

							["Position"] = Vector(0, 0, 0.10000000149012),

							["Model"] = "models/props_junk/PopCan01a.mdl",

							["EditorExpand"] = true,

						},

					},

				},

				["self"] = {

					["UniqueID"] = "1785750490",

					["Name"] = "blunt",

					["Scale"] = Vector(1, 1, 9.6999998092651),

					["EditorExpand"] = true,

					["Size"] = 0.1,

					["ClassName"] = "model",

					["Angles"] = Angle(0.85738605260849, 3.4882729053497, -107.416015625),

					["Position"] = Vector(1.0161743164063, -8.7052612304688, 1.4518127441406),

					["Model"] = "models/props_junk/PopCan01a.mdl",

					["Material"] = "models/props_pipes/GutterMetal01a",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "571262028",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )



GM.PacModels:Register( "female_".. weedEffect.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

				},

				["self"] = {

					["Velocity"] = 5,

					["UniqueID"] = "1447211353",

					["StickToSurface"] = false,

					["EndSize"] = 40,

					["Material"] = "particle/particle_smokegrenade1",

					["NumberParticles"] = 6,

					["AirResistance"] = 20,

					["RandomColour"] = false,

					["Collide"] = false,

					["Position"] = Vector(-0.20269775390625, -5.9537353515625, 0.00201416015625),

					["Sliding"] = false,

					["DieTime"] = 20,

					["Lighting"] = false,

					["AlignToSurface"] = false,

					["RandomRollSpeed"] = 0.1,

					["Bounce"] = 0,

					["ClassName"] = "particles",

					["FireDelay"] = 20,

					["Spread"] = 0.8,

					["Gravity"] = Vector(0, 0, 0.80000001192093),

					["Angles"] = Angle(7.8547178418376e-005, -92.67830657959, -4.6317221858772e-005),

					["StartSize"] = 0,

					["RollDelta"] = 0.2,

				},

			},

			[2] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Angles"] = Angle(-90, -0.00044594760402106, 0.00046106442459859),

							["ClassName"] = "clip",

							["UniqueID"] = "2534860599",

							["Position"] = Vector(0.0009307861328125, -0.0106201171875, -0.82891845703125),

						},

					},

					[2] = {

						["children"] = {

							[1] = {

								["children"] = {

								},

								["self"] = {

									["ClassName"] = "effect",

									["UniqueID"] = "263057254",

									["Effect"] = "barrel_smoke_trailb",

								},

							},

						},

						["self"] = {

							["UniqueID"] = "2451388655",

							["Name"] = "cherry",

							["Scale"] = Vector(1, 1, 0.10000000149012),

							["ClassName"] = "model",

							["Size"] = 0.09,

							["Material"] = "models/weapons/v_crossbow/rebar_glow",

							["Position"] = Vector(0, 0, 0.0099999997764826),

							["Model"] = "models/props_junk/PopCan01a.mdl",

							["EditorExpand"] = true,

						},

					},

					[3] = {

						["children"] = {

						},

						["self"] = {

							["UniqueID"] = "3577223228",

							["Name"] = "ash",

							["Scale"] = Vector(1, 1, 0.30000001192093),

							["ClassName"] = "model",

							["Size"] = 0.1,

							["Material"] = "models/props_canal/rock_riverbed01a",

							["Position"] = Vector(0, 0, 0.10000000149012),

							["Model"] = "models/props_junk/PopCan01a.mdl",

							["EditorExpand"] = true,

						},

					},

				},

				["self"] = {

					["UniqueID"] = "1785750490",

					["Name"] = "blunt",

					["Scale"] = Vector(1, 1, 9.6999998092651),

					["EditorExpand"] = true,

					["Size"] = 0.1,

					["ClassName"] = "model",

					["Angles"] = Angle(0.85738265514374, 3.4882907867432, -111.07164001465),

					["Position"] = Vector(0.17916870117188, -8.2879028320313, 1.5643615722656),

					["Model"] = "models/props_junk/PopCan01a.mdl",

					["Material"] = "models/props_pipes/GutterMetal01a",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "788241134",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.PacModels:RegisterOutfitModelOverload( weedEffect.PacOutfit, GM.Config.PlayerModels.Female, "female_".. weedEffect.PacOutfit )



GM.PacModels:Register( "m04".. weedEffect.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Angles"] = Angle(-90, -0.00044594760402106, 0.00046106442459859),

							["ClassName"] = "clip",

							["UniqueID"] = "2534860599",

							["Position"] = Vector(0.0009307861328125, -0.0106201171875, -0.82891845703125),

						},

					},

					[2] = {

						["children"] = {

							[1] = {

								["children"] = {

								},

								["self"] = {

									["ClassName"] = "effect",

									["UniqueID"] = "833359847",

									["Effect"] = "barrel_smoke_trailb",

								},

							},

						},

						["self"] = {

							["UniqueID"] = "2451388655",

							["Name"] = "cherry",

							["Scale"] = Vector(1, 1, 0.10000000149012),

							["ClassName"] = "model",

							["Size"] = 0.09,

							["Material"] = "models/weapons/v_crossbow/rebar_glow",

							["Position"] = Vector(0, 0, 0.0099999997764826),

							["Model"] = "models/props_junk/PopCan01a.mdl",

							["EditorExpand"] = true,

						},

					},

					[3] = {

						["children"] = {

						},

						["self"] = {

							["UniqueID"] = "3577223228",

							["Name"] = "ash",

							["Scale"] = Vector(1, 1, 0.30000001192093),

							["ClassName"] = "model",

							["Size"] = 0.1,

							["Material"] = "models/props_canal/rock_riverbed01a",

							["Position"] = Vector(0, 0, 0.10000000149012),

							["Model"] = "models/props_junk/PopCan01a.mdl",

							["EditorExpand"] = true,

						},

					},

				},

				["self"] = {

					["UniqueID"] = "1785750490",

					["Name"] = "blunt",

					["Scale"] = Vector(1, 1, 9.6999998092651),

					["EditorExpand"] = true,

					["Size"] = 0.1,

					["ClassName"] = "model",

					["Angles"] = Angle(0.857386469841, 3.4882705211639, -111.1372756958),

					["Position"] = Vector(1.4902954101563, -8.3141479492188, 1.6209411621094),

					["Model"] = "models/props_junk/PopCan01a.mdl",

					["Material"] = "models/props_pipes/GutterMetal01a",

				},

			},

			[2] = {

				["children"] = {

				},

				["self"] = {

					["Velocity"] = 5,

					["UniqueID"] = "1447211353",

					["StickToSurface"] = false,

					["EndSize"] = 40,

					["Material"] = "particle/particle_smokegrenade1",

					["NumberParticles"] = 6,

					["AirResistance"] = 20,

					["RandomColour"] = false,

					["Collide"] = false,

					["Position"] = Vector(0.62043762207031, -6.2371215820313, 0.0017318725585938),

					["Sliding"] = false,

					["DieTime"] = 20,

					["Lighting"] = false,

					["AlignToSurface"] = false,

					["RandomRollSpeed"] = 0.1,

					["Bounce"] = 0,

					["ClassName"] = "particles",

					["FireDelay"] = 20,

					["Spread"] = 0.8,

					["Gravity"] = Vector(0, 0, 0.80000001192093),

					["Angles"] = Angle(9.3488211859949e-005, -84.328323364258, -2.4172466510208e-005),

					["StartSize"] = 0,

					["RollDelta"] = 0.2,

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "571262028",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.PacModels:RegisterOutfitFaceIDOverload( weedEffect.PacOutfit, "male_04", "m04".. weedEffect.PacOutfit )



GM.Drugs:RegisterEffect( weedEffect )


-- MEDICAL MARIJUANA


local Item = {}

Item.Name = "Medical Marijuana"

Item.Desc = "Medical grade marijuana"

Item.Type = "type_drugs"

Item.Model = "models/freeman/smalldrugbag.mdl"

Item.Weight = 1

Item.Volume = 1

Item.CanDrop = true

Item.CanUse = true

Item.Illegal = true

Item.LimitID = "cannabis"



Item.OnUse = function( _, pPlayer )

	GAMEMODE.Drugs:PlayerApplyEffect( pPlayer, "weed", 3 *60, 3 )

	pPlayer:SetHealth( pPlayer:GetMaxHealth() )

end

Item.SetupEntity = function( _, eEnt )

	eEnt.CanPlayerPickup = Item.CanPlayerPickup

	eEnt.CanPlayerUse = Item.CanPlayerUse

end

Item.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

Item.CanPlayerUse = function( eEnt, pPlayer, bCanUse )

	return true --Anyone can take drugs!

end

GM.Inv:RegisterItem( Item )
