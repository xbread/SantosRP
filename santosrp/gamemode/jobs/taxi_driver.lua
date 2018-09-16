--[[
	Name: taxi_driver.lua
	For: TalosLife
	By: TalosLife
]]--

GM.ChatRadio:RegisterChannel( 8, "Taxi Services", false )

local Job = {}
Job.ID = 5
Job.Enum = "JOB_TAXI"
Job.TeamColor = Color( 255, 100, 160, 255 )
Job.Name = "Taxi Driver"
Job.ParkingGaragePos = GM.Config.TaxiParkingZone
Job.Pay = {
	{ PlayTime = 0, Pay = 28 },
	{ PlayTime = 4 *(60 *60), Pay = 47 },
	{ PlayTime = 12 *(60 *60), Pay = 74 },
	{ PlayTime = 24 *(60 *60), Pay = 95 },
}
Job.PlayerCap = GM.Config.Job_Taxi_PlayerCap or { Min = 2, MinStart = 8, Max = 6, MaxEnd = 60 }
Job.HasChatRadio = true
Job.DefaultChatRadioChannel = 8
Job.ChannelKeys = {}
Job.CarSpawns = GM.Config.TaxiCarSpawns
Job.TaxiID = "taxi_cab"
Job.TaxiChargeAmount = 5
Job.TaxiChargeInterval = 10

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
	local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
	if curCar and curCar.Job and curCar.Job == JOB_TAXI then
		curCar:Remove()
	end
end

if SERVER then
	function Job:PlayerLoadout( pPlayer )
	end

	function Job:OnPlayerSpawnTaxi( pPlayer, entCar )
		entCar.IsTaxi = true
		pPlayer:AddNote( "You have spawned your taxi cab!" )
	end
	
	--Player wants to spawn a taxi
	function Job:PlayerSpawnTaxiCab( pPlayer )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.TaxiID, self.CarSpawns, self.ParkingGaragePos )
		if IsValid( car ) then
			self:OnPlayerSpawnTaxi( pPlayer, car )
		end
	end
	
	--Player wants to stow their taxi
	function Job:PlayerStowTaxiCab( pPlayer )
		GAMEMODE.Cars:PlayerStowJobCar( pPlayer, self.ParkingGaragePos )
	end

		hook.Add( "GamemodePlayerSendTextMessage", "TaxiJobTexting", function( pSender, strText, strNumberSendTo )
		if strNumberSendTo ~= "Taxi" then return end
		if pSender.m_intLastTowText and pSender.m_intLastTowText > CurTime() then
			local time = math.Round( pSender.m_intLastTowText -CurTime() )
			GAMEMODE.Net:SendTextMessage( pSender, "Taxi", "You must wait ".. time.. " seconds before you can send another message to a Taxi Driver." )
			pSender:EmitSound( "taloslife/sms.mp3" )
			return true
		end
		local sentTo = 0
		strText = "Taxi call from ".. GAMEMODE.Player:GetGameVar(pSender, "phone_number").. "\n(".. pSender:Nick().. "):\n".. strText
		for k, v in pairs( player.GetAll() ) do
			if GAMEMODE.Jobs:GetPlayerJobID( v ) == JOB_TAXI then
				GAMEMODE.Net:SendTextMessage( v, "Taxi Dispatch", strText )
				v:EmitSound( "taloslife/sms.mp3" )
				sentTo = sentTo +1
			end
		end

		local respMsg = ""
		if sentTo == 0 then
			respMsg = "No Taxi services are available right now. Sorry!"
		else
			respMsg = "Your message was received by dispatch and sent to ".. sentTo.. " players."
		end
		
		GAMEMODE.Net:SendTextMessage( pSender, "Taxi", respMsg )
		pSender:EmitSound( "taloslife/sms.mp3" )
		pSender.m_intLastTowText = CurTime() +60
		return
	end )

	hook.Add( "PlayerEnteredVehicle", "TaxiCharge", function( pPlayer, entVehicle, intRole )
		if IsValid( entVehicle:GetParent() ) and entVehicle:GetParent().IsTaxi then
			entVehicle:GetParent().m_tblPlayers = entVehicle:GetParent().m_tblPlayers or {}
			entVehicle:GetParent().m_tblPlayers[pPlayer] = { LastTime = 0, Count = 0 }
		end
	end )

	hook.Add( "PlayerLeaveVehicle", "TaxiCharge", function( pPlayer, entVehicle, intRole )
		if IsValid( entVehicle:GetParent() ) and entVehicle:GetParent().IsTaxi then
			if not entVehicle:GetParent().m_tblPlayers then return end
			entVehicle:GetParent().m_tblPlayers[pPlayer] = nil
		end
	end )

	local chargeAmount = Job.TaxiChargeAmount
	timer.Create( "TaxiChargePlayers", 1, 0, function()
		for k, v in pairs( player.GetAll() ) do
			if not v:InVehicle() or not v:GetVehicle().IsTaxi then continue end

			for ply, data in pairs( v:GetVehicle().m_tblPlayers or {} ) do
				if CurTime() < data.LastTime then continue end
				data.LastTime = CurTime() +Job.TaxiChargeInterval

				if ply == v:GetVehicle():GetDriver() then continue end
				if ply:GetMoney() >= chargeAmount then
					ply:TakeMoney( chargeAmount )
					v:AddMoney( chargeAmount )

					data.Count = data.Count +1
					if data.Count >= 6 then
						ply:AddNote( "You were charged $".. chargeAmount *data.Count.. " for your time in the taxi." )
						v:AddNote( "You earned $".. chargeAmount *data.Count.. " from one of your passengers." )
						data.Count = 0
					end
				end
			end
		end
	end )
else
	--client
end

GM.Jobs:Register( Job )