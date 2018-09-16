--[[
	Name: sv_servernet.lua
	For: TalosLife
	By: TalosLife
]]--

if g_ServerNetSock then
	g_ServerNetSock:Close()
	g_ServerNetSock = nil
end

require "bromsock"

GM.ServerNet = (GAMEMODE or GM).ServerNet or {}
GM.ServerNet.m_tblIPList = (GAMEMODE or GM).ServerNet.m_tblIPList or {}
GM.ServerNet.m_tblProtocols = (GAMEMODE or GM).ServerNet.m_tblProtocols or {}
GM.ServerNet.m_intClientTimeout = 1000
GM.ServerNet.m_intPort = GM.Config.ServerNetPort or 37015

function GM.ServerNet:Load()
	if GM.Config and GM.Config.ServerNetPool then
		for _, ip in pairs( GM.Config.ServerNetPool ) do
			self:AddServerToPool( ip )
		end
	end

	if GM.Config and GM.Config.ServerNetPort then
		self:Listen( GM.Config.ServerNetPort )
	end
end

function GM.ServerNet:AddServerToPool( strIP )
	self.m_tblIPList[strIP] = strIP
end

function GM.ServerNet:GetServerPool()
	return self.m_tblIPList
end

function GM.ServerNet:RegisterEventHandle( strProtocol, strEvent, funcHandle )
	self.m_tblProtocols[strProtocol] = self.m_tblProtocols[strProtocol] or {}
	self.m_tblProtocols[strProtocol][strEvent] = funcHandle
end

function GM.ServerNet:Listen( intPort )
	if not BromSock then return end
	if self.m_pSocket then self.m_pSocket:Close() end

	self.m_pSocket = BromSock()
	g_ServerNetSock = self.m_pSocket
	self.m_pSocket:Create()
	self.m_pSocket:SetOption( 0x6, 0x0001, 0 )
	self.m_pSocket:SetOption( 0xffff, 0x0004, 1 )

	self.m_pSocket:SetCallbackAccept( function( pSocket, pClientSocket )
		local ip, port = pClientSocket:GetIP(), pClientSocket:GetPort()
		--print( "ServerNet: Accepted ", ip, port )

		if not self.m_tblIPList[ip] then --Deny this client
			pClientSocket:Close()
		else
			--TEST THIS
			if GAMEMODE.Config.ServerNetUseTLS_1_2 and pClientSocket:StartSSLClient() then
				--print( "Client socket is now running with SSL", pClientSocket:GetIP() )
			end

			--Client is sending us an event packet
			pClientSocket:SetCallbackReceive( function( pClient, packet )
				local proto, event = packet:ReadString(), packet:ReadString()
				if proto:len() == 0 or event:len() == 0 then return end
				
				if self.m_tblProtocols[proto] then
					local func = self.m_tblProtocols[proto][event]
					
					if func then
						local b, args = pcall( func, pClient, packet )
						if not b then
							print( "ServerNet: Event handle error!", args )
						end
					end
				end

				pClient:Close()
				packet:Clear()
				packet = nil --?
			end )

			pClientSocket:SetTimeout( self.m_intClientTimeout )
			pClientSocket:Receive()
		end

		self.m_pSocket:Accept()
	end )

	if self.m_pSocket:Listen( intPort ) then
		print( "ServerNet: Listening on port ".. intPort )
	else
		print( "ServerNet: Failed to listen on port ".. intPort )
	end

	self.m_pSocket:Accept()
end

function GM.ServerNet:NewEvent( strProto, strName )
	if not BromPacket then return end
	self.m_pNewPacket = BromPacket()
	self.m_pNewPacket:WriteString( strProto )
	self.m_pNewPacket:WriteString( strName )
	return self.m_pNewPacket
end

function GM.ServerNet:FireEvent( strIP, intPort )
	local outSock = BromSock( BROMSOCK_TCP )
	local packet = self.m_pNewPacket
	outSock:SetCallbackConnect( function()
		outSock:SetCallbackSend( function()
			outSock:Close()
			packet:Clear()
			packet = nil
			outSock = nil
		end )

		outSock:Send( packet )
	end )

	outSock:Connect( strIP, intPort or self.m_intPort )
	self.m_pNewPacket = nil
end

-- ----------------------------------------------------------------


-- Economy
-- ----------------------------------------------------------------
function GM.ServerNet:BroadcastTaxesChanged()
	for _, ip in pairs( self:GetServerPool() ) do
		local packet = self:NewEvent( "econ", "taxes_changed" )
		if not packet then continue end
		self:FireEvent( ip )
	end
end

GM.ServerNet:RegisterEventHandle( "econ", "taxes_changed", function( pClientSocket, packet )
	--fetch the new tax data from sql!
	GAMEMODE.Econ:LoadSavedTaxData()
end )


-- Judge
-- ----------------------------------------------------------------