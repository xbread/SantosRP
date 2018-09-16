--[[
	Name: cl_menu_npcdialog.lua
	For: TalosLife
	By: TalosLife
]]--

surface.CreateFont( "NPCDialogTitle", {size = 22, weight = 425, font = "Trebuchet18"} )

local Panel = {}
function Panel:Init()
	self.m_pnlIcon = vgui.Create( "ModelImage", self )

	self.m_pnlPromptLabel = vgui.Create( "DLabel", self )
	self.m_pnlPromptLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlPromptLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlPromptLabel:SetFont( "Trebuchet24" )

	self.m_pnlTitleLabel = vgui.Create( "DLabel", self )
	self.m_pnlTitleLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlTitleLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlTitleLabel:SetFont( "NPCDialogTitle" )

	self.m_pnlOptionContainer = vgui.Create( "SRP_ScrollPanel", self )

	self.m_tblOptions = {}
end

function Panel:SetModel( strModel )
	self.m_pnlIcon:SetModel( strModel )
end

function Panel:SetPrompt( strText )
	self.m_pnlPromptLabel:SetText( strText )
	self.m_pnlPromptLabel:SizeToContents()
end

function Panel:SetTitle( strTitle )
	self.m_pnlTitleLabel:SetText( strTitle )
	self.m_pnlTitleLabel:SizeToContents()
end

function Panel:AddOption( strText, funcCallback )
	local option = vgui.Create( "SRP_Button", self.m_pnlOptionContainer )
	option:SetText( strText )
	option:SetTextColorMouseOver( Color(255, 255, 255, 255) )
	option:SetTextColorOverride( Color(175, 175, 175, 200) )
	option.DoClick = function()
		funcCallback()
	end
	
	self.m_tblOptions[#self.m_tblOptions +1] = option
	self.m_pnlOptionContainer:AddItem( option )
end

function Panel:ClearOptions()
	self.m_pnlOptionContainer:Clear( true )
	self.m_tblOptions = {}
end

function Panel:ClearTitle()
	self.m_pnlTitleLabel:SetText( "" )
end

function Panel:ClearPrompt()
	self.m_pnlPromptLabel:SetText( "" )
end

function Panel:Clear()
	self:ClearTitle()
	self:ClearPrompt()
	self:ClearOptions()
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlIcon:SetPos( 0, 0 )
	self.m_pnlIcon:SetSize( intH, intH )

	self.m_pnlPromptLabel:SetPos( intH +((intW -intH) /2) -(self.m_pnlPromptLabel:GetWide() /2), 5 )
	self.m_pnlTitleLabel:SetPos( (intH /2) -(self.m_pnlTitleLabel:GetWide() /2), intH -self.m_pnlTitleLabel:GetTall() -5 )

	local x, y = self.m_pnlIcon:GetPos()
	self.m_pnlOptionContainer:SetPos( x +self.m_pnlIcon:GetWide(), 5 +self.m_pnlPromptLabel:GetTall() +5 )
	x, y = self.m_pnlOptionContainer:GetPos()
	self.m_pnlOptionContainer:SetSize( intW -x, intH -y )

	for k, v in pairs( self.m_tblOptions ) do
		v:SetTall( 25 )
		v:DockMargin( 0, 0, 0, 0 )
		v:Dock( TOP )
	end
end
vgui.Register( "SRPNPCDialog", Panel, "SRP_FramePanel" )