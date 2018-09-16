--[[
	Name: vape_clerk.lua
	For: Cosmic Gaming
	By: Cheese
]]--


local NPCMeta = {}
NPCMeta.Name = "Vapes Clerk"
NPCMeta.UID = "vape_clerk"
NPCMeta.SubText = "Purchase items here"
NPCMeta.Model = "models/Humans/Group02/Male_04.mdl"

NPCMeta.Sounds = {
	StartDialog = {
		"vo/npc/male01/answer30.wav",
		"vo/npc/male01/gordead_ans01.wav",
		"vo/npc/male01/gordead_ques16.wav",
		"vo/npc/male01/hi01.wav",
		"vo/npc/male01/hi02.wav",
	},
	EndDialog = {
		"vo/npc/male01/finally.wav",
		"vo/npc/male01/pardonme01.wav",
		"vo/npc/male01/vanswer01.wav",
		"vo/npc/male01/vanswer13.wav",
	}
}

--[itemID] = priceToBuy,

NPCMeta.ItemsForSale = {

	--vapes

	["American Vape"] = 200,
	["Custom Vape"] = 400,
	["Hallucinogenic Vape"] = 100,
	["Flavored Vape"] = 300,
	["Mega Vape"] = 10000000,
}

--[itemID] = priceToSell,

NPCMeta.ItemsCanBuy = {
	["American Vape"] = 150,
	["Custom Vape"] = 300,
	["Hallucinogenic Vape"] = 75,
	["Flavored Vape"] = 225,
	["Mega Vape"] = 500000,
}

for k, v in pairs( NPCMeta.ItemsForSale ) do
	NPCMeta.ItemsCanBuy[k] = math.ceil( v *0.66 )
end

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "vape_clerk" )
	if (entNPC.m_intLastSoundTime or 0) < CurTime() then
		local snd, _ = table.Random( self.Sounds.StartDialog )
		entNPC:EmitSound( snd, 60 )
		entNPC.m_intLastSoundTime = CurTime() +2
	end
end

function NPCMeta:OnPlayerEndDialog( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if (pPlayer.m_entTalkingNPC.m_intLastSoundTime or 0) < CurTime() then
		local snd, _ = table.Random( self.Sounds.EndDialog )
		pPlayer.m_entTalkingNPC:EmitSound( snd, 60 )
		pPlayer.m_entTalkingNPC.m_intLastSoundTime = CurTime() +2
	end
	pPlayer.m_entTalkingNPC = nil
end

if SERVER then

	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.

	function NPCMeta:RegisterDialogEvents()
	end
	
elseif CLIENT then

	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "vape_clerk", self.StartDialog, self )
	end

	function NPCMeta:StartDialog()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "You gonna buy something pal?" )

		GAMEMODE.Dialog:AddOption( "Show me what you have for sale.", function()
			GAMEMODE.Gui:ShowNPCShopMenu( self.UID )
			GAMEMODE.Dialog:HideDialog()
		end )
		
		GAMEMODE.Dialog:AddOption( "I would like to return some items.", function()
			GAMEMODE.Gui:ShowNPCSellMenu( self.UID )
			GAMEMODE.Dialog:HideDialog()
		end )
		
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )