--[[
	Name: bus_driver.lua
	For: TalosLife
	By: TalosLife
]]--

GM.ChatRadio:RegisterChannel( 9, "City Bus Services", false )

local Job = {}
Job.ID = 9
Job.Enum = "JOB_BUS_DRIVER"
Job.TeamColor = Color( 255, 100, 160, 255 )
Job.Name = "Bus Driver"
Job.ParkingGaragePos = GM.Config.BusParkingZone
Job.Pay = {
	{ PlayTime = 0, Pay = 25 },
	{ PlayTime = 4 *(60 *60), Pay = 50 },
	{ PlayTime = 12 *(60 *60), Pay = 85 },
	{ PlayTime = 24 *(60 *60), Pay = 110 },
}
Job.PlayerCap = GM.Config.Job_BusDriver_PlayerCap or { Min = 2, MinStart = 8, Max = 6, MaxEnd = 60 }
Job.HasChatRadio = true
Job.DefaultChatRadioChannel = 9
Job.ChannelKeys = {}
Job.CarSpawns = GM.Config.BusCarSpawns
Job.BusID = "gta_bus"
Job.BusChargeAmount = 50

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
	local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
	if curCar and curCar.Job and curCar.Job == JOB_BUS_DRIVER then
		curCar:Remove()
	end
end

if SERVER then
	function Job:PlayerLoadout( pPlayer )
	end

	function Job:OnPlayerSpawnBus( pPlayer, entCar )
		entCar.IsBus = true
		pPlayer:AddNote( "You spawned your bus!" )
	end
	
	--Player wants to spawn a bus
	function Job:PlayerSpawnBus( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.BusID, self.CarSpawns, self.ParkingGaragePos )
		if IsValid( car ) then
			self:OnPlayerSpawnBus( pPlayer, car )
		end
	end
	
	--Player wants to stow their bus
	function Job:PlayerStowBus( pPlayer )
		GAMEMODE.Cars:PlayerStowJobCar( pPlayer, self.ParkingGaragePos )
	end

	local chargeAmount = Job.BusChargeAmount
	hook.Add( "CanPlayerEnterVehicle", "BusCanEnter", function( pPlayer, entVehicle, strRole )
		local parent = entVehicle:GetParent()
		if IsValid( parent ) and parent.IsBus then
			if not IsValid( parent:GetDriver() ) or parent:GetPlayerOwner() ~= parent:GetDriver() then return end
			if not pPlayer:CanAfford( chargeAmount ) then return false end
		end
	end )

	hook.Add( "PlayerEnteredVehicle", "BusCharge", function( pPlayer, entVehicle, intRole )
		local parent = entVehicle:GetParent()
		if IsValid( parent ) and parent.IsBus then
			if not IsValid( parent:GetDriver() ) then return end
			if parent:GetPlayerOwner() == pPlayer then return end
			if parent:GetDriver() ~= parent:GetPlayerOwner() then return end

			pPlayer:TakeMoney( chargeAmount )
			pPlayer:AddNote( "You were charged $".. chargeAmount.. " to board this bus." )

			entVehicle:GetParent():GetDriver():AddMoney( chargeAmount )
			entVehicle:GetParent():GetDriver():AddNote( "You received $".. chargeAmount.. " from someone boarding your bus!" )
		end
	end )
else
	--client
end

GM.Jobs:Register( Job )