--[[
	Name: cl_license.lua
	For: TalosLife
	By: TalosLife
]]--

GM.License = {}

function GM.License:PlayerHasLicense( pPlayer )
	return GAMEMODE.Player:GetSharedGameVar( pPlayer, "driver_license", "" ) ~= ""
end

function GM.License:GetPlayerPlateNumber( pPlayer )
	if not GAMEMODE.Cars:PlayerHasCar( pPlayer ) then return "unknown" end
	return GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer ):GetNWString( "plate_serial" )
end

function GM.License:GetPlayerFromPlateNumber( strPlateNumber )
	for k, v in pairs( player.GetAll() ) do
		if not GAMEMODE.Player:PlayerHasCar( v ) then continue end
		if GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer ):GetNWString( "plate_serial" ):lower() == strPlateNumber:lower() then
			return v
		end
	end
end

hook.Add( "GamemodeDefineGameVars", "DefineLicenseVars", function( pPlayer )
	GAMEMODE.Player:DefineSharedGameVar( "driver_license", "", "String", true )
end )