--[[
	Name: map_train.lua
	
		
]]--

if true then return end
if CLIENT then return end

local stops = {
	{
		pos = Vector( 12279.451172, 7430.330078, 392.031250 ),
		spawns = {
			Vector( 12282.981445, 7309.088867, 399.031250 ),
			Vector( 12327.520508, 7314.607910, 399.031250 ),
			Vector( 12367.274414, 7278.159668, 399.031250 ),
			Vector( 12414.791992, 7312.104492, 399.031250 ),
			Vector( 12404.373047, 7278.121582, 399.031250 ),
			Vector( 12203.083984, 7284.069336, 399.031250 ),
			Vector( 12167.410156, 7328.417480, 399.031250 ),
			Vector( 12151.473633, 7277.078613, 399.031250 ),
			Vector( 12138.084961, 7330.957520, 399.031250 ),
		}
	},
	{
		pos = Vector( -5538.528320, 3308.584229, 656.031250 ),
		spawns = {
			Vector( -5538.528320, 3308.584229, 656.031250 ),
			Vector( -5442.108398, 3187.166504, 664.031250 ),
			Vector( -5380.911621, 3242.598633, 664.031250 ),
			Vector( -5429.504883, 3245.124512, 664.031250 ),
			Vector( -5409.329102, 3273.158203, 664.031250 ),
			Vector( -5383.536621, 3302.807617, 664.031250 ),
			Vector( -5426.561035, 3362.220215, 664.031250 ),
			Vector( -5401.589844, 3382.452393, 664.031250 ),
			Vector( -5439.534668, 3447.569824, 664.031250 ),
		}
	},
	{
		pos = Vector( -13479.913086, -7285.834473, 560.031250 ),
		spawns = {
			Vector( -13638.456055, -7413.760742, 568.031250 ),
			Vector( -13595.758789, -7413.867676, 568.031250 ),
			Vector( -13607.132813, -7349.273926, 568.031250 ),
			Vector( -13636.177734, -7306.140137, 568.031250 ),
			Vector( -13592.278320, -7284.170410, 568.031250 ),
			Vector( -13640.996094, -7256.720215, 568.031250 ),
			Vector( -13598.691406, -7221.742676, 568.031250 ),
			Vector( -13644.542969, -7172.869141, 568.031250 ),
			Vector( -13597.893555, -7147.773926, 568.031250 ),
		}
	},
}

local seatPos = {
	{ Vector( 165.798431, -44, 19.531385 ), Angle( 0, 0, 0 ) },
	{ Vector( 137.323044, -44, 19.531385 ), Angle( 0, 0, 0 ) },
	{ Vector( 108.823143, -44, 19.531385 ), Angle( 0, 0, 0 ) },
	{ Vector( 81.032211, -44, 19.531385 ), Angle( 0, 0, 0 ) },
	{ Vector( -81.053185, -44, 19.531385 ), Angle( 0, 0, 0 ) },
	{ Vector( -109.533569, -44, 19.531385 ), Angle( 0, 0, 0 ) },
	{ Vector( -137.283478, -44, 19.531385 ), Angle( 0, 0, 0 ) },
	{ Vector( -165.033401, -44, 19.531385 ), Angle( 0, 0, 0 ) },

	{ Vector( 165.798431, 45, 19.531385 ), Angle( 0, 180, 0 ) },
	{ Vector( 137.323044, 45, 19.531385 ), Angle( 0, 180, 0 ) },
	{ Vector( 108.823143, 45, 19.531385 ), Angle( 0, 180, 0 ) },
	{ Vector( 81.032211, 45, 19.531385 ), Angle( 0, 180, 0 ) },
	{ Vector( -81.053185, 45, 19.531385 ), Angle( 0, 180, 0 ) },
	{ Vector( -109.533569, 45, 19.531385 ), Angle( 0, 180, 0 ) },
	{ Vector( -137.283478, 45, 19.531385 ), Angle( 0, 180, 0 ) },
	{ Vector( -165.033401, 45, 19.531385 ), Angle( 0, 180, 0 ) },
}
local parentEntName = "Monorail_Train 1"
local seats = {}
local trainEnt

hook.Add( "InitPostEntity", "SetupMapTrain", function()
	local found
	for k, v in pairs( ents.GetAll() ) do
		if v:GetName() == parentEntName then
			found = v
			break
		end
	end

	if not IsValid( found ) then return end
	trainEnt = found

	for k, v in pairs( seatPos ) do
		local seat = ents.Create( "prop_vehicle_prisoner_pod" )
		seat:SetModel( "models/nova/airboat_seat.mdl" )
		seat:SetPos( trainEnt:LocalToWorld(v[1]) )
		seat:SetAngles( trainEnt:LocalToWorldAngles(v[2]) )
		seat:SetKeyValue( "vehiclescript", "scripts/vehicles/prisoner_pod.txt" )
		seat:SetKeyValue( "limitview", "0" )
		seat:Spawn()
		seat:Activate()
		seat:SetParent( trainEnt )
		seats[#seats +1] = seat
	end
end )

hook.Add( "PlayerUse", "PlayerUseMapTrain", function( pPlayer, eEnt )
	if CurTime() < (pPlayer.m_intLastTrainUse or 0) then return end
	pPlayer.m_intLastTrainUse = CurTime() +5

	if eEnt == trainEnt and not pPlayer:InVehicle() then
		if eEnt:GetVelocity():Length() <= 0.1 then
			for k, v in pairs( seats ) do
				if not IsValid( v:GetDriver() ) then
					pPlayer:EnterVehicle( v )
					pPlayer:EnterVehicle( v )
					pPlayer.m_intEnterTrainTime = CurTime() +1
					print "ENTER"
				end
			end
		end
	end
end )

hook.Add( "PlayerLeaveVehicle", "PlayerExitMapTrain", function( pPlayer, eEnt )
	if eEnt:GetParent() == trainEnt and not pPlayer:InVehicle() then
		if CurTime() < (pPlayer.m_intEnterTrainTime or 0) then return end
		print "exit car"
		local stop
		local cur = math.huge
		for k, v in pairs( stops ) do
			if v.pos < cur then
				stop = v
			end
		end

		if stop then
			local spawn = GAMEMODE.Util:FindSpawnPoint( v.spawns, 34 )
			if not spawn then
				spawn, _ = table.Random( v.spawns )
			end

			pPlayer:SetPos( spawn )
		end
	end
end )

hook.Add( "CanExitVehicle", "PlayerExitMapTrain", function( eEnt, pPlayer )
	if eEnt == trainEnt then
		if CurTime() < (pPlayer.m_intEnterTrainTime or 0) then return end
		return eEnt:GetVelocity():Length() <= 0.1
	end
end )