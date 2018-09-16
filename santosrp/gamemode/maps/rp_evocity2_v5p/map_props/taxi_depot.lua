--[[
	Name: taxi_depot.lua
	For: SantosRP
	By: Ultra
]]--

local MapProp = {}
MapProp.ID = "taxi_depot"
MapProp.m_tblSpawn = {
	{ mdl = 'models/props_c17/computer01_keyboard.mdl',pos = Vector('2854.981201 2339.396729 115.164536'), ang = Angle('-8.075 20.907 -0.846') },
	{ mdl = 'models/props_c17/computer01_keyboard.mdl',pos = Vector('2803.409180 2337.651611 115.458801'), ang = Angle('-3.593 169.980 -0.687') },
	{ mdl = 'models/props/cs_office/trash_can.mdl',pos = Vector('2760.539063 2501.831543 76.428864'), ang = Angle('-0.049 -92.285 -0.088') },
	{ mdl = 'models/props/cs_office/cardboard_box02.mdl',pos = Vector('2978.162354 2508.409668 139.936676'), ang = Angle('-0.610 -130.408 0.544') },
	{ mdl = 'models/props/cs_office/shelves_metal1.mdl',pos = Vector('2709.494385 2400.692871 76.489227'), ang = Angle('-0.016 -179.984 0.005') },
	{ mdl = 'models/props_lab/monitor02.mdl',pos = Vector('2845.614990 2318.140137 115.886826'), ang = Angle('-0.632 43.770 -0.703') },
	{ mdl = 'models/props_interiors/furniture_desk01a.mdl',pos = Vector('2848.660889 2338.554932 95.858315'), ang = Angle('-0.126 -0.165 -0.016') },
	{ mdl = 'models/props/cs_office/offinspf.mdl',pos = Vector('2515.488525 2449.599121 167.598587'), ang = Angle('0.000 -90.000 0.000') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('2939.101807 2503.493408 75.693741'), ang = Angle('0.011 -100.349 0.055') },
	{ mdl = 'models/props/cs_office/paper_towels.mdl',pos = Vector('2819.150635 2508.719482 122.475105'), ang = Angle('89.588 -69.648 18.594') },
	{ mdl = 'models/props/cs_office/offpaintingd.mdl',pos = Vector('2686.648926 2402.369873 159.091202'), ang = Angle('0.000 89.995 0.000') },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('2880.314209 2341.038330 76.400108'), ang = Angle('-0.011 177.742 0.082') },
	{ mdl = 'models/props/cs_office/offpaintingo.mdl',pos = Vector('2534.064209 2304.451904 160.384186'), ang = Angle('0.000 0.000 0.000') },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('2536.793701 2326.640625 76.366982'), ang = Angle('-0.011 49.466 0.104') },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('2998.599609 2505.698730 76.489471'), ang = Angle('-0.093 -90.088 -0.016') },
	{ mdl = 'models/props/cs_office/microwave.mdl',pos = Vector('2784.205078 2506.855225 113.711296'), ang = Angle('-0.027 -177.841 0.220') },
	{ mdl = 'models/props_c17/chair02a.mdl',pos = Vector('2565.499023 2523.589355 91.084129'), ang = Angle('0.209 -89.995 -0.110') },
	{ mdl = 'models/props/cs_office/shelves_metal3.mdl',pos = Vector('2709.431396 2336.337402 76.503143'), ang = Angle('-0.005 -179.995 0.000') },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('2775.032959 2334.115479 76.434685'), ang = Angle('-0.242 23.472 0.099') },
	{ mdl = 'models/props_interiors/furniture_desk01a.mdl',pos = Vector('2812.548828 2338.747559 95.843925'), ang = Angle('-0.022 179.445 0.011') },
	{ mdl = 'models/props_interiors/furniture_lamp01a.mdl',pos = Vector('2667.714600 2320.554688 109.739433'), ang = Angle('-0.555 161.900 -0.319') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('2579.503906 2377.199951 115.869102'), ang = Angle('-0.016 -119.998 -0.016') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('2814.815918 2363.620850 115.783218'), ang = Angle('0.005 -177.286 0.439') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('2850.834717 2362.187500 115.833725'), ang = Angle('-0.126 -11.080 -0.873') },
	{ mdl = 'models/props_lab/monitor02.mdl',pos = Vector('2814.167969 2318.045654 115.828720'), ang = Angle('-0.555 141.790 -0.374') },
	{ mdl = 'models/props_c17/furnituretable002a.mdl',pos = Vector('2800.225830 2499.822510 94.588959'), ang = Angle('-0.176 -90.000 -0.044') },
	{ mdl = 'models/props_c17/computer01_keyboard.mdl',pos = Vector('2558.627930 2376.659180 115.442520'), ang = Angle('-5.229 -89.308 -0.802') },
	{ mdl = 'models/props_lab/monitor02.mdl',pos = Vector('2535.704102 2395.121582 115.892670'), ang = Angle('-0.363 -61.194 -0.676') },
	{ mdl = 'models/props_c17/chair02a.mdl',pos = Vector('2530.328369 2523.561279 91.116341'), ang = Angle('0.038 -90.000 0.000') },
	{ mdl = 'models/props/cs_office/cardboard_box03.mdl',pos = Vector('3006.674561 2508.070557 139.872070'), ang = Angle('-0.198 -88.544 -0.016') },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('2672.817139 2400.437012 76.499802'), ang = Angle('0.000 -179.879 0.000') },
	{ mdl = 'models/props_interiors/furniture_desk01a.mdl',pos = Vector('2554.718262 2386.035400 95.961761'), ang = Angle('-0.082 -96.136 -0.033') },
	{ mdl = 'models/props/cs_office/coffee_mug.mdl',pos = Vector('2837.622070 2357.853516 115.704720'), ang = Angle('-0.851 59.052 -0.478') },
}

GAMEMODE.Map:RegisterMapProp( MapProp )