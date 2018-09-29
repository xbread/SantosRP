
-----------------------------------------------------
--[[

	Name: cl_menu_scoreboard.lua

	For: SantosRP

	By: Ultra

]]--



surface.CreateFont( "Scoreboard_Trebuchet18", {size = 18, weight = 550, font = "Trebuchet24"} )

surface.CreateFont( "Scoreboard_Trebuchet20", {size = 20, weight = 550, font = "Trebuchet24"} )

surface.CreateFont( "Scoreboard_Trebuchet24", {size = 24, weight = 550, font = "Trebuchet24"} )

surface.CreateFont( "Scoreboard_Trebuchet38", {size = 38, weight = 550, font = "Trebuchet24"} )

local TEX_GRADIENT_LEFT	= surface.GetTextureID( "gui/gradient" )

local TEX_GRADIENT_DOWN = surface.GetTextureID( "gui/gradient_down" )



local Panel = {}

function Panel:Init()

	self.m_pnlAvatar = vgui.Create( "AvatarImage", self )

	self.m_pnlAvatar:SetSize( 64, 64 )

end



function Panel:SetPlayer( pPlayer )

	self.m_pPlayer = pPlayer

	self.m_pnlAvatar:SetPlayer( pPlayer )

	self:InvalidateLayout()

end



function Panel:TranslateGroupName( strGroup )

	local data = GAMEMODE.Config.UserGroupConfig[strGroup]

	if not data then return strGroup end

	return data.Name

end



function Panel:TranslateGroupColor( strGroup )

	local data = GAMEMODE.Config.UserGroupConfig[strGroup]

	if not data then return color_white end

	return data.Color

end



function Panel:Paint( intW, intH )

	surface.SetDrawColor( 0, 0, 0, 250 )

	surface.DrawRect( 0, 0, intH +1, intH +1 )



	surface.SetDrawColor( 50, 50, 50, 150 )

	surface.DrawRect( intH +1, (intH /2) -((intH *0.6) /2), intW -1, intH *0.6 )



	surface.SetTexture( TEX_GRADIENT_LEFT )

	surface.SetDrawColor( 0, 0, 0, 100 )

	surface.DrawTexturedRect( intH +1, (intH /2) -((intH *0.6) /2), intW -1, intH *0.6 )



	if not IsValid( self.m_pPlayer ) then return end

	local prefix = ""

	if not self.m_pPlayer:Alive() then

		prefix = prefix.. "(DEAD) "

	end

	if GAMEMODE.Buddy:IsBuddyWith( self.m_pPlayer ) then

		prefix = prefix.. "(Buddy) "

	end



	local name = self.m_pPlayer:Nick()

	if not name or name == "" or name == " " then name = "Spawning... (".. self.m_pPlayer:RealNick().. ")" end

	

	draw.SimpleText(

		prefix.. name,

		"Scoreboard_Trebuchet20",

		intH +5,

		(intH /2) -1,

		color_white,

		TEXT_ALIGN_LEFT,

		TEXT_ALIGN_CENTER

	)



	draw.SimpleText(

		self.m_pPlayer:Ping().. "ms",

		"Scoreboard_Trebuchet20",

		intW -5,

		(intH /2) -1,

		color_white,

		TEXT_ALIGN_RIGHT,

		TEXT_ALIGN_CENTER

	)



	draw.SimpleText(

		self:TranslateGroupName( self.m_pPlayer:GetUserGroup() ),

		"Scoreboard_Trebuchet20",

		intW -100,

		(intH /2) -1,

		self:TranslateGroupColor( self.m_pPlayer:GetUserGroup() ),

		TEXT_ALIGN_RIGHT,

		TEXT_ALIGN_CENTER

	)

end



function Panel:PerformLayout( intW, intH )

	self.m_pnlAvatar:SetSize( intH -2, intH -2 )

	self.m_pnlAvatar:SetPos( 1, 1 )

end

vgui.Register( "SRPScoreboard_PlayerCard", Panel, "EditablePanel" )



local Panel = {}

function Panel:Init()

	self.m_tblPlayersLeft = {}

	self.m_tblPlayersRight = {}



	self.m_pnlLeftList = vgui.Create( "SRP_ScrollPanel", self )

	self.m_pnlRightList = vgui.Create( "SRP_ScrollPanel", self )



	self.m_matLogo = Material( "santosrp/logo.png", "smooth" )

end



function Panel:Refresh()

	for k, v in pairs( self.m_tblPlayersLeft ) do

		if ValidPanel( v ) then v:Remove() end

	end

	for k, v in pairs( self.m_tblPlayersRight ) do

		if ValidPanel( v ) then v:Remove() end

	end



	self.m_pnlLeftList:Clear()

	self.m_pnlRightList:Clear()



	self.m_tblPlayersLeft = {}

	self.m_tblPlayersRight = {}



	local players = player.GetAll()

	local numPlayers = #players

	for i = 1, numPlayers do

		if self:GetWide() >= 1024 and i % 2 == 0 then

			table.insert( self.m_tblPlayersRight, self:CreatePlayerCard(players[i], self.m_pnlRightList) )

		else

			table.insert( self.m_tblPlayersLeft, self:CreatePlayerCard(players[i], self.m_pnlLeftList) )

		end

	end

	

	self:InvalidateLayout()

end



function Panel:CreatePlayerCard( pPlayer, pnlParent )

	local card = vgui.Create( "SRPScoreboard_PlayerCard", pnlParent )

	card:SetPlayer( pPlayer )

	pnlParent:AddItem( card )

	return card

end



function Panel:GetJobCounts()

	local ret = {

		[2] = 0,

		[3] = 0,

		[4] = 0,

	}



	for k, v in pairs( player.GetAll() ) do

		if not GAMEMODE.Jobs:GetPlayerJobID( v ) then continue end

		local id = GAMEMODE.Jobs:GetPlayerJobID( v )

		if not ret[id] then continue end

		ret[id] = ret[id] +1

	end



	return ret

end



function Panel:PaintOver( intW, intH )

	surface.SetDrawColor( 0, 0, 0, 255 )

	surface.DrawRect( 0, 0, intW, 1 ) --top

	surface.DrawRect( 0, 0, 1, intH ) --left side



	surface.DrawRect( intW -1, 0, 1, intH ) --right side

	surface.DrawRect( 0, intH -1, intW, 1 ) --bottom



	surface.SetTexture( TEX_GRADIENT_DOWN )

	surface.SetDrawColor( 0, 0, 0, 125 )

	surface.DrawTexturedRect( 0, 0, intW, 400 )



	surface.SetDrawColor( 255, 255, 255, 255 )

	surface.SetMaterial( self.m_matLogo )

	surface.DrawTexturedRect( 5, 5, 400, 150 )



	draw.SimpleText(

		GetHostName(),

		"Scoreboard_Trebuchet38",

		intW -5,

		0,

		Color(255, 255, 255, 255),

		TEXT_ALIGN_RIGHT

	)

	draw.SimpleText(

		#player.GetAll() .."/".. game.MaxPlayers() .. " Players",

		"Scoreboard_Trebuchet24",

		intW -5,

		38 +24,

		Color(255, 255, 255, 255),

		TEXT_ALIGN_RIGHT,

		TEXT_ALIGN_BOTTOM

	)





	local y = 95

	for k, v in pairs( self:GetJobCounts() ) do

		draw.SimpleText(

			GAMEMODE.Jobs:GetJobByID( k ).Name.. ": ".. v,

			"Scoreboard_Trebuchet18",

			intW -5,

			y,

			Color(255, 255, 255, 255),

			TEXT_ALIGN_RIGHT

		)



		y = y +18

	end

end



function Panel:PerformLayout( intW, intH )

	local headerTall = 155

	local listPaddingW = 0

	local listPaddingH = 0



	if intW < 1024 then

		self.m_pnlLeftList:SetPos( listPaddingW, listPaddingH +headerTall )

		self.m_pnlLeftList:SetSize( intW -(listPaddingW *2), intH -(listPaddingH *2) -headerTall  )

		self.m_pnlRightList:SetVisible( false )



		for k, v in pairs( self.m_tblPlayersLeft ) do

			v:SetTall( 48 )

			v:DockMargin( 5, 0, 5, 5 )

			v:Dock( TOP )

		end

	else

		self.m_pnlRightList:SetVisible( true )



		local wide = (intW -(listPaddingW *3)) /2



		self.m_pnlLeftList:SetPos( listPaddingW, listPaddingH +headerTall )

		self.m_pnlLeftList:SetSize( wide, intH -(listPaddingH *2) -headerTall  )



		self.m_pnlRightList:SetPos( wide +(listPaddingW *2), listPaddingH +headerTall  )

		self.m_pnlRightList:SetSize( wide, intH -(listPaddingH *2) -headerTall  )



		for k, v in pairs( self.m_tblPlayersLeft ) do

			v:SetTall( 48 )

			v:DockMargin( 5, 0, 5, 5 )

			v:Dock( TOP )

		end



		for k, v in pairs( self.m_tblPlayersRight ) do

			v:SetTall( 48 )

			v:DockMargin( 5, 0, 5, 5 )

			v:Dock( TOP )

		end

	end

end

vgui.Register( "SRPScoreboard", Panel, "SRP_FramePanel" )
