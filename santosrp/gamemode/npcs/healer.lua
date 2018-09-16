--[[
	Name: healer.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Doctor"
NPCMeta.UID = "healer"
NPCMeta.SubText = "Heal your ailments here"
NPCMeta.Model = "models/Kleiner.mdl"
NPCMeta.HealCost = GM.Config.NPCHealerCost
NPCMeta.Sounds = {
	StartDialog = {
		"vo/k_lab/kl_ohdear.wav",
		"vo/k_lab2/kl_greatscott.wav",
		"vo/trainyard/kl_morewarn03.wav",
	},
	EndDialog = {
		"vo/k_lab/kl_bonvoyage.wav",
		"vo/trainyard/kl_whatisit02.wav",
	}
}

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	if GAMEMODE.Jobs:GetNumPlayers( JOB_EMS ) >= GAMEMODE.Config.MinEMSToDisable then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "healer_cantheal" )
	else
		if pPlayer:Health() >= 100 and not GAMEMODE.PlayerDamage:PlayerHasDamagedLimbs( pPlayer ) then
			GAMEMODE.Net:ShowNPCDialog( pPlayer, "healer_fullhealth" )
		else
			GAMEMODE.Net:ShowNPCDialog( pPlayer, "healer" )
		end
	end

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

function NPCMeta:OnPlayerRequestHeal( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if pPlayer:Health() >= 100 and not GAMEMODE.PlayerDamage:PlayerHasDamagedLimbs( pPlayer ) then return end
	
	if GAMEMODE.Jobs:GetNumPlayers( JOB_EMS ) >= GAMEMODE.Config.MinEMSToDisable then
		return
	end

	if pPlayer:CanAfford( self.HealCost ) then
		pPlayer:SetHealth( pPlayer:GetMaxHealth() )
		pPlayer:AddNote( "Any ailments you had have been healed!" )
		pPlayer:TakeMoney( self.HealCost )
		pPlayer:EmitSound( "items/medshot4.wav" )
		GAMEMODE.PlayerDamage:HealPlayerLimbs( pPlayer )
	else
		pPlayer:AddNote( "You can't afford that!" )
	end
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "heal_me", self.OnPlayerRequestHeal, self )
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "healer", self.StartDialog, self )
		GM.Dialog:RegisterDialog( "healer_cantheal", self.StartDialog_CantHeal, self )
		GM.Dialog:RegisterDialog( "healer_fullhealth", self.StartDialog_FullHealth, self )
	end
	
	function NPCMeta:StartDialog()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I need medical assistance.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "heal_me" )
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_CantHeal()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "Can't you get help from one of the paramedics?" )

		GAMEMODE.Dialog:AddOption( "I guess...", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_FullHealth()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "Sorry, I can't find anything wrong with you." )

		GAMEMODE.Dialog:AddOption( "Oh, Alright then...", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )