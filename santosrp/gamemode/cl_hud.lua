--[[
	Name: cl_hud.lua
	
		
]]--

GM.HUD = {}
GM.HUD.m_tblNotes = {}

GM.HUD.m_convBlur = CreateClientConVar( "motion_blur", "0", false, false )
GM.HUD.m_matBlur = Material( "pp/blurscreen.png", "noclamp" )
GM.HUD.m_matLogo = Material( "santosrp/logo.png", "smooth" )
GM.HUD.m_matDeathOverlay = Material( "santosrp/vignette_death.png", "unlitgeneric ignorez" )

GM.HUD.m_tblNoticeMaterial = {}
GM.HUD.m_tblNoticeMaterial[NOTIFY_GENERIC] = Material( "vgui/notices/generic" )
GM.HUD.m_tblNoticeMaterial[NOTIFY_ERROR] = Material( "vgui/notices/error" )
GM.HUD.m_tblNoticeMaterial[NOTIFY_UNDO] = Material( "vgui/notices/undo" )
GM.HUD.m_tblNoticeMaterial[NOTIFY_HINT] = Material( "vgui/notices/hint" )
GM.HUD.m_tblNoticeMaterial[NOTIFY_CLEANUP] = Material( "vgui/notices/cleanup" )

local block = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudCrosshair"] = true,
	["CHudSecondaryAmmo"] = true,
}
hook.Add( "HUDShouldDraw", "BlockHL2HUD", function( strName )
	if block[strName] then return false end
end )

function GM.HUD:Paint()
	if self.m_convBlur:GetBool() then
		DrawMotionBlur( 0.055, 1, 0.001 )
	end

	--surface.SetDrawColor( 255, 255, 255, 255 )
	--surface.SetMaterial( self.m_matLogo )
	--surface.DrawTexturedRect( 0, 0, 88, 46 )

	GAMEMODE.Jail:PaintJailedHUD()
	self:DrawCarHUD()
	self:DrawChopShopOverlay()
	--self:DrawDeathOverlay()
end

function GM.HUD:Think()
	self:UpdateNotes()
end

function GM.HUD:DrawFancyRect( intX, intY, intW, intH, intSlantLeft, intSlantRight, matMaterial )
	intSlantLeft, intSlantRight = math.rad(intSlantLeft), math.rad(intSlantRight)

	local ladj = (intSlantLeft == 90 or intSlantLeft == 270) and 0 or ((1 /math.tan(intSlantLeft)) *intH)
	local radj = (intSlantRight == 90 or intSlantRight == 270) and 0 or ((1 /math.tan(intSlantRight)) *intH)

	local tl = ladj > 0 and ladj or 0
	local bl = ladj > 0 and 0 or -ladj
	local tr = radj > 0 and 0 or -radj
	local br = radj > 0 and radj or 0

	if matMaterial then surface.SetMaterial( matMaterial ) else draw.NoTexture() end
	surface.DrawPoly{
		{ x = intX +tl, y = intY },
		{ x = intX +intW -tr, y = intY },
		{ x = intX +intW -br, y = intY +intH },
		{ x = intX +bl, y = intY +intH }
	}
end

local healthColor = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}
function GM.HUD:RenderScreenspaceEffects()
	local hp, maxHp = LocalPlayer():Health(), 100
	healthColor["$pp_colour_colour"] = math.Clamp( hp /maxHp *2 -1, 0, 1 )
	DrawColorModify( healthColor )
end

--Notifications
function GM.HUD:KillNote( uid )
	if not IsValid( self.m_tblNotes[uid] ) then return end
	self.m_tblNotes[uid].StartTime = SysTime()
	self.m_tblNotes[uid].Length = 0.8
end

function GM.HUD:AddNote( text, type, length )
	local parent = nil
	if GetOverlayPanel then parent = GetOverlayPanel() end

	local Panel = vgui.Create( "SRPNoticePanel", parent )
	Panel.StartTime = SysTime()
	Panel.Length = length and length or 8
	Panel.VelX = -5
	Panel.VelY = 0
	Panel.fx = ScrW() +200
	Panel.fy = ScrH()
	Panel:SetAlpha( 255 )
	Panel:SetText( text )
	Panel:SetType( type )
	Panel:SetPos( Panel.fx, Panel.fy )

	table.insert( self.m_tblNotes, Panel )
	--surface.PlaySound( "ui/beepclear.wav" )
end

function GM.HUD:UpdateNotice( i, Panel, Count )
	local x = Panel.fx
	local y = Panel.fy
	local w = Panel:GetWide()
	local h = Panel:GetTall()
	w = w
	h = h +16
	
	local ideal_y = (ScrH() *0.66) -(Count -i) *(h -12)
	local ideal_x = ScrW() -w
	local timeleft = Panel.StartTime -(SysTime() -Panel.Length)
	
	-- Cartoon style about to go thing
	if timeleft < 0.7 then
		ideal_x = ideal_x -50
	end
	-- Gone!
	if timeleft < 0.2 then
		ideal_x = ideal_x +w *2
	end
	
	local spd = FrameTime() *15
	y = y +Panel.VelY *spd
	x = x +Panel.VelX *spd
	
	local dist = ideal_y -y
	Panel.VelY = Panel.VelY +dist *spd *1
	if math.abs( dist ) < 2 and math.abs( Panel.VelY ) < 0.1 then Panel.VelY = 0 end

	local dist = ideal_x -x
	Panel.VelX = Panel.VelX +dist *spd *1
	if math.abs( dist ) < 2 and math.abs( Panel.VelX ) < 0.1 then Panel.VelX = 0 end
	
	-- Friction.. kind of FPS independant.
	Panel.VelX = Panel.VelX *(0.95 -FrameTime() *8 )
	Panel.VelY = Panel.VelY *(0.95 -FrameTime() *8 )
	Panel.fx = x
	Panel.fy = y
	Panel:SetPos( Panel.fx, Panel.fy )
end

function GM.HUD:UpdateNotes()
	local i = 0
	local Count = table.Count( self.m_tblNotes )
	for key, Panel in pairs( self.m_tblNotes ) do
		i = i +1
		self:UpdateNotice( i, Panel, Count )
	end
	
	for k, Panel in pairs( self.m_tblNotes ) do
		if not IsValid( Panel ) or Panel:KillSelf() then self.m_tblNotes[k] = nil end
	end
end

function GM.HUD:DrawDeathOverlay()
	if LocalPlayer():Alive() or not LocalPlayer():GetCharacterID() then return end
	
	DrawMotionBlur( 0.055, 1, 0.001 )
	surface.SetMaterial( self.m_matDeathOverlay )
	surface.SetDrawColor( Color(255, 255, 255, 255) )
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
	
	if LocalPlayer():InVehicle() then
		local text = "Stabilized"
		draw.SimpleText( text, "Trebuchet24", ScrW() /2, 200, Color(0, 200, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "Trebuchet24", ScrW() /2 +2, 200+2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	else
		local timeelapsed = CurTime() -(LocalPlayer():GetNWFloat("DeathStart") or 0)
		local text = string.ToMinutesSeconds( math.max(GAMEMODE.Config.DeathWaitTime -timeelapsed, 0) )
		draw.SimpleText( text, "Trebuchet24", ScrW() /2, 200, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, "Trebuchet24", ScrW() /2 +2, 200 +2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end

function GM.HUD:DrawChopShopOverlay()
	local start = LocalPlayer():GetNWFloat( "chop_shop_timer", -1 )
	local endtime = LocalPlayer():GetNWFloat( "chop_duration", -1 )

	if start == -1 then return end
	if CurTime() > start +endtime then return end
	
	local text = "Chop Shop - Time Left: ".. GAMEMODE.Util:FormatTime( (start +endtime) -CurTime() )

	surface.SetFont( "DermaLarge" )
	local tw, th = surface.GetTextSize( text )
	local y = math.max( ScrH() *0.05, 50 )

	surface.SetDrawColor( 40, 40, 40, 150 )
	self:DrawFancyRect( 0, y, tw +30, th +10, 90, 80 )

	draw.SimpleTextOutlined(
		text,
		"DermaLarge",
		5,
		y +5,
		Color( 255, 255, 255, 255 ),
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_LEFT,
		1,
		Color( 0, 0, 0, 255 )
	)
end