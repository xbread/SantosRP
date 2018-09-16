--[[
	Name: cl_menu_billpay.lua
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
			"Are you sure you want to pay this bill? This will cost $".. string.Comma(self.m_tblBillData.Cost),
			"Pay Bill",
			"Yes",
			function()
				GAMEMODE.Net:RequestPayBill( self.m_intBillID )
			end,
			"No",
			function()
			end
		)
	end

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "CarMenuFont" )

	self.m_pnlPriceLabel = vgui.Create( "DLabel", self )
	self.m_pnlPriceLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlPriceLabel:SetTextColor( Color(120, 230, 110, 255) )
	self.m_pnlPriceLabel:SetFont( "CarMenuFont" )

	self.m_pnlTimeLabel = vgui.Create( "DLabel", self )
	self.m_pnlTimeLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlTimeLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlTimeLabel:SetFont( "ItemCardDescFont" )

	self.m_pnlTimeLeftLabel = vgui.Create( "DLabel", self )
	self.m_pnlTimeLeftLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlTimeLeftLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlTimeLeftLabel:SetFont( "ItemCardDescFont" )
	self.m_pnlTimeLeftLabel:SetVisible( false )

	self.m_colRed = Color( 255, 50, 50, 255 )
	self.m_colYellow = Color( 255, 216, 40, 255 )
	self.m_colGreen = Color( 50, 255, 50, 255 )
end

function Panel:SetBill( intBillID, tblBillData )
	self.m_intBillID = intBillID
	self.m_tblBillData = tblBillData

	self.m_pnlNameLabel:SetText( tblBillData.Name )
	self.m_pnlPriceLabel:SetText( "$".. string.Comma(tblBillData.Cost) )

	local issuePrepend = "Issue Date: ".. os.date("%X - %m/%d/%Y", self.m_tblBillData.IssueTime).. ",  "
	if self.m_tblBillData.LifeTime <= 0 then
		self.m_pnlTimeLabel:SetText( issuePrepend.. "Expiry Date: Never" )
	else
		self.m_pnlTimeLabel:SetText( issuePrepend.. "Expiry Date: ".. os.date("%X - %m/%d/%Y", self.m_tblBillData.IssueTime +self.m_tblBillData.LifeTime) )
	end

	self:InvalidateLayout()
end

function Panel:Think()
	if not self.m_tblBillData then return end
	self.m_pnlBtn:SetDisabled( not LocalPlayer():CanAfford(self.m_tblBillData.Cost) )
	self.m_pnlTimeLeftLabel:SetVisible( self.m_tblBillData.LifeTime > 0 )

	if self.m_tblBillData.LifeTime > 0 then
		local time = GAMEMODE.Util:FormatTime( math.max((self.m_tblBillData.IssueTime +self.m_tblBillData.LifeTime) -os.time(), 0), true )
		self.m_pnlTimeLeftLabel:SetText( "Time Left: ".. time )

		local timeCur = os.time() -self.m_tblBillData.IssueTime
		local timeMax = self.m_tblBillData.LifeTime
		local scalar =(timeMax -timeCur) /timeMax

		if scalar <= 0.03 then
			self.m_pnlTimeLeftLabel:SetTextColor( self.m_colRed )
		elseif scalar <= 0.33 then
			self.m_pnlTimeLeftLabel:SetTextColor( self.m_colYellow )
		elseif scalar > 0.33 then
			self.m_pnlTimeLeftLabel:SetTextColor( self.m_colGreen )
		end
	end
	
	self.m_pnlTimeLabel:SizeToContents()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	local padding = 5

	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( padding, 0 )

	self.m_pnlBtn:SetSize( 64, intH )
	self.m_pnlBtn:SetPos( intW -self.m_pnlBtn:GetWide(), 0 )

	self.m_pnlPriceLabel:SizeToContents()
	self.m_pnlPriceLabel:SetPos( intW -self.m_pnlBtn:GetWide() -self.m_pnlPriceLabel:GetWide() -padding, (intH /2) -(self.m_pnlPriceLabel:GetTall() /2) )

	self.m_pnlTimeLeftLabel:SizeToContents()
	self.m_pnlTimeLeftLabel:SetPos( padding, intH -self.m_pnlTimeLeftLabel:GetTall() -padding )

	self.m_pnlTimeLabel:SizeToContents()
	if self.m_tblBillData and self.m_tblBillData.LifeTime > 0 then
		self.m_pnlTimeLabel:SetPos( padding, intH -self.m_pnlTimeLabel:GetTall() -self.m_pnlTimeLeftLabel:GetTall() -padding )
	else
		self.m_pnlTimeLabel:SetPos( padding, intH -self.m_pnlTimeLabel:GetTall() -padding )
	end
end
vgui.Register( "SRPBillCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetDeleteOnClose( false )
	self:SetTitle( "Unpaid Bills Menu" )
	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}

	self.m_pnlBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlBtn:SetFont( "CarMenuFont" )
	self.m_pnlBtn:SetText( "Pay All ($0)" )
	self.m_pnlBtn:SetAlpha( 150 )
	self.m_pnlBtn.DoClick = function()
		GAMEMODE.Gui:Derma_Query(
			"Are you sure you want to pay all bills? This will cost $".. string.Comma(self:GetTotalBillCost()),
			"Pay Bill",
			"Yes",
			function()
				GAMEMODE.Net:RequestPayAllBills()
			end,
			"No",
			function()
			end
		)
	end

	hook.Add( "GamemodeOnBillsUpdated", "UpdateBillsMenu", function( tblBills )
		self:Populate( tblBills )
	end )
end

function Panel:GetTotalBillCost()
	local ret = 0
	for k, v in pairs( self.m_tblCards ) do
		if ValidPanel( v ) and v.m_tblBillData then
			ret = ret +v.m_tblBillData.Cost
		end
	end
	return ret
end

function Panel:Populate( tblBills )
	self.m_pnlCanvas:Clear( true )
	self.m_tblCards = {}

	for k, v in SortedPairsByMemberValue( tblBills, "IssueTime", true ) do
		self:CreateBillCard( k, v )
	end

	self.m_pnlBtn:SetText( "Pay All ($".. string.Comma(self:GetTotalBillCost()).. ")" )
	self:InvalidateLayout()
end

function Panel:CreateBillCard( intBillID, tblBillData )
	local pnl = vgui.Create( "SRPBillCard" )
	pnl:SetBill( intBillID, tblBillData )
	pnl.m_pnlParentMenu = self
	self.m_pnlCanvas:AddItem( pnl )
	self.m_tblCards[#self.m_tblCards +1] = pnl
	return pnl
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )

	self.m_pnlBtn:SetSize( intW, 32 )
	self.m_pnlBtn:SetPos( 0, intH -self.m_pnlBtn:GetTall() )

	self.m_pnlCanvas:SetPos( 0, 24 )
	self.m_pnlCanvas:SetSize( intW, intH -24 -self.m_pnlBtn:GetTall() )

	for _, pnl in pairs( self.m_tblCards ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( pnl.m_tblBillData.LifeTime <= 0 and 50 or 75 )
		pnl:Dock( TOP )
	end
end

function Panel:Open()
	if table.Count( g_GamemodeUnPaidBills or {} ) <= 0 then
		GAMEMODE.Net:RequestBillUpdate()
	end

	self:SetVisible( true )
	self:MakePopup()
end

function Panel:OnClose()
	GAMEMODE.Net:SendNPCDialogEvent( "bank_storage_end_dialog" )
end
vgui.Register( "SRPBillsMenu", Panel, "SRP_Frame" )