--[[
	Name: judge.lua
	For: TalosLife
	By: TalosLife
]]--

local Job = {}
Job.ID = 20
Job.Enum = "JOB_JUDGE"
Job.TeamColor = Color( 255, 100, 160, 255 )
Job.Name = "Distrct Judge"
Job.WhitelistName = "judge"
Job.Pay = {
	{ PlayTime = 0, Pay = 150 },
	{ PlayTime = 4 *(60 *60), Pay = 190 },
	{ PlayTime = 12 *(60 *60), Pay = 230 },
	{ PlayTime = 24 *(60 *60), Pay = 280 },
}
Job.PlayerCap = GM.Config.Job_Prosecutor_PlayerCap or { Min = 2, MinStart = 8, Max = 6, MaxEnd = 60 }

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
end


if SERVER then
	function Job:PlayerLoadout( pPlayer )
	end
else
	--client
end

GM.Jobs:Register( Job )