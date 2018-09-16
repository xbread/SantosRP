--[[
	Name: sv_license.lua
	For: TalosLife
	By: TalosLife
]]--

GM.License = {}
GM.License.m_intLastTick = 0

function GM.License:Tick()
	if self.m_intLastTick > CurTime() then return end
	self.m_intLastTick = CurTime() +1
	self:UpdateRevokedLicenses()
end

--[[ Custom Plates ]]--
function GM.License:PlayerBuyPlate( pPlayer, strPlate )
	if not pPlayer:CheckGroup( "vip" ) then return end
	if not pPlayer:CanAfford( GAMEMODE.Config.LPlateCost ) then
		pPlayer:AddNote( "You can't afford to buy a custom plate number!" )
		return false
	end

	if strPlate:len() < 1 or strPlate:len() > 7 or strPlate:find( "[^%a%d-]" ) then
		pPlayer:AddNote( "You entered an invalid plate number." )
		return false
	end

	local result = sql.QueryRow( string.format( 
		[[SELECT * FROM %s WHERE plate=%s]],
		LPlates.TableName,
		sql.SQLStr( strPlate )
	) )

	if result then
		pPlayer:AddNote( "That plate number is already in use." )
		return false
	end

	pPlayer:TakeMoney( GAMEMODE.Config.LPlateCost )
	LPlates.SetPlateInfo( pPlayer, strPlate )
	pPlayer:AddNote( "You purchased a custom license plate!" )

	return true
end

--[[ License Management ]]--
function GM.License:GenerateNumbers( intAmount )
	local str = ""
	for i = 1, intAmount do
		str = str.. math.random( 0, 9 )
	end
	return str
end

function GM.License:GenerateLicense( pPlayer )
	local license = "V%s-%s-%s-%s-%s"
	license = license:format(
		self:GenerateNumbers( 3 ),
		self:GenerateNumbers( 3 ),
		self:GenerateNumbers( 2 ),
		self:GenerateNumbers( 3 ),
		self:GenerateNumbers( 1 )
	)

	GAMEMODE.Player:SetSharedGameVar( pPlayer, "driver_license", license )
	self:UpdateLicenseData( pPlayer )
end

function GM.License:RevokeLicense( pPlayer )
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "driver_license", "" )
	self:UpdateLicenseData( pPlayer )
end

function GM.License:PlayerHasLicense( pPlayer )
	return GAMEMODE.Player:GetSharedGameVar( pPlayer, "driver_license", "" ) ~= ""
end

function GM.License:GetPlayerPlateNumber( pPlayer )
	if not GAMEMODE.Cars:PlayerHasCar( pPlayer ) then return "unknown" end
	return GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer ):GetNWString( "plate_serial" )
end

function GM.License:GetPlayerFromPlateNumber( strPlateNumber )
	for k, v in pairs( player.GetAll() ) do
		if not GAMEMODE.Player:PlayerHasCar( v ) then continue end
		if GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer ):GetNWString( "plate_serial" ):lower() == strPlateNumber:lower() then
			return v
		end
	end
end

function GM.License:PlayerSubmitDrivingTest( pPlayer, tblOptions )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	if saveTable.License and (saveTable.License.RevokeTime or saveTable.License.ID) then
		return
	end

	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "evocity_dmv" then return end

	if saveTable.LastDrivingTestTime then
		if saveTable.LastDrivingTestTime +GAMEMODE.Config.DrivingTestRetakeDelay > os.time() then
			local time = math.ceil( ((saveTable.LastDrivingTestTime +GAMEMODE.Config.DrivingTestRetakeDelay) -os.time()) /60 )
			pPlayer:AddNote( "You must wait ".. time.. " minutes before taking this test again." )
			return
		end
	end

	if table.Count( tblOptions ) ~= table.Count( GAMEMODE.Config.DrivingTestQuestions_Answers ) then
		return false
	end

	local numCorrect = 0
	for qID, pickedKey in pairs( tblOptions ) do
		if GAMEMODE.Config.DrivingTestQuestions_Answers[qID].Options[pickedKey] then
			numCorrect = numCorrect +1
		end
	end

	if GAMEMODE.Config.MinCorrectDrivingTestQuestions > numCorrect then
		pPlayer:AddNote( "You failed your driving test!" )
		saveTable.LastDrivingTestTime = os.time()
		--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "LastDrivingTestTime", saveTable.LastDrivingTestTime )
		GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "LastDrivingTestTime" )
	else
		pPlayer:AddNote( "You passed your driving test!" )
		self:GenerateLicense( pPlayer )
		pPlayer:AddNote( "Your license id is ".. GAMEMODE.Player:GetSharedGameVar(pPlayer, "driver_license") )
	end
end

--[[ License Dot Management ]]--
function GM.License:PlayerDotLicense( pPlayer, pDottedPlayer, strDotReason )
	if not IsValid( pDottedPlayer ) then return false end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) or GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_SWAT ) then return false end
	if not GAMEMODE.Cars:IsPlayerCarForJob( pPlayer, JOB_POLICE ) then return false end
	if pPlayer:GetVehicle() ~= GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer ) then return false end
	if not self:PlayerHasLicense( pDottedPlayer ) then return false end
	if strDotReason == "" then return false end
	if strDotReason:len() > GAMEMODE.Config.MaxLicenseDotReasonLength then return false end

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pDottedPlayer )
	if not saveTable then return false end

	saveTable.License =  saveTable.License or {}
	saveTable.License.Dots = saveTable.License.Dots or {}
	table.insert( saveTable.License.Dots, {
		GivenBy = pPlayer:Nick(),
		Reason = strDotReason,
		Date = os.time(),
	} )

	if table.Count( saveTable.License.Dots ) > GAMEMODE.Config.MaxLicenseDotHistory then
		table.remove( saveTable.License.Dots, 1 )
	end

	--Save dots NOW
	--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "License", saveTable.License )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "License" )

	pPlayer:AddNote( "You placed a warning on ".. pDottedPlayer:Nick().. "'s license!" )
	pDottedPlayer:AddNote( "You received a warning on your license!" )

	return true
end

function GM.License:GetPlayerDots( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return {} end	
	if not saveTable.License then return {} end
	return saveTable.License.Dots
end

--[[ License Revoke Management ]]--
function GM.License:UpdateRevokedLicenses()
	local saveTable
	for k, v in pairs( player.GetAll() ) do
		saveTable = GAMEMODE.Char:GetCurrentSaveTable( v )
		if not saveTable or not saveTable.License then continue end
		if not saveTable.License.RevokeTime then continue end
		
		if saveTable.License.RevokeTime +saveTable.License.RevokeDuration < os.time() then
			saveTable.License.RevokeTime = nil
			saveTable.License.RevokeDuration = nil
			self:GenerateLicense( v )
			v:AddNote( "Your license is no longer revoked!" )
		end
	end
end

function GM.License:PlayerRevokePlayerLicense( pPlayer, pRevoke, intDuration )
	if not IsValid( pRevoke ) then return false end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) then return false end
	if not GAMEMODE.Cars:IsPlayerCarForJob( pPlayer, JOB_POLICE ) then return false end
	if pPlayer:GetVehicle() ~= GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer ) then return false end
	if not self:PlayerHasLicense( pRevoke ) then return false end
	if intDuration < GAMEMODE.Config.MinLicenseRevokeTime or intDuration > GAMEMODE.Config.MaxLicenseRevokeTime then
		return false
	end
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pRevoke )
	if not saveTable then return false end

	saveTable.License = saveTable.License or {}
	saveTable.License.RevokeTime = os.time()
	saveTable.License.RevokeDuration = intDuration
	--Clear dots
	saveTable.License.Dots = nil

	self:RevokeLicense( pRevoke ) --Revoke calls update which commits license data

	local time = math.ceil( intDuration /60 )
	pPlayer:AddNote( "You revoked ".. pRevoke:Nick().. "'s license!" )
	pRevoke:AddNote( "Your license was revoked for ".. time.. " minutes!" )

	return true
end

--[[ Ticket Management ]]--
function GM.License:GetPlayerUnpiadTickets( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Tickets then return {} end
	return saveTable.Tickets.Unpaid or {}
end

function GM.License:GetPlayerPaidTickets( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Tickets then return {} end
	return saveTable.Tickets.Paid or {}
end

function GM.License:AddPlayerTicket( pPlayer, strReason, strGivenBy, intPrice )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return false end

	saveTable.Tickets = saveTable.Tickets or {}
	saveTable.Tickets.Unpaid = saveTable.Tickets.Unpaid or {}

	if table.Count( saveTable.Tickets.Unpaid ) > GAMEMODE.Config.MaxOutstandingTickets then
		return false
	end

	table.insert( saveTable.Tickets.Unpaid, {
		Price = intPrice,
		GivenBy = strGivenBy,
		Reason = strReason,
		Date = os.time(),
	} )

	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Tickets" )

	return true
end

function GM.License:PlayerTicketPlayer( pPlayer, pTicket, strReason, intPrice )
	if not IsValid( pTicket ) then return false end
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) then return false end
	if strReason == "" then return false end
	if strReason:len() > GAMEMODE.Config.MaxTicketReasonLength then return false end
	if intPrice < GAMEMODE.Config.MinTicketPrice or intPrice > GAMEMODE.Config.MaxTicketPrice then return false end

	if self:AddPlayerTicket( pTicket, strReason, pPlayer:Nick(), intPrice ) then
		pTicket:AddNote( pPlayer:Nick().. " gave you a ticket for $".. string.Comma(intPrice) )
		pPlayer:AddNote( "You gave ".. pTicket:Nick().. " a ticket for $".. string.Comma(intPrice) )
		return true
	end

	return false
end

function GM.License:PlayerTicketPlayerCar( pPlayer, entTarget, strReason, intPrice )
	if not IsValid( entTarget ) or not entTarget.CarData then return false end
	if strReason == "" then return false end
	if strReason:len() > GAMEMODE.Config.MaxTicketReasonLength then return false end
	if intPrice < GAMEMODE.Config.MinTicketPrice or intPrice > GAMEMODE.Config.MaxTicketPrice then return false end

	entTarget.m_tblWaitingTicket = {
		Price = intPrice,
		GivenBy = pPlayer:Nick(),
		Reason = strReason,
	}

	pPlayer:AddNote( "You left a ticket for the owner of this car." )

	return true
end

function GM.License:PlayerPayTicket( pPlayer, intTicketIDX )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "evocity_dmv" then return end

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Tickets or not saveTable.Tickets.Unpaid then return false end
	
	local ticketData = saveTable.Tickets.Unpaid[intTicketIDX]
	if not ticketData then return false end
	
	if pPlayer:CanAfford( ticketData.Price ) then
		pPlayer:TakeMoney( ticketData.Price )

		if not saveTable.Tickets.Paid then saveTable.Tickets.Paid = {} end
		table.insert( saveTable.Tickets.Paid, ticketData )
		if table.Count( saveTable.Tickets.Paid ) > GAMEMODE.Config.MaxTicketHistory then
			table.remove( saveTable.Tickets.Paid, 1 )
		end

		table.remove( saveTable.Tickets.Unpaid, intTicketIDX )
		--Save tickets NOW
		--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "Tickets", saveTable.Tickets )
		GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Tickets" )

		pPlayer:AddNote( "You paid for a ticket!" )
		
		return true
	end

	pPlayer:AddNote( "You can't afford to pay that ticket!" )

	return false
end

function GM.License:PlayerEnteredVehicle( pPlayer, entVeh )
	if entVeh.m_tblWaitingTicket and entVeh == GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer ) then
		if self:AddPlayerTicket( pPlayer, entVeh.m_tblWaitingTicket.Reason, entVeh.m_tblWaitingTicket.GivenBy, entVeh.m_tblWaitingTicket.Price ) then
			pPlayer:AddNote( "You found a ticket on your car for $".. string.Comma(entVeh.m_tblWaitingTicket.Price).. "!" )
			entVeh.m_tblWaitingTicket = nil
		end
	end
end

--[[ Data Management ]]--
function GM.License:ApplyLicenseData( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.License then return end

	if saveTable.License.RevokeTime then
		if saveTable.License.RevokeTime +saveTable.License.RevokeDuration < os.time() then
			saveTable.License.RevokeTime = nil
			saveTable.License.RevokeDuration = nil

			--Save removed data NOW
			--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "License", saveTable.License )
			GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "License" )
		end
	end

	if saveTable.License.RevokeTime then
		GAMEMODE.Player:SetSharedGameVar( pPlayer, "driver_license", "", true )
	else
		GAMEMODE.Player:SetSharedGameVar( pPlayer, "driver_license", saveTable.License.ID, true )
	end
end

function GM.License:UpdateLicenseData( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end

	saveTable.License = saveTable.License or {}
	saveTable.License.ID = GAMEMODE.Player:GetSharedGameVar( pPlayer, "driver_license", "unknown" )

	--Save license data NOW
	--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "License", saveTable.License )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "License" )
end


--[[ Data Format For Cop Computer ]]--
function GM.License:GetCopComputerData( pPlayer )
	local data = {}
	data.Dots = self:GetPlayerDots( pPlayer )
	data.PlateNumber = self:GetPlayerPlateNumber( pPlayer )
	data.UnpiadTickets = self:GetPlayerUnpiadTickets( pPlayer )
	data.PaidTickets = self:GetPlayerPaidTickets( pPlayer )

	return data
end

--[[ Game Vars ]]--
hook.Add( "GamemodeDefineGameVars", "DefineLicenseVars", function( pPlayer )
	GAMEMODE.Player:DefineSharedGameVar( pPlayer, "driver_license", "", "String", true )
end )

hook.Add( "GamemodePlayerSelectCharacter", "ApplyLicenseVars", function( pPlayer )
	GAMEMODE.License:ApplyLicenseData( pPlayer )
end )

concommand.Add( "srp_dev_givelicense", function( pPlayer )
	if not pPlayer:IsSuperAdmin() then return end
	GAMEMODE.License:GenerateLicense( pPlayer )
end )

concommand.Add( "srp_dev_removelicense", function( pPlayer )
	if not pPlayer:IsSuperAdmin() then return end
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	saveTable.License = nil

	GAMEMODE.Player:SetSharedGameVar( pPlayer, "driver_license", "" )
end )