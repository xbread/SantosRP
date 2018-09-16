--[[
	Name: map_config.lua
	For: SantosRP
	By: Ultra
]]--

if SERVER then
	resource.AddWorkshop( "538207599" ) --map
	resource.AddWorkshop( "538347004" ) --map content p.1
	resource.AddWorkshop( "538350412" ) --map content p.2

	--[[ Car Dealer Settings ]]--
	GM.Config.CarSpawns = {
		{ Vector( 1321, -2576, 76 ), Angle( 0, 180, 0 ) },
		{ Vector( 1710, -2576, 76 ), Angle( 0, 180, 0 ) },
	}
	GM.Config.CarGarageBBox = {
		Min = Vector( 1184.139160, -3062.782715, 60 ),
		Max = Vector( 2574.817383, -2432.138916, 331.968750 ),
	}

	--[[ Jail Settings ]]--
	GM.Config.JailPositions = {
		Vector( 431.941742, -2014.026123, -427.968750 ),
		Vector( 567.871582, -2013.279053, -427.968750 ),
		Vector( 696.630676, -2012.224976, -427.968750 ),
		Vector( 824.634460, -2011.994629, -427.968750 ),
		Vector( 817.407837, -2333.036133, -427.968750 ),
		Vector( 690.124207, -2332.469971, -427.968750 ),
		Vector( 563.377686, -2331.713379, -427.968750 ),
		Vector( 435.130127, -2330.947510, -427.968750 ),
	}
	GM.Config.JailReleasePositions = {
		Vector( -443.622620, -1528.857666, -427.968750 ),
		Vector( -384.211884, -1530.030762, -427.968750 ),
		Vector( -321.025360, -1531.278198, -427.968750 ),
		Vector( -272.838440, -1532.229004, -427.968750 ),
		Vector( -268.412537, -1597.297119, -427.968750 ),
	}
	GM.Config.JailBBox = {
		Min = Vector( -442.439697, -2865.241943, -537.470642 ),
		Max = Vector( 1393.850586, -1495.114990, -182.535034 ),
	}

	--[[ NPC Drug Dealer Settings ]]--
	GM.Config.DrugNPCPositions = {
		{ Vector(4235.982422, 1886.990845, 90), Angle(0, 65, 0) },
		{ Vector(-7693.956543, 13896.530273, 220), Angle(0, 100, 0) },
		{ Vector(10429.881836, -11742.623047, -1705), Angle(0, 133, 0) },
		{ Vector(4248.085938, 6562.305176, -1800), Angle(0, -92, 0) },
	}

	--[[ Map Settings ]]--
	GM.Config.SpawnPoints = {
		Vector( -427.152161, -1317.699585, 76.031250 ),
		Vector( -417.965118, -1167.874878, 76.031250 ),
		Vector( -492.801392, -1084.796875, 76.031250 ),
		Vector( -689.465027, -1088.181519, 76.031250 ),
		Vector( -809.124756, -1087.980347, 76.031250 ),
		Vector( -812.688293, -1218.799194, 76.031250 ),
		Vector( -673.866943, -1188.138062, 76.031219 ),
		Vector( -664.278442, -1296.522095, 76.031250 ),
		Vector( -803.064331, -1342.030151, 76.031250 ),
		Vector( -588.568481, -1372.312622, 76.031219 ),
	}

	--[[ Register the car customs shop location ]]--
	GM.CarShop.m_tblGarage["rp_evocity2_v5p"] = {
		Doors = {
			["truckbay"] = { CarPos = Vector(-2772, 3577, 76) },
			["carbay"] = { CarPos = Vector(-2549, 3577, 76) },
		},
		BBox = {
			Min = Vector( 0, 0, 0 ),
			Max = Vector( 0, 0, 0 ),
		},
		PlayerSetPos = Vector(0, 0, 0),
	}

	--[[ Fire Spawner Settings ]]--
	GM.Config.AutoFiresEnabled = true
	GM.Config.AutoFireSpawnMinTime = 60 *15
	GM.Config.AutoFireSpawnMaxTime = 60 *60
	GM.Config.AutoFireSpawnPoints = {
		--Gas stations
		Vector( "-7250.792969 1213.995361 140.031235" ),
		Vector( "-7508.535156 1673.816284 140.031250" ),
		Vector( "-7369.942871 1842.052734 140.031250" ),

		--Tow impound
		Vector( "6994.235840 13582.430664 72.000000" ),

		--Club foods
		Vector( "8039.754395 6247.695313 70.031250" ),
		--Club foods back
		Vector( "8630.919922 5138.466797 64.031235" ),

		--City alley
		Vector( "3941.169434 146.384354 76.031250" ),

		--MTL
		Vector( "7603.112305 3250.128418 -1823.968750" ),

		--Farms
		Vector( "10125.783203 -9118.668945 -1728.000000" ),
		Vector( "13085.934570 -6553.687012 -1728.000000" ),
	}
end

--[[ Car Dealer Settings ]]--
GM.Config.CarPreviewModelPos = Vector( 2164.933105, -1616.638672, 79 )
GM.Config.CarPreviewCamPos = Vector( 2041.270508, -1760.573364, 180.039322 )
GM.Config.CarPreviewCamAng = Angle( 30, 50, 0 )
GM.Config.CarPreviewCamLen = 2

--[[ Chop Shop ]]--
GM.Config.ChopShop_ChopLocation = Vector( -1491, 14080, 64 )

--[[ Weather & Day Night ]]--
GM.Config.Weather_SkyZPos = nil --Let the code figure the zpos out on this map
GM.Config.FogLightingEnabled = false --This will override the fog hiding the farz