--[[
	Name: job_item_lockers.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "job_item_lockers"
MapProp.m_tblSpawn = {}
MapProp.m_tblEnts = {
	{ pos = Vector(-2297.031250, 518.906250, 111.968750), ang = Angle(0, 180, 0), model = "models/props_wasteland/controlroom_storagecloset001a.mdl", job = "JOB_EMS" },
	{ pos = Vector(-368.250000, -1829.968750, -392.093750), ang = Angle(0, -90, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_POLICE" },
	{ pos = Vector(-193.937500, -1830.062500, -392.000000), ang = Angle(0, 90, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_SWAT" }
}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblEnts ) do
		local ent = ents.Create( "ent_job_item_locker" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
		ent:SetCollisionGroup( COLLISION_GROUP_NONE )
		ent:SetMoveType( MOVETYPE_NONE )
		ent.IsMapProp = true
		ent.MapPropID = id
		ent:Spawn()
		ent:Activate()
		ent:SetModel( propData.model )
		ent:SetJobID( _G[propData.job] )

		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )