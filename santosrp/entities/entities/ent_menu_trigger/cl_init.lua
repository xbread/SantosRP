--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
end

function ENT:Draw()
end

surface.CreateFont( "MenuTriggerFont", {size = 128, weight = 425, font = "Trebuchet18"} )
local function DrawMenuTriggerUI( ent )
	surface.SetFont( "MenuTriggerFont" )
	local w, h = surface.GetTextSize( ent:GetText() )
	w = w +35
	h = h +13
	surface.SetDrawColor( 50, 50, 50, 150 )
	surface.DrawRect( -(w /2), 0, w, h )
	draw.SimpleText(
		ent:GetText(),
		"MenuTriggerFont",
		0,
		0,
		color_white,
		TEXT_ALIGN_CENTER
	)
end

local function RenderMenu( ent )
	local angs = ent:LocalToWorldAngles( Angle(180, -90, -90) )
	local pos = ent:LocalToWorld( Vector(0, 0, 0) )
	cam.Start3D2D( pos, angs, 0.03 )
		DrawMenuTriggerUI( ent )
	cam.End3D2D()
end

g_MenuTriggerCache = g_MenuTriggerCache or {}
hook.Add( "NetworkEntityCreated", "Cache_MenuTriggers", function( eEnt )
	if eEnt:GetClass() ~= "ent_menu_trigger" then return end
	g_MenuTriggerCache[eEnt] = true
end )

hook.Add( "PostDrawTranslucentRenderables", "Draw_MenuTriggers", function()
	local old = render.GetToneMappingScaleLinear()
	render.SetToneMappingScaleLinear( Vector(1, 1, 1) )
	render.SuppressEngineLighting( true )
	render.PushFilterMag( 3 )
	render.PushFilterMin( 3 )

	for k, v in pairs( g_MenuTriggerCache ) do
		if not IsValid( k ) then g_MenuTriggerCache[k] = nil continue end
		--Draw only in range
		if k:GetPos():DistToSqr( LocalPlayer():EyePos() ) > k.m_intMaxRenderRange ^2 then
			continue
		end

		RenderMenu( k )
	end

	render.PopFilterMag()
	render.PopFilterMin()
	render.SuppressEngineLighting( false )
	render.SetToneMappingScaleLinear( old ) 
end )