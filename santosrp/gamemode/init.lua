--[[
	Name: init.lua
	For: TalosLife
	By: TalosLife
]]--

include "sh_init.lua"
gameevent.Listen "player_disconnect"

function GM:Reinitialize( pPlayer, strCmd, tblArgs, bNoClients )
	if not IsValid( ply ) or pPlayer:IsSuperAdmin() then
		Msg( "Reinitializing gamemode...\n" )
		self:Initialize()

		if not bNoClients then
			for _, v in pairs( player.GetAll() ) do
				v:ConCommand( "__gamemode_reinitialize_cl" )
			end
		end
	end
end
--concommand.Add( "__gamemode_reinitialize", function( pPlayer, strCmd, tblArgs ) GAMEMODE:Reinitialize( pPlayer, strCmd, tblArgs, false ) end )
--hook.Add( "OnReloaded", "Gamemode_AutoRefresh", function() GAMEMODE:Reinitialize( _, _, _, true ) end )

function GM:Load()
	self:PrintDebug( 0, "Loading Mika32" )
	self.Map:Load()
	self.Jobs:LoadJobs()
	self.Econ:Load()
	self.Inv:LoadItems()
	self.Property:LoadProperties()
	self.NPC:LoadNPCs()
	self.Cars:LoadCars()
	self.Weather:LoadTypes()
	self.Apps:Load()
	--self.ServerNet:Load()
end

function GM:Initialize()
	self.Map:Initialize()
	self.Net:Initialize()
	self.FireSystem:Initialize()
	self.Skills:Initialize()
	self.NPC:Initialize()
	self.Needs:Initialize()
	self.Inv:Initialize()
	self:PrintDebug( 0, "Mika Loaded!" )

	if not self.SQL:IsConnected() then
		self.SQL:Connect( self.Config.SQLHostName, self.Config.SQLUserName, self.Config.SQLPassword, self.Config.SQLDBName )
	end
end

function GM:InitPostEntity()
	self.DayNight:InitPostEntity()
	self.PropProtect:InitPostEntity()
	self.Property:LoadMap()
	self.NPC:InitPostEntity()
	self.Map:InitPostEntity()
end

function GM:Think()
	self.PlayerAnims:ThinkPlayerBones()
	self.DayNight:Think()
end

function GM:Tick()
	self.SQL:Tick()
	self.Jail:Tick()
	self.License:Tick()
	self.Uncon:Tick()
	self.Drugs:Tick()
	self.Jobs:Tick()
	self.Cars:TickCarFuel()
	self.Needs:Tick()
	self.ChopShop:Tick()
	self.Weather:Tick()
	self.FireSystem:Tick()
	self.PlayerDamage:Tick()
	self.Econ:Tick()
end

function GM:EntityTakeDamage( eEnt, pDamageInfo )
	if self.Map:EntityTakeDamage( eEnt, pDamageInfo ) then
		return true
	end

	self.PlayerDamage:EntityTakeDamage( eEnt, pDamageInfo )
	self.EntityDamage:EntityTakeDamage( eEnt, pDamageInfo )
	
	if self.Uncon:EntityTakeDamage( eEnt, pDamageInfo ) then
		return true
	end

	self.Cars:EntityTakeDamage( eEnt, pDamageInfo )

	if self.SeatBelts:EntityTakeDamage( eEnt, pDamageInfo ) then
		return true
	end
end

function GM:PlayerShouldTakeDamage( pPlayer, entAttacker )
	if entAttacker.IsItem then return false end
	return true
end

function GM:OnEntityCreated( eEnt )
	self.FireSystem:OnEntityCreated( eEnt )
end

function GM:EntityRemoved( eEnt )
	self.Inv:EntityRemoved( eEnt )
	self.PropProtect:EntityRemoved( eEnt )
	
	if eEnt:IsPlayer() then
		self.Phone:PlayerDisconnected( eEnt )
	end
end

function GM:EntityKeyValue( eEnt, strKey, strValue )
end

function GM:EntityFireBullets( eEnt, tblBullet )
	if self.PlayerDamage:EntityFireBullets( eEnt, tblBullet ) then
		return true, tblBullet
	end
end

function GM:ShouldCollide( eEnt1, eEnt2 )
	if eEnt1:IsVehicle() or eEnt2:IsVehicle() then
		return self.Cars:ShouldCollide( eEnt1, eEnt2 )
	end
end

function GM:ShutDown()
	self.SQL:ShutDown()
end

function GM:CheckPassword( strSID64, strIP, strSVPass, strCLPass, strName )
	if GAMEMODE.Config.Banned4Lyfe[strSID64] then
		return false, GAMEMODE.Config.Banned4Lyfe[strSID64]
	end
end

function GM:player_disconnect( tblData )
	local sid64 = util.SteamIDTo64( tblData.networkid )
	self.PropProtect:PlayerDisconnectedGameEvent( sid64 )

	self.SQL:PlayerDisconnected( sid64 )
	self.Player.m_tblPlayerData[sid64] = nil

	self.Property:PlayerDisconnected( sid64 )
end

function GM:PlayerDisconnected( pPlayer )
	self.Inv:PlayerDisconnected( pPlayer )
	self.PropProtect:PlayerDisconnected( pPlayer )
end

function GM:PlayerInitialSpawn( pPlayer )
	if not pPlayer:IsBot() then
		self.SQL:PlayerInitialSpawn( pPlayer )
	end
	
	self.Player:InitialSpawn( pPlayer )
	self.Weather:PlayerInitialSpawn( pPlayer )
	self.DayNight:PlayerInitialSpawn( pPlayer )
end

function GM:PlayerSpawn( pPlayer )
	pPlayer.m_bSkipDeathWait = nil
	pPlayer.m_intDeathWaitStart = nil

	self.Uncon:PlayerSpawn( pPlayer )
	self.Needs:PlayerSpawn( pPlayer )
	self.Inv:PlayerSpawn( pPlayer )
	self.Player:Spawn( pPlayer )
	self.Jail:PlayerSpawn( pPlayer )
end

function GM:PlayerDeath( pPlayer )
	self.Player:PlayerDeath( pPlayer )
	self.Inv:PlayerDeath( pPlayer )
	self.Uncon:PlayerDeath( pPlayer )
	self.Drugs:PlayerDeath( pPlayer )
	self.Needs:PlayerDeath( pPlayer )
end

function GM:PlayerSilentDeath( pPlayer )
	pPlayer.m_bSpawnDeathSilent = true
end

function GM:PlayerDeathThink( pPlayer )
	if pPlayer.m_bSkipDeathWait then
		pPlayer:Spawn()
		self.PlayerDamage:HealPlayerLimbs( pPlayer )
		return true
	end

	if not pPlayer.m_intDeathWaitStart then
		pPlayer.m_intDeathWaitStart = CurTime()
		pPlayer:SetNWFloat( "DeathStart", pPlayer.m_intDeathWaitStart )
	end

	if CurTime() > pPlayer.m_intDeathWaitStart +GAMEMODE.Config.DeathWaitTime then
		pPlayer:Spawn()
		self.PlayerDamage:HealPlayerLimbs( pPlayer )
		return true
	end

	return false
end

function GM:DoPlayerDeath( pPlayer, pAttacker, pDamageInfo )
	self.Uncon:DoPlayerDeath( pPlayer, pAttacker, pDamageInfo )

	pPlayer:AddDeaths( 1 )
	if IsValid( pAttacker ) and pAttacker:IsPlayer() then
		if pAttacker == pPlayer then
			pAttacker:AddFrags( -1 )
		else
			pAttacker:AddFrags( 1 )
		end
	end
end

function GM:PlayerLoadout( pPlayer )
	self.Player:Loadout( pPlayer )

	if pPlayer.m_bSpawnDeathSilent then
		pPlayer.m_bSpawnDeathSilent = nil
	end
end

function GM:PlayerUse( pPlayer, eEnt )
	if pPlayer:KeyDown( IN_WALK ) then return end
	
	if self.PropProtect:PlayerUse( pPlayer, eEnt ) then
		return false
	elseif self.Inv:PlayerUse( pPlayer, eEnt ) then
		return false
	end

	return true
end


function GM:PlayerCanHearPlayersVoice( pPlayer1, pPlayer2 )
	if self.ChatRadio:PlayerCanHearPlayersVoice( pPlayer1, pPlayer2 ) then
		return true
	end

	if self.Phone:PlayerCanHearPlayersVoice( pPlayer1, pPlayer2 ) then
		return true
	end

	return ( pPlayer1:GetPos():Distance( pPlayer2:GetPos() ) <= 600 ), true
end



function GM:PlayerSay( ... )
	return self.Chat:PlayerSay( ... )
end

function GM:PlayerSpray( pPlayer )
	return true
end

function GM:GravGunPunt( pPlayer, eEnt )
	return false
end

function GM:AllowPlayerPickup( pPlayer, eEnt )
	return true
end

function GM:PlayerSwitchWeapon( pPlayer, entOldWep, entNewWep )
	return false
end

function GM:PlayerCanPickupWeapon( pPlayer, entWep )
	return not entWep.IsItem
end

function GM:KeyPress( pPlayer, intKey )
	self.SeatBelts:KeyPress( pPlayer, intKey )

	if intKey == IN_USE and pPlayer:KeyDown( IN_WALK ) then
		local ent = util.TraceLine{
			start = pPlayer:GetShootPos(),
			endpos = pPlayer:GetShootPos() +(pPlayer:GetAimVector() *100),
			filter = pPlayer
		}.Entity

		if ent.IsItem then
			if self.Inv:PlayerUse( pPlayer, ent ) then
				return
			end
		end
	end
end

function GM:CanPlayerSuicide( pPlayer )
	return false
end

function GM:CanPlayerEnterVehicle( pPlayer, entVeh )
	local ret = self.Uncon:CanPlayerEnterVehicle( pPlayer, entVeh )
	if ret ~= nil then return ret end
	return not entVeh.IsLocked
end

function GM:PlayerEnteredVehicle( pPlayer, entVeh )
	self.Cars:PlayerEnteredVehicle( pPlayer, entVeh )
	self.License:PlayerEnteredVehicle( pPlayer, entVeh )
	self.SeatBelts:PlayerEnteredVehicle( pPlayer, entVeh )
end

function GM:PlayerLeaveVehicle( pPlayer, entVeh )
	self.SeatBelts:PlayerLeaveVehicle( pPlayer, entVeh )
end

function GM:PlayerSpawnedVehicle( pPlayer, entVeh )
end

function GM:PhysgunPickup( pPlayer, eEnt )
	local ret = self.Map:PhysgunPickup( pPlayer, eEnt )
	if ret ~= nil then return ret end

	local ret = self.PropProtect:PhysgunPickup( pPlayer, eEnt )
	if ret ~= nil then return ret end

	return true
end

function GM:GravGunPickupAllowed( pPlayer, eEnt )
	return self.PropProtect:GravGunPickupAllowed( pPlayer, eEnt )
end

function GM:GetFallDamage( pPlayer, intVel )
	--local dmg = intVel /10
	--if dmg < 10 then dmg = 0 end
	--return dmg

	return self.PlayerDamage:GetFallDamage( pPlayer, intVel )
end

function GM:ScalePlayerDamage( pPlayer, intHitgroup, pDamageInfo )
	self.PlayerDamage:ScalePlayerDamage( pPlayer, intHitgroup, pDamageInfo )
end

function GM:GamemodeUpdateMapLighting( ... )
	return self.Weather:GamemodeUpdateMapLighting( ... )
end

function GM:GamemodeOnSkyboxUpdate( ... )
	return self.Weather:GamemodeOnSkyboxUpdate( ... )
end

function GM:GamemodeOnCharacterDeath( pPlayer )
	self.Inv:GamemodeOnCharacterDeath( pPlayer )
end

GM:Load()

--Wtf, commands being sent with no command string?
g_CmdRun = g_CmdRun or concommand.Run
function concommand.Run( player, command, arguments, args, ... )
	if not command then return end
	return g_CmdRun( player, command, arguments, args, ... )
end

concommand.Add( "srp_admin_save_shutdown", function( pPlayer, strCmd, tblArgs )
	if IsValid( pPlayer ) and not pPlayer:IsSuperAdmin() then return end
	if GAMEMODE.m_bInShutDown then return end
	GAMEMODE.m_bInShutDown = true

	ServerLog( "Server is shutting down...\n" )
	RunConsoleCommand( "sv_password", GAMEMODE.Util:RandomString(30, 32) )
	RunConsoleCommand( "bot" )

	timer.Simple( 0, function()
		for k, v in pairs( player.GetAll() ) do
			if v:IsBot() then continue end
			v:Kick( "Server shutting down..." )
		end

		ServerLog( "Waiting on sql...\n" )

		timer.Create( "WaitForSQLShutdown", 1, 0, function()
			for worker, data in pairs( GAMEMODE.SQL:GetWriteQueue() ) do
				if table.Count( data ) > 0 then return end
			end

			--All write queues are empty, shut down!
			ServerLog( "Server is safe to restart.\n" )
			game.ConsoleCommand( "killserver\n" )
		end )
	end )
end )