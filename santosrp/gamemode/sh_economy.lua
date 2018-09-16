--[[
	Name: sh_economy.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Econ = (GAMEMODE or GM).Econ or {}

function GM.Econ:Load()
	self:LoadTaxes()
	self:LoadBills()

	if SERVER then
		self:LoadAutoBills()
	end
end

function GM.Econ:Tick()
	if SERVER then
		if (self.m_intLastBillTick or 0) < CurTime() then
			self.m_intLastBillTick = CurTime() +5

			for _, v in pairs( player.GetAll() ) do
				self:TickPlayerBills( v )
				self:TickAutoBills( v )
			end
		end
	end
end

-- Taxes
-- ----------------------------------------------------------------
GM.Econ.m_tblTaxes = (GM or GAMEMODE).Econ.m_tblTaxes or {}

function GM.Econ:LoadTaxes()
	self:RegisterTax( "fuel", {Name = "Fuel Tax", MinValue = 0, MaxValue = 1, Value = 0} )
	self:RegisterTax( "sales", {Name = "Sales Tax", MinValue = 0, MaxValue = 0.4, Value = 0} )
	self:RegisterTax( "car_insurance", {Name = "Vehicle Insurance Tax", MinValue = 0, MaxValue = 0.25, Value = 0} )

	self:RegisterTax( "prop_Stores", {Name = "Property Tax: Stores", MinValue = 0, MaxValue = 0.4, Value = 0} )
	self:RegisterTax( "prop_Warehouse", {Name = "Property Tax: Warehouses", MinValue = 0, MaxValue = 0.5, Value = 0} )
	self:RegisterTax( "prop_Apartments", {Name = "Property Tax: Apartments", MinValue = 0, MaxValue = 0.25, Value = 0} )
	self:RegisterTax( "prop_House", {Name = "Property Tax: Houses", MinValue = 0, MaxValue = 0.25, Value = 0} )

	for k, v in pairs( GM.Jobs:GetJobs() ) do
		self:RegisterTax( "income_".. k, {
			Name = "Income Tax: ".. v.Name,
			MinValue = 0,
			MaxValue = 0.25,
			Value = 0,
		} )
	end
end

function GM.Econ:RegisterTax( strTaxID, tblTaxData )
	self.m_tblTaxes[strTaxID] = tblTaxData
	tblTaxData.ID = strTaxID
end

function GM.Econ:GetTaxes()
	return self.m_tblTaxes
end

function GM.Econ:GetTaxData( strTaxID )
	return self.m_tblTaxes[strTaxID]
end

function GM.Econ:ApplyTaxToSum( strTaxID, intAmount, bSub )
	local data = self.m_tblTaxes[strTaxID]
	if not data then return intAmount end
	
	local taxValue = intAmount *(data.Value or 0)
	if bSub then taxValue = taxValue *-1 end
	return math.ceil( intAmount +taxValue )
end

function GM.Econ:GetTaxRate( strTaxID )
	if not self.m_tblTaxes[strTaxID] then return end
	return self.m_tblTaxes[strTaxID].Value or 0
end

if CLIENT then
	function GM.Econ:SetTaxRate( strTaxID, intRate )
		local oldValue = self.m_tblTaxes[strTaxID].Value or 0
		self.m_tblTaxes[strTaxID].Value = intRate
		self:OnTaxRateChanged( strTaxID, oldValue, intRate )
	end

	function GM.Econ:OnTaxRateChanged( strTaxID, intOldRate, intNewRate )
		hook.Call( "GamemodeOnTaxRateChanged", GAMEMODE, strTaxID, intOldRate, intNewRate )
	end
end

-- Bills
-- ----------------------------------------------------------------
GM.Econ.m_tblBills = (GM or GAMEMODE).Econ.m_tblBills or {}

if CLIENT then
	if not g_GamemodeUnPaidBills then g_GamemodeUnPaidBills = {} end
end

function GM.Econ:LoadBills()
	self:RegisterBillType(
		"property",
		function( pPlayer, tblBill, tblMetaData, intBillIDX )
			--OnPay
		end,
		function( pPlayer, tblBill, tblMetaData, intBillIDX  )
			--OnFailToPay
			--do nothing, this should never happen since we will only
			--issue bills of this type that never expire...
		end,
		function( pPlayer, tblBill, tblMetaData, intBillIDX )
			--Update
			if not tblMetaData.Shared.PropertyID then return end
			if os.time() > tblBill.IssueTime +GAMEMODE.Config.PropertyEvictTime then
				if GAMEMODE.Property:PlayerOwnsProperty( pPlayer, tblMetaData.Shared.PropertyID ) then
					GAMEMODE.Property:ResetProperty( tblMetaData.Shared.PropertyID )
					pPlayer:AddNote( "You have been evicted from ".. tblMetaData.Shared.PropertyID.. "!" )
					pPlayer:AddNote( "You are currently overdue on property tax payments." )
				end
			end
		end
	)

	self:RegisterBillType(
		"car_insurance",
		function( pPlayer, tblBill, tblMetaData, intBillIDX )
			--OnPay
		end,
		function( pPlayer, tblBill, tblMetaData, intBillIDX )
			--OnFailToPay
			local carID = tblMetaData.Shared.CarID
			if not carID or not GAMEMODE.Cars:GetCarByUID( carID ) then return end
			if not GAMEMODE.Cars:PlayerOwnsCar( pPlayer, carID ) then return end
			
			--Remove the car
			pPlayer:GetCharacter().Vehicles[carID] = nil
			GAMEMODE.Player:SetGameVar( pPlayer, "vehicles", pPlayer:GetCharacter().Vehicles )
			GAMEMODE.SQL:MarkDiffDirty( pPlayer, "vehicles" )

			local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
			if IsValid( curCar ) and curCar.UID == carID then
				curCar:Remove()
			end

			local data = GAMEMODE.Cars:GetCarByUID( carID )
			pPlayer:AddNote( "Your ".. data.Name.. " was repossessed due to outstanding insurance payments." )

			--Look for and remove other bills for the same car
			local bills = GAMEMODE.Econ:GetPlayerBills( pPlayer )
			if bills then
				for k, v in pairs( bills ) do
					if k == intBillIDX then continue end --this bill will be removed when our callback is done
					if v.Type == "car_insurance" and v.MetaData.Shared.CarID == carID then
						table.remove( bills, k )
					end
				end
			end
		end,
		function( pPlayer, tblBill, tblMetaData, intBillIDX )
			--Update
		end
	)
end

function GM.Econ:RegisterBillType( strBillID, funcOnBillPay, funcOnBillDefault, funcUpdate )
	self.m_tblBills[strBillID] = { OnPay = funcOnBillPay, OnDefault = funcOnBillDefault, Update = funcUpdate }
end

function GM.Econ:GetBillData( strBillID )
	return self.m_tblBills[strBillID]
end

function GM.Econ:GetPlayerBills( pPlayer )
	if SERVER then
		local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
		if not saveTable then return end
		return saveTable.Bills
	else
		return g_GamemodeUnPaidBills or {}
	end
end

if SERVER then
	function GM.Econ:PlayerHasUnpaidBillsOfType( pPlayer, strBillID )
		local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
		if not saveTable or not saveTable.Bills then return false end

		for k, v in pairs( saveTable.Bills ) do
			if v.Type == strBillID then
				return true
			end
		end

		return false
	end
else
	function GM.Econ:PlayerHasUnpaidBillsOfType( strBillID )
		for k, v in pairs( g_GamemodeUnPaidBills or {} ) do
			if v.Type == strBillID then
				return true
			end
		end
	end
end