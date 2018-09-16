GM.Jail = {}
GM.Jail.m_intLastTick = 0

function GM.Jail:PlayerSpawn( pPlayer )
	if not pPlayer.m_bGamemodeDataLoaded or not GAMEMODE.Char:GetPlayerCharacter( pPlayer ) then return end --This player hasn't loaded in yet.

	if self:IsPlayerInJail( pPlayer ) then
		if self:GetJailTimeLeft( pPlayer ) > 0 then --throw them back in the slammer!
			self:SendPlayerToJail( pPlayer )
		else --clear jail data
			self:OnPlayerLeaveJail( pPlayer, "Jail time served." )
			self:ClearPlayerJailData( pPlayer )
		end
	end
end

function GM.Jail:Tick()
	if self.m_intLastTick > CurTime() then return end
	self.m_intLastTick = CurTime() +1

	for k, v in pairs( player.GetAll() ) do
		if not self:IsPlayerInJail( v ) then continue end
		if self:GetJailTimeLeft( v ) < 0 then
			self:ReleasePlayerFromJail( v, "Jail time served." )
		else
			if GAMEMODE.Config.JailBBox and v:Alive() then
				if not GAMEMODE.Util:VectorInRange( v:GetPos(), GAMEMODE.Config.JailBBox.Min, GAMEMODE.Config.JailBBox.Max ) then
					v.m_intUnjailTicks = (v.m_intUnjailTicks or 0) +1
					if v.m_intUnjailTicks < 5 then continue end

					--Player is in jail but out of the jail zone, consider this a jail break and unjail them
					if self:ReleasePlayerFromJail( v, "Escaped from cell!", true, true ) then
						v:AddNote( "You have broken out of your cell!" )
						hook.Call( "GamemodeOnPlayerJailBreak", GAMEMODE, v )
					end
				else
					v.m_intUnjailTicks = nil
				end
			end
		end
	end
end

function GM.Jail:FindEmptyCell()
	for k, v in pairs( GAMEMODE.Config.JailPositions ) do
		for _, ent in pairs( ents.FindInSphere(v, 128) ) do
			if ent:GetClass() == "player" then continue end
		end

		return k, v
	end
end

function GM.Jail:FindEmptyReleaseSpawn()
	for k, v in pairs( GAMEMODE.Config.JailReleasePositions ) do
		for _, ent in pairs( ents.FindInSphere(v, 32) ) do
			if ent:GetClass() == "player" then continue end
		end

		return k, v
	end
end

function GM.Jail:IsPlayerInJail( pPlayer )
	return GAMEMODE.Player:GetSharedGameVar( pPlayer, "arrested" )
end

function GM.Jail:GetArrestStartTime( pPlayer )
	return GAMEMODE.Player:GetGameVar( pPlayer, "arrest_start", 0 )
end

function GM.Jail:GetJailTimeLeft( pPlayer )
	return (GAMEMODE.Player:GetGameVar(pPlayer, "arrest_start", 0) +GAMEMODE.Player:GetSharedGameVar(pPlayer, "arrest_duration", 0)) -os.time()
end

function GM.Jail:GetPlayerBailPrice( pPlayer )
	if not self:IsPlayerInJail( pPlayer ) then return 0 end
	local bailPrice = GAMEMODE.Player:GetSharedGameVar( pPlayer, "arrest_duration", 0 )
	if bailPrice > 0 then
		bailPrice = math.floor( bailPrice /60 ) *350
	end

	return bailPrice
end

function GM.Jail:SendPlayerToJail( pPlayer )
	local cellID, cellPos = self:FindEmptyCell()
	if not cellID then --fuck, just throw them in a random cell lol
		cellID = math.random( 1, #self.m_tblJailPos )
		cellPos = self.m_tblJailPos[cellID]
	end

	if not cellPos then return false end
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "arrested", true )
	pPlayer:StripWeapons()
	pPlayer:SetPos( cellPos )
	pPlayer:AddNote( "You have been sent to jail!" )
	GAMEMODE.Phone:PlayerEndCall( pPlayer )
	
	return true
end

function GM.Jail:ReleasePlayerFromJail( pPlayer, strReason, bNoSetPos, bCustomReason )
	if not self:IsPlayerInJail( pPlayer ) then return false end
	
	self:OnPlayerLeaveJail( pPlayer, strReason )
	self:ClearPlayerJailData( pPlayer )

	if not bNoSetPos then
		local spawnID, spawnPos = self:FindEmptyReleaseSpawn( pPlayer )
		if not spawnID then
			spawnPos = table.Random( GAMEMODE.Config.JailReleasePositions )
		end

		if pPlayer:InVehicle() then pPlayer:ExitVehicle() end
		pPlayer:SetPos( spawnPos )
	end
	
	hook.Call( "PlayerLoadout", GAMEMODE, pPlayer ) --Give them back their normal weapons
	if not bCustomReason then
		pPlayer:AddNote( "You were relased from jail!" )
		pPlayer:AddNote( strReason )
	end
	
	return true
end

function GM.Jail:OnPlayerLeaveJail( pPlayer, strReason )
	--save arrest data in rap sheet
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	
	saveTable.RapSheet = saveTable.RapSheet or {}
	table.insert( saveTable.RapSheet, {
		Date = os.time(),
		LeaveReason = strReason,
		ArrestReason = GAMEMODE.Player:GetGameVar( pPlayer, "arrest_reason", "unknown" ),
		ArrestedBy = GAMEMODE.Player:GetGameVar( pPlayer, "arrested_by", "unknown" ),
		Duration = GAMEMODE.Player:GetSharedGameVar( pPlayer, "arrest_duration", 0 ),
	} )

	if table.Count( saveTable.RapSheet ) > GAMEMODE.Config.MaxArrestHistory then
		table.remove( saveTable.RapSheet, 1 )
	end

	--Save rap sheet NOW
	--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "RapSheet", saveTable.RapSheet )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "RapSheet" )
end

function GM.Jail:ApplyCurrentArrestData( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	if not saveTable.CurrentArrest then
		self:ClearPlayerJailData( pPlayer, true, true )
		return
	end

	GAMEMODE.Player:SetSharedGameVar( pPlayer, "arrested", true, true )
	GAMEMODE.Player:SetGameVar( pPlayer, "arrest_start", saveTable.CurrentArrest.StartTime, true )
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "arrest_duration", saveTable.CurrentArrest.Duration, true )
	GAMEMODE.Player:SetGameVar( pPlayer, "arrest_reason", saveTable.CurrentArrest.Reason, true )
	GAMEMODE.Player:SetGameVar( pPlayer, "arrested_by", saveTable.CurrentArrest.ArrestedBy, true )
end

function GM.Jail:UpdateCurrentArrestData( pPlayer, bClear )
	--save arrest data
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end

	if not bClear then
		saveTable.CurrentArrest = {
			Reason = GAMEMODE.Player:GetGameVar( pPlayer, "arrest_reason", "unknown" ),
			StartTime = GAMEMODE.Player:GetGameVar( pPlayer, "arrest_start", 0 ),
			Duration = GAMEMODE.Player:GetSharedGameVar( pPlayer, "arrest_duration", 0 ),
			ArrestedBy = GAMEMODE.Player:GetGameVar( pPlayer, "arrested_by", "unknown" ),
		}
	else
		saveTable.CurrentArrest = nil
	end

	--Save current arrest data NOW
	--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "CurrentArrest", saveTable.CurrentArrest )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "CurrentArrest" )
end

function GM.Jail:ClearPlayerJailData( pPlayer, bNoUpdate, bNoSend )
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "arrested", false, bNoSend )
	GAMEMODE.Player:SetGameVar( pPlayer, "arrest_start", 0, bNoSend )
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "arrest_duration", 0, bNoSend )
	GAMEMODE.Player:SetGameVar( pPlayer, "arrest_reason", "", bNoSend )
	GAMEMODE.Player:SetGameVar( pPlayer, "arrested_by", "", bNoSend )

	pPlayer.m_intUnjailTicks = nil

	if not bNoUpdate then
		self:UpdateCurrentArrestData( pPlayer, true )
	end
end

--Player actions
function GM.Jail:PlayerSendPlayerToJail( pPlayer, pBeingJailed, intDuration, strReason )
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) then return false end
	if not IsValid( pBeingJailed ) then return false end
	if not pPlayer:WithinTalkingRange() then return false end
	if pPlayer:GetTalkingNPC().UID ~= "cop_jail_warden" then return false end

	if not IsValid( pBeingJailed:isHandcuffed() ) then return false end
	if pBeingJailed:GetPos():Distance( pPlayer:GetPos() ) >256 then return false end
	if intDuration < GAMEMODE.Config.MinJailTime then return false end
	if intDuration > GAMEMODE.Config.MaxJailTime then return false end
	if strReason == "" then return false end
	if strReason:len() > GAMEMODE.Config.MaxJailReasonLen then return false end

	if self:SendPlayerToJail( pBeingJailed ) then
		GAMEMODE.Player:SetGameVar( pBeingJailed, "arrest_start", os.time() )
		GAMEMODE.Player:SetSharedGameVar( pBeingJailed, "arrest_duration", intDuration )
		GAMEMODE.Player:SetGameVar( pBeingJailed, "arrest_reason", strReason )
		GAMEMODE.Player:SetGameVar( pBeingJailed, "arrested_by", pPlayer:Nick() )
		--Remove any warrants they might of had
		self:ClearPlayerWarrantData( pBeingJailed, false, true ) --no save is true, the save table will be saved in the next call
		self:UpdateCurrentArrestData( pBeingJailed ) --saves the whole save table, once
		
		return true
	end

	return false
end

function GM.Jail:PlayerReleasePlayerFromJail( pPlayer, pJailedPlayer, strReason )
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) then return false end
	if not IsValid( pJailedPlayer ) then return false end
	if not pPlayer:WithinTalkingRange() then return false end
	if pPlayer:GetTalkingNPC().UID ~= "cop_jail_warden" then return false end
	if strReason == "" then return false end
	if strReason:len() > GAMEMODE.Config.MaxJailFreeReasonLen then return false end

	if self:ReleasePlayerFromJail( pJailedPlayer, strReason ) then
		pPlayer:AddNote( "You relased ".. pJailedPlayer:Nick().. " from jail!" )
		return true
	end

	return false
end

function GM.Jail:BailPlayerFromJail( pPayingPlayer, pPlayer )
	if not self:IsPlayerInJail( pPlayer ) then return false end
	if not IsValid( pPlayer ) then return false end
	if GAMEMODE.Jobs:PlayerIsJob( pPayingPlayer, JOB_POLICE ) then return false end
	if not pPayingPlayer:WithinTalkingRange() then return false end
	if pPayingPlayer:GetTalkingNPC().UID ~= "cop_jail_warden" then return false end

	local bailPrice = self:GetPlayerBailPrice( pPlayer )
	if not pPayingPlayer:CanAfford( bailPrice ) then
		pPayingPlayer:AddNote( "You can't afford ".. pPlayer:Nick().. "'s bail price!" )
		return false
	end

	if self:ReleasePlayerFromJail( pPlayer, "Bailed out by ".. pPlayer:Nick() ) then
		pPayingPlayer:TakeMoney( bailPrice )
		pPayingPlayer:AddNote( "You bailed out ".. pPlayer:Nick().. "!" )

		return true
	end

	return false
end


--[[ Warrants ]]--
function GM.Jail:PlayerHasWarrant( pPlayer )
	return GAMEMODE.Player:GetSharedGameVar( pPlayer, "warrant" )
end

function GM.Jail:ApplyCurrentWarrantData( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	if not saveTable.CurrentWarrant then
		self:ClearPlayerWarrantData( pPlayer, true, nil, true )
		return
	end
	
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "warrant", true, true )
	GAMEMODE.Player:SetGameVar( pPlayer, "warrant_reason", saveTable.CurrentWarrant.Reason, true )
	GAMEMODE.Player:SetGameVar( pPlayer, "warrant_by", saveTable.CurrentWarrant.WarrantBy, true )
end

function GM.Jail:UpdateCurrentWarrantData( pPlayer, bClear, bNoSave )
	--save arrest data
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end

	if not bClear then
		saveTable.CurrentWarrant = {
			Reason = GAMEMODE.Player:GetGameVar( pPlayer, "warrant_reason", "unknown" ),
			WarrantBy = GAMEMODE.Player:GetGameVar( pPlayer, "warrant_by", "unknown" ),
		}
	else
		saveTable.CurrentWarrant = nil
	end

	--Update current warrant data NOW
	if not bNoSave then
		--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "CurrentWarrant", saveTable.CurrentWarrant )
		GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "CurrentWarrant" )
	end
end

function GM.Jail:ClearPlayerWarrantData( pPlayer, bNoUpdate, bNoSave, bNoSend )
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "warrant", false, bNoSend )
	GAMEMODE.Player:SetGameVar( pPlayer, "warrant_reason", "", bNoSend )
	GAMEMODE.Player:SetGameVar( pPlayer, "warrant_by", "", bNoSend )

	if not bNoUpdate then
		self:UpdateCurrentWarrantData( pPlayer, true, bNoSave )
	end
end

--Player actions
function GM.Jail:PlayerWarrantPlayer( pPlayer, pWarrantPlayer, strReason )
	if not IsValid( pWarrantPlayer ) then return false end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) then return false end
	if not GAMEMODE.Cars:IsPlayerCarForJob( pPlayer, JOB_POLICE ) then return false end
	if pPlayer:GetVehicle() ~= GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer ) then return false end
	if strReason == "" then return false end
	if strReason:len() > GAMEMODE.Config.MaxWarrantReasonLength then return false end

	GAMEMODE.Player:SetSharedGameVar( pWarrantPlayer, "warrant", true )
	GAMEMODE.Player:SetGameVar( pWarrantPlayer, "warrant_reason", strReason )
	GAMEMODE.Player:SetGameVar( pWarrantPlayer, "warrant_by", pPlayer:Nick() )
	self:UpdateCurrentWarrantData( pWarrantPlayer )
	pPlayer:AddNote( "You placed a warrant on ".. pWarrantPlayer:Nick().. "!" )

	return true
end

function GM.Jail:PlayerRemovePlayerWarrant( pPlayer, pWarrantPlayer )
	if not IsValid( pWarrantPlayer ) then return false end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE )  then return false end
	if not GAMEMODE.Cars:IsPlayerCarForJob( pPlayer, JOB_POLICE )  then return false end
	if pPlayer:GetVehicle() ~= GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer ) then return false end
	if not self:PlayerHasWarrant( pWarrantPlayer ) then return false end
	
	self:ClearPlayerWarrantData( pWarrantPlayer )
	pPlayer:AddNote( "You removed the warrant for ".. pWarrantPlayer:Nick().. "!" )

	return true
end

--[[ Data Format For Cop Computer ]]--
function GM.Jail:GetCopComputerData( pPlayer )
	local data = {}
	if GAMEMODE.Player:GetSharedGameVar( pPlayer, "warrant" ) then
		data.Warrant = {
			WarrantBy = GAMEMODE.Player:GetGameVar( pPlayer, "warrant_by", "unknown" ),
			WarrantReason = GAMEMODE.Player:GetGameVar( pPlayer, "warrant_reason", "unknown" )
		}
	end

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if saveTable then
		data.ArrestRecord = saveTable.RapSheet or {}
	end
	
	return data
end

--[[ Game Vars ]]--
hook.Add( "GamemodeDefineGameVars", "DefineJailVars", function( pPlayer )
	--Jail
	GAMEMODE.Player:DefineSharedGameVar( pPlayer, "arrested", false, "Bool", true )
	GAMEMODE.Player:DefineGameVar( pPlayer, "arrest_start", 0, "UInt32", true )
	GAMEMODE.Player:DefineSharedGameVar( pPlayer, "arrest_duration", 0, "Float", true )
	GAMEMODE.Player:DefineGameVar( pPlayer, "arrest_reason", "", "String", true )
	GAMEMODE.Player:DefineGameVar( pPlayer, "arrested_by", "", "String", true )

	--Warrant
	GAMEMODE.Player:DefineSharedGameVar( pPlayer, "warrant", false, "Bool", true )
	GAMEMODE.Player:DefineGameVar( pPlayer, "warrant_reason", "", "String", true )
	GAMEMODE.Player:DefineGameVar( pPlayer, "warrant_by", "", "String", true )
end )

hook.Add( "GamemodePlayerSelectCharacter", "ApplyJailVars", function( pPlayer )
	GAMEMODE.Jail:ApplyCurrentArrestData( pPlayer )
	GAMEMODE.Jail:ApplyCurrentWarrantData( pPlayer )
end )