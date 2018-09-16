--[[
	Name: car_dealer.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Car Dealer"
NPCMeta.UID = "car_dealer"
NPCMeta.SubText = "Purchase a vehicle here"
NPCMeta.Model = "models/alyx.mdl"
NPCMeta.Sounds = {
	StartDialog = {
		"vo/eli_lab/al_thyristor02.wav",
		"vo/novaprospekt/al_gladtoseeyoureok.wav",
	},
	EndDialog = {
		"vo/eli_lab/al_allright01.wav",
		"vo/novaprospekt/al_careofyourself.wav",
	}
}

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "car_dealer" )

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

function NPCMeta:ShowBuyCarMenu( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	GAMEMODE.Net:ShowNWMenu( pPlayer, "car_buy" )
end

function NPCMeta:ShowSellCarMenu( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	GAMEMODE.Net:ShowNWMenu( pPlayer, "car_sell" )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "car_dealer_buy", self.ShowBuyCarMenu, self )
		GM.Dialog:RegisterDialogEvent( "car_dealer_sell", self.ShowSellCarMenu, self )
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "car_dealer", self.StartDialog, self )
	end
	
	function NPCMeta:StartDialog()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I would like to buy a car.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "car_dealer_buy" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "I would like to sell my car.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "car_dealer_sell" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )