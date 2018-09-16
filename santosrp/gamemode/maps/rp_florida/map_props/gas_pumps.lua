--[[
	Name: gas_pumps.lua
	For: santosrp
	By: santosrp
]]--

local MapProp = {}
MapProp.ID = "gas_pumps"
MapProp.m_tblSpawn = {}
MapProp.m_tblPumps = {
	{ pos = Vector(220, -1067, 144), angs = Angle(0, 270, 0) },
	{ pos = Vector(292, -1067, 144), angs = Angle(0, 270, 0) },
	{ pos = Vector(292, -651, 144), angs = Angle(0, 270, 0) },
	{ pos = Vector(220, -651, 144), angs = Angle(0, 270, 0) },
	{ pos = Vector(220, -235, 144), angs = Angle(0, 270, 0) },
	{ pos = Vector(292, -235, 144), angs = Angle(0, 270, 0) },	
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