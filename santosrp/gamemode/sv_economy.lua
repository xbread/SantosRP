--[[
	Name: sv_economy.lua
	For: TalosLife
	By: TalosLife
]]--

hook.Add( "GamemodePlayerSelectCharacter", "NetworkEconData", function( pPlayer )
	timer.Simple( 30, function()
		if not IsValid( pPlayer ) then return end
		GAMEMODE.Net:SendPlayerBills( pPlayer )
		GAMEMODE.Net:SendTaxFullUpdate( pPlayer )
	end )

	timer.Simple( 5, function()
		if not IsValid( pPlayer ) then return end
		for k, v in pairs( GAMEMODE.Econ.m_tblBills ) do
			if GAMEMODE.Econ:PlayerHasUnpaidBillsOfType( pPlayer, k ) then
				pPlayer:AddNote( "You currently have unpaid bills! Be sure to pay for them at the bank.", NOTIFY_ERROR, 20 )
				break
			end
		end
	end )
end )

-- Taxes
-- ----------------------------------------------------------------
function GM.Econ:SetTaxRate( strTaxID, intRate, bNoNetwork )
	local data = self.m_tblTaxes[strTaxID]
	if not data then return false end
	
	intRate = math.Clamp( intRate, data.MinValue, data.MaxValue )
	local oldValue = data.Value or 0
	data.Value = intRate

	if not bNoNetwork then
		GAMEMODE.Net:SendTaxUpdate( nil, strTaxID )
		self:CommitTaxData()
	end
	
	self:OnTaxRateChanged( strTaxID, oldValue, data.Value )
	return true
end

function GM.Econ:OnTaxRateChanged( strTaxID, intOldValue, intNewValue )
	hook.Call( "GamemodeOnTaxRateChanged", GAMEMODE, strTaxID, intOldValue, intNewValue )
end

function GM.Econ:CommitTaxData()
	local num, done = table.Count( self.m_tblTaxes ), 0
	local callback = function( tblData, q )
		done = done +1
		if done == num then
			GAMEMODE.ServerNet:BroadcastTaxesChanged()
		end
	end

	for k, v in pairs( self.m_tblTaxes ) do
		GAMEMODE.SQL:PooledQueryWrite( 2, ([[INSERT INTO gamemode_taxes (`key`, value) VALUES ('%s', %1.2f) ON DUPLICATE KEY UPDATE value=%1.2f]]):format(
			k,
			v.Value,
			v.Value
		), callback )
	end
end

function GM.Econ:LoadSavedTaxData()
	GAMEMODE.SQL:QueryReadOnly( [[SELECT * FROM gamemode_taxes]], function( tblData, q )
		for k, row in pairs( tblData ) do
			GAMEMODE.Econ:SetTaxRate( row.key, row.value, true )
		end

		GAMEMODE.Net:SendTaxFullUpdate()
	end )
end

-- Bills
-- ----------------------------------------------------------------
--intTimeToPay = 0 for a bill that never expires
GM.Econ.m_tblAutoBills = (GAMEMODE or GM).Econ.m_tblAutoBills or {}

function GM.Econ:RegisterAutoBill( strUID, intDuration, funcBillPlayer )
	self.m_tblAutoBills[strUID] = { Length = intDuration, BillPlayer = funcBillPlayer }
end

function GM.Econ:LoadAutoBills()
	self:RegisterAutoBill( "bill_cars", GM.Config.CarInsuranceTaxInterval, function( pPlayer )
		if not pPlayer:GetCharacter() then return end
		local bill = false
		for k, v in pairs( pPlayer:GetCharacter().Vehicles ) do
			local data = GAMEMODE.Cars:GetCarByUID( k )
			if not data then continue end
			local billCost = math.ceil( GAMEMODE.CarShop:GetRepairCost(data.Price, 0, 100) *GAMEMODE.Config.CarInsuranceBillScale )
			self:IssuePlayerBill(
				pPlayer,
				"car_insurance",
				"Vehicle Insurance: ".. data.Name,
				billCost,
				GAMEMODE.Config.CarInsuranceBillTime,
				{ Shared = {CarID = k} }
			)
			bill = true
		end

		if bill then pPlayer:AddNote( "You have new car insurance bills waiting at the bank." ) end
	end )

	self:RegisterAutoBill( "bill_property", GM.Config.PropertyTaxInterval, function( pPlayer )
		if not pPlayer:GetCharacter() then return end
		local bill = false
		for k, v in pairs( GAMEMODE.Property:GetPropertiesByOwner(pPlayer) ) do
			local data = GAMEMODE.Property.m_tblRegister[GAMEMODE.Property:GetPropertyByName(v).ID]
			if not data or not data.Price or not data.Cat then continue end
			local billCost = GAMEMODE.Econ:ApplyTaxToSum( "prop_".. data.Cat, data.Price *GAMEMODE.Config.PropertyTaxScale )
			self:IssuePlayerBill(
				pPlayer,
				"property",
				"Property Tax: ".. data.Name,
				billCost,
				0,
				{ Shared = {PropertyID = v} }
			)
			bill = true
		end

		if bill then pPlayer:AddNote( "You have new property bills waiting at the bank." ) end
	end )
end

function GM.Econ:IssuePlayerBill( pPlayer, strBillID, strBillName, intBillCost, intTimeToPay, tblMetaData )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return false end
	saveTable.Bills = saveTable.Bills or {}

	local bill = {
		Type = strBillID,
		Name = strBillName,
		Cost = intBillCost,
		LifeTime = intTimeToPay,
		IssueTime = os.time(),
		MetaData = tblMetaData
	}
	local billUID = table.insert( saveTable.Bills, bill )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Bills" )
	GAMEMODE.Net:SendPlayerBills( pPlayer )

	return billUID
end

function GM.Econ:PlayerPayBill( pPlayer, intBillIDX )
	--intBillIDX is the key of the bill being paid in the save table
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Bills then return false end

	local billData = saveTable.Bills[intBillIDX]
	if not billData then return false end
	
	local typeData = self:GetBillData( billData.Type )
	if not typeData then return false end
	
	if not pPlayer:CanAfford( billData.Cost ) then
		pPlayer:AddNote( "You cannot afford to pay that bill!" )
		return false
	end

	pPlayer:TakeMoney( billData.Cost )
	typeData.OnPay( pPlayer, billData, billData.MetaData, intBillIDX )
	table.remove( saveTable.Bills, intBillIDX )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Bills" )
	GAMEMODE.Net:SendPlayerBills( pPlayer )
	pPlayer:AddNote( "You paid off a bill for $".. string.Comma(billData.Cost).. "!" )
	return true
end

function GM.Econ:PlayerPayAllBills( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Bills then return false end
	
	local total = 0
	for k, v in pairs( saveTable.Bills ) do
		total = total +v.Cost
	end
	if total <= 0 then return end

	if not pPlayer:CanAfford( total ) then
		pPlayer:AddNote( "You cannot afford to pay all of your bills!" )
		return false
	end

	pPlayer:TakeMoney( total )
	for k, v in pairs( saveTable.Bills ) do
		if not self:GetBillData( v.Type ) then continue end
		self:GetBillData( v.Type ).OnPay( pPlayer, v, v.MetaData, k )
	end

	saveTable.Bills = {}
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Bills" )
	GAMEMODE.Net:SendPlayerBills( pPlayer )
	pPlayer:AddNote( "You paid all of your bills for $".. string.Comma(total).. "!" )
	return true
end

function GM.Econ:OnPlayerBillExpired( pPlayer, intBillIDX )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Bills then return false end

	local billData = saveTable.Bills[intBillIDX]
	if not billData then return false end
	
	local typeData = self:GetBillData( billData.Type )
	if not typeData then return false end
	
	typeData.OnDefault( pPlayer, billData, billData.MetaData, intBillIDX )
	table.remove( saveTable.Bills, intBillIDX )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Bills" )
	GAMEMODE.Net:SendPlayerBills( pPlayer )

	return true
end

function GM.Econ:TickPlayerBills( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Bills then return end

	local time = os.time()
	for uid, billData in pairs( saveTable.Bills ) do
		local data = self.m_tblBills[billData.Type]
		if not data then continue end
		
		if data.Update then
			if time > (billData.LastUpdate or 0) then
				billData.LastUpdate = time +5
				data.Update( pPlayer, billData, billData.MetaData, uid )
			end
		end

		if billData.LifeTime <= 0 then continue end --This bill never expires until paid
		if time > (billData.IssueTime +billData.LifeTime) then --This bill has passed the expiry point!
			self:OnPlayerBillExpired( pPlayer, uid )
		end
	end
end

function GM.Econ:TickAutoBills( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	
	local dirty = not saveTable.AutoBills
	saveTable.AutoBills = saveTable.AutoBills or {}
	local playTime = GAMEMODE.Jobs:GetTotalSavedPlayTime( pPlayer )

	for billID, v in pairs( self.m_tblAutoBills ) do
		if not saveTable.AutoBills[billID] then
			saveTable.AutoBills[billID] = playTime
			dirty = true
			continue
		end

		if playTime >= saveTable.AutoBills[billID] +v.Length then
			saveTable.AutoBills[billID] = playTime
			dirty = true
			v.BillPlayer( pPlayer )
		end
	end

	if dirty then
		GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "AutoBills" )
	end
end

hook.Add( "GamemodeCanPlayerBuyProperty", "Bills_UnpiadBlockPurchase", function( pPlayer, strPropName )
	if GAMEMODE.Econ:PlayerHasUnpaidBillsOfType( pPlayer, "property" ) then
		pPlayer:AddNote( "You currently have unpaid property taxes!" )
		pPlayer:AddNote( "You must pay your bills before you can purchase a new property." )
		return false
	end
end )

hook.Add( "GamemodeInitSQLTables", "DefineLoadEconData", function()
	GAMEMODE.SQL:PooledQueryWrite( 1, [[CREATE TABLE IF NOT EXISTS `gamemode_taxes` (
		`key` VARCHAR(255) NOT NULL,
		`value` FLOAT NULL,
		UNIQUE INDEX `key` (`key`)
	) ENGINE=InnoDB;]], function()
		GAMEMODE.Econ:LoadSavedTaxData()
	end )
end )