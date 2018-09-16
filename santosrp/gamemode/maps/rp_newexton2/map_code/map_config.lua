--[[

	Name: map_config.lua
	
]]--


if SERVER then
	resource.AddWorkshop( "1318768443") --map
	GM.DayNight.m_tblTimeData.High = string.byte( "m" )


	--[[ Car Dealer Settings ]]--
	GM.Config.CarSpawns = {
		{ Vector( -7226.034180, -792.156250, -13953.000000 ), Angle( 0, 180, 0 ) },
		{ Vector( -7457.364258, -798.399719, -13953.000000 ), Angle( 0, 180, 0 ) },
		{ Vector( -7675.187500, -803.906250, -13953.000000 ), Angle( 0, 180, 0 ) },
	}

	GM.Config.CarGarageBBox = {
		Min = Vector( -9339.78, -2209.78, -14192 ),
		Max = Vector( -6818.18, -474.93, -10000 ),
	}


	--[[ Jail Settings ]]--
	GM.Config.JailPositions = {
		Vector( -7184.093750, -5262.875000, -13932.500000 ),
		Vector( -7190.187500, -5159.250000, -13932.406250 ),
		Vector( -7190.500000, -5041.062500, -13932.406250 ),
		Vector( -7522.656250, -5062.218750, -13932.406250 ),
		Vector( -7544.281250, -5171.000000, -13932.437500 ),
		Vector( -7535.468750, -5265.875000, -13932.406250 ),
	}

	GM.Config.JailReleasePositions = {
		Vector( -7887.281250, -5671.625000, -13917.875000 ),
		Vector( -7910.093750, -5755.656250, -13917.968750 ),
		Vector( -8000.875000, -5676.875000, -13917.968750 ),
	}

	GM.Config.JailBBox = {
		{
			Min = Vector( -7614.85, -5339.12, -14068.31 ),
			Max = Vector( -7086.16, -4905.16, -13215.98 ),
		},
	}

	
	--[[ NPC Drug Dealer Settings ]]--

	GM.Config.DrugNPCPositions = {
		{ Vector( "-3315.156250 -7867.125000 -13951.968750" ), Angle( 0, -177, 0 ) },
	}


	--[[ Map Settings ]]--
	GM.Config.SpawnPoints = {
		Vector( -5195.437500, -5490.218750, -13864.593750 ),
		Vector( -4808.250000, -5474.625000, -13859.406250 ),
	}


	--[[ Register the car customs shop location ]]--
	GM.CarShop.m_tblGarage["rp_rockford_open"] = {
		NoDoors = true,
		CarPos = {
			Vector( -6230.875000, -1215.500000, -13953.250000 ),
			Vector( -6207.687500, -1812.531250, -13953.250000 ),
		},
		
		BBox = {
			Min = Vector( -5392.031250, -1959.968750, -13887.968750 ), --Inside of the garage
			Max = Vector( -6311.968750, -1104.031250, -13887.968750 ), --Inside of the garage
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
GM.Config.CarPreviewModelPos = Vector( -3403.156250, -844.031250, -13933.968750 )
GM.Config.CarPreviewCamPos = Vector( -3607.24, -997.08, -13791.12 )
GM.Config.CarPreviewCamAng = Angle( 24.56, 40.82, 0 )
GM.Config.CarPreviewCamLen = 1.5


--[[ Chop Shop ]]--
GM.Config.ChopShop_ChopLocation = Vector( -4182, -8230, 287 )


--[[ Weather & Day Night ]]--
GM.Config.Weather_SkyZPos = nil --Skybox is not even height!
GM.Config.FogLightingEnabled = false