--[[
	Name: cl_menu_storagechest.lua
	For: TalosLife
	By: TalosLife
]]--

local function MoveToInventory( eEnt, strItemID, intAmount )
	GAMEMODE.Net:NewEvent( "ent", "str_chst_t" )
		net.WriteEntity( eEnt )
		net.WriteString( strItemID )
		net.WriteUInt( intAmount, 16 )
	GAMEMODE.Net:FireEvent()
end

local function MoveToContainer( eEnt, strItemID, intAmount )
	GAMEMODE.Net:NewEvent( "ent", "str_chst_a" )
		net.WriteEntity( eEnt )
		net.WriteString( strItemID )
		net.WriteUInt( intAmount, 16 )
	GAMEMODE.Net:FireEvent()
end

local Panel = {}
function Panel:Init()
	self:SetTitle( "Storage Container" )
	self:SetDeleteOnClose( false )

	self.m_pnlInvLabel = vgui.Create( "DLabel", self )
	self.m_pnlInvLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlInvLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlInvLabel:SetFont( "Trebuchet24" )
	self.m_pnlInvLabel:SetText( "Inventory" )
	self.m_pnlInvLabel:SizeToContents()

	self.m_pnlChestLabel = vgui.Create( "DLabel", self )
	self.m_pnlChestLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlChestLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlChestLabel:SetFont( "Trebuchet24" )
	self.m_pnlChestLabel:SetText( "Storage Chest" )
	self.m_pnlChestLabel:SizeToContents()

	self.m_pnlInventoryList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlInventoryList.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 100 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlChestList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlChestList.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 100 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlVolumeBar = vgui.Create( "SRP_Progress", self )
	self.m_pnlVolumeBar:SetBarColor( Color(200, 90, 40, 255) )
	self.m_pnlVolumeBar.Think = function()
		if not IsValid( self.m_entTarget ) or not self.m_tblCurContents then return end
		self.m_pnlVolumeBar:SetFraction( GAMEMODE.Inv:ComputeVolume( self.m_tblCurContents ) /self.m_entTarget:GetMaxVolume() )
	end
	self.m_pnlVolumeBar.PaintOver = function( _, intW, intH )
		draw.SimpleTextOutlined(
			"Volume",
			"EquipSlotFont",
			5, intH /2,
			color_white,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)

		if not IsValid( self.m_entTarget ) or not self.m_tblCurContents then return end
		draw.SimpleTextOutlined(
			"(".. GAMEMODE.Inv:ComputeVolume( self.m_tblCurContents ).. "/".. self.m_entTarget:GetMaxVolume().. ")",
			"EquipSlotFont",
			intW -5, intH /2,
			color_white,
			TEXT_ALIGN_RIGHT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)
	end

	self.m_tblInvItems = {}
	self.m_tblChestItems = {}
end

function Panel:SetEntity( eEnt )
	self.m_entTarget = eEnt
end

function Panel:Populate( tblItems )
	for k, v in pairs( self.m_tblInvItems ) do
		if ValidPanel( v ) then v:Remove() end
	end
	for k, v in pairs( self.m_tblChestItems ) do
		if ValidPanel( v ) then v:Remove() end
	end

	self.m_tblInvItems = {}
	self.m_tblChestItems = {}	
	self.m_tblCurContents = tblItems

	for k, v in pairs( LocalPlayer():GetInventory() ) do
		if not GAMEMODE.Inv:ValidItem( k ) then continue end
		if GAMEMODE.Inv:GetItem( k ).JobItem then continue end
		
		local pnl = vgui.Create( "SRPQMenuItemCard", self.m_pnlInventoryList )
		pnl.BuildTrayButtons = function( pnl )
			pnl.m_pnlBtnTray:Clear()
			if not pnl.m_tblItem then return end
			
			local takeBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )
			takeBtn:SetText( "Move To Container" )
			takeBtn.DoClick = function()
				MoveToContainer( self.m_entTarget, k, 1 )
			end
			takeBtn.DoRightClick = function()
				local dMenu = DermaMenu()
				dMenu:AddOption( "Move 5", function() MoveToContainer( self.m_entTarget, k, 5 ) end )
				dMenu:AddOption( "Move 10", function() MoveToContainer( self.m_entTarget, k, 10 ) end )
				dMenu:AddOption( "Move 15", function() MoveToContainer( self.m_entTarget, k, 15 ) end )
				dMenu:AddOption( "Move 25", function() MoveToContainer( self.m_entTarget, k, 25 ) end )
				dMenu:AddOption( "Move 50", function() MoveToContainer( self.m_entTarget, k, 50 ) end )
				dMenu:Open()
			end
			table.insert( pnl.m_tblTrayBtns, takeBtn )

			pnl.m_pnlBtnTray:InvalidateLayout()
		end
		pnl:SetItemID( k )
		pnl:SetItemAmount( v )

		table.insert( self.m_tblInvItems, pnl )
	end

	for k, v in pairs( tblItems or {} ) do
		if not GAMEMODE.Inv:ValidItem( k ) then continue end
		
		local pnl = vgui.Create( "SRPQMenuItemCard", self.m_pnlChestList )
		pnl.BuildTrayButtons = function( pnl )
			pnl.m_pnlBtnTray:Clear()
			if not pnl.m_tblItem then return end
			
			local takeBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )
			takeBtn:SetText( "Move To Inventory" )
			takeBtn.DoClick = function()
				MoveToInventory( self.m_entTarget, k, 1 )
			end
			takeBtn.DoRightClick = function()
				local dMenu = DermaMenu()
				dMenu:AddOption( "Move 5", function() MoveToInventory( self.m_entTarget, k, 5 ) end )
				dMenu:AddOption( "Move 10", function() MoveToInventory( self.m_entTarget, k, 10 ) end )
				dMenu:AddOption( "Move 15", function() MoveToInventory( self.m_entTarget, k, 15 ) end )
				dMenu:AddOption( "Move 25", function() MoveToInventory( self.m_entTarget, k, 25 ) end )
				dMenu:AddOption( "Move 50", function() MoveToInventory( self.m_entTarget, k, 50 ) end )
				dMenu:Open()
			end
			table.insert( pnl.m_tblTrayBtns, takeBtn )

			local destroyBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )
			destroyBtn:SetText( "Destroy" )
			destroyBtn.DoClick = function()
				GAMEMODE.Gui:Derma_Query(
					"Are you sure you want to destroy this item?",
					"Destroy Item",
					"Ok",
					function()
						GAMEMODE.Net:NewEvent( "ent", "str_chst_d" )
							net.WriteEntity( self.m_entTarget )
							net.WriteString( k )
						GAMEMODE.Net:FireEvent()
					end,
					"Cancel",
					function() end
				)
			end
			table.insert( pnl.m_tblTrayBtns, destroyBtn )

			pnl.m_pnlBtnTray:InvalidateLayout()
		end
		pnl:SetItemID( k )
		pnl:SetItemAmount( v )

		table.insert( self.m_tblChestItems, pnl )
	end

	self:InvalidateLayout()
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )
	local padding = 0
	local half = intW /2

	self.m_pnlInvLabel:SetPos( 5, 28 )
	self.m_pnlChestLabel:SetPos( intW -self.m_pnlChestLabel:GetWide() -5, 28 )

	self.m_pnlVolumeBar:SetSize( intW, 20 )
	self.m_pnlVolumeBar:SetPos( 0, intH -self.m_pnlVolumeBar:GetTall() )

	self.m_pnlInventoryList:SetSize( half -(padding *2), intH -28 -self.m_pnlInvLabel:GetTall() -padding -self.m_pnlVolumeBar:GetTall() )
	self.m_pnlInventoryList:SetPos( padding, 28 +self.m_pnlInvLabel:GetTall() +padding )

	self.m_pnlChestList:SetSize( half -(padding *2), intH -28 -self.m_pnlInvLabel:GetTall() -padding -padding -self.m_pnlVolumeBar:GetTall() )
	self.m_pnlChestList:SetPos( padding +half, 28 +self.m_pnlInvLabel:GetTall() +padding )

	for _, pnl in pairs( self.m_tblInvItems ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 48 )
		pnl:Dock( TOP )
	end

	for _, pnl in pairs( self.m_tblChestItems ) do
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
vgui.Register( "SRPStorageChestMenu", Panel, "SRP_Frame" )