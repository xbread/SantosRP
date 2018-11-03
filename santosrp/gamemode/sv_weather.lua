GM.Weather = {}
GM.Weather.m_tblTypes = (GAMEMODE or GM).m_tblTypes or {}
GM.Weather.m_tblActiveTypes = (GAMEMODE or GM).m_tblTypes or {}

function GM.Weather:LoadTypes()
	GM:PrintDebug( 0, "->LOADING WEATHER TYPES" )

	local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "weather_types/*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		AddCSLuaFile( GM.Config.GAMEMODE_PATH.. "weather_types/".. v )
		include( GM.Config.GAMEMODE_PATH.. "weather_types/".. v )
	end

	GM:PrintDebug( 0, "->WEATHER TYPES LOADED" )
end

function GM.Weather:RegisterType( tblWeatherType )
	if self.m_tblTypes[tblWeatherType.ID] then return end
	self.m_tblTypes[tblWeatherType.ID] = tblWeatherType
end

function GM.Weather:GetType( strTypeID )
	return self.m_tblTypes[strTypeID]
end

function GM.Weather:IsTypeRunning( strTypeID )
	return self.m_tblActiveTypes[strTypeID] and true
end

function GM.Weather:GetActiveTypeData( strTypeID )
	return self.m_tblActiveTypes[strTypeID]
end

function GM.Weather:StartType( strTypeID, intRunTime )
	local timeOffset = 0
	self.m_tblActiveTypes[strTypeID] = {
		Start = CurTime(),
		RunTime = intRunTime,
		Offset = 0,
	}

	self.m_tblTypes[strTypeID]:Start( CurTime(), intRunTime, timeOffset )
	GAMEMODE.Net:BroadcastWeatherStart( strTypeID )
end

function GM.Weather:StopType( strTypeID )
	self.m_tblActiveTypes[strTypeID] = nil
	self.m_tblTypes[strTypeID]:Stop()
	GAMEMODE.Net:BroadcastWeatherStop( strTypeID )
end

function GM.Weather:HasRunningTypes()
	return table.Count( self.m_tblActiveTypes ) > 0
end

function GM.Weather:PlayerInitialSpawn( pPlayer )
	
end

function GM.Weather:Tick()
	local time = CurTime()
	for typeID, data in pairs( self.m_tblActiveTypes ) do
		if data.RunTime == 0 then continue end
		if time > data.Start +data.RunTime then
			self:StopType( typeID )
			self.m_intLastRandomizerTime = CurTime() +math.random(
				GAMEMODE.Config.WeatherRandomizer_MinTime,
				GAMEMODE.Config.WeatherRandomizer_MaxTime
			)
		else
			if self.m_tblTypes[typeID].Think then
				self.m_tblTypes[typeID]:Think()
			end
		end
	end

	if self:HasRunningTypes() then return end
	if time < (self.m_intLastRandomizerTime or 0) then return end
	self:RunWeatherRandomizer()
end

function GM.Weather:RunWeatherRandomizer()
	local data, _ = table.Random( GAMEMODE.Config.WeatherTable )
	if data.Chance() then
		local len = math.random( data.MinTime, data.MaxTime )
		self.m_intLastRandomizerTime = CurTime() +len +10
		self:StartType( data.ID, len )
	else
		self.m_intLastRandomizerTime = CurTime() +math.random(
			GAMEMODE.Config.WeatherRandomizer_MinTime,
			GAMEMODE.Config.WeatherRandomizer_MaxTime
		)
	end
end

function GM.Weather:GamemodeUpdateMapLighting( ... )
	local time = CurTime()
	for typeID, data in pairs( self.m_tblActiveTypes ) do
		if not self.m_tblTypes[typeID].GamemodeUpdateMapLighting then continue end
		return self.m_tblTypes[typeID]:GamemodeUpdateMapLighting( ... )
	end
end

function GM.Weather:GamemodeOnSkyboxUpdate( ... )
	local time = CurTime()
	for typeID, data in pairs( self.m_tblActiveTypes ) do
		if not self.m_tblTypes[typeID].GamemodeOnSkyboxUpdate then continue end
		return self.m_tblTypes[typeID]:GamemodeOnSkyboxUpdate( ... )
	end
end

concommand.Add( "srp_dev_stop_weather", function( pPlayer, strCmd, tblArgs )
	if not IsValid( pPlayer ) or not pPlayer:IsSuperAdmin() then return end
	for k, v in pairs( GAMEMODE.Weather.m_tblActiveTypes ) do
		GAMEMODE.Weather:StopType( k )
	end
end )

hook.Add( "GamemodeOnPlayerReady", "SendWeatherUpdate", function( pPlayer )
	timer.Simple( 3, function()
		if not IsValid( pPlayer ) then return end
		GAMEMODE.Net:SendClientWeatherUpdate( pPlayer )
	end )
end )
