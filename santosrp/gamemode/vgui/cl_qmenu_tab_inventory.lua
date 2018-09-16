--[[
	Name: cl_qmenu_tab_inventory.lua
	For: TalosLife
	By: TalosLife
]]--

surface.CreateFont( "ItemCardFont", {size = 28, weight = 400, font = "DermaLarge"} )
surface.CreateFont( "ItemCardFont2", {size = 24, weight = 400, font = "DermaLarge"} )
surface.CreateFont( "ItemCardDescFont", {size = 20, weight = 400, font = "DermaLarge"} )
surface.CreateFont( "EquipSlotFont", {size = 12, weight = 400, font = "DermaLarge"} )
surface.CreateFont( "MoneyDisplayFont", {size = 22, weight = 550, font = "DermaLarge"} )

local Panel = {}
function Panel:Init()
	self:SetText( " " )
	self.m_tblActIndex = {
		["pistol"] 		= ACT_HL2MP_IDLE_PISTOL,
		["smg"] 		= ACT_HL2MP_IDLE_SMG1,
		["grenade"] 	= ACT_HL2MP_IDLE_GRENADE,
		["ar2"] 		= ACT_HL2MP_IDLE_AR2,
		["shotgun"] 	= ACT_HL2MP_IDLE_SHOTGUN,
		["rpg"]	 		= ACT_HL2MP_IDLE_RPG,
		["physgun"] 	= ACT_HL2MP_IDLE_PHYSGUN,
		["crossbow"] 	= ACT_HL2MP_IDLE_CROSSBOW,
		["melee"] 		= ACT_HL2MP_IDLE_MELEE,
		["slam"] 		= ACT_HL2MP_IDLE_SLAM,
		["normal"]		= ACT_HL2MP_IDLE,
		["fist"]		= ACT_HL2MP_IDLE_FIST,
		["melee2"]		= ACT_HL2MP_IDLE_MELEE2,
		["passive"]		= ACT_HL2MP_IDLE_PASSIVE,
		["knife"]		= ACT_HL2MP_IDLE_KNIFE,
		["duel"]		= ACT_HL2MP_IDLE_DUEL,
		["camera"]		= ACT_HL2MP_IDLE_CAMERA,
		["magic"]		= ACT_HL2MP_IDLE_MAGIC,
		["revolver"]	= ACT_HL2MP_IDLE_REVOLVER
	}

	self.m_tblOutfits = {}
end

function Panel:SetPlayerModel( strModel, intSkin, tblBodyGroups )
	self.m_strModel = strModel
	if self.m_entModel then
		self.m_entModel:Remove()
	end

	self.m_entModel = ClientsideModel( strModel, RENDERGROUP_BOTH )
	self.m_entModel:SetNoDraw( true )
	self.m_entModel:SetSkin( intSkin )
	for k, v in pairs( tblBodyGroups or {} ) do
		self.m_entModel:SetBodygroup( k, v )
	end
	pac.SetupENT( self.m_entModel )
	pac.IgnoreEntity( self.m_entModel )

	local min, max = self.m_entModel:GetRenderBounds()
	local center = (min +max) *-0.50
	self.m_entModel:SetPos( center +Vector(0, 0, 0) )
	self.m_entModel:SetAngles( Angle(0, 0, 0) )

	self.m_entModel:ResetSequence( self.m_entModel:LookupSequence("pose_standing_02") )
	self.m_intLastPaint = 0
	self.m_tblOutfits = {}
	self:SetWeapon( nil )

	self.m_bDirty = true
end

function Panel:GetPlayerModel()
	return self.m_strModel
end

function Panel:SetWeapon( tblWeapon )
	if self.m_entWepModel then
		self.m_entWepModel:Remove()
		self.m_entWepModel = nil
		self.m_tblWeapon = nil
		self.m_strWepClass = nil
	end

	if not tblWeapon then
		self.m_entModel:ResetSequence( self.m_entModel:LookupSequence("pose_standing_02") )
		return
	end

	self.m_tblWeapon = tblWeapon

	self.m_entWepModel = ClientsideModel( tblWeapon.WorldModel, RENDERGROUP_BOTH )
	if self.m_entWepModel then
		self.m_entWepModel:SetNoDraw( true )
		self.m_entWepModel:SetParent( self.m_entModel )
		self.m_entWepModel:AddEffects( EF_BONEMERGE )

		if tblWeapon.HoldType and self.m_tblActIndex[tblWeapon.HoldType] then
			self.m_entModel:ResetSequence( self.m_entModel:SelectWeightedSequence(self.m_tblActIndex[tblWeapon.HoldType]) )
		end
	end

	self.m_bDirty = true
end

function Panel:Think()
	local dirty = false

	--Remove old slots
	for k, v in pairs( self.m_tblOutfits ) do
		if GAMEMODE.Player:GetSharedGameVar( LocalPlayer(), k ) ~= v.ID then
			self.m_entModel:RemovePACPart( GAMEMODE.PacModels:GetOutfitForModel(v.PacOutfit, LocalPlayer():GetModel()) )
			self.m_tblOutfits[k] = nil
			dirty = true
		end
	end

	--Add new slots
	local value, item
	for k, v in pairs( GAMEMODE.Inv:GetEquipmentSlots() ) do
		k = "eq_slot_".. k
		value = GAMEMODE.Player:GetSharedGameVar( LocalPlayer(), k, "" )
		item = GAMEMODE.Inv:GetItem( value and value or "" )

		if v.Type == "GAMEMODE_INTERNAL_PAC_ONLY" then
			if (not self.m_tblOutfits[k] or self.m_tblOutfits[k].ID ~= value) then
				self.m_tblOutfits[k] = {
					ID = value,
					PacOutfit = value
				}

				if self.m_tblOutfits[k].PacOutfit and self.m_tblOutfits[k].PacOutfit ~= "" then
					self.m_entModel:AttachPACPart( GAMEMODE.PacModels:GetOutfitForModel(value, LocalPlayer():GetModel()) )
				end
				dirty = true
			end			
		else
			if (not self.m_tblOutfits[k] or self.m_tblOutfits[k].ID ~= value) and item and item.PacOutfit then
				self.m_tblOutfits[k] = {
					ID = value,
					PacOutfit = item.PacOutfit
				}

				if self.m_tblOutfits[k].PacOutfit and self.m_tblOutfits[k].PacOutfit ~= "" then
					self.m_entModel:AttachPACPart( GAMEMODE.PacModels:GetOutfitForModel(item.PacOutfit, LocalPlayer():GetModel()) )
				end
				dirty = true
			end
		end
	end

	--Update active weapon
	local activeWep = LocalPlayer():GetActiveWeapon()
	local weaponTable = IsValid( activeWep ) and weapons.Get( activeWep:GetClass() ) or nil
	
	if not weaponTable and self.m_tblWeapon then
		self:SetWeapon()
		dirty = true
	elseif weaponTable then
		if not self.m_tblWeapon or self.m_tblWeapon.WorldModel ~= weaponTable.WorldModel or
			not IsValid( self.m_entWepModel ) or
			not IsValid( self.m_entWepModel:GetParent() ) then

			self:SetWeapon( weaponTable )
			dirty = true
		end
	end

	if dirty or self.m_bDirty then
		self.m_bDirty = false
		if self.m_tblWeapon then
			if self.m_tblWeapon.HoldType and self.m_tblActIndex[self.m_tblWeapon.HoldType] then
				self.m_entModel:ResetSequence( self.m_entModel:SelectWeightedSequence(self.m_tblActIndex[self.m_tblWeapon.HoldType]) )
			end
		else
			self.m_entModel:ResetSequence( self.m_entModel:LookupSequence("pose_standing_02") )
		end
	end
end

function Panel:DrawModel()
	local curparent = self
	local rightx = self:GetWide()
	local leftx = 0
	local topy = 0
	local bottomy = self:GetTall()
	local previous = curparent
	while curparent:GetParent() ~= nil do
		curparent = curparent:GetParent()
		local x, y = previous:GetPos()
		topy = math.Max( y, topy + y )
		leftx = math.Max( x, leftx + x )
		bottomy = math.Min( y + previous:GetTall(), bottomy + y )
		rightx = math.Min( x + previous:GetWide(), rightx + x )
		previous = curparent
	end

	render.SetScissorRect( leftx, topy, rightx, bottomy, true )
		pac.UnIgnoreEntity( self.m_entModel )
		pac.ShowEntityParts( self.m_entModel )
		pac.ForceRendering( true )
				pac.RenderOverride( self.m_entModel, "opaque" )
				pac.RenderOverride( self.m_entModel, "translucent", true )
				self.m_entModel:DrawModel()

				if self.m_entWepModel then
					self.m_entWepModel:DrawModel()
				end
		pac.ForceRendering( false )
		pac.HideEntityParts( self.m_entModel )
		pac.IgnoreEntity( self.m_entModel )
	render.SetScissorRect( 0, 0, 0, 0, false )
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 40, 40, 40, 200 )
	surface.DrawRect( 0, 0, intW, intH )

	if not IsValid( self.m_entModel ) then return end
	local x, y = self:LocalToScreen( 0, 0 )
	local ang = Angle( 0, 0, 0 )

	cam.Start3D( (ang:Forward() *130) +(ang:Up() *-1), (ang:Forward()*-1):Angle(), 22, x, y, intW, intH, 5 )
		render.SuppressEngineLighting( true )
		render.SetLightingOrigin( self.m_entModel:GetPos() )
		render.ResetModelLighting( 1, 1, 1 )
		render.SetColorModulation( 1, 1, 1 )
		render.SetBlend( 1 )
	
		self:DrawModel()
	
		render.SuppressEngineLighting( false )
	cam.End3D()

	self.m_entModel:FrameAdvance( (RealTime() -self.m_intLastPaint) *1 )
	self.m_intLastPaint = RealTime()
end

function Panel:PerformLayout( intW, intH )
end
vgui.Register( "SRPPlayerPreview", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_colItemName = Color( 255, 255, 255, 255 )
	self.m_colAmount = Color( 120, 230, 110, 255 )

	self.m_pnlIcon = vgui.Create( "ModelImage", self )
	self.m_pnlIcon:SetMouseInputEnabled( false )
	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetTextColor( self.m_colItemName )
	self.m_pnlNameLabel:SetFont( "EquipSlotFont" )
	self.m_pnlNameLabel:SetMouseInputEnabled( false )

	self:SetText( "" )
end

function Panel:SetItemID( strItemID )
	self.m_strItemID = strItemID
	self.m_tblItem = GAMEMODE.Inv:GetItem( strItemID )
	if self.m_tblItem then
		self.m_pnlIcon:SetModel( self.m_tblItem.Model, self.m_tblItem.Skin )
		self.m_pnlIcon:SetVisible( true )
	else
		self.m_pnlIcon:SetVisible( false )
	end
	
	self:InvalidateLayout()
end

function Panel:SetSlotID( strID )
	self.m_strSlotID = strID
end

function Panel:Think()
	local cur = GAMEMODE.Player:GetSharedGameVar( LocalPlayer(), "eq_slot_".. self.m_strSlotID )
	if self.m_strItemID ~= cur then
		self:SetItemID( cur )
	end
end

function Panel:DoClick()
	if not self.m_tblItem then return end
	GAMEMODE.Net:RequestEquipItem( self.m_tblItem.EquipSlot )
end

function Panel:SetTitle( strText )
	self.m_pnlNameLabel:SetText( strText )
	self:InvalidateLayout()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PaintOver( intW, intH )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, intW, 1 ) --top
	surface.DrawRect( 0, 0, 1, intH ) --left side

	surface.DrawRect( intW -1, 0, 1, intH ) --right side
	surface.DrawRect( 0, intH -1, intW, 1 ) --bottom
end

function Panel:PerformLayout( intW, intH )
	local padding = 5

	self.m_pnlIcon:SetPos( 0, 0 )
	self.m_pnlIcon:SetSize( intH, intH )

	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( (intW /2) -(self.m_pnlNameLabel:GetWide() /2), (intH /2) -(self.m_pnlNameLabel:GetTall() /2) )
end
vgui.Register( "SRPEquipSlot", Panel, "DButton" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_colItemName = Color( 255, 255, 255, 255 )
	self.m_colAmount = Color( 120, 230, 110, 255 )

	self.m_matWeight = Material( "icon16/anchor.png", "smooth" )
	self.m_matVolume = Material( "icon16/brick.png", "smooth" )

	self.m_pnlIcon = vgui.Create( "ModelImage", self )
	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( self.m_colItemName )
	self.m_pnlNameLabel:SetFont( "ItemCardFont2" )

	self.m_pnlNumLabel = vgui.Create( "DLabel", self )
	self.m_pnlNumLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNumLabel:SetTextColor( self.m_colAmount )
	self.m_pnlNumLabel:SetFont( "Trebuchet24" )
	self.m_pnlNumLabel:SetText( " " )

	self.m_pnlContainer = vgui.Create( "EditablePanel", self )

	self.m_tblTrayBtns = {}
	self.m_pnlBtnTray = vgui.Create( "EditablePanel", self.m_pnlContainer )
	self.m_pnlBtnTray:SetVisible( false )
	self.m_pnlBtnTray.PerformLayout = function( p, intW, intH )
		for k, v in pairs( self.m_tblTrayBtns ) do
			v:SetWide( 100 )
			v:DockMargin( 0, 0, 5, 0 )
			v:Dock( LEFT )
		end
	end

	self.m_pnlDescLabel = vgui.Create( "DLabel", self.m_pnlContainer )
	self.m_pnlDescLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlDescLabel:SetTextColor( self.m_colItemName )
	self.m_pnlDescLabel:SetFont( "ItemCardDescFont" )

	self.m_intItemAmount = 1
end

function Panel:Think()
	local x, y = self:CursorPos()
	if x < 0 or y < 0 or x > self:GetWide() or y > self:GetTall() then
		if self.m_bIsHovered then
			self.m_bIsHovered = false
			self:OnCursorEndHover()
		end
	else
		if not self.m_bIsHovered then
			self.m_bIsHovered = true
			self:OnCursorHover()
		end
	end
end

function Panel:OnCursorHover()
	local padding = 5
	local labelPosX = 0
	local labelPosY = 0

	self.m_pnlDescLabel:Stop()
	self.m_pnlBtnTray:Stop()

	self.m_pnlDescLabel:SetPos( labelPosX, labelPosY )
	self.m_pnlDescLabel:SetVisible( true )
	self.m_pnlDescLabel:MoveTo( labelPosX, labelPosY -self.m_pnlBtnTray:GetTall(), 0.25, 0, 2, function()
		self.m_pnlDescLabel:SetVisible( false )
	end )

	self.m_pnlBtnTray:SetPos( labelPosX, labelPosY +self.m_pnlBtnTray:GetTall() )
	self.m_pnlBtnTray:SetVisible( true )
	self.m_pnlBtnTray:MoveTo( labelPosX, labelPosY, 0.25, 0, 2, function()
		self.m_pnlBtnTray:SetVisible( true )
	end )
end

function Panel:OnCursorEndHover()
	local padding = 5
	local labelPosX = 0
	local labelPosY = 0

	self.m_pnlDescLabel:Stop()
	self.m_pnlBtnTray:Stop()

	self.m_pnlDescLabel:SetPos( labelPosX, labelPosY -self.m_pnlDescLabel:GetTall() )
	self.m_pnlDescLabel:SetVisible( true )
	self.m_pnlDescLabel:MoveTo( labelPosX, labelPosY, 0.25, 0, 2, function()
		self.m_pnlDescLabel:SetVisible( true )
	end )

	self.m_pnlBtnTray:SetVisible( true )
	self.m_pnlBtnTray:MoveTo( labelPosX, labelPosY +self.m_pnlDescLabel:GetTall(), 0.25, 0, 2, function()
		self.m_pnlBtnTray:SetVisible( false )
	end )
end

function Panel:BuildTrayButtons()
	self.m_pnlBtnTray:Clear()
	if not self.m_tblItem then return end
	
	if self.m_tblItem.CanDrop then
		local dropBtn = vgui.Create( "SRP_Button", self.m_pnlBtnTray )
		dropBtn:SetText( "Drop" )
		dropBtn.DoClick = function()
			GAMEMODE.Net:RequestDropItem( self.m_strItemID, 1 )
		end
		table.insert( self.m_tblTrayBtns, dropBtn )

		local dropOwnerlessBtn = vgui.Create( "SRP_Button", self.m_pnlBtnTray )
		dropOwnerlessBtn:SetText( "Drop (Abandoned)" )
		dropOwnerlessBtn.DoClick = function()
			GAMEMODE.Net:RequestDropItem( self.m_strItemID, 1, true )
		end
		table.insert( self.m_tblTrayBtns, dropOwnerlessBtn )
	end

	if self.m_tblItem.CanUse then
		local useBtn = vgui.Create( "SRP_Button", self.m_pnlBtnTray )
		useBtn:SetText( "Use" )
		useBtn.DoClick = function()
			GAMEMODE.Net:RequestUseItem( self.m_strItemID )
		end
		table.insert( self.m_tblTrayBtns, useBtn )
	end

	if self.m_tblItem.CanEquip then
		local eqBtn = vgui.Create( "SRP_Button", self.m_pnlBtnTray )
		eqBtn:SetText( "Equip" )
		eqBtn.DoClick = function()
			GAMEMODE.Net:RequestEquipItem( self.m_tblItem.EquipSlot, self.m_strItemID )
		end
		table.insert( self.m_tblTrayBtns, eqBtn )
	end

	self.m_pnlBtnTray:InvalidateLayout()
end

function Panel:SetItemID( strItemID )
	self.m_strItemID = strItemID
	self.m_tblItem = GAMEMODE.Inv:GetItem( strItemID )

	if self.m_intItemPrice then
		self.m_pnlNameLabel:SetText( "$".. string.Comma(self.m_intItemPrice).. " - ".. strItemID )
	else
		self.m_pnlNameLabel:SetText( strItemID )
	end
	
	self.m_pnlIcon:SetModel( self.m_tblItem.Model, self.m_tblItem.Skin )
	self.m_pnlDescLabel:SetText( self.m_tblItem.Desc )

	self:InvalidateLayout()
	self:BuildTrayButtons()
end

function Panel:SetItemAmount( intAmount )
	self.m_intItemAmount = intAmount
	self.m_pnlNumLabel:SetText( "x".. intAmount )
	self:InvalidateLayout()
end

function Panel:SetItemPrice( intAmount )
	self.m_intItemPrice = intAmount
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PaintOver( intW, intH )
	if not self.m_tblItem then return end
	
	surface.SetFont( "EquipSlotFont" )
	local weight = tostring( self.m_tblItem.Weight *self.m_intItemAmount )
	local volume = tostring( self.m_tblItem.Volume *self.m_intItemAmount )

	local wW, wH = surface.GetTextSize( weight.. "-" )
	local vW, vH = surface.GetTextSize( volume.. "-" )
	draw.SimpleText(
		weight,
		"EquipSlotFont",
		intW -5, 8,
		color_white,
		TEXT_ALIGN_RIGHT
	)

	surface.SetMaterial( self.m_matWeight )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( intW -10 -wW -16, 5, 16, 16 )

	draw.SimpleText(
		volume,
		"EquipSlotFont",
		intW -5, intH -8,
		color_white,
		TEXT_ALIGN_RIGHT,
		TEXT_ALIGN_BOTTOM
	)

	surface.SetMaterial( self.m_matVolume )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( intW -10 -wW -16, intH -5 -16, 16, 16 )
end

function Panel:PerformLayout( intW, intH )
	local padding = 5

	self.m_pnlIcon:SetPos( 0, 0 )
	self.m_pnlIcon:SetSize( intH, intH )

	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( (padding *2) +intH, (intH /2) -self.m_pnlNameLabel:GetTall() )
	
	self.m_pnlNumLabel:SizeToContents()
	self.m_pnlNumLabel:SetPos( self.m_pnlIcon:GetWide() -self.m_pnlNumLabel:GetWide(), (intH /2) +(self.m_pnlNameLabel:GetTall() /2) -(self.m_pnlNameLabel:GetTall() /2) )


	self.m_pnlDescLabel:SizeToContents()
	self.m_pnlContainer:SetPos( (padding *2) +intH, (intH /2) )
	self.m_pnlContainer:SetSize( intW -(padding *2) +intH, self.m_pnlDescLabel:GetTall() )

	local w, h = self.m_pnlContainer:GetSize()
	self.m_pnlBtnTray:SetSize( w, h )
	self.m_pnlBtnTray:SetPos( self.m_pnlDescLabel:GetPos() )
end
vgui.Register( "SRPQMenuItemCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlWeightBar = vgui.Create( "SRP_Progress", self )
	self.m_pnlWeightBar:SetBarColor( Color(150, 200, 135, 255) )
	self.m_pnlWeightBar.Think = function()
		local weight, _ = GAMEMODE.Inv:ComputeInventorySize()
		self.m_pnlWeightBar:SetFraction( GAMEMODE.Inv:GetCurrentWeight() /weight )
	end
	self.m_pnlWeightBar.PaintOver = function( _, intW, intH )
		local weight, _ = GAMEMODE.Inv:ComputeInventorySize()
		draw.SimpleTextOutlined(
			"Weight",
			"EquipSlotFont",
			5, intH /2,
			color_white,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)

		draw.SimpleTextOutlined(
			"(".. GAMEMODE.Inv:GetCurrentWeight().. "/".. weight.. ")",
			"EquipSlotFont",
			intW -5, intH /2,
			color_white,
			TEXT_ALIGN_RIGHT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)
	end

	self.m_pnlVolumeBar = vgui.Create( "SRP_Progress", self )
	self.m_pnlVolumeBar:SetBarColor( Color(200, 90, 40, 255) )
	self.m_pnlVolumeBar.Think = function()
		local _, volume = GAMEMODE.Inv:ComputeInventorySize()
		self.m_pnlVolumeBar:SetFraction( GAMEMODE.Inv:GetCurrentVolume() /volume )
	end
	self.m_pnlVolumeBar.PaintOver = function( _, intW, intH )
		local _, volume = GAMEMODE.Inv:ComputeInventorySize()
		draw.SimpleTextOutlined(
			"Volume",
			"EquipSlotFont",
			5, intH /2,
			color_white,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)

		draw.SimpleTextOutlined(
			"(".. GAMEMODE.Inv:GetCurrentVolume().. "/".. volume.. ")",
			"EquipSlotFont",
			intW -5, intH /2,
			color_white,
			TEXT_ALIGN_RIGHT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)
	end

	self.m_pnlHungerBar = vgui.Create( "SRP_Progress", self )
	self.m_pnlHungerBar:SetBarColor( Color(167, 178, 71, 255) )
	self.m_pnlHungerBar.Think = function()
		self.m_pnlHungerBar:SetFraction( GAMEMODE.Needs:GetNeed( "Hunger" ) /GAMEMODE.Needs:GetNeedData( "Hunger" ).Max )
	end
	self.m_pnlHungerBar.PaintOver = function( _, intW, intH )
		draw.SimpleTextOutlined(
			"Hunger",
			"EquipSlotFont",
			5, intH /2,
			color_white,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)

		draw.SimpleTextOutlined(
			"(".. GAMEMODE.Needs:GetNeed( "Hunger" ).. "/".. GAMEMODE.Needs:GetNeedData( "Hunger" ).Max.. ")",
			"EquipSlotFont",
			intW -5, intH /2,
			color_white,
			TEXT_ALIGN_RIGHT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)
	end

	self.m_pnlThirst = vgui.Create( "SRP_Progress", self )
	self.m_pnlThirst:SetBarColor( Color(0, 90, 160, 255) )
	self.m_pnlThirst.Think = function()
		self.m_pnlThirst:SetFraction( GAMEMODE.Needs:GetNeed( "Thirst" ) /GAMEMODE.Needs:GetNeedData( "Thirst" ).Max )
	end
	self.m_pnlThirst.PaintOver = function( _, intW, intH )
		draw.SimpleTextOutlined(
			"Thirst",
			"EquipSlotFont",
			5, intH /2,
			color_white,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)

		draw.SimpleTextOutlined(
			"(".. GAMEMODE.Needs:GetNeed( "Thirst" ).. "/".. GAMEMODE.Needs:GetNeedData( "Thirst" ).Max.. ")",
			"EquipSlotFont",
			intW -5, intH /2,
			color_white,
			TEXT_ALIGN_RIGHT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)
	end

	self.m_pnlStamina = vgui.Create( "SRP_Progress", self )
	self.m_pnlStamina:SetBarColor( Color(175, 60, 60, 255) )
	self.m_pnlStamina.Think = function()
		self.m_pnlStamina:SetFraction( GAMEMODE.Needs:GetNeed( "Stamina" ) /GAMEMODE.Needs:GetNeedData( "Stamina" ).Max )
	end
	self.m_pnlStamina.PaintOver = function( _, intW, intH )
		draw.SimpleTextOutlined(
			"Stamina",
			"EquipSlotFont",
			5, intH /2,
			color_white,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)

		draw.SimpleTextOutlined(
			"(".. GAMEMODE.Needs:GetNeed( "Stamina" ).. "/".. GAMEMODE.Needs:GetNeedData( "Stamina" ).Max.. ")",
			"EquipSlotFont",
			intW -5, intH /2,
			color_white,
			TEXT_ALIGN_RIGHT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)
	end

	self.m_colMoney = Color( 120, 230, 110, 255 )
	self.m_pnlMoneyDisplay = vgui.Create( "EditablePanel", self )
	self.m_pnlMoneyDisplay.Paint = function( p, intW, intH )
		surface.SetDrawColor( 60, 60, 60, 200 )
		surface.DrawRect( 0, 0, intW, intH )

		draw.SimpleText(
			"$".. string.Comma( GAMEMODE.Player:GetGameVar("money_wallet", 0) ),
			"MoneyDisplayFont",
			intW -5, intH /2 -1,
			self.m_colMoney,
			TEXT_ALIGN_RIGHT,
			TEXT_ALIGN_CENTER
		)
	end
	self.m_pnlBtnDropMoney = vgui.Create( "SRP_Button", self.m_pnlMoneyDisplay )
	self.m_pnlBtnDropMoney:SetText( "Drop Money" )
	self.m_pnlMoneyDisplay.PerformLayout = function( _, intW, intH )
		self.m_pnlBtnDropMoney:SetSize( 80, intH )
		self.m_pnlBtnDropMoney:SetPos( 0, 0 )
	end
	self.m_pnlBtnDropMoney.DoClick = function()
		local context = DermaMenu( self )

		local owned = context:AddSubMenu( "Owned" )	
		owned:AddOption( "$100", function() GAMEMODE.Net:RequestDropMoney( 100 ) end )
		owned:AddOption( "$500", function() GAMEMODE.Net:RequestDropMoney( 500 ) end )
		owned:AddOption( "$1000", function() GAMEMODE.Net:RequestDropMoney( 1000 ) end )
		owned:AddOption( "$2500", function() GAMEMODE.Net:RequestDropMoney( 2500 ) end )
		owned:AddOption( "$5000", function() GAMEMODE.Net:RequestDropMoney( 5000 ) end )
		owned:AddOption( "Enter Amount", function()
			GAMEMODE.Gui:StringRequest(
				"Drop Money",
				"Enter the amount of money you would like to drop.", 
				"10000",
				function( strText )
					if not tonumber(strText) then return end
					GAMEMODE.Net:RequestDropMoney( tonumber(strText) )
				end,
				function() end,
				"Drop Money",
				"Cancel"
			)
		end )

		local ownerless = context:AddSubMenu( "Abandoned" )	
		ownerless:AddOption( "$100", function() GAMEMODE.Net:RequestDropMoney( 100, true ) end )
		ownerless:AddOption( "$500", function() GAMEMODE.Net:RequestDropMoney( 500, true ) end )
		ownerless:AddOption( "$1000", function() GAMEMODE.Net:RequestDropMoney( 1000, true ) end )
		ownerless:AddOption( "$2500", function() GAMEMODE.Net:RequestDropMoney( 2500, true ) end )
		ownerless:AddOption( "$5000", function() GAMEMODE.Net:RequestDropMoney( 5000, true ) end )
		ownerless:AddOption( "Enter Amount", function()
			GAMEMODE.Gui:StringRequest(
				"Drop Money (Abandoned)",
				"Enter the amount of money you would like to drop.", 
				"10000",
				function( strText )
					if not tonumber(strText) then return end
					GAMEMODE.Net:RequestDropMoney( tonumber(strText), true )
				end,
				function() end,
				"Drop Money",
				"Cancel"
			)
		end )

		context:Open()
	end

	self.m_tblTabs = {
		{ Name = "All", ID = "type_all" },
		{ Name = "Clothing", ID = "type_clothing" },
		{ Name = "Electronics", ID = "type_electronics" },
		{ Name = "Furniture", ID = "type_furniture" },
		{ Name = "Food", ID = "type_food" },
		{ Name = "Drugs", ID = "type_drugs" },
		{ Name = "Books", ID = "type_book" },
		{ Name = "Misc", ID = "type_misc" },
		{ Name = "Weapons", ID = "type_weapon" },
		{ Name = "Ammo", ID = "type_ammo" },
	}

	self.m_tblTabPanels = {}
	self.m_pnlItemList = vgui.Create( "SRP_PropertySheet", self )
	self.m_pnlItemList:SetPadding( 0 )
	for k, v in pairs( self.m_tblTabs ) do
		self.m_tblTabPanels[v.ID] = { Panel = vgui.Create( "SRP_ScrollPanel", self.m_pnlItemList ), Cards = {} }
		self.m_pnlItemList:AddSheet( v.Name, self.m_tblTabPanels[v.ID].Panel )
	end

	self.m_pnlCharModel = vgui.Create( "SRPPlayerPreview", self )
	self.m_pnlSlotContainer = vgui.Create( "EditablePanel", self )
	
	self.m_pnlPrimarySlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlPrimarySlot:SetTitle( "Primary" )
	self.m_pnlPrimarySlot:SetSlotID( "PrimaryWeapon" )

	self.m_pnlSecondarySlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlSecondarySlot:SetTitle( "Secondary" )
	self.m_pnlSecondarySlot:SetSlotID( "SecondaryWeapon" )

	self.m_pnlAltSlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlAltSlot:SetTitle( "Alternate" )
	self.m_pnlAltSlot:SetSlotID( "AltWeapon" )

	self.m_pnlHeadSlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlHeadSlot:SetTitle( "Head" )
	self.m_pnlHeadSlot:SetSlotID( "Head" )

	self.m_pnlEyesSlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlEyesSlot:SetTitle( "Eyes" )
	self.m_pnlEyesSlot:SetSlotID( "Eyes" )

	self.m_pnlFaceSlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlFaceSlot:SetTitle( "Face" )
	self.m_pnlFaceSlot:SetSlotID( "Face" )

	self.m_pnlNeckSlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlNeckSlot:SetTitle( "Neck" )
	self.m_pnlNeckSlot:SetSlotID( "Neck" )

	self.m_pnlBackSlot = vgui.Create( "SRPEquipSlot", self.m_pnlSlotContainer )
	self.m_pnlBackSlot:SetTitle( "Back" )
	self.m_pnlBackSlot:SetSlotID( "Back" )

	self:Refresh()
end

function Panel:Refresh()
	local groups = {}
	for k, v in pairs( LocalPlayer():GetBodyGroups() ) do
		groups[v.id] = LocalPlayer():GetBodygroup( v.id )
	end
	self.m_pnlCharModel:SetPlayerModel( LocalPlayer():GetModel(), LocalPlayer():GetSkin(), groups )

	for k, v in pairs( self.m_tblTabPanels ) do
		for _, card in pairs( v.Cards ) do
			if ValidPanel( card ) then card:Remove() end
		end

		v.Cards = {}
	end

	local itemData
	for itemName, itemAmount in SortedPairs( LocalPlayer():GetInventory() ) do
		itemData = GAMEMODE.Inv:GetItem( itemName )
		if not itemData then continue end
		
		local groupTab = itemData.Type
		groupTab = groupTab or "type_all"

		local tabPanel = self.m_tblTabPanels[groupTab].Panel
		local itemCard = vgui.Create( "SRPQMenuItemCard", tabPanel )
		itemCard:SetItemID( itemName )
		itemCard:SetItemAmount( itemAmount )
		tabPanel:AddItem( itemCard )
		table.insert( self.m_tblTabPanels[groupTab].Cards, itemCard )

		if groupTab ~= "type_all" then --add it to type_all too
			local tabPanel = self.m_tblTabPanels["type_all"].Panel
			local itemCard = vgui.Create( "SRPQMenuItemCard", tabPanel )
			itemCard:SetItemID( itemName )
			itemCard:SetItemAmount( itemAmount )
			tabPanel:AddItem( itemCard )
			table.insert( self.m_tblTabPanels["type_all"].Cards, itemCard )
		else --add to the misc tab
			local tabPanel = self.m_tblTabPanels["type_misc"].Panel
			local itemCard = vgui.Create( "SRPQMenuItemCard", tabPanel )
			itemCard:SetItemID( itemName )
			itemCard:SetItemAmount( itemAmount )
			tabPanel:AddItem( itemCard )
			table.insert( self.m_tblTabPanels["type_misc"].Cards, itemCard )
		end
	end

	self:InvalidateLayout()
end

function Panel:PerformLayout( intW, intH )
	local w = intW *0.3
	local y = intH
	self.m_pnlWeightBar:SetSize( w, 20 )
	y = y -self.m_pnlWeightBar:GetTall()
	self.m_pnlWeightBar:SetPos( 0, y )

	self.m_pnlVolumeBar:SetSize( w, 20 )
	y = y -self.m_pnlVolumeBar:GetTall() +1
	self.m_pnlVolumeBar:SetPos( 0, y )

	self.m_pnlStamina:SetSize( w, 20 )
	y = y -self.m_pnlStamina:GetTall() +1
	self.m_pnlStamina:SetPos( 0, y )

	self.m_pnlHungerBar:SetSize( w, 20 )
	y = y -self.m_pnlHungerBar:GetTall() +1
	self.m_pnlHungerBar:SetPos( 0, y )

	self.m_pnlThirst:SetSize( w, 20 )
	y = y -self.m_pnlThirst:GetTall() +1
	self.m_pnlThirst:SetPos( 0, y )

	self.m_pnlMoneyDisplay:SetSize( w, 25 )
	self.m_pnlMoneyDisplay:SetPos(
		0,
		y -self.m_pnlMoneyDisplay:GetTall()
	)

	self.m_pnlCharModel:SetPos( 0, 0 )
	self.m_pnlCharModel:SetSize(
		w,
		y -self.m_pnlMoneyDisplay:GetTall()
	)

	self.m_pnlSlotContainer:SetPos( 0, 0 )
	self.m_pnlSlotContainer:SetSize( self.m_pnlCharModel:GetSize() )

	local y = 5
	
	self.m_pnlPrimarySlot:SetSize( 48, 48 )
	self.m_pnlPrimarySlot:SetPos( 5, self.m_pnlSlotContainer:GetTall() -self.m_pnlPrimarySlot:GetTall() -5 )
	
	self.m_pnlSecondarySlot:SetSize( 48, 48 )
	self.m_pnlSecondarySlot:SetPos(
		self.m_pnlSlotContainer:GetWide() /2 -(self.m_pnlSecondarySlot:GetWide() /2),
		self.m_pnlSlotContainer:GetTall() -self.m_pnlPrimarySlot:GetTall() -5
	)
	
	self.m_pnlAltSlot:SetSize( 48, 48 )
	self.m_pnlAltSlot:SetPos(
		self.m_pnlSlotContainer:GetWide() -self.m_pnlAltSlot:GetWide() -5,
		self.m_pnlSlotContainer:GetTall() -self.m_pnlPrimarySlot:GetTall() -5
	)

	self.m_pnlHeadSlot:SetSize( 48, 48 )
	self.m_pnlHeadSlot:SetPos(
		self.m_pnlSlotContainer:GetWide() /2 -(self.m_pnlSecondarySlot:GetWide() /2),
		5
	)

	self.m_pnlEyesSlot:SetSize( 48, 48 )
	self.m_pnlEyesSlot:SetPos( 5, self.m_pnlSlotContainer:GetTall() *0.125 )

	self.m_pnlFaceSlot:SetSize( 48, 48 )
	self.m_pnlFaceSlot:SetPos(
		self.m_pnlSlotContainer:GetWide() -self.m_pnlFaceSlot:GetWide() - 5,
		self.m_pnlSlotContainer:GetTall() *0.125
	)

	self.m_pnlNeckSlot:SetSize( 48, 48 )
	self.m_pnlNeckSlot:SetPos(
		self.m_pnlSlotContainer:GetWide() -self.m_pnlNeckSlot:GetWide() - 5,
		self.m_pnlSlotContainer:GetTall() *0.125 +self.m_pnlFaceSlot:GetTall() +5
	)

	self.m_pnlBackSlot:SetSize( 48, 48 )
	self.m_pnlBackSlot:SetPos(
		5,
		self.m_pnlSlotContainer:GetTall() *0.33
	)

	local x, y = self.m_pnlSlotContainer:GetPos()

	self.m_pnlItemList:SetSize( intW -x -self.m_pnlSlotContainer:GetWide(), intH )
	self.m_pnlItemList:SetPos( x +self.m_pnlSlotContainer:GetWide(), 0 )

	for k, v in pairs( self.m_tblTabPanels ) do
		--v.Panel:SetPos( 0, 0 )
		--v.Panel:SetSize( self.m_pnlItemList:GetSize() )
		for _, card in pairs( v.Cards ) do
			card:SetTall( 48 )
			card:DockMargin( 0, 0, 0, 5 )
			card:Dock( TOP )
		end
	end

end
vgui.Register( "SRPQMenu_Inventory", Panel, "EditablePanel" )