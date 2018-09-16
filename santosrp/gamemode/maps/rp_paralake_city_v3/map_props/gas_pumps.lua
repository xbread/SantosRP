--[[
	Name: gas_pumps.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "gas_pumps"
MapProp.m_tblSpawn = {}
MapProp.m_tblPumps = {
	--Gas station 1
	{ pos = Vector(-12044.913086, 10898.847656, 68.184036), angs = Angle(0, 0, 0) },
	{ pos = Vector(-12044.913086, 10700.800781, 68.184036), angs = Angle(0, 0, 0) },

	--Gas station 2
	{ pos = Vector(-6709.756348, 1810.960571, 296.244263), angs = Angle(0, 90, 0) },
	{ pos = Vector(-6513.330566, 1810.960571, 296.244263), angs = Angle(0, 90, 0) },

	--Gas station 3
	{ pos = Vector(-8748.852539, -7964.764648, 296.307251), angs = Angle(0, 90, 0) },
	{ pos = Vector(-8945.123047, -7964.764648, 296.307251), angs = Angle(0, 90, 0) },
}

function MapProp:CustomSpawn()
	for k, v in pairs( self.m_tblPumps ) do
		local ent = ents.Create( "ent_fuelpump" )
		ent:SetPos( v.pos )
		ent:SetAngles( v.angs )
		ent.IsMapProp = true
		ent:Spawn()
		ent:Activate()

		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )