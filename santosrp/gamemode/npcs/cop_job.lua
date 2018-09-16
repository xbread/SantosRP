--[[
	Name: cop_job.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Police Chief"
NPCMeta.UID = "cop_job"
NPCMeta.SubText = "Become a police officer here"
NPCMeta.Model = "models/player/santos/cop/male_01.mdl"
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
	},
	JobQuit = {
		"vo/npc/male01/answer02.wav",
		"vo/npc/male01/answer03.wav",
		"vo/npc/male01/answer04.wav",
		"vo/npc/male01/answer24.wav",
		"vo/npc/male01/heretohelp01.wav",
		"vo/npc/male01/heretohelp02.wav",
		"vo/npc/male01/notthemanithought02.wav",
		"vo/npc/male01/notthemanithought01.wav",
	},
	JobJoin = {
		"vo/npc/male01/answer25.wav",
		"vo/npc/male01/answer24.wav",
		"vo/npc/male01/answer28.wav",
		"vo/npc/male01/answer35.wav",
	},
}

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	  if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) or GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_SWAT ) or GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_STATE_POLICE ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "cop_job" )
	else
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "cop_join" )
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

function NPCMeta:PlayerJoinPolice( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) then return end

	if GAMEMODE.Jobs:CalcJobPlayerCap( JOB_POLICE ) <= GAMEMODE.Jobs:GetNumPlayers( JOB_POLICE ) and not pPlayer:CheckGroup( "vip" ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "cop_atplayercap" )
		return
	end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_POLICE )
	local snd, _ = table.Random( self.Sounds.JobJoin )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end

function NPCMeta:PlayerJoinStatePolice( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_STATE_POLICE ) then return end

	if GAMEMODE.Jobs:CalcJobPlayerCap( JOB_STATE_POLICE ) <= GAMEMODE.Jobs:GetNumPlayers( JOB_STATE_POLICE ) and not pPlayer:CheckGroup( "vip" ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "cop_atplayercap" )
		return
	end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_STATE_POLICE )
	local snd, _ = table.Random( self.Sounds.JobJoin )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end

function NPCMeta:PlayerQuitPolice( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
		if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) and not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_SWAT ) and not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_STATE_POLICE ) then return end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_CIVILIAN )
	local snd, _ = table.Random( self.Sounds.JobQuit )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end

function NPCMeta:PlayerBecomeSwat( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_SWAT ) then return end

	if GAMEMODE.Jobs:CalcJobPlayerCap( JOB_SWAT ) and not pPlayer:CheckGroup( "vip" ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "cop_atplayercap" )
		return
	end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_SWAT )
	local snd, _ = table.Random( self.Sounds.JobJoin )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "cop_become", self.PlayerJoinPolice, self )
		GM.Dialog:RegisterDialogEvent( "cop_become_SP", self.PlayerJoinStatePolice, self )
		GM.Dialog:RegisterDialogEvent( "cop_become_SWAT", self.PlayerBecomeSwat, self )
		GM.Dialog:RegisterDialogEvent( "cop_quit", self.PlayerQuitPolice, self )
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "cop_join", self.StartDialog_Join, self )
		GM.Dialog:RegisterDialog( "cop_job", self.StartDialog_Cop, self )
		GM.Dialog:RegisterDialog( "cop_atplayercap", self.StartDialog_AtJobCap, self )
	end
	
	
	function NPCMeta:StartDialog_Join()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I would like to join the Police Force.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "cop_become" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "I would like to become a State Trooper.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "cop_become_SP" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "I would like to join the SWAT team.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "cop_become_SWAT" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_Cop()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "Yes officer?" )

		GAMEMODE.Dialog:AddOption( "I would like to quit my job.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "cop_quit" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_AtJobCap()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "Sorry, we are not currently hiring." )

		GAMEMODE.Dialog:AddOption( "Oh, alright then...", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )