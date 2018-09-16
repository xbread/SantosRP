--[[
	Name: clothing_clerk.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Store Clerk"
NPCMeta.UID = "clothing_clerk"
NPCMeta.SubText = "Purchase new clothing here"
NPCMeta.Model = "models/Humans/Group02/Female_07.mdl"
NPCMeta.Sounds = {
	StartDialog = {
		"vo/npc/female01/hi01.wav",
		"vo/npc/female01/hi02.wav",
		"vo/npc/female01/gordead_ques16.wav",
		"vo/npc/female01/answer30.wav",
	},
	EndDialog = {
		"vo/npc/female01/answer01.wav",
		"vo/npc/female01/answer32.wav",
		"vo/npc/female01/question03.wav",
		"vo/npc/female01/answer03.wav",
	}
}

function NPCMeta:Initialize()
	NPCMeta.ItemsCanBuy = {}

	for k, v in pairs( GAMEMODE.Inv:GetItems() ) do
		if not v.ClothingMenuPrice then continue end
		NPCMeta.ItemsCanBuy[k] = math.ceil( v.ClothingMenuPrice *0.66 )
	end
end

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "clothing_clerk" )

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

function NPCMeta:ShowClothingMenu( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	GAMEMODE.Net:ShowNWMenu( pPlayer, "clothing_shop_menu" )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "clothing_clerk_openmenu", self.ShowClothingMenu, self )
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "clothing_clerk", self.StartDialog, self )
	end
	
	function NPCMeta:StartDialog()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I would like to buy some new clothing.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "clothing_clerk_openmenu" )
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