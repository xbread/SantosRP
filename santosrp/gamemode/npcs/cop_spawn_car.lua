--[[
	Name: cop_spawn_car.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Police Manager"
NPCMeta.UID = "cop_spawn_car"
NPCMeta.SubText = "Spawn a police car here"
NPCMeta.Model = "models/player/santos/cop/male_03.mdl"
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
	if GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) or GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_SWAT ) or GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_STATE_POLICE ) then
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "cop_spawn" )
	else
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "cop_spawn_notacop" )
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
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) or GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_SWAT )  then end
	
	GAMEMODE.Net:ShowNWMenu( pPlayer, "cop_car_spawn" )
end

function NPCMeta:ShowSPMenu( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_STATE_POLICE ) then end
	
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "SP" )
end

function NPCMeta:ShowMainMenu( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_STATE_POLICE ) then end
	
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "cop_spawn" )
end

function NPCMeta:SpawnPatrolDodgeCharger( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_STATE_POLICE ) then return end

	GAMEMODE.Jobs:GetJobByID( JOB_STATE_POLICE ):PlayerSpawnPatrolDodgeCharger( pPlayer )
end

function NPCMeta:SpawnPatrolDodgeCharger( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_STATE_POLICE ) then return end

	GAMEMODE.Jobs:GetJobByID( JOB_STATE_POLICE ):PlayerSpawnPatrolDodgeCharger( pPlayer )
end

function NPCMeta:SpawnPatrolTaurus( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_STATE_POLICE ) then return end

	GAMEMODE.Jobs:GetJobByID( JOB_STATE_POLICE ):PlayerSpawnPatrolTaurus( pPlayer )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "cop_open_car_spawnmenu", self.ShowSpawnMenu, self )
		GM.Dialog:RegisterDialogEvent( "cop_open_SP", self.ShowSPMenu, self )
		GM.Dialog:RegisterDialogEvent( "Main_Menu", self.ShowMainMenu, self )
		GM.Dialog:RegisterDialogEvent( "SP_SRT8", self.SpawnPatrolDodgeCharger, self )
		GM.Dialog:RegisterDialogEvent( "SP_Taurus", self.SpawnPatrolTaurus, self )
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "cop_spawn", self.StartDialog_Spawn, self )
		GM.Dialog:RegisterDialog( "cop_spawn_notacop", self.StartDialog_NotACop, self )
		GM.Dialog:RegisterDialog( "SP", self.StartDialog_SPGarage, self )
	end
	
	function NPCMeta:StartDialog_Spawn()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "Yes officer?" )

		GAMEMODE.Dialog:AddOption( "Evo City Police Garage", function()
			GAMEMODE.Net:SendNPCDialogEvent( "cop_open_car_spawnmenu" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "State Police Garage", function()
			GAMEMODE.Net:SendNPCDialogEvent( "cop_open_SP" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_SPGarage()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "Select A Vehicle Trooper." )

		GAMEMODE.Dialog:AddOption( "Spawn » Dodge Charger SRT8", function()
			GAMEMODE.Net:SendNPCDialogEvent( "SP_SRT8" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Spawn » Ford Taurus 2013", function()
			GAMEMODE.Net:SendNPCDialogEvent( "SP_Taurus" )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Go Back", function()
			GAMEMODE.Net:SendNPCDialogEvent( "Main_Menu" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_NotACop()
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