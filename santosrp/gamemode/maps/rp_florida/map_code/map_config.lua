--[[
	Name: map_config.lua
	For: santosrp
	By: santosrp
]]--

if SERVER then
	resource.AddWorkshop( "896531193") -- Map
	resource.AddWorkshop( "896533931") -- Map Content 1
	resource.AddWorkshop( "896535567") -- Map Content 2	
	resource.AddWorkshop( "896536305") -- Map Content 3
	resource.AddWorkshop( "896537512") -- Map Content 4
	resource.AddWorkshop( "896538001") -- Map Content 5
	
	GM.DayNight.m_tblTimeData.High = string.byte( "m" )
	
	--[[ Car Dealer Settings ]]--
	GM.Config.CarSpawns = {
		{ Vector( -2076, -1131, 136 ), Angle( 0, 0, 0 ) },
		{ Vector( -2354, -1125, 136 ), Angle( 0, 0, 0 ) },
		{ Vector( -2620, -1125, 136 ), Angle( 0, 0, 0 ) },
		{ Vector( -2081, -648, 136 ), Angle( 0, 0, 0 ) },
		{ Vector( -2363, -613, 136 ), Angle( 0, 0, 0 ) },
		{ Vector( -2625, -670, 136 ), Angle( 0, 0, 0 ) },
		{ Vector( -2108, -177, 136 ), Angle( 0, 0, 0 ) },
		{ Vector( -2381, -153, 136 ), Angle( 0, 0, 0 ) },
		{ Vector( -2630, -185, 136 ), Angle( 0, 0, 0 ) },
		{ Vector( -2881, -1105, 136 ), Angle( 0, 0, 0 ) },
		{ Vector( -2879, -621, 136 ), Angle( 0, 0, 0 ) },
		{ Vector( -2877, -181, 136 ), Angle( 0, 0, 0 ) },
	}
	GM.Config.CarGarageBBox = {
		Min = Vector( -3830.2092285156, -1266.2307128906, 100 ),
		Max = Vector( -1738.3753662109, -8.7169723510742, 1167 ),
	}

	--[[ Jail Settings ]]--
	GM.Config.JailPositions = {
		Vector( 2512, -3210, -184 ),
		Vector( 2650, -3212, -184 ),
		Vector( 2794, -3201, -184 ),
		Vector( 2928, -3209, -184 ),
	}
	GM.Config.JailReleasePositions = {
		Vector( 2623, -2879, 136 ),
		Vector( 2559, -2880, 136 ),
		Vector( 2497, -2878, 136 ),
		Vector( 2665, -2575, 136 ),
		Vector( 2577, -2565, 136 ),
		Vector( 2498, -2561, 136 ),
	}
	GM.Config.JailBBox = {
		Min = Vector( 2415, -4052, -845 ), --Underground cells
		Max = Vector( 3620, -1519, 845 ),
	}

	--[[ NPC Drug Dealer Settings ]]--
	GM.Config.DrugNPCPositions = {
		{ Vector( 3955, 3402, 328 ), Angle( 0, 180, 0 ) },
		{ Vector( 4426, 90, 136 ), Angle( 0, 0, 0 ) },
		{ Vector( -8342, 201, 136 ), Angle( 0, 180, 0 ) },
	}

	--[[ Map Settings ]]--
	GM.Config.SpawnPoints = {
		Vector( -159, -4733, 265 ),
		Vector( -64, -4741, 265 ),
		Vector( -76, -4597, 265 ),
		Vector( -146, -4588, 265 ),
		Vector( -73, -4495, 265 ),
		Vector( -153, -4499, 265 ),
		Vector( -83, -4226, 328 ),
		Vector( 56, -4230, 328 ),
		Vector( -4, -4244, 328 ),
		Vector( 639, -4234, 328 ),
		Vector( 732, -4236, 328 ),
		Vector( 821, -4235, 328 ),
		Vector( 1380, -3944, 200 ),
		Vector( 1392, -3809, 200 ),
		Vector( 1194, -3817, 200 ),
		Vector( 1192, -3940, 200 ),
		Vector( -600, -3936, 200 ),
		Vector( -614, -3807, 200 ),		
		}

	--[[ Register the car customs shop location ]]--
	GM.CarShop.m_tblGarage["rp_florida"] = {
		NoDoors = true,
		CarPos = {
			Vector( -1983, -2816, 131 ),
			Vector( -1954, -2483, 131 ),
		},
		BBox = {
			Min = Vector( -2544.745605, -2771.412842, 199.885620 ), --Inside of the garage
			Max = Vector( -1492.828857, -2879.602783, 193.183350 ), --Inside of the garage
		},		
		PlayerSetPos = Vector( -1921.115967, -2653.553711, 155 ), --If a player gets inside the garage, set them to this location
	}

	--[[ Fire Spawner Settings ]]--
	GM.Config.AutoFiresEnabled = true
	GM.Config.AutoFireSpawnMinTime = 60 *10
	GM.Config.AutoFireSpawnMaxTime = 60 *30
	GM.Config.AutoFireSpawnPoints = {
		--Shop interior
		Vector( 7298.746094, 3730.687500, 200.03125 ),

		--Road side suburbs
		Vector( -8111.763672, -4478.330078, 155 ),
		
		--Road side town square tunnel
		Vector(-7130.313477, -8919.452148, 155),
		
		--Abandon Building
		Vector( 3955.157715, 3383.546631, 200.031250 ),

		--Gas stations
		Vector( 570.096863, -677.346863, 155 ),

		--Gas stations inside
		Vector( 1238.933594, -418.066803, 155 ),
	}
end

--[[ Car Dealer Settings ]]--
GM.Config.CarPreviewModelPos = Vector( -2275, -3100, 135 )
GM.Config.CarPreviewCamPos = Vector( -2288.919189, -2886, 200 )
GM.Config.CarPreviewCamAng = Angle( 0, -90, 0 )
GM.Config.CarPreviewCamLen = 1.5

--[[ Chop Shop ]]--
GM.Config.ChopShop_ChopLocation = Vector( 3978, 4315, 13 )

--[[ Weather & Day Night ]]--
GM.Config.Weather_SkyZPos = nil --Skybox is not even height!
GM.Config.FogLightingEnabled = false