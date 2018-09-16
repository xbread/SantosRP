--[[
	Name: cl_menu_buy_lplate.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self:SetTitle( "Purchase Custom License Plate" )
	self:SetDeleteOnClose( false )

	self.m_pnlLabel = vgui.Create( "DLabel", self )
	self.m_pnlLabel:SetFont( "Trebuchet24" )
	self.m_pnlLabel:SetMouseInputEnabled( false )
	self.m_pnlLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlLabel:SetText( ([[Welcome to the DMV.

For a custom license plate, enter any 7 character
combination of uppercase letters, numbers or dashes.

You will be charged $%s.]]):format(GAMEMODE.Config.LPlateCost) )

	self.m_pnlBtnBuy = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnBuy:SetFont( "DermaLarge" )
	self.m_pnlBtnBuy:SetText( "Buy" )
	self.m_pnlBtnBuy.DoClick = function()
		local val = self.m_pnlTextBox:GetText()
		if val == "" then return end
		GAMEMODE.Net:RequestBuyPlate( val )
	end

	self.m_pnlTextBox = vgui.Create( "DTextEntry", self )
	self.m_pnlTextBox.OnEnter = self.m_pnlBtnBuy.DoClick
	self.m_pnlTextBox.OnTextChanged = function( _ )
		local txt = self.m_pnlTextBox:GetText()

		txt = string.gsub( txt, "[^%a%d-]", "" )
		txt = string.gsub( txt, "%l", function( m )
			return string.upper( m )
		end )
		txt = string.Left( txt, 7 )

		self.m_pnlTextBox:SetText( txt )
		self.m_pnlTextBox:SetCaretPos( string.len(txt) )
	end
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )

	self.m_pnlBtnBuy:SetSize( 80, 30 )
	self.m_pnlTextBox:SetSize( intW *0.8, 30 )
	self.m_pnlTextBox:SetPos( ((intW -self.m_pnlBtnBuy:GetWide()) /2) -(self.m_pnlTextBox:GetWide() /2), (intH /2) +self.m_pnlTextBox:GetTall() )

	local x, y = self.m_pnlTextBox:GetPos()
	self.m_pnlBtnBuy:SetPos( x +self.m_pnlTextBox:GetWide(), y )

	self.m_pnlLabel:SizeToContents()
	self.m_pnlLabel:SetPos( (intW /2) -(self.m_pnlLabel:GetWide() /2), y -self.m_pnlLabel:GetTall() )
end

function Panel:Open()
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:OnClose()
	GAMEMODE.Net:SendNPCDialogEvent( "evocity_dmv_end_dialog" )
end
vgui.Register( "SRPCustomPlateMenu", Panel, "SRP_Frame" )