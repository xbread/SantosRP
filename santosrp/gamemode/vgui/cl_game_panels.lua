--[[
	Name: cl_game_panels.lua
	For: TalosLife
	By: TalosLife
]]--

--[[---------------------------------------------------------
   Name: SRPFramePanel
-----------------------------------------------------------]]
local MAT_BLUR = Material( "pp/blurscreen.png", "noclamp" )

local Panel = {}
function Panel:Init()
	self.m_matBlur = MAT_BLUR
end

function Panel:Paint( intW, intH )
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilWriteMask( 1 )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawRect( 0, 0, intW, intH )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		surface.SetMaterial( self.m_matBlur )
		surface.SetDrawColor( 255, 255, 255, 255 )

		for i = 0, 1, 0.33 do
			self.m_matBlur:SetFloat( '$blur', 5 *i )
			self.m_matBlur:Recompute()
			render.UpdateScreenEffectTexture()

			local x, y = self:GetPos()
			surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
		end
	render.SetStencilEnable( false )

	surface.SetDrawColor( 35, 35, 35, 120 )
	surface.DrawRect( 0, 0, intW, intH )
end

vgui.Register( "SRP_FramePanel", Panel, "EditablePanel" )

--[[---------------------------------------------------------
   Name: SRPFrame
-----------------------------------------------------------]]
local MAT_BLUR = Material( "pp/blurscreen.png", "noclamp" )

local Panel = {}
function Panel:Init()
	self.m_matBlur = MAT_BLUR
	self.m_colBG = Color( 35, 35, 35, 120 )
end

function Panel:SetBackgroundColor( col )
	self.m_colBG = col
end

function Panel:Paint( intW, intH )
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilWriteMask( 1 )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawRect( 0, 0, intW, intH )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		surface.SetMaterial( self.m_matBlur )
		surface.SetDrawColor( 255, 255, 255, 255 )

		for i = 0, 1, 0.33 do
			self.m_matBlur:SetFloat( '$blur', 5 *i )
			self.m_matBlur:Recompute()
			render.UpdateScreenEffectTexture()

			local x, y = self:GetPos()
			surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
		end
	render.SetStencilEnable( false )

	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, 24 )

	surface.SetDrawColor( self.m_colBG )
	surface.DrawRect( 0, 24, intW, intH -24 )
end

vgui.Register( "SRP_Frame", Panel, "DFrame" )

--[[---------------------------------------------------------
   Name: SRPButton
-----------------------------------------------------------]]
local PANEL = {}
function PANEL:Init()
	self.m_intAlpha = 255
	self.m_colWhite = Color( 255, 255, 255, 255 )
	self.m_colWhiteT = Color( 255, 255, 255, 100 )
	self.m_colGrey = Color( 100, 100, 100, 255 )
end

function PANEL:SetAlpha( int )
	self.m_intAlpha = int
end

function PANEL:SetAlphaOverride( int )
	self.m_intAlphaOverride = int
end

function PANEL:SetTextColorOverride( col )
	self.m_colOverride = col
end

function PANEL:SetTextColorMouseOver( col )
	self.m_colMouseOverOverride = col
end

function PANEL:SetTexture( strTex, intW, intH, intX, intY )
	self.m_matIcon = Material( strTex )
	self.m_intTexW = intW
	self.m_intTexH = intH
	self.m_intTexX = intX or 0
	self.m_intTexY = intY or 0
end

function PANEL:SetColor( col )
	self.m_colColor = col
end

function PANEL:SetMouseOverColor( col )
	self.m_colMouseOver = col
end

function PANEL:SetDisabledColor( col )
	self.m_colDisabled = col
end

function PANEL:SetDepressedColor( col )
	self.m_colDepressed = col
end

function PANEL:Paint( intW, intH )
	if self:GetDisabled() then
		if not self.m_colDisabled then
			surface.SetDrawColor( 40, 40, 40, self.m_intAlphaOverride or self.m_intAlpha *0.9 )
		else
			surface.SetDrawColor( self.m_colDisabled.r, self.m_colDisabled.g, self.m_colDisabled.b, self.m_colDisabled.a )
		end

		self:SetTextColor( self.m_colOverride or self.m_colGrey )
	elseif self.Depressed then
		if not self.m_colDepressed then
			surface.SetDrawColor( 55, 55, 55, self.m_intAlphaOverride or self.m_intAlpha *0.8 )
		else
			surface.SetDrawColor( self.m_colDepressed.r, self.m_colDepressed.g, self.m_colDepressed.b, self.m_colDepressed.a )
		end
		
		self:SetTextColor( self.m_colOverride or self.m_colWhite )
	elseif self.Hovered then
		if not self.m_colMouseOver then
			surface.SetDrawColor( 100, 100, 100, self.m_intAlphaOverride or self.m_intAlpha *0.7 )
		else
			surface.SetDrawColor( self.m_colMouseOver.r, self.m_colMouseOver.g, self.m_colMouseOver.b, self.m_colMouseOver.a )
		end

		self:SetTextColor( self.m_colMouseOverOverride or self.m_colWhite )
	elseif self.m_bSelected then
		if not self.m_colSelected then
			surface.SetDrawColor( 100, 100, 100, self.m_intAlphaOverride or self.m_intAlpha *0.7 )
		else
			surface.SetDrawColor( self.m_colSelected.r, self.m_colSelected.g, self.m_colSelected.b, self.m_colSelected.a )
		end

		self:SetTextColor( self.m_colMouseOverOverride or self.m_colWhite )
	else
		if not self.m_colColor then
			surface.SetDrawColor( 80, 80, 80, self.m_intAlphaOverride or self.m_intAlpha *0.6 )
		else
			surface.SetDrawColor( self.m_colColor.r, self.m_colColor.g, self.m_colColor.b, self.m_colColor.a )
		end

		self:SetTextColor( self.m_colOverride or self.m_colWhiteT )
	end

	surface.DrawRect( 0, 0, intW, intH )

	if self.m_matIcon then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.m_matIcon )
		surface.DrawTexturedRect( self.m_intTexX, self.m_intTexY, self.m_intTexW or intW, self.m_intTexH or intH )
	end
end
vgui.Register( "SRP_Button", PANEL, "DButton" )

--[[---------------------------------------------------------
   Name: SRPTab
-----------------------------------------------------------]]
local PANEL = {}
AccessorFunc( PANEL, "m_pPropertySheet", "PropertySheet" )
AccessorFunc( PANEL, "m_pPanel", "Panel" )

function PANEL:Init()
	self:SetMouseInputEnabled( true )
	self:SetContentAlignment( 7 )
	self:SetTextInset( 0, 7 )
end

function PANEL:Setup( label, pPropertySheet, pPanel, strMaterial )
	self:SetText( label )
	self:SetPropertySheet( pPropertySheet )
	self:SetPanel( pPanel )
	
	if strMaterial then
		self.Image = vgui.Create( "DImage", self )
		self.Image:SetImage( strMaterial )
		self.Image:SizeToContents()
		self:InvalidateLayout()
	end
end

function PANEL:IsActive()
	return self:GetPropertySheet():GetActiveTab() == self
end

function PANEL:DoClick()
	self:GetPropertySheet():SetActiveTab( self )
end

function PANEL:PerformLayout()
	self:ApplySchemeSettings()
	if not self.Image then return end
		
	self.Image:SetPos( 10, 5 )
	if not self:IsActive() then
		self.Image:SetImageColor( Color(255, 255, 255, 150) )
	else
		self.Image:SetImageColor( Color(255, 255, 255, 255) )
	end
end

function PANEL:Paint( intW, intH )
	if self:IsActive() then
		surface.SetDrawColor( 125, 125, 125, 65 )
		surface.DrawRect( 0, 0, intW, intH )
	end
end

function PANEL:UpdateColours( skin )
	local Active = self:GetPropertySheet():GetActiveTab() == self
	if Active then
		if self:GetDisabled() then return self:SetTextStyleColor( skin.Colours.Tab.Active.Disabled ) end
		if self:IsDown() then return self:SetTextStyleColor( skin.Colours.Tab.Active.Down ) end
		if self.Hovered then return self:SetTextStyleColor( skin.Colours.Tab.Active.Hover ) end
		return self:SetTextStyleColor( skin.Colours.Tab.Active.Normal )
	end

	if self:GetDisabled() then return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Disabled ) end
	if self:IsDown() then return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Down ) end
	if self.Hovered then return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Hover ) end
	return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Normal )
end

function PANEL:ApplySchemeSettings()
	local ExtraInset = 15
	if self.Image then
		ExtraInset = ExtraInset + self.Image:GetWide()
	end
	
	self:SetTextInset( ExtraInset, 7 )
	local w, h = self:GetContentSize()
	h = 20
	self:SetSize( w + 20, 28 )
	
	DLabel.ApplySchemeSettings( self )
end

function PANEL:DragHoverClick( HoverTime )
	self:DoClick()
end
vgui.Register( "SRP_Tab", PANEL, "DButton" )

--[[---------------------------------------------------------
   Name: SRPPropertySheet
-----------------------------------------------------------]]
local PANEL = {}
Derma_Hook( PANEL, "Paint", "Paint", "PropertySheet" )
AccessorFunc( PANEL, "m_pActiveTab", "ActiveTab" )
AccessorFunc( PANEL, "m_iPadding", "Padding" )
AccessorFunc( PANEL, "m_fFadeTime", "FadeTime" )
AccessorFunc( PANEL, "m_bShowIcons", "ShowIcons" )

function PANEL:Init()
	self:SetShowIcons( true )
	self.tabScroller = vgui.Create( "DHorizontalScroller", self )
	self.tabScroller:SetOverlap( 5 )
	self.tabScroller:Dock( TOP )
	self:SetFadeTime( 0.1 )
	self:SetPadding( 8 )
		
	self.animFade = Derma_Anim( "Fade", self, self.CrossFade )
	self.Items = {}
end

function PANEL:AddSheet( label, panel, material, NoStretchX, NoStretchY, Tooltip )
	if not IsValid( panel ) then return end

	local Sheet = {}
	Sheet.Name = label
	Sheet.Tab = vgui.Create( "SRP_Tab", self )
	Sheet.Tab:SetTooltip( Tooltip )
	Sheet.Tab:Setup( label, self, panel, material )
	
	Sheet.Panel = panel
	Sheet.Panel.NoStretchX = NoStretchX
	Sheet.Panel.NoStretchY = NoStretchY
	Sheet.Panel:SetPos( self:GetPadding(), 28 +self:GetPadding() )
	Sheet.Panel:SetVisible( false )
	
	panel:SetParent( self )
	table.insert( self.Items, Sheet )
	
	if not self:GetActiveTab() then
		self:SetActiveTab( Sheet.Tab )
		Sheet.Panel:SetVisible( true )
	end
	
	self.tabScroller:AddPanel( Sheet.Tab )
	
	return Sheet
end

function PANEL:SetActiveTab( active )
	if self.m_pActiveTab == active then return end
	if self.m_pActiveTab then
		if self:GetFadeTime() > 0 then
			self.animFade:Start( self:GetFadeTime(), { OldTab = self.m_pActiveTab, NewTab = active } )
		else
			self.m_pActiveTab:GetPanel():SetVisible( false )
		end
	end

	self.m_pActiveTab = active
	self:InvalidateLayout()
end

function PANEL:Think()
	self.animFade:Run()
end

function PANEL:CrossFade( anim, delta, data )
	local old = ValidPanel( data.OldTab ) and data.OldTab:GetPanel() or nil
	local new = data.NewTab:GetPanel()
	
	if anim.Finished then
		new:SetAlpha( 255 )
		new:SetZPos( 0 )

		if old then
			old:SetVisible( false )
			old:SetZPos( 0 )
		end
		
		return
	end
	
	if anim.Started then
		new:SetZPos( 1 )
		new:SetAlpha( 0 )

		if old then
			old:SetAlpha( 255 )
			old:SetZPos( 0 )
		end
	end
	
	if old then
		old:SetVisible( true )
	end
	
	new:SetVisible( true )
	new:SetAlpha( 255 * delta )
end

function PANEL:PerformLayout()
	local ActiveTab = self:GetActiveTab()
	local Padding = self:GetPadding()
	
	if not ActiveTab then return end
	ActiveTab:InvalidateLayout( true )
	self.tabScroller:SetTall( ActiveTab:GetTall() )
	
	local ActivePanel = ActiveTab:GetPanel()
	for k, v in pairs( self.Items ) do
		if v.Tab:GetPanel() == ActivePanel then
			v.Tab:GetPanel():SetVisible( true )
			v.Tab:SetZPos( 100 )
		else
			v.Tab:GetPanel():SetVisible( false )	
			v.Tab:SetZPos( 1 )
		end
	
		v.Tab:ApplySchemeSettings()
	end
	
	if not ActivePanel.NoStretchX then 
		ActivePanel:SetWide( self:GetWide() -Padding *2 ) 
	else
		ActivePanel:CenterHorizontal()
	end
	
	if not ActivePanel.NoStretchY then 
		local _, y = ActivePanel:GetPos()
		ActivePanel:SetTall( self:GetTall() -y -Padding )
	else
		ActivePanel:CenterVertical()
	end
	
	ActivePanel:InvalidateLayout()
	-- Give the animation a chance
	self.animFade:Run()
end

function PANEL:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 100 )
	surface.DrawRect( 0, 0, intW, 28 )
end

function PANEL:SizeToContentWidth()
	local wide = 0

	for k, v in pairs( self.Items ) do
		if v.Panel then
			v.Panel:InvalidateLayout( true )
			wide = math.max( wide, v.Panel:GetWide()  +self.m_iPadding *2 )
		end
	end
	
	self:SetWide( wide )
end

function PANEL:SwitchToName( name )
	for k, v in pairs( self.Items ) do
		if v.Name == name then
			v.Tab:DoClick()
			return true
		end
	end
	
	return false
end

function PANEL:SetupCloseButton( func )
	self.CloseButton = self.tabScroller:Add( "DImageButton" )
	self.CloseButton:SetImage( "icon16/circlecross.png" )
	self.CloseButton:SetColor( Color( 10, 10, 10, 200 ) )
	self.CloseButton:DockMargin( 0, 0, 0, 8 )
	self.CloseButton:SetWide( 16 )
	self.CloseButton:Dock( RIGHT )
	self.CloseButton.DoClick = function() func() end
end

function PANEL:CloseTab( tab, bRemovePanelToo )
	for k, v in pairs( self.Items ) do
		if v.Tab ~= tab then continue end
		table.remove( self.Items, k )
	end
	
	for k, v in pairs( self.tabScroller.Panels ) do
		if v ~= tab then continue end
		table.remove( self.tabScroller.Panels, k )
	end
	
	self.tabScroller:InvalidateLayout( true )
	 
	if tab == self:GetActiveTab() and #self.Items > 0 then
		self.m_pActiveTab = self.Items[#self.Items].Tab
	end
	
	local pnl = tab:GetPanel()
	if ( bRemovePanelToo ) then
		pnl:Remove()
	end

	tab:Remove()
	self:InvalidateLayout( true )
	
	return pnl
end
vgui.Register( "SRP_PropertySheet", PANEL, "Panel" )


--[[---------------------------------------------------------
   Name: SRPScrollBar
-----------------------------------------------------------]]
local PANEL = {}
AccessorFunc( PANEL, "Padding", "Padding" )
AccessorFunc( PANEL, "pnlCanvas", "Canvas" )
function PANEL:Init()
	self.pnlCanvas 	= vgui.Create( "Panel", self )
	self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.PerformLayout = function( pnl )
		self:PerformLayout()
		self:InvalidateParent()
	end
	
	-- Create the scroll bar
	self.VBar = vgui.Create( "DVScrollBar", self )
	self.VBar:Dock( RIGHT )

	self.VBar.Paint = function() end

	local paintBtn = function( p, intW, intH )
		if p.Depressed then
			surface.SetDrawColor( 55, 55, 55, 200 )
		elseif p.Hovered then
			surface.SetDrawColor( 100, 100, 100, 150 )
		else
			surface.SetDrawColor( 80, 80, 80, 150 )
		end

		surface.DrawRect( 0, 0, intW, intH )
	end

	self.VBar.btnUp.Paint = paintBtn
	self.VBar.btnDown.Paint = paintBtn
	
	self.VBar.btnGrip.Paint = function( p, intW, intH )
		if p.Depressed then
			surface.SetDrawColor( 70, 70, 70, 200 )
		elseif p.Hovered then
			surface.SetDrawColor( 130, 130, 130, 175 )
		else
			surface.SetDrawColor( 120, 120, 120, 175 )
		end

		surface.DrawRect( 0, 0, intW, intH )
	end

	self:SetPadding( 0 )
	self:SetMouseInputEnabled( true )
	
	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:SetPaintBackground( false )
end

function PANEL:AddItem( pnl )
	pnl:SetParent( self:GetCanvas() )
end

function PANEL:OnChildAdded( child )
	self:AddItem( child )
end

function PANEL:SizeToContents()
	self:SetSize( self.pnlCanvas:GetSize() )
end

function PANEL:GetVBar()
	return self.VBar
end

function PANEL:GetCanvas()
	return self.pnlCanvas
end

function PANEL:InnerWidth()
	return self:GetCanvas():GetWide()
end

function PANEL:Rebuild()
	self:GetCanvas():SizeToChildren( false, true )

	-- Although this behaviour isn't exactly implied, center vertically too
	if self.m_bNoSizing and self:GetCanvas():GetTall() < self:GetTall() then
		self:GetCanvas():SetPos( 0, (self:GetTall() -self:GetCanvas():GetTall()) *0.5 )
	end
end

function PANEL:OnMouseWheeled( dlta )
	return self.VBar:OnMouseWheeled( dlta )
end

function PANEL:OnVScroll( iOffset )
	self.pnlCanvas:SetPos( 0, iOffset )
end

function PANEL:ScrollToChild( panel )
	self:PerformLayout()
	
	local x, y = self.pnlCanvas:GetChildPosition( panel )
	local w, h = panel:GetSize()
	y = y +h *0.5
	y = y -self:GetTall() *0.5

	self.VBar:AnimateTo( y, 0.5, 0, 0.5 )
end

function PANEL:PerformLayout()
	local Wide = self:GetWide()
	local YPos = 0
	
	self:Rebuild()
	self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
	YPos = self.VBar:GetOffset()
		
	if self.VBar.Enabled then Wide = Wide -self.VBar:GetWide() end
	self.pnlCanvas:SetPos( 0, YPos )
	self.pnlCanvas:SetWide( Wide )
	self:Rebuild()
end

function PANEL:Clear()
	return self.pnlCanvas:Clear()
end
vgui.Register( "SRP_ScrollPanel", PANEL, "DPanel" )


--[[---------------------------------------------------------
   Name: SRP_CategoryHeader
-----------------------------------------------------------]]
local PANEL = {
	Init = function( self )
		self:SetContentAlignment( 4 )
		self:SetTextInset( 5, 0 )
		self:SetFont( "DermaDefaultBold" )
	end,
	
	DoClick = function( self )
		self:GetParent():Toggle()
	end,
	
	UpdateColours = function( self, skin )
		if not self:GetParent():GetExpanded() then
			self:SetExpensiveShadow( 0, Color(0, 0, 0, 200) )	
			return self:SetTextStyleColor( skin.Colours.Category.Header_Closed ) 
		end
		
		self:SetExpensiveShadow( 1, Color(0, 0, 0, 100) )
		return self:SetTextStyleColor( skin.Colours.Category.Header )
	end,
}
vgui.Register( "SRP_CategoryHeader", PANEL, "SRP_Button" )


--[[---------------------------------------------------------
   Name: SRP_CollapsibleCategory
-----------------------------------------------------------]]
local PANEL = {}
AccessorFunc( PANEL, "m_bSizeExpanded", 		"Expanded", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_iContentHeight",	 	"StartHeight" )
AccessorFunc( PANEL, "m_fAnimTime", 			"AnimTime" )
AccessorFunc( PANEL, "m_bDrawBackground", 		"DrawBackground", 	FORCE_BOOL )
AccessorFunc( PANEL, "m_iPadding", 				"Padding" )
AccessorFunc( PANEL, "m_pList", 				"List" )

function PANEL:Init()
	self.Header = vgui.Create( "SRP_CategoryHeader", self )
	self.Header:Dock( TOP )
	self.Header:SetSize( 20, 20 )

	self:SetSize( 16, 16 )
	self:SetExpanded( true )
	self:SetMouseInputEnabled( true )

	self:SetAnimTime( 0.2 )
	self.animSlide = Derma_Anim( "Anim", self, self.AnimSlide )

	self:SetDrawBackground( true )
	self:DockMargin( 0, 0, 0, 2 )
	self:DockPadding( 0, 0, 0, 5 )
end

function PANEL:Add( strName )
	local button = vgui.Create( "SRP_Button", self )
	button.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "CategoryButton", panel, w, h ) end
	button.UpdateColours = function( button, skin )
		if button.AltLine then
			if button.Depressed or button.m_bSelected then
				return button:SetTextStyleColor( skin.Colours.Category.LineAlt.Text_Selected )
			end

			if hovered then
				return button:SetTextStyleColor( skin.Colours.Category.LineAlt.Text_Hover )
			end

			return button:SetTextStyleColor( skin.Colours.Category.LineAlt.Text )	
		end

		if button.Depressed or button.m_bSelected then
			return button:SetTextStyleColor( skin.Colours.Category.Line.Text_Selected )
		end

		if hovered then return
			button:SetTextStyleColor( skin.Colours.Category.Line.Text_Hover )
		end

		return button:SetTextStyleColor( skin.Colours.Category.Line.Text )
	end

	button:SetHeight( 17 )
	button:SetTextInset( 4, 0 )

	button:SetContentAlignment( 4 )
	button:DockMargin( 1, 0, 1, 0 )
	button.DoClickInternal =  function()
		if self:GetList() then
			self:GetList():UnselectAll()
		else
			self:UnselectAll()
		end

		button:SetSelected( true )
	end

	button:Dock( TOP )
	button:SetText( strName )

	self:InvalidateLayout( true )
	self:UpdateAltLines()

	return button 
end

function PANEL:UnselectAll()
	local children = self:GetChildren()
	for k, v in pairs( children ) do
		if v.SetSelected then
			v:SetSelected( false )
		end
	end
end

function PANEL:UpdateAltLines()
	local children = self:GetChildren()
	for k, v in pairs( children ) do
		v.AltLine = k % 2 ~= 1		
	end
end

function PANEL:Think()
	self.animSlide:Run()
end

function PANEL:SetLabel( strLabel )
	self.Header:SetText( strLabel )
end

function PANEL:Paint( w, h )
	return false
end

function PANEL:SetContents( pContents )
	self.Contents = pContents
	self.Contents:SetParent( self )
	self.Contents:Dock( FILL )
	self:InvalidateLayout()
end

function PANEL:Toggle()
	self:SetExpanded( not self:GetExpanded() )

	if not self:GetExpanded() then
		self.OldHeight = self:GetTall()
	end

	self.animSlide:Start( self:GetAnimTime(), { From = self:GetTall() } )
	
	self:InvalidateLayout( true )
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()
	
	local cookie = '1'
	if not self:GetExpanded() then cookie = '0' end
	self:SetCookie( "Open", cookie )

	self:OnToggle( self:GetExpanded( ) )
end

function PANEL:OnToggle( expanded )
end

function PANEL:DoExpansion( b )
	if self.m_bSizeExpanded == b then return end
	self:Toggle()
end

function PANEL:PerformLayout()
	local Padding = self:GetPadding() or 0

	if self.Contents then
		if self:GetExpanded() then
			self.Contents:InvalidateLayout( true )
			self.Contents:SetVisible( true )
		else
			self.Contents:SetVisible( false )
		end
	end
	
	if self:GetExpanded() then
		self:SizeToChildren( false, true )
	else
		self:SetTall( self.Header:GetTall() )
	end	
	
	-- Make sure the color of header text is set
	self.Header:ApplySchemeSettings()
	self.animSlide:Run()
	self:UpdateAltLines()
end

function PANEL:OnMousePressed( mcode )
	if not self:GetParent().OnMousePressed then return end
	return self:GetParent():OnMousePressed( mcode )
end

function PANEL:AnimSlide( anim, delta, data )
	self:InvalidateLayout()
	self:InvalidateParent()
	
	if anim.Started then
		if self:GetExpanded() then
			data.To = self.OldHeight or self:GetTall()
		else
			data.To = self:GetTall()
		end
	end
	
	if anim.Finished then return end

	if self.Contents then self.Contents:SetVisible( true ) end
	self:SetTall( Lerp(delta, data.From, data.To or self:GetTall()) )
end

function PANEL:LoadCookies()
	local Open = self:GetCookieNumber( "Open", 1 ) == 1
	self:SetExpanded( Open )
	self:InvalidateLayout( true )
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()
end
vgui.Register( "SRP_CollapsibleCategory", PANEL, "EditablePanel" )


--[[---------------------------------------------------------
   Name: SRP_ListView_Column
-----------------------------------------------------------]]
surface.CreateFont( "SRP_ListHeaderFont", {size = 14, weight = 600, font = "DermaLarge"} )

local PANEL = {}
AccessorFunc( PANEL, "m_iMinWidth", 			"MinWidth" )
AccessorFunc( PANEL, "m_iMaxWidth", 			"MaxWidth" )
AccessorFunc( PANEL, "m_iTextAlign", 			"TextAlign" )
AccessorFunc( PANEL, "m_bFixedWidth", 			"FixedWidth" )
AccessorFunc( PANEL, "m_bDesc", 				"Descending" )
AccessorFunc( PANEL, "m_iColumnID", 			"ColumnID" )
Derma_Hook( PANEL, 	"PerformLayout", "Layout", "ListViewColumn" )

function PANEL:Init()
	self.Header = vgui.Create( "SRP_Button", self )
	self.Header:SetColor( Color(10, 10, 10, 150) )
	self.Header:SetMouseOverColor( Color(40, 40, 40, 150) )
	self.Header:SetDepressedColor( Color(0, 0, 0, 150) )
	self.Header:SetFont( "SRP_ListHeaderFont" )

	self.Header.DoClick = function() self:DoClick() end
	self.Header.DoRightClick = function() self:DoRightClick() end
	self.DraggerBar = vgui.Create( "DListView_DraggerBar", self )
	
	self:SetMinWidth( 10 )
	self:SetMaxWidth( 1920 *10 )
end

function PANEL:SetFixedWidth( i )
	self:SetMinWidth( i )
	self:SetMaxWidth( i )
end

function PANEL:DoClick()
	self:GetParent():SortByColumn( self:GetColumnID(), self:GetDescending() )
	self:SetDescending( not self:GetDescending() )
end

function PANEL:DoRightClick()
end

function PANEL:SetName( strName )
	self.Header:SetText( strName )
end

function PANEL:Paint( intW, intH )
end

function PANEL:PerformLayout()
	if self.m_iTextAlign then 
		self.Header:SetContentAlignment( self.m_iTextAlign ) 
	end
		
	self.Header:SetPos( 0, 0 )
	self.Header:SetSize( self:GetWide(), self:GetParent():GetHeaderHeight() )
	
	self.DraggerBar:SetWide( 4 )
	self.DraggerBar:StretchToParent( nil, 0, nil, 0 )
	self.DraggerBar:AlignRight()
end

function PANEL:ResizeColumn( iSize )
	self:GetParent():OnRequestResize( self, iSize )
end

function PANEL:SetWidth( iSize )
	iSize = math.Clamp( iSize, self.m_iMinWidth, self.m_iMaxWidth )
	-- If the column changes size we need to lay the data out too
	if iSize ~= self:GetWide() then
		self:GetParent():SetDirty( true )
	end

	self:SetWide( iSize )
	return iSize
end
vgui.Register( "SRP_ListView_Column", PANEL, "EditablePanel" )


--[[---------------------------------------------------------
   Name: SRP_ListView
-----------------------------------------------------------]]
local PANEL = {}
AccessorFunc( PANEL, "m_bDirty",		"Dirty", FORCE_BOOL )
AccessorFunc( PANEL, "m_bSortable",		"Sortable", FORCE_BOOL )
AccessorFunc( PANEL, "m_iHeaderHeight",	"HeaderHeight" )
AccessorFunc( PANEL, "m_iDataHeight",	"DataHeight" )
AccessorFunc( PANEL, "m_bMultiSelect",	"MultiSelect" )
AccessorFunc( PANEL, "m_bHideHeaders",	"HideHeaders" )

function PANEL:Init()
	self:SetSortable( true )
	self:SetMouseInputEnabled( true )
	self:SetMultiSelect( true )
	self:SetHideHeaders( false )

	self:SetHeaderHeight( 16 )
	self:SetDataHeight( 17 )

	self.Columns = {}
	self.Lines = {}
	self.Sorted = {}

	self:SetDirty( true )

	self.pnlCanvas = vgui.Create( "Panel", self )

	self.VBar = vgui.Create( "DVScrollBar", self )
	self.VBar:SetZPos( 20 )
end

function PANEL:DisableScrollbar()
	if IsValid( self.VBar ) then
		self.VBar:Remove()
	end
	self.VBar = nil
end

function PANEL:GetLines()
	return self.Lines
end

function PANEL:GetInnerTall()
	return self:GetCanvas():GetTall()
end

function PANEL:GetCanvas()
	return self.pnlCanvas
end

function PANEL:AddColumn( strName, iPosition )
	local pColumn = nil
	if self.m_bSortable then
		pColumn = vgui.Create( "SRP_ListView_Column", self )
	else
		pColumn = vgui.Create( "DListView_ColumnPlain", self )
	end

	pColumn:SetName( strName )
	pColumn:SetZPos( 10 )
	if iPosition then
		table.insert( self.Columns, iPosition, pColumn )

		for i = 1, #self.Columns do
			self.Columns[i]:SetColumnID( i )
		end
	else
		local ID = table.insert( self.Columns, pColumn )
		pColumn:SetColumnID( ID )
	end

	self:InvalidateLayout()
	return pColumn
end

function PANEL:RemoveLine( LineID )
	local Line = self:GetLine( LineID )
	local SelectedID = self:GetSortedID( LineID )
	self.Lines[LineID] = nil
	table.remove( self.Sorted, SelectedID )
	self:SetDirty( true )
	self:InvalidateLayout()
	Line:Remove()
end

function PANEL:ColumnWidth( i )
	local ctrl = self.Columns[i]
	if not ctrl then return 0 end
	return ctrl:GetWide()
end

function PANEL:FixColumnsLayout()
	local NumColumns = #self.Columns
	if NumColumns == 0 then return end

	local AllWidth = 0
	for k, Column in pairs( self.Columns ) do
		AllWidth = AllWidth +Column:GetWide()
	end
	
	local ChangeRequired = self.pnlCanvas:GetWide() -AllWidth
	local ChangePerColumn = math.floor( ChangeRequired /NumColumns )
	local Remainder = ChangeRequired -(ChangePerColumn *NumColumns)
	
	for k, Column in pairs( self.Columns ) do
		local TargetWidth = Column:GetWide() +ChangePerColumn
		Remainder = Remainder +(TargetWidth -Column:SetWidth(TargetWidth))
	end
	
	-- If there's a remainder, try to palm it off on the other panels, equally
	while Remainder ~= 0 do
		local PerPanel = math.floor( Remainder /NumColumns )
		
		for k, Column in pairs( self.Columns ) do
			Remainder = math.Approach( Remainder, 0, PerPanel )
			
			local TargetWidth = Column:GetWide() +PerPanel
			Remainder = Remainder +(TargetWidth -Column:SetWidth(TargetWidth))
			
			if Remainder == 0 then break end
		end
		
		Remainder = math.Approach( Remainder, 0, 1 )
	end

	-- Set the positions of the resized columns
	local x = 0
	for k, Column in pairs( self.Columns ) do
		Column.x = x
		x = x +Column:GetWide()
		
		Column:SetTall( self:GetHeaderHeight() )
		Column:SetVisible( not self:GetHideHeaders() )
	end
end

function PANEL:PerformLayout()
	-- Do Scrollbar
	local Wide = self:GetWide()
	local YPos = 0
	
	if IsValid( self.VBar ) then
		self.VBar:SetPos( self:GetWide() -16, 0 )
		self.VBar:SetSize( 16, self:GetTall() )
		self.VBar:SetUp( self.VBar:GetTall() -self:GetHeaderHeight(), self.pnlCanvas:GetTall() )
		YPos = self.VBar:GetOffset()

		if self.VBar.Enabled then Wide = Wide -16 end
	end

	if self.m_bHideHeaders then
		self.pnlCanvas:SetPos( 0, YPos )
	else
		self.pnlCanvas:SetPos( 0, YPos +self:GetHeaderHeight() )
	end

	self.pnlCanvas:SetSize( Wide, self.pnlCanvas:GetTall() )
	self:FixColumnsLayout()

	-- If the data is dirty, re-layout
	if self:GetDirty( true ) then
		self:SetDirty( false )
		local y = self:DataLayout()
		self.pnlCanvas:SetTall( y )
		
		-- Layout again, since stuff has changed..
		self:InvalidateLayout( true )
	end
end

function PANEL:Paint( intW, intH )
	local x, y = self.pnlCanvas:GetPos()

	surface.SetDrawColor( 35, 35, 35, 100 )
	surface.DrawRect( 0, y, intW, intH )
end

function PANEL:OnScrollbarAppear()
	self:SetDirty( true )
	self:InvalidateLayout()
end

function PANEL:OnRequestResize( SizingColumn, iSize )
	-- Find the column to the right of this one
	local Passed = false
	local RightColumn = nil
	for k, Column in ipairs( self.Columns ) do
		if Passed then
			RightColumn = Column
			break
		end
		if SizingColumn == Column then Passed = true end
	end
	
	-- Alter the size of the column on the right too, slightly
	if RightColumn then
		local SizeChange = SizingColumn:GetWide() -iSize
		RightColumn:SetWide( RightColumn:GetWide() +SizeChange )
	end
	
	SizingColumn:SetWide( iSize )
	self:SetDirty( true )
	-- Invalidating will munge all the columns about and make it right
	self:InvalidateLayout()
end

function PANEL:DataLayout()
	local y = 0
	local h = self.m_iDataHeight
	
	for k, Line in ipairs( self.Sorted ) do
		Line:SetPos( 1, y )
		Line:SetSize( self:GetWide() -2, h )
		Line:DataLayout( self ) 
		Line:SetAltLine( k % 2 == 1 )
		
		y = y + Line:GetTall()
	end
	
	return y
end

function PANEL:AddLine( ... )
	self:SetDirty( true )
	self:InvalidateLayout()

	local Line = vgui.Create( "DListView_Line", self.pnlCanvas )
	local ID = table.insert( self.Lines, Line )
	Line:SetListView( self ) 
	Line:SetID( ID )

	-- This assures that there will be an entry for every column
	for k, v in pairs( self.Columns ) do
		Line:SetColumnText( k, "" )
	end

	for k, v in pairs( {...} ) do
		local pnl = Line:SetColumnText( k, v )
		pnl.UpdateColours = function() end
		pnl:SetTextColor( Color(255, 255, 255, 255) )
	end

	-- Make appear at the bottom of the sorted list
	local SortID = table.insert( self.Sorted, Line )
	if SortID % 2 == 1 then
		Line:SetAltLine( true )
	end

	return Line
end

function PANEL:OnMouseWheeled( dlta )
	if not IsValid( self.VBar ) then return end
	return self.VBar:OnMouseWheeled( dlta )
end

function PANEL:ClearSelection( dlta )
	for k, Line in pairs( self.Lines ) do
		Line:SetSelected( false )
	end
end

function PANEL:GetSelectedLine()
	for k, Line in pairs( self.Lines ) do
		if Line:IsSelected() then return k end
	end
end

function PANEL:GetLine( id )
	return self.Lines[id]
end

function PANEL:GetSortedID( line )
	for k, v in pairs( self.Sorted ) do
		if v:GetID() == line then return k end
	end
end

function PANEL:OnClickLine( Line, bClear )
	local bMultiSelect = self.m_bMultiSelect
	if not bMultiSelect and not bClear then return end

	-- Control, multi select
	if bMultiSelect and input.IsKeyDown( KEY_LCONTROL ) then
		bClear = false
	end

	-- Shift block select
	if bMultiSelect and input.IsKeyDown( KEY_LSHIFT ) then
		local Selected = self:GetSortedID( self:GetSelectedLine() )
		if Selected then
			if bClear then self:ClearSelection() end
			local LineID = self:GetSortedID( Line:GetID() )
		
			local First = math.min( Selected, LineID )
			local Last = math.max( Selected, LineID )
			for id = First, Last do
				local line = self.Sorted[id]
				line:SetSelected( true )
			end
		
			return
		end
	end

	-- Check for double click
	if Line:IsSelected() and Line.m_fClickTime and (not bMultiSelect or bClear) then 
		local fTimeDistance = SysTime() -Line.m_fClickTime

		if fTimeDistance < 0.3 then
			self:DoDoubleClick( Line:GetID(), Line )
			return
		end
	end

	-- If it's a new mouse click, or this isn't 
	--  multiselect we clear the selection
	if not bMultiSelect or bClear then
		self:ClearSelection()
	end

	if Line:IsSelected() then return end
	Line:SetSelected( true )
	Line.m_fClickTime = SysTime()
	self:OnRowSelected( Line:GetID(), Line )
end

function PANEL:SortByColumns( c1, d1, c2, d2, c3, d3, c4, d4 )
	table.Copy( self.Sorted, self.Lines )
	
	table.sort( self.Sorted, function( a, b ) 
		if not IsValid( a ) then return true end
		if not IsValid( b ) then return false end
		
		if c1 and a:GetColumnText( c1 ) ~= b:GetColumnText( c1 ) then
			if d1 then a, b = b, a end
			return a:GetColumnText( c1 ) < b:GetColumnText( c1 )
		end
		
		if c2 and a:GetColumnText( c2 ) ~= b:GetColumnText( c2 ) then
			if d2 then a, b = b, a end
			return a:GetColumnText( c2 ) < b:GetColumnText( c2 )
		end
			
		if c3 and a:GetColumnText( c3 ) ~= b:GetColumnText( c3 ) then
			if d3 then a, b = b, a end
			return a:GetColumnText( c3 ) < b:GetColumnText( c3 )
		end
		
		if c4 and a:GetColumnText( c4 ) ~= b:GetColumnText( c4 ) then
			if d4 then a, b = b, a end
			return a:GetColumnText( c4 ) < b:GetColumnText( c4 )
		end
		
		return true
	end )

	self:SetDirty( true )
	self:InvalidateLayout()
end

function PANEL:SortByColumn( ColumnID, Desc )
	table.Copy( self.Sorted, self.Lines )
	
	table.sort( self.Sorted, function( a, b ) 
		if Desc then
			a, b = b, a
		end
		
		local aval = a:GetSortValue( ColumnID ) and a:GetSortValue( ColumnID ) or a:GetColumnText( ColumnID )
		local bval = b:GetSortValue( ColumnID ) and b:GetSortValue( ColumnID ) or b:GetColumnText( ColumnID )
		return aval < bval
	end )

	self:SetDirty( true )
	self:InvalidateLayout()
end

function PANEL:SelectItem( Item )
	if not Item then return end
	Item:SetSelected( true )
	self:OnRowSelected( Item:GetID(), Item )
end

function PANEL:SelectFirstItem()
	self:ClearSelection()
	self:SelectItem( self.Sorted[1] )
end

function PANEL:DoDoubleClick( LineID, Line )
	-- For Override
end

function PANEL:OnRowSelected( LineID, Line )
	-- For Override
end

function PANEL:OnRowRightClick( LineID, Line )
	-- For Override
end

function PANEL:Clear()
	for k, v in pairs( self.Lines ) do
		v:Remove()
	end

	self.Lines = {}
	self.Sorted = {}
	self:SetDirty( true )
end

function PANEL:GetSelected()
	local ret = {}
	for k, v in pairs( self.Lines ) do
		if v:IsLineSelected() then
			table.insert( ret, v )
		end
	end

	return ret
end

function PANEL:SizeToContents( )
	self:SetHeight( self.pnlCanvas:GetTall() +self:GetHeaderHeight() )
end
vgui.Register( "SRP_ListView", PANEL, "EditablePanel" )


--[[---------------------------------------------------------
   Name: SRP_Progress
-----------------------------------------------------------]]
local PANEL = {}
local TEX_GRADIENT_LEFT	= surface.GetTextureID( "gui/gradient" )
local TEX_GRADIENT_DOWN = surface.GetTextureID( "gui/gradient_down" )
AccessorFunc( PANEL, "m_fFraction",	"Fraction" )
function PANEL:Init()
	self:SetMouseInputEnabled( false )
	self:SetFraction( 0 )
	self.m_colBackground = Color( 40, 40, 40, 255 )
	self.m_colBar = Color( 255, 50, 50, 255 )
end
function PANEL:SetBackgroundColor( col )
	self.m_colBackground = col
end
function PANEL:SetBarColor( col )
	self.m_colBar = col
end
function PANEL:Paint( intW, intH )
	surface.SetDrawColor( self.m_colBackground )
	surface.DrawRect( 1, 1, intW -2, intH -2 )
	if (intW -2) *self.m_fFraction > 0 then
		surface.SetDrawColor( self.m_colBar )
		surface.DrawRect( 1, 1, (intW -2) *self.m_fFraction, intH -2 )
		surface.SetTexture( TEX_GRADIENT_DOWN )
		surface.SetDrawColor(
			math.max( 0, self.m_colBar.r -100 ),
			math.max( 0, self.m_colBar.g -100 ),
			math.max( 0, self.m_colBar.b -100 ),
			255
		)
		local half = (intH -2) /2 -1
		surface.DrawTexturedRect( 1, 1, (intW -2) *self.m_fFraction, half )
		surface.DrawTexturedRectRotated( 1 +((intW -1) *self.m_fFraction) /2, intH -(half /2), (intW -2) *self.m_fFraction, half, 180 )
	end
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, intW, 1 ) --top
	surface.DrawRect( 0, 0, 1, intH ) --left side
	surface.DrawRect( intW -1, 0, 1, intH ) --right side
	surface.DrawRect( 0, intH -1, intW, 1 ) --bottom
end
vgui.Register( "SRP_Progress", PANEL, "EditablePanel" )