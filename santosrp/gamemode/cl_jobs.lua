--[[
	Name: cl_jobs.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Jobs = (GAMEMODE or GM).Jobs or {}
GM.Jobs.m_tblJobs = (GAMEMODE or GM).m_tblJobs or {}

function GM.Jobs:LoadJobs()
	GM:PrintDebug( 0, "->LOADING JOBS" )

	local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "jobs/*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( GM.Config.GAMEMODE_PATH.. "jobs/".. v )
	end

	GM:PrintDebug( 0, "->JOBS LOADED" )
end

function GM.Jobs:Register( tblJob )
	self.m_tblJobs[tblJob.ID] = tblJob
	_G[tblJob.Enum] = tblJob.ID
	if tblJob.PlayerModel then
		self:PrecacheModels( tblJob.PlayerModel )
	end
	if tblJob.ClothingLockerExtraModels then
		for k, v in pairs( tblJob.ClothingLockerExtraModels ) do
			self:PrecacheModels( v )
		end
	end
end
function GM.Jobs:PrecacheModels( tblModels )
	if type( tblModels.Male ) == "string" then
		util.PrecacheModel( tblModels.Male )
		util.PrecacheModel( tblModels.Female )
	elseif type( tblModels.Male ) == "table" then
		util.PrecacheModel( tblModels.Male_Fallback )
		util.PrecacheModel( tblModels.Female_Fallback )
		for k, v in pairs( tblModels.Male ) do
			util.PrecacheModel( v )
		end
		for k, v in pairs( tblModels.Female ) do
			util.PrecacheModel( v )
		end
	end
end


function GM.Jobs:GetJobs()
	return self.m_tblJobs
end

function GM.Jobs:GetJobByID( intJobID )
	return self.m_tblJobs[intJobID]
end

function GM.Jobs:GetPlayerJob( pPlayer )
	if not IsValid( pPlayer ) or not pPlayer.Team then return end
	return self.m_tblJobs[pPlayer:Team()]
end

function GM.Jobs:GetPlayerJobID( pPlayer )
	return pPlayer:Team()
end

function GM.Jobs:PlayerHasJob( pPlayer )
	return self:GetPlayerJob( pPlayer ) and true or false
end

function GM.Jobs:PlayerIsJob( pPlayer, intJobID )
	return pPlayer:Team() == intJobID
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