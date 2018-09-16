--[[
	Name: cl_menu_property.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_matIcon = Material( "icon16/building.png" )
	self.m_colSold = Color( 255, 50, 50, 255 )
	self.m_colSell = Color( 50, 255, 50, 255 )
	self.m_colPrice = Color( 120, 230, 110, 255 )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "DermaLarge" )

	self.m_pnlPriceLabel = vgui.Create( "DLabel", self )
	self.m_pnlPriceLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlPriceLabel:SetTextColor( self.m_colPrice )
	self.m_pnlPriceLabel:SetFont( "Trebuchet24" )

	self.m_pnlBuyBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlBuyBtn:SetFont( "DermaLarge" )
	self.m_pnlBuyBtn:SetAlpha( 150 )
	self.m_pnlBuyBtn.DoClick = function()
		if not self.m_tblProperty then return end
		
		local owner = GAMEMODE.Property:GetOwner( self.m_tblProperty.Name )
		if owner == LocalPlayer() then
			GAMEMODE.Net:RequestSellProperty( self.m_tblProperty.Name )
		elseif not IsValid( owner ) then
			GAMEMODE.Net:RequestBuyProperty( self.m_tblProperty.Name )
		end
	end
end

function Panel:SetProperty( tblData )
	self.m_tblProperty = tblData
	self.m_pnlNameLabel:SetText( tblData.Name )
	self:InvalidateLayout()
end

function Panel:Think()
	if not self.m_tblProperty then return end

	local owner = GAMEMODE.Property:GetOwner( self.m_tblProperty.Name )
	if owner == LocalPlayer() then
		self.m_pnlBuyBtn:SetText( "SELL" )
		self.m_pnlBuyBtn:SetTextColorOverride( self.m_colSell )
		self.m_pnlPriceLabel:SetText( "Sell for $".. string.Comma(math.ceil(self.m_tblProperty.Price /2)) )
	else
		if not self.m_tblProperty.Cat then return end
		self.m_pnlBuyBtn:SetDisabled( IsValid(owner) )
		self.m_pnlPriceLabel:SetText( "$".. string.Comma(GAMEMODE.Econ:ApplyTaxToSum("prop_".. self.m_tblProperty.Cat, self.m_tblProperty.Price)) )

		if self.m_pnlBuyBtn:GetDisabled() then
			self.m_pnlBuyBtn:SetText( "SOLD!" )
			self.m_pnlBuyBtn:SetTextColorOverride( self.m_colSold )
		else
			self.m_pnlBuyBtn:SetText( "BUY" )
			self.m_pnlBuyBtn:SetTextColorOverride( nil )
		end		
	end
end

function Panel:Paint( intW, intH )
	local padding = 5

	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, intH )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( self.m_matIcon )
	surface.DrawTexturedRect( padding, padding, intH -(padding *2), intH -(padding *2) )
end

function Panel:PerformLayout( intW, intH )
	local padding = 5
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetWide( intW )
	self.m_pnlNameLabel:SetPos( (padding *2) +intH, (intH /2) -self.m_pnlNameLabel:GetTall() )
	
	self.m_pnlPriceLabel:SizeToContents()
	self.m_pnlPriceLabel:SetWide( intW )
	self.m_pnlPriceLabel:SetPos( (padding *2) +intH, (intH /2) +(self.m_pnlNameLabel:GetTall() /2) -(self.m_pnlNameLabel:GetTall() /2) )

	self.m_pnlBuyBtn:SetSize( 82, intH )
	self.m_pnlBuyBtn:SetPos( intW -self.m_pnlBuyBtn:GetWide(), 0 )
end
vgui.Register( "SRPPropertyCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetTitle( "Purchase Properties" )
	self:SetDeleteOnClose( false )

	self.m_pnlTabs = vgui.Create( "SRP_PropertySheet", self )
	self.m_pnlTabs:SetPadding( 0 )
	self.m_tblTabPanels = {}
end

function Panel:Populate()
	for k, v in pairs( self.m_tblTabPanels ) do
		for _, p in pairs( v.Panels ) do
			p:Remove()
		end

		self.m_pnlTabs:CloseTab( v.Sheet.Tab, true )
	end

	self.m_tblTabPanels = {}

	local tabSet = false
	for id, name in pairs( GAMEMODE.Config.PropertyCats ) do
		local tabPanel = self.m_pnlTabs:AddSheet( name, vgui.Create("SRP_ScrollPanel") )--, "icon16/star.png" )
		self.m_tblTabPanels[id] = { Sheet = tabPanel, Parent = tabPanel.Panel, Panels = {} }

		for k, data in pairs( GAMEMODE.Property:GetProperties() ) do
			if not data.Cat or data.Cat ~= name then continue end
			if IsValid( GAMEMODE.Property:GetOwner(data.Name) ) and GAMEMODE.Property:GetOwner(data.Name) ~= LocalPlayer() then continue end
			tabPanel.Panel:AddItem( self:CreatePropertyCard(id, data) )
		end

		if not tabSet then
			tabSet = true
			self.m_pnlTabs:SetActiveTab( tabPanel.Tab )
		end
	end

	self:InvalidateLayout()
end

function Panel:CreatePropertyCard( idx, tblData )
	local pnl = vgui.Create( "SRPPropertyCard" )
	pnl:SetProperty( tblData )
	table.insert( self.m_tblTabPanels[idx].Panels, pnl )
	return pnl
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )

	self.m_pnlTabs:SetPos( 0, 24 )
	self.m_pnlTabs:SetSize( intW, intH -24 )

	for _, tbl in pairs( self.m_tblTabPanels ) do
		for _, pnl in pairs( tbl.Panels ) do
			pnl:DockMargin( 0, 0, 0, 5 )
			pnl:SetTall( 64 )
			pnl:Dock( TOP )
		end
	end
end

function Panel:Open()
	self:Populate()

	self:SetVisible( true )
	self:MakePopup()
end

function Panel:OnClose()
	GAMEMODE.Net:SendNPCDialogEvent( "property_buy_end_dialog" )
end
vgui.Register( "SRPPropertyShop", Panel, "SRP_Frame" )