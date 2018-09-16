--[[
	Name: cl_menu_phone_app_messages.lua
	For: TalosLife
	By: TalosLife
]]--

local MAT_NEWMSG = Material( "taloslife/phone/ic_menu_notifications.png" )

--Photo display view
local Panel = {}
function Panel:Init()
	self.m_pnlToolbar = vgui.Create( "SRPPhone_AppToolbar", self )
	self.m_tblSelect = {}
	self.m_intCurSelection = 1

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Back", "taloslife/phone/ic_menu_revert.png", function()
		self:GetParent():GetParent():BackPage()
	end) )
	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Save", "taloslife/phone/ic_menu_save.png", function()
		GAMEMODE.Gui.m_pnlPhone:GetApp( "Camera" ):GetAppPanel():WritePicture( file.Read(self.m_strPhotoPath, "DATA") or "" )
		GAMEMODE.Gui.m_pnlPhone:GetApp( "Gallery" ):GetAppPanel():Rebuild()
		self:GetParent():GetParent():BackPage()
	end) )

	self.m_tblSelect[self.m_intCurSelection]:SetSelected( true )
end

function Panel:SetPhotoPath( strPath )
	self.m_strPhotoPath = strPath
	self.m_strPhotoFullPath = "../data/".. strPath
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

function Panel:Paint( intW, intH )
	if not self.m_bLoadedImage then
		self.m_matPreview = Material( self.m_strPhotoFullPath, "unlitgeneric" )
		self.m_bLoadedImage = true
		return
	end

	surface.SetDrawColor( 50, 50, 50, 255 )
	surface.DrawRect( 0, 0, intW, intH )

	if not self.m_matPreview then return end
	surface.SetMaterial( self.m_matPreview )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 36, intW, intH -36 )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlToolbar:SetPos( 0, 0 )
	self.m_pnlToolbar:SetSize( intW, 36 )
end
vgui.Register( "SRPPhone_ViewTempPhoto", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

--Message display card
local Panel = {}
function Panel:Init()
	self:SetSelectable( true )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	--self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetFont( "Trebuchet18" )

	self.m_pnlMsgLabel = vgui.Create( "DLabel", self )
	--self.m_pnlMsgLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlMsgLabel:SetTextColor( Color(0, 0, 0, 255) )
	self.m_pnlMsgLabel:SetFont( "Trebuchet18" )
	self.m_pnlMsgLabel:SetWrap( true )
end

function Panel:SetNumber( strNumber )
	self.m_strNumber = strNumber
	self.m_pnlNameLabel:SetText( self.m_bOutgoing and "Me" or strNumber )

	if not self.m_bOutgoing then
		for k, v in pairs( GAMEMODE.Gui.m_pnlPhone:GetApp("Contacts"):GetAppPanel().m_tblContacts ) do
			if v.Number == strNumber then
				self.m_pnlNameLabel:SetText( k )
				break
			end
		end
	end
end

function Panel:SetMessageData( strMessageData )
	self.m_strMessageData = strMessageData

	if self.m_bIsJPEG then
		self.m_strPhotoPath = "../data/".. strMessageData
		self.m_pnlViewPhoto:SetPhotoPath( strMessageData )
	else
		self.m_pnlMsgLabel:SetText( strMessageData )
	end
end

function Panel:SetIsJPEG( bIsJPEG )
	self.m_bIsJPEG = bIsJPEG
	self.m_pnlViewPhoto = vgui.Create( "SRPPhone_ViewTempPhoto", self )
	self.m_pnlViewPhoto:SetVisible( false )
end

function Panel:SetPhotoName( strName )
	self.m_strPhotoName = strName
	self.m_pnlMsgLabel:SetText( strName.. "\nImage - Click to view" )
end

function Panel:SetOutgoing( bOut )
	self.m_bOutgoing = bOut
end

function Panel:DoClick()
	if self.m_bIsJPEG then
		GAMEMODE.Gui.m_pnlPhone:ShowMenu( self.m_pnlViewPhoto )
	end
end

function Panel:Paint( intW, intH )
	if self.m_bOutgoing then
		draw.RoundedBox(
			6,
			0,
			2,
			intW,
			intH -4,
			Color( 254, 233, 199, 255 )
		)
	else
		draw.RoundedBox(
			6,
			0,
			2,
			intW,
			intH -4,
			Color( 200, 226, 226, 255 )
		)
	end

	if not self:IsSelected() then return end
	surface.SetDrawColor( 80, 80, 80, 150 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( 5, 5 )

	self.m_pnlMsgLabel:SetWide( intW -10 )
	self.m_pnlMsgLabel:SizeToContentsY()
	self.m_pnlMsgLabel:SetPos( 5, self.m_pnlNameLabel:GetTall() )
end
vgui.Register( "SRPPhone_TextMessageCard", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

--Cards in new thread list
local Panel = {}
function Panel:Init()
	self:SetSelectable( true )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetFont( "Trebuchet18" )
end

function Panel:SetContactData( strName, tblData )
	self.m_strName = strName
	self.m_tblData = tblData
	self.m_pnlNameLabel:SetText( strName )
end

function Panel:DoClick()
	GAMEMODE.Gui.m_pnlPhone:GetApp( "Messages" ):GetAppPanel():NewThread( self.m_tblData.Number )
	GAMEMODE.Gui.m_pnlPhone:BackPage()
end

function Panel:Paint( intW, intH )
	if not self:IsSelected() then return end
	surface.SetDrawColor( 80, 80, 80, 150 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( 5, (intH /2) -(self.m_pnlNameLabel:GetTall() /2) )
end
vgui.Register( "SRPPhone_MsgNewThreadCard", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

--Display contacts for new threads
local Panel = {}
function Panel:Init()
	self.m_tblContacts = {}

	self.m_pnlToolbar = vgui.Create( "SRPPhone_AppToolbar", self )
	self.m_tblSelect = {}

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Back", "taloslife/phone/ic_menu_revert.png", function()
		self:GetParent():GetParent():BackPage()
	end) )

	self.m_pnlContactContainer = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}

	self.m_intCurSelection = 1
	self.m_tblSelect[self.m_intCurSelection]:SetSelected( true )
end

function Panel:Rebuild()
	for k, v in pairs( self.m_tblSelect ) do
		if table.HasValue( self.m_tblCards, v ) then
			self.m_tblSelect[k] = nil
		end	
	end

	for k, v in pairs( self.m_tblCards ) do
		if ValidPanel( v ) then v:Remove() end
	end

	self.m_tblCards = {}

	--Add 911
	local card = vgui.Create( "SRPPhone_MsgNewThreadCard", self.m_pnlContactContainer )
	card:SetContactData( "Emergency", {CantEdit = true, Number = "911"} )
	table.insert( self.m_tblCards, card )
	table.insert( self.m_tblSelect, card )
	self.m_pnlContactContainer:AddItem( card )

	--Add Tow
	local card = vgui.Create( "SRPPhone_MsgNewThreadCard", self.m_pnlContactContainer )
	card:SetContactData( "Roadside Assistance", {CantEdit = true, Number = "Roadside Assistance"} )
	table.insert( self.m_tblCards, card )
	table.insert( self.m_tblSelect, card )
	self.m_pnlContactContainer:AddItem( card )

	--Add Taxi
	local card = vgui.Create( "SRPPhone_MsgNewThreadCard", self.m_pnlContactContainer )
	card:SetContactData( "Taxi", {CantEdit = true, Number = "Taxi"} )
	table.insert( self.m_tblCards, card )
	table.insert( self.m_tblSelect, card )
	self.m_pnlContactContainer:AddItem( card )
	
	for k, v in pairs( GAMEMODE.Gui.m_pnlPhone:GetApp("Contacts"):GetAppPanel().m_tblContacts ) do
		local card = vgui.Create( "SRPPhone_MsgNewThreadCard", self.m_pnlContactContainer )
		card:SetContactData( k, v )

		table.insert( self.m_tblCards, card )
		table.insert( self.m_tblSelect, card )
		self.m_pnlContactContainer:AddItem( card )
	end

	self.m_intCurSelection = 1
	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
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

	self:ScrollToSelected()
end

function Panel:LastSelection()
	self.m_intCurSelection = self.m_intCurSelection -1

	if 0 >= self.m_intCurSelection then
		self.m_intCurSelection = #self.m_tblSelect
	end

	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
	end

	self:ScrollToSelected()
end

function Panel:GetCurrentSelection()
	for k, v in pairs( self.m_tblSelect ) do
		if k == self.m_intCurSelection then
			return v
		end
	end
end

function Panel:ScrollToSelected()
	if not ValidPanel( self:GetCurrentSelection() ) then return end
	if not table.HasValue( self.m_tblCards, self:GetCurrentSelection() ) then return end
	self.m_pnlContactContainer:ScrollToChild( self:GetCurrentSelection() )
end

function Panel:DoClick()
	self:GetCurrentSelection():DoClick()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 60, 60, 60, 255 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlToolbar:SetPos( 0, 0 )
	self.m_pnlToolbar:SetSize( intW, 36 )

	self.m_pnlContactContainer:SetPos( 0, self.m_pnlToolbar:GetTall() )
	self.m_pnlContactContainer:SetSize( intW, intH -self.m_pnlToolbar:GetTall() )

	for k, v in pairs( self.m_tblCards ) do
		v:DockMargin( 0, 0, 0, 5 )
		v:SetTall( 32 )
		v:Dock( TOP )
	end
end
vgui.Register( "SRPPhone_MsgNewThread", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

--Cards for active thread list
local Panel = {}
function Panel:Init()
	self:SetSelectable( true )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetFont( "Trebuchet18" )

	self.m_pnlThreadView = vgui.Create( "SRPPhone_ThreadView", self )
	self.m_pnlThreadView:SetVisible( false )
end

function Panel:SetNumber( strNumber )
	self.m_strNumber = strNumber
	self.m_pnlNameLabel:SetText( strNumber )
	self.m_pnlThreadView:SetNumber( strNumber )

	for k, v in pairs( GAMEMODE.Gui.m_pnlPhone:GetApp("Contacts"):GetAppPanel().m_tblContacts ) do
		if v.Number == strNumber then
			self.m_pnlNameLabel:SetText( k )
		end
	end
end

function Panel:AddMessage_Incoming( ... )
	self.m_pnlThreadView:AddMessage_Incoming( ... )
	if not self.m_pnlThreadView:IsVisible() then
		self.m_bNewMsg = true
	end
end

function Panel:AddMessage_Outgoing( ... )
	self.m_pnlThreadView:AddMessage_Outgoing( ... )
end

function Panel:DoClick()
	GAMEMODE.Gui.m_pnlPhone:ShowMenu( self.m_pnlThreadView )
	self.m_bNewMsg = false
end

function Panel:Paint( intW, intH )
	if self.m_bNewMsg then
		local iconSize = 24
		surface.SetMaterial( MAT_NEWMSG )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( intW -iconSize -5, (intH /2) -(iconSize /2), iconSize, iconSize )
	end

	if not self:IsSelected() then return end
	surface.SetDrawColor( 80, 80, 80, 150 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( 5, (intH /2) -(self.m_pnlNameLabel:GetTall() /2) )
end
vgui.Register( "SRPPhone_MsgThreadCard", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

--Thread conversation display
local Panel = {}
function Panel:Init()
	self.m_pnlToolbar = vgui.Create( "SRPPhone_AppToolbar", self )
	self.m_tblSelect = {}

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Back", "taloslife/phone/ic_menu_revert.png", function()
		self:GetParent():GetParent():BackPage()
	end) )
	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Remove", "taloslife/phone/ic_menu_close_clear_cancel.png", function()
		self:GetParent():GetParent():BackPage()
		GAMEMODE.Gui.m_pnlPhone:GetApp( "Messages" ):GetAppPanel():RemoveThread( self.m_strNumber )
	end) )

	self.m_pnlThreadContainer = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}

	self.m_pnlMsgText = vgui.Create( "SRPPhone_TextEntry", self )
	self.m_pnlMsgText:SetMultiline( true )
	function self.m_pnlMsgText:AllowInput( intKey )
		if self:GetText():len() >= GAMEMODE.Config.MaxTextMsgLen then
			return true
		end
	end
	table.insert( self.m_tblSelect, self.m_pnlMsgText )

	self.m_pnlSendBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlSendBtn:SetText( "Send" )
	self.m_pnlSendBtn.DoClick = function()
		if self.m_pnlMsgText:GetText() == "" then return end
		GAMEMODE.Net:SendTextMessage( self.m_strNumber, self.m_pnlMsgText:GetText() )
		self.m_pnlMsgText:SetText( "" )
	end
	table.insert( self.m_tblSelect, self.m_pnlSendBtn )

	self.m_intCurSelection = 1
	self.m_tblSelect[self.m_intCurSelection]:SetSelected( true )
end

function Panel:AddMessage_Incoming( bIsJPEG, strNumSender, strMessageData, strPhotoName )
	local card = vgui.Create( "SRPPhone_TextMessageCard", self )
	if not bIsJPEG then
		card:SetNumber( strNumSender )
		card:SetIsJPEG( bIsJPEG )
		card:SetMessageData( strMessageData ) --text data
	else
		card:SetNumber( strNumSender )
		card:SetIsJPEG( bIsJPEG )
		card:SetPhotoName( strPhotoName )
		card:SetMessageData( strMessageData ) --full path to photo
	end
	
	card:InvalidateLayout( true )
	table.insert( self.m_tblCards, card )
	table.insert( self.m_tblSelect, card )
	self.m_pnlThreadContainer:AddItem( card )

	if #self.m_tblCards > 20 then
		for k, v in pairs( self.m_tblSelect ) do
			if v == self.m_tblCards[1] then
				table.remove( self.m_tblSelect, k )
				break
			end
		end

		self.m_tblCards[1]:Remove()
		table.remove( self.m_tblCards, 1 )
	end

	self:InvalidateLayout( true )
	self.m_pnlThreadContainer:ScrollToChild( card )
end

function Panel:AddMessage_Outgoing( bIsJPEG, strNumSender, strMessageData, strPhotoName )
	local card = vgui.Create( "SRPPhone_TextMessageCard", self )
	if not bIsJPEG then
		card:SetOutgoing( true )
		card:SetNumber( strNumSender )
		card:SetIsJPEG( bIsJPEG )
		card:SetMessageData( strMessageData ) --text data
	else
		card:SetOutgoing( true )
		card:SetNumber( strNumSender )
		card:SetIsJPEG( bIsJPEG )
		card:SetPhotoName( strPhotoName )
		card:SetMessageData( strMessageData ) --full path to photo
	end
	
	card:InvalidateLayout( true )
	table.insert( self.m_tblCards, card )
	table.insert( self.m_tblSelect, card )
	self.m_pnlThreadContainer:AddItem( card )

	if #self.m_tblCards > 20 then
		for k, v in pairs( self.m_tblSelect ) do
			if v == self.m_tblCards[1] then
				table.remove( self.m_tblSelect, k )
				break
			end
		end

		self.m_tblCards[1]:Remove()
		table.remove( self.m_tblCards, 1 )
	end

	self:InvalidateLayout( true )
	self.m_pnlThreadContainer:ScrollToChild( card )
end

function Panel:SetNumber( strNumber )
	self.m_strNumber = strNumber
end

function Panel:NextSelection()
	self.m_intCurSelection = self.m_intCurSelection +1

	if self.m_intCurSelection > #self.m_tblSelect then
		self.m_intCurSelection = 1
	end

	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
	end

	self:ScrollToSelected()
end

function Panel:LastSelection()
	self.m_intCurSelection = self.m_intCurSelection -1

	if 0 >= self.m_intCurSelection then
		self.m_intCurSelection = #self.m_tblSelect
	end

	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
	end

	self:ScrollToSelected()
end

function Panel:GetCurrentSelection()
	for k, v in pairs( self.m_tblSelect ) do
		if k == self.m_intCurSelection then
			return v
		end
	end
end

function Panel:ScrollToSelected()
	if not ValidPanel( self:GetCurrentSelection() ) then return end
	if not table.HasValue( self.m_tblCards, self:GetCurrentSelection() ) then return end
	self.m_pnlThreadContainer:ScrollToChild( self:GetCurrentSelection() )
end

function Panel:DoClick()
	self:GetCurrentSelection():DoClick()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 60, 60, 60, 255 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlToolbar:SetPos( 0, 0 )
	self.m_pnlToolbar:SetSize( intW, 36 )

	self.m_pnlSendBtn:SetSize( 40, 96 )
	self.m_pnlSendBtn:SetPos( intW -self.m_pnlSendBtn:GetWide(), intH -self.m_pnlSendBtn:GetTall() )

	self.m_pnlMsgText:SetSize( intW -self.m_pnlSendBtn:GetWide(), self.m_pnlSendBtn:GetTall() )
	self.m_pnlMsgText:SetPos( 0, intH -self.m_pnlMsgText:GetTall() )

	self.m_pnlThreadContainer:SetPos( 0, self.m_pnlToolbar:GetTall() )
	self.m_pnlThreadContainer:SetSize( intW, intH -self.m_pnlToolbar:GetTall() -self.m_pnlMsgText:GetTall() )

	for k, v in pairs( self.m_tblCards ) do
		v:SetWide( intW -4 )
		v:SetTall( v.m_pnlNameLabel:GetTall() +v.m_pnlMsgLabel:GetTall() +10 )

		v:DockMargin( 2, 2, 2, 2 )
		v:Dock( TOP )
	end
end
vgui.Register( "SRPPhone_ThreadView", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlToolbar = vgui.Create( "SRPPhone_AppToolbar", self )
	self.m_tblSelect = {}

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Back", "taloslife/phone/ic_menu_revert.png", function()
		self:GetParent():GetParent():BackPage()
	end) )
	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("New Thread", "taloslife/phone/ic_menu_invite.png", function()
		self.m_pnlNewThread:Rebuild()
		GAMEMODE.Gui.m_pnlPhone:ShowMenu( self.m_pnlNewThread )
	end) )

	self.m_pnlNewThread = vgui.Create( "SRPPhone_MsgNewThread", self )
	self.m_pnlNewThread:SetVisible( false )

	self.m_pnlThreadContainer = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}

	self.m_intCurSelection = 1
	self.m_tblSelect[self.m_intCurSelection]:SetSelected( true )

	hook.Add( "GamemodeGameStatusChanged", "Phone_UpdateMessages", function( bInGame )
		if bInGame then
			self:ClearThreads()
		end
	end )

	local hookName = ("Phone_DisplayText_%p"):format( self )
	hook.Add( "GamemodePhoneGetTextMessage", hookName, function( strNumSender, strMessage )
		if not ValidPanel( self ) then
			hook.Remove( "GamemodePhoneGetTextMessage", hookName )	
			return
		end

		local thread = self:GetThread( strNumSender )
		if not ValidPanel( thread ) then
			thread = self:NewThread( strNumSender )
		end

		thread:AddMessage_Incoming( false, strNumSender, strMessage )
	end )

	hook.Add( "GamemodePhoneGetImageMessage", hookName, function( strNumSender, strImageData )
		if not ValidPanel( self ) then
			hook.Remove( "GamemodeOnGetImageMessage", hookName )	
			return
		end

		local thread = self:GetThread( strNumSender )
		if not ValidPanel( thread ) then
			thread = self:NewThread( strNumSender )
		end

		--Save jpg data to temp
		local photoName = os.date("%m-%d-%Y - %X", os.time()):gsub(":", "_").. ".jpg"
		local fullPath = self:WriteTempPhoto( strNumSender.. "_".. photoName, strImageData )
		thread:AddMessage_Incoming( true, strNumSender, fullPath, photoName )
	end )

	hook.Add( "GamemodePhoneSendTextMessage", hookName, function( strNumSender, strMessage )
		if not ValidPanel( self ) then
			hook.Remove( "GamemodePhoneGetTextMessage", hookName )	
			return
		end

		local thread = self:GetThread( strNumSender )
		if not ValidPanel( thread ) then
			thread = self:NewThread( strNumSender )
		end

		thread:AddMessage_Outgoing( false, strNumSender, strMessage )
	end )

	hook.Add( "GamemodePhoneSendImageMessage", hookName, function( strNumSender, strImageData, strOrigPath, strOrigName )
		if not ValidPanel( self ) then
			hook.Remove( "GamemodeOnGetImageMessage", hookName )	
			return
		end

		local thread = self:GetThread( strNumSender )
		if not ValidPanel( thread ) then
			thread = self:NewThread( strNumSender )
		end

		thread:AddMessage_Outgoing( true, strNumSender, strOrigPath, strOrigName )
	end )
end

function Panel:WriteTempPhoto( strName, strImageData )
	local char_id = tonumber( GAMEMODE.Player:GetSharedGameVar(LocalPlayer(), "char_id", "") )
	if not char_id then return end

	if not file.IsDir( "santosrp", "DATA" ) then
		file.CreateDir( "santosrp" )
	end
	if not file.IsDir( "taloslife/phone", "DATA" ) then
		file.CreateDir( "taloslife/phone" )
	end
	if not file.IsDir( "taloslife/phone/temp_photos", "DATA" ) then
		file.CreateDir( "taloslife/phone/temp_photos" )
	end
	if not file.IsDir( "taloslife/phone/temp_photos/".. char_id, "DATA" ) then
		file.CreateDir( "taloslife/phone/temp_photos/".. char_id )
	end

	file.Write( "taloslife/phone/temp_photos/".. char_id.. "/".. strName.. ".txt", strImageData )
	return "taloslife/phone/temp_photos/".. char_id.. "/".. strName.. ".txt"
end

function Panel:NewThread( strNumber )
	for k, v in pairs( self.m_tblCards ) do
		if v.m_strNumber == strNumber then return end
	end

	local card = vgui.Create( "SRPPhone_MsgThreadCard", self )
	card:SetNumber( strNumber )
	table.insert( self.m_tblCards, card )
	table.insert( self.m_tblSelect, card )
	self.m_pnlThreadContainer:AddItem( card )

	return card
end

function Panel:RemoveThread( strNumber )
	if #self.m_tblSelect > 2 then
		for i = 3, #self.m_tblSelect do
			self.m_tblSelect[i] = nil
		end
	end

	local cards = table.Copy( self.m_tblCards )
	self.m_tblCards = {}

	for k, v in pairs( cards ) do
		if v.m_strNumber == strNumber then
			v:Remove()
		else
			table.insert( self.m_tblCards, v )
			table.insert( self.m_tblSelect, v )
			self.m_pnlThreadContainer:AddItem( v )
		end
	end

	self.m_intCurSelection = 1
	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
	end

	self:InvalidateLayout()
end

function Panel:GetThread( strNumber )
	for k, v in pairs( self.m_tblCards ) do
		if v.m_strNumber == strNumber then
			return v
		end
	end
end

function Panel:ClearThreads()
end

function Panel:NextSelection()
	self.m_intCurSelection = self.m_intCurSelection +1

	if self.m_intCurSelection > #self.m_tblSelect then
		self.m_intCurSelection = 1
	end

	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
	end

	self:ScrollToSelected()
end

function Panel:LastSelection()
	self.m_intCurSelection = self.m_intCurSelection -1

	if 0 >= self.m_intCurSelection then
		self.m_intCurSelection = #self.m_tblSelect
	end

	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
	end

	self:ScrollToSelected()
end

function Panel:GetCurrentSelection()
	for k, v in pairs( self.m_tblSelect ) do
		if k == self.m_intCurSelection then
			return v
		end
	end
end

function Panel:ScrollToSelected()
	if not ValidPanel( self:GetCurrentSelection() ) then return end
	if not table.HasValue( self.m_tblCards, self:GetCurrentSelection() ) then return end
	self.m_pnlThreadContainer:ScrollToChild( self:GetCurrentSelection() )
end

function Panel:DoClick()
	self:GetCurrentSelection():DoClick()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 60, 60, 60, 255 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlToolbar:SetPos( 0, 0 )
	self.m_pnlToolbar:SetSize( intW, 36 )

	self.m_pnlThreadContainer:SetPos( 0, self.m_pnlToolbar:GetTall() )
	self.m_pnlThreadContainer:SetSize( intW, intH -self.m_pnlToolbar:GetTall() )

	for k, v in pairs( self.m_tblCards ) do
		v:DockMargin( 0, 0, 0, 5 )
		v:SetTall( 32 )
		v:Dock( TOP )
	end
end
vgui.Register( "SRPPhone_App_Messages", Panel, "EditablePanel" )