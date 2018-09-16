--[[
	Name: law_jobs.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Law Office"
NPCMeta.UID = "law_jobs"
NPCMeta.SubText = "Become a lawyer,prosecutor, or a judge here"
NPCMeta.Model = "models/Humans/Group02/Female_04.mdl"
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
	},
	JobQuit = {
		"vo/npc/female01/answer02.wav",
		"vo/npc/female01/answer03.wav",
		"vo/npc/female01/answer04.wav",
		"vo/npc/female01/answer24.wav",
		"vo/npc/female01/heretohelp01.wav",
		"vo/npc/female01/heretohelp02.wav",
		"vo/npc/female01/notthemanithought01.wav",
		"vo/npc/female01/notthemanithought02.wav",
	},
	JobJoin = {
		"vo/npc/female01/answer25.wav",
		"vo/npc/female01/answer24.wav",
		"vo/npc/female01/answer29.wav",
		"vo/npc/female01/answer36.wav",
	},
}

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_LAWYER ) or GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_PROSECUTOR ) or GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_JUDGE ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "law_start_isjob" )
	else
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "law_start" )
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

function NPCMeta:PlayerBecomeLawyer( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_LAWYER ) then return end

	if GAMEMODE.Jobs:CalcJobPlayerCap( JOB_LAWYER ) <= GAMEMODE.Jobs:GetNumPlayers( JOB_LAWYER ) and not pPlayer:CheckGroup( "vip" ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "law_atplayercap" )
		return
	end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_LAWYER )
	local snd, _ = table.Random( self.Sounds.JobJoin )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end

function NPCMeta:PlayerBecomeProsecutor( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_PROSECUTOR ) then return end

	if GAMEMODE.Jobs:CalcJobPlayerCap( JOB_PROSECUTOR ) <= GAMEMODE.Jobs:GetNumPlayers( JOB_PROSECUTOR ) and not pPlayer:CheckGroup( "vip" ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "law_atplayercap" )
		return
	end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_PROSECUTOR )
	local snd, _ = table.Random( self.Sounds.JobJoin )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end


function NPCMeta:PlayerBecomeJudge( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_JUDGE ) then return end

	if GAMEMODE.Jobs:CalcJobPlayerCap( JOB_JUDGE ) <= GAMEMODE.Jobs:GetNumPlayers( JOB_JUDGE ) and not pPlayer:CheckGroup( "vip" ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "law_atplayercap" )
		return
	end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_JUDGE )
	local snd, _ = table.Random( self.Sounds.JobJoin )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end


function NPCMeta:PlayerQuitJob( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_LAWYER ) and not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_PROSECUTOR ) and not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_JUDGE ) then return end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_CIVILIAN )
	local snd, _ = table.Random( self.Sounds.JobQuit )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "law_become_lawyer", self.PlayerBecomeLawyer, self )
		GM.Dialog:RegisterDialogEvent( "law_become_prosecutor", self.PlayerBecomeProsecutor, self )
		GM.Dialog:RegisterDialogEvent( "law_become_judge", self.PlayerBecomeJudge, self )
		GM.Dialog:RegisterDialogEvent( "law_quit_job", self.PlayerQuitJob, self )
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "law_start", self.StartDialog, self )
		GM.Dialog:RegisterDialog( "law_start_isjob", self.StartDialog_IsJob, self )
		GM.Dialog:RegisterDialog( "law_atplayercap", self.StartDialog_AtJobCap, self )
	end
	
	function NPCMeta:StartDialog()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I would like to become a lawyer.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "law_become_lawyer" )
			GAMEMODE.Dialog:HideDialog()
		end )		

		GAMEMODE.Dialog:AddOption( "I would like to become a prosecutor.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "law_become_prosecutor" )
			GAMEMODE.Dialog:HideDialog()
		end )	

			GAMEMODE.Dialog:AddOption( "I would like to become a judge.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "law_become_judge" )
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
			GAMEMODE.Net:SendNPCDialogEvent( "law_quit_job" )
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