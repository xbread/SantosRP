--[[
	Name: bus_stations
	
	By: Rustic7
]]--

local MapProp = {}
MapProp.ID = "bus_stations"
MapProp.m_tblSpawn = {}
MapProp.m_tblProps = {
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('1643.423950 9897.868164 80.486717'), ang = Angle('0.049 178.901 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-8558.270508 5810.749512 292.380981'), ang = Angle('-0.027 -0.005 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-9839.762695 -7989.771973 292.392365'), ang = Angle('0.005 0.000 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-6823.595703 -6925.792480 0.430459'), ang = Angle('-0.038 -90.005 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-5589.704102 -6383.319336 8.384548'), ang = Angle('-0.011 -89.995 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('5379.818359 12424.408203 80.368896'), ang = Angle('-0.033 179.951 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-8222.107422 786.789795 16.358200'), ang = Angle('-0.005 -90.044 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-6450.245117 2144.573486 292.497528'), ang = Angle('0.000 89.676 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-6649.637695 2879.365234 292.455444'), ang = Angle('-0.093 -90.033 0.016') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-10593.048828 4960.639648 292.384674'), ang = Angle('-0.033 -90.022 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-10445.139648 11919.592773 139.657410'), ang = Angle('-0.011 -89.808 3.669') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('9896.103516 12179.301758 80.398193'), ang = Angle('-0.104 -179.995 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-12306.301758 10344.792969 64.331978'), ang = Angle('0.000 179.989 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-13035.392578 9909.721680 53.724060'), ang = Angle('-0.115 0.049 1.609') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-9532.581055 685.704895 8.409821'), ang = Angle('-0.027 1.027 -0.005') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-10185.588867 2879.371826 292.386505'), ang = Angle('-0.016 -89.967 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-10310.271484 4224.385742 292.311462'), ang = Angle('0.000 90.000 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('12181.317383 12959.998047 80.373466'), ang = Angle('0.011 89.791 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-7156.133301 4224.778809 292.409790'), ang = Angle('0.000 89.879 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-4800.043945 7395.367676 292.361816'), ang = Angle('-0.011 -90.000 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-7235.541504 4960.368164 292.409607'), ang = Angle('-0.005 -89.995 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-12584.235352 -12280.708008 292.288269'), ang = Angle('0.000 179.929 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-5423.256836 3332.825439 292.387299'), ang = Angle('0.005 -179.995 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-10917.671875 2142.961426 292.301086'), ang = Angle('-0.060 89.725 -0.005') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-5322.294922 -8226.024414 286.457581'), ang = Angle('-1.747 65.446 1.511') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-8893.423828 -8320.176758 292.386292'), ang = Angle('0.011 -90.104 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-8456.304688 11183.314453 267.215210'), ang = Angle('-0.049 90.000 -3.669') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-13347.642578 -13146.483398 292.382843'), ang = Angle('0.000 0.000 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('-11591.371094 -15679.562500 292.394318'), ang = Angle('-0.104 89.989 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('936.291992 10104.259766 80.234932'), ang = Angle('5.532 0.016 0.428') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('8032.747559 10840.829102 80.364937'), ang = Angle('-0.027 90.159 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('6659.564941 11582.900391 80.339371'), ang = Angle('0.000 -90.000 0.000') },
	{ mdl = 'models/sligwolf/bus_bendi/bus_stop_001.mdl',pos = Vector('7546.411133 12972.299805 80.439026'), ang = Angle('-0.033 89.984 0.005') },
}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblProps ) do
		local ent = ents.Create( "prop_physics" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
		ent:SetModel( propData.mdl )
		ent:SetCollisionGroup( COLLISION_GROUP_NONE )
		ent:SetMoveType( MOVETYPE_NONE )
		ent.IsMapProp = true
		ent:Spawn()
		ent:Activate()

		ent:SetSaveValue( "fademindist", 4096 )
		ent:SetSaveValue( "fademaxdist", 3072 )

		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )