--[[
	Name: atms.lua
	For: SantosRP
	By: Ultra
]]--

local MapProp = {}
MapProp.ID = "atms"
MapProp.m_tblSpawn = {}
MapProp.m_tblAtms = {
	{ pos = Vector(184.856934, -1608.072144, 74.689865), ang = Angle(0, -180, 0) }, --gov building
	{ pos = Vector(-60.002796, 2932.969727, 76.035614), ang = Angle(0, -90, 0) }, --burger king
	{ pos = Vector(-696.995544, 914.047058, 76.309052), ang = Angle(0, 0, 0) }, --skyscraper 1
	{ pos = Vector(1873, 297.0000, 140.312378), ang = Angle(0, -90, 0) }, --bank 1
	{ pos = Vector(1965, 297.0000, 140.312378), ang = Angle(0, -90, 0) }, --bank 2
	{ pos = Vector(7974.062012, 6090.018066, 69.735222), ang = Angle(0, 0, 0) }, --club foods

	--not already in the map
	{ pos = Vector(1736.113770, -2408.893799, 76.426270), ang = Angle(0, 90, 0) }, --car dealer
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
end

GAMEMODE.Map:RegisterMapProp( MapProp )