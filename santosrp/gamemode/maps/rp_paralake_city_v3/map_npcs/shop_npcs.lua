--[[
	Name: shop_npcs.lua
	
		
]]--

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_dealer",
	pos = { Vector( -9288.436523, -10911.519531, 488.031250 ) },
	angs = { Angle( 0, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_spawn",
	pos = { Vector( -4601.084961, 2092.480225, 290 ) },
	angs = { Angle( 0, 90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "property_buy",
	pos = { Vector( -4895.968750, 5079.993652, 352.031250 ) },
	angs = { Angle( 0, 180, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( -11421.111328, 10700.489258, 64.031250 ) },
	angs = { Angle( 0, -180, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( -6571.669434, 1071.968750, 292.031250 ) },
	angs = { Angle( 0, 90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( -8731.611328, -7247.968750, 292.031250 ) },
	angs = { Angle( 0, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "electronics_clerk",
	pos = { Vector( -12291.811523, -12607.968750, 356.031250 ) },
	angs = { Angle( 0, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "hardware_clerk",
	pos = { Vector( -7165.108887, 3871.968750, 364.031250 ) },
	angs = { Angle( 0, 90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "clothing_clerk",
	pos = { Vector( -11451.988281, -12663.968750, 293 ) },
	angs = { Angle( 0, -90, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "clothing_clerk",
	pos = { Vector( 4114.687012, 12637.500000, 80.031258 ) },
	angs = { Angle( 0, 0, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "book_clerk",
	pos = { Vector( -4723.417480, 12408.461914, 481.031250 ) },
	angs = { Angle( 0, -90, 0 ) },
}

local randPos = table.Random( GAMEMODE.Config.DrugNPCPositions )
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "drug_buyer",
	pos = { randPos[1] },
	angs = { randPos[2] },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "home_items_clerk",
	pos = { Vector( -7527.968750, 3953.316406, 384.031250 ) },
	angs = { Angle( 0, -180, 0 ) },
}

GAMEMODE.Map:RegisterNPCSpawn{
	UID = "club_foods_clerk",
	pos = { Vector( -12019.682617, -11566.031250, 356.031250 ) },
	angs = { Angle( 0, 63, 0 ) },
}