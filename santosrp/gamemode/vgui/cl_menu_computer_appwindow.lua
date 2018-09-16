--[[
	Name: cl_menu_computer_appwindow.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
AccessorFunc( Panel, "m_bDraggable","Draggable", FORCE_BOOL )
AccessorFunc( Panel, "m_bSizable", "Sizable", FORCE_BOOL )
AccessorFunc( Panel, "m_bScreenLock","ScreenLock", FORCE_BOOL )
AccessorFunc( Panel, "m_iMinWidth", "MinWidth" )
AccessorFunc( Panel, "m_iMinHeight", "MinHeight" )

function Panel:Init()
	self:SetFocusTopLevel( true )

	self.m_pnlBtnClose = vgui3D.Create( "DButton", self )
	self.m_pnlBtnClose:SetText( "" )
	self.m_pnlBtnClose.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowCloseButton", panel, w, h ) end
	self.m_pnlBtnClose.DoClick = function()
		self:Close()
	end

	self.m_pnlBtnFull = vgui3D.Create( "DButton", self )
	self.m_pnlBtnFull:SetText( "" )
	self.m_pnlBtnFull.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowMaximizeButton", panel, w, h ) end
	self.m_pnlBtnFull.DoClick = function()
		self:Fullscreen()
	end

	self.m_pnlBtnMin = vgui3D.Create( "DButton", self )
	self.m_pnlBtnMin:SetText( "" )
	self.m_pnlBtnMin.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowMinimizeButton", panel, w, h ) end
	self.m_pnlBtnMin.DoClick = function()
		self:Minimize()
	end

	self.m_pnlLabelWindow = vgui3D.Create( "DLabel", self )
	self.m_pnlLabelWindow:SetText( "App Window" )
	self.m_pnlLabelWindow:SetTextColor( Color(240, 240, 240, 255) )
	self.m_pnlLabelWindow:SetFont( "Trebuchet18" )

	self.m_intTopBarHeight = 24
	self:SetDraggable( true )
	self:SetSizable( true )
	self:SetScreenLock( true )
	self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )

	self:NoClipping( true )

	self.m_bDeleteOnClose = true
end

function Panel:SetDesktop( pnlDesktop )
	self.m_pnlDesktop = pnlDesktop
end

function Panel:GetDesktop()
	return self.m_pnlDesktop
end

function Panel:SetApp( tblApp )
	self.m_tblApp = tblApp

	if tblApp.Icon then
		self:SetIcon( tblApp.Icon)
	end

	self.m_pnlAppWindow = vgui3D.Create( tblApp.Panel, self )
	self:InvalidateLayout()
end

function Panel:SetTitle( str )
	self.m_pnlLabelWindow:SetText( str )
	self:InvalidateLayout()
end

function Panel:GetTitle()
	return self.m_pnlLabelWindow:GetText()
end

function Panel:SetIcon( strIcon )
	self.m_strIcon = strIcon
	self.m_matIcon = Material( strIcon, "" )
end

function Panel:Paint( intW, intH )
	derma.SkinHook( "Paint", "Frame", self, intW, intH )

	if self.m_matIcon then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.m_matIcon )
		surface.DrawTexturedRect( 3, (self.m_intTopBarHeight /2) -8, 16, 16 )
	end

	return true
end

function Panel:Think()
	if not ValidPanel( self:GetDesktop() ) then return end

	local root = self:GetDesktop()
	local parent = self:GetParent()
	local mousex, mousey = root:GetMousePos()

	if self.Dragging then
		local x = mousex -self.Dragging[1]
		local y = mousey -self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if self:GetScreenLock() then
			x = math.Clamp( x, 0, parent:GetWide() -self:GetWide() )
			y = math.Clamp( y, 0, parent:GetTall() -self:GetTall() )
		end

		self:SetPos( x, y )
	end

	if self.Sizing then
		local x = mousex -self.Sizing[1]
		local y = mousey -self.Sizing[2]
		local px, py = self:GetPos()

		if x < self.m_iMinWidth then
			x = self.m_iMinWidth
		elseif x > parent:GetWide() -px and self:GetScreenLock() then
			x = parent:GetWide() - px
		end

		if y < self.m_iMinHeight then
			y = self.m_iMinHeight
		elseif y > parent:GetTall() - py and self:GetScreenLock()
			then y = parent:GetTall() - py
		end

		self:SetSize( x, y )
		self:SetCursor( "sizenwse" )
		return
	end

	if self.Hovered and self.m_bSizable and
		mousex > (self.x +self:GetWide() -20 ) and
		mousey > (self.y +self:GetTall() -20 ) then

		self:SetCursor( "sizenwse" )
		return
	end

	if self.Hovered and self:GetDraggable() and mousey < (self.y +24) then
		self:SetCursor( "sizeall" )
		return
	end

	self:SetCursor( "arrow" )

	-- Don't allow the frame to go higher than 0
	if self.y < 0 then
		self:SetPos( self.x, 0 )
	end
end

function Panel:OnMousePressed()
	self:MoveToFront()
	self:RequestFocus()

	if self.m_bSizable then
		if gui.MouseX() > (self.x +self:GetWide() -20) and
			gui.MouseY() > (self.y +self:GetTall() -20) then

			self.Sizing = { gui.MouseX() -self:GetWide(), gui.MouseY() -self:GetTall() }
			self:MouseCapture( true )
			self.m_bFullscreen = false

			return
		end
	end

	if self:GetDraggable() and gui.MouseY() < (self.y +24) and not self.m_bFullscreen then
		self.Dragging = { gui.MouseX() -self.x, gui.MouseY() -self.y }
		self:MouseCapture( true )
		return
	end
end

function Panel:OnMouseReleased()
	self.Dragging = nil
	self.Sizing = nil
	self:MouseCapture( false )
end

function Panel:OnEventHandled( strEvent )
	if strEvent == "OnMousePressed" or strEvent == "OnMouseReleased" then
		self:MoveToFront()
		self:RequestFocus()
	end
end

function Panel:Close()
	if self.OnClose then
		self:OnClose()
	end

	self:SetVisible( false )
	self:GetDesktop():GetTaskBar():RemoveAppWindow( self )
	self:Remove()
end

function Panel:Fullscreen()
	if not self.m_bFullscreen then
		self.m_intOldW = self:GetWide()
		self.m_intOldH = self:GetTall()
		self.m_intOldX, self.m_intOldY = self:GetPos()
		self.m_bFullscreen = true

		local w, h = self:GetDesktop():GetSize()
		local barTall = self:GetDesktop().m_intTaskbarHeight or 0

		self:SetSize( w, h -barTall )
		self:SetPos( 0, 0 )
		self:InvalidateLayout()
	else
		self.m_bFullscreen = false
		self:SetSize( self.m_intOldW or 200, self.m_intOldH or 125 )
		self:SetPos( self.m_intOldX or 0, self.m_intOldY or 0 )
		self:InvalidateLayout()
	end
end

function Panel:Minimize()
	if not self.m_bMinimized then
		self:SetVisible( false )
		self.m_bMinimized = true
	else
		self:SetVisible( true )
		self.m_bMinimized = false
	end
end

function Panel:IsMinimized()
	return self.m_bMinimized
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlLabelWindow:SizeToContents()

	self.m_pnlBtnClose:SetPos( intW - 31 - 4, 0 )
	self.m_pnlBtnClose:SetSize( 31, 31 )

	self.m_pnlBtnFull:SetPos( intW - 31 * 2 - 4, 0 )
	self.m_pnlBtnFull:SetSize( 31, 31 )

	self.m_pnlBtnMin:SetPos( intW - 31 * 3 - 4, 0 )
	self.m_pnlBtnMin:SetSize( 31, 31 )

	local inset = self.m_matIcon and 13 or 0
	self.m_pnlLabelWindow:SetPos( 8 +inset, 2 )
	self.m_pnlLabelWindow:SetSize( intW -25, 20 )

	if ValidPanel( self.m_pnlAppWindow ) then
		self.m_pnlAppWindow:SetPos( 1, self.m_intTopBarHeight +1 )
		self.m_pnlAppWindow:SetSize( intW -2, intH -self.m_intTopBarHeight -2 )
	end
end
vgui.Register( "SRPComputer_AppWindow", Panel, "EditablePanel" )