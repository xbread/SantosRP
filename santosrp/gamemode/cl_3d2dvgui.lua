--[[
3D2D VGUI Wrapper
Copyright (c) 2015 Alexander Overvoorde, Matt Stevens
Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--

--[[
changed/modified:
z order system to order panel events
logic for panel events
better cursor pos math, custom cursor pos overload
PaintManual -> PaintAt
added GetInputWindows to allow for custom input/focus rules
no longer detour vgui, use separate vgui3D table
added vgui3D.PostPanelEvent for custom panel events
vgui3D.RealMouseX/Y for getting real cursor position inside of mouse overloads
]]--


--table of functions to check if a panel can receive an event or not
local event_logic = {
	["OnMousePressed"] = function( pnl )
		if not pnl:IsMouseInputEnabled() or not pnl:IsVisible() then return false end
		return true
	end,
	["OnMouseReleased"] = function( pnl )
		if not pnl:IsMouseInputEnabled() or not pnl:IsVisible() then return false end
		return true
	end,
}

local inputWindows = {}
local origin = Vector( 0, 0, 0 )
local angle = Vector( 0, 0, 0 )
local normal = Vector( 0, 0, 0 )
local scale = 0

local rootMX, rootMY
local mouseRootX, mouseRootY
local customMouseFunc, mouseRoot

--Cursor & Events
local function GetInputWindows()
	return inputWindows
end

local function getCursorPos( pnl )
	if customMouseFunc then
		return customMouseFunc( pnl, origin, normal, angle, scale )
	end

	local p = util.IntersectRayWithPlane( LocalPlayer():EyePos(), LocalPlayer():GetAimVector(), origin, normal )
	if not p then return 0, 0 end

	local offset = p -origin
	offset:Rotate( Angle(0, -angle.y, 0) )
	offset:Rotate( Angle(-angle.p, 0, 0) )
	offset:Rotate( Angle(0, 0, -angle.r) )
	return offset.x, -offset.y
end

local function pointInsidePanel( pnl, x, y )
	local px, py = pnl:LocalToScreen( 0, 0 )
	if mouseRoot then --translate the mouse from the plane's local pos to the local pos of the real panel
		local ox, oy = vgui3D.GetMouseOffset()
		px = px -ox
		py = py -oy
	end
	
	local sx, sy = pnl:GetSize()
	x = x /scale
	y = y /scale

	return x >= px and y >= py and x <= px + sx and y <= py + sy
end

local function isMouseOver( pnl )
	return pointInsidePanel( pnl, getCursorPos(pnl) )
end

local function mouseX()
	return rootMX /scale
end

local function mouseY()
	return rootMY /scale
end

local function postPanelEvent( pnl, event, ... )
	if not ValidPanel( pnl ) or not isMouseOver( pnl ) then
		return false
	end

	local handled = false
	for z, child in ipairs( pnl.ZOrder or {} ) do
		if event_logic[event] and not event_logic[event]( child ) then continue end
		if postPanelEvent( child, event, ... ) then
			if pnl.OnEventHandled then pnl:OnEventHandled( event ) end
			handled = true
			break
		end
	end

	if not handled and pnl[event] then
		pnl[event]( pnl, ... )
		return true
	else
		return handled
	end
end

local function checkHover( pnl, x, y )
	if not pnl:GetParent() or not pnl:GetParent().ZOrder then
		if not inputWindows[pnl] then return end	
	end

	pnl.WasHovered = pnl.Hovered
	pnl.Hovered = pointInsidePanel( pnl, x, y )

	if not pnl.WasHovered and pnl.Hovered then
		if pnl.OnCursorEntered then pnl:OnCursorEntered() end
	elseif pnl.WasHovered and not pnl.Hovered then
		if pnl.OnCursorExited then pnl:OnCursorExited() end
	end

	for z, child in ipairs( pnl.ZOrder or {} ) do
		if ValidPanel( child ) and child:IsVisible() then checkHover( child, x, y ) end
	end
end

hook.Add( "KeyPress", "GamemodeVGUI3D2DMousePress", function( _, key )
	for pnl in pairs( inputWindows ) do
		if not pnl.m_bCustom3DMouseMode and key == IN_USE then
			if ValidPanel( pnl ) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				normal = pnl.Normal
				
				vgui3D.PostPanelEvent( pnl, "OnMousePressed", MOUSE_LEFT )
			end
		end
	end
end )

hook.Add( "KeyRelease", "GamemodeVGUI3D2DMouseRelease", function( _, key )
	for pnl in pairs( inputWindows ) do
		if not pnl.m_bCustom3DMouseMode and key == IN_USE then
			if ValidPanel( pnl ) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				normal = pnl.Normal

				vgui3D.PostPanelEvent( pnl, "OnMouseReleased", MOUSE_LEFT )
			end
		end
	end
end )

--Drawing
local function Start3D2D( pos, ang, res )
	origin = pos
	scale = res
	angle = ang
	normal = ang:Up()
	cam.Start3D2D( pos, ang, res )
end

local function Paint3D2D( pnl )
	if not pnl:IsValid() then return end
	if pnl.m_func3DCustomMouseFunc then
		customMouseFunc = pnl.m_func3DCustomMouseFunc
	end

	-- Override gui.MouseX and gui.MouseY for certain stuff
	local oldMouseX = gui.MouseX
	local oldMouseY = gui.MouseY
	mouseRoot = pnl
	mouseRootX, mouseRootY = pnl:GetPos()
	rootMX, rootMY = getCursorPos( pnl )

	gui.MouseX = mouseX
	gui.MouseY = mouseY

	if pnl.Think then
		if not pnl.OThink then
			pnl.OThink = pnl.Think
			pnl.Think = function()
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				normal = pnl.Normal
				
				pnl:OThink()
			end
		end
	end

	checkHover( pnl, rootMX, rootMY )

	-- Store the orientation of the window to calculate the position outside the render loop
	pnl.Origin = origin
	pnl.Scale = scale
	pnl.Angle = angle
	pnl.Normal = normal

	-- Draw it manually
	pnl:SetPaintedManually( false )
		--PaintAt does not follow the normal draw culling, NEAT!
		pnl:PaintAt( 0, 0, pnl:GetWide(), pnl:GetTall() )
	pnl:SetPaintedManually( true )

	gui.MouseX = oldMouseX
	gui.MouseY = oldMouseY
	customMouseFunc = nil
	mouseRoot = nil
	rootMX, rootMY = nil, nil
	mouseRootX, mouseRootY = nil, nil
end

local function End3D2D()
	cam.End3D2D()
end

--Z Pos hax
local function getZIndex( pnl )
	if not pnl:GetParent() then return 0 end
	local idx
	for k, v in pairs( pnl:GetParent().ZOrder or {} ) do
		if v == pnl then idx = k break end
	end
	return idx or 0
end

local function unrefZIndex( pnl )
	if not pnl:GetParent().ZOrder then return end
	
	local idx = pnl:GetZIndex()
	if not idx then return end
	table.remove( pnl:GetParent().ZOrder, idx )
end

local function zOrderChanged( pnl, intOld, intNew )
end

local function setZIndex( pnl, intNewIDX )
	if not pnl:GetParent() or not pnl:GetParent().ZOrder then return end
	local last = pnl:GetZIndex()
	if last and last ~= 0 then
		table.remove( pnl:GetParent().ZOrder, last )
	end

	table.insert( pnl:GetParent().ZOrder, intNewIDX, pnl )

	if pnl.ZOrderChanged then
		pnl:ZOrderChanged( last, intNewIDX )
	end
end

local function moveToFrontZIndex( pnl, ... )
	if pnl.RealRequestFocus then pnl:RealRequestFocus() end
	pnl:SetZIndex( 1 )
end

local function setParent( pnl, parent )
	local old = pnl:GetParent()
	if old and old.Childs then
		for k, child in pairs( old.Childs ) do
			if child == pnl then
				old.Childs[k] = nil
				break
			end
		end
	end

	unrefZIndex( pnl )

	if parent then
		if not parent.Childs then
			parent.Childs = {}
			parent.ZOrder = {}
			setmetatable( parent.ZOrder, {__mode = "v"} )
		end

		pnl.RealSetParent( pnl, parent )
		parent.Childs[pnl] = true
		moveToFrontZIndex( pnl )
	end
end

--Panel Factory & Globals
local function Create( class, parent )
	local pnl = vgui.Create( class, parent )
	if not ValidPanel( pnl ) then return end

	pnl.Parent = parent
	pnl.Class = class
	if parent then
		if not parent.Childs then
			parent.Childs = {}
			parent.ZOrder = {}
			setmetatable( parent.ZOrder, {__mode = "v"} )
		end

		if pnl.OnRemove then pnl.RealOnRemove = pnl.OnRemove end
		pnl.OnRemove = unrefZIndex

		if pnl.RequestFocus then pnl.RealRequestFocus = pnl.RequestFocus end
		pnl.RequestFocus = moveToFrontZIndex

		if pnl.SetParent then pnl.RealSetParent = pnl.SetParent end
		pnl.SetParent = setParent

		pnl.ZOrderChanged = pnl.ZOrderChanged or zOrderChanged
		pnl.GetZIndex = getZIndex
		pnl.SetZIndex = setZIndex

		parent.Childs[pnl] = true
		moveToFrontZIndex( pnl )
	end

	return pnl
end

vgui3D = {}
vgui3D.Start3D2D = Start3D2D
vgui3D.Paint3D2D = Paint3D2D
vgui3D.End3D2D = End3D2D
vgui3D.GetInputWindows = GetInputWindows
vgui3D.Create = Create
vgui3D.SetCustomMouse = function( pnl, bCustomMouse ) pnl.m_bCustom3DMouseMode = bCustomMouse end
vgui3D.SetCustomMouseFunc = function( func ) customMouseFunc = func end
vgui3D.PostPanelEvent = function( pnl, event, ... )
	if pnl.Origin and pnl.Angle and pnl.Normal and pnl.Scale then
		origin = pnl.Origin
		scale = pnl.Scale
		angle = pnl.Angle
		normal = pnl.Normal
	end

	local lastMouseFunc = customMouseFunc
	customMouseFunc = pnl.m_func3DCustomMouseFunc
		local oldMouseX = gui.MouseX
		local oldMouseY = gui.MouseY
		mouseRoot = pnl
		mouseRootX, mouseRootY = pnl:GetPos()
		rootMX, rootMY = getCursorPos( pnl )

		gui.MouseX = mouseX
		gui.MouseY = mouseY

		postPanelEvent( pnl, event, ... )
	customMouseFunc = lastMouseFunc

	gui.MouseX = oldMouseX
	gui.MouseY = oldMouseY
	mouseRoot = nil
	mouseRootX, mouseRootY = nil
	rootMX, rootMY = nil
end
vgui3D.GetRealMouseX = gui.MouseX
vgui3D.GetRealMouseY = gui.MouseY
vgui3D.GetMouseOffset = function()
	return mouseRootX or 0, mouseRootY or 0
end