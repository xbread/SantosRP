--[[
	Name: cl_menu_phone_app_gallery.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self:SetSelectable( true )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetFont( "Trebuchet18" )

	self.m_pnlContactView = vgui.Create( "SRPPhone_ViewContact", self )
	self.m_pnlContactView:SetVisible( false )
end

function Panel:SetWorkingPhoto( strPath )
	self.m_strPhoto = strPath
end

function Panel:SetContactData( strName, tblData )
	self.m_strName = strName
	self.m_tblData = tblData
	self.m_pnlNameLabel:SetText( strName )
	self.m_pnlContactView:SetContactData( self.m_strName, self.m_tblData )
end

function Panel:DoClick()
	GAMEMODE.Gui.m_pnlPhone:GetApp( "Contacts" ):GetAppPanel().m_tblContacts[self.m_strName].Photo = self.m_strPhoto
	GAMEMODE.Gui.m_pnlPhone:GetApp( "Contacts" ):GetAppPanel():SaveContacts()
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
vgui.Register( "SRPPhone_ContactSetPhotoCard", Panel, "EditablePanel" )

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

function Panel:SetWorkingPhoto( strName, strPath )
	self.m_strPhotoName = strName
	self.m_strPhoto = strPath
end

function Panel:SetContactData( strName, tblData )
	self.m_strName = strName
	self.m_tblData = tblData
	self.m_pnlNameLabel:SetText( strName )
	self.m_pnlContactView:SetContactData( self.m_strName, self.m_tblData )
end

function Panel:DoClick()
	GAMEMODE.Net:SendImageMessage( self.m_tblData.Number, file.Read(self.m_strPhoto, "DATA") or "", self.m_strPhoto, self.m_strPhotoName )
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
vgui.Register( "SRPPhone_ContactSendPhotoCard", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

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

function Panel:SetWorkingPhoto( strPath )
	self.m_strPhoto = strPath
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

	for k, v in pairs( GAMEMODE.Gui.m_pnlPhone:GetApp("Contacts"):GetAppPanel().m_tblContacts or {} ) do
		local card = vgui.Create( "SRPPhone_ContactSetPhotoCard", self.m_pnlContactContainer )
		card:SetWorkingPhoto( self.m_strPhoto )
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
vgui.Register( "SRPPhone_ContactSetPhoto", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

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

function Panel:SetWorkingPhoto( strName, strPath )
	self.m_strPhotoName = strName
	self.m_strPhoto = strPath
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

	for k, v in pairs( GAMEMODE.Gui.m_pnlPhone:GetApp("Contacts"):GetAppPanel().m_tblContacts or {} ) do
		local card = vgui.Create( "SRPPhone_ContactSendPhotoCard", self.m_pnlContactContainer )
		card:SetWorkingPhoto( self.m_strPhotoName, self.m_strPhoto )
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
vgui.Register( "SRPPhone_SendPhoto", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlToolbar = vgui.Create( "SRPPhone_AppToolbar", self )
	self.m_tblSelect = {}
	self.m_intCurSelection = 1

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Back", "taloslife/phone/ic_menu_revert.png", function()
		self:GetParent():GetParent():BackPage()
	end) )
	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Set Contact", "taloslife/phone/ic_menu_cc_am.png", function()
		self.m_pnlPickContact:Rebuild()
		GAMEMODE.Gui.m_pnlPhone:ShowMenu( self.m_pnlPickContact )
	end) )
	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Send To", "taloslife/phone/ic_menu_cc_am.png", function()
		self.m_pnlSendTo:Rebuild()
		GAMEMODE.Gui.m_pnlPhone:ShowMenu( self.m_pnlSendTo )
	end) )
	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Delete", "taloslife/phone/ic_menu_close_clear_cancel.png", function()
		file.Delete( self.m_strPath.. self.m_strName )
		GAMEMODE.Gui.m_pnlPhone:GetApp( "Gallery" ):GetAppPanel():Rebuild()
		GAMEMODE.Gui.m_pnlPhone:BackPage()
	end) )

	self.m_pnlPickContact = vgui.Create( "SRPPhone_ContactSetPhoto", self )
	self.m_pnlPickContact:SetVisible( false )

	self.m_pnlSendTo = vgui.Create( "SRPPhone_SendPhoto", self )
	self.m_pnlSendTo:SetVisible( false )

	self.m_tblSelect[self.m_intCurSelection]:SetSelected( true )
end

function Panel:SetPhoto( strName, strPath )
	self.m_strName = strName
	self.m_strPath = strPath
	self.m_matPreview = Material( "../data/".. self.m_strPath.. self.m_strName, "unlitgeneric" )
	self.m_pnlPickContact:SetWorkingPhoto( "../data/".. self.m_strPath.. self.m_strName )
	self.m_pnlSendTo:SetWorkingPhoto( self.m_strName, self.m_strPath.. self.m_strName )
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
	if not self.m_matPreview then return end
	
	surface.SetDrawColor( 50, 50, 50, 255 )
	surface.DrawRect( 0, 0, intW, intH )

	surface.SetMaterial( self.m_matPreview )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 36, intW, intH -36 )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlToolbar:SetPos( 0, 0 )
	self.m_pnlToolbar:SetSize( intW, 36 )
end
vgui.Register( "SRPPhone_ViewPhoto", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetSelectable( true )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetFont( "Trebuchet18" )

	self.m_pnlPhotoView = vgui.Create( "SRPPhone_ViewPhoto", self )
	self.m_pnlPhotoView:SetVisible( false )
end

function Panel:SetPhoto( strName, strPath )
	self.m_strName = strName
	self.m_strPath = strPath
	self.m_pnlNameLabel:SetText( strName )
	self.m_pnlPhotoView:SetPhoto( self.m_strName, self.m_strPath )
end

function Panel:DoClick()
	GAMEMODE.Gui.m_pnlPhone:ShowMenu( self.m_pnlPhotoView )
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
vgui.Register( "SRPPhone_PhotoCard", Panel, "EditablePanel" )

-- --------------------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_tblPhotos = {}
	self.m_pnlToolbar = vgui.Create( "SRPPhone_AppToolbar", self )
	self.m_tblSelect = {}

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Back", "taloslife/phone/ic_menu_revert.png", function()
		self:GetParent():GetParent():BackPage()
	end) )

	self.m_pnlPhotoContainer = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}

	self.m_intCurSelection = 1
	self.m_tblSelect[self.m_intCurSelection]:SetSelected( true )

	hook.Add( "GamemodeGameStatusChanged", "Phone_UpdateGallery", function( bInGame )
		if bInGame then
			self:PurgeTempPhotos()
			self:Rebuild()
		end
	end )
end

function Panel:PurgeTempPhotos()
	local char_id = tonumber( GAMEMODE.Player:GetSharedGameVar(LocalPlayer(), "char_id", "") )
	if not char_id then return end
	
	local files, _ = file.Find( "taloslife/phone/temp_photos/".. char_id.. "/*", "DATA" )
	for k, v in pairs( files ) do
		file.Delete( "taloslife/phone/temp_photos/".. char_id.. "/".. v )
	end
end

function Panel:BuildPhotos()
	local char_id = tonumber( GAMEMODE.Player:GetSharedGameVar(LocalPlayer(), "char_id", "") )
	if not char_id then return end
	
	self.m_tblPhotos = {}
	local files, _ = file.Find( "taloslife/phone/photos/".. char_id.. "/*", "DATA" )
	for k, v in pairs( files ) do
		table.insert( self.m_tblPhotos, { Name = v, Path = "taloslife/phone/photos/".. char_id.. "/" } )
	end
end

function Panel:Rebuild()
	self:BuildPhotos()

	for k, v in pairs( self.m_tblSelect ) do
		if table.HasValue( self.m_tblCards, v ) then
			self.m_tblSelect[k] = nil
		end	
	end

	for k, v in pairs( self.m_tblCards ) do
		if ValidPanel( v ) then v:Remove() end
	end

	self.m_tblCards = {}

	for k, v in pairs( self.m_tblPhotos ) do
		local card = vgui.Create( "SRPPhone_PhotoCard", self.m_pnlPhotoContainer )
		card:SetPhoto( v.Name, v.Path )

		table.insert( self.m_tblCards, card )
		table.insert( self.m_tblSelect, card )
		self.m_pnlPhotoContainer:AddItem( card )
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
	self.m_pnlPhotoContainer:ScrollToChild( self:GetCurrentSelection() )
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

	self.m_pnlPhotoContainer:SetPos( 0, self.m_pnlToolbar:GetTall() )
	self.m_pnlPhotoContainer:SetSize( intW, intH -self.m_pnlToolbar:GetTall() )

	for k, v in pairs( self.m_tblCards ) do
		v:DockMargin( 0, 0, 0, 5 )
		v:SetTall( 32 )
		v:Dock( TOP )
	end
end
vgui.Register( "SRPPhone_App_Gallery", Panel, "EditablePanel" )