--[[
	Name: job_item_lockers.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "job_item_lockers"
MapProp.m_tblSpawn = {}
MapProp.m_tblEnts = {
	{ pos = Vector(322.242920, -5521.086914, 99.999054), ang = Angle(0, -90, 0), model = "models/props_c17/Lockers001a.mdl", job = "JOB_EMS" },
	{ pos = Vector(-7453.718262, -4632.000977, 45), ang = Angle(0, -90, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_POLICE" },
	{ pos = Vector(-7121.062500, -4706.093750, 43.968750), ang = Angle(0, -180, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_SWAT" },
	{ pos = Vector(-4401.562500, -5846.875000, 755.968750), ang = Angle(0, 90, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_SSERVICE" },
	{ pos = Vector(-3912.187500, -6025.031250, 43.937500), ang = Angle(0, -90, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_ROADWORKER" },
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