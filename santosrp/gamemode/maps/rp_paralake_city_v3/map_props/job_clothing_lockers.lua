--[[
	Name: job_clothing_lockers.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "job_clothing_lockers"
MapProp.m_tblSpawn = {}
MapProp.m_tblLockers = {
	--not already in the map
	{ pos = Vector(-13266.949219, 12951.020508, 99.910812), ang = Angle(0, -90, 0), id = "JOB_FIREFIGHTER" }, --Fire
	{ pos = Vector(-8657.054688, 10557.494141, 163.841858), ang = Angle(0, -180, 0), id = "JOB_POLICE" }, --Police
}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblLockers ) do
		local ent = ents.Create( "ent_job_clothing_locker" )
		ent:SetJobID( _G[propData.id] )
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
end

GAMEMODE.Map:RegisterMapProp( MapProp )