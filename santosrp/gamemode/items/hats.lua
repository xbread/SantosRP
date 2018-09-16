--[[
	Name: hats.lua
	For: TalosLife
	By: TalosLife
]]--

for i = 1, 6 do
	local Item = {}
	Item.Name = "Hat 1 (Skin ".. i.. ")"
	Item.Desc = "A hat!"
	Item.Type = "type_clothing"
	Item.Model = "models/sal/acc/fix/beerhat.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "hat_1_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Hat 1"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(1.4918847084045, -83.569976806641, -90.140960693359),
						["Position"] = Vector(3.1406707763672, -0.3818359375, -0.0687255859375),
						["ClassName"] = "model",
						["Model"] = "models/sal/acc/fix/beerhat.mdl",
						["UniqueID"] = "209812177",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "2058691519",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

for i = 1, 8 do
local Item = {}
	Item.Name = "Hat 2 (Skin ".. i.. ")"
	Item.Desc = "A hat!"
	Item.Type = "type_clothing"
	Item.Model = "models/modified/hat01_fix.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "hat_2_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Hat 2"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(0.74745231866837, -63.848991394043, -89.977737426758),
						["Position"] = Vector(3.8207092285156, 0.2646484375, -0.052398681640625),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat01_fix.mdl",
						["Scale"] = Vector(1, 0.89999997615814, 0.89999997615814),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "2018693519",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

for i = 1, 5 do
	local Item = {}
	Item.Name = "Hat 3 (Skin ".. i.. ")"
	Item.Desc = "A hat!"
	Item.Type = "type_clothing"
	Item.Model = "models/modified/hat03.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "hat_3_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Hat 3"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(0.74703735113144, -68.221748352051, -91.627410888672),
						["Position"] = Vector(3.7014770507813, 0.0482177734375, -0.075355529785156),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat03.mdl",
						["Scale"] = Vector(1.039999961853, 1, 1.0800000429153),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "3533606796",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

for i = 1, 5 do
	local Item = {}
	Item.Name = "Hat 4 (Skin ".. i.. ")"
	Item.Desc = "A hat!"
	Item.Type = "type_clothing"
	Item.Model = "models/modified/hat04.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "hat_4_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Hat 4"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(1.1644088029861, -52.322715759277, -90.757415771484),
						["Position"] = Vector(3.0736083984375, 1.320068359375, -0.29595947265625),
						["ClassName"] = "model",
						["Model"] = "models/modified/hat04.mdl",
						["UniqueID"] = "209812177",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "1572141440",
				["EditorExpand"] = true,
			},
		},
	} )
	GM.Inv:RegisterItem( Item )
end

-- ----------------------------------------------------------------

local Item = {}
Item.Name = "Hat 5"
Item.Desc = "A hat!"
Item.Type = "type_clothing"
Item.Model = "models/modified/hat06.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanEquip = true
Item.EquipSlot = "Head"
Item.PacOutfit = "hat_5"

Item.ClothingMenuCat = "Hats"
Item.ClothingMenuItemName = "Hat 5"
Item.ClothingMenuPrice = 20

GM.PacModels:Register( Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {},
				["self"] = {
					["Angles"] = Angle(10.896186828613, -77.207176208496, -92.475463867188),
					["Position"] = Vector(4.8170776367188, -0.2227783203125, 0.23963928222656),
					["ClassName"] = "model",
					["Model"] = "models/modified/hat06.mdl",
					["UniqueID"] = "209812177",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["OwnerName"] = "self",
			["UniqueID"] = "1216746819",
			["EditorExpand"] = true,
		},
	},
} )
GM.Inv:RegisterItem( Item )

-- ----------------------------------------------------------------

for i = 1, 11 do
	local Item = {}
	Item.Name = "Hat 6 (Skin ".. i.. ")"
	Item.Desc = "A hat!"
	Item.Type = "type_clothing"
	Item.Model = "models/modified/hat07.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "hat_6_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Hat 6"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(0.31205752491951, -71.074462890625, -89.614410400391),
						["Position"] = Vector(4.2066345214844, 0.09722900390625, 0.012069702148438),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat07.mdl",
						["Scale"] = Vector(1, 1, 0.94999998807907),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "1167650586",
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
						["Angles"] = Angle(0.31205752491951, -71.074462890625, -89.614410400391),
						["Position"] = Vector(4.2066345214844, 0.09722900390625, 0.012069702148438),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat07.mdl",
						["Scale"] = Vector(1, 1, 0.94999998807907),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "909766472",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

for i = 1, 11 do
	local Item = {}
	Item.Name = "Hat 6 (Backwards) (Skin ".. i.. ")"
	Item.Desc = "A hat!"
	Item.Type = "type_clothing"
	Item.Model = "models/modified/hat07.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "hat_6_b_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Hat 6 (Backwards)"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(-5.0159196689492e-006, 108.92553710938, 89.761161804199),
						["Position"] = Vector(4.7865753173828, -1.2931518554688, -0.029329299926758),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat07.mdl",
						["Scale"] = Vector(1, 1, 0.94999998807907),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "1167650586",
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
						["Angles"] = Angle(-5.0159196689492e-006, 108.92553710938, 88),
						["Position"] = Vector(3.8746337890625, -1.3129272460938, -0.032989501953125),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat07.mdl",
						["Scale"] = Vector(1, 1, 0.94999998807907),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "614280942",
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

for i = 1, 12 do
	local Item = {}
	Item.Name = "Hat 7 (Skin ".. i.. ")"
	Item.Desc = "A hat!"
	Item.Type = "type_clothing"
	Item.Model = "models/modified/hat08.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "hat_7_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Hat 7"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(1.4283438920975, -73.315315246582, -89.626945495605),
						["Position"] = Vector(4.0590515136719, -0.3604736328125, -0.00537109375),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat08.mdl",
						["Scale"] = Vector(1, 0.94999998807907, 0.89999997615814),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "3263536383",
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
						["Angles"] = Angle(1.4283438920975, -73.315315246582, -89.626945495605),
						["Position"] = Vector(3.1804046630859, -0.62371826171875, -0.011444091796875),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat08.mdl",
						["Scale"] = Vector(1, 0.94999998807907, 0.89999997615814),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "710911671",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

for i = 1, 12 do
	local Item = {}
	Item.Name = "Hat 7 (Backwards) (Skin ".. i.. ")"
	Item.Desc = "A hat!"
	Item.Type = "type_clothing"
	Item.Model = "models/modified/hat08.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "hat_7_b_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Hat 7 (Backwards)"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(-0.15496084094048, 131.22784423828, 90.339340209961),
						["Position"] = Vector(4.5207977294922, -0.8984375, 0.058860778808594),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat08.mdl",
						["Scale"] = Vector(1, 0.94999998807907, 0.89999997615814),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "3263536383",
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
						["Angles"] = Angle(-0.15496084094048, 131.22784423828, 90.339340209961),
						["Position"] = Vector(3.3729553222656, -1.2905883789063, 0.06695556640625),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat08.mdl",
						["Scale"] = Vector(1, 0.94999998807907, 0.89999997615814),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "760346339",
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

for i = 1, 13 do
	local Item = {}
	Item.Name = "Hat 8 (Skin ".. i.. ")"
	Item.Desc = "A hat!"
	Item.Type = "type_clothing"
	Item.Model = "models/modified/hat_11.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "hat_8_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Hat 8"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(1.2673186063766, -71.937225341797, -88.757141113281),
						["Position"] = Vector(5.074462890625, 0.39404296875, 0.01397705078125),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat_11.mdl",
						["Scale"] = Vector(1, 1, 0.94999998807907),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "3912119116",
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
						["Angles"] = Angle(1.2673186063766, -71.937225341797, -88.757141113281),
						["Position"] = Vector(4.3008422851563, -0.0994873046875, -0.010986328125),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat_11.mdl",
						["Scale"] = Vector(1, 1, 0.94999998807907),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "342244288",
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

for i = 1, 13 do
	local Item = {}
	Item.Name = "Hat 9 (Skin ".. i.. ")"
	Item.Desc = "A hat!"
	Item.Type = "type_clothing"
	Item.Model = "models/modified/hat_12.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "hat_9_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Hat 9"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(1.4918854236603, -83.569976806641, -89.038208007813),
						["Position"] = Vector(4.0720672607422, 0.1629638671875, -0.064605712890625),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat_12.mdl",
						["Scale"] = Vector(1.1200000047684, 1.1000000238419, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "2676275670",
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
						["Angles"] = Angle(1.3608664274216, -76.43285369873, -88.860313415527),
						["Position"] = Vector(3.4827728271484, -0.237548828125, 0.008697509765625),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat_12.mdl",
						["Scale"] = Vector(1.1200000047684, 1.1000000238419, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "266431772",
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

for i = 1, 7 do
	local Item = {}
	Item.Name = "Hat 10 (Skin ".. i.. ")"
	Item.Desc = "A hat!"
	Item.Type = "type_clothing"
	Item.Model = "models/modified/hat_13.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "hat_10_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Hat 10"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(-2.2210850715637, -66.575874328613, -89.782775878906),
						["Position"] = Vector(5.0800170898438, 0.49560546875, -0.0015869140625),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat_13.mdl",
						["Scale"] = Vector(1, 1, 0.89999997615814),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "2771511422",
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
						["Angles"] = Angle(-2.1871836185455, -72.45092010498, -89.556648254395),
						["Position"] = Vector(4.3937072753906, 0.10150146484375, -0.001434326171875),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat_13.mdl",
						["Scale"] = Vector(1, 1, 0.89999997615814),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "600184316",
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

for i = 1, 8 do
	local Item = {}
	Item.Name = "Hat 11 (Skin ".. i.. ")"
	Item.Desc = "A hat!"
	Item.Type = "type_clothing"
	Item.Model = "models/modified/hat_14.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "hat_11_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Hat 11"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(0.56960958242416, -85.472755432129, -89.302742004395),
						["Position"] = Vector(5.174072265625, -0.1634521484375, 0.16043090820313),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat_14.mdl",
						["Scale"] = Vector(1, 0.89999997615814, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "1420120905",
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
						["Angles"] = Angle(0.56960958242416, -85.472755432129, -89.302742004395),
						["Position"] = Vector(4.1383361816406, -0.2449951171875, 0.14773559570313),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/hat_14.mdl",
						["Scale"] = Vector(1, 0.89999997615814, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "107217969",
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

for i = 1, 10 do
	local Item = {}
	Item.Name = "Bike Helmet (Skin ".. i.. ")"
	Item.Desc = "A bike helmet."
	Item.Type = "type_clothing"
	Item.Model = "models/modified/bike_1.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "bike_helmet_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Bike Helmet"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(0.74644386768341, -68.98210144043, -90.467338562012),
						["Position"] = Vector(3.8404541015625, -0.41705322265625, -0.26605224609375),
						["ClassName"] = "model",
						["Model"] = "models/modified/bike_1.mdl",
						["UniqueID"] = "209812177",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "1402927619",
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
						["Angles"] = Angle(0, -68.98210144043, -90.467338562012),
						["Position"] = Vector(2.3703346252441, -0.012786865234375, -0.25668334960938),
						["ClassName"] = "model",
						["Model"] = "models/modified/bike_1.mdl",
						["UniqueID"] = "209812177",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "243065709",
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

for i = 1, 13 do
	local Item = {}
	Item.Name = "Top-Hat (Skin ".. i.. ")"
	Item.Desc = "A top-hat."
	Item.Type = "type_clothing"
	Item.Model = "models/modified/tophat.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Head"
	Item.PacOutfit = "tophat_".. (i -1)

	Item.ClothingMenuCat = "Hats"
	Item.ClothingMenuItemName = "Top-Hat"
	Item.ClothingMenuPrice = 20

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Angles"] = Angle(2.4389314651489, -79.660377502441, -89.427040100098),
						["Position"] = Vector(5.3080902099609, 0.44097900390625, 0.023193359375),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/tophat.mdl",
						["Scale"] = Vector(1.0499999523163, 1, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "4162399392",
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
						["Angles"] = Angle(2.4389314651489, -79.660377502441, -89.427040100098),
						["Position"] = Vector(3.8327331542969, -0.4521484375, -0.019500732421875),
						["ClassName"] = "model",
						["UniqueID"] = "209812177",
						["Model"] = "models/modified/tophat.mdl",
						["Scale"] = Vector(1.0499999523163, 1.1000000238419, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "2428039145",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end