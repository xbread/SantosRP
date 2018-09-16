--[[
	Name: cl_qmenu_tab_character.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "CarMenuFont" )

	self.m_pnlLevelLabel = vgui.Create( "DLabel", self )
	self.m_pnlLevelLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlLevelLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlLevelLabel:SetFont( "Trebuchet24" )

	self.m_pnlXPBar = vgui.Create( "SRP_Progress", self )
	self.m_pnlXPBar:SetBarColor( Color(170, 220, 155, 255) )
	self.m_pnlXPBar.Think = function()
		if not self.m_strSkillName then return end
		local curXP = GAMEMODE.Skills:GetPlayerXP( self.m_strSkillName )
		local baseXP = GAMEMODE.Skills:GetXPForLevel( self.m_strSkillName, GAMEMODE.Skills:GetPlayerLevel(self.m_strSkillName) -1 )
		local targetXP = GAMEMODE.Skills:GetXPForLevel( self.m_strSkillName, GAMEMODE.Skills:GetPlayerLevel(self.m_strSkillName) )

		curXP = curXP -baseXP
		targetXP = targetXP -baseXP
		self.m_pnlXPBar:SetFraction( curXP /targetXP )
	end

	self.m_pnlXPLabel = vgui.Create( "DLabel", self )
	self.m_pnlXPLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlXPLabel:SetFont( "Trebuchet24" )
	self.m_pnlXPLabel.Think = function()
		if not self.m_strSkillName then return end
		if GAMEMODE.Skills:GetPlayerXP( self.m_strSkillName ) ~= self.m_intLastXP or -1 then
			self.m_intLastXP = GAMEMODE.Skills:GetPlayerXP( self.m_strSkillName )
			local curXP = GAMEMODE.Skills:GetPlayerXP( self.m_strSkillName )
			local baseXP = GAMEMODE.Skills:GetXPForLevel( self.m_strSkillName, GAMEMODE.Skills:GetPlayerLevel(self.m_strSkillName) -1 )
			local targetXP = GAMEMODE.Skills:GetXPForLevel( self.m_strSkillName, GAMEMODE.Skills:GetPlayerLevel(self.m_strSkillName) )

			curXP = curXP -baseXP
			targetXP = targetXP -baseXP
			self.m_pnlXPLabel:SetText( curXP.. "XP / ".. targetXP.. "XP" )
			self:InvalidateLayout()
		end
	end
end

function Panel:Think()
	if not self.m_strSkillName then return end
	if GAMEMODE.Skills:GetPlayerLevel( self.m_strSkillName ) ~= self.m_intLastLevel or -1 then
		self.m_intLastLevel = GAMEMODE.Skills:GetPlayerLevel( self.m_strSkillName )
		self.m_pnlLevelLabel:SetText( "Level: ".. self.m_intLastLevel )
		self:InvalidateLayout()
	end
end

function Panel:SetSkill( strSkill, tblData )
	self.m_strSkillName = strSkill
	self.m_tblSkill = tblData
	self.m_pnlNameLabel:SetText( strSkill )
	self:InvalidateLayout()
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	local padding = 5
	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetPos( padding, (intH /2) -self.m_pnlNameLabel:GetTall() )

	local x, y = self.m_pnlNameLabel:GetPos()
	self.m_pnlLevelLabel:SizeToContents()
	self.m_pnlLevelLabel:SetPos( x, y +self.m_pnlNameLabel:GetTall() +padding )

	self.m_pnlXPBar:SetPos( self.m_pnlLevelLabel:GetWide() +(padding *3), y +self.m_pnlNameLabel:GetTall() +padding )
	x, y = self.m_pnlXPBar:GetPos()
	self.m_pnlXPBar:SetSize( intW -x -padding, 25 )

	self.m_pnlXPLabel:SizeToContents()
	self.m_pnlXPLabel:SetPos( x +((intW -x -padding) /2) -(self.m_pnlXPLabel:GetWide() /2), y )
end
vgui.Register( "SRPSkillInfoCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlCharModel = vgui.Create( "SRPCharacterPreview", self )
	self.m_pnlCharModel:SetBackgroundColor( Color(40, 40, 40, 200) )
	self.m_pnlCharModel.DrawLimbCard = self.DrawLimbCard
	function self.m_pnlCharModel:Paint( intW, intH )
		surface.SetDrawColor( self.m_colBG )
		surface.DrawRect( 0, 0, intW, intH )

		if not IsValid( self.m_entModel ) then return end
		local x, y = self:LocalToScreen( 0, 0 )

		local ang = Angle( 0, 0, 0 )
		local camPos = (ang:Forward() *130) +(ang:Up() *-1) +(ang:Right() *3)
		cam.Start3D( camPos, (ang:Forward()*-1):Angle(), 16, x, y, intW, intH, 1 )
			cam.IgnoreZ( true )
			render.SuppressEngineLighting( true )
			render.SetLightingOrigin( self.m_entModel:GetPos() )
			render.ResetModelLighting( 1, 1, 1 )
			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 1 )

			self:DrawModel()

			render.SuppressEngineLighting( false )
			cam.IgnoreZ( false )
		cam.End3D()

		self.m_entModel:FrameAdvance( (RealTime() -self.m_intLastPaint) *1 )

		draw.SimpleText(
			self.m_strFirstName.. " ".. self.m_strLastName,
			"CharacterDisplayFont",
			intW /2,
			intH /2,
			Color( 255, 255, 255, 255 ),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)

		local cardWide = 96
		local cardTall = 24
		self:DrawLimbCard( HITGROUP_HEAD, 5, 5, cardWide, cardTall )
		self:DrawLimbCard( HITGROUP_CHEST, (intW /2) -(cardWide /2), intH *0.275, cardWide, cardTall )

		self:DrawLimbCard( HITGROUP_LEFTARM, 5, intH *0.175, cardWide, cardTall )
		self:DrawLimbCard( HITGROUP_RIGHTARM, intW -cardWide -5, intH *0.175, cardWide, cardTall )

		self:DrawLimbCard( HITGROUP_LEFTLEG, 5, intH *0.6175, cardWide, cardTall )
		self:DrawLimbCard( HITGROUP_RIGHTLEG, intW -cardWide -5, intH *0.6175, cardWide, cardTall )

		self.m_intLastPaint = RealTime()
	end

	self.m_pnlSkillList = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblSkillCards = {}

	self.m_pnlHealthBar = vgui.Create( "SRP_Progress", self.m_pnlCharModel )
	self.m_pnlHealthBar:SetBarColor( Color(220, 50, 50, 255) )
	self.m_pnlHealthBar.Think = function()
		self.m_pnlHealthBar:SetFraction( LocalPlayer():Health() /100 )
	end
	self.m_pnlHealthBar.PaintOver = function( _, intW, intH )
		draw.SimpleTextOutlined(
			"Health",
			"EquipSlotFont",
			5, intH /2,
			color_white,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)

		draw.SimpleTextOutlined(
			"(".. LocalPlayer():Health().. "/100)",
			"EquipSlotFont",
			intW -5, intH /2,
			color_white,
			TEXT_ALIGN_RIGHT,
			TEXT_ALIGN_CENTER,
			1,
			color_black
		)
	end
end

local MAT_BLEED = Material( "icon16/bullet_red.png" )
local MAT_BROKEN = Material( "icon16/bullet_orange.png" )
local MAT_BANDAGE = Material( "icon16/hourglass_add.png" )
function Panel:DrawLimbCard( intLimbID, intX, intY, intW, intH )
	local limbData = GAMEMODE.PlayerDamage:GetLimbs()[intLimbID]
	local curHealth = GAMEMODE.PlayerDamage:GetPlayerLimbHealth( intLimbID )

	local isBroken = GAMEMODE.PlayerDamage:IsPlayerLimbBroken( intLimbID )
	local isBleeding = GAMEMODE.PlayerDamage:IsPlayerLimbBleeding( intLimbID )
	local isBandaged = GAMEMODE.PlayerDamage:PlayerLimbHasBandage( intLimbID )

	if isBroken then intH = intH +16 end
	if isBleeding then intH = intH +16 end
	if isBandaged and isBleeding then intH = intH +16 end
	
	surface.SetDrawColor( 50, 50, 50, 255 )
	surface.DrawRect( intX, intY, intW, intH )

	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( intX, intY, intW, 1 ) --top
	surface.DrawRect( intX, intY, 1, intH ) --left side

	surface.DrawRect( intX +intW -1, intY, 1, intH ) --right side
	surface.DrawRect( intX, intY +intH -1, intW, 1 ) --bottom

	draw.SimpleTextOutlined(
		limbData.Name.. ": ".. curHealth.. "/".. limbData.MaxHealth.. "HP",
		"EquipSlotFont",
		intX +(intW /2), intY,
		color_white,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_TOP,
		1,
		color_black
	)

	local barW, barH = intW, 10
	local barX, barY = intX, intY +14
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( barX, barY, barW, barH )

	local scalar = 1 -((limbData.MaxHealth -curHealth) /limbData.MaxHealth)
	surface.SetDrawColor( 255, 50, 50, 255 )
	surface.DrawRect( barX +1, barY +1, (barW -2) *scalar, barH -2 )

	local x, y = barX, barY +barH
	if isBroken then
		cam.IgnoreZ( true )
		surface.SetMaterial( MAT_BROKEN )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( x, y, 16, 16 )
		cam.IgnoreZ( false )

		draw.SimpleTextOutlined(
			"Broken!",
			"EquipSlotFont",
			x +16 +2, y,
			color_white,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP,
			1,
			color_black
		)

		y = y +16
	end

	if isBleeding then
		cam.IgnoreZ( true )
		surface.SetMaterial( MAT_BLEED )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( x, y, 16, 16 )
		cam.IgnoreZ( false )

		draw.SimpleTextOutlined(
			"Bleeding!",
			"EquipSlotFont",
			x +16 +2, y,
			color_white,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP,
			1,
			color_black
		)

		y = y +16
	end

	if isBandaged and isBleeding then
		cam.IgnoreZ( true )
		surface.SetMaterial( MAT_BANDAGE )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( x, y, 16, 16 )
		cam.IgnoreZ( false )

		draw.SimpleTextOutlined(
			"Bandage: ".. GAMEMODE.Util:FormatTime( GAMEMODE.PlayerDamage:GetPlayerBandageTimeLeft(intLimbID) ),
			"EquipSlotFont",
			x +16 +2, y,
			color_white,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP,
			1,
			color_black
		)

		y = y +16
	end
end

function Panel:Refresh()
	self.m_pnlCharModel:SetModel( LocalPlayer():GetModel() )
	self.m_pnlCharModel:SetSkin( LocalPlayer():GetSkin() )
	self.m_pnlCharModel:SetName(
		GAMEMODE.Player:GetSharedGameVar( LocalPlayer(), "name_first" ),
		GAMEMODE.Player:GetSharedGameVar( LocalPlayer(), "name_last" )
	)
	for k, v in pairs( LocalPlayer():GetBodyGroups() ) do
		self.m_pnlCharModel.m_entModel:SetBodygroup( v.id, LocalPlayer():GetBodygroup(v.id) )
	end

	for k, v in pairs( self.m_tblSkillCards ) do
		if IsValid( v ) then v:Remove() end
	end

	self.m_tblSkillCards = {}
	for k, v in pairs( GAMEMODE.Skills:GetSkills() ) do
		self:CreateSkillCard( k, v )
	end
end

function Panel:CreateSkillCard( strSkill, tblSkillData )
	local pnl = vgui.Create( "SRPSkillInfoCard", self.m_pnlSkillList )
	pnl:SetSkill( strSkill, tblSkillData )
	pnl.m_pnlParentMenu = self
	self.m_pnlSkillList:AddItem( pnl )
	table.insert( self.m_tblSkillCards, pnl )

	return pnl
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlCharModel:SetPos( 0, 0 )
	self.m_pnlCharModel:SetSize( intW *0.3, intH )

	self.m_pnlSkillList:SetPos( self.m_pnlCharModel:GetWide(), 0 )
	self.m_pnlSkillList:SetSize( intW -self.m_pnlCharModel:GetWide(), intH )

	for _, pnl in pairs( self.m_tblSkillCards ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 64 )
		pnl:Dock( TOP )
	end

	self.m_pnlHealthBar:SetSize( self.m_pnlCharModel:GetWide(), 20 )
	self.m_pnlHealthBar:SetPos( 0, self.m_pnlSkillList:GetTall() -self.m_pnlHealthBar:GetTall() )
end
vgui.Register( "SRPQMenu_Character", Panel, "EditablePanel" )