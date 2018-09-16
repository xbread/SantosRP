--[[
	Name: sh_car_radios.lua
	For: TalosLife
	By: TalosLife
]]--

local MAX_RADIO_DIST = 768




GM.CarRadio = {}
GM.CarRadio.m_tblStations = {
    { Name = "Hanson.FM", Url = "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1357102" },
    { Name = "Rap.FM", Url = "http://yp.shoutcast.com/sbin/tunein-station.pls?id=137513" },
    { Name = "Country.FM", Url = "http://yp.shoutcast.com/sbin/tunein-station.pls?id=21992" },
    { Name = "Comedy.FM", Url = "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1406466" },
    { Name = "Smooth Jazz.FM", Url = "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1174062" },
    { Name = "Classic Rock.FM", Url = "http://yp.shoutcast.com/sbin/tunein-station.pls?id=99217539" },
    { Name = "Classical.FM", Url = "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1083969" },

}


if SERVER then
	function GM.CarRadio:PlayStation( entVeh, intStationID, bIsCustom )
		if not bIsCustom and not self.m_tblStations[intStationID] then return end
		if entVeh.m_intCurrentRadioStation == intStationID then return end
		entVeh.m_intCurrentRadioStation = intStationID

		GAMEMODE.Net:NetworkCarRadioPlay( entVeh, intStationID, bIsCustom )
	end

	function GM.CarRadio:StopStation( entVeh )
		entVeh.m_intCurrentRadioStation = nil
		GAMEMODE.Net:NetworkCarRadioStop( entVeh )
	end

	function GM.CarRadio:SendRadioFullUpdate( pPlayer )
		GAMEMODE.Net:SendFullCarRadioUpdate( pPlayer )
	end

	hook.Add( "GamemodeOnPlayerReady", "SendCarRadioFullUpdate", function( pPlayer )
		GAMEMODE.CarRadio:SendRadioFullUpdate( pPlayer )
	end )

	hook.Add( "PlayerLeaveVehicle", "StopCarRadios", function( pPlayer, entVehicle )
		if entVehicle.m_intCurrentRadioStation then
			GAMEMODE.CarRadio:StopStation( entVehicle )
		end
	end )
else
	GM.CarRadio.m_tblCarStreams = {}
	GM.CarRadio.m_varVolume = CreateClientConVar( "srp_cradio_volume", "1", true, false )

	function GM.CarRadio:StartStream( entVehicle, strUrl )
		if GAMEMODE.Config.HasDataCap:GetInt() == 1 then return end
		if not IsValid( entVehicle ) then return end
		self:StopStream( entVehicle )

		sound.PlayURL( strUrl, "3d noplay", function( pAudioChan )
			if not IsValid( pAudioChan ) or not IsValid( entVehicle ) then return end
			self.m_tblCarStreams[entVehicle] = pAudioChan
		end )
	end
	
	function GM.CarRadio:StopStream( entVehicle )
		if not IsValid( self.m_tblCarStreams[entVehicle] ) then return end
		self.m_tblCarStreams[entVehicle]:Stop()
		self.m_tblCarStreams[entVehicle] = nil
	end

	hook.Add( "HUDPaint", "UpdateCarRadios", function()
		for k, v in pairs( GAMEMODE.CarRadio.m_tblCarStreams ) do
			if not IsValid( v ) then GAMEMODE.CarRadio.m_tblCarStreams[k] = nil continue end
			if not IsValid( k ) then
				if IsValid( v ) then v:Stop() end
				GAMEMODE.CarRadio.m_tblCarStreams[k] = nil
				continue
			end

			local state = v:GetState()
			if k:GetPos():Distance( LocalPlayer():GetPos() ) > MAX_RADIO_DIST then
				if state == GMOD_CHANNEL_PLAYING then
					v:Pause()
				end
			else
				if state == GMOD_CHANNEL_PAUSED or state == GMOD_CHANNEL_STOPPED then
					if IsValid( v ) then v:Play() end
				end
			end
			
			if IsValid( v ) then
				local veh = LocalPlayer():GetVehicle()

				if IsValid( veh ) and (veh == k or veh:GetParent() == k) then
					v:SetPos( EyePos() )
				else
					v:SetPos( k:LocalToWorld(k:OBBCenter()) )
				end

				--v:Set3DFadeDistance( 768, 3070 )
				v:SetVolume( math.max(GAMEMODE.CarRadio.m_varVolume:GetFloat(), 0) )
			end
		end
	end )

	hook.Add( "GamemodeDataCapModeChanged", "UpdateCarRadios", function( strNewVal )
		if tonumber( strNewVal ) == 1 then
			for k, v in pairs( GAMEMODE.CarRadio.m_tblCarStreams ) do
				if IsValid( v ) then v:Stop() end
			end
			GAMEMODE.CarRadio.m_tblCarStreams = {}
		end
	end )
end