--[[
	Name: cl_chatradios.lua
	For: TalosLife
	By: TalosLife
]]--

GM.ChatRadio = (GAMEMODE or GM).ChatRadio or {}
GM.ChatRadio.m_tblChannels = (GAMEMODE or GM).ChatRadio.m_tblChannels or {}

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

function GM.ChatRadio:HasRadio()
	return self.m_intCurrentChannel ~= nil
end

function GM.ChatRadio:HasChannelKey( intChanID )
	local job = GAMEMODE.Jobs:GetPlayerJob( LocalPlayer() )
	if not job or not job.HasChatRadio or not job.ChannelKeys then return end
	return job.ChannelKeys[intChanID] and true
end

function GM.ChatRadio:RequestSetChannel( intChanID )
	GAMEMODE.Net:RequestChangeChatRadioChannel( intChanID )
end

function GM.ChatRadio:RequestMuteRadio( bMute )
	GAMEMODE.Net:RequestMuteChatRadio( bMute )
end

function GM.ChatRadio:GetCurrentChannel()
	return self.m_intCurrentChannel
end

function GM.ChatRadio:SetCurrentChannel( intChanID )
	self.m_intCurrentChannel = intChanID
	hook.Call( "GamemodeChatRadioChannelChanged", GAMEMODE, intChanID )
end