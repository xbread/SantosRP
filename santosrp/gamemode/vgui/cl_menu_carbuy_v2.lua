--[[
	Name: cl_menu_carbuy_v2.lua
	For: TalosLife
	By: TalosLife
]]--

surface.CreateFont( "CarMenuV2VIPFont", {size = 64, weight = 400, font = "DermaLarge"} )

local Panel = {}
function Panel:Init()
	self.m_tblCars = {}
	self.m_tblCarIcons = {}

	self.m_pnlBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlBtn.DoClick = function()
		self.m_pnlParentMenu:HideAllSubMenus()

		if self.m_pnlCarContainer:GetWide() == 0 then
			self:Expand()
		else
			self:Close()
		end
	end

	self.m_pnlCarContainer = vgui.Create( "DHorizontalScroller", self )
	self.m_pnlCarContainer:SetWide( 0 )
end

function Panel:Expand()
	self.m_pnlCarContainer:SizeTo( self:GetWide() -self.m_pnlBtn:GetWide(), -1, 1, 0, 2, function()
	end )
end

function Panel:Close()
	self.m_pnlCarContainer:SizeTo( 0, -1, 1, 0, 2, function()
		self.m_pnlCarContainer:SetWide( 0 )
	end )
end

function Panel:SetMake( strMake )
	self.m_strMake = strMake
	self.m_pnlBtn:SetText( strMake )
end

function Panel:SetCars( tblCars )
	self.m_tblCars = tblCars

	for k, v in SortedPairsByMemberValue( tblCars, "Price", false ) do
		local pnlIcon = vgui.Create( "SpawnIcon", self.m_pnlCarContainer )
		pnlIcon:SetSize( self:GetTall(), self:GetTall() )
		pnlIcon:SetModel( v.Model )
		pnlIcon:SetTooltip( v.Name )
		pnlIcon.DoClick = function()
			self.m_pnlParentMenu:SetSelectedCar( v )
		end

		table.insert( self.m_tblCarIcons, pnlIcon )
		self.m_pnlCarContainer:AddPanel( pnlIcon )
	end
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 30, 30, 30, 90 )

	local x, y = self.m_pnlCarContainer:GetPos()
	local w, h = self.m_pnlCarContainer:GetSize()
	surface.DrawRect( x, y, w, h )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlBtn:SetSize( 100, intH )
	self.m_pnlBtn:SetPos( intW -self.m_pnlBtn:GetWide(), 0 )

	self.m_pnlCarContainer:SetPos( intW -self.m_pnlBtn:GetWide() -self.m_pnlCarContainer:GetWide(), 0 )
	self.m_pnlCarContainer:SetTall( intH )

	local xPos = 0
	for k, v in pairs( self.m_tblCarIcons ) do
		v:SetSize( intH, intH )
		v:SetPos( xPos, 0 )
		xPos = xPos +intH
	end
end
vgui.Register( "SRPCarMakePanel", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_matBlur = Material( "pp/blurscreen.png", "noclamp" )

	self.m_tblSortedCarList = {}
	self.m_pnlMakeContainer = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblMakeCards = {}

	local tbl = {}
	for k, v in pairs( GAMEMODE.Config.StockCarColors ) do
		tbl[#tbl +1] = v
	end

	self.m_pnlColors = vgui.Create( "DColorPalette", self )
	self.m_pnlColors:SetColorButtons( tbl )
	self.m_pnlColors:SetButtonSize( 32 )
	self.m_pnlColors.DoClick = function( _, color, btn )
		if IsValid( self.m_entCar ) then
			self.m_entCar:SetColor( color )
			self.m_intColorID = btn:GetID()
		end
	end

	self.m_pnlToolBar = vgui.Create( "SRP_FramePanel", self )
	self.m_pnlNameLabel = vgui.Create( "DLabel", self.m_pnlToolBar )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "DermaLarge" )
	self.m_pnlNameLabel:SetText( " " )

	self.m_pnlPriceLabel = vgui.Create( "DLabel", self.m_pnlToolBar )
	self.m_pnlPriceLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlPriceLabel:SetTextColor( Color( 120, 230, 110, 255 ) )
	self.m_pnlPriceLabel:SetFont( "Trebuchet24" )
	self.m_pnlPriceLabel:SetText( " " )

	self.m_pnlBtnBack = vgui.Create( "SRP_Button", self.m_pnlToolBar )
	self.m_pnlBtnBack:SetText( "Back" )
	self.m_pnlBtnBack.DoClick = function()
		self:Close()
	end

	self.m_pnlBtnBuy = vgui.Create( "SRP_Button", self.m_pnlToolBar )
	self.m_pnlBtnBuy:SetText( "Purchase" )
	self.m_pnlBtnBuy.DoClick = function()
		if not self.m_tblCurCar then return end
		GAMEMODE.Net:RequestBuyCar( self.m_tblCurCar.UID, self.m_intColorID or 1 )
	end
	self.m_pnlBtnBuy.Think = function()
		if self.m_tblCurCar then
			if self.m_tblCurCar.VIP and not LocalPlayer():CheckGroup( "vip" ) then
				self.m_pnlBtnBuy:SetDisabled( true )
				return
			end

			if not LocalPlayer():CanAfford( self.m_tblCurCar.Price ) then
				self.m_pnlBtnBuy:SetDisabled( true )
				return
			end

			self.m_pnlBtnBuy:SetDisabled( false )
		end
	end

	self.m_pnlBtnBuy:SetDisabled( true )
end

function Panel:SetSelectedCar( tblCar )
	self.m_tblCurCar = tblCar
	self.m_intColorID = nil

	local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", tblCar.Price )
	self:SetModel( tblCar.Model )
	self.m_pnlNameLabel:SetText( tblCar.Name )
	self.m_pnlPriceLabel:SetText( "$".. string.Comma(price) )
	self.m_pnlBtnBuy:SetDisabled( false )
	self:InvalidateLayout()
end

function Panel:SetModel( strModel )
	if IsValid( self.m_entCar ) then
		self.m_entCar:Remove()
	end

	self.m_entCar = ClientsideModel( strModel, RENDERGROUP_BOTH )
	self.m_entCar:SetPos( GAMEMODE.Config.CarPreviewModelPos )
	self.m_entCar:SetAngles( Angle(0, 0, 0) )

	self.m_entCar:SetPoseParameter( "vehicle_wheel_fl_height", 0.5 )
	self.m_entCar:SetPoseParameter( "vehicle_wheel_fr_height", 0.5 )
	self.m_entCar:SetPoseParameter( "vehicle_wheel_rl_height", 0.5 )
	self.m_entCar:SetPoseParameter( "vehicle_wheel_rr_height", 0.5 )
	self.m_entCar:InvalidateBoneCache()
end

function Panel:Think()
	if not self.m_angCur then
		self.m_angCur = Angle( 0, 45, 0 )
	end

	self.m_angCur.y = math.NormalizeAngle( self.m_angCur.y +(FrameTime() *10) )
	if IsValid( self.m_entCar ) then
		self.m_entCar:SetAngles( self.m_angCur )
	end
end

function Panel:Populate()
	--Sort the cars into tables by make and price
	local cars = GAMEMODE.Cars:GetAllCarsByUID()
	for k, data in SortedPairsByMemberValue( cars, "Make", false ) do
		if not self.m_tblSortedCarList[data.Make] then
			self.m_tblSortedCarList[data.Make] = {}
		end
		
		self.m_tblSortedCarList[data.Make][k] = data
	end

	--Build the buttons for each make
	for k, v in pairs( self.m_tblSortedCarList ) do
		self:AddMake( k, v )
	end

	self:InvalidateLayout()
end

function Panel:AddMake( strText, tblCars )
	local makePnl = vgui.Create( "SRPCarMakePanel", self )
	makePnl:SetMake( strText )
	makePnl.m_pnlParentMenu = self
	makePnl:SetSize( 500, 72 )
	makePnl:SetCars( tblCars )
	self.m_pnlMakeContainer:AddItem( makePnl )
	table.insert( self.m_tblMakeCards, makePnl )
end

function Panel:HideAllSubMenus()
	for k, v in pairs( self.m_tblMakeCards ) do
		v.m_pnlCarContainer:SetWide( 0 )
	end
end

function Panel:Paint( intW, intH )
	local x, y = self.m_pnlColors:GetPos()
	y = y -5

	local w, h = self.m_pnlColors:GetSize()
	h = h +10
	local extraW = 16

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
	GAMEMODE.HUD:DrawFancyRect(x -extraW, y, w +(extraW *2), h, 90 +11.25, 90 -11.25 )

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

	surface.SetDrawColor( 10, 10, 10, 75 )
	GAMEMODE.HUD:DrawFancyRect(x -extraW, y, w +(extraW *2), h, 90 +11.25, 90 -11.25 )
end

function Panel:PaintOver( intW, intH )
	if self.m_tblCurCar and self.m_tblCurCar.VIP then
		x, y = self.m_pnlNameLabel:GetPos()
		local tx, ty = self.m_pnlToolBar:GetPos()
		
		draw.SimpleText(
			"VIP",
			"CarMenuV2VIPFont",
			x +self.m_pnlNameLabel:GetWide() +10,
			ty +(self.m_pnlToolBar:GetTall() /2),
			Color( 200, 50, 50, 100 ),
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER
		)
	end
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlToolBar:SetPos( 0, intH *0.75 )

	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( (intW /2) -(self.m_pnlNameLabel:GetWide() /2), 0 )

	self.m_pnlPriceLabel:SizeToContents()
	self.m_pnlPriceLabel:SetPos( (intW /2) -(self.m_pnlPriceLabel:GetWide() /2), self.m_pnlNameLabel:GetTall() )

	self.m_pnlToolBar:SetSize( intW, self.m_pnlNameLabel:GetTall() +self.m_pnlPriceLabel:GetTall() )
	self.m_pnlBtnBack:SetPos( 0, 0 )
	self.m_pnlBtnBack:SetSize( 128, self.m_pnlToolBar:GetTall() )

	
	self.m_pnlBtnBuy:SetSize( 128, self.m_pnlToolBar:GetTall() )
	self.m_pnlBtnBuy:SetPos( intW -self.m_pnlBtnBuy:GetWide(), 0 )

	local x, y = self.m_pnlToolBar:GetPos()
	local w, h = self.m_pnlToolBar:GetSize()
	self.m_pnlColors:SetSize( table.Count(GAMEMODE.Config.StockCarColors) *self.m_pnlColors:GetButtonSize(), 128 )
	self.m_pnlColors:SetPos( (intW /2) -(self.m_pnlColors:GetWide() /2), y +h +5 )

	local x, y = self.m_pnlToolBar:GetPos()
	self.m_pnlMakeContainer:SetPos( intW -500, 0 )
	self.m_pnlMakeContainer:SetSize( 500, y )

	for _, pnl in pairs( self.m_tblMakeCards ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 72 )
		pnl:Dock( TOP )
		pnl:InvalidateLayout()
	end
end

function Panel:Open()
	GAMEMODE.CiniCam:JumpFromTo( LocalPlayer():EyePos(), EyeAngles(), LocalPlayer():GetFOV(), 
		GAMEMODE.Config.CarPreviewCamPos,
		GAMEMODE.Config.CarPreviewCamAng,
		LocalPlayer():GetFOV(),
		GAMEMODE.Config.CarPreviewCamLen,
		function()
		end
	)
	
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:Close()
	if IsValid( self.m_entCar ) then
		self.m_entCar:Remove()
	end

	self.m_pnlNameLabel:SetText( " " )
	self.m_pnlPriceLabel:SetText( " " )
	self.m_tblCurCar = nil

	GAMEMODE.CiniCam:ClearCamera()
	self:SetVisible( false )

	GAMEMODE.Net:SendNPCDialogEvent( "car_dealer_end_dialog" )
end
vgui.Register( "SRPCarBuyMenu2", Panel, "EditablePanel" )