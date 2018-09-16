--[[
	Name: evocity_dmv.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "DMV"
NPCMeta.UID = "evocity_dmv"
NPCMeta.SubText = "Take your driving test/Purchase custom plates/Pay tickets here"
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
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "dmv_start" )

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

function NPCMeta:ShowPlateMenu( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end

	if pPlayer:CheckGroup( "vip" ) then
		GAMEMODE.Net:ShowNWMenu( pPlayer, "custom_plate_menu" )
	else
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "dmv_lplate_notvip" )
	end
end

function NPCMeta:ShowDriveTestMenu( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable.License or not (saveTable.License.RevokeTime or saveTable.License.ID) then
		if saveTable.LastDrivingTestTime then
			if saveTable.LastDrivingTestTime +GAMEMODE.Config.DrivingTestRetakeDelay < os.time() then
				local time = math.ceil( (os.time() -(saveTable.LastDrivingTestTime +GAMEMODE.Config.DrivingTestRetakeDelay)) /60 )
				pPlayer:AddNote( "You must wait ".. time.. " minutes before taking this test again." )
				return
			end
		end

		GAMEMODE.Net:ShowNWMenu( pPlayer, "driving_test_menu" )
	else
		GAMEMODE.Net:ShowNPCDialog( pPlayer, "dmv_already_has_id" )
	end
end

function NPCMeta:ShowTicketMenu( pPlayer, ... )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end
	GAMEMODE.Net:ShowNWMenu( pPlayer, "ticket_menu" )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialogEvent( "dmv_open_custom_plate_menu", self.ShowPlateMenu, self )
		GM.Dialog:RegisterDialogEvent( "dmv_open_driving_test_menu", self.ShowDriveTestMenu, self )
		GM.Dialog:RegisterDialogEvent( "dmv_open_tickets_menu", self.ShowTicketMenu, self )
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "dmv_start", self.StartDialog, self )
		GM.Dialog:RegisterDialog( "dmv_already_has_id", self.StartDialog_HasID, self )
		GM.Dialog:RegisterDialog( "dmv_lplate_notvip", self.StartDialog_NotVIP, self )
	end
	
	function NPCMeta:StartDialog()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		GAMEMODE.Dialog:AddOption( "I'm here to take a driving test.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "dmv_open_driving_test_menu" )
			GAMEMODE.Dialog:HideDialog()
		end )		

		GAMEMODE.Dialog:AddOption( "I'd like to purchase custom plates for my vehicle.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "dmv_open_custom_plate_menu" )
			GAMEMODE.Dialog:HideDialog()
		end )		

		GAMEMODE.Dialog:AddOption( "I'm here to pay off a ticket that was given to me.", function()
			GAMEMODE.Net:SendNPCDialogEvent( "dmv_open_tickets_menu" )
			GAMEMODE.Dialog:HideDialog()
		end )

		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:StartDialog_HasID()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "You already have a drivers license!" )

		GAMEMODE.Dialog:AddOption( "Oh, I guess I forgot...", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )

		GAMEMODE.Dialog:AddOption( "Oh, well I need something else.", function()
			NPCMeta:StartDialog()
		end )
	end
	
	function NPCMeta:StartDialog_NotVIP()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "You must be a VIP to do that!" )

		GAMEMODE.Dialog:AddOption( "Oh, well I'll just be going then...", function()
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )

		GAMEMODE.Dialog:AddOption( "Oh, well I need something else.", function()
			NPCMeta:StartDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )