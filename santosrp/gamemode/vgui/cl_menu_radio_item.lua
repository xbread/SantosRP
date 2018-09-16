--[[
	Name: cl_menu_radio_item.lua
	For: TalosLife
	By: TalosLife
]]--

local RADIO_TAKE = 5

local Panel = {}
function Panel:Init()
	self.m_colSold = Color( 255, 50, 50, 255 )
	self.m_colSell = Color( 50, 255, 50, 255 )
	self.m_colPrice = Color( 120, 230, 110, 255 )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "CarMenuFont" )

	self.m_pnlPlayBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlPlayBtn:SetFont( "DermaLarge" )
	self.m_pnlPlayBtn:SetText( "Play" )
	self.m_pnlPlayBtn:SetAlpha( 150 )
	self.m_pnlPlayBtn.DoClick = function()
		GAMEMODE.Net:RequestPlayPropRadio( LocalPlayer():GetEyeTrace().Entity, self.m_intID )
	end
end

function Panel:SetStation( id, tblData )
	self.m_intID = id
	self.m_tblData = tblData
	self.m_pnlNameLabel:SetText( tblData.Name )
	self:InvalidateLayout()
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
vgui.Register( "SRPRadioStationCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetTitle( "Radio" )

	self.m_pnlStationList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblStations = {}

	self.m_pnlStopBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlStopBtn:SetFont( "DermaLarge" )
	self.m_pnlStopBtn:SetText( "Stop" )
	self.m_pnlStopBtn:SetAlpha( 150 )
	self.m_pnlStopBtn.DoClick = function()
		GAMEMODE.Net:RequestStopPropRadio( LocalPlayer():GetEyeTrace().Entity )
	end

	self.m_pnlVolume = vgui.Create( "DNumSlider", self )
	self.m_pnlVolume:SetConVar( "srp_pradio_volume" )
	self.m_pnlVolume:SetMin( 0 )
	self.m_pnlVolume:SetMax( 1 )
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
end

function Panel:Refresh()
	for k, v in pairs( self.m_tblStations ) do
		if ValidPanel( v ) then v:Remove() end
	end

	self.m_tblStations = {}

	for k, v in pairs( GAMEMODE.CarRadio.m_tblStations ) do
		local pnl = vgui.Create( "SRPRadioStationCard", self.m_pnlStationList )
		pnl:SetStation( k, v )
		self.m_tblStations[#self.m_tblStations +1] = pnl
	end

	if LocalPlayer():CheckGroup( "vip" ) then
		local pnl = vgui.Create( "EditablePanel", self.m_pnlStationList )
		pnl.m_intSizeOverride = 32
		pnl.Paint = function( p, intW, intH )
			surface.SetDrawColor( 50, 50, 50, 200 )
			surface.DrawRect( 0, 0, intW, intH )
		end

		pnl.m_pnlText = vgui.Create( "DTextEntry", pnl )
		pnl.m_pnlPlayBtn = vgui.Create( "SRP_Button", pnl )
		pnl.m_pnlPlayBtn:SetFont( "DermaLarge" )
		pnl.m_pnlPlayBtn:SetText( "Play ID" )
		pnl.m_pnlPlayBtn:SetAlpha( 150 )
		pnl.m_pnlPlayBtn.DoClick = function()
			if not pnl.m_pnlText:GetValue() or pnl.m_pnlText:GetValue() == "" then return end
			if not tonumber( pnl.m_pnlText:GetValue() ) then return end
			GAMEMODE.Net:RequestPlayCustomPropRadio( LocalPlayer():GetEyeTrace().Entity, tonumber(pnl.m_pnlText:GetValue()) )
		end	
		pnl.PerformLayout = function( p, intW, intH )
			local padding = 5

			pnl.m_pnlPlayBtn:SetSize( 110, intH )
			pnl.m_pnlPlayBtn:SetPos( intW -pnl.m_pnlPlayBtn:GetWide(), 0 )

			pnl.m_pnlText:SetSize( intW -pnl.m_pnlPlayBtn:GetWide(), intH )
			pnl.m_pnlText:SetPos( 0, 0 )
		end

		self.m_tblStations[#self.m_tblStations +1] = pnl
	end
	self:InvalidateLayout()
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )

	local padding = 5

	self.m_pnlStopBtn:SetSize( intW, 32 )
	self.m_pnlStopBtn:SetPos( 0, intH -self.m_pnlStopBtn:GetTall() )

	self.m_pnlVolume:SetSize( intW, 32 )
	self.m_pnlVolume:SetPos( 0, intH -self.m_pnlStopBtn:GetTall() -self.m_pnlVolume:GetTall() )

	self.m_pnlStationList:SetPos( padding, 24 )
	self.m_pnlStationList:SetSize( intW -(padding *2), intH -24 -self.m_pnlStopBtn:GetTall() -self.m_pnlVolume:GetTall() )

	for _, pnl in pairs( self.m_tblStations ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( pnl.m_intSizeOverride or 48 )
		pnl:Dock( TOP )
	end
end
vgui.Register( "SRPItemRadio", Panel, "SRP_Frame" )