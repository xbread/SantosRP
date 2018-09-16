--[[
	Name: cl_menu_spawn_copcar.lua
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

	self.m_pnlPreviewBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlPreviewBtn:SetFont( "CarMenuFont" )
	self.m_pnlPreviewBtn:SetText( "View Info" )
	self.m_pnlPreviewBtn:SetAlpha( 150 )
	self.m_pnlPreviewBtn.DoClick = function()
		if not self.m_tblCar then return end
		local curCar = LocalPlayer():GetNWEntity( "CurrentCar" )
		if IsValid( curCar ) and curCar:GetModel() == self.m_tblCar.Model:lower() then
			GAMEMODE.Net:RequestStowCopCar()
		else
			self.m_tblParentMenu:ShowCarPreview( self.m_tblCar )
		end
	end
end

function Panel:SetCar( tblData )
	self.m_tblCar = tblData
	self.m_pnlNameLabel:SetText( tblData.Name )
	self.m_pnlIcon:SetModel( tblData.Model )
	self:InvalidateLayout()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:Think()
	local curCar = LocalPlayer():GetNWEntity( "CurrentCar" )
	if IsValid( curCar ) and curCar:GetModel() == self.m_tblCar.Model:lower() then
		self.m_pnlPreviewBtn:SetText( "Store Car" )
	else
		self.m_pnlPreviewBtn:SetText( "View Info" )
	end
end

function Panel:PerformLayout( intW, intH )
	local padding = 5

	self.m_pnlIcon:SetPos( 0, 0 )
	self.m_pnlIcon:SetSize( intH, intH )

	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetWide( intW )
	self.m_pnlNameLabel:SetPos( (padding *2) +intH, (intH /2) -self.m_pnlNameLabel:GetTall() )
	
	self.m_pnlPreviewBtn:SetSize( 110, intH )
	self.m_pnlPreviewBtn:SetPos( intW -self.m_pnlPreviewBtn:GetWide(), 0 )
end
vgui.Register( "SRPCopCarCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_colSkin = Color( 255, 255, 255, 255 )
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
	self.m_pnlBuyBtn:SetText( "Spawn" )
	self.m_pnlBuyBtn:SetAlpha( 200 )
	self.m_pnlBuyBtn.DoClick = function()
		GAMEMODE.Net:RequestSpawnCopCar( self.m_tblCar.UID, self.m_colCurrentColor, self.m_intCurrentSkin, self.m_tblCurrentGroups )
	end

	self.m_pnlDescLabel = vgui.Create( "DLabel", self )
	self.m_pnlDescLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlDescLabel:SetTextColor( self.m_colDesc )
	self.m_pnlDescLabel:SetFont( "Trebuchet24" )

	self.m_pnlCarModel = vgui.Create( "DModelPanel", self )
	local ang = Angle( 0, 0, 0 )
	self.m_pnlCarModel:SetCamPos( (ang:Forward() *-300) +(ang:Up() *55) )

	--Skins
	self.m_intCurrentSkin = 0
	self.m_pnlNextSkin = vgui.Create( "SRP_Button", self )
	self.m_pnlNextSkin:SetFont( "DermaLarge" )
	self.m_pnlNextSkin:SetText( ">" )
	self.m_pnlNextSkin:SetAlpha( 200 )
	self.m_pnlNextSkin.DoClick = function()
		self.m_intCurrentSkin = self.m_intCurrentSkin +1
		if self.m_pnlCarModel.Entity:SkinCount() < (self.m_intCurrentSkin +1) then
			self.m_intCurrentSkin = 0
		end

		self.m_pnlCarModel.Entity:SetSkin( self.m_intCurrentSkin )
		self.m_pnlSkinLabel:SetText( "Skin: ".. self.m_intCurrentSkin )
		self:InvalidateLayout()
	end

	self.m_pnlPrevSkin = vgui.Create( "SRP_Button", self )
	self.m_pnlPrevSkin:SetFont( "DermaLarge" )
	self.m_pnlPrevSkin:SetText( "<" )
	self.m_pnlPrevSkin:SetAlpha( 200 )
	self.m_pnlPrevSkin.DoClick = function()
		self.m_intCurrentSkin = self.m_intCurrentSkin -1
		if self.m_intCurrentSkin < 0 then
			self.m_intCurrentSkin = self.m_pnlCarModel.Entity:SkinCount() -1
		end

		self.m_pnlCarModel.Entity:SetSkin( self.m_intCurrentSkin )
		self.m_pnlSkinLabel:SetText( "Skin: ".. self.m_intCurrentSkin )
		self:InvalidateLayout()
	end

	self.m_pnlSkinLabel = vgui.Create( "DLabel", self )
	self.m_pnlSkinLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlSkinLabel:SetTextColor( self.m_colSkin )
	self.m_pnlSkinLabel:SetFont( "CarMenuPreviewPriceFont" )

	--Colors
	self.m_colCurrentColor = Color( 255, 255, 255, 255 )
	self.m_pnlColorPicker = vgui.Create( "DColorMixer", self )
	self.m_pnlColorPicker:SetPalette( false )
	self.m_pnlColorPicker:SetAlphaBar( false )
	self.m_pnlColorPicker:SetWangs( true )
	self.m_pnlColorPicker:SetColor( self.m_colCurrentColor )
	self.m_pnlColorPicker.ValueChanged = function( pnl, col )
		self.m_colCurrentColor.r = col.r
		self.m_colCurrentColor.g = col.g
		self.m_colCurrentColor.b = col.b

		self.m_pnlCarModel.Entity:SetColor( col )
		self.m_pnlCarModel:SetColor( col )
	end

	--Bodygroups
	self.m_tblCurrentGroups = {}
	self.m_pnlBodyGroups = vgui.Create( "SRP_Button", self )
	self.m_pnlBodyGroups:SetFont( "DermaLarge" )
	self.m_pnlBodyGroups:SetText( "Edit Body Groups" )
	self.m_pnlBodyGroups:SetAlpha( 200 )
	self.m_pnlBodyGroups.DoClick = function()
		local contextMenu = DermaMenu( self )
		local ent = self.m_pnlCarModel.Entity
		local options = ent:GetBodyGroups()

		for k, v in pairs( options ) do
			if v.num <= 1 then continue end

			if v.num == 2 then -- If there's only 2 options, add it as a checkbox instead of a submenu
				local current = ent:GetBodygroup( v.id )
				local opposite = 1
				if current == opposite then opposite = 0 end

				local option = contextMenu:AddOption( v.name, function() self:ApplyBodygroup( v.id, opposite ) end )
				if current == 1 then
					option:SetChecked( true )
				end
			else -- More than 2 options we add our own submenu
				local groups = contextMenu:AddSubMenu( v.name )

				for i = 1, v.num do
					local modelname = "model #" .. i
					if v.submodels and v.submodels[i -1] ~= "" then modelname = v.submodels[i -1] end
					local option = groups:AddOption( modelname, function() self:ApplyBodygroup( v.id, i -1 ) end )

					if ent:GetBodygroup( v.id ) == i -1 then
						option:SetChecked( true )
					end
				end
			end
		end

		contextMenu:Open()
	end
end

function Panel:ApplyBodygroup( intIDX, intVal )
	self.m_tblCurrentGroups[intIDX] = intVal
	if IsValid( self.m_pnlCarModel.Entity ) then
		self.m_pnlCarModel.Entity:SetBodygroup( intIDX, intVal )
	end
end

function Panel:SetCar( tblCar )
	self.m_tblCar = tblCar
	self.m_pnlDescLabel:SetText( tblCar.Desc )
	self.m_pnlCarModel:SetModel( tblCar.Model )
	self.m_pnlCarModel.Entity:SetRenderMode( RENDERMODE_TRANSALPHA )

	self.m_intCurrentSkin = 0
	self.m_tblCurrentGroups = {}
	self.m_pnlSkinLabel:SetText( "Skin: ".. self.m_intCurrentSkin )
	self.m_colCurrentColor = Color( 255, 255, 255, 255 )
	self.m_pnlColorPicker:SetColor( self.m_colCurrentColor )
	self.m_pnlCarModel:SetColor( self.m_colCurrentColor )

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
	local x, y = self.m_pnlPrevSkin:GetPos()
	local x2, y2 = self.m_pnlNextSkin:GetPos()
	surface.SetDrawColor( 40, 40, 40, 150 )
	surface.DrawRect( x +self.m_pnlPrevSkin:GetWide(), y, x2 -x, intH -y )
end

function Panel:PaintOver( intW, intH )
	if not self.m_tblCar then return end
end

function Panel:Think()
	if not self.m_tblCar then return end

end

function Panel:PerformLayout( intW, intH )
	self.m_pnlBackBtn:SetSize( 150, 32 )
	self.m_pnlBackBtn:SetPos( 0, intH -self.m_pnlBackBtn:GetTall() )

	self.m_pnlBuyBtn:SetSize( 150, 32 )
	self.m_pnlBuyBtn:SetPos( intW -self.m_pnlBuyBtn:GetWide(), intH -self.m_pnlBuyBtn:GetTall() )

	self.m_pnlDescLabel:SizeToContents()
	self.m_pnlDescLabel:SetPos( (intW /2) -(self.m_pnlDescLabel:GetWide() /2), intH -self.m_pnlDescLabel:GetTall() -10 )

	self.m_pnlCarModel:SetSize( intW, intH -32 )
	self.m_pnlCarModel:SetPos( 0, 0 )

	--Skins
	self.m_pnlSkinLabel:SizeToContents()
	self.m_pnlSkinLabel:SetPos( (intW /2) -(self.m_pnlSkinLabel:GetWide() /2), intH -self.m_pnlSkinLabel:GetTall() )

	local x, y = self.m_pnlSkinLabel:GetPos()
	self.m_pnlNextSkin:SetSize( 32, 32 )
	self.m_pnlNextSkin:SetPos( x +self.m_pnlSkinLabel:GetWide() +15, intH -self.m_pnlNextSkin:GetTall() )

	self.m_pnlPrevSkin:SetSize( 32, 32 )
	self.m_pnlPrevSkin:SetPos( x -self.m_pnlPrevSkin:GetWide() -15, intH -self.m_pnlPrevSkin:GetTall() )

	--Colors
	self.m_pnlColorPicker:SetSize( 256, 128 )
	self.m_pnlColorPicker:SetPos( 0, 0 )

	--Bodygroups
	self.m_pnlBodyGroups:SetSize( 250, 32 )
	self.m_pnlBodyGroups:SetPos( intW -self.m_pnlBodyGroups:GetWide(), 0 )
end
vgui.Register( "SRPCopCarPreview", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetDeleteOnClose( false )

	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlCarPreview = vgui.Create( "SRPCopCarPreview", self )
	self.m_pnlCarPreview.m_tblParentMenu = self
	self.m_tblCards = {}

	self:AddSearchBar()

	self:SetTitle( "Police Car Spawn" )
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

	local cars = GAMEMODE.Cars:GetAllJobCars()
	for k, data in pairs( cars ) do
		if data.Job ~= "JOB_POLICE" then continue end
		self:CreateCarCard( k, data )
	end

	local cars = GAMEMODE.Cars:GetAllJobCars()
	for k, data in pairs( cars ) do
		if data.Job ~= "JOB_SWAT" then continue end
		self:CreateCarCard( k, data )
	end

	local cars = GAMEMODE.Cars:GetAllJobCars()
	for k, data in pairs( cars ) do
		if data.Job ~= "JOB_JUDGE" then continue end
		self:CreateCarCard( k, data )
	end

	local cars = GAMEMODE.Cars:GetAllJobCars()
	for k, data in pairs( cars ) do
		if data.Job ~= "JOB_MAYOR" then continue end
		self:CreateCarCard( k, data )
	end

	self:InvalidateLayout()
end

function Panel:CreateCarCard( k, tblData )
	local pnl = vgui.Create( "SRPCopCarCard" )
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

function Panel:OnClose()
	GAMEMODE.Net:SendNPCDialogEvent( "cop_spawn_car_end_dialog" )
end
vgui.Register( "SRPCopCarSpawn", Panel, "SRP_Frame" )