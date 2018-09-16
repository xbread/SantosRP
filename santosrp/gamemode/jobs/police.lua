--[[
	Name: police.lua
	For: TalosLife
	By: TalosLife
]]--

--Job protocols start at 50 to save space for other things in the gamemode
GM.Net:AddProtocol( "police", 51 )
GM.ChatRadio:RegisterChannel( 1, "Police", false )
GM.ChatRadio:RegisterChannel( 2, "Police Encrypted", true )

local Job = {}
Job.ID = 2
Job.Enum = "JOB_POLICE"
Job.Receives911Messages = true
Job.TeamColor = Color( 255, 0, 0, 255 )
Job.Name = "Police"
Job.WhitelistName = "police"
Job.PlayerModel = {
	Male_Fallback = "models/player/santos/cop/Male_02_santosrp.mdl",
	Female_Fallback = "models/portal/player/female_police02.mdl",

	Male = {
		["male_01"] = "models/player/santos/cop/male_01.mdl",
		["male_02"] = "models/player/santos/cop/Male_02.mdl",
		["male_03"] = "models/player/santos/cop/Male_03.mdl",
		["male_04"] = "models/player/santos/cop/Male_04.mdl",
		["male_05"] = "models/player/santos/cop/Male_05.mdl",
		["male_06"] = "models/player/santos/cop/Male_06.mdl",
		["male_07"] = "models/player/santos/cop/Male_07.mdl",
		["male_08"] = "models/player/santos/cop/Male_08.mdl",
		["male_09"] = "models/player/santos/cop/Male_09.mdl",
	},
	Female = {
		["female_01"] = "models/portal/player/female_police02.mdl",
	},
}
Job.CanWearCivClothing = true
Job.Pay = {
	{ PlayTime = 0, Pay = 80 },
	{ PlayTime = 4 *(60 *60), Pay = 120 },
	{ PlayTime = 12 *(60 *60), Pay = 170 },
	{ PlayTime = 24 *(60 *60), Pay = 250 },
}
Job.PlayerCap = GM.Config.Job_Police_PlayerCap or { Min = 2, MinStart = 8, Max = 6, MaxEnd = 60 }
Job.HasChatRadio = false
Job.DefaultChatRadioChannel = 1
Job.ChannelKeys = {
	[2] = true, --Police Encrypted
	[4] = true, --Fire Encrypted
	[6] = true, --EMS Encrypted
}
Job.PoliceGaragePos = GM.Config.CopParkingZone
Job.CarSpawns = GM.Config.CopCarSpawns

function Job:OnPlayerJoinJob( pPlayer )
	pPlayer.m_bJobCivModelOverload = false
	pPlayer:SetArmor(100)
	pPlayer:AddNote("You are now wearing light kevlar.")
end

function Job:OnPlayerQuitJob( pPlayer )
	pPlayer.m_bJobCivModelOverload = false
	pPlayer.m_intSelectedJobModelSkin = nil
	pPlayer.m_tblSelectedJobModelBGroups = {}
	pPlayer:SetArmor(0)
	pPlayer:AddNote("Your light kevlar has been removed.")

	local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
	if curCar and curCar.Job and curCar.Job == JOB_POLICE then
		curCar:Remove()
	end
end

function Job:GetPlayerModel( pPlayer, bUnModified )
	if pPlayer.m_bJobCivModelOverload and not bUnModified then
		return GAMEMODE.Jobs:GetJobByID( JOB_CIVILIAN ):GetPlayerModel( pPlayer )
	end

	local valid, mdl
	if SERVER then
		valid, mdl = GAMEMODE.Util:FaceMatchPlayerModel(
			GAMEMODE.Player:GetGameVar( pPlayer, "char_model_base", "" ),
			GAMEMODE.Player:GetSharedGameVar( pPlayer, "char_sex", GAMEMODE.Char.SEX_MALE ) == GAMEMODE.Char.SEX_MALE,
			self.PlayerModel
		)
	else
		valid, mdl = GAMEMODE.Util:FaceMatchPlayerModel(
			GAMEMODE.Player:GetGameVar( "char_model_base", "" ),
			GAMEMODE.Player:GetSharedGameVar( pPlayer, "char_sex", GAMEMODE.Char.SEX_MALE ) == GAMEMODE.Char.SEX_MALE,
			self.PlayerModel
		)
	end

	if valid then
		return mdl
	else
		if GAMEMODE.Player:GetSharedGameVar( pPlayer, "char_sex", GAMEMODE.Char.SEX_MALE ) == GAMEMODE.Char.SEX_MALE then
			return self.PlayerModel.Male_Fallback
		else
			return self.PlayerModel.Female_Fallback
		end
	end
end

if SERVER then
	function Job:PlayerSetModel( pPlayer )
		pPlayer:SetModel( self:GetPlayerModel(pPlayer) )
		pPlayer:SetSkin( not pPlayer.m_bJobCivModelOverload and
			(pPlayer.m_intSelectedJobModelSkin or 0) or
			GAMEMODE.Player:GetGameVar( pPlayer, "char_skin", 0 )
		)

		if pPlayer.m_tblSelectedJobModelBGroups then
			for k, v in pairs( pPlayer:GetBodyGroups() ) do
				if pPlayer.m_tblSelectedJobModelBGroups[v.id] then
					if pPlayer.m_tblSelectedJobModelBGroups[v.id] > pPlayer:GetBodygroupCount( v.id ) -1 then continue end
					pPlayer:SetBodygroup( v.id, pPlayer.m_tblSelectedJobModelBGroups[v.id] )
				end
			end
		end
	end

	function Job:PlayerLoadout( pPlayer )
		pPlayer:Give( "weapon_handcuffer" )
		pPlayer:Give( "weapon_ticket_giver" )
		pPlayer:Give( "policebadgewallet" )
		pPlayer:Give( "swep_radiodevice" )
--		pPlayer:Give( "radio_detective" )
	end

	function Job:OnPlayerSpawnCopCar( pPlayer, entCar )
		local color, skin, groups = net.ReadColor(), net.ReadUInt( 8 ), net.ReadTable()
		entCar:SetColor( color )
		entCar:SetSkin( skin )

		for k, v in pairs( groups ) do
			entCar:SetBodygroup( k, v )
		end

		entCar.IsCopCar = true
		pPlayer:AddNote( "You have spawned your police car!" )
	end

	--Player wants to spawn a cop car
	GM.Net:RegisterEventHandle( "police", "sp_c", function( intMsgLen, pPlayer )
		if not pPlayer:WithinTalkingRange() then return end
		if pPlayer:GetTalkingNPC().UID ~= "cop_spawn_car" then return end

		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, net.ReadString(), Job.CarSpawns, Job.PoliceGaragePos )
		if IsValid( car ) then
			Job:OnPlayerSpawnCopCar( pPlayer, car )
		end
	end )

	--Player wants to stow their cop car
	GM.Net:RegisterEventHandle( "police", "st", function( intMsgLen, pPlayer )
		if not pPlayer:WithinTalkingRange() then return end
		if pPlayer:GetTalkingNPC().UID ~= "cop_spawn_car" then return end

		GAMEMODE.Cars:PlayerStowJobCar( pPlayer, Job.PoliceGaragePos )
	end )

	hook.Add( "KeyPress", "OpenCopComputer", function( pPlayer, intKey )
		if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) then return end
		if not IsValid( pPlayer:GetVehicle() ) then return end
		
		if IsValid( pPlayer:GetVehicle():GetParent() ) then
			if not pPlayer:GetVehicle():GetParent().IsCopCar then return end
		else
			if not pPlayer:GetVehicle().IsCopCar then return end
		end

		if intKey == IN_RELOAD then
			GAMEMODE.Net:ShowNWMenu( pPlayer, "cop_car_computer" )
		end
	end )

	hook.Add( "PlayerEnteredVehicle", "CopComputerHint", function( pPlayer, entVeh, intRole )
		if entVeh.IsCopCar then
			pPlayer:AddNote( "Press 'R' to open your police computer" )
		end
	end )

	hook.Add( "GamemodePlayerSendTextMessage", "PoliceJobTexting", function( pSender, strText, strNumberSendTo )
		if strNumberSendTo ~= "911" then return end
		if pSender.m_intLast911 and pSender.m_intLast911 > CurTime() then
			local time = math.Round( pSender.m_intLast911 -CurTime() )
			GAMEMODE.Net:SendTextMessage( pSender, "911", "You must wait ".. time.. " seconds before you can send another message to dispatch." )
			pSender:EmitSound( "taloslife/sms.mp3" )
			return true
		end

		local sentTo = 0
		strText = "911 from ".. GAMEMODE.Player:GetGameVar(pSender, "phone_number").. "\
(".. pSender:Nick().. "):\
".. strText
		for k, v in pairs( player.GetAll() ) do
			if not GAMEMODE.Jobs:GetPlayerJob( v ) then continue end
			if GAMEMODE.Jobs:GetPlayerJob( v ).Receives911Messages then
				GAMEMODE.Net:SendTextMessage( v, "Dispatch", strText )
				v:EmitSound( "taloslife/sms.mp3" )
				sentTo = sentTo +1
			end
		end

		local respMsg = ""
		if sentTo == 0 then
			respMsg = "No emergency services are available right now. Sorry!"
		else
			respMsg = "Your message was received by dispatch and sent to ".. sentTo.. " players."
		end
		
		GAMEMODE.Net:SendTextMessage( pSender, "911", respMsg )
		pSender:EmitSound( "taloslife/sms.mp3" )
		pSender.m_intLast911 = CurTime() +GAMEMODE.Config.Text911CoolDown
		return true
	end )

	hook.Add( "GamemodeOnPlayerJailBreak", "AlertPolice", function( pJailedPlayer )
		local str = ("%s has escaped from jail!"):format( pJailedPlayer:Nick() )
		for k, v in pairs( player.GetAll() ) do
			if v == pJailedPlayer then continue end
			if GAMEMODE.Jobs:GetPlayerJobID( v ) ~= JOB_POLICE then continue end
			GAMEMODE.Net:SendTextMessage( v, "Dispatch", str )
		end
	end )
else
	function GM.Net:RequestSpawnCopCar( strJobCarID, colColor, intSkin, tblBodygroups )
		self:NewEvent( "police", "sp_c" )
			net.WriteString( strJobCarID )
			net.WriteColor( colColor or Color(255, 255, 255, 255) )
			net.WriteUInt( intSkin or 0, 8 )
			net.WriteTable( tblBodygroups or {} )
		self:FireEvent()
	end

	function GM.Net:RequestStowCopCar()
		self:NewEvent( "police", "st" )
		self:FireEvent()
	end
end

GM.Jobs:Register( Job )