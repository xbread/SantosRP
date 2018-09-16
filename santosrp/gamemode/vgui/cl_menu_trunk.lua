--[[
	Name: cl_menu_trunk.lua
	
		
]]--

local Panel = {}
function Panel:Init()
	self:SetTitle( "Trunk Storage" )
	self:SetDeleteOnClose( false )

	self.m_pnlInvLabel = vgui.Create( "DLabel", self )
	self.m_pnlInvLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlInvLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlInvLabel:SetFont( "Trebuchet24" )
	self.m_pnlInvLabel:SetText( "Inventory" )
	self.m_pnlInvLabel:SizeToContents()

	self.m_pnlBankLabel = vgui.Create( "DLabel", self )
	self.m_pnlBankLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlBankLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlBankLabel:SetFont( "Trebuchet24" )
	self.m_pnlBankLabel:SetText( "Car Trunk" )
	self.m_pnlBankLabel:SizeToContents()

	self.m_pnlInventoryList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlInventoryList.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 100 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlBankList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlBankList.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 100 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_tblInvItems = {} 
	self.m_tblTrunkItems = {}

	hook.Add( "GamemodeOnGetTrunkUpdate", "TrunkMenu", function()
		if not ValidPanel( self ) or not self:IsVisible() then return end
		self:Refresh(self.m_eCar)
	end )
end

function Panel:Refresh(eCar)
	for k, v in pairs( self.m_tblInvItems ) do
		if ValidPanel( v ) then v:Remove() end
	end
	for k, v in pairs( self.m_tblTrunkItems ) do
		if ValidPanel( v ) then v:Remove() end
	end

	self.m_tblInvItems = {}
	self.m_tblTrunkItems = {}	

	for k, v in pairs( LocalPlayer():GetInventory() ) do
		if not GAMEMODE.Inv:ValidItem( k ) then continue end
		-- if GAMEMODE.Inv:GetItem( k ).JobItem then continue end
		
		local pnl = vgui.Create( "SRPQMenuItemCard", self.m_pnlInventoryList )
		pnl.BuildTrayButtons = function( pnl )
			pnl.m_pnlBtnTray:Clear()
			if not pnl.m_tblItem then return end
			
			local takeBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )
			takeBtn:SetText( "Move To Trunk" )
			takeBtn.DoClick = function()
				GAMEMODE.Net:MoveItemToTrunk( eCar:EntIndex(), k, 1 )
			end
			takeBtn.DoRightClick = function()
				local dMenu = DermaMenu()
				dMenu:AddOption( "Move 5", function() GAMEMODE.Net:MoveItemToTrunk( eCar:EntIndex(), k, 5 ) end )
				dMenu:AddOption( "Move 10", function() GAMEMODE.Net:MoveItemToTrunk( eCar:EntIndex(), k, 10 ) end )
				dMenu:AddOption( "Move 15", function() GAMEMODE.Net:MoveItemToTrunk( eCar:EntIndex(), k, 15 ) end )
				dMenu:AddOption( "Move 25", function() GAMEMODE.Net:MoveItemToTrunk( eCar:EntIndex(), k, 25 ) end )
				dMenu:AddOption( "Move 50", function() GAMEMODE.Net:MoveItemToTrunk( eCar:EntIndex(), k, 50 ) end )
				dMenu:Open()
			end
			table.insert( pnl.m_tblTrayBtns, takeBtn )

			pnl.m_pnlBtnTray:InvalidateLayout()
		end
		pnl:SetItemID( k )
		pnl:SetItemAmount( v )

		table.insert( self.m_tblInvItems, pnl )
	end

	for k, v in pairs( eCar.TrunkItems or {} ) do
		if not GAMEMODE.Inv:ValidItem( k ) then continue end
		
		local pnl = vgui.Create( "SRPQMenuItemCard", self.m_pnlBankList )
		pnl.BuildTrayButtons = function( pnl )
			pnl.m_pnlBtnTray:Clear()
			if not pnl.m_tblItem then return end
			
			local takeBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )
			takeBtn:SetText( "Move To Inventory" )
			takeBtn.DoClick = function()
				GAMEMODE.Net:TakeItemFromTrunk( eCar:EntIndex(), k, 1 )
			end
			takeBtn.DoRightClick = function()
				local dMenu = DermaMenu()
				dMenu:AddOption( "Move 5", function() GAMEMODE.Net:TakeItemFromTrunk( eCar:EntIndex(), k, 5 ) end )
				dMenu:AddOption( "Move 10", function() GAMEMODE.Net:TakeItemFromTrunk( eCar:EntIndex(), k, 10 ) end )
				dMenu:AddOption( "Move 15", function() GAMEMODE.Net:TakeItemFromTrunk( eCar:EntIndex(), k, 15 ) end )
				dMenu:AddOption( "Move 25", function() GAMEMODE.Net:TakeItemFromTrunk( eCar:EntIndex(), k, 25 ) end )
				dMenu:AddOption( "Move 50", function() GAMEMODE.Net:TakeItemFromTrunk( eCar:EntIndex(), k, 50 ) end )
				dMenu:Open()
			end
			table.insert( pnl.m_tblTrayBtns, takeBtn )

			pnl.m_pnlBtnTray:InvalidateLayout()
		end
		pnl:SetItemID( k )
		pnl:SetItemAmount( v )

		table.insert( self.m_tblTrunkItems, pnl )
	end

	self:InvalidateLayout()
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )
	local padding = 0
	local half = intW /2

	self.m_pnlInvLabel:SetPos( 5, 28 )
	self.m_pnlBankLabel:SetPos( intW -self.m_pnlBankLabel:GetWide() -5, 28 )

	self.m_pnlInventoryList:SetSize( half -(padding *2), intH -28 -self.m_pnlInvLabel:GetTall() -padding )
	self.m_pnlInventoryList:SetPos( padding, 28 +self.m_pnlInvLabel:GetTall() +padding )

	self.m_pnlBankList:SetSize( half -(padding *2), intH -28 -self.m_pnlInvLabel:GetTall() -padding )
	self.m_pnlBankList:SetPos( padding +half, 28 +self.m_pnlInvLabel:GetTall() +padding )

	for _, pnl in pairs( self.m_tblInvItems ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 48 )
		pnl:Dock( TOP )
	end

	for _, pnl in pairs( self.m_tblTrunkItems ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 48 )
		pnl:Dock( TOP )
	end
end

function Panel:Open(eCar)
	self.m_eCar = eCar
	self:Refresh(eCar)
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:OnClose()
end
vgui.Register( "SRPTrunkStorageMenu", Panel, "SRP_Frame" )