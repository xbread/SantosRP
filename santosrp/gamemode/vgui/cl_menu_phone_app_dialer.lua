--[[
	Name: cl_menu_phone_app_dialer.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_tblMatList = {}
	self.m_tblSelect = {}
	self.m_intCurSelection = 1

	self.m_pnlCallingBtnContainer = vgui.Create( "EditablePanel", self )
	self.m_pnlBtnCallingAcceptCall = vgui.Create( "DImageButton", self.m_pnlCallingBtnContainer )
	self.m_pnlBtnCallingAcceptCall:SetImage( "taloslife/phone/ic_jog_dial_answer.png" )
	self.m_pnlBtnCallingAcceptCall.DoClick = function()
		GAMEMODE.Net:AcceptCall()
	end
	self.m_pnlBtnCallingDenyCall = vgui.Create( "DImageButton", self.m_pnlCallingBtnContainer )
	self.m_pnlBtnCallingDenyCall:SetImage( "taloslife/phone/ic_jog_dial_decline.png" )
	self.m_pnlBtnCallingDenyCall.DoClick = function()
		GAMEMODE.Net:HangUpPhone()
	end
	self.m_pnlCallingBtnContainer.PerformLayout = function( _, intW, intH )
		self.m_pnlBtnCallingAcceptCall:SetSize( 48, 48 )
		self.m_pnlBtnCallingAcceptCall:SetPos( 0, 0 )

		self.m_pnlBtnCallingDenyCall:SetSize( 48, 48 )
		self.m_pnlBtnCallingDenyCall:SetPos( self.m_pnlBtnCallingAcceptCall:GetWide() +48, 0 )		
	end
	self.m_pnlCallingBtnContainer.Paint = function( _, intW, intH )
		for k, v in pairs( self.m_tblSelect ) do
			if k == self.m_intCurSelection and v:GetParent() == self.m_pnlCallingBtnContainer then
				local x, y = v:GetPos()
				local w, h = v:GetSize()

				draw.RoundedBox(
					4,
					x,
					y,
					w,
					h,
					Color( 255, 255, 255, 50 )
				)
			end
		end
	end

	self.m_pnlCallBtnContainer = vgui.Create( "EditablePanel", self )
	self.m_pnlBtnCallEndCall = vgui.Create( "DImageButton", self.m_pnlCallBtnContainer )
	self.m_pnlBtnCallEndCall:SetImage( "taloslife/phone/ic_jog_dial_decline.png" )
	self.m_pnlBtnCallEndCall.DoClick = function()
		GAMEMODE.Net:HangUpPhone()
	end
	self.m_pnlCallBtnContainer.PerformLayout = function( _, intW, intH )
		self.m_pnlBtnCallEndCall:SetSize( 48, 48 )
		self.m_pnlBtnCallEndCall:SetPos( 0, 0 )
	end
	self.m_pnlCallBtnContainer.Paint = function( _, intW, intH )
		for k, v in pairs( self.m_tblSelect ) do
			if k == self.m_intCurSelection and v:GetParent() == self.m_pnlCallBtnContainer then
				local x, y = v:GetPos()
				local w, h = v:GetSize()

				draw.RoundedBox(
					4,
					x,
					y,
					w,
					h,
					Color( 255, 255, 255, 50 )
				)
			end
		end
	end

	hook.Add( "GamemodePhoneCallStart", "Phone", function()
		self.m_pnlCallingBtnContainer:SetVisible( false )
		self.m_pnlCallBtnContainer:SetVisible( true )

		timer.Destroy( "phone_ring_out" )
		self.m_bInCall = true

		self.m_tblSelect = {}
		table.insert( self.m_tblSelect, self.m_pnlBtnCallEndCall )
	end )

	hook.Add( "GamemodePhoneCallEnd", "Phone", function()
		if not ValidPanel( GAMEMODE.Gui:GetCurrentPhoneMenu() ) then return end
		if not GAMEMODE.Gui:GetCurrentPhoneMenu().IsCallMenu then return end
		self.m_bInCall = false
		GAMEMODE.Gui:PhonePageBack()
	end )

	hook.Add( "GamemodePhoneBadNumber", "Phone", function()
		surface.PlaySound( "taloslife/phone_error.mp3" )
	end )

	hook.Add( "GamemodePhoneBusy", "Phone", function()
		surface.PlaySound( "taloslife/phone_busy.mp3" )
	end )

	hook.Add( "GamemodePhoneCallIncoming", "Phone_CurCall", function( strNumber )
		if not ValidPanel( GAMEMODE.Gui:GetCurrentPhoneMenu() ) or not GAMEMODE.Gui:GetCurrentPhoneMenu().IsCallMenu then
			GAMEMODE.Gui.m_pnlPhone:ShowMenu( self )
		end

		self.m_pnlCallingBtnContainer:SetVisible( true )
		self.m_pnlCallingBtnContainer:MoveToFront()

		self.m_pnlCallBtnContainer:SetVisible( false )
		self.m_pnlCallBtnContainer:MoveToBack()

		self.m_tblSelect = {}
		self.m_intCurSelection = 1
		table.insert( self.m_tblSelect, self.m_pnlBtnCallingAcceptCall )
		table.insert( self.m_tblSelect, self.m_pnlBtnCallingDenyCall )
		self:InvalidateParent( true )
	end )

	hook.Add( "GamemodePhoneCallOutgoing", "Phone_CurCall", function( strNumber )
		if not ValidPanel( GAMEMODE.Gui:GetCurrentPhoneMenu() ) or not GAMEMODE.Gui:GetCurrentPhoneMenu().IsCallMenu then
			GAMEMODE.Gui.m_pnlPhone:ShowMenu( self )
		end

		self.m_pnlCallingBtnContainer:SetVisible( false )
		self.m_pnlCallingBtnContainer:MoveToBack()

		self.m_pnlCallBtnContainer:SetVisible( true )
		self.m_pnlCallBtnContainer:MoveToFront()

		self.m_tblSelect = {}
		self.m_intCurSelection = 1
		table.insert( self.m_tblSelect, self.m_pnlBtnCallEndCall )
		self:InvalidateParent( true )
	end )
end

function Panel:SetIncomingCall( strNumber )
	self.m_strNumberDisplay = strNumber
	self.m_bState = true --in
end

function Panel:SetOutgoingCall( strNumber )
	self.m_strNumberDisplay = strNumber
	self.m_bState = false --out
end

function Panel:NextSelection()
	self.m_intCurSelection = self.m_intCurSelection +1

	if self.m_intCurSelection > #self.m_tblSelect then
		self.m_intCurSelection = 1
	end

	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
	end
end

function Panel:LastSelection()
	self.m_intCurSelection = self.m_intCurSelection -1

	if 0 >= self.m_intCurSelection then
		self.m_intCurSelection = #self.m_tblSelect
	end

	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
	end
end

function Panel:GetCurrentSelection()
	for k, v in pairs( self.m_tblSelect ) do
		if k == self.m_intCurSelection then
			return v
		end
	end
end

function Panel:DoClick()
	if not self:GetCurrentSelection() then return end
	self:GetCurrentSelection():DoClick()
end

function Panel:OnPageBack()
	self.m_bInCall = false
	GAMEMODE.Net:HangUpPhone()
	timer.Destroy( "phone_ring_out" )
end

function Panel:Paint( intW, intH )
	local tbl = GAMEMODE.Gui.m_pnlPhone:GetApp( "Contacts" ):GetAppPanel().m_tblContacts
	for k, v in pairs( tbl ) do
		if v.Number == self.m_strNumberDisplay then
			if v.Photo then
				if not self.m_tblMatList[v.Photo] then
					self.m_tblMatList[v.Photo] = Material( v.Photo, "unlitgeneric" )
				end

				if self.m_tblMatList[v.Photo] then
					surface.SetMaterial( self.m_tblMatList[v.Photo] )
					surface.SetDrawColor( 255, 255, 255, 255 )			
					surface.DrawTexturedRect( 0, 0, intW, intH )
				end
			end
			
			draw.SimpleText(
				k,
				"DermaLarge",
				intW /2,
				intH *0.15,
				Color(255, 255, 255, 255),
				TEXT_ALIGN_CENTER
			)

			break
		end
	end

	draw.SimpleText(
		(self.m_bState and "->" or "<-").. (self.m_strNumberDisplay or ""),
		"DermaLarge",
		intW /2,
		intH *0.25,
		Color(255, 255, 255, 255),
		TEXT_ALIGN_CENTER
	)

	local x, y = self.m_pnlCallBtnContainer:GetPos()
	draw.SimpleText(
		self.m_bInCall and "Hang Up" or "Ringing",
		"DermaLarge",
		intW /2,
		y -32,
		Color(255, 255, 255, 255),
		TEXT_ALIGN_CENTER
	)
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlCallingBtnContainer:SetSize( 48 *3, 48 )
	self.m_pnlCallingBtnContainer:SetPos( (intW /2) -(self.m_pnlCallingBtnContainer:GetWide() /2), intH *0.75 )

	self.m_pnlCallBtnContainer:SetSize( 48, 48 )
	self.m_pnlCallBtnContainer:SetPos( (intW /2) -(self.m_pnlCallBtnContainer:GetWide() /2), intH *0.75 )
end
vgui.Register( "SRPPhone_App_Phone_Call", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlToolbar = vgui.Create( "SRPPhone_AppToolbar", self )
	self.m_tblSelect = {}

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Back", "taloslife/phone/ic_menu_revert.png", function()
		self:GetParent():GetParent():BackPage()
	end) )
	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Contacts", "taloslife/phone/ic_menu_cc_am.png", function()
		self:GetParent():GetParent():ShowApp( "Contacts" )
	end) )

	self.m_tblBtnMats = {
		{ Key = "1", Mat = "taloslife/phone/sym_keyboard_num1.png" },
		{ Key = "2", Mat = "taloslife/phone/sym_keyboard_num2.png" },
		{ Key = "3", Mat = "taloslife/phone/sym_keyboard_num3.png" },
		{ Key = "4", Mat = "taloslife/phone/sym_keyboard_num4.png" },
		{ Key = "5", Mat = "taloslife/phone/sym_keyboard_num5.png" },
		{ Key = "6", Mat = "taloslife/phone/sym_keyboard_num6.png" },
		{ Key = "7", Mat = "taloslife/phone/sym_keyboard_num7.png" },
		{ Key = "8", Mat = "taloslife/phone/sym_keyboard_num8.png" },
		{ Key = "9", Mat = "taloslife/phone/sym_keyboard_num9.png" },
		{ Key = "back", Mat = "taloslife/phone/sym_keyboard_delete.png" },
		{ Key = "0", Mat = "taloslife/phone/sym_keyboard_num0_no_plus.png" },
		{ Key = "dial", Mat = "taloslife/phone/sym_action_call.png" },
	}

	self.m_intCurSelection = 1
	self.m_strCurNumber = ""
	self:BuildKeyPad()
	self.m_tblSelect[self.m_intCurSelection]:SetSelected( true )

	self.m_pnlCallMenu = vgui.Create( "SRPPhone_App_Phone_Call", self )
	self.m_pnlCallMenu:SetVisible( false )

	--Fuck derma. Something is changing my panel pointers and fucking EVERYTHING UP. But this var seems to live on so FUCK IT
	self.m_pnlCallMenu.IsCallMenu = true

	hook.Add( "GamemodePhoneCallIncoming", "Phone", function( strNumber )
		self.m_pnlCallMenu:SetIncomingCall( strNumber )
		if self.m_pnlCallMenu:IsVisible() then return end
		GAMEMODE.Gui.m_pnlPhone:ShowMenu( self.m_pnlCallMenu )
	end )

	hook.Add( "GamemodePhoneCallOutgoing", "Phone", function( strNumber )
		self.m_pnlCallMenu:SetOutgoingCall( strNumber )

		surface.PlaySound( "taloslife/phone_ring.mp3" )
		timer.Create( "phone_ring_out", 5, 0, function()
			surface.PlaySound( "taloslife/phone_ring.mp3" )
		end )
	end )

	hook.Add( "GamemodePhoneCallEnd", "Phone", function( strNumber )
		if not ValidPanel( GAMEMODE.Gui:GetCurrentPhoneMenu() ) then return end
		if not GAMEMODE.Gui:GetCurrentPhoneMenu().IsCallMenu then return end
		GAMEMODE.Gui:PhonePageBack()
	end )
end

function Panel:BuildKeyPad()
	self.m_pnlKeyContainer = vgui.Create( "EditablePanel", self )
	self.m_tblKeys = {}

	for k, v in pairs( self.m_tblBtnMats ) do
		local btn = vgui.Create( "DImageButton", self.m_pnlKeyContainer )
		btn:SetImage( v.Mat )
		btn.DoClick = function()
			self:KeyPressed( v.Key )
		end

		table.insert( self.m_tblKeys, btn )
		table.insert( self.m_tblSelect, btn )
	end

	self.m_pnlKeyContainer.Paint = function( _, intW, intH )
		for k, v in pairs( self.m_tblKeys ) do
			if v.m_bSelected then
				local x, y = v:GetPos()
				local w, h = v:GetSize()

				draw.RoundedBox(
					4,
					x,
					y,
					w,
					h,
					Color( 255, 255, 255, 50 )
				)
			end
		end
	end
end

function Panel:KeyPressed( strNum )
	if tonumber( strNum ) ~= nil then
		if self.m_strCurNumber:len() < 10 then
			self.m_strCurNumber = self.m_strCurNumber ..strNum
			surface.PlaySound( "taloslife/dtmf".. strNum.. ".wav" )
		end
	else
		if strNum == "back" then
			self.m_strCurNumber = self.m_strCurNumber:sub( 1, self.m_strCurNumber:len() -1 )
		elseif strNum == "dial" then
			if self.m_strCurNumber == "" then return end
			GAMEMODE.Net:DialPhoneNumber( self.m_strCurNumber )
		end
	end
end

function Panel:NextSelection()
	self.m_intCurSelection = self.m_intCurSelection +1

	if self.m_intCurSelection > #self.m_tblSelect then
		self.m_intCurSelection = 1
	end

	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
	end
end

function Panel:LastSelection()
	self.m_intCurSelection = self.m_intCurSelection -1

	if 0 >= self.m_intCurSelection then
		self.m_intCurSelection = #self.m_tblSelect
	end

	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
	end
end

function Panel:GetCurrentSelection()
	for k, v in pairs( self.m_tblSelect ) do
		if k == self.m_intCurSelection then
			return v
		end
	end
end

function Panel:DoClick()
	self:GetCurrentSelection():DoClick()
end

function Panel:NumberTyped( int )
	self:KeyPressed( int )
end

function Panel:Paint( intW, intH )
	--Key container bg
	local x, y = self.m_pnlKeyContainer:GetPos()
	local w, h = self.m_pnlKeyContainer:GetSize()
	y = y -5

	surface.SetDrawColor( 30, 30, 30, 255 )
	surface.DrawRect( 0, y, intW, intH -y )

	local cH = intH -self.m_pnlToolbar:GetTall() -y
	--Current Number Display
	draw.SimpleText(
		self.m_strCurNumber,
		"DermaLarge",
		intW /2,
		self.m_pnlToolbar:GetTall() +(cH /2),
		Color(255, 255, 255, 255),
		TEXT_ALIGN_CENTER
	)

	local tbl = GAMEMODE.Gui.m_pnlPhone:GetApp( "Contacts" ):GetAppPanel().m_tblContacts
	for k, v in pairs( tbl ) do
		if v.Number == self.m_strCurNumber then
			draw.SimpleText(
				k,
				"DermaLarge",
				intW /2,
				self.m_pnlToolbar:GetTall() +(cH /2) -28,
				Color(255, 255, 255, 255),
				TEXT_ALIGN_CENTER
			)

			break
		end
	end
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlToolbar:SetPos( 0, 0 )
	self.m_pnlToolbar:SetSize( intW, 36 )

	local keySizeW, keySizeH = 64, 35
	local keyPaddingW, keyPaddingH = 5, 5

	local keysPerRow, count = 3, 0
	local x, y = 0, 0
	for k, v in pairs( self.m_tblKeys ) do
		count = count +1
		v:SetPos( x, y )
		v:SetSize( keySizeW, keySizeH )

		if count >= keysPerRow then
			count = 0
			x = 0
			y = y +keySizeH +keyPaddingH
		else
			x = x +keySizeW +keyPaddingW
		end
	end

	self.m_pnlKeyContainer:SetSize( keysPerRow *(keySizeW +keyPaddingW), y )
	self.m_pnlKeyContainer:SetPos( (intW /2) -(self.m_pnlKeyContainer:GetWide() /2), intH -self.m_pnlKeyContainer:GetTall() -5 )

	self.m_pnlCallMenu:SetPos( 0, 0 )
	self.m_pnlCallMenu:SetSize( intW, intH )
end
vgui.Register( "SRPPhone_App_PhoneDialer", Panel, "EditablePanel" )