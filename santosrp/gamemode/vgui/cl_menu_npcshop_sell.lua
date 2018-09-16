--[[
	Name: cl_menu_npcshop_sell.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_colSold = Color( 255, 50, 50, 255 )
	self.m_colSell = Color( 50, 255, 50, 255 )
	self.m_colPrice = Color( 120, 230, 110, 255 )

	self.m_pnlIcon = vgui.Create( "ModelImage", self )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "DermaLarge" )

	self.m_pnlPriceLabel = vgui.Create( "DLabel", self )
	self.m_pnlPriceLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlPriceLabel:SetTextColor( self.m_colPrice )
	self.m_pnlPriceLabel:SetFont( "Trebuchet24" )

	self.m_pnlSellBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlSellBtn:SetFont( "DermaLarge" )
	self.m_pnlSellBtn:SetText( "Sell" )
	self.m_pnlSellBtn:SetAlpha( 150 )
	self.m_pnlSellBtn.DoClick = function()
		if not self.m_tblParentMenu then return end
		GAMEMODE.Net:RequestSellNPCItem( self.m_tblParentMenu.m_strNPCID, self.m_strItemID, 1 )
	end
	self.m_pnlSellBtn.DoRightClick = function()
		if not self.m_tblParentMenu then return end
		local dMenu = DermaMenu()
		dMenu:AddOption( "Sell 5", function() GAMEMODE.Net:RequestSellNPCItem( self.m_tblParentMenu.m_strNPCID, self.m_strItemID, 5 ) end )
		dMenu:AddOption( "Sell 10", function() GAMEMODE.Net:RequestSellNPCItem( self.m_tblParentMenu.m_strNPCID, self.m_strItemID, 10 ) end )
		dMenu:AddOption( "Sell 15", function() GAMEMODE.Net:RequestSellNPCItem( self.m_tblParentMenu.m_strNPCID, self.m_strItemID, 15 ) end )
		dMenu:AddOption( "Sell 25", function() GAMEMODE.Net:RequestSellNPCItem( self.m_tblParentMenu.m_strNPCID, self.m_strItemID, 25 ) end )
		dMenu:AddOption( "Sell 50", function() GAMEMODE.Net:RequestSellNPCItem( self.m_tblParentMenu.m_strNPCID, self.m_strItemID, 50 ) end )
		dMenu:Open()
	end
end

function Panel:SetItemID( strItemID )
	self.m_strItemID = strItemID
	self.m_tblItem = GAMEMODE.Inv:GetItem( strItemID )

	if self.m_tblItem then
		self.m_pnlNameLabel:SetText( self.m_tblItem.Name )
		self.m_pnlIcon:SetModel( self.m_tblItem.Model, self.m_tblItem.Skin )
	end

	self:InvalidateLayout()
end

function Panel:SetItemPrice( intPrice )
	self.m_intItemPrice = intPrice
	self.m_pnlPriceLabel:SetText( "Sells For $".. string.Comma(intPrice) )
	self:InvalidateLayout()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	local padding = 5

	self.m_pnlIcon:SetPos( 0, 0 )
	self.m_pnlIcon:SetSize( intH, intH )

	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetWide( intW )
	self.m_pnlNameLabel:SetPos( (padding *2) +intH, (intH /2) -self.m_pnlNameLabel:GetTall() )
	
	self.m_pnlPriceLabel:SizeToContents()
	self.m_pnlPriceLabel:SetWide( intW )
	self.m_pnlPriceLabel:SetPos( (padding *2) +intH, (intH /2) +(self.m_pnlNameLabel:GetTall() /2) -(self.m_pnlNameLabel:GetTall() /2) )

	self.m_pnlSellBtn:SetSize( 82, intH )
	self.m_pnlSellBtn:SetPos( intW -self.m_pnlSellBtn:GetWide(), 0 )
end
vgui.Register( "SRPNPCSellMenuCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetTitle( "" )
	self.m_tblCards = {}
	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )

	hook.Add( "GamemodeOnInventoryUpdated", "UpdateDrugMenu", function()
		if self:IsVisible() then self:Populate( self.m_strNPCID ) end
	end )
end

function Panel:Populate( strNPCID )
	self.m_strNPCID = strNPCID

	local data = GAMEMODE.NPC:GetNPCMeta( strNPCID )
	if not data then return end
	
	self:SetTitle( data.Name )

	for k, v in pairs( self.m_tblCards ) do
		if ValidPanel( v ) then v:Remove() end
	end

	self.m_tblCards = {}
	
	if data.ItemsCanBuy then
		for name, price in SortedPairs( data.ItemsCanBuy ) do
			if not LocalPlayer():GetInventory()[name] then continue end
			if LocalPlayer():GetInventory()[name] <= 0 then continue end
			self:CreateItemCard( name, price )
		end
	end
	
	self:InvalidateLayout()
end

function Panel:CreateItemCard( strItemID, intPrice )
	local pnl = vgui.Create( "SRPNPCSellMenuCard" )
	pnl:SetItemID( strItemID )
	pnl:SetItemPrice( intPrice )
	pnl.m_tblParentMenu = self
	table.insert( self.m_tblCards, pnl )
	self.m_pnlCanvas:AddItem( pnl )
	return pnl
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )

	self.m_pnlCanvas:SetPos( 0, 24 )
	self.m_pnlCanvas:SetSize( intW, intH -24 )

	for _, pnl in pairs( self.m_tblCards ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 64 )
		pnl:Dock( TOP )
	end
end

function Panel:Open()
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:OnClose()
	local data = GAMEMODE.NPC:GetNPCMeta( self.m_strNPCID or "" )
	if not data then return end
	GAMEMODE.Net:SendNPCDialogEvent( data.UID.. "_end_dialog" )
end
vgui.Register( "SRPNPCSellMenu", Panel, "SRP_Frame" )