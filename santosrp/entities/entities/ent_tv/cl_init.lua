--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife

	"http://g4p.org/YouTube/player.php?uid="
	"http://g4p.org/YouTube/twitchplayer.php?vid="
]]--

include "shared.lua"
CreateClientConVar( "srp_tv_volume", "15", true, false )

local videoURL = "http://santosrp.com/youtubesantos/player.php?uid="
local twitchURL = "http://santosrp.com/youtubesantos/twitchplayer.php?vid="
function ENT:Initialize()
	self.m_vecCamPos = Vector( 6.175, -27.821627, 35.345478 )
	self.m_angCamAngs = Angle( 0, 90, 90 )
	self.m_intWidth, self.m_intHeight = 1920, 1920

	self.m_tblQuad = {
		[1] = Vector( 0, 0, 0 ),
		[2] = Vector( self.m_intWidth, 0, 0 ),
		[3] = Vector( self.m_intWidth, self.m_intHeight, 0 ),
		[4] = Vector( 0, self.m_intHeight, 0 )
	}

	self.m_strUID = "tv_".. tostring( self:EntIndex() ).. "_uid"
	self:ReloadPlayer()
end

function ENT:Reload()
	if ValidPanel( self.m_pnlWebPage ) then
		self.m_pnlWebPage:Remove()
	end

	if GAMEMODE.Config.HasDataCap:GetInt() == 1 then return end

	self.m_pnlWebPage = vgui.Create( "DHTML" )
	self.m_pnlWebPage:SetSize( self.m_intWidth, 1128 )
	self.m_pnlWebPage:SetPaintedManually( true )
	self.m_pnlWebPage:SetScrollbars( false )
	self.m_pnlWebPage:SetAllowLua( true )
	self.m_pnlWebPage:SetMouseInputEnabled( false )
	self.m_pnlWebPage:SetKeyBoardInputEnabled( false )
end

function ENT:OnRemove()
	self.m_pnlWebPage:Remove()
end

function ENT:HasPlayer()
	return self.m_bHasPlayer
end

function ENT:ReloadPlayer()
	self.m_bHasPlayer = nil
	self:Reload()
	if not ValidPanel( self.m_pnlWebPage ) then return end
	self.m_pnlWebPage:OpenURL( videoURL.. self.m_strUID )
end

function ENT:OnYoutubeLoaded()
	self.m_bHasPlayer = true
end

--Play, stop
function ENT:IsPlayingVideo()
	return self.m_bVideoStarted
end

function ENT:IsVideoLoaded()
	return self.m_bVideoLoaded
end

function ENT:LoadTwitch( strUserID )
	self.m_pnlWebPage:OpenURL( twitchURL.. strUserID )
	self.m_bVideoLoaded = true
end

function ENT:LoadVideo()
	self.m_pnlWebPage:RunJavascript( [[
		jQuery("#youtube-player-container")
			.tubeplayer("play", {
			id: "]].. self.m_strPlayingID.. [[",
			time: ]].. self.m_intPlayTime +(RealTime() -self.m_intStartPlay).. [[,
		});
	]] )

	self.m_bVideoLoaded = true
end

function ENT:UnloadVideo()
	if self.m_bPlayingTwitch then
		self.m_pnlWebPage:SetHTML( "" )
	elseif self:HasPlayer() then
		self.m_pnlWebPage:RunJavascript( [[
			jQuery("#youtube-player-container").tubeplayer("stop");
		]] )
	end

	self:ReloadPlayer()
	self.m_bVideoLoaded = false
end

function ENT:PlayVideo( strVideoID, intTime )
	if GAMEMODE.Config.HasDataCap:GetInt() == 1 then return end
	if not self:HasPlayer() then
		timer.Simple( 1, function()
			if not IsValid( self ) then return end
			self:PlayVideo( strVideoID, intTime +1 )
		end )

		return
	end
	
	self.m_intPlayTime = intTime
	self.m_intStartPlay = RealTime()
	self.m_strPlayingID = strVideoID
	self.m_bVideoStarted = true
	self.m_bVideoLoaded = false
	self.m_bPlayingTwitch = false
	self:LoadVideo()
end

function ENT:PlayTwitch( strTwitchUser )
	if GAMEMODE.Config.HasDataCap:GetInt() == 1 then return end
	--if not self:HasPlayer() then
	--	timer.Simple( 1, function()
	--		if not IsValid( self ) then return end
	--		self:LoadTwitch( strVideoID )
	--	end )
--
	--	return
	--end
	
	self.m_intPlayTime = 0
	self.m_intStartPlay = RealTime()
	self.m_strPlayingID = strTwitchUser
	self.m_bVideoStarted = true
	self.m_bVideoLoaded = false
	self.m_bPlayingTwitch = true
	self:LoadTwitch( strTwitchUser )
end

function ENT:StopVideo()
	self:UnloadVideo()
	self.m_bVideoStarted = false
	self.m_bPlayingTwitch = false
end

function ENT:GetMaxVolume()
	return GetConVarNumber( "srp_tv_volume" ) or 50
end

function ENT:UpdateVolume()
	if not self:HasPlayer() then return end
	if not ValidPanel( self.m_pnlWebPage ) then return end
	if not self:IsVideoLoaded() then return end
	
	local vol
	if self:GetMaxVolume() ~= 0 then
		local fallOff = 512
		local scaler = (fallOff -LocalPlayer():GetPos():Distance(self:GetPos())) /fallOff

		vol = Lerp( scaler, 0, self:GetMaxVolume() )
	else
		vol = 0
	end

	if not self.m_bPlayingTwitch then
		self.m_pnlWebPage:RunJavascript( [[
			jQuery("#youtube-player-container").tubeplayer("volume", ]].. vol.. [[);
		]] )
	end
end

function ENT:Draw()
	self:DrawModel()

	if not ValidPanel( self.m_pnlWebPage ) then 
		self:ReloadPlayer()
		return
	end

	local viewNorm = (self:GetPos() -EyePos()):GetNormalized()
	if viewNorm:Dot( self:GetAngles():Forward() * -1 ) <= 0 then
		return
	end

	local range = self.m_bPlayingTwitch and 256 or 1024
	if self:GetPos():Distance( EyePos() ) > range then
		return
	end

	if not self.m_intLastFrame or CurTime() > self.m_intLastFrame then
		self.m_pnlWebPage:UpdateHTMLTexture()
		self.m_intLastFrame = CurTime() +(1 /24)
	end

	self.m_matHTML = self.m_pnlWebPage:GetHTMLMaterial()
	if not self.m_matHTML then return end
	
	local old = render.GetToneMappingScaleLinear()
	render.SetToneMappingScaleLinear( Vector(1, 1, 1) )
		render.SuppressEngineLighting( true )
		render.PushFilterMag( 3 )
		render.PushFilterMin( 3 )

		cam.Start3D2D( self:LocalToWorld(self.m_vecCamPos), self:LocalToWorldAngles(self.m_angCamAngs), 0.031 )
			render.SetMaterial( self.m_matHTML )
			render.DrawQuad(
				self.m_tblQuad[1],
				self.m_tblQuad[2],
				self.m_tblQuad[3],
				self.m_tblQuad[4]
			)
		cam.End3D2D()			
		
		render.PopFilterMag()
		render.PopFilterMin()
		render.SuppressEngineLighting( false )
	render.SetToneMappingScaleLinear( old ) 
end

function ENT:Think()
	if not ValidPanel( self.m_pnlWebPage ) then return end
	if not self:HasPlayer() then return end
	
	if self:IsPlayingVideo() then
		local range = self.m_bPlayingTwitch and 256 or 1024
		if not self:IsVideoLoaded() then
			if LocalPlayer():GetPos():Distance( self:GetPos() ) <= range then
				if self.m_bPlayingTwitch then self:LoadTwitch(self.m_strPlayingID) else self:LoadVideo() end
			end
		else
			if LocalPlayer():GetPos():Distance( self:GetPos() ) > range then
				self:UnloadVideo()
			end
		end
	end

	self:UpdateVolume()
end

function ENT:ShowMenu()
	self.m_pnlMenu = vgui.Create( "SRPTVMenu" )
	self.m_pnlMenu:SetEntity( self )
	self.m_pnlMenu:SetSize( 640, 480 )
	self.m_pnlMenu:Center()
	self.m_pnlMenu:SetEntity( self )
	self.m_pnlMenu:SetVisible( true )
	self.m_pnlMenu:MakePopup()
	self.m_pnlMenu:Populate()
end

--Netcode
function ENT:RequestPlayVideo( strVideoID )
	net.Start( "ent_tv" )
		net.WriteUInt( self.NET_VIDEO_PLAY, 8 )
		net.WriteEntity( self )
		net.WriteString( strVideoID )
	net.SendToServer()
end

function ENT:RequestPlayTwitch( strTwitchUser )
	net.Start( "ent_tv" )
		net.WriteUInt( self.NET_VIDEO_PLAYT, 8 )
		net.WriteEntity( self )
		net.WriteString( strTwitchUser )
	net.SendToServer()
end

function ENT:RequestStopVideo()
	net.Start( "ent_tv" )
		net.WriteUInt( self.NET_VIDEO_STOP, 8 )
		net.WriteEntity( self )
	net.SendToServer()
end

--function ENT:RequestTakeTV()
--	net.Start( "ent_tv" )
--		net.WriteUInt( self.NET_VIDEO_TAKE, 8 )
--		net.WriteEntity( self )
--	net.SendToServer()
--end

net.Receive( "ent_tv", function( intMsgLen, pPlayer )
	local id, ent = net.ReadUInt( 8 ), net.ReadEntity()
	if not IsValid( ent ) then
		return
	end

	if id == ent.NET_VIDEO_PLAY then
		ent:PlayVideo( net.ReadString(), net.ReadUInt(32) )
	elseif id == ent.NET_VIDEO_STOP then
		ent:StopVideo()
	elseif id == ent.NET_VIDEO_MENU then
		ent:ShowMenu()
	elseif id == ent.NET_VIDEO_PLAYT then
		ent:PlayTwitch( net.ReadString() )
	end
end )

function OnYoutubeLoaded( strID )
	for k, ent in pairs( ents.FindByClass("ent_tv") ) do
		if ent.m_strUID ~= strID then continue end
		ent:OnYoutubeLoaded()
		break
	end
end

hook.Add( "GamemodeDataCapModeChanged", "UpdateTVs", function( strNewVal )
	if tonumber( strNewVal ) == 1 then
		for k, v in pairs( ents.FindByClass("ent_tv") ) do
			if ValidPanel( v.m_pnlWebPage ) then
				v.m_pnlWebPage:Remove()
			end
		end
	end
end )