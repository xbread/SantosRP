--[[
	Name: cl_menu_ticketpay.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_pnlBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlBtn:SetFont( "CarMenuFont" )
	self.m_pnlBtn:SetText( "Pay" )
	self.m_pnlBtn:SetAlpha( 150 )
	self.m_pnlBtn.DoClick = function()
		GAMEMODE.Gui:Derma_Query(
			"Are you sure you want to pay this ticket? This will cost $".. self.m_tblTicketData.Price,
			"Pay Ticket",
			"Yes",
			function()
				GAMEMODE.Net:RequestPayTicket( self.m_intTicketID )
			end,
			"No",
			function()
			end
		)
	end

	self.m_pnlGivenByLabel = vgui.Create( "DLabel", self )
	self.m_pnlGivenByLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlGivenByLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlGivenByLabel:SetFont( "CarMenuFont" )

	self.m_pnlPriceLabel = vgui.Create( "DLabel", self )
	self.m_pnlPriceLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlPriceLabel:SetTextColor( Color(120, 230, 110, 255) )
	self.m_pnlPriceLabel:SetFont( "CarMenuFont" )

	self.m_pnlReasonLabel = vgui.Create( "DLabel", self )
	self.m_pnlReasonLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlReasonLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlReasonLabel:SetFont( "CarMenuFont" )
end

function Panel:SetTicket( intTicketID, tblTicketData )
	self.m_intTicketID = intTicketID
	self.m_tblTicketData = tblTicketData

	self.m_pnlGivenByLabel:SetText( "Issued By: ".. tblTicketData.GivenBy )
	self.m_pnlPriceLabel:SetText( "$".. string.Comma(tblTicketData.Price) )
	self.m_pnlReasonLabel:SetText( tblTicketData.Reason )

	self:InvalidateLayout()
end

function Panel:Think()
	if not self.m_tblTicketData then return end
	self.m_pnlBtn:SetDisabled( not LocalPlayer():CanAfford(self.m_tblTicketData.Price) )
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	local padding = 5

	self.m_pnlGivenByLabel:SizeToContents()
	self.m_pnlGivenByLabel:SetPos( padding, intH -self.m_pnlGivenByLabel:GetTall() -padding )

	self.m_pnlPriceLabel:SizeToContents()
	self.m_pnlPriceLabel:SetPos( (padding *3) +self.m_pnlGivenByLabel:GetWide(), intH -self.m_pnlPriceLabel:GetTall() -padding )

	self.m_pnlReasonLabel:SizeToContents()
	self.m_pnlReasonLabel:SetPos( padding, padding )

	self.m_pnlBtn:SetSize( 110, intH )
	self.m_pnlBtn:SetPos( intW -self.m_pnlBtn:GetWide(), 0 )
end
vgui.Register( "SRPTicketCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetDeleteOnClose( false )
	self:SetTitle( "Unpaid Tickets Menu" )
	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}

	hook.Add( "GamemodeGetUnpaidTickets", "UpdateTicketMenu", function( tblTickets )
		self:Populate( tblTickets )
	end )
end

function Panel:Populate( tblTickets )
	self.m_pnlCanvas:Clear( true )
	self.m_tblCards = {}

	for k, v in pairs( tblTickets ) do
		self:CreateTicketCard( k, v )
	end

	self:InvalidateLayout()
end

function Panel:CreateTicketCard( intTicketID, tblTicketData )
	local pnl = vgui.Create( "SRPTicketCard" )
	pnl:SetTicket( intTicketID, tblTicketData )
	pnl.m_pnlParentMenu = self
	self.m_pnlCanvas:AddItem( pnl )
	self.m_tblCards[#self.m_tblCards +1] = pnl

	return pnl
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )

	self.m_pnlCanvas:SetPos( 0, 24 )
	self.m_pnlCanvas:SetSize( intW, intH -24 )

	for _, pnl in pairs( self.m_tblCards ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 64 )
		pnl:Dock( TOP )
	end
end

function Panel:Open()
	GAMEMODE.Net:RequestTicketList()
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:OnClose()
	GAMEMODE.Net:SendNPCDialogEvent( "evocity_dmv_end_dialog" )
end
vgui.Register( "SRPTicketMenu", Panel, "SRP_Frame" )