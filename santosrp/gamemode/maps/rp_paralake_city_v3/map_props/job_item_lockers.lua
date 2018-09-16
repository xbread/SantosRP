--[[
	Name: job_item_lockers.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "job_item_lockers"
MapProp.m_tblSpawn = {}
MapProp.m_tblEnts = {
	{ pos = Vector(-6259.682617, 6919.135742, 336.131866), ang = Angle(0, -90, 0), model = "models/props_wasteland/controlroom_storagecloset001a.mdl", job = "JOB_EMS" },
	{ pos = Vector(-6414.846680, 6968.031250, 356.031250), ang = Angle(0, -90, 0), model = "models/props_wasteland/controlroom_storagecloset001a", job = "JOB_EMS" },
	{ pos = Vector(-8657.077148, 10613.462891, 163.964310), ang = Angle(0, -180, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_POLICE" },
	{ pos = Vector(-8895.312500, 10537.062500, 164.000000), ang = Angle(0, 90, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_SWAT" }
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