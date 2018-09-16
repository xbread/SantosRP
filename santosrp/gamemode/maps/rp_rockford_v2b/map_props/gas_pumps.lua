--[[
	Name: gas_pumps.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "gas_pumps"
MapProp.m_tblSpawn = {}
MapProp.m_tblPumps = {
	{ pos = Vector("-13909.390625 2813.321777 392.290771"), angs = Angle(0, 0, 0) },
	{ pos = Vector("-13909.390625 2466.693604 392.290771"), angs = Angle(0, 0, 0) },

	{ pos = Vector("276.738922 3783.782959 544.200684"), angs = Angle(0, 180, 0) },
	{ pos = Vector("276.738922 4121.998535 544.200684"), angs = Angle(0, 180, 0) },
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