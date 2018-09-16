--[[
	Name: sv_chatradios.lua
	For: TalosLife
	By: TalosLife
]]--

GM.ChatRadio = {}
GM.ChatRadio.m_tblChannels = {}

function GM.ChatRadio:RegisterChannel( intChanID, strName, bEncrypted )
	self.m_tblChannels[intChanID] = { Name = strName, Encrypted = bEncrypted }
end

function GM.ChatRadio:GetChannel( intChanID )
	return self.m_tblChannels[intChanID]
end

function GM.ChatRadio:GetChannels()
	return self.m_tblChannels
end

function GM.ChatRadio:IsChannelEncrypted( intChanID )
	return self.m_tblChannels[intChanID].Encrypted
end

function GM.ChatRadio:GrantEncryptedChannelKey( pPlayer, intChanID )
	pPlayer.m_tblChatRadioChanKeys = pPlayer.m_tblChatRadioChanKeys or {}
	pPlayer.m_tblChatRadioChanKeys[intChanID] = true
end

function GM.ChatRadio:RevokeEncryptedChannelKey( pPlayer, intChanID )
	pPlayer.m_tblChatRadioChanKeys = pPlayer.m_tblChatRadioChanKeys or {}
	pPlayer.m_tblChatRadioChanKeys[intChanID] = nil
end

function GM.ChatRadio:PlayerHasChannelKey( pPlayer, intChanID )
	if not pPlayer.m_tblChatRadioChanKeys then return false end
	return pPlayer.m_tblChatRadioChanKeys[intChanID] or false
end

function GM.ChatRadio:PlayerHasRadio( pPlayer )
	local job = GAMEMODE.Jobs:GetPlayerJob( pPlayer )
	if not job or not job.HasChatRadio then return false end
	return true
end

function GM.ChatRadio:PlayerSetChannel( pPlayer, intChan )
	if not self:PlayerHasRadio( pPlayer ) then return end
	if not self:GetChannel( intChan ) then return end
	pPlayer.m_intRadioChannel = intChan
	GAMEMODE.Net:SendPlayerChatRadioChannel( pPlayer, intChan )
end

function GM.ChatRadio:GetPlayerChannel( pPlayer )
	return pPlayer.m_intRadioChannel
end

function GM.ChatRadio:PlayerMuteRadio( pPlayer, bMuted )
	if not self:PlayerHasRadio( pPlayer ) then return end
	pPlayer.m_bRadioMuted = bMuted
end

function GM.ChatRadio:PlayerCanHearPlayersVoice( pPlayer1, pPlayer2 )
	if not self:PlayerHasRadio( pPlayer1 ) or not self:PlayerHasRadio( pPlayer2 ) then return end
	if self:GetPlayerChannel( pPlayer1 ) == self:GetPlayerChannel( pPlayer2 ) then
		if pPlayer1:IsIncapacitated() or pPlayer2:IsIncapacitated() then return end

		if self:IsChannelEncrypted( self:GetPlayerChannel(pPlayer1) ) then
			if self:PlayerHasChannelKey( pPlayer1, self:GetPlayerChannel(pPlayer1) ) then
				if self:PlayerHasChannelKey( pPlayer2, self:GetPlayerChannel(pPlayer2) ) then
					return true
				end
			end
		else
			return true
		end
	end
end

hook.Add( "GamemodePlayerSetJob", "UpdateChatRadios", function( pPlayer, intJobID )
	local job = GAMEMODE.Jobs:GetJobByID( intJobID )
	if job and job.HasChatRadio then
		GAMEMODE.ChatRadio:PlayerSetChannel( pPlayer, job.DefaultChatRadioChannel or 1 )

		if job.ChannelKeys then
			for k, v in pairs( job.ChannelKeys ) do
				GAMEMODE.ChatRadio:GrantEncryptedChannelKey( pPlayer, k )
			end
		end
	else
		GAMEMODE.Net:SendPlayerChatRadioChannel( pPlayer, nil )
	end
end )

hook.Add( "GamemodePlayerQuitJob", "UpdateChatRadios", function( pPlayer, intJobID )
	pPlayer.m_intRadioChannel = nil
	pPlayer.m_bRadioMuted = nil

	local job = GAMEMODE.Jobs:GetJobByID( intJobID )
	if job and job.HasChatRadio and job.ChannelKeys then
		for k, v in pairs( job.ChannelKeys ) do
			GAMEMODE.ChatRadio:RevokeEncryptedChannelKey( pPlayer, k )
		end
	end
end )