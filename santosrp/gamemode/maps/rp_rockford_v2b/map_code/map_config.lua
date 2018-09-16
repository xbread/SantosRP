--[[
	Name: map_config.lua
	
		
]]--

if SERVER then
	resource.AddWorkshop( "651386968") --map
	resource.AddWorkshop( "328735857") --map content p.1
	
	GM.DayNight.m_tblTimeData.High = string.byte( "m" )
	
	--[[ Car Dealer Settings ]]--
	GM.Config.CarSpawns = {
		{ Vector( -10544.041992, -4694.017090, -200 ), Angle( 0, 180, 0 ) },
		{ Vector( -10722.385742, -4694.017090, -200 ), Angle( 0, 180, 0 ) },
		{ Vector( -10882.837891, -4694.017090, -200 ), Angle( 0, 180, 0 ) },
		{ Vector( -11040.472656, -4694.017090, -200 ), Angle( 0, 180, 0 ) },
		{ Vector( -11200.802734, -4694.017090, -200 ), Angle( 0, 180, 0 ) },
		{ Vector( -11357.319336, -4694.017090, -200 ), Angle( 0, 180, 0 ) },
		{ Vector( -11519.519531, -4694.017090, -200 ), Angle( 0, 180, 0 ) },
		{ Vector( -11681.851563, -4694.017090, -200 ), Angle( 0, 180, 0 ) },

		{ Vector( -10544.041992, -4027.500244, -200 ), Angle( 0, 0, 0 ) },
		{ Vector( -10722.385742, -4027.500244, -200 ), Angle( 0, 0, 0 ) },
		{ Vector( -10882.837891, -4027.500244, -200 ), Angle( 0, 0, 0 ) },
		{ Vector( -11040.472656, -4027.500244, -200 ), Angle( 0, 0, 0 ) },
	}
	GM.Config.CarGarageBBox = {
		Min = Vector( -11759.857422, -4863.970215, -280 ),
		Max = Vector( -10448.208984, -3856.061279, -16.031250 ),
	}

	--[[ Jail Settings ]]--
	GM.Config.JailPositions = {
		Vector( -7168.887695, -5744.702148, -1407.968750 ),
		Vector( -7618.137695, -5744.215820, -1407.968750 ),
		Vector( -7166.188477, -5489.132324, -1407.968750 ),
		Vector( -7618.484375, -5497.109863, -1407.968750 ),
	}
	GM.Config.JailReleasePositions = {
		Vector( -8568.342773, -5866.604004, 8.031250 ),
		Vector( -8644.741211, -5864.987305, 8.031250 ),
		Vector( -8711.574219, -5861.915039, 8.031250 ),
		Vector( -8789.971680, -5856.155273, 8.031250 ),
		Vector( -8566.955078, -5774.761719, 8.031250 ),
		Vector( -8666.511719, -5772.773926, 8.031250 ),
		Vector( -8567.293945, -5716.694336, 8.031250 ),
	}
	GM.Config.JailBBox = {
			Min = Vector( -7680, -5890, -1420 ), --Underground cells
			Max = Vector( -7100, -5050, -1210 ),
	}

	--[[ NPC Drug Dealer Settings ]]--
	GM.Config.DrugNPCPositions = {
		{ Vector( -5277.687500, 2005.862427, 70.604301 ), Angle( 0, 70, 0 ) },
		{ Vector( -7754.513672, 21.929438, 70.404022 ), Angle( 0, 2.5, 0 ) },
		{ Vector( -9559.187500, -294.172791, -205.968750 ), Angle( 0, -47, 0 ) },
		{ Vector( -2612.507080, 13749.910156, 330.847534 ), Angle( 0, 67, 0 ) },
		{ Vector( -1422.450439, 9696.228516, 620.031250 ), Angle( 0, 87, 0 ) },
	}

	--[[ Map Settings ]]--
	GM.Config.SpawnPoints = {
		Vector( -5224.136719, -5392.854980, 67 ),
		Vector( -5228.727539, -5555.010742, 67 ),
		Vector( -4939.162598, -5548.214844, 67 ),
		Vector( -4935.185059, -5380.179199, 67 ),
		Vector( -4700.748535, -5385.589844, 67 ),
		Vector( -4703.695801, -5510.267578, 67 ),
		Vector( -4431.059570, -5507.099609, 67 ),
		Vector( -4431.059570, -5507.099609, 67 ),
		Vector( -4427.256836, -5367.197754, 67 ),
		Vector( -4192.229980, -5378.046387, 67 ),
		Vector( -4196.021484, -5518.884277, 67 ),
	}

	--[[ Register the car customs shop location ]]--
	GM.CarShop.m_tblGarage["rp_rockford_v2b"] = {
		NoDoors = true,
		CarPos = {
			Vector( -7330.221680, -1749.981445, 8.031250 ),
			Vector( -7320.714355, -1249.820679, 8.031250 ),
			Vector( -8686.833984, -1252.635132, 8.031250 ),
			Vector( -8690.154297, -1752.877197, 8.031250 ),
		},
		BBox = {
			Min = Vector( -8887.811523, -1975.901611, 8.031250 ), --Inside of the garage
			Max = Vector( -7112.437988, -1032.262817, 263.968750 ), --Inside of the garage
		},
		PlayerSetPos = Vector( -7782.479492, -2050.822998, 8.031250 ), --If a player gets inside the garage, set them to this location
	}

	--[[ Fire Spawner Settings ]]--
	GM.Config.AutoFiresEnabled = true
	GM.Config.AutoFireSpawnMinTime = 60 *10
	GM.Config.AutoFireSpawnMaxTime = 60 *30
	GM.Config.AutoFireSpawnPoints = {
		--Road side car dealer
		Vector( "-2204.491699 -753.151123 19.765747" ),

		--Road side city alley
		Vector( "-9854.040039 3485.471924 7.999939" ),

		--Factory
		Vector( "-8813.806641 7178.747070 0.000000" ),
		Vector( "-7863.180664 7258.520020 0.000061" ),
		Vector( "-7099.451172 7063.115234 0.000000" ),


		--Gas stations
		Vector( "150.768524 4202.308105 536.031250" ),
		Vector( "426.462280 3770.764404 536.031250" ),

		Vector( "-13753.673828 2417.652344 384.031250" ),
		Vector( "-14085.485352 2898.688965 384.031250" ),

		--Gas stations inside
		Vector( "845.067078 3938.952637 544.031250" ),

		Vector( "-14467.480469 2654.844238 392.031250" ),
	}
end

--[[ Car Dealer Settings ]]--
GM.Config.CarPreviewModelPos = Vector( -3424.300781, -862.886780, 18.265505 )
GM.Config.CarPreviewCamPos = Vector( -3588.573975, -1026.366943, 141.199615 )
GM.Config.CarPreviewCamAng = Angle( 15.88, 45, 0 )
GM.Config.CarPreviewCamLen = 1.5

--[[ Chop Shop ]]--
GM.Config.ChopShop_ChopLocation = Vector( -4182, -8230, 287 )

--[[ Weather & Day Night ]]--
GM.Config.Weather_SkyZPos = nil --Skybox is not even height!
GM.Config.FogLightingEnabled = false