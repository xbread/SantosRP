--[[
	Name: cl_qmenu_tab_settings.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "DermaLarge" )
	self.m_pnlNameLabel:SetText( "Sound Settings" )

	self.m_pnlRadioVolume = vgui.Create( "DNumSlider", self )
	self.m_pnlRadioVolume:SetConVar( "srp_pradio_volume" )
	self.m_pnlRadioVolume:SetMin( 0 )
	self.m_pnlRadioVolume:SetMax( 1 )
	self.m_pnlRadioVolume:SetText( "Radio Item Volume" )
	self.m_pnlRadioVolume.Label:SetTextInset( 5, 0 )
	self.m_pnlRadioVolume.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	self.m_pnlRadioVolume.PerformLayout = function()
		self.m_pnlRadioVolume.Label:SizeToContents()
		self.m_pnlRadioVolume.Label:SetWide( self.m_pnlRadioVolume.Label:GetWide() +5 )
	end

	self.m_pnlCarRadioVolume = vgui.Create( "DNumSlider", self )
	self.m_pnlCarRadioVolume:SetConVar( "srp_cradio_volume" )
	self.m_pnlCarRadioVolume:SetMin( 0 )
	self.m_pnlCarRadioVolume:SetMax( 1 )
	self.m_pnlCarRadioVolume:SetText( "Car Radio Volume" )
	self.m_pnlCarRadioVolume.Label:SetTextInset( 5, 0 )
	self.m_pnlCarRadioVolume.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	self.m_pnlCarRadioVolume.PerformLayout = function()
		self.m_pnlCarRadioVolume.Label:SizeToContents()
		self.m_pnlCarRadioVolume.Label:SetWide( self.m_pnlCarRadioVolume.Label:GetWide() +5 )
	end

	self.m_pnlTVVolume = vgui.Create( "DNumSlider", self )
	self.m_pnlTVVolume:SetConVar( "srp_tv_volume" )
	self.m_pnlTVVolume:SetMin( 0 )
	self.m_pnlTVVolume:SetMax( 100 )
	self.m_pnlTVVolume:SetText( "Television Volume" )
	self.m_pnlTVVolume.Label:SetTextInset( 5, 0 )
	self.m_pnlTVVolume.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	self.m_pnlTVVolume.PerformLayout = function()
		self.m_pnlTVVolume.Label:SizeToContents()
		self.m_pnlTVVolume.Label:SetWide( self.m_pnlTVVolume.Label:GetWide() +5 )
	end

	self.m_pnlRainVolume = vgui.Create( "DNumSlider", self )
	self.m_pnlRainVolume:SetConVar( "srp_rain_volume" )
	self.m_pnlRainVolume:SetMin( 0 )
	self.m_pnlRainVolume:SetMax( 255 )
	self.m_pnlRainVolume:SetText( "Rain Volume" )
	self.m_pnlRainVolume.Label:SetTextInset( 5, 0 )
	self.m_pnlRainVolume.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	self.m_pnlRainVolume.PerformLayout = function()
		self.m_pnlRainVolume.Label:SizeToContents()
		self.m_pnlRainVolume.Label:SetWide( self.m_pnlRainVolume.Label:GetWide() +5 )
	end

	self.m_pnlRainTVolume = vgui.Create( "DNumSlider", self )
	self.m_pnlRainTVolume:SetConVar( "srp_rain_thunder_volume" )
	self.m_pnlRainTVolume:SetMin( 0 )
	self.m_pnlRainTVolume:SetMax( 100 )
	self.m_pnlRainTVolume:SetText( "Thunder Volume" )
	self.m_pnlRainTVolume.Label:SetTextInset( 5, 0 )
	self.m_pnlRainTVolume.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	self.m_pnlRainTVolume.PerformLayout = function()
		self.m_pnlRainTVolume.Label:SizeToContents()
		self.m_pnlRainTVolume.Label:SetWide( self.m_pnlRainTVolume.Label:GetWide() +5 )
	end
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 40, 40, 40, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:DockMargin( 5, 0, 5, 5 )
	self.m_pnlNameLabel:Dock( TOP )

	self.m_pnlRadioVolume:SetTall( 32 )
	self.m_pnlRadioVolume:DockMargin( 5, 0, 5, 5 )
	self.m_pnlRadioVolume:Dock( TOP )

	self.m_pnlCarRadioVolume:SetTall( 32 )
	self.m_pnlCarRadioVolume:DockMargin( 5, 0, 5, 5 )
	self.m_pnlCarRadioVolume:Dock( TOP )

	self.m_pnlTVVolume:SetTall( 32 )
	self.m_pnlTVVolume:DockMargin( 5, 0, 5, 5 )
	self.m_pnlTVVolume:Dock( TOP )

	self.m_pnlRainVolume:SetTall( 32 )
	self.m_pnlRainVolume:DockMargin( 5, 0, 5, 5 )
	self.m_pnlRainVolume:Dock( TOP )

	self.m_pnlRainTVolume:SetTall( 32 )
	self.m_pnlRainTVolume:DockMargin( 5, 0, 5, 5 )
	self.m_pnlRainTVolume:Dock( TOP )
end
vgui.Register( "SRPQMenu_Settings_Sound", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "DermaLarge" )
	self.m_pnlNameLabel:SetText( "Gameplay Settings" )

	self.m_pnlCamRPos = vgui.Create( "DNumSlider", self )
	self.m_pnlCamRPos:SetConVar( "srp_cam_side" )
	self.m_pnlCamRPos:SetMin( 0 )
	self.m_pnlCamRPos:SetMax( 32 )
	self.m_pnlCamRPos:SetText( "Camera Right Offset" )
	self.m_pnlCamRPos.Label:SetTextInset( 5, 0 )
	self.m_pnlCamRPos.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	self.m_pnlCamRPos.PerformLayout = function()
		self.m_pnlCamRPos.Label:SizeToContents()
		self.m_pnlCamRPos.Label:SetWide( self.m_pnlCamRPos.Label:GetWide() +5 )
	end

	self.m_pnlCamBPos = vgui.Create( "DNumSlider", self )
	self.m_pnlCamBPos:SetConVar( "srp_cam_back" )
	self.m_pnlCamBPos:SetMin( 24 )
	self.m_pnlCamBPos:SetMax( 128 )
	self.m_pnlCamBPos:SetText( "Camera Back Offset" )
	self.m_pnlCamBPos.Label:SetTextInset( 5, 0 )
	self.m_pnlCamBPos.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	self.m_pnlCamBPos.PerformLayout = function()
		self.m_pnlCamBPos.Label:SizeToContents()
		self.m_pnlCamBPos.Label:SetWide( self.m_pnlCamBPos.Label:GetWide() +5 )
	end

	self.m_pnlDataCapMode = vgui.Create( "DCheckBoxLabel", self )
	self.m_pnlDataCapMode:SetConVar( "srp_datacap_mode" )
	self.m_pnlDataCapMode:SetText( "Disable streaming web content (Data Cap Mode)" )

	self.m_pnlLightMode = vgui.Create( "DCheckBoxLabel", self )
	self.m_pnlLightMode:SetConVar( "srp_lightsensitive_mode" )
	self.m_pnlLightMode:SetText( "Disable light flashes (For users with epilepsy/seizure conditions)" )
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 40, 40, 40, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:DockMargin( 5, 0, 5, 5 )
	self.m_pnlNameLabel:Dock( TOP )

	self.m_pnlCamRPos:SetTall( 32 )
	self.m_pnlCamRPos:DockMargin( 5, 0, 5, 5 )
	self.m_pnlCamRPos:Dock( TOP )

	self.m_pnlCamBPos:SetTall( 32 )
	self.m_pnlCamBPos:DockMargin( 5, 0, 5, 5 )
	self.m_pnlCamBPos:Dock( TOP )

	self.m_pnlDataCapMode:SetTall( 32 )
	self.m_pnlDataCapMode:DockMargin( 5, 0, 5, 5 )
	self.m_pnlDataCapMode:Dock( TOP )

	self.m_pnlLightMode:SetTall( 32 )
	self.m_pnlLightMode:DockMargin( 5, 0, 5, 5 )
	self.m_pnlLightMode:Dock( TOP )
end
vgui.Register( "SRPQMenu_Settings_Gameplay", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "DermaLarge" )
	self.m_pnlNameLabel:SetText( "Performance Settings" )

	self.m_pnlPACRange = vgui.Create( "DNumSlider", self )
	self.m_pnlPACRange:SetConVar( "srp_pac_drawrange" )
	self.m_pnlPACRange:SetMin( 128 )
	self.m_pnlPACRange:SetMax( 4096 )
	self.m_pnlPACRange:SetText( "PAC Draw Distance" )
	self.m_pnlPACRange.Label:SetTextInset( 5, 0 )
	self.m_pnlPACRange.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	self.m_pnlPACRange.PerformLayout = function()
		self.m_pnlPACRange.Label:SizeToContents()
		self.m_pnlPACRange.Label:SetWide( self.m_pnlPACRange.Label:GetWide() +5 )
	end


	self.m_pnlRainNum = vgui.Create( "DNumSlider", self )
	self.m_pnlRainNum:SetConVar( "srp_max_rain_particles" )
	self.m_pnlRainNum:SetMin( 0 )
	self.m_pnlRainNum:SetMax( 48 )
	self.m_pnlRainNum:SetText( "Rain Particle Count" )
	self.m_pnlRainNum.Label:SetTextInset( 5, 0 )
	self.m_pnlRainNum.TextArea:SetTextColor( Color(200, 200, 200, 255) )
	self.m_pnlRainNum.PerformLayout = function()
		self.m_pnlRainNum.Label:SizeToContents()
		self.m_pnlRainNum.Label:SetWide( self.m_pnlRainNum.Label:GetWide() +5 )
	end
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 40, 40, 40, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:DockMargin( 5, 0, 5, 5 )
	self.m_pnlNameLabel:Dock( TOP )

	self.m_pnlPACRange:SetTall( 32 )
	self.m_pnlPACRange:DockMargin( 5, 0, 5, 5 )
	self.m_pnlPACRange:Dock( TOP )

	self.m_pnlRainNum:SetTall( 32 )
	self.m_pnlRainNum:DockMargin( 5, 0, 5, 5 )
	self.m_pnlRainNum:Dock( TOP )
end
vgui.Register( "SRPQMenu_Settings_Performance", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlSound = vgui.Create( "SRPQMenu_Settings_Sound", self )
	self.m_pnlGameplay = vgui.Create( "SRPQMenu_Settings_Gameplay", self )
	self.m_pnlPerf = vgui.Create( "SRPQMenu_Settings_Performance", self )
end

function Panel:Refresh()
	self:InvalidateLayout()
end

function Panel:PerformLayout( intW, intH )
	local w, h = (intW -10) /2, (intH -10) /2

	self.m_pnlSound:SetSize( w, h  )
	self.m_pnlGameplay:SetSize( w, h  )
	self.m_pnlPerf:SetSize( w, h  )

	self.m_pnlPerf:SetPos( 5, 5 )
	self.m_pnlGameplay:SetPos( w +5, 5 )
	self.m_pnlSound:SetPos( 5, h +5 )
end
vgui.Register( "SRPQMenu_Settings", Panel, "EditablePanel" )