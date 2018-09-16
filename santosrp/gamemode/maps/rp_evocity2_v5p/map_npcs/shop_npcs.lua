--[[
	Name: shop_npcs.lua
	For: SantosRP
	By: Ultra
]]--

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_dealer",
	pos = { Vector( 1482, -2349, 240 ) },
	angs = { Angle( 0, 108, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_spawn",
	pos = { Vector( 1993, -2463, 76 ) },
	angs = { Angle( 0, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "property_buy",
	pos = { Vector( 1051, -1249, 76 ) },
	angs = { Angle( 0, -180, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( -7686, 1219, 148 ) },
	angs = { Angle( 0, 0, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "electronics_clerk",
	pos = { Vector( -2464, -1752, 76 ) },
	angs = { Angle( 0, 0, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "hardware_clerk",
	pos = { Vector( -2415, -1403, 76 ) },
	angs = { Angle( 0, 90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "clothing_clerk",
	pos = { Vector( -2555, -2553, 76 ) },
	angs = { Angle( 0, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "book_clerk",
	pos = { Vector( 10153, -11986, -1718 ) },
	angs = { Angle( 0, 90, 0 ) },
}

local randPos = table.Random( GAMEMODE.Config.DrugNPCPositions )
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "drug_buyer",
	pos = { randPos[1] },
	angs = { randPos[2] },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "home_items_clerk",
	pos = { Vector( 4085, -2820, 76 ) },
	angs = { Angle( 0, 180, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "club_foods_clerk",
	pos = { Vector( 8212.207031, 6375.868164, 70.1 ) },
	angs = { Angle( 0, 33, 0 ) },
}