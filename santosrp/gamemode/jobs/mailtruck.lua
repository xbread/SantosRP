--[[
	Name: mailtruck.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 7
Job.Enum = "JOB_MAIL"
Job.TeamColor = Color( 255, 100, 160, 255 )
Job.Name = "Mail Truck Driver"
Job.Pay = {
	{ PlayTime = 0, Pay = 25 },
	{ PlayTime = 4 *(60 *60), Pay = 40 },
	{ PlayTime = 12 *(60 *60), Pay = 60 },
	{ PlayTime = 24 *(60 *60), Pay = 95 },
}
Job.PlayerCap = GM.Config.Job_MailTruck_PlayerCap or { Min = 2, MinStart = 8, Max = 6, MaxEnd = 60 }
Job.TruckID = "mail_truck"
Job.MAX_BOXES = 10
Job.m_vecMailDepot = GM.Config.MailDepotPos
Job.ParkingLotPos = GM.Config.MailParkingZone
Job.TruckSpawns = GM.Config.MailCarSpawns
Job.m_tblMailPoints = GM.Config.MailPoints

if SERVER then
	Job.m_tblTrucks = JOB_MAIL and GAMEMODE.Jobs:GetJobByID( JOB_MAIL ).m_tblTrucks or {}
end

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
	local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
	if curCar and curCar.Job and curCar.Job == JOB_MAIL then
		curCar:Remove()
	end
end

if SERVER then
	function Job:PlayerLoadout( pPlayer )
	end

	function Job:OnPlayerSpawnMailTruck( pPlayer, entCar )
		entCar:SetNWInt( "boxes", 0 )
		entCar:SetSkin( 1 )
		entCar.IsMailTruck = true
		self.m_tblTrucks[entCar] = true

		pPlayer:AddNote( "You spawned your mail truck!" )
	end

	function Job:GenerateMailPoint( entCar )
		local point, idx = table.Random( self.m_tblMailPoints )
		entCar:SetNWInt( "dest", idx )
		entCar.MailDest = {
			Pos = point.Pos,
			Name = point.Name,
			Pay = math.random( point.MinPrice, point.MaxPrice ),
		}
	end

	function Job:MakePackage( entCar )
		local dist = entCar:OBBCenter():Distance( entCar:OBBMaxs() ) +14
		local tr = util.TraceLine{
			start = entCar:GetPos() +(entCar:GetAngles():Right() *dist) +Vector(0, 0, 72),
			endpos = entCar:GetPos() +(entCar:GetAngles():Right() *dist),
			filter = pOwner,
		}
		local spawnPos = tr.HitPos

		local ent = ents.Create( "ent_mail" )
		ent:SetPos( spawnPos )
		ent:SetAngles( Angle(0, 0, 0) )
		ent:Spawn()
		ent:Activate()
		ent.ParentMailTruck = entCar

		if IsValid( entCar.CurrentPackage ) then
			entCar.CurrentPackage:Remove()
		end

		local vFlushPoint = spawnPos -(tr.HitNormal *512)
		vFlushPoint = ent:NearestPoint( vFlushPoint )
		vFlushPoint = ent:GetPos() -vFlushPoint
		vFlushPoint = spawnPos +vFlushPoint +Vector(0, 0, 2)
		ent:SetPos( vFlushPoint )

		entCar:DeleteOnRemove( ent )
		entCar.CurrentPackage = ent
	end

	function Job:ThinkMailDepot()
		if not self.m_vecMailDepot then return end
		if not self.m_intLastDepotThink then
			self.m_intLastDepotThink = 0
		end

		if CurTime() < self.m_intLastDepotThink then return end
		self.m_intLastDepotThink = CurTime() +1

		for k, v in pairs( ents.FindInSphere(self.m_vecMailDepot, 100) ) do
			if not IsValid( v ) or not v:IsVehicle() or not v.IsMailTruck then continue end
			
			if v:GetNWInt( "boxes" ) < self.MAX_BOXES then
				v:SetNWInt( "boxes", v:GetNWInt("boxes") +1 )
				v:EmitSound( "physics/cardboard/cardboard_box_impact_soft".. math.random(1, 7).. ".wav" )

				if not v.MailDest then
					self:GenerateMailPoint( v )
				end
			end
		end
	end

	function Job:ThinkDeliveryPoints()
		if not self.m_intLastPointThink then
			self.m_intLastPointThink = 0
		end

		if CurTime() < self.m_intLastPointThink then return end
		self.m_intLastPointThink = CurTime() +1

		for k, v in pairs( self.m_tblTrucks ) do
			if not IsValid( k ) or not k.MailDest then continue end
			
			for _, ent in pairs( ents.FindInSphere(k.MailDest.Pos, 64) ) do
				if not IsValid( ent ) or not ent.ParentMailTruck then continue end
				if ent.ParentMailTruck == k then
					k:GetPlayerOwner():AddMoney( k.MailDest.Pay )
					k:GetPlayerOwner():AddNote( "You earned $".. k.MailDest.Pay.. " for delivering a package!" )

					ent:Remove()
					k:SetNWInt( "boxes", k:GetNWInt("boxes") -1 )
					if k:GetNWInt( "boxes" ) > 0 then
						self:GenerateMailPoint( k )
					else
						k.MailDest = nil
						k:SetNWInt( "dest", -1 )
					end
				end
			end
		end
	end

	hook.Add( "EntityRemoved", "RemoveMailTruck", function( eEnt )
		if not IsValid( eEnt ) or not eEnt:IsVehicle() or not eEnt.IsMailTruck then return end
		Job.m_tblTrucks[eEnt] = nil
	end )

	hook.Add( "PlayerUse", "UseMailTruck", function( pPlayer, eEnt )
		if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_MAIL ) then return end
		if not IsValid( eEnt ) or not eEnt:IsVehicle() or not eEnt.IsMailTruck then return end
		if eEnt:GetNWInt( "boxes" ) <= 0 then return end

		local dot = (pPlayer:GetEyeTrace().HitPos -eEnt:GetPos()):GetNormal():Dot( eEnt:GetForward() )
		if dot < -0.9 and CurTime() >(pPlayer.m_intLastUsedMailTruck or 0) then
			Job:MakePackage( eEnt )
			pPlayer.m_intLastUsedMailTruck = CurTime() +1
			return false
		end
	end )

	hook.Add( "Think", "ThinkMailTruck", function()
		Job:ThinkMailDepot()
		Job:ThinkDeliveryPoints()
	end )

	--Player wants to spawn a mail truck
	function Job:PlayerSpawnMailTruck( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.TruckID, self.TruckSpawns, self.ParkingLotPos )
		if IsValid( car ) then
			self:OnPlayerSpawnMailTruck( pPlayer, car )
		end
	end
	
	--Player wants to stow their mail truck
	function Job:PlayerStowMailTruck( pPlayer )
		GAMEMODE.Cars:PlayerStowJobCar( pPlayer, self.ParkingLotPos )
	end
else
	hook.Add( "PostDrawTranslucentRenderables", "DrawMailJob", function()
		if GAMEMODE.Jobs:GetPlayerJobID( LocalPlayer() ) ~= JOB_MAIL then return end
		local veh = GAMEMODE.Cars:GetCurrentPlayerCar( LocalPlayer() )
		local eye = LocalPlayer():EyeAngles()
		local Ang = Angle( 0, EyeAngles().y -90, 90 )

		--Draw mail depot
		cam.Start3D2D( Job.m_vecMailDepot +Vector(0, 0, 128 +math.sin(CurTime()) *2), Ang, 0.25 )
			draw.WordBox(2, -60, 0, "Mail Depot", "handcuffTextSmall", Color(0, 140, 0, 150), Color(255,255,255,255))
			draw.SimpleText( "Drive here to load boxes onto your truck", "handcuffTextSmall", 0, 45, color_white, 1, 1 )
		cam.End3D2D()

		if not IsValid( veh ) then return end
		if veh:GetNWInt( "dest" ) == -1 then return end
		--Draw current destination
		
		local dest = Job.m_tblMailPoints[veh:GetNWInt("dest")]
		if not dest then return end
		cam.Start3D2D( dest.Pos +Vector(0, 0, 32 +math.sin(CurTime()) *2), Ang, 0.25 )
			draw.WordBox(2, -60, 0, "Delivery Point", "handcuffTextSmall", Color(0, 140, 0, 150), Color(255,255,255,255))
			draw.SimpleText( "Drop a package here to complete this delivery", "handcuffTextSmall", 0, 45, color_white, 1, 1 )
		cam.End3D2D()
	end )

	hook.Add( "HUDPaint", "DrawMailJob", function()
		if GAMEMODE.Jobs:GetPlayerJobID( LocalPlayer() ) ~= JOB_MAIL then return end
		local veh = GAMEMODE.Cars:GetCurrentPlayerCar( LocalPlayer() )
		if not IsValid( veh ) then return end
		local dest = Job.m_tblMailPoints[veh:GetNWInt("dest", -1)]
		
		draw.SimpleTextOutlined(
			"Packages Remaining: ".. veh:GetNWInt( "boxes" ),
			"handcuffTextSmall",
			5,
			5,
			color_white,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_LEFT,
			1,
			Color( 0, 0, 0, 255 )
		)

		if dest then
			draw.SimpleTextOutlined(
				"Delivery Destination: ".. dest.Name,
				"handcuffTextSmall",
				5,
				30,
				color_white,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_LEFT,
				1,
				Color( 0, 0, 0, 255 )
			)
		end
	end )
end

GM.Jobs:Register( Job )