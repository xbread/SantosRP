include "sh_init.lua"
gameevent.Listen "player_disconnect"

function GM.Reinitialize( pPlayer, strCmd, tblArgs )
	Msg( "Reinitializing gamemode...\n" )
	GAMEMODE:Initialize( true )
end
concommand.Add( "__gamemode_reinitialize_cl", function( pPlayer, strCmd, tblArgs ) GAMEMODE:Reinitialize( pPlayer, strCmd, tblArgs, false ) end )

function GM:Load()
	RunConsoleCommand( "r_drawmodeldecals", 0 )
	RunConsoleCommand( "r_drawparticles", 0 )
	RunConsoleCommand( "gmod_mcore_test", 1 )
	RunConsoleCommand( "mat_aaquality", -1 )
	RunConsoleCommand( "cl_threaded_bone_setup", 1 )
	
	self.Map:Load()
	self.Inv:LoadItems()
	self.Property:LoadProperties()
	self.NPC:LoadNPCs()
	self.Cars:LoadCars()
	self.Jobs:LoadJobs()
	self.Econ:Load()
	self.Weather:LoadTypes()
	self.Apps:Load()
end

function GM:Initialize( bReload )
	self.Map:Initialize()
	self.Net:Initialize()
	self.Needs:Initialize()
	self.Char:Initialize()
	self.Gui:Initialize()
	self.Skills:Initialize()
	self.NPC:Initialize()
	self.Player:Initialize()
	self.PlayerDamage:Initialize()
end

function GM:GamemodeSetupWorldFog( tblFogData )
	return self.Weather:GamemodeSetupWorldFog( tblFogData )
end

function GM:GamemodeSetupSkyboxFog( ... )
	return self.Weather:GamemodeSetupSkyboxFog( ... )
end

function GM:SetupWorldFog()
	return self.DayNight:SetupWorldFog()
end

function GM:SetupSkyboxFog( ... )
	return self.DayNight:SetupSkyboxFog( ... )
end

function GM:InitPostEntity()
	timer.Simple( 5, function()
		self.Net:SendPlayerReady()
	end )
end

function GM:OnEntityCreated( eEnt )
	self.Player:OnEntityCreated( eEnt )
end

function GM:EntityRemoved( eEnt )
	self.Cars:EntityRemoved( eEnt )
end

function GM:player_disconnect( tblData )
	self.Player:EntityRemoved( util.SteamIDTo64(tblData.networkid) )
end

function GM:IsInGame()
	return self.m_bInGame
end

function GM:HUDPaint()
	self.HUD:Paint()
	self.Uncon:PaintUnconOverlay()
end

function GM:RenderScreenspaceEffects()
	self.Weather:RenderScreenspaceEffects()
	self.Drugs:RenderScreenspaceEffects()
	self.HUD:RenderScreenspaceEffects()
end

function GM:PostDrawTranslucentRenderables()
	self.Property:PaintDoorText()
	self.Weather:PostDrawTranslucentRenderables()
	self.Buddy:PostDrawTranslucentRenderables()
end

function GM:ShouldDrawLocalPlayer()
	return self.Camera:ShouldDrawLocalPlayer()
end

function GM:GetMotionBlurValues( ... )
	return self.Drugs:GetMotionBlurValues( ... )
end

function GM:Think()
	self.HUD:Think()
	self.CiniCam:Think()
	self.Gui:Think()
	self.PacModels:UpdatePlayers()
	self.PlayerAnims:ThinkPlayerBones()
	self.Weather:Think()
	
	if input.IsKeyDown( KEY_P ) and not vgui.CursorVisible() and not LocalPlayer():GetNWBool( "SeatBelt" ) then
		LocalPlayer():ConCommand( "rp_seatbelt" )
	end
end

function GM:Tick()
	self.Gui:Tick()
end

function GM:KeyPress( ... )
	self.Gui:KeyPress( ... )
end

function GM:CreateMove( ... )
	self.Gui:CreateMove( ... )
end

function GM:HUDShouldDraw( ... )
	if self.Gui:HUDShouldDraw( ... ) ~= nil then
		return false
	end

	return true
end

function GM:PreDrawViewModel( vm, pl, wep )
	if MAIN_MOVIEMODE then return true end
	if IsValid( wep ) and wep.PreDrawViewModel then return wep:PreDrawViewModel( vm, pl, wep ) end
end

function GM:PostDrawViewModel( vm, pl, wep )
	if wep.UseHands or not wep:IsScripted() then
		local hands = LocalPlayer():GetHands()
		if IsValid( hands ) then hands:DrawModel() end
	end
	
	if wep.PostDrawViewModel then return wep:PostDrawViewModel( vm, pl,wep ) end
end

function GM:PlayerFootstep( pl, pos, ft, sound, vol, filter )
	if MAIN_MOVIEMODE and pl == LocalPlayer() then return true end
end

function GM:OnPlayerChat( ... )
	return self.Chat:OnPlayerChat( ... )
end

function GM:PlayerSwitchWeapon( ... )
	self.PacModels:PlayerSwitchWeapon( ... )
end

function GM:GamemodeOnCharacterUpdate()
	self.Gui:ShowCharacterSelection()
end

function GM:GamemodeGameVarChanged( ... )
	self.PlayerDamage:GamemodeGameVarChanged( ... )
end

function GM:GamemodeSharedGameVarChanged( ... )
	self.Inv:PlayerEquipSlotChanged( ... )
end

GM:Load()

cvars.AddChangeCallback( "srp_datacap_mode", function( _, _, val )
	hook.Call( "GamemodeDataCapModeChanged", GAMEMODE, val )
end )
