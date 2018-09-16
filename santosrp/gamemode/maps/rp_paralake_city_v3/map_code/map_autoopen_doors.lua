--[[
	Name: map_autoopen_doors.lua
	
		 
]]--

if CLIENT then return end
local lastTick = 0
g_AutoOpenDoors = g_AutoOpenDoors or {}
local classNames = {
	{ 
		Class = "prop_door_rotating",
		Pos = Vector("-13125.000000 12753.000000 119.209999"),
		Min = Vector("-13184.552734 12672.155273 64.031250"),
		Max = Vector("-13088.407227 12830.876953 207.968750"),
		PlayerOnly = true,
		Job = "JOB_FIREFIGHTER",
	},
	{ 
		Class = "prop_door_rotating",
		Pos = Vector("-13487.000000 12976.900391 119.209999"),
		Min = Vector("-13499.538086 12911.112305 64.031250"),
		Max = Vector("-13442.356445 13063.122070 207.968750"),
		PlayerOnly = true,
		Job = "JOB_FIREFIGHTER",
	},

	{ 
		Class = "prop_door_rotating",
		Pos = Vector("-9115.000000 10639.000000 343.000000"),
		Min = Vector("-9134.801758 10569.823242 288.031250"),
		Max = Vector("-9044.224609 10745.205078 421.256653"),
		PlayerOnly = true,
		Job = "JOB_POLICE",
	},
	{ 
		Class = "func_door_rotating",
		Pos = Vector("-8656.000000 9679.990234 314.000000"),
		Min = Vector("-9074.942383 9377.503906 207.089355"),
		Max = Vector("-8268.656250 9689.804688 512"),
		CarOnly = true,
		Job = "JOB_POLICE",
	},
	{ 
		Class = "func_door_rotating",
		Pos = Vector("-8656.000000 9392.000000 314.000000"),
		Min = Vector("-9074.942383 9377.503906 207.089355"),
		Max = Vector("-8268.656250 9689.804688 512"),
		CarOnly = true,
		Job = "JOB_POLICE",
	},
}

g_DoorBBoxes = g_DoorBBoxes or {
	["FD_garagedoor 1"] = { Min = Vector("-12930 12490 50"), Max = Vector("-12700 13057 350"), CarOnly = true, Job = "JOB_FIREFIGHTER" },
	["FD_garagedoor 2"] = { Min = Vector("-12547 12490 50"), Max = Vector("-12285 13057 350"), CarOnly = true, Job = "JOB_FIREFIGHTER" },
	["FD_garagedoor 3"] = { Min = Vector("-12162 12490 50"), Max = Vector("-11900 13057 350"), CarOnly = true, Job = "JOB_FIREFIGHTER" },
}

hook.Add( "InitPostEntity", "GetAutoOpenDoors", function()
	for k, v in pairs( ents.GetAll() ) do
		if IsValid( v ) and g_DoorBBoxes[v:GetName()] then
			g_AutoOpenDoors[v:GetName()] = v
		end
	end

	for k, v in pairs( classNames ) do
		local found = ents.FindInSphere( v.Pos, 24 )

		for k2, v2 in pairs( found ) do
			if v2:GetClass() == v.Class then
				g_AutoOpenDoors[v2:EntIndex()] = v2
				g_DoorBBoxes[v2:EntIndex()] = v
				break
			end
		end
	end
end )

hook.Add( "Tick", "AutoOpenDoors", function()
	if lastTick > CurTime() then return end
	lastTick = CurTime() +1.5

	for k, v in pairs( g_DoorBBoxes ) do
		if not IsValid( g_AutoOpenDoors[k] ) then continue end
		
		local breakContinue
		for _, ent in pairs( ents.FindInBox(v.Min, v.Max) ) do
			if not IsValid( ent ) then continue end
			
			if not v.PlayerOnly and ent:IsVehicle() and ent.UID then
				if not IsValid( ent:GetDriver() ) then continue end
				if GAMEMODE.Jobs:GetPlayerJobEnum( ent:GetDriver() ) ~= v.Job then continue end

				if not g_AutoOpenDoors[k].m_bOpen then
					g_AutoOpenDoors[k]:Fire( "Open" )
					g_AutoOpenDoors[k].m_bOpen = true
				end

				breakContinue = true
				break
			elseif ent:IsPlayer() and GAMEMODE.Jobs:GetPlayerJobEnum( ent ) == v.Job then
				if v.CarOnly then continue end
				
				if not g_AutoOpenDoors[k].m_bOpen then
					g_AutoOpenDoors[k]:Fire( "Open" )
					g_AutoOpenDoors[k].m_bOpen = true
				end

				breakContinue = true
				break
			end
		end

		if breakContinue then continue end
		g_AutoOpenDoors[k]:Fire( "Close" )
		g_AutoOpenDoors[k].m_bOpen = false
	end
end )