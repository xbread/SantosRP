--[[
	Name: sv_properties.lua
	
		
]]--

GM.Property = (GAMEMODE or GM).Property or {}
GM.Property.DOOR_SEARCH_RANGE = 12
GM.Property.NET_BUY = 0
GM.Property.NET_SELL = 1
GM.Property.NET_SET_TITLE = 2
GM.Property.NET_ADD_FRIEND = 3
GM.Property.NET_REMOVE_FRIEND = 4
GM.Property.NET_SINGLE_UPDATE = 5
GM.Property.NET_FULL_UPDATE = 6
GM.Property.NET_REQUEST_UPD = 7
GM.Property.NET_OPEN_DOOR_MENU = 8

GM.Property.m_tblRegister = (GAMEMODE or GM).Property.m_tblRegister or {}
GM.Property.m_tblProperties = (GAMEMODE or GM).Property.m_tblProperties or {}
GM.Property.m_tblDoorClasses = {
	["prop_door_rotating"] = true,
	["func_door_rotating"] = true,
	["func_door"] = true,
}

function GM.Property:LoadProperties()
	GM:PrintDebug( 0, "->LOADING PROPERTIES" )

	local map = game.GetMap():gsub( ".bsp", "" )
	local path = GM.Config.GAMEMODE_PATH.. "maps/".. map.. "/properties/"

	local foundFiles, foundFolders = file.Find( path.. "*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( path.. v )
		AddCSLuaFile( path.. v )
	end

	GM:PrintDebug( 0, "->PROPERTIES LOADED" )
end

function GM.Property:Register( tblProp )
	local idx = #self.m_tblRegister +1
	self.m_tblRegister[idx] = tblProp
	tblProp.ID = idx
end

function GM.Property:LoadMap()
	for idx, data in pairs( self.m_tblRegister ) do
		local tbl = {
			ID = idx,
			Name = data.Name,
			Owner = nil,
			OwnerSID64 = nil,
			Price = data.Price,
			Desc = data.Desc,
			Job = data.JobDoor,
			Doors = {},
		}

		--Find and initialize all doors
		--ErrorNoHalt( "Loading doors for: ".. data.Name )
		local isLocked
		for _, pos in pairs( data.Doors ) do
			if type( pos ) == "table" then
				isLocked = pos.Locked
				pos = pos.Pos
			else
				isLocked = false
			end

			local door = self:InitializeDoorAtPos( pos, data )
			if not IsValid( door ) then continue end
			tbl.Doors[door:EntIndex()] = door

			if data.Locked or isLocked then
				door:Fire( "Lock" )
				door.IsLocked = true
			end
		end

		self.m_tblProperties[data.Name] = tbl
	end
end

function GM.Property:PlayerDisconnected( strSID64 )
	for _, name in pairs( GAMEMODE.Property:GetPropertiesBySteamID64(strSID64) ) do
		GAMEMODE.Property:ResetProperty( name )
	end
end

function GM.Property:InitializeDoorAtPos( vecPos, tblData )
	for _, ent in pairs( ents.FindInSphere(vecPos, tblData.SearchRangeOverride or self.DOOR_SEARCH_RANGE) ) do
		if not IsValid( ent ) or ent.m_tblPropertyData then continue end
		if self.m_tblDoorClasses[ent:GetClass()] or ent:GetClass():lower():find( "door" ) then
			--We found a valid door!
			ent.m_tblPropertyData = {
				Name = tblData.Name,
				JobDoor = tblData.JobDoor,
				GovernmentDoor = tblData.Government,
				Friends = {},
			}

			ent:SetNWString( "title", "" )

			return ent
		end
	end
end

function GM.Property:ResetProperty( strName )
	local data = self:GetPropertyByName( strName )
	if not data then return end
	data.Owner = nil
	data.OwnerSID64 = nil

	for name, ent in pairs( data.Doors ) do
		self:SetDoorTitle( ent, "" )
		ent.m_tblPropertyData.Friends = {}
		self:ForceUnlockEntity( ent )
	end

	GAMEMODE.Net:NetworkProperty( strName )
end

function GM.Property:GetPropertyByName( strName )
	return self.m_tblProperties[strName]
end

function GM.Property:GetPropertyByDoor( entDoor )
	if not IsValid( entDoor ) or not entDoor.m_tblPropertyData then return end
	return self:GetPropertyByName( entDoor.m_tblPropertyData.Name )
end

function GM.Property:IsPropertyOwned( strName )
	return IsValid( self:GetPropertyByName(strName).Owner )
end

function GM.Property:GetPropertiesByOwner( pPlayer )
	local ret = {}
	for name, data in pairs( self.m_tblProperties ) do
		if data.Owner == pPlayer then
			ret[#ret +1] = name
		end
	end

	return ret
end

function GM.Property:GetPropertiesBySteamID64( strSID64 )
	local ret = {}
	for name, data in pairs( self.m_tblProperties ) do
		if data.OwnerSID64 == strSID64 then
			ret[#ret +1] = name
		end
	end

	return ret
end

function GM.Property:PlayerOwnsProperty( pPlayer, strName )
	return self:GetOwner( strName ) == pPlayer
end

function GM.Property:GetOwner( strName )
	return self:GetPropertyByName( strName ).Owner
end

function GM.Property:ValidProperty( strName )
	return self:GetPropertyByName( strName ) ~= nil
end

function GM.Property:SetDoorTitle( entDoor, strTitle )
	if not IsValid( entDoor ) or not entDoor.m_tblPropertyData then return false end
	entDoor:SetNWString( "title", strTitle )
	return true
end

function GM.Property:PlayerBuyProperty( strName, pPlayer )
	if not self:ValidProperty( strName ) then return false end
	if self:IsPropertyOwned( strName ) then
		pPlayer:AddNote( "That property is already owned." )
		return false
	end

	local data = self:GetPropertyByName( strName )
	if not data then return false end
	if self.m_tblRegister[data.ID].Government then return false end
	if not self.m_tblRegister[data.ID].Cat then return false end
	
	local price = data.Price
	price = GAMEMODE.Econ:ApplyTaxToSum( "prop_".. self.m_tblRegister[data.ID].Cat, price )

	if pPlayer:GetMoney() < price then
		pPlayer:AddNote( "You can not afford that." )
		return false
	end

	local ret = hook.Call( "GamemodeCanPlayerBuyProperty", GAMEMODE, pPlayer, strName )
	if ret ~= nil and ret == false then
		return false
	end

	data.Owner = pPlayer
	data.OwnerSID64 = pPlayer:SteamID64()
	pPlayer:AddNote( "You bought ".. data.Name.. " for $".. price.. "." )
	pPlayer:AddMoney( -price )
	GAMEMODE.Net:NetworkProperty( strName )

	return true
end

function GM.Property:PlayerSellProperty( strName, pPlayer )
	if not self:ValidProperty( strName ) then return false end
	if not self:IsPropertyOwned( strName ) then return false end
	local data = self:GetPropertyByName( strName )
	if not data then return false end
	
	local owner = data.Owner
	if owner ~= pPlayer then
		pPlayer:AddNote( "You don't own that property." )
		return false
	end

	local price = math.ceil( data.Price /2 )
	owner:AddMoney( price )
	owner:AddNote( "You sold ".. data.Name.. " for $".. price.. "." )
	self:ResetProperty( strName )

	return true
end

function GM.Property:OpenDoorMenu( pPlayer )
	local ent = pPlayer:GetEyeTrace().Entity
	if not IsValid( ent ) then return end
	local data = self:GetPropertyByDoor( ent )
	if not data then return end
	
	if data.Owner ~= pPlayer then return end
	GAMEMODE.Net:NetworkOpenDoorMenu( pPlayer, ent )
	return true
end

function GM.Property:ToggleLock( pPlayer, intClick )
	local ent = pPlayer:GetEyeTrace().Entity
	if not IsValid( ent ) then return end
	if ent:GetPos():Distance( pPlayer:GetPos() ) > (ent:IsVehicle() and 160 or 84) then pPlayer:AddNote( "Get closer." ) return end

	if ent:GetClass():find( "jeep" ) then --Player is locking/unlocking a vehicle
		local vecPos = ent:GetPos() + ent:GetForward()*ent:OBBMins().y;
		if ent.Job and GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == ent.Job then
			if vecPos:Distance(pPlayer:GetPos()) < 60 then 
				self:ToggleTrunkLockEntity( pPlayer, ent, intClick )
				return
			end
			self:ToggleLockEntity( pPlayer, ent, intClick )
		elseif GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer ) == ent then
			if vecPos:Distance(pPlayer:GetPos()) < 60 then 
				self:ToggleTrunkLockEntity( pPlayer, ent, intClick )
				return
			end
			self:ToggleLockEntity( pPlayer, ent, intClick )
		elseif IsValid( ent:GetPlayerOwner() ) and GAMEMODE.Buddy:IsCarShared( pPlayer, ent:GetPlayerOwner() ) then
			if vecPos:Distance(pPlayer:GetPos()) < 60 then 
				self:ToggleTrunkLockEntity( pPlayer, ent, intClick )
				return
			end
			self:ToggleLockEntity( pPlayer, ent, intClick )
		end
	elseif ent.m_tblPropertyData then --Player is locking/unlocking a property door
		if ent.m_tblPropertyData.GovernmentDoor and GAMEMODE.Config.GovernemtDoorJobs[GAMEMODE.Jobs:GetPlayerJobEnum(pPlayer)] then
			self:ToggleLockEntity( pPlayer, ent, intClick )
		else
			if GAMEMODE.Jobs:GetPlayerJob( pPlayer ).HasMasterKeys and self:IsPropertyOwned( ent.m_tblPropertyData.Name ) then
				self:ToggleLockEntity( pPlayer, ent, intClick )
				return
			end

			local data = GAMEMODE.Property:GetPropertyByDoor( ent )
			if data and data.Owner == pPlayer then
				self:ToggleLockEntity( pPlayer, ent, intClick )
			elseif data and IsValid( data.Owner ) and GAMEMODE.Buddy:IsDoorShared( pPlayer, data.Owner ) then
				self:ToggleLockEntity( pPlayer, ent, intClick )
			end
		end
	end
end

function GM.Property:ToggleTrunkLockEntity( pPlayer, eEnt, intClick )
	if intClick == 2 then
		pPlayer:AddNote( "You locked the trunk!" )
		eEnt.IsTrunkLocked = true
		eEnt:EmitSound( "doors/default_locked.wav" )
	else
		pPlayer:AddNote( "You unlocked the trunk!" )
		eEnt.IsTrunkLocked = false
		eEnt:EmitSound( "doors/latchunlocked1.wav" )
	end
end

function GM.Property:ToggleLockEntity( pPlayer, eEnt, intClick )
	if intClick == 2 then
		pPlayer:AddNote( "You locked the door!" )
		eEnt.IsLocked = true
		eEnt:Fire( "Lock" )
		eEnt:EmitSound( "doors/default_locked.wav" )
	else
		pPlayer:AddNote( "You unlocked the door!" )
		eEnt.IsLocked = false
		eEnt:Fire( "Unlock" )
		eEnt:EmitSound( "doors/latchunlocked1.wav" )
	end

	if eEnt:GetClass():find( "jeep" ) then
		eEnt.VC_Locked = eEnt.IsLocked

		for k, v in pairs( eEnt.VC_SeatTable or {} ) do
			v.IsLocked = eEnt.IsLocked
			v.VC_Locked = eEnt.IsLocked
			v:Fire( eEnt.IsLocked and "Lock" or "Unlock" )
		end
	end
end

function GM.Property:ForceUnlockEntity( eEnt )
	eEnt.IsLocked = false
	eEnt:Fire( "Unlock" )
	eEnt:EmitSound( "doors/latchunlocked1.wav" )
end

hook.Add( "GamemodeOnPlayerReady", "SendPropertyFullUpdate", function( pPlayer )
	timer.Simple( 30, function()
		if not IsValid( pPlayer ) then return end
		GAMEMODE.Net:SendFullPropertyUpdate( pPlayer )
	end )
end )