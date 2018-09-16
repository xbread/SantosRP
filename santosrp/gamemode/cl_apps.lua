--[[
	Name: cl_apps.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Apps = (GAMEMODE or GM).Apps or {}
GM.Apps.m_tblRegister = (GAMEMODE or GM).Apps.m_tblRegister or {}
GM.Apps.m_tblRegister_Computer = (GAMEMODE or GM).Apps.m_tblRegister_Computer or {}

function GM.Apps:Load()
	self:LoadComputerApps()
end

function GM.Apps:LoadComputerApps()
	GM:PrintDebug( 0, "->LOADING COMPUTER APPS" )

	local path = GM.Config.GAMEMODE_PATH.. "apps/computer/"
	local foundFiles, foundFolders = file.Find( path.. "*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( path.. v )
	end

	GM:PrintDebug( 0, "->COMPUTER APPS LOADED" )
end

function GM.Apps:Register( tblApp )
	self.m_tblRegister[tblApp.ID] = tblApp

	if tblApp.AppType == self.APP_COMPUTER then
		self.m_tblRegister_Computer[tblApp.ID] = self.m_tblRegister[tblApp.ID]
	end
end

function GM.Apps:GetApps()
	return self.m_tblRegister
end

function GM.Apps:GetApp( strID )
	return self.m_tblRegister[strID]
end

function GM.Apps:GetComputerApps()
	return self.m_tblRegister_Computer
end

function GM.Apps:GetComputerApp( strID )
	return self.m_tblRegister_Computer[strID]
end