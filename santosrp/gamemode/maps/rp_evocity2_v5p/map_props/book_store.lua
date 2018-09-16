--[[
	Name: book_store.lua
	For: SantosRP
	By: Ultra
]]--

local MapProp = {}
MapProp.ID = "book_store"
MapProp.m_tblSpawn = {
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('10333.232422 -11969.591797 -1718.525879'), ang = Angle('0.005 -179.995 -0.005') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('10096.117188 -11802.127930 -1719.421631'), ang = Angle('-0.060 -22.720 -0.071') },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('10168.260742 -11805.088867 -1718.835327'), ang = Angle('0.000 -90.082 0.000') },
	{ mdl = 'models/props/cs_office/bookshelf3.mdl',pos = Vector('10347.409180 -11916.840820 -1718.645264'), ang = Angle('0.027 -0.044 0.049') },
	{ mdl = 'models/props/cs_office/bookshelf2.mdl',pos = Vector('10255.749023 -11791.099609 -1718.558105'), ang = Angle('-0.011 -90.016 0.104') },
	{ mdl = 'models/props/cs_office/offpaintingd.mdl',pos = Vector('10190.455078 -11784.395508 -1639.338135'), ang = Angle('0.000 180.000 0.000') },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('10347.498047 -11810.697266 -1718.616089'), ang = Angle('0.000 0.000 0.000') },
	{ mdl = 'models/props/cs_office/offpaintingg.mdl',pos = Vector('10415.812500 -12087.589844 -1638.745361'), ang = Angle('0.000 0.000 0.000') },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('10347.461914 -11863.857422 -1718.664185'), ang = Angle('-0.005 0.011 -0.027') },
	{ mdl = 'models/props_lab/binderredlabel.mdl',pos = Vector('10085.013672 -11956.039063 -1674.189819'), ang = Angle('-0.060 -87.786 0.187') },
	{ mdl = 'models/props_lab/binderblue.mdl',pos = Vector('10091.220703 -11957.741211 -1673.148804'), ang = Angle('-1.566 -42.336 -90.000') },
	{ mdl = 'models/props/cs_office/computer_keyboard.mdl',pos = Vector('10127.741211 -11966.995117 -1681.116699'), ang = Angle('-0.500 -87.462 -0.016') },
	{ mdl = 'models/props/cs_office/bookshelf3.mdl',pos = Vector('10443.890625 -11916.548828 -1718.627930'), ang = Angle('-0.016 -179.962 -0.016') },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('10090.081055 -12047.549805 -1718.652832'), ang = Angle('-0.044 0.060 -0.011') },
	{ mdl = 'models/props/cs_office/bookshelf3.mdl',pos = Vector('10123.224609 -12080.901367 -1718.704834'), ang = Angle('-0.005 90.033 0.000') },
	{ mdl = 'models/props_lab/bindergreenlabel.mdl',pos = Vector('10087.517578 -11954.298828 -1670.206055'), ang = Angle('-4.246 -74.756 -88.303') },
	{ mdl = 'models/props/cs_office/computer_monitor.mdl',pos = Vector('10115.767578 -11952.242188 -1674.422974'), ang = Angle('-0.291 -67.571 0.044') },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('10443.954102 -11863.585938 -1718.634155'), ang = Angle('-0.022 -179.995 -0.005') },
	{ mdl = 'models/props/cs_office/offpaintingf.mdl',pos = Vector('10292.130859 -12087.558594 -1642.420410'), ang = Angle('0.000 0.000 0.000') },
	{ mdl = 'models/props/cs_militia/bar01.mdl',pos = Vector('10151.382813 -11986.616211 -1718.811523'), ang = Angle('0.000 0.000 0.000') },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('10428.451172 -12072.267578 -1719.482544'), ang = Angle('0.000 135.000 0.000') },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('10347.232422 -11969.591797 -1718.525879'), ang = Angle('0.005 0.000 -0.005') },
	{ mdl = 'models/props/cs_office/bookshelf2.mdl',pos = Vector('10443.859375 -11810.620117 -1718.501099'), ang = Angle('0.000 179.995 0.000') },
	{ mdl = 'models/props/cs_office/bookshelf3.mdl',pos = Vector('10331.507813 -11916.548828 -1718.627930'), ang = Angle('-0.016 -179.962 -0.016') },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('10333.305664 -11863.585938 -1718.634155'), ang = Angle('-0.022 -179.995 -0.005') },
	{ mdl = 'models/props/cs_office/offpaintinge.mdl',pos = Vector('10134.078125 -11784.978516 -1637.743652'), ang = Angle('0.000 180.000 0.000') },
	{ mdl = 'models/props/cs_office/bookshelf2.mdl',pos = Vector('10443.914063 -12022.626953 -1718.543457'), ang = Angle('0.044 -179.984 -0.055') },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('10443.855469 -11969.591797 -1718.525879'), ang = Angle('0.005 -179.995 -0.005') },
	{ mdl = 'models/props/cs_office/bookshelf2.mdl',pos = Vector('10332.828125 -11810.620117 -1718.501099'), ang = Angle('0.000 179.995 0.000') },
}

GAMEMODE.Map:RegisterMapProp( MapProp )