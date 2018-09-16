--[[
	Name: cl_qmenu_tab_buddies.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_pnlAvatar = vgui.Create( "AvatarImage", self )
	self:SetText( " " )
end

function Panel:SetMainPanel( pnl )
	self.m_pnlMain = pnl
end

function Panel:SetPlayer( pPlayer )
	self.m_pPlayer = pPlayer
	self.m_pnlAvatar:SetPlayer( pPlayer )
end

function Panel:SetBuddyID( intBuddyID )
	self.m_intBuddyID = intBuddyID
end

function Panel:DoClick()
	if IsValid( self.m_pPlayer ) then
		self.m_pnlMain:ShowBuddyMenu( self.m_pPlayer:GetCharacterID() )
	else
		self.m_pnlMain:ShowBuddyMenu( self.m_intBuddyID )
	end
end

function Panel:Think()
	if not GAMEMODE.Buddy:GetBuddyData( self.m_intBuddyID ) then return end
	if not IsValid( self.m_pPlayer ) then
		local pl = GAMEMODE.Buddy:GetPlayerByBuddyID( self.m_intBuddyID )

		if pl and IsValid( pl ) then
			self:SetPlayer( pl )
		end
	end
end

function Panel:PaintOver( intW, intH )
	local buddyData = GAMEMODE.Buddy:GetBuddyData( self.m_intBuddyID )
	if not IsValid( self.m_pPlayer ) and not buddyData then return end

	local aX, aY = self.m_pnlAvatar:GetPos()
	local aW, aH = self.m_pnlAvatar:GetSize()
	local text = IsValid( self.m_pPlayer ) and self.m_pPlayer:Nick() or buddyData.LastName

	draw.SimpleText(
		IsValid(self.m_pPlayer) and "[Online] ".. text or "[Offline] ".. text,
		"DermaLarge",
		aX +aW +5,
		intH /2,
		Color( 255, 255, 255, 255 ),
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlAvatar:SetPos( 5, 5 )
	self.m_pnlAvatar:SetSize( 32, 32 )
end
vgui.Register( "SRPBuddyCard", Panel, "SRP_Button" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlBtnBack = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnBack:SetText( "Back" )
	self.m_pnlBtnBack.DoClick = function()
		self:GetParent():ShowBuddyOverview()
	end

	self.m_pnlBtnCar = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnCar.DoClick = function()
		local buddyData = GAMEMODE.Buddy:GetBuddyData( self.m_intBuddyID )
		local value = not (buddyData and buddyData.Settings["ShareCar"] or false)
		GAMEMODE.Net:RequestEditBuddyKey( self.m_intBuddyID, "ShareCar", value )
	end
	self.m_pnlBtnCar.Think = function()
		local buddyData = GAMEMODE.Buddy:GetBuddyData( self.m_intBuddyID )
		self.m_pnlBtnCar:SetDisabled( not buddyData )
		if not buddyData then return end

		self.m_pnlBtnCar:SetText( buddyData.Settings.ShareCar and "Revoke Car Keys" or "Share Car Keys" )
	end

	self.m_pnlBtnDoor = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnDoor.DoClick = function()
		local buddyData = GAMEMODE.Buddy:GetBuddyData( self.m_intBuddyID )
		local value = not (buddyData and buddyData.Settings["ShareDoors"] or false)
		GAMEMODE.Net:RequestEditBuddyKey( self.m_intBuddyID, "ShareDoors", value )
	end
	self.m_pnlBtnDoor.Think = function()
		local buddyData = GAMEMODE.Buddy:GetBuddyData( self.m_intBuddyID )
		self.m_pnlBtnDoor:SetDisabled( not buddyData )
		if not buddyData then return end

		self.m_pnlBtnDoor:SetText( buddyData.Settings.ShareDoors and "Revoke Property Keys" or "Share Property Keys" )
	end

	self.m_pnlBtnItems = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnItems.DoClick = function()
		local buddyData = GAMEMODE.Buddy:GetBuddyData( self.m_intBuddyID )
		local value = not (buddyData and buddyData.Settings["ShareItems"] or false)
		GAMEMODE.Net:RequestEditBuddyKey( self.m_intBuddyID, "ShareItems", value )
	end
	self.m_pnlBtnItems.Think = function()
		local buddyData = GAMEMODE.Buddy:GetBuddyData( self.m_intBuddyID )
		self.m_pnlBtnItems:SetDisabled( not buddyData )
		if not buddyData then return end

		self.m_pnlBtnItems:SetText( buddyData.Settings.ShareItems and "Revoke Prop Protection" or "Grant Prop Protection" )
	end

	self.m_pnlBtnRemove = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnRemove.DoClick = function()
		local buddyData = GAMEMODE.Buddy:GetBuddyData( self.m_intBuddyID )
		if not buddyData then
			GAMEMODE.Net:RequestAddBuddy( self.m_intBuddyID )
		else
			GAMEMODE.Net:RequestRemoveBuddy( self.m_intBuddyID )
			self:GetParent():ShowBuddyOverview()
		end
	end
	self.m_pnlBtnRemove.Think = function()
		local buddyData = GAMEMODE.Buddy:GetBuddyData( self.m_intBuddyID )
		if not buddyData then
			self.m_pnlBtnRemove:SetText( "Add Buddy" )
		else
			self.m_pnlBtnRemove:SetText( "Remove Buddy" )
		end
	end

	self.m_tblPropertyBtns = {}
end

function Panel:SetBuddyData( intBuddyID )
	self.m_intBuddyID = intBuddyID
end

function Panel:Update()
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlBtnBack:SetPos( 5, intH -25 )
	self.m_pnlBtnBack:SetSize( 100, 20 )

	self.m_pnlBtnCar:DockMargin( 0, 0, 0, 5 )
	self.m_pnlBtnDoor:DockMargin( 0, 0, 0, 5 )
	self.m_pnlBtnItems:DockMargin( 0, 0, 0, 5 )
	self.m_pnlBtnRemove:DockMargin( 0, 0, 0, 5 )

	self.m_pnlBtnCar:SetTall( 32 )
	self.m_pnlBtnDoor:SetTall( 32 )
	self.m_pnlBtnItems:SetTall( 32 )
	self.m_pnlBtnRemove:SetTall( 32 )

	self.m_pnlBtnCar:Dock( TOP )
	self.m_pnlBtnDoor:Dock( TOP )
	self.m_pnlBtnItems:Dock( TOP )
	self.m_pnlBtnRemove:Dock( TOP )
end
vgui.Register( "SRPEditBuddy", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlCardContainer = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}
end

function Panel:Rebuild()
	for k, v in pairs( self.m_tblCards ) do
		if ValidPanel( v ) then v:Remove() end
	end
	self.m_tblCards = {}

	self:AddHeader( "Buddies" )
	for k, v in pairs( GAMEMODE.Buddy:GetBuddyTable() ) do
		self:AddBuddy( k )
	end

	self:AddHeader( "Players" )
	for k, v in pairs( player.GetAll() ) do
		if v == LocalPlayer() then continue end
		if GAMEMODE.Buddy:IsBuddyWith( v ) then continue end
		if not v:GetCharacterID() or v:GetCharacterID() == 0 then continue end
		self:AddPlayer( v )
	end

	self:InvalidateLayout()
end

function Panel:AddHeader( strText )
	local header = vgui.Create( "EditablePanel" )
	header.Paint = function( pnl, intW, intH )
		surface.SetDrawColor( 70, 70, 70, 100 )
		surface.DrawRect( 0, 0, intW, intH )

		surface.SetFont( "DermaLarge" )
		local tX, tY = surface.GetTextSize( strText )

		draw.SimpleText(
			strText,
			"DermaLarge",
			(intW /2),
			(intH /2),
			Color( 255, 255, 255, 255 ),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)	
	end

	table.insert( self.m_tblCards, header )
	self.m_pnlCardContainer:AddItem( header )
end

function Panel:AddPlayer( pPlayer )
	local card = vgui.Create( "SRPBuddyCard", self )
	card:SetMainPanel( self:GetParent() )
	card:SetPlayer( pPlayer )
	card:SetTextColorOverride( Color(255, 255, 255, 255) )
	table.insert( self.m_tblCards, card )
	self.m_pnlCardContainer:AddItem( card )
end

function Panel:AddBuddy( intBuddyID )
	local card = vgui.Create( "SRPBuddyCard", self )
	card:SetMainPanel( self:GetParent() )

	local pl = GAMEMODE.Buddy:GetPlayerByBuddyID( intBuddyID )
	card:SetBuddyID( intBuddyID )
	if pl then
		card:SetPlayer( pl )
	end

	table.insert( self.m_tblCards, card )
	self.m_pnlCardContainer:AddItem( card )
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlCardContainer:SetPos( 0, 0 )
	self.m_pnlCardContainer:SetSize( intW, intH )

	local padding = 5
	local cardTall = 32 +(padding *2)
	local yPos = 0
	for k, v in pairs( self.m_tblCards ) do
		v:SetPos( 0, yPos )
		v:SetSize( intW, cardTall )

		yPos = yPos +cardTall +padding
	end
end
vgui.Register( "SRPViewBuddy", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self.m_pnlEditBuddy = vgui.Create( "SRPEditBuddy", self )
	self.m_pnlViewBuddy = vgui.Create( "SRPViewBuddy", self )

	hook.Add( "GamemodeOnBuddyUpdate", "UpdateBuddyMenu", function()
		self:Rebuild()
	end )

	self:ShowBuddyOverview()
end

function Panel:ShowBuddyMenu( intBuddyID )
	self.m_pnlViewBuddy:SetVisible( false )
	self.m_pnlEditBuddy:SetVisible( true )
	self.m_pnlEditBuddy:SetBuddyData( intBuddyID )
	self.m_pnlEditBuddy:Update()
	self.m_pnlEditBuddy:MoveToFront()
end

function Panel:ShowBuddyOverview()
	self.m_pnlViewBuddy:SetVisible( true )
	self.m_pnlEditBuddy:SetVisible( false )
	self.m_pnlViewBuddy:MoveToFront()
end

function Panel:Rebuild()
	self.m_pnlViewBuddy:Rebuild()

	if self.m_pnlEditBuddy:IsVisible() then
		self.m_pnlEditBuddy:Update()
	end
end

function Panel:PerformLayout( intW, intH )
	self.m_pnlViewBuddy:SetPos( 0, 0 )
	self.m_pnlEditBuddy:SetPos( 0, 0 )
	self.m_pnlViewBuddy:SetSize( intW, intH )
	self.m_pnlEditBuddy:SetSize( intW, intH )
end
vgui.Register( "SRPQMenu_Buddies", Panel, "EditablePanel" )