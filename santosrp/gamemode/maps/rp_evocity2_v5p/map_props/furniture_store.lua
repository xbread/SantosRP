--[[
	Name: furniture_store.lua
	For: SantosRP
	By: Ultra
]]--

local MapProp = {}
MapProp.ID = "furniture_store"
MapProp.m_tblSpawn = {
	{ mdl = 'models/props_c17/furniturechair001a.mdl',pos = Vector('3781.790039 -2671.989258 96.267715'), ang = Angle('-0.049 -51.471 0.044'), },
	{ mdl = 'models/props_wasteland/controlroom_filecabinet002a.mdl',pos = Vector('4024.033691 -2609.318848 111.349350'), ang = Angle('0.000 179.610 0.000'), },
	{ mdl = 'models/props_interiors/furniture_vanity01a.mdl',pos = Vector('3830.031738 -2580.869873 111.567810'), ang = Angle('-0.154 -89.901 -0.077'), },
	{ mdl = 'models/props_c17/furniturechair001a.mdl',pos = Vector('3777.422607 -2703.878662 96.333328'), ang = Angle('-0.170 35.739 0.000'), },
	{ mdl = 'models/props_c17/furniturechair001a.mdl',pos = Vector('3813.169434 -2678.741699 96.326668'), ang = Angle('0.093 -151.507 0.242'), },
	{ mdl = 'models/props_interiors/furniture_couch02a.mdl',pos = Vector('3648.373535 -2658.860107 97.879440'), ang = Angle('-0.033 11.074 0.000'), },
	{ mdl = 'models/props_c17/furniturechair001a.mdl',pos = Vector('3807.182617 -2708.736816 96.305199'), ang = Angle('-0.330 125.250 0.000'), },
	{ mdl = 'models/props_c17/furnituredrawer002a.mdl',pos = Vector('3642.439453 -2593.560303 92.965065'), ang = Angle('0.302 -39.260 0.000'), },
	{ mdl = 'models/props_interiors/furniture_couch01a.mdl',pos = Vector('3672.076416 -2814.098389 97.785774'), ang = Angle('0.000 90.000 0.000'), },
	{ mdl = 'models/props_c17/furnituredresser001a.mdl',pos = Vector('3728.365479 -2584.498291 117.272858'), ang = Angle('1.445 -90.000 -0.005'), },
	{ mdl = 'models/props_c17/furnituredrawer003a.mdl',pos = Vector('4033.184082 -2752.447266 98.640221'), ang = Angle('-0.049 -179.978 -0.170'), },
	{ mdl = 'models/props_c17/shelfunit01a.mdl',pos = Vector('4029.507324 -2707.405273 75.165947'), ang = Angle('0.022 89.984 0.016'), },
	{ mdl = 'models/props_wasteland/controlroom_filecabinet002a.mdl',pos = Vector('4024.110840 -2586.046387 111.388824'), ang = Angle('-0.148 179.539 0.000'), },
	{ mdl = 'models/props_combine/breenchair.mdl',pos = Vector('3967.208008 -2600.605225 76.423683'), ang = Angle('-0.121 -138.510 0.374'), },
	{ mdl = 'models/props_c17/furnituretable003a.mdl',pos = Vector('3670.366455 -2769.888916 87.032753'), ang = Angle('0.071 89.934 0.011'), },
	{ mdl = 'models/props_c17/furnituretable001a.mdl',pos = Vector('3795.976563 -2690.749512 94.285042'), ang = Angle('0.066 -147.299 0.192'), },
	{ mdl = 'models/props_c17/furniturecouch001a.mdl',pos = Vector('3671.052002 -2718.065918 92.965546'), ang = Angle('0.038 -89.995 0.000'), },
	{ mdl = 'models/props_interiors/furniture_lamp01a.mdl',pos = Vector('3640.758301 -2621.729492 109.745697'), ang = Angle('0.335 -75.745 0.000'), },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('3932.906738 -2621.725342 76.424904'), ang = Angle('0.016 -142.202 0.000'), },
	{ mdl = 'models/props_c17/furnituredrawer001a.mdl',pos = Vector('3779.316895 -2582.112549 96.510872'), ang = Angle('0.401 -89.978 0.027'), },
}

GAMEMODE.Map:RegisterMapProp( MapProp )