--[[
	Name: job_config.lua
	
		
]]--

--[[ EMS Config ]]--
GM.Config.EMSHospitalZone = {
	Min = Vector( -7578.591797, 6054.324219, 200 ),
	Max = Vector( -6159.354004, 7289.731445, 768 ),
}

if SERVER then
	GM.Config.EMSParkingZone = {
		Min = Vector( -7938.025879, 6163.599121, 270 ),
		Max = Vector( -7579.824707, 7290.646973, 768 ),
	}

	GM.Config.EMSCarSpawns = {
		{ Vector( -7751.565918, 6273.905762, 288.031250 ), Angle( 0, 90, 0 ) },
		{ Vector( -7751.565918, 6471.905762, 288.031250 ), Angle( 0, 90, 0 ) },
		{ Vector( -7751.565918, 6961.701660, 288.031250 ), Angle( 0, 90, 0 ) },
		{ Vector( -7751.565918, 7173.201660, 288.031250 ), Angle( 0, 90, 0 ) },
	}
end

--[[ Fire Config ]]--
if SERVER then
	GM.Config.FireParkingZone = {
		Min = Vector( -13183.034180, 12828.916016, 50 ),
		Max = Vector( -11808.301758, 13407.663086, 320 ),
	}

	GM.Config.FireCarSpawns = {
		{ Vector( -12032, 13124, 64 ), Angle( 0, -180, 0 ) },
		{ Vector( -12416, 13124, 64 ), Angle( 0, -180, 0 ) },
		{ Vector( -12801, 13124, 64 ), Angle( 0, -180, 0 ) },
	}
end

--[[ Cop Config ]]--
if SERVER then
	GM.Config.CopParkingZone = {
		Min = Vector( -10399.437866, 9280, -150 ),
		Max = Vector( -9617.787842, 11133, 768 ),
	}

	GM.Config.CopCarSpawns = {
		{ Vector( -10149.401367, 9463.628906, 160 ), Angle( 0, -90, 0 ) },
		{ Vector( -10149.401367, 9638.005859, 160 ), Angle( 0, -90, 0 ) },
		{ Vector( -10149.401367, 9810.625977, 160 ), Angle( 0, -90, 0 ) },
		{ Vector( -10156.510742, 9984.185547, 160 ), Angle( 0, -90, 0 ) },
		{ Vector( -10156.510742, 10157.947266, 160 ), Angle( 0, -90, 0 ) },
		{ Vector( -10156.510742, 10334.201172, 160 ), Angle( 0, -90, 0 ) },
		{ Vector( -10156.510742, 10504.347656, 160 ), Angle( 0, -90, 0 ) },
		{ Vector( -10156.510742, 10685.044922, 160 ), Angle( 0, -90, 0 ) },
		{ Vector( -10156.510742, 10853.083008, 160 ), Angle( 0, -90, 0 ) },
	}
end

--[[ Tow Config ]]--
if SERVER then
	GM.Config.TowWelderZone = {
		Min = Vector( -11087.155273, 9504.961914, -100 ),
		Max = Vector( -10608.554688, 10014.702148, 323.96875 ),
	}
	
	GM.Config.TowParkingZone = {
		Min = Vector( -12282.837891, 8737.132813, -100 ),
		Max = Vector( -10608.031250, 9504.462891, 768 ),
	}

	GM.Config.TowCarSpawns = {
		{ Vector( -10983.065430, 9197.822266, 64 ), Angle( 0, 90, 0 ) },
		{ Vector( -10975.474609, 8958.121094, 64 ), Angle( 0, 90, 0 ) },
	}
end

--[[ Taxi Config ]]--
if SERVER then
	GM.Config.TaxiParkingZone = {
		Min = Vector( -7857.803223, 1422.160767, 270 ),
		Max = Vector( -7492.590820, 2180.804443, 768 ),
	}

	GM.Config.TaxiCarSpawns = {
		{ Vector( -7675, 2046.654053, 288.031250 ), Angle( 0, -90, 0 ) },
		{ Vector( -7675, 1883.319946, 288.031250 ), Angle( 0, -90, 0 ) },
		{ Vector( -7675, 1719.828369, 288.031250 ), Angle( 0, -90, 0 ) },
		{ Vector( -7675, 1547.328369, 288.031250 ), Angle( 0, -90, 0 ) },
	}
end

--[[ Sales Config ]]--
if SERVER then
	GM.Config.SalesParkingZone = {
		Min = Vector( -10943.416016, -8302.894531, 275 ),
		Max = Vector( -9856.680664, -7680.686523, 768 ),
	}

	GM.Config.SalesCarSpawns = {
		{ Vector( -10819.497070, -8194.287109, 289 ), Angle( 0, 90, 0 ) },
		{ Vector( -10819.497070, -7983.059570, 289 ), Angle( 0, 90, 0 ) },
		{ Vector( -10819.497070, -7776.900879, 289 ), Angle( 0, 90, 0 ) },

		{ Vector( -9968.601563, -8194.287109, 289 ), Angle( 0, -90, 0 ) },
		{ Vector( -9968.601563, -7983.059570, 289 ), Angle( 0, 90, 0 ) },
		{ Vector( -9968.601563, -7776.900879, 289 ), Angle( 0, 90, 0 ) },
	}
end

--[[ Mail Config ]]--
if SERVER then
	GM.Config.MailParkingZone = {
		Min = Vector( -5760.416016, -7612.894531, -100 ),
		Max = Vector( -4546.680664, -6349.686523, 768 ),
	}

	GM.Config.MailCarSpawns = {
		{ Vector( -4629.615234, -7092.584473, 72 ), Angle( 0, 0, 0 ) },
		{ Vector( -4836.107910, -7059.133301, 72.031250 ), Angle( 0, 0, 0 ) },
		{ Vector( -5030.413574, -7042.100586, 72.031250 ), Angle( 0, 0, 0 ) },
		{ Vector( -5238.215332, -7062.275879, 72.031250 ), Angle( 0, 0, 0 ) },
		{ Vector( -5435.097656, -7072.060547, 72.031250 ), Angle( 0, 0, 0 ) },
		{ Vector( -5656.137207, -7123.722656, 72.031250 ), Angle( 0, 0, 0 ) },
	}
end

GM.Config.MailDepotPos = Vector( -6041.228516, -7331.349121, 1 )
GM.Config.MailPoints = {
	--Subs
	{ Pos = Vector( 9863, 10080, 80 ), Name = "Subs Large 1", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 9863, 11261, 80 ), Name = "Subs Large 2", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 9863, 12536, 80 ), Name = "Subs Large 3", MinPrice = 50, MaxPrice = 200 },
	{ Pos = Vector( 8773, 10886, 80 ), Name = "Subs 4", MinPrice = 30, MaxPrice = 150 },
	{ Pos = Vector( 8029, 11542, 80 ), Name = "Subs 3", MinPrice = 30, MaxPrice = 150 },
	{ Pos = Vector( 6723, 10880, 80 ), Name = "Subs 2", MinPrice = 40, MaxPrice = 150 },
	{ Pos = Vector( 5997, 11538, 80 ), Name = "Subs 1", MinPrice = 30, MaxPrice = 150 },
	{ Pos = Vector( 4139, 9404, 80 ), Name = "Freddy's Bakery Subs", MinPrice = 50, MaxPrice = 250 },
	{ Pos = Vector( 4480, 12724, 80 ), Name = "Clothing Store Subs", MinPrice = 50, MaxPrice = 250 },

	{ Pos = Vector( 516, 9456, 126 ), Name = "Church", MinPrice = 100, MaxPrice = 150 },
	{ Pos = Vector( -8595, 10900, 292 ), Name = "Police Station", MinPrice = 100, MaxPrice = 200 },
	{ Pos = Vector( -11365, 5960, 192 ), Name = "Hungriges Srhmein Restaurant", MinPrice = 100, MaxPrice = 10 },
	{ Pos = Vector( -7473, 5068, 288 ), Name = "Mad Joe's Coffee", MinPrice = 10, MaxPrice = 50 },
	{ Pos = Vector( -5415, 5238, 292 ), Name = "Bank", MinPrice = 200, MaxPrice = 300 },
	{ Pos = Vector( -6315, 5165, 288 ), Name = "Fish Store", MinPrice = 30, MaxPrice = 150 },
	{ Pos = Vector( -6160, 3985, 292 ), Name = "Safety First", MinPrice = 50, MaxPrice = 150 },
	{ Pos = Vector( -9468, 3298, 296 ), Name = "Sky Scraper", MinPrice = 50, MaxPrice = 150 },
	{ Pos = Vector( -8848, -10716, 292 ), Name = "Car Dealer", MinPrice = 100, MaxPrice = 250 },
}

--[[ Bus Config ]]--
if SERVER then
	GM.Config.BusParkingZone = GM.Config.MailParkingZone
	GM.Config.BusCarSpawns = GM.Config.MailCarSpawns
end