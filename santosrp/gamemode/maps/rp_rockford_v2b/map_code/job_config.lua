--[[
	Name: job_config.lua
	
		
]]--

--[[ EMS Config ]]--
GM.Config.EMSHospitalZone = {
	Min = Vector( -1024.230225, -6559.565430, -32 ),
	Max = Vector( 1022.156128, -5154.420410, 768 ),
}

if SERVER then
	GM.Config.EMSParkingZone = {
		Min = Vector( -5758.987305, -3694.379150, -32 ),
		Max = Vector( -4489.044922, -2864.728516, 768 ),
	}

	GM.Config.EMSCarSpawns = {
		{ Vector( -4720.229492, -3239.016846, 10 ), Angle( 0, 0, 0 ) },
		{ Vector( -4993.812012, -3239.016846, 10 ), Angle( 0, 0, 0 ) },
		{ Vector( -5242.958984, -3239.016846, 10 ), Angle( 0, 0, 0 ) },
		{ Vector( -5502.378906, -3239.016846, 10 ), Angle( 0, 0, 0 ) },
	}
end

--[[ Fire Config ]]--
if SERVER then
	GM.Config.FireParkingZone = {
		Min = Vector( -5758.987305, -3694.379150, -32 ),
		Max = Vector( -4489.044922, -2864.728516, 768 ),
	}

	GM.Config.FireCarSpawns = {
		{ Vector( -4720.229492, -3239.016846, 10 ), Angle( 0, 0, 0 ) },
		{ Vector( -4993.812012, -3239.016846, 10 ), Angle( 0, 0, 0 ) },
		{ Vector( -5242.958984, -3239.016846, 10 ), Angle( 0, 0, 0 ) },
		{ Vector( -5502.378906, -3239.016846, 10 ), Angle( 0, 0, 0 ) },
	}
end

--[[ Cop Config ]]--
if SERVER then
	GM.Config.CopParkingZone = {
		Min = Vector( -8500.212891, -6401.408203, -32 ),
		Max = Vector( -7380.753418, -5295.041504, 768 ),
	}

	GM.Config.CopCarSpawns = {
		{ Vector( -8077.293945, -5528.816895, 8 ), Angle( 0, 180, 0 ) },
		{ Vector( -8235.380859, -5524.071777, 8 ), Angle( 0, 180, 0 ) },
		{ Vector( -8400.001953, -5521.797852, 8 ), Angle( 0, 180, 0 ) },
	}
end

--[[ Tow Config ]]--
if SERVER then
	GM.Config.TowWelderZone = {
		Min = Vector( -8887.533203, -1015.672058, -32 ),
		Max = Vector( -7961.439453, -553.501465, 391.968750 ),
	}

	GM.Config.TowParkingZone = {
		Min = Vector( -7663.616699, 320.031250, -32 ),
		Max = Vector( -7107.888672, 1855.192871, 768 ),
	}

	GM.Config.TowCarSpawns = {
		{ Vector( -7265.251953, -923.552612, 64 ), Angle( 0, -90, 0 ) },
		{ Vector( -7042.387207, 401.294037,	64 ), Angle( 0, 180, 0 ) },
	}
end

--[[ Taxi Config ]]--
if SERVER then
	GM.Config.TaxiParkingZone = {
		Min = Vector( -2231.173828, 3730.625732, 490 ),
		Max = Vector( -645.887817, 4733.752441, 1024 ),
	}

	GM.Config.TaxiCarSpawns = {
		{ Vector( -1918.889038, 4011.472168, 540.031250 ), Angle( 0, 0, 0 ) },
	}
end

--[[ Sales Config ]]--
if SERVER then
	GM.Config.SalesParkingZone = {
		Min = Vector( 1888.780029, 5250.757324, 500 ),
		Max = Vector( 2836.544922, 6548.457520, 1024 ),
	}

	GM.Config.SalesCarSpawns = {
		{ Vector( 2478.596924, 5455.141113, 545 ), Angle( 0, 180, 0 ) },
		{ Vector( 2634.052734, 5455.141113, 545 ), Angle( 0, 180, 0 ) },

		{ Vector( 2429.390381, 6173.523926, 545 ), Angle( 0, 180, 0 ) },
		{ Vector( 2265.908936, 6173.523926, 545 ), Angle( 0, 180, 0 ) },
		{ Vector( 2106.444336, 6173.523926, 545 ), Angle( 0, 180, 0 ) },

		{ Vector( 2429.390381, 5858.960449, 545 ), Angle( 0, 0, 0 ) },
		{ Vector( 2265.908936, 5858.960449, 545 ), Angle( 0, 0, 0 ) },
		{ Vector( 2106.444336, 5858.960449, 545 ), Angle( 0, 0, 0 ) },
	}
end

--[[ Mail Config ]]--
if SERVER then
	GM.Config.MailParkingZone = {
		Min = Vector( -3775.218262, -6463.633789, -32 ),
		Max = Vector( -2753.116211, -5375.882324, 768 ),
	}

	GM.Config.MailCarSpawns = {
		{ Vector( -2889.357422, -5884.015625, 10 ), Angle( 0, -90, 0 ) },
		{ Vector( -2889.357422, -6044.422363, 10 ), Angle( 0, -90, 0 ) },
		{ Vector( -2889.357422, -6207.299316, 10 ), Angle( 0, -90, 0 ) },
		{ Vector( -2889.357422, -6366.423340, 10 ), Angle( 0, -90, 0 ) },

		{ Vector( -3647.122314, -5650.406250, 10 ), Angle( 0, 90, 0 ) },
		{ Vector( -3647.122314, -5810.284668, 10 ), Angle( 0, 90, 0 ) },
		{ Vector( -3647.122314, -5965.915527, 10 ), Angle( 0, 90, 0 ) },
	}
end

GM.Config.MailDepotPos = Vector( -2889.326416, -5724.145508, 1 )
GM.Config.MailPoints = {
	{ Pos = Vector( -9775.446289, -772.151794, 8.031250 ), Name = "Club Catalyst", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -1526.220825, 4269.524902, 544.031250 ), Name = "Rockford Transit Authority", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -1435.734131, 6384.477051, 544.031250 ), Name = "Quarantine Realty", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 2420.872559, 1518.659424, 544.031250 ), Name = "Books Emporium", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 2418.283691, 2049.665039, 544.031250 ), Name = "Furniture Gallery", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 2433.029541, 3425.653320, 544.031250 ), Name = "Electronics Plus", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 2411.549316, 3971.722412, 544.031250 ), Name = "Frosty Fashion", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 1821.985596, 5909.744629, 574.031250 ), Name = "Rockford Foods Supermarket", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -8965.943359, -5689.702148, 8.031250 ), Name = "Police Station", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -6364.861328, -3340.133301, 8.031250 ), Name = "Rockford EMS", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -548.685242, -5739.691406, 59.445824 ), Name = "Grace General Hospital", MinPrice = 50, MaxPrice = 200 },

	--Subs
	{ Pos = Vector( 11242.794922, 6093.435547, 1544.031250 ), Name = "House 10 Richard Dr", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 10904.426758, 6941.621094, 1544.031250 ), Name = "House 11 Richard Dr", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 10423.262695, 2702.307129, 1544.031250 ), Name = "House 8 Richard Dr", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 9150.292969, 1753.636353, 1544.031250 ), Name = "House 6 Richard Dr", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 7735.554688, 5552.941406, 1544.031250 ), Name = "House 3 Richard Dr", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 7753.851074, 7464.055176, 1544.031250 ), Name = "House 1 Richard Dr", MinPrice = 50, MaxPrice = 200 },
}

--[[ Bus Config ]]--
if SERVER then
	GM.Config.BusParkingZone = GM.Config.TaxiParkingZone
	GM.Config.BusCarSpawns = {
		{ Vector( -818.164307, 4161.285645, 540 ), Angle( 0, 0, 0 ) },
	}
end

--[[ Secret Service Config ]]--
if SERVER then
	GM.Config.SSParkingZone = GM.Config.MailParkingZone
	GM.Config.SSCarSpawns = GM.Config.MailCarSpawns
end

--[[ City Worker Service Config ]]--
if SERVER then
	GM.Config.RoadParkingZone = GM.Config.MailParkingZone
	GM.Config.RoadParkingSpawns = GM.Config.MailCarSpawns
end