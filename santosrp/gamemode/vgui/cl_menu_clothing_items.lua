--[[
	Name: cl_menu_clothing_items.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_pnlIcon = vgui.Create( "ModelImage", self )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "CarMenuFont" )
	self.m_pnlNameLabel:SetText( " " )

	self.m_pnlDescLabel = vgui.Create( "DLabel", self )
	self.m_pnlDescLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlDescLabel:SetTextColor( Color(230, 230, 230, 255) )
	self.m_pnlDescLabel:SetFont( "Trebuchet24" )
	self.m_pnlDescLabel:SetText( " " )

	self.m_pnlItemList = vgui.Create( "DHorizontalScroller", self )
	self.m_tblItemIcons = {}
end

function Panel:SetItemData( strDisplayName, tblRootItem, tblSubItems )
	self.m_tblSubItems = tblSubItems or {}
	self.m_strModel = tblRootItem.Model
	self.m_intSkin = tblRootItem.Skin

	self.m_pnlIcon:SetSize( self:GetTall(), self:GetTall() )
	self.m_pnlIcon:SetModel( self.m_strModel, self.m_intSkin )

	self.m_pnlNameLabel:SetText( strDisplayName )
	self.m_pnlDescLabel:SetText( table.Count(self.m_tblSubItems).. " Option(s)." )
	self:Populate()
end

function Panel:Populate()
	for k, v in pairs( self.m_tblItemIcons ) do
		if ValidPanel( v ) then v:Remove() end
	end

	self.m_pnlItemList.Panels = {}
	self.m_tblItemIcons = {}

	for k, v in SortedPairsByMemberValue( self.m_tblSubItems, "Skin" ) do
		local btn = vgui.Create( "SpawnIcon", self.m_pnlItemList )
		btn:SetSize( self:GetTall() *0.75, self:GetTall() *0.75 )
		btn:SetModel( v.Model, v.Skin )
		btn:SetTooltip( v.Name )
		btn.DoClick = function()
			self:GetParent().m_pnlItemBuy:SetSelectedItem( v )
			self:GetParent():PreviewPart( v.EquipSlot, v.PacOutfit )
		end
		self.m_pnlItemList:AddPanel( btn )
		table.insert( self.m_tblItemIcons, btn )
	end

	self:InvalidateLayout()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 60, 60, 60, 200 )
	surface.DrawRect( 0, 0, intW, intH )

	local iw, ih = self.m_pnlIcon:GetSize()
	surface.SetDrawColor( 75, 75, 75, 150 )
	surface.DrawRect( 0, 0, iw, ih )

	local x, y = self.m_pnlItemList:GetPos()
	local w, h = self.m_pnlItemList:GetSize()
	surface.SetDrawColor( 30, 30, 30, 100 )
	surface.DrawRect( x, y +3, w, h +5 )
end

function Panel:PerformLayout( intW, intH )
	local padding = 5
	self.m_pnlIcon:SetPos( 0, 0 )
	self.m_pnlIcon:SetSize( intH, intH )

	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( (padding *2) +intH, 0 )

	local _, h = self.m_pnlNameLabel:GetSize()
	self.m_pnlDescLabel:SizeToContents()
	self.m_pnlDescLabel:SetPos( (padding *2) +intH +self.m_pnlNameLabel:GetWide() +10, h -self.m_pnlDescLabel:GetTall() )

	self.m_pnlItemList:SetPos( intH, h )
	self.m_pnlItemList:SetSize( intW -intH, intH -h -5 )

	local xPos = 0
	for k, v in pairs( self.m_tblItemIcons ) do
		v:SetPos( xPos, 0 )
		xPos = xPos +v:GetWide()
	end
end
vgui.Register( "SRPClothingMenu_SelectedDisplay", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlIcon = vgui.Create( "ModelImage", self )
	self.m_pnlIcon:SetVisible( false )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "CarMenuFont" )
	self.m_pnlNameLabel:SetText( " " )

	self.m_pnlPriceLabel = vgui.Create( "DLabel", self )
	self.m_pnlPriceLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlPriceLabel:SetTextColor( Color(120, 230, 110, 255) )
	self.m_pnlPriceLabel:SetFont( "Trebuchet24" )
	self.m_pnlPriceLabel:SetText( " " )

	self.m_pnlDescStatsLabel = vgui.Create( "DLabel", self )
	self.m_pnlDescStatsLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlDescStatsLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlDescStatsLabel:SetFont( "Trebuchet18" )
	self.m_pnlDescStatsLabel:SetText( " " )
	self.m_pnlDescStatsLabel:SetWrap( true )

	self.m_pnlBuyBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlBuyBtn:SetText( "Purchase" )
	self.m_pnlBuyBtn.Think = function()
		if not self.m_tblCurItem then
			self.m_pnlBuyBtn:SetDisabled( true )
			return
		end
		self.m_pnlBuyBtn:SetDisabled( not LocalPlayer():CanAfford(self.m_tblCurItem.ClothingMenuPrice) )
	end
	self.m_pnlBuyBtn.DoClick = function()
		GAMEMODE.Net:BuyCharacterClothingItem( self.m_tblCurItem.Name )
	end
end

function Panel:SetSelectedItem( tblItem )
	if self.m_tblCurItem and self.m_tblCurItem.Name == tblItem.Name then
		self.m_pnlIcon:SetVisible( false )
		self.m_pnlNameLabel:SetText( " " )
		self.m_pnlPriceLabel:SetText( " " )
		self.m_pnlDescStatsLabel:SetText( " " )
		self.m_tblCurItem = nil
		return
	end

	self.m_tblCurItem = tblItem
	self.m_strModel = tblItem.Model
	self.m_intSkin = tblItem.Skin

	self.m_pnlIcon:SetModel( self.m_strModel, self.m_intSkin )
	self.m_pnlIcon:SetVisible( true )
	self.m_pnlNameLabel:SetText( tblItem.Name )
	self.m_pnlPriceLabel:SetText( "$".. string.Comma(tblItem.ClothingMenuPrice) )

	local str
	if tblItem.Desc then
		str = tblItem.Desc
	end
	if tblItem.Stats then
		str = str.. "\nStats:\n".. tblItem.Stats
	end

	self.m_pnlDescStatsLabel:SetText( str or " " )
	self:InvalidateLayout()
end

function Panel:Think()
	if self.m_tblCurItem then
		self.m_pnlPriceLabel:SetText( "$".. string.Comma(GAMEMODE.Econ:ApplyTaxToSum("sales", self.m_tblCurItem.ClothingMenuPrice)) )
		self.m_pnlPriceLabel:SizeToContents()
	end
end

function Panel:Paint( intW, intH )
	local iconTall = self.m_pnlIcon:GetTall()
	surface.SetDrawColor( 75, 75, 75, 220 )
	surface.DrawRect( 0, 0, intW, iconTall )

	surface.SetDrawColor( 30, 30, 30, 220 )
	surface.DrawRect( 0, iconTall, intW, intH -iconTall )
end

function Panel:PerformLayout( intW, intH )
	local padding = 5

	self.m_pnlIcon:SetPos( 0, 0 )
	self.m_pnlIcon:SetSize( 64, 64 )
	if self.m_strModel then
		self.m_pnlIcon:SetModel( self.m_strModel, self.m_intSkin )
	end
	
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( (padding *2) +self.m_pnlIcon:GetWide(), 0 )

	local _, h = self.m_pnlNameLabel:GetSize()
	self.m_pnlPriceLabel:SizeToContents()
	self.m_pnlPriceLabel:SetPos( (padding *2) +self.m_pnlIcon:GetWide(), h )

	self.m_pnlBuyBtn:SetSize( intW, 32 )
	self.m_pnlBuyBtn:SetPos( 0, intH -self.m_pnlBuyBtn:GetTall() )

	self.m_pnlDescStatsLabel:SizeToContents()
	self.m_pnlDescStatsLabel:SetPos( padding, 64 )
	self.m_pnlDescStatsLabel:SetSize( intW -(padding *2), self.m_pnlDescStatsLabel:GetTall() )
end
vgui.Register( "SRPClothingMenu_SelectedBuy", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlCanvas.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 150 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlItemInfo = vgui.Create( "SRPClothingMenu_SelectedDisplay", self )
	self.m_pnlItemBuy = vgui.Create( "SRPClothingMenu_SelectedBuy", self )

	self.m_pnlMoneyLabel = vgui.Create( "DLabel", self )
	self.m_pnlMoneyLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlMoneyLabel:SetTextColor( Color(120, 230, 110, 255) )
	self.m_pnlMoneyLabel:SetFont( "DermaLarge" )
	self.m_pnlMoneyLabel:SetText( " " )
	self.m_pnlMoneyLabel.Think = function()
		local curMoney = GAMEMODE.Player:GetGameVar( "money_wallet", 0 )

		if self.m_pnlMoneyLabel.m_intLastMoney and self.m_pnlMoneyLabel.m_intLastMoney == curMoney then return end
		self.m_pnlMoneyLabel:SetText( "$".. string.Comma(curMoney) )
		self.m_pnlMoneyLabel.m_intLastMoney = curMoney
		self:InvalidateLayout()
	end

	self.m_pnlBtnClose = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnClose:SetText( "Close" )
	self.m_pnlBtnClose.DoClick = function()
		self:Close()
	end
	
	self.m_tblCatList = {}
	self.m_intNumCols = 3
end

function Panel:Populate()
	for k, v in pairs( self.m_tblCatList ) do
		if ValidPanel( v.Panel ) then
			v.Panel:Remove()
		end
	end

	self.m_tblCatList = {}

	local items = GAMEMODE.Inv:GetItems()
	local clothingItems = {}

	for k, v in pairs( items ) do
		if v.ClothingMenuPrice then
			clothingItems[k] = v
		end
	end

	local sortedItems = {}
	for k, v in pairs( clothingItems ) do
		if not v.ClothingMenuCat then continue end

		if not sortedItems[v.ClothingMenuItemName] then
			sortedItems[v.ClothingMenuItemName] = {}
		end
		table.insert( sortedItems[v.ClothingMenuItemName], v )
	end

	for itemGroup, items in pairs( sortedItems ) do
		if #items > 1 then
			if items[1].Skin then
				table.SortByMember( items, "Skin", true )
			end
			
			if items[1].ClothingMenuPrice then
				table.SortByMember( items, "ClothingMenuPrice", true )
			end
		end
	end
	
	local cat
	local groupButtons = {}
	for itemGroup, items in SortedPairs( sortedItems ) do
		local rootItem = items[1]

		cat = self:GetItemCat( rootItem.ClothingMenuCat )
		if not cat then cat = self:AddItemCat( rootItem.ClothingMenuCat ) end
		if rootItem.ClothingMenuItemName and groupButtons[rootItem.ClothingMenuItemName] then continue end
		
		local btn = vgui.Create( "SpawnIcon", cat.List )
		local size = math.floor( (self.m_pnlCanvas:GetWide() -self.m_pnlCanvas.VBar:GetWide()) /self.m_intNumCols )
		btn:SetSize( size, size )
		btn:SetModel( rootItem.Model, rootItem.Skin )
		--btn:RebuildSpawnIcon()
		btn.DoClick = function()
			self.m_pnlItemInfo:SetItemData( itemGroup, rootItem, items )
		end

		cat.List:AddItem( btn )
	end

	self:InvalidateLayout()
end

function Panel:AddItemCat( strName )
	local pnl = vgui.Create( "SRP_CollapsibleCategory", self.m_pnlCanvas )
	pnl.OldHeight = 400
	pnl:SetExpanded( false )
	pnl:SetLabel( strName )
	pnl.Header:SetFont( "DermaLarge" )
	pnl.Header:SetTall( 32 )
	pnl.Paint = function( p, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 200 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	local wide = self.m_pnlCanvas:GetWide() -self.m_pnlCanvas.VBar:GetWide()
	local pnlList = vgui.Create( "DGrid", self )
	pnlList:SetRowHeight( (wide /self.m_intNumCols) )
	pnlList:SetColWide( (wide /self.m_intNumCols) )
	pnlList:SetCols( self.m_intNumCols )
	pnlList:SetTall( pnl.OldHeight )
	pnl:SetContents( pnlList )

	self.m_pnlCanvas:AddItem( pnl )

	local tbl = self.m_tblCatList[table.insert( self.m_tblCatList, {
		Name = strName,
		Panel = pnl,
		List = pnlList,
	} )]
	
	table.SortByMember( self.m_tblCatList, "Name", true )
	
	return tbl
end

function Panel:GetItemCat( strName )
	for k, v in pairs( self.m_tblCatList ) do
		if v.Name == strName then return v end
	end
end

function Panel:PreviewPart( strSlot, strPartID )
	if self.m_tblCurPreviewPart then
		self.m_entPlayerModel:RemovePACPart( self.m_tblCurPreviewPart.Part, true )

		if self.m_tblRealParts[self.m_tblCurPreviewPart.Slot] then
			self.m_entPlayerModel:AttachPACPart( self.m_tblRealParts[self.m_tblCurPreviewPart.Slot], nil, true )
		end

		if self.m_tblCurPreviewPart.ID == strPartID then self.m_tblCurPreviewPart = nil return end
	end

	self.m_tblCurPreviewPart = { Slot = strSlot, ID = strPartID, Part = GAMEMODE.PacModels:GetOutfitForModel(strPartID, LocalPlayer():GetModel()) }

	if self.m_tblRealParts[self.m_tblCurPreviewPart.Slot] then
		self.m_entPlayerModel:RemovePACPart( self.m_tblRealParts[self.m_tblCurPreviewPart.Slot], true )
	end
	
	self.m_entPlayerModel:AttachPACPart( self.m_tblCurPreviewPart.Part, nil, true )
end

function Panel:Paint( intW, intH )
	cam.Start3D()
		pac.ShowEntityParts( self.m_entPlayerModel )
		pac.ForceRendering( true )
				pac.RenderOverride( self.m_entPlayerModel, "opaque" )
				pac.RenderOverride( self.m_entPlayerModel, "translucent", true )
				self.m_entPlayerModel:DrawModel()
		pac.ForceRendering( false )
		pac.HideEntityParts( self.m_entPlayerModel )
	cam.End3D()

	local x, y = self.m_pnlMoneyLabel:GetPos()
	local w, h = self.m_pnlMoneyLabel:GetSize()
	local extraW, extraY = 48, 5
	surface.SetDrawColor( 50, 50, 50, 200 )
	GAMEMODE.HUD:DrawFancyRect( x -extraW, y -extraY, intW -(x -extraW), h +(extraY *2), 120, 90 )
end

function Panel:Think()
	if IsValid( self.m_entPlayerModel ) then
		if not self.m_intLastThink then self.m_intLastThink = RealTime() end
		self.m_entPlayerModel:FrameAdvance( (RealTime() -self.m_intLastThink) *1 )
	end

	pac.IgnoreEntity( LocalPlayer() )
	pac.HideEntityParts( LocalPlayer() )
	
	if not LocalPlayer():Alive() and self:IsVisible() then
		self:Close()
	end
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlCanvas:SetPos( 0, 0 )
	self.m_pnlCanvas:SetSize( intW *0.2, intH -128 )

	for k, v in ipairs( self.m_tblCatList ) do
		v.Panel:MoveToFront()
		v.Panel:DockMargin( 0, 0, 0, 5 )
		v.Panel:Dock( TOP )
	end

	local w, h = self.m_pnlCanvas:GetSize()
	self.m_pnlItemInfo:SetSize( intW -w, 128 )
	self.m_pnlItemInfo:SetPos( 0, intH -self.m_pnlItemInfo:GetTall() )

	self.m_pnlItemBuy:SetSize( intW -self.m_pnlItemInfo:GetWide(), 128 +64 )
	self.m_pnlItemBuy:SetPos( intW -self.m_pnlItemBuy:GetWide(), intH -self.m_pnlItemBuy:GetTall() )

	self.m_pnlMoneyLabel:SizeToContents()
	
	self.m_pnlBtnClose:SetSize( 100, self.m_pnlMoneyLabel:GetTall() +10 )
	self.m_pnlBtnClose:SetPos( intW -self.m_pnlBtnClose:GetWide(), 0 )

	self.m_pnlMoneyLabel:SetPos( intW -self.m_pnlMoneyLabel:GetWide() -20 -self.m_pnlBtnClose:GetWide(), 5 )
end

function Panel:Open()
	g_ClothingItemsMenu = self

	local pos, angs = LocalPlayer():EyePos(), LocalPlayer():EyeAngles()
	local targetAngs = Angle( 0, angs.y, 0 )
	local targetPos = pos +(targetAngs:Forward() *-64) +(targetAngs:Up() *-8)

	GAMEMODE.CiniCam:JumpFromTo( pos, angs, LocalPlayer():GetFOV(),
		targetPos,
		targetAngs,
		LocalPlayer():GetFOV(),
		1,
		function()
		end
	)
	
	self.m_entPlayerModel = ClientsideModel( LocalPlayer():GetModel(), RENDERGROUP_BOTH )
	self.m_entPlayerModel:SetSkin( LocalPlayer():GetSkin() )
	self.m_entPlayerModel:SetPos( LocalPlayer():GetPos() )
	self.m_entPlayerModel:SetAngles( Angle(0, angs.y -180, 0) )
	self.m_entPlayerModel:ResetSequence( self.m_entPlayerModel:LookupSequence("pose_standing_02") )
	self.m_entPlayerModel:SetNoDraw( true )
	pac.SetupENT( self.m_entPlayerModel )

	self.m_tblRealParts = {}
	for k, v in pairs( LocalPlayer().m_tblEquipPACOutfits or {} ) do
		if v.CurPacPart then
			self.m_tblRealParts[k] = v.CurPacPart
			self.m_entPlayerModel:AttachPACPart( v.CurPacPart, nil, true )
		end
	end

	self:InvalidateLayout( true )
	self:Populate()
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:Close()
	if self.m_entPlayerModel then
		self.m_entPlayerModel:Remove()
	end

	GAMEMODE.CiniCam:ClearCamera()
	self:SetVisible( false )

	pac.UnIgnoreEntity( LocalPlayer() )
	pac.ShowEntityParts( LocalPlayer() )
end
vgui.Register( "SRPClothingItemsMenu", Panel, "EditablePanel" )

hook.Add( "ShouldDrawLocalPlayer", "ClothingMenuHack", function()
	if ValidPanel( g_ClothingItemsMenu ) and g_ClothingItemsMenu:IsVisible() then
		if not LocalPlayer().m_bNoDrawClothingMenu then
			LocalPlayer():SetNoDraw( true )
			LocalPlayer().m_bNoDrawClothingMenu = true
		end

		return true
	end

	if LocalPlayer().m_bNoDrawClothingMenu then
		LocalPlayer().m_bNoDrawClothingMenu = nil
		LocalPlayer():SetNoDraw( false )
	end
end )