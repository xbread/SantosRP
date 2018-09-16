--[[
	Name: bank_storage.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Bank Storage"
NPCMeta.UID = "bank_storage"
NPCMeta.SubText = "Store items here"
NPCMeta.Model = "models/breen.mdl"
NPCMeta.Sounds = {
	StartDialog = {
		"vo/citadel/br_nothingtosay_a.wav",
		"vo/citadel/br_gravgun.wav",
		"vo/citadel/br_gift_a.wav",
		"vo/k_lab/br_tele_02.wav",
	},
	EndDialog = {
		"vo/citadel/br_newleader_a.wav",
		"vo/citadel/br_rabble_a.wav",
	}
}

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "bank_storage" )

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

function NPCMeta:ShowBankMenu( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	GAMEMODE.Net:ShowNWMenu( pPlayer, "bank_storage_menu" )
end

function NPCMeta:ShowLostAndFoundMenu( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	GAMEMODE.Net:ShowNWMenu( pPlayer, "lost_and_found_menu" )
end

function NPCMeta:ShowBillsMenu( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	GAMEMODE.Net:ShowNWMenu( pPlayer, "bills_menu" )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "bank_open_menu", self.ShowBankMenu, self )
		GM.Dialog:RegisterDialogEvent( "bank_open_lostandfound_menu", self.ShowLostAndFoundMenu, self )
		GM.Dialog:RegisterDialogEvent( "bank_open_bills_menu", self.ShowBillsMenu, self )
	end
elseif CLIENT then
	NPCMeta.RandomGreetings = {
		"Here to retrieve an item?",
		"Making an item deposit?",
		"Can I help you with anything today?",
		"We have the best safety deposit boxes around!",
	}

	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "bank_storage", self.StartDialog, self )
	end
	
	function NPCMeta:StartDialog()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( table.Random(self.RandomGreetings) )

		GAMEMODE.Dialog:AddOption( "I would like to view my item storage.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "bank_open_menu" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "I would like to claim my items in lost and found.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "bank_open_lostandfound_menu" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "I'm here to pay my bills.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "bank_open_bills_menu" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )