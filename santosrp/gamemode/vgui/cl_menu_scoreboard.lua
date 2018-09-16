--[[
    Name: cl_menu_scoreboard.lua
    For: SantosRP
    By: Ultra
]]--
 
surface.CreateFont( "Scoreboard_Trebuchet18", {size = 18, weight = 550, font = "Trebuchet24"} )
surface.CreateFont( "Scoreboard_Trebuchet20", {size = 20, weight = 550, font = "Trebuchet24"} )
surface.CreateFont( "Scoreboard_Trebuchet24", {size = 24, weight = 550, font = "Trebuchet24"} )
surface.CreateFont( "Scoreboard_Trebuchet38", {size = 38, weight = 550, font = "Trebuchet24"} )
local TEX_GRADIENT_LEFT = surface.GetTextureID( "gui/gradient" )
local TEX_GRADIENT_DOWN = surface.GetTextureID( "gui/gradient_down" )
 
local Panel = {}
SCOREBOARD = Panel
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
    if data.Rainbow then return data.Color() end
    return data.Color
end
 
function Panel:Paint( intW, intH )
    surface.SetDrawColor( 0, 0, 0, 250 )
    surface.DrawRect( 0, 9, intH +1-21, intH +1-21 )
 
    surface.SetDrawColor( 50, 50, 50, 150 )
    surface.DrawRect( intH -14, (intH /2) -((intH *0.6) /2), intW -1, intH *0.6 )
 
    surface.SetTexture( TEX_GRADIENT_LEFT )
    surface.SetDrawColor( 0, 0, 0, 100 )
    surface.DrawTexturedRect( intH -14, (intH /2) -((intH *0.6) /2), intW -1, intH *0.6 )
 
    if not IsValid( self.m_pPlayer ) then return end
    local prefix = ""
    if not self.m_pPlayer:Alive() then
        prefix = prefix.. "(Not Alive) "
    end
    if GAMEMODE.Buddy:IsBuddyWith( self.m_pPlayer ) then
        prefix = prefix.. "(Buddy) "
    end
 
    local ee = self.m_pPlayer:SteamID64()

    local lenny = steamworks.GetPlayerName(ee)

    --local name = self.m_pPlayer:Nick()
    local name 
    if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() or LocalPlayer():GetUserGroup() == "trialmod" or LocalPlayer():GetUserGroup() == "moderator" or LocalPlayer():GetUserGroup() == "developer" then
        name = lenny .. " ( " .. self.m_pPlayer:Nick() .. " )"
    else
    	name = lenny
    end
    --if not name or name == "" or name == " " then name = "Spawning... (".. self.m_pPlayer:RealNick().. ")" end
   
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
        math.floor(self.m_pPlayer:Ping() / 2) .. "ms",
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

function Panel:OnMouseReleased(mc)
    local ply = self.m_pPlayer
    if mc==MOUSE_LEFT then
        local a=DermaMenu()
        	a:AddOption(ply:GetName(),function() SetClipboardText(ply:GetName()) end)
        	a:AddSpacer()
            RegisterDermaMenuForClose(a)
            a:AddOption("Open Profile URL",function()
                local url="http://steamcommunity.com/profiles/" .. tostring(ply:SteamID64())
                gui.OpenURL(url)
            end):SetImage'icon16/transmit.png'
            a:AddOption("Copy Profile URL",function()
                SetClipboardText("http://steamcommunity.com/profiles/".. tostring(ply:SteamID64()))
            end):SetImage'icon16/link.png'
            a:AddSpacer()
            a:AddOption("Copy SteamID",function()
                SetClipboardText(tostring(ply:SteamID()))
            end):SetImage'icon16/book_edit.png'
            a:AddOption("Copy Community ID",function()
                SetClipboardText(tostring(ply:SteamID64()))
            end):SetImage'icon16/book_link.png'
            a:AddOption("Copy Name",function()
                SetClipboardText("RP Name: " .. ply:Nick() .. " | Steam Name: " .. ply:GetName())
            end):SetImage'icon16/user_suit.png'
            a:AddSpacer()
            if ply==LocalPlayer() then
                a:AddOption("Disconnect",function()
                RunConsoleCommand("disconnect")
            end):SetImage'icon16/stop.png'
        end

        a:Open()
    end
    if mc==MOUSE_RIGHT then
        local a=DermaMenu()
        if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() or LocalPlayer():GetUserGroup() == "trialmod" or LocalPlayer():GetUserGroup() == "moderator" then
        			a:AddOption(ply:GetName(),function() SetClipboardText(ply:GetName()) end)
        			a:AddOption(ply:Nick(),function() SetClipboardText(ply:Nick()) end)
        			a:AddOption(ply:SteamID(),function() SetClipboardText(ply:SteamID()) end)
        			a:AddOption(ply:SteamID64(),function() SetClipboardText(ply:SteamID64()) end)
					local adminmenu,b = a:AddSubMenu("Admin Menu",function() end)
					b:SetImage'icon16/lock_open.png'


					local m,b = adminmenu:AddSubMenu("Kick",function()
						RunConsoleCommand("ulx","kick","'" .. ply:Nick() .. "'")
					end)
					b:SetImage'icon16/door_out.png'
					m:AddOption(("%s (%s)"):format("kick", "Posting pornographic content"),function()
						RunConsoleCommand("ulx","kick","'" .. ply:Nick() .. "'", "Posting pornographic content")
					end):SetImage('icon16/door_out.png')
					m:AddOption(("%s (%s)"):format("kick", "Chat Spam"),function()
						RunConsoleCommand("ulx","kick","'" .. ply:Nick() .. "'", "Chat Spam")
					end):SetImage('icon16/door_out.png')
					m:AddOption(("%s (%s)"):format("kick", "Prop Spam"),function()
							RunConsoleCommand("ulx","kick","'" .. "'" .. ply:Nick() .. "'" .. "'", "Prop Spam")
					end):SetImage('icon16/door_out.png')
					m:AddOption(("%s (%s)"):format("kick", "Annoying other players"),function()
						RunConsoleCommand("ulx","kick","'" .. ply:Nick() .. "'", "Annoying other players")
					end):SetImage('icon16/door_out.png')
					m:AddSpacer()
					m:AddOption(("%s (%s)"):format("kick", "Custom Reason"),function()	
								Derma_StringRequest(
									"Kick with custom reason",
									"Type in a custom kick reason",
									"",
									function(txt) RunConsoleCommand("ulx","kick","'" .. ply:Nick() .. "'",txt) end,
									function(txt) return false end
								)
						end):SetImage('icon16/door_out.png')

					if LocalPlayer():IsAdmin() then
						local m,b = adminmenu:AddSubMenu("Ban",function()
							RunConsoleCommand("ulx", "ban","'" .. ply:Nick() .. "'")
						end)
						b:SetImage'icon16/stop.png'
						m:AddOption(("%s (%s)"):format("Ban", "Posting pornographic content"),function()
							
								RunConsoleCommand("ulx","ban","'" .. ply:Nick() .. "'",30, "Posting pornographic content")
							
						end):SetImage('icon16/stop.png')
						m:AddOption(("%s (%s)"):format("Ban", "Chat Spam"),function()
							
								RunConsoleCommand("ulx","ban","'" .. ply:Nick() .. "'",30, "Chat Spam")
							
						end):SetImage('icon16/stop.png')
						m:AddOption(("%s (%s)"):format("Ban", "Prop Spam"),function()
							
								RunConsoleCommand("ulx","ban","'" .. ply:Nick() .. "'",30, "Prop Spam")
							
						end):SetImage('icon16/stop.png')
						m:AddOption(("%s (%s)"):format("Ban", "Annoying other players"),function()
							
								RunConsoleCommand("ulx","ban","'" .. ply:Nick() .. "'",30, "Annoying other players")
						end):SetImage('icon16/stop.png')
						m:AddSpacer()
						m:AddOption(("%s (%s)"):format("Ban", "Custom Reason"),function()
							
								Derma_StringRequest(
									"Ban with custom reason",
									"Type in a custom ban reason",
									"",
									function(txt) RunConsoleCommand("ulx","ban","'" .. ply:Nick() .. "'",10,txt) end,
									function(txt) return false end
								)
						end):SetImage('icon16/stop.png')
					else
						adminmenu:AddOption("UnBan",function()
							RunConsoleCommand("ulx","unban",'_'..eid)
						end):SetImage'icon16/weather_sun.png'
					end
        a:Open()
		end
	end
	if mc==MOUSE_WHEEL_UP and LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() or LocalPlayer():GetUserGroup() == "trialmod" or LocalPlayer():GetUserGroup() == "moderator" then
	end
end

function Panel:Close()
    CloseDermaMenus()
end

function Panel:PerformLayout( intW, intH )
    self.m_pnlAvatar:SetSize( intH -22, intH -22 )
    self.m_pnlAvatar:SetPos( 1, 10 )
end
vgui.Register( "SRPScoreboard_PlayerCard", Panel, "EditablePanel" )
 
local Panel = {}
function Panel:Init()
    self.m_tblPlayersLeft = {}
    self.m_tblPlayersRight = {}
 
    self.m_pnlLeftList = vgui.Create( "SRP_ScrollPanel", self )
    self.m_pnlRightList = vgui.Create( "SRP_ScrollPanel", self )
end

local groupsSorted = {}

local number = 1
local function sortGroups(t)
    for k, v in pairs(t) do
        sortGroups(v)
        groupsSorted[k] = number
        number = number + 1
    end
end

local function GetPlayers()
    groupsSorted = {}
    sortGroups(ULib.ucl.getInheritanceTree())

    local sort = {}

    for k, v in pairs( player.GetAll() ) do
        if IsValid( v ) then
            table.insert( sort, v )
        end
    end

    // Sort that shit
    local rankSort = function( a, b )
        local arank = groupsSorted[a:GetUserGroup() or "user"] or 9
        local brank = groupsSorted[b:GetUserGroup() or "user"] or 9

        return arank < brank
    end

    table.sort( sort, rankSort )

    return sort
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
 
    local players = GetPlayers()
    local numPlayers = #players

    if self:GetWide() >= 1024 then
        for i = 1, numPlayers do
            if i - 1 < numPlayers / 2 then
                table.insert( self.m_tblPlayersLeft, self:CreatePlayerCard(players[i], self.m_pnlLeftList) )
            else
                table.insert( self.m_tblPlayersRight, self:CreatePlayerCard(players[i], self.m_pnlRightList) )
            end
        end
    else
        for i = 1, numPlayers do
            table.insert( self.m_tblPlayersLeft, self:CreatePlayerCard(players[i], self.m_pnlLeftList) )
        end
    end

    --[[for i = 1, numPlayers/2 do
        if self:GetWide() >= 1024 and i % 2 == 0 then
            table.insert( self.m_tblPlayersRight, self:CreatePlayerCard(players[i], self.m_pnlRightList) )
        else
            table.insert( self.m_tblPlayersLeft, self:CreatePlayerCard(players[i], self.m_pnlLeftList) )
        end
    end]]
   
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
        [21] = 0,
    }

    for k, v in pairs( player.GetAll() ) do
        if not GAMEMODE.Jobs:GetPlayerJobID( v ) then continue end
        local id = GAMEMODE.Jobs:GetPlayerJobID( v )
        if not ret[id] then continue end
        ret[id] = ret[id] +1
    end

    return ret
end

function Panel:GetJobCounts2()
    local ret = {
        [6] = 0,
        [9] = 0,
        [10] = 0,
        [7] = 0,
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
	surface.DrawTexturedRect( 0, 0, intW, 500 )

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
    -- GGS
    local y = 77
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
    
    local y2 = 77
    for k2, v2 in pairs( self:GetJobCounts2() ) do
        draw.SimpleText(
            GAMEMODE.Jobs:GetJobByID( k2 ).Name.. ": ".. v2,
            "Scoreboard_Trebuchet18",
            intW -120,
            y2,
            Color(255, 255, 255, 255),
            TEXT_ALIGN_RIGHT
        )

        y2 = y2 +18
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
            v:DockMargin( 5, 0, 5, -18 )
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
            v:DockMargin( 5, 0, 5, -18 )
            v:Dock( TOP )
        end
 
        for k, v in pairs( self.m_tblPlayersRight ) do
            v:SetTall( 48 )
            v:DockMargin( 5, 0, 5, -18 )
            v:Dock( TOP )
        end
    end
end

function Panel:Close()
    CloseDermaMenus()
end
vgui.Register( "SRPScoreboard", Panel, "SRP_FramePanel" )