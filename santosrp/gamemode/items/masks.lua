--[[
	Name: masks.lua
	For: TalosLife
	By: TalosLife
]]--

-------------------------------------------------------------------------------

for i = 1, 3 do
	local Item = {}
	Item.Name = "Doctor Mask (Skin ".. i.. ")"
	Item.Desc = "A mask."
	Item.Type = "type_clothing"
	Item.Model = "models/sal/halloween/doctor.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Face"
	Item.PacOutfit = "doctormask_".. (i -1)

	Item.ClothingMenuCat = "Masks"
	Item.ClothingMenuItemName = "Doctor Mask"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(-0.23924688994884, -75.360595703125, -90.536819458008),
						["Position"] = Vector(0.64466857910156, -0.91094970703125, 0.02960205078125),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/halloween/doctor.mdl",
						["Scale"] = Vector(0.89999997615814, 0.89999997615814, 0.89999997615814),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "29784825",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

for i = 1, 4 do
	local Item = {}
	Item.Name = "Head Wrap 1 (Skin ".. i.. ")"
	Item.Desc = "A head wrap."
	Item.Type = "type_clothing"
	Item.Model = "models/sal/halloween/headwrap1.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Face"
	Item.PacOutfit = "headwrap1_".. (i -1)

	Item.ClothingMenuCat = "Masks"
	Item.ClothingMenuItemName = "Head Wrap 1"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(-0.26489961147308, -78.132667541504, -90.524635314941),
						["Position"] = Vector(0.7626953125, -1.012939453125, 0.052581787109375),
						["ClassName"] = "model",
						["Model"] = "models/sal/halloween/headwrap1.mdl",
						["UniqueID"] = "209812177",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "1379974504",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.PacModels:Register( "female_".. Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Angles"] = Angle(-0.33434307575226, -86.018409729004, -90.483337402344),
						["Position"] = Vector(0.50421142578125, -1.0315551757813, 0.05499267578125),
						["ClassName"] = "model",
						["Size"] = 0.925,
						["Model"] = "models/sal/halloween/headwrap1.mdl",
						["UniqueID"] = "209812177",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "225780283",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

for i = 1, 4 do
	local Item = {}
	Item.Name = "Head Wrap 2 (Skin ".. i.. ")"
	Item.Desc = "A head wrap."
	Item.Type = "type_clothing"
	Item.Model = "models/sal/halloween/headwrap2.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Face"
	Item.PacOutfit = "headwrap2_".. (i -1)

	Item.ClothingMenuCat = "Masks"
	Item.ClothingMenuItemName = "Head Wrap 2"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(0.25897008180618, -78.13745880127, -90.524635314941),
						["Position"] = Vector(0.74317932128906, -0.99993896484375, 0.15255737304688),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/halloween/headwrap2.mdl",
						["Scale"] = Vector(1, 0.89999997615814, 0.89999997615814),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "2898387808",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.PacModels:Register( "female_".. Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Angles"] = Angle(0.18417976796627, -86.055656433105, -90.555320739746),
						["Position"] = Vector(0.36099243164063, -0.9268798828125, 0.15615844726563),
						["ClassName"] = "model",
						["Size"] = 0.95,
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/halloween/headwrap2.mdl",
						["Scale"] = Vector(1, 0.89999997615814, 0.89999997615814),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "183990628",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

for i = 1, 15 do
	local Item = {}
	Item.Name = "Mask 1 (Skin ".. i.. ")"
	Item.Desc = "A mask."
	Item.Type = "type_clothing"
	Item.Model = "models/sal/acc/fix/mask_2.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Face"
	Item.PacOutfit = "mask_1_".. (i -1)

	Item.ClothingMenuCat = "Masks"
	Item.ClothingMenuItemName = "Mask 1"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(0.35900056362152, -78.697257995605, -89.233215332031),
						["Position"] = Vector(1.4432067871094, -1.244873046875, -0.05841064453125),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/acc/fix/mask_2.mdl",
						["Scale"] = Vector(0.89999997615814, 0.80000001192093, 0.80000001192093),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "2613660395",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.PacModels:Register( "female_".. Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Angles"] = Angle(0.47308132052422, -87.568542480469, -89.29776763916),
						["Position"] = Vector(1.2700653076172, -1.2521362304688, -0.06048583984375),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/acc/fix/mask_2.mdl",
						["Scale"] = Vector(0.89999997615814, 0.80000001192093, 0.80000001192093),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "181485678",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

for i = 1, 9 do
	local Item = {}
	Item.Name = "Mask 2 (Skin ".. i.. ")"
	Item.Desc = "A mask."
	Item.Type = "type_clothing"
	Item.Model = "models/sal/acc/fix/mask_4.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Face"
	Item.PacOutfit = "mask_2_".. (i -1)

	Item.ClothingMenuCat = "Masks"
	Item.ClothingMenuItemName = "Mask 2"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(0.31379926204681, -75.365798950195, -89.213645935059),
						["Position"] = Vector(0.73045349121094, -1.318359375, -0.008544921875),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/acc/fix/mask_4.mdl",
						["Scale"] = Vector(0.89999997615814, 0.80000001192093, 0.80000001192093),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "1817484290",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.PacModels:Register( "female_".. Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Angles"] = Angle(0.4387209713459, -84.824768066406, -89.275917053223),
						["Position"] = Vector(0.56289672851563, -1.3333129882813, -0.010528564453125),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/acc/fix/mask_4.mdl",
						["Scale"] = Vector(0.89999997615814, 0.80000001192093, 0.80000001192093),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "236868214",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

local Item = {}
Item.Name = "Mask 4"
Item.Desc = "A mask."
Item.Type = "type_clothing"
Item.Model = "models/modified/mask5.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanEquip = true
Item.EquipSlot = "Face"
Item.PacOutfit = "mask_4"

Item.ClothingMenuCat = "Masks"
Item.ClothingMenuItemName = "Mask 4"
Item.ClothingMenuPrice = 20

GM.PacModels:Register( Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {},
				["self"] = {
					["Angles"] = Angle(0.45277458429337, -76.420318603516, -89.221832275391),
					["Position"] = Vector(0.87838745117188, -1.4190063476563, -0.14654541015625),
					["ClassName"] = "model",
					["UniqueID"] = "209812177",
					["Model"] = "models/modified/mask5.mdl",
					["Scale"] = Vector(0.87000000476837, 0.80000001192093, 0.80000001192093),
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["OwnerName"] = "self",
			["UniqueID"] = "431006987",
			["EditorExpand"] = true,
		},
	},
} )
GM.PacModels:Register( "female_".. Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Angles"] = Angle(0.55264002084732, -84.095512390137, -89.28931427002),
					["Position"] = Vector(0.52528381347656, -1.4555053710938, -0.15060424804688),
					["ClassName"] = "model",
					["UniqueID"] = "209812177",
					["Model"] = "models/modified/mask5.mdl",
					["Scale"] = Vector(0.87000000476837, 0.80000001192093, 0.80000001192093),
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "398336169",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )
GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
GM.Inv:RegisterItem( Item )

-- ----------------------------------------------------------------

for i = 1, 4 do
	local Item = {}
	Item.Name = "Mask 5 (Skin ".. i.. ")"
	Item.Desc = "A mask."
	Item.Type = "type_clothing"
	Item.Model = "models/modified/mask6.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Face"
	Item.PacOutfit = "mask_5_".. (i -1)

	Item.ClothingMenuCat = "Masks"
	Item.ClothingMenuItemName = "Mask 5"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(2.4176585674286, -77.86971282959, -89.283172607422),
						["Position"] = Vector(0.81741333007813, -1.2211303710938, 0.00994873046875),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/mask6.mdl",
						["Scale"] = Vector(0.87999999523163, 0.75999999046326, 0.80000001192093),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "648983471",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.PacModels:Register( "female_".. Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Angles"] = Angle(2.5086915493011, -88.580253601074, -89.744827270508),
						["Position"] = Vector(0.4300537109375, -1.2306518554688, 0.00830078125),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/mask6.mdl",
						["Scale"] = Vector(0.87999999523163, 0.75999999046326, 0.80000001192093),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "225493810",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

for i = 1, 4 do
	local Item = {}
	Item.Name = "Monkey Mask (Skin ".. i.. ")"
	Item.Desc = "A monkey mask."
	Item.Type = "type_clothing"
	Item.Model = "models/sal/halloween/monkey.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Face"
	Item.PacOutfit = "monkey_mask_".. (i -1)

	Item.ClothingMenuCat = "Masks"
	Item.ClothingMenuItemName = "Monkey Mask"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(0.25897008180618, -78.13745880127, -89.926315307617),
						["Position"] = Vector(0.55389404296875, -0.391357421875, -0.072021484375),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/halloween/monkey.mdl",
						["Scale"] = Vector(1.1000000238419, 0.89999997615814, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "2373768565",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.PacModels:Register( "female_".. Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Angles"] = Angle(0.26763850450516, -87.794410705566, -89.97078704834),
						["Position"] = Vector(0.55389404296875, -0.391357421875, -0.072021484375),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/halloween/monkey.mdl",
						["Scale"] = Vector(1.1000000238419, 0.89999997615814, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "331781024",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

for i = 1, 11 do
	local Item = {}
	Item.Name = "Ninja Mask (Skin ".. i.. ")"
	Item.Desc = "A ninja mask."
	Item.Type = "type_clothing"
	Item.Model = "models/sal/halloween/ninja.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Face"
	Item.PacOutfit = "ninja_mask_".. (i -1)

	Item.ClothingMenuCat = "Masks"
	Item.ClothingMenuItemName = "Ninja Mask"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(2.1324779987335, -78.13500213623, -89.926246643066),
						["Position"] = Vector(0.51876831054688, -0.49639892578125, 0.01055908203125),
						["ClassName"] = "model",
						["Model"] = "models/sal/halloween/ninja.mdl",
						["UniqueID"] = "209812177",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "341121150",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.PacModels:Register( "female_".. Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Angles"] = Angle(2.1166336536407, -87.38648223877, -90.269958496094),
						["Position"] = Vector(0.5025634765625, -0.14947509765625, 0.023101806640625),
						["ClassName"] = "model",
						["Model"] = "models/sal/halloween/ninja.mdl",
						["UniqueID"] = "209812177",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "113584280",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

for i = 1, 4 do
	local Item = {}
	Item.Name = "Skull Mask (Skin ".. i.. ")"
	Item.Desc = "A skull mask."
	Item.Type = "type_clothing"
	Item.Model = "models/sal/halloween/skull.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Face"
	Item.PacOutfit = "skull_mask_".. (i -1)

	Item.ClothingMenuCat = "Masks"
	Item.ClothingMenuItemName = "Skull Mask"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(-1.010236620903, -77.61009979248, -89.906616210938),
						["Position"] = Vector(2.0240478515625, -0.5167236328125, 0.027557373046875),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/halloween/skull.mdl",
						["Scale"] = Vector(1, 0.89999997615814, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "24919899",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.PacModels:Register( "female_".. Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Angles"] = Angle(0, -87.428497314453, -89.735740661621),
						["Position"] = Vector(2.0143737792969, -0.305908203125, 0.024322509765625),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/halloween/skull.mdl",
						["Scale"] = Vector(1, 0.89999997615814, 0.89999997615814),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "356943197",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

for i = 1, 2 do
	local Item = {}
	Item.Name = "Zombie Mask (Skin ".. i.. ")"
	Item.Desc = "A zombie mask."
	Item.Type = "type_clothing"
	Item.Model = "models/sal/halloween/zombie.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Face"
	Item.PacOutfit = "zombie_mask_".. (i -1)

	Item.ClothingMenuCat = "Masks"
	Item.ClothingMenuItemName = "Zombie Mask"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(-1.010236620903, -77.61009979248, -89.906616210938),
						["Position"] = Vector(0.8955078125, -1.0062255859375, 0.05023193359375),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/halloween/zombie.mdl",
						["Scale"] = Vector(0.94999998807907, 0.89999997615814, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "4208460940",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.PacModels:Register( "female_".. Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Angles"] = Angle(-0.96580547094345, -90.150459289551, -89.68953704834),
						["Position"] = Vector(0.068817138671875, -0.7418212890625, 0.041473388671875),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/halloween/zombie.mdl",
						["Scale"] = Vector(0.94999998807907, 1, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "289825119",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

for i = 1, 26 do
	local Item = {}
	Item.Name = "Bag Mask (Skin ".. i.. ")"
	Item.Desc = "A bag mask."
	Item.Type = "type_clothing"
	Item.Model = "models/sal/halloween/bag.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Face"
	Item.PacOutfit = "bag_mask_".. (i -1)

	Item.ClothingMenuCat = "Masks"
	Item.ClothingMenuItemName = "Bag Mask"
	Item.ClothingMenuPrice = 20
	
	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(0.31379926204681, -75.365798950195, -90.536766052246),
						["Position"] = Vector(1.0636596679688, -1.1539916992188, 0.0080108642578125),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/sal/halloween/bag.mdl",
						["Scale"] = Vector(1, 0.89999997615814, 0.89999997615814),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "1817484290",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.Inv:RegisterItem( Item )
end

-- ---------------------------------------------------------------- RUSTIC 7 ADDED&BROKE

local Item = {}
Item.Name = "Cookie Face"
Item.Desc = "A mask."
Item.Type = "type_clothing"
Item.Model = "models/sal/gingerbread.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanEquip = true
Item.EquipSlot = "Face"
Item.PacOutfit = "gingerbread"

Item.ClothingMenuCat = "Masks"
Item.ClothingMenuItemName = "Cookie Face"
Item.ClothingMenuPrice = 200

GM.PacModels:Register( Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {},
				["self"] = {
					["Angles"] = Angle(-1.0215491056442, -77.068084716797, -90.51749420166),
					["Position"] = Vector(-62.645050048828, -15.724487304688, 0.62237548828125),
					["ClassName"] = "model",
					["Model"] = "models/sal/gingerbread.mdl",
					["UniqueID"] = "209812177",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["OwnerName"] = "self",
			["UniqueID"] = "3319913860",
			["EditorExpand"] = true,
		},
	},
} )
GM.Inv:RegisterItem( Item )

-- ----------------------------------------------------------------

local Item = {}
Item.Name = "Bear Mask"
Item.Desc = "A bear mask."
Item.Type = "type_clothing"
Item.Model = "models/sal/bear.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanEquip = true
Item.EquipSlot = "Face"
Item.PacOutfit = "bear_mask"

Item.ClothingMenuCat = "Masks"
Item.ClothingMenuItemName = "Bear Mask"
Item.ClothingMenuPrice = 20

GM.PacModels:Register( Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {},
				["self"] = {
					["Angles"] = Angle(-1.0215491056442, -77.068084716797, -90.51749420166),
					["Position"] = Vector(-23.652435302734, -6.1498413085938, 0.26165771484375),
					["ClassName"] = "model",
					["UniqueID"] = "209812177",
					["Model"] = "models/sal/bear.mdl",
					["Scale"] = Vector(1.1000000238419, 0.80000001192093, 0.89999997615814),
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["OwnerName"] = "self",
			["UniqueID"] = "3798068848",
			["EditorExpand"] = true,
		},
	},
} )
GM.PacModels:Register( "female_".. Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Angles"] = Angle(-1.0215491056442, -77.068084716797, -90.51749420166),
					["Position"] = Vector(-25.340763092041, -5.9835815429688, 0.24252319335938),
					["ClassName"] = "model",
					["UniqueID"] = "209812177",
					["Model"] = "models/sal/bear.mdl",
					["Scale"] = Vector(0.89999997615814, 0.80000001192093, 0.89999997615814),
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "250963276",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )
GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
GM.Inv:RegisterItem( Item )

-- ----------------------------------------------------------------

local Item = {}
Item.Name = "Horse Mask"
Item.Desc = "A horse mask."
Item.Type = "type_clothing"
Item.Model = "models/horsie/horsiemask.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanEquip = true
Item.EquipSlot = "Face"
Item.PacOutfit = "horse_mask"

Item.ClothingMenuCat = "Masks"
Item.ClothingMenuItemName = "Horse Mask"
Item.ClothingMenuPrice = 20

GM.PacModels:Register( Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {},
				["self"] = {
					["Angles"] = Angle(74.985855102539, -64.123222351074, -87.659126281738),
					["Position"] = Vector(3.69384765625, -3.595703125, 1.1826171875),
					["ClassName"] = "model",
					["Model"] = "models/horsie/horsiemask.mdl",
					["UniqueID"] = "1062430989",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["OwnerName"] = "self",
			["UniqueID"] = "3798068848",
			["EditorExpand"] = true,
		},
	},
} )
GM.Inv:RegisterItem( Item )

-- ----------------------------------------------------------------

local Item = {}
Item.Name = "Raccoon Mask"
Item.Desc = "A raccoon mask."
Item.Type = "type_clothing"
Item.Model = "models/sal/racoon.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanEquip = true
Item.EquipSlot = "Face"
Item.PacOutfit = "raccon_mask"

Item.ClothingMenuCat = "Masks"
Item.ClothingMenuItemName = "Raccoon Mask"
Item.ClothingMenuPrice = 20

GM.PacModels:Register( Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {},
				["self"] = {
					["Angles"] = Angle(-4.270721912384, -78.693031311035, -90.066482543945),
					["Position"] = Vector(-28.951171875, -6.7183227539063, 0.053741455078125),
					["ClassName"] = "model",
					["UniqueID"] = "209812177",
					["Model"] = "models/sal/racoon.mdl",
					["Scale"] = Vector(1, 1, 1.1000000238419),
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["OwnerName"] = "self",
			["UniqueID"] = "3798068848",
			["EditorExpand"] = true,
		},
	},
} )
GM.Inv:RegisterItem( Item )

-- ----------------------------------------------------------------

local Item = {}
Item.Name = "Balaclava"
Item.Desc = "A balaclava."
Item.Type = "type_clothing"
Item.Model = "models/sal/burgle.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanEquip = true
Item.EquipSlot = "Face"
Item.PacOutfit = "burgle_mask"

Item.ClothingMenuCat = "Masks"
Item.ClothingMenuItemName = "Balaclava"
Item.ClothingMenuPrice = 20

GM.PacModels:Register( Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {},
				["self"] = {
					["Angles"] = Angle(-1.0123730897903, -76.068428039551, -90.53524017334),
					["Position"] = Vector(-62.542388916016, -15.977172851563, 0.58953857421875),
					["ClassName"] = "model",
					["Model"] = "models/sal/burgle.mdl",
					["UniqueID"] = "209812177",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["OwnerName"] = "self",
			["UniqueID"] = "1522067600",
			["EditorExpand"] = true,
		},
	},
} )
GM.PacModels:Register( "female_".. Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Angles"] = Angle(-1.0123730897903, -76.068428039551, -90.53524017334),
					["Position"] = Vector(-56.959575653076, -14.628479003906, 0.514404296875),
					["ClassName"] = "model",
					["UniqueID"] = "209812177",
					["Model"] = "models/sal/burgle.mdl",
					["Scale"] = Vector(0.94999998807907, 0.89999997615814, 0.89999997615814),
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "210413036",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )
GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
GM.Inv:RegisterItem( Item )