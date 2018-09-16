--[[
	Name: job_clothing_lockers.lua
	For: santosrp
	By: santosrp
]]--

local MapProp = {}
MapProp.ID = "job_clothing_lockers"
MapProp.m_tblSpawn = {}
MapProp.m_tblLockers = {
	--not already in the map
	{ pos = Vector(-4001.093750, -3585.250000, -13916), ang = Angle(0, 179, 0), id = "JOB_FIREFIGHTER" }, --Fire
	{ pos = Vector(-7817.031250, -5555, -13908.031250), ang = Angle(0, -179, 0), id = "JOB_POLICE" }, --Police
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