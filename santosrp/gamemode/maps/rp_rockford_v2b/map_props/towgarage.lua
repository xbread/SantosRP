--[[
	Name: towgarage
	
		 & Rusitc & Devon
]]--

local MapProp = {}
MapProp.ID = "towgarage"
MapProp.m_tblSpawn = {
{ mdl = 'models/props_wasteland/kitchen_counter001d.mdl',pos = Vector('-8853.792969 -761.067078 28.471487'), ang = Angle('-0.055 -0.835 0.000') },
{ mdl = 'models/props_warehouse/toolbox.mdl',pos = Vector('-8849.730469 -856.119995 8.375835'), ang = Angle('0.033 15.200 0.071') },
{ mdl = 'models/props_wasteland/controlroom_storagecloset001a.mdl',pos = Vector('-8871.158203 -659.983826 52.209190'), ang = Angle('-0.005 0.214 0.132') },
{ mdl = 'models/props_wasteland/barricade001a.mdl',pos = Vector('-8251.839844 -995.992310 44.879478'), ang = Angle('-1.648 -174.908 -16.985') },
{ mdl = 'models/props_vehicles/carparts_wheel01a.mdl',pos = Vector('-8848.152344 -746.675598 29.933218'), ang = Angle('24.445 -97.130 -91.989') },
{ mdl = 'models/props_wasteland/controlroom_storagecloset001b.mdl',pos = Vector('-8524.366211 -568.924866 51.721802'), ang = Angle('0.016 -89.967 0.022') },
{ mdl = 'models/gibs/airboat_broken_engine.mdl',pos = Vector('-8849.541992 -790.346558 31.358047'), ang = Angle('0.011 103.491 -12.662') },
{ mdl = 'models/props_wasteland/controlroom_desk001a.mdl',pos = Vector('-8391.554688 -573.076416 24.851494'), ang = Angle('-0.121 -90.000 -0.011') },
{ mdl = 'models/props_warehouse/toolbox.mdl',pos = Vector('-8271.265625 -567.861206 8.438866'), ang = Angle('0.000 -90.000 0.154') },
{ mdl = 'models/props_c17/canister01a.mdl',pos = Vector('-8215.083984 -557.709595 37.701454'), ang = Angle('0.044 -112.495 0.022') },
{ mdl = 'models/props_junk/garbage_plasticbottle001a_fullsheet.mdl',pos = Vector('-8342.040039 -564.286011 51.756565'), ang = Angle('-0.291 -101.766 0.396') },
{ mdl = 'models/props_c17/oildrum001.mdl',pos = Vector('-7981.524902 -571.003845 8.409608'), ang = Angle('-0.011 -101.250 0.368') },
{ mdl = 'models/props_c17/canister02a.mdl',pos = Vector('-8204.716797 -557.169678 37.604702'), ang = Angle('0.000 -90.000 -0.005') },
{ mdl = 'models/props/de_prodigy/tirestack2.mdl',pos = Vector('-8057.145508 -991.474182 8.304259'), ang = Angle('0.000 89.940 0.016') },
{ mdl = 'models/props/de_prodigy/tirestack.mdl',pos = Vector('-7995.542480 -991.501892 8.245381'), ang = Angle('0.000 89.973 0.000') },
{ mdl = 'models/props/de_prodigy/pushcart.mdl',pos = Vector('-8093.368164 -575.285034 24.301018'), ang = Angle('-0.060 179.984 -0.005') },
{ mdl = 'models/props/de_prodigy/tirestack3.mdl',pos = Vector('-8117.766602 -991.349426 8.496820'), ang = Angle('-0.077 89.973 0.000') },
{ mdl = 'models/props_wasteland/barricade001a.mdl',pos = Vector('-8252.040039 -990.730652 28.067799'), ang = Angle('-0.033 -175.084 0.033') },
{ mdl = 'models/props_wasteland/barricade001a.mdl',pos = Vector('-8206.153320 -990.482910 27.240461'), ang = Angle('-0.033 153.402 0.033') },
{ mdl = 'models/props_vehicles/carparts_door01a.mdl',pos = Vector('-8875.452148 -930.069946 26.942696'), ang = Angle('0.791 90.082 -13.502') },
{ mdl = 'models/props_vehicles/carparts_axel01a.mdl',pos = Vector('-8851.467773 -755.451843 55.910053'), ang = Angle('1.110 1.181 -0.231') },
{ mdl = 'models/props_vehicles/carparts_wheel01a.mdl',pos = Vector('-8849.594727 -720.545105 25.352604'), ang = Angle('0.269 -1.104 89.775') },
{ mdl = 'models/props_warehouse/toolbox.mdl',pos = Vector('-8831.141602 -588.652954 8.846910'), ang = Angle('-2.109 -57.365 -0.005') },
}

GAMEMODE.Map:RegisterMapProp( MapProp )