--[[
	Name: furn_store.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "furn_store"
MapProp.m_tblSpawn = {
	{ mdl = 'models/props_trainstation/trainstation_clock001.mdl',pos = Vector('1542.281250 1987.125000 680.718750'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props/cs_militia/barstool01.mdl',pos = Vector('2046.562500 2112.437500 544.218750'), ang = Angle('-0.044 -90.000 0.132'), },
	{ mdl = 'models/sunabouzu/lobby_poster.mdl',pos = Vector('1773.312500 2171.468750 643.593750'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_militia/gun_cabinet.mdl',pos = Vector('1555.781250 2016.531250 544.406250'), ang = Angle('-0.044 -0.967 -0.088'), },
	{ mdl = 'models/props_c17/furniturecupboard001a.mdl',pos = Vector('1887.906250 2160.843750 606.406250'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props_interiors/magazine_rack.mdl',pos = Vector('1552.375000 1855.750000 544.406250'), ang = Angle('0.000 0.000 -0.044'), },
	{ mdl = 'models/props/cs_office/table_coffee.mdl',pos = Vector('1772.656250 2097.531250 544.343750'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_office/offinspa.mdl',pos = Vector('2014.093750 1796.406250 622.500000'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props_combine/breenchair.mdl',pos = Vector('2156.375000 2146.531250 544.406250'), ang = Angle('0.176 -108.721 0.132'), },
	{ mdl = 'models/props/cs_office/sofa_chair.mdl',pos = Vector('1696.656250 2097.750000 544.375000'), ang = Angle('-0.044 -1.011 -0.044'), },
	{ mdl = 'models/props_interiors/furniture_shelf01a.mdl',pos = Vector('2018.406250 2162.406250 587.593750'), ang = Angle('0.132 -90.000 -0.044'), },
	{ mdl = 'models/props_c17/furnituredresser001a.mdl',pos = Vector('1961.125000 2155.500000 585.406250'), ang = Angle('1.582 -90.000 0.000'), },
	{ mdl = 'models/props/cs_office/sofa_chair.mdl',pos = Vector('1850.000000 2095.062500 544.312500'), ang = Angle('-0.044 178.989 -0.044'), },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('1772.656250 2150.406250 544.343750'), ang = Angle('0.088 -90.088 -0.044'), },
	{ mdl = 'models/props_interiors/chair_thonet.mdl',pos = Vector('1749.062500 1861.375000 544.406250'), ang = Angle('-0.132 -96.855 0.923'), },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('2097.968750 2114.843750 544.343750'), ang = Angle('-0.132 180.000 0.000'), },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('2209.187500 1819.187500 543.687500'), ang = Angle('-0.220 -87.231 -0.220'), },
	{ mdl = 'models/props_interiors/chair_thonet.mdl',pos = Vector('1787.812500 1824.406250 544.437500'), ang = Angle('0.000 165.542 -0.088'), },
	{ mdl = 'models/props_interiors/chair_thonet.mdl',pos = Vector('1713.031250 1823.125000 544.468750'), ang = Angle('0.439 0.747 -0.396'), },
	{ mdl = 'models/props_interiors/furniture_lamp01a.mdl',pos = Vector('2208.187500 2152.656250 577.625000'), ang = Angle('-0.088 180.000 -0.044'), },
	{ mdl = 'models/props_c17/furnituredrawer002a.mdl',pos = Vector('2204.343750 2056.781250 560.843750'), ang = Angle('0.088 180.000 0.000'), },
	{ mdl = 'models/props_interiors/furniture_desk01a.mdl',pos = Vector('2205.687500 2106.875000 563.937500'), ang = Angle('-0.132 179.956 0.000'), },
	{ mdl = 'models/testmodels/coffee_table_long.mdl',pos = Vector('1952.281250 1891.281250 544.343750'), ang = Angle('0.088 90.044 0.132'), },
	{ mdl = 'models/props_combine/breenglobe.mdl',pos = Vector('2088.656250 2148.812500 584.656250'), ang = Angle('0.044 -122.168 0.044'), },
	{ mdl = 'models/props_combine/breenclock.mdl',pos = Vector('2087.718750 2115.687500 579.843750'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/testmodels/sofa_double.mdl',pos = Vector('1946.781250 1823.125000 544.656250'), ang = Angle('-0.044 90.000 -0.044'), },
	{ mdl = 'models/splayn/rp/lr/chair.mdl',pos = Vector('2049.968750 1816.531250 544.406250'), ang = Angle('-0.132 89.956 -0.044'), },
	{ mdl = 'models/splayn/rp/lr/couch.mdl',pos = Vector('2133.062500 1879.625000 544.312500'), ang = Angle('0.000 90.000 0.000'), },
	{ mdl = 'models/props_interiors/desk_executive.mdl',pos = Vector('1614.687500 1989.093750 544.281250'), ang = Angle('0.000 179.868 0.000'), },
	{ mdl = 'models/props_c17/furnituredrawer001a.mdl',pos = Vector('1877.656250 2157.875000 564.437500'), ang = Angle('0.571 -90.044 0.132'), },
	{ mdl = 'models/testmodels/sofa_single.mdl',pos = Vector('1871.906250 1847.250000 545.625000'), ang = Angle('0.000 89.956 -0.044'), },
	{ mdl = 'models/sunabouzu/theater_table.mdl',pos = Vector('1847.093750 1891.718750 560.437500'), ang = Angle('0.044 -179.956 0.000'), },
	{ mdl = 'models/props_interiors/dining_table_round.mdl',pos = Vector('1749.875000 1826.812500 544.312500'), ang = Angle('0.044 131.396 0.000'), },
	{ mdl = 'models/props_interiors/cashregister01.mdl',pos = Vector('1612.375000 1976.031250 582.656250'), ang = Angle('-0.571 148.447 0.132'), },
	{ mdl = 'models/props_interiors/phone.mdl',pos = Vector('1601.281250 2024.343750 583.125000'), ang = Angle('0.132 179.297 0.483'), },
	{ mdl = 'models/props_c17/furnituredrawer003a.mdl',pos = Vector('1923.468750 2165.218750 566.625000'), ang = Angle('0.176 -90.000 0.000'), },
	{ mdl = 'models/splayn/rp/lr/couch.mdl',pos = Vector('2138.718750 1817.468750 544.312500'), ang = Angle('-0.044 89.868 -0.044'), },
	{ mdl = 'models/props/cs_militia/barstool01.mdl',pos = Vector('2023.093750 2112.437500 544.156250'), ang = Angle('-0.044 -90.000 0.132'), },
	{ mdl = 'models/props/cs_militia/barstool01.mdl',pos = Vector('1999.593750 2112.437500 544.125000'), ang = Angle('-0.044 -90.000 0.132'), },
}

GAMEMODE.Map:RegisterMapProp( MapProp )