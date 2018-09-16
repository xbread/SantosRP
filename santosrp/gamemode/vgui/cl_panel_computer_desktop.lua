local Panel = {}
function Panel:Init()
	self:SetText( " " )
	self.m_pnlLabelName = vgui3D.Create( "DLabel", self )
	self.m_pnlLabelName:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlLabelName:SetFont( "Trebuchet18" )
	self.m_pnlLabelName:SetMouseInputEnabled( false )
	--self.m_pnlLabelName:SetWrap( true )
	self:SetMouseInputEnabled( true )
end

function Panel:SetApp( tblApp )
	self.m_tblApp = tblApp

	if tblApp.Icon then
		self:SetIcon( tblApp.Icon )
	end

	if tblApp.Name then
		self.m_pnlLabelName:SetText( tblApp.Name )
	end

	self:InvalidateLayout()
end

function Panel:SetIcon( strIcon )
	self.m_strIcon = strIcon
	self.m_matIcon = Material( strIcon, "" )
end

function Panel:Paint( intW, intH )
	if self.Hovered then
		surface.SetDrawColor( 78, 85, 89, 180 )
	else
		surface.SetDrawColor( 49, 53, 55, 180 )
	end
	surface.DrawRect( 0, 0, intW, intH )

	if self.m_matIcon then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.m_matIcon )
		surface.DrawTexturedRect( 0, 0, intH, intH )
	end
end

function Panel:DoClick()
	--fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
	self:GetParent():GetParent():GetParent():GetParent():LaunchApp( self.m_tblApp.ID )
	self:GetParent():GetParent():GetParent():CloseStartMenu()
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlLabelName:SizeToContents()
	self.m_pnlLabelName:SetWide( math.min(self.m_pnlLabelName:GetWide(), intW -intH -5) )
	self.m_pnlLabelName:SetPos( intH +5, (intH /2) -(self.m_pnlLabelName:GetTall() /2) )
end
vgui.Register( "SRPComputer_AppIconListLine", Panel, "DButton" )



local Panel = {}
function Panel:Init()
	self.m_tblAppList = {}

	self.m_pnlAppList = vgui3D.Create( "SRPComputer_ScrollPanel", self )
	self.m_pnlAppList:SetMouseInputEnabled( true )
	self.m_pnlAppList.Paint = function( _, intW, intH )
	end

	self.m_pnlBtnExit = vgui3D.Create( "DButton", self )
	self.m_pnlBtnExit:SetText( "Log Out" )
	self.m_pnlBtnExit:SetFont( "Trebuchet18" )
	self.m_pnlBtnExit:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlBtnExit.DoClick = function()

		self:CloseStartMenu()
		GAMEMODE.Net:RequestQuitComputerUI()
	end
end

function Panel:RebuildAppList( tblApps )
	for k, v in pairs( self.m_tblAppList ) do
		if ValidPanel( v ) then v:Remove() end
	end
	self.m_tblAppList = {}

	for k, v in pairs( tblApps ) do
		if not v.StartMenuIcon then continue end
		self:CreateAppListCard( k, v )
	end

	self:InvalidateLayout()
end

function Panel:CreateAppListCard( strID, tblApp )
	local appCard = vgui3D.Create( "SRPComputer_AppIconListLine", self.m_pnlAppList )
	appCard:SetApp( tblApp )
	table.insert( self.m_tblAppList, appCard )
	self.m_pnlAppList:AddItem( appCard )
end

function Panel:OpenStartMenu()
	self:GetParent():OpenStartMenu()
end

function Panel:CloseStartMenu()
	self:GetParent():CloseStartMenu()
end

function Panel:IsStartMenuOpen()
	return self:GetParent():IsStartMenuOpen()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 49, 53, 55, 240 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlBtnExit:SetSize( 96, 24 )
	self.m_pnlBtnExit:SetPos( intW -self.m_pnlBtnExit:GetWide(), intH -self.m_pnlBtnExit:GetTall() )

	self.m_pnlAppList:SetSize( intW, intH -self.m_pnlBtnExit:GetTall() )
	self.m_pnlAppList:SetPos( 0, 0 )

	for k, v in pairs( self.m_tblAppList ) do
		v:SetSize( intW, 32 )
		v:DockMargin( 0, 0, 0, 0 )
		v:Dock( TOP )
	end
end
vgui.Register( "SRPComputer_TaskBar_StartMenu", Panel, "EditablePanel" )



local Panel = {}
function Panel:Init()
	self:SetText( " " )

	self.m_pnlLabelName = vgui3D.Create( "DLabel", self )
	self.m_pnlLabelName:SetText( "App Window" )
	self.m_pnlLabelName:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlLabelName:SetFont( "Trebuchet18" )
end

function Panel:SetAppPanel( pnlWindow )
	self.m_pnlAppWindow = pnlWindow
end

function Panel:GetAppPanel()
	return self.m_pnlAppWindow
end

function Panel:SetWindowName( strName )
	self.m_strWindowName = strName
	self.m_pnlLabelName:SetText( strName )
	self:InvalidateLayout()
end

function Panel:GetWindowName()
	return self.m_strWindowName
end

function Panel:SetWindowIcon( strIcon )
	self.m_strIconPath = strIcon
	self.m_matIcon = strIcon and Material( strIcon, "" ) or nil
end

function Panel:GetWindowIcon()
	return self.m_strIconPath
end

function Panel:GetWindowIconMat()
	return self.m_matIcon
end

function Panel:DoClick()
	--set app window on top 
	if self:GetAppPanel():IsMinimized() then
		self:GetAppPanel():Minimize()
	end

	self:GetAppPanel():RequestFocus()
	self:GetAppPanel():MoveToFront()
end

function Panel:DoDoubleClick()
	if not self:GetAppPanel():IsMinimized() then
		self:GetAppPanel():Minimize()
	end
end

function Panel:DoRightClick()
	--open dmenu, options full screen, minimize or quit
end

function Panel:PaintOver( intW, intH )
	if self.m_matIcon then
		local icon_pad = 2
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.m_matIcon )
		surface.DrawTexturedRect( icon_pad, icon_pad, intH -(icon_pad *2), intH -(icon_pad *2) )
	end
end

function Panel:PerformLayout( intW, intH )
	local padding = 3
	local inset = (self.m_matIcon and intH or 0) +padding

	self.m_pnlLabelName:SizeToContents()
	self.m_pnlLabelName:SetPos( inset, (intH /2) -(self.m_pnlLabelName:GetTall() /2) )

	self:SetWide( inset +self.m_pnlLabelName:GetWide() +padding )
end
vgui.Register( "SRPComputer_TaskBar_WindowTab", Panel, "DButton" )



local Panel = {}
function Panel:Init()
	self.m_tblWindows = {}

	self.m_pnlBtnStart = vgui3D.Create( "DButton", self )
	self.m_pnlBtnStart:SetText( "Start" )
	self.m_pnlBtnStart:SetFont( "Trebuchet18" )
	self.m_pnlBtnStart:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlBtnStart.DoClick = function()
		if not self:IsStartMenuOpen() then
			self:OpenStartMenu()
		else
			self:CloseStartMenu()
		end
	end

	self.m_pnlTabScroller = vgui3D.Create( "SRPComputer_DHorizontalScroller", self )
	self.m_pnlTabScroller:SetOverlap( 0 )

	self.m_pnlClockLabel = vgui3D.Create( "DLabel", self )
	self.m_pnlClockLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlClockLabel:SetFont( "Trebuchet18" )
end

function Panel:AddAppWindow( strWindowName, pnlWindow, strIcon )
	local tab = vgui3D.Create( "SRPComputer_TaskBar_WindowTab", self )
	tab:SetAppPanel( pnlWindow )
	tab:SetWindowIcon( strIcon )
	tab:SetWindowName( strWindowName )

	self.m_tblWindows[pnlWindow] = { Name = strWindowName, Icon = strIcon, TabPanel = tab }
	self.m_pnlTabScroller:AddPanel( tab )
	self:InvalidateLayout()
end

function Panel:RemoveAppWindow( pnlWindow )
	if not self.m_tblWindows[pnlWindow] then return end
	for k, v in pairs( self.m_pnlTabScroller.Panels ) do
		if v == self.m_tblWindows[pnlWindow].TabPanel then
			table.remove( self.m_pnlTabScroller.Panels, k )
			v:Remove()
			break
		end
	end

	self.m_pnlTabScroller:InvalidateLayout()
end

function Panel:OpenStartMenu()
	self:GetParent():OpenStartMenu()
end

function Panel:CloseStartMenu()
	self:GetParent():CloseStartMenu()
end

function Panel:IsStartMenuOpen()
	return self:GetParent():IsStartMenuOpen()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 49, 53, 55, 252 )
	surface.DrawRect( 0, 0, intW, intH )
end

local days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }
function Panel:Think()
	local min = math.floor( GAMEMODE.DayNight:GetTime() %60 )
	local hour = math.floor( GAMEMODE.DayNight:GetTime() /60 )
	local pm = hour >= 12 and "PM" or "AM"
	if hour >= 12 then hour = hour -12 end
	if hour == 0 then hour = 12 end
	if min < 10 then min = "0".. min end

	if not ValidPanel( self.m_pnlClockLabel ) then return end
	self.m_pnlClockLabel:SetText( (hour.. ":".. min.. " ".. pm ).. " - ".. days[GAMEMODE.DayNight:GetDay() or 1] )
	self.m_pnlClockLabel:SizeToContents()
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlBtnStart:SetSize( 74, intH )
	self.m_pnlBtnStart:SetPos( 0, 0 )

	self.m_pnlClockLabel:SizeToContents()
	self.m_pnlClockLabel:SetPos( intW -self.m_pnlClockLabel:GetWide() -5, (intH /2) -(self.m_pnlClockLabel:GetTall() /2) )

	self.m_pnlTabScroller:SetPos( self.m_pnlBtnStart:GetWide(), 0 )
	self.m_pnlTabScroller:SetSize( intW -self.m_pnlBtnStart:GetWide() -self.m_pnlClockLabel:GetWide() -5, intH )
end
vgui.Register( "SRPComputer_TaskBar", Panel, "EditablePanel" )



local Panel = {}
function Panel:Init()
	self:SetText( "" )
	self.m_pnlLabelName = vgui3D.Create( "DLabel", self )
	self.m_pnlLabelName:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlLabelName:SetFont( "Default" )
	self.m_pnlLabelName:SetMouseInputEnabled( false )
	self.m_pnlLabelName:SetWrap( true )
end

function Panel:SetApp( tblApp )
	self.m_tblApp = tblApp

	if tblApp.Icon then
		self:SetIcon( tblApp.Icon )
	end

	if tblApp.Name then
		self.m_pnlLabelName:SetText( tblApp.Name )
	end

	self:InvalidateLayout()
end

function Panel:SetIcon( strIcon )
	self.m_strIcon = strIcon
	self.m_matIcon = Material( strIcon, "" )
end

function Panel:Paint( intW, intH )
	if self.m_matIcon then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.m_matIcon )

		local size = intH -self.m_pnlLabelName:GetTall()
		surface.DrawTexturedRect( (intW /2) -(size /2), 0, size, size )
	end
end

function Panel:DoDoubleClick()
	--start the app!
	--fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
	self:GetParent():GetParent():LaunchApp( self.m_tblApp.ID )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlLabelName:SizeToContents()
	self.m_pnlLabelName:SetWide( math.min(self.m_pnlLabelName:GetWide(), intW) )
	self.m_pnlLabelName:SetPos( (intW /2) -(self.m_pnlLabelName:GetWide() /2), intH -self.m_pnlLabelName:GetTall() )
end
vgui.Register( "SRPComputer_AppIcon", Panel, "DButton" )



local Panel = {}
function Panel:Init()
	self.m_intIconSize = 64
	self.m_tblIcons = {}
end

function Panel:RebuildAppList( tblApps )
	for k, v in pairs( self.m_tblIcons ) do
		if ValidPanel( v ) then v:Remove() end
	end
	self.m_tblIcons = {}

	for k, v in pairs( tblApps ) do
		if not v.DekstopIcon then continue end
		self:CreateAppIcon( k, v )
	end

	self:InvalidateLayout()
end

function Panel:CreateAppIcon( strID, tblApp )
	local appIcon = vgui3D.Create( "SRPComputer_AppIcon", self )
	appIcon:SetApp( tblApp )
	table.insert( self.m_tblIcons, appIcon )
end

function Panel:Paint( intW, intH )
end

function Panel:PerformLayout( intW, intH )
	local x, y, padding = 5, 5, 5

	for k, v in pairs( self.m_tblIcons ) do
		v:SetPos( x, y )
		v:SetSize( self.m_intIconSize, self.m_intIconSize )
		y = y +self.m_intIconSize +padding

		if y +(self.m_intIconSize +padding) > intH then
			y = padding
			x = x +self.m_intIconSize +padding
		end
	end
end
vgui.Register( "SRPComputer_IconContainer", Panel, "EditablePanel" )



local Panel = {}
function Panel:Init()
end

function Panel:Paint( intW, intH )
end

function Panel:PerformLayout( intW, intH )
end
vgui.Register( "SRPComputer_AppWindowContainer", Panel, "EditablePanel" )



local Panel = {}
function Panel:Init()
	vgui3D.SetCustomMouse( self, true )
	self.m_func3DCustomMouseFunc = self.Get3DCursorPos

	self.m_pnlIcons = vgui3D.Create( "SRPComputer_IconContainer", self )
	self.m_pnlTaskBar = vgui3D.Create( "SRPComputer_TaskBar", self )
	self.m_pnlAppContainer = vgui3D.Create( "SRPComputer_AppWindowContainer", self )

	self.m_intTaskbarHeight = 24
	self.m_tblApps = {}

	self.m_tblAppWindows = {}

	self:SetWallpaper( "nomad/computer/wp_1.png" )
	self:SetSkin( "srp_comp" )
end

function Panel:Get3DCursorPos( vecOrigin, vecNormal, angAngles, intScale )
	local dirLocalView = gui.ScreenToVector( vgui3D.GetRealMouseX(), vgui3D.GetRealMouseY() )
	local posDiffToEyes = EyePos() -(GAMEMODE.CiniCam.m_tblVars.Current and GAMEMODE.CiniCam.m_tblVars.Current.pos or Vector(0))

	local p = util.IntersectRayWithPlane(
		EyePos(),
		dirLocalView,
		vecOrigin +posDiffToEyes,
		vecNormal
	)

	if not p then return 0, 0 end

	local offset = p -vecOrigin
	--print( EyePos(), posDiffToEyes, offset, p )
	offset:Rotate( Angle(0, -angAngles.y, 0) )
	offset:Rotate( Angle(-angAngles.p, 0, 0) )
	offset:Rotate( Angle(0, 0, -angAngles.r) )
	return offset.x, -offset.y
end

function Panel:GetMousePos()
	local rootX, rootY = self:GetPos()
	vgui3D.SetCustomMouseFunc( self.m_func3DCustomMouseFunc )
		local x, y = self.m_func3DCustomMouseFunc( self, self.Origin, self.Normal, self.Angle, self.Scale )
		x = x /(self.Scale or 1)
		y = y /(self.Scale or 1)

		local mousex = math.Clamp( x, 0, self:GetWide() -1 )
		local mousey = math.Clamp( y, 0, self:GetTall() -1 )
	vgui3D.SetCustomMouseFunc()
	return x, y
end

function Panel:OnInputGained()
	self:SetMouseInputEnabled( true )
	self:SetKeyBoardInputEnabled( true )
	gui.EnableScreenClicker( true )
	self.m_bHasInput = true
end

function Panel:OnInputLost()
	self:SetMouseInputEnabled( false )
	self:SetKeyBoardInputEnabled( false )
	self:KillFocus()
	self.m_bHasInput = false
	gui.EnableScreenClicker( false )

	if IsValid( self.m_entComputer ) and not IsValid( self.m_entComputer:GetPlayerOwner() ) then
		self:CloseAllWindows()
	end
end

function Panel:LaunchApp( strID )
	if not self.m_tblApps[strID] then return end
	if not self.m_tblApps[strID].MultiRun then
		for k, v in pairs( self.m_tblAppWindows ) do
			if not ValidPanel( k ) then self.m_tblAppWindows[k] = nil continue end
			if k.m_tblApp.ID == strID then
				if k:IsMinimized() then
					k:Minimize()
				end
				k:MoveToFront()
				k:RequestFocus()

				return
			end
		end
	end

	local appWindow = vgui3D.Create( "SRPComputer_AppWindow", self.m_pnlAppContainer )
	appWindow:SetDesktop( self )
	appWindow:SetApp( self.m_tblApps[strID] )
	appWindow:SetVisible( true )
	appWindow:MoveToFront()
	appWindow:RequestFocus()
	self.m_tblAppWindows[appWindow] = true
	self.m_pnlTaskBar:AddAppWindow( appWindow:GetTitle(), appWindow, self.m_tblApps[strID].Icon )
end

function Panel:CloseAllWindows()
	for k, v in pairs( self.m_tblAppWindows ) do
		if not ValidPanel( k ) then continue end
		self.m_pnlTaskBar:RemoveAppWindow( k )
		k:Remove()
	end

	self.m_tblAppWindows = {}
end

function Panel:OpenStartMenu()
	if ValidPanel( self.m_pnlStartMenu ) then
		self.m_pnlStartMenu:Remove()
	end

	self.m_pnlStartMenu = vgui3D.Create( "SRPComputer_TaskBar_StartMenu", self )
	self.m_pnlStartMenu:RebuildAppList( self.m_tblApps )
	self.m_pnlStartMenu:SetVisible( true )
	self.m_pnlStartMenu:MoveToFront()
	self.m_pnlStartMenu:RequestFocus()
	self:InvalidateLayout( true )
end

function Panel:CloseStartMenu()
	if ValidPanel( self.m_pnlStartMenu ) then
		self.m_pnlStartMenu:Remove()
	end
end

function Panel:IsStartMenuOpen()
	return ValidPanel( self.m_pnlStartMenu )
end

function Panel:OnPlayerOpenMenu( pPlayer, entComputer, tblApps )
	self:SetAppList( tblApps )

	for k, v in pairs( self.m_tblAppWindows ) do
		if not ValidPanel( k ) then self.m_tblAppWindows[k] = nil continue end
		if not tblApps[k.m_tblApp.ID] then
			self.m_pnlTaskBar:RemoveAppWindow( k )
			k:Remove()
			self.m_tblAppWindows[k] = nil
		end
	end

	self.m_pnlIcons:RebuildAppList( tblApps )
end

function Panel:SetAppList( tblApps )
	self.m_tblApps = tblApps

	self.m_pnlIcons:RebuildAppList( tblApps )
	if ValidPanel( self.m_pnlStartMenu ) then
		self.m_pnlStartMenu:RebuildAppList( tblApps )
	end
end

function Panel:SetEntity( entComputer )
	self.m_entComputer = entComputer
end

function Panel:GetEntity()
	return self.m_entComputer
end

function Panel:SetWallpaper( strMatPath )
	self.m_strWallpaper = strMatPath
	self.m_matWallpaper = Material( strMatPath, "" )
end

function Panel:GetWallpaper()
	return self.m_strWallpaper
end

function Panel:GetWallpaperMat()
	return self.m_matWallpaper
end

function Panel:SetTaskBarHeight( int )
	self.m_intTaskbarHeight = int
	self:InvalidateLayout()
end

function Panel:GetTaskBarHeight()
	return self.m_intTaskbarHeight
end

function Panel:GetIconContainer()
	return self.m_pnlIcons
end

function Panel:GetAppContainer()
	return self.m_pnlAppContainer
end

function Panel:GetTaskBar()
	return self.m_pnlTaskBar
end

function Panel:Paint( intW, intH )
	if not self.m_intTaskbarHeight then return end
	
	if self.m_matWallpaper then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.m_matWallpaper )
		surface.DrawTexturedRect( 0, 0, intW, intH )
	else
		surface.SetDrawColor( 50, 50, 255, 255 )
		surface.DrawRect( 0, 0, intW, intH )
	end
end

--[[function Panel:PaintOver( intW, intH )
	if gui.MouseX() < 0 or gui.MouseX() > intW then return end
	if gui.MouseY() < 0 or gui.MouseY() > intH then return end
	
	local wide, thick = 16, 2
	surface.SetDrawColor( 250, 50, 50, 255 )
	surface.DrawRect( gui.MouseX() -(wide /2), gui.MouseY(), wide +thick, thick )
	surface.DrawRect( gui.MouseX(), gui.MouseY() -(wide /2), thick, wide +thick )
end]]--

function Panel:Think()
	if not self.m_bHasInput then
		self.m_bLeftMouseDown = false
		self.m_bRightMouseDown = false
		return
	end

	if input.IsMouseDown( MOUSE_LEFT ) and not self.m_bLeftMouseDown then
		self.m_bLeftMouseDown = true
		vgui3D.PostPanelEvent( self, "OnMousePressed", MOUSE_LEFT )
	elseif not input.IsMouseDown( MOUSE_LEFT ) and self.m_bLeftMouseDown then
		self.m_bLeftMouseDown = false
		vgui3D.PostPanelEvent( self, "OnMouseReleased", MOUSE_LEFT )
	end

	if input.IsMouseDown( MOUSE_RIGHT ) and not self.m_bRightMouseDown then
		self.m_bRightMouseDown = true
		vgui3D.PostPanelEvent( self, "OnMousePressed", MOUSE_RIGHT )
	elseif not input.IsMouseDown( MOUSE_RIGHT ) and self.m_bRightMouseDown then
		self.m_bRightMouseDown = false
		vgui3D.PostPanelEvent( self, "OnMouseReleased", MOUSE_RIGHT )
	end
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlTaskBar:SetSize( intW, self.m_intTaskbarHeight )
	self.m_pnlTaskBar:SetPos( 0, intH -self.m_pnlTaskBar:GetTall() )

	self.m_pnlIcons:SetPos( 0, 0 )
	self.m_pnlIcons:SetSize( intW, intH -self.m_pnlTaskBar:GetTall() )

	self.m_pnlAppContainer:SetPos( 0, 0 )
	self.m_pnlAppContainer:SetSize( intW, intH -self.m_pnlTaskBar:GetTall() )

	if ValidPanel( self.m_pnlStartMenu ) then
		self.m_pnlStartMenu:SetSize( 180, 250 )
		self.m_pnlStartMenu:SetPos( 0, intH -self.m_pnlTaskBar:GetTall() -self.m_pnlStartMenu:GetTall() )
		self.m_pnlStartMenu:InvalidateLayout( true )
	end
end
vgui.Register( "SRPComputer_Desktop", Panel, "EditablePanel" )