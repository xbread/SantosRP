--[[
	Name: job_config.lua
	For: santosrp
	By: santosrp
]]--

--[[ EMS Config ]]--
GM.Config.EMSHospitalZone = {
	Min = Vector( 2237.0786132813, 125.8353729248, 136),
	Max = Vector( 3454.4274902344, 1856.2947998047, 500),
}

if SERVER then
	GM.Config.EMSParkingZone = {
		Min = Vector( 2918.397461, 1844.659424, 200.031250 ),
		Max = Vector( 2889.652832, -568.829895, 200.031250 ),
	}

	GM.Config.EMSCarSpawns = {
		{ Vector( 1755.4913330078, 2059.1865234375, 129 ), Angle( 0, 180, 0 ) },
		{ Vector( 1755.4913330078, 1740.1865234375, 129 ), Angle( 0, 180, 0 ) },
		{ Vector( 1755.4913330078, 1421.1865234375, 129 ), Angle( 0, 180, 0 ) },
		{ Vector( 1755.4913330078, 1102.1865234375, 129 ), Angle( 0, 180, 0 ) },
	}
end

--[[ Fire Config ]]--
if SERVER then
	GM.Config.FireParkingZone = {
		Min = Vector( 3224.954346, -4444.929199, 200.031250 ),
		Max = Vector( 2456.031250, -4452.879883, 200.031250 ),
	}

	GM.Config.FireCarSpawns = {
		{ Vector( 2630, -4270, 135 ), Angle( 0, 90, 0 ) },
		{ Vector( 2632, -4640, 135 ), Angle( 0, 90, 0 ) },
	}
end

--[[ Cop Config ]]--
if SERVER then
	GM.Config.CopParkingZone = {
		Min = Vector( 3335.968750, -2032.958374, 200.031250 ),
		Max = Vector( 2490.524902, -1949.347412, 211.145096 ),
	}

	GM.Config.CopCarSpawns = {
		{ Vector( 2537, -1682, 135 ), Angle( 0, 180, 0 ) },
		{ Vector( 2800, -1692, 135 ), Angle( 0, 180, 0 ) },
		{ Vector( 3020, -1695, 135 ), Angle( 0, 180, 0 ) },
		{ Vector( 3021, -2277, 135 ), Angle( 0, 0, 0 ) },
		{ Vector( 2798, -2272, 135 ), Angle( 0, 0, 0 ) },
		{ Vector( 2549, -2279, 135 ), Angle( 0, 0, 0 ) },		
	}
end

--[[ Tow Config ]]--
if SERVER then
	GM.Config.TowWelderZone = {
		Min = Vector( 5169, 6442, 222 ),
		Max = Vector( 6805, 7321, 286 ),
	}

	GM.Config.TowParkingZone = {
		Min = Vector( 5169, 6442, 222 ),
		Max = Vector( 6805, 7321, 286 ),
	}

	GM.Config.TowCarSpawns = {
		{ Vector( 5640, 6699, 138 ), Angle( 0, 180, 0 ) },
		{ Vector( 5979, 6685, 138 ), Angle( 0, 180, 0 ) },
		{ Vector( 6347, 6687, 138 ), Angle( 0, 180, 0 ) },
	}
end

--[[ Taxi Config ]]--
if SERVER then
	GM.Config.TaxiParkingZone = {
		Min = Vector( 250.103012, -1385.641357, 200.031250 ),
		Max = Vector( 335.628448, -2299.960693, 200.0312504 ),
	}

	GM.Config.TaxiCarSpawns = {
		{ Vector( 123, -2053, 131 ), Angle( 0, 90, 0 ) },
	}
end

--[[ Sales Config ]]--
if SERVER then
	GM.Config.SalesParkingZone = {
		Min = Vector( 5941.900391, 7151.889648, 200.031250 ),
		Max = Vector( 5933.704590, 6485.531250, 200.031250 ),
	}

	GM.Config.SalesCarSpawns = {
		{ Vector( 5640, 6699, 138 ), Angle( 0, 180, 0 ) },
		{ Vector( 5979, 6685, 138 ), Angle( 0, 180, 0 ) },
		{ Vector( 6347, 6687, 138 ), Angle( 0, 180, 0 ) },
	}
end

--[[ Mail Config ]]--
if SERVER then
	GM.Config.MailParkingZone = {
		Min = Vector( 5941.900391, 7151.889648, 200.031250 ),
		Max = Vector( 5933.704590, 6485.531250, 200.031250 ),
	}

	GM.Config.MailCarSpawns = {
		{ Vector( 5640, 6699, 138 ), Angle( 0, 180, 0 ) },
		{ Vector( 5979, 6685, 138 ), Angle( 0, 180, 0 ) },
		{ Vector( 6347, 6687, 138 ), Angle( 0, 180, 0 ) },
	}
end

GM.Config.MailDepotPos = Vector( 5619.107422, 6979.818848, 140.031250 )
GM.Config.MailPoints = {
	{ Pos = Vector( -4797, -5148, 148 ), Name = "Pulse Night Club", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 5379, 3999, 148 ), Name = "The Vannah Realty", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -28, -8764, 180 ), Name = "Harbor View Hotel", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -4979, -3943, 148 ), Name = "Twin Apartments", MinPrice = 50, MaxPrice = 200 },	
	{ Pos = Vector( 4453, -411, 148 ), Name = "Arcadia Apartments", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 7145, 3993, 148 ), Name = "Electronics Plus", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 4928, -3485, 150 ), Name = "Kappel's Clothing", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 4271, -4637, 148 ), Name = "Super Walmart", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 2209, -2799, 148 ), Name = "Police Station", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 2202, -4810, 148 ), Name = "Miami Fire Department", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 3033, 116, 1484 ), Name = "St. Alex General Hospital", MinPrice = 50, MaxPrice = 200 },

	--Subs
	{ Pos = Vector( -11951, -1442, 148 ), Name = "Suburbs House 6", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -12459, -616, 148 ), Name = "Suburbs House 5", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -12466, 981, 148 ), Name = "Suburbs House 4", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -11945, 1951, 148 ), Name = "Suburbs House 3", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -10422, -165, 150 ), Name = "Suburbs House 2", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -9944, 665, 148 ), Name = "Suburbs House 1", MinPrice = 50, MaxPrice = 200 },
}

--[[ Bus Config ]]--
if SERVER then
	GM.Config.BusParkingZone = GM.Config.TaxiParkingZone
	GM.Config.BusCarSpawns = {
		{ Vector( 123, -2053, 131 ), Angle( 0, 90, 0 ) },
	}
end

--[[ Secret Service Config ]]--
if SERVER then
	GM.Config.SSParkingZone = GM.Config.CopParkingZone
	GM.Config.SSCarSpawns = GM.Config.CopCarSpawns
end