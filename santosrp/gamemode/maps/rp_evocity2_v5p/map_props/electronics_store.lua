--[[
	Name: electronics_store.lua
	For: SantosRP
	By: Ultra
]]--

local MapProp = {}
MapProp.ID = "electronics_store"
MapProp.m_tblSpawn = {
	{ mdl = 'models/props/cs_office/phone_p2.mdl',pos = Vector('-2401.705078 -1995.842773 112.655205'), ang = Angle('0.000 77.278 -90.000') },
	{ mdl = 'models/props/cs_office/phone_p1.mdl',pos = Vector('-2397.216064 -2000.882446 113.479996'), ang = Angle('-0.066 98.630 0.264') },
	{ mdl = 'models/props_c17/tv_monitor01.mdl',pos = Vector('-2476.670654 -1861.579224 121.520111'), ang = Angle('-0.192 -12.717 0.110') },
	{ mdl = 'models/props/cs_office/computer_caseb.mdl',pos = Vector('-2271.884766 -1833.633423 113.463280'), ang = Angle('0.066 -100.640 0.209') },
	{ mdl = 'models/props/cs_office/computer_caseb.mdl',pos = Vector('-2165.687012 -1828.718750 113.559044'), ang = Angle('-0.011 -67.500 -0.033') },
	{ mdl = 'models/props_lab/monitor02.mdl',pos = Vector('-2478.393555 -1961.055298 113.742897'), ang = Angle('-0.286 8.394 -0.516') },
	{ mdl = 'models/props/cs_office/projector.mdl',pos = Vector('-2178.953369 -1949.612671 113.273254'), ang = Angle('0.676 -136.791 0.000') },
	{ mdl = 'models/props_c17/furnituretable002a.mdl',pos = Vector('-2408.583984 -2008.525269 94.477951'), ang = Angle('0.000 89.995 0.000') },
	{ mdl = 'models/props_c17/furnituretable002a.mdl',pos = Vector('-2473.483887 -1875.491211 94.443825'), ang = Angle('-0.027 0.005 0.005') },
	{ mdl = 'models/props_lab/harddrive02.mdl',pos = Vector('-2471.696533 -1932.453125 123.408699'), ang = Angle('0.005 0.159 -0.390') },
	{ mdl = 'models/props_c17/furnituretable002a.mdl',pos = Vector('-2180.131104 -1829.358154 94.452408'), ang = Angle('0.005 -89.956 0.022') },
	{ mdl = 'models/props/cs_office/tv_plasma.mdl',pos = Vector('-2289.820801 -1672.356079 157.243454'), ang = Angle('0.000 -90.000 0.000') },
	{ mdl = 'models/props_c17/furnituretable002a.mdl',pos = Vector('-2248.223389 -1829.291748 94.464645'), ang = Angle('0.077 -90.027 0.000') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('-2340.507080 -2008.875732 75.651382'), ang = Angle('0.000 45.000 0.000') },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('-2249.704346 -1834.806274 113.511833'), ang = Angle('0.385 -84.792 0.000') },
	{ mdl = 'models/props/cs_office/radio.mdl',pos = Vector('-2206.800049 -1684.968140 108.386536'), ang = Angle('0.000 -67.489 0.000') },
	{ mdl = 'models/props_c17/furnituretable002a.mdl',pos = Vector('-2473.527344 -1943.677002 94.662331'), ang = Angle('0.005 0.044 0.000') },
	{ mdl = 'models/props/cs_office/radio.mdl',pos = Vector('-2158.811279 -1685.116211 108.279732'), ang = Angle('-0.165 -67.495 0.044') },
	{ mdl = 'models/props_trainstation/traincar_rack001.mdl',pos = Vector('-2207.335693 -1683.426636 105.386734'), ang = Angle('0.000 -90.000 0.000') },
	{ mdl = 'models/props/cs_office/radio.mdl',pos = Vector('-2257.290039 -1684.644897 108.348396'), ang = Angle('-0.544 -67.577 0.148') },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('-2193.066650 -1833.401123 113.508011'), ang = Angle('0.297 -97.476 0.027') },
	{ mdl = 'models/props/cs_office/tv_plasma.mdl',pos = Vector('-2207.980713 -1672.404907 139.224884'), ang = Angle('0.000 -90.000 0.000') },
	{ mdl = 'models/props_c17/furnituretable001a.mdl',pos = Vector('-2175.808105 -1952.859253 94.305016'), ang = Angle('0.000 -179.956 -0.044') },
	{ mdl = 'models/props/cs_office/projector_remote.mdl',pos = Vector('-2190.885010 -1958.791260 113.201363'), ang = Angle('0.516 168.536 -0.027') },
	{ mdl = 'models/props_lab/monitor01b.mdl',pos = Vector('-2482.093994 -1896.886108 118.956665'), ang = Angle('-8.026 18.232 -0.192') },
	{ mdl = 'models/props_c17/computer01_keyboard.mdl',pos = Vector('-2460.148193 -1959.302490 113.727303'), ang = Angle('-0.555 -0.088 -0.137') },
	{ mdl = 'models/props/de_nuke/clock.mdl',pos = Vector('-2497.605469 -1700.295410 177.681046'), ang = Angle('0.000 0.000 0.000') },
	{ mdl = 'models/props/cs_office/radio.mdl',pos = Vector('-2232.312988 -1684.803833 108.240555'), ang = Angle('0.000 -67.484 0.077') },
	{ mdl = 'models/props/cs_office/tv_plasma.mdl',pos = Vector('-2377.367432 -1672.494873 174.890778'), ang = Angle('0.000 -90.000 0.000') },
	{ mdl = 'models/props_combine/breenclock.mdl',pos = Vector('-2424.537842 -2002.982910 117.578743'), ang = Angle('0.198 90.055 0.121') },
	{ mdl = 'models/props_combine/breenclock.mdl',pos = Vector('-2416.431641 -2017.183838 117.708237'), ang = Angle('0.209 90.011 0.005') },
	{ mdl = 'models/props/cs_office/radio.mdl',pos = Vector('-2182.573975 -1684.587402 108.349503'), ang = Angle('0.533 -67.429 0.192') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('-2383.368164 -1998.989136 113.501465'), ang = Angle('-0.467 99.234 0.066') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('-2392.017090 -2015.295776 113.559555'), ang = Angle('0.198 99.503 -0.176') },
}

GAMEMODE.Map:RegisterMapProp( MapProp )