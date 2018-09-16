--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

function ENT:Initialize()
	self.m_vecMenuPos = Vector( 7.05, -14.73, 56.7 )
	self.m_angMenuAngs = Angle( 0, 90, 75 )

	self.m_vecKeypadPos = Vector( 10.2, -10.45, 45.8 )
	self.m_angKeypadAngs = Angle( 0, 90, 29 )

	self.m_pnlMenu = vgui3D.Create( "SRPATMDisplay" )
	self.m_pnlMenu:SetSize( 560, 480 )
	self.m_pnlMenu:SetEntity( self )
	self.m_pnlMenu:SetPaintedManually( true )
	self.m_pnlMenu:SetMouseInputEnabled( false )
	self.m_pnlMenu:SetPos( -(self.m_pnlMenu:GetWide() +1), -(self.m_pnlMenu:GetTall() +1) )

	self.m_pnlKeypad = vgui3D.Create( "SRPATMKeypad" )
	self.m_pnlKeypad:SetSize( 335, 271 )
	self.m_pnlKeypad:SetEntity( self )
	self.m_pnlKeypad:SetPaintedManually( true )
	self.m_pnlKeypad:SetMouseInputEnabled( false )
	self.m_pnlKeypad:SetPos( -(self.m_pnlKeypad:GetWide() +1), -(self.m_pnlKeypad:GetTall() +1) )
end

local function ClearInput( ent )
	if not ent.m_pnlMenu then return end
	if not ent.m_pnlKeypad then return end

	if vgui3D.GetInputWindows()[ent.m_pnlMenu] then
		ent.m_pnlMenu:OnInputLost()
	end
	vgui3D.GetInputWindows()[ent.m_pnlMenu] = nil
	vgui3D.GetInputWindows()[ent.m_pnlKeypad] = nil
end

local function EnableInput( ent )
	if not ent.m_pnlMenu then return end
	if not ent.m_pnlKeypad then return end

	if not vgui3D.GetInputWindows()[ent.m_pnlMenu] then
		ent.m_pnlMenu:OnInputGained()
	end

	vgui3D.GetInputWindows()[ent.m_pnlMenu] = true
	vgui3D.GetInputWindows()[ent.m_pnlKeypad] = true
end

local function RenderMenu( ent )
	if not ValidPanel( ent.m_pnlMenu ) then return end
	if not ValidPanel( ent.m_pnlKeypad ) then return end
	
	--Enable input in range
	if ent:GetPos():DistToSqr( LocalPlayer():EyePos() ) <= ent.m_intMaxUseRange ^2 then
		EnableInput( ent )
	else
		ClearInput( ent )
	end
	
	local angs = ent:LocalToWorldAngles( ent.m_angMenuAngs )
	local pos = ent:LocalToWorld( ent.m_vecMenuPos )
	vgui3D.Start3D2D( pos, angs, 0.0234 )
		vgui3D.Paint3D2D( ent.m_pnlMenu )
	vgui3D.End3D2D()

	angs = ent:LocalToWorldAngles( ent.m_angKeypadAngs )
	pos = ent:LocalToWorld( ent.m_vecKeypadPos )
	vgui3D.Start3D2D( pos, angs, 0.015 )
		vgui3D.Paint3D2D( ent.m_pnlKeypad )
	vgui3D.End3D2D()
end

g_atmCache = g_atmCache or {}
hook.Add( "NetworkEntityCreated", "Cache_ATMs", function( eEnt )
	if eEnt:GetClass() ~= "ent_atm" then return end
	g_atmCache[eEnt] = true
end )

hook.Add( "PostDrawOpaqueRenderables", "Draw_ATM_Menus", function()
	local old = render.GetToneMappingScaleLinear()
	render.SetToneMappingScaleLinear( Vector(1, 1, 1) )
	render.SuppressEngineLighting( true )
	--render.PushFilterMag( 3 )
	--render.PushFilterMin( 3 )

	for k, v in pairs( g_atmCache ) do
		if not IsValid( k ) then g_atmCache[k] = nil continue end
		if not k.m_pnlMenu then return end
		if not k.m_pnlKeypad then return end

		--Draw only in range
		if k:GetPos():DistToSqr( LocalPlayer():EyePos() ) > k.m_intMaxRenderRange ^2 then
			ClearInput( k )
			continue
		end

		--Draw only when we can see it
		local viewNorm = (k:GetPos() -LocalPlayer():EyePos()):GetNormalized()
		if viewNorm:Dot( k:GetAngles():Forward() * -1 ) <= 0.2 then
			ClearInput( k )
			continue
		end

		RenderMenu( k )
	end

	--render.PopFilterMag()
	--render.PopFilterMin()
	render.SuppressEngineLighting( false )
	render.SetToneMappingScaleLinear( old ) 
end )