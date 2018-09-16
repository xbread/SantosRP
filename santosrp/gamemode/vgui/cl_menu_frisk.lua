
-----------------------------------------------------
--[[
	Name: cl_menu_frisk.lua
	For: SantosRP
	By: Ultra
]]--

local Panel = {}
function Panel:Init()
	self:SetTitle( "" )
	self:SetDeleteOnClose( false )

	self.m_pnlInvLabel = vgui.Create( "DLabel", self )
	self.m_pnlInvLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlInvLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlInvLabel:SetFont( "Trebuchet24" )
	self.m_pnlInvLabel:SetText( "Inventory" )
	self.m_pnlInvLabel:SizeToContents()

	self.m_pnlQueueLabel = vgui.Create( "DLabel", self )
	self.m_pnlQueueLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlQueueLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlQueueLabel:SetFont( "Trebuchet24" )
	self.m_pnlQueueLabel:SetText( "Queue" )
	self.m_pnlQueueLabel:SizeToContents()

	self.m_pnlInventoryList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlInventoryList.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 100 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlQueueList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlQueueList.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 100 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlBtnTake = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnTake:SetText( "Drop Items" )
	self.m_pnlBtnTake.DoClick = function()
		self:DropItems()
		self.m_tblQueueList = {}
	end

	self.m_pnlBtnID = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnID:SetText( "Show ID" )

	self.m_tblInvItems = {}
	self.m_tblQueueItems = {}

	self.m_tblInventoryList = {}
	self.m_tblQueueList = {}

	self.m_wepIDCard = weapons.Get( "weapon_idcard" )
	self.m_wepIDCard:InitializeSpawnIcon()
	self.m_wepIDCard.SpawnIcon:SetParent( self )
	self.m_wepIDCard.SpawnIcon:SetMouseInputEnabled( false )
	self.m_wepIDCard.SpawnIcon:SetKeyBoardInputEnabled( false )
	self.m_wepIDCard.SpawnIcon:MoveToBack()
end

function Panel:OnRemove()
	if ValidPanel( self.m_wepIDCard.SpawnIcon ) then
		self.m_wepIDCard.SpawnIcon:Remove()
	end
end

function Panel:PaintOver( intW, intH )
	if not IsValid( self.m_pFrisking ) then return end
	if self.m_pnlBtnID.Depressed then
		self.m_wepIDCard:drawIDInfo( self.m_pFrisking )
	end
end

function Panel:Update( pFrisking, tblItems )
	self.m_tblInventoryList = tblItems
	self.m_pFrisking = pFrisking
	self:SetTitle( ("%s's Inventory"):format(self.m_pFrisking:Nick()) )

	if ValidPanel( self.m_wepIDCard.SpawnIcon ) then
		self.m_wepIDCard.SpawnIcon:SetModel( pFrisking:GetModel() )
	end
	
	if not self.m_tblQueueList then
		self.m_tblQueueList = {}
	else
		for k, v in pairs( self.m_tblQueueList ) do
			if not tblItems[k] or tblItems[k] < v then
				self.m_tblQueueList[k] = nil
			else
				tblItems[k] = tblItems[k] -v
				if tblItems[k] <= 0 then
					tblItems[k] = nil
				end
			end
		end
	end

	self:Refresh()
end

function Panel:Refresh()
	for k, v in pairs( self.m_tblInvItems ) do
		if ValidPanel( v ) then v:Remove() end
	end
	for k, v in pairs( self.m_tblQueueItems ) do
		if ValidPanel( v ) then v:Remove() end
	end

	self.m_tblInvItems = {}
	self.m_tblQueueItems = {}

	for k, v in pairs( self.m_tblInventoryList ) do
		if not GAMEMODE.Inv:ValidItem( k ) then continue end
		local data = GAMEMODE.Inv:GetItem( k )

		local pnl = vgui.Create( "SRPQMenuItemCard", self.m_pnlInventoryList )
		pnl.BuildTrayButtons = function( pnl )
			pnl.m_pnlBtnTray:Clear()
			if not pnl.m_tblItem then return end
			
			if not data.JobItem then
				local takeBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )
				takeBtn:SetText( "Move To Queue" )
				takeBtn.DoClick = function()
					self:AddToQueue( k, 1 )
				end
				takeBtn.DoRightClick = function()
					local dMenu = DermaMenu()
					dMenu:AddOption( "Move 5", function() self:AddToQueue( k, 5 ) end )
					dMenu:AddOption( "Move 10", function() self:AddToQueue( k, 10 ) end )
					dMenu:AddOption( "Move 15", function() self:AddToQueue( k, 15 ) end )
					dMenu:AddOption( "Move 25", function() self:AddToQueue( k, 25 ) end )
					dMenu:AddOption( "Move 50", function() self:AddToQueue( k, 50 ) end )
					dMenu:AddOption( "Move All", function() self:AddToQueue( k, v ) end )
					dMenu:Open()
				end
				table.insert( pnl.m_tblTrayBtns, takeBtn )
			end

			local destroyBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )
			destroyBtn:SetText( "Destroy" )
			destroyBtn.DoClick = function()
				self:DestroyItem( k, 1 )
			end
			destroyBtn.DoRightClick = function()
				local dMenu = DermaMenu()
				dMenu:AddOption( "Destroy 5", function() self:DestroyItem( k, 5 ) end )
				dMenu:AddOption( "Destroy 10", function() self:DestroyItem( k, 10 ) end )
				dMenu:AddOption( "Destroy 15", function() self:DestroyItem( k, 15 ) end )
				dMenu:AddOption( "Destroy 25", function() self:DestroyItem( k, 25 ) end )
				dMenu:AddOption( "Destroy 50", function() self:DestroyItem( k, 50 ) end )
				dMenu:AddOption( "Destroy All", function() self:DestroyItem( k, v ) end )
				dMenu:Open()
			end
			table.insert( pnl.m_tblTrayBtns, destroyBtn )

			pnl.m_pnlBtnTray:InvalidateLayout()
		end
		pnl:SetItemID( k )
		pnl:SetItemAmount( v )

		table.insert( self.m_tblInvItems, pnl )
	end

	for k, v in pairs( self.m_tblQueueList or {} ) do
		if not GAMEMODE.Inv:ValidItem( k ) then continue end
		
		local pnl = vgui.Create( "SRPQMenuItemCard", self.m_pnlQueueList )
		pnl.BuildTrayButtons = function( pnl )
			pnl.m_pnlBtnTray:Clear()
			if not pnl.m_tblItem then return end
			
			local takeBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )
			takeBtn:SetText( "Remove" )
			takeBtn.DoClick = function()
				self:RemoveFromQueue( k, 1 )
			end
			takeBtn.DoRightClick = function()
				local dMenu = DermaMenu()
				dMenu:AddOption( "Remove 5", function() self:RemoveFromQueue( k, 5 ) end )
				dMenu:AddOption( "Remove 10", function() self:RemoveFromQueue( k, 10 ) end )
				dMenu:AddOption( "Remove 15", function() self:RemoveFromQueue( k, 15 ) end )
				dMenu:AddOption( "Remove 25", function() self:RemoveFromQueue( k, 25 ) end )
				dMenu:AddOption( "Remove 50", function() self:RemoveFromQueue( k, 50 ) end )
				dMenu:AddOption( "Remove All", function() self:RemoveFromQueue( k, 50 ) end )
				dMenu:Open()
			end
			table.insert( pnl.m_tblTrayBtns, takeBtn )

			pnl.m_pnlBtnTray:InvalidateLayout()
		end
		pnl:SetItemID( k )
		pnl:SetItemAmount( v )

		table.insert( self.m_tblQueueItems, pnl )
	end

	self:InvalidateLayout()
end

function Panel:AddToQueue( strItemID, intAmount )
	if self.m_tblInventoryList[strItemID] then
		local amt = math.min( self.m_tblInventoryList[strItemID], intAmount )
		self.m_tblQueueList[strItemID] = (self.m_tblQueueList[strItemID] or 0) +amt

		self.m_tblInventoryList[strItemID] = self.m_tblInventoryList[strItemID] -amt
		if self.m_tblInventoryList[strItemID] <= 0 then
			self.m_tblInventoryList[strItemID] = nil
		end
	end

	self:Refresh()
end

function Panel:RemoveFromQueue( strItemID, intAmount )
	if self.m_tblQueueList[strItemID] then
		local amt = math.min( self.m_tblQueueList[strItemID], intAmount )
		self.m_tblInventoryList[strItemID] = (self.m_tblInventoryList[strItemID] or 0) +amt

		self.m_tblQueueList[strItemID] = self.m_tblQueueList[strItemID] -amt
		if self.m_tblQueueList[strItemID] <= 0 then
			self.m_tblQueueList[strItemID] = nil
		end
	end

	self:Refresh()
end

function Panel:DestroyItem( strItemID, intAmount )
	net.Start( "gm_frisk" )
		net.WriteUInt( 3, 8 )
		net.WriteString( strItemID )
		net.WriteUInt( intAmount, 32 )
	net.SendToServer()
end

function Panel:DropItems()
	net.Start( "gm_frisk" )
		net.WriteUInt( 2, 8 )
		net.WriteUInt( table.Count(self.m_tblQueueList), 16 )
		for k, v in pairs( self.m_tblQueueList ) do
			net.WriteString( k )
			net.WriteUInt( v, 32 )
		end
	net.SendToServer()
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )
	local padding = 0
	local half = intW /2

	self.m_pnlInvLabel:SetPos( 5, 28 )
	self.m_pnlQueueLabel:SetPos( intW -self.m_pnlQueueLabel:GetWide() -5, 28 )

	self.m_pnlInventoryList:SetSize( half -(padding *2), intH -28 -self.m_pnlInvLabel:GetTall() -padding -25 )
	self.m_pnlInventoryList:SetPos( padding, 28 +self.m_pnlInvLabel:GetTall() +padding )

	self.m_pnlBtnID:SetSize( self.m_pnlInventoryList:GetWide(), 25 )
	self.m_pnlBtnID:SetPos( padding, intH -self.m_pnlBtnID:GetTall() )

	self.m_pnlQueueList:SetSize( half -(padding *2), intH -28 -self.m_pnlInvLabel:GetTall() -padding -25 )
	self.m_pnlQueueList:SetPos( padding +half, 28 +self.m_pnlInvLabel:GetTall() +padding )

	self.m_pnlBtnTake:SetSize( self.m_pnlQueueList:GetWide(), 25 )
	self.m_pnlBtnTake:SetPos( padding +half, intH -self.m_pnlBtnTake:GetTall() )

	for _, pnl in pairs( self.m_tblInvItems ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 48 )
		pnl:Dock( TOP )
	end

	for _, pnl in pairs( self.m_tblQueueItems ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 48 )
		pnl:Dock( TOP )
	end
end

function Panel:Open()
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:OnClose()
	self.m_tblQueueList = {}

	net.Start( "gm_frisk" )
		net.WriteUInt( 0, 8 )
	net.SendToServer()
end
vgui.Register( "SRPFriskMenu", Panel, "SRP_Frame" )