--[[
	Name: drugs_meth.lua
	For: TalosLife
	By: TalosLife
]]--

local Item = {}
Item.Name = "Drug Lab"
Item.Desc = "A lab for processing chemicals and heating compounds."
Item.Type = "type_drugs"
Item.Model = "models/props/CS_militia/table_shed.mdl"
Item.Weight = 65
Item.Volume = 60
Item.HealthOverride = 2500
Item.CanDrop = true
Item.Illegal = true
Item.DropClass = "ent_drug_lab"
Item.LimitID = "drug lab"

Item.CraftingEntClass = "ent_crafting_table"
Item.CraftingTab = "Machines"
Item.CraftSkill = "Crafting"
Item.CraftSkillLevel = 1
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Wood Plank"] = 10,
	["Metal Bracket"] = 8,
	["Metal Plate"] = 6,
	["Metal Pipe"] = 3,
	["Chunk of Plastic"] = 5,
	["Car Battery"] = 1,
	["Circular Saw"] = 1,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Still"
Item.Desc = "A large still used to separate and condense chemicals."
Item.Type = "type_drugs"
Item.Model = "models/props_pipes/valve002.mdl"
Item.Weight = 65
Item.Volume = 60
Item.HealthOverride = 1500
Item.CanDrop = true
Item.Illegal = true
Item.DropClass = "ent_still"
Item.LimitID = "still"

Item.CraftingEntClass = "ent_crafting_table"
Item.CraftingTab = "Machines"
Item.CraftSkill = "Crafting"
Item.CraftSkillLevel = 1
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Bracket"] = 15,
	["Metal Plate"] = 10,
	["Metal Pipe"] = 15,
	["Chunk of Plastic"] = 4,
	["Car Battery"] = 1,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Chemical Reaction Chamber"
Item.Desc = "A large lab-grade reaction chamber."
Item.Type = "type_drugs"
Item.Model = "models/props_wasteland/laundry_washer001a.mdl"
Item.Weight = 65
Item.Volume = 60
Item.HealthOverride = 3000
Item.CanDrop = true
Item.Illegal = true
Item.DropClass = "ent_reaction_chamber"
Item.LimitID = "reaction chamber"

Item.CraftingEntClass = "ent_crafting_table"
Item.CraftingTab = "Machines"
Item.CraftSkill = "Crafting"
Item.CraftSkillLevel = 1
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Bracket"] = 15,
	["Metal Plate"] = 20,
	["Metal Pipe"] = 15,
	["Chunk of Plastic"] = 10,
	["Car Battery"] = 2,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1, { ["vip"] = 1 } )

--Drug components
local Item = {}
Item.Name = "Aluminum Foil"
Item.Desc = "A sheet of aluminum foil."
Item.Model = "models/gibs/glass_shard02.mdl"
Item.Weight = 2
Item.Volume = 6
Item.CanDrop = true
Item.LimitID = "aluminum foil"
Item.DrugLab_BlenderVars = {
	BlendProgress = 10,
	BlendAmountPerTick = 0.1,
	GiveItem = "Aluminum Powder",
	GiveAmount = 2,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Aluminum Powder"
Item.Desc = "A jar of powdered aluminum metal."
Item.Model = "models/props_lab/jar01b.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = true
Item.LimitID = "aluminum powder"
Item.DropClass = "ent_fluid_aluminum_powder"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Red Phosphorous"
Item.Desc = "A box of red phosphorous."
Item.Type = "type_drugs"
Item.Model = "models/props_lab/box01a.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = true
Item.CanCook = true
Item.LimitID = "red phosphorous"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 3, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Cleaning Solution"
Item.Desc = "A bottle of ammonia-based cleaning solution."
Item.Model = "models/props_junk/garbage_plasticbottle002a.mdl"
Item.Weight = 6
Item.Volume = 4
Item.CanDrop = true
Item.LimitID = "cleaning solution"
Item.DropClass = "ent_fluid_ammonia"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Methylamine"
Item.Desc = "A jar of the compound methylamine, an illegal methamphetamine precursor."
Item.Type = "type_drugs"
Item.Model = "models/props_lab/jar01b.mdl"
Item.Weight = 5
Item.Volume = 5
Item.CanDrop = true
Item.Illegal = true
Item.DropClass = "ent_fluid_methylamine"
Item.LimitID = "methylamine"

Item.ReactionChamberVars = {
	Mats = { --Items needed to make a single MakeAmount of the output fluid
		["Ammonia"] = 1,
		["Methanol"] = 2,
		["Aluminum Powder"] = 1,
	},
	Interval = 0.75, --Interval
	MakeAmount = 2, --Amount of fluid to make per interval
	MinGiveAmount = 500, --Amount of the output fluid needed to give a player an item
	GiveItem = "Methylamine",
	GiveAmount = 1,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Methanol"
Item.Desc = "A jar of methanol."
Item.Type = "type_drugs"
Item.Model = "models/props_lab/jar01b.mdl"
Item.Weight = 5
Item.Volume = 3
Item.CanDrop = true
Item.DropClass = "ent_fluid_methanol"
Item.LimitID = "methanol"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Phenylacetic Acid"
Item.Desc = "A jar of phenylacetic acid, an illegal drug precursor."
Item.Type = "type_drugs"
Item.Model = "models/props_lab/jar01b.mdl"
Item.Weight = 5
Item.Volume = 3
Item.CanDrop = true
Item.Illegal = true
Item.DropClass = "ent_fluid_phenylacetic_acid"
Item.LimitID = "phenylacetic acid"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Acetic Acid"
Item.Desc = "A jar of acetic acid, an illegal drug precursor."
Item.Type = "type_drugs"
Item.Model = "models/props_lab/jar01b.mdl"
Item.Weight = 5
Item.Volume = 3
Item.CanDrop = true
Item.Illegal = true
Item.DropClass = "ent_fluid_acetic_acid"
Item.LimitID = "acetic acid"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Phenylacetone"
Item.Desc = "A jar of the compound phenylacetone, an illegal methamphetamine precursor."
Item.Type = "type_drugs"
Item.Model = "models/props_lab/jar01b.mdl"
Item.Weight = 5
Item.Volume = 3
Item.CanDrop = true
Item.Illegal = true
Item.DropClass = "ent_fluid_phenylacetone"
Item.LimitID = "phenylacetone"

Item.CookingPotVars = {
	Skill = "Chemistry",
	SkillWeight = 0.32, --max % to remove from the score in the worst case

	--Only displayed if over time explode/fire are both off and item is grabbed before it reaches the max time cap
	--anything catches fire past the max time cap (set in the cooking pot shared file)
	OverCookMsg = "You overcooked it! This batch is ruined!",
	OverTimeExplode = true, --Explode and start a fire if the item goes over max time
	OverTimeStartFire = false, --Start a fire if the item goes over max time

	MinTime = 10,
	MaxTime = 90,
	TimeWeight = -0.85, --the closer this number is to 0, the less impact time has on the end score (-4 = 0/100% impact do not go below)
	IdealTimePercent = 0.7, --% from min to max time to consider ideal

	Items = {},
	Fluids = {
		["Acetic Acid"] = { IdealAmount = 400, MaxAmount = 500, MinAmount = 300 },
		["Phenylacetic Acid"] = { IdealAmount = 325, MaxAmount = 450, MinAmount = 250 },
		["Aluminum Powder"] = { IdealAmount = 175, MaxAmount = 250, MinAmount = 100 },
	},
	GiveItems = { --In order from low quality to high quality (enter only 1 for no quality)
		{ MinQuality = 0, GiveItem = "Phenylacetone", GiveAmount = 1 },
		{ MinQuality = 0.66, GiveItem = "Phenylacetone", GiveAmount = 2 },
		{ MinQuality = 0.9, GiveItem = "Phenylacetone", GiveAmount = 4 },
	},
	GiveXP = { --In order from 0 score up
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.66, GiveAmount = 6 },
		{ MinQuality = 0.9, GiveAmount = 7 },
	}
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )


--Drug items
local Item = {}
Item.Name = "Methamphetamine (Low Quality)"
Item.Desc = "A bag of low quality crystal methamphetamine."
Item.Type = "type_drugs"
Item.Model = "models/weapons/w_package.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.Illegal = true
Item.LimitID = "methamphetamine"

Item.OnUse = function( _, pPlayer )
	GAMEMODE.Drugs:PlayerApplyEffect( pPlayer, "meth", 1 *60, 1 )
	GAMEMODE.Needs:AddPlayerNeed( pPlayer, "Stamina", 25 )
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
Item.CookingPotVars = {
	Skill = "Chemistry",
	SkillWeight = 0.39, --max % to remove from the score in the worst case

	--Only displayed if over time explode/fire are both off and item is grabbed before it reaches the max time cap
	--anything catches fire past the max time cap (set in the cooking pot shared file)
	OverCookMsg = "You overcooked it! This batch is ruined!",
	OverTimeExplode = true, --Explode and start a fire if the item goes over max time
	OverTimeStartFire = false, --Start a fire if the item goes over max time

	MinTime = 10,
	MaxTime = 90,
	TimeWeight = -0.85, --the closer this number is to 0, the less impact time has on the end score (-4 = 0/100% impact do not go below)
	IdealTimePercent = 0.66, --% from min to max time to consider ideal

	Items = {
		["Red Phosphorous"] = { IdealAmount = 3, MaxAmount = 4, MinAmount = 1 }
	},
	Fluids = {
		["Phenylacetone"] = { IdealAmount = 350, MaxAmount = 425, MinAmount = 200 },
		["Methylamine"] = { IdealAmount = 400, MaxAmount = 500, MinAmount = 325 },
		["Water"] = { IdealAmount = 100, MaxAmount = 250, MinAmount = 25 }
	},
	GiveItems = { --In order from low quality to high quality (enter only 1 for no quality)
		{ MinQuality = 0, GiveItem = "Methamphetamine (Low Quality)", GiveAmount = 4 },
		{ MinQuality = 0.61, GiveItem = "Methamphetamine (Medium Quality)", GiveAmount = 6 },
		{ MinQuality = 0.825, GiveItem = "Methamphetamine (High Quality)", GiveAmount = 8 },
	},
	GiveXP = { --In order from 0 score up
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.61, GiveAmount = 7 },
		{ MinQuality = 0.825, GiveAmount = 9 },
	}
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )

local Item = {}
Item.Name = "Methamphetamine (Medium Quality)"
Item.Desc = "A bag of medium quality crystal methamphetamine."
Item.Type = "type_drugs"
Item.Model = "models/weapons/w_package.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.Illegal = true
Item.LimitID = "methamphetamine"

Item.OnUse = function( _, pPlayer )
	GAMEMODE.Drugs:PlayerApplyEffect( pPlayer, "meth", 2 *60, 2 )
	GAMEMODE.Needs:AddPlayerNeed( pPlayer, "Stamina", 50 )
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

local Item = {}
Item.Name = "Methamphetamine (High Quality)"
Item.Desc = "A bag of high quality crystal methamphetamine."
Item.Type = "type_drugs"
Item.Model = "models/weapons/w_package.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.Illegal = true
Item.LimitID = "methamphetamine"

Item.OnUse = function( _, pPlayer )
	GAMEMODE.Drugs:PlayerApplyEffect( pPlayer, "meth", 4 *60, 4 )
	GAMEMODE.Needs:AddPlayerNeed( pPlayer, "Stamina", 75 )
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


--[[ Meth Effect ]]--
local methEffect = {}
methEffect.Name = "meth"
methEffect.NiceName = "Methamphetamine"
methEffect.MaxPower = 25

function methEffect:OnStart( pPlayer )
	if CLIENT then return end
	pPlayer:EmitSound( "ambient/voices/cough".. math.random(1, 4)..".wav", 75, 95 )
	pPlayer:ViewPunch( Angle(math.random(6, 12), 0, 0) )

	local scalar = math.Clamp( (self.MaxPower -GAMEMODE.Drugs:GetPlayerEffectPower(pPlayer, self.Name)) /self.MaxPower, 0, 1 )
	GAMEMODE.Player:ModifyMoveSpeed( pPlayer, "MethSpeed", 0, Lerp(scalar, 50, 0) )

	if GAMEMODE.Drugs:GetPlayerEffectPower( pPlayer, self.Name ) >= self.MaxPower then
		if not pPlayer:IsUncon() then
			pPlayer:GoUncon()
		end
	end
end

function methEffect:OnStop( pPlayer )
	if CLIENT then return end
	
	if GAMEMODE.Drugs:GetPlayerEffectPower( pPlayer, self.Name ) <= 0 then
		if GAMEMODE.Player:IsMoveSpeedModifierActive( pPlayer, "MethSpeed" ) then
			GAMEMODE.Player:RemoveMoveSpeedModifier( pPlayer, "MethSpeed" )
		end
	end
end

if CLIENT then
	function methEffect:RenderScreenspaceEffects()
		local pow = math.min( GAMEMODE.Drugs:GetEffectPower(self.Name), self.MaxPower )
		local darkenMin = 0.8
		local darkenMax = 0.66
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

	function methEffect:GetMotionBlurValues( intW, intH, intForward, intRot )
		local pow = math.min( GAMEMODE.Drugs:GetEffectPower(self.Name), self.MaxPower )
		return intW, intH, Lerp( pow /self.MaxPower, 0, 1 ), intRot
	end
end

methEffect.PacOutfit = "drug_meth"
methEffect.PacOutfitSlot = {
	Name = "int_drug_meth",
	Data = {
		Type = "GAMEMODE_INTERNAL_PAC_ONLY",
		Internal = true,
		KeepOnDeath = false,
		PacEnabled = true,
	},
}
GM.PacModels:Register( methEffect.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Velocity"] = 2,
					["UniqueID"] = "3860556725",
					["EndSize"] = 30,
					["Material"] = "particle/particle_smokegrenade",
					["NumberParticles"] = 2,
					["AirResistance"] = 10,
					["RandomColour"] = false,
					["Collide"] = false,
					["Position"] = Vector(0.81370544433594, -6.7429809570313, 0.00140380859375),
					["Sliding"] = false,
					["Lighting"] = false,
					["FireDelay"] = 22,
					["DieTime"] = 10,
					["ClassName"] = "particles",
					["Bounce"] = 0,
					["Spread"] = 0.4,
					["Gravity"] = Vector(0, 0, 1),
					["Angles"] = Angle(7.8120283433236e-005, -87.789237976074, -2.5506487872917e-005),
					["StartSize"] = 0,
					["RollDelta"] = -0.2,
				},
			},
			[2] = {
				["children"] = {
					[1] = {
						["children"] = {
						},
						["self"] = {
							["Angles"] = Angle(-90, 0, 0),
							["ClassName"] = "clip",
							["UniqueID"] = "2985885681",
							["Position"] = Vector(-0.0020904541015625, 0.00567626953125, -2.2859497070313),
						},
					},
					[2] = {
						["children"] = {
							[1] = {
								["children"] = {
								},
								["self"] = {
									["Angles"] = Angle(0, 180, 0),
									["ClassName"] = "clip",
									["UniqueID"] = "2566512536",
									["Position"] = Vector(1.5040740966797, -0.004364013671875, -0.00775146484375),
								},
							},
							[2] = {
								["children"] = {
								},
								["self"] = {
									["UniqueID"] = "3890718453",
									["TintColor"] = Vector(255, 255, 255),
									["Model"] = "models/props_mining/caverocks_cluster01.mdl",
									["Name"] = "meth",
									["Scale"] = Vector(0.69999998807907, 0.69999998807907, 0.30000001192093),
									["Size"] = 0.01,
									["ClassName"] = "model",
									["DoubleFace"] = true,
									["EditorExpand"] = true,
									["Position"] = Vector(-0.34999999403954, 0, 0),
									["Angles"] = Angle(-90, 0, 0),
									["Brightness"] = 1.1,
									["Material"] = "models/props/cs_office/snowmana",
								},
							},
							[3] = {
								["children"] = {
								},
								["self"] = {
									["Angles"] = Angle(90, 0, 0),
									["ClassName"] = "clip",
									["UniqueID"] = "1306617473",
									["Position"] = Vector(0, 0, 1.4800000190735),
								},
							},
							[4] = {
								["children"] = {
								},
								["self"] = {
									["Position"] = Vector(0.42996215820313, 0.0185546875, -0.0185546875),
									["ClassName"] = "effect",
									["UniqueID"] = "3877593657",
									["Effect"] = "barrel_smoke_trailb",
								},
							},
						},
						["self"] = {
							["Position"] = Vector(-0.0006103515625, 0.00299072265625, -1.7405395507813),
							["Name"] = "bowl",
							["Alpha"] = 0.65,
							["ClassName"] = "model",
							["DoubleFace"] = true,
							["UniqueID"] = "1682371200",
							["Size"] = 0.037,
							["Material"] = "models/debug/debugwhite",
							["Model"] = "models/XQM/Rails/gumball_1.mdl",
							["EditorExpand"] = true,
						},
					},
				},
				["self"] = {
					["UniqueID"] = "1447719391",
					["Model"] = "models/props_junk/PopCan01a.mdl",
					["Size"] = 0.15,
					["Name"] = "pipe",
					["Scale"] = Vector(1, 1, 3.0999999046326),
					["Alpha"] = 0.85,
					["ClassName"] = "model",
					["DoubleFace"] = true,
					["EditorExpand"] = true,
					["Position"] = Vector(0.86341094970703, -7.2188720703125, -0.11407470703125),
					["Angles"] = Angle(0, 0, -90),
					["Brightness"] = 10.7,
					["Material"] = "models/props_combine/health_charger_glass",
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "2340012506",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )

GM.PacModels:Register( "female_".. methEffect.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
					[1] = {
						["children"] = {
							[1] = {
								["children"] = {
								},
								["self"] = {
									["UniqueID"] = "3890718453",
									["TintColor"] = Vector(255, 255, 255),
									["Model"] = "models/props_mining/caverocks_cluster01.mdl",
									["Name"] = "meth",
									["Scale"] = Vector(0.69999998807907, 0.69999998807907, 0.30000001192093),
									["Size"] = 0.01,
									["ClassName"] = "model",
									["DoubleFace"] = true,
									["EditorExpand"] = true,
									["Position"] = Vector(-0.34999999403954, 0, 0),
									["Angles"] = Angle(-90, 0, 0),
									["Brightness"] = 1.1,
									["Material"] = "models/props/cs_office/snowmana",
								},
							},
							[2] = {
								["children"] = {
								},
								["self"] = {
									["Angles"] = Angle(0, 180, 0),
									["ClassName"] = "clip",
									["UniqueID"] = "2566512536",
									["Position"] = Vector(1.5040740966797, -0.004364013671875, -0.00775146484375),
								},
							},
							[3] = {
								["children"] = {
								},
								["self"] = {
									["Angles"] = Angle(90, 0, 0),
									["ClassName"] = "clip",
									["UniqueID"] = "1306617473",
									["Position"] = Vector(0, 0, 1.4800000190735),
								},
							},
							[4] = {
								["children"] = {
								},
								["self"] = {
									["Effect"] = "barrel_smoke_trailb",
									["ClassName"] = "effect",
									["UniqueID"] = "4083499796",
									["Angles"] = Angle(2.2598509788513, 9.3988192020333e-006, 1.7088761524064e-005),
								},
							},
						},
						["self"] = {
							["Position"] = Vector(-0.0006103515625, 0.00299072265625, -1.7405395507813),
							["Name"] = "bowl",
							["Alpha"] = 0.65,
							["ClassName"] = "model",
							["DoubleFace"] = true,
							["UniqueID"] = "1682371200",
							["Size"] = 0.037,
							["Material"] = "models/debug/debugwhite",
							["Model"] = "models/XQM/Rails/gumball_1.mdl",
							["EditorExpand"] = true,
						},
					},
					[2] = {
						["children"] = {
						},
						["self"] = {
							["Angles"] = Angle(-90, 0, 0),
							["ClassName"] = "clip",
							["UniqueID"] = "2985885681",
							["Position"] = Vector(-0.0020904541015625, 0.00567626953125, -2.2859497070313),
						},
					},
				},
				["self"] = {
					["UniqueID"] = "1447719391",
					["Model"] = "models/props_junk/PopCan01a.mdl",
					["Size"] = 0.15,
					["Name"] = "pipe",
					["Scale"] = Vector(1, 1, 3.0999999046326),
					["Alpha"] = 0.85,
					["ClassName"] = "model",
					["DoubleFace"] = true,
					["EditorExpand"] = true,
					["Position"] = Vector(0.00897216796875, -6.914306640625, 0.0350341796875),
					["Angles"] = Angle(0, 0, -90),
					["Brightness"] = 10.7,
					["Material"] = "models/props_combine/health_charger_glass",
				},
			},
			[2] = {
				["children"] = {
				},
				["self"] = {
					["Velocity"] = 2,
					["UniqueID"] = "3860556725",
					["EndSize"] = 30,
					["Material"] = "particle/particle_smokegrenade",
					["NumberParticles"] = 2,
					["AirResistance"] = 10,
					["RandomColour"] = false,
					["Collide"] = false,
					["Position"] = Vector(0.027557373046875, -6.77294921875, 0.00140380859375),
					["Sliding"] = false,
					["Lighting"] = false,
					["FireDelay"] = 22,
					["DieTime"] = 10,
					["ClassName"] = "particles",
					["Bounce"] = 0,
					["Spread"] = 0.4,
					["Gravity"] = Vector(0, 0, 1),
					["Angles"] = Angle(7.8120283433236e-005, -87.789237976074, -2.5506487872917e-005),
					["StartSize"] = 0,
					["RollDelta"] = -0.2,
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "2340012506",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )
GM.PacModels:RegisterOutfitModelOverload( methEffect.PacOutfit, GM.Config.PlayerModels.Female, "female_".. methEffect.PacOutfit )

GM.PacModels:Register( "m04".. methEffect.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
					[1] = {
						["children"] = {
							[1] = {
								["children"] = {
								},
								["self"] = {
									["UniqueID"] = "3890718453",
									["TintColor"] = Vector(255, 255, 255),
									["Model"] = "models/props_mining/caverocks_cluster01.mdl",
									["Name"] = "meth",
									["Scale"] = Vector(0.69999998807907, 0.69999998807907, 0.30000001192093),
									["Size"] = 0.01,
									["ClassName"] = "model",
									["DoubleFace"] = true,
									["EditorExpand"] = true,
									["Position"] = Vector(-0.34999999403954, 0, 0),
									["Angles"] = Angle(-90, 0, 0),
									["Brightness"] = 1.1,
									["Material"] = "models/props/cs_office/snowmana",
								},
							},
							[2] = {
								["children"] = {
								},
								["self"] = {
									["Angles"] = Angle(0, 180, 0),
									["ClassName"] = "clip",
									["UniqueID"] = "2566512536",
									["Position"] = Vector(1.5040740966797, -0.004364013671875, -0.00775146484375),
								},
							},
							[3] = {
								["children"] = {
								},
								["self"] = {
									["Angles"] = Angle(90, 0, 0),
									["ClassName"] = "clip",
									["UniqueID"] = "1306617473",
									["Position"] = Vector(0, 0, 1.4800000190735),
								},
							},
							[4] = {
								["children"] = {
								},
								["self"] = {
									["ClassName"] = "effect",
									["UniqueID"] = "2129041181",
									["Position"] = Vector(0.42864990234375, 0.00341796875, -0.003387451171875),
									["Effect"] = "barrel_smoke_trailb",
									["Angles"] = Angle(12.683970451355, 2.6253908799845e-005, 1.7502605260233e-005),
								},
							},
						},
						["self"] = {
							["Position"] = Vector(-0.0006103515625, 0.00299072265625, -1.7405395507813),
							["Name"] = "bowl",
							["Alpha"] = 0.65,
							["ClassName"] = "model",
							["DoubleFace"] = true,
							["UniqueID"] = "1682371200",
							["Size"] = 0.037,
							["Material"] = "models/debug/debugwhite",
							["Model"] = "models/XQM/Rails/gumball_1.mdl",
							["EditorExpand"] = true,
						},
					},
					[2] = {
						["children"] = {
						},
						["self"] = {
							["Angles"] = Angle(-90, 0, 0),
							["ClassName"] = "clip",
							["UniqueID"] = "2985885681",
							["Position"] = Vector(-0.0020904541015625, 0.00567626953125, -2.2859497070313),
						},
					},
				},
				["self"] = {
					["UniqueID"] = "1447719391",
					["Model"] = "models/props_junk/PopCan01a.mdl",
					["Size"] = 0.15,
					["Name"] = "pipe",
					["Scale"] = Vector(1, 1, 3.0999999046326),
					["Alpha"] = 0.85,
					["ClassName"] = "model",
					["DoubleFace"] = true,
					["EditorExpand"] = true,
					["Position"] = Vector(1.1987915039063, -7.0154418945313, 0.018218994140625),
					["Angles"] = Angle(0, 0, -90),
					["Brightness"] = 10.7,
					["Material"] = "models/props_combine/health_charger_glass",
				},
			},
			[2] = {
				["children"] = {
				},
				["self"] = {
					["Velocity"] = 2,
					["UniqueID"] = "3860556725",
					["EndSize"] = 30,
					["Material"] = "particle/particle_smokegrenade",
					["NumberParticles"] = 2,
					["AirResistance"] = 10,
					["RandomColour"] = false,
					["Collide"] = false,
					["Position"] = Vector(0.81370544433594, -6.7429809570313, 0.00140380859375),
					["Sliding"] = false,
					["Lighting"] = false,
					["FireDelay"] = 22,
					["DieTime"] = 10,
					["ClassName"] = "particles",
					["Bounce"] = 0,
					["Spread"] = 0.4,
					["Gravity"] = Vector(0, 0, 1),
					["Angles"] = Angle(7.8120283433236e-005, -87.789237976074, -2.5506487872917e-005),
					["StartSize"] = 0,
					["RollDelta"] = -0.2,
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "2340012506",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )
GM.PacModels:RegisterOutfitFaceIDOverload( methEffect.PacOutfit, "male_04", "m04".. methEffect.PacOutfit )

GM.Drugs:RegisterEffect( methEffect )