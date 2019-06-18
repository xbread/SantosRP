----------------------------------------------
-----------JChat by JohnnyThunders------------ 
----------------------------------------------

if JChat then return end
JChat = JChat or {} --Let's prevent any breaking.
--Various data 

if SERVER then
	local meta = FindMetaTable("Player")
	local oldprintmessage = meta.PrintMessage
	function meta:PrintMessage(enum, text)
		if enum == HUD_PRINTTALK then
			--print(text)
			umsg.Start("JChat.SendChatPrint")
			umsg.Bool(true)
			umsg.End()
		end
		oldprintmessage(self, tonumber(enum), tostring(text))
	end
	local oldchatprint = meta.ChatPrint
	function meta:ChatPrint(text)
		self:PrintMessage(HUD_PRINTTALK,text)
	end	
	CreateConVar("jchat_useicons", 0, FCVAR_ARCHIVE)
	cvars.AddChangeCallback("jchat_useicons", function(cvar, old, new)
		umsg.Start("JChat.UseIcons")
		umsg.Bool(tobool(new))
		umsg.End()
	end)
else

local meta = FindMetaTable("Player")
local oldprintmessage = meta.PrintMessage
function meta:PrintMessage(enum, text)
	if enum == HUD_PRINTTALK then
		--print(text)
		JChat.SentChatPrintLine = true
	end
	oldprintmessage(self, enum, text)
end
local oldchatprint = meta.ChatPrint
function meta:ChatPrint(text)
	self:PrintMessage(HUD_PRINTTALK,text)
end	

JChat.ScrollSpeed = 3.52
JChat.ChatFont = CreateClientConVar("jchat_chatfont", "ChatFont"):GetString()
JChat.UseIcons = true
usermessage.Hook("JChat.UseIcons", function(um)
	JChat.UseIcons = um:ReadBool()
end)

do
	surface.SetFont(JChat.ChatFont)
	local w, h = surface.GetTextSize("0")
	JChat.LineSpacing = h + 2
end

JChat.SentChatPrintLine = false
JChat.MaxLines = CreateClientConVar("jchat_maxlines", 10):GetInt()
JChat.FadeTime = CreateClientConVar("jchat_fadetime", 0.35):GetFloat()

cvars.AddChangeCallback("jchat_fadetime", function(cvar, old, new)
	JChat.FadeTime = new
end)

cvars.AddChangeCallback("jchat_chatfont", function(cvar, old, new)
	JChat.ChatFont = new
	surface.SetFont(new)
	local _, h = surface.GetTextSize("O")
	JChat.LineSpacing = h + 2
	RunConsoleCommand("jchat_maxlines", GetConVar("jchat_maxlines"):GetInt())
end)

cvars.AddChangeCallback("jchat_maxlines", function(cvar, old, new)
	JChat.MaxLines = new
	if JChat.FakePanel and JChat.ChatBox then
		local x, y = JChat.ChatBox:GetPos()
		local fx, fy = JChat.FakePanel:GetPos()
		JChat.ChatBox:SetPos(x, y - (new - old) * JChat.LineSpacing)
		JChat.ChatBox:SetSize(520, JChat.MaxLines * JChat.LineSpacing)
		JChat.FakePanel:SetPos(fx, fy - (new - old) * JChat.LineSpacing)
		JChat.ChatBox.TextEntry:SetPos(10, JChat.ChatBox:GetTall() + 15)
	end
end)

JChat.ChatColors = {
	-- [":red:"] = Color(255, 0, 0),
	-- [":green:"] = Color(0, 255, 0),
	-- [":blue:"] = Color(0, 0, 255),
	-- [":yellow:"] = Color(255, 255, 0),
	-- [":black:"]= Color(0, 0, 0),
	-- [":white:"] = Color(255, 255, 255),
	-- [":grey:"] = Color(115, 115, 115),
	-- [":gray:"] = Color(115, 115, 115), -- for the american spelling
	-- [":lightblue:"] = Color(152, 245, 255),
	-- [":aqua:"] = Color(127, 255, 212),
	-- [":orange:"] = Color(205, 127, 50),
	-- [":purple:"] = Color(127, 0, 255),
	-- [":lightgreen:"] = Color(202, 255, 112),
	-- [":pink:"] = Color(255, 20, 147),
	-- [":darkred:"] = Color(139, 26, 26)
}
JChat.SentChatPrintLine = false

if !JChat.OldChatAddText then JChat.OldChatAddText = chat.AddText end

JChat.ChatboxPanel = JChat.ChatboxPanel or {} --Initialize our panel data

local function IsColor(color)
	return (type(color) == "table" and color.r and color.g and color.b)
end

function JChat.GetLastColor(linedata)
	local color = color_white
	for k, v in pairs(linedata.textdata) do
		if IsColor(v) then
			color = v
		end
	end
	return color
end

function JChat.WrapString(linedata, maxwidth)
	surface.SetFont(JChat.ChatFont)
	local linewidth = 0
	local packedlines = {}
	local linenumber = 1
	table.insert(packedlines, {icon = linedata.icon, textdata = {}})
	for k, v in pairs(linedata.textdata) do
		if type(v) == "string" then
			local w, h = surface.GetTextSize(v)
			linewidth = linewidth + w
			if linewidth + ((linedata.icon and #packedlines == 1) and 22 or 0) >= maxwidth then
				local w, h = surface.GetTextSize(v)
				linewidth = w
				linenumber = linenumber + 1
				table.insert(packedlines, {textdata = {JChat.GetLastColor(packedlines[linenumber-1])}})
			end	
		end
		if IsColor(v) then
			table.insert(packedlines[linenumber].textdata, v)
		end
		if type(v) == "string" then
			table.insert(packedlines[linenumber].textdata, v)
		end
	end
	return packedlines		
end

function JChat.ChatboxPanel:Init()
	self.ChatLines = {}
	self.ScrollY = 0
	//self:SetHighlightColor(Color(200,0,0,180))
end

local a = 255

function JChat.ChatboxPanel:DrawLine(num, data)
	surface.SetFont(JChat.ChatFont)
	local linewidth = 0
	local num = num - 1
	local w, h = 0, 0
	h = h + JChat.LineSpacing * num
	
	data.alpha = math.Approach(data.alpha, 0, (self.TextEntry:IsVisible() and 0 or JChat.FadeTime))
	for _, elem in pairs(data.textdata) do
		if type(elem) == "table" and elem.r and elem.g and elem.b then
			surface.SetTextColor(Color(elem.r, elem.g, elem.b, (self.TextEntry:IsVisible() and 255 or data.alpha)))
		end
		if type(elem) == "string" then
			w, _ = surface.GetTextSize(elem)
			surface.SetTextPos((data.icon and 22 or 2) + linewidth, h + self.ScrollY * -1)
			surface.DrawText(elem)
			linewidth = linewidth + w
		end
			
	end --But our team of scientific trained ninja monkeys is working on this aspect
	if data.icon then
		if not self.MAT_LIST then self.MAT_LIST = {} end
		if not self.MAT_LIST[data.icon] then
			self.MAT_LIST[data.icon] = Material(data.icon)
		end

		surface.SetDrawColor(Color(255, 255, 255, (self.TextEntry:IsVisible() and 255 or data.alpha)))
		surface.SetMaterial( self.MAT_LIST[data.icon] )
		surface.DrawTexturedRect(2, h + self.ScrollY * -1, JChat.LineSpacing - 2, JChat.LineSpacing - 2)                                                       
	end                                                                                                                
	surface.SetTextColor(color_white) --Reset the color                                                                 
end                                                                                                                     

function JChat.ChatboxPanel:AddLine(linedata)
	if !JChat.UseIcons then
		linedata.icon = nil
	end
	--linedata struct = {icon(optional), textdata(same format as chat.AddText), printedon = RealTime()}			        
	local wrapped = JChat.WrapString(linedata, self:GetWide())
	for k,v in pairs(wrapped) do                                                                                        
		v.alpha = 255
		table.insert(self.ChatLines, v)                                                                                 
	end
	if #self.ChatLines >= math.ceil(self:GetTall() / JChat.LineSpacing) then
		self.ScrollY = (#self.ChatLines - math.ceil(self:GetTall() / JChat.LineSpacing)) * JChat.LineSpacing
	end
	for k, v in pairs(self.ChatLines) do
		if k ~= #self.ChatLines then
			v.shouldfade = true
		end
	end
end

function JChat.ChatboxPanel:Paint()
	if self.TextEntry then
		surface.SetDrawColor(Color(50, 50, 50, (self.TextEntry:IsVisible() and 150 or 0))) --Darkish transparent grey
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		for k, v in ipairs(self.ChatLines) do
			self:DrawLine(k, v)
		end
	end
end

vgui.Register("JChat.ChatBoxPanel", JChat.ChatboxPanel, "EditablePanel")

timer.Simple(0, function()
	JChat.ChatBox = vgui.Create("JChat.ChatBoxPanel")
	JChat.ChatBox:SetSize(520, JChat.MaxLines * JChat.LineSpacing)
	JChat.ChatBox:SetPos(20, ScrH() * 0.75 - JChat.ChatBox:GetTall())
	JChat.ChatBox:SetVisible(true)

	JChat.FakePanel = vgui.Create("EditablePanel")
	JChat.FakePanel:SetPos(10, ScrH() * 0.75 - JChat.ChatBox:GetTall())
	JChat.FakePanel:SetSize(800, ScrH())
	JChat.FakePanel:SetVisible(true)
	JChat.FakePanel.Paint = function() end
	JChat.FakePanel.OnMouseWheeled = function(self, dir)
		if JChat.ChatBox then
			local maxlines = math.ceil(JChat.ChatBox:GetTall() / JChat.LineSpacing)
			if #JChat.ChatBox.ChatLines >= maxlines then
				JChat.ChatBox.ScrollY = math.Clamp(JChat.ChatBox.ScrollY + (dir * -1) * JChat.LineSpacing, 0, (#JChat.ChatBox.ChatLines - maxlines) * JChat.LineSpacing)
				-- print(JChat.ChatBox.ScrollY)
			end
		end
	end

	local chatx, chaty = JChat.ChatBox:GetPos()
	JChat.ChatBox.TextEntry = vgui.Create("DTextEntry", JChat.FakePanel)
	JChat.ChatBox.TextEntry:SetParent(JChat.FakePanel)
	JChat.ChatBox.TextEntry:SetPos(10, JChat.MaxLines * JChat.LineSpacing + 15)
	JChat.ChatBox.TextEntry:SetSize(JChat.ChatBox:GetWide(), 20)
	JChat.ChatBox.TextEntry:SetAllowNonAsciiCharacters(true)
	JChat.ChatBox.TextEntry:SetTextInset(0, 0)
	JChat.ChatBox.TextEntry:SetVisible(false)
	JChat.ChatBox.TextEntry.IsTeamChat = false
	JChat.ChatBox.TextEntry.OnMouseWheeled = function(self, dir)
		local maxlines = math.ceil(JChat.ChatBox:GetTall() / JChat.LineSpacing)
		if #JChat.ChatBox.ChatLines >= maxlines then
			JChat.ChatBox.ScrollY = math.Clamp(JChat.ChatBox.ScrollY + (dir * -1) * JChat.LineSpacing, 0, (#JChat.ChatBox.ChatLines - maxlines) * JChat.LineSpacing)
			-- print(JChat.ChatBox.ScrollY)
		end
	end
	JChat.ChatBox.TextEntry.OnKeyCodeTyped = function(self, key)
		if key == KEY_ESCAPE then
			JChat.ChatBox.TextEntry:SetVisible(false)
			JChat.FakePanel:SetVisible(false)
			self:SetText("")
			timer.Simple(0, function()
				RunConsoleCommand("cancelselect")
			end)
		end
		if key == KEY_ENTER then
			if self:GetText():Trim() ~= "" then
				RunConsoleCommand((self.IsTeamChat and "say_team" or "say"), self:GetText():Trim())
				JChat.ChatBox.TextEntry.IsTeamChat = false
			end
			self:SetText("")
			timer.Simple(0.001, function()
			JChat.ChatBox.TextEntry:SetVisible(false)
			JChat.FakePanel:SetVisible(false)
			JChat.ChatBox.TextEntry:KillFocus()
			end)
		end
	end
	JChat.ChatBox.TextEntry.Paint = function(self)
			surface.SetDrawColor(color_black)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			surface.SetDrawColor(color_white)
			surface.DrawRect(1, 1, self:GetWide() - 2, self:GetTall() - 2)
			self:DrawTextEntryText(Color(0, 0, 0), Color(255, 255, 255), Color(0, 0, 0))
	end
	JChat.ChatBox.TextEntry.OnEnter = function(self)
		if self:GetText():Trim() ~= "" then
			RunConsoleCommand((self.IsTeamChat and "say_team" or "say"), self:GetText():Trim())
			JChat.ChatBox.TextEntry.IsTeamChat = false
		end
		self:SetText("")
		timer.Simple(0.001, function()
		JChat.ChatBox.TextEntry:SetVisible(false)
		JChat.FakePanel:SetVisible(false)
		JChat.ChatBox.TextEntry:KillFocus()
		end)
	end
	JChat.ChatBox.TextEntry.OnTextChanged = function(self)
		hook.Call("ChatTextChanged", GAMEMODE, self:GetText():Trim())
	end
	end)

	JChat.isplayerchat = false

	function chat.AddText(...)
		local pargs = {...}
		local colorsparsed = false
		timer.Simple(0, function()
			local ind = 1
			local args = {}
			for k, v in pairs(pargs) do
				if IsColor(v) then
					local fixedcolor = Color(v.r, v.g, v.b, 255)
					table.insert(args, fixedcolor)
				end
				if type(v) == "Player" and IsValid(v) then
					JChat.isplayerchat = true
					--print( v:getJobInt(), JOB_POLICE, v:GetNWBool( "undercov" ) )
					--if v:getJobInt() == JOB_POLICE and v:GetNWBool( "undercov" ) then
					--	table.insert(args, team.GetColor(JOB_CIVILIAN))
					--else
						table.insert(args, team.GetColor(v:Team()))
					--end
					
					table.insert(args, v:Nick())
				end
				if type(v) == "string" then
					for s in string.gmatch(v, "%s?[(%S)]+[^.]?") do --HEIL MEIN PATTERN
					local start = 0 --credit to Divran
						for startpos, center, endpos in string.gmatch(s, "()(%b::)()" ) do
							--print(startpos, center, endpos)
							if JChat.ChatColors[center] then
								colorsparsed = true
								table.insert(args, string.sub(s, start, startpos - 1))
								table.insert(args, JChat.ChatColors[center])
								start = endpos
							end
						end
						if colorsparsed then
							table.insert(args, string.sub(s, start))
							s = ""
						end
						surface.SetFont(JChat.ChatFont)
						local w, _ = surface.GetTextSize(s)
						local singlew, _ = surface.GetTextSize("O")
						if w >= JChat.ChatBox:GetWide() then
							local lastchar = 0
							local maxchars = JChat.ChatBox:GetWide() / singlew
							for i = 0, math.ceil(w / JChat.ChatBox:GetWide()) do
								local cutstr = string.sub(s, lastchar + 1, lastchar + maxchars)
								table.insert(args, cutstr)
								lastchar = lastchar + string.len(cutstr)
							end
						else
							table.insert(args, s)
						end
					end
				end
			end
			JChat.ChatBox:AddLine({icon = JChat.PlayerChatIcon, textdata = args})
			JChat.OldChatAddText(unpack(pargs))
			JChat.PlayerChatIcon = nil
		end)
	end

	usermessage.Hook("JChat.SendChatPrint", function(um)
		JChat.SentChatPrintLine = um:ReadBool()
	end)

	hook.Add("OnPlayerChat", "JCAHR", function(ply)
		if IsValid(ply) then
			if ply:IsSuperAdmin() then
				JChat.PlayerChatIcon = "icon16/star.png"
				return
			end
			if ply:IsAdmin() then
				JChat.PlayerChatIcon = "icon16/shield.png"
				return
			end
		else
			JChat.PlayerChatIcon = "icon16/application_xp_terminal.png"
			return
		end
		JChat.PlayerChatIcon = "icon16/user.png"
	end)

	hook.Add("ChatText","mein_chat", function(index, nick, text, messagetype)
		--:?[^(:.-:)]+:?
		timer.Simple(0, function()
			if JChat.ChatBox and nick ~= text then
				local args = {}
				if JChat.SentChatPrintLine then
					args = {}
					table.insert(args, Color(151, 211, 255))
					for s in string.gmatch(text, "%s?[(%S)]+[^.]?") do --HEIL PATTERN
						table.insert(args, s)
					end
					JChat.ChatBox:AddLine({icon = "icon16/world.png", textdata = args})
					JChat.SentChatPrintLine = false
					return
				end
				if messagetype == "joinleave" then
					args = {}
					local color = color_white
					for leavestr in string.gmatch(text, "%S+") do
						if leavestr == "joined" then
							color = Color(161, 255, 161)
						end
						if leavestr == "left" then
							color = Color(200, 0, 10)
						end
					end
					table.insert(args, color)
					for s in string.gmatch(text, "%s?[(%S)]+[^.]?") do --HEIL PATTERN
						table.insert(args, s)
					end
					JChat.ChatBox:AddLine({icon = "icon16/world.png", textdata = args})
					return 
				end
				if messagetype == "none" then
					args = {}
					for s in string.gmatch(text, "%S+") do
						if s == "cvar" then
							table.insert(args, Color(255, 225, 0))
						end
					end
					for s in string.gmatch(text, "%s?[(%S)]+[^.]?") do
						table.insert(args, s)
					end
				JChat.ChatBox:AddLine({icon = "icon16/world.png", textdata = args})
				end
			end
		end)
	end)

	hook.Add("StartChat", "JChat.HideChat", function() return true end)

	local OpenChat = function(pl, bind, pressed)
		if(pressed and string.find(bind, "messagemode")) then
			if string.find(bind, "messagemode2") then
				JChat.ChatBox.TextEntry.IsTeamChat = true
			end
			JChat.ChatBox:SetVisible(true)
			JChat.ChatBox.TextEntry:SetVisible(true)
			JChat.FakePanel:SetVisible(true)
			JChat.FakePanel:MakePopup()
			JChat.ChatBox.TextEntry:RequestFocus()
			return true 
		end
	end
	hook.Add("PlayerBindPress", "JChat.PlayerBindPress", OpenChat)


	hook.Add("HUDShouldDraw", "JChat.HUDShouldDraw", function(elem)
		if elem == "CHudChat" then
			return false
		end
	end)
end
