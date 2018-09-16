--[[
	Name: drugs_tobacco.lua
	For: TalosLife
	By: TalosLife
]]--

local Item = {}
Item.Name = "Cigarettes"
Item.Desc = "A pack of cigarettes"
Item.Type = "type_drugs"
Item.Model = "models/boxopencigshib.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.Illegal = true
Item.LimitID = "cigarettes"

Item.OnUse = function( _, pPlayer )
	GAMEMODE.Drugs:PlayerApplyEffect( pPlayer, "cigarette", 4 *60, 1 )
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )

local Item = {}
Item.Name = "Cigar Box"
Item.Desc = "A box of cigars"
Item.Type = "type_drugs"
Item.Model = "models/gibs/furniture_gibs/furniture_vanity01a_gib01.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanUse = true
Item.Illegal = true
Item.LimitID = "cigarettes"

Item.OnUse = function( _, pPlayer )
	GAMEMODE.Drugs:PlayerApplyEffect( pPlayer, "cigar", 5 *60, 1 )
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 8, { ["vip"] = 4 } )

--[[ Tobacco Effect ]]--
local cigEffect = {}
cigEffect.Name = "cigarette"
cigEffect.NiceName = "Nicotine"
cigEffect.MaxPower = 25

function cigEffect:OnStart( pPlayer )
end

function cigEffect:Think( pPlayer )
end

function cigEffect:OnStop( pPlayer )
end

if CLIENT then
	function cigEffect:RenderScreenspaceEffects()
	end

	function cigEffect:GetMotionBlurValues( intW, intH, intForward, intRot )
		return intW, intH, intForward, intRot
	end
end

cigEffect.PacOutfit = "drug_cig"
cigEffect.PacOutfitSlot = {
	Name = "int_drug_cig",
	Data = {
		Type = "GAMEMODE_INTERNAL_PAC_ONLY",
		Internal = true,
		KeepOnDeath = false,
		PacEnabled = true,
	},
}
GM.PacModels:Register( cigEffect.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
					[1] = {
						["children"] = {
						},
						["self"] = {
							["UniqueID"] = "686013029",
							["Name"] = "ash",
							["Scale"] = Vector(1, 1, 0.30000001192093),
							["Material"] = "models/props_wasteland/concretewall066a",
							["Size"] = 0.07,
							["Position"] = Vector(1.4700000286102, 0, 0),
							["Angles"] = Angle(-90, 0, 0),
							["Model"] = "models/props_junk/PopCan01a.mdl",
							["ClassName"] = "model",
						},
					},
					[2] = {
						["children"] = {
							[1] = {
								["children"] = {
								},
								["self"] = {
									["ClassName"] = "effect",
									["UniqueID"] = "968541480",
									["Effect"] = "barrel_smoke_trailb",
								},
							},
						},
						["self"] = {
							["UniqueID"] = "4226166498",
							["Name"] = "cherry",
							["Scale"] = Vector(1, 1, 0.10000000149012),
							["Material"] = "models/weapons/v_crossbow/rebar_glow",
							["Size"] = 0.07,
							["Position"] = Vector(1.5499999523163, 0, 0),
							["Angles"] = Angle(-90, 0, 0),
							["Model"] = "models/props_junk/PopCan01a.mdl",
							["ClassName"] = "model",
						},
					},
				},
				["self"] = {
					["ClassName"] = "model",
					["UniqueID"] = "3894885173",
					["Model"] = "models/pissedmeoff.mdl",
					["Size"] = 0.65,
					["Position"] = Vector(0.88388061523438, -6.5858764648438, -1.0126342773438),
					["Name"] = "cigarette",
					["Angles"] = Angle(19.313579559326, -86.569694519043, -1.8829755783081),
				},
			},
			[2] = {
				["children"] = {
				},
				["self"] = {
					["Velocity"] = 5,
					["UniqueID"] = "3514151176",
					["StickToSurface"] = false,
					["Material"] = "particle/particle_smokegrenade1",
					["AirResistance"] = 30,
					["RandomColour"] = false,
					["Collide"] = false,
					["Position"] = Vector(0.93278503417969, -6.3522338867188, 0.0014572143554688),
					["Sliding"] = false,
					["Lighting"] = false,
					["AlignToSurface"] = false,
					["DieTime"] = 8,
					["FireDelay"] = 12,
					["ClassName"] = "particles",
					["Bounce"] = 0,
					["Gravity"] = Vector(0, 0, 2),
					["Name"] = "cig_smoke",
					["Angles"] = Angle(7.7266508014873e-005, -87.288673400879, -2.4972880055429e-005),
					["StartSize"] = 0,
					["RollDelta"] = -0.2,
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "234646324",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )

GM.PacModels:Register( "female_".. cigEffect.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Velocity"] = 5,
					["UniqueID"] = "3514151176",
					["StickToSurface"] = false,
					["Material"] = "particle/particle_smokegrenade1",
					["AirResistance"] = 30,
					["RandomColour"] = false,
					["Collide"] = false,
					["Position"] = Vector(0.24172973632813, -6.385009765625, 0.000885009765625),
					["Sliding"] = false,
					["Lighting"] = false,
					["AlignToSurface"] = false,
					["DieTime"] = 8,
					["FireDelay"] = 12,
					["ClassName"] = "particles",
					["Bounce"] = 0,
					["Gravity"] = Vector(0, 0, 2),
					["Name"] = "cig_smoke",
					["Angles"] = Angle(7.7266508014873e-005, -87.288673400879, -2.4972880055429e-005),
					["StartSize"] = 0,
					["RollDelta"] = -0.2,
				},
			},
			[2] = {
				["children"] = {
					[1] = {
						["children"] = {
							[1] = {
								["children"] = {
								},
								["self"] = {
									["ClassName"] = "effect",
									["UniqueID"] = "968541480",
									["Effect"] = "barrel_smoke_trailb",
								},
							},
						},
						["self"] = {
							["UniqueID"] = "4226166498",
							["Name"] = "cherry",
							["Scale"] = Vector(1, 1, 0.10000000149012),
							["Material"] = "models/weapons/v_crossbow/rebar_glow",
							["Size"] = 0.07,
							["Position"] = Vector(1.5499999523163, 0, 0),
							["Angles"] = Angle(-90, 0, 0),
							["Model"] = "models/props_junk/PopCan01a.mdl",
							["ClassName"] = "model",
						},
					},
					[2] = {
						["children"] = {
						},
						["self"] = {
							["UniqueID"] = "686013029",
							["Name"] = "ash",
							["Scale"] = Vector(1, 1, 0.30000001192093),
							["Material"] = "models/props_wasteland/concretewall066a",
							["Size"] = 0.07,
							["Position"] = Vector(1.4700000286102, 0, 0),
							["Angles"] = Angle(-90, 0, 0),
							["Model"] = "models/props_junk/PopCan01a.mdl",
							["ClassName"] = "model",
						},
					},
				},
				["self"] = {
					["ClassName"] = "model",
					["UniqueID"] = "3894885173",
					["Model"] = "models/pissedmeoff.mdl",
					["Size"] = 0.65,
					["Position"] = Vector(0.043670654296875, -6.3189086914063, -0.87332153320313),
					["Name"] = "cigarette",
					["Angles"] = Angle(19.313579559326, -86.569694519043, -1.8829755783081),
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "234646324",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )
GM.PacModels:RegisterOutfitModelOverload( cigEffect.PacOutfit, GM.Config.PlayerModels.Female, "female_".. cigEffect.PacOutfit )

GM.PacModels:Register( "m04".. cigEffect.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Velocity"] = 5,
					["UniqueID"] = "3514151176",
					["StickToSurface"] = false,
					["Material"] = "particle/particle_smokegrenade1",
					["AirResistance"] = 30,
					["RandomColour"] = false,
					["Collide"] = false,
					["Position"] = Vector(0.93278503417969, -6.3522338867188, 0.0014572143554688),
					["Sliding"] = false,
					["Lighting"] = false,
					["AlignToSurface"] = false,
					["DieTime"] = 8,
					["FireDelay"] = 12,
					["ClassName"] = "particles",
					["Bounce"] = 0,
					["Gravity"] = Vector(0, 0, 2),
					["Name"] = "cig_smoke",
					["Angles"] = Angle(7.7266508014873e-005, -87.288673400879, -2.4972880055429e-005),
					["StartSize"] = 0,
					["RollDelta"] = -0.2,
				},
			},
			[2] = {
				["children"] = {
					[1] = {
						["children"] = {
							[1] = {
								["children"] = {
								},
								["self"] = {
									["ClassName"] = "effect",
									["UniqueID"] = "968541480",
									["Effect"] = "barrel_smoke_trailb",
								},
							},
						},
						["self"] = {
							["UniqueID"] = "4226166498",
							["Name"] = "cherry",
							["Scale"] = Vector(1, 1, 0.10000000149012),
							["Material"] = "models/weapons/v_crossbow/rebar_glow",
							["Size"] = 0.07,
							["Position"] = Vector(1.5499999523163, 0, 0),
							["Angles"] = Angle(-90, 0, 0),
							["Model"] = "models/props_junk/PopCan01a.mdl",
							["ClassName"] = "model",
						},
					},
					[2] = {
						["children"] = {
						},
						["self"] = {
							["UniqueID"] = "686013029",
							["Name"] = "ash",
							["Scale"] = Vector(1, 1, 0.30000001192093),
							["Material"] = "models/props_wasteland/concretewall066a",
							["Size"] = 0.07,
							["Position"] = Vector(1.4700000286102, 0, 0),
							["Angles"] = Angle(-90, 0, 0),
							["Model"] = "models/props_junk/PopCan01a.mdl",
							["ClassName"] = "model",
						},
					},
				},
				["self"] = {
					["ClassName"] = "model",
					["UniqueID"] = "3894885173",
					["Model"] = "models/pissedmeoff.mdl",
					["Size"] = 0.65,
					["Position"] = Vector(1.2772369384766, -6.3361206054688, -0.9464111328125),
					["Name"] = "cigarette",
					["Angles"] = Angle(19.313579559326, -86.569694519043, -1.8829755783081),
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "234646324",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )
GM.PacModels:RegisterOutfitFaceIDOverload( cigEffect.PacOutfit, "male_04", "m04".. cigEffect.PacOutfit )
GM.Drugs:RegisterEffect( cigEffect )


--[[ Tobacco Effect ]]--
local cigarEffect = {}
cigarEffect.Name = "cigar"
cigarEffect.NiceName = "Nicotine"
cigarEffect.MaxPower = 25

function cigarEffect:OnStart( pPlayer )
end

function cigarEffect:Think( pPlayer )
end

function cigarEffect:OnStop( pPlayer )
end

if CLIENT then
	function cigarEffect:RenderScreenspaceEffects()
	end

	function cigarEffect:GetMotionBlurValues( intW, intH, intForward, intRot )
		return intW, intH, intForward, intRot
	end
end

cigarEffect.PacOutfit = "drug_cigar"
cigarEffect.PacOutfitSlot = {
	Name = "int_drug_cigar",
	Data = {
		Type = "GAMEMODE_INTERNAL_PAC_ONLY",
		Internal = true,
		KeepOnDeath = false,
		PacEnabled = true,
	},
}
GM.PacModels:Register( cigarEffect.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Velocity"] = 6,
					["UniqueID"] = "419367293",
					["StickToSurface"] = false,
					["EndSize"] = 35,
					["Material"] = "particle/particle_smokegrenade1",
					["AirResistance"] = 30,
					["RandomColour"] = false,
					["Collide"] = false,
					["Position"] = Vector(1.4326171875, -7.712890625, 0.03564453125),
					["Sliding"] = false,
					["Lighting"] = false,
					["AlignToSurface"] = false,
					["DieTime"] = 8,
					["ClassName"] = "particles",
					["OwnerVelocityMultiplier"] = 0.01,
					["FireDelay"] = 25,
					["Gravity"] = Vector(0, 0, 2),
					["Angles"] = Angle(-3.7012421671534e-005, -66.997940063477, -2.2321513824863e-005),
					["StartSize"] = 1,
					["RollDelta"] = -0.1,
				},
			},
			[2] = {
				["children"] = {
					[1] = {
						["children"] = {
						},
						["self"] = {
							["UniqueID"] = "145926232",
							["Name"] = "band",
							["Scale"] = Vector(1, 1, 0.40000000596046),
							["Material"] = "models/props_c17/furniturefabric001a",
							["Size"] = 0.228,
							["Position"] = Vector(0, -0.0020000000949949, -1),
							["Angles"] = Angle(-4.2688685653047e-007, 12.39999961853, 0),
							["Model"] = "models/props_junk/PopCan01a.mdl",
							["ClassName"] = "model",
						},
					},
					[2] = {
						["children"] = {
							[1] = {
								["children"] = {
								},
								["self"] = {
									["ClassName"] = "effect",
									["UniqueID"] = "4096653763",
									["Effect"] = "barrel_smoke_trailb",
								},
							},
						},
						["self"] = {
							["UniqueID"] = "2835220303",
							["Name"] = "ash",
							["Scale"] = Vector(1, 1, 0.10000000149012),
							["Model"] = "models/props_docks/dock01_pole01a_128.mdl",
							["ClassName"] = "model",
							["Size"] = 0.05,
							["EditorExpand"] = true,
							["Position"] = Vector(0.00030517578125, -0.00390625, 2.434326171875),
							["Material"] = "models/props_canal/rock_riverbed01a",
							["Brightness"] = 0.8,
							["Angles"] = Angle(-4.2688685653047e-007, -9.6049541298271e-007, 0),
						},
					},
				},
				["self"] = {
					["UniqueID"] = "4272946858",
					["Name"] = "stogie",
					["Scale"] = Vector(1, 1, 0.69999998807907),
					["EditorExpand"] = true,
					["Size"] = 0.05,
					["ClassName"] = "model",
					["Angles"] = Angle(-4.2688685653047e-007, -9.6049541298271e-007, 108.96017456055),
					["Position"] = Vector(0.6483154296875, -7.52734375, -1.169921875),
					["Model"] = "models/props_docks/dock01_pole01a_128.mdl",
					["Material"] = "models/props_pipes/GutterMetal01a",
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "1237277158",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )

GM.PacModels:Register( "female_".. cigarEffect.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Velocity"] = 6,
					["UniqueID"] = "419367293",
					["StickToSurface"] = false,
					["EndSize"] = 35,
					["Material"] = "particle/particle_smokegrenade1",
					["AirResistance"] = 30,
					["RandomColour"] = false,
					["Collide"] = false,
					["Position"] = Vector(1.4326171875, -7.712890625, 0.03564453125),
					["Sliding"] = false,
					["Lighting"] = false,
					["AlignToSurface"] = false,
					["DieTime"] = 8,
					["ClassName"] = "particles",
					["OwnerVelocityMultiplier"] = 0.01,
					["FireDelay"] = 25,
					["Gravity"] = Vector(0, 0, 2),
					["Angles"] = Angle(-3.7012421671534e-005, -66.997940063477, -2.2321513824863e-005),
					["StartSize"] = 1,
					["RollDelta"] = -0.1,
				},
			},
			[2] = {
				["children"] = {
					[1] = {
						["children"] = {
						},
						["self"] = {
							["UniqueID"] = "145926232",
							["Name"] = "band",
							["Scale"] = Vector(1, 1, 0.40000000596046),
							["Material"] = "models/props_c17/furniturefabric001a",
							["Size"] = 0.19,
							["Position"] = Vector(0, -0.0020000000949949, -1),
							["Angles"] = Angle(-4.2688685653047e-007, 12.39999961853, 0),
							["Model"] = "models/props_junk/PopCan01a.mdl",
							["ClassName"] = "model",
						},
					},
					[2] = {
						["children"] = {
							[1] = {
								["children"] = {
								},
								["self"] = {
									["ClassName"] = "effect",
									["UniqueID"] = "4096653763",
									["Effect"] = "barrel_smoke_trailb",
								},
							},
						},
						["self"] = {
							["UniqueID"] = "2835220303",
							["Name"] = "ash",
							["Scale"] = Vector(1, 1, 0.10000000149012),
							["Model"] = "models/props_docks/dock01_pole01a_128.mdl",
							["ClassName"] = "model",
							["Size"] = 0.04,
							["EditorExpand"] = true,
							["Position"] = Vector(-0.001953125, -0.001953125, 1.951416015625),
							["Material"] = "models/props_canal/rock_riverbed01a",
							["Brightness"] = 0.8,
							["Angles"] = Angle(-4.2688685653047e-007, -9.6049541298271e-007, 0),
						},
					},
				},
				["self"] = {
					["UniqueID"] = "4272946858",
					["Name"] = "stogie",
					["Scale"] = Vector(1, 1, 0.69999998807907),
					["EditorExpand"] = true,
					["Size"] = 0.04,
					["ClassName"] = "model",
					["Angles"] = Angle(-0, 5.069281314718e-007, 110.72737121582),
					["Position"] = Vector(0.09130859375, -7.23193359375, -1.07421875),
					["Model"] = "models/props_docks/dock01_pole01a_128.mdl",
					["Material"] = "models/props_pipes/GutterMetal01a",
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "1237277158",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )
GM.PacModels:RegisterOutfitModelOverload( cigarEffect.PacOutfit, GM.Config.PlayerModels.Female, "female_".. cigarEffect.PacOutfit )

GM.PacModels:Register( "m04".. cigarEffect.PacOutfit, {
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
									["ClassName"] = "effect",
									["UniqueID"] = "4096653763",
									["Effect"] = "barrel_smoke_trailb",
								},
							},
						},
						["self"] = {
							["UniqueID"] = "2835220303",
							["Name"] = "ash",
							["Scale"] = Vector(1, 1, 0.10000000149012),
							["Model"] = "models/props_docks/dock01_pole01a_128.mdl",
							["ClassName"] = "model",
							["Size"] = 0.05,
							["EditorExpand"] = true,
							["Position"] = Vector(0.00030517578125, -0.00390625, 2.434326171875),
							["Material"] = "models/props_canal/rock_riverbed01a",
							["Brightness"] = 0.8,
							["Angles"] = Angle(-4.2688685653047e-007, -9.6049541298271e-007, 0),
						},
					},
					[2] = {
						["children"] = {
						},
						["self"] = {
							["UniqueID"] = "145926232",
							["Name"] = "band",
							["Scale"] = Vector(1, 1, 0.40000000596046),
							["Material"] = "models/props_c17/furniturefabric001a",
							["Size"] = 0.228,
							["Position"] = Vector(0, -0.0020000000949949, -1),
							["Angles"] = Angle(-4.2688685653047e-007, 12.39999961853, 0),
							["Model"] = "models/props_junk/PopCan01a.mdl",
							["ClassName"] = "model",
						},
					},
				},
				["self"] = {
					["UniqueID"] = "4272946858",
					["Name"] = "stogie",
					["Scale"] = Vector(1, 1, 0.69999998807907),
					["EditorExpand"] = true,
					["Size"] = 0.05,
					["ClassName"] = "model",
					["Angles"] = Angle(-0, 5.069281314718e-007, 110.72737121582),
					["Position"] = Vector(1.2124633789063, -7.20068359375, -1.06591796875),
					["Model"] = "models/props_docks/dock01_pole01a_128.mdl",
					["Material"] = "models/props_pipes/GutterMetal01a",
				},
			},
			[2] = {
				["children"] = {
				},
				["self"] = {
					["Velocity"] = 6,
					["UniqueID"] = "419367293",
					["StickToSurface"] = false,
					["EndSize"] = 35,
					["Material"] = "particle/particle_smokegrenade1",
					["AirResistance"] = 30,
					["RandomColour"] = false,
					["Collide"] = false,
					["Position"] = Vector(1.4326171875, -7.712890625, 0.03564453125),
					["Sliding"] = false,
					["Lighting"] = false,
					["AlignToSurface"] = false,
					["DieTime"] = 8,
					["ClassName"] = "particles",
					["OwnerVelocityMultiplier"] = 0.01,
					["FireDelay"] = 25,
					["Gravity"] = Vector(0, 0, 2),
					["Angles"] = Angle(-3.7012421671534e-005, -66.997940063477, -2.2321513824863e-005),
					["StartSize"] = 1,
					["RollDelta"] = -0.1,
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "1237277158",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )
GM.PacModels:RegisterOutfitFaceIDOverload( cigarEffect.PacOutfit, "male_04", "m04".. cigarEffect.PacOutfit )
GM.Drugs:RegisterEffect( cigarEffect )