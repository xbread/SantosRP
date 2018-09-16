--[[
	Name: neck_items.lua
	For: TalosLife
	By: TalosLife
]]--

local Item = {}
Item.Name = "Bandana"
Item.Desc = "A bandana."
Item.Type = "type_clothing"
Item.Model = "models/modified/bandana.mdl"
Item.Weight = 1
Item.Volume = 1
Item.CanDrop = true
Item.CanEquip = true
Item.EquipSlot = "Neck"
Item.PacOutfit = "bandana"

Item.ClothingMenuCat = "Neckwear"
Item.ClothingMenuItemName = "Bandana"
Item.ClothingMenuPrice = 800

GM.PacModels:Register( Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {},
				["self"] = {
					["Angles"] = Angle(-1.1042726039886, -87.110969543457, -89.747604370117),
					["Position"] = Vector(-0.38726806640625, -0.10284423828125, -0.045135498046875),
					["ClassName"] = "model",
					["UniqueID"] = "209812177",
					["Model"] = "models/modified/bandana.mdl",
					["Scale"] = Vector(1.1499999761581, 0.98000001907349, 1),
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["OwnerName"] = "self",
			["UniqueID"] = "186508818",
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
					["Angles"] = Angle(-1.1042726039886, -87.110969543457, -89.747604370117),
					["Position"] = Vector(-1.5002212524414, -0.01043701171875, -0.058563232421875),
					["ClassName"] = "model",
					["UniqueID"] = "209812177",
					["Model"] = "models/modified/bandana.mdl",
					["Scale"] = Vector(1.0499999523163, 0.98000001907349, 1),
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "367889536",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )
GM.PacModels:RegisterOutfitModelOverload( Item.PacOutfit, GM.Config.PlayerModels.Female, "female_".. Item.PacOutfit )
GM.Inv:RegisterItem( Item )

-- ----------------------------------------------------------------