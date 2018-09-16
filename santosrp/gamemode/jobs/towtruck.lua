--[[
	Name: towtruck.lua
	For: TalosLife
	By: TalosLife
]]--

GM.ChatRadio:RegisterChannel( 7, "Tow Services", false )

local Job = {}
Job.ID = 6
Job.Enum = "JOB_TOW"
Job.TeamColor = Color( 255, 100, 160, 255 )
Job.Name = "Tow Truck Driver"
Job.Pay = {
	{ PlayTime = 0, Pay = 35 },
	{ PlayTime = 4 *(60 *60), Pay = 55 },
	{ PlayTime = 12 *(60 *60), Pay = 65 },
	{ PlayTime = 24 *(60 *60), Pay = 90 },
}
Job.PlayerCap = GM.Config.Job_Tow_PlayerCap or { Min = 2, MinStart = 8, Max = 6, MaxEnd = 60 }
Job.HasChatRadio = true
Job.DefaultChatRadioChannel = 7
Job.ChannelKeys = {}
Job.ParkingLotPos = GM.Config.TowParkingZone
Job.TruckSpawns = GM.Config.TowCarSpawns
Job.TruckID = "tow_truck"
Job.FlatbedID = "tow_flatbed"

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
	local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
	if curCar and curCar.Job and curCar.Job == JOB_TOW then
		curCar:Remove()
	end
end

if SERVER then
	function Job:PlayerLoadout( pPlayer )
		pPlayer:Give( "weapon_vehicle_welder" )
	end

	function Job:OnPlayerSpawnFlatbed( pPlayer, entCar )
		if not IsValid( pPlayer ) or not IsValid( entCar ) then return end

		local vecOffset = Vector( 0.5, -2.197299, 1 )
		local angOffset = Angle( 0, 0, 0 )

		local bed = ents.Create( "ent_towtruck_bed" )
		bed:SetPos( entCar:LocalToWorld(vecOffset) )
		bed:SetAngles( entCar:LocalToWorldAngles(angOffset) )
		bed:Spawn()
		bed:Activate()
		bed:SetTruck( entCar, vecOffset, angOffset )
		bed:GetPhysicsObject():Wake()
		bed.AdminPhysGun = true

		local btnLock = ents.Create( "ent_button" )
		btnLock:SetModel( "models/maxofs2d/button_05.mdl" )
		btnLock:SetPos( entCar:LocalToWorld(Vector(-43.819336, -32.144527, 47.464691)) )
		btnLock:SetAngles( entCar:LocalToWorldAngles(Angle(0, -90, 90)) )
		btnLock:Spawn()
		btnLock:Activate()
		btnLock:SetParent( entCar )
		btnLock:SetModelScale( 0.5 )
		btnLock.BlockPhysGun = true
		btnLock:SetCanUseCallback( function( entBtn, pPlayer )
			if IsValid( entCar ) and IsValid( entCar:GetDriver() ) then return end
			return GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_TOW
		end )
		bed:SetBedLockButton( btnLock )

		local btnBack = ents.Create( "ent_button" )
		btnBack:SetModel( "models/maxofs2d/button_06.mdl" )
		btnBack:SetIsToggle( false )
		btnBack:SetPos( entCar:LocalToWorld(Vector(-44.391602, -40.890621, 47.378601)) )
		btnBack:SetAngles( entCar:LocalToWorldAngles(Angle(-90, 0, 0)) )
		btnBack:Spawn()
		btnBack:Activate()
		btnBack:SetParent( entCar )
		btnBack:SetModelScale( 0.25 )
		btnBack.BlockPhysGun = true
		btnBack:SetCanUseCallback( function( entBtn, pPlayer )
			if IsValid( entCar ) and IsValid( entCar:GetDriver() ) then return end
			return GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_TOW
		end )
		bed:SetTranslateBackButton( btnBack )

		local btnForward = ents.Create( "ent_button" )
		btnForward:SetModel( "models/maxofs2d/button_06.mdl" )
		btnForward:SetIsToggle( false )
		btnForward:SetPos( entCar:LocalToWorld(Vector(-44.391602, -48.897945, 47.378601)) )
		btnForward:SetAngles( entCar:LocalToWorldAngles(Angle(-90, 0, 0)) )
		btnForward:Spawn()
		btnForward:Activate()
		btnForward:SetParent( entCar )
		btnForward:SetModelScale( 0.25 )
		btnForward.BlockPhysGun = true
		btnForward:SetCanUseCallback( function( entBtn, pPlayer )
			if IsValid( entCar ) and IsValid( entCar:GetDriver() ) then return end
			return GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_TOW
		end )
		bed:SetTranslateForwardButton( btnForward )

		local btnWBack = ents.Create( "ent_button" )
		btnWBack:SetModel( "models/maxofs2d/button_06.mdl" )
		btnWBack:SetIsToggle( false )
		btnWBack:SetPos( entCar:LocalToWorld(Vector(-44.391602, -68.314453, 47.378601)) )
		btnWBack:SetAngles( entCar:LocalToWorldAngles(Angle(-90, 0, 0)) )
		btnWBack:Spawn()
		btnWBack:Activate()
		btnWBack:SetParent( entCar )
		btnWBack:SetModelScale( 0.25 )
		btnWBack.BlockPhysGun = true
		btnWBack:SetCanUseCallback( function( entBtn, pPlayer )
			if IsValid( entCar ) and IsValid( entCar:GetDriver() ) then return end
			return GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_TOW
		end )
		bed:SetWinchBackButton( btnWBack )

		local btnWForward = ents.Create( "ent_button" )
		btnWForward:SetModel( "models/maxofs2d/button_06.mdl" )
		btnWForward:SetIsToggle( false )
		btnWForward:SetPos( entCar:LocalToWorld(Vector(-44.391602, -60.279293, 47.378601)) )
		btnWForward:SetAngles( entCar:LocalToWorldAngles(Angle(-90, 0, 0)) )
		btnWForward:Spawn()
		btnWForward:Activate()
		btnWForward:SetParent( entCar )
		btnWForward:SetModelScale( 0.25 )
		btnWForward.BlockPhysGun = true
		btnWForward:SetCanUseCallback( function( entBtn, pPlayer )
			if IsValid( entCar ) and IsValid( entCar:GetDriver() ) then return end
			return GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_TOW
		end )
		bed:SetWinchForwardButton( btnWForward )

		local btnWRel = ents.Create( "ent_button" )
		btnWRel:SetModel( "models/maxofs2d/button_01.mdl" )
		btnWRel:SetIsToggle( false )
		btnWRel:SetPos( entCar:LocalToWorld(Vector(-45.289066, -77.012695, 48.113190)) )
		btnWRel:SetAngles( entCar:LocalToWorldAngles(Angle(90, 180, 0)) )
		btnWRel:Spawn()
		btnWRel:Activate()
		btnWRel:SetParent( entCar )
		btnWRel:SetModelScale( 0.25 )
		btnWRel.BlockPhysGun = true
		btnWRel:SetCanUseCallback( function( entBtn, pPlayer )
			if IsValid( entCar ) and IsValid( entCar:GetDriver() ) then return end
			return GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_TOW
		end )
		bed:SetWinchReleaseButton( btnWRel )

		entCar.BedEnt = bed
		entCar.IsTow = true
		entCar:DeleteOnRemove( bed )
		entCar:DeleteOnRemove( btnLock )
		entCar:DeleteOnRemove( btnBack )
		entCar:DeleteOnRemove( btnForward )
		entCar:DeleteOnRemove( btnWBack )
		entCar:DeleteOnRemove( btnWForward )
		entCar:DeleteOnRemove( btnWRel )

		pPlayer:AddNote( "You spawned your tow truck!" )
	end

	function Job:OnPlayerSpawnTowTruck( pPlayer, entCar )
		GAMEMODE.Cars:ApplyVehicleParams( entCar, "TowBuff", {
			["engine"] = {
				["shiftUpRPM"] = -1000,
				["maxSpeed"] = -80,
				["horsepower"] = 370,
				["gearRatio"] = {
					[1] = 5,
					[2] = 3,
					[3] = 1,
					[4] = 0,
					[5] = 0,
				},
			},
			["body"] = {
				["addGravity"] = 300,
				["massOverride"] = 4000,
			},
			["axles"] = {
				[1] = {
					["torqueFactor"] = -0.5,
				},
				[2] = {
					["torqueFactor"] = 0.5,
					["suspension_maxBodyForce"] = 2000,
				},
			},
		} )

		entCar.IsTow = true

		local btn = ents.Create( "ent_vehicle_btn" )
		btn:SetPos( Vector(35, -130, 50) )
		btn:SetAngles( entCar:LocalToWorldAngles(Angle(20, 180, 0)) )
		btn:SetMoveParent( entCar )
		btn:Spawn()
		btn:SetLabel( "Raise / Lower Hook" )
		btn.Extender = true

		local release = ents.Create( "ent_vehicle_btn" )
		release:SetPos( Vector(-35, -130, 50) )
		release:SetAngles( entCar:LocalToWorldAngles(Angle(20, 180, 0)) )
		release:SetMoveParent( entCar )
		release:Spawn()
		release:SetIsToggle( false )
		release:SetLabel( "Disengage Hook" )

		local Hook = ents.Create( "ent_towtruck_hook" )
		Hook:SetPos( entCar:LocalToWorld(Vector(0, -170, 10)) )
		Hook:SetAngles( entCar:GetAngles() )
		Hook:Spawn()
		Hook:SetPlayerOwner( pPlayer )
		local physobj = Hook:GetPhysicsObject()
		if IsValid( physobj ) then
			physobj:SetMass( 10 )
			physobj:SetDamping( 15, 5 )
		end

		local constr, rope = constraint.Elastic(
			Hook, entCar,
			0, 0,
			Vector( 0, 0, 0 ),
			Vector( 0, -160, 110 ),
			50000, 25, 0.5,
			"cable/cable",
			2,
			true
		)
		local nocollide = constraint.NoCollide( Hook, entCar, 0, 0 )
		rope:Fire( "SetSpringLength", 20 )

		Hook.constraint = constr
		Hook.rope = rope
		Hook.Vehicle = entCar

		btn.Hook = Hook
		release.Hook = Hook
		entCar.Hook = Hook

		entCar:DeleteOnRemove( Hook )
		entCar:DeleteOnRemove( btn )
		entCar:DeleteOnRemove( release )

		pPlayer:AddNote( "You spawned your tow truck!" )
	end
	
	--Player wants to spawn a tow truck
	function Job:PlayerSpawnTowTruck( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.TruckID, self.TruckSpawns, self.ParkingLotPos )
		if IsValid( car ) then
			self:OnPlayerSpawnTowTruck( pPlayer, car )
		end
	end

	--Player wants to spawn a flatbed
	function Job:PlayerSpawnFlatbed( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.FlatbedID, self.TruckSpawns, self.ParkingLotPos )
		if IsValid( car ) then
			self:OnPlayerSpawnFlatbed( pPlayer, car )
		end
	end	

	--Player wants to stow their tow truck
	function Job:PlayerStowTowTruck( pPlayer )
		GAMEMODE.Cars:PlayerStowJobCar( pPlayer, self.ParkingLotPos )
	end

	hook.Add( "GamemodePlayerSendTextMessage", "TowJobTexting", function( pSender, strText, strNumberSendTo )
		if strNumberSendTo ~= "Roadside Assistance" then return end
		if pSender.m_intLastTowText and pSender.m_intLastTowText > CurTime() then
			local time = math.Round( pSender.m_intLastTowText -CurTime() )
			GAMEMODE.Net:SendTextMessage( pSender, "Roadside Assistance", "You must wait ".. time.. " seconds before you can send another message to roadside assistance." )
			pSender:EmitSound( "taloslife/sms.mp3" )
			return true
		end
		local sentTo = 0
		strText = "Roadside assistance call from ".. GAMEMODE.Player:GetGameVar(pSender, "phone_number").. "\n(".. pSender:Nick().. "):\n".. strText
		for k, v in pairs( player.GetAll() ) do
			if GAMEMODE.Jobs:GetPlayerJobID( v ) == JOB_TOW then
				GAMEMODE.Net:SendTextMessage( v, "Tow Dispatch", strText )
				v:EmitSound( "taloslife/sms.mp3" )
				sentTo = sentTo +1
			end
		end

		local respMsg = ""
		if sentTo == 0 then
			respMsg = "No roadside services are available right now. Sorry!"
		else
			respMsg = "Your message was received by dispatch and sent to ".. sentTo.. " players."
		end
		
		GAMEMODE.Net:SendTextMessage( pSender, "Roadside Assistance", respMsg )
		pSender:EmitSound( "taloslife/sms.mp3" )
		pSender.m_intLastTowText = CurTime() +60
		return
	end )

	hook.Add( "PlayerEnteredVehicle", "TowTips", function( pPlayer, entVeh, intRole )
		if not entVeh.IsTow then return end
		if not IsValid( entVeh.BedEnt ) then return end
		
		if not entVeh.BedEnt:IsBedLocked() then
			pPlayer:AddNote( "The truck bed is currently unlocked!" )
			pPlayer:AddNote( "This will impact your speed, please lock the bed before driving." )
		end
	end )

	--Custom exit spawns for the flatbed, try to handle it here first since the default one is kind of crappy
	local spawns = { Vector(-102.989403, 80.599289, 43.687336), Vector(85.989922, 85.333710, 39.285664) }
	hook.Add( "PlayerLeaveVehicle", "FlatbedExitSpawn", function( pPlayer, entVeh )
		if entVeh.IsTow and IsValid( entVeh.BedEnt ) then
			for i = 1, #spawns do
				if GAMEMODE.Util:MinMaxsStuck( entVeh:LocalToWorld(spawns[i]), pPlayer:OBBMins(), pPlayer:OBBMaxs() ) then continue end
				pPlayer:SetPos( entVeh:LocalToWorld(spawns[i]) )
				return
			end
		elseif IsValid( entVeh:GetParent() ) and entVeh:GetParent().IsTow and IsValid( entVeh:GetParent().BedEnt ) then
			for i = 1, #spawns, -1 do
				if GAMEMODE.Util:MinMaxsStuck( entVeh:LocalToWorld(spawns[i]), pPlayer:OBBMins(), pPlayer:OBBMaxs() ) then continue end
				pPlayer:SetPos( entVeh:LocalToWorld(spawns[i]) )
				return
			end			
		end
	end )
else
	--client
end

GM.Jobs:Register( Job )