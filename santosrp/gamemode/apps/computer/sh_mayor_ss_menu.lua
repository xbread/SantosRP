--[[
	Name: sh_mayor_ss_menu.lua
	For: TalosLife
	By: TalosLife
]]--

local App = {}
App.Name = "Secret Service"
App.ID = "nsa.exe"
App.Panel = "SRPComputer_AppWindow_SecretService"
App.Icon = "nomad/computer/icon_ss.png"
App.DekstopIcon = true
App.StartMenuIcon = true

--App code
--End app code
GM.Apps:Register( App )
if SERVER then return end
--App UI
local Panel = {}
function Panel:Init()
	self.m_pnlAvatar = vgui3D.Create( "AvatarImage", self )
	self.m_pnlLabelName = vgui3D.Create( "DLabel", self )
	self.m_pnlLabelName:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlLabelName:SetFont( "Trebuchet18" )
	self.m_pnlLabelName:SetMouseInputEnabled( false )
	self.m_pnlBtnFire = vgui3D.Create( "DButton", self )
	self.m_pnlBtnFire:SetText( "Fire" )
	self.m_pnlBtnFire.DoClick = function() GAMEMODE.Net:RequestFireSS( self.m_pPlayer ) end
	self.m_pnlBtnFire:SetTextColor( Color(255, 255, 255, 255) )
end
function Panel:SetPlayer( pPlayer )
	self.m_pPlayer = pPlayer
	self.m_pnlAvatar:SetSize( 32, 32 )
	self.m_pnlAvatar:SetPlayer( pPlayer )
	self.m_pnlLabelName:SetText( pPlayer:Nick() )
	self:InvalidateLayout()
end
function Panel:Think()
	if not IsValid( self.m_pPlayer ) then
		self:Remove()
	end
end
function Panel:PerformLayout( intW, intH )
	self.m_pnlLabelName:SizeToContents()
	self.m_pnlAvatar:SetPos( 0, 0 )
	self.m_pnlAvatar:SetSize( intH, intH )
	self.m_pnlLabelName:SetPos( self.m_pnlAvatar:GetWide() +5, 0 )
	self.m_pnlBtnFire:SetSize( 64, 16 )
	self.m_pnlBtnFire:SetPos( self.m_pnlAvatar:GetWide() +5, intH -self.m_pnlBtnFire:GetTall() -3 )	
end
vgui.Register( "SRPComputer_AppWindow_SecretService_EmployCard", Panel, "EditablePanel" )
local Panel = {}
function Panel:Init()
	self.m_pnlCanvas = vgui3D.Create( "SRPComputer_ScrollPanel", self )
	self.m_tblPlayerCards = {}
	self:Populate()
	local hookID = ("UpdateSSApp_%p"):format( self )
	hook.Add( "GamemodeOnGetSSApps", hookID, function( tblApps )
		if not ValidPanel( self ) then hook.Remove( "GamemodeOnGetSSApps", hookID ) return end
		self:Populate()
	end )
	self.m_pnlLabelCap = vgui3D.Create( "DLabel", self )
	self.m_pnlLabelCap:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlLabelCap:SetFont( "Trebuchet18" )
	self.m_pnlLabelCap:SetMouseInputEnabled( false )
end
function Panel:Think()
	if CurTime() < (self.m_intLastThink or 0) then return end
	local cap = GAMEMODE.Jobs:CalcJobPlayerCap( JOB_SSERVICE )
	local num = GAMEMODE.Jobs:GetNumPlayers( JOB_SSERVICE )
	self.m_pnlLabelCap:SetText( num.. "/".. cap.. " Employees" )
	self:InvalidateLayout()
	self.m_intLastThink = CurTime() +1
end
function Panel:Populate()
	for k, v in pairs( player.GetAll() ) do
		if GAMEMODE.Jobs:GetPlayerJobID( v ) ~= JOB_SSERVICE then continue end
		self:CreatePlayerCard( v )
	end
	--for i = 1, 11 do
	--	self:CreatePlayerCard( LocalPlayer() )
	--end
end
function Panel:CreatePlayerCard( pPlayer )
	local card = vgui3D.Create( "SRPComputer_AppWindow_SecretService_EmployCard", self.m_pnlCanvas )
	card:SetPlayer( pPlayer )
	table.insert( self.m_tblPlayerCards, card )
	self.m_pnlCanvas:AddItem( card )
	return card
end
function Panel:PerformLayout( intW, intH )
	self.m_pnlLabelCap:SizeToContents()
	self.m_pnlLabelCap:SetPos( 0, intH -self.m_pnlLabelCap:GetTall() )
	self.m_pnlCanvas:SetPos( 0, 0 )
	self.m_pnlCanvas:SetSize( intW, intH -self.m_pnlLabelCap:GetTall() )
	
	for _, pnl in pairs( self.m_tblPlayerCards ) do
		if not ValidPanel( pnl ) then continue end
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 38 )
		pnl:Dock( TOP )
	end
end
vgui.Register( "SRPComputer_AppWindow_SecretService_TabEmploy", Panel, "EditablePanel" )
local Panel = {}
function Panel:Init()
	self.m_pnlAvatar = vgui3D.Create( "AvatarImage", self )
	self.m_pnlLabelName = vgui3D.Create( "DLabel", self )
	self.m_pnlLabelName:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlLabelName:SetFont( "Trebuchet18" )
	self.m_pnlLabelName:SetMouseInputEnabled( false )
	self.m_pnlBtnApprove = vgui3D.Create( "DButton", self )
	self.m_pnlBtnApprove:SetText( "Accept" )
	self.m_pnlBtnApprove.DoClick = function() GAMEMODE.Net:RequestApproveSSApp( self.m_pPlayer ) end
	self.m_pnlBtnApprove:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlBtnDeny = vgui3D.Create( "DButton", self )
	self.m_pnlBtnDeny:SetText( "Deny" )
	self.m_pnlBtnDeny.DoClick = function() GAMEMODE.Net:RequestDenySSApp( self.m_pPlayer ) end
	self.m_pnlBtnDeny:SetTextColor( Color(255, 255, 255, 255) )
end
function Panel:SetPlayer( pPlayer )
	self.m_pPlayer = pPlayer
	self.m_pnlAvatar:SetSize( 32, 32 )
	self.m_pnlAvatar:SetPlayer( pPlayer )
	self.m_pnlLabelName:SetText( pPlayer:Nick() )
	self:InvalidateLayout()
end
function Panel:Think()
	if not IsValid( self.m_pPlayer ) then
		self:Remove()
	end
end
function Panel:PerformLayout( intW, intH )
	self.m_pnlLabelName:SizeToContents()
	self.m_pnlAvatar:SetPos( 0, 0 )
	self.m_pnlAvatar:SetSize( intH, intH )
	self.m_pnlLabelName:SetPos( self.m_pnlAvatar:GetWide() +5, 0 )
	self.m_pnlBtnApprove:SetSize( 64, 16 )
	self.m_pnlBtnDeny:SetSize( 64, 16 )
	self.m_pnlBtnApprove:SetPos( self.m_pnlAvatar:GetWide() +5, intH -self.m_pnlBtnApprove:GetTall() -3 )
	self.m_pnlBtnDeny:SetPos( self.m_pnlAvatar:GetWide() +self.m_pnlBtnApprove:GetWide() +10, intH -self.m_pnlBtnDeny:GetTall() -3 )	
end
vgui.Register( "SRPComputer_AppWindow_SecretService_AppCard", Panel, "EditablePanel" )
local Panel = {}
function Panel:Init()
	self.m_pnlCanvas = vgui3D.Create( "SRPComputer_ScrollPanel", self )
	local hookID = ("UpdateSSApp_%p"):format( self )
	hook.Add( "GamemodeOnGetSSApps", hookID, function( tblApps )
		if not ValidPanel( self ) then hook.Remove( "GamemodeOnGetSSApps", hookID ) return end
		self:Populate( tblApps )
	end )
	self.m_tblPlayerCards = {}
	self:Populate( GAMEMODE.m_tblSSApps or {} )
end
function Panel:Populate( tblApps )
	for k, v in pairs( self.m_tblPlayerCards ) do
		if ValidPanel( v ) then v:Remove() end
	end
	self.m_tblPlayerCards = {}
	for pl, _ in pairs( tblApps ) do
		if IsValid( pl ) then
			self:CreatePlayerCard( pl )
		end
	end
	--for i = 1, 12 do
	--	self:CreatePlayerCard( LocalPlayer() )
	--end
	self:InvalidateLayout()
end
function Panel:CreatePlayerCard( pPlayer )
	local card = vgui3D.Create( "SRPComputer_AppWindow_SecretService_AppCard", self.m_pnlCanvas )
	card:SetPlayer( pPlayer )
	table.insert( self.m_tblPlayerCards, card )
	self.m_pnlCanvas:AddItem( card )
	return card
end
function Panel:PerformLayout( intW, intH )
	self.m_pnlCanvas:SetPos( 0, 0 )
	self.m_pnlCanvas:SetSize( intW, intH )
	for _, pnl in pairs( self.m_tblPlayerCards ) do
		if not ValidPanel( pnl ) then continue end
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 38 )
		pnl:Dock( TOP )
	end
end
vgui.Register( "SRPComputer_AppWindow_SecretService_TabApps", Panel, "EditablePanel" )
local Panel = {}
function Panel:Init()
	self:GetParent():SetTitle( App.Name )
	self:GetParent():SetSize( 280, 400 )
	self:GetParent():SetPos( 50, 50 )
	self.m_pnlTabs = vgui3D.Create( "SRPComputer_DPropertySheet", self )
	self.m_pnlTabs:AddSheet( "Employees", vgui3D.Create("SRPComputer_AppWindow_SecretService_TabEmploy", self.m_pnlTabs), "icon16/briefcase.png", nil, nil, "" )
	self.m_pnlTabs:AddSheet( "Applications", vgui3D.Create("SRPComputer_AppWindow_SecretService_TabApps", self.m_pnlTabs), "icon16/book_open.png", nil, nil, "" )
end
function Panel:PerformLayout( intW, intH )
	self.m_pnlTabs:SetPos( 0, 0 )
	self.m_pnlTabs:SetSize( intW, intH )
end
vgui.Register( "SRPComputer_AppWindow_SecretService", Panel, "EditablePanel" )
