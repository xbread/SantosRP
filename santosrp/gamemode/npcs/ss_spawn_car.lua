--[[
	Name: ss_spawn_car.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Secret Service VR"
NPCMeta.UID = "ss_spawn_car"
NPCMeta.SubText = "Spawn a government car here"
NPCMeta.Model = "models/odessa.mdl"
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
}

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_SSERVICE ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "ss_spawn" )
	else
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "ss_spawn_notss" )
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

function NPCMeta:ShowSpawnMenu( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_SSERVICE ) then return end
	
	GAMEMODE.Net:ShowNWMenu( pPlayer, "ss_car_spawn" )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "ss_open_car_spawnmenu", self.ShowSpawnMenu, self )
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "ss_spawn", self.StartDialog_Spawn, self )
		GM.Dialog:RegisterDialog( "ss_spawn_notss", self.StartDialog_NotSS, self )
	end
	
	function NPCMeta:StartDialog_Spawn()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I would like to spawn a government vehicle.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "ss_open_car_spawnmenu" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_NotSS()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )