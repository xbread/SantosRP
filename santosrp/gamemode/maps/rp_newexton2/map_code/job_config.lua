--[[
	Name: job_config.lua
]]--


--[[ EMS Config ]]--
GM.Config.EMSHospitalZone = {
	Min = Vector( -1042.38, -6577.74, -142770.21 ),
	Max = Vector( 1062.06, -5122.48, -12741.71 ),
}

if SERVER then
	GM.Config.EMSParkingZone = {
		Min = Vector( -6016.03, -3448.42, -14028.44 ),
		Max = Vector( -5391.57, -2927.91, -13476.95 ),
	}
	
	GM.Config.EMSCarSpawns = {
		{ Vector( -5832.343750, -3159.935547, -13957.781250 ), Angle( 0, 0, 0 ) },
		{ Vector( -5594.968750, -3161.156250, -13957.781250 ), Angle( 0, 0, 0 ) },
	}
end


--[[ Fire Config ]]--w
if SERVER then
	GM.Config.FireParkingZone = {
		Min = Vector( -4978.01, -3656.11, -13972.26 ),
		Max = Vector( -4226.63, -2975.13, -13336.41 ),
	}

	GM.Config.FireCarSpawns = {
		{ Vector( -4458.281250, -3240.375000, -13949.156250 ), Angle( 0, 0, 0 ) },
		{ Vector( -4650.593750, -3242.562500, -13949.187500 ), Angle( 0, 0, 0 ) },
		{ Vector( -4838.968750, -3244.375000, -13949.187500 ), Angle( 0, 0, 0 ) },
	}
end


--[[ Cop Config ]]--
if SERVER then
	GM.Config.CopParkingZone = {
		Min = Vector( -8890.34, -5592.48, -14137 ),
		Max = Vector( -8050.27, -4525.52, -12996.53 ),
	}

	GM.Config.CopCarSpawns = {
		{ Vector( -8291.500000, -4783.093750, -13951.719727 ), Angle( 0, -90, 0 ) },
		{ Vector( -8290.406250, -5114.687500, -13951.718750 ), Angle( 0, -90, 0 ) },
		{ Vector( -8291.687500, -5501.625488, -13951.719727 ), Angle( 0, -90, 0 ) },
	}
end


--[[ Tow Config ]]--
if SERVER then
	GM.Config.TowWelderZone = {
		Min = Vector( -7705.31, 1385.24, -14113.77 ),
		Max = Vector( -7020.18, 278.16, -13153.74 ),
	}
	

	GM.Config.TowParkingZone = {
		Min = Vector( -7705.31, 1385.24, -14113.77 ),
		Max = Vector( -7020.18, 278.16, -13153.74 ),
	}

	GM.Config.TowCarSpawns = {
		{ Vector( -7462.468750, 1577.062500, -13500.312500 ), Angle( 0, 0, 0 ) },
	}
end


--[[ Taxi Config ]]--
if SERVER then
	GM.Config.TaxiParkingZone = {
		Min = Vector( -1869.29, 2959.02, -13719.84 ),
		Max = Vector( -478.94, 4093.59, -12713.67 ),
	}

	GM.Config.TaxiCarSpawns = {
		{ Vector( -1581.468750, 3942.781250, -13416.656250 ), Angle( 0, 0, 0 ) },
		{ Vector( -1418.812500, 3938.937744, -13416.656250 ), Angle( 0, 0, 0 ) },
	}
end


--[[ Sales Config ]]--
if SERVER then
	GM.Config.SalesParkingZone = {
		Min = Vector( -2754.625000, -6462.343750, -13948.468750 ),
		Max = Vector( -3773.218750, -5361.656250, -13500.906250 ),
	}

	GM.Config.SalesCarSpawns = {
		{ Vector( -3645.531250, -5490.937500, -13947.343750 ), Angle( 0, 0, 0 ) },
		{ Vector( -3636.312500, -5649.812500, -13947.343750 ), Angle( 0, 0, 0 ) },
		{ Vector( -3629.843750, -5809.406250, -13947.343750 ), Angle( 0, 0, 0 ) },
		{ Vector( -3632.375000, -5968.468750, -13947.343750 ), Angle( 0, 0, 0 ) },
	}
end


--[[ Mail Config ]]--
if SERVER then
	GM.Config.MailParkingZone = {
		Min = Vector( -3773, -6460.61, -13995.71 ),
		Max = Vector( -2766.74, -5365.75, -13640.45 ),
	}

	GM.Config.MailCarSpawns = {
		{ Vector( -2877.281250, -5565.218750, -13947.312500 ), Angle( 0, 174, 0 ) },
		{ Vector( -2882.156250, -5723.312012, -13947.312500 ), Angle( 0, 174, 0 ) },
	}
end

GM.Config.MailDepotPos = Vector( -2885.593750 -5559.843750 -13953.187500 )
GM.Config.MailPoints = {
	{ Pos = Vector( -3790.750000, -3333.187500, -13901.968750 ), Name = "Bank", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -1446.843750, 4404.156250, -13361.875000 ), Name = "Rockford Transit Authority", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -1074.250000, 6545.000000, -13398.000000 ), Name = "Quarantine Realty", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 1631.625000, 2871.500000, -13361.343750 ), Name = "Books Emporium", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 1631.062500, 3252.500000, -13361.656250 ), Name = "Furniture Gallery", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 1634.031250, 3637.406250, -13361.468750 ), Name = "Electronics Plus", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 2041.343750, 3930.781250, -13362.062500 ), Name = "Frosty Fashion", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 1787.531250, 5934.468750, -13367.968750 ), Name = "Rockford Foods Supermarket", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -7945.593750, -5668.156250, -13933.937500 ), Name = "Police Station", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -5317.593750, -3006.031250, -13941.875000 ), Name = "Rockford EMS", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( -224.468750, -6010.031250, -13877.937500 ), Name = "Grace General Hospital", MinPrice = 50, MaxPrice = 200 },

	--Subs
	{ Pos = Vector( 10986.718750, 5399.781250, -12373.906250 ), Name = "House 10 Richard Dr", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 10890.593750, 7147.218750, -12374.031250 ), Name = "House 11 Richard Dr", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 10764.593750, 2591.875000, -12397.812500 ), Name = "House 8 Richard Dr", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 8987.343750, 1559.031250, -12373.968750 ), Name = "House 6 Richard Dr", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 8168.125000, 5572.750000, -12373.906250 ), Name = "House 3 Richard Dr", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 8143.125000, 7190.062500, -12398.000000 ), Name = "House 1 Richard Dr", MinPrice = 50, MaxPrice = 200 },
}


--[[ Bus Config ]]--
if SERVER then
	GM.Config.BusParkingZone = GM.Config.TaxiParkingZone
	GM.Config.BusCarSpawns = {
		{ Vector( -946.125000, 3909.156250, -13416.656250 ), Angle( 0, 0, 0 ) },
		{ Vector( -779.593750, 3901.062744, -13416.656250 ), Angle( 0, 0, 0 ) },
	}
end


--[[ Secret Service Config ]]--
if SERVER then
	GM.Config.SSParkingZone = GM.Config.SalesParkingZone
	GM.Config.SSCarSpawns = GM.Config.SalesParkingZone
end