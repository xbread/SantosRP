-----------------------------------------------------
--[[

    Name: fas2_guns.lua

    For: SantosRP

    By: Ultra

]]--



local Item = {}

Item.Name = "AK-47"

Item.Desc = "An AK-47 rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_rif_ak47.mdl"

Item.Weight = 12

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_ak47"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_ak47"

Item.PacOutfit = "ak47_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 15

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 2,

    ["Trigger"] = 2,

    ["Stock"] = 2,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 2,

    ["Lower Receiver"] = 2,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "2859473494",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_ak47@@1",

						},

					},

				},

				["self"] = {

					["Angles"] = Angle(-3.2440683841705, -178.67698669434, -22.848773956299),

					["UniqueID"] = "1484483537",

					["Position"] = Vector(-1.486930847168, -1.2796630859375, -9.1651153564453),

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_ak47.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "AK-74"

Item.Desc = "An AK-74 rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_rif_ak47.mdl"

Item.Weight = 12

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_ak74"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_ak74"

Item.PacOutfit = "ak74_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 15

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 2,

    ["Trigger"] = 2,

    ["Stock"] = 2,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 2,

    ["Lower Receiver"] = 2,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "2696076219",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_ak74@@1",

						},

					},

				},

				["self"] = {

					["Position"] = Vector(-13.74267578125, 0.849365234375, -0.64501953125),

					["Angles"] = Angle(3.4856202602386, -0.33305096626282, 12.302300453186),

					["UniqueID"] = "1484483537",

					["Size"] = 0.925,

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/world/rifles/ak12.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "G3A3"

Item.Desc = "A G3A3 rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_g3a3.mdl"

Item.Weight = 12

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_g3"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_g3"

Item.PacOutfit = "g3_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 16

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 2,

    ["Trigger"] = 2,

    ["Stock"] = 2,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 2,

    ["Lower Receiver"] = 2,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "3060188880",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_g3@@1",

						},

					},

				},

				["self"] = {

					["Angles"] = Angle(-3.2440683841705, -178.67698669434, -22.848773956299),

					["UniqueID"] = "1484483537",

					["Position"] = Vector(-3.8226852416992, -1.2533569335938, -9.2270812988281),

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_g3a3.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "Glock-20"

Item.Desc = "A Glock-20 pistol."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_pist_glock18.mdl"

Item.Weight = 6

Item.Volume = 4

Item.CanDrop = true

Item.DropClass = "fas2_glock20"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "SecondaryWeapon"

Item.EquipGiveClass = "fas2_glock20"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 7

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 2,

    ["Trigger"] = 2,

    ["Stock"] = 1,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 1,

    ["Upper Receiver"] = 1,

}

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "M3 Super 90"

Item.Desc = "An M3 Super 90 shotgun."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_shot_m3super90.mdl"

Item.Weight = 14

Item.Volume = 11

Item.CanDrop = true

Item.DropClass = "fas2_m3s90"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_m3s90"

Item.PacOutfit = "m3_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 12

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 1,

    ["Trigger"] = 1,

    ["Stock"] = 2,

    ["Handle Grip"] = 1,

    ["Long Barrel"] = 1,

    ["Upper Receiver"] = 1,

}

GM.PacModels:Register( Item.PacOutfit, {

    [1] = {

        ["children"] = {

            [1] = {

                ["children"] = {

                },

                ["self"] = {

                    ["Angles"] = Angle(24.521390914917, 2.9193983078003, -0.26048710942268),

                    ["UniqueID"] = "1484483537",

                    ["Position"] = Vector(8.8532104492188, -2.9111938476563, -5.2907600402832),

                    ["Bone"] = "spine 2",

                    ["Model"] = "models/weapons/w_m3.mdl",

                    ["ClassName"] = "model",

                },

            },

        },

        ["self"] = {

            ["EditorExpand"] = true,

            ["UniqueID"] = "239303487",

            ["ClassName"] = "group",

            ["Name"] = "my outfit",

            ["Description"] = "add parts to me!",

        },

    },

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "M24"

Item.Desc = "An M24 bolt action rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_m24.mdl"

Item.Weight = 12

Item.Volume = 12

Item.CanDrop = true

Item.DropClass = "fas2_m24"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_m24"

Item.PacOutfit = "m24_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 20

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 2,

    ["Trigger"] = 2,

    ["Stock"] = 2,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 2,

    ["Lower Receiver"] = 2,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "1972331155",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_m24@@1",

						},

					},

				},

				["self"] = {

					["Angles"] = Angle(3.4166414737701, 0.63323080539703, 17.383584976196),

					["UniqueID"] = "1484483537",

					["Position"] = Vector(3.8931884765625, -2.3147583007813, -7.177001953125),

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_m24.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "MP5A5"

Item.Desc = "An MP5A5 sub-machine gun."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_smg_mp5.mdl"

Item.Weight = 10

Item.Volume = 8

Item.CanDrop = true

Item.DropClass = "fas2_mp5a5"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_mp5a5"

Item.PacOutfit = "mp5_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 12

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 2,

    ["Trigger"] = 2,

    ["Stock"] = 1,

    ["Handle Grip"] = 1,

    ["Long Barrel"] = 1,

    ["Lower Receiver"] = 1,

    ["Upper Receiver"] = 1,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "3827241767",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_mp5a5@@1",

						},

					},

				},

				["self"] = {

					["Angles"] = Angle(-3.2440683841705, -178.67698669434, -22.848773956299),

					["UniqueID"] = "1484483537",

					["Position"] = Vector(2.2931747436523, -1.4446411132813, -8.773193359375),

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_mp5.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "PP-19 Bizon"

Item.Desc = "A PP-19 Bizon sub-machine gun."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_smg_biz.mdl"

Item.Weight = 11

Item.Volume = 9

Item.CanDrop = true

Item.DropClass = "fas2_pp19"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_pp19"

Item.PacOutfit = "bizon_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 14

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 1,

    ["Trigger"] = 1,

    ["Stock"] = 2,

    ["Handle Grip"] = 1,

    ["Long Barrel"] = 1,

    ["Lower Receiver"] = 1,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "850574148",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_pp19@@1",

						},

					},

				},

				["self"] = {

					["Angles"] = Angle(4.0020641023375e-008, 1.0672171413262e-007, 18.04736328125),

					["UniqueID"] = "1484483537",

					["Position"] = Vector(-8.503662109375, -1.8165893554688, -10.407783508301),

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_smg_biz.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "Raging Bull"

Item.Desc = "A Raging Bull revolver."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_357.mdl"

Item.Weight = 9

Item.Volume = 6

Item.CanDrop = true

Item.DropClass = "fas2_ragingbull"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "SecondaryWeapon"

Item.EquipGiveClass = "fas2_ragingbull"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 17

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 1,

    ["Bolt"] = 2,

    ["Trigger"] = 1,

    ["Stock"] = 1,

    ["Handle Grip"] = 1,

    ["Short Barrel"] = 1,

    ["Lower Receiver"] = 1,

    ["Cylinder"] = 2,

}

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "Sako RK-95"

Item.Desc = "A Sako RK-95 rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/world/rifles/rk95.mdl"

Item.Weight = 13

Item.Volume = 12

Item.CanDrop = true

Item.DropClass = "fas2_rk95"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_rk95"

Item.PacOutfit = "rk95_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 16

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 1,

    ["Bolt"] = 1,

    ["Trigger"] = 2,

    ["Stock"] = 2,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 1,

    ["Lower Receiver"] = 1,

    ["Upper Receiver"] = 1,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "430416509",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_rk95@@1",

						},

					},

				},

				["self"] = {

					["Angles"] = Angle(5.8067636489868, 1.4176924228668, 18.150701522827),

					["UniqueID"] = "1484483537",

					["Position"] = Vector(2.3665466308594, -2.2958984375, -5.68359375),

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/world/rifles/rk95.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "RPK-47"

Item.Desc = "An RPK-47 machine gun."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_ak47.mdl"

Item.Weight = 18

Item.Volume = 15

Item.CanDrop = true

Item.DropClass = "fas2_rpk"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_rpk"

Item.PacOutfit = "rpk_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 25

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 3,

    ["Trigger"] = 2,

    ["Stock"] = 2,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 2,

    ["Lower Receiver"] = 2,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "312083675",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_rpk@@1",

						},

					},

				},

				["self"] = {

					["Angles"] = Angle(-3.2440683841705, -178.67698669434, -22.848773956299),

					["UniqueID"] = "1484483537",

					["Position"] = Vector(-1.486930847168, -1.2796630859375, -9.1651153564453),

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_ak47.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "SG 552"

Item.Desc = "An SG 552 rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_sg550.mdl"

Item.Weight = 13

Item.Volume = 12

Item.CanDrop = true

Item.DropClass = "fas2_sg552"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_sg552"

Item.PacOutfit = "sg552_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 16

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 1,

    ["Bolt"] = 1,

    ["Trigger"] = 2,

    ["Stock"] = 2,

    ["Handle Grip"] = 1,

    ["Long Barrel"] = 2,

    ["Lower Receiver"] = 2,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "204696927",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_sg552@@1",

						},

					},

				},

				["self"] = {

					["Angles"] = Angle(-3.2440683841705, -178.67698669434, -22.848773956299),

					["UniqueID"] = "1484483537",

					["Position"] = Vector(-3.7593002319336, -1.4359130859375, -8.1918640136719),

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_sg550.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "SKS"

Item.Desc = "An SKS rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/world/rifles/sks.mdl"

Item.Weight = 11

Item.Volume = 11

Item.CanDrop = true

Item.DropClass = "fas2_sks"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_sks"

Item.PacOutfit = "sks_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 10

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 1,

    ["Trigger"] = 2,

    ["Stock"] = 1,

    ["Handle Grip"] = 1,

    ["Long Barrel"] = 1,

    ["Lower Receiver"] = 2,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "3821689262",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_sks@@1",

						},

					},

				},

				["self"] = {

					["Angles"] = Angle(-3.2440683841705, -178.67698669434, -22.848773956299),

					["UniqueID"] = "1484483537",

					["Position"] = Vector(-4.6706466674805, -2.5431518554688, -6.1690368652344),

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/world/rifles/sks.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "M11A1"

Item.Desc = "A M11A1 machine pistol."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_smg_mac10.mdl"

Item.Weight = 8

Item.Volume = 6

Item.CanDrop = true

Item.DropClass = "fas2_mac11"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_mac11"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 10

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 1,

    ["Bolt"] = 1,

    ["Trigger"] = 2,

    ["Handle Grip"] = 1,

    ["Long Barrel"] = 1,

    ["Lower Receiver"] = 1,

    ["Upper Receiver"] = 1,

}

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "IMI Uzi"

Item.Desc = "An IMI Uzi sub-machine gun."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_smg_mac10.mdl"

Item.Weight = 10

Item.Volume = 8

Item.CanDrop = true

Item.DropClass = "fas2_uzi"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_uzi"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 15

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 1,

    ["Bolt"] = 1,

    ["Trigger"] = 1,

    ["Stock"] = 1,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 1,

    ["Lower Receiver"] = 2,

    ["Upper Receiver"] = 1,

}

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "FAMAS F1"

Item.Desc = "A FAMAS F1 rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_rif_famas.mdl"

Item.Weight = 12

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_famas"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_famas"

Item.PacOutfit = "famasf1_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 14

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 1,

    ["Bolt"] = 2,

    ["Trigger"] = 2,

    ["Stock"] = 1,

    ["Handle Grip"] = 1,

    ["Long Barrel"] = 2,

    ["Lower Receiver"] = 1,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "3289902064",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_famas@@1",

						},

					},

				},

				["self"] = {

					["Position"] = Vector(4.4692764282227, -1.7459106445313, -8.8655014038086),

					["Angles"] = Angle(0.35247972607613, -178.35551452637, -12.094970703125),

					["UniqueID"] = "1484483537",

					["Size"] = 1.025,

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_famas.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "G36C"

Item.Desc = "A G36C rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_g36e.mdl"

Item.Weight = 12

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_g36c"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_g36c"

Item.PacOutfit = "g36_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 15

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 1,

    ["Bolt"] = 2,

    ["Trigger"] = 1,

    ["Stock"] = 2,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 2,

    ["Lower Receiver"] = 1,

    ["Upper Receiver"] = 1,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "3661784215",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_g36c@@1",

						},

					},

				},

				["self"] = {

					["Position"] = Vector(0.58003997802734, -2.068359375, -9.1623611450195),

					["Angles"] = Angle(-2.9162585735321, -177.65454101563, -12.110625267029),

					["UniqueID"] = "1484483537",

					["Size"] = 1.025,

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_g36e.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "M4A1"

Item.Desc = "An M4A1 rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_rif_m4a1.mdl"

Item.Weight = 12

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_m4a1"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_m4a1"

Item.PacOutfit = "m4_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 18

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 2,

    ["Trigger"] = 2,

    ["Stock"] = 1,

    ["Handle Grip"] = 1,

    ["Long Barrel"] = 1,

    ["Lower Receiver"] = 2,

    ["Upper Receiver"] = 1,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "1107791906",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_m4a1@@1",

						},

					},

				},

				["self"] = {

					["Position"] = Vector(1.8674926757813, -1.91015625, -8.9012145996094),

					["Angles"] = Angle(0.35247972607613, -178.35551452637, -12.094970703125),

					["UniqueID"] = "1484483537",

					["Size"] = 1.025,

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_m4.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "M14"

Item.Desc = "An M14 rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_m14.mdl"

Item.Weight = 12

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_m14"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_m14"

Item.PacOutfit = "m14_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 12

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 1,

    ["Bolt"] = 2,

    ["Trigger"] = 1,

    ["Stock"] = 1,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 1,

    ["Lower Receiver"] = 2,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "965353309",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_m14@@1",

						},

					},

				},

				["self"] = {

					["Position"] = Vector(-4.3627014160156, -2.2530517578125, -8.9742736816406),

					["Angles"] = Angle(-2.9162585735321, -177.65454101563, -12.110625267029),

					["UniqueID"] = "1484483537",

					["Size"] = 1.025,

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_m14.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "M21"

Item.Desc = "An M21 rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_m14.mdl"

Item.Weight = 12

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_m21"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_m21"

Item.PacOutfit = "m21_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 18

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 2,

    ["Trigger"] = 2,

    ["Stock"] = 3,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 3,

    ["Lower Receiver"] = 3,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "965353309",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_m21@@1",

						},

					},

				},

				["self"] = {

					["Position"] = Vector(-4.3627014160156, -2.2530517578125, -8.9742736816406),

					["Angles"] = Angle(-2.9162585735321, -177.65454101563, -12.110625267029),

					["UniqueID"] = "1484483537",

					["Size"] = 1.025,

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_m14.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "M82"

Item.Desc = "An M82 rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_m82.mdl"

Item.Weight = 18

Item.Volume = 15

Item.CanDrop = true

Item.DropClass = "fas2_m82"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_m82"

Item.PacOutfit = "m82_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 25

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 4,

    ["Bolt"] = 4,

    ["Trigger"] = 4,

    ["Stock"] = 4,

    ["Handle Grip"] = 4,

    ["Long Barrel"] = 4,

    ["Lower Receiver"] = 4,

    ["Upper Receiver"] = 4,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "1137486923",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_m82@@1",

						},

					},

				},

				["self"] = {

					["Position"] = Vector(-3.5045623779297, -2.8840942382813, 1.4510498046875),

					["Angles"] = Angle(-28.385202407837, 179.85206604004, 1.4463603496552),

					["UniqueID"] = "1484483537",

					["Size"] = 1.025,

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_m82.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "SG 550"

Item.Desc = "An SG 550 rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_sg550.mdl"

Item.Weight = 12

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_sg550"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_sg550"

Item.PacOutfit = "sg550_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 19

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 2,

    ["Trigger"] = 1,

    ["Stock"] = 2,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 2,

    ["Lower Receiver"] = 2,

    ["Upper Receiver"] = 1,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "204696927",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_sg550@@1",

						},

					},

				},

				["self"] = {

					["Angles"] = Angle(-3.2440683841705, -178.67698669434, -22.848773956299),

					["UniqueID"] = "1484483537",

					["Position"] = Vector(-3.7593002319336, -1.4359130859375, -8.1918640136719),

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_sg550.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "SR-25"

Item.Desc = "An SR-25 rifle."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_sr25.mdl"

Item.Weight = 12

Item.Volume = 10

Item.CanDrop = true

Item.DropClass = "fas2_sr25"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_sr25"

Item.PacOutfit = "sr25_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 18

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 2,

    ["Trigger"] = 2,

    ["Stock"] = 3,

    ["Handle Grip"] = 3,

    ["Long Barrel"] = 2,

    ["Lower Receiver"] = 5,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "3759011901",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_sr25@@1",

						},

					},

				},

				["self"] = {

					["Position"] = Vector(-1.1805114746094, -2.1366577148438, -9.0991287231445),

					["Angles"] = Angle(-2.9162585735321, -177.65454101563, -12.110625267029),

					["UniqueID"] = "1484483537",

					["Size"] = 1.025,

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_sr25.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "IMI Desert Eagle"

Item.Desc = "A Desert Eagle pistol."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_deserteagle.mdl"

Item.Weight = 9

Item.Volume = 6

Item.CanDrop = true

Item.DropClass = "fas2_deagle"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "SecondaryWeapon"

Item.EquipGiveClass = "fas2_deagle"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 18

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 1,

    ["Bolt"] = 2,

    ["Trigger"] = 1,

    ["Stock"] = 2,

    ["Handle Grip"] = 2,

    ["Short Barrel"] = 2,

    ["Lower Receiver"] = 1,

    ["Slide"] = 1,

}

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "M1911"

Item.Desc = "An M1911 pistol."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_1911.mdl"

Item.Weight = 6

Item.Volume = 4

Item.CanDrop = true

Item.DropClass = "fas2_m1911"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "SecondaryWeapon"

Item.EquipGiveClass = "fas2_m1911"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 6

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 1,

    ["Bolt"] = 1,

    ["Trigger"] = 1,

    ["Handle Grip"] = 2,

    ["Short Barrel"] = 1,

    ["Lower Receiver"] = 1,

    ["Slide"] = 1,

}

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "OTs-33 Pernach"

Item.Desc = "An OTs-33 Pernach machine pistol."

Item.Type = "type_weapon"

Item.Model = "models/weapons/world/pistols/ots33.mdl"

Item.Weight = 6

Item.Volume = 4

Item.CanDrop = true

Item.DropClass = "fas2_ots33"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "SecondaryWeapon"

Item.EquipGiveClass = "fas2_ots33"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 8

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 1,

    ["Trigger"] = 2,

    ["Handle Grip"] = 2,

    ["Short Barrel"] = 1,

    ["Lower Receiver"] = 1,

    ["Slide"] = 2,

}

GM.Inv:RegisterItem( Item )





local Item = {}

Item.Name = "P226"

Item.Desc = "A P226 pistol."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_pist_p228.mdl"

Item.Weight = 6

Item.Volume = 4

Item.CanDrop = true

Item.DropClass = "fas2_p226"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "SecondaryWeapon"

Item.EquipGiveClass = "fas2_p226"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 7

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 1,

    ["Bolt"] = 1,

    ["Trigger"] = 1,

    ["Short Barrel"] = 1,

    ["Lower Receiver"] = 1,

    ["Slide"] = 1,

}

GM.Inv:RegisterItem( Item )


local Item = {}

Item.Name = "Makarov"

Item.Desc = "A Makarov pistol."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_makarov.mdl"

Item.Weight = 6

Item.Volume = 4

Item.CanDrop = true

Item.DropClass = "stalker_makarov"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "SecondaryWeapon"

Item.EquipGiveClass = "stalker_makarov"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 7

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 2,

    ["Trigger"] = 2,

    ["Stock"] = 1,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 1,

    ["Upper Receiver"] = 1,

}

GM.Inv:RegisterItem( Item )


local Item = {}

Item.Name = "GSh18"

Item.Desc = "A GSH18 pistol."

Item.Type = "type_weapon"

Item.Model = "models/weapons/gsh18.mdl"

Item.Weight = 6

Item.Volume = 4

Item.CanDrop = true

Item.DropClass = "stalker_gsh18"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "SecondaryWeapon"

Item.EquipGiveClass = "stalker_gsh18"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 7

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 2,

    ["Trigger"] = 2,

    ["Stock"] = 1,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 1,

    ["Upper Receiver"] = 1,

}

GM.Inv:RegisterItem( Item )


local Item = {}

Item.Name = "M60E3"

Item.Desc = "An M60E3 machine gun."

Item.Type = "type_weapon"

Item.Model = "models/weapons/w_m60e3.mdl"

Item.Weight = 18

Item.Volume = 15

Item.CanDrop = true

Item.DropClass = "fas2_m60e3"

Item.CanEquip = true

Item.Illegal = true

Item.EquipSlot = "PrimaryWeapon"

Item.EquipGiveClass = "fas2_m60e3"

Item.PacOutfit = "rpk_back"



Item.CraftingEntClass = "ent_assembly_table"

Item.CraftingTab = "Weapons"

Item.CraftSkill = "Gun Smithing"

Item.CraftSkillLevel = 25

Item.CraftSkillXP = 1

Item.CraftRecipe = {

    ["Firing Pin"] = 2,

    ["Bolt"] = 3,

    ["Trigger"] = 2,

    ["Stock"] = 2,

    ["Handle Grip"] = 2,

    ["Long Barrel"] = 2,

    ["Lower Receiver"] = 2,

    ["Upper Receiver"] = 2,

}

GM.PacModels:Register( Item.PacOutfit, {

	[1] = {

		["children"] = {

			[1] = {

				["children"] = {

					[1] = {

						["children"] = {

						},

						["self"] = {

							["Event"] = "weapon_class",

							["UniqueID"] = "312083675",

							["Operator"] = "equal",

							["ClassName"] = "event",

							["Arguments"] = "fas2_rpk@@1",

						},

					},

				},

				["self"] = {

					["Angles"] = Angle(-3.2440683841705, -178.67698669434, -22.848773956299),

					["UniqueID"] = "1484483537",

					["Position"] = Vector(-1.486930847168, -1.2796630859375, -9.1651153564453),

					["EditorExpand"] = true,

					["Bone"] = "spine 2",

					["Model"] = "models/weapons/w_ak47.mdl",

					["ClassName"] = "model",

				},

			},

		},

		["self"] = {

			["EditorExpand"] = true,

			["UniqueID"] = "239303487",

			["ClassName"] = "group",

			["Name"] = "my outfit",

			["Description"] = "add parts to me!",

		},

	},

} )

GM.Inv:RegisterItem( Item )



-- FIREARM SOURCE