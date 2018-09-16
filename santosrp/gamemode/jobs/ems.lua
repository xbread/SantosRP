--[[
	Name: ems.lua
	For: TalosLife
	By: TalosLife
]]--

--Job protocols start at 50 to save space for other things in the gamemode
GM.Net:AddProtocol( "ems", 53 )

GM.ChatRadio:RegisterChannel( 5, "EMS", false )
GM.ChatRadio:RegisterChannel( 6, "EMS Encrypted", true )

local Job = {}
Job.ID = 3
Job.HasMasterKeys = true
Job.Receives911Messages = true
Job.Enum = "JOB_EMS"
--Job.WhitelistName = "parmedic"
Job.TeamColor = Color( 255, 100, 160, 255 )
Job.Name = "Paramedic"
Job.PlayerModel = {
	Male_Fallback = "models/player/portal/male_08_medic.mdl",
	Female_Fallback = "models/player/portal/male_02_medic.mdl",
	
	Male = {
		["male_01"] = "models/player/portal/male_02_medic.mdl",
		["male_02"] = "models/player/portal/male_04_medic.mdl",
		["male_03"] = "models/player/portal/male_05_medic.mdl",
		["male_04"] = "models/player/portal/male_06_medic.mdl",
		["male_05"] = "models/player/portal/male_07_medic.mdl",
		["male_06"] = "models/player/portal/male_06_medic.mdl",
		["male_07"] = "models/player/portal/male_08_medic.mdl",
		["male_08"] = "models/player/portal/male_09_medic.mdl",
	},
	Female = {
		["female_01"] = "models/player/portal/male_02_medic.mdl",
		["female_02"] = "models/player/portal/male_04_medic.mdl",
		["female_03"] = "models/player/portal/male_05_medic.mdl",
		["female_04"] = "models/player/portal/male_06_medic.mdl",
		["female_05"] = "models/player/portal/male_07_medic.mdl",
		["female_06"] = "models/player/portal/male_06_medic.mdl",
		["female_07"] = "models/player/portal/male_08_medic.mdl",
		["female_08"] = "models/player/portal/male_09_medic.mdl",
	},
}
Job.Pay = {
	{ PlayTime = 0, Pay = 60 },
	{ PlayTime = 4 *(60 *60), Pay = 95 },
	{ PlayTime = 12 *(60 *60), Pay = 170 },
	{ PlayTime = 24 *(60 *60), Pay = 250 },
}
Job.PlayerCap = GM.Config.Job_EMS_PlayerCap or { Min = 2, MinStart = 8, Max = 6, MaxEnd = 60 }
Job.HasChatRadio = false
Job.DefaultChatRadioChannel = 5
Job.ChannelKeys = {
	[2] = true, --Police Encrypted
	[4] = true, --Fire Encrypted
	[6] = true, --EMS Encrypted
}
Job.ParkingLotPos = GM.Config.EMSParkingZone
Job.CarSpawns = GM.Config.EMSCarSpawns
Job.FirstRespondID = "ems_firstrespond"
Job.FirstResponderID = "ford_explorer_2013_ems"
Job.AmbulanceID = "ems_ambulance"
Job.BedModel = "models/custommodels/stretcher.mdl" --"models/props_medicinalpractice/medic_stretcher_a.mdl"

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
	local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
	if curCar and curCar.Job and curCar.Job == JOB_EMS then
		curCar:Remove()
	end
end

if SERVER then
	function Job:PlayerSetModel( pPlayer )
		local charData = GAMEMODE.Char:GetPlayerCharacter( pPlayer )
		if not charData then return end

		local valid, mdl = GAMEMODE.Util:FaceMatchPlayerModel(
			GAMEMODE.Player:GetGameVar( pPlayer, "char_model_base", "" ),
			charData.Sex == GAMEMODE.Char.SEX_MALE,
			self.PlayerModel
		)

		if valid then
			pPlayer:SetModel( mdl )
		else
			if charData.Sex == GAMEMODE.Char.SEX_MALE then
				pPlayer:SetModel( self.PlayerModel.Male_Fallback )
			elseif charData.Sex == GAMEMODE.Char.SEX_FEMALE then
				pPlayer:SetModel( self.PlayerModel.Female_Fallback )
			end
		end

		pPlayer:SetSkin( 0 )
	end

	function Job:PlayerLoadout( pPlayer )
		pPlayer:Give( "weapon_defib" )
		pPlayer:Give( "swep_radiodevice" )
	end

	function Job:OnPlayerSpawnFirstResponderCar( pPlayer, entCar )
		entCar:SetSkin( 5 )
		entCar:SetBodygroup( 1, 1 )

		pPlayer:AddNote( "You spawned your first responder SUV vehicle!" )
	end
	
	function Job:OnPlayerSpawnFirstRespondCar( pPlayer, entCar )
		entCar:SetSkin( 5 )
		entCar:SetBodygroup( 1, 1 )

		pPlayer:AddNote( "You spawned your first responder vehicle!" )
	end

	function Job:OnPlayerSpawnAmbulance( pPlayer, entCar )
			entCar:SetSkin( 2 )
		entCar.IsAmbulance = true
		
		local btn = ents.Create( "ent_button" )
		btn:SetModel( "models/maxofs2d/button_06.mdl" )
		btn:SetIsToggle( true )
		btn:SetPos( entCar:LocalToWorld(Vector(55, -158, 60)) )
		btn:SetAngles( entCar:GetAngles() +Angle(90, 0, 0) )
		btn:SetParent( entCar )
		btn:Spawn()
		btn:SetLabel( "Open/Close Door" )
		btn.BlockPhysGun = true
		btn:SetCanUseCallback( function( entBtn, pPlayer )
			return GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_EMS
		end )

		function btn:Toggle( bEnable, pPlayer )
			local toggle = entCar:GetPoseParameter( "doors_opening" )
			entCar:SetPoseParameter( "doors_opening", toggle == 1 and 0 or 1 )
			self:SetOn( entCar:GetPoseParameter("doors_opening") == 1 )
		end
		
		local bed = ents.Create( "ent_stretcher" )
		bed:SetPos( entCar:LocalToWorld(Vector(46.100838, -89.551132, 65.100494)) )
		bed:SetAngles( entCar:LocalToWorldAngles(Angle(0, 180, 0)) )
		bed:Spawn()
		bed:GetPhysicsObject():SetMass( 5 )
		bed:SetParent( entCar )
		
		local index = entCar:EntIndex()
		timer.Create( "AmbulanceAdd".. index, 3, 0, function()
			if not IsValid( entCar ) then timer.Destroy( "AmbulanceAdd".. index ) return end
			
			local snapto = entCar:LocalToWorld( Vector(20, -160, 38) )
			for k, prop in pairs( ents.FindByClass("ent_stretcher") ) do
				if not IsValid( prop ) then continue end
				if prop:GetModel() ~= self.BedModel then continue end
				if prop:GetParent() == veh then continue end

				if not prop.LastReleased then continue end
				if prop.LastReleased > CurTime() -5 then continue end
				if prop:GetPos():Distance( snapto ) < 100 then
					prop:SetPos( entCar:LocalToWorld(Vector(46.100838, -89.551132, 65.100494)) )
					prop:SetAngles( entCar:LocalToWorldAngles(Angle(0, 180, 0)) )
					prop:SetParent( entCar )
					prop:EmitSound( Sound("weapons/crossbow/hit1.wav") )
					prop.LastReleased = nil
				end
			end
		end )
		
		entCar:DeleteOnRemove( btn )
		entCar:DeleteOnRemove( bed )
		pPlayer:AddNote( "Your spawned your ambulance!" )
	end

	hook.Add( "CanExitVehicle", "EMS_Stretcher", function( entCar, pPlayer )
		if entCar.IsStretcher then
			local parent = entCar:GetMoveParent()
			if IsValid( parent ) then parent = parent:GetParent() end
			
			return not pPlayer:IsUncon() and not IsValid( parent )
		end
	end )

	hook.Add( "PlayerLeaveVehicle", "EMS_Stretcher_ReUnconscious", function( pPlayer, entCar )
		if entCar.IsStretcher then
			if IsValid( entCar:GetMoveParent() ) and IsValid( entCar:GetMoveParent():GetParent() ) then
				pPlayer:SetPos( entCar:GetMoveParent():GetParent():LocalToWorld(Vector(-20, -200, 10)) )
			end
			
			if pPlayer:IsUncon() then
				pPlayer:BecomeRagdoll()
			end
		end
	end )

	--Player wants to spawn a first responder ford vehicle
	function Job:PlayerSpawnFirstResponderCar( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.FirstResponderID, self.CarSpawns, self.ParkingLotPos )
		if IsValid( car ) then
			self:OnPlayerSpawnFirstResponderCar( pPlayer, car )
		end
	end
	
	--Player wants to spawn a first responder vehicle
	function Job:PlayerSpawnFirstRespondCar( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.FirstRespondID, self.CarSpawns, self.ParkingLotPos )
		if IsValid( car ) then
			self:OnPlayerSpawnFirstRespondCar( pPlayer, car )
		end
	end
	
	--Player wants to spawn an ambulance
	function Job:PlayerSpawnAmbulance( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.AmbulanceID, self.CarSpawns, self.ParkingLotPos )
		if IsValid( car ) then
			self:OnPlayerSpawnAmbulance( pPlayer, car )
		end
	end
	
	--Player wants to stow their ems car
	function Job:PlayerStowEMSCar( pPlayer )
		GAMEMODE.Cars:PlayerStowJobCar( pPlayer, self.ParkingLotPos )
	end

	function GM.Net:SendPlayerEMSClipboardData( pPlayer, pAbout )
		self:NewEvent( "ems", "clip" )
			net.WriteEntity( pAbout )
			net.WriteUInt( pAbout:Health(), 8 )

			for k, v in pairs( GAMEMODE.PlayerDamage:GetLimbs() ) do
				net.WriteUInt( k, 8 )
				net.WriteUInt( GAMEMODE.PlayerDamage:GetPlayerLimbHealth(pAbout, k), 8 )
				net.WriteBool( GAMEMODE.PlayerDamage:IsPlayerLimbBleeding(pAbout, k) )
				net.WriteBool( GAMEMODE.PlayerDamage:IsPlayerLimbBroken(pAbout, k) )
			end
		self:FireEvent( pPlayer )
	end
else
	local MAT_HEALTH_ICON = Material( "icon16/heart.png" )
	hook.Add( "HUDPaint", "EMS_DrawDeadPlayers", function()
		if GAMEMODE.Jobs:GetPlayerJobID( LocalPlayer() ) ~= JOB_EMS then return end
		for k, v in pairs( player.GetAll() ) do
			if not (v:IsUncon() or not v:Alive()) or not IsValid( v:GetRagdoll() ) then continue end
			
			local pos = v:GetRagdoll():GetPos():ToScreen()
			local timeelapsed = CurTime() -(not v:Alive() and v:GetNWFloat("DeathStart") or v:GetNWFloat("StartDie"))
			draw.SimpleText(
				string.ToMinutesSeconds( (v:Alive() and 600 or 180) -timeelapsed ),
				"Trebuchet24",
				pos.x,
				pos.y,
				color_white,
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_TOP
			)
			local num, unit = GAMEMODE.Util:ConvertUnitsToM( v:GetPos():Distance(LocalPlayer():GetPos()) )
			draw.SimpleText(
				num.. unit,
				"Trebuchet24",
				pos.x,
				pos.y +18,
				color_white,
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_TOP
			)

			local iconSize = 16
			surface.SetMaterial( MAT_HEALTH_ICON )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( pos.x -(iconSize /2), pos.y -iconSize, iconSize, iconSize )
		end
	end )

	GM.Net:RegisterEventHandle( "ems", "clip", function( intMsgLen, pPlayer )
		local about = net.ReadEntity()
		local health = net.ReadUInt( 8 )

		local limbs = {}
		for k, v in pairs( GAMEMODE.PlayerDamage:GetLimbs() ) do
			limbs[net.ReadUInt( 8 )] = {
				Health = net.ReadUInt( 8 ),
				Bleeding = net.ReadBool(),
				Broken = net.ReadBool(),
			}
		end

		local wep = LocalPlayer():GetActiveWeapon()
		if IsValid( wep ) and wep:GetClass() == "weapon_ems_clipboard" then
			wep.m_tblHealthData	= {
				Limbs = limbs,
				Health = health,
				Target = about,
			}
		end
	end )
end

GM.Jobs:Register( Job )