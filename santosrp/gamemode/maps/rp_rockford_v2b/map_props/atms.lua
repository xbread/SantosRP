--[[
	Name: atms.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "atms"
MapProp.m_tblSpawn = {}
MapProp.m_tblAtms = {
	--not already in the map
	--{ pos = Vector(-8570.160156, -7071.170410, 292.548340), ang = Angle(0, -90, 0) }, --gas station 3
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