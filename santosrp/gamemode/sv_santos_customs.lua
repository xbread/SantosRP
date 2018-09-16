--[[
	Name: sv_santos_customs.lua
	For: TalosLife
	By: TalosLife
]]--

util.AddNetworkString "carShop"

local PAINT_COST = 300
local SKIN_COST = 500
local BODYGROUP_COST = 500
local STREETGLOW_COST = 750

GM.CarShop = GM.CarShop or {}
GM.CarShop.OPEN_MENU = 0
GM.CarShop.CLOSE_MENU = 1
GM.CarShop.PICK_COLOR = 2
GM.CarShop.PICK_BODYGROUP = 3
GM.CarShop.PICK_SKIN = 4
GM.CarShop.SYNC_CLIENT = 5
GM.CarShop.SEND_UPGRADES = 6
GM.CarShop.BUY_UPGRADE = 7
GM.CarShop.UPDATE_GLOW = 8
GM.CarShop.FIX_CAR = 9

GM.CarShop.DOOR_OPEN_RANGE = 225
GM.CarShop.m_tblNetActions = {}
GM.CarShop.m_tblDoors = {}
GM.CarShop.m_tblGarage = {}

function GM.CarShop:Initialize()
	self:GetDoors()

	timer.Create( "CarShop_DoorLogic", 1, 0, function()
		self:UpdateDoors()
	end )

	timer.Create( "CarShop_PlayerLogic", 1, 0, function()
		self:CheckForPlayers()
	end )
end

function GM.CarShop:GetDoors()
	local doorTbl = self.m_tblGarage[game.GetMap():gsub(".bsp", "")]
	if not doorTbl then return error( "[CarShop] No doors listed for the current map!" ) end
	
	if doorTbl.NoDoors then
		self.m_bNoDoors = true
		for k, v in pairs( doorTbl.CarPos ) do
			self.m_tblDoors[k] = { NoDoors = true, CarPos = v, Ply = nil }
		end
	else
		for k, ent in pairs( ents.GetAll() ) do
			if not IsValid( ent ) then continue end
			local data = doorTbl.Doors[ent:GetName()]

			if data then
				self.m_tblDoors[ent:EntIndex()] = { Ent = ent, CarPos = data.CarPos, Ply = nil, m_bOpen = false }
				ent:Fire( "Close", "1" )
			end
		end
	end
end

function GM.CarShop:UpdateDoors()
	if self.m_bNoDoors then return end
	
	for k, v in pairs( self.m_tblDoors ) do
		if IsValid( v.Ply ) and IsValid( v.Car ) then
			if v.m_bOpen then
				v.Ent:Fire( "Close", "1" )
				v.m_bOpen = false
			else
				if v.Car:GetPos():Distance( v.CarPos ) > 400 then
					self:PlayerExitShop( pPlayer )
				end
			end
			
			continue
		elseif (v.Ply or v.Car) and not IsValid( v.Ply ) or not IsValid( v.Car ) then
			v.Ply = nil
			v.Car = nil
		end

		local hasCar = false
		for _, ent in pairs( ents.FindInSphere(v.Ent:GetPos(), self.DOOR_OPEN_RANGE) ) do
			if not IsValid( ent ) or not ent:IsVehicle() then continue end
			if ent:GetClass() ~= "prop_vehicle_jeep" then continue end

			hasCar = true
			if not v.m_bOpen then
				v.Ent:Fire( "Open", "1" )
				v.m_bOpen = true
			end
		end

		if not hasCar and v.m_bOpen and not v.Ent.BlockClose then
			v.Ent:Fire( "Close", "1" )
			v.m_bOpen = false
		end
	end
end

function GM.CarShop:CheckForPlayers()
	--[[local boundBox = self.m_tblGarage[game.GetMap():gsub(".bsp", "")].BBox
	for k, v in pairs( ents.FindInBox(boundBox.Min, boundBox.Max) ) do
		if v:IsPlayer() and not v:GetVehicle() then
			v:SetPos( self.m_tblGarage[game.GetMap():gsub(".bsp", "")].PlayerSetPos )
			continue
		end
	end]]--

	for k, v in pairs( self.m_tblDoors ) do
		if IsValid( v.Ply ) and IsValid( v.Car ) then continue end
		
		local hasCar = false
		for _, ent in pairs( ents.FindInSphere(v.CarPos, 8) ) do
			if not IsValid( ent ) or not ent:IsVehicle() or not IsValid( ent:GetDriver() ) then continue end
			if ent:GetClass() ~= "prop_vehicle_jeep" then continue end
			if self.m_bNoDoors or not v.Ent.BlockClose then
				if not ent:GetDriver().m_bBlockCustomsMenu then
					self:PlayerEnterShop( ent:GetDriver(), k )
				end
			end
			
			hasCar = true
		end

		if not self.m_bNoDoors then
			v.Ent.BlockClose = hasCar
		end
	end
end

function GM.CarShop:PlayerEnterShop( pPlayer, intDoorIndex )
	if not self.m_tblDoors[intDoorIndex] then return end
	if not self.m_bNoDoors and not IsValid( self.m_tblDoors[intDoorIndex].Ent ) then return end
	if not IsValid( GAMEMODE.Cars:GetCurrentPlayerCar(pPlayer) ) then return end
	if not pPlayer:InVehicle() then return end
	
	if GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer ).Job then
		pPlayer:AddNote( "You can't customize a job vehicle!" )
		return
	end

	if not GAMEMODE.Cars:PlayerOwnsCar( pPlayer, GAMEMODE.Cars:GetCurrentPlayerCar(pPlayer).UID ) then
		return
	end

	if pPlayer:GetVehicle():GetPlayerOwner() ~= pPlayer then
		pPlayer:AddNote( "You can't customize a vehicle you don't own!" )
		return
	end
	
	self.m_tblDoors[intDoorIndex].Ply = pPlayer
	self.m_tblDoors[intDoorIndex].Car = pPlayer:GetVehicle()
	pPlayer:Lock()
	pPlayer:GetVehicle():Fire( "TurnOff", "1" )
	pPlayer:GetVehicle():Fire( "HandBrakeOn", "1" )
	pPlayer.m_bIsInCarShop = true

	self:NetworkOpenCarMenu( pPlayer )
end

function GM.CarShop:PlayerExitShop( pPlayer )
	for k, v in pairs( self.m_tblDoors ) do
		if not IsValid( v.Ply ) or v.Ply ~= pPlayer then continue end
		v.Ply.m_bBlockCustomsMenu = true
		local pl = v.Ply
		timer.Simple( 8, function() if not IsValid( pl ) then return end pl.m_bBlockCustomsMenu = nil end )

		self.m_tblDoors[k].Ply = nil
		self.m_tblDoors[k].Car = nil

		if not self.m_bNoDoors then
			self.m_tblDoors[k].Ent.BlockClose = true
			self.m_tblDoors[k].m_bOpen = false
		end
		
		self:NetworkCloseCarMenu( pPlayer )
		pPlayer:UnLock()
		pPlayer:GetVehicle():Fire( "TurnOn", "1" )
		pPlayer.m_bIsInCarShop = false

		--restore some data
		local car = pPlayer:GetVehicle()
		local tblCarCol = car:GetColor()

		net.Start( "carShop" )
			net.WriteUInt( self.SYNC_CLIENT, 8 )
			net.WriteColor( Color(tblCarCol.r, tblCarCol.g, tblCarCol.b, 255) )
			net.WriteUInt( car:GetSkin(), 8 )
			net.WriteUInt( 0, 8 )
		net.Send( pPlayer )

		--save the changes
		self:PlayerSaveCarChanges( pPlayer )

		break
	end
end

--[[ Upgrades ]]--
function GM.CarShop:ApplyUpgradeTable( entCar, tblUpgrades )
	local params = {}
	for strType, strValue in pairs( tblUpgrades ) do
		GAMEMODE.Cars:ApplyVehicleUpgradeParams( self.m_tblUpgrades[strType][strValue].Params, params )
	end

	GAMEMODE.Cars:ApplyVehicleParams( entCar, "VehicleUpgrades", params )
end

function GM.CarShop:InitCarUpgrades( pPlayer, entCar )
	local carData = GAMEMODE.Cars:GetPlayerCarData( pPlayer, entCar.UID )
	if carData then
		entCar.m_tblUpgrades = carData.upgrades or {}
	else
		entCar.m_tblUpgrades = {}
	end

	for k, v in pairs( self.m_tblUpgrades ) do
		if not entCar.m_tblUpgrades[k] then
			for part, data in pairs( v ) do
				if data.StockPart then
					entCar.m_tblUpgrades[k] = part
					break
				end
			end 
		end
	end

	self:ApplyUpgradeTable( entCar, entCar.m_tblUpgrades )
	self:NetworkCarUpgrades( pPlayer, entCar )

	entCar:SetColor( carData.color or Color(255, 255, 255) )
	entCar:SetSkin( carData.skin or 0 )
	for k, v in pairs( carData.bgroups or {} ) do
		entCar:SetBodygroup( k, v )
	end

	if carData.glowcolor then
		entCar:SetNWVector( "glow_col", carData.glowcolor )
		entCar:SetNWBool( "glow_on", false )
	end
end

function GM.CarShop:PlayerBuyUpgrade( pPlayer, strType, strKey )
	if not self.m_tblUpgrades[strType] then return end
	if not self.m_tblUpgrades[strType][strKey] then return end
	
	local upgrade = self.m_tblUpgrades[strType][strKey]
	if not upgrade then return end

	if upgrade.VIP and not pPlayer:CheckGroup( "vip" ) then
		pPlayer:AddNote( "You are not a VIP, sorry!" )
		return
	end

	local carData = pPlayer:GetVehicle().m_tblUpgrades
	if not carData then return end
	
	if carData[strType] == strKey then
		pPlayer:AddNote( "You already have that upgrade!" )
		return
	end

	local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", upgrade.Price )
	if pPlayer:GetMoney() -price < 0 then
		pPlayer:AddNote( "You can't afford that!" )
		return
	end
	
	carData[strType] = strKey
	pPlayer:TakeMoney( price )
	self:ApplyUpgradeTable( pPlayer:GetVehicle(), carData )
	self:NetworkCarUpgrades( pPlayer, pPlayer:GetVehicle() )

	pPlayer:AddNote( "You purchased the ".. strKey.. " upgrade!" )
end

function GM.CarShop:PlayerUpdateUnderglow( pPlayer, bEnable, colColor )
	local car = pPlayer:GetVehicle()
	if not IsValid( car ) then return end
	
	if not pPlayer:CheckGroup( "vip" ) then
		pPlayer:AddNote( "You are not a VIP, sorry!" )
		return
	end
	
	if not bEnable then
		car:SetNWVector( "glow_col", Vector(-1, -1, -1) )
	else
		local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", STREETGLOW_COST )
		if pPlayer:GetMoney() -price < 0 then
			pPlayer:AddNote( "You can't afford that!" )
			return
		end

		pPlayer:TakeMoney( price )

		car:SetNWVector( "glow_col", Vector(
			math.Clamp( colColor.r, 0, 255 ),
			math.Clamp( colColor.g, 0, 255 ),
			math.Clamp( colColor.b, 0, 255 )
		) )
	end
end

function GM.CarShop:PlayerSaveCarChanges( pPlayer )
	local car = pPlayer:GetVehicle()
	local carName = car.UID
	if not carName then return end

	local carData = GAMEMODE.Cars:GetPlayerCarData( pPlayer, carName ) or {}
	carData.color = car:GetColor()
	carData.skin = car:GetSkin()

	local tbl = {}
	for k, v in pairs( car:GetBodyGroups() ) do
		tbl[v.id] = car:GetBodygroup( v.id )
	end
	carData.bgroups = tbl
	carData.upgrades = car.m_tblUpgrades or {}
	carData.glowcolor = car:GetNWVector( "glow_col" )

	pPlayer:GetCharacter().Vehicles[carName] = carData
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "vehicles" )
end

--[[ Netcode ]]--
function GM.CarShop:AddNetworkAction( intTypeID, fnFunc )
	self.m_tblNetActions[intTypeID] = fnFunc
end

net.Receive( "carShop", function( intMsgLen, pPlayer )
	for k, v in pairs( GAMEMODE.CarShop.m_tblDoors ) do
		if v.Ply == pPlayer then
			local typeID = net.ReadUInt( 8 )
			local func = GAMEMODE.CarShop.m_tblNetActions[typeID]
			if not func then return end
			func( pPlayer )

			break
		end
	end
end )

function GM.CarShop:NetworkOpenCarMenu( pPlayer )
	net.Start( "carShop" )
		net.WriteUInt( self.OPEN_MENU, 8 )
	net.Send( pPlayer )
end

function GM.CarShop:NetworkCloseCarMenu( pPlayer )
	net.Start( "carShop" )
		net.WriteUInt( self.CLOSE_MENU, 8 )
	net.Send( pPlayer )
end

function GM.CarShop:NetworkCarUpgrades( pPlayer, entCar )
	net.Start( "carShop" )
		net.WriteUInt( self.SEND_UPGRADES, 8 )
		net.WriteEntity( entCar )
		net.WriteTable( entCar.m_tblUpgrades )
	net.Send( pPlayer )
end

--Player pushed the close button
GM.CarShop:AddNetworkAction( GM.CarShop.CLOSE_MENU, function( pPlayer )
	if not pPlayer.m_bIsInCarShop then return end
	GAMEMODE.CarShop:PlayerExitShop( pPlayer )
	GAMEMODE.CarShop:NetworkCloseCarMenu( pPlayer )
end )

--Player picks a new paint color
GM.CarShop:AddNetworkAction( GM.CarShop.PICK_COLOR, function( pPlayer )
	if not GAMEMODE.Cars:PlayerHasCar( pPlayer ) then return end
	local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", PAINT_COST )
	if pPlayer:GetMoney() -price < 0 then
		pPlayer:AddNote( "You can't afford that!" )
		return
	end

	local newColor = net.ReadColor()
	pPlayer.m_entCurrentCar:SetColor( newColor )
	pPlayer:TakeMoney( price )
	pPlayer:AddNote( "You purchased a new paint job!" )
end )

--Player sets a bodygroup
GM.CarShop:AddNetworkAction( GM.CarShop.PICK_BODYGROUP, function( pPlayer )
	if not pPlayer:CheckGroup( "vip" ) then
		return
	end
	
	if not GAMEMODE.Cars:PlayerHasCar( pPlayer ) then return end
	--Sub model group
	local numGroups = pPlayer.m_entCurrentCar:GetNumBodyGroups()
	local selectedGroup = net.ReadUInt( 8 )
	if selectedGroup > numGroups or numGroups < selectedGroup then return end

	--Selected sub model
	local numSubModels = pPlayer.m_entCurrentCar:GetBodygroupCount( selectedGroup )
	local selectedSubModel = net.ReadUInt( 8 )
	if selectedSubModel > numSubModels or numSubModels < selectedSubModel then return end

	local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", BODYGROUP_COST )
	if pPlayer:GetMoney() -price < 0 then
		pPlayer:AddNote( "You can't afford that!" )
		return
	end

	pPlayer.m_entCurrentCar:SetBodygroup( selectedGroup, selectedSubModel )
	pPlayer:TakeMoney( price )
	pPlayer:AddNote( "You purchased a new body group!" )
end )

--Player picks a new skin
GM.CarShop:AddNetworkAction( GM.CarShop.PICK_SKIN, function( pPlayer )
	if not pPlayer:CheckGroup( "vip" ) then
		return
	end

	if not GAMEMODE.Cars:PlayerHasCar( pPlayer ) then return end
	local numSkins = pPlayer.m_entCurrentCar:SkinCount() -1
	local selectedSkin = net.ReadUInt( 8 )

	if selectedSkin > numSkins or numSkins < selectedSkin then return end
	local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", SKIN_COST )
	if pPlayer:GetMoney() -price < 0 then
		pPlayer:AddNote( "You can't afford that!" )
		return
	end
	
	pPlayer.m_entCurrentCar:SetSkin( selectedSkin )
	pPlayer:TakeMoney( price )
	pPlayer:AddNote( "You purchased a new skin!" )
end )

--Player buys an upgrade
GM.CarShop:AddNetworkAction( GM.CarShop.BUY_UPGRADE, function( pPlayer )
	if not GAMEMODE.Cars:PlayerHasCar( pPlayer ) then return end
	GAMEMODE.CarShop:PlayerBuyUpgrade( pPlayer, net.ReadString(), net.ReadString() )
end )

--Player buys/removes streetglow
GM.CarShop:AddNetworkAction( GM.CarShop.UPDATE_GLOW, function( pPlayer )
	if not pPlayer:CheckGroup( "vip" ) then
		return
	end
	
	if not GAMEMODE.Cars:PlayerHasCar( pPlayer ) then return end
	local b = net.ReadBit() == 1
	GAMEMODE.CarShop:PlayerUpdateUnderglow( pPlayer, b, b and net.ReadColor() or nil )
end )

--Player wants to fix their car
GM.CarShop:AddNetworkAction( GM.CarShop.FIX_CAR, function( pPlayer )
	if not GAMEMODE.Cars:PlayerHasCar( pPlayer ) then return end
	
	local car = pPlayer:GetVehicle()
	local cur = GAMEMODE.Cars:GetCarHealth( car )
	local max = GAMEMODE.Cars:GetCarMaxHealth( car )
	local hasWheelDamage = GAMEMODE.Cars:HasDamagedWheels( car )
	if cur >= max and not hasWheelDamage then
		pPlayer:AddNote( "There is nothing wrong with this car." )
		return
	end
	
	local cost = GAMEMODE.Cars:CalcVehicleValue( car )
	cost = GAMEMODE.CarShop:GetRepairCost( cost, cur, max )

	if not pPlayer:CanAfford( cost ) then
		pPlayer:AddNote( "You can't afford that!" )
		return
	end

	pPlayer:TakeMoney( cost )
	GAMEMODE.Cars:FixVehicleWheels( car )
	GAMEMODE.Cars:ResetCarHealth( car )
	pPlayer:AddNote( "You spent $".. cost.. " fixing your car." )
end )

-- ----------------------------------------------------------

hook.Add( "InitPostEntity", "SetupCarShop", function()
	GAMEMODE.CarShop:Initialize()
end )

hook.Add( "PlayerSpawnedVehicle", "ApplyCarUpgrades", function( pPlayer, entCar )
	if not GAMEMODE.Cars:PlayerOwnsCar( pPlayer, entCar.UID ) then return end
	GAMEMODE.CarShop:InitCarUpgrades( pPlayer, entCar )

	for k, v in pairs( list.Get("Vehicles") ) do
		if v.Model ~= entCar:GetModel() then continue end
		
		local data = file.Read(v.KeyValues.vehiclescript, "GAME")
		local x, y = data:find( "Vehicle_Sounds" )
		data = data:sub( x -1 )

		--find gear 3
		local exploded = string.Explode("\n", data)
		local foundLine = ""
		for k, v in pairs( exploded ) do
			if v:find( "\"SS_GEAR_3\"" ) then
				foundLine = exploded[k+1]
				break
			end
		end

		foundLine = foundLine:gsub("\"Sound\"", ""):Trim():gsub( "\"", "" )
		if foundLine ~= "" then
			entCar.BoostSound = foundLine
		end
		
		break
	end
end )

hook.Add( "Tick", "BoostSound", function()
	for k, v in pairs( ents.FindByClass("prop_vehicle_jeep") ) do
		if not IsValid( v ) or not v.BoostSound then continue end
		local audioPath = v.BoostSound
		
		if v:IsBoosting() then
			if not v.BoostAudio then
				v.BoostAudio = CreateSound( v, audioPath )
			end

			if not v.m_bBoostPlaying then
				v.m_bBoostPlaying = true
				v.m_bBoostFadeOut = false
				v.BoostAudio:Stop()
				v.BoostAudio:PlayEx( 1, 133 )
			end
		else
			if v.BoostAudio and not v.m_bBoostFadeOut then
				v.m_bBoostFadeOut = true
				v.m_bBoostPlaying = false
				v.BoostAudio:FadeOut( 0.33 )
			end
		end
	end
end )

hook.Add( "EntityRemoved", "RemoveBoost", function( eEnt )
	if eEnt:GetClass() ~= "prop_vehicle_jeep" or not eEnt.BoostSound then return end
	if eEnt.BoostAudio then
		eEnt.BoostAudio:Stop()
		eEnt.BoostAudio = nil
	end
end )

concommand.Add( "srp_toggle_streetglow", function( pPlayer )
	local car = pPlayer:GetVehicle()
	if not IsValid( car ) then return end
	car:SetNWBool( "glow_on", not car:GetNWBool("glow_on") )
end )

concommand.Add( "srp_dev_fix_carshop", function( pPlayer )
	if not pPlayer:IsSuperAdmin() then return end
	GAMEMODE.CarShop.m_tblDoors = {}
	GAMEMODE.CarShop:Initialize()
end )