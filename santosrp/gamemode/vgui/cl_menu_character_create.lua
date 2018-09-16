--[[
	Name: cl_menu_character_create.lua
	For: TalosLife
	By: TalosLife
]]--

surface.CreateFont( "CharacterDisplayFont" , {
	font = "Trebuchet",
	size = 24,
	weight = 1500,
	antialias = true,
	outline  = false,
	shadow  = true,
} )

surface.CreateFont( "CharacterTitleFont" , {
	font = "Trebuchet",
	size = 48,
	weight = 400,
	antialias = true,
	outline  = false,
	shadow  = true,
} )

local Panel = {}
function Panel:Init()
	self:SetText( " " )

	self.m_strFirstName = "John"
	self.m_strLastName = "Doe"

	self.m_entModel = ClientsideModel( "models/error.mdl", RENDERGROUP_BOTH )
	self.m_entModel:SetSkin( 0 )
	self.m_entModel:SetNoDraw( true )
	local min, max = self.m_entModel:GetRenderBounds()
	local center = (min +max) *-0.50
	self.m_entModel:SetPos( center +Vector(0, 0, 2) )
	self.m_entModel:SetAngles( Angle(0, 0, 0) )
	self.m_intLastPaint = 0

	self.m_colBG = Color( 75, 75, 75, 100 )
end

function Panel:SetName( strFirst, strLast )
	self.m_strFirstName = strFirst
	self.m_strLastName = strLast
end

function Panel:SetModel( strModel )
	self.m_entModel:SetModel( strModel )
	self.m_entModel:ResetSequence( self.m_entModel:LookupSequence("pose_standing_01") )
end

function Panel:SetSkin( intSkin )
	self.m_entModel:SetSkin( intSkin )
end

function Panel:SkinCount()
	return self.m_entModel:SkinCount()
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
	self.m_entModel:DrawModel()
	render.SetScissorRect( 0, 0, 0, 0, false )
end

function Panel:SetBackgroundColor( col )
	self.m_colBG = col
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( self.m_colBG )
	surface.DrawRect( 0, 0, intW, intH )

	if not IsValid( self.m_entModel ) then return end
	local x, y = self:LocalToScreen( 0, 0 )

	local ang = Angle( 0, 0, 0 )
	cam.Start3D( ang:Forward() *105, (ang:Forward() *-1):Angle(), 33, x, y, intW, intH, 5 )
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

	self.m_intLastPaint = RealTime()
end

function Panel:PerformLayout( intW, intH )
end
vgui.Register( "SRPCharacterPreview", Panel, "DButton" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_strFirstName = "John"
	self.m_strLastName = "Doe"
	self.m_intSex = 0
	self.m_intSkin = 0

	--Pick a random model
	local count = table.Count( GAMEMODE.Config.PlayerModels.Male )
	local randomIDX = math.random( 1, count )
	local i = 0
	for k, v in pairs( GAMEMODE.Config.PlayerModels.Male ) do
		i = i +1
		if i == randomIDX then self.m_strModel = k break end
	end

	--Right side buttons
	self.m_pnlBtnContainer = vgui.Create( "EditablePanel", self )
	self.m_pnlBtnContainer.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 100 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlBtnBack = vgui.Create( "SRP_Button", self.m_pnlBtnContainer )
	self.m_pnlBtnBack:SetText( "Back" )
	self.m_pnlBtnBack.DoClick = function()
		GAMEMODE.Gui:ShowCharacterSelection()
	end

	self.m_pnlBtnSex = vgui.Create( "SRP_Button", self.m_pnlBtnContainer )
	self.m_pnlBtnSex:SetText( "Male" )
	self.m_pnlBtnSex.DoClick = function()
		self.m_intSex = self.m_intSex == 1 and 0 or 1
		self.m_pnlBtnSex:SetText( self.m_intSex == 0 and "Male" or "Female" )
		self:ChangeSex()
	end

	self.m_pnlBtnOk = vgui.Create( "SRP_Button", self.m_pnlBtnContainer )
	self.m_pnlBtnOk:SetText( "Done" )
	self.m_pnlBtnOk.DoClick = function()
		GAMEMODE.Net:RequestCreateCharacter{
			Name = {
				First = self.m_strFirstName,
				Last = self.m_strLastName,
			},
			Model = self.m_strModel,
			Sex = self.m_intSex,
			Skin = self.m_intSkin,
		}
	end

	--Left side character display
	self.m_pnlCharDisplay = vgui.Create( "SRPCharacterPreview", self )
	self.m_pnlCharDisplay:SetName( self.m_strFirstName, self.m_strLastName )
	self.m_pnlCharDisplay:SetModel( self.m_strModel )

	--Center options
	self.m_pnlNameFLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameFLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameFLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameFLabel:SetFont( "DermaLarge" )
	self.m_pnlNameFLabel:SetText( "First Name" )

	self.m_pnlNameLLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLLabel:SetFont( "DermaLarge" )
	self.m_pnlNameLLabel:SetText( "Last Name" )

	self.m_pnlNameFirst = vgui.Create( "DTextEntry", self )
	self.m_pnlNameFirst:SetText( self.m_strFirstName )
	self.m_pnlNameLast = vgui.Create( "DTextEntry", self )
	self.m_pnlNameLast:SetText( self.m_strLastName )

	self.m_pnlNameFirst.OnTextChanged = function()
		self.m_strFirstName = self.m_pnlNameFirst:GetText()
		self.m_pnlCharDisplay:SetName( self.m_strFirstName, self.m_strLastName )
	end
	self.m_pnlNameLast.OnTextChanged = function()
		self.m_strLastName = self.m_pnlNameLast:GetText()
		self.m_pnlCharDisplay:SetName( self.m_strFirstName, self.m_strLastName )
	end

	self.m_pnlSkinLabel = vgui.Create( "DLabel", self )
	self.m_pnlSkinLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlSkinLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlSkinLabel:SetFont( "DermaLarge" )
	self.m_pnlSkinLabel:SetText( "Character Skin (0)" )

	self.m_pnlBtnSkinNext = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnSkinNext:SetText( "Next ->" )
	self.m_pnlBtnSkinNext.DoClick = function()
		self:NextSkin()
	end

	self.m_pnlBtnSkinLast = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnSkinLast:SetText( "<- Last" )
	self.m_pnlBtnSkinLast.DoClick = function()
		self:LastSkin()
	end

	self.m_pnlModelLabel = vgui.Create( "DLabel", self )
	self.m_pnlModelLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlModelLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlModelLabel:SetFont( "DermaLarge" )
	self.m_pnlModelLabel:SetText( "Character Model" )

	self.m_pnlModelList = vgui.Create( "DPanelList", self )
	self.m_pnlModelList:SetSpacing( 5 )
	self.m_pnlModelList:SetPadding( 10 )
	self.m_pnlModelList:EnableHorizontal( true ) 
	self.m_pnlModelList:EnableVerticalScrollbar( false ) 
	self.m_pnlModelList.Paint = function( _, intW, intH )
		surface.SetDrawColor( 50, 50, 50, 125 )
		surface.DrawRect( 0, 0, intW, intH )
	end

	self.m_pnlErrorLabel = vgui.Create( "DLabel", self )
	self.m_pnlErrorLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlErrorLabel:SetTextColor( Color(255, 50, 50, 255) )
	self.m_pnlErrorLabel:SetFont( "Trebuchet24" )
	self.m_pnlErrorLabel:SetText( "" )

	hook.Add( "GamemodeGameStatusChanged", "HideMenu", function( bStatus )
		if not ValidPanel( self ) then return end
		if bStatus then self:SetVisible( false ) end
	end )

	hook.Add( "GamemodeCharacterCreateError", "CharCreateMenu", function( strError )
		if not ValidPanel( self ) or not self:IsVisible() then return end
		self.m_pnlErrorLabel:SetText( "Error: ".. strError )
		self:InvalidateLayout()
	end )

	hook.Add( "GamemodeLoadingCharacter", "ShowLoadingMenuNewChar", function()
		if not self:IsVisible() then return end
		GAMEMODE.Gui:ShowCharacterSelection()
		GAMEMODE.Gui.m_pnlCharSel:InvalidateLayout( true )
		GAMEMODE.Gui.m_pnlCharSel:ShowLoadingScreen()
	end )

	self:PopulateModelList()
end

function Panel:NextSkin()
	self.m_intSkin = self.m_intSkin +1
	if self.m_intSkin > self.m_pnlCharDisplay:SkinCount() -1 then
		self.m_intSkin = 0
	end

	if not GAMEMODE.Util:ValidPlayerSkin( self.m_strModel, self.m_intSkin ) then
		self:NextSkin()
		return
	end

	self.m_pnlSkinLabel:SetText( "Character Skin (".. self.m_intSkin.. ")" )
	self.m_pnlCharDisplay:SetSkin( self.m_intSkin )
	self:InvalidateLayout()
end

function Panel:LastSkin()
	self.m_intSkin = self.m_intSkin -1
	if self.m_intSkin < 0 then
		self.m_intSkin = self.m_pnlCharDisplay:SkinCount() -1
	end

	if not GAMEMODE.Util:ValidPlayerSkin( self.m_strModel, self.m_intSkin ) then
		self:LastSkin()
		return
	end

	self.m_pnlSkinLabel:SetText( "Character Skin (".. self.m_intSkin.. ")" )
	self.m_pnlCharDisplay:SetSkin( self.m_intSkin )
	self:InvalidateLayout()
end

function Panel:ChangeSex()
	self:PopulateModelList()

	--Pick a random model
	local models = GAMEMODE.Config.PlayerModels[self.m_intSex == 0 and "Male" or "Female"]
	local count = table.Count( models )
	local randomIDX = math.random( 1, count )
	local i = 0
	for k, v in pairs( models ) do
		i = i +1
		if i == randomIDX then self.m_strModel = k break end
	end

	self.m_intSkin = 0
	self.m_pnlSkinLabel:SetText( "Character Skin (0)" )
	self.m_pnlCharDisplay:SetModel( self.m_strModel )
	self.m_pnlCharDisplay:SetSkin( self.m_intSkin )
	self:InvalidateLayout()
end

function Panel:PopulateModelList()
	local models = GAMEMODE.Config.PlayerModels[self.m_intSex == 0 and "Male" or "Female"]
	self.m_pnlModelList:Clear( true )

	for k, v in pairs( models ) do
		local modelIcon = vgui.Create( "SpawnIcon" )
		modelIcon:SetSize( 64, 64 )
		modelIcon:SetModel( k )
		modelIcon:SetToolTip( nil )
		modelIcon.PaintOver = function()
		end
		modelIcon.DoClick = function()
			self.m_strModel = k
			self.m_pnlCharDisplay:SetModel( k )
			self.m_intSkin = 0
			self.m_pnlSkinLabel:SetText( "Character Skin (0)" )
			self.m_pnlCharDisplay:SetSkin( self.m_intSkin )
			self:InvalidateLayout()
		end

		self.m_pnlModelList:AddItem( modelIcon )
	end

	self:InvalidateLayout()
end

function Panel:PerformLayout( intW, intH )
	if not self.m_pnlCharDisplay then return end
	
	--Left side
	self.m_pnlCharDisplay:SetPos( 0, 0 )
	self.m_pnlCharDisplay:SetSize( intW *0.25, intH )

	--Right side
	self.m_pnlBtnContainer:SetSize( intW *0.15, intH )
	self.m_pnlBtnContainer:SetPos( intW -self.m_pnlBtnContainer:GetWide(), 0 )

	local btnY, btnPadding = 0, 0
	self.m_pnlBtnBack:SetPos( 0, btnY )
	self.m_pnlBtnBack:SetSize( self.m_pnlBtnContainer:GetWide(), 64 )
	btnY = btnY +self.m_pnlBtnBack:GetTall() +btnPadding

	self.m_pnlBtnSex:SetPos( 0, btnY )
	self.m_pnlBtnSex:SetSize( self.m_pnlBtnContainer:GetWide(), self.m_pnlBtnContainer:GetWide() )
	btnY = btnY +self.m_pnlBtnSex:GetTall() +btnPadding

	self.m_pnlBtnOk:SetSize( self.m_pnlBtnContainer:GetWide(), 64 )
	self.m_pnlBtnOk:SetPos( 0, intH -self.m_pnlBtnOk:GetTall() )

	--Center
	local w, h = self.m_pnlCharDisplay:GetSize()
	local cW = intW -w -self.m_pnlBtnContainer:GetWide()
	local curH = 5

	self.m_pnlErrorLabel:SizeToContents()
	self.m_pnlErrorLabel:SetPos( w +5, curH )
	self.m_pnlErrorLabel:SetVisible( self.m_pnlErrorLabel:GetText() ~= "" )
	if self.m_pnlErrorLabel:IsVisible() then
		curH = curH +self.m_pnlErrorLabel:GetTall() +5
	end

	self.m_pnlNameFLabel:SizeToContents()
	self.m_pnlNameFLabel:SetPos( w +5, curH )
	curH = curH +self.m_pnlNameFLabel:GetTall() +5

	self.m_pnlNameFirst:SetPos( w +5, curH )
	self.m_pnlNameFirst:SetSize( cW -10, 30 )
	curH = curH +self.m_pnlNameFirst:GetTall() +5

	self.m_pnlNameLLabel:SizeToContents()
	self.m_pnlNameLLabel:SetPos( w +5, curH )
	curH = curH +self.m_pnlNameLLabel:GetTall() +5

	self.m_pnlNameLast:SetPos( w +5, curH )
	self.m_pnlNameLast:SetSize( cW -10, 30 )
	curH = curH +self.m_pnlNameLLabel:GetTall() +5

	self.m_pnlModelList:SetSize( cW, 155 )
	self.m_pnlModelList:SetPos( w, intH -self.m_pnlModelList:GetTall() )

	self.m_pnlModelLabel:SizeToContents()
	self.m_pnlModelLabel:SetPos( w +5, intH -self.m_pnlModelList:GetTall() -self.m_pnlModelLabel:GetTall() )

	local x, y = self.m_pnlModelLabel:GetPos()
	self.m_pnlSkinLabel:SizeToContents()
	self.m_pnlSkinLabel:SetPos( w +5 +((cW /2) -self.m_pnlSkinLabel:GetWide() /2), y -self.m_pnlSkinLabel:GetTall() )

	self.m_pnlBtnSkinLast:SetSize( 96, self.m_pnlSkinLabel:GetTall() )
	self.m_pnlBtnSkinLast:SetPos( w +5, y -self.m_pnlSkinLabel:GetTall() )

	self.m_pnlBtnSkinNext:SetSize( 96, self.m_pnlSkinLabel:GetTall() )
	self.m_pnlBtnSkinNext:SetPos( w +cW -self.m_pnlBtnSkinNext:GetWide() -5, y -self.m_pnlSkinLabel:GetTall() )
end
vgui.Register( "SRPNewCharacterPanel", Panel, "SRP_FramePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetText( " " )
end

function Panel:SetCharacter( intCharID, tblCharData )
	self.m_intCharID = intCharID
	self.m_tblChar = tblCharData

	if IsValid( self.m_entModel ) then
		self.m_entModel:Remove()
	end

	self.m_entModel = ClientsideModel( tblCharData.Model, RENDERGROUP_BOTH )
	self.m_entModel:SetSkin( tblCharData.Skin )
	self.m_entModel:SetNoDraw( true )

	local min, max = self.m_entModel:GetRenderBounds()
	local center = (min +max) *-0.50
	self.m_entModel:SetPos( center +Vector(0, 0, 2) )
	self.m_entModel:SetAngles( Angle(0, 0, 0) )

	self.m_entModel:ResetSequence( self.m_entModel:LookupSequence("pose_standing_01") )
	self.m_intLastPaint = 0
end

function Panel:DoClick()
	GAMEMODE.Net:RequestSelectCharacter( self.m_intCharID )
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
	self.m_entModel:DrawModel()
	render.SetScissorRect( 0, 0, 0, 0, false )
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( Color(75, 75, 75, 100) )
	surface.DrawRect( 0, 0, intW, intH )

	if not IsValid( self.m_entModel ) then return end
	local x, y = self:LocalToScreen( 0, 0 )

	local lightScale = self.Hovered and 1 or 0.15

	local ang = Angle( 0, 0, 0 )
	cam.Start3D( ang:Forward() *105, (ang:Forward() *-1):Angle(), 33, x, y, intW, intH, 5 )
		cam.IgnoreZ( true )
	
		render.SuppressEngineLighting( true )
		render.SetLightingOrigin( self.m_entModel:GetPos() )
		render.ResetModelLighting( lightScale, lightScale, lightScale )
		render.SetColorModulation( 1, 1, 1 )
		render.SetBlend( 1 )

		self:DrawModel()
	
		render.SuppressEngineLighting( false )
		cam.IgnoreZ( false )
	cam.End3D()

	self.m_entModel:FrameAdvance( (RealTime() -self.m_intLastPaint) *1 )

	draw.SimpleText(
		self.m_tblChar.Name.First.. " ".. self.m_tblChar.Name.Last,
		"CharacterDisplayFont",
		intW /2,
		intH /2,
		Color( 255, 255, 255, 255 ),
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER
	)

	self.m_intLastPaint = RealTime()
end

function Panel:PerformLayout( intW, intH )
end
vgui.Register( "SRPCharacterCard", Panel, "DButton" )

-- ----------------------------------------------------------------

local MAT_BLUR = Material( "pp/blurscreen.png", "noclamp" )
local Panel = {}
function Panel:Init()
	self.m_pnlTitleLabel = vgui.Create( "DLabel", self )
	self.m_pnlTitleLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlTitleLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlTitleLabel:SetFont( "CharacterTitleFont" )
	self.m_pnlTitleLabel:SetText( "Select A Character" )

	self.m_pnlBtnDisconnect = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnDisconnect:SetText( "Disconnect" )
	self.m_pnlBtnDisconnect.DoClick = function()
		RunConsoleCommand( "Disconnect" )
	end
	self.m_pnlBtnDisconnect.Paint = function( _, intW, intH )
		if self.m_pnlBtnDisconnect.Hovered then
			surface.SetDrawColor( 80, 80, 80, 150 )
		else
			surface.SetDrawColor( 50, 50, 50, 125 )
		end
		
		GAMEMODE.HUD:DrawFancyRect( 0, 0, intW, intH, 110, 90 )
		self.m_pnlBtnDisconnect:SetTextColor( Color(255, 255, 255, 255) )
	end

	self.m_pnlCharContainer = vgui.Create( "EditablePanel", self )
	self.m_tblCards = {}

	self.m_pnlLoadingMenu = vgui.Create( "EditablePanel", self )
	self.m_pnlLoadingMenu:SetVisible( false )
	self.m_pnlLoadingMenu:SetSize( 0, 0 )
	self.m_pnlLoadingMenu.Paint = function( pnl, intW, intH )
		draw.SimpleText(
			"Waiting for game data...",
			"CharacterDisplayFont",
			intW /2,
			intH /2,
			Color( 255, 255, 255, 255 ),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end

	hook.Add( "GamemodeGameStatusChanged", "HideMenu", function( bStatus )
		if not ValidPanel( self ) then return end
		if bStatus then self:SetVisible( false ) end
	end )

	hook.Add( "GamemodeLoadingCharacter", "ShowLoadingMenu", function()
		if not self:IsVisible() then return end
		self:ShowLoadingScreen()
	end )
end

function Panel:ShowLoadingScreen()
	local x, y = self.m_pnlCharContainer:GetPos()
	local w, h = self.m_pnlCharContainer:GetSize()

	self.m_pnlCharContainer:MoveTo( -w, y, 0.25, 0, 2, function()
		self.m_pnlCharContainer:SetVisible( false )
	end )

	self.m_pnlLoadingMenu:SetPos( self:GetWide(), y )
	self.m_pnlLoadingMenu:SetSize( w, h )
	self.m_pnlLoadingMenu:SetVisible( true )
	self.m_pnlLoadingMenu:MoveTo( 0, y, 0.25, 0, 2, function()
		self.m_pnlLoadingMenu:SetVisible( true )
	end )

	self.m_pnlTitleLabel:SetText( "Loading..." )
	self.m_pnlTitleLabel:SizeToContents()
	self.m_pnlTitleLabel:SetPos( (self:GetWide() /2) -(self.m_pnlTitleLabel:GetWide() /2), 5 )
end

function Panel:Populate( tblChars )
	for k, v in pairs( self.m_tblCards ) do
		if ValidPanel( v ) then
			v:Remove()
		end
	end

	self.m_tblCards = {}
	for id, data in pairs( tblChars ) do
		local card = vgui.Create( "SRPCharacterCard", self.m_pnlCharContainer )
		card:SetCharacter( id, data )

		table.insert( self.m_tblCards, card )
	end

	if table.Count( self.m_tblCards ) < GAMEMODE.Config.MaxCharacters then
		local pnlIconBtn = vgui.Create( "SRP_Button", self.m_pnlCharContainer )
		pnlIconBtn:SetText( "New Character" )
		pnlIconBtn.DoClick = function()
			GAMEMODE.Gui:ShowNewCharacterMenu()
		end

		table.insert( self.m_tblCards, pnlIconBtn )
	end
end

function Panel:Paint( intW, intH )
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
	surface.DrawRect( 0, 0, intW, intH )

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

	surface.SetDrawColor( 35, 35, 35, 80 )
	surface.DrawRect( 0, 0, intW, intH )

	local tX, tY = self.m_pnlTitleLabel:GetPos()
	local tW, tH = self.m_pnlTitleLabel:GetSize()
	local extraPadding = 96

	local _, contentY = self.m_pnlCharContainer:GetPos()
	surface.SetDrawColor( 50, 50, 50, 125 )
	GAMEMODE.HUD:DrawFancyRect( tX -(extraPadding /2), 0, tW +extraPadding, contentY, 110, 70 )
end

function Panel:PerformLayout( intW, intH )
	local titlePadding = 5
	self.m_pnlTitleLabel:SizeToContents()
	self.m_pnlTitleLabel:SetPos( (intW /2) -(self.m_pnlTitleLabel:GetWide() /2), titlePadding )

	self.m_pnlBtnDisconnect:SetSize( 150, self.m_pnlTitleLabel:GetTall() +(titlePadding *2) )
	self.m_pnlBtnDisconnect:SetPos( intW -self.m_pnlBtnDisconnect:GetWide(), 0 )

	self.m_pnlCharContainer:SetPos( 0, (titlePadding *2) +self.m_pnlTitleLabel:GetTall() )
	self.m_pnlCharContainer:SetSize( intW, intH -titlePadding -self.m_pnlTitleLabel:GetTall() )

	local cW, cH = self.m_pnlCharContainer:GetSize()

	local maxChars = 3
	local paddingW, paddingH = cH *0.025, cH *0.025

	local sizeW = (cW -(paddingW *maxChars) -paddingW) /maxChars
	local sizeH = cH -(paddingH *2)
	local curX = paddingW

	for k, v in pairs( self.m_tblCards ) do
		v:SetSize( sizeW, sizeH )
		v:SetPos( curX, paddingH )
		curX = curX +paddingW +sizeW
	end
end
vgui.Register( "SRPCharacterSelection", Panel, "SRP_FramePanel" )