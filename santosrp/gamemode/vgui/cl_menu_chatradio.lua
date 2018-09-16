--[[
	Name: cl_menu_chatradio.lua
	For: TalosLife
	By: TalosLife
]]--

local MAT_SHIELD = Material( "icon16/shield.png", "noclamp" )
local MAT_LOCK = Material( "icon16/lock.png", "noclamp" )

local Panel = {}
function Panel:Init()
	self:SetTitle( "Voice Chat Radio" )
	self:SetDeleteOnClose( false )

	self.m_intCurSelection = GAMEMODE.Config.DefaultChatRadioChannel

	self.m_pnlBtnNext = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnNext:SetFont( "DermaLarge" )
	self.m_pnlBtnNext:SetText( ">" )
	self.m_pnlBtnNext.DoClick = function( pnl )
		self:NextSelection()
	end

	self.m_pnlBtnPrev = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnPrev:SetFont( "DermaLarge" )
	self.m_pnlBtnPrev:SetText( "<" )
	self.m_pnlBtnPrev.DoClick = function( pnl )
		self:PrevSelection()
	end

	self.m_pnlBtnMute = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnMute:SetFont( "DermaLarge" )
	self.m_pnlBtnMute:SetText( "Mute" )
	self.m_pnlBtnMute.DoClick = function( pnl )
		GAMEMODE.ChatRadio:RequestMuteRadio( not self.m_bMuted )
		self.m_bMuted = not self.m_bMuted
		self.m_pnlBtnMute:SetText( self.m_bMuted and "Unmute" or "Mute" )
	end

	self.m_pnlChanIDLabel = vgui.Create( "DLabel", self )
	self.m_pnlChanIDLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlChanIDLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlChanIDLabel:SetFont( "Trebuchet24" )
	self.m_pnlChanIDLabel:SetText( " " )

	self.m_pnlChanDescLabel = vgui.Create( "DLabel", self )
	self.m_pnlChanDescLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlChanDescLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlChanDescLabel:SetFont( "Trebuchet24" )
	self.m_pnlChanDescLabel:SetText( " " )

	hook.Add( "GamemodeChatRadioChannelChanged", "UpdateRadioMenu", function( intNewChan )
		if intNewChan then
			self.m_intCurSelection = intNewChan
			self.m_pnlChanIDLabel:SetText( "Channel ".. tostring(intNewChan).. "/".. tostring(#GAMEMODE.ChatRadio:GetChannels()) )
			self.m_pnlChanDescLabel:SetText( GAMEMODE.ChatRadio:GetChannel(intNewChan).Name )
			self:InvalidateLayout()
		else
			self.m_bMuted = nil
			self.m_pnlBtnMute:SetText( "Mute" )
		end
	end )
end

function Panel:PaintOver( intW, intH )
	if not self.m_intCurSelection then return end
	if not GAMEMODE.ChatRadio:IsChannelEncrypted( self.m_intCurSelection ) then return end
	if GAMEMODE.ChatRadio:HasChannelKey( self.m_intCurSelection ) then return end
	
	local x, y = self.m_pnlChanIDLabel:GetPos()
	local w, h = self.m_pnlChanIDLabel:GetSize()
	local imgWide = 24
	surface.SetMaterial( MAT_LOCK )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( x -imgWide -5, (y +(h /2)) -(imgWide /2), imgWide, imgWide )
end

function Panel:NextSelection()
	local newChan = self.m_intCurSelection +1
	if newChan > #GAMEMODE.ChatRadio:GetChannels() then
		newChan = 1
	end

	GAMEMODE.ChatRadio:RequestSetChannel( newChan )
end

function Panel:PrevSelection()
	local newChan = self.m_intCurSelection -1
	if newChan < 1 then
		newChan = #GAMEMODE.ChatRadio:GetChannels()
	end

	GAMEMODE.ChatRadio:RequestSetChannel( newChan )
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )

	local half = intW /2
	self.m_pnlBtnPrev:SetSize( half, 48 )
	self.m_pnlBtnPrev:SetPos( 0, 24 )

	self.m_pnlBtnNext:SetSize( half, 48 )
	self.m_pnlBtnNext:SetPos( intW -self.m_pnlBtnNext:GetWide(), 24 )

	self.m_pnlBtnMute:SetSize( intW, 48 )
	self.m_pnlBtnMute:SetPos( 0, intH -self.m_pnlBtnMute:GetTall() )

	self.m_pnlChanIDLabel:SizeToContents()
	self.m_pnlChanIDLabel:SetPos( half -(self.m_pnlChanIDLabel:GetWide() /2), 24 +self.m_pnlBtnNext:GetTall() +5 )

	self.m_pnlChanDescLabel:SizeToContents()
	self.m_pnlChanDescLabel:SetPos( half -(self.m_pnlChanDescLabel:GetWide() /2), 24 +self.m_pnlBtnNext:GetTall() +self.m_pnlChanIDLabel:GetTall() +10 )
end

function Panel:Think()
	if not GAMEMODE.ChatRadio:HasRadio() and self:IsVisible() then
		self:Close()
	end
end

function Panel:Open()
	if not GAMEMODE.ChatRadio:HasRadio() then return end
	
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:Close()
	self:SetVisible( false )
end
vgui.Register( "SRPChatRadioMenu", Panel, "SRP_Frame" )