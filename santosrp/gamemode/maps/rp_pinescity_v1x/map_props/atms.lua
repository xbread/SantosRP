--[[
	Name: atms.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "atms"
MapProp.m_tblSpawn = {}
MapProp.m_tblAtms = {
	--not already in the map
	{ pos = Vector(-11247.223633, 10560.978516, 64.547211), ang = Angle(0, -180, 0) }, --gas station 1
	{ pos = Vector(-6707.320801, 895.032715, 292.359436), ang = Angle(0, 90, 0) }, --gas station 2
	{ pos = Vector(-8570.160156, -7071.170410, 292.548340), ang = Angle(0, -90, 0) }, --gas station 3

	{ pos = Vector(-4991.748535, 4383.073242, 288.273590), ang = Angle(0, 90, 0) }, --bank 1
	{ pos = Vector(-5089.097168, 4383.164551, 288.308563), ang = Angle(0, 90, 0) }, --bank 2
	{ pos = Vector(-5177.820313, 4383.110840, 288.428131), ang = Angle(0, 90, 0) }, --bank 3

	{ pos = Vector(-11227.102539, 5691.736816, 192.397003), ang = Angle(0, 180, 0) }, --restaurant 1
	{ pos = Vector(-11733.568359, -13839.225586, 288.525055), ang = Angle(0, -90, 0) }, --restaurant 2
	{ pos = Vector(3871.145264, 9537.702148, 80.440491), ang = Angle(0, 0, 0) }, --restaurant 3

	{ pos = Vector(-8735.236328, -10966.860352, 464.549896), ang = Angle(0, -180, 0) }, --car dealer
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