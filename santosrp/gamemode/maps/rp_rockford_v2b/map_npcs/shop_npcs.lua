--[[
	Name: shop_npcs.lua
	
		
]]--

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_dealer",
	pos = { Vector( -4432.285645, -679.968750, 64.031250 ) },
	angs = { Angle( 0, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_spawn",
	pos = { Vector( -11211.335938, -3896.824951, -207.968750 ) },
	angs = { Angle( 0, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "property_buy",
	pos = { Vector( -1078.631714, 6616.013672, 544.031250 ) },
	angs = { Angle( 0, -170, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( 1004.031250, 4033.197510, 580.031250 ) },
	angs = { Angle( 0, 180, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( -14636.031250, 2688.006592, 400.031250 ) },
	angs = { Angle( 0, 0, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "electronics_clerk",
	pos = { Vector( 1580.474243, 3527.604004, 544.031250 ) },
	angs = { Angle( 0, 0, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "hardware_clerk",
	pos = { Vector( -7593.268066, -3200.784180, 8.031258 ) },
	angs = { Angle( 0, 0, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "clothing_clerk",
	pos = { Vector( 2013.968750, 3882.754639, 608.031250 ) },
	angs = { Angle( 0, 0, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "book_clerk",
	pos = { Vector( 2008.174194, 1440.177734, 544.031250 ) },
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
	pos = { Vector( 1568.338501, 1966.125366, 544.031250 ) },
	angs = { Angle( 0, 0, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "club_foods_clerk",
	pos = { Vector( 1584.654297, 6182.375977, 638.031250 ) },
	angs = { Angle( 0, -110, 0 ) },
}