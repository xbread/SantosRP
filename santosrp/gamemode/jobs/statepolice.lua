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
Job.ID = 55
Job.Enum = "JOB_STATE_POLICE"
Job.Receives911Messages = true
Job.TeamColor = Color( 255, 0, 0, 255 )
Job.Name = "State Police"
Job.WhitelistName = "statepolice"
Job.PlayerModel = {
	Male_Fallback = "models/gta5/player/deputy.mdl",
	Female_Fallback = "models/gta5/player/deputy.mdl",

	Male = {
		["male_01"] = "models/gta5/player/deputy.mdl",
		["male_02"] = "models/gta5/player/deputy.mdl",
		["male_03"] = "models/gta5/player/deputy.mdl",
		["male_04"] = "models/gta5/player/deputy.mdl",
		["male_05"] = "models/gta5/player/deputy.mdl",
		["male_06"] = "models/gta5/player/deputy.mdl",
		["male_07"] = "models/gta5/player/deputy.mdl",
		["male_08"] = "models/gta5/player/deputy.mdl",
		["male_09"] = "models/gta5/player/deputy.mdl",
	},
	Female = {
		["female_01"] = "models/gta5/player/deputy.mdl",
		["female_02"] = "models/gta5/player/deputy.mdl",
		["female_03"] = "models/gta5/player/deputy.mdl",
		["female_04"] = "models/gta5/player/deputy.mdl",
		["female_05"] = "models/gta5/player/deputy.mdl",
		["female_06"] = "models/gta5/player/deputy.mdl",
		["female_07"] = "models/gta5/player/deputy.mdl",
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
Job.PatrolDodgeChargerID = "chargersrt8poltdmsp"
Job.PatrolTaurusID = "taurus_201_copsp"


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
	if curCar and curCar.Job and curCar.Job == JOB_STATE_POLICE then
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

	hook.Add( "KeyPress", "OpenCopComputer", function( pPlayer, intKey )
		if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_STATE_POLICE ) then return end
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
end
------------------------------------
if SERVER then
	function Job:OnPlayerSpawnPatrolTaurus( pPlayer, entCar )
		entCar:SetSkin( 19 )
		entCar:SetBodygroup( 1, 1 )
		
		entCar.IsCopCar = true
		pPlayer:AddNote( "Your spawned your Dodge Charger: Patrol vehicle!" )
	end

	function Job:OnPlayerSpawnPatrolDodgeCharger( pPlayer, entCar )
		entCar:SetSkin( 19 )
		entCar:SetBodygroup( 1, 1 )
		
		entCar.IsCopCar = true
		pPlayer:AddNote( "Your spawned your Dodge Charger: Patrol vehicle!" )
	end
	
	--Player wants to spawn a patrol dodge charger
	function Job:PlayerSpawnPatrolDodgeCharger( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.PatrolDodgeChargerID, self.CarSpawns, self.ParkingLotPos )
		if IsValid( car ) then
			self:OnPlayerSpawnPatrolDodgeCharger( pPlayer, car )
		end
	end

	function Job:PlayerSpawnPatrolTaurus( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.PatrolTaurusID, self.CarSpawns, self.ParkingLotPos )
		if IsValid( car ) then
			self:OnPlayerSpawnPatrolTaurus( pPlayer, car )
		end
	end
	
	--Player wants to stow their patrol car
	function Job:PlayerStowPatrolCar( pPlayer )
		GAMEMODE.Cars:PlayerStowJobCar( pPlayer, self.ParkingLotPos )
	end	
end

GM.Jobs:Register( Job )