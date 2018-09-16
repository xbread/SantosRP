--[[
	Name: cl_weather.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Weather = {}
GM.Weather.m_tblTypes = (GAMEMODE or GM).m_tblTypes or {}
GM.Weather.m_tblActiveTypes = (GAMEMODE or GM).m_tblTypes or {}

function GM.Weather:LoadTypes()
	GM:PrintDebug( 0, "->LOADING WEATHER TYPES" )

	local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "weather_types/*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
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

function GM.Weather:HasRunningTypes()
	return table.Count( self.m_tblActiveTypes ) > 0
end

function GM.Weather:StartType( strTypeID, intStartTime, intRunTime )
	local timeOffset = math.max( CurTime() -intStartTime, 0 )
	self.m_tblActiveTypes[strTypeID] = {
		Start = intStartTime,
		RunTime = intRunTime,
		Offset = timeOffset,
	}

	self.m_tblTypes[strTypeID]:Start( intStartTime, intRunTime, timeOffset )
end

function GM.Weather:StopType( strTypeID )
	self.m_tblActiveTypes[strTypeID] = nil
	self.m_tblTypes[strTypeID]:Stop()
end

function GM.Weather:Think()
	for typeID, data in pairs( self.m_tblActiveTypes ) do
		if not self.m_tblTypes[typeID].Think then continue end
		self.m_tblTypes[typeID]:Think()
	end
end

function GM.Weather:PostDrawTranslucentRenderables()
	for typeID, data in pairs( self.m_tblActiveTypes ) do
		if not self.m_tblTypes[typeID].PostDrawTranslucentRenderables then continue end
		self.m_tblTypes[typeID]:PostDrawTranslucentRenderables()
	end
end

function GM.Weather:RenderScreenspaceEffects()
	for typeID, data in pairs( self.m_tblActiveTypes ) do
		if not self.m_tblTypes[typeID].RenderScreenspaceEffects then continue end
		self.m_tblTypes[typeID]:RenderScreenspaceEffects()
	end
end

function GM.Weather:GamemodeSetupWorldFog( ... )
	if not GAMEMODE.Config.FogLightingEnabled then return end
	
	for typeID, data in pairs( self.m_tblActiveTypes ) do
		if not self.m_tblTypes[typeID].GamemodeSetupWorldFog then continue end
		return self.m_tblTypes[typeID]:GamemodeSetupWorldFog( ... )
	end
end

function GM.Weather:GamemodeSetupSkyboxFog( ... )
	if not GAMEMODE.Config.FogLightingEnabled then return end
	
	for typeID, data in pairs( self.m_tblActiveTypes ) do
		if not self.m_tblTypes[typeID].GamemodeSetupSkyboxFog then continue end
		return self.m_tblTypes[typeID]:GamemodeSetupSkyboxFog( ... )
	end
end