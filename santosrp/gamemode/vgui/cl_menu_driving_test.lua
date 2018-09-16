--[[
	Name: cl_menu_driving_test.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self:SetDeleteOnClose( false )

	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )

	self.m_pnlLabel = vgui.Create( "DLabel", self )
	self.m_pnlLabel:SetFont( "Trebuchet24" )
	self.m_pnlLabel:SetMouseInputEnabled( false )
	self.m_pnlLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlLabel:SetText( "Please answer the following:" )
	self.m_pnlCanvas:AddItem( self.m_pnlLabel )

	self.m_tblCards = {}
	self.m_tblAnswers = {}
	for k, v in pairs( GAMEMODE.Config.DrivingTestQuestions ) do
		local label = vgui.Create( "DLabel", self )
		label:SetFont( "Trebuchet24" )
		label:SetMouseInputEnabled( false )
		label:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
		label:SetText( v.Question )
		self.m_pnlCanvas:AddItem( label )
		table.insert( self.m_tblCards, label )

		-- ------------------

		local comboBox = vgui.Create( "DComboBox" )
		comboBox:SetValue( "Options" )
		comboBox.IsCBox = true
		for str, _ in pairs( v.Options ) do
			comboBox:AddChoice( str )
		end
		comboBox.OnSelect = function( _, _, value )
			self.m_tblAnswers[k] = value
		end
		self.m_pnlCanvas:AddItem( comboBox )
		table.insert( self.m_tblCards, comboBox )
	end

	self.m_pnlBtnSubmit = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnSubmit:SetText( "Submit" )
	self.m_pnlBtnSubmit.DoClick = function()
		GAMEMODE.Net:SubmitDrivingTest( self.m_tblAnswers )
	end
	self.m_pnlCanvas:AddItem( self.m_pnlBtnSubmit )

	self:InvalidateLayout()
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )

	self.m_pnlCanvas:SetPos( 0, 24 )
	self.m_pnlCanvas:SetSize( intW, intH -24 )

	self.m_pnlLabel:SizeToContents()
	self.m_pnlLabel:DockMargin( 0, 0, 0, 5 )
	self.m_pnlLabel:Dock( TOP )

	for k, v in pairs( self.m_tblCards ) do
		if v.IsCBox then
			v:DockMargin( 0, 0, 0, 5 )
			v:SetSize( intW, 25 )
			v:Dock( TOP )
		else
			v:DockMargin( 0, 0, 0, 5 )
			v:SizeToContents()
			v:Dock( TOP )
		end
	end

	self.m_pnlBtnSubmit:DockMargin( 0, 0, 0, 5 )
	self.m_pnlBtnSubmit:SetTall( 25 )
	self.m_pnlBtnSubmit:Dock( TOP )
end

function Panel:Open()
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:OnClose()
	GAMEMODE.Net:SendNPCDialogEvent( "evocity_dmv_end_dialog" )
end
vgui.Register( "SRPDrivingTestMenu", Panel, "SRP_Frame" )