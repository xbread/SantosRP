-- --------------------------------------------------------------
-- Cocaine for SantosRP by bread
-- --------------------------------------------------------------
 
local Item = {}
Item.Name = "Cocaine Leaves"
Item.Desc = "A box of cocaine leaves."
Item.Type = "type_drugs"
Item.Model = "models/freeman/coca_seedbox.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.Illegal = true
Item.LimitID = "cocaine_leaf"
Item.DrugLab_BlenderVars = {
	BlendProgress = 10,
	BlendAmountPerTick = 0.1,
	GiveItem = "Cocaine Mulch",
	GiveAmount = 2,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Baking soda"
Item.Desc = "A box of baking soda."
Item.Type = "type_drugs"
Item.Model = "models/props_lab/box01a.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = true
Item.CanCook = true
Item.LimitID = "baking soda"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 3, { ["vip"] = 1 } )

local Item = {}
Item.Name = "Cocaine Mulch"
Item.Desc = "A bag of cocaine mulch."
Item.Model = "models/props_junk/garbage_bag001a.mdl"
Item.Weight = 14
Item.Volume = 12
Item.Illegal = true 
Item.CanDrop = true
Item.LimitID = "ccmuch"
Item.DropClass = "ent_fluid_mulch"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 4 )

local Item = {}
Item.Name = "Cocaine Paste"
Item.Desc = "A jar of the compound cocaine paste."
Item.Type = "type_drugs"
Item.Model = "models/props_lab/jar01b.mdl"
Item.Weight = 5
Item.Volume = 5
Item.CanDrop = true
Item.Illegal = true
Item.DropClass = "ent_fluid_cokepaste"
Item.LimitID = "methylamine"

Item.ReactionChamberVars = {
	Mats = {
		["Ammonia"] = 1,
		["Methanol"] = 2,
		["Cocaine Mulch"] = 1,
	},
	Interval = 0.75,
	MakeAmount = 2,
	MinGiveAmount = 500,
	GiveItem = "Cocaine Paste",
	GiveAmount = 1,
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 1 } )


-- --------------------------------------------------------------
-- Low Quality
-- --------------------------------------------------------------

local Item = {}
Item.Name = "Cocaine (Low Quality)"
Item.Desc = "A bag of low quality cocaine."
Item.Type = "type_drugs"
Item.Model = "models/freeman/cocaine_crack.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.Illegal = true
Item.LimitID = "coke"

Item.OnUse = function( _, pPlayer )
	GAMEMODE.Drugs:PlayerApplyEffect( pPlayer, "meth", 1 * 60, 1 )
	GAMEMODE.Needs:AddPlayerNeed( pPlayer, "Stamina", 100 )
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
	SkillWeight = 0.39,
	OverCookMsg = "You overcooked it! This batch is ruined!",
	OverTimeExplode = true, 
	OverTimeStartFire = false,

	MinTime = 10,
	MaxTime = 90,
	TimeWeight = -0.85, 
	IdealTimePercent = 0.66, 

	Items = {
		["Baking soda"] = { IdealAmount = 1, MaxAmount = 1, MinAmount = 1 }
	},
	Fluids = {
		["Cocaine Paste"] = { IdealAmount = 700, MaxAmount = 850, MinAmount = 300 },
		["Methanol"] = { IdealAmount = 300, MaxAmount = 500, MinAmount = 200 },
		["Water"] = { IdealAmount = 100, MaxAmount = 250, MinAmount = 25 }
	},
	GiveItems = { 
		{ MinQuality = 0, GiveItem = "Cocaine (Low Quality)", GiveAmount = 4 },
		{ MinQuality = 0.61, GiveItem = "Cocaine (Medium Quality)", GiveAmount = 6 },
		{ MinQuality = 0.825, GiveItem = "Cocaine (High Quality)", GiveAmount = 8 },
	},
	GiveXP = { 
		{ MinQuality = 0, GiveAmount = 5 },
		{ MinQuality = 0.61, GiveAmount = 7 },
		{ MinQuality = 0.825, GiveAmount = 9 },
	}
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )

-- --------------------------------------------------------------
-- Medium Quality
-- --------------------------------------------------------------

local Item = {}
Item.Name = "Cocaine (Medium Quality)"
Item.Desc = "A bag of medium quality crack cocaine."
Item.Type = "type_drugs"
Item.Model = "models/freeman/cocaine_crack.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.Illegal = true
Item.LimitID = "cokemed"

Item.OnUse = function( _, pPlayer )
	GAMEMODE.Drugs:PlayerApplyEffect( pPlayer, "coke", 2 * 60, 1 )
	GAMEMODE.Needs:AddPlayerNeed( pPlayer, "Stamina", 200 )
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
-- --------------------------------------------------------------
-- High Quality
-- --------------------------------------------------------------

local Item = {}
Item.Name = "Cocaine (High Quality)"
Item.Desc = "A bag of high quality crack cocaine."
Item.Type = "type_drugs"
Item.Model = "models/freeman/cocaine_crack.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.Illegal = true
Item.LimitID = "cokehi"

Item.OnUse = function( _, pPlayer )
	GAMEMODE.Drugs:PlayerApplyEffect( pPlayer, "coke", 3 * 60, 1 )
	GAMEMODE.Needs:AddPlayerNeed( pPlayer, "Stamina", 200 )
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

-- -------------------------------------------------------------- 
-- Cocaine effect
-- --------------------------------------------------------------

local cokeEffect = {}
cokeEffect.Name = "coke"
cokeEffect.NiceName = "Crack Cocaine"
cokeEffect.MaxPower = 25

function cokeEffect:OnStart( pPlayer )
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

function cokeEffect:OnStop( pPlayer )
	if CLIENT then return end
	
	if GAMEMODE.Drugs:GetPlayerEffectPower( pPlayer, self.Name ) <= 0 then
		if GAMEMODE.Player:IsMoveSpeedModifierActive( pPlayer, "MethSpeed" ) then
			GAMEMODE.Player:RemoveMoveSpeedModifier( pPlayer, "MethSpeed" )
		end
	end
end

if CLIENT then
	function cokeEffect:RenderScreenspaceEffects()
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

	function cokeEffect:GetMotionBlurValues( intW, intH, intForward, intRot )
		local pow = math.min( GAMEMODE.Drugs:GetEffectPower(self.Name), self.MaxPower )
		return intW, intH, Lerp( pow /self.MaxPower, 0, 1 ), intRot
	end
end

cokeEffect.PacOutfit = "drug_meth"
cokeEffect.PacOutfitSlot = {
	Name = "int_drug_coke",
	Data = {
		Type = "GAMEMODE_INTERNAL_PAC_ONLY",
		Internal = true,
		KeepOnDeath = false,
		PacEnabled = true,
	},
}
GM.PacModels:Register( cokeEffect.PacOutfit, {
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

GM.PacModels:Register( "female_".. cokeEffect.PacOutfit, {
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
GM.PacModels:RegisterOutfitModelOverload( cokeEffect.PacOutfit, GM.Config.PlayerModels.Female, "female_".. cokeEffect.PacOutfit )

GM.PacModels:Register( "m04".. cokeEffect.PacOutfit, {
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
GM.PacModels:RegisterOutfitFaceIDOverload( cokeEffect.PacOutfit, "male_04", "m04".. cokeEffect.PacOutfit )

GM.Drugs:RegisterEffect( cokeEffect ) 
local cokeEffect = {}
cokeEffect.Name = "coke"
cokeEffect.NiceName = "Crack Cocaine"
cokeEffect.MaxPower = 25

function cokeEffect:OnStart( pPlayer )
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

function cokeEffect:OnStop( pPlayer )
	if CLIENT then return end
	
	if GAMEMODE.Drugs:GetPlayerEffectPower( pPlayer, self.Name ) <= 0 then
		if GAMEMODE.Player:IsMoveSpeedModifierActive( pPlayer, "MethSpeed" ) then
			GAMEMODE.Player:RemoveMoveSpeedModifier( pPlayer, "MethSpeed" )
		end
	end
end

if CLIENT then
	function cokeEffect:RenderScreenspaceEffects()
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

	function cokeEffect:GetMotionBlurValues( intW, intH, intForward, intRot )
		local pow = math.min( GAMEMODE.Drugs:GetEffectPower(self.Name), self.MaxPower )
		return intW, intH, Lerp( pow /self.MaxPower, 0, 1 ), intRot
	end
end

cokeEffect.PacOutfit = "drug_meth"
cokeEffect.PacOutfitSlot = {
	Name = "int_drug_coke",
	Data = {
		Type = "GAMEMODE_INTERNAL_PAC_ONLY",
		Internal = true,
		KeepOnDeath = false,
		PacEnabled = true,
	},
}
GM.PacModels:Register( cokeEffect.PacOutfit, {
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

GM.PacModels:Register( "female_".. cokeEffect.PacOutfit, {
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
GM.PacModels:RegisterOutfitModelOverload( cokeEffect.PacOutfit, GM.Config.PlayerModels.Female, "female_".. cokeEffect.PacOutfit )

GM.PacModels:Register( "m04".. cokeEffect.PacOutfit, {
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
GM.PacModels:RegisterOutfitFaceIDOverload( cokeEffect.PacOutfit, "male_04", "m04".. cokeEffect.PacOutfit )

GM.Drugs:RegisterEffect( cokeEffect )