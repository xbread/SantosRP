--[[
	Name: cl_menu_phone_app_contacts.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_pnlToolbar = vgui.Create( "SRPPhone_AppToolbar", self )
	self.m_tblSelect = {}

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Back", "taloslife/phone/ic_menu_revert.png", function()
		GAMEMODE.Gui.m_pnlPhone:BackPage()
	end) )

	self.m_intCurSelection = 1
	self.m_tblSelect[self.m_intCurSelection]:SetSelected( true )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetText( "Contact Name:" )
	self.m_pnlNameLabel:SetFont( "Trebuchet24" )
	self.m_pnlNameText = vgui.Create( "SRPPhone_TextEntry", self )
	table.insert( self.m_tblSelect, self.m_pnlNameText )

	self.m_pnlNumberLabel = vgui.Create( "DLabel", self )
	self.m_pnlNumberLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNumberLabel:SetText( "Phone Number:" )
	self.m_pnlNumberLabel:SetFont( "Trebuchet24" )
	self.m_pnlNumberText = vgui.Create( "SRPPhone_TextEntry", self )
	table.insert( self.m_tblSelect, self.m_pnlNumberText )

	self.m_pnlAddBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlAddBtn:SetText( "Add Contact" )
	self.m_pnlAddBtn.DoClick = function()
		if self.m_pnlNameText:GetText() == "" then return end
		if self.m_pnlNumberText:GetText() == "" then return end
		
		if self.m_pnlParentMenu:AddContact( self.m_pnlNameText:GetText(), self.m_pnlNumberText:GetText() ) then
			GAMEMODE.Gui.m_pnlPhone:BackPage()
		end
	end
	table.insert( self.m_tblSelect, self.m_pnlAddBtn )
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

function Panel:Clear()
	self.m_pnlNameText:SetText( "" )
	self.m_pnlNumberText:SetText( "" )
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 60, 60, 60, 255 )
	surface.DrawRect( 0, 0, intW, intH )

	if self:GetCurrentSelection() == self.m_pnlNameText then
		local x, y = self.m_pnlNameLabel:GetPos()
		local w, h = self.m_pnlNameText:GetSize()
		h = h +self.m_pnlNameText:GetTall()

		draw.RoundedBox(
			4,
			x,
			y,
			w,
			h,
			Color( 255, 255, 255, 50 )
		)
	elseif self:GetCurrentSelection() == self.m_pnlNumberText then
		local x, y = self.m_pnlNumberLabel:GetPos()
		local w, h = self.m_pnlNumberText:GetSize()
		h = h +self.m_pnlNumberText:GetTall()

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

function Panel:PerformLayout( intW, intH )
	self.m_pnlToolbar:SetPos( 0, 0 )
	self.m_pnlToolbar:SetSize( intW, 36 )

	local y = self.m_pnlToolbar:GetTall() +5
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( 5, y )
	y = y +self.m_pnlNameLabel:GetTall()

	self.m_pnlNameText:SetPos( 5, y )
	self.m_pnlNameText:SetSize( intW -10, 25 )
	y = y +self.m_pnlNameText:GetTall() +5

	self.m_pnlNumberLabel:SizeToContents()
	self.m_pnlNumberLabel:SetPos( 5, y )
	y = y +self.m_pnlNumberLabel:GetTall()

	self.m_pnlNumberText:SetPos( 5, y )
	self.m_pnlNumberText:SetSize( intW -10, 25 )

	self.m_pnlAddBtn:SetSize( intW, 32 )
	self.m_pnlAddBtn:SetPos( 0, intH -self.m_pnlAddBtn:GetTall() )
end
vgui.Register( "SRPPhone_AddContact", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlToolbar = vgui.Create( "SRPPhone_AppToolbar", self )
	self.m_tblSelect = {}

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Back", "taloslife/phone/ic_menu_revert.png", function()
		GAMEMODE.Gui.m_pnlPhone:BackPage()
	end) )

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Call", "taloslife/phone/ic_menu_call.png", function()
		GAMEMODE.Gui.m_pnlPhone:GetApp( "Phone" ):GetAppPanel().m_strCurNumber = self.m_tblData.Number
		GAMEMODE.Gui.m_pnlPhone:ShowApp( "Phone", function()
			GAMEMODE.Net:DialPhoneNumber( self.m_tblData.Number )
		end )
	end) )

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Delete", "taloslife/phone/ic_menu_blocked_user.png", function()
		if self.m_tblData.CantEdit then return end
		GAMEMODE.Gui.m_pnlPhone:GetApp( "Contacts" ):GetAppPanel().m_tblContacts[self.m_strName] = nil
		GAMEMODE.Gui.m_pnlPhone:GetApp( "Contacts" ):GetAppPanel():Rebuild()
		GAMEMODE.Gui.m_pnlPhone:BackPage()
	end) )

	self.m_intCurSelection = 1
	self.m_tblSelect[self.m_intCurSelection]:SetSelected( true )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetText( "Contact Name:" )
	self.m_pnlNameLabel:SetFont( "Trebuchet24" )
	self.m_pnlNameText = vgui.Create( "SRPPhone_TextEntry", self )
	table.insert( self.m_tblSelect, self.m_pnlNameText )

	self.m_pnlNumberLabel = vgui.Create( "DLabel", self )
	self.m_pnlNumberLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNumberLabel:SetText( "Phone Number:" )
	self.m_pnlNumberLabel:SetFont( "Trebuchet24" )
	self.m_pnlNumberText = vgui.Create( "SRPPhone_TextEntry", self )
	table.insert( self.m_tblSelect, self.m_pnlNumberText )

	self.m_pnlUpdBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlUpdBtn:SetText( "Update Contact" )
	self.m_pnlUpdBtn.DoClick = function()
		if self.m_tblData.CantEdit then return end
		if self.m_pnlNameText:GetText() == "" then return end
		if self.m_pnlNumberText:GetText() == "" then return end
		
		local pnl = GAMEMODE.Gui.m_pnlPhone:GetApp( "Contacts" ):GetAppPanel()
		if self.m_pnlNameText:GetText() == self.m_strName then
			pnl.m_tblContacts[self.m_strName].Number = self.m_pnlNumberText:GetText()
		else
			if pnl:AddContact( self.m_pnlNameText:GetText(), self.m_pnlNumberText:GetText() ) then
				pnl.m_tblContacts[self.m_strName] = nil
			else
				--
			end
		end

		pnl:SaveContacts()
		pnl:Rebuild()
	end
	table.insert( self.m_tblSelect, self.m_pnlUpdBtn )
end

function Panel:SetContactData( strName, tblData )
	self.m_strName = strName
	self.m_tblData = tblData
	self.m_pnlNameText:SetText( strName )
	self.m_pnlNumberText:SetText( tblData.Number )
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

function Panel:OnPageBack()
	if not self.m_tblData.CantEdit then return end
	self.m_pnlNameText:SetText( self.m_strName )
	self.m_pnlNumberText:SetText( self.m_tblData.Number )
end

function Panel:Clear()
	self.m_pnlNameText:SetText( "" )
	self.m_pnlNumberText:SetText( "" )
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 60, 60, 60, 255 )
	surface.DrawRect( 0, 0, intW, intH )

	if self:GetCurrentSelection() == self.m_pnlNameText then
		local x, y = self.m_pnlNameLabel:GetPos()
		local w, h = self.m_pnlNameText:GetSize()
		h = h +self.m_pnlNameText:GetTall()

		draw.RoundedBox(
			4,
			x,
			y,
			w,
			h,
			Color( 255, 255, 255, 50 )
		)
	elseif self:GetCurrentSelection() == self.m_pnlNumberText then
		local x, y = self.m_pnlNumberLabel:GetPos()
		local w, h = self.m_pnlNumberText:GetSize()
		h = h +self.m_pnlNumberText:GetTall()

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

function Panel:PerformLayout( intW, intH )
	self.m_pnlToolbar:SetPos( 0, 0 )
	self.m_pnlToolbar:SetSize( intW, 36 )

	local y = self.m_pnlToolbar:GetTall() +5
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( 5, y )
	y = y +self.m_pnlNameLabel:GetTall()

	self.m_pnlNameText:SetPos( 5, y )
	self.m_pnlNameText:SetSize( intW -10, 25 )
	y = y +self.m_pnlNameText:GetTall() +5

	self.m_pnlNumberLabel:SizeToContents()
	self.m_pnlNumberLabel:SetPos( 5, y )
	y = y +self.m_pnlNumberLabel:GetTall()

	self.m_pnlNumberText:SetPos( 5, y )
	self.m_pnlNumberText:SetSize( intW -10, 25 )

	self.m_pnlUpdBtn:SetSize( intW, 32 )
	self.m_pnlUpdBtn:SetPos( 0, intH -self.m_pnlUpdBtn:GetTall() )
end
vgui.Register( "SRPPhone_ViewContact", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetSelectable( true )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetFont( "Trebuchet18" )

	self.m_pnlContactView = vgui.Create( "SRPPhone_ViewContact", self )
	self.m_pnlContactView:SetVisible( false )
end

function Panel:SetContactData( strName, tblData )
	self.m_strName = strName
	self.m_tblData = tblData
	self.m_pnlNameLabel:SetText( strName )
	self.m_pnlContactView:SetContactData( self.m_strName, self.m_tblData )
end

function Panel:DoClick()
	GAMEMODE.Gui.m_pnlPhone:ShowMenu( self.m_pnlContactView )
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
vgui.Register( "SRPPhone_ContactCard", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_tblContacts = {}

	self.m_pnlToolbar = vgui.Create( "SRPPhone_AppToolbar", self )
	self.m_tblSelect = {}

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Back", "taloslife/phone/ic_menu_revert.png", function()
		self:GetParent():GetParent():BackPage()
	end) )
	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Add", "taloslife/phone/ic_menu_invite.png", function()
		self.m_pnlNewContact:Clear()
		GAMEMODE.Gui.m_pnlPhone:ShowMenu( self.m_pnlNewContact )
	end) )

	self.m_pnlNewContact = vgui.Create( "SRPPhone_AddContact", self )
	self.m_pnlNewContact:SetVisible( false )
	self.m_pnlNewContact.m_pnlParentMenu = self

	self.m_pnlContactContainer = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}

	self.m_intCurSelection = 1
	self.m_tblSelect[self.m_intCurSelection]:SetSelected( true )

	hook.Add( "GamemodeGameStatusChanged", "Phone_UpdateContacts", function( bInGame )
		if bInGame then
			self:BuildContacts()
		end
	end )
end

function Panel:BuildContacts()
	local char_id = tonumber( GAMEMODE.Player:GetSharedGameVar(LocalPlayer(), "char_id", "") )
	if not char_id then return end
	
	local saved = util.JSONToTable( file.Read("taloslife/phone/contacts_".. char_id.. ".txt") or "" )
	self.m_tblContacts = saved or {}
	self:Rebuild()
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

	--Add our own number first
	local card = vgui.Create( "SRPPhone_ContactCard", self.m_pnlContactContainer )
	card:SetContactData( "Me", {CantEdit = true, Number = GAMEMODE.Player:GetGameVar("phone_number", "")} )
	table.insert( self.m_tblCards, card )
	table.insert( self.m_tblSelect, card )
	self.m_pnlContactContainer:AddItem( card )

	for k, v in pairs( self.m_tblContacts ) do
		local card = vgui.Create( "SRPPhone_ContactCard", self.m_pnlContactContainer )
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

function Panel:SaveContacts()
	local char_id = tonumber( GAMEMODE.Player:GetSharedGameVar(LocalPlayer(), "char_id", "") )
	if not char_id then return end

	if not file.IsDir( "santosrp", "DATA" ) then
		file.CreateDir( "santosrp" )
	end
	if not file.IsDir( "taloslife/phone", "DATA" ) then
		file.CreateDir( "taloslife/phone" )
	end

	file.Write( "taloslife/phone/contacts_".. char_id.. ".txt", util.TableToJSON(self.m_tblContacts) )
end

function Panel:AddContact( strName, strNumber )
	if self.m_tblContacts[strName] then
		--
		return false
	end

	self.m_tblContacts[strName] = { Number = strNumber }
	self:SaveContacts()
	self:Rebuild()

	return true
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

	self.m_pnlNewContact:SetPos( 0, self.m_pnlToolbar:GetTall() )
	self.m_pnlNewContact:SetSize( intW, intH -self.m_pnlToolbar:GetTall() )

	for k, v in pairs( self.m_tblCards ) do
		v:DockMargin( 0, 0, 0, 5 )
		v:SetTall( 32 )
		v:Dock( TOP )
	end
end
vgui.Register( "SRPPhone_App_Contacts", Panel, "EditablePanel" )