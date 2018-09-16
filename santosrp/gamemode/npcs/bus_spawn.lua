--[[
	Name: bus_spawn.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Bus Manager"
NPCMeta.UID = "bus_spawn"
NPCMeta.SubText = "Become a bus driver here"
NPCMeta.Model = "models/Humans/Group01/Male_01.mdl"
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
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_BUS_DRIVER ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "bus_spawn" )
	else
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "bus_spawn_notdriver" )
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

function NPCMeta:SpawnBus( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_BUS_DRIVER ) then return end

	GAMEMODE.Jobs:GetJobByID( JOB_BUS_DRIVER ):PlayerSpawnBus( pPlayer )
	self:OnPlayerEndDialog( pPlayer )
end

function NPCMeta:StowBus( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_BUS_DRIVER ) then return end

	GAMEMODE.Jobs:GetJobByID( JOB_BUS_DRIVER ):PlayerStowBus( pPlayer )
	self:OnPlayerEndDialog( pPlayer )
end

function NPCMeta:BecomeJob( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_BUS_DRIVER ) then return end

	if GAMEMODE.Jobs:CalcJobPlayerCap( JOB_BUS_DRIVER ) <= GAMEMODE.Jobs:GetNumPlayers( JOB_BUS_DRIVER ) and not pPlayer:CheckGroup( "vip" ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "bus_atplayercap" )
		return
	end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_BUS_DRIVER )
	local snd, _ = table.Random( self.Sounds.JobJoin )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end

function NPCMeta:QuitJob( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_BUS_DRIVER ) then return end

	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_CIVILIAN )
	local snd, _ = table.Random( self.Sounds.JobQuit )
	pPlayer:GetTalkingNPC():EmitSound( snd, 60 )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "bus_spawn_truck", self.SpawnBus, self )
		GM.Dialog:RegisterDialogEvent( "bus_stow_truck", self.StowBus, self )
		GM.Dialog:RegisterDialogEvent( "bus_become", self.BecomeJob, self )
		GM.Dialog:RegisterDialogEvent( "bus_quit", self.QuitJob, self )
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "bus_spawn", self.StartDialog_Spawn, self )
		GM.Dialog:RegisterDialog( "bus_spawn_notdriver", self.StartDialog_NotBusDriver, self )
		GM.Dialog:RegisterDialog( "bus_atplayercap", self.StartDialog_AtJobCap, self )
	end
	
	function NPCMeta:StartDialog_Spawn()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I would like to spawn my bus.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "bus_spawn_truck" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "I would like to store my bus.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "bus_stow_truck" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "I would like to quit my job", function()
			GAMEMODE.Net:SendNPCDialogEvent( "bus_quit" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_NotBusDriver()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I would like to become a bus driver.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "bus_become" )
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