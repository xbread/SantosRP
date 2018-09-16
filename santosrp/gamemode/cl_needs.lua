--[[
	Name: cl_needs.lua
	For: TalosLife
	By: TalosLife 
]]--

GM.Needs = (GAMEMODE or GM).Needs or {}
GM.Needs.m_tblNeeds = (GAMEMODE or GM).Needs.m_tblNeeds or {}

function GM.Needs:Initialize()
	self:RegisterNeed( "Hunger", 500 )
	self:RegisterNeed( "Thirst", 500 )
	self:RegisterNeed( "Stamina", 100 )
end

function GM.Needs:RegisterNeed( strNeedID, intMaxAmount )
	self.m_tblNeeds[strNeedID] = {
		Max = intMaxAmount,
	}
end

function GM.Needs:GetNeed( strNeedID )
	return GAMEMODE.Player:GetGameVar( "need_".. strNeedID, 0 )
end

function GM.Needs:GetNeedData( strNeedID )
	return self.m_tblNeeds[strNeedID]
end

hook.Add( "GamemodeDefineGameVars", "DefineNeedVars", function( pPlayer )
	for k, v in pairs( GAMEMODE.Needs.m_tblNeeds ) do
		GAMEMODE.Player:DefineGameVar( "need_".. k, v.Max, "UInt16" )
	end
end )