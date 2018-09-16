--[[
	Name: sv_phone.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Phone = {}

function GM.Phone:GeneratePlayerNumber( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end

	saveTable.PhoneNumber = util.CRC( pPlayer:SteamID().. pPlayer:GetCharacterID() )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "PhoneNumber" )
end

--[[ Voice Calls ]]--
function GM.Phone:SetPlayerCallState( pPlayer, strState )
	pPlayer.m_strCallState = strState
end

function GM.Phone:GetPlayerCallState( pPlayer )
	return pPlayer.m_strCallState
end

--Player wants to call someone
function GM.Phone:PlayerCallNumber( pPlayer, strNumber )
	if pPlayer:IsIncapacitated() then return end
	if self:GetPlayerCallState( pPlayer ) ~= nil then --already in some stage of a call
		return
	end

	local foundPlayer
	for k, v in pairs( player.GetAll() ) do
		if GAMEMODE.Player:GetGameVar( v, "phone_number" ) == strNumber then
			foundPlayer = v
			break
		end
	end

	if not IsValid( foundPlayer ) or foundPlayer == pPlayer or not foundPlayer:Alive() then
		self:SendDialFailed( pPlayer )
		return
	end

	if self:GetPlayerCallState( foundPlayer ) ~= nil then
		self:SendBusySignal( pPlayer )
		return
	end
	if foundPlayer:IsIncapacitated() then
		self:SendBusySignal( pPlayer )
		return
	end

	local callUID = CurTime()
	pPlayer.m_pCallingPlayer = foundPlayer
	pPlayer.m_intCallStart = callUID
	foundPlayer.m_pCallingPlayer = pPlayer
	foundPlayer.m_intCallStart = callUID

	self:SetPlayerCallState( pPlayer, "call_wait_out" )
	self:SetPlayerCallState( foundPlayer, "call_wait_in" )
	self:SendOutgoingCall( pPlayer, foundPlayer )
	self:SendIncomingCall( foundPlayer, pPlayer )

	timer.Simple( 30, function() --If no one picks up after this time, deny the call for them
		if not IsValid( pPlayer ) then
			if IsValid( foundPlayer ) and foundPlayer.m_intCallStart and foundPlayer.m_intCallStart == callUID then
				GAMEMODE.Phone:PlayerDenyCall( foundPlayer )
			end
			return
		end

		if pPlayer.m_intCallStart and pPlayer.m_intCallStart == callUID then
			GAMEMODE.Phone:PlayerDenyCall( pPlayer )
		end
	end )
end

--Player wants to pick up the phone
function GM.Phone:PlayerAnswerCall( pPlayer )
	if pPlayer:IsIncapacitated() then return end
	if self:GetPlayerCallState( pPlayer ) ~= "call_wait_in" then return end
	if not IsValid( pPlayer.m_pCallingPlayer ) then --Player left the game after dialing
		GAMEMODE.Phone:PlayerDenyCall( pPlayer )
		return
	end

	self:SetPlayerCallState( pPlayer, "in_call" )
	self:SetPlayerCallState( pPlayer.m_pCallingPlayer, "in_call" )

	pPlayer.m_pInCallWith = pPlayer.m_pCallingPlayer
	pPlayer.m_pCallingPlayer.m_pInCallWith = pPlayer

	--Clear these so the auto deny doesn't try to end the call
	pPlayer.m_intCallStart = nil
	pPlayer.m_pCallingPlayer.m_intCallStart = nil

	pPlayer.m_pCallingPlayer.m_pCallingPlayer = nil
	pPlayer.m_pCallingPlayer = nil
	
	self:SendCallStart( pPlayer )
	self:SendCallStart( pPlayer.m_pInCallWith )
end

--Player wants to ignore the call / stop trying to call someone
function GM.Phone:PlayerDenyCall( pPlayer )
	if self:GetPlayerCallState( pPlayer ) == "in_call" then
		self:PlayerEndCall( pPlayer )
		return
	end

	if self:GetPlayerCallState( pPlayer ) ~= "call_wait_in" and self:GetPlayerCallState( pPlayer ) ~= "call_wait_out" then return end

	if IsValid( pPlayer.m_pCallingPlayer ) then
		self:SetPlayerCallState( pPlayer.m_pCallingPlayer, nil )
		self:SendCallEnd( pPlayer.m_pCallingPlayer )
		pPlayer.m_pCallingPlayer.m_pCallingPlayer = nil
		pPlayer.m_pCallingPlayer.m_intCallStart = nil
	end

	pPlayer.m_intCallStart = nil
	pPlayer.m_pCallingPlayer = nil
	self:SetPlayerCallState( pPlayer, nil )
	self:SendCallEnd( pPlayer )
end

--One of the players has hung up
function GM.Phone:PlayerEndCall( pPlayer )
	if self:GetPlayerCallState( pPlayer ) ~= "in_call" then return end
	
	if IsValid( pPlayer.m_pInCallWith ) then
		self:SetPlayerCallState( pPlayer.m_pInCallWith, nil )
		self:SendCallEnd( pPlayer.m_pInCallWith )
		pPlayer.m_pInCallWith.m_pInCallWith = nil
	end
	
	pPlayer.m_pInCallWith = nil
	self:SetPlayerCallState( pPlayer, nil )
	self:SendCallEnd( pPlayer )
end

function GM.Phone:PlayerDisconnected( pPlayer )
	local state = self:GetPlayerCallState( pPlayer )
	if state == "in_call" or state == "call_wait_in" or state == "call_wait_out" then
		self:PlayerDenyCall( pPlayer )
	end
end

function GM.Phone:PlayerCanHearPlayersVoice( pPlayer1, pPlayer2 )
	if self:GetPlayerCallState( pPlayer1 ) ~= "in_call" or self:GetPlayerCallState( pPlayer1 ) ~= "in_call" then return false end
	return pPlayer1.m_pInCallWith == pPlayer2 or pPlayer2.m_pInCallWith == pPlayer1
end

--Netcode
--Player called an invalid number
function GM.Phone:SendDialFailed( pPlayer )
	GAMEMODE.Net:SendDialFailed( pPlayer )
end

--Player dialed a player that is already in a call
function GM.Phone:SendBusySignal( pPlayer )
	GAMEMODE.Net:SendBusySignal( pPlayer )
end

--Player accepted a call
function GM.Phone:SendCallStart( pPlayer )
	GAMEMODE.Net:SendCallStart( pPlayer )

	if pPlayer.m_strRingTimerID then
		timer.Destroy( pPlayer.m_strRingTimerID )
		pPlayer.m_strRingTimerID = nil
	end
end

--Player has ended the phone call
function GM.Phone:SendCallEnd( pPlayer )
	GAMEMODE.Net:SendCallEnd( pPlayer )

	if pPlayer.m_strRingTimerID then
		timer.Destroy( pPlayer.m_strRingTimerID )
		pPlayer.m_strRingTimerID = nil
	end
end

--Tell player they are trying to call someone
function GM.Phone:SendOutgoingCall( pPlayer, pCalling )
	GAMEMODE.Net:SendOutgoingCall( pPlayer, pCalling )
end

--Tell player that another player is trying to call them
function GM.Phone:SendIncomingCall( pPlayer, pCaller )
	GAMEMODE.Net:SendIncomingCall( pPlayer, pCaller )

	pPlayer.m_strRingTimerID = "PhoneRing_".. pPlayer:EntIndex()
	pPlayer:EmitSound( "taloslife/ringtone.wav" )
	timer.Create( pPlayer.m_strRingTimerID, 4, 0, function()
		if not IsValid( pPlayer ) then timer.Destroy( pPlayer.m_strRingTimerID or "" ) return end
		pPlayer:EmitSound( "taloslife/ringtone.wav" )
	end )
end

--[[ Texting ]]--
function GM.Phone:PlayerSendTextMessage( pSender, strText, strNumberSendTo )
	if pSender:IsIncapacitated() then return end

	strText = string.Trim( strText or "" )
	if strText == "" or strText:len() > GAMEMODE.Config.MaxTextMsgLen then return end

	if hook.Call( "GamemodePlayerSendTextMessage", GAMEMODE, pSender, strText, strNumberSendTo ) then
		return
	end

	local foundPlayer
	for k, v in pairs( player.GetAll() ) do
		if GAMEMODE.Player:GetGameVar( v, "phone_number" ) == strNumberSendTo then
			foundPlayer = v
			break
		end
	end
	if not IsValid( foundPlayer ) or pPlayer == foundPlayer then return end

	GAMEMODE.Net:SendTextMessage( foundPlayer, GAMEMODE.Player:GetGameVar(pSender, "phone_number"), strText )
	foundPlayer:EmitSound( "taloslife/sms.mp3" )
end

--[[ Image Texting ]]--
function GM.Phone:PlayerSendPlayerImage( pPlayer, strSendNumber, intNumParts )
	if pPlayer.m_bSendingImage then return end
	if pPlayer:IsIncapacitated() then return end

	local foundPlayer
	for k, v in pairs( player.GetAll() ) do
		if GAMEMODE.Player:GetGameVar( v, "phone_number" ) == strSendNumber then
			foundPlayer = v
			break
		end
	end
	if not IsValid( foundPlayer ) or pPlayer == foundPlayer then return end
	
	pPlayer.m_bSendingImage = true
	pPlayer.m_strSendingImageTo = strSendNumber
	pPlayer.m_intNumSendingImageParts = intNumParts

	pPlayer.m_intCurSendingImagePart = 0
	pPlayer.m_strSendingImageData = ""
	GAMEMODE.Net:RequestNextImagePart( pPlayer )
end

function GM.Phone:PlayerSendImagePart( pPlayer, strPartData )
	if not pPlayer.m_bSendingImage then return end
	pPlayer.m_intCurSendingImagePart = pPlayer.m_intCurSendingImagePart +1
	pPlayer.m_strSendingImageData = pPlayer.m_strSendingImageData.. strPartData

	if pPlayer.m_intNumSendingImageParts < pPlayer.m_intCurSendingImagePart then
		GAMEMODE.Net:RequestNextImagePart( pPlayer )
	else
		pPlayer.m_bSendingImage = false
		GAMEMODE.Net:SendImagePartsDone( pPlayer )

		local foundPlayer
		for k, v in pairs( player.GetAll() ) do
			if GAMEMODE.Player:GetGameVar( v, "phone_number" ) == pPlayer.m_strSendingImageTo then
				foundPlayer = v
				break
			end
		end
		if not IsValid( foundPlayer ) or pPlayer == foundPlayer then return end

		GAMEMODE.Net:SendImageDataToPlayer( foundPlayer, GAMEMODE.Player:GetGameVar(pPlayer, "phone_number"), pPlayer.m_strSendingImageData )
		pPlayer.m_strSendingImageData = nil
		foundPlayer:EmitSound( "taloslife/sms.mp3" )
	end
end

hook.Add( "GamemodeDefineGameVars", "DefinePhoneData", function( pPlayer )
	GAMEMODE.Player:DefineGameVar( pPlayer, "phone_number", "", "String", true )
end )

hook.Add( "GamemodePlayerSelectCharacter", "ApplyPhoneData", function( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	if not saveTable.PhoneNumber then
		GAMEMODE.Phone:GeneratePlayerNumber( pPlayer )
	end

	GAMEMODE.Player:SetGameVar( pPlayer, "phone_number", saveTable.PhoneNumber, true )
end )

hook.Add( "PlayerDeath", "HangUp", function( pPlayer )
	GAMEMODE.Phone:PlayerDenyCall( pPlayer )
end )

hook.Add( "PlayerCanPickupWeapon", "DetectCuffs", function( pPlayer, entWep )
	if entWep:GetClass() == "weapon_handcuffed" or entWep:GetClass() == "weapon_ziptied" then
		GAMEMODE.Phone:PlayerDenyCall( pPlayer )
	end
end )