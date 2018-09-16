
-----------------------------------------------------
--[[
	Name: cl_menu_lost_and_found.lua
	For: SantosRP
	By: Ultra
]]--

local Panel = {}
function Panel:Init()
	self:SetTitle( "Lost and Found (Item Recovery)" )
	self:SetDeleteOnClose( false )

	self.m_pnlItemList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_pnlItemList.Paint = function( _, intW, intH )
	end

	self.m_tblItemList = {}

	hook.Add( "GamemodeOnGetLostAndFoundUpdate", "LostAndFoundMenu", function()
		if not ValidPanel( self ) or not self:IsVisible() then return end
		self:Refresh()
	end )
end

function Panel:Refresh()
	for k, v in pairs( self.m_tblItemList ) do
		if ValidPanel( v ) then v:Remove() end
	end
	self.m_tblItemList = {}

	for k, v in pairs( GAMEMODE.m_tblLostItems or {} ) do
		if not GAMEMODE.Inv:ValidItem( k ) then continue end
		
		local pnl = vgui.Create( "SRPQMenuItemCard", self.m_pnlItemList )
		pnl.BuildTrayButtons = function( pnl )
			pnl.m_pnlBtnTray:Clear()
			if not pnl.m_tblItem then return end
			
			local takeBtn = vgui.Create( "SRP_Button", pnl.m_pnlBtnTray )
			takeBtn:SetText( "Take" )
			takeBtn.DoClick = function()
				GAMEMODE.Net:TakeItemFromLostAndFound( k, v )
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
						GAMEMODE.Net:DestroyLostAndFoundItem( k )
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

		table.insert( self.m_tblItemList, pnl )
	end

	self:InvalidateLayout()
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )
	local padding = 0

	self.m_pnlItemList:SetSize( intW -(padding *2), intH -24 -padding )
	self.m_pnlItemList:SetPos( padding, 24 +padding )

	for _, pnl in pairs( self.m_tblItemList ) do
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
vgui.Register( "SRPLostAndFoundMenu", Panel, "SRP_Frame" )