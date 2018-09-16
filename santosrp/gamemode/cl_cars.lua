--[[
	Name: cl_cars.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Cars = (GAMEMODE or GM).Cars or {}
GM.Cars.m_tblRegister = (GAMEMODE or GM).Cars.m_tblRegister or {}
GM.Cars.m_tblRegisterByMake = (GAMEMODE or GM).Cars.m_tblRegisterByMake or {}
GM.Cars.m_tblJobRegister = (GAMEMODE or GM).Cars.m_tblJobRegister or {}
GM.Cars.m_tblFuelCache = (GAMEMODE or GM).Cars.m_tblFuelCache or {}

function GM.Cars:LoadCars()
	GM:PrintDebug( 0, "->LOADING CARS" )

	local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "cars/*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( GM.Config.GAMEMODE_PATH.. "cars/".. v )
	end

	GM:PrintDebug( 0, "->CARS LOADED" )
end

function GM.Cars:Register( tblCar )
	self.m_tblRegister[tblCar.UID] = tblCar
	self.m_tblRegisterByMake[tblCar.Make] = self.m_tblRegisterByMake[tblCar.Make] or {}
	self.m_tblRegisterByMake[tblCar.Make][tblCar.UID] = tblCar
	--util.PrecacheModel( tblCar.Model )
end

function GM.Cars:RegisterJobCar( tblCar )
	self.m_tblJobRegister[tblCar.UID] = tblCar
	--util.PrecacheModel( tblCar.Model )
end

function GM.Cars:GetCarByUID( strCarUID )
	return self.m_tblRegister[strCarUID]
end

function GM.Cars:GetCarsByMake( strMake )
	return self.m_tblRegisterByMake[strMake]
end

function GM.Cars:GetAllCarsByMake()
	return self.m_tblRegisterByMake
end

function GM.Cars:GetAllCarsByUID()
	return self.m_tblRegister
end

function GM.Cars:GetJobCarByUID( strCarUID )
	return self.m_tblJobRegister[strCarUID]
end

function GM.Cars:GetAllJobCars()
	return self.m_tblJobRegister
end

function GM.Cars:PlayerHasCar( pPlayer )
	return IsValid( pPlayer:GetNWEntity("CurrentCar") )
end

function GM.Cars:GetCurrentPlayerCar( pPlayer )
	return pPlayer:GetNWEntity( "CurrentCar" )
end

--Returns the total value of the given vehicle
function GM.Cars:CalcVehicleValue( entCar )
	local data = self:GetCarByUID( entCar:GetNWString("UID", "") )
	if not data or not data.Price or data.Job then return end
	
	local ret = { BasePrice = data.Price, Value = data.Price }
	hook.Call( "GamemodeCalcVehicleValue", GAMEMODE, entCar, ret )

	return ret.Value
end

--Returns the health of the given vehicle
function GM.Cars:GetCarHealth( entCar )
	return GAMEMODE.Config.UseCustomVehicleDamage and entCar:GetNWInt( "CarHealth", 0 ) or entCar:GetNWInt( "VC_Health", 0 )
end

--Returns the max health of the given vehicle
function GM.Cars:GetCarMaxHealth( entCar )
	return GAMEMODE.Config.UseCustomVehicleDamage and GAMEMODE.Config.MaxCarHealth or entCar:GetNWInt( "VC_MaxHealth", 0 )
end

--[[ Car Fuel ]]--
function GM.Cars:UpdateCarFuel( intEntIndex, intFuel, intMaxFuel )
	self.m_tblFuelCache[intEntIndex] = {
		Fuel = intFuel,
		MaxFuel = intMaxFuel,
	}
end

function GM.Cars:EntityRemoved( eEnt )
	if eEnt:IsVehicle() and self.m_tblFuelCache[eEnt:EntIndex()] then
		self.m_tblFuelCache[eEnt:EntIndex()] = nil
	end
end

local carMeta = debug.getregistry().Vehicle
function carMeta:GetFuel()
	if not GAMEMODE.Cars.m_tblFuelCache[self:EntIndex()] then return 10 end
	return GAMEMODE.Cars.m_tblFuelCache[self:EntIndex()].Fuel or 10
end

function carMeta:GetMaxFuel()
	if not GAMEMODE.Cars.m_tblFuelCache[self:EntIndex()] then return 10 end
	return GAMEMODE.Cars.m_tblFuelCache[self:EntIndex()].MaxFuel or 10
end