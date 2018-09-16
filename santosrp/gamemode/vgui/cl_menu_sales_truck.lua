--[[
	Name: cl_menu_sales_truck.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_colPrice = Color( 120, 230, 110, 255 )

	self.m_pnlIcon = vgui.Create( "ModelImage", self )
	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "CarMenuFont" )

	self.m_pnlDescLabel = vgui.Create( "DLabel", self )
	self.m_pnlDescLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlDescLabel:SetTextColor( self.m_colPrice )
	self.m_pnlDescLabel:SetFont( "Trebuchet24" )

	self.m_pnlPriceLabel = vgui.Create( "DLabel", self )
	self.m_pnlPriceLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlPriceLabel:SetTextColor( self.m_colPrice )
	self.m_pnlPriceLabel:SetFont( "Trebuchet24" )

	self.m_pnlBuyBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlBuyBtn:SetFont( "DermaLarge" )
	self.m_pnlBuyBtn:SetText( "BUY" )
	self.m_pnlBuyBtn:SetAlpha( 150 )
end

function Panel:SetItem( tblData, intPrice )
	self.m_tblItem = tblData
	self.m_pnlNameLabel:SetText( tblData.Name )
	self.m_pnlDescLabel:SetText( tblData.Desc )
	self.m_pnlIcon:SetModel( tblData.Model, tblData.Skin )

	local taxed = GAMEMODE.Econ:ApplyTaxToSum( "sales", intPrice ) +math.ceil( intPrice *0.32 )
	self.m_pnlPriceLabel:SetText( "$".. taxed )
	self:InvalidateLayout()
end

function Panel:SetClickFuncs( fnDoClick, fnDoRightClick )
	self.m_pnlBuyBtn.DoClick = function() fnDoClick( self ) end
	self.m_pnlBuyBtn.DoRightClick = function() fnDoRightClick( self ) end
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
	self.m_pnlNameLabel:SetPos( (padding *2) +intH, (intH /2) -self.m_pnlNameLabel:GetTall() )
	
	self.m_pnlDescLabel:SizeToContents()
	self.m_pnlDescLabel:SetPos( (padding *2) +intH, (intH /2) +(self.m_pnlNameLabel:GetTall() /2) -(self.m_pnlNameLabel:GetTall() /2) )

	self.m_pnlBuyBtn:SetSize( 110, intH )
	self.m_pnlBuyBtn:SetPos( intW -self.m_pnlBuyBtn:GetWide(), 0 )

	self.m_pnlPriceLabel:SizeToContents()
	self.m_pnlPriceLabel:SetPos(
		intW -self.m_pnlPriceLabel:GetWide() -self.m_pnlBuyBtn:GetWide() - 5,
		(intH /2) +(self.m_pnlNameLabel:GetTall() /2) -(self.m_pnlNameLabel:GetTall() /2)
	)
end
vgui.Register( "SRPItemSalesTruckCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------
local function BuyItem( strItem, intAmount )
	GAMEMODE.Net:PlayerBuySalesTruckItem( strItem, intAmount )
end

local Panel = {}
function Panel:Init()
	self:SetTitle( "Sales Truck" )
	self:SetDeleteOnClose( false )

	self.m_pnlItemList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlItemList.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 100 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_tblItems = {}
end

function Panel:SetEntity( eEnt )
	self.m_entTruck = eEnt
	if not IsValid( eEnt ) then return end

	local jobData = GAMEMODE.Jobs:GetJobByID( JOB_SALES_TRUCK )
	self:SetTitle( jobData.m_tblTruckTypes[self.m_entTruck:GetNWInt("sales_truck_id")].Name.. " Truck" )
	self:Refresh()
end

function Panel:Think()
	if self:IsVisible() and not IsValid( self.m_entTruck ) or self.m_entTruck:GetPos():Distance( LocalPlayer():GetPos() ) > 200 then
		self:SetVisible( false )
	end
end

function Panel:Refresh()
	for k, v in pairs( self.m_tblItems ) do
		if ValidPanel( v ) then v:Remove() end
	end

	self.m_tblItems = {}	
	if not IsValid( self.m_entTruck ) then self:Remove() return end
	local jobData = GAMEMODE.Jobs:GetJobByID( JOB_SALES_TRUCK )

	for k, v in pairs( jobData.m_tblTruckTypes[self.m_entTruck:GetNWInt("sales_truck_id")].Items ) do
		local pnl = vgui.Create( "SRPItemSalesTruckCard", self.m_pnlItemList )
		pnl:SetItem( GAMEMODE.Inv:GetItem(k), v )
		pnl:SetClickFuncs(
			function( pnl )
				BuyItem( k, 1 )
			end,
			function( pnl )
				local dMenu = DermaMenu()
				dMenu:AddOption( "Buy 5", function() BuyItem( k, 5 ) end )
				dMenu:AddOption( "Buy 10", function() BuyItem( k, 10 ) end )
				dMenu:AddOption( "Buy 15", function() BuyItem( k, 15 ) end )
				dMenu:AddOption( "Buy 25", function() BuyItem( k, 25 ) end )
				dMenu:AddOption( "Buy 50", function() BuyItem( k, 50 ) end )
				dMenu:Open()
			end
		)

		table.insert( self.m_tblItems, pnl )
	end

	self:InvalidateLayout()
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )

	self.m_pnlItemList:SetSize( intW, intH -24 )
	self.m_pnlItemList:SetPos( 0, 24 )

	for _, pnl in pairs( self.m_tblItems ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 64 )
		pnl:Dock( TOP )
	end
end

function Panel:Open()
	self:SetVisible( true )
	self:MakePopup()
end
vgui.Register( "SRPSalesTruck", Panel, "SRP_Frame" )