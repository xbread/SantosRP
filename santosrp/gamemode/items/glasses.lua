--[[
	Name: glasses.lua
	For: TalosLife
	By: TalosLife
]]--

local Item = {}
Item.Name = "Aviators"
Item.Desc = "Aviator glasses."
Item.Type = "type_clothing"
Item.Model = "models/modified/aviators.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanEquip = true
Item.EquipSlot = "Eyes"
Item.PacOutfit = "aviators"

Item.ClothingMenuCat = "Glasses"
Item.ClothingMenuItemName = "Aviators"
Item.ClothingMenuPrice = 10

GM.PacModels:Register( Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {},
				["self"] = {
					["Angles"] = Angle(2.7020609378815, -76.87100982666, -88.916572570801),
					["UniqueID"] = "3880120277",
					["Position"] = Vector(2.3573303222656, 0.2515869140625, 0.1302490234375),
					["Passes"] = 0.6,
					["Model"] = "models/modified/aviators.mdl",
					["ClassName"] = "model",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["OwnerName"] = "self",
			["UniqueID"] = "2346440670",
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
					["Angles"] = Angle(0, -76.87100982666, -88.916999816895),
					["UniqueID"] = "3880120277",
					["Position"] = Vector(1.3399353027344, -0.52081298828125, -0.0570068359375),
					["Size"] = 0.9,
					["Passes"] = 0.6,
					["Model"] = "models/modified/aviators.mdl",
					["ClassName"] = "model",
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "503508723",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )
GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
GM.Inv:RegisterItem( Item )

-- ----------------------------------------------------------------

for i = 1, 6 do
	local Item = {}
	Item.Name = "Glasses 1 (Skin ".. i.. ")"
	Item.Desc = "A pair of glasses."
	Item.Type = "type_clothing"
	Item.Model = "models/modified/glasses01.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Eyes"
	Item.PacOutfit = "glasses1_".. (i -1)

	Item.ClothingMenuCat = "Glasses"
	Item.ClothingMenuItemName = "Glasses 1"
	Item.ClothingMenuPrice = 10

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(1.0014785528183, -79.47785949707, -89.399063110352),
						["UniqueID"] = "3880120277",
						["Position"] = Vector(2.6703491210938, -0.16461181640625, 0.0250244140625),
						["Passes"] = 0.6,
						["Model"] = "models/modified/glasses01.mdl",
						["ClassName"] = "model",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "3559228583",
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
						["Angles"] = Angle(0, -84.816207885742, -89.494850158691),
						["UniqueID"] = "3880120277",
						["Position"] = Vector(2.0667114257813, 0.072265625, 0.04473876953125),
						["Passes"] = 0.6,
						["Model"] = "models/modified/glasses01.mdl",
						["ClassName"] = "model",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "919676900",
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
	Item.Name = "Glasses 2 (Skin ".. i.. ")"
	Item.Desc = "A pair of glasses."
	Item.Type = "type_clothing"
	Item.Model = "models/modified/glasses_3.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Eyes"
	Item.PacOutfit = "glasses2_".. (i -1)

	Item.ClothingMenuCat = "Glasses"
	Item.ClothingMenuItemName = "Glasses 2"
	Item.ClothingMenuPrice = 10

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(-0.87159264087677, -75.281692504883, -89.33130645752),
						["UniqueID"] = "3880120277",
						["Position"] = Vector(2.3961486816406, -0.0008544921875, -0.048263549804688),
						["Passes"] = 0.6,
						["Model"] = "models/modified/glasses_3.mdl",
						["ClassName"] = "model",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "2364297872",
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
						["Angles"] = Angle(0.061968613415956, -80.587074279785, -89.33423614502),
						["UniqueID"] = "3880120277",
						["Position"] = Vector(1.7431335449219, -0.11151123046875, -0.034149169921875),
						["Passes"] = 0.6,
						["Model"] = "models/modified/glasses_3.mdl",
						["ClassName"] = "model",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "505673117",
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

for i = 1, 5 do
	local Item = {}
	Item.Name = "Glasses 3 (Skin ".. i.. ")"
	Item.Desc = "A pair of glasses."
	Item.Type = "type_clothing"
	Item.Model = "models/modified/glasses02.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Eyes"
	Item.PacOutfit = "glasses3_".. (i -1)

	Item.ClothingMenuCat = "Glasses"
	Item.ClothingMenuItemName = "Glasses 3"
	Item.ClothingMenuPrice = 10

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(0.50712621212006, -75.589408874512, -89.242538452148),
						["UniqueID"] = "3880120277",
						["Position"] = Vector(2.5024108886719, -0.45269775390625, 0.0066909790039063),
						["Passes"] = 0.6,
						["Model"] = "models/modified/glasses02.mdl",
						["ClassName"] = "model",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "2364297872",
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
						["Angles"] = Angle(-0.027301972731948, -82.05428314209, -89.329490661621),
						["UniqueID"] = "3880120277",
						["Position"] = Vector(1.7593231201172, -0.80096435546875, -0.00177001953125),
						["ClassName"] = "model",
						["Passes"] = 0.6,
						["Model"] = "models/modified/glasses02.mdl",
						["Scale"] = Vector(1, 0.94999998807907, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "680926543",
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

for i = 1, 5 do
	local Item = {}
	Item.Name = "Glasses 4 (Skin ".. i.. ")"
	Item.Desc = "A pair of glasses."
	Item.Type = "type_clothing"
	Item.Model = "models/modified/glasses_4.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Eyes"
	Item.PacOutfit = "glasses4_".. (i -1)

	Item.ClothingMenuCat = "Glasses"
	Item.ClothingMenuItemName = "Glasses 4"
	Item.ClothingMenuPrice = 10

	GM.PacModels:Register( "glasses4_".. (i -1), {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(1.4426789283752, -80.986824035645, -89.390594482422),
						["UniqueID"] = "3880120277",
						["Position"] = Vector(2.9739074707031, 0.70550537109375, 0.017730712890625),
						["Passes"] = 0.6,
						["Model"] = "models/modified/glasses_4.mdl",
						["ClassName"] = "model",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "2364297872",
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
						["Angles"] = Angle(-0.0042791129089892, -84.540626525879, -89.493804931641),
						["UniqueID"] = "3880120277",
						["Position"] = Vector(2.1488647460938, 0.44354248046875, -0.01080322265625),
						["Passes"] = 0.6,
						["Model"] = "models/modified/glasses_4.mdl",
						["ClassName"] = "model",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "871255264",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end