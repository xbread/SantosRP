--[[
	Name: bags.lua
	For: TalosLife
	By: TalosLife
]]--

for i = 1, 3 do
	local Item = {}
	Item.Name = "Backpack 1 (Skin ".. i.. ")"
	Item.Desc = "A backpack."
	Item.Type = "type_clothing"
	Item.Model = "models/modified/backpack_1.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true

	Item.EquipSlot = "Back"
	Item.PacOutfit = "backpack1_".. (i -1)
	Item.Stats = [[+100 Inventory Weight
+150 Inventory Volume]]

	Item.EquipBoostCarryWeight = 100
	Item.EquipBoostCarryVolume = 150

	Item.ClothingMenuCat = "Bags"
	Item.ClothingMenuItemName = "Backpack 1"
	Item.ClothingMenuPrice = 50

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(-2.2549149990082, 103.04399108887, 89.099395751953),
						["UniqueID"] = "1484483537",
						["Position"] = Vector(3.8101043701172, 2.7722778320313, -0.1195068359375),
						["Bone"] = "spine 1",
						["Model"] = "models/modified/backpack_1.mdl",
						["ClassName"] = "model",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "706994644",
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
						["Angles"] = Angle(0.58343929052353, 95.733207702637, 89.392776489258),
						["UniqueID"] = "1484483537",
						["Position"] = Vector(-1.6768951416016, 1.4813537597656, -0.069732666015625),
						["ClassName"] = "model",
						["Bone"] = "spine 2",
						["Model"] = "models/modified/backpack_1.mdl",
						["Scale"] = Vector(0.89999997615814, 1, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "672390180",
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

for i = 1, 3 do
	local Item = {}
	Item.Name = "Backpack 2 (Skin ".. i.. ")"
	Item.Desc = "A backpack."
	Item.Type = "type_clothing"
	Item.Model = "models/modified/backpack_2.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Back"
	Item.PacOutfit = "backpack2_".. (i -1)
	Item.Stats = [[+150 Inventory Weight
+175 Inventory Volume]]

	Item.EquipBoostCarryWeight = 150
	Item.EquipBoostCarryVolume = 175

	Item.ClothingMenuCat = "Bags"
	Item.ClothingMenuItemName = "Backpack 2"
	Item.ClothingMenuPrice = 50

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(2.1630403995514, 96.995300292969, 91.88899230957),
						["UniqueID"] = "1484483537",
						["Position"] = Vector(5.5845947265625, 2.4451904296875, -0.2005615234375),
						["ClassName"] = "model",
						["Bone"] = "spine 1",
						["Model"] = "models/modified/backpack_2.mdl",
						["Scale"] = Vector(0.97000002861023, 1, 0.94999998807907),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "1111652714",
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
						["Angles"] = Angle(2.1842617988586, 95.204307556152, 90.645835876465),
						["UniqueID"] = "1484483537",
						["Position"] = Vector(0.27727508544922, 1.0806579589844, -0.038299560546875),
						["ClassName"] = "model",
						["Bone"] = "spine 2",
						["Model"] = "models/modified/backpack_2.mdl",
						["Scale"] = Vector(0.8299999833107, 0.80000001192093, 0.94999998807907),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "739210028",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

-------------------------------------------------------------------

for i = 1, 2 do
	local Item = {}
	Item.Name = "Backpack 3 (Skin ".. i.. ")"
	Item.Desc = "A backpack."
	Item.Type = "type_clothing"
	Item.Model = "models/modified/backpack_3.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = true
	Item.CanEquip = true
	Item.EquipSlot = "Back"
	Item.PacOutfit = "backpack3_".. (i -1)
	Item.Stats = [[+80 Inventory Weight
+100 Inventory Volume]]

	Item.EquipBoostCarryWeight = 80
	Item.EquipBoostCarryVolume = 100

	Item.ClothingMenuCat = "Bags"
	Item.ClothingMenuItemName = "Backpack 3"
	Item.ClothingMenuPrice = 50

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(1.8635333776474, 103.36968231201, 88.196571350098),
						["UniqueID"] = "1484483537",
						["Position"] = Vector(4.2387275695801, 2.1855773925781, 0.0042724609375),
						["Bone"] = "spine 1",
						["Model"] = "models/modified/backpack_3.mdl",
						["ClassName"] = "model",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "1881984557",
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
						["Angles"] = Angle(2.8758752346039, 94.99193572998, 88.177467346191),
						["UniqueID"] = "1484483537",
						["Position"] = Vector(-1.5196228027344, 0.91940307617188, -0.30667114257813),
						["ClassName"] = "model",
						["Bone"] = "spine 2",
						["Model"] = "models/modified/backpack_3.mdl",
						["Scale"] = Vector(0.80000001192093, 0.89999997615814, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "719887665",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end

-------------------------------------------------------------------

for i = 1, 2 do
	local Item = {}
	Item.Name = "K-Throat VIP Backpack"
	Item.Desc = "A backpack."
	Item.Type = "type_clothing"
	Item.Model = "models/modified/backpack_3.mdl"
	Item.Skin = i -1
	Item.Weight = 1
	Item.Volume = 1
	Item.CanDrop = false
	Item.CanEquip = true
	Item.EquipSlot = "Back"
	Item.PacOutfit = "backpack3_".. (i -1)
	Item.Stats = [[+2000 Inventory Weight
+2000 Inventory Volume]]

	Item.EquipBoostCarryWeight = 2000
	Item.EquipBoostCarryVolume = 2000

	GM.PacModels:Register( Item.PacOutfit, {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {},
					["self"] = {
						["Angles"] = Angle(1.8635333776474, 103.36968231201, 88.196571350098),
						["UniqueID"] = "1484483537",
						["Position"] = Vector(4.2387275695801, 2.1855773925781, 0.0042724609375),
						["Bone"] = "spine 1",
						["Model"] = "models/modified/backpack_3.mdl",
						["ClassName"] = "model",
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["UniqueID"] = "1881984557",
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
						["Angles"] = Angle(2.8758752346039, 94.99193572998, 88.177467346191),
						["UniqueID"] = "1484483537",
						["Position"] = Vector(-1.5196228027344, 0.91940307617188, -0.30667114257813),
						["ClassName"] = "model",
						["Bone"] = "spine 2",
						["Model"] = "models/modified/backpack_3.mdl",
						["Scale"] = Vector(0.80000001192093, 0.89999997615814, 1),
						["Skin"] = (i -1),
					},
				},
			},
			["self"] = {
				["EditorExpand"] = true,
				["UniqueID"] = "719887665",
				["ClassName"] = "group",
				["Name"] = "my outfit",
				["Description"] = "add parts to me!",
			},
		},
	} )
	GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
	GM.Inv:RegisterItem( Item )
end