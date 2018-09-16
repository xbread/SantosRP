--[[
	Name: cl_menu_carbuy.lua
	For: TalosLife
	By: TalosLife
]]--

surface.CreateFont( "CarMenuFont", {size = 28, weight = 400, font = "DermaLarge"} )
surface.CreateFont( "CarMenuVIPFont", {size = 100, weight = 400, font = "DermaLarge"} )
surface.CreateFont( "CarMenuVIPHugeFont", {size = 128, weight = 400, font = "DermaLarge"} )
surface.CreateFont( "CarMenuPreviewPriceFont", {size = 36, weight = 400, font = "DermaLarge"} )

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

	self.m_pnlPreviewBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlPreviewBtn:SetFont( "CarMenuFont" )
	self.m_pnlPreviewBtn:SetText( "View Info" )
	self.m_pnlPreviewBtn:SetAlpha( 150 )
	self.m_pnlPreviewBtn.DoClick = function()
		if not self.m_tblCar then return end
		self.m_tblParentMenu:ShowCarPreview( self.m_tblCar )
	end
end

function Panel:SetCar( tblData )
	self.m_tblCar = tblData
	self.m_pnlNameLabel:SetText( tblData.Name )
	self.m_pnlPriceLabel:SetText( "$".. string.Comma(tblData.Price) )
	self.m_pnlIcon:SetModel( tblData.Model )
	self:InvalidateLayout()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, intH )

	if self.m_tblCar.VIP then
		draw.SimpleText(
			"VIP",
			"CarMenuVIPFont",
			intW -self.m_pnlPreviewBtn:GetWide() -20,
			intH /2 -3,
			Color( 200, 50, 50, 45 ),
			TEXT_ALIGN_RIGHT,
			TEXT_ALIGN_CENTER
		)
	end
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

	self.m_pnlPreviewBtn:SetSize( 110, intH )
	self.m_pnlPreviewBtn:SetPos( intW -self.m_pnlPreviewBtn:GetWide(), 0 )
end
vgui.Register( "SRPCarCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_colPrice = Color( 120, 230, 110, 255 )
	self.m_colDesc = Color( 255, 255, 255, 255 )
	self.m_colInfo = Color( 255, 255, 255, 255 )

	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlCarPreview = vgui.Create( "Panel", self )
	self.m_tblCards = {}

	self.m_pnlBackBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlBackBtn:SetFont( "DermaLarge" )
	self.m_pnlBackBtn:SetText( "Back" )
	self.m_pnlBackBtn:SetAlpha( 200 )
	self.m_pnlBackBtn.DoClick = function()
		self.m_tblParentMenu:ShowCarList()
	end

	self.m_pnlBuyBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlBuyBtn:SetFont( "DermaLarge" )
	self.m_pnlBuyBtn:SetText( "Purchase" )
	self.m_pnlBuyBtn:SetAlpha( 200 )
	self.m_pnlBuyBtn.DoClick = function()
		GAMEMODE.Net:RequestBuyCar( self.m_tblCar.UID, 1 )
	end

	self.m_pnlPriceLabel = vgui.Create( "DLabel", self )
	self.m_pnlPriceLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlPriceLabel:SetTextColor( self.m_colPrice )
	self.m_pnlPriceLabel:SetFont( "CarMenuPreviewPriceFont" )

	self.m_pnlDescLabel = vgui.Create( "DLabel", self )
	self.m_pnlDescLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlDescLabel:SetTextColor( self.m_colDesc )
	self.m_pnlDescLabel:SetFont( "Trebuchet24" )

	self.m_pnlCarModel = vgui.Create( "DModelPanel", self )
	local ang = Angle( 0, 0, 0 )
	self.m_pnlCarModel:SetCamPos( (ang:Forward() *-256) +(ang:Up() *55) )
end

function Panel:SetCar( tblCar )
	self.m_tblCar = tblCar

	self.m_pnlPriceLabel:SetText( "$".. string.Comma(tblCar.Price) )
	self.m_pnlDescLabel:SetText( tblCar.Desc )
	self.m_pnlCarModel:SetModel( tblCar.Model )

	if IsValid( self.m_pnlCarModel.Entity ) then
		self.m_pnlCarModel.Entity:SetPoseParameter( "vehicle_wheel_fl_height", 0.5 )
		self.m_pnlCarModel.Entity:SetPoseParameter( "vehicle_wheel_fr_height", 0.5 )
		self.m_pnlCarModel.Entity:SetPoseParameter( "vehicle_wheel_rl_height", 0.5 )
		self.m_pnlCarModel.Entity:SetPoseParameter( "vehicle_wheel_rr_height", 0.5 )
		self.m_pnlCarModel.Entity:InvalidateBoneCache()
	end
	
	self:InvalidateLayout()
end

function Panel:Paint( intW, intH )
end

function Panel:PaintOver( intW, intH )
	if not self.m_tblCar then return end
	
	local tY = 0
	draw.SimpleText(
		"Fuel tank: ".. (self.m_tblCar.FuelTank or 0).. "l",
		"Trebuchet24",
		5,
		tY,
		self.m_colInfo,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_LEFT
	)
	tY = tY +29
	draw.SimpleText(
		"Fuel consumption: ".. (self.m_tblCar.FuelConsumption or 0).. "km/l",
		"Trebuchet24",
		5,
		tY,
		self.m_colInfo,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_LEFT
	)
end

function Panel:Think()
	if not self.m_tblCar then return end
	if self.m_tblCar.VIP and not LocalPlayer():CheckGroup( "vip" ) then
		self.m_pnlBuyBtn:SetDisabled( true )
	end

	self.m_pnlBuyBtn:SetDisabled( LocalPlayer():GetMoney() < self.m_tblCar.Price )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlBackBtn:SetSize( 150, 32 )
	self.m_pnlBackBtn:SetPos( 0, intH -self.m_pnlBackBtn:GetTall() )

	self.m_pnlBuyBtn:SetSize( 150, 32 )
	self.m_pnlBuyBtn:SetPos( intW -self.m_pnlBuyBtn:GetWide(), intH -self.m_pnlBuyBtn:GetTall() )

	self.m_pnlPriceLabel:SizeToContents()
	self.m_pnlPriceLabel:SetPos( (intW /2) -(self.m_pnlPriceLabel:GetWide() /2), intH -self.m_pnlPriceLabel:GetTall() -5 )

	self.m_pnlDescLabel:SizeToContents()
	self.m_pnlDescLabel:SetPos( (intW /2) -(self.m_pnlDescLabel:GetWide() /2), intH -self.m_pnlPriceLabel:GetTall() -self.m_pnlDescLabel:GetTall() -10 )

	self.m_pnlCarModel:SetSize( intW, intH -32 )
	self.m_pnlCarModel:SetPos( 0, 0 )
end
vgui.Register( "SRPCarPreview", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetDeleteOnClose( false )

	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlCarPreview = vgui.Create( "SRPCarPreview", self )
	self.m_pnlCarPreview.m_tblParentMenu = self
	self.m_tblCards = {}

	self:AddSearchBar()
end

function Panel:AddSearchBar()
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

function Panel:ShowCarList()
	self.m_pnlCarPreview:SetVisible( false )
	self.m_pnlCanvas:SetVisible( true )
end

function Panel:ShowCarPreview( tblCar )
	self.m_pnlCarPreview:SetVisible( true )
	self.m_pnlCanvas:SetVisible( false )
	self.m_pnlCarPreview:SetCar( tblCar )
end

function Panel:Populate()
	self.m_pnlCanvas:Clear( true )
	self.m_tblCards = {}

	self:AddSearchBar()

	local cars = GAMEMODE.Cars:GetAllCarsByUID()
	for k, data in SortedPairsByMemberValue( cars, "Price", false ) do
		self:CreateCarCard( k, data )
	end

	self:InvalidateLayout()
end

function Panel:CreateCarCard( k, tblData )
	local pnl = vgui.Create( "SRPCarCard" )
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
	self.m_pnlCarPreview:SetPos( 0, 24 )
	self.m_pnlCarPreview:SetSize( intW, intH -24 )

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
	self:ShowCarList()
	self:SetVisible( true )
	self:MakePopup()
end
vgui.Register( "SRPCarShop", Panel, "SRP_Frame" )