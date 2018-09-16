--[[

	Name: gas_clerk.lua

	For: TalosLife

	By: TalosLife

]]--



local NPCMeta = {}

NPCMeta.Name = "Store Clerk"

NPCMeta.UID = "gas_clerk"

NPCMeta.SubText = "Purchase items here"

NPCMeta.Model = "models/Humans/Group02/Female_02.mdl"

NPCMeta.Sounds = {

	StartDialog = {

		"vo/npc/female01/hi01.wav",

		"vo/npc/female01/hi02.wav",

		"vo/npc/female01/gordead_ques16.wav",

		"vo/npc/female01/answer30.wav",

	},

	EndDialog = {

		"vo/npc/female01/pardonme01.wav",

		"vo/npc/female01/pardonme02.wav",

		"vo/npc/female01/answer15.wav",

		"vo/npc/female01/excuseme02.wav",

		"vo/npc/female01/excuseme01.wav",

	}

}

--[itemID] = priceToBuy,

NPCMeta.ItemsForSale = {

	["Fuel Can"] = 7,
	["Cigarettes"] = 8,
	["Cigar Box"] = 5,
	
--food
	["Fritos - Original"] = 6,
	["Doritos - Nacho Cheese"] = 6,
	["Fritos - BBQ"] = 7,
	["Fritos - BBQ Hoops"] = 7,
	["Lays - Classic"] = 6,
	["Lays - Salt & Vinegar"] = 6,
	["Lays - Barbecue"] = 6,
	["Lays - Sour Cream & Onion"] = 7,
	["Lays - Dill Pickle"] = 7,
	["Lays - Flamin' Hot"] = 7,
--drink
	["Filtered Water"] = 6,
	["Jo Jo's Cola"] = 13,
	["Sprunk Cola"] = 13,
	["Orange Juice"] = 10,
	["Milk"] = 12,
	["Beer"] = 4,
}

--[itemID] = priceToSell,

NPCMeta.ItemsCanBuy = {}

for k, v in pairs( NPCMeta.ItemsForSale ) do

	NPCMeta.ItemsCanBuy[k] = math.ceil( v *0.66 )

end

--[itemID] = priceToSell,

NPCMeta.ItemsCanBuy = {}

for k, v in pairs( NPCMeta.ItemsForSale ) do

	NPCMeta.ItemsCanBuy[k] = math.ceil( v *0.66 )

end



function NPCMeta:OnPlayerTalk( entNPC, pPlayer )

	GAMEMODE.Net:ShowNPCDialog( pPlayer, "gas_clerk" )

	

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

		GM.Dialog:RegisterDialog( "gas_clerk", self.StartDialog, self )

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

		GAMEMODE.Dialog:AddOption( "Hands Up, Head Down!", function()

			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )

			GAMEMODE.Dialog:HideDialog()

		end )

		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()

			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )

			GAMEMODE.Dialog:HideDialog()

		end )

	end

end



GM.NPC:Register( NPCMeta )