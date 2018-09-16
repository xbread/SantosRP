--[[
	Name: firestation.lua
	For: SantosRP
	By: Ultra
]]--

local MapProp = {}
MapProp.ID = "firestation"
MapProp.m_tblSpawn = {
	{ mdl = 'models/props/cs_office/offinspc.mdl',pos = Vector('4864.771484 13699.506836 154.706558'), ang = Angle('0.000 179.995 0.000') },
	{ mdl = 'models/props/cs_office/computer_caseb.mdl',pos = Vector('4667.866699 13599.600586 68.339020'), ang = Angle('0.000 -9.113 0.192') },
	{ mdl = 'models/props/cs_office/computer_caseb.mdl',pos = Vector('4812.926758 13600.033203 68.404213'), ang = Angle('-0.005 -2.384 0.330') },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('4982.842285 13664.550781 68.438156'), ang = Angle('0.033 -127.991 0.275') },
	{ mdl = 'models/props/cs_office/offcorkboarda.mdl',pos = Vector('4531.296387 13699.583008 137.485733'), ang = Angle('0.000 179.995 0.000') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('4515.050293 13302.729492 68.405785'), ang = Angle('0.022 -89.874 0.044') },
	{ mdl = 'models/props/cs_office/computer_caseb.mdl',pos = Vector('4561.471680 13153.296875 68.438721'), ang = Angle('-0.011 -89.632 -0.225') },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('4532.225098 13158.538086 99.735596'), ang = Angle('0.225 -110.314 0.055') },
	{ mdl = 'models/props/cs_office/bookshelf3.mdl',pos = Vector('4470.042480 13673.269531 68.510643'), ang = Angle('-0.038 -0.066 -0.011') },
	{ mdl = 'models/props/cs_office/trash_can.mdl',pos = Vector('4577.612793 13346.507813 68.477226'), ang = Angle('0.577 -2.181 -0.923') },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('4655.382324 13653.549805 68.416290'), ang = Angle('0.044 179.907 0.038') },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('4470.031738 13567.215820 68.335449'), ang = Angle('-0.044 0.005 0.093') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('4475.198730 13443.444336 67.638474'), ang = Angle('0.390 -3.148 -0.797') },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('4838.384277 13649.581055 68.440376'), ang = Angle('-0.016 -168.613 -0.143') },
	{ mdl = 'models/props/cs_office/radio.mdl',pos = Vector('4927.924805 13688.404297 99.821739'), ang = Angle('-0.978 -52.493 0.000') },
	{ mdl = 'models/props_lab/frame002a.mdl',pos = Vector('4476.902344 13167.893555 99.793571'), ang = Angle('-0.571 -61.337 0.203') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('4739.491211 13332.391602 133.101990'), ang = Angle('89.995 -90.000 180.000') },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('4805.520996 13652.322266 99.840012'), ang = Angle('0.450 -0.099 0.027') },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('4803.239258 13653.556641 68.390457'), ang = Angle('0.000 179.995 0.000') },
	{ mdl = 'models/props/cs_office/sofa_chair.mdl',pos = Vector('4494.339355 13489.392578 68.493477'), ang = Angle('0.165 -44.456 0.137') },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('4509.425781 13161.051758 68.370834'), ang = Angle('0.066 90.341 0.033') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('4816.104980 13691.916016 99.907097'), ang = Angle('0.000 -12.623 0.000') },
	{ mdl = 'models/props/cs_office/bookshelf2.mdl',pos = Vector('4470.135254 13620.242188 68.517097'), ang = Angle('-0.060 -0.132 -0.016') },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('4730.104492 13309.849609 68.395119'), ang = Angle('0.000 -89.984 0.033') },
	{ mdl = 'models/props/cs_office/table_coffee.mdl',pos = Vector('4554.123047 13429.308594 68.472847'), ang = Angle('0.104 49.026 0.000') },
	{ mdl = 'models/props/cs_office/shelves_metal3.mdl',pos = Vector('5006.524902 13479.172852 68.420662'), ang = Angle('-0.049 -0.016 0.000') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('4668.238281 13692.178711 99.817070'), ang = Angle('0.220 -4.697 0.352') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('4949.772949 13691.571289 99.838287'), ang = Angle('0.000 -5.850 -0.346') },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('4658.764160 13653.535156 99.932228'), ang = Angle('-0.467 0.022 -0.038') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('4738.177734 13099.961914 67.774841'), ang = Angle('-0.835 138.851 0.214') },
	{ mdl = 'models/props/cs_office/computer_caseb.mdl',pos = Vector('4948.717773 13599.667969 68.369064'), ang = Angle('0.121 1.873 -0.363') },
	{ mdl = 'models/props/cs_office/offpaintinga.mdl',pos = Vector('4463.400879 13474.148438 163.444504'), ang = Angle('0.016 -89.989 0.000') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('4513.133301 13380.680664 68.429504'), ang = Angle('0.022 48.472 0.005') },
	{ mdl = 'models/props/cs_office/offinspf.mdl',pos = Vector('4738.920410 13699.582031 154.666534'), ang = Angle('0.000 -179.995 0.000') },
	{ mdl = 'models/props/cs_office/phone.mdl',pos = Vector('4472.465332 13144.636719 99.836601'), ang = Angle('-0.385 -58.700 0.346') },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('4491.223633 13105.387695 68.385582'), ang = Angle('-0.060 50.521 -0.033') },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('4702.523438 13636.966797 68.360909'), ang = Angle('0.000 145.025 0.044') },
	{ mdl = 'models/props/cs_office/file_box.mdl',pos = Vector('4654.428223 13623.030273 99.771736'), ang = Angle('-0.022 -9.338 -0.308') },
	{ mdl = 'models/props/cs_office/offcorkboarda.mdl',pos = Vector('4575.462402 13699.571289 137.641449'), ang = Angle('0.000 180.000 0.000') },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('4935.401855 13653.660156 68.338104'), ang = Angle('0.000 -179.962 -0.005') },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('4937.043457 13652.586914 99.850441'), ang = Angle('-0.527 -0.016 0.005') },
}

GAMEMODE.Map:RegisterMapProp( MapProp )