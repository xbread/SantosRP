--[[
	Name: car_dealer.lua
	For: SantosRP
	By: Ultra
]]--

local MapProp = {}
MapProp.ID = "car_dealer"
MapProp.m_tblSpawn = {
	{ mdl = 'models/props_lab/frame002a.mdl',pos = Vector('1475.269043 -2288.653564 271.803253'), ang = Angle('-0.983 -77.585 0.209') },
	{ mdl = 'models/props_interiors/furniture_lamp01a.mdl',pos = Vector('1532.064453 -2289.910645 273.760559'), ang = Angle('0.022 -157.390 0.000') },
	{ mdl = 'models/props_combine/breenclock.mdl',pos = Vector('1456.056274 -2300.510498 275.951965'), ang = Angle('-0.818 -45.313 0.110') },
	{ mdl = 'models/props/cs_office/radio.mdl',pos = Vector('1191.798706 -2124.962158 271.841949'), ang = Angle('1.615 178.731 -0.038') },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('1439.983765 -2337.093994 271.840607'), ang = Angle('-0.582 -20.803 -0.027') },
	{ mdl = 'models/props/cs_office/trash_can.mdl',pos = Vector('1536.045654 -1385.495850 240.202728'), ang = Angle('0.000 180.000 0.000') },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('1231.876221 -2071.179688 240.376343'), ang = Angle('-0.005 -89.973 0.016') },
	{ mdl = 'models/props/cs_office/computer_caseb.mdl',pos = Vector('1284.160278 -2119.089844 240.491867'), ang = Angle('0.000 83.271 0.077') },
	{ mdl = 'models/props/cs_office/offcertificatea.mdl',pos = Vector('1458.035156 -2423.541260 325.389465'), ang = Angle('0.000 0.000 0.000') },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('1260.544800 -2116.439941 271.796936'), ang = Angle('-0.143 113.269 0.022') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('1194.729980 -2105.441406 271.730774'), ang = Angle('-0.115 63.528 0.242') },
	{ mdl = 'models/props/cs_office/water_bottle.mdl',pos = Vector('1200.841675 -2118.278320 276.889648'), ang = Angle('0.000 67.500 0.000') },
	{ mdl = 'models/props/cs_office/shelves_metal2.mdl',pos = Vector('1198.520874 -1350.807373 240.371521'), ang = Angle('-0.121 -179.753 0.022') },
	{ mdl = 'models/props/cs_office/offcorkboarda.mdl',pos = Vector('1184.497559 -2205.970215 308.255890'), ang = Angle('2.571 -90.060 0.615') },
	{ mdl = 'models/props/cs_office/offcorkboarda.mdl',pos = Vector('1184.354980 -2254.537109 309.168335'), ang = Angle('0.000 -90.000 0.000') },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('1204.291748 -2325.455078 271.763123'), ang = Angle('0.775 -65.770 -0.038') },
	{ mdl = 'models/props/cs_office/paper_towels.mdl',pos = Vector('1542.908325 -1284.835693 286.603790'), ang = Angle('89.275 0.417 127.881') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('1267.606201 -2333.137451 271.714111'), ang = Angle('0.313 -111.857 -0.308') },
	{ mdl = 'models/props/cs_office/file_box.mdl',pos = Vector('1258.192017 -2311.241699 271.891022'), ang = Angle('0.000 3.955 0.005') },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('1230.384644 -2320.802490 240.370667'), ang = Angle('-0.005 90.000 0.000') },
	{ mdl = 'models/props/cs_office/computer_caseb.mdl',pos = Vector('1284.873291 -2329.746826 240.423660'), ang = Angle('0.000 -93.378 0.786') },
	{ mdl = 'models/props/cs_office/cardboard_box03.mdl',pos = Vector('1276.561279 -2414.661133 240.489197'), ang = Angle('-0.088 78.294 -0.060') },
	{ mdl = 'models/props/cs_office/paperbox_pile_01.mdl',pos = Vector('1249.974731 -1188.551147 240.498871'), ang = Angle('0.000 -90.016 0.000') },
	{ mdl = 'models/props_c17/furnituretable002a.mdl',pos = Vector('1535.164307 -1273.369019 258.513184'), ang = Angle('0.000 -179.995 0.000') },
	{ mdl = 'models/props/cs_office/microwave.mdl',pos = Vector('1538.224976 -1257.048340 277.658020'), ang = Angle('0.000 92.291 0.000') },
	{ mdl = 'models/props/cs_office/shelves_metal3.mdl',pos = Vector('1198.666870 -1286.541870 240.371063'), ang = Angle('0.055 -179.780 -0.011') },
	{ mdl = 'models/props/cs_office/cardboard_box01.mdl',pos = Vector('1305.524902 -2403.050049 240.414597'), ang = Angle('-0.071 71.774 -0.357') },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('1485.223755 -1174.189697 240.388168'), ang = Angle('-0.038 -90.033 -0.011') },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('1356.655762 -1174.261353 240.370834'), ang = Angle('-0.022 -89.984 -0.027') },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('1229.336548 -2375.223633 240.323196'), ang = Angle('0.000 67.500 0.000') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('1542.271851 -1193.546265 239.710007'), ang = Angle('0.159 -135.000 -0.159') },
	{ mdl = 'models/props/cs_office/shelves_metal1.mdl',pos = Vector('1198.487793 -1415.210449 240.375183'), ang = Angle('-0.044 -179.841 -0.011') },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('1230.801636 -2119.134766 240.382004'), ang = Angle('0.033 -90.104 -0.022') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('1379.463379 -1790.298950 240.440079'), ang = Angle('0.165 90.038 0.000') },
	{ mdl = 'models/props/cs_office/bookshelf2.mdl',pos = Vector('1191.084229 -1699.408569 240.505646'), ang = Angle('0.049 0.000 0.000') },
	{ mdl = 'models/props_c17/bench01a.mdl',pos = Vector('1544.583618 -1657.909912 259.876068'), ang = Angle('0.000 179.995 0.000') },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('1420.883179 -1174.235107 240.358734'), ang = Angle('0.038 -89.967 0.000') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('1492.432983 -2295.212891 271.798279'), ang = Angle('0.000 -90.000 0.000') },
	{ mdl = 'models/props/cs_office/table_coffee.mdl',pos = Vector('1379.546021 -1723.734131 240.292526'), ang = Angle('0.000 -90.000 0.000') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('1377.156250 -1659.603149 240.352890'), ang = Angle('0.016 -89.967 0.000') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('1544.582764 -1595.937012 239.680710'), ang = Angle('0.000 135.000 0.000') },
	{ mdl = 'models/props_c17/furnituretable002a.mdl',pos = Vector('1535.347290 -1341.505249 258.539185'), ang = Angle('-0.115 179.720 0.071') },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('1352.616455 -2409.860596 240.291275'), ang = Angle('0.027 89.934 0.000') },
	{ mdl = 'models/props/cs_office/sofa_chair.mdl',pos = Vector('1288.046143 -1722.644043 240.393082'), ang = Angle('0.033 0.060 0.000') },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('1191.157959 -1646.379028 240.496857'), ang = Angle('0.000 0.000 0.005') },
	{ mdl = 'models/props_interiors/furniture_lamp01a.mdl',pos = Vector('1545.022949 -1717.342773 273.744904'), ang = Angle('0.000 157.500 0.000') },
	{ mdl = 'models/props_c17/bench01a.mdl',pos = Vector('1544.844482 -1777.082520 259.894348'), ang = Angle('0.049 179.984 0.000') },
	{ mdl = 'models/props/cs_office/bookshelf3.mdl',pos = Vector('1191.085205 -1752.422363 240.514526'), ang = Angle('-0.022 0.011 0.011') },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('1516.432617 -2345.371826 240.417358'), ang = Angle('-0.038 179.808 0.093') },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('1460.629761 -2314.417236 240.335800'), ang = Angle('0.126 134.918 -0.016') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('1527.940796 -2236.580322 239.709656'), ang = Angle('-0.176 157.154 0.434') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('1808.994141 -1552.226929 75.668007'), ang = Angle('0.000 -22.500 0.000') },
	{ mdl = 'models/props/cs_office/table_coffee.mdl',pos = Vector('1789.808960 -1665.227173 76.367821'), ang = Angle('-0.082 61.408 -0.016') },
	{ mdl = 'models/props/cs_office/table_coffee.mdl',pos = Vector('1722.456787 -1621.691162 76.499802'), ang = Angle('0.000 54.679 0.000') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('1660.337280 -1673.912720 76.259430'), ang = Angle('0.011 34.563 0.000') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('1847.826782 -1607.098999 76.420685'), ang = Angle('0.220 -133.731 0.000') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('1744.715454 -1545.704102 76.417938'), ang = Angle('0.225 -106.875 0.000') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('1791.069214 -1744.214600 76.417320'), ang = Angle('-0.038 89.720 -0.005') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('1711.006470 -1732.767700 75.732903'), ang = Angle('0.000 52.800 0.522') },
}
MapProp.m_tblCars = {
	{ mdl = 'models/tdmcars/242turbo.mdl',pos = Vector('1376.007324 -2004.057495 79.278519'), ang = Angle('0.005 -110.869 0.169') },
	{ mdl = 'models/tdmcars/lam_gallardospyd.mdl',pos = Vector('2415.022705 -1878.820435 74.994141'), ang = Angle('0.011 -47.302 -0.141') },
	{ mdl = 'models/tdmcars/hon_civic97.mdl',pos = Vector('1379.017334 -1321.083740 75.336777'), ang = Angle('-0.044 -58.705 0.115') },
	{ mdl = 'models/tdmcars/rx8.mdl',pos = Vector('1373.126953 -1556.309326 75.122231'), ang = Angle('0.000 -104.678 0.115') },
	{ mdl = 'models/tdmcars/por_carreragt.mdl',pos = Vector('2157.779297 -2270.072754 74.938835'), ang = Angle('-0.000 83.227 0.308') },
	{ mdl = 'models/tdmcars/toy_mr2gt.mdl',pos = Vector('1382.403809 -2252.719727 75.456490'), ang = Angle('-0.000 -51.932 0.095') },
	{ mdl = 'models/tdmcars/mitsu_evox.mdl',pos = Vector('1369.544312 -1794.799805 70.163162'), ang = Angle('0.000 -64.583 -0.547') },
	{ mdl = 'models/tdmcars/hon_s2000.mdl',pos = Vector('2147.021729 -1304.505981 76.103737'), ang = Angle('-0.016 61.490 -0.615') },
	{ mdl = 'models/tdmcars/chev_camzl1.mdl',pos = Vector('2428.972168 -1318.551636 75.728111'), ang = Angle('-0.000 139.285 0.208') },
	{ mdl = 'models/tdmcars/350z.mdl',pos = Vector('1881.267578 -1323.559448 76.367859'), ang = Angle('0.000 -137.642 0.401') },
	{ mdl = 'models/tdmcars/bmwm3e92.mdl',pos = Vector('2405.218506 -2204.484375 75.542191'), ang = Angle('0.011 29.850 0.298') },
}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblCars ) do
		local ent = ents.Create( "prop_physics" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
		ent:SetModel( propData.mdl )
		ent:SetCollisionGroup( COLLISION_GROUP_NONE )
		ent:SetMoveType( MOVETYPE_NONE )
		ent.IsMapProp = true
		ent:Spawn()
		ent:Activate()

		ent:SetSaveValue( "fademindist", GAMEMODE.Config.DetailPropFadeMin )
		ent:SetSaveValue( "fademaxdist", GAMEMODE.Config.DetailPropFadeMax )
		ent:SetPoseParameter( "vehicle_wheel_fl_height", 0.5 )
		ent:SetPoseParameter( "vehicle_wheel_fr_height", 0.5 )
		ent:SetPoseParameter( "vehicle_wheel_rl_height", 0.5 )
		ent:SetPoseParameter( "vehicle_wheel_rr_height", 0.5 )
		--ent:InvalidateBoneCache()

		local rand = math.random( 1, table.Count(GAMEMODE.Config.StockCarColors) )
		local idx = 0
		for k, v in pairs( GAMEMODE.Config.StockCarColors ) do
			idx = idx +1
			if idx == rand then
				ent:SetColor( v )
				break
			end
		end
		
		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end

	--Make the car preview area
	local ent = ents.Create( "prop_physics" )
	ent:SetModel( "models/hunter/tubes/circle4x4.mdl" )
	ent:SetPos( Vector(2164.933105, -1616.638672, 77.687775) )
	ent:SetAngles( Angle(0, 0, 0) )
	ent:SetMaterial( "phoenix_storms/dome" )
	ent.IsMapProp = true
	ent:Spawn()
	ent:Activate()
	ent:SetModelScale( 1.5 )
	ent:PhysicsInit( SOLID_VPHYSICS )
	ent:SetMoveType( MOVETYPE_NONE )
	ent:SetSaveValue( "fademindist", GAMEMODE.Config.DetailPropFadeMin )
	ent:SetSaveValue( "fademaxdist", GAMEMODE.Config.DetailPropFadeMax )

	local phys = ent:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )