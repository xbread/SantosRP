--[[
	Name: cl_menu_crafting_table.lua
	For: TalosLife
	By: TalosLife
]]--

surface.CreateFont( "Crafting_Trebuchet20", {size = 20, weight = 525, font = "Trebuchet24"} )
surface.CreateFont( "Crafting_Trebuchet20_Bold", {size = 20, weight = 400, font = "Trebuchet24"} )

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

	self.m_pnlDescLabel = vgui.Create( "DLabel", self )
	self.m_pnlDescLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlDescLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlDescLabel:SetFont( "Crafting_Trebuchet20_Bold" )

	self.m_pnlLevelLabel = vgui.Create( "DLabel", self )
	self.m_pnlLevelLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlLevelLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlLevelLabel:SetFont( "CarMenuFont" )

	self.m_pnlCraftBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlCraftBtn:SetFont( "CarMenuFont" )
	self.m_pnlCraftBtn:SetText( "Craft" )
	self.m_pnlCraftBtn:SetAlpha( 150 )
	self.m_pnlCraftBtn.DoClick = function()
		GAMEMODE.Net:RequestCraftItem( self.m_tblItem.Name )
	end

	self.m_tblMatLabels = {}
end

function Panel:SetItem( tblData )
	self.m_tblItem = tblData
	self.m_pnlNameLabel:SetText( tblData.Name )
	self.m_pnlDescLabel:SetText( tblData.Desc )
	self.m_pnlIcon:SetModel( tblData.Model, tblData.Skin )

	self.m_pnlLevelLabel:SetText( tblData.CraftSkill.. ": ".. tblData.CraftSkillLevel )
	if GAMEMODE.Skills:GetPlayerLevel( tblData.CraftSkill ) < tblData.CraftSkillLevel then
		self.m_pnlLevelLabel:SetTextColor( Color(255, 50, 50, 255) )
	end

	local maxW = 0
	for k, v in pairs( tblData.CraftRecipe ) do
		local label = vgui.Create( "DLabel", self )
		label:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
		label:SetFont( "Crafting_Trebuchet20" )
		label:SetText( k.. ("(%d/%d)"):format( math.min(LocalPlayer():GetInventory()[k] or 0, v), v ) )

		if v > (LocalPlayer():GetInventory()[k] or 0) then
			label:SetTextColor( Color(255, 50, 50, 255) )
		else
			label:SetTextColor( Color(255, 255, 255, 255) )
		end

		table.insert( self.m_tblMatLabels, label )
	end

	self:InvalidateLayout()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:Think()
	if not self.m_tblItem then return end

	if GAMEMODE.Skills:GetPlayerLevel( self.m_tblItem.CraftSkill ) < self.m_tblItem.CraftSkillLevel then
		self.m_pnlCraftBtn:SetDisabled( true )
		return
	end

	local hasItems = true
	for k, v in pairs( self.m_tblItem.CraftRecipe ) do
		if not GAMEMODE.Inv:PlayerHasItem( k, v ) then
			hasItems = false
		end
	end

	self.m_pnlCraftBtn:SetDisabled( not hasItems )
end

function Panel:PerformLayout( intW, intH )
	local padding = 5

	self.m_pnlIcon:SetPos( 0, 0 )
	self.m_pnlIcon:SetSize( intH, intH )
	self.m_pnlIcon:SetModel( self.m_tblItem.Model )

	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( (padding *2) +intH, 4 )

	self.m_pnlDescLabel:SizeToContents()
	self.m_pnlDescLabel:SetPos( (padding *2) +intH, 32 )

	self.m_pnlCraftBtn:SetSize( 65, intH )
	self.m_pnlCraftBtn:SetPos( intW -self.m_pnlCraftBtn:GetWide(), 0 )

	self.m_pnlLevelLabel:SizeToContents()
	self.m_pnlLevelLabel:SetPos( intW -self.m_pnlCraftBtn:GetWide() -self.m_pnlLevelLabel:GetWide() -padding, 4 )

	local x, y = (padding *2) +intH, 32 +self.m_pnlDescLabel:GetTall()
	local w, h = intW -((padding *2) +intH) -self.m_pnlCraftBtn:GetWide(), intH -32 -self.m_pnlDescLabel:GetTall() 
	
	local _x, _y = x, y
	for k, v in pairs( self.m_tblMatLabels ) do
		v:SizeToContents()
		v:SetPos( _x, _y )
		_x = _x +v:GetWide() +10

		if _x >= w then
			_x = x
			_y = _y +v:GetTall()
		end
	end
end
vgui.Register( "SRPCraftingCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlIcon = vgui.Create( "ModelImage", self )

	self.m_pnlAbortBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlAbortBtn:SetFont( "CarMenuFont" )
	self.m_pnlAbortBtn:SetText( "Cancel" )
	self.m_pnlAbortBtn:SetAlpha( 150 )
	self.m_pnlAbortBtn.DoClick = function()
		GAMEMODE.Net:RequestAbortCraft()
	end

	self.m_pnlTimeBar = vgui.Create( "DProgress", self )
	self.m_pnlTimeBar.Think = function()
		if not self.m_tblItem then return end
		self.m_pnlTimeBar:SetFraction( (CurTime() -self.m_intCraftStartTime) /self.m_intCraftDuration )
	end

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "CarMenuFont" )
end

function Panel:SetCraftingData( strItemID, intStartCraft )
	self.m_tblItem = GAMEMODE.Inv:GetItem( strItemID )
	self.m_intCraftStartTime = intStartCraft

	local craftDurationScalar = GAMEMODE.Skills:GetReductionFactor( self.m_tblItem.CraftSkill, self.m_tblItem.CraftSkillLevel )
	local craftDuration = self.m_tblItem.CraftDuration or 10
	self.m_intCraftDuration = math.max( 1, craftDuration -(craftDuration *craftDurationScalar) )

	self.m_pnlNameLabel:SetText( "Crafting 1 ".. self.m_tblItem.Name )
	self.m_pnlIcon:SetModel( self.m_tblItem.Model, self.m_tblItem.Skin )
	self:InvalidateLayout()
end

function Panel:Paint( intW, intH )
	--surface.SetDrawColor( 50, 50, 50, 200 )
	--surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlIcon:SetSize( 128, 128 )
	self.m_pnlIcon:SetPos( (intW /2) -(self.m_pnlIcon:GetWide() /2), (intH /2) -(self.m_pnlIcon:GetTall() /2) )

	local x, y = self.m_pnlIcon:GetPos()
	self.m_pnlTimeBar:SetSize( intW *0.8, 30 )
	self.m_pnlTimeBar:SetPos( (intW /2) -(self.m_pnlTimeBar:GetWide() /2), y +self.m_pnlIcon:GetTall() +5 )

	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( (intW /2) -(self.m_pnlNameLabel:GetWide() /2), y +self.m_pnlIcon:GetTall() +5 )

	self.m_pnlAbortBtn:SetSize( intW, 30 )
	self.m_pnlAbortBtn:SetPos( 0, intH -self.m_pnlAbortBtn:GetTall() )
end
vgui.Register( "SRPCraftingDisplay", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetDeleteOnClose( false )
	self:SetTitle( "Crafting Table" )

	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}

	self.m_pnlSearch = vgui.Create( "EditablePanel", self )
	self.m_pnlSearch.SearchBtn = vgui.Create( "SRP_Button", self.m_pnlSearch )
	self.m_pnlSearch.SearchBtn:SetFont( "DermaLarge" )
	self.m_pnlSearch.SearchBtn:SetText( "Search" )
	self.m_pnlSearch.SearchBtn:SetAlpha( 200 )
	self.m_pnlSearch.SearchBtn.DoClick = function()
		for k, v in pairs( self.m_tblCards ) do
			if v.m_tblItem.Name:lower():find( self.m_pnlSearch.TextEntry:GetValue() ) ~= nil then
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

	self.m_pnlCraftDisplay = vgui.Create( "SRPCraftingDisplay", self )
	self.m_pnlCraftDisplay:SetVisible( false )

	hook.Add( "GamemodeOnStartCrafting", ("OnStartCraft_CraftingTableMenu_%p"):format(self), function( strItemID, intStartTime )
		if self.m_strGroup ~= GAMEMODE.Inv:GetItem( strItemID ).CraftingEntClass then return end
		self.m_pnlCraftDisplay:SetCraftingData( strItemID, intStartTime )

		self.m_pnlCanvas:MoveTo( -self:GetWide(), 24, 0.25, 0, 2, function()
			self.m_pnlCanvas:SetVisible( false )
		end )

		self.m_pnlCraftDisplay:SetVisible( true )
		self.m_pnlCraftDisplay:SetPos( self:GetWide(), 24 )
		self.m_pnlCraftDisplay:MoveTo( 0, 24, 0.25, 0, 2, function()
			self.m_pnlCraftDisplay:SetVisible( true )
		end )
	end )

	hook.Add( "GamemodeOnEndCrafting", ("OnEndCraft_CraftingTableMenu_%p"):format(self), function( strItemID )
		if self.m_strGroup ~= GAMEMODE.Inv:GetItem( strItemID ).CraftingEntClass then return end
		self.m_pnlCraftDisplay:SetVisible( true )
		self.m_pnlCraftDisplay:MoveTo( self:GetWide(), 24, 0.25, 0, 2, function()
			self.m_pnlCraftDisplay:SetVisible( false )
		end )

		self.m_pnlCanvas:SetVisible( true )
		self.m_pnlCanvas:SetPos( -self:GetWide(), 24 )
		self.m_pnlCanvas:MoveTo( 0, 24, 0.25, 0, 2, function()
			self.m_pnlCanvas:SetVisible( true )
		end )
	end )
end

function Panel:SetCraftingGroupData( strMenuTitle, strCraftingGroup )
	self:SetTitle( strMenuTitle )
	self.m_strGroup = strCraftingGroup
end

function Panel:Populate()
	for k, v in pairs( self.m_tblCards ) do
		if ValidPanel( v ) then v:Remove() end
		self.m_tblCards[k] = nil
	end

	local items = table.Copy( GAMEMODE.Inv:GetItems() )
	for k, data in SortedPairsByMemberValue( items, "CraftSkillLevel", false ) do
		if not data.CraftingEntClass or data.CraftingEntClass ~= self.m_strGroup then continue end
		self:CreateCraftingCardCard( k, items[k] )
	end

	self:InvalidateLayout()
end

function Panel:CreateCraftingCardCard( k, tblData )
	local pnl = vgui.Create( "SRPCraftingCard" )
	pnl:SetItem( tblData )
	pnl.m_pnlParentMenu = self
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
		pnl:SetTall( 128 )
		pnl:Dock( TOP )
	end

	self.m_pnlCraftDisplay:SetPos( 0, 24 )
	self.m_pnlCraftDisplay:SetSize( intW, intH -24 )
end

function Panel:Open()
	self:Populate()
	self:SetVisible( true )
	self:MakePopup()
end
vgui.Register( "SRPCraftingTableMenu", Panel, "SRP_Frame" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetDeleteOnClose( false )
	self:SetTitle( "Crafting Table" )

	self.m_pnlTabs = vgui.Create( "SRP_PropertySheet", self )
	self.m_pnlTabs:SetPadding( 0 )
	self.m_tblTabs = {}

	self.m_pnlCraftDisplay = vgui.Create( "SRPCraftingDisplay", self )
	self.m_pnlCraftDisplay:SetVisible( false )

	hook.Add( "GamemodeOnStartCrafting", ("OnStartCraft_CraftingTableMenu_%p"):format(self), function( strItemID, intStartTime )
		if self.m_strGroup ~= GAMEMODE.Inv:GetItem( strItemID ).CraftingEntClass then return end
		self.m_pnlCraftDisplay:SetCraftingData( strItemID, intStartTime )

		self.m_pnlTabs:MoveTo( -self:GetWide(), 24, 0.25, 0, 2, function()
			self.m_pnlTabs:SetVisible( false )
		end )

		self.m_pnlCraftDisplay:SetVisible( true )
		self.m_pnlCraftDisplay:SetPos( self:GetWide(), 24 )
		self.m_pnlCraftDisplay:MoveTo( 0, 24, 0.25, 0, 2, function()
			self.m_pnlCraftDisplay:SetVisible( true )
		end )
	end )

	hook.Add( "GamemodeOnEndCrafting", ("OnEndCraft_CraftingTableMenu_%p"):format(self), function( strItemID )
		if self.m_strGroup ~= GAMEMODE.Inv:GetItem( strItemID ).CraftingEntClass then return end
		self.m_pnlCraftDisplay:SetVisible( true )
		self.m_pnlCraftDisplay:MoveTo( self:GetWide(), 24, 0.25, 0, 2, function()
			self.m_pnlCraftDisplay:SetVisible( false )
		end )

		self.m_pnlTabs:SetVisible( true )
		self.m_pnlTabs:SetPos( -self:GetWide(), 24 )
		self.m_pnlTabs:MoveTo( 0, 24, 0.25, 0, 2, function()
			self.m_pnlTabs:SetVisible( true )
		end )
	end )
end

function Panel:AddTab( strTabName )
	local tab = vgui.Create( "EditablePanel", self )
	tab.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", tab )
	tab.m_tblCards = {}

	tab.m_pnlSearch = vgui.Create( "EditablePanel", tab )
	tab.m_pnlSearch.SearchBtn = vgui.Create( "SRP_Button", tab.m_pnlSearch )
	tab.m_pnlSearch.SearchBtn:SetFont( "DermaLarge" )
	tab.m_pnlSearch.SearchBtn:SetText( "Search" )
	tab.m_pnlSearch.SearchBtn:SetAlpha( 200 )
	tab.m_pnlSearch.SearchBtn.DoClick = function()
		for k, v in pairs( tab.m_tblCards ) do
			if v.m_tblItem.Name:lower():find( tab.m_pnlSearch.TextEntry:GetValue() ) ~= nil then
				tab.m_pnlCanvas:ScrollToChild( v )
				break
			end
		end
	end

	tab.m_pnlSearch.TextEntry = vgui.Create( "DTextEntry", tab.m_pnlSearch )
	tab.m_pnlSearch.TextEntry.OnEnter = tab.m_pnlSearch.SearchBtn.DoClick
	tab.m_pnlSearch.PerformLayout = function( p, intW, intH )
		p.SearchBtn:SetSize( 110, intH )
		p.SearchBtn:SetPos( intW -p.SearchBtn:GetWide(), 0 )

		p.TextEntry:SetSize( intW -p.SearchBtn:GetWide(), intH )
		p.TextEntry:SetPos( 0, 0 )
	end

	tab.m_pnlSearch.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 200 )
		surface.DrawRect( 0, 0, intW, intH )
	end
	tab.m_pnlCanvas:AddItem( tab.m_pnlSearch )

	tab.PerformLayout = function( _, intW, intH )
		tab.m_pnlCanvas:SetPos( 0, 0 )
		tab.m_pnlCanvas:SetSize( intW, intH )

		tab.m_pnlSearch:DockMargin( 0, 0, 0, 5 )
		tab.m_pnlSearch:SetTall( 32 )
		tab.m_pnlSearch:Dock( TOP )

		for _, pnl in pairs( tab.m_tblCards ) do
			pnl:DockMargin( 0, 0, 0, 5 )
			pnl:SetTall( 128 )
			pnl:Dock( TOP )
		end
	end

	self.m_tblTabs[strTabName] = tab
	self.m_pnlTabs:AddSheet( strTabName, tab )
end

function Panel:GetTab( strTabName )
	return self.m_tblTabs[strTabName] and self.m_tblTabs[strTabName].Panel or nil
end

function Panel:SetCraftingGroupData( strMenuTitle, strCraftingGroup )
	self:SetTitle( strMenuTitle )
	self.m_strGroup = strCraftingGroup
end

function Panel:Populate()
	for _, tab in pairs( self.m_tblTabs ) do
		for k, v in pairs( tab.m_tblCards ) do
			if ValidPanel( v ) then v:Remove() end
			tab.m_tblCards[k] = nil
		end
	end
	
	local items = table.Copy( GAMEMODE.Inv:GetItems() )
	for k, data in SortedPairsByMemberValue( items, "CraftSkillLevel", false ) do
		if not data.CraftingEntClass or data.CraftingEntClass ~= self.m_strGroup then continue end
		self:CreateCraftingCardCard( k, items[k] )
	end

	self:InvalidateLayout()
end

function Panel:CreateCraftingCardCard( k, tblData )
	if not tblData.CraftSkill then return end

	local pnl = vgui.Create( "SRPCraftingCard" )
	pnl:SetItem( tblData )
	pnl.m_pnlParentMenu = self
	if not ValidPanel( self:GetTab(tblData.CraftSkill) ) then
		self:AddTab( tblData.CraftSkill )
	end

	self:GetTab( tblData.CraftSkill ).m_pnlCanvas:AddItem( pnl )
	self:GetTab( tblData.CraftSkill ).m_tblCards[k] = pnl
	return pnl
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )
	self.m_pnlTabs:SetPos( 0, 24 )
	self.m_pnlTabs:SetSize( intW, intH -24 )

	self.m_pnlCraftDisplay:SetPos( 0, 24 )
	self.m_pnlCraftDisplay:SetSize( intW, intH -24 )
end

function Panel:Open()
	self:Populate()
	self:SetVisible( true )
	self:MakePopup()
end
vgui.Register( "SRPAssemblyTableMenu", Panel, "SRP_Frame" )