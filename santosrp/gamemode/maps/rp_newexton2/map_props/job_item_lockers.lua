--[[
	Name: job_item_lockers.lua
	For: santosrp
	By: santosrp
]]--

local MapProp = {}
MapProp.ID = "job_item_lockers"
MapProp.m_tblSpawn = {}
MapProp.m_tblEnts = {
	{ pos = Vector(320.562500, -5521.031250, -13852), ang = Angle(0, -89, 0), model = "models/props_c17/Lockers001a.mdl", job = "JOB_EMS" },
	{ pos = Vector(-7817.062500, -5432.875000, -13908), ang = Angle(0, -179, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_POLICE" },
	{ pos = Vector(32131, 321312, -123123), ang = Angle(14, -89, 0), model = "models/props_c17/lockers001a.mdl", job = "JOB_SSERVICE" },
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