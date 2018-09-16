--[[
	Name: cl_computer_panels.lua
	For: TalosLife
	By: TalosLife
]]--

local PANEL = {}
function PANEL:Init()
	self.Offset = 0
	self.Scroll = 0
	self.CanvasSize = 1
	self.BarSize = 1	
	
	self.btnUp = vgui3D.Create( "DButton", self )
	self.btnUp:SetText( "" )
	self.btnUp.DoClick = function ( self ) self:GetParent():AddScroll( -1 ) end
	self.btnUp.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonUp", panel, w, h ) end
	
	self.btnDown = vgui3D.Create( "DButton", self )
	self.btnDown:SetText( "" )
	self.btnDown.DoClick = function ( self ) self:GetParent():AddScroll( 1 ) end
	self.btnDown.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonDown", panel, w, h ) end
	
	self.btnGrip = vgui3D.Create( "DScrollBarGrip", self )
	
	self:SetSize( 15, 15 )
end

function PANEL:SetEnabled( b )
	if ( !b ) then
		self.Offset = 0
		self:SetScroll( 0 )
		self.HasChanged = true	
	end
	
	self:SetMouseInputEnabled( b )
	self:SetVisible( b )
	
	-- We're probably changing the width of something in our parent
	-- by appearing or hiding, so tell them to re-do their layout.
	if ( self.Enabled != b ) then
		self:GetParent():InvalidateLayout()
		if ( self:GetParent().OnScrollbarAppear ) then
			self:GetParent():OnScrollbarAppear()
		end
	end
	
	self.Enabled = b		
end

function PANEL:Value()
	return self.Pos	
end

function PANEL:BarScale()
	if ( self.BarSize == 0 ) then return 1 end
	return self.BarSize / (self.CanvasSize+self.BarSize)	
end

function PANEL:SetUp( _barsize_, _canvassize_ )
	self.BarSize 	= _barsize_
	self.CanvasSize = math.max( _canvassize_ - _barsize_, 1 )

	self:SetEnabled( _canvassize_ > _barsize_ )
	self:InvalidateLayout()		
end

function PANEL:OnMouseWheeled( dlta )
	if ( !self:IsVisible() ) then return false end
	-- We return true if the scrollbar changed.
	-- If it didn't, we feed the mousehweeling to the parent panel
	return self:AddScroll( dlta * -2 )	
end

function PANEL:AddScroll( dlta )
	local OldScroll = self:GetScroll()
	dlta = dlta * 25
	self:SetScroll( self:GetScroll() + dlta )
	
	return OldScroll != self:GetScroll()	
end

function PANEL:SetScroll( scrll )
	if ( !self.Enabled ) then self.Scroll = 0 return end
	self.Scroll = math.Clamp( scrll, 0, self.CanvasSize )
	self:InvalidateLayout()
	
	-- If our parent has a OnVScroll function use that, if
	-- not then invalidate layout (which can be pretty slow)
	local func = self:GetParent().OnVScroll
	if ( func ) then
		func( self:GetParent(), self:GetOffset() )
	else
		self:GetParent():InvalidateLayout()
	end	
end

function PANEL:AnimateTo( scrll, length, delay, ease )
	local anim = self:NewAnimation( length, delay, ease )
	anim.StartPos = self.Scroll
	anim.TargetPos = scrll
	anim.Think = function( anim, pnl, fraction )
		pnl:SetScroll( Lerp( fraction, anim.StartPos, anim.TargetPos ) )
	end	
end

function PANEL:GetScroll()
	if ( !self.Enabled ) then self.Scroll = 0 end
	return self.Scroll	
end

function PANEL:GetOffset()
	if ( !self.Enabled ) then return 0 end
	return self.Scroll * -1	
end

function PANEL:Think()
end

function PANEL:Paint( w, h )
	derma.SkinHook( "Paint", "VScrollBar", self, w, h )
	return true	
end

function PANEL:OnMousePressed()
	local rootX, rootY = vgui3D.GetMouseOffset()
	local mx, my = gui.MouseX(), gui.MouseY()
	mx = mx +rootX
	my = my +rootY

	local x, y = self:ScreenToLocal( mx, my )
	local PageSize = self.BarSize

	if ( y > self.btnGrip.y ) then
		self:SetScroll( self:GetScroll() + PageSize )
	else
		self:SetScroll( self:GetScroll() - PageSize )
	end	
end

function PANEL:OnMouseReleased()
	self.Dragging = false
	self.DraggingCanvas = nil
	self:MouseCapture( false )
	self.btnGrip.Depressed = false
end

function PANEL:GetMousePos()
	local root
	local pnl = self
	while ValidPanel( pnl:GetParent() ) do
		if pnl.m_func3DCustomMouseFunc then
			root = pnl
			break
		end

		pnl = pnl:GetParent()
	end

	if not ValidPanel( root ) then return 0, 0 end
	return root:GetMousePos()
end

function PANEL:OnCursorMoved( x, y )
	if ( !self.Enabled ) then return end
	if ( !self.Dragging ) then return end

	local rootX, rootY = vgui3D.GetMouseOffset()
	local mx, my = self:GetMousePos()
	mx = mx +rootX
	my = my +rootY

	local x, y = self:ScreenToLocal( mx, my )

	-- Uck. 
	y = y - self.btnUp:GetTall()
	y = y - self.HoldPos
	
	local TrackSize = self:GetTall() - self:GetWide() * 2 - self.btnGrip:GetTall()
	y = y / TrackSize
	
	self:SetScroll( y * self.CanvasSize )	
end

function PANEL:Grip()
	if ( !self.Enabled ) then return end
	if ( self.BarSize == 0 ) then return end

	self:MouseCapture( true )
	self.Dragging = true
	
	local x, y = 0, gui.MouseY()
	local x, y = self.btnGrip:ScreenToLocal( x, y )
	self.HoldPos = y
	self.btnGrip.Depressed = true
end

function PANEL:PerformLayout()
	local Wide = self:GetWide()
	local Scroll = self:GetScroll() / self.CanvasSize
	local BarSize = math.max( self:BarScale() * (self:GetTall() - (Wide * 2)), 10 )
	local Track = self:GetTall() - (Wide * 2) - BarSize
	Track = Track + 1
	Scroll = Scroll * Track
	
	self.btnGrip:SetPos( 0, Wide + Scroll )
	self.btnGrip:SetSize( Wide, BarSize )
	
	self.btnUp:SetPos( 0, 0, Wide, Wide )
	self.btnUp:SetSize( Wide, Wide )
	
	self.btnDown:SetPos( 0, self:GetTall() - Wide, Wide, Wide )
	self.btnDown:SetSize( Wide, Wide )
end
vgui.Register( "SRPComputer_DVScrollBar", PANEL, "DPanel" )



local PANEL = {}
AccessorFunc( PANEL, "Padding", "Padding" )
AccessorFunc( PANEL, "pnlCanvas", "Canvas" )
function PANEL:Init()
	self.pnlCanvas 	= vgui3D.Create( "Panel", self )
	self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.PerformLayout = function( pnl )
		self:PerformLayout()
		self:InvalidateParent()
	end
	
	-- Create the scroll bar
	self.VBar = vgui3D.Create( "SRPComputer_DVScrollBar", self )
	self.VBar:Dock( RIGHT )

	--self.VBar.Paint = function() end

	--local paintBtn = function( p, intW, intH )
	--	if p.Depressed then
	--		surface.SetDrawColor( 55, 55, 55, 200 )
	--	elseif p.Hovered then
	--		surface.SetDrawColor( 100, 100, 100, 150 )
	--	else
	--		surface.SetDrawColor( 80, 80, 80, 150 )
	--	end
--
	--	surface.DrawRect( 0, 0, intW, intH )
	--end

	--self.VBar.btnUp.Paint = paintBtn
	--self.VBar.btnDown.Paint = paintBtn
	
	--self.VBar.btnGrip.Paint = function( p, intW, intH )
	--	if p.Depressed then
	--		surface.SetDrawColor( 70, 70, 70, 200 )
	--	elseif p.Hovered then
	--		surface.SetDrawColor( 130, 130, 130, 175 )
	--	else
	--		surface.SetDrawColor( 120, 120, 120, 175 )
	--	end
--
	--	surface.DrawRect( 0, 0, intW, intH )
	--end

	self:SetPadding( 0 )
	self:SetMouseInputEnabled( true )
	
	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:SetPaintBackground( false )

	self:NoClipping( true )
end

function PANEL:AddItem( pnl )
	pnl:SetParent( self:GetCanvas() )
end

function PANEL:OnChildAdded( child )
	self:AddItem( child )
end

function PANEL:SizeToContents()
	self:SetSize( self.pnlCanvas:GetSize() )
end

function PANEL:GetVBar()
	return self.VBar
end

function PANEL:GetCanvas()
	return self.pnlCanvas
end

function PANEL:InnerWidth()
	return self:GetCanvas():GetWide()
end

function PANEL:Rebuild()
	self:GetCanvas():SizeToChildren( false, true )

	-- Although this behaviour isn't exactly implied, center vertically too
	if self.m_bNoSizing and self:GetCanvas():GetTall() < self:GetTall() then
		self:GetCanvas():SetPos( 0, (self:GetTall() -self:GetCanvas():GetTall()) *0.5 )
	end
end

function PANEL:OnMouseWheeled( dlta )
	return self.VBar:OnMouseWheeled( dlta )
end

function PANEL:OnVScroll( iOffset )
	self.pnlCanvas:SetPos( 0, iOffset )
end

function PANEL:ScrollToChild( panel )
	self:PerformLayout()
	
	local x, y = self.pnlCanvas:GetChildPosition( panel )
	local w, h = panel:GetSize()
	y = y +h *0.5
	y = y -self:GetTall() *0.5

	self.VBar:AnimateTo( y, 0.5, 0, 0.5 )
end

function PANEL:PerformLayout()
	local Wide = self:GetWide()
	local YPos = 0
	
	self:Rebuild()
	self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
	YPos = self.VBar:GetOffset()
		
	if self.VBar.Enabled then Wide = Wide -self.VBar:GetWide() end
	self.pnlCanvas:SetPos( 0, YPos )
	self.pnlCanvas:SetWide( Wide )
	self:Rebuild()
end

function PANEL:Clear()
	return self.pnlCanvas:Clear()
end
vgui.Register( "SRPComputer_ScrollPanel", PANEL, "DPanel" )




local PANEL = {}
AccessorFunc( PANEL, "m_iOverlap", 			"Overlap" )
AccessorFunc( PANEL, "m_bShowDropTargets", 	"ShowDropTargets", FORCE_BOOL )
function PANEL:Init()
	self.Panels = {}
	self.OffsetX = 0
	self.FrameTime = 0
	
	self.pnlCanvas = vgui3D.Create( "DDragBase", self )
	self.pnlCanvas:SetDropPos( "6" )
	self.pnlCanvas:SetUseLiveDrag( false )
	self.pnlCanvas.OnModified = function() self:OnDragModified() end
	
	self.pnlCanvas.UpdateDropTarget = function( Canvas, drop, pnl )
		if not self:GetShowDropTargets() then return end
		DDragBase.UpdateDropTarget( Canvas, drop, pnl )
	end
	
	self.pnlCanvas.OnChildAdded = function( Canvas, child )
		local dn = Canvas:GetDnD()
		if ( dn ) then
			child:Droppable( dn )
			child.OnDrop = function()
				local x, y = Canvas:LocalCursorPos()
				local closest, id = self.pnlCanvas:GetClosestChild( x, Canvas:GetTall() / 2 ), 0
				
				for k, v in pairs( self.Panels ) do
					if v == closest then id = k break end
				end
				
				table.RemoveByValue( self.Panels, child )
				table.insert( self.Panels, id, child )
				
				self:InvalidateLayout()
				
				return child
			end
		end
	end
	
	self:SetOverlap( 0 )
	
	self.btnLeft = vgui3D.Create( "DButton", self )
	self.btnLeft:SetText( "" )
	self.btnLeft.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonLeft", panel, w, h ) end
	
	self.btnRight = vgui3D.Create( "DButton", self )
	self.btnRight:SetText( "" )
	self.btnRight.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonRight", panel, w, h ) end

	self:NoClipping( true )
end

function PANEL:OnDragModified()
	-- Override me
end

function PANEL:SetUseLiveDrag( bool )
	self.pnlCanvas:SetUseLiveDrag( bool )
end

function PANEL:MakeDroppable( name )
	self.pnlCanvas:MakeDroppable( name )
end

function PANEL:AddPanel( pnl )
	table.insert( self.Panels, pnl )
	pnl:SetParent( self.pnlCanvas )
	self:InvalidateLayout(true)
end

function PANEL:OnMouseWheeled( dlta )
	self.OffsetX = self.OffsetX + dlta * -30
	self:InvalidateLayout( true )
	return true
end

function PANEL:GetMousePos()
	local root
	local pnl = self
	while ValidPanel( pnl:GetParent() ) do
		if pnl.m_func3DCustomMouseFunc then
			root = pnl
			break
		end

		pnl = pnl:GetParent()
	end

	if not ValidPanel( root ) then return 0, 0 end
	return root:GetMousePos()
end

function PANEL:Think()
	-- Hmm.. This needs to really just be done in one place
	-- and made available to everyone.
	local FrameRate = VGUIFrameTime() - self.FrameTime
	self.FrameTime = VGUIFrameTime()

	if ( self.btnRight:IsDown() ) then
		self.OffsetX = self.OffsetX + (500 * FrameRate)
		self:InvalidateLayout( true )
	end
	
	if ( self.btnLeft:IsDown() ) then
		self.OffsetX = self.OffsetX - (500 * FrameRate)
		self:InvalidateLayout( true )
	end
	
	if ( dragndrop.IsDragging() ) then
		local mousex, mousey = self:GetMousePos()
		local absX, absY = self:LocalToScreen( 0, 0 )
		local x, y = mousex -absX, mouseY- absY --self:LocalCursorPos()
		
		if x < 30 then
			self.OffsetX = self.OffsetX - (350 * FrameRate)
		elseif x > self:GetWide() - 30 then
			self.OffsetX = self.OffsetX + (350 * FrameRate)
		end
		
		self:InvalidateLayout( true )
	end
end 

function PANEL:PerformLayout()
	local w, h = self:GetSize()
	self.pnlCanvas:SetTall( h )
	
	local x = 0
	for k, v in pairs( self.Panels ) do
		v:SetPos( x, 0 )
		v:SetTall( h )
		v:ApplySchemeSettings()
		
		x = x + v:GetWide() - self.m_iOverlap
	end
	
	self.pnlCanvas:SetWide( x + self.m_iOverlap )
	
	if ( w < self.pnlCanvas:GetWide() ) then
		self.OffsetX = math.Clamp( self.OffsetX, 0, self.pnlCanvas:GetWide() - self:GetWide() )
	else
		self.OffsetX = 0
	end
	
	self.pnlCanvas.x = self.OffsetX * -1
	
	self.btnLeft:SetSize( 15, 15 )
	self.btnLeft:AlignLeft( 4 )
	self.btnLeft:AlignBottom( 5 )
	
	self.btnRight:SetSize( 15, 15 )
	self.btnRight:AlignRight( 4 )
	self.btnRight:AlignBottom( 5 )
	
	self.btnLeft:SetVisible( self.pnlCanvas.x < 0 )
	self.btnRight:SetVisible( self.pnlCanvas.x + self.pnlCanvas:GetWide() > self:GetWide() )
end
vgui.Register( "SRPComputer_DHorizontalScroller", PANEL, "Panel" )



local PANEL = {}
AccessorFunc( PANEL, "NumSlider", 			"NumSlider" )
AccessorFunc( PANEL, "m_fSlideX", 			"SlideX" )
AccessorFunc( PANEL, "m_fSlideY", 			"SlideY" )
AccessorFunc( PANEL, "m_iLockX", 			"LockX" )
AccessorFunc( PANEL, "m_iLockY", 			"LockY" )
AccessorFunc( PANEL, "Dragging", 			"Dragging" )
AccessorFunc( PANEL, "m_bTrappedInside", 	"TrapInside" )
AccessorFunc( PANEL, "m_iNotches", 			"Notches" )
Derma_Hook( PANEL, "Paint", "Paint", "Slider" )

function PANEL:Init()
	self:SetMouseInputEnabled( true )
	
	self:SetSlideX( 0.5 )
	self:SetSlideY( 0.5 )
	
	self.Knob = vgui3D.Create( "DButton", self )
	self.Knob:SetText( "" )
	self.Knob:SetSize( 15, 15 )
	self.Knob:NoClipping( true )
	self.Knob.Paint = function( panel, w, h )
		derma.SkinHook( "Paint", "SliderKnob", panel, w, h )
	end
	self.Knob.OnCursorMoved = function( panel, x, y )
		local root
		local pnl = panel
		while ValidPanel( pnl:GetParent() ) do
			if pnl.m_func3DCustomMouseFunc then
				root = pnl
				break
			end

			pnl = pnl:GetParent()
		end

		local x, y = panel:LocalToScreen( 0, 0 ) --abs pos of panel origin
		local rootX, rootY = root:GetPos()

		local mx, my = root:GetMousePos() --mouse pos
		mx = mx +rootX
		my = my +rootY

		self:OnCursorMoved( self:ScreenToLocal(mx, my) )
	end
	
	self:SetLockY( 0.5 )
end

function PANEL:IsEditing()
	return self.Dragging || self.Knob.Depressed
end

function PANEL:SetBackground( img )
	if ( !self.BGImage ) then
		self.BGImage = vgui3D.Create( "DImage", self )
	end
	
	self.BGImage:SetImage( img )
	self:InvalidateLayout()
end

function PANEL:OnCursorMoved( x, y )
	if ( !self.Dragging && !self.Knob.Depressed ) then return end
	
	local w, h = self:GetSize()
	local iw, ih = self.Knob:GetSize()
	
	if ( self.m_bTrappedInside ) then
		w = w - iw
		h = h - ih
		
		x = x - iw * 0.5
		y = y - ih * 0.5
	end
	
	x = math.Clamp( x, 0, w ) / w
	y = math.Clamp( y, 0, h ) / h
	
	if ( self.m_iLockX ) then x = self.m_iLockX end
	if ( self.m_iLockY ) then y = self.m_iLockY end
	
	x, y = self:TranslateValues( x, y )
	
	self:SetSlideX( x )
	self:SetSlideY( y )
	
	self:InvalidateLayout()
end

function PANEL:TranslateValues( x, y )
	-- Give children the chance to manipulate the values..
	return x, y
end

function PANEL:GetMousePos()
	local root
	local pnl = self
	while ValidPanel( pnl:GetParent() ) do
		if pnl.m_func3DCustomMouseFunc then
			root = pnl
			break
		end

		pnl = pnl:GetParent()
	end

	if not ValidPanel( root ) then return 0, 0 end
	return root:GetMousePos()
end

function PANEL:OnMousePressed( mcode )
	self:SetDragging( true )
	self:MouseCapture( true )

	local x, y = self:LocalToScreen( 0, 0 ) --abs pos of panel origin
	local rootX, rootY = vgui3D.GetMouseOffset() --root:GetPos()
	local mx, my = gui.MouseX(), gui.MouseY() --self:GetMousePos() --mouse pos
	mx = mx +rootX
	my = my +rootY

	self:OnCursorMoved( self:ScreenToLocal(mx, my) )
end

function PANEL:Think()
	if self.Dragging and not (input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT)) then
		self:OnMouseReleased( input.IsMouseDown(MOUSE_LEFT) and MOUSE_LEFT or MOUSE_RIGHT )
	end
end

function PANEL:OnMouseReleased( mcode )
	self:SetDragging( false )
	self:MouseCapture( false )
end

function PANEL:PerformLayout()
	local w, h = self:GetSize()
	local iw, ih = self.Knob:GetSize()
	
	if ( self.m_bTrappedInside ) then
		w = w - iw
		h = h - ih
		self.Knob:SetPos( (self.m_fSlideX or 0) * w, (self.m_fSlideY or 0) * h )
	else
		self.Knob:SetPos( (self.m_fSlideX or 0) * w - iw * 0.5, (self.m_fSlideY or 0) * h - ih * 0.5 )
	end
	
	if ( self.BGImage ) then
		self.BGImage:StretchToParent(0,0,0,0)
		self.BGImage:SetZPos( -10 )
	end
end

function PANEL:SetSlideX( i )
	self.m_fSlideX = i
	self:InvalidateLayout()
end

function PANEL:SetSlideY( i )
	self.m_fSlideY = i
	self:InvalidateLayout()
end

function PANEL:GetDragging()
	return self.Dragging || self.Knob.Depressed
end
vgui.Register( "SRPComputer_DSlider", PANEL, "Panel" )



local PANEL = {}
function PANEL:Init()
	self.m_intMin = 0
	self.m_intMax = 0

	self.TextArea = vgui3D.Create( "DTextEntry", self )
	self.TextArea:Dock( RIGHT )
	self.TextArea:SetDrawBackground( false )
	self.TextArea:SetWide( 45 )
	self.TextArea:SetNumeric( true )
	self.TextArea.OnChange = function( textarea, val ) self:SetValue( self.TextArea:GetText() ) end

	self.Slider = vgui3D.Create( "SRPComputer_DSlider", self )
	self.Slider:SetLockY( 0.5 )
	self.Slider.TranslateValues = function( slider, x, y ) return self:TranslateSliderValues( x, y ) end
	self.Slider:SetTrapInside( true )
	self.Slider:Dock( FILL )
	self.Slider:SetHeight( 16 )
	Derma_Hook( self.Slider, "Paint", "Paint", "NumSlider" )
	
	self.Label = vgui3D.Create ( "DLabel", self )
	self.Label:Dock( LEFT )
	self.Label:SetMouseInputEnabled( true )

	self:SetTall( 32 )

	self:SetMin( 0 )
	self:SetMax( 1 )
	self:SetDecimals( 2 )
	self:SetText( "" )
	self:SetValue( 0.5 )
end

function PANEL:SetMinMax( min, max )
	self.m_intMin = tonumber( min )
	self.m_intMax = tonumber( max )
	self:UpdateNotches()
end

function PANEL:SetDark( b )
	self.Label:SetDark( b )
end

function PANEL:SetMin( int )
	self.m_intMin = int
end

function PANEL:SetMax( int )
	self.m_intMax = int
end

function PANEL:GetMin()
	return self.m_intMin
end

function PANEL:GetMax()
	return self.m_intMax
end

function PANEL:GetRange()
	return self:GetMax() -self:GetMin()
end

function PANEL:SetMin( min )
	if ( !min ) then min = 0  end
	self.m_intMin = min
	self:UpdateNotches()
end

function PANEL:SetMax( max )
	if ( !max ) then max = 0  end
	self.m_intMax = max
	self:UpdateNotches()
end

function PANEL:SetValue( val )
	val = math.Clamp( tonumber( val ) or 0, self:GetMin(), self:GetMax() )

	if ( val == nil ) then return end
	if ( self:GetValue() == val ) then return end

	self.m_intValue = val
	self:ValueChanged( self:GetValue() )
end

function PANEL:GetValue()
	return self.m_intValue
end

function PANEL:SetDecimals( d )
	self.m_intDec = d
end

function PANEL:GetDecimals()
	return self.m_intDec or 2
end

function PANEL:PerformLayout()
	self.Label:SetWide( self:GetWide() /2.4 )
end

function PANEL:SetText( text )
	self.Label:SetText( text )
end

function PANEL:GetTextValue()
	local iDecimals = self:GetDecimals()
	if ( iDecimals == 0 ) then
		return Format( "%i", self:GetValue() )
	end
	return Format( "%."..iDecimals.."f", self:GetValue() )
end

function PANEL:GetFraction( intVal )
	return 1 -(self:GetMax() -(intVal or self:GetValue())) /self:GetMax()
end

function PANEL:ValueChanged( val )
	val = math.Clamp( tonumber( val ) or 0, self:GetMin(), self:GetMax() )

	self.Slider:SetSlideX( self:GetFraction(val) )
	
	if ( self.TextArea != vgui.GetKeyboardFocus() ) then
		self.TextArea:SetValue( tostring(self:GetTextValue()) )
	end

	self:OnValueChanged( val )
end

function PANEL:OnValueChanged( val )
	-- For override
end

function PANEL:TranslateSliderValues( x, y )
	self:SetValue( self:GetMin() + (x *self:GetRange()) )
	return self:GetFraction(), y
end

function PANEL:GetTextArea()
	return self.TextArea
end

function PANEL:UpdateNotches()
	local range = self:GetRange()
	self.Slider:SetNotches( nil )
	
	if ( range < self:GetWide()/4 ) then
		return self.Slider:SetNotches( range )
	else
		self.Slider:SetNotches( self:GetWide()/4 )
	end
end
vgui.Register( "SRPComputer_DNumSlider", PANEL, "Panel" )



local PANEL = {}
AccessorFunc( PANEL, "m_pPropertySheet", "PropertySheet" )
AccessorFunc( PANEL, "m_pPanel", "Panel" )

function PANEL:Init()
	self:SetMouseInputEnabled( true )
	self:SetContentAlignment( 7 )
	self:SetTextInset( 0, 3 )
	self:SetTall( 20 )
end

function PANEL:Setup( label, pPropertySheet, pPanel, strMaterial )
	self:SetText( label )
	self:SetPropertySheet( pPropertySheet )
	self:SetPanel( pPanel )
	
	if strMaterial then
		self.Image = vgui.Create( "DImage", self )
		self.Image:SetImage( strMaterial )
		self.Image:SizeToContents()
		self:InvalidateLayout()
	end
end

function PANEL:IsActive()
	return self:GetPropertySheet():GetActiveTab() == self
end

function PANEL:DoClick()
	self:GetPropertySheet():SetActiveTab( self )
end

function PANEL:PerformLayout()
	self:ApplySchemeSettings()
	if not self.Image then return end
		
	self.Image:SetPos( 10, 2 )
	if not self:IsActive() then
		self.Image:SetImageColor( Color(255, 255, 255, 150) )
	else
		self.Image:SetImageColor( Color(255, 255, 255, 255) )
	end
end

function PANEL:Paint( intW, intH )
	if self:IsActive() then
		surface.SetDrawColor( 125, 125, 125, 65 )
		surface.DrawRect( 0, 0, intW, intH )
	end
end

function PANEL:UpdateColours( skin )
	local Active = self:GetPropertySheet():GetActiveTab() == self
	if Active then
		if self:GetDisabled() then return self:SetTextStyleColor( skin.Colours.Tab.Active.Disabled ) end
		if self:IsDown() then return self:SetTextStyleColor( skin.Colours.Tab.Active.Down ) end
		if self.Hovered then return self:SetTextStyleColor( skin.Colours.Tab.Active.Hover ) end
		return self:SetTextStyleColor( skin.Colours.Tab.Active.Normal )
	end

	if self:GetDisabled() then return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Disabled ) end
	if self:IsDown() then return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Down ) end
	if self.Hovered then return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Hover ) end
	return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Normal )
end

function PANEL:ApplySchemeSettings()
	local ExtraInset = 15
	if self.Image then
		ExtraInset = ExtraInset + self.Image:GetWide()
	end
	
	self:SetTextInset( ExtraInset, 3 )
	local w, h = self:GetContentSize()
	h = 20
	self:SetSize( w + 20, 20 )
	
	DLabel.ApplySchemeSettings( self )
end

function PANEL:DragHoverClick( HoverTime )
	self:DoClick()
end
vgui.Register( "SRPComputer_DTab", PANEL, "DButton" )



local PANEL = {}
Derma_Hook( PANEL, "Paint", "Paint", "PropertySheet" )
AccessorFunc( PANEL, "m_pActiveTab", "ActiveTab" )
AccessorFunc( PANEL, "m_iPadding", "Padding" )
AccessorFunc( PANEL, "m_fFadeTime", "FadeTime" )
AccessorFunc( PANEL, "m_bShowIcons", "ShowIcons" )

function PANEL:Init()
	self:SetShowIcons( true )
	self.tabScroller = vgui3D.Create( "SRPComputer_DHorizontalScroller", self )
	self.tabScroller:SetOverlap( 5 )
	self.tabScroller:Dock( TOP )
	self:SetFadeTime( 0.1 )
	self:SetPadding( 8 )
		
	self.animFade = Derma_Anim( "Fade", self, self.CrossFade )
	self.Items = {}
end

function PANEL:AddSheet( label, panel, material, NoStretchX, NoStretchY, Tooltip )
	if not IsValid( panel ) then return end

	local Sheet = {}
	Sheet.Name = label
	Sheet.Tab = vgui3D.Create( "SRPComputer_DTab", self )
	Sheet.Tab:SetTooltip( Tooltip )
	Sheet.Tab:Setup( label, self, panel, material )
	
	Sheet.Panel = panel
	Sheet.Panel.NoStretchX = NoStretchX
	Sheet.Panel.NoStretchY = NoStretchY
	Sheet.Panel:SetPos( self:GetPadding(), 20 +self:GetPadding() )
	Sheet.Panel:SetVisible( false )
	
	panel:SetParent( self )
	table.insert( self.Items, Sheet )
	
	if not self:GetActiveTab() then
		self:SetActiveTab( Sheet.Tab )
		Sheet.Panel:SetVisible( true )
	end
	
	self.tabScroller:AddPanel( Sheet.Tab )
	
	return Sheet
end

function PANEL:SetActiveTab( active )
	if self.m_pActiveTab == active then return end
	if self.m_pActiveTab then
		if self:GetFadeTime() > 0 then
			self.animFade:Start( self:GetFadeTime(), { OldTab = self.m_pActiveTab, NewTab = active } )
		else
			self.m_pActiveTab:GetPanel():SetVisible( false )
		end
	end

	self.m_pActiveTab = active
	self:InvalidateLayout()
end

function PANEL:Think()
	self.animFade:Run()
end

function PANEL:CrossFade( anim, delta, data )
	local old = ValidPanel( data.OldTab ) and data.OldTab:GetPanel() or nil
	local new = data.NewTab:GetPanel()
	
	if anim.Finished then
		new:SetAlpha( 255 )
		new:SetZPos( 0 )

		if old then
			old:SetVisible( false )
			old:SetZPos( 0 )
		end
		
		return
	end
	
	if anim.Started then
		new:SetZPos( 1 )
		new:SetAlpha( 0 )

		if old then
			old:SetAlpha( 255 )
			old:SetZPos( 0 )
		end
	end
	
	if old then
		old:SetVisible( true )
	end
	
	new:SetVisible( true )
	new:SetAlpha( 255 * delta )
end

function PANEL:PerformLayout()
	local ActiveTab = self:GetActiveTab()
	local Padding = self:GetPadding()
	
	if not ActiveTab then return end
	ActiveTab:InvalidateLayout( true )
	self.tabScroller:SetTall( ActiveTab:GetTall() )
	
	local ActivePanel = ActiveTab:GetPanel()
	for k, v in pairs( self.Items ) do
		if v.Tab:GetPanel() == ActivePanel then
			v.Tab:GetPanel():SetVisible( true )
			v.Tab:SetZPos( 100 )
		else
			v.Tab:GetPanel():SetVisible( false )	
			v.Tab:SetZPos( 1 )
		end
	
		v.Tab:ApplySchemeSettings()
	end
	
	if not ActivePanel.NoStretchX then 
		ActivePanel:SetWide( self:GetWide() -Padding *2 ) 
	else
		ActivePanel:CenterHorizontal()
	end
	
	if not ActivePanel.NoStretchY then 
		local _, y = ActivePanel:GetPos()
		ActivePanel:SetTall( self:GetTall() -y -Padding )
	else
		ActivePanel:CenterVertical()
	end
	
	ActivePanel:InvalidateLayout()
	-- Give the animation a chance
	self.animFade:Run()
end

function PANEL:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 100 )
	surface.DrawRect( 0, 0, intW, 20 )
end

function PANEL:SizeToContentWidth()
	local wide = 0

	for k, v in pairs( self.Items ) do
		if v.Panel then
			v.Panel:InvalidateLayout( true )
			wide = math.max( wide, v.Panel:GetWide()  +self.m_iPadding *2 )
		end
	end
	
	self:SetWide( wide )
end

function PANEL:SwitchToName( name )
	for k, v in pairs( self.Items ) do
		if v.Name == name then
			v.Tab:DoClick()
			return true
		end
	end
	
	return false
end

function PANEL:SetupCloseButton( func )
	self.CloseButton = self.tabScroller:AddPanel( vgui3D.Create("DImageButton", self.tabScroller) )
	self.CloseButton:SetImage( "icon16/circlecross.png" )
	self.CloseButton:SetColor( Color( 10, 10, 10, 200 ) )
	self.CloseButton:DockMargin( 0, 0, 0, 8 )
	self.CloseButton:SetWide( 16 )
	self.CloseButton:Dock( RIGHT )
	self.CloseButton.DoClick = function() func() end
end

function PANEL:CloseTab( tab, bRemovePanelToo )
	for k, v in pairs( self.Items ) do
		if v.Tab ~= tab then continue end
		table.remove( self.Items, k )
	end
	
	for k, v in pairs( self.tabScroller.Panels ) do
		if v ~= tab then continue end
		table.remove( self.tabScroller.Panels, k )
	end
	
	self.tabScroller:InvalidateLayout( true )
	 
	if tab == self:GetActiveTab() and #self.Items > 0 then
		self.m_pActiveTab = self.Items[#self.Items].Tab
	end
	
	local pnl = tab:GetPanel()
	if ( bRemovePanelToo ) then
		pnl:Remove()
	end

	tab:Remove()
	self:InvalidateLayout( true )
	
	return pnl
end
vgui.Register( "SRPComputer_DPropertySheet", PANEL, "Panel" )


--[[
local PANEL = {}
AccessorFunc( PANEL, "m_bStretchToFit", 			"StretchToFit" )
function PANEL:Init()
	self:SetDrawBackground( false )
	self:SetDrawBorder( false )
	self:SetStretchToFit( true )

	self:SetCursor( "hand" )
	self.m_Image = vgui3D.Create( "DImage", self )
	
	self:SetText( "" )
	
	self:SetColor( Color( 255, 255, 255, 255 ) )
end

function PANEL:SetImageVisible( bBool )
	self.m_Image:SetVisible( bBool )
end

function PANEL:SetImage( strImage, strBackup )
	self.m_Image:SetImage( strImage, strBackup )
end

PANEL.SetIcon = PANEL.SetImage

function PANEL:SetColor( col )
	self.m_Image:SetImageColor( col )
	self.ImageColor = col
end

function PANEL:GetImage()
	return self.m_Image:GetImage()
end

function PANEL:SetKeepAspect( bKeep )
	self.m_Image:SetKeepAspect( bKeep )
end

function PANEL:SetMaterial( Mat )
	self.m_Image:SetMaterial( Mat )
end

function PANEL:SizeToContents( )
	self.m_Image:SizeToContents()
	self:SetSize( self.m_Image:GetWide(), self.m_Image:GetTall() )
end

function PANEL:OnMousePressed( mousecode )
	DButton.OnMousePressed( self, mousecode )

	if ( self.m_bStretchToFit ) then
		self.m_Image:SetPos( 2, 2 )
		self.m_Image:SetSize( self:GetWide() - 4, self:GetTall() - 4 )
	else
		self.m_Image:SizeToContents()
		self.m_Image:SetSize( self.m_Image:GetWide() * 0.8, self.m_Image:GetTall() * 0.8 )
		self.m_Image:Center()
	end
end

function PANEL:OnMouseReleased( mousecode )
	DButton.OnMouseReleased( self, mousecode )

	if ( self.m_bStretchToFit ) then
		self.m_Image:SetPos( 0, 0 )
		self.m_Image:SetSize( self:GetSize() )
	else
		self.m_Image:SizeToContents()
		self.m_Image:Center()
	end
end

function PANEL:PerformLayout()
	if ( self.m_bStretchToFit ) then
		self.m_Image:SetPos( 0, 0 )
		self.m_Image:SetSize( self:GetSize() )
	else
		self.m_Image:SizeToContents()
		self.m_Image:Center()
	end
end

function PANEL:SetDisabled( bDisabled )
	DButton.SetDisabled( self, bDisabled )

	if ( bDisabled ) then
		self.m_Image:SetAlpha( self.ImageColor.a * 0.4 ) 
	else
		self.m_Image:SetAlpha( self.ImageColor.a ) 
	end
end

function PANEL:SetOnViewMaterial( MatName, Backup )
	self.m_Image:SetOnViewMaterial( MatName, Backup )
end
vgui.Register( "SRPComputer_DImageButton", PANEL, "DButton" )]]--