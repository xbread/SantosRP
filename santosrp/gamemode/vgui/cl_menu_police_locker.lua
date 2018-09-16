
local Panel = {}

function Panel:Init()

	self.m_colItemName = Color( 255, 255, 255, 255 )

	self.m_colDesc = Color( 215, 215, 215, 255 )



	self.m_pnlIcon = vgui.Create( "ModelImage", self )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )

	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlNameLabel:SetTextColor( self.m_colItemName )

	self.m_pnlNameLabel:SetFont( "ItemCardFont" )



	self.m_pnlDescLabel = vgui.Create( "DLabel", self )

	self.m_pnlDescLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlDescLabel:SetTextColor( self.m_colDesc )

	self.m_pnlDescLabel:SetFont( "Trebuchet24" )



	self.m_pnlCheckBox = vgui.Create( "DCheckBoxLabel", self )

	self.m_pnlCheckBox:SetText( "Select" )

	self.m_pnlCheckBox.OnChange = function( p, bChecked )



	end

end



function Panel:SetItemID( strItemID )

	self.m_strItemID = strItemID

	self.m_tblItem = GAMEMODE.Inv:GetItem( strItemID )

	self.m_pnlNameLabel:SetText( strItemID )

	self.m_pnlDescLabel:SetText( self.m_tblItem.Desc )

	self.m_pnlIcon:SetModel( self.m_tblItem.Model, self.m_tblItem.Skin )



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

	self.m_pnlNameLabel:SetPos( (padding *2) +intH, (intH /2) -self.m_pnlNameLabel:GetTall() )

	

	self.m_pnlDescLabel:SizeToContents()

	self.m_pnlDescLabel:SetWide( intW )

	self.m_pnlDescLabel:SetPos( (padding *2) +intH, (intH /2) +(self.m_pnlNameLabel:GetTall() /2) -(self.m_pnlNameLabel:GetTall() /2) )



	self.m_pnlCheckBox:SizeToContents()

	self.m_pnlCheckBox:SetPos( intW -self.m_pnlCheckBox:GetWide() -padding, (intH /2) -(self.m_pnlCheckBox:GetTall() /2) )

end

vgui.Register( "SRPPoliceLockerCard", Panel, "EditablePanel" )



-- ----------------------------------------------------------------



local Panel = {}

function Panel:Init()

	self:SetDeleteOnClose( false )

	self:SetTitle( "Police Equipment Locker" )

	

	self.m_tblItemCards = {}

	self.m_pnlItemList = vgui.Create( "SRP_ScrollPanel", self )



	self.m_pnlBtnLoadout = vgui.Create( "SRP_Button", self )

	self.m_pnlBtnLoadout:SetText( "Take Selected Items" )

	self.m_pnlBtnLoadout.DoClick = function()

		local values = {}

		for k, v in pairs( self.m_tblItemCards ) do

			values[v.m_strItemID] = v.m_pnlCheckBox:GetChecked()

		end



		GAMEMODE.Net:RequestTakePoliceLockerItems( values )

	end



	self.m_pnlBtnSelectAll = vgui.Create( "SRP_Button", self )

	self.m_pnlBtnSelectAll:SetText( "Select All" )

	self.m_pnlBtnSelectAll.DoClick = function()

		for k, v in pairs( self.m_tblItemCards ) do

			v.m_pnlCheckBox:SetChecked( true )

		end

	end



	self:Refresh()

end



function Panel:Refresh()

	self.m_tblItemCards = {}

	self.m_pnlItemList:Clear( true )



	for itemName, itemAmount in pairs( GAMEMODE.Config.PoliceLockerItems ) do

		local itemCard = vgui.Create( "SRPPoliceLockerCard", self.m_pnlItemList )

		itemCard:SetItemID( itemName )



		self.m_pnlItemList:AddItem( itemCard )

		table.insert( self.m_tblItemCards, itemCard )

	end

end



function Panel:PerformLayout( intW, intH )

	DFrame.PerformLayout( self, intW, intH )



	self.m_pnlItemList:SetPos( 0, 24 )

	self.m_pnlItemList:SetSize( intW, intH -24 -32 )



	for k, v in pairs( self.m_tblItemCards ) do

		v:SetTall( 64 )

		v:DockMargin( 0, 0, 0, 5 )

		v:Dock( TOP )

	end



	self.m_pnlBtnSelectAll:SetSize( 100, 32 )

	self.m_pnlBtnSelectAll:SetPos( intW -self.m_pnlBtnSelectAll:GetWide(), intH -32 )



	self.m_pnlBtnLoadout:SetSize( intW -self.m_pnlBtnSelectAll:GetWide(), 32 )

	self.m_pnlBtnLoadout:SetPos( 0, intH -32 )

end



function Panel:Open()

	self:Refresh()

	self:SetVisible( true )

	self:MakePopup()

end

vgui.Register( "SRPPoliceLocker", Panel, "SRP_Frame" )