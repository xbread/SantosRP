--[[
	Name: book_store.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "book_store"
MapProp.m_tblSpawn = {
	{ mdl = 'models/props_interiors/cashregister01.mdl',pos = Vector('2046.187500 1454.843750 573.968750'), ang = Angle('-0.527 -164.004 0.527'), },
	{ mdl = 'models/props_interiors/furniture_lamp01a.mdl',pos = Vector('1679.781250 1439.250000 577.781250'), ang = Angle('-0.308 -167.915 0.000'), },
	{ mdl = 'models/props_interiors/corkboardverticle01.mdl',pos = Vector('1972.000000 1787.343750 611.343750'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props_interiors/chairlobby01.mdl',pos = Vector('2175.968750 1742.750000 545.031250'), ang = Angle('-0.044 -2.109 -3.516'), },
	{ mdl = 'models/props_interiors/magazine_rack.mdl',pos = Vector('2130.656250 1424.531250 544.468750'), ang = Angle('-0.044 90.000 0.000'), },
	{ mdl = 'models/sunabouzu/theater_table.mdl',pos = Vector('1748.031250 1499.781250 560.312500'), ang = Angle('0.000 -1.230 0.000'), },
	{ mdl = 'models/testmodels/macbook_pro.mdl',pos = Vector('2008.906250 1475.218750 574.125000'), ang = Angle('-0.044 -98.306 -0.132'), },
	{ mdl = 'models/props_lab/bindergraylabel01a.mdl',pos = Vector('2046.468750 1781.937500 573.562500'), ang = Angle('-0.352 -88.682 0.000'), },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('1906.500000 1766.906250 544.281250'), ang = Angle('-0.044 -90.044 0.000'), },
	{ mdl = 'models/props_equipment/snack_machine.mdl',pos = Vector('2184.375000 1429.750000 541.437500'), ang = Angle('0.000 90.088 -0.044'), },
	{ mdl = 'models/props/cs_militia/wood_table.mdl',pos = Vector('2026.281250 1771.500000 544.218750'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props_interiors/chairlobby01.mdl',pos = Vector('2101.281250 1738.375000 544.312500'), ang = Angle('0.000 4.087 -0.132'), },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('2099.687500 1774.125000 573.593750'), ang = Angle('-0.220 -90.352 0.176'), },
	{ mdl = 'models/props_junk/garbage_coffeemug001a.mdl',pos = Vector('2001.343750 1765.687500 576.343750'), ang = Angle('-0.264 -52.383 0.132'), },
	{ mdl = 'models/props_interiors/chairlobby01.mdl',pos = Vector('2015.125000 1727.656250 544.343750'), ang = Angle('-0.132 -27.422 -0.264'), },
	{ mdl = 'models/props/cs_militia/wood_table.mdl',pos = Vector('2175.250000 1771.500000 544.312500'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/splayn/rp/lr/couch.mdl',pos = Vector('1745.500000 1434.687500 544.375000'), ang = Angle('-0.044 90.132 0.000'), },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('1684.625000 1769.593750 543.687500'), ang = Angle('0.044 -133.154 -0.088'), },
	{ mdl = 'models/props/cs_office/sofa_chair.mdl',pos = Vector('1641.812500 1766.781250 544.375000'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_office/sofa_chair.mdl',pos = Vector('1725.687500 1766.843750 544.343750'), ang = Angle('0.000 -90.088 -0.044'), },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('1799.218750 1761.343750 544.343750'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/props/cs_havana/bookcase_small.mdl',pos = Vector('1540.312500 1599.531250 552.218750'), ang = Angle('0.000 -89.956 -0.044'), },
	{ mdl = 'models/props/cs_office/bookshelf2.mdl',pos = Vector('1812.875000 1761.187500 544.250000'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props/cs_militia/wood_table.mdl',pos = Vector('2100.750000 1771.500000 544.312500'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('1799.218750 1708.187500 544.343750'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/props/cs_havana/bookcase_large.mdl',pos = Vector('1540.250000 1707.843750 620.625000'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('1812.875000 1708.218750 544.406250'), ang = Angle('-0.044 0.088 0.000'), },
	{ mdl = 'models/props/cs_office/offcorkboarda.mdl',pos = Vector('1906.218750 1787.593750 607.156250'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/props_lab/huladoll.mdl',pos = Vector('2054.468750 1773.312500 573.937500'), ang = Angle('0.220 -101.206 0.527'), },
	{ mdl = 'models/props_interiors/desk_metal.mdl',pos = Vector('2001.843750 1474.687500 541.625000'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_havana/bookcase_large.mdl',pos = Vector('1540.406250 1480.156250 620.593750'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('2020.531250 1772.843750 573.625000'), ang = Angle('-0.176 -90.308 -0.088'), },
	{ mdl = 'models/props/cs_havana/bookcase_large.mdl',pos = Vector('1540.406250 1480.156250 552.218750'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_havana/bookcase_small.mdl',pos = Vector('1540.312500 1599.531250 620.750000'), ang = Angle('0.000 -89.956 -0.044'), },
	{ mdl = 'models/splayn/rp/lr/chair.mdl',pos = Vector('1665.562500 1478.187500 544.406250'), ang = Angle('-0.044 22.720 -0.044'), },
	{ mdl = 'models/props/cs_office/offinspf.mdl',pos = Vector('1740.750000 1412.281250 611.281250'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props/cs_havana/bookcase_large.mdl',pos = Vector('1540.250000 1707.843750 552.250000'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/splayn/rp/lr/chair.mdl',pos = Vector('1832.312500 1467.031250 544.531250'), ang = Angle('0.220 134.868 0.308'), },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('2175.937500 1774.468750 573.468750'), ang = Angle('0.220 -90.044 -0.044'), },
	{ mdl = 'models/props_interiors/desk_metal.mdl',pos = Vector('2049.375000 1452.343750 541.625000'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('2217.062500 1765.656250 543.718750'), ang = Angle('0.264 32.168 0.352'), },
	{ mdl = 'models/props/cs_office/offinspg.mdl',pos = Vector('2002.468750 1413.062500 609.312500'), ang = Angle('0.000 0.000 0.000'), },
}

GAMEMODE.Map:RegisterMapProp( MapProp )