--[[
	Name: atms.lua
	For: santosrp
	By: santosrp
]]--

local MapProp = {}
MapProp.ID = "atms"
MapProp.m_tblSpawn = {}
MapProp.m_tblAtms = {
	--not already in the map
	--{ pos = Vector(-671, -6547, 155), ang = Angle(0, 0, 0) }, --bank
	{ pos = Vector(172.531174, -4295.064453, 264.504364), ang = Angle(0.075, -90.048, -0.001) },
	{ pos = Vector(1008.764343, -426.728394, 136.548218), ang = Angle(-0.087, 179.994, 0.075) },
	{ pos = Vector(-1712.939331, -4639.930664, 136.569153), ang = Angle(0.091, -0.101, -0.002) },
	{ pos = Vector(-2480.816406, -6550.648926, -135.540009), ang = Angle(-0.050, 0.068, 0.100) },	
	{ pos = Vector(172.531174, -4295.064453, 264.504364), ang = Angle(0.075, -90.048, -0.001) },
	{ pos = Vector(1008.764343, -426.728394, 136.548218), ang = Angle(-0.087, 179.994, 0.075) },
	{ pos = Vector(-1712.939331, -4639.930664, 136.569153), ang = Angle(0.091, -0.101, -0.002) },
	{ pos = Vector(-2480.816406, -6550.648926, -135.540009), ang = Angle(-0.050, 0.068, 0.100) },
	{ pos = Vector(3047.335449, 744.814575, 136.412018), ang = Angle(0.043, -89.824, 0.072) },
	{ pos = Vector(5779.201172, 2767.162842, 136.438370), ang = Angle(0.044, 90.057, -0.099) },
	{ pos = Vector(4239.720703, -3018.861816, 136.435379), ang = Angle(0.129, -0.021, 0.045) },
	{ pos = Vector(4976.819336, -5395.273926, 136.563980), ang = Angle(-0.102, 179.983, -0.027) },
	{ pos = Vector(-470.944519, -8103.030273, 168.411835), ang = Angle(0.025, -89.962, -0.074) },
	{ pos = Vector(-1751.139526, -8416.869141, 136.431870), ang = Angle(0.197, -179.853, 0.143) },
	{ pos = Vector(-5615.924805, -3984.924561, 136.506210), ang = Angle(0.028, 90.092, 0.188) },
	{ pos = Vector(-4887.145996, -5442.862305, 136.478424), ang = Angle(0.002, -179.999, 0.275) },
	{ pos = Vector(-4887.201172, -6853.453125, 136.469254), ang = Angle(-0.034, -179.773, -0.134) },
	{ pos = Vector(-1843.052734, -3240.813965, 136.499634), ang = Angle(-0.109, 89.801, 0.274) },
	{ pos = Vector(-672.848267, -6530.011230, 136.435135), ang = Angle(0.053, 0.026, 0.095) },
}


function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblAtms ) do
		local ent = ents.Create( "ent_atm" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
		ent.IsMapProp = true
		ent:Spawn()
		ent:Activate()

		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end

	for k, v in pairs( ents.GetAll() ) do
		if v:GetModel() == "models/props_unique/atm01.mdl" then
			local ent = ents.Create( "ent_atm" )
			ent:SetPos( v:GetPos() )
			ent:SetAngles( v:GetAngles() )
			ent.IsMapProp = true
			ent:Spawn()
			ent:Activate()
			v:Remove()

			local phys = ent:GetPhysicsObject()
			if IsValid( phys ) then
				phys:EnableMotion( false )
			end
		end
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )