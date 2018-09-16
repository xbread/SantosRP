--[[
	Name: job_config.lua
	For: SantosRP
	By: Ultra
]]--

--[[ EMS Config ]]--
GM.Config.EMSHospitalZone = {
	Min = Vector( -3094.178467, 346.304047, -48.156326 ),
	Max = Vector( -2148.702393, 1240.331543, 1097.876343 ),
}

--[[ EMS Config ]]--
if SERVER then
	GM.Config.EMSParkingZone = {
		Min = Vector( -3043.071289, 1153.223145, 68 ),
		Max = Vector( -2280.147949, 1599.786865, 320 ),
	}

	GM.Config.EMSCarSpawns = {
		{ Vector( -2342.883545, 1496, 76.031219 ), Angle( 0, 0, 0 ) },
		{ Vector( -2469.618652, 1496, 76.031219 ), Angle( 0, 0, 0 ) },
		{ Vector( -2598.603760, 1496, 76.031219 ), Angle( 0, 0, 0 ) },
		{ Vector( -2727.589844, 1496, 76.031219 ), Angle( 0, 0, 0 ) },
		{ Vector( -2853.576172, 1496, 76.031219 ), Angle( 0, 0, 0 ) },
	}
end

--[[ Fire Config ]]--
if SERVER then
	GM.Config.FireParkingZone = {
		Min = Vector( 5025, 12945, 60 ),
		Max = Vector( 5730, 13700, 325 ),
	}

	GM.Config.FireCarSpawns = {
		{ Vector( 5589, 13394, 68 ), Angle( 0, 180, 0 ) },
		{ Vector( 5363, 13394, 68 ), Angle( 0, 180, 0 ) },
		{ Vector( 5137, 13394, 68 ), Angle( 0, 180, 0 ) },
	}
end

--[[ Cop Config ]]--
if SERVER then
	GM.Config.CopParkingZone = {
		Min = Vector( -847.437866, -2467.400391, -190 ),
		Max = Vector( 1155.787842, -1456.198242, 12 ),
	}

	GM.Config.CopCarSpawns = {
		{ Vector( 535.359009, -2293, -179.968750 ), Angle( 0, 0, 0 ) },
		{ Vector( 270.655731, -2293, -179.968750 ), Angle( 0, 0, 0 ) },
		{ Vector( -14.049555, -2293, -179.968750 ), Angle( 0, 0, 0 ) },
		{ Vector( -272.752319, -2293, -179.968750 ), Angle( 0, 0, 0 ) },
		{ Vector( -556.005249, -2293, -179.968750 ), Angle( 0, 0, 0 ) },
	}
end

--[[ Tow Config ]]--
if SERVER then
	GM.Config.TowWelderZone = {
		Min = Vector( 6904.932617, 12850.216797, 0 ),
		Max = Vector( 7118.400879, 13214.668945, 327.968750 ),
	}

	GM.Config.TowParkingZone = {
		Min = Vector( 6904.932617, 12850.216797, 0 ),
		Max = Vector( 7662.277832, 13831.408203, 768 ),
	}

	GM.Config.TowCarSpawns = {
		{ Vector( 7493.244629, 13640.015625, 74 ), Angle( 0, 180, 0 ) },
		{ Vector( 7343.240723, 13640.015625, 74 ), Angle( 0, 180, 0 ) },
		{ Vector( 7230.076660, 13640.015625, 74 ), Angle( 0, 180, 0 ) },
	}
end

--[[ Taxi Config ]]--
if SERVER then
	GM.Config.TaxiParkingZone = {
		Min = Vector( 2515, 2304, 70 ),
		Max = Vector( 3202, 2872, 245 ),
	}

	GM.Config.TaxiCarSpawns = {
		{ Vector( 2625, 2733, 76 ), Angle( 0, 180, 0 ) },
		{ Vector( 2800, 2733, 76 ), Angle( 0, 180, 0 ) },
		{ Vector( 2952, 2733, 76 ), Angle( 0, 180, 0 ) },
		{ Vector( 3102, 2733, 76 ), Angle( 0, 180, 0 ) },
	}
end

--[[ Sales Config ]]--
if SERVER then
	GM.Config.SalesParkingZone = {
		Min = Vector( 9922.214844, 3786.209229, -1830 ),
		Max = Vector( 10927.476563, 4860.504395, -1568.621216 ),
	}

	GM.Config.SalesCarSpawns = {
		{ Vector( 10757.956055, 4715, -1823.968750 ), Angle( 0, 90, 0 ) },
		{ Vector( 10757.956055, 4565, -1823.968750 ), Angle( 0, 90, 0 ) },
		{ Vector( 10757.956055, 4415, -1823.968750 ), Angle( 0, 90, 0 ) },
		{ Vector( 10757.956055, 4265, -1823.968750 ), Angle( 0, 90, 0 ) },
		{ Vector( 10757.956055, 4115, -1823.968750 ), Angle( 0, 90, 0 ) },
	}
end

--[[ Mail Config ]]--
if SERVER then
	GM.Config.MailParkingZone = {
		Min = Vector( 9922.214844, 3786.209229, -1900 ),
		Max = Vector( 10927.476563, 4860.504395, -1568.621216 ),
	}

	GM.Config.MailCarSpawns = {
		{ Vector( 10757.956055, 4715, -1823.968750 ), Angle( 0, 90, 0 ) },
		{ Vector( 10757.956055, 4565, -1823.968750 ), Angle( 0, 90, 0 ) },
		{ Vector( 10757.956055, 4415, -1823.968750 ), Angle( 0, 90, 0 ) },
		{ Vector( 10757.956055, 4265, -1823.968750 ), Angle( 0, 90, 0 ) },
		{ Vector( 10757.956055, 4115, -1823.968750 ), Angle( 0, 90, 0 ) },
	}
end

GM.Config.MailDepotPos = Vector( 10058.955078, 4262.601074, -1823.968750 )
GM.Config.MailPoints = {
	{ Pos = Vector('8414.269531 9146.810547 -1823.999878'), Name = "Subs Large 3", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('6250.940918 9148.338867 -1824.000000'), Name = "Subs Large 2", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('6422.318359 7860.912598 -1824.000122'), Name = "Subs Large 1", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('6890.182617 7898.719238 -1824.000000'), Name = "Subs Large 4", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('10800.728516 -3798.763916 -1728.000000'), Name = "Subs House 1", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('12786.304688 -10729.465820 -1728.000000'), Name = "Subs House 2", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('12788.152344 -11194.166016 -1728.000000'), Name = "Subs House 3", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('12786.470703 -12332.996094 -1728.000000'), Name = "Subs House 4", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('12790.519531 -13359.156250 -1728.000000'), Name = "Subs House 5", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('10287.729492 -12130.004883 -1718.968750'), Name = "Bookstore", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('9671.493164 -12129.656250 -1718.968750'), Name = "Subs Market 201", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('10742.080078 -12129.436523 -1718.968750'), Name = "Subs Market 203", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('-2313.553223 1119.329590 80.031250'), Name = "Hospital", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('-3382.419189 3027.522705 76.031250'), Name = "Midas To HQ", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('55.697128 2947.293213 76.031250'), Name = "Burger King", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('-2061.637695 -1068.993530 76.031250'), Name = "Hardware Store", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('-2367.445313 -2105.541016 76.031250'), Name = "Evocity Electronics", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('-2431.994629 -2450.214355 76.031250'), Name = "Evocity Clothing Store", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('2670.672607 -1743.491333 76.000008'), Name = "Car Dealership", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('3561.345215 -3026.221924 76.031250'), Name = "City Apartment Market 104", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('3544.175293 -2758.862793 76.031250'), Name = "City Apartment Market 103", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('3544.080566 -1319.191772 76.031250'), Name = "The Amber Shop", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('668.994141 -1046.214722 76.031242'), Name = "Evocity Realtor", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('3699.693848 506.647614 76.031250'), Name = "J&M Glass Co", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('3697.659424 1158.928955 76.031250'), Name = "Evocity Old Resturant", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('3691.817871 1947.983643 76.031250'), Name = "Nathan's Drugs", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('2921.989014 2241.553711 76.031250'), Name = "Taxi HQ", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('1774.430542 -113.128632 140.031250'), Name = "Bank Of America", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('955.132263 916.679993 76.031235'), Name = "Skyscraper", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('-591.041321 -1394.952881 76.031250'), Name = "City Hall", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('7873.277344 6018.398926 70.031250'), Name = "Club Foods", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('4895.411621 12998.468750 68.000000'), Name = "Fire Station", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('-334.648987 11651.103516 -127.968765'), Name = "Old River House", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('-4519.119629 13615.670898 196.031250'), Name = "Evocity District Building 1", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('-3033.803955 13504.715820 197.000000'), Name = "Evocity District Factory", MinPrice = 20, MaxPrice = 60 },
	{ Pos = Vector('-7354.874023 1376.570679 140.031250'), Name = "Gas Station", MinPrice = 20, MaxPrice = 60 },
}

--[[ Bus Config ]]--
if SERVER then
	GM.Config.BusParkingZone = GM.Config.MailParkingZone

	GM.Config.BusCarSpawns = {
		{ Vector( 8887.238281, 3865.602051, -1823.968750 ), Angle( 0, 90, 0 ) },
	}
end