--[[
	Name: lawyer.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 10
Job.Enum = "JOB_LAWYER"
Job.TeamColor = Color( 255, 100, 160, 255 )
Job.Name = "Lawyer"
Job.WhitelistName = "lawyer"
Job.Pay = {
	{ PlayTime = 0, Pay = 80 },
	{ PlayTime = 4 *(60 *60), Pay = 130 },
	{ PlayTime = 12 *(60 *60), Pay = 200 },
	{ PlayTime = 24 *(60 *60), Pay = 250 },
}
Job.PlayerCap = GM.Config.Job_Lawyer_PlayerCap or { Min = 2, MinStart = 8, Max = 6, MaxEnd = 60 }

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
end

if SERVER then
	function Job:PlayerLoadout( pPlayer )
	end

	function Job:TextAllPlayers( strSenderName, strMsg )
		local num = 0
		for k, v in pairs( player.GetAll() ) do
			if GAMEMODE.Jobs:GetPlayerJob( v )  ~= self.ID then continue end
			GAMEMODE.Net:SendTextMessage( v, strSenderName, strMsg )
			v:EmitSound( "taloslife/sms.mp3" )
			num = num +1
		end
		return num
	end
else
	--client
end

GM.Jobs:Register( Job )