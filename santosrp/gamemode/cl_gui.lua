--[[
	Name: cl_gui.lua
	
		
]]--

GM.Gui = (GAMEMODE or GM).Gui or {}
GM.Gui.m_intKeyDelay = 0.15
GM.Gui.m_tblNWMenus = (GAMEMODE or GM).Gui.m_tblNWMenus or {}
GM.Gui.m_tblKeyStates = (GAMEMODE or GM).Gui.m_tblKeyStates or {}
GM.Gui.m_tblVoicePanels = {}
GM.Gui.m_tblDefPhoneApps = {
	{ Name = "Phone", Icon = "santosrp/phone/phone_4.png", Panel = "SRPPhone_App_PhoneDialer" },
	{ Name = "Contacts", Icon = "santosrp/phone/contacts.png", Panel = "SRPPhone_App_Contacts" },
	{ Name = "Messages", Icon = "santosrp/phone/mms.png", Panel = "SRPPhone_App_Messages" },
	{ Name = "Camera", Icon = "santosrp/phone/camera.png", Panel = "SRPPhone_App_Camera" },
	{ Name = "Gallery", Icon = "santosrp/phone/gallery.png", Panel = "SRPPhone_App_Gallery" },
}

function GM.Gui:Initialize()
	self:BuildCarShop()
	self:BuildCarSpawn()
	self:BuildCopMenus()
	self:BuildJailMenus()
	self:BuildTicketMenu()
	self:BuildPropertyMenus()
	self:BuildCustomPlateMenu()
	self:BuildDrivingTestMenu()
	self:BuildBankMenu()
	self:BuildClothingMenu()
	self:BuildPhoneMenu()
	self:BuildCraftingMenus()
	self:BuildChatRadioMenu()
	self:BuildItemLockerMenu()
	self:BuildGovMenus()
	
	--FFFFFFFFFFFFF GARRY, CALL THE FUCKING CALLBACK, AT ALL TIMES
	g_PanelMoveTo = g_PanelMoveTo or debug.getregistry().Panel.MoveTo
	debug.getregistry().Panel.MoveTo = function( pnl, x, y, length, delay, ease, callback )
		if pnl.x == x and pnl.y == y then callback() return end
		return g_PanelMoveTo( pnl, x, y, length, delay, ease, callback )
	end
end

function GM.Gui:RegisterNWMenu( strID, pnlMenu )
	self.m_tblNWMenus[strID] = pnlMenu
end

function GM.Gui:ShowNWMenu( strID )
	self.m_tblNWMenus[strID]:Open()
end

function GM.Gui:PhonePageBack()
	self.m_pnlPhone:BackPage()
end

function GM.Gui:GetCurrentPhoneMenu()
	return self.m_pnlPhone.m_pnlContent:GetCurrentMenu()
end

function GM.Gui:Tick()
	if input.IsKeyDown( KEY_V ) then
		if not ValidPanel( self.m_pnlCarRadioMenu ) then
			self.m_pnlCarRadioMenu = vgui.Create( "SRPRadioRadialMenu" )
			self.m_pnlCarRadioMenu:SetSize( 340, 340 )
			self.m_pnlCarRadioMenu:Center()

			--Some kind of mouse bug?
			self.m_pnlCarRadioMenu:MakePopup()
			self.m_pnlCarRadioMenu:SetVisible( false )
		end

		if IsValid( LocalPlayer():GetVehicle() ) and LocalPlayer():GetVehicle():GetClass() ~= "prop_vehicle_jeep" then return end
		if self.m_pnlCarRadioMenu:IsVisible() or vgui.CursorVisible() or not LocalPlayer():InVehicle() then return end
		if ValidPanel( vgui.GetKeyboardFocus() ) then return end
		self.m_pnlCarRadioMenu:Open()	
	else
		if ValidPanel( self.m_pnlCarRadioMenu ) then
			self.m_pnlCarRadioMenu:Close()
		end
	end

	if input.IsKeyDown( KEY_T ) then
		if not ValidPanel( self.m_pnlActMenu ) then
			self.m_pnlActMenu = vgui.Create( "SRPActRadialMenu" )
			self.m_pnlActMenu:SetSize( 280, 280 )
			self.m_pnlActMenu:Center()

			--Some kind of mouse bug?
			self.m_pnlActMenu:MakePopup()
			self.m_pnlActMenu:SetVisible( false )
		end

		if self.m_pnlActMenu:IsVisible() or vgui.CursorVisible() or LocalPlayer():InVehicle() then return end
		if ValidPanel( vgui.GetKeyboardFocus() ) then return end
		self.m_pnlActMenu:Open()	
	else
		if ValidPanel( self.m_pnlActMenu ) and self.m_pnlActMenu:IsVisible() then
			self.m_pnlActMenu:Close()
		end
	end

	if input.IsKeyDown( KEY_F2 ) then
		if not ValidPanel( self.m_pnlChatRadio ) then return end
		if self.m_pnlChatRadio:IsVisible() or vgui.CursorVisible() then return end
		if ValidPanel( vgui.GetKeyboardFocus() ) then return end
		self.m_pnlChatRadio:Open()	
	else
		if ValidPanel( self.m_pnlChatRadio ) and self.m_pnlChatRadio:IsVisible() then
			self.m_pnlChatRadio:Close()
		end
	end
end

function GM.Gui:KeyPress( _, intKey )
	if not GAMEMODE.m_bInGame then return end
	if not ValidPanel( self.m_pnlPhone ) or not self.m_pnlPhone:IsVisible() then return end
	if not self.m_intLastMouseClick then self.m_intLastMouseClick = 0 end
	
	if CurTime() > self.m_intLastMouseClick then
		if intKey == IN_ATTACK2 then
			self.m_pnlPhone:NextSelection()
			self.m_intLastMouseClick = CurTime() +self.m_intKeyDelay
		elseif intKey == IN_ATTACK then
			self.m_pnlPhone:DoClick()
			self.m_intLastMouseClick = CurTime() +self.m_intKeyDelay
		end
	end
end

function GM.Gui:CreateMove( CUserCmd )
	if not GAMEMODE.m_bInGame then return end
	if not self.m_intLastScroll then self.m_intLastScroll = 0 end
	
	if not ValidPanel( self.m_pnlPhone ) then return end
	if not self.m_pnlPhone:IsVisible() then return end
	if CurTime() < self.m_intLastScroll then return end
	
	if CUserCmd:GetMouseWheel() > 0 then
		self.m_intLastScroll = CurTime() +0.015
		self.m_pnlPhone:NextSelection()
	elseif CUserCmd:GetMouseWheel() < 0 then
		self.m_intLastScroll = CurTime() +0.015
		self.m_pnlPhone:LastSelection()
	end
end

--function GM.Gui:PlayerStartVoice( pPlayer )
--	self.m_tblVoicePanels[pPlayer] = {}
--end
--
--function GM.Gui:PlayerEndVoice( pPlayer )
--	if ValidPanel( self.m_tblVoicePanels[pPlayer] ) then
--		self.m_tblVoicePanels[pPlayer]:Remove()
--	end
--	self.m_tblVoicePanels[pPlayer] = nil
--end

function GM.Gui:HUDShouldDraw( strName )
	if not ValidPanel( self.m_pnlPhone ) then return end
	if not self.m_pnlPhone:IsVisible() then return end
	if strName == "CHudWeaponSelection" then return false end
end

--Thanks gmod, this is a huge mess now
function GM.Gui:Think()
	if not GAMEMODE.m_bInGame then return end
	if vgui.CursorVisible() then return end
	if gui.IsGameUIVisible() then return end
	
	if input.IsKeyDown( KEY_UP ) then
		if not self.m_tblKeyStates[KEY_UP] then
			self.m_pnlPhone:Toggle()
			self.m_tblKeyStates[KEY_UP] = CurTime() +self.m_intKeyDelay
		end
	else
		if self.m_tblKeyStates[KEY_UP] and CurTime() > self.m_tblKeyStates[KEY_UP] then
			self.m_tblKeyStates[KEY_UP] = false
		end
	end
	
	if not ValidPanel( self.m_pnlPhone ) then return end
	if not self.m_pnlPhone:IsVisible() then return end
	if ValidPanel( vgui.GetKeyboardFocus() ) then return end

	--Click
	if input.IsKeyDown( KEY_ENTER ) then
		if not self.m_tblKeyStates[KEY_ENTER] then
			self.m_pnlPhone:DoClick()
			self.m_tblKeyStates[KEY_ENTER] = CurTime() +self.m_intKeyDelay
		end
	else
		if self.m_tblKeyStates[KEY_ENTER] and CurTime() > self.m_tblKeyStates[KEY_ENTER] then
			self.m_tblKeyStates[KEY_ENTER] = false
		end
	end

	--Next
	if input.IsKeyDown( KEY_RIGHT ) then
		if not self.m_tblKeyStates[KEY_RIGHT] then
			self.m_pnlPhone:NextSelection()
			self.m_tblKeyStates[KEY_RIGHT] = CurTime() +self.m_intKeyDelay
		end
	else
		if self.m_tblKeyStates[KEY_RIGHT] and CurTime() > self.m_tblKeyStates[KEY_RIGHT] then
			self.m_tblKeyStates[KEY_RIGHT] = false
		end
	end

	--Last
	if input.IsKeyDown( KEY_LEFT ) then
		if not self.m_tblKeyStates[KEY_LEFT] then
			self.m_pnlPhone:LastSelection()
			self.m_tblKeyStates[KEY_LEFT] = CurTime() +self.m_intKeyDelay
		end
	else
		if self.m_tblKeyStates[KEY_LEFT] and CurTime() > self.m_tblKeyStates[KEY_LEFT] then
			self.m_tblKeyStates[KEY_LEFT] = false
		end
	end

	--Back page
	if input.IsKeyDown( KEY_BACKSPACE ) then
		if not self.m_tblKeyStates[KEY_BACKSPACE] then
			self.m_pnlPhone:BackPage()
			self.m_tblKeyStates[KEY_BACKSPACE] = CurTime() +self.m_intKeyDelay
		end
	else
		if self.m_tblKeyStates[KEY_BACKSPACE] and CurTime() > self.m_tblKeyStates[KEY_BACKSPACE] then
			self.m_tblKeyStates[KEY_BACKSPACE] = false
		end
	end

	--Back page
	if input.IsMouseDown( MOUSE_4 ) then
		if not self.m_tblKeyStates[MOUSE_4] then
			self.m_pnlPhone:BackPage()
			self.m_tblKeyStates[MOUSE_4] = CurTime() +self.m_intKeyDelay
		end
	else
		if self.m_tblKeyStates[MOUSE_4] and CurTime() > self.m_tblKeyStates[MOUSE_4] then
			self.m_tblKeyStates[MOUSE_4] = false
		end
	end

	--Keypad number Keys
	for key = 37, 46 do
		if input.IsKeyDown( key ) then
			if not self.m_tblKeyStates[key] then
				self.m_pnlPhone:NumberTyped( GAMEMODE.Util:EnumToKey(key, 37) )
				self.m_tblKeyStates[key] = CurTime() +self.m_intKeyDelay
			end
		else
			if self.m_tblKeyStates[key] and CurTime() > self.m_tblKeyStates[key] then
				self.m_tblKeyStates[key] = false
			end
		end
	end

	--Number row keys
	for key = 1, 10 do
		if input.IsKeyDown( key ) then
			if not self.m_tblKeyStates[key] then
				self.m_pnlPhone:NumberTyped( GAMEMODE.Util:EnumToKey(key, 1) )
				self.m_tblKeyStates[key] = CurTime() +self.m_intKeyDelay
			end
		else
			if self.m_tblKeyStates[key] and CurTime() > self.m_tblKeyStates[key] then
				self.m_tblKeyStates[key] = false
			end
		end
	end
end

function GM:OnSpawnMenuOpen()
	if not self:IsInGame() then return end
	if LocalPlayer():HasWeapon( "weapon_handcuffed" ) or LocalPlayer():HasWeapon( "weapon_ziptied" ) then return end
	
	if not ValidPanel( self.m_pnlQMenu ) then
		self.m_pnlQMenu = vgui.Create( "SRPQMenu" )
		self.m_pnlQMenu:SetSize( math.max(ScrW() *0.66, 800), math.max(ScrH() *0.8, 600) )
		--self.m_pnlQMenu:SetSize( 800, 600 )
		self.m_pnlQMenu:Center()
	end

	self.m_pnlQMenu:Refresh()
	self.m_pnlQMenu:SetVisible( true )
	self.m_pnlQMenu:MakePopup()

	RestoreCursorPosition()
end

function GM:OnSpawnMenuClose()
	if ValidPanel( self.m_pnlQMenu ) then
		self.m_pnlQMenu:SetVisible( false )
		CloseDermaMenus()
		RememberCursorPosition()
	end
end

function GM:ScoreboardShow()
	if not ValidPanel( self.m_pnlScoreboard ) then
		self.m_pnlScoreboard = vgui.Create( "SRPScoreboard" )
		self.m_pnlScoreboard:SetSize( math.max(ScrW() *0.66, 800), math.max(ScrH() *0.8, 600) )
		self.m_pnlScoreboard:Center()
	end

	self.m_pnlScoreboard:Refresh()
	self.m_pnlScoreboard:SetVisible( true )
	self.m_pnlScoreboard:MakePopup()
end

function GM:ScoreboardHide()
	if ValidPanel( self.m_pnlScoreboard ) then
		self.m_pnlScoreboard:SetVisible( false )
	end
end

function GM.Gui:StringRequest( strTitle, strText, strDefaultText, fnEnter, fnCancel, strButtonText, strButtonCancelText, intCharLimit )
	local Window = vgui.Create( "SRP_Frame" )
		Window:SetTitle( strTitle or "Message Title (First Parameter)" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )
		Window:SetBackgroundBlur( true )
		Window:SetDrawOnTop( true )
		Window:SetBackgroundColor( Color(35, 35, 35, 175) )

	local InnerPanel = vgui.Create( "DPanel", Window )
		InnerPanel:SetDrawBackground( false )

	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( strText or "Message Text (Second Parameter)" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetTextColor( color_white )

	local TextEntry = vgui.Create( "DTextEntry", InnerPanel )
		TextEntry:SetText( strDefaultText or "" )
		TextEntry.OnEnter = function() Window:Close() fnEnter( TextEntry:GetValue() ) end

		if intCharLimit then
			TextEntry.AllowInput = function( pnl, intKey )
				local text = pnl:GetValue():sub(0, pnl:GetCaretPos())
				if string.len( text ) >= intCharLimit then
					return true
				end
			end
		end

	local ButtonPanel = vgui.Create( "DPanel", Window )
		ButtonPanel:SetTall( 30 )
		ButtonPanel:SetDrawBackground( false )

	local Button = vgui.Create( "SRP_Button", ButtonPanel )
		Button:SetText( strButtonText or "OK" )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button:SetPos( 5, 5 )
		Button.DoClick = function() Window:Close() fnEnter( TextEntry:GetValue() ) end

	local ButtonCancel = vgui.Create( "SRP_Button", ButtonPanel )
		ButtonCancel:SetText( strButtonCancelText or "Cancel" )
		ButtonCancel:SizeToContents()
		ButtonCancel:SetTall( 20 )
		ButtonCancel:SetWide( Button:GetWide() + 20 )
		ButtonCancel:SetPos( 5, 5 )
		ButtonCancel.DoClick = function() Window:Close() if ( fnCancel ) then fnCancel( TextEntry:GetValue() ) end end
		ButtonCancel:MoveRightOf( Button, 5 )

	ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
	
	local w, h = Text:GetSize()
	w = math.max( w, 400 ) 
	Window:SetSize( w +50, h +25 +75 +10 )
	Window:Center()
	InnerPanel:StretchToParent( 5, 25, 5, 45 )
	Text:StretchToParent( 5, 5, 5, 35 )	
	
	TextEntry:StretchToParent( 5, nil, 5, nil )
	TextEntry:AlignBottom( 5 )
	TextEntry:RequestFocus()
	TextEntry:SelectAllText( true )
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )
	Window:MakePopup()
	Window:DoModal()
	return Window
end

function GM.Gui:Derma_Query( strText, strTitle, ... )
	local Window = vgui.Create( "SRP_Frame" )
		Window:SetTitle( strTitle or "Message Title (First Parameter)" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )
		Window:SetBackgroundBlur( true )
		Window:SetDrawOnTop( true )
		Window:SetBackgroundColor( Color(35, 35, 35, 175) )
		
	local InnerPanel = vgui.Create( "DPanel", Window )
		InnerPanel:SetDrawBackground( false )
	
	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( strText or "Message Text (Second Parameter)" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetTextColor( color_white )

	local ButtonPanel = vgui.Create( "DPanel", Window )
		ButtonPanel:SetTall( 30 )
		ButtonPanel:SetDrawBackground( false )

	-- Loop through all the options and create buttons for them.
	local NumOptions = 0
	local x = 5

	for k = 1, 8, 2 do
		local Text = select( k, ... )
		if Text == nil then break end
		local Func = select( k +1, ... ) or function() end
	
		local Button = vgui.Create( "SRP_Button", ButtonPanel )
			Button:SetText( Text )
			Button:SizeToContents()
			Button:SetTall( 20 )
			Button:SetWide( Button:GetWide() +20 )
			Button.DoClick = function() Window:Close() Func() end
			Button:SetPos( x, 5 )
			
		x = x +Button:GetWide() +5
		ButtonPanel:SetWide( x ) 
		NumOptions = NumOptions +1
	end

	
	local w, h = Text:GetSize()
	w = math.max( w, ButtonPanel:GetWide() )
	Window:SetSize( w +50, h +25 +45 +10 )
	Window:Center()
	
	InnerPanel:StretchToParent( 5, 25, 5, 45 )
	Text:StretchToParent( 5, 5, 5, 5 )	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )

	Window:MakePopup()
	Window:DoModal()
	
	if NumOptions == 0 then
		Window:Close()
		Error( "Derma_Query: Created Query with no Options!?" )
		return nil
	end
	
	return Window
end

function GM.Gui:Derma_Message( strText, strTitle, strButtonText )
	local Window = vgui.Create( "SRP_Frame" )
		Window:SetTitle( strTitle or "Message" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )
		Window:SetBackgroundBlur( true )
		Window:SetDrawOnTop( true )
		Window:SetBackgroundColor( Color(35, 35, 35, 175) )
		
	local InnerPanel = vgui.Create( "Panel", Window )
	
	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( strText or "Message Text" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetTextColor( color_white )
		
	local ButtonPanel = vgui.Create( "DPanel", Window )
		ButtonPanel:SetTall( 30 )
		ButtonPanel:SetDrawBackground( false )
		
	local Button = vgui.Create( "SRP_Button", ButtonPanel )
		Button:SetText( strButtonText or "OK" )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button:SetPos( 5, 5 )
		Button.DoClick = function() Window:Close() end
		
	ButtonPanel:SetWide( Button:GetWide() + 10 )
	
	local w, h = Text:GetSize()
	Window:SetSize( w +50, h +25 +45 +10 )
	Window:Center()
	InnerPanel:StretchToParent( 5, 25, 5, 45 )
	Text:StretchToParent( 5, 5, 5, 5 )	
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )
	Window:MakePopup()
	Window:DoModal()
	return Window
end

--Build all the game ui
function GM.Gui:BuildCarShop()
	if ValidPanel( self.m_pnlCarShop ) then
		self.m_pnlCarShop:Remove()
	end

	self.m_pnlCarShop = vgui.Create( "SRPCarBuyMenu2" )
	self.m_pnlCarShop:SetSize( ScrW(), ScrH() )
	self.m_pnlCarShop:Center()
	self.m_pnlCarShop:Populate()
	self.m_pnlCarShop:SetVisible( false )
	self:RegisterNWMenu( "car_buy", self.m_pnlCarShop )

	if ValidPanel( self.m_pnlCarSell ) then
		self.m_pnlCarSell:Remove()
	end

	self.m_pnlCarSell = vgui.Create( "SRPCarSellMenu" )
	self.m_pnlCarSell:SetTitle( "Sell A Car" )
	self.m_pnlCarSell:SetSize( 800, 480 )
	self.m_pnlCarSell:Center()
	self.m_pnlCarSell:Populate()
	self.m_pnlCarSell:SetVisible( false )
	self:RegisterNWMenu( "car_sell", self.m_pnlCarSell )
end

function GM.Gui:BuildCarSpawn()
	if ValidPanel( self.m_pnlCarSpawn ) then
		self.m_pnlCarSpawn:Remove()
	end

	self.m_pnlCarSpawn = vgui.Create( "SRPCarSpawn" )
	self.m_pnlCarSpawn:SetSize( 800, 480 )
	self.m_pnlCarSpawn:Center()
	self.m_pnlCarSpawn:Populate()
	self.m_pnlCarSpawn:SetVisible( false )
	self:RegisterNWMenu( "car_spawn", self.m_pnlCarSpawn )
end

function GM.Gui:BuildCopMenus()
	if ValidPanel( self.m_pnlCopCarSpawn ) then
		self.m_pnlCopCarSpawn:Remove()
	end

	self.m_pnlCopCarSpawn = vgui.Create( "SRPCopCarSpawn" )
	self.m_pnlCopCarSpawn:SetSize( 800, 480 )
	self.m_pnlCopCarSpawn:Center()
	self.m_pnlCopCarSpawn:Populate()
	self.m_pnlCopCarSpawn:SetVisible( false )
	self:RegisterNWMenu( "cop_car_spawn", self.m_pnlCopCarSpawn )

	if ValidPanel( self.m_pnlCopComputer ) then
		self.m_pnlCopComputer:Remove()
	end
	
	self.m_pnlCopComputer = vgui.Create( "SRPCopComputerSkinnedMenu" )
	self.m_pnlCopComputer:SetSize( 817, 692 )
	self.m_pnlCopComputer:Center()
	self.m_pnlCopComputer:SetVisible( false )
	self:RegisterNWMenu( "cop_car_computer", self.m_pnlCopComputer )
end

function GM.Gui:BuildJailMenus()
	if ValidPanel( self.m_pnlJailTurnIn ) then
		self.m_pnlJailTurnIn:Remove()
	end
	self.m_pnlJailTurnIn = vgui.Create( "SRPJailTurnInMenu" )
	self.m_pnlJailTurnIn:SetSize( 800, 480 )
	self.m_pnlJailTurnIn:Center()
	self.m_pnlJailTurnIn:SetVisible( false )
	self:RegisterNWMenu( "cop_jail_turnin", self.m_pnlJailTurnIn )

	if ValidPanel( self.m_pnlJailFree ) then
		self.m_pnlJailFree:Remove()
	end
	self.m_pnlJailFree = vgui.Create( "SRPJailFreeMenu" )
	self.m_pnlJailFree:SetSize( 800, 480 )
	self.m_pnlJailFree:Center()
	self.m_pnlJailFree:SetVisible( false )
	self:RegisterNWMenu( "cop_jail_free", self.m_pnlJailFree )

	if ValidPanel( self.m_pnlJailBail ) then
		self.m_pnlJailFree:Remove()
	end
	self.m_pnlJailBail = vgui.Create( "SRPJailBailMenu" )
	self.m_pnlJailBail:SetSize( 800, 480 )
	self.m_pnlJailBail:Center()
	self.m_pnlJailBail:SetVisible( false )
	self:RegisterNWMenu( "cop_jail_bail", self.m_pnlJailBail )
end

function GM.Gui:BuildTicketMenu()
	if ValidPanel( self.m_pnlTicketMenu ) then
		self.m_pnlTicketMenu:Remove()
	end

	self.m_pnlTicketMenu = vgui.Create( "SRPTicketMenu" )
	self.m_pnlTicketMenu:SetSize( 800, 480 )
	self.m_pnlTicketMenu:Center()
	self.m_pnlTicketMenu:SetVisible( false )
	self:RegisterNWMenu( "ticket_menu", self.m_pnlTicketMenu )
end

function GM.Gui:BuildPropertyMenus()
	if ValidPanel( self.m_pnlPropertyBuyMenu ) then
		self.m_pnlPropertyBuyMenu:Remove()
	end

	self.m_pnlPropertyBuyMenu = vgui.Create( "SRPPropertyShop" )
	self.m_pnlPropertyBuyMenu:SetSize( 800, 480 )
	self.m_pnlPropertyBuyMenu:Center()
	self.m_pnlPropertyBuyMenu:SetVisible( false )
	self:RegisterNWMenu( "property_buy", self.m_pnlPropertyBuyMenu )
end

function GM.Gui:ShowNPCShopMenu( strNPCID )
	if ValidPanel( self.m_pnlNPCShopMenu ) then
		self.m_pnlNPCShopMenu:Remove()
	end

	self.m_pnlNPCShopMenu = vgui.Create( "SRPNPCShopMenu" )
	self.m_pnlNPCShopMenu:SetSize( 800, 480 )
	self.m_pnlNPCShopMenu:Center()
	self.m_pnlNPCShopMenu:Populate( strNPCID )
	self.m_pnlNPCShopMenu:SetVisible( true )
	self.m_pnlNPCShopMenu:MakePopup()
end

function GM.Gui:ShowNPCSellMenu( strNPCID )
	if ValidPanel( self.m_pnlNPCSellMenu ) then
		self.m_pnlNPCSellMenu:Remove()
	end

	self.m_pnlNPCSellMenu = vgui.Create( "SRPNPCSellMenu" )
	self.m_pnlNPCSellMenu:SetSize( 800, 480 )
	self.m_pnlNPCSellMenu:Center()
	self.m_pnlNPCSellMenu:Populate( strNPCID )
	self.m_pnlNPCSellMenu:SetVisible( true )
	self.m_pnlNPCSellMenu:MakePopup()
end

function GM.Gui:ShowCharacterSelection()
	if ValidPanel( self.m_pnlCharCreate ) then
		self.m_pnlCharCreate:Remove()
	end

	if ValidPanel( self.m_pnlCharCreate ) then
		self.m_pnlCharSel:SetVisible( false )
	end
	
	self.m_pnlCharSel = vgui.Create( "SRPCharacterSelection" )
	self.m_pnlCharSel:SetPos( 0, 0 )
	self.m_pnlCharSel:SetSize( ScrW(), ScrH() )
	self.m_pnlCharSel:Populate( GAMEMODE.Char:GetPlayerCharacters() )
	self.m_pnlCharSel:SetVisible( true )
	self.m_pnlCharSel:MakePopup()
end

function GM.Gui:ShowNewCharacterMenu()
	if ValidPanel( self.m_pnlCharCreate ) then
		self.m_pnlCharCreate:Remove()
	end

	if ValidPanel( self.m_pnlCharSel ) then
		self.m_pnlCharSel:SetVisible( false )
	end

	self.m_pnlCharCreate = vgui.Create( "SRPNewCharacterPanel" )
	self.m_pnlCharCreate:SetPos( 0, 0 )
	self.m_pnlCharCreate:SetSize( ScrW(), ScrH() )
	self.m_pnlCharCreate:SetVisible( true )
	self.m_pnlCharCreate:MakePopup()
end

function GM.Gui:BuildCustomPlateMenu()
	if ValidPanel( self.m_pnlCustomPlate ) then
		self.m_pnlCustomPlate:Remove()
	end

	self.m_pnlCustomPlate = vgui.Create( "SRPCustomPlateMenu" )
	self.m_pnlCustomPlate:SetSize( 800, 480 )
	self.m_pnlCustomPlate:Center()
	self.m_pnlCustomPlate:SetVisible( false )
	self:RegisterNWMenu( "custom_plate_menu", self.m_pnlCustomPlate )
end

function GM.Gui:BuildDrivingTestMenu()
	if ValidPanel( self.m_pnlDrivingTestMenu ) then
		self.m_pnlDrivingTestMenu:Remove()
	end

	self.m_pnlDrivingTestMenu = vgui.Create( "SRPDrivingTestMenu" )
	self.m_pnlDrivingTestMenu:SetSize( 800, 480 )
	self.m_pnlDrivingTestMenu:Center()
	self.m_pnlDrivingTestMenu:SetVisible( false )
	self:RegisterNWMenu( "driving_test_menu", self.m_pnlDrivingTestMenu )
end

function GM.Gui:BuildBankMenu()
	if ValidPanel( self.m_pnlBankMenu ) then
		self.m_pnlBankMenu:Remove()
	end

	self.m_pnlBankMenu = vgui.Create( "SRPBankStorageMenu" )
	self.m_pnlBankMenu:SetSize( 800, 480 )
	self.m_pnlBankMenu:Center()
	self.m_pnlBankMenu:SetVisible( false )
	self:RegisterNWMenu( "bank_storage_menu", self.m_pnlBankMenu )

	if ValidPanel( self.m_pnlLostAndFoundMenu ) then
		self.m_pnlLostAndFoundMenu:Remove()
	end

	self.m_pnlLostAndFoundMenu = vgui.Create( "SRPLostAndFoundMenu" )
	self.m_pnlLostAndFoundMenu:SetSize( 800, 480 )
	self.m_pnlLostAndFoundMenu:Center()
	self.m_pnlLostAndFoundMenu:SetVisible( false )
	self:RegisterNWMenu( "lost_and_found_menu", self.m_pnlLostAndFoundMenu )

	if ValidPanel( self.m_pnlBillsMenu ) then
		self.m_pnlBillsMenu:Remove()
	end

	self.m_pnlBillsMenu = vgui.Create( "SRPBillsMenu" )
	self.m_pnlBillsMenu:SetSize( 800, 480 )
	self.m_pnlBillsMenu:Center()
	self.m_pnlBillsMenu:SetVisible( false )
	self:RegisterNWMenu( "bills_menu", self.m_pnlBillsMenu )
end

function GM.Gui:BuildClothingMenu()
	if ValidPanel( self.m_pnlClothingMenu ) then
		self.m_pnlClothingMenu:Remove()
	end

	self.m_pnlClothingMenu = vgui.Create( "SRPClothingMenu" )
	self.m_pnlClothingMenu:SetSize( 800, 600 )
	self.m_pnlClothingMenu:Center()
	self.m_pnlClothingMenu:SetVisible( false )
	self:RegisterNWMenu( "clothing_shop_menu", self.m_pnlClothingMenu )

	if ValidPanel( self.m_pnlClothingItemMenu ) then
		self.m_pnlClothingItemMenu:Remove()
	end

	self.m_pnlClothingItemMenu = vgui.Create( "SRPClothingItemsMenu" )
	self.m_pnlClothingItemMenu:SetSize( ScrW(), ScrH() )
	self.m_pnlClothingItemMenu:Center()
	self.m_pnlClothingItemMenu:SetVisible( false )
	self:RegisterNWMenu( "clothing_items_store", self.m_pnlClothingItemMenu )

	if ValidPanel( self.m_pnlClothingLockerMenu ) then
		self.m_pnlClothingLockerMenu:Remove()
	end

	self.m_pnlClothingLockerMenu = vgui.Create( "SRPJobClothingLockerMenu" )
	self.m_pnlClothingLockerMenu:SetSize( 800, 600 )
	self.m_pnlClothingLockerMenu:Center()
	self.m_pnlClothingLockerMenu:SetVisible( false )
	self:RegisterNWMenu( "job_clothing_locker", self.m_pnlClothingLockerMenu )
end

function GM.Gui:BuildPhoneMenu()
	if ValidPanel( self.m_pnlPhone ) then
		self.m_pnlPhone:Remove()
	end

	self.m_pnlPhone = vgui.Create( "SRPPhoneMenu" )
	self.m_pnlPhone:SetSize( 276, 500 )
	self.m_pnlPhone:SetPos( ScrW() -self.m_pnlPhone:GetWide(), ScrH() )
	self.m_pnlPhone:SetVisible( false )
end

function GM.Gui:BuildCraftingMenus()
	if ValidPanel( self.m_pnlCraftingTableMenu ) then
		self.m_pnlCraftingTableMenu:Remove()
	end

	self.m_pnlCraftingTableMenu = vgui.Create( "SRPCraftingTableMenu" )
	self.m_pnlCraftingTableMenu:SetSize( 800, 480 )
	self.m_pnlCraftingTableMenu:Center()
	self.m_pnlCraftingTableMenu:SetVisible( false )
	self.m_pnlCraftingTableMenu:SetCraftingGroupData( "Crafting Table", "ent_crafting_table" )
	self:RegisterNWMenu( "crafting_table", self.m_pnlCraftingTableMenu )

	if ValidPanel( self.m_pnlGunSmithingTableMenu ) then
		self.m_pnlGunSmithingTableMenu:Remove()
	end

	self.m_pnlGunSmithingTableMenu = vgui.Create( "SRPCraftingTableMenu" )
	self.m_pnlGunSmithingTableMenu:SetSize( 800, 480 )
	self.m_pnlGunSmithingTableMenu:Center()
	self.m_pnlGunSmithingTableMenu:SetVisible( false )
	self.m_pnlGunSmithingTableMenu:SetCraftingGroupData( "Gun Smithing Table", "ent_gunsmithing_table" )
	self:RegisterNWMenu( "gunsmithing_table", self.m_pnlGunSmithingTableMenu )

	if ValidPanel( self.m_pnlAssemblyTableMenu ) then
		self.m_pnlAssemblyTableMenu:Remove()
	end

	self.m_pnlAssemblyTableMenu = vgui.Create( "SRPAssemblyTableMenu" )
	self.m_pnlAssemblyTableMenu:SetSize( 800, 480 )
	self.m_pnlAssemblyTableMenu:Center()
	self.m_pnlAssemblyTableMenu:SetVisible( false )
	self.m_pnlAssemblyTableMenu:SetCraftingGroupData( "Assembly Table", "ent_assembly_table" )
	self:RegisterNWMenu( "assembly_table", self.m_pnlAssemblyTableMenu )

	if ValidPanel( self.m_pnlFoodTableMenu ) then
		self.m_pnlFoodTableMenu:Remove()
	end
	
	self.m_pnlFoodTableMenu = vgui.Create( "SRPCraftingTableMenu" )
	self.m_pnlFoodTableMenu:SetSize( 800, 480 )
	self.m_pnlFoodTableMenu:Center()
	self.m_pnlFoodTableMenu:SetVisible( false )
	self.m_pnlFoodTableMenu:SetCraftingGroupData( "Food-Prep Table", "ent_foodprep_table" )
	self:RegisterNWMenu( "foodprep_table", self.m_pnlFoodTableMenu )
end

function GM.Gui:BuildChatRadioMenu()
	if ValidPanel( self.m_pnlChatRadio ) then
		self.m_pnlChatRadio:Remove()
	end

	self.m_pnlChatRadio = vgui.Create( "SRPChatRadioMenu" )
	self.m_pnlChatRadio:SetSize( 226, 185 )
	self.m_pnlChatRadio:SetPos( ScrW() -self.m_pnlChatRadio:GetWide() -5, (ScrH() /2) -(self.m_pnlChatRadio:GetTall() /2) )
	self.m_pnlChatRadio:SetVisible( false )
end

function GM.Gui:BuildItemLockerMenu()
	if ValidPanel( self.m_pnlItemLocker ) then
		self.m_pnlItemLocker:Remove()
	end

	self.m_pnlItemLocker = vgui.Create( "SRPJobItemLocker" )
	self.m_pnlItemLocker:SetSize( 800, 480 )
	self.m_pnlItemLocker:Center()
	self.m_pnlItemLocker:SetVisible( false )
	self:RegisterNWMenu( "job_item_locker", self.m_pnlItemLocker )
end

function GM.Gui:BuildGovMenus()
	if ValidPanel( self.m_pnlSSCarSpawn ) then
		self.m_pnlSSCarSpawn:Remove()
	end

	self.m_pnlSSCarSpawn = vgui.Create( "SRPSSCarSpawn" )
	self.m_pnlSSCarSpawn:SetSize( 800, 480 )
	self.m_pnlSSCarSpawn:Center()
	self.m_pnlSSCarSpawn:Populate()
	self.m_pnlSSCarSpawn:SetVisible( false )
	self:RegisterNWMenu( "ss_car_spawn", self.m_pnlSSCarSpawn )
end


function GM.Gui:ShowSalesTruckMenu( entCar )
	if ValidPanel( self.m_pnlSalesTruckMenu ) then
		self.m_pnlSalesTruckMenu:Remove()
	end

	self.m_pnlSalesTruckMenu = vgui.Create( "SRPSalesTruck" )
	self.m_pnlSalesTruckMenu:SetSize( 800, 480 )
	self.m_pnlSalesTruckMenu:Center()
	self.m_pnlSalesTruckMenu:SetEntity( entCar )
	self.m_pnlSalesTruckMenu:Open()
end

function GM.Gui:ShowItemBoxMenu( entItemBox, tblItems )
	if not ValidPanel( self.m_pnlItemBox ) then
		self.m_pnlItemBox = vgui.Create( "SRPItemBoxMenu" )
		self.m_pnlItemBox:SetSize( 800, 480 )
		self.m_pnlItemBox:Center()
		self.m_pnlItemBox:SetVisible( false )
	end

	self.m_pnlItemBox:SetEntity( entItemBox )
	self.m_pnlItemBox:Populate( tblItems )

	if not self.m_pnlItemBox:IsVisible() then
		self.m_pnlItemBox:Open()
	end
end

function GM.Gui:ShowStorageChestMenu( entChest, tblItems )
	if not ValidPanel( self.m_pnlStorageChest ) then
		self.m_pnlStorageChest = vgui.Create( "SRPStorageChestMenu" )
		self.m_pnlStorageChest:SetSize( 800, 480 )
		self.m_pnlStorageChest:Center()
		self.m_pnlStorageChest:SetVisible( false )
	end

	self.m_pnlStorageChest:SetEntity( entChest )
	self.m_pnlStorageChest:Populate( tblItems )

	if not self.m_pnlStorageChest:IsVisible() then
		self.m_pnlStorageChest:Open()
	end
end

function GM.Gui:ShowPropRadioMenu()
	if ValidPanel( self.m_pnlItemRadioMenu ) then
		self.m_pnlItemRadioMenu:Remove()
	end

	self.m_pnlItemRadioMenu = vgui.Create( "SRPItemRadio" )
	self.m_pnlItemRadioMenu:SetDeleteOnClose( true )
	self.m_pnlItemRadioMenu:SetSize( 640, 480 )
	self.m_pnlItemRadioMenu:Center()
	self.m_pnlItemRadioMenu:Refresh()
	
	self.m_pnlItemRadioMenu:MakePopup()
	self.m_pnlItemRadioMenu:SetVisible( true )
end

function GM.Gui:ShowCashRegisterMenu( entRegister, intMoney, tblNearby, tblListedItems )
	if ValidPanel( self.m_pnlCashRegister ) then
		self.m_pnlCashRegister:Remove()
	end

	self.m_pnlCashRegister = vgui.Create( "SRPCashRegisterMenu" )
	self.m_pnlCashRegister:SetEntity( entRegister )
	self.m_pnlCashRegister:SetMoney( intMoney )
	self.m_pnlCashRegister:SetSize( 800, 480 )
	self.m_pnlCashRegister:Center()
	self.m_pnlCashRegister:SetVisible( true )
	self.m_pnlCashRegister:MakePopup()
	self.m_pnlCashRegister:Populate( tblNearby, tblListedItems )
end

function GM.Gui:ShowTrunk(intCarIndex)
	local eCar = ents.GetByIndex(intCarIndex)
	if ValidPanel( self.m_pnlTrunkMenu ) then
	self.m_pnlTrunkMenu:Remove()
	end

	self.m_pnlTrunkMenu = vgui.Create( "SRPTrunkStorageMenu" )
	self.m_pnlTrunkMenu:SetSize( 800, 480 )
	self.m_pnlTrunkMenu:Center()
	self.m_pnlTrunkMenu:SetVisible( false )
	self.m_pnlTrunkMenu:Open(eCar)
end


