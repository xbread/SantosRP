--[[
	Name: sv_chop_shop.lua
	For: TalosLife
	By: TalosLife
]]--

GM.ChopShop = (GM or GAMEMODE).ChopShop or {}
GM.ChopShop.m_tblCars = (GM or GAMEMODE).ChopShop.m_tblCars or {}
GM.ChopShop.m_tblPlayers = (GM or GAMEMODE).ChopShop.m_tblPlayers or {}
GM.ChopShop.m_tblChopping = (GM or GAMEMODE).ChopShop.m_tblChopping or {}

function GM.ChopShop:FindCarToChop( pPlayer )
	for k, v in pairs( ents.FindInSphere(GAMEMODE.Config.ChopShop_ChopLocation, 256) ) do
		if not IsValid( v ) or not v:IsVehicle() or not v.UID then continue end
		if pPlayer.m_entLastVehicle ~= v then continue end
		if v.Job then return end
		
		if v.m_intChopStart then continue end
		return v
	end
end

function GM.ChopShop:PlayerChopCar( pPlayer )
	local entCar = self:FindCarToChop( pPlayer )
	if not IsValid( entCar ) then return 0 end
	if entCar:GetPlayerOwner() == pPlayer then return 1 end
	if not self:PlayerCanChopCar( pPlayer, entCar ) then return 2 end
	
	entCar.m_intChopStart = CurTime()
	entCar.m_pStolenBy = pPlayer
	entCar.m_strStolenBy = pPlayer:SteamID64()

	self.m_tblChopping[entCar] = true
	self.m_tblPlayers[pPlayer:SteamID64()] = CurTime()

	local ownerID = entCar:GetPlayerOwner():SteamID64()
	self.m_tblCars[ownerID] = self.m_tblCars[ownerID] or {}
	self.m_tblCars[ownerID][entCar.UID] = CurTime()

	pPlayer:AddNote( "You stated chopping a car!" )
	pPlayer:SetNWFloat( "chop_shop_timer", CurTime() )
	pPlayer:SetNWFloat( "chop_duration", GAMEMODE.Config.ChopShop_CarChopDuration )

	return 3
end

--Checks if a player can chop a car
function GM.ChopShop:PlayerCanChopCar( pPlayer, entCar )
	if entCar.m_intChopStart then return false end --Already being chopped
	if entCar.Job or not entCar.UID then return false end

	if self.m_tblPlayers[pPlayer:SteamID64()] then --Chopped a car before
		if CurTime() > self.m_tblPlayers[pPlayer:SteamID64()] +GAMEMODE.Config.ChopShop_CarStealCooldown then --Cooldown ran out
			self.m_tblPlayers[pPlayer:SteamID64()] = nil
			return true
		else
			local timeLeft = ((self.m_tblPlayers[pPlayer:SteamID64()] +GAMEMODE.Config.ChopShop_CarStealCooldown) -CurTime()) /60
			pPlayer:AddNote( ("You must wait %s minutes before chopping another car."):format(math.Round(timeLeft, 0)) )
		end
	end

	return not self.m_tblPlayers[pPlayer:SteamID64()]
end

--Checks if a player's car was stolen
function GM.ChopShop:IsCarStolen( pPlayer, strCarUID )
	local ownerID = pPlayer:SteamID64()
	if not self.m_tblCars[ownerID] then return false end
	if not self.m_tblCars[ownerID][strCarUID] then return false end
	
	if CurTime() > self.m_tblCars[ownerID][strCarUID] +GAMEMODE.Config.ChopShop_CarStealDuration then
		self.m_tblCars[ownerID][strCarUID] = nil
		return false
	end

	return true
end

function GM.ChopShop:GetStolenCarTimeLeft( pPlayer, strCarUID )
	local ownerID = pPlayer:SteamID64()
	if not self.m_tblCars[ownerID] then return end
	if not self.m_tblCars[ownerID][strCarUID] then return end
	return (self.m_tblCars[ownerID][strCarUID] +GAMEMODE.Config.ChopShop_CarStealDuration) -CurTime()
end

function GM.ChopShop:Tick()
	if not self.m_intLastThink then self.m_intLastThink = 0 end
	if self.m_intLastThink > CurTime() then return end
	self.m_intLastThink = CurTime() +1

	for k, v in pairs( self.m_tblChopping ) do
		if not IsValid( k ) or not k.m_strStolenBy or not IsValid( k.m_pStolenBy ) or k:GetPos():Distance( GAMEMODE.Config.ChopShop_ChopLocation ) > 256 or not k.m_pStolenBy:Alive() then
			if k and k.m_strStolenBy then
				self.m_tblPlayers[k.m_strStolenBy] = nil
			end --failed to chop it, reset this so they can try again

			if IsValid( k.m_pStolenBy ) then
				k.m_pStolenBy:AddNote( "Your car is no longer being chopped." )
				k.m_pStolenBy:SetNWFloat( "chop_shop_timer", -1 )
			end

			self.m_tblChopping[k] = nil --unref from chop table
			if IsValid( k ) then
				k.m_intChopStart = nil --remove data
				k.m_pStolenBy = nil --remove data
				k.m_strStolenBy = nil --remove data
			end

			continue
		end

		if CurTime() > k.m_intChopStart +GAMEMODE.Config.ChopShop_CarChopDuration then
			local money = GAMEMODE.Cars:CalcVehicleValue( k ) *0.02
			k.m_pStolenBy:AddNote( "You earend $".. money.. " for chopping a car!" )
			k.m_pStolenBy:AddMoney( money )
			self.m_tblChopping[k] = nil --unref from chop table
			k:Remove()
		end
	end
end

hook.Add( "PlayerEnteredVehicle", "TrackChopCar", function( pPlayer, entVeh )
	if entVeh.m_intChopStart then
		GAMEMODE.ChopShop.m_tblPlayers[entVeh.m_strStolenBy] = nil --failed to chop it, reset this so they can try again
		GAMEMODE.ChopShop.m_tblChopping[entVeh] = nil --unref from chop table

		if IsValid( entVeh.m_pStolenBy ) then
			entVeh.m_pStolenBy:AddNote( "Your car is no longer being chopped." )
			entVeh.m_pStolenBy:SetNWFloat( "chop_shop_timer", -1 )
		end

		if IsValid( entVeh ) then
			entVeh.m_intChopStart = nil --remove data
			entVeh.m_pStolenBy = nil --remove data
			entVeh.m_strStolenBy = nil --remove data
		end	
	end
end )

hook.Add( "PlayerLeaveVehicle", "TrackChopCar", function( pPlayer, entVeh )
	pPlayer.m_entLastVehicle = entVeh
end )

hook.Add( "GamemodePlayerCanSpawnCar", "BlockStolenCars", function( pPlayer, strCarUID )
	if GAMEMODE.ChopShop:IsCarStolen( pPlayer, strCarUID ) then
		local timeLeft = ((GAMEMODE.ChopShop.m_tblPlayers[pPlayer:SteamID64()] +GAMEMODE.Config.ChopShop_CarStealCooldown) -CurTime()) /60
		pPlayer:AddNote( "This car was stolen and destroyed at a chop shop!" )
		pPlayer:AddNote( ("You must wait %s minutes before insurance replaces this car."):format(math.Round(timeLeft, 0)) )

		return false
	end
end )