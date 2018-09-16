
-----------------------------------------------------
--[[
	Name: ems.lua
	
		
]]--

local Job = {}
Job.ID = 23
Job.Enum = "JOB_SANITATION"
Job.TeamColor = Color( 191, 129, 13, 255 )
Job.Name = "Sanitation Worker"
Job.Pay = {
	{ PlayTime = 0, Pay = 190 },
	{ PlayTime = 4 *(60 *60), Pay = 235 },
	{ PlayTime = 12 *(60 *60), Pay = 275 },
	{ PlayTime = 24 *(60 *60), Pay = 365 },
}
Job.PlayerCap = GM.Config.Job_Garbage_PlayerCap or { Min = 2, MinStart = 8, Max = 6, MaxEnd = 60 }
Job.ParkingLotPos = GM.Config.TowParkingZone
Job.TruckSpawns = GM.Config.TowCarSpawns
Job.CarID = "JOB_CITYWORKER"

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
	local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
	if curCar and curCar.Job and curCar.Job == JOB_SANITATION then
		curCar:Remove()
	end
end

if SERVER then
	local function MakeEnt(name, ply)
	    if !IsValid(ply) then return end
	    local ent = ents.Create(name)

	    if !IsValid(ent) then return end
	    if !ent.CPPISetOwner then return ent end

	    ent:CPPISetOwner(ply)
	    return ent
	end

function Job:GetPlayerModel( pPlayer )
	local base, overload

	if SERVER then
		base = GAMEMODE.Player:GetGameVar( pPlayer, "char_model_base", nil )
		overload = GAMEMODE.Player:GetGameVar( pPlayer, "char_model_overload", nil )
	else
		base = GAMEMODE.Player:GetGameVar( "char_model_base", nil )
		overload = GAMEMODE.Player:GetGameVar( "char_model_overload", nil )
	end
	
	if util.IsValidModel( overload or "" ) then
		return overload
	else
		return base
	end
end

function Job:PlayerSetModel( pPlayer )
	local mdl = self:GetPlayerModel(pPlayer)

	if mdl then
		pPlayer:SetModel( mdl )
		pPlayer:SetSkin( GAMEMODE.Player:GetGameVar(pPlayer, "char_skin", 0) )
	end
end

	function Job:PlayerLoadout( pPlayer )

	end

	function Job:OnPlayerSpawnTruck( pPlayer, entCar )
		local vehicle = entCar
		local localpos = vehicle:GetPos() 
		local localang = vehicle:GetAngles()
		local Forward = localang:Forward()
		local Right = localang:Right()
		local Up = localang:Up()

		local Color01 = Color(190,65,0,255)	
		local RF = RecipientFilter()
		RF:AddAllPlayers()


		pPlayer:AddNote( "Your spawned your Sanitation truck!" )
	end

	--Player wants to spawn an garbage truck
	function Job:PlayerSpawnTruck( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.CarID, self.TruckSpawns, self.ParkingLotPos )		
		if IsValid( car ) then
			self:OnPlayerSpawnTruck( pPlayer, car )
		end
	end
	
	function Job:PlayerStowGarbageCar( pPlayer )
		GAMEMODE.Cars:PlayerStowJobCar( pPlayer, self.ParkingLotPos )
	end
end

GM.Jobs:Register( Job )