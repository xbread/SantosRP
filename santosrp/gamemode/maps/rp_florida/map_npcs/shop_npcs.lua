--[[
	Name: shop_npcs.lua
	For: santosrp
	By: santosrp
]]--

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_dealer",
	pos = { Vector( -2032, -3179, 190 ) },
	angs = { Angle( 0, 0, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_spawn",
	pos = { Vector( -1767, -713, 136 ) },
	angs = { Angle( 0, 180, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "property_buy",
	pos = { Vector( 5265, 3554, 136 ) },
	angs = { Angle( 0, 90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( 1185, -167, 136 ) },
	angs = { Angle( 0, 270, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "electronics_clerk",
	pos = { Vector( 7035, 3542, 136 ) },
	angs = { Angle( 0, 90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "hardware_clerk",
	pos = { Vector( 3852, -2445, 136 ) },
	angs = { Angle( 0, 0, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "clothing_clerk",
	pos = { Vector( 5359, -3551, 136 ) },
	angs = { Angle( 0, 180, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "book_clerk",
	pos = { Vector( 4015, -4559, 136 ) },
	angs = { Angle( 0, 270, 0 ) },
}

local randPos = table.Random( GAMEMODE.Config.DrugNPCPositions )
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "drug_buyer",
	pos = { randPos[1] },
	angs = { randPos[2] },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "home_items_clerk",
	pos = { Vector( 4011, -4176, 136 ) },
	angs = { Angle( 0, 270, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "club_foods_clerk",
	pos = { Vector( 4015, -4750, 136 ) },
	angs = { Angle( 0, 270, 0 ) },
}