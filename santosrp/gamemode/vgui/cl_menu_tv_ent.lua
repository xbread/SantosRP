--[[
	Name: cl_menu_tv_ent.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "CarMenuFont" )

	self.m_pnlPlayBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlPlayBtn:SetFont( "CarMenuFont" )
	self.m_pnlPlayBtn:SetText( "Play" )
	self.m_pnlPlayBtn:SetAlpha( 150 )
	self.m_pnlPlayBtn.DoClick = function()
		self.m_pnlParentMenu.m_entTV:RequestPlayVideo( self.m_strVideoID )
	end
end

function Panel:SetName( strName )
	self.m_pnlNameLabel:SetText( strName )
	self:InvalidateLayout()
end

function Panel:SetID( strID )
	self.m_strVideoID = strID
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	local padding = 5

	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetWide( intW )
	self.m_pnlNameLabel:SetPos( padding, (intH /2) -(self.m_pnlNameLabel:GetTall() /2) )
	
	self.m_pnlPlayBtn:SetSize( 110, intH )
	self.m_pnlPlayBtn:SetPos( intW -self.m_pnlPlayBtn:GetWide(), 0 )
end
vgui.Register( "SRPTVPresetCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetTitle( "Television Menu" )
	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}

	self.m_pnlStopBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlStopBtn:SetFont( "CarMenuFont" )
	self.m_pnlStopBtn:SetText( "Stop Video" )
	self.m_pnlStopBtn:SetAlpha( 150 )
	self.m_pnlStopBtn.DoClick = function()
		self.m_entTV:RequestStopVideo()
	end

	--self.m_pnlTakeBtn = vgui.Create( "SRP_Button", self )
	--self.m_pnlTakeBtn:SetFont( "CarMenuFont" )
	--self.m_pnlTakeBtn:SetText( "Take TV" )
	--self.m_pnlTakeBtn:SetAlpha( 150 )
	--self.m_pnlTakeBtn.DoClick = function()
	--	self.m_entTV:RequestTakeTV()
	--end

	self.m_pnlCustomID = vgui.Create( "EditablePanel", self )
	self.m_pnlCustomID.PlayBtn = vgui.Create( "SRP_Button", self.m_pnlCustomID )
	self.m_pnlCustomID.PlayBtn:SetFont( "Trebuchet18" )
	self.m_pnlCustomID.PlayBtn:SetText( "Play Youtube" )
	self.m_pnlCustomID.PlayBtn:SetAlpha( 150 )
	self.m_pnlCustomID.PlayBtn.DoClick = function()
		if self.m_pnlCustomID.TextEntry:GetValue() == "" then return end
		self.m_entTV:RequestPlayVideo( self.m_pnlCustomID.TextEntry:GetValue() )
	end
	self.m_pnlCustomID.TextEntry = vgui.Create( "DTextEntry", self.m_pnlCustomID )
	self.m_pnlCustomID.TextEntry.OnEnter = self.m_pnlCustomID.PlayBtn.DoClick
	self.m_pnlCustomID.PerformLayout = function( p, intW, intH )
		p.PlayBtn:SetSize( 110, intH )
		p.PlayBtn:SetPos( intW -p.PlayBtn:GetWide(), 0 )

		p.TextEntry:SetSize( intW -p.PlayBtn:GetWide(), intH )
		p.TextEntry:SetPos( 0, 0 )
	end
	self.m_pnlCustomID.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 200 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlCustomTW = vgui.Create( "EditablePanel", self )
	self.m_pnlCustomTW.PlayBtn = vgui.Create( "SRP_Button", self.m_pnlCustomTW )
	self.m_pnlCustomTW.PlayBtn:SetFont( "Trebuchet18" )
	self.m_pnlCustomTW.PlayBtn:SetText( "Play Twitch" )
	self.m_pnlCustomTW.PlayBtn:SetAlpha( 150 )
	self.m_pnlCustomTW.PlayBtn.DoClick = function()
		if self.m_pnlCustomTW.TextEntry:GetValue() == "" then return end
		self.m_entTV:RequestPlayTwitch( self.m_pnlCustomTW.TextEntry:GetValue() )
	end
	self.m_pnlCustomTW.TextEntry = vgui.Create( "DTextEntry", self.m_pnlCustomTW )
	self.m_pnlCustomTW.TextEntry.OnEnter = self.m_pnlCustomTW.PlayBtn.DoClick
	self.m_pnlCustomTW.PerformLayout = function( p, intW, intH )
		p.PlayBtn:SetSize( 110, intH )
		p.PlayBtn:SetPos( intW -p.PlayBtn:GetWide(), 0 )

		p.TextEntry:SetSize( intW -p.PlayBtn:GetWide(), intH )
		p.TextEntry:SetPos( 0, 0 )
	end
	self.m_pnlCustomTW.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 200 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlVolume = vgui.Create( "DNumSlider", self )
	self.m_pnlVolume:SetConVar( "srp_tv_volume" )
	self.m_pnlVolume:SetMin( 0 )
	self.m_pnlVolume:SetMax( 100 )
	self.m_pnlVolume:SetText( "Volume" )
	self.m_pnlVolume.Label:SetTextInset( 5, 0 )
	self.m_pnlVolume.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	self.m_pnlVolume.PerformLayout = function()
		self.m_pnlVolume.Label:SizeToContents()
		self.m_pnlVolume.Label:SetWide( self.m_pnlVolume.Label:GetWide() +5 )
	end
	self.m_pnlVolume.Paint = function( p, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 100 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlCustomID:SetTall( 32 )
	self.m_pnlCanvas:AddItem( self.m_pnlCustomID )
	self.m_pnlCustomTW:SetTall( 32 )
	self.m_pnlCanvas:AddItem( self.m_pnlCustomTW )
end

function Panel:SetEntity( eEnt )
	self.m_entTV = eEnt
end

function Panel:Think()
	if not IsValid( self.m_entTV ) then
		self:Remove()
	end
end

function Panel:Populate()
	for k, v in pairs( self.m_tblCards ) do
		if ValidPanel( v ) then v:Remove() end
		self.m_tblCards[k] = nil
	end

	for _, data in pairs( self.m_entTV.m_tblPresets ) do
		self:CreatePresetCard( data.Name, data.ID )
	end

	self:InvalidateLayout()
end

function Panel:CreatePresetCard( strName, strID )
	local pnl = vgui.Create( "SRPTVPresetCard" )
	pnl:SetName( strName )
	pnl:SetID( strID )
	pnl.m_pnlParentMenu = self
	self.m_pnlCanvas:AddItem( pnl )
	self.m_tblCards[#self.m_tblCards +1] = pnl

	return pnl
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )

	self.m_pnlStopBtn:SetSize( intW, 32 )
	self.m_pnlStopBtn:SetPos( 0, intH -self.m_pnlStopBtn:GetTall() )

	self.m_pnlVolume:SetSize( intW, 32 )
	self.m_pnlVolume:SetPos( 0, intH -self.m_pnlStopBtn:GetTall() -self.m_pnlVolume:GetTall() )

	self.m_pnlCanvas:SetPos( 0, 24 )
	self.m_pnlCanvas:SetSize( intW, intH -24 -self.m_pnlStopBtn:GetTall() -self.m_pnlVolume:GetTall() )

	self.m_pnlCustomID:DockMargin( 0, 0, 0, 5 )
	self.m_pnlCustomID:SetTall( 32 )
	self.m_pnlCustomID:Dock( TOP )

	self.m_pnlCustomTW:DockMargin( 0, 0, 0, 5 )
	self.m_pnlCustomTW:SetTall( 32 )
	self.m_pnlCustomTW:Dock( TOP )
	
	for _, pnl in pairs( self.m_tblCards ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 32 )
		pnl:Dock( TOP )
	end
end
vgui.Register( "SRPTVMenu", Panel, "SRP_Frame" )