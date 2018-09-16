--[[
	Name: chop_shop.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Chop Shop"
NPCMeta.UID = "chop_shop"
NPCMeta.SubText = "Chop a stolen car for money here"
NPCMeta.Model = "models/gman_high.mdl"

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "chop_shop" )
end

function NPCMeta:ChopCar( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	
	local code = GAMEMODE.ChopShop:PlayerChopCar( pPlayer )
	if code == 3 then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "chop_shop_begin" )
	elseif code == 2 then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "chop_shop_error" )
	elseif code == 1 then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "chop_shop_mycar" )
	elseif code == 0 then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "chop_shop_nocar" )
	end
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "chop_shop_chop_car", self.ChopCar, self )
	end
elseif CLIENT then
	NPCMeta.RandomGreetings = {
		"What do you want?",
		"You better start bringing me nice cars!",
		"You weren't followed right?!",
	}

	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "chop_shop", self.StartDialog, self )
		GM.Dialog:RegisterDialog( "chop_shop_begin", self.StartDialog_Begin, self )
		GM.Dialog:RegisterDialog( "chop_shop_error", self.StartDialog_GoAway, self )
		GM.Dialog:RegisterDialog( "chop_shop_nocar", self.StartDialog_NoCar, self )
		GM.Dialog:RegisterDialog( "chop_shop_mycar", self.StartDialog_OwnedCar, self )
	end
	
	function NPCMeta:StartDialog()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( table.Random(self.RandomGreetings) )

		GAMEMODE.Dialog:AddOption( "I brought this car for you to chop up!", function()
			GAMEMODE.Net:SendNPCDialogEvent( "chop_shop_chop_car" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_Begin()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "Excellent, I can shred this car in no time!" )

		GAMEMODE.Dialog:AddOption( "Great!", function()
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_GoAway()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "I'm busy right now, come back later!" )

		GAMEMODE.Dialog:AddOption( "Alright then.", function()
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_NoCar()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "What car? Drive one here then we can talk." )

		GAMEMODE.Dialog:AddOption( "Alright then.", function()
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_OwnedCar()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "You want me to chop your own car?" )

		GAMEMODE.Dialog:AddOption( "I guess not...", function()
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )