
-----------------------------------------------------
--[[

	Name: cl_menu_bank_storage.lua

	For: SantosRP

	By: Ultra

]]--



local Panel = {}

function Panel:Init()

	self:SetTitle( "Bank Storage" )

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

	self.m_pnlBankLabel:SetText( "Bank Storage" )

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

	self.m_tblBankItems = {}



	hook.Add( "GamemodeOnGetBankUpdate", "BankMenu", function()

		if not ValidPanel( self ) or not self:IsVisible() then return end

		self:Refresh()

	end )

end



function Panel:Refresh()

	for k, v in pairs( self.m_tblInvItems ) do

		if ValidPanel( v ) then v:Remove() end

	end

	for k, v in pairs( self.m_tblBankItems ) do

		if ValidPanel( v ) then v:Remove() end

	end



	self.m_tblInvItems = {}

	self.m_tblBankItems = {}	



	for k, v in pairs( LocalPlayer():GetInventory() ) do

		if not GAMEMODE.Inv:ValidItem( k ) then continue end

		if GAMEMODE.Inv:GetItem( k ).JobItem then continue end

		

		local pnl = vgui.Create( "SRPQMenuItemCard", self.m_pnlInventoryList )

		pnl.BuildTrayButtons = function( pnl )

			pnl.m_pnlBtnTray:Clear()

			if not pnl.m_tblItem then return end

			

			local takeBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )

			takeBtn:SetText( "Move To Bank" )

			takeBtn.DoClick = function()

				GAMEMODE.Net:MoveItemToNPCBank( k, 1 )

			end

			takeBtn.DoRightClick = function()

				local dMenu = DermaMenu()

				dMenu:AddOption( "Move 5", function() GAMEMODE.Net:MoveItemToNPCBank( k, 5 ) end )

				dMenu:AddOption( "Move 10", function() GAMEMODE.Net:MoveItemToNPCBank( k, 10 ) end )

				dMenu:AddOption( "Move 15", function() GAMEMODE.Net:MoveItemToNPCBank( k, 15 ) end )

				dMenu:AddOption( "Move 25", function() GAMEMODE.Net:MoveItemToNPCBank( k, 25 ) end )

				dMenu:AddOption( "Move 50", function() GAMEMODE.Net:MoveItemToNPCBank( k, 50 ) end )

				dMenu:Open()

			end

			table.insert( pnl.m_tblTrayBtns, takeBtn )



			pnl.m_pnlBtnTray:InvalidateLayout()

		end

		pnl:SetItemID( k )

		pnl:SetItemAmount( v )



		table.insert( self.m_tblInvItems, pnl )

	end



	for k, v in pairs( GAMEMODE.m_tblBankItems or {} ) do

		if not GAMEMODE.Inv:ValidItem( k ) then continue end

		

		local pnl = vgui.Create( "SRPQMenuItemCard", self.m_pnlBankList )

		pnl.BuildTrayButtons = function( pnl )

			pnl.m_pnlBtnTray:Clear()

			if not pnl.m_tblItem then return end

			

			local takeBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )

			takeBtn:SetText( "Move To Inventory" )

			takeBtn.DoClick = function()

				GAMEMODE.Net:TakeItemFromBank( k, 1 )

			end

			takeBtn.DoRightClick = function()

				local dMenu = DermaMenu()

				dMenu:AddOption( "Move 5", function() GAMEMODE.Net:TakeItemFromBank( k, 5 ) end )

				dMenu:AddOption( "Move 10", function() GAMEMODE.Net:TakeItemFromBank( k, 10 ) end )

				dMenu:AddOption( "Move 15", function() GAMEMODE.Net:TakeItemFromBank( k, 15 ) end )

				dMenu:AddOption( "Move 25", function() GAMEMODE.Net:TakeItemFromBank( k, 25 ) end )

				dMenu:AddOption( "Move 50", function() GAMEMODE.Net:TakeItemFromBank( k, 50 ) end )

				dMenu:Open()

			end

			table.insert( pnl.m_tblTrayBtns, takeBtn )



			pnl.m_pnlBtnTray:InvalidateLayout()

		end

		pnl:SetItemID( k )

		pnl:SetItemAmount( v )



		table.insert( self.m_tblBankItems, pnl )

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



	for _, pnl in pairs( self.m_tblBankItems ) do

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



function Panel:OnClose()

	GAMEMODE.Net:SendNPCDialogEvent( "bank_storage_end_dialog" )

end

vgui.Register( "SRPBankStorageMenu", Panel, "SRP_Frame" )