--[[
	Name: cl_menu_itembox.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self:SetDeleteOnClose( false )
	self:SetTitle( "Item Box" )
	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}

	self.m_pnlSearch = vgui.Create( "EditablePanel", self )
	self.m_pnlSearch.SearchBtn = vgui.Create( "SRP_Button", self.m_pnlSearch )
	self.m_pnlSearch.SearchBtn:SetFont( "DermaLarge" )
	self.m_pnlSearch.SearchBtn:SetText( "Search" )
	self.m_pnlSearch.SearchBtn:SetAlpha( 200 )
	self.m_pnlSearch.SearchBtn.DoClick = function()
		for k, v in pairs( self.m_tblCards ) do
			if v.m_strItemID:lower():find( self.m_pnlSearch.TextEntry:GetValue() ) ~= nil then
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

function Panel:SetEntity( eEnt )
	self.m_entEnt = eEnt
end

function Panel:Think()
	if not IsValid( self.m_entEnt ) then
		self:SetVisible( false )
	elseif self.m_entEnt:GetPos():Distance( LocalPlayer():GetPos() ) > 200 then
		self:SetVisible( false )
	end
end

function Panel:Populate( tblItems )
	for k, v in pairs( self.m_tblCards ) do
		if ValidPanel( v ) then v:Remove() end
		self.m_tblCards[k] = nil
	end

	for k, data in SortedPairs( tblItems ) do
		if not GAMEMODE.Inv:GetItem( k ) then continue end
		self:CreateItemCard( k, data )
	end

	self:InvalidateLayout()
end

function Panel:CreateItemCard( k, itemAmount )
	local pnl = vgui.Create( "SRPQMenuItemCard" )
	pnl.BuildTrayButtons = function( pnl )
		pnl.m_pnlBtnTray:Clear()
		if not pnl.m_tblItem then return end
		
		local takeBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )
		takeBtn:SetText( "Take" )
		takeBtn.DoClick = function()
			net.Start( "ItemBox" )
				net.WriteEntity( self.m_entEnt )
				net.WriteBit( true )
				net.WriteString( k )
			net.SendToServer()
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
					net.Start( "ItemBox" )
						net.WriteEntity( self.m_entEnt )
						net.WriteBit( false )
						net.WriteString( k )
					net.SendToServer()
				end,
				"Cancel",
				function() end
			)
		end
		table.insert( pnl.m_tblTrayBtns, destroyBtn )

		pnl.m_pnlBtnTray:InvalidateLayout()
	end
	pnl:SetItemID( k )
	pnl:SetItemAmount( itemAmount )

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
		pnl:SetTall( 48 )
		pnl:Dock( TOP )
	end
end

function Panel:Open()
	self:SetVisible( true )
	self:MakePopup()
end
vgui.Register( "SRPItemBoxMenu", Panel, "SRP_Frame" )