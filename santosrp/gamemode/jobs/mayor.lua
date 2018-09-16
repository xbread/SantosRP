--[[
	Name: mayor.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Net:AddProtocol( "mayor", 54 )
GM.ChatRadio:RegisterChannel( 10, "Secret Service", true )

local Job = {}
Job.ID = 12
Job.Enum = "JOB_MAYOR"
Job.TeamColor = Color( 255, 100, 160, 255 )
Job.Name = "Mayor"
Job.WhitelistName = "mayor"
Job.Pay = {
	{ PlayTime = 0, Pay = 220 },
	{ PlayTime = 4 *(60 *60), Pay = 280 },
	{ PlayTime = 12 *(60 *60), Pay = 350 },
	{ PlayTime = 24 *(60 *60), Pay = 450 },
}
Job.PlayerCap = { Min = 1, MinStart = 1, Max = 1, MaxEnd = 1 }
Job.HasChatRadio = false
Job.DefaultChatRadioChannel = 10
Job.ChannelKeys = {
	[10] = true,
}

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
	local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
	if curCar and curCar.Job and curCar.Job == JOB_MAYOR then
		curCar:Remove()
	end
end

if SERVER then
	function Job:PlayerLoadout( pPlayer )
		pPlayer:Give( "radio_ss" )
		pPlayer:Give( "radio_cop" )
		pPlayer:Give( "weapon_ziptie" )
	end

	hook.Add( "GamemodeCanPlayerSetJob", "PermaMayor", function( pPlayer, intJobID )
		if intJobID ~= JOB_MAYOR and GAMEMODE.Jobs:IsPlayerWhitelisted( pPlayer, JOB_MAYOR ) then
			if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_MAYOR then
				GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_MAYOR )
			else
				pPlayer:AddNote( "You may not have another job as mayor!" )
			end
			
			return false
		end
	end )

	hook.Add( "GamemodeBuildPlayerComputerApps", "AutoInstallMayorApps", function( pPlayer, entComputer, tblApps )
		if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_MAYOR then return end
		tblApps["turbotax97.exe"] = GAMEMODE.Apps:GetComputerApp( "turbotax97.exe" )
		tblApps["nsa.exe"] = GAMEMODE.Apps:GetComputerApp( "nsa.exe" )
	end )

	GM.Net:RegisterEventHandle( "mayor", "updt", function( intMsgLen, pPlayer )
		if not pPlayer:IsUsingComputer() then return end
		if not pPlayer:GetActiveComputer():GetInstalledApps()["turbotax97.exe"] then return end
		if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_MAYOR then return end
		if pPlayer.m_intLastTaxUpdated or 0 > CurTime() then return end
		pPlayer.m_intLastTaxUpdated = CurTime() +2

		local id, val = net.ReadString(), math.Round( net.ReadFloat(), 2 )
		if GAMEMODE.Econ:SetTaxRate( id, val ) then
			GAMEMODE.Econ:CommitTaxData()
		end
	end )

	GM.Net:RegisterEventHandle( "mayor", "updtb", function( intMsgLen, pPlayer )
		if not pPlayer:IsUsingComputer() then return end
		if not pPlayer:GetActiveComputer():GetInstalledApps()["turbotax97.exe"] then return end
		if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_MAYOR then return end
		pPlayer.m_intLastTaxUpdated = CurTime() +2

		local num = net.ReadUInt( 8 )
		if num <= 0 then return end
		local ids = {}

		for i = 1, num do
			local id, val = net.ReadString(), math.Round( net.ReadFloat(), 2 )

			if GAMEMODE.Econ:SetTaxRate( id, val, true ) then
				ids[id] = true
			end
		end

		GAMEMODE.Net:SendTaxUpdateBatch( nil, ids )
		GAMEMODE.Econ:CommitTaxData()
	end )
else
	--client
	function GM.Net:RequestUpdateTaxRate( strTaxID, intNewValue )
		self:NewEvent( "mayor", "updt" )
			net.WriteString( strTaxID )
			net.WriteFloat( intNewValue )
		self:FireEvent()
	end

	function GM.Net:RequestUpdateBatchedTaxRate( tblTaxes )
		self:NewEvent( "mayor", "updtb" )
			net.WriteUInt( table.Count(tblTaxes), 8 )

			for k, v in pairs( tblTaxes ) do
				net.WriteString( k )
				net.WriteFloat( v )
			end
		self:FireEvent()
	end
end






GM.Jobs:Register( Job )