--[[
	Name: mayor_jobs.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Assistant"
NPCMeta.UID = "mayor_jobs"
NPCMeta.SubText = "Apply for the secret service here"
NPCMeta.Model = "models/Humans/Group01/Male_04.mdl"
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
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_SSERVICE ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "ss_start_isjob" )
	elseif GAMEMODE.Jobs:GetJobByID( JOB_SSERVICE ):PlayerHasApp( pPlayer ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "ss_start_hasapp" )
	else
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "ss_start" )
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

function NPCMeta:PlayerApplyForSS( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_SSERVICE ) then return end
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_MAYOR ) then return end
	if GAMEMODE.Jobs:GetJobByID( JOB_SSERVICE ):PlayerHasApp( pPlayer ) then return end

	if GAMEMODE.Jobs:GetJobByID( JOB_SSERVICE ):PlayerApply( pPlayer ) then
		local snd, _ = table.Random( self.Sounds.JobJoin )
		pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
	end
end

function NPCMeta:PlayerRemoveSSApp( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_SSERVICE ) then return end
	if not GAMEMODE.Jobs:GetJobByID( JOB_SSERVICE ):PlayerHasApp( pPlayer ) then return end

	GAMEMODE.Jobs:GetJobByID( JOB_SSERVICE ):PlayerPullApp( pPlayer )
	local snd, _ = table.Random( self.Sounds.JobJoin )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end

function NPCMeta:PlayerQuitSS( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_SSERVICE ) then return end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_CIVILIAN )
	local snd, _ = table.Random( self.Sounds.JobQuit )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "ss_apply", self.PlayerApplyForSS, self )
		GM.Dialog:RegisterDialogEvent( "ss_revoke", self.PlayerRemoveSSApp, self )
		GM.Dialog:RegisterDialogEvent( "ss_quit_job", self.PlayerQuitSS, self )
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "ss_start", self.StartDialog, self )
		GM.Dialog:RegisterDialog( "ss_start_isjob", self.StartDialog_IsJob, self )
		GM.Dialog:RegisterDialog( "ss_start_hasapp", self.StartDialog_HasApp, self )
	end
	
	function NPCMeta:StartDialog()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I would like to apply for the mayor's secret service.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "ss_apply" )
			GAMEMODE.Dialog:HideDialog()
		end )		

		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end
	
	function NPCMeta:StartDialog_IsJob()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I would like to quit my job.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "ss_quit_job" )
			GAMEMODE.Dialog:HideDialog()
		end )		

		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_HasApp()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )
		
		GAMEMODE.Dialog:AddOption( "I would like to revoke my secret service application.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "ss_revoke" )
			GAMEMODE.Dialog:HideDialog()
		end )		

		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )