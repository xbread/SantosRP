--[[
	Name: sh_init.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Name 	= "SantosRP
GM.Author 	= "Ultra"
GM.Email 	= "ultraminge@gmail.com"
GM.Website 	= ""



function GM:PrintDebug( intLevel, ... )
	--print( ... )
end

include( SERVER and "sv_manifest.lua" or "cl_manifest.lua" )

if not debug.getregistry().Player.CheckGroup then
	debug.getregistry().Player.CheckGroup = function()
		return true
	end
end

if game.SinglePlayer() then
	debug.getregistry().Player.SteamID64 = function()
		return "1234567890"
	end
end

hook.Remove( "PlayerTick", "TickWidgets" )

--Precache models
for k, v in pairs( GM.Config.PlayerModels.Male ) do
	util.PrecacheModel( k )
end

for k, v in pairs( GM.Config.PlayerModels.Female ) do
	util.PrecacheModel( k )
end

for k, v in pairs( GM.Config.PlayerModelOverloads.Male or {} ) do
	util.PrecacheModel( k )
end

for k, v in pairs( GM.Config.PlayerModelOverloads.Female or {} ) do
	util.PrecacheModel( k )
end


if ( SERVER ) then
	concommand.Add( 'rp_lookup', function( ply, cmd, args )
		if ( ply:IsAdmin() ) then
		
			for k,v in pairs( player.GetAll() ) do
				local NameARG= tostring( args[1] )
			
				if ( v:Name() == NameARG ) then
				
					ply:PrintMessage( HUD_PRINTCONSOLE, '--------------------------' )
					ply:PrintMessage( HUD_PRINTCONSOLE, 'Name : ' .. NameARG )
					ply:PrintMessage( HUD_PRINTCONSOLE, 'SteamID : ' .. v:SteamID() )
					ply:PrintMessage( HUD_PRINTCONSOLE, 'Money : ' .. v:GetMoney() )
					ply:PrintMessage( HUD_PRINTCONSOLE, 'Bank : ' .. v:GetBankMoney() )
					ply:PrintMessage( HUD_PRINTCONSOLE, '--------------------------' )
				
				end
			end
		else
		
			ply:PrintMessage( HUD_PRINTCONSOLE, 'You Cannot Use This Command!' )
		end
	end )
end
