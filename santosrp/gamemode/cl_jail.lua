--[[
	Name: cl_jail.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Jail = {}

function GM.Jail:PaintJailedHUD()
	if not GAMEMODE.Player:GetSharedGameVar( LocalPlayer(), "arrested" ) then return end
	local x = ScrW() /2
	local y = ScrH() -100
	local box_w = 435
	local box_h = 90
	
	surface.SetDrawColor( 0, 0, 0, 220 )
	surface.DrawRect( x -(box_w /2), y -(box_h /2), box_w, box_h )
	
	draw.SimpleTextOutlined( "You are in jail!", "handcuffText", x, y-10, color_white, 1, 1, 1, color_black )
	draw.SimpleText( "You must wait until you have served your sentence or until another player bails you out!", "DermaDefault", x, y + 25, color_white, 1, 1 )
	
	local jailTimeLeft = GAMEMODE.Player:GetGameVar( "arrest_start", 0 ) +GAMEMODE.Player:GetSharedGameVar( LocalPlayer(), "arrest_duration", 0 )
	jailTimeLeft = math.max( jailTimeLeft -os.time(), 0 )
	
	local text = "Jail - Time Left: ".. GAMEMODE.Util:FormatTime( jailTimeLeft, true )
	draw.SimpleText( text, "DermaDefault", x, y - 35, Color(220, 20, 20), 1, 1 )
end

function GM.Jail:IsPlayerInJail( pPlayer )
	return GAMEMODE.Player:GetSharedGameVar( pPlayer, "arrested" )
end

function GM.Jail:GetPlayerBailPrice( pPlayer )
	if not self:IsPlayerInJail( pPlayer ) then return 0 end
	local bailPrice = GAMEMODE.Player:GetSharedGameVar( pPlayer, "arrest_duration", 0 )
	if bailPrice > 0 then
		bailPrice = math.floor( bailPrice /60 ) *350
	end

	return bailPrice
end

function GM.Jail:PlayerHasWarrent( pPlayer )
	return GAMEMODE.Player:GetSharedGameVar( pPlayer, "warrant" )
end

hook.Add( "GamemodeDefineGameVars", "DefineJailVars", function( pPlayer )
	GAMEMODE.Player:DefineSharedGameVar( "arrested", false, "Bool", true )
	GAMEMODE.Player:DefineGameVar( "arrest_start", 0, "UInt32", true )
	GAMEMODE.Player:DefineSharedGameVar( "arrest_duration", 0, "Float", true )
	GAMEMODE.Player:DefineGameVar( "arrest_reason", "", "String", true )
	GAMEMODE.Player:DefineGameVar( "arrested_by", "", "String", true )

	GAMEMODE.Player:DefineSharedGameVar( "warrant", false, "Bool", true )
	GAMEMODE.Player:DefineGameVar( "warrant_reason", "", "String", true )
	GAMEMODE.Player:DefineGameVar( "warrant_by", "", "String", true )
end )