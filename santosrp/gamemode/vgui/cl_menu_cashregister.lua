--[[
	Name: cl_menu_cashregister.lua
	For: TalosLife
	By: TalosLife
]]--

local function ListItemForSale( entRegister, entItem, intAmount )
	GAMEMODE.Net:NewEvent( "ent", "creg_rs" )
		net.WriteEntity( entRegister )
		net.WriteEntity( entItem )
		net.WriteUInt( intAmount, 32 )
	GAMEMODE.Net:FireEvent()
end

local function UnlistItemForSale( entRegister, entItem )
	GAMEMODE.Net:NewEvent( "ent", "creg_ruls" )
		net.WriteEntity( entRegister )
		net.WriteEntity( entItem )
	GAMEMODE.Net:FireEvent()
end

local function TakeMoney( entRegister )
	GAMEMODE.Net:NewEvent( "ent", "creg_rtm" )
		net.WriteEntity( entRegister )
	GAMEMODE.Net:FireEvent()
end

local Panel = {}
function Panel:Init()
	self:SetTitle( "Cash Register" )
	self:SetDeleteOnClose( false )

	self.m_pnlInvLabel = vgui.Create( "DLabel", self )
	self.m_pnlInvLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlInvLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlInvLabel:SetFont( "Trebuchet24" )
	self.m_pnlInvLabel:SetText( "Nearby Items" )
	self.m_pnlInvLabel:SizeToContents()

	self.m_pnlChestLabel = vgui.Create( "DLabel", self )
	self.m_pnlChestLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlChestLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlChestLabel:SetFont( "Trebuchet24" )
	self.m_pnlChestLabel:SetText( "Listed Items" )
	self.m_pnlChestLabel:SizeToContents()

	self.m_pnlNearbyList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlNearbyList.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 100 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlForSaleList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlForSaleList.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 100 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlBtnTakeMoney = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnTakeMoney:SetFont( "CarMenuFont" )
	self.m_pnlBtnTakeMoney:SetText( "Take Money" )
	self.m_pnlBtnTakeMoney:SetAlpha( 150 )
	self.m_pnlBtnTakeMoney.DoClick = function()
		if not IsValid( self.m_entTarget ) then return end
		TakeMoney( self.m_entTarget )
	end

	self.m_tblNearbyItems = {}
	self.m_tblListedItems = {}
end

function Panel:SetEntity( eEnt )
	self.m_entTarget = eEnt
end

function Panel:SetMoney( intAmount )
	self.m_intMoney = intAmount
	self.m_pnlBtnTakeMoney:SetText( "$".. string.Comma(intAmount).. " - Take Money" )
end

function Panel:Populate( tblNearby, tblItemsListed )
	for k, v in pairs( self.m_tblNearbyItems ) do
		if ValidPanel( v ) then v:Remove() end
	end
	for k, v in pairs( self.m_tblListedItems ) do
		if ValidPanel( v ) then v:Remove() end
	end

	self.m_tblNearbyItems = {}
	self.m_tblListedItems = {}	
	self.m_tblCurContents = tblItemsListed

	for k, v in pairs( tblNearby ) do
		if not IsValid( v.Ent ) or not GAMEMODE.Inv:ValidItem( v.Name ) then continue end
		
		local pnl = vgui.Create( "SRPQMenuItemCard", self.m_pnlNearbyList )
		pnl.BuildTrayButtons = function( pnl )
			pnl.m_pnlBtnTray:Clear()
			if not pnl.m_tblItem then return end
			
			local takeBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )
			takeBtn:SetText( "List For Sale" )
			takeBtn.DoClick = function()
				GAMEMODE.Gui:StringRequest(
					"List Item",
					"Enter a price for this item",
					"",
					function( strText )
						if not IsValid( self.m_entTarget ) or not IsValid( v.Ent ) then return end
						if not tonumber( strText ) then return end
						ListItemForSale( self.m_entTarget, v.Ent, tonumber(strText) )
					end,
					function()
					end,
					"Submit",
					nil,
					10
				)
			end
			table.insert( pnl.m_tblTrayBtns, takeBtn )

			pnl.m_pnlBtnTray:InvalidateLayout()
		end
		pnl:SetItemID( v.Name )
		pnl:SetItemAmount( 1 )

		table.insert( self.m_tblNearbyItems, pnl )
	end

	for k, v in pairs( tblItemsListed or {} ) do
		if not GAMEMODE.Inv:ValidItem( v.Name ) then continue end
		
		local pnl = vgui.Create( "SRPQMenuItemCard", self.m_pnlForSaleList )
		pnl.BuildTrayButtons = function( pnl )
			pnl.m_pnlBtnTray:Clear()
			if not pnl.m_tblItem then return end
			
			local takeBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )
			takeBtn:SetText( "Un-list Item" )
			takeBtn.DoClick = function()
				if not IsValid( self.m_entTarget ) or not IsValid( v.Ent ) then return end
				UnlistItemForSale( self.m_entTarget, v.Ent )
			end

			table.insert( pnl.m_tblTrayBtns, takeBtn )
			pnl.m_pnlBtnTray:InvalidateLayout()
		end
		pnl:SetItemPrice( v.Price )
		pnl:SetItemID( v.Name )

		table.insert( self.m_tblListedItems, pnl )
	end

	self:InvalidateLayout()
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )
	local half = intW /2

	self.m_pnlInvLabel:SetPos( 5, 28 )
	self.m_pnlChestLabel:SetPos( intW -self.m_pnlChestLabel:GetWide() -5, 28 )

	self.m_pnlBtnTakeMoney:SetSize( intW, 32 )
	self.m_pnlBtnTakeMoney:SetPos( 0, intH -self.m_pnlBtnTakeMoney:GetTall() )

	self.m_pnlNearbyList:SetSize( half, intH -28 -self.m_pnlInvLabel:GetTall() -self.m_pnlBtnTakeMoney:GetTall() )
	self.m_pnlNearbyList:SetPos( 0, 28 +self.m_pnlInvLabel:GetTall() )

	self.m_pnlForSaleList:SetSize( half, intH -28 -self.m_pnlInvLabel:GetTall() -self.m_pnlBtnTakeMoney:GetTall() )
	self.m_pnlForSaleList:SetPos( 0 +half, 28 +self.m_pnlInvLabel:GetTall() )

	for _, pnl in pairs( self.m_tblNearbyItems ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 48 )
		pnl:Dock( TOP )
	end

	for _, pnl in pairs( self.m_tblListedItems ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 48 )
		pnl:Dock( TOP )
	end
end

function Panel:Open()
	self:Refresh()
	self:SetVisible( true )
	self:MakePopup()
end
vgui.Register( "SRPCashRegisterMenu", Panel, "SRP_Frame" )