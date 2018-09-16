--[[
	Name: sh_item_radios.lua
	For: TalosLife
	By: TalosLife
]]--

local MAX_RADIO_DIST = 3072

GM.PropRadio = {}

if SERVER then
	function GM.PropRadio:PlayStation( entProp, intStationID, bIsCustom )
		if not bIsCustom and not GAMEMODE.CarRadio.m_tblStations[intStationID] then return end
		if entProp.m_intCurrentRadioStation == intStationID then return end
		entProp.m_intCurrentRadioStation = intStationID

		GAMEMODE.Net:NetworkPropRadioPlay( entProp, intStationID, bIsCustom )
	end

	function GM.PropRadio:StopStation( entProp )
		entProp.m_intCurrentRadioStation = nil
		GAMEMODE.Net:NetworkPropRadioStop( entProp )
	end

	function GM.PropRadio:SendRadioFullUpdate( pPlayer )
		GAMEMODE.Net:SendFullPropRadioUpdate( pPlayer )
	end

	hook.Add( "SantosPlayerLoaded", "SendRadioFullUpdate", function( pPlayer )
		GAMEMODE.PropRadio:SendRadioFullUpdate( pPlayer )
	end )
else
	GM.PropRadio.m_tblPropStreams = {}
	GM.PropRadio.m_varVolume = CreateClientConVar( "srp_pradio_volume", "1", true, false )

	function GM.PropRadio:StartStream( entProp, strUrl )
		if GAMEMODE.Config.HasDataCap:GetInt() == 1 then return end
		if not IsValid( entProp ) then return end
		self:StopStream( entProp )

		sound.PlayURL( strUrl, "3d noplay", function( pAudioChan )
			if not IsValid( pAudioChan ) or not IsValid( entProp ) then return end
			self.m_tblPropStreams[entProp] = pAudioChan
		end )
	end
	
	function GM.PropRadio:StopStream( entProp )
		if not IsValid( self.m_tblPropStreams[entProp] ) then return end
		self.m_tblPropStreams[entProp]:Stop()
		self.m_tblPropStreams[entProp] = nil
	end

	hook.Add( "Think", "UpdatePropRadios", function()
		for k, v in pairs( GAMEMODE.PropRadio.m_tblPropStreams ) do
			if not IsValid( v ) then GAMEMODE.PropRadio.m_tblPropStreams[k] = nil continue end
			if not IsValid( k ) then
				if IsValid( v ) then v:Stop() end
				GAMEMODE.PropRadio.m_tblPropStreams[k] = nil
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
				--v:Set3DFadeDistance( 768, 3070 )
				v:SetPos( k:LocalToWorld(k:OBBCenter()) )
				v:SetVolume( math.max(GAMEMODE.PropRadio.m_varVolume:GetFloat(), 0) )
			end
		end
	end )

	hook.Add( "GamemodeDataCapModeChanged", "UpdatePropRadios", function( strNewVal )
		if tonumber( strNewVal ) == 1 then
			for k, v in pairs( GAMEMODE.PropRadio.m_tblPropStreams ) do
				if IsValid( v ) then v:Stop() end
			end
			GAMEMODE.PropRadio.m_tblPropStreams = {}
		end
	end )
end