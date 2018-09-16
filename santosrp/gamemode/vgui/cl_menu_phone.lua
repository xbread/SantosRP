--[[
	Name: cl_menu_phone.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
end

function Panel:OnKeyCodeTyped( key )
	if key == KEY_ENTER then
		self:KillFocus()
	end
end

function Panel:DoClick()
	GAMEMODE.Gui.m_pnlPhone:MakePopup()
	GAMEMODE.Gui.m_pnlPhone:SetKeyboardInputEnabled( true )
	GAMEMODE.Gui.m_pnlPhone:SetMouseInputEnabled( false )
	self:RequestFocus()
end

function Panel:OnFocusChanged( b )
	if b then return end
	GAMEMODE.Gui.m_pnlPhone:SetKeyboardInputEnabled( false )
	GAMEMODE.Gui.m_pnlPhone:SetMouseInputEnabled( false )
	GAMEMODE.Gui.m_pnlPhone:KillFocus()	
end

function Panel:SetSelected( b )
	self.m_bSelected = b

	if not b then
		self:OnFocusChanged( false )
	else
		self:DoClick()
	end
end
vgui.Register( "SRPPhone_TextEntry", Panel, "DTextEntry" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_matGr = Material( "gui/gradient_down.vtf" )

	self.m_tblBtns = {}
	self.m_pnlBtnContainer = vgui.Create( "EditablePanel", self )
	self.m_pnlBtnContainer.Paint = function( _, intW, intH )
		for k, v in pairs( self.m_tblBtns ) do
			local x, y = v:GetPos()
			local w, h = v:GetSize()

			draw.SimpleText(
				v.m_strText,
				"HudHintTextSmall",
				x +(w /2),
				y +h,
				Color(255, 255, 255, 255),
				TEXT_ALIGN_CENTER
			)
		end
	end
end

function Panel:AddButton( strName, strMat, funcDoClick )
	local iconSize = 24
	local pnl = vgui.Create( "DButton", self.m_pnlBtnContainer )
	pnl:SetSize( 48, 32 )
	pnl:SetText( " " )
	pnl.m_strText = strName
	pnl.m_matIcon = Material( strMat )
	pnl.DoClick = funcDoClick
	pnl.Paint = function( p, intW, intH )
		if p.m_bSelected then
			draw.RoundedBox(
				4,
				0,
				0,
				intW,
				intH,
				Color( 255, 255, 255, 50 )
			)		
		end

		surface.SetMaterial( p.m_matIcon )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( (intW /2) -(iconSize /2), (intH /2) -(iconSize /2), iconSize, iconSize )
	end

	table.insert( self.m_tblBtns, pnl )
	return pnl
end

function Panel:SetSelected( b )
	self.m_bSelected = b
end

function Panel:SetIcon( strIcon )
	self.m_matIcon = Material( strIcon )
end

function Panel:SetAppName( strName )
	self.m_strAppName = strName
end

function Panel:GetAppName()
	return self.m_strAppName
end

function Panel:SetAppPanel( strPanel )
	self.m_pnlApp = vgui.Create( strPanel )
	self.m_pnlApp:SetVisible( false )
end

function Panel:DoClick()
	self:GetParent():ShowMenu( self.m_pnlApp )
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 255 )
	surface.DrawRect( 0, 0, intW, intH )

	surface.SetMaterial( self.m_matGr )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawTexturedRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	local x = 0
	for k, v in pairs( self.m_tblBtns ) do
		v:SetSize( 48, 24 )
		v:SetPos( x, 0 )
		x = x +v:GetWide()
	end

	self.m_pnlBtnContainer:SetPos( (intW /2) -(x /2), 0 )
	self.m_pnlBtnContainer:SetSize( x, intH )
end
vgui.Register( "SRPPhone_AppToolbar", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_matIcon = Material( "taloslife/phone/phone.png" )
	self:SetText( " " )
end

function Panel:SetSelected( b )
	self.m_bSelected = b
end

function Panel:SetIcon( strIcon )
	self.m_matIcon = Material( strIcon, "noclamp smooth" )
end

function Panel:SetAppName( strName )
	self.m_strAppName = strName
end

function Panel:GetAppName()
	return self.m_strAppName
end

function Panel:SetAppPanel( strPanel )
	self.m_pnlApp = vgui.Create( strPanel )
	self.m_pnlApp:SetVisible( false )
end

function Panel:GetAppPanel()
	return self.m_pnlApp
end

function Panel:DoClick()
	self:GetParent():ShowMenu( self.m_pnlApp )
end

function Panel:Paint( intW, intH )
	surface.SetMaterial( self.m_matIcon )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
end
vgui.Register( "SRPPhone_AppIcon", Panel, "DButton" )

-- --------------------------------------------------------------------------
local days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }
local Panel = {}
function Panel:Init()
	self.m_matSignal = Material( "taloslife/phone/stat_sys_signal_evdo_1.png", "noclamp" )

	self.m_pnlClockLabel = vgui.Create( "DLabel", self )
	self.m_pnlClockLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlClockLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlClockLabel:SetFont( "Trebuchet18" )
end

function Panel:Think()
	local min = math.floor( GAMEMODE.DayNight:GetTime() %60 )
	local hour = math.floor( GAMEMODE.DayNight:GetTime() /60 )
	local pm = hour >= 12 and "PM" or "AM"
	if hour >= 12 then hour = hour -12 end
	if hour == 0 then hour = 12 end
	if min < 10 then min = "0".. min end
	self.m_pnlClockLabel:SetText( (hour.. ":".. min.. " ".. pm ).. " - ".. days[GAMEMODE.DayNight:GetDay() or 1] )
	self.m_pnlClockLabel:SizeToContents()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, intW, intH )

	local x, y = self.m_pnlClockLabel:GetPos()
	surface.SetMaterial( self.m_matSignal )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( x -15 -8, y -2, 15, 19 )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlClockLabel:SizeToContents()
	self.m_pnlClockLabel:SetPos( intW -self.m_pnlClockLabel:GetWide() -5, 5 )
end
vgui.Register( "SRPPhoneTitleBar", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_tblApps = {}
	self.m_intAppLabelTall = 5
	self.m_intCurSelection = 1
end

function Panel:ShowMenu( ... )
	self:GetParent():ShowMenu( ... )
end

function Panel:DoClick()
	self:GetCurrentSelection():DoClick()
end

function Panel:NextSelection()
	self.m_intCurSelection = self.m_intCurSelection +1

	if self.m_intCurSelection > #self.m_tblApps then
		self.m_intCurSelection = 1
	end

	for k, v in pairs( self.m_tblApps ) do
		v:SetSelected( k == self.m_intCurSelection )
	end
end

function Panel:LastSelection()
	self.m_intCurSelection = self.m_intCurSelection -1

	if 0 >= self.m_intCurSelection then
		self.m_intCurSelection = #self.m_tblApps
	end

	for k, v in pairs( self.m_tblApps ) do
		v:SetSelected( k == self.m_intCurSelection )
	end
end

function Panel:GetCurrentSelection()
	for k, v in pairs( self.m_tblApps ) do
		if k == self.m_intCurSelection then
			return v
		end
	end
end

function Panel:Refresh()
	for k, v in pairs( self.m_tblApps ) do
		if ValidPanel( v ) then
			v:Remove()
		end
	end

	self.m_tblApps = {}
	self.m_intCurSelection = 1

	for k, v in pairs( GAMEMODE.Gui.m_tblDefPhoneApps ) do
		local app = vgui.Create( "SRPPhone_AppIcon", self )
		app:SetIcon( v.Icon )
		app:SetAppPanel( v.Panel )
		app:SetAppName( v.Name )
		table.insert( self.m_tblApps, app )

		if #self.m_tblApps == self.m_intCurSelection then
			app:SetSelected( true )
		else
			app:SetSelected( false )
		end
	end

	self:InvalidateLayout()
end

function Panel:Paint()
	for k, v in pairs( self.m_tblApps ) do
		local x, y = v:GetPos()
		local w, h = v:GetSize()

		surface.SetFont( "HudHintTextSmall" )
		local tW, tH = surface.GetTextSize( v:GetAppName() )
		if v.m_bSelected then
			draw.RoundedBox(
				4,
				x,
				y,
				w,
				h +self.m_intAppLabelTall +tH,
				Color( 255, 255, 255, 50 )
			)
		end

		draw.SimpleText(
			v:GetAppName(),
			"HudHintTextSmall",
			x +(w /2),
			y +h,
			Color(255, 255, 255, 255),
			TEXT_ALIGN_CENTER
		)
	end
end

function Panel:PerformLayout( intW, intH )
	local x, y = 0, 0
	local iconSize, iconPadding, iconPaddingY = 50, 5, 10

	local perRow, count = 4, 0
	for k, v in pairs( self.m_tblApps ) do
		v:SetPos( x, y )
		v:SetSize( iconSize, iconSize )

		count = count +1
		if count < perRow then
			x = x +iconSize +iconPadding
		else
			x = 0
			count = 0
			y = y +iconSize +iconPaddingY +self.m_intAppLabelTall
		end
	end
end
vgui.Register( "SRPAppList", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlTitleBar = vgui.Create( "SRPPhoneTitleBar", self )
	self.m_pnlAppList = vgui.Create( "SRPAppList", self )
	self.m_pnlAppList:Refresh()

	self.m_tblPageBuffer = {}
end

function Panel:HomePage()
	local cur = self.m_tblPageBuffer[#self.m_tblPageBuffer]
	if not cur then return end
	self.m_bAnim = true

	cur:SetPos( 0, self.m_pnlTitleBar:GetTall() )
	cur:MoveTo( self:GetWide(), self.m_pnlTitleBar:GetTall(), 0.25, 0, 2, function()
		cur:SetVisible( false )
	end )

	self.m_pnlAppList:SetVisible( true )
	self.m_pnlAppList:SetPos( -self:GetWide(), 30 )
	self.m_pnlAppList:MoveTo( 0, 30, 0.25, 0, 2, function()
		self.m_pnlAppList:SetVisible( true )
		self.m_bAnim = false
	end )

	self.m_tblPageBuffer = {}
end

function Panel:ShowMenu( pnlMenu, funcCallback )
	if self.m_bAnim then return end
	self.m_bAnim = true

	pnlMenu:SetParent( self )
	pnlMenu:SetSize( self:GetWide(), self:GetTall() -self.m_pnlTitleBar:GetTall() )
	pnlMenu:InvalidateLayout()

	local old = self.m_tblPageBuffer[#self.m_tblPageBuffer]
	old = old or self.m_pnlAppList
	old:SetPos( 0, old ~= self.m_pnlAppList and self.m_pnlTitleBar:GetTall() or 30 )
	old:MoveTo( -self:GetWide(), old ~= self.m_pnlAppList and self.m_pnlTitleBar:GetTall() or 30, 0.25, 0, 2, function()
		old:SetVisible( false )
		if funcCallback then funcCallback() end
	end )

	pnlMenu:SetVisible( true )
	pnlMenu:SetPos( self:GetWide(), self.m_pnlTitleBar:GetTall() )
	pnlMenu:MoveTo( 0, self.m_pnlTitleBar:GetTall(), 0.25, 0, 2, function()
		pnlMenu:SetVisible( true )
		self.m_bAnim = false
		if funcCallback then funcCallback() end
	end )

	if pnlMenu.OnShowPage then
		pnlMenu:OnShowPage()
	end

	table.insert( self.m_tblPageBuffer, pnlMenu )
end

function Panel:GetCurrentMenu()
	return self.m_tblPageBuffer[#self.m_tblPageBuffer]
end

function Panel:DoClick()
	if self.m_pnlAppList:IsVisible() then
		self.m_pnlAppList:DoClick()
	else
		self.m_tblPageBuffer[#self.m_tblPageBuffer]:DoClick()
	end
end

function Panel:NextSelection()
	if self.m_pnlAppList:IsVisible() then
		self.m_pnlAppList:NextSelection()
	else
		self.m_tblPageBuffer[#self.m_tblPageBuffer]:NextSelection()
	end
end

function Panel:LastSelection()
	if self.m_pnlAppList:IsVisible() then
		self.m_pnlAppList:LastSelection()
	else
		self.m_tblPageBuffer[#self.m_tblPageBuffer]:LastSelection()
	end
end

function Panel:BackPage()
	if self.m_pnlAppList:IsVisible() then return end
	if #self.m_tblPageBuffer == 0 then return end
	if self.m_bAnim then return end
	self.m_bAnim = true

	local old = self.m_tblPageBuffer[#self.m_tblPageBuffer]
	local new = self.m_tblPageBuffer[#self.m_tblPageBuffer -1]
	if not new then new = self.m_pnlAppList end

	local oldIDX, newIDX = #self.m_tblPageBuffer, #self.m_tblPageBuffer -1
	old:MoveTo( self:GetWide(), self.m_pnlTitleBar:GetTall(), 0.25, 0, 2, function()
		old:SetVisible( false )
		if old.OnPageBack then
			old:OnPageBack()
		end

		self.m_tblPageBuffer[oldIDX] = nil
	end )

	new:SetPos( -self:GetWide(), new ~= self.m_pnlAppList and self.m_pnlTitleBar:GetTall() or 30 )
	new:SetVisible( true )
	new:MoveTo( 0, new ~= self.m_pnlAppList and self.m_pnlTitleBar:GetTall() or 30, 0.25, 0, 2, function()
		new:SetVisible( true )
		self.m_bAnim = false
	end )
end

function Panel:NumberTyped( int )
	if #self.m_tblPageBuffer == 0 then return end
	if not self.m_tblPageBuffer[#self.m_tblPageBuffer].NumberTyped then return end
	self.m_tblPageBuffer[#self.m_tblPageBuffer]:NumberTyped( int )
end

function Panel:Paint( intW, intH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlTitleBar:SetPos( 0, 0 )
	self.m_pnlTitleBar:SetSize( intW, 25 )

	self.m_pnlAppList:SetPos( 5, 30 )
	self.m_pnlAppList:SetSize( intW -10, intH -35 )
end
vgui.Register( "SRPPhoneHomeMenu", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )

	self.m_matBG = Material( "taloslife/phone/android_01.png", "noclamp" )
	self.m_matWallpaper = Material( "taloslife/phone/wallpapers/grass.png", "noclamp smooth" )
	self.m_intMenuX = 23
	self.m_intMenuY = 43
	self.m_intMenuW = 248 -self.m_intMenuX
	self.m_intMenuH = 442 -self.m_intMenuY
	self.m_intScrH = ScrH()

	self.m_pnlContent = vgui.Create( "SRPPhoneHomeMenu", self )

	hook.Add( "GamemodeSharedGameVarChanged", "JailClosePhone", function( pPlayer, strVar, vaOld, vaNew )
		if pPlayer ~= LocalPlayer() or strVar ~= "arrested" then return end
		if vaNew and self:IsVisible() then
			self:Toggle()
		end
	end )
end

function Panel:HomePage()
	self.m_pnlContent:HomePage()
end

function Panel:GetApp( strAppName )
	for k, v in pairs( self.m_pnlContent.m_pnlAppList.m_tblApps ) do
		if v:GetAppName() == strAppName then
			return v
		end
	end
end

function Panel:ShowApp( strAppName, funcCallback )
	self.m_pnlContent:ShowMenu( self:GetApp(strAppName):GetAppPanel(), funcCallback )
end

function Panel:ShowMenu( pnlMenu, funcCallback )
	self.m_pnlContent:ShowMenu( pnlMenu, funcCallback )
end

function Panel:GetCurrentMenu()
	return self.m_pnlContent:GetCurrentMenu()
end

function Panel:DoClick()
	self.m_pnlContent:DoClick()
end

function Panel:NextSelection()
	self.m_pnlContent:NextSelection()
end

function Panel:LastSelection()
	self.m_pnlContent:LastSelection()
end

function Panel:BackPage()
	self.m_pnlContent:BackPage()
end

function Panel:NumberTyped( int )
	self.m_pnlContent:NumberTyped( int )
end

function Panel:Think()
	if not self:IsVisible() or self.m_bClosing then return end
	if LocalPlayer():HasWeapon( "weapon_handcuffed" ) or LocalPlayer():HasWeapon( "weapon_ziptied" ) then
		self:Toggle()
	end
end

function Panel:Toggle()
	local posX, posY = self:GetPos()
	local w, h = self:GetSize()

	if self:IsVisible() then
		self.m_bClosing = true
		self:MoveTo( posX, self.m_intScrH, 0.25, 0, 2, function()
			self:SetVisible( false )
			self.m_bClosing = nil
		end )
	else
		if LocalPlayer():HasWeapon( "weapon_handcuffed" ) or LocalPlayer():HasWeapon( "weapon_ziptied" ) then
			return
		end
		if GAMEMODE.Player:GetSharedGameVar( LocalPlayer(), "arrested" ) then
			return
		end

		self.m_bClosing = nil
		self:SetVisible( true )
		self:MoveTo( posX, self.m_intScrH -h +32, 0.25, 0, 2, function()
			self:SetVisible( true )
		end )
	end
end

function Panel:Paint( intW, intH )
	surface.SetMaterial( self.m_matBG )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, intW, intH )

	surface.SetMaterial( self.m_matWallpaper )
	surface.DrawTexturedRect( self.m_intMenuX, self.m_intMenuY, self.m_intMenuW, self.m_intMenuH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlContent:SetPos( self.m_intMenuX, self.m_intMenuY )
	self.m_pnlContent:SetSize( self.m_intMenuW, self.m_intMenuH )
end
vgui.Register( "SRPPhoneMenu", Panel, "EditablePanel" )

hook.Add( "GamemodeDefineGameVars", "DefinePhoneData", function( pPlayer )
	GAMEMODE.Player:DefineGameVar( "phone_number", "", "String", true )
end )