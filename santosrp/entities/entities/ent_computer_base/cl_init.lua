--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

function ENT:Initialize()
	self.m_vecScreenPos = Vector( -10.6, -12.68, 17.174713 )
	self.m_angScreenAng = Angle( 0, 90, 76.45 )

	self.m_vecCamPos = Vector( 4.881836, 0.503906, 12.813683 )
	self.m_angCamAng = Angle( 13.858, -179.99, 0 )

	self.m_pnlMenu = vgui3D.Create( "SRPComputer_Desktop" )
	self.m_pnlMenu:SetSize( 800, 515 ) --800x515
	self.m_pnlMenu:SetPos( self.m_pnlMenu:GetWide() *-1 -1, self.m_pnlMenu:GetTall() *-1 -1 )
	self.m_pnlMenu:SetEntity( self )
	self.m_pnlMenu:SetPaintedManually( true )
	self.m_pnlMenu:SetMouseInputEnabled( false )

	self:ChildInit()
end

function ENT:ChildInit()
end

local function ClearInput( ent )
	if vgui3D.GetInputWindows()[ent.m_pnlMenu] then
		ent.m_pnlMenu:OnInputLost()
	end
	vgui3D.GetInputWindows()[ent.m_pnlMenu] = nil
end

local function EnableInput( ent )
	if not vgui3D.GetInputWindows()[ent.m_pnlMenu] then
		ent.m_pnlMenu:OnInputGained()
	end

	vgui3D.GetInputWindows()[ent.m_pnlMenu] = true
end

local function RenderMenu( ent )
	if not ValidPanel( ent.m_pnlMenu ) then return end

	local angs = ent:LocalToWorldAngles( ent.m_angScreenAng )
	local pos = ent:LocalToWorld( ent.m_vecScreenPos )

	local zmode
	if vgui3D.GetInputWindows()[ent.m_pnlMenu] then
		cam.IgnoreZ( true )
		zmode = true
	end

	vgui3D.Start3D2D( pos, angs, 0.031875 )
		vgui3D.Paint3D2D( ent.m_pnlMenu )
	vgui3D.End3D2D()

	if zmode then
		cam.IgnoreZ( false )
	end
end

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():DistToSqr( LocalPlayer():EyePos() ) > self.m_intMaxRenderRange ^2 then
		return
	end

	local old = render.GetToneMappingScaleLinear()
	render.SetToneMappingScaleLinear( Vector(1, 1, 1) )
	render.SuppressEngineLighting( true )
	--render.PushFilterMag( 3 )
	--render.PushFilterMin( 3 )

	RenderMenu( self )

	--render.PopFilterMag()
	--render.PopFilterMin()
	render.SuppressEngineLighting( false )
	render.SetToneMappingScaleLinear( old ) 
end

-- Netcode
-- ---------------------------------------------------------------- 
GAMEMODE.Net:RegisterEventHandle( "ent", "comp_use", function( intMsgLen, pPlayer )
	local currentComp = net.ReadEntity()
	if not IsValid( currentComp ) then return end

	local numApps = net.ReadUInt( 8 )
	local apps = {}
	if numApps > 0 then
		for i = 1, numApps do
			local appName = net.ReadString()
			apps[appName] = GAMEMODE.Apps:GetComputerApp( appName )
		end
	end
	
	GAMEMODE.CiniCam:JumpFromToFollow( currentComp, LocalPlayer():EyePos(), EyeAngles(), LocalPlayer():GetFOV(), 
		currentComp.m_vecCamPos,
		currentComp.m_angCamAng,
		LocalPlayer():GetFOV(),
		1,
		function()
		end
	)
	EnableInput( currentComp )
	if ValidPanel( currentComp.m_pnlMenu ) then
		currentComp.m_pnlMenu:OnPlayerOpenMenu( pPlayer, currentComp, apps )
	end

	g_ActiveComputer = currentComp
end )

GAMEMODE.Net:RegisterEventHandle( "ent", "comp_quit", function( intMsgLen, pPlayer )
	GAMEMODE.CiniCam:ClearCamera()

	local currentComp = net.ReadEntity()
	if not IsValid( currentComp ) then return end
	ClearInput( currentComp )

	g_ActiveComputer = nil
end )

function GAMEMODE.Net:RequestQuitComputerUI()
	self:NewEvent( "ent", "comp_rquit" )
	self:FireEvent()
end

local pmeta = debug.getregistry().Player
function pmeta:IsUsingComputer()
	return IsValid( g_ActiveComputer )
end

function pmeta:GetActiveComputer()
	return g_ActiveComputer
end