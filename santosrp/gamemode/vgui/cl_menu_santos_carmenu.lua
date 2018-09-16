--[[
	Name: cl_menu_santos_carmenu.lua
	For: TalosLife
	By: TalosLife
]]--

local OPEN_MENU = 0
local CLOSE_MENU = 1
local PICK_COLOR = 2
local PICK_BODYGROUP = 3
local PICK_SKIN = 4
local SYNC_CLIENT = 5
local SEND_UPGRADES = 6
local BUY_UPGRADE = 7
local UPDATE_GLOW = 8
local FIX_CAR = 9

local PAINT_COST = 300
local SKIN_COST = 500
local BODYGROUP_COST = 500
local STREETGLOW_COST = 750

if g_CarShop and ValidPanel( g_CarShop.m_pnlMenu ) then
	g_CarShop.m_pnlMenu:Remove()
end

g_CarShop = {}
g_CarShop.m_tblNetActions = {}

net.Receive( "carShop", function( intMsgLen )
	local typeID = net.ReadUInt( 8 )
	local func = g_CarShop.m_tblNetActions[typeID]
	if not func then return end
	
	func()
end )

function g_CarShop:AddNetworkAction( intTypeID, fnFunc )
	self.m_tblNetActions[intTypeID] = fnFunc
end

g_CarShop:AddNetworkAction( OPEN_MENU, function()
	if not ValidPanel( g_CarShop.m_pnlMenu ) then
		g_CarShop.m_pnlMenu = vgui.Create( "carMenu" )
	end

	g_CarShop.m_pnlMenu:SetSize( ScrW(), ScrH() )
	g_CarShop.m_pnlMenu:SetPos( 0, 0 )
	g_CarShop.m_pnlMenu:Open()
end )

g_CarShop:AddNetworkAction( CLOSE_MENU, function()
	if ValidPanel( g_CarShop.m_pnlMenu ) then
		g_CarShop.m_pnlMenu:CloseAndRemove()
	end
end )

g_CarShop:AddNetworkAction( SYNC_CLIENT, function()
	LocalPlayer():GetVehicle():SetColor( net.ReadColor() )
	LocalPlayer():GetVehicle():SetSkin( net.ReadUInt(8) )

	local num = net.ReadUInt( 8 )
	if num == 0 then return end
	for i = 1, num do
		LocalPlayer():GetVehicle():SetBodygroup( net.ReadUInt(8), net.ReadUInt(8) )
	end
end )

g_CarShop:AddNetworkAction( SEND_UPGRADES, function()
	local car = net.ReadEntity()
	car.m_tblUpgrades = net.ReadTable()
end )

-- ----------------------------------------------------------------
--[[ Base Menu ]]--
-- ----------------------------------------------------------------
local Panel = {}
function Panel:Init()
	self.m_tblSubMenus = {}
	self.m_tblOptions = {
		{ Text = "Paint", func = function()
			self:ShowSubMenu( "Paint" )
		end },
		{ Text = "Skins", func = function()
			self:ShowSubMenu( "Skins" )
		end, Group = "vip" },
		{ Text = "Underglow", func = function()
			self:ShowSubMenu( "Underglow" )
		end, Group = "vip" },
		{ Text = "Body Groups", func = function()
			self:ShowSubMenu( "Groups" )
		end, Group = "vip" },
		{ Text = "Mods", func = function()
			self:ShowSubMenu( "Mods" )
		end },
		{ Text = "Repair Vehicle", func = function()
			local curCar = LocalPlayer():GetVehicle()
			if not IsValid( curCar ) then return end
			local val = GAMEMODE.Cars:CalcVehicleValue( curCar )
			val = GAMEMODE.CarShop:GetRepairCost( val, GAMEMODE.Cars:GetCarHealth(curCar), GAMEMODE.Cars:GetCarMaxHealth(curCar) )

			GAMEMODE.Gui:Derma_Query(
				"Are you sure? This will cost $".. val,
				"Repair all damage",
				"Repair",
				function()
					net.Start( "carShop" )
						net.WriteUInt( FIX_CAR, 8 )
					net.SendToServer()
					surface.PlaySound( "buttons/button14.wav" )
				end,
				"Back",
				function() end
			)
		end },
		{ Text = "Close", func = function()
			net.Start( "carShop" )
				net.WriteUInt( CLOSE_MENU, 8 )
			net.SendToServer()
		end },
	}

	self.m_pnlContent = vgui.Create( "SRP_FramePanel", self )
	self.m_pnlOptionsContainer = vgui.Create( "EditablePanel", self.m_pnlContent )
	for k, v in ipairs( self.m_tblOptions ) do
		v.pnl = vgui.Create( "SRP_Button", self.m_pnlOptionsContainer )
		v.pnl:SetText( v.Text )
		v.pnl.DoClick = v.func
		v.pnl:SetTall( 32 )
		v.pnl:Dock( TOP )
		v.pnl:DockMargin( 5, 0, 5, 5 )
		v.pnl:SetTextColorOverride( Color(255, 255, 255, 255) )
		v.pnl:SetAlphaOverride( 175 )

		if v.Group then
			v.pnl.Think = function()
				v.pnl:SetDisabled( not LocalPlayer():CheckGroup(v.Group) )
			end
		end
	end

	local pi2 = math.pi *2
	self.m_pnlBtnCamLeft = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnCamLeft:SetText( "<" )
	self.m_pnlBtnCamLeft.DoClick = function()
		local rho, theta, phi = GAMEMODE.Util:CartesianToSpherical( self.m_vecCamPos -self:GetLookAt() )
		local pi2 = math.pi *2
		local rad = 8.25 *(math.pi /180)
		self:LerpCamPos( self:GetLookAt() +GAMEMODE.Util:SphericalToCartesian(self.m_intDist, theta, (phi -rad) %pi2), 0.1 )
	end

	self.m_pnlBtnCamRight = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnCamRight:SetText( ">" )
	self.m_pnlBtnCamRight.DoClick = function()
		local rho, theta, phi = GAMEMODE.Util:CartesianToSpherical( self.m_vecCamPos -self:GetLookAt() )
		local pi2 = math.pi *2
		local rad = 8.25 *(math.pi /180)
		self:LerpCamPos( self:GetLookAt() +GAMEMODE.Util:SphericalToCartesian(self.m_intDist, theta, (phi +rad) %pi2), 0.1 )
	end

	self.m_pnlBtnCamUp = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnCamUp:SetText( "^" )
	self.m_pnlBtnCamUp.DoClick = function()
		local rho, theta, phi = GAMEMODE.Util:CartesianToSpherical( self.m_vecCamPos -self:GetLookAt() )
		local pi2 = math.pi *2
		local rad = 8.25 *(math.pi /180)
		self:LerpCamPos( self:GetLookAt() +GAMEMODE.Util:SphericalToCartesian(self.m_intDist, (theta -rad) %pi2, phi), 0.1 )
	end

	self.m_pnlBtnCamDown = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnCamDown:SetText( "v" )
	self.m_pnlBtnCamDown.DoClick = function()
		local rho, theta, phi = GAMEMODE.Util:CartesianToSpherical( self.m_vecCamPos -self:GetLookAt() )
		local pi2 = math.pi *2
		local rad = 8.25 *(math.pi /180)
		self:LerpCamPos( self:GetLookAt() +GAMEMODE.Util:SphericalToCartesian(self.m_intDist, math.Clamp((theta +rad) %pi2, 0, 1.5), phi), 0.1 )
	end

	self.m_pnlBtnCamZoomIn = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnCamZoomIn:SetText( "+" )
	self.m_pnlBtnCamZoomIn.DoClick = function()
		local rho, theta, phi = GAMEMODE.Util:CartesianToSpherical( self.m_vecCamPos -self:GetLookAt() )
		self.m_intDist = math.max( self.m_intDist -10, 100 )
		self:LerpCamPos( self:GetLookAt() +GAMEMODE.Util:SphericalToCartesian(self.m_intDist, theta, phi), 0.1 )
	end

	self.m_pnlBtnCamZoomOut = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnCamZoomOut:SetText( "-" )
	self.m_pnlBtnCamZoomOut.DoClick = function()
		local rho, theta, phi = GAMEMODE.Util:CartesianToSpherical( self.m_vecCamPos -self:GetLookAt() )
		self.m_intDist = math.min( self.m_intDist +10, 200 )
		self:LerpCamPos( self:GetLookAt() +GAMEMODE.Util:SphericalToCartesian(self.m_intDist, theta, phi), 0.1 )
	end

	--[[ Sub Menus ]]--
	self.m_pnlPaintMenu = self:RegisterSubMenu( "Paint", vgui.Create("carMenu_Paint", self.m_pnlContent) )
	self.m_pnlSkinMenu = self:RegisterSubMenu( "Skins", vgui.Create("carMenu_Skin", self.m_pnlContent) )
	self.m_pnlUnderglow = self:RegisterSubMenu( "Underglow", vgui.Create("carMenu_Underglow", self.m_pnlContent) )
	self.m_pnlBodyGroups = self:RegisterSubMenu( "Groups", vgui.Create("carMenu_BodyGroups", self.m_pnlContent) )
	self.m_pnlMods = self:RegisterSubMenu( "Mods", vgui.Create("carMenu_Mods", self.m_pnlContent) )
end

function Panel:CloseAndRemove()
	if IsValid( LocalPlayer():GetVehicle() ) then
		LocalPlayer():GetVehicle().m_colGlowPreview = nil
	end

	self:Remove()
end

function Panel:RegisterSubMenu( strName, pnl )
	self.m_tblSubMenus[strName] = pnl
	pnl:SetVisible( false )
	return pnl
end

function Panel:ShowSubMenu( strMenu )
	if self.m_pnlOpenSubMenu then
		self.m_pnlOpenSubMenu:Close()
	end

	self:InvalidateLayout()

	self.m_pnlOpenSubMenu = self.m_tblSubMenus[strMenu]
	self.m_pnlOpenSubMenu:Open()
	self.m_intCamDist = nil
end

function Panel:SetCamPos( vecPos )
	self.m_vecCamPos = vecPos
end

function Panel:SetLookAt( vecLook )
	self.m_vecLookAt = vecLook
end

function Panel:GetLookAt()
	return self.m_vecLookAt
end

function Panel:LerpCamPos( vecNewPos, intTime )
	self.m_vecLastCamPos = self.m_vecCamPos
	self.m_vecTargetCamPos = vecNewPos
	self.m_intLerpCamStart = RealTime()
	self.m_intLerpCamLen = intTime
end

function Panel:LerpLookAt( vecNewPos, intTime )
	self.m_vecLastLookAt = self.m_vecLookAt
	self.m_vecTargetLookAt = vecNewPos
	self.m_intLerpLookStart = RealTime()
	self.m_intLerpLookLen = intTime
end

function Panel:Think()
	if self.m_vecTargetCamPos then
		local scalar = (RealTime() -self.m_intLerpCamStart) /self.m_intLerpCamLen
		self:SetCamPos( LerpVector(math.min(scalar, 1), self.m_vecLastCamPos, self.m_vecTargetCamPos) )

		if scalar >= 1 then
			self.m_vecLastCamPos = nil
			self.m_vecTargetCamPos = nil
			self.m_intLerpCamStart = nil
			self.m_intLerpCamLen = nil
		end
	end

	if self.m_vecTargetLookAt then
		local scalar = (RealTime() -self.m_intLerpLookStart) /self.m_intLerpLookLen
		self:SetLookAt( LerpVector(math.min(scalar, 1), self.m_vecLastLookAt, self.m_vecTargetLookAt) )

		if scalar >= 1 then
			self.m_vecTargetLookAt = nil
			self.m_vecLastLookAt = nil
			self.m_intLerpLookStart = nil
			self.m_intLerpLookLen = nil
		end
	end

	if ValidPanel( self.m_pnlOpenSubMenu ) then
		self.m_pnlOpenSubMenu:MoveToFront()
	end

	if IsValid( LocalPlayer():GetVehicle() ) then
		self:SetLookAt( LocalPlayer():GetVehicle():GetPos() +Vector(0, 0, 12) )
	end
end

function Panel:CalcView( pPlayer, vecPos, angAngles, intFov )
	local view = {}
	view.origin = self.m_vecCamPos or vecPos
	view.fov = intFov
	view.angles = self.m_vecLookAt and (self.m_vecLookAt -view.origin):Angle() or angAngles

	local shakeMul = 0.5
	view.angles = view.angles +Angle(
		math.sin(CurTime()) *shakeMul,
		math.cos(CurTime()) *shakeMul,
		0
	)

    return view
end

function Panel:Open()
	if IsValid( LocalPlayer():GetVehicle() ) then
		local car = LocalPlayer():GetVehicle()
		local carPos = car:GetPos()
		local carAngs = car:GetAngles()

		self:SetLookAt( carPos +Vector(0, 0, 12) )
		self:SetCamPos( carPos )
		car:SetThirdPersonMode( false )
		self.m_intDist = 150
		
		local rad = math.pi /180
		self:LerpCamPos( self:GetLookAt() +GAMEMODE.Util:SphericalToCartesian(self.m_intDist, 1.2209032169638, 2.1827487677391), 1 )
	end

	if self.m_pnlOpenSubMenu then
		self.m_pnlOpenSubMenu:SetVisible( false )
		self.m_pnlOpenSubMenu = nil
	end

	self:SetVisible( true )
	self:MakePopup()
	self:InvalidateLayout()
end

function Panel:Close()
	self:Remove()
end

function Panel:Toggle( bHide )
	if self:IsVisible() or bHide then
		self:Close()
	else
		self:Open()
	end
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlContent:SetPos( 0, 0 )
	self.m_pnlContent:SetSize( 300, intH )

	local wide = self.m_pnlContent:GetWide() -10 -(5 *5)
	local wide_1 = wide /6
	self.m_pnlBtnCamLeft:SetSize( wide_1, 32 )
	self.m_pnlBtnCamLeft:SetPos( 5, intH -32 -5 )

	self.m_pnlBtnCamUp:SetSize( wide_1, 32 )
	self.m_pnlBtnCamUp:SetPos( 10 +wide_1, intH -32 -5 )

	self.m_pnlBtnCamDown:SetSize( wide_1, 32 )
	self.m_pnlBtnCamDown:SetPos( 15 +(wide_1 *2), intH -32 -5 )

	self.m_pnlBtnCamRight:SetSize( wide_1, 32 )
	self.m_pnlBtnCamRight:SetPos( 20 +(wide_1 *3), intH -32 -5 )

	self.m_pnlBtnCamZoomIn:SetSize( wide_1, 32 )
	self.m_pnlBtnCamZoomIn:SetPos( 25 +(wide_1 *4), intH -32 -5 )

	self.m_pnlBtnCamZoomOut:SetSize( wide_1, 32 )
	self.m_pnlBtnCamZoomOut:SetPos( 30 +(wide_1 *5), intH -32 -5 )

	local tall = 0
	for k, v in pairs( self.m_tblOptions ) do
		tall = tall +32 +5
	end

	self.m_pnlOptionsContainer:SetSize( self.m_pnlContent:GetWide(), tall )
	self.m_pnlOptionsContainer:SetPos( 0, self.m_pnlContent:GetTall() -self.m_pnlOptionsContainer:GetTall() -(32 +5) )

	for k, v in pairs( self.m_tblSubMenus ) do
		v:SetPos( 5, 5 )
		v:SetWide( self.m_pnlContent:GetWide() -10 )
		v:SetTall( self.m_pnlContent:GetTall() -self.m_pnlOptionsContainer:GetTall() -10 -(32 +5) )
	end
end
vgui.Register( "carMenu", Panel, "EditablePanel" )

hook.Add( "CalcView", "!CarShop", function( pPlayer, vecPos, angAngles, intFov )
	if not ValidPanel( g_CarShop.m_pnlMenu ) or not g_CarShop.m_pnlMenu:IsVisible() then return end
	return g_CarShop.m_pnlMenu:CalcView( pPlayer, vecPos, angAngles, intFov )
end )

-- ----------------------------------------------------------------
--[[ Paint Menu ]]--
-- ----------------------------------------------------------------
local Panel = {}
function Panel:Init()
	self.m_colCurrentColor = Color( 255, 255, 255, 255 )
	if IsValid( LocalPlayer():GetVehicle() ) then
		local tblCol = LocalPlayer():GetVehicle():GetColor()
		self.m_colCurrentColor = Color(
			tblCol.r,
			tblCol.g,
			tblCol.b,
			255
		)
	end

	self.m_pnlColorPicker = vgui.Create( "DColorMixer", self )
	self.m_pnlColorPicker:SetPalette( true ) 
	self.m_pnlColorPicker:SetAlphaBar( false ) 
	self.m_pnlColorPicker:SetWangs( true )
	self.m_pnlColorPicker:SetColor( self.m_colCurrentColor )
	self.m_pnlColorPicker.ValueChanged = function( pnl, col )
		self.m_colCurrentColor.r = col.r
		self.m_colCurrentColor.g = col.g
		self.m_colCurrentColor.b = col.b

		if LocalPlayer():GetVehicle() then
			LocalPlayer():GetVehicle():SetColor( self.m_colCurrentColor )
		end
	end

	self.m_pnlBtnBuyPaint = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnBuyPaint:SetTextColorOverride( Color(255, 255, 255, 255) )
	self.m_pnlBtnBuyPaint:SetAlphaOverride( 175 )
	self.m_pnlBtnBuyPaint:SetText( "Buy Paint Job ($".. GAMEMODE.Econ:ApplyTaxToSum("sales", PAINT_COST).. ")" )
	self.m_pnlBtnBuyPaint.DoClick = function()
		GAMEMODE.Gui:Derma_Query(
			"Are you sure? This will cost $".. GAMEMODE.Econ:ApplyTaxToSum("sales", PAINT_COST),
			"Purchase Paint Job",
			"Ok",
			function()
				net.Start( "carShop" )
					net.WriteUInt( PICK_COLOR, 8 )
					net.WriteColor( self.m_colCurrentColor )
				net.SendToServer()
				surface.PlaySound( "buttons/button14.wav" )
			end,
			"Back",
			function() end
		)
	end
end

function Panel:Open()
	self:SetVisible( true )
	self:MakePopup()

	local tblCol = LocalPlayer():GetVehicle():GetColor()
	self.m_colCurrentColor.r = tblCol.r
	self.m_colCurrentColor.g = tblCol.g
	self.m_colCurrentColor.b = tblCol.b 
end

function Panel:Close()
	self:SetVisible( false )
end

function Panel:Think()
	self.m_pnlBtnBuyPaint:SetDisabled( LocalPlayer():GetMoney() < GAMEMODE.Econ:ApplyTaxToSum("sales", PAINT_COST) )
end

function Panel:PerformLayout( intW, intH )
	local btnTall = 32

	self.m_pnlColorPicker:SetSize( intW, intW )
	self.m_pnlColorPicker:SetPos( 0, (intH /2) -(self.m_pnlColorPicker:GetTall() /2) )

	local x, y = self.m_pnlColorPicker:GetPos()
	self.m_pnlBtnBuyPaint:SetSize( intW, btnTall )
	self.m_pnlBtnBuyPaint:SetPos( 0, y +self.m_pnlColorPicker:GetTall() +5 )
end
vgui.Register( "carMenu_Paint", Panel, "EditablePanel" )


-- ----------------------------------------------------------------
--[[ Skin Menu ]]--
-- ----------------------------------------------------------------
local Panel = {}
function Panel:Init()
	self.m_intCurrentSkin = 0

	self.m_pnlBtnNextSkin = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnNextSkin:SetTextColorOverride( Color(255, 255, 255, 255) )
	self.m_pnlBtnNextSkin:SetAlphaOverride( 175 )
	self.m_pnlBtnNextSkin:SetText( "<" )
	self.m_pnlBtnNextSkin.DoClick = function()
		self.m_intCurrentSkin = self.m_intCurrentSkin +1
		if self.m_intCurrentSkin > LocalPlayer():GetVehicle():SkinCount() -1 then
			self.m_intCurrentSkin = 0
		end

		LocalPlayer():GetVehicle():SetSkin( self.m_intCurrentSkin )
	end

	self.m_pnlBtnPrevSkin = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnPrevSkin:SetTextColorOverride( Color(255, 255, 255, 255) )
	self.m_pnlBtnPrevSkin:SetAlphaOverride( 175 )
	self.m_pnlBtnPrevSkin:SetText( ">" )
	self.m_pnlBtnPrevSkin.DoClick = function()
		self.m_intCurrentSkin = self.m_intCurrentSkin -1
		if self.m_intCurrentSkin < 0 then
			self.m_intCurrentSkin = LocalPlayer():GetVehicle():SkinCount() -1
		end

		LocalPlayer():GetVehicle():SetSkin( self.m_intCurrentSkin )
	end

	self.m_pnlBtnBuySkin = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnBuySkin:SetTextColorOverride( Color(255, 255, 255, 255) )
	self.m_pnlBtnBuySkin:SetAlphaOverride( 175 )
	self.m_pnlBtnBuySkin:SetText( "Buy Skin ($".. GAMEMODE.Econ:ApplyTaxToSum("sales", SKIN_COST).. ")" )
	self.m_pnlBtnBuySkin.DoClick = function()
		GAMEMODE.Gui:Derma_Query(
			"Are you sure? This will cost $".. GAMEMODE.Econ:ApplyTaxToSum("sales", SKIN_COST),
			"Purchase Skin",
			"Ok",
			function()
				net.Start( "carShop" )
					net.WriteUInt( PICK_SKIN, 8 )
					net.WriteUInt( self.m_intCurrentSkin, 8 )
				net.SendToServer()
				surface.PlaySound( "buttons/button14.wav" )
			end,
			"Back",
			function() end
		)
	end
end

function Panel:Open()
	self:InvalidateLayout()
	self:SetVisible( true )
	self:MakePopup()
	self.m_intCurrentSkin = LocalPlayer():GetVehicle():GetSkin()
end

function Panel:Close()
	self:SetVisible( false )
end

function Panel:Think()
	self.m_pnlBtnBuySkin:SetDisabled( LocalPlayer():GetMoney() < GAMEMODE.Econ:ApplyTaxToSum("sales", SKIN_COST) )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlBtnNextSkin:SetSize( 64, 64 )
	self.m_pnlBtnNextSkin:SetPos( 0, (intH /2) -(self.m_pnlBtnNextSkin:GetTall() /2) )

	self.m_pnlBtnPrevSkin:SetSize( 64, 64 )
	self.m_pnlBtnPrevSkin:SetPos( intW -64, (intH /2) -(self.m_pnlBtnPrevSkin:GetTall() /2) )

	self.m_pnlBtnBuySkin:SetSize( 100, 64 )
	self.m_pnlBtnBuySkin:SetPos( (intW /2) -(self.m_pnlBtnBuySkin:GetWide() /2), (intH /2) -(self.m_pnlBtnBuySkin:GetTall() /2) )
end
vgui.Register( "carMenu_Skin", Panel, "EditablePanel" )


-- ----------------------------------------------------------------
--[[ Bodygroup Menu ]]--
-- ----------------------------------------------------------------
local Panel = {}
function Panel:Init()
	self.m_intRotOffset = 0

	self.m_pnlOptions = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblPanels = {}
end

function Panel:BuildGroups( entVehicle )
	for k, v in pairs( self.m_tblPanels ) do
		if ValidPanel( v ) then v:Remove() end
	end

	self.m_tblPanels = {}
	self.m_pnlOptions:Clear()
	local bodyGroups = entVehicle:GetBodyGroups()

	for k, v in pairs( bodyGroups ) do
		if v.num <= 1 then continue end --invalid
		
		local pnl
		if v.num <= 2 then --Add a toggle
			pnl = vgui.Create( "DCheckBoxLabel", self.m_pnlOptions )
			pnl:SetTall( 15 )
			pnl:SetText( v.name )
			pnl.Button.DoClick = function()
				if pnl:GetChecked() then
					GAMEMODE.Gui:Derma_Query(
						"Are you sure? This will cost $".. GAMEMODE.Econ:ApplyTaxToSum("sales", BODYGROUP_COST),
						"Remove this bodygroup",
						"Ok",
						function()
							net.Start( "carShop" )
								net.WriteUInt( PICK_BODYGROUP, 8 )
								net.WriteUInt( v.id, 8 )
								net.WriteUInt( 0, 8 )
							net.SendToServer()
							surface.PlaySound( "buttons/button14.wav" )
						end,
						"Back",
						function() end
					)
				else
					GAMEMODE.Gui:Derma_Query(
						"Are you sure? This will cost $".. GAMEMODE.Econ:ApplyTaxToSum("sales", BODYGROUP_COST),
						"Purchase this bodygroup",
						"Ok",
						function()
							net.Start( "carShop" )
								net.WriteUInt( PICK_BODYGROUP, 8 )
								net.WriteUInt( v.id, 8 )
								net.WriteUInt( 1, 8 )
							net.SendToServer()
							surface.PlaySound( "buttons/button14.wav" )
						end,
						"Back",
						function() end
					)
				end
			end
			pnl.Think = function()
				local active = entVehicle:GetBodygroup( v.id ) == 1
				pnl.Button:SetDisabled( LocalPlayer():GetMoney() < GAMEMODE.Econ:ApplyTaxToSum("sales", BODYGROUP_COST) )
				if self.m_tblSavedGroupData then
					return
				end
				
				pnl:SetChecked( active )
			end
			pnl.Button.OnCursorEntered = function( p, ... )
				DCheckBox.OnCursorEntered( p, ... )
				self.m_tblSavedGroupData = {
					Group = v.id,
					Num = entVehicle:GetBodygroup( v.id ),
				}

				entVehicle:SetBodygroup( v.id, 1 )
			end
			pnl.Button.OnCursorExited = function( p, ... )
				DCheckBox.OnCursorEntered( p, ... )
				if not self.m_tblSavedGroupData then return end
				entVehicle:SetBodygroup( self.m_tblSavedGroupData.Group, self.m_tblSavedGroupData.Num )
				self.m_tblSavedGroupData = nil
			end

			self.m_pnlOptions:AddItem( pnl )
			table.insert( self.m_tblPanels, pnl )
		else --Add a list of toggles
			for i = 0, v.num -1 do
				local modelname = "model #" .. i
				if v.submodels and v.submodels[i] ~= "" then modelname = v.submodels[i] end
		
				local cbox = vgui.Create( "DCheckBoxLabel", self.m_pnlOptions )
				cbox:SetText( modelname )
				cbox:SizeToContents()
				cbox:SetTall( 15 )
				cbox.Indent = true

				if i == 0 then
					cbox.FirstBox = true
				elseif i == v.num -1 then
					cbox.LastBox = true
				end

				cbox.Button.DoClick = function()
					if cbox:GetChecked() then return end
					GAMEMODE.Gui:Derma_Query(
						"Are you sure? This will cost $".. GAMEMODE.Econ:ApplyTaxToSum("sales", BODYGROUP_COST),
						"Purchase this bodygroup",
						"Ok",
						function()
							net.Start( "carShop" )
								net.WriteUInt( PICK_BODYGROUP, 8 )
								net.WriteUInt( v.id, 8 )
								net.WriteUInt( i, 8 )
							net.SendToServer()
							surface.PlaySound( "buttons/button14.wav" )
						end,
						"Back",
						function() end
					)
				end
				cbox.Think = function()
					local active = entVehicle:GetBodygroup( v.id ) == i
					cbox.Button:SetDisabled( LocalPlayer():GetMoney() < GAMEMODE.Econ:ApplyTaxToSum("sales", BODYGROUP_COST) )
					if self.m_tblSavedGroupData then
						return
					end

					cbox:SetChecked( active )
				end
				cbox.Button.OnCursorEntered = function( p, ... )
					DCheckBox.OnCursorEntered( p, ... )
					self.m_tblSavedGroupData = {
						Group = v.id,
						Num = entVehicle:GetBodygroup( v.id ),
					}

					entVehicle:SetBodygroup( v.id, i )
				end
				cbox.Button.OnCursorExited = function( p, ... )
					DCheckBox.OnCursorEntered( p, ... )
					if not self.m_tblSavedGroupData then return end
					entVehicle:SetBodygroup( self.m_tblSavedGroupData.Group, self.m_tblSavedGroupData.Num )
					self.m_tblSavedGroupData = nil
				end

				self.m_pnlOptions:AddItem( cbox )
				table.insert( self.m_tblPanels, cbox )
			end
		end
	end
end

function Panel:Open()
	self.m_intRotOffset = 0
	self:BuildGroups( LocalPlayer():GetVehicle() )
	self:InvalidateLayout()
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:Close()
	self:SetVisible( false )
end

function Panel:PerformLayout( intW, intH )
	local yPos = 0
	for k, v in pairs( self.m_tblPanels ) do
		if v.FirstBox then
			yPos = yPos +5
		end

		v:SetPos( v.Indent and 5 or 0, yPos )
		yPos = yPos +v:GetTall() +5

		if v.LastBox then
			yPos = yPos +5
		end
	end

	self.m_pnlOptions:SetSize( intW, intH )
	self.m_pnlOptions:SetPos( 0, 0 )
end
vgui.Register( "carMenu_BodyGroups", Panel, "EditablePanel" )

-- ----------------------------------------------------------------
--[[ Mods Menu ]]--
-- ----------------------------------------------------------------
local Panel = {}
function Panel:Init()
	self.m_tblOptions = {}
	self.m_pnlTitle = vgui.Create( "DLabel", self )
	self.m_pnlTitle:SetFont( "DermaLarge" )
end

function Panel:SetTitle( strText )
	self.m_pnlTitle:SetText( strText )
	self:InvalidateLayout()
end

function Panel:AddOption( strOption, funcDoClick )
	local option = vgui.Create( "SRP_Button", self )
	option:SetText( strOption )
	option:SetTextColorOverride( Color(255, 255, 255, 255) )
	option:SetAlphaOverride( 175 )
	option.DoClick = funcDoClick
	table.insert( self.m_tblOptions, option )

	self:InvalidateLayout()

	return option
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlTitle:SizeToContents()
	self.m_pnlTitle:Dock( TOP )
	self.m_pnlTitle:DockMargin( 5, 0, 5, 5 )

	for k, v in pairs( self.m_tblOptions ) do
		v:SetTall( 32 )
		v:Dock( TOP )
		v:DockMargin( 0, 0, 0, 5 )
	end
end

function Panel:Paint()
end
vgui.Register( "carMenu_ModSelector", Panel, "EditablePanel" )

local Panel = {}
function Panel:Init()
	self.m_tblSelectors = {}

	for k, v in pairs( GAMEMODE.CarShop.m_tblUpgrades ) do
		local option = vgui.Create( "carMenu_ModSelector", self )
		option:SetTitle( k )

		for strName, data in SortedPairsByMemberValue(v, "ID") do
			local pnl = option:AddOption( strName.. " ($".. GAMEMODE.Econ:ApplyTaxToSum("sales", data.Price).. ")", function()
				self:SelectOption( k, strName )
			end )
			pnl.Think = function()
				if data.VIP and not LocalPlayer():CheckGroup( "vip" ) then
					pnl:SetDisabled( true )
					return
				end

				if not IsValid( LocalPlayer():GetVehicle() ) then return end
				if not LocalPlayer():GetVehicle().m_tblUpgrades then return end
				local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", data.Price )

				if LocalPlayer():GetMoney() < price then
					pnl:SetDisabled( true )
				else
					pnl:SetDisabled( LocalPlayer():GetVehicle().m_tblUpgrades[k] == strName )
				end

				if LocalPlayer():GetVehicle().m_tblUpgrades[k] == strName then
					pnl:SetText( "[Installed] ".. strName.. " ($".. price.. ")" )
				else
					pnl:SetText( strName.. " ($".. price.. ")" )
				end
			end
		end

		table.insert( self.m_tblSelectors, option )
	end
end

function Panel:SelectOption( strCat, strValue )
	local upgrade = GAMEMODE.CarShop.m_tblUpgrades[strCat][strValue]
	local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", upgrade.Price )
	GAMEMODE.Gui:Derma_Query(
		"Are you sure? This upgrade will cost $".. price,
		"Purchase ".. strCat.. " - ".. strValue.. " Upgrade",
		"Ok",
		function()
			net.Start( "carShop" )
				net.WriteUInt( BUY_UPGRADE, 8 )
				net.WriteString( strCat )
				net.WriteString( strValue )
			net.SendToServer()
			surface.PlaySound( "buttons/button14.wav" )
		end,
		"Back",
		function() end
	)
end

function Panel:Open()
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:Close()
	self:SetVisible( false )
end

function Panel:PerformLayout( intW, intH )
	for k, v in pairs( self.m_tblSelectors ) do
		local num = #v.m_tblOptions
		v:SetTall( num *32 +((num -1) *5) +v.m_pnlTitle:GetTall() +5 )
		v:Dock( TOP )
		v:DockMargin( 0, 0, 0, 5 )
	end
end
vgui.Register( "carMenu_Mods", Panel, "EditablePanel" )

-- ----------------------------------------------------------------
--[[ Underglow Menu ]]--
-- ----------------------------------------------------------------
local Panel = {}
function Panel:Init()
	self.m_colCurrentColor = Color( 255, 255, 255, 255 )
	if IsValid( LocalPlayer():GetVehicle() ) and LocalPlayer():GetVehicle():GetNWVector( "glow_col" ) then
		local vecCol = LocalPlayer():GetVehicle():GetNWVector( "glow_col" )
		if vecCol.x ~= -1 then
			self.m_colCurrentColor = Color( vecCol.r, vecCol.g, vecCol.b )
		end
	end

	self.m_pnlColorPicker = vgui.Create( "DColorMixer", self )
	self.m_pnlColorPicker:SetPalette( true ) 
	self.m_pnlColorPicker:SetAlphaBar( false ) 
	self.m_pnlColorPicker:SetWangs( true )
	self.m_pnlColorPicker:SetColor( self.m_colCurrentColor )
	self.m_pnlColorPicker.ValueChanged = function( pnl, col )
		self.m_colCurrentColor.r = col.r
		self.m_colCurrentColor.g = col.g
		self.m_colCurrentColor.b = col.b

		if IsValid( LocalPlayer():GetVehicle() ) then
			LocalPlayer():GetVehicle().m_colGlowPreview = self.m_colCurrentColor
		end
	end

	self.m_pnlBtnBuyNeons = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnBuyNeons:SetTextColorOverride( Color(255, 255, 255, 255) )
	self.m_pnlBtnBuyNeons:SetAlphaOverride( 175 )
	self.m_pnlBtnBuyNeons:SetText( "Purchase Underglow ($".. GAMEMODE.Econ:ApplyTaxToSum("sales", STREETGLOW_COST).. ")" )
	self.m_pnlBtnBuyNeons.DoClick = function()
		GAMEMODE.Gui:Derma_Query(
			"Are you sure? This will cost $".. GAMEMODE.Econ:ApplyTaxToSum( "sales", STREETGLOW_COST ),
			"Purchase Underglow Color",
			"Ok",
			function()
				net.Start( "carShop" )
					net.WriteUInt( UPDATE_GLOW, 8 )
					net.WriteBit( true )
					net.WriteColor( self.m_colCurrentColor )
				net.SendToServer()
				surface.PlaySound( "buttons/button14.wav" )

				if IsValid( LocalPlayer():GetVehicle() ) then
					LocalPlayer():GetVehicle().m_colGlowPreview = nil
				end
			end,
			"Back",
			function() end
		)
	end

	self.m_pnlBtRemoveNeons = vgui.Create( "SRP_Button", self )
	self.m_pnlBtRemoveNeons:SetTextColorOverride( Color(255, 255, 255, 255) )
	self.m_pnlBtRemoveNeons:SetAlphaOverride( 175 )
	self.m_pnlBtRemoveNeons:SetText( "Remove Underglow (FREE)" )
	self.m_pnlBtRemoveNeons.DoClick = function()
		GAMEMODE.Gui:Derma_Query(
			"Are you sure you want to remove your underglow?",
			"Remove Underglow Color",
			"Ok",
			function()
				net.Start( "carShop" )
					net.WriteUInt( UPDATE_GLOW, 8 )
					net.WriteBit( false )
				net.SendToServer()
				surface.PlaySound( "buttons/button14.wav" )

				if IsValid( LocalPlayer():GetVehicle() ) then
					LocalPlayer():GetVehicle().m_colGlowPreview = nil
				end
			end,
			"Back",
			function() end
		)
	end
end

function Panel:Open()
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:Close()
	self:SetVisible( false )

	if IsValid( LocalPlayer():GetVehicle() ) then
		LocalPlayer():GetVehicle().m_colGlowPreview = nil
	end	
end

function Panel:Think()
	self.m_pnlBtnBuyNeons:SetDisabled( LocalPlayer():GetMoney() < GAMEMODE.Econ:ApplyTaxToSum("sales", STREETGLOW_COST) )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlColorPicker:SetSize( intW, intW )
	self.m_pnlColorPicker:SetPos( 0, (intH /2) -(self.m_pnlColorPicker:GetTall() /2) )

	local x, y = self.m_pnlColorPicker:GetPos()
	self.m_pnlBtnBuyNeons:SetPos( 0, y +self.m_pnlColorPicker:GetTall() +5 )
	self.m_pnlBtnBuyNeons:SetSize( intW, 32 )

	self.m_pnlBtRemoveNeons:SetPos( 0, y +self.m_pnlColorPicker:GetTall() +5 +self.m_pnlBtnBuyNeons:GetTall() +5 )
	self.m_pnlBtRemoveNeons:SetSize( intW, 32 )
end
vgui.Register( "carMenu_Underglow", Panel, "EditablePanel" )