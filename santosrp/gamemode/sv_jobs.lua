--[[
	Name: sv_jobs.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Jobs = (GAMEMODE or GM).Jobs or {}
GM.Jobs.m_tblJobs = (GAMEMODE or GM).Jobs.m_tblJobs or {}

function GM.Jobs:LoadJobs()
	GM:PrintDebug( 0, "->LOADING JOBS" )

	local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "jobs/*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( GM.Config.GAMEMODE_PATH.. "jobs/".. v )
		AddCSLuaFile( GM.Config.GAMEMODE_PATH.. "jobs/".. v )
	end

	GM:PrintDebug( 0, "->JOBS LOADED" )
end

function GM.Jobs:Register( tblJob )
	self.m_tblJobs[tblJob.ID] = tblJob
	_G[tblJob.Enum] = tblJob.ID
	team.SetUp( tblJob.ID, tblJob.Name, tblJob.TeamColor or Color(255, 255, 255, 255) )

	if tblJob.PlayerModel then
		if type( tblJob.PlayerModel.Male ) == "string" then
			util.PrecacheModel( tblJob.PlayerModel.Male )
			util.PrecacheModel( tblJob.PlayerModel.Female )
		elseif type( tblJob.PlayerModel.Male ) == "table" then
			util.PrecacheModel( tblJob.PlayerModel.Male_Fallback )
			util.PrecacheModel( tblJob.PlayerModel.Female_Fallback )

			for k, v in pairs( tblJob.PlayerModel.Male ) do
				util.PrecacheModel( v )
			end
			for k, v in pairs( tblJob.PlayerModel.Female ) do
				util.PrecacheModel( v )
			end
		end
	end
end

function GM.Jobs:GetJobs()
	return self.m_tblJobs
end

function GM.Jobs:GetJobByID( intJobID )
	return self.m_tblJobs[intJobID]
end

function GM.Jobs:SetPlayerJob( pPlayer, intJobID, bNoNote )
	if self:GetJobByID( intJobID ).WhitelistName then
		if not self:IsPlayerWhitelisted( pPlayer, intJobID ) then
			pPlayer:AddNote( "Apply For This Job @ CosmicGaming.Net" )
			return
		end
	end

	if hook.Call( "GamemodeCanPlayerSetJob", GAMEMODE, pPlayer, intJobID ) == false then
		return
	end

	if pPlayer.m_intJobID then --Player already has a job, call the switch job event on the old job first
		self:GetJobByID( pPlayer.m_intJobID ):OnPlayerQuitJob( pPlayer )
		hook.Call( "GamemodePlayerQuitJob", GAMEMODE, pPlayer, pPlayer.m_intJobID )
	end

	pPlayer.m_intJobID = intJobID
	pPlayer:SetTeam( intJobID )
	pPlayer.m_intJobTime = RealTime()

	self:GetJobByID( intJobID ):OnPlayerJoinJob( pPlayer ) --Call the switch job event on the new job

	if self:GetJobByID( intJobID ).PlayerSetModel then
		self:GetJobByID( intJobID ):PlayerSetModel( pPlayer )
	else --fallback to civ
		GAMEMODE.Jobs:GetJobByID( JOB_CIVILIAN ):PlayerSetModel( pPlayer )
	end

	hook.Call( "GamemodePlayerSetJob", GAMEMODE, pPlayer, intJobID )

	if not bNoNote then
		pPlayer:AddNote( "You are now a ".. self:GetJobByID(intJobID).Name.. "!" )
	end
	
	pPlayer:StripWeapons()
	GAMEMODE.Inv:RemoveJobItems( pPlayer )
	hook.Call( "PlayerLoadout", GAMEMODE, pPlayer )
end

function GM.Jobs:GetPlayerJob( pPlayer )
	return self.m_tblJobs[pPlayer.m_intJobID]
end

function GM.Jobs:GetPlayerJobID( pPlayer )
	return pPlayer.m_intJobID
end

function GM.Jobs:GetPlayerJobEnum( pPlayer )
	return self:GetPlayerJob( pPlayer ).Enum
end

function GM.Jobs:PlayerHasJob( pPlayer )
	return pPlayer.m_intJobID and true or false
end

function GM.Jobs:PlayerIsJob( pPlayer, intJobID )
	return pPlayer.m_intJobID == intJobID
end

function GM.Jobs:GetNumPlayers( intJobID )
	local count = 0
	for k, v in pairs( player.GetAll() ) do
		if self:GetPlayerJobID( v ) == intJobID then
			count = count +1
		end
	end

	return count
end

function GM.Jobs:IsPlayerWhitelisted( pPlayer, intJobID )
	local ret = hook.Call( "GamemodeIsPlayerJobWhitelisted", GAMEMODE, pPlayer, intJobID )
	if ret ~= nil then
		return ret
	end
	
	--fallback to flat files if the above hook returns nothing
	local jobData = self:GetJobByID( intJobID )
	local data = util.KeyValuesToTable( file.Read("taloslife/job_whitelists/list_".. jobData.WhitelistName.. ".txt", "DATA") or "" )
	if not data or not table.HasValue( data, pPlayer:SteamID() ) then return false end
	return true
end

function GM.Jobs:WhitelistPlayer( pPlayer, intJobID )
	if not file.IsDir( "santosrp", "DATA" ) then file.CreateDir( "santosrp" ) end
	if not file.IsDir( "taloslife/job_whitelists", "DATA" ) then file.CreateDir( "taloslife/job_whitelists" ) end

	local jobData = self:GetJobByID( intJobID )
	local data = util.KeyValuesToTable( file.Read("taloslife/job_whitelists/list_".. jobData.WhitelistName.. ".txt", "DATA") or "" )
	
	data = data or {}
	data[pPlayer:RealNick()] = pPlayer:SteamID()
	file.Write( "taloslife/job_whitelists/list_".. jobData.WhitelistName.. ".txt", util.TableToKeyValues(data) )
end

function GM.Jobs:GetPlayerPay( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return 0 end

	local jobData = self:GetPlayerJob( pPlayer )
	local pay = 0
	for k, v in ipairs( jobData.Pay ) do
		if v.PlayTime > (saveTable.JobTimes and saveTable.JobTimes[jobData.ID] or 0) then continue end
		if v.Pay > pay then pay = v.Pay end
	end

	return pay
end

function GM.Jobs:UpdateSavedPlayTime( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	saveTable.JobTimes = saveTable.JobTimes or {}
	local jobID = self:GetPlayerJobID( pPlayer )

	saveTable.JobTimes[jobID] = saveTable.JobTimes[jobID] or 0
	local lastPay = self:GetPlayerPay( pPlayer )
	saveTable.JobTimes[jobID] = saveTable.JobTimes[jobID] +(RealTime() -pPlayer.m_intJobTime)
	local newPay = self:GetPlayerPay( pPlayer )
	pPlayer.m_intJobTime = RealTime()

	if newPay ~= lastPay then
		pPlayer:AddNote( "You have played this job for over ".. math.Round(saveTable.JobTimes[jobID] /60).. " minutes!" )
		pPlayer:AddNote( "You have been promoted for your hard work! You now make $".. string.Comma(newPay).. " working this job." )
	end

	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "JobTimes" )
end

function GM.Jobs:GetTotalSavedPlayTime( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.JobTimes then return 0 end
	
	local ret = 0
	for k, v in pairs( saveTable.JobTimes ) do
		ret = ret +v
	end
	return ret
end

function GM.Jobs:GetSavedPlayTime( pPlayer, intJobID )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.JobTimes then return 0 end
	return saveTable.JobTimes[intJobID] or 0
end

function GM.Jobs:CalcJobPlayerCap( intJobID )
	local data = self.m_tblJobs[intJobID]
	if not data then return end
	
	local curPlayers = #player.GetAll()
	local minP, maxP = data.PlayerCap.Min, data.PlayerCap.Max
	local minS, maxE = data.PlayerCap.MinStart, data.PlayerCap.MaxEnd

	if curPlayers <= minS then
		return minP
	elseif curPlayers >= maxE then
		return maxP
	else
		local scalar = (curPlayers -minS) /(maxE -minS)
		return math.ceil( (maxP -minP) *scalar +minP )
	end
end

function GM.Jobs:Tick()
	if not GAMEMODE.Config.JobPayInterval then return end
	if not self.m_intLastPlayTimeThink then self.m_intLastPlayTimeThink = CurTime() +30 end
	if CurTime() > self.m_intLastPlayTimeThink then
		for k, v in pairs( player.GetAll() ) do
			if not self:GetPlayerJobID( v ) then continue end
			self:UpdateSavedPlayTime( v )
		end

		self.m_intLastPlayTimeThink = CurTime() +30
	end

	if not self.m_intLastPayThink then self.m_intLastPayThink = CurTime() +GAMEMODE.Config.JobPayInterval end
	if CurTime() < self.m_intLastPayThink then return end
	self.m_intLastPayThink = CurTime() +GAMEMODE.Config.JobPayInterval

	for k, v in pairs( player.GetAll() ) do
		if not self:PlayerHasJob( v ) then continue end

		local pay = self:GetPlayerPay( v )
		local payt = GAMEMODE.Econ:ApplyTaxToSum( "income_".. self:GetPlayerJobID(v), pay, true )

		v:AddBankMoney( payt )
		v:AddNote( "You received a paycheck from your job!" )
		v:AddNote( "$".. string.Comma(payt).. " (".. 100 *GAMEMODE.Econ:GetTaxRate("income_".. self:GetPlayerJobID(v)).. "% tax) was transfered to your bank account." )
	end
end

concommand.Add( "srp_admin_whitelist_player", function( pPlayer, strCmd, tblArgs )
	if not pPlayer:IsSuperAdmin() then return end
	local targetName = tblArgs[1] or ""
	local jobID = tblArgs[2] and tonumber( tblArgs[2] ) or nil

	if not jobID then
		return
	end

	for k, v in pairs( player.GetAll() ) do
		if v:Nick():lower():find( targetName:lower() ) then
			if GAMEMODE.Jobs:IsPlayerWhitelisted( v, jobID ) then
				--
				return
			end

			GAMEMODE.Jobs:WhitelistPlayer( v, jobID )
			return
		end
	end
end )