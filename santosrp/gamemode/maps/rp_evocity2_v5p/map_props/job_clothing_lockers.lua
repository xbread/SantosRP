--[[
	Name: job_clothing_lockers.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "job_clothing_lockers"
MapProp.m_tblSpawn = {}
MapProp.m_tblLockers = {
	--not already in the map
	{ pos = Vector(4756.906250, 13199.843750, 103.968750), ang = Angle(0, 180, 0), id = "JOB_FIREFIGHTER" }, --Fire
	{ pos = Vector(-278.500000, -1830.062500, -392.000000), ang = Angle(0, -90, 0), id = "JOB_POLICE" }, --Police
	{ pos = Vector(-999.785461, -9610.014648, -3128.307373), ang = Angle(33.973003, -1.468040, 0), id = "JOB_LEAF" }, --Police
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