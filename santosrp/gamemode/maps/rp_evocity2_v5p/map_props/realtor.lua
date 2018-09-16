--[[
	Name: realtor.lua
	For: SantosRP
	By: Ultra
]]--

local MapProp = {}
MapProp.ID = "realtor"
MapProp.m_tblSpawn = {
	{ mdl = 'models/props/cs_office/paperbox_pile_01.mdl',pos = Vector('1061.288574 -1627.480103 76.500603'), ang = Angle('-0.005 90.055 0.000') },
	{ mdl = 'models/props/cs_office/computer_caseb.mdl',pos = Vector('1024.122437 -1189.963013 76.324409'), ang = Angle('0.000 2.329 -0.027') },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('1009.741577 -1219.071411 107.980492'), ang = Angle('-0.005 -24.604 0.033') },
	{ mdl = 'models/props/cs_office/radio.mdl',pos = Vector('1001.243347 -1283.725830 107.881317'), ang = Angle('1.522 87.858 -0.016') },
	{ mdl = 'models/props/cs_office/offpaintingi.mdl',pos = Vector('1131.661377 -1449.498535 160.045837'), ang = Angle('0.033 89.978 0.000') },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('825.666687 -1641.727173 76.498100'), ang = Angle('0.011 89.918 -0.027') },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('890.034851 -1641.803711 76.375244'), ang = Angle('-0.038 89.978 -0.044') },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('1071.001465 -1217.756226 76.497314'), ang = Angle('-0.143 -134.517 0.154') },
	{ mdl = 'models/props/cs_office/table_coffee.mdl',pos = Vector('791.781799 -1446.947388 76.372269'), ang = Angle('-0.143 90.527 -0.027') },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('1008.851807 -1243.194092 76.450256'), ang = Angle('0.022 -179.962 -0.027') },
	{ mdl = 'models/props/cs_office/file_box.mdl',pos = Vector('473.571136 -1558.590088 107.792580'), ang = Angle('0.000 94.400 -0.549') },
	{ mdl = 'models/props/cs_office/table_coffee.mdl',pos = Vector('503.506287 -1264.532349 76.496933'), ang = Angle('-0.005 -60.244 0.000') },
	{ mdl = 'models/props/cs_office/tv_plasma.mdl',pos = Vector('689.093140 -1655.596924 141.868317'), ang = Angle('0.000 89.995 0.000') },
	{ mdl = 'models/props/cs_office/offpaintingj.mdl',pos = Vector('1131.628662 -1398.138550 154.665863'), ang = Angle('0.000 90.000 0.000') },
	{ mdl = 'models/props/cs_office/offpaintingk.mdl',pos = Vector('1131.540771 -1349.005127 167.532608'), ang = Angle('0.000 89.995 0.000') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('977.386108 -1175.287842 75.704224'), ang = Angle('-0.209 -134.995 -0.203') },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('465.316437 -1607.278076 107.765091'), ang = Angle('0.648 164.443 -0.033') },
	{ mdl = 'models/props_combine/breenglobe.mdl',pos = Vector('503.909729 -1263.850952 109.829582'), ang = Angle('-0.472 -50.131 0.313') },
	{ mdl = 'models/props/cs_office/bookshelf2.mdl',pos = Vector('371.044678 -1393.997192 76.499947'), ang = Angle('-0.016 -0.093 0.000') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('419.748444 -1230.352539 76.382004'), ang = Angle('-0.181 -36.420 -0.011') },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('407.934296 -1613.462769 76.412148'), ang = Angle('-0.066 15.820 0.209') },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('466.805664 -1582.253906 76.342346'), ang = Angle('0.000 0.000 0.000') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('1020.027344 -1281.496216 107.842201'), ang = Angle('-0.379 20.945 -0.357') },
	{ mdl = 'models/props/cs_office/offpaintingo.mdl',pos = Vector('651.309692 -1152.414551 147.640579'), ang = Angle('0.000 180.000 0.000') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('463.851563 -1176.759399 75.683319'), ang = Angle('-0.016 -60.853 -0.192') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('536.442017 -1174.309204 76.378487'), ang = Angle('0.044 -90.027 0.071') },
	{ mdl = 'models/props/cs_office/trash_can.mdl',pos = Vector('385.407257 -1287.944336 76.367111'), ang = Angle('-0.077 -5.625 -0.154') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('793.358582 -1518.296143 76.366737'), ang = Angle('0.000 89.995 0.000') },
	{ mdl = 'models/props/cs_office/shelves_metal2.mdl',pos = Vector('1117.487305 -1547.797485 76.442490'), ang = Angle('-0.005 -0.005 -0.093') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('791.538818 -1381.533447 76.280075'), ang = Angle('0.000 -90.000 0.000') },
	{ mdl = 'models/props/cs_office/offpaintingg.mdl',pos = Vector('1131.619019 -1302.939819 160.216568'), ang = Angle('0.000 89.995 0.000') },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('371.068756 -1340.582397 76.492744'), ang = Angle('0.060 0.000 0.000') },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('954.410950 -1641.692383 76.445030'), ang = Angle('-0.110 89.896 -0.049') },
	{ mdl = 'models/props/cs_office/offcertificatea.mdl',pos = Vector('1131.605347 -1240.290649 147.609497'), ang = Angle('0.000 90.000 0.000') },
	{ mdl = 'models/props/cs_office/offpaintingm.mdl',pos = Vector('846.323364 -1152.455811 147.842972'), ang = Angle('0.000 -179.995 0.000') },
	{ mdl = 'models/props/cs_office/computer_caseb.mdl',pos = Vector('453.440582 -1636.192017 76.490875'), ang = Angle('0.000 179.022 -0.088') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('455.473419 -1544.487671 107.859520'), ang = Angle('0.000 -166.273 0.000') },
}

GAMEMODE.Map:RegisterMapProp( MapProp )