--[[
	Name: cl_menu_carsell.lua
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
	self.m_pnlNameLabel:SetFont( "CarMenuFont" )

	self.m_pnlPriceLabel = vgui.Create( "DLabel", self )
	self.m_pnlPriceLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlPriceLabel:SetTextColor( self.m_colPrice )
	self.m_pnlPriceLabel:SetFont( "Trebuchet24" )

	self.m_pnlSellBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlSellBtn:SetFont( "CarMenuFont" )
	self.m_pnlSellBtn:SetText( "SELL" )
	self.m_pnlSellBtn:SetAlpha( 150 )
	self.m_pnlSellBtn.DoClick = function()
		if not self.m_tblCar then return end
		
		GAMEMODE.Net:RequestSellCar( self.m_tblCar.UID )

		timer.Simple( 0.6, function()
			if not ValidPanel( self ) or not ValidPanel( self.m_tblParentMenu ) then return end
			self.m_tblParentMenu:Populate()
		end )
	end
end

function Panel:SetCar( tblData )
	self.m_tblCar = tblData
	self.m_pnlNameLabel:SetText( tblData.Name )

	local sellPrice = math.ceil( tblData.Price *(LocalPlayer():CheckGroup("vip") and .75 or .6) )
	self.m_pnlPriceLabel:SetText( "Sells for $".. string.Comma(sellPrice) )
	self.m_pnlIcon:SetModel( tblData.Model )
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

	self.m_pnlSellBtn:SetSize( 110, intH )
	self.m_pnlSellBtn:SetPos( intW -self.m_pnlSellBtn:GetWide(), 0 )
end
vgui.Register( "SRPCarSellCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetDeleteOnClose( false )
	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}

	self.m_pnlSearch = vgui.Create( "EditablePanel", self )
	self.m_pnlSearch.SearchBtn = vgui.Create( "SRP_Button", self.m_pnlSearch )
	self.m_pnlSearch.SearchBtn:SetFont( "DermaLarge" )
	self.m_pnlSearch.SearchBtn:SetText( "Search" )
	self.m_pnlSearch.SearchBtn:SetAlpha( 200 )
	self.m_pnlSearch.SearchBtn.DoClick = function()
		for k, v in pairs( self.m_tblCards ) do
			if v.m_tblCar.Name:lower():find( self.m_pnlSearch.TextEntry:GetValue() ) ~= nil then
				self.m_pnlCanvas:ScrollToChild( v )
				break
			end
		end
	end

	self.m_pnlSearch.TextEntry = vgui.Create( "DTextEntry", self.m_pnlSearch )
	self.m_pnlSearch.TextEntry.OnEnter = self.m_pnlSearch.SearchBtn.DoClick
	self.m_pnlSearch.PerformLayout = function( p, intW, intH )
		p.SearchBtn:SetSize( 110, intH )
		p.SearchBtn:SetPos( intW -p.SearchBtn:GetWide(), 0 )

		p.TextEntry:SetSize( intW -p.SearchBtn:GetWide(), intH )
		p.TextEntry:SetPos( 0, 0 )
	end

	self.m_pnlSearch.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 200 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlCanvas:AddItem( self.m_pnlSearch )
end

function Panel:Populate()
	for k, v in pairs( self.m_tblCards ) do
		if ValidPanel( v ) then v:Remove() end
		self.m_tblCards[k] = nil
	end

	local cars = GAMEMODE.Cars:GetAllCarsByUID()
	local playerCars = GAMEMODE.Player:GetGameVar( "vehicles", {} )
	for k, data in SortedPairsByMemberValue( cars, "Price", false ) do
		if not playerCars[data.UID] then continue end
		self:CreateCarCard( k, cars[k] )
	end

	self:InvalidateLayout()
end

function Panel:CreateCarCard( k, tblData )
	local pnl = vgui.Create( "SRPCarSellCard" )
	pnl:SetCar( tblData )
	pnl.m_tblParentMenu = self
	self.m_pnlCanvas:AddItem( pnl )
	self.m_tblCards[k] = pnl

	return pnl
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )

	self.m_pnlCanvas:SetPos( 0, 24 )
	self.m_pnlCanvas:SetSize( intW, intH -24 )

	self.m_pnlSearch:DockMargin( 0, 0, 0, 5 )
	self.m_pnlSearch:SetTall( 32 )
	self.m_pnlSearch:Dock( TOP )

	for _, pnl in pairs( self.m_tblCards ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 64 )
		pnl:Dock( TOP )
	end
end

function Panel:Open()
	self:Populate()
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:OnClose()
	GAMEMODE.Net:SendNPCDialogEvent( "car_dealer_end_dialog" )
end
vgui.Register( "SRPCarSellMenu", Panel, "SRP_Frame" )