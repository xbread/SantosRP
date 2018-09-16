--[[
	Name: cl_menu_qmenu.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_pnlTabs = vgui.Create( "SRP_PropertySheet", self )
	self.m_pnlTabs:SetPadding( 0 )
	self.m_pnlTabInventory = self.m_pnlTabs:AddSheet( "Inventory", vgui.Create("SRPQMenu_Inventory", self) ).Panel
	self.m_pnlTabCharacter = self.m_pnlTabs:AddSheet( "Character", vgui.Create("SRPQMenu_Character", self) ).Panel
	self.m_pnlTabBuddies = self.m_pnlTabs:AddSheet( "Buddies", vgui.Create("SRPQMenu_Buddies", self) ).Panel
	self.m_pnlTabSettings = self.m_pnlTabs:AddSheet( "Settings", vgui.Create("SRPQMenu_Settings", self) ).Panel
end

function Panel:Refresh()
	self.m_pnlTabInventory:Refresh()
	self.m_pnlTabCharacter:Refresh()
	self.m_pnlTabBuddies:Rebuild()
	self.m_pnlTabSettings:Refresh()
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlTabs:SetPos( 0, 0 )
	self.m_pnlTabs:SetSize( intW, intH )
end
vgui.Register( "SRPQMenu", Panel, "SRP_FramePanel" )