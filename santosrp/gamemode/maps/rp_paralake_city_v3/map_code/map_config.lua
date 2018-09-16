--[[
	Name: map_config.lua
	
		
]]--

if SERVER then
	resource.AddWorkshop( "579409868") --map
	resource.AddWorkshop( "579407884") --map content p.1
	resource.AddWorkshop( "579409188") --map content p.2
	
	--[[ Car Dealer Settings ]]--
	GM.Config.CarSpawns = {
		{ Vector( -5059.041992, 3171.136963, 288.031250 ), Angle( 0, 90, 0 ) },
		{ Vector( -5057.848633, 3393.136963, 288.031250 ), Angle( 0, 90, 0 ) },
		{ Vector( -5056.688477, 3608.386963, 288.031250 ), Angle( 0, 90, 0 ) },
		{ Vector( -5055.531250, 3823.636963, 288.031250 ), Angle( 0, 90, 0 ) },
		{ Vector( -5054.342285, 4043.386963, 288.031250 ), Angle( 0, 90, 0 ) },
		{ Vector( -4001.664307, 4016.667480, 288.031250 ), Angle( 0, -90, 0 ) },
		{ Vector( -4001.996338, 3793.167480, 288.031250 ), Angle( 0, -90, 0 ) },
		{ Vector( -4002.321533, 3578.667480, 288.031250 ), Angle( 0, -90, 0 ) },
		{ Vector( -4002.657959, 3358.167480, 288.031250 ), Angle( 0, -90, 0 ) },
		{ Vector( -4002.976807, 3147.417480, 288.031250 ), Angle( 0, -90, 0 ) },
		{ Vector( -4003.312256, 2926.167480, 288.031250 ), Angle( 0, -90, 0 ) },
	}
	GM.Config.CarGarageBBox = {
		Min = Vector( -5407.760254, 2289.167725, 260 ),
		Max = Vector( -3136.203125, 4175.577637, 1024 ),
	}

	--[[ Jail Settings ]]--
	GM.Config.JailPositions = {
		Vector( -7769.065918, 10627.841797, -774.968750 ),
		Vector( -7608.505859, 10629.277344, -774.968750 ),
		Vector( -7447.789063, 10631.541992, -774.968750 ),
		Vector( -7288.014648, 10628.874023, -774.968750 ),
		Vector( -7276.446777, 10314.981445, -774.968750 ),
		Vector( -7439.095215, 10316.829102, -774.968750 ),
		Vector( -7597.505371, 10313.082031, -774.968750 ),
		Vector( -7752.664063, 10311.818359, -774.968750 ),
	}
	GM.Config.JailReleasePositions = {
		Vector( -9092.318359, 10832.419922, 288.031250 ),
		Vector( -9102.884766, 10768.697266, 288.031250 ),
		Vector( -9031.946289, 10829.445313, 288.031250 ),
		Vector( -9032.783203, 10763.484375, 288.031250 ),
		Vector( -9059.055664, 10714.805664, 288.031250 ),
		Vector( -8947.312500, 10779.576172, 288.031250 ),
	}
	GM.Config.JailBBox = {
		Min = Vector( -8149.527832, 10266.830078, -800 ),
		Max = Vector( -7147.175781, 10746.897461, -450 ),
	}

	--[[ NPC Drug Dealer Settings ]]--
	GM.Config.DrugNPCPositions = {
		{ Vector( -9380.265625, 8607.599609, 8 ), Angle(0, 0, 0) },
		{ Vector( 1797.927124, 9606.061523, 78 ), Angle(0, 50, 0) },
		{ Vector( 8474.322266, -7223.315918, 90 ), Angle(0, -140, 0) },
		{ Vector( 11273.801758, -244.420776, 450 ), Angle(0, 100, 0) },
	}

	--[[ Map Settings ]]--
	GM.Config.SpawnPoints = {
		Vector( -4549.042969, 10053.715820, 416.031250 ),
		Vector( -4481.622559, 10229.341797, 416.031250 ),
		Vector( -4874.284668, 10024.970703, 416.031250 ),
		Vector( -5098.170898, 10123.297852, 416.031250 ),
		Vector( -4893.638184, 10308.343750, 416.031250 ),
		Vector( -5120.490234, 10600.036133, 416.031250 ),
		Vector( -4830.434570, 10566.908203, 416.031250 ),
	}

	--[[ Register the car customs shop location ]]--
	GM.CarShop.m_tblGarage["rp_paralake_city_v3"] = {
		Doors = {
			["Repair_garagedoor 2"] = { CarPos = Vector(-7931, -7157, 316) }, --Doors for the garage
			["Repair_garagedoor 1"] = { CarPos = Vector(-7526, -7157, 316) }, --Doors for the garage
		},
		BBox = {
			Min = Vector( -8127, -7438, 294 ), --Inside of the garage
			Max = Vector( -7344, -7057, 411 ), --Inside of the garage
		},
		PlayerSetPos = Vector( -7730, -7507, 292 ), --If a player gets inside the garage, set them to this location
	}

	--[[ Fire Spawner Settings ]]--
	GM.Config.AutoFiresEnabled = true
	GM.Config.AutoFireSpawnMinTime = 60 *15
	GM.Config.AutoFireSpawnMaxTime = 60 *60
	GM.Config.AutoFireSpawnPoints = {
		--Gas stations
		Vector( "-8942.533203 -7861.419922 288.031250" ),
		Vector( "-8715.147461 -8090.916504 288.031250" ),
		Vector( "-6547.855469 1689.688477 288.031250" ),
		Vector( "-6564.518066 1903.038940 288.031250" ),
		Vector( "-11943.944336 10784.564453 60.031250" ),
		Vector( "-12175.997070 10799.713867 60.031250" ),

		--Gas stations inside
		Vector( "-6895.257324 1255.600098 292.031250" ),
		Vector( "-11610.813477 10396.053711 64.031250" ),
		Vector( "-8439.782227 -7404.658203 292.031250" ),

		--Junkyard
		Vector( "-3962.382568 -9468.200195 286.502014" ),
		Vector( "-5659.629395 -9288.423828 280.031250" ),
		Vector( "-3365.916992 -8674.002930 280.031250" ),

		--Grocery store
		Vector( "-11883.190430 -11767.650391 292.031250" ),
		Vector( "-11879.181641 -10883.125977 292.031250" ),

		--Electronics store alley
		Vector( "-11857.025391 -12460.521484 292.031219" ),

		--Bank
		Vector( "-4931.397949 4436.788086 288.031250" ),

		--Underpass
		Vector( "-12887.172852 5914.155273 8.031250" ),
	}
end

--[[ Car Dealer Settings ]]--
GM.Config.CarPreviewModelPos = Vector( -9263.245117, -11054.450195, 300 )
GM.Config.CarPreviewCamPos = Vector( -9398.241211, -11223.866211, 412.947296 )
GM.Config.CarPreviewCamAng = Angle( 20, 51, 0 )
GM.Config.CarPreviewCamLen = 1.5

--[[ Chop Shop ]]--
GM.Config.ChopShop_ChopLocation = Vector( -5658.086914, -9473.299805, 348.023529 )

--[[ Weather & Day Night ]]--
GM.Config.Weather_SkyZPos = 3430
GM.Config.FogLightingEnabled = true