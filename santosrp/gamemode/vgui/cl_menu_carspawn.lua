--[[
	Name: cl_menu_carspawn.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_colSold = Color( 255, 50, 50, 255 )
	self.m_colSell = Color( 50, 255, 50, 255 )
	self.m_colPrice = Color( 120, 230, 110, 255 )

	self.m_pnlIcon = vgui.Create( "ModelImage", self )

	self.m_pnlGetBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlGetBtn:SetFont( "CarMenuFont" )
	self.m_pnlGetBtn:SetText( "Retrieve" )
	self.m_pnlGetBtn:SetAlpha( 150 )
	self.m_pnlGetBtn.DoClick = function()
		if not self.m_tblCar then return end
		local car = LocalPlayer():GetNWEntity( "CurrentCar" )

		if IsValid( car ) and car:GetModel() == self.m_tblCar.Model then
			GAMEMODE.Net:RequestStowCar( self.m_tblCar.UID )
		else
			GAMEMODE.Net:RequestSpawnCar( self.m_tblCar.UID )
		end
	end

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "CarMenuFont" )
end

function Panel:Think()
	if not self.m_tblCar then return end
	local car = LocalPlayer():GetNWEntity( "CurrentCar" )
	self.m_pnlGetBtn:SetText( (IsValid(car) and car:GetModel() == self.m_tblCar.Model) and "Store" or "Retrieve" )
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

function Panel:PerformLayout( intW, intH )
	local padding = 5

	self.m_pnlIcon:SetPos( 0, 0 )
	self.m_pnlIcon:SetSize( intH, intH )

	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetWide( intW )
	self.m_pnlNameLabel:SetPos( (padding *2) +intH, (intH /2) -(self.m_pnlNameLabel:GetTall() /2) )

	self.m_pnlGetBtn:SetSize( 110, intH )
	self.m_pnlGetBtn:SetPos( intW -self.m_pnlGetBtn:GetWide(), 0 )
end
vgui.Register( "SRPCarSpawnCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetDeleteOnClose( false )
	self:SetTitle( "Vehicle Spawn" )
	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )
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

function Panel:Populate()
	for k, v in pairs( self.m_tblCards ) do
		if ValidPanel( v ) then v:Remove() end
		self.m_tblCards[k] = nil
	end

	local cars = GAMEMODE.Cars:GetAllCarsByUID()
	local playerCars = GAMEMODE.Player:GetGameVar( "vehicles", {} )
	for k, data in SortedPairsByMemberValue(cars, "Price", false) do
		if not playerCars[data.UID] then continue end
		self:CreateCarCard( k, data )
	end

	self:InvalidateLayout()
end

function Panel:CreateCarCard( k, tblData )
	local pnl = vgui.Create( "SRPCarSpawnCard" )
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
	GAMEMODE.Net:SendNPCDialogEvent( "car_spawn_end_dialog" )
end
vgui.Register( "SRPCarSpawn", Panel, "SRP_Frame" )