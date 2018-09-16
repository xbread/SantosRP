--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

ENT.Base = "base_anim"

function ENT:Initialize()
	self:SetModel( "models/props/cs_office/TV_plasma.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
end

function ENT:Use( pPlayer )
	self:NetworkShowTVMenu( pPlayer )
end

function ENT:PlayVideo( strVideoID )
	if self:IsPlayingTwitch() then
		self:StopVideo()
		timer.Simple( 0.25, function()
			if not IsValid( self ) then return end
			self:PlayVideo( strVideoID )
		end )
	end

	self:NetworkVideoPlay( strVideoID, 0 )
	self.m_intStartVideoTime = RealTime()
	self.m_strCurrentVideo = strVideoID
	self.m_bPlayingYoutube = true
	self.m_bPlayingTwitch = false
end

function ENT:PlayTwitch( strTwitchUser )
	if self:IsPlayingYoutube() then
		self:StopVideo()
		timer.Simple( 0.25, function()
			if not IsValid( self ) then return end
			self:PlayTwitch( strTwitchUser )
		end )
	end

	self:NetworkVideoPlayTwitch( strTwitchUser )
	self.m_intStartVideoTime = RealTime()
	self.m_strCurrentTwitchUser = strTwitchUser
	self.m_bPlayingYoutube = false
	self.m_bPlayingTwitch = true
end

function ENT:StopVideo()
	self:NetworkVideoStop()
	self.m_strCurrentVideo = nil
	self.m_strCurrentTwitchUser = nil
	self.m_intStartVideoTime = nil
	self.m_bPlayingYoutube = false
	self.m_bPlayingTwitch = false
end

function ENT:GetCurrentVideo()
	return self.m_strCurrentVideo
end

function ENT:GetCurrentTwitchUser()
	return self.m_strCurrentTwitchUser
end

function ENT:GetVideoPlayTime()
	return self.m_intStartVideoTime or 0
end

function ENT:IsPlayingYoutube()
	return self.m_bPlayingYoutube
end

function ENT:IsPlayingTwitch()
	return self.m_bPlayingTwitch
end

function ENT:NetworkVideoPlay( strVideoID, intTimeOffset, pPlayer )
	net.Start( "ent_tv" )
		net.WriteUInt( self.NET_VIDEO_PLAY, 8 )
		net.WriteEntity( self )
		net.WriteString( strVideoID )
		net.WriteUInt( intTimeOffset or 0, 32 )
	if not pPlayer then
		net.Broadcast()
	else
		net.Send( pPlayer )
	end
end

function ENT:NetworkVideoPlayTwitch( strTwitchUser, pPlayer )
	net.Start( "ent_tv" )
		net.WriteUInt( self.NET_VIDEO_PLAYT, 8 )
		net.WriteEntity( self )
		net.WriteString( strTwitchUser )
	if not pPlayer then
		net.Broadcast()
	else
		net.Send( pPlayer )
	end
end

function ENT:NetworkVideoStop( pPlayer )
	net.Start( "ent_tv" )
		net.WriteUInt( self.NET_VIDEO_STOP, 8 )
		net.WriteEntity( self )
	if not pPlayer then
		net.Broadcast()
	else
		net.Send( pPlayer )
	end
end

function ENT:NetworkShowTVMenu( pPlayer )
	net.Start( "ent_tv" )
		net.WriteUInt( self.NET_VIDEO_MENU, 8 )
		net.WriteEntity( self )
	net.Send( pPlayer )	
end

util.AddNetworkString "ent_tv"
net.Receive( "ent_tv", function( intMsgLen, pPlayer )
	local id, ent = net.ReadUInt( 8 ), net.ReadEntity()
	if not IsValid( ent ) or ent:GetClass() ~= "ent_tv" then return end
	if pPlayer:GetPos():Distance( ent:GetPos() ) >ent.m_intUseRange then return end

	if id == ent.NET_VIDEO_PLAY then
		ent:PlayVideo( net.ReadString() )
	elseif id == ent.NET_VIDEO_STOP then
		ent:StopVideo()
	--elseif id == ent.NET_VIDEO_TAKE then
	--	if ent:GetPlayerOwner() ~= pPlayer then return end
	--	if pPlayer:AddInventory( "Television", nil, 1 ) then
	--		ent:Remove()
	--	end
	elseif id == ent.NET_VIDEO_PLAYT then
		ent:PlayTwitch( net.ReadString() )
	end
end )

hook.Add( "GamemodeOnPlayerReady", "UpdateTVs", function( pPlayer )
	for k, v in pairs( ents.FindByClass("ent_tv") ) do
		if v:IsPlayingYoutube() then
			v:NetworkVideoPlay( v:GetCurrentVideo(), RealTime() -v:GetVideoPlayTime(), pPlayer )
		elseif v:IsPlayingTwitch() then
			v:NetworkVideoPlayTwitch( v:GetCurrentTwitchUser(), pPlayer )
		end
	end
end )