--[[
	Name: cl_menu_phone_app_camera.lua
	For: TalosLife
	By: TalosLife
]]--

hook.Add( "RenderScene", "Update_PhoneCamRT", function()
	if g_InPhoneRender then return end
	if not ValidPanel( g_PhoneCameraMenu ) or not g_PhoneCameraMenu:IsVisible() then return end

	if not g_PhoneCameraMenu.m_rtCamTarget then
		g_PhoneCameraMenu:InitCamera()
		return
	end

	g_InPhoneRender = true
	--print ""
	--print( "start", g_InPhoneRender )
		
		local OldRT = render.GetRenderTarget()
		render.SetRenderTarget( g_PhoneCameraMenu.m_rtCamTarget )
			render.SetViewPort( 0, 0, GAMEMODE.Gui.m_pnlPhone.m_intMenuW, GAMEMODE.Gui.m_pnlPhone.m_intMenuH )
			cam.Start2D()
			render.EnableClipping( true )

			render.Clear( 0, 0, 0, 255 )
			g_CamDrawPlayer = true
			render.RenderView{
				angles = g_PhoneCameraMenu.m_bFaceCam and LocalPlayer():EyeAngles() +Angle( 0, 180, 0 ) or nil,
				origin = g_PhoneCameraMenu.m_bFaceCam and LocalPlayer():EyePos() +(LocalPlayer():GetAngles():Forward() *32) or LocalPlayer():EyePos(),
				x = 0,
				y = 0,
				w = GAMEMODE.Gui.m_pnlPhone.m_intMenuW,
				h = GAMEMODE.Gui.m_pnlPhone.m_intMenuH,
				drawhud = false,
				drawviewmodel = false,
				dopostprocess = false,
				fov = 50,
			}
			g_CamDrawPlayer = false

			render.EnableClipping( false )
			cam.End2D()
			render.SetViewPort( 0, 0, ScrW(), ScrH() )
		render.SetRenderTarget( OldRT )

	g_InPhoneRender = false
	--print( "end", g_InPhoneRender )
	--print ""
end )

--[[
hook.Add( "ShouldDrawLocalPlayer", "Phone_Camera", function()
	--print( "ShouldDrawLocalPlayer", g_InPhoneRender, g_CamDrawPlayer )
	if not g_InPhoneRender then return end
	if g_PhoneCameraMenu.m_bFaceCam and g_CamDrawPlayer then return true end
end )]]--

local Panel = {}
function Panel:Init()
	g_PhoneCameraMenu = self

	self.m_tblContacts = {}

	self.m_pnlToolbar = vgui.Create( "SRPPhone_AppToolbar", self )
	self.m_tblSelect = {}

	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Back", "taloslife/phone/ic_menu_revert.png", function()
		self:GetParent():GetParent():BackPage()
	end) )
	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Swap View", "taloslife/phone/ic_menu_camera.png", function()
		--self.m_bFaceCam = not self.m_bFaceCam
	end) )
	table.insert( self.m_tblSelect, self.m_pnlToolbar:AddButton("Gallery", "taloslife/phone/ic_menu_gallery.png", function()
		GAMEMODE.Gui.m_pnlPhone:ShowApp( "Gallery" )
	end) )

	self.m_pnlBtnTakePic = vgui.Create( "DImageButton", self )
	self.m_pnlBtnTakePic:SetImage( "taloslife/phone/cam_button.png" )
	self.m_pnlBtnTakePic.DoClick = function()
		local pic = self:TakePicture()
		if pic == "" then return end
		
		self:WritePicture( pic )
		GAMEMODE.Gui.m_pnlPhone:GetApp( "Gallery" ):GetAppPanel():Rebuild()
		surface.PlaySound( "npc/scanner/scanner_photo1.wav" )
	end
	table.insert( self.m_tblSelect, self.m_pnlBtnTakePic )

	self.m_intCurSelection = 1
	self.m_tblSelect[self.m_intCurSelection]:SetSelected( true )

	self:InitCamera()
end

function Panel:NextSelection()
	self.m_intCurSelection = self.m_intCurSelection +1

	if self.m_intCurSelection > #self.m_tblSelect then
		self.m_intCurSelection = 1
	end

	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
	end
end

function Panel:LastSelection()
	self.m_intCurSelection = self.m_intCurSelection -1

	if 0 >= self.m_intCurSelection then
		self.m_intCurSelection = #self.m_tblSelect
	end

	for k, v in pairs( self.m_tblSelect ) do
		v:SetSelected( k == self.m_intCurSelection )
	end
end

function Panel:GetCurrentSelection()
	for k, v in pairs( self.m_tblSelect ) do
		if k == self.m_intCurSelection then
			return v
		end
	end
end

function Panel:DoClick()
	self:GetCurrentSelection():DoClick()
end

function Panel:WritePicture( strData )
	local char_id = tonumber( GAMEMODE.Player:GetSharedGameVar(LocalPlayer(), "char_id", "") )
	if not char_id then return end

	if not file.IsDir( "santosrp", "DATA" ) then
		file.CreateDir( "santosrp" )
	end
	if not file.IsDir( "taloslife/phone", "DATA" ) then
		file.CreateDir( "taloslife/phone" )
	end
	if not file.IsDir( "taloslife/phone/photos", "DATA" ) then
		file.CreateDir( "taloslife/phone/photos" )
	end
	if not file.IsDir( "taloslife/phone/photos/".. char_id, "DATA" ) then
		file.CreateDir( "taloslife/phone/photos/".. char_id )
	end

	local fname = os.date( "%m-%d-%Y - %X", os.time() ):gsub( ":", "_" )
	file.Write( "taloslife/phone/photos/".. char_id.. "/".. fname.. ".jpg", strData )
end

function Panel:InitCamera()
	if not GAMEMODE.Gui.m_pnlPhone then return end
	self.m_rtCamTarget = GetRenderTargetEx(
		"phone_camera",
		GAMEMODE.Gui.m_pnlPhone.m_intMenuW,
		GAMEMODE.Gui.m_pnlPhone.m_intMenuH,
		RT_SIZE_NO_CHANGE,
		MATERIAL_RT_DEPTH_SEPARATE,
		bit.bor(2, 4),
		CREATERENDERTARGETFLAGS_UNFILTERABLE_OK,
		IMAGE_FORMAT_RGB888
	)

	self.m_matCamView = CreateMaterial( "Portal", "UnlitGeneric", {
		["$basetexture"] = "phone_camera",
		["$ignorez"] = "1",
		["$vertexcolor"] = "1",
		["$vertexalpha"] = "0",
		["$alpha"] = "1"
	} )
end

function Panel:TakePicture()
	if not self.m_rtCamTarget then return "" end
	
	render.PushRenderTarget( self.m_rtCamTarget )
		local data = render.Capture{
			format = "jpeg",
			quality = 90,
			w = GAMEMODE.Gui.m_pnlPhone.m_intMenuW,
			h = GAMEMODE.Gui.m_pnlPhone.m_intMenuH,
			x = 0,
			y = 0,
		}
	render.PopRenderTarget()

	return data
end

function Panel:Paint( intW, intH )
	if not self.m_matCamView then return end

	surface.SetMaterial( self.m_matCamView )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 36, intW, intH -36 )

	surface.SetDrawColor( 50, 50, 50, 100 )
	surface.DrawRect( 0, self.m_pnlBtnTakePic.y, intW, self.m_pnlBtnTakePic:GetTall() )

	if self:GetCurrentSelection() == self.m_pnlBtnTakePic then
		local x, y = self.m_pnlBtnTakePic:GetPos()
		local w, h = self.m_pnlBtnTakePic:GetSize()

		draw.RoundedBox(
			4,
			x,
			y,
			w,
			h,
			Color( 255, 255, 255, 50 )
		)
	end
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlToolbar:SetPos( 0, 0 )
	self.m_pnlToolbar:SetSize( intW, 36 )

	self.m_pnlBtnTakePic:SetSize( 64, 64 )
	self.m_pnlBtnTakePic:SetPos( (intW /2) -(self.m_pnlBtnTakePic:GetWide() /2), intH *0.75 )
end
vgui.Register( "SRPPhone_App_Camera", Panel, "EditablePanel" )