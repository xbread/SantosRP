--[[
	Name: evocity_frontdesk.lua
	For: TalosLife
	By: TalosLife
]]--

local NPCMeta = {}
NPCMeta.Name = "Receptionist"
NPCMeta.UID = "evocity_frontdesk"
NPCMeta.SubText = "Get government information here"
NPCMeta.Model = "models/alyx.mdl"

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "front_desk_start" )
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "front_desk_start", self.StartDialog, self )
	end
	
	function NPCMeta:StartDialog()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "How can I help you?" )

		if not GAMEMODE.Jobs:PlayerIsJob( LocalPlayer(), JOB_POLICE ) then
			GAMEMODE.Dialog:AddOption( "Where do I join the police force?", function()
				self:ShowJoinPoliceQuestion()
			end )
		else
			GAMEMODE.Dialog:AddOption( "Where do I spawn a police car?", function()
				self:ShowSpawnPoliceCarQuestion()
			end )
		end

		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:ShowJoinPoliceQuestion()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "Go to the second floor and talk to the police chief." )

		GAMEMODE.Dialog:AddOption( "I have another question.", function()
			self:StartDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Thank you.", function()
			GAMEMODE.Dialog:HideDialog()
		end )
	end

	function NPCMeta:ShowSpawnPoliceCarQuestion()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "Go to the basement floor and talk to the manager." )

		GAMEMODE.Dialog:AddOption( "I have another question.", function()
			self:StartDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Thank you.", function()
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )