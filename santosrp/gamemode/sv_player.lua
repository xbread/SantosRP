--[[
	Name: sv_player.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Player = (GAMEMODE or GM).Player or {}
GM.Player.m_tblPlayerData = (GAMEMODE or GM).Player.m_tblPlayerData or {}

function GM.Player:InitialSpawn( pPlayer )
end

function GM.Player:Spawn( pPlayer )
	--This player just spawned or hasn't picked a character
	if not pPlayer.m_bGamemodeDataLoaded or not GAMEMODE.Char:GetPlayerCharacter( pPlayer ) then
		GAMEMODE:PlayerSpawnAsSpectator( pPlayer )
		pPlayer:Freeze( true )
		pPlayer:AllowFlashlight( false )
		return
	end

	pPlayer:UnSpectate()
	pPlayer:Freeze( false )
	pPlayer:InitializeHands( "male07" )
	pPlayer:AllowFlashlight( true )
	self:UpdatePlayerMoveSpeed( pPlayer )

	if not GAMEMODE.Jobs:PlayerHasJob( pPlayer ) then
		GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_CIVILIAN, true ) --This shouldn't be needed, but just in case
	else --Setjob calls loadout, so do this so it doesn't happen twice in this case
		hook.Call( "PlayerLoadout", GAMEMODE, pPlayer )

		if GAMEMODE.Jobs:GetPlayerJob( pPlayer ).PlayerSetModel then
			GAMEMODE.Jobs:GetPlayerJob( pPlayer ):PlayerSetModel( pPlayer )
		else --fallback to civ
			GAMEMODE.Jobs:GetJobByID( JOB_CIVILIAN ):PlayerSetModel( pPlayer )
		end
	end

	--Find a spot to put them
	local foundSpot
	for k, v in pairs( GAMEMODE.Config.SpawnPoints ) do
		local found = ents.FindInSphere( v, 48 )
		for idx, ent in pairs( found ) do
			if GAMEMODE.Util.m_tblIgnoreSpawnEnts[ent:GetClass()] then
				found[idx] = nil
			end
		end

		if table.Count( found ) == 0 then foundSpot = v break end
	end

	if not foundSpot then
		local vec, _ = table.Random( GAMEMODE.Config.SpawnPoints )
		foundSpot = vec
	end

	pPlayer:SetPos( foundSpot )
	pPlayer:SetHealth( 100 )
end

function GM.Player:Loadout( pPlayer )
	local job = GAMEMODE.Jobs:GetPlayerJob( pPlayer )
	if not job then return end

	for k, v in pairs( GAMEMODE.Config.GlobalLoadout ) do
		pPlayer:Give( v )
	end
	
	job:PlayerLoadout( pPlayer )
	GAMEMODE.Inv:PlayerLoadout( pPlayer )

	pPlayer:SelectWeapon( "weapon_srphands" )
end

function GM.Player:PlayerDeath( pPlayer )
	self:ClearMoveSpeedModifiers( pPlayer )
end

-- ----------------------------------------------------------------
-- Player move speed modifiers
-- ----------------------------------------------------------------
function GM.Player:UpdatePlayerMoveSpeed( pPlayer )
	local newWalk, newRun = GAMEMODE.Config.DefWalkSpeed, GAMEMODE.Config.DefRunSpeed

	if pPlayer.m_tblSpeedFlags then
		for k, v in pairs( pPlayer.m_tblSpeedFlags ) do
			newWalk = newWalk +v[1]
			newRun = newRun +v[2]
		end
	end

	if newWalk > newRun then
		newRun = newWalk
	end

	pPlayer:SetWalkSpeed( math.max(newWalk, 45) )
	pPlayer:SetRunSpeed( math.max(newRun, 45) )
end

function GM.Player:ModifyMoveSpeed( pPlayer, strModifierID, intWalkMod, intRunMod )
	if not pPlayer.m_tblSpeedFlags then pPlayer.m_tblSpeedFlags = {} end
	pPlayer.m_tblSpeedFlags[strModifierID] = { intWalkMod, intRunMod }
	self:UpdatePlayerMoveSpeed( pPlayer )
end

function GM.Player:GetMoveSpeedModifier( pPlayer, strModifierID )
	if not pPlayer.m_tblSpeedFlags then return end
	return pPlayer.m_tblSpeedFlags[strModifierID]
end

function GM.Player:IsMoveSpeedModifierActive( pPlayer, strModifierID )
	if not pPlayer.m_tblSpeedFlags then return false end
	return pPlayer.m_tblSpeedFlags[strModifierID] and true
end

function GM.Player:RemoveMoveSpeedModifier( pPlayer, strModifierID, bNoUpdate )
	if not pPlayer.m_tblSpeedFlags then return end
	pPlayer.m_tblSpeedFlags[strModifierID] = nil
	if not bNoUpdate then self:UpdatePlayerMoveSpeed( pPlayer ) end
end

function GM.Player:ClearMoveSpeedModifiers( pPlayer )
	if not pPlayer.m_tblSpeedFlags then return end
	for k, v in pairs( pPlayer.m_tblSpeedFlags ) do
		self:RemoveMoveSpeedModifier( pPlayer, k, true )
	end

	self:UpdatePlayerMoveSpeed( pPlayer )
end

-- ----------------------------------------------------------------
-- Player gamemode data
-- ----------------------------------------------------------------
function GM.Player:PlayerReadyForData( pPlayer )
	if pPlayer.m_bGamemodeDataLoaded then return end
	pPlayer.m_bGamemodeDataLoaded = true

	GAMEMODE:PrintDebug( 0, tostring(pPlayer).. " is ready to load game data." )

	self:LoadGameData( pPlayer, function()
		if not IsValid( pPlayer ) then return end --wow, lamer
		GAMEMODE:PrintDebug( 0, tostring(pPlayer).. " had their game data loaded." )
		hook.Call( "GamemodeOnPlayerReady", GAMEMODE, pPlayer )

		--send them all of their characters in a short format for view in the selection menu
		GAMEMODE.Net:SendPlayerCharacters( pPlayer )
	end )
end

function GM.Player:GetData( strSID64 )
	return self.m_tblPlayerData[strSID64]
end

function GM.Player:LoadGameData( pPlayer, funcCallback )
	local dataProto = {
		Characters = {}, --Load this
		GameVars = {}, --Shared vars from server to this client
		SharedGameVars = {}, --Shared vars from server to all clients about this client
	}

	self.m_tblPlayerData[pPlayer:SteamID64()] = dataProto

	GAMEMODE.SQL:LoadPlayerID( pPlayer, function( intID )
		if not IsValid( pPlayer ) then return end
		
		pPlayer:SetPlayerSQLID( intID )
		GAMEMODE.SQL:LoadPlayerCharacters( pPlayer, function( tblCharacters )
			if not IsValid( pPlayer ) then return end
			self.m_tblPlayerData[pPlayer:SteamID64()].Characters = tblCharacters
			self:DefineGameVars( pPlayer )
			funcCallback()
		end )
	end )
end

function GM.Player:DefineGameVars( pPlayer )
	hook.Call( "GamemodeDefineGameVars", {}, pPlayer )
end

--Game vars, these network only when changed, and are defined first with a type for better networking
--Game vars must be defind on the server AND the client!
function GM.Player:DefineGameVar( pPlayer, strVar, vaValue, strType, bDontNetwork )
	if not pPlayer:GetGamemodeData() then return end
	pPlayer:GetGamemodeData().GameVars[strVar] = { Type = strType, Value = vaValue, Defualt = vaValue }

	if not bDontNetwork then
		GAMEMODE.Net:UpdateGameVar( pPlayer, strVar )
	end

	GAMEMODE:PrintDebug( 0, tostring(pPlayer).. "::Game var ".. strVar.. " was defined." )
end

function GM.Player:GetGameVarType( pPlayer, strVar )
	if not pPlayer:GetGamemodeData() then return end
	if not pPlayer:GetGamemodeData().GameVars[strVar] then return end
	return pPlayer:GetGamemodeData().GameVars[strVar].Type
end

function GM.Player:GetGameVar( pPlayer, strVar, vaFallback )
	if not pPlayer:GetGamemodeData() then return vaFallback end
	if not pPlayer:GetGamemodeData().GameVars[strVar] then return vaFallback end
	return pPlayer:GetGamemodeData().GameVars[strVar].Value
end

function GM.Player:SetGameVar( pPlayer, strVar, vaValue, bDontNetwork )
	if not pPlayer:GetGamemodeData() then return end
	if not pPlayer:GetGamemodeData().GameVars[strVar] then return end
	pPlayer:GetGamemodeData().GameVars[strVar].Value = vaValue

	if not bDontNetwork then
		GAMEMODE.Net:UpdateGameVar( pPlayer, strVar )
	end
	
	GAMEMODE:PrintDebug( 0, tostring(pPlayer).. "::Game var ".. strVar.. " was set to ".. tostring(vaValue) )
end

--Shared game vars, these network only when changed, and are defined first with a type for better networking
--Shared game vars must be defind on the server AND the client!
--Shared game vars are sent to ALL clients
function GM.Player:DefineSharedGameVar( pPlayer, strVar, vaValue, strType, bDontNetwork )
	if not pPlayer:GetGamemodeData() then return end
	pPlayer:GetGamemodeData().SharedGameVars[strVar] = { Type = strType, Value = vaValue, Defualt = vaValue }

	if not bDontNetwork then
		GAMEMODE.Net:UpdateSharedGameVar( pPlayer, strVar )
	end

	GAMEMODE:PrintDebug( 0, tostring(pPlayer).. "::Shared game var ".. strVar.. " was defined." )
end

function GM.Player:GetSharedGameVarType( pPlayer, strVar )
	if not pPlayer:GetGamemodeData() then return end
	if not pPlayer:GetGamemodeData().SharedGameVars[strVar] then return end
	return pPlayer:GetGamemodeData().SharedGameVars[strVar].Type
end

function GM.Player:GetSharedGameVar( pPlayer, strVar, vaFallback )
	if not pPlayer:GetGamemodeData() then return vaFallback end
	if not pPlayer:GetGamemodeData().SharedGameVars[strVar] then return vaFallback end
	return pPlayer:GetGamemodeData().SharedGameVars[strVar].Value
end

function GM.Player:SetSharedGameVar( pPlayer, strVar, vaValue, bDontNetwork )
	if not pPlayer:GetGamemodeData() then return end
	if not pPlayer:GetGamemodeData().SharedGameVars[strVar] then return end
	pPlayer:GetGamemodeData().SharedGameVars[strVar].Value = vaValue

	if not bDontNetwork then
		GAMEMODE.Net:UpdateSharedGameVar( pPlayer, strVar )
	end
	
	GAMEMODE:PrintDebug( 0, tostring(pPlayer).. "::Shared game var ".. strVar.. " was set to ".. tostring(vaValue) )
end

-- ----------------------------------------------------------------
-- Player meta functions
-- ----------------------------------------------------------------
local pmeta = debug.getregistry().Player
function pmeta:GetGamemodeData()
	return GAMEMODE.Player:GetData( self:SteamID64() )
end

function pmeta:GetCharacters()
	return GAMEMODE.Char:GetPlayerCharacters( self )
end

function pmeta:GetCharacter()
	return GAMEMODE.Char:GetPlayerCharacter( self )
end

function pmeta:HasValidCharacter()
	if not self:GetGamemodeData() then return false end
	return GAMEMODE.Char:GetPlayerCharacter( self ) and true or false
end

function pmeta:GetCharacterID()
	if not self:GetGamemodeData() then return end
	return self:GetGamemodeData().SelectedCharacter
end

function pmeta:GetInventory()
	if not self:HasValidCharacter() then return end
	return self:GetCharacter().Inventory
end

function pmeta:GetEquipment()
	if not self:HasValidCharacter() then return end
	return self:GetCharacter().Equipped
end

function pmeta:GetEquipSlot( strSlotName )
	if not self:HasValidCharacter() then return end
	return self:GetCharacter().Equipped[strSlotName]
end

function pmeta:GetMoney()
	if not self:HasValidCharacter() then return end
	return self:GetCharacter().Money.Wallet
end

function pmeta:AddMoney( intAmount )
	if not self:HasValidCharacter() then return false end
	local char = self:GetGamemodeData().Characters[self:GetCharacterID()]
	char.Money.Wallet = char.Money.Wallet +intAmount
	GAMEMODE.Player:SetGameVar( self, "money_wallet", char.Money.Wallet )
	GAMEMODE.SQL:MarkDiffDirty( self, "money_wallet" )

	return true
end

function pmeta:TakeMoney( intAmount )
	if not self:HasValidCharacter() then return false end
	local char = self:GetGamemodeData().Characters[self:GetCharacterID()]

	if char.Money.Wallet -intAmount < 0 then return false end
	char.Money.Wallet = char.Money.Wallet -intAmount
	GAMEMODE.Player:SetGameVar( self, "money_wallet", char.Money.Wallet )
	GAMEMODE.SQL:MarkDiffDirty( self, "money_wallet" )

	return true
end

function pmeta:CanAfford( intAmount )
	if not self:HasValidCharacter() then return false end
	return self:GetMoney() -intAmount >= 0
end

function pmeta:GetBankMoney()
	if not self:HasValidCharacter() then return end
	return self:GetCharacter().Money.Bank
end

function pmeta:AddBankMoney( intAmount )
	if not self:HasValidCharacter() then return false end
	local char = self:GetGamemodeData().Characters[self:GetCharacterID()]
	char.Money.Bank = char.Money.Bank +intAmount
	GAMEMODE.Player:SetGameVar( self, "money_bank", char.Money.Bank )
	GAMEMODE.SQL:MarkDiffDirty( self, "money_bank" )

	return true
end

function pmeta:TakeBankMoney( intAmount )
	if not self:HasValidCharacter() then return false end
	local char = self:GetGamemodeData().Characters[self:GetCharacterID()]

	if char.Money.Bank -intAmount < 0 then return false end
	char.Money.Bank = char.Money.Bank -intAmount
	GAMEMODE.Player:SetGameVar( self, "money_bank", char.Money.Bank )
	GAMEMODE.SQL:MarkDiffDirty( self, "money_bank" )
	
	return true
end

function pmeta:GetTalkingNPC()
	return self.m_entTalkingNPC
end

function pmeta:WithinTalkingRange()
	if not IsValid( self:GetTalkingNPC() ) then return false end
	return self:GetPos():Distance( self:GetTalkingNPC():GetPos() ) <= 200
end

function pmeta:AddNote( strMsg, intIcon, intDuration )
	GAMEMODE.Net:SendHint( self, strMsg, intIcon, intDuration )
end

function pmeta:IsIncapacitated()
	if not self:Alive() then return true end
	if self:IsRagdolled() then return true end
	if self:HasWeapon( "weapon_handcuffed" ) or self:HasWeapon( "weapon_ziptied" ) then return true end
	if GAMEMODE.Jail:IsPlayerInJail( self ) then return true end
	return false
end

g_OldNick = g_OldNick or pmeta.Nick
pmeta.RealNick = g_OldNick
function pmeta:Nick()
	local first = GAMEMODE.Player:GetSharedGameVar( self, "name_first" )
	local last = GAMEMODE.Player:GetSharedGameVar( self, "name_last" )

	if not first or first == "" then
		return g_OldNick( self )
	else
		return first.. " ".. last
	end
end

g_OldName = g_OldName or pmeta.Name
pmeta.RealName = g_OldNick
function pmeta:Name()
	local first = GAMEMODE.Player:GetSharedGameVar( self, "name_first" )
	local last = GAMEMODE.Player:GetSharedGameVar( self, "name_last" )

	if not first or first == "" then
		return g_OldName( self )
	else
		return first.. " ".. last
	end
end
--- THIS IS GSPEAK 2 WORK

g_OldGetName = g_OldGetName or pmeta.GetName
pmeta.RealGetName = g_OldGetName
function pmeta:GetName()
	local first = GAMEMODE.Player:GetSharedGameVar( self, "name_first" )
	local last = GAMEMODE.Player:GetSharedGameVar( self, "name_last" )

	if not first or first == "" then
		return g_OldGetName( self )
	else
		return first.. " ".. last
	end
end

-- THIS IS GSPEAK 2 WORK

--[[g_IsSuperAdmin = g_IsSuperAdmin or pmeta.IsSuperAdmin
function pmeta:IsSuperAdmin( ... )
	if self:CheckGroup( "community_manager" ) then
		return true
	end

	return g_IsSuperAdmin( self, ... )
end]]--

g_CheckGroup = g_CheckGroup or pmeta.CheckGroup
if g_CheckGroup then
	function pmeta:CheckGroup( strName, ... )
		if strName == "vip" and GAMEMODE.Config.VIPGroups[self:GetUserGroup()] then
			return true
		end

		return g_CheckGroup( self, strName, ... )
	end
end

concommand.Add( "srp_dev_give_money", function( pPlayer, strCmd, tblArgs )
	if not pPlayer:IsSuperAdmin() then return end
	local amount = math.max( tonumber(tblArgs[1] or 0), 0 )
	pPlayer:AddMoney( amount )
end )

concommand.Add( "srp_dev_remove", function( pPlayer, strCmd, tblArgs )
	if not pPlayer:IsAdmin() then return end
	local trEnt = pPlayer:GetEyeTrace().Entity

	if IsValid( trEnt ) and not trEnt:IsPlayer() then
		trEnt:Remove()
	end
end )

concommand.Add( "srp_dev_change_player_name", function( pPlayer, strCmd, tblArgs )
	if not pPlayer:IsSuperAdmin() then return end
	local targetSID = tostring( tblArgs[1] or "" )

	local foundPlayer
	for k, v in pairs( player.GetAll() ) do
		if v:SteamID() == targetSID then
			foundPlayer = v
			break
		end
	end	

	if not IsValid( foundPlayer ) then
		pPlayer:PrintMessage( HUD_PRINTCONSOLE, "Unable to locate a player with that steam id!" )
		return
	end

	if not foundPlayer:HasValidCharacter() then
		pPlayer:PrintMessage( HUD_PRINTCONSOLE, "That player has not loaded a character yet!" )
		return
	end

	local nameFirst, nameLast = tostring( tblArgs[2] or "" ), tostring( tblArgs[3] or "" )

	if nameFirst:len() <= 0 or nameLast:len() <= 0 then
		pPlayer:PrintMessage( HUD_PRINTCONSOLE, "Cannot set a zero-length name!" )
		return
	end

	pPlayer:PrintMessage( HUD_PRINTCONSOLE, "Changing ".. foundPlayer:Nick().. "'s name to ".. nameFirst.. " ".. nameLast.. "!" )

	local id = GAMEMODE.SQL:GetPlayerPoolID( foundPlayer:SteamID64() )
	GAMEMODE.SQL:UpdateCharacterFirstName( id, foundPlayer:GetCharacterID(), nameFirst )
	GAMEMODE.SQL:UpdateCharacterLastName( id, foundPlayer:GetCharacterID(), nameLast )
	GAMEMODE.Player:SetSharedGameVar( foundPlayer, "name_first", nameFirst )
	GAMEMODE.Player:SetSharedGameVar( foundPlayer, "name_last", nameLast )	
	foundPlayer:GetCharacter().Name.First = nameFirst 
	foundPlayer:GetCharacter().Name.Last = nameLast
end )
