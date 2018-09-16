--[[
	Name: cl_player.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Player = (GAMEMODE or GM).Player or {}
GM.Player.m_tblGameVars = (GAMEMODE or GM).Player.m_tblGameVars or {}
GM.Player.m_tblPlayerSharedVars = (GAMEMODE or GM).Player.m_tblPlayerSharedVars or {}
GM.Player.m_tblSharedGameVars = (GAMEMODE or GM).Player.m_tblSharedGameVars or {}
GM.Player.m_tblInventory = (GAMEMODE or GM).Player.m_tblInventory or {}

function GM.Player:Initialize()
	self:DefineGameVars()
end

function GM.Player:DefineGameVars()
	hook.Call( "GamemodeDefineGameVars", GAMEMODE )
end

function GM.Player:OnEntityCreated( eEnt )
	if not eEnt:IsPlayer() then return end
	self:SetupGamemodeData( eEnt )
	GAMEMODE.Inv:ApplyPACModels( eEnt )
end

function GM.Player:EntityRemoved( strSID64 )
	if self.m_tblPlayerSharedVars[strSID64] then
		self.m_tblPlayerSharedVars[strSID64] = nil
	end
end

function GM.Player:SetupGamemodeData( pPlayer )
	--pPlayer.m_tblGamemodeData = {
	--	SharedGameVars = table.Copy( self.m_tblSharedGameVars ),
	--}

	--GAMEMODE:PrintDebug( 0, "SetupGamemodeData for ".. tostring(pPlayer) )
end

--Game vars, these network only when changed, and are defined first with a type for better networking
--Game vars must be defind on the server AND the client!
function GM.Player:DefineGameVar( strVar, vaValue, strType )
	if self.m_tblGameVars[strVar] then return end
	self.m_tblGameVars[strVar] = { Type = strType, Value = vaValue }
	GAMEMODE:PrintDebug( 0, "Game var ".. strVar.. " was defined." )
end

function GM.Player:GetGameVarType( strVar )
	return self.m_tblGameVars[strVar].Type
end

function GM.Player:GetGameVar( strVar, vaFallback )
	if not self.m_tblGameVars[strVar] then return vaFallback end
	return self.m_tblGameVars[strVar].Value
end

function GM.Player:SetGameVar( strVar, vaValue )
	if not self.m_tblGameVars[strVar] then return end
	hook.Call( "GamemodeGameVarChanged", GAMEMODE, strVar, self.m_tblGameVars[strVar], vaValue )
	self.m_tblGameVars[strVar].Value = vaValue

	GAMEMODE:PrintDebug( 0, "Game var ".. strVar.. " was set to ".. tostring(vaValue) )
end

--Shared game vars, these network only when changed, and are defined first with a type for better networking
--Shared game vars must be defind on the server AND the client!
--Shared game vars are sent to ALL clients
function GM.Player:DefineSharedGameVar( strVar, vaValue, strType )
	if self.m_tblSharedGameVars[strVar] then return end
	self.m_tblSharedGameVars[strVar] = { Type = strType, Value = vaValue }
	GAMEMODE:PrintDebug( 0, tostring(pPlayer).. "::Shared game var ".. strVar.. " was defined." )
end

function GM.Player:GetSharedGameVarType( strVar )
	return self.m_tblSharedGameVars[strVar].Type
end

function GM.Player:GetSharedGameVar( pPlayer, strVar, vaFallback )
	if not IsValid( pPlayer ) or not pPlayer:SteamID64() then return vaFallback end
	
	if not self.m_tblPlayerSharedVars[pPlayer:SteamID64()] then
		self.m_tblPlayerSharedVars[pPlayer:SteamID64()] = table.Copy( self.m_tblSharedGameVars )
	end

	if not self.m_tblPlayerSharedVars[pPlayer:SteamID64()][strVar] then return vaFallback end
	return self.m_tblPlayerSharedVars[pPlayer:SteamID64()][strVar].Value
end

function GM.Player:SetSharedGameVar( strSID64, strVar, vaValue )
	if not self.m_tblPlayerSharedVars[strSID64] then 
		self.m_tblPlayerSharedVars[strSID64] = table.Copy( self.m_tblSharedGameVars )
	end
	if not self.m_tblPlayerSharedVars[strSID64][strVar] then return end

	local pl = player.GetBySteamID64( strSID64 ) or nil
	local oldVal = self.m_tblPlayerSharedVars[strSID64][strVar].Value
	self.m_tblPlayerSharedVars[strSID64][strVar].Value = vaValue

	if IsValid( pl ) then
		hook.Call( "GamemodeSharedGameVarChanged", GAMEMODE,
			pl,
			strVar,
			oldVal,
			vaValue
		)
	end
	
	GAMEMODE:PrintDebug( 0, "Shared game var ".. strVar.. " was set to ".. tostring(vaValue) )
end

-- ----------------------------------------------------------------
-- Player meta functions
-- ----------------------------------------------------------------
local pmeta = debug.getregistry().Player
function pmeta:GetInventory()
	if self ~= LocalPlayer() then return end
	return GAMEMODE.Player.m_tblInventory
end

function pmeta:SetInventory( tblItems )
	if self ~= LocalPlayer() then return end
	GAMEMODE.Player.m_tblInventory = tblItems
end

function pmeta:GetMoney()
	if self ~= LocalPlayer() then return end
	return GAMEMODE.Player:GetGameVar( "money_wallet", 0 )
end

function pmeta:GetBankMoney()
	if self ~= LocalPlayer() then return end
	return GAMEMODE.Player:GetGameVar( "money_bank", 0 )
end

function pmeta:CanAfford( intAmount )
	if self ~= LocalPlayer() then return end
	return self:GetMoney() -intAmount >= 0
end

function pmeta:GetCharacters()
	if self ~= LocalPlayer() then return end
	return GAMEMODE.Char:GetPlayerCharacters( self )
end

function pmeta:GetCharacter()
	if self ~= LocalPlayer() then return end
	return GAMEMODE.Char:GetPlayerCharacters( self )[GAMEMODE.Player:GetSharedGameVar(self, "char_id", 0)]
end

function pmeta:GetCharacterID()
	return GAMEMODE.Player:GetSharedGameVar( self, "char_id" )
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

-- THIS IS GSPEAK 2 WORK

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

-- GPSEAK ABOVE

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