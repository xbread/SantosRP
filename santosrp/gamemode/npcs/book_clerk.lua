--[[
	Name: book_clerk.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Book Clerk"
NPCMeta.UID = "book_clerk"
NPCMeta.SubText = "Purchase books here"
NPCMeta.Model = "models/mossman.mdl"
NPCMeta.Sounds = {
	StartDialog = {
		"vo/eli_lab/mo_airlock03.wav",
	},
	EndDialog = {
		"vo/eli_lab/mo_anyway04.wav",
		"vo/eli_lab/mo_gowithalyx02.wav",
	}
}
--[itemID] = priceToBuy,
NPCMeta.ItemsForSale = {
	--Gun smithing books
	["Skill Book: Gun Smithing 2"] = 1000,
	["Skill Book: Gun Smithing 3"] = 2000,
	["Skill Book: Gun Smithing 4"] = 3000,
	["Skill Book: Gun Smithing 5"] = 4500,
	["Skill Book: Gun Smithing 6"] = 5500,
	["Skill Book: Gun Smithing 7"] = 6500,
	["Skill Book: Gun Smithing 8"] = 7500,
	["Skill Book: Gun Smithing 9"] = 8500,
	["Skill Book: Gun Smithing 10"] = 9500,

	--Crafting books
	["Skill Book: Crafting 2"] = 150,
	["Skill Book: Crafting 3"] = 300,
	["Skill Book: Crafting 4"] = 500,
	["Skill Book: Crafting 5"] = 600,
	["Skill Book: Crafting 6"] = 700,
	["Skill Book: Crafting 7"] = 800,
	["Skill Book: Crafting 8"] = 900,
	["Skill Book: Crafting 9"] = 1000,
	["Skill Book: Crafting 10"] = 1200,

	--Assembly books
	["Skill Book: Assembly 2"] = 1500,
	["Skill Book: Assembly 3"] = 3000,
	["Skill Book: Assembly 4"] = 4000,
	["Skill Book: Assembly 5"] = 5500,
	["Skill Book: Assembly 6"] = 6500,
	["Skill Book: Assembly 7"] = 7000,
	["Skill Book: Assembly 8"] = 9000,
	["Skill Book: Assembly 9"] = 9500,
	["Skill Book: Assembly 10"] = 10000,
}
--[itemID] = priceToSell,
NPCMeta.ItemsCanBuy = {}
for k, v in pairs( NPCMeta.ItemsForSale ) do
	NPCMeta.ItemsCanBuy[k] = math.ceil( v *0.66 )
end

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "book_clerk" )
	
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
		GM.Dialog:RegisterDialog( "book_clerk", self.StartDialog, self )
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