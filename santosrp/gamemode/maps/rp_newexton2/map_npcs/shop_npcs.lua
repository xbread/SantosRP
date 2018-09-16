--[[
	Name: shop_npcs.lua
	For: SantosRP
	By: DFG SantosRP
]]--
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_dealer",
	pos = { Vector( -4536.218750, -666.625000, -13922.843750 ) },
	angs = { Angle( 0, -89, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "car_spawn",
	pos = { Vector( -7123.062500, -1432.500000, -13907.343750 ) },
	angs = { Angle( 0, 180, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "property_buy",
	pos = { Vector( -1075.281250, 6613.031738, -13407.968750 ) },
	angs = { Angle( 0, 177, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( 1001.000061, 3907.781250, -13399.968750 ) },
	angs = { Angle( 0, -179, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( -1162.968750, 5750.593750, -13399.968750 ) },
	angs = { Angle( 0, -179, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "gas_clerk",
	pos = { Vector( -14646.812500, 2689.875000, -13551.968750 ) },
	angs = { Angle( 0, 0, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "electronics_clerk",
	pos = { Vector( 1605.562500, 3555.875000, -13407.676758 ) },
	angs = { Angle( 0, 0, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "hardware_clerk",
	pos = { Vector( -7598.968750, -3173.781250, -13943.968750 ) },
	angs = { Angle( 0, 0, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "clothing_clerk",
	pos = { Vector( 2016.937500, 3880.281250, -13407.968750 ) },
	angs = { Angle( 0, 0, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "book_clerk",
	pos = { Vector( 1595.437500, 2784.843750, -13407.968750	) },
	angs = { Angle( 0, 0, 0 ) },
}
local randPos = table.Random( GAMEMODE.Config.DrugNPCPositions )
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "drug_buyer",
	pos = { randPos[1] },
	angs = { randPos[2] },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "home_items_clerk",
	pos = { Vector( 1606.187500, 3166.906250, -13407.877930 ) },
	angs = { Angle( 0, -1, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "club_foods_clerk",
	pos = { Vector( 1603.718750, 6065.968750, -13377.968750 ) },
	angs = { Angle( 0, -90, 0 ) },
}
GAMEMODE.Map:RegisterNPCSpawn{
	UID = "vape_clerk",
	pos = { Vector( 1612.375000, 6191.781250, -13377.968750 ) },
	angs = { Angle( 0, -90, 0 ) },
}