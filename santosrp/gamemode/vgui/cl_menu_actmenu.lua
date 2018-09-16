--[[
	Name: cl_menu_actmenu.lua
	For: TalosLife
	By: TalosLife

	Push and hold "T" to view the taunt menu, mouse over an action and release "T".
]]--
local MAT_BLUR = Material( "pp/blurscreen.png", "noclamp" )
local Actions = {
	"Cheer",
	"Laugh",
	"Muscle",
	"Zombie",
	"Robot",
	"Disagree",
	"Agree",
	"Dance",
	"Becon",
	"Salute",
	"Wave",
	"Forward",
	"Pers",
}

local Panel = {}
function Panel:Init()
	self:Build()
end

function Panel:Build()
	if self.m_tblButtons then
		for k, v in pairs( self.m_tblButtons ) do
			if ValidPanel( v ) then v:Remove() end		
		end
	end
	
	self.m_strSndHover = Sound( "garrysmod/ui_hover.wav" )
	self.m_matBlur = MAT_BLUR
	self.m_texWhite = surface.GetTextureID( "vgui/white" )
	self.m_int360 = math.pi *2
	self.m_intCurAngle = 90
	self.m_intTargetAngle = 90
	
	self:InitializeButtons()
end

function Panel:InitializeButtons()
	self.m_tblButtons = {}
	for k, v in ipairs( Actions ) do
		self.m_tblButtons[k] = {
			Name = v,
			Cmd = v:lower(),

		}
	end

	local count = #self.m_tblButtons
	self.m_intBtnAng = math.pi *2 /count
	
	for k, v in pairs( self.m_tblButtons ) do
		v.Angle = (k -2) *self.m_intBtnAng -math.pi /2
		
		while v.Angle < 0 do
			v.Angle = v.Angle +math.pi *2
		end
	end
end

local MOUSE_CHECK_DIST = 120
local MOUSE_CUR_DIST = 0
function Panel:Think()
	if IsValid( LocalPlayer() ) and LocalPlayer().HandsUp and self:IsVisible() then
		self:SetVisible( false )
		return
	end
	
	local mx, my 	= gui.MousePos()
	local cx, cy 	= ScrW() /2, ScrH() /2
	MOUSE_CUR_DIST 	= math.Distance( mx, my, cx, cy )

	if MOUSE_CUR_DIST > 48 then
		local norm = Vector( mx -cx, cy -my, 0 ):GetNormal()
		self.m_intTargetAngle = norm:Angle().y

		if MOUSE_CUR_DIST > MOUSE_CHECK_DIST then
			gui.SetMousePos( cx +norm.x *MOUSE_CHECK_DIST, cy -norm.y *MOUSE_CHECK_DIST )
		end
	end

	self.m_intCurAngle = math.ApproachAngle( self.m_intCurAngle, self.m_intTargetAngle, 55 *(math.AngleDifference(self.m_intCurAngle, self.m_intTargetAngle) /180) )
	
	self.m_intCurSelection, _ = self:GetCurrentSelection()
	if self.m_intLastSelection and self.m_intCurSelection ~= self.m_intLastSelection then
		surface.PlaySound( self.m_strSndHover )
	end
	
	self.m_intLastSelection = self.m_intCurSelection
end

function Panel:GetCurrentSelection()
	local selectionAngle, selection = -1, nil
	local selectedAng = -1

	for k, v in pairs( self.m_tblButtons ) do
		local ang = math.deg( v.Angle -self.m_intBtnAng /2 )
		local diff = math.AngleDifference( self.m_intCurAngle, ang )
		
		if selectionAngle == -1 or diff < selectionAngle then
			selectionAngle = diff
			selection = k
			selectedAng = math.deg( v.Angle ) +180
		end
	end

	return selection, math.NormalizeAngle( selectedAng )
end

function Panel:BuildPoly( x, y, radius, count )
	self.m_tblCurrentPoly = { x = x, y = y, radius = radius, count = count }
	local delta = self.m_int360 /count
	local verts = {}

	for n = 0, self.m_int360, delta do
		local c, s = math.cos( n ), math.sin( n )
		table.insert( verts, {
			x = x +c *radius,
			y = y +s *radius,
			u = 0.5 +c *0.5,
			v = 0.5 +s *0.5
		} )
	end

	self.m_tblCurrentPoly.Verts = verts
end

function Panel:DrawCircle( x, y, radius, count )
	local cur = self.m_tblCurrentPoly
	if not cur or cur.x ~= x or cur.y ~= y or cur.radius ~= radius or cur.count ~= count then
		self:BuildPoly( x, y, radius, count )
	end
	
	if self.m_tblCurrentPoly and self.m_tblCurrentPoly.Verts then
		surface.SetTexture( self.m_texWhite )
		surface.DrawPoly( self.m_tblCurrentPoly.Verts )
	end
end

function Panel:PaintBackground( intW, intH )
	local bgRadius = intW /2
	local bgPolyCount = 38

	surface.SetDrawColor( 30, 30, 30, 125 )
	self:DrawCircle( intW -bgRadius, bgRadius, bgRadius, bgPolyCount )

	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilWriteMask( 1 )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )

	surface.SetDrawColor( 255, 255, 255, 255 )
	self:DrawCircle( intW -bgRadius, bgRadius, bgRadius, bgPolyCount )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		surface.SetMaterial( self.m_matBlur )
		surface.SetDrawColor( 255, 255, 255, 255 )

		for i = 0, 1, 0.33 do
			self.m_matBlur:SetFloat( '$blur', 5 *i )
			self.m_matBlur:Recompute()
			render.UpdateScreenEffectTexture()

			local x, y = self:GetPos()
			surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
		end
	render.SetStencilEnable( false )
end

function Panel:Paint( intW, intH )
	local sx, sy = intW /2, intH /2
	local size, size_half, center = intW, intW /2, intW /2.66

	self:PaintBackground( intW, intH )
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	for k, v in pairs( self.m_tblButtons ) do
		local brightness 	= (k == self.m_intCurSelection and 255 or 125)
		local ang 			= v.Angle
		local vx, vy 		= math.cos( ang ), math.sin( ang )
		local x, y 			= sx -vx *center, sy +vy *(center -1)
		local lx, ly 		= math.cos( ang +self.m_intBtnAng /2 ), math.sin( ang +self.m_intBtnAng /2 )

		surface.SetDrawColor( 80, 80, 80, 200 )
		surface.DrawLine( sx +lx *74, sy +ly *74, sx +lx *128, sy +ly *128 )
		
		surface.SetFont( "DermaDefaultBold" )
		local tw, th = surface.GetTextSize( v.Name )

		surface.SetTextColor( 0, 0, 0, 255 )
		for _x = -1, 1 do
			for _y = -1, 1 do
				surface.SetTextPos( (x -tw /2) +_x, (y -th /2) +_y )
				surface.DrawText( v.Name )
			end
		end

		surface.SetTextColor( brightness, brightness, brightness, 220 )
		surface.SetTextPos( x -tw /2, y -th /2 )
		surface.DrawText( v.Name )
	end
end

function Panel:Open()
	if IsValid( LocalPlayer() ) and LocalPlayer().HandsUp then return end
	
	self:SetVisible( true )
	self:MakePopup()
	self:SetKeyBoardInputEnabled( false )
	
	local selection, ang = self:GetCurrentSelection()
	self.m_intTargetAngle = ang
	self.m_intCurAngle = ang
end

function Panel:Close()
	local selection, _ = self:GetCurrentSelection()
	local action = self.m_tblButtons[selection]
	if action then
		RunConsoleCommand( "act", action.Cmd )
	end

	self:SetVisible( false )
end
vgui.Register( "SRPActRadialMenu", Panel, "EditablePanel" )