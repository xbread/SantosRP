--[[
	Name: sh_mayor_taxes.lua
	For: TalosLife
	By: TalosLife
]]--

local App = {}
App.Name = "City Taxes"
App.ID = "turbotax97.exe"
App.Panel = "SRPComputer_AppWindow_MayorTaxes"
App.Icon = "nomad/computer/icon_taxes.png"
App.DekstopIcon = true
App.StartMenuIcon = true

--App code
--End app code

GM.Apps:Register( App )

if SERVER then return end
--App UI
local Panel = {}
function Panel:Init()
	self.m_pnlNameLabel = vgui3D.Create( "DLabel", self )
	self.m_pnlNameLabel:SetMouseInputEnabled( false )

	self.m_pnlNumSlider = vgui3D.Create( "SRPComputer_DNumSlider", self )
	self.m_pnlNumSlider:SetMin( 0 )
	self.m_pnlNumSlider:SetMax( 100 )
	self.m_pnlNumSlider:SetDecimals( 0 )
	self.m_pnlNumSlider.OnValueChanged = function( _, ... ) self:OnValueChanged( ... ) end
end

function Panel:SetTaxData( tblTaxData )
	self.m_tblTaxData = tblTaxData

	self.m_pnlNumSlider:SetMax( 100 *(tblTaxData.MaxValue or 1) )
	self.m_pnlNumSlider:SetMin( 100 *(tblTaxData.MinValue or 0) )
	self.m_pnlNumSlider:SetValue( 100 *(tblTaxData.Value or 0) )
	self.m_pnlNameLabel:SetText( tblTaxData.Name )
	self:InvalidateLayout()
end

function Panel:OnValueChanged( intValue )
	self.m_pnlNumSlider.TextArea:SetText( self.m_pnlNumSlider.TextArea:GetText().. "%" )
	if not self.m_tblTaxData or not ValidPanel( self.m_pnlParent ) then return end
	self.m_pnlParent:OnValueChanged( self, intValue )
end

function Panel:PerformLayout( intW, intH )
	local padding = 3
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( padding, padding )

	self.m_pnlNumSlider:SetWide( intW -(padding *2) )
	self.m_pnlNumSlider:SetPos( padding, intH -self.m_pnlNumSlider:GetTall() )
end
vgui.Register( "SRPComputer_MayorTaxCard", Panel, "EditablePanel" )



local Panel = {}
function Panel:Init()
	self:GetParent():SetTitle( App.Name )
	self:GetParent():SetSize( 410, 380 )
	self:GetParent():SetPos( 75, 75 )

	self.m_pnlTaxList = vgui3D.Create( "SRPComputer_ScrollPanel", self )
	self.m_tblTaxCards = {}
	self.m_tblTaxes = {}

	self.m_pnlBtnApply = vgui3D.Create( "DButton", self )
	self.m_pnlBtnApply:SetText( "Update Taxes" )
	self.m_pnlBtnApply:SetTextColor( Color(240, 240, 240, 255) )
	self.m_pnlBtnApply:SetDisabled( true )
	self.m_pnlBtnApply.DoClick = function()
		--network changed taxes to server
		local diff = {}
		local num = 0
		local lastK

		for k, v in pairs( self.m_tblTaxes ) do
			if GAMEMODE.Econ:GetTaxData( k ).Value ~= v then
				diff[k] = v
				num = num +1
				lastK = k
			end
		end

		if num <= 0 then return end
		if num == 1 then
			GAMEMODE.Net:RequestUpdateTaxRate( lastK, self.m_tblTaxes[lastK] )
		else
			GAMEMODE.Net:RequestUpdateBatchedTaxRate( diff )
		end
	end

	self:BuildTaxCards()
	local hookID = ("UpdateMayorApp_%p"):format( self )
	hook.Add( "GamemodeOnTaxRateChanged", hookID, function()
		if not ValidPanel( self ) then
			hook.Remove( "GamemodeOnTaxRateChanged", hookID )
			return
		end

		self:BuildTaxCards()
	end )
end

function Panel:OnValueChanged( pnl, intValue )
	intValue = math.Round( intValue /100, 2 )
	self.m_tblTaxes[pnl.m_tblTaxData.ID] = intValue

	--if we have changes, enable
	for k, v in pairs( GAMEMODE.Econ:GetTaxes() ) do
		if v.Value ~= (self.m_tblTaxes[k] or -1) then
			self.m_pnlBtnApply:SetDisabled( false )
			return
		end
	end

	self.m_pnlBtnApply:SetDisabled( false )
end

function Panel:BuildTaxCards()
	for k, v in pairs( self.m_tblTaxCards ) do
		if ValidPanel( v ) then v:Remove() end
	end
	self.m_tblTaxCards = {}

	for k, v in SortedPairsByMemberValue( GAMEMODE.Econ:GetTaxes(), "Name" ) do
		self:CreateTaxCard( v )
		self.m_tblTaxes[k] = v.Value or 0
	end

	self.m_pnlBtnApply:SetDisabled( true )
	self:GetParent():InvalidateLayout()
end

function Panel:CreateTaxCard( tblTaxData )
	local taxCard = vgui3D.Create( "SRPComputer_MayorTaxCard", self.m_pnlTaxList )
	taxCard:SetTaxData( tblTaxData )
	taxCard.m_pnlParent = self
	table.insert( self.m_tblTaxCards, taxCard )
	self.m_pnlTaxList:AddItem( taxCard )
end

function Panel:PerformLayout( intW, intH )
	local padding = 3
	self.m_pnlBtnApply:SetSize( intW -(padding *2), 24 )
	self.m_pnlBtnApply:SetPos( padding, intH -self.m_pnlBtnApply:GetTall() -padding )

	self.m_pnlTaxList:SetPos( padding, padding )
	self.m_pnlTaxList:SetSize( intW -(padding *2), intH -self.m_pnlBtnApply:GetTall() -(padding *3) )

	for k, v in pairs( self.m_tblTaxCards ) do
		v:SetSize( intW, 32 )
		v:DockMargin( 0, 0, 0, 0 )
		v:Dock( TOP )
	end
end
vgui.Register( "SRPComputer_AppWindow_MayorTaxes", Panel, "EditablePanel" )