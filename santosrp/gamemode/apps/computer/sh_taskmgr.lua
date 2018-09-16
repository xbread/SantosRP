--[[
	Name: sh_taskmgr.lua
	For: TalosLife
	By: TalosLife
]]--

local App = {}
App.Name = "Task Manager"
App.ID = "taskmgr.exe"
App.Panel = "SRPComputer_AppWindow_TaskManager"
App.Icon = "icon16/wrench.png"
App.CoreApp = true
App.DekstopIcon = false
App.StartMenuIcon = true

GM.Apps:Register( App )

if SERVER then return end

local Panel = {}
function Panel:Init()
	self.m_pnlIDLabel = vgui3D.Create( "DLabel", self )
	self.m_pnlIDLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlIDLabel:SetFont( "Trebuchet18" )
	self.m_pnlIDLabel:SetMouseInputEnabled( false )
end

function Panel:SetProcID( strID )
	self.m_strProcID = strID
	self.m_pnlIDLabel:SetText( strID )
	self.m_pnlIDLabel:SizeToContents()
	self:InvalidateLayout()
end

function Panel:GetProcID()
	return self.m_strProcID
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlIDLabel:SizeToContents()
	self.m_pnlIDLabel:SetPos( 0, (intH /2) -(self.m_pnlIDLabel:GetTall() /2) )
end
vgui.Register( "SRPComputer_AppWindow_TaskManager_ProcessCard", Panel, "EditablePanel" )



local Panel = {}
function Panel:Init()
	self.m_pnlCanvas = vgui3D.Create( "SRPComputer_ScrollPanel", self )
	self.m_tblProcCards = {}
end

function Panel:AddProcess( pnlWindow, strProcName )
	self.m_tblProcCards[pnlWindow] = vgui3D.Create( "SRPComputer_AppWindow_TaskManager_ProcessCard", self )
	self.m_tblProcCards[pnlWindow]:SetProcID( strProcName )
	self.m_pnlCanvas:AddItem( self.m_tblProcCards[pnlWindow] )
end

function Panel:Think()
	if (self.m_intLastThink or 0) > CurTime() then return end

	local invalid
	for k, v in pairs( self.m_tblProcCards ) do
		if not ValidPanel( k ) then
			if ValidPanel( v ) then v:Remove() end
			self.m_tblProcCards[k] = nil
			invalid = true
		end
	end

	for k, v in pairs( self:GetDesktop().m_tblAppWindows ) do
		if not ValidPanel( k ) then continue end
		if not self.m_tblProcCards[k] then
			self:AddProcess( k, k.m_tblApp.ID )
			invalid = true
		end
	end

	self.m_intLastThink = CurTime() +2

	if invalid then
		self:InvalidateLayout()
	end
end

function Panel:GetDesktop()
	--FfffFFffFfffffffffffffFff
	return self:GetParent():GetParent():GetParent():GetDesktop()
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlCanvas:SetPos( 0, 0 )
	self.m_pnlCanvas:SetSize( intW, intH )
	
	local y = 0
	for _, pnl in pairs( self.m_tblProcCards ) do
		if not ValidPanel( pnl ) then continue end
		pnl:SetTall( 18 )
		if self.m_pnlCanvas.VBar.Enabled then
			pnl:SetWide( self.m_pnlCanvas:GetWide() -self.m_pnlCanvas.VBar:GetWide() )
		else
			pnl:SetWide( self.m_pnlCanvas:GetWide() )
		end
		pnl:SetPos( 0, y )
		y = y +pnl:GetTall()
	end
end
vgui.Register( "SRPComputer_AppWindow_TaskManager_TabProcesses", Panel, "EditablePanel" )



local Panel = {}
function Panel:Init()
end

function Panel:Think()
end

function Panel:PerformLayout( intW, intH )
end
vgui.Register( "SRPComputer_AppWindow_TaskManager_TabPerformance", Panel, "EditablePanel" )



local Panel = {}
function Panel:Init()
	self.m_pnlCanvas = vgui3D.Create( "SRPComputer_ScrollPanel", self )
	self.m_tblUserCards = {}
end

function Panel:AddUserCard()
end

function Panel:Think()
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlCanvas:SetPos( 0, 0 )
	self.m_pnlCanvas:SetSize( intW, intH )
	
	for _, pnl in pairs( self.m_tblUserCards ) do
		if not ValidPanel( pnl ) then continue end
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 18 )
		pnl:Dock( TOP )
	end
end
vgui.Register( "SRPComputer_AppWindow_TaskManager_TabUsers", Panel, "EditablePanel" )



local Panel = {}
function Panel:Init()
	self:GetParent():SetTitle( App.Name )
	self:GetParent():SetSize( 282, 180 )
	self:GetParent():SetPos( 50, 50 )
	self:GetParent():RequestFocus()
	self:GetParent():MoveToFront()

	self.m_pnlTabs = vgui3D.Create( "SRPComputer_DPropertySheet", self )
	self.m_pnlTabs:AddSheet( "Processes", vgui3D.Create("SRPComputer_AppWindow_TaskManager_TabProcesses", self.m_pnlTabs), "icon16/application_cascade.png", nil, nil, "" )
	self.m_pnlTabs:AddSheet( "Performance", vgui3D.Create("SRPComputer_AppWindow_TaskManager_TabPerformance", self.m_pnlTabs), "icon16/server_chart.png", nil, nil, "" )
	self.m_pnlTabs:AddSheet( "Users", vgui3D.Create("SRPComputer_AppWindow_TaskManager_TabUsers", self.m_pnlTabs), "icon16/user_gray.png", nil, nil, "" )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlTabs:SetPos( 0, 0 )
	self.m_pnlTabs:SetSize( intW, intH )
end
vgui.Register( "SRPComputer_AppWindow_TaskManager", Panel, "EditablePanel" )