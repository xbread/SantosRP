--[[
	Name: firefighter.lua
	For: TalosLife
	By: TalosLife
]]--

GM.ChatRadio:RegisterChannel( 3, "Fire", false )
GM.ChatRadio:RegisterChannel( 4, "Fire Encrypted", true )

local Job = {}
Job.ID = 4
Job.HasMasterKeys = true
Job.Receives911Messages = true
Job.Enum = "JOB_FIREFIGHTER"
Job.TeamColor = Color( 255, 100, 160, 255 )
Job.Name = "Firefighter"
--Job.WhitelistName = "firefighter"
Job.PlayerModel = {
	Male_Fallback = "models/player/portal/male_07_fireman.mdl",
	Female_Fallback = "models/player/portal/male_07_fireman.mdl",
	
	Male = {
		["male_01"] = "models/player/portal/male_01_fireman.mdl",
		["male_02"] = "models/player/portal/male_02_fireman.mdl",
		["male_03"] = "models/player/portal/male_03_fireman.mdl",
		["male_04"] = "models/player/portal/male_04_fireman.mdl",
		["male_05"] = "models/player/portal/male_05_fireman.mdl",
		["male_06"] = "models/player/portal/male_06_fireman.mdl",
		["male_07"] = "models/player/portal/male_07_fireman.mdl",
		["male_08"] = "models/player/portal/male_08_fireman.mdl",
		["male_09"] = "models/player/portal/male_09_fireman.mdl",
	},
	Female = {
		["female_01"] = "models/player/portal/male_02_fireman.mdl",
		["female_02"] = "models/player/portal/male_02_fireman.mdl",
		["female_03"] = "models/player/portal/male_02_fireman.mdl",
		["female_04"] = "models/player/portal/male_04_fireman.mdl",
		["female_05"] = "models/player/portal/male_05_fireman.mdl",
		["female_06"] = "models/player/portal/male_06_fireman.mdl",
		["female_07"] = "models/player/portal/male_07_fireman.mdl",
		["female_08"] = "models/player/portal/male_08_fireman.mdl",
		["female_09"] = "models/player/portal/male_09_fireman.mdl",
	},
}
Job.Pay = {
	{ PlayTime = 0, Pay = 65 },
	{ PlayTime = 4 *(60 *60), Pay = 100 },
	{ PlayTime = 12 *(60 *60), Pay = 180 },
	{ PlayTime = 24 *(60 *60), Pay = 270 },
}
Job.PlayerCap = GM.Config.Job_Fire_PlayerCap or { Min = 2, MinStart = 8, Max = 6, MaxEnd = 60 }
Job.HasChatRadio = true
Job.DefaultChatRadioChannel = 3
Job.ChannelKeys = {
	[2] = true, --Police Encrypted
	[4] = true, --Fire Encrypted
	[6] = true, --EMS Encrypted
}
Job.ParkingGaragePos = GM.Config.FireParkingZone
Job.CarSpawns = GM.Config.FireCarSpawns
Job.FiretruckID = "fire_truck"
Job.FirstRespondID = "fire_first"

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
	pPlayer.m_intSelectedJobModelSkin = nil
	pPlayer.m_tblSelectedJobModelBGroups = nil

	local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
	if curCar and curCar.Job and curCar.Job == JOB_FIREFIGHTER then
		curCar:Remove()
	end
end

function Job:GetPlayerModel( pPlayer )
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
		pPlayer:SetSkin( pPlayer.m_intSelectedJobModelSkin or 0 )

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
	pPlayer:Give( "swep_radiodevice" )
	pPlayer:Give("weapon_extinguisher_custom")
	end

	function Job:OnPlayerSpawnFiretruck( pPlayer, entCar )
		function entCar:GetHoseSlot()
			local Pos = entCar:LocalToWorld( Vector(-60, 10, 70) )
			local Ang = (-entCar:GetUp()):Angle()
			
			return Pos, Ang
		end

		local Pos, Ang = entCar:GetHoseSlot()
		entCar.IsFiretruck = true
		entCar.Hose = ents.Create( "ent_firehose" )
		entCar.Hose:SetPos( Pos )
		entCar.Hose:SetAngles( Ang )
		entCar.Hose:SetOwner( entCar )
		entCar.Hose:Spawn()
		entCar.Hose:Activate()
		entCar.Hose:SetParent( entCar )

		entCar:SetColor( Color(255, 0, 0, 255) )
		pPlayer:AddNote( "You spawned your firetruck!" )
	end
	
	function Job:OnPlayerSpawnFirstRespondCar( pPlayer, entCar )
		entCar:SetSkin( 2 )
		pPlayer:AddNote( "Your spawned your first responder vehicle!" )
	end
	
		--Player wants to spawn a first responder vehicle
	function Job:PlayerSpawnFirstRespondCar( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.FirstRespondID, self.CarSpawns, self.ParkingLotPos )
		if IsValid( car ) then
			self:OnPlayerSpawnFirstRespondCar( pPlayer, car )
		end
	end
	
	--Player wants to spawn a firetruck
	function Job:PlayerSpawnFiretruck( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.FiretruckID, self.CarSpawns, self.ParkingGaragePos )
		if IsValid( car ) then
			self:OnPlayerSpawnFiretruck( pPlayer, car )
		end
	end
	
	--Player wants to stow their firetruck
	function Job:PlayerStowFiretruck( pPlayer )
		GAMEMODE.Cars:PlayerStowJobCar( pPlayer, self.ParkingGaragePos )
	end
else
	--client
end

GM.Jobs:Register( Job )