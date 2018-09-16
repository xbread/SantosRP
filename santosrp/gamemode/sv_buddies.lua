--[[
	Name: sv_buddies.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Buddy = {}

function GM.Buddy:GetPlayerBuddyID( pPlayer, pOther )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Buddies then return end

	local buddyID = pOther:GetCharacterID()
	if saveTable.Buddies[buddyID] then
		return buddyID
	end
end

function GM.Buddy:GetPlayerByBuddyID( intBuddyID )
	for k, v in pairs( player.GetAll() ) do
		if not v:GetCharacterID() then continue end
		if v:GetCharacterID() == tonumber( intBuddyID ) then
			return v
		end
	end
end

function GM.Buddy:GetPlayerBuddyData( pPlayer, intBuddyID )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Buddies then return end
	return saveTable.Buddies[intBuddyID]
end

function GM.Buddy:IsPlayerBuddyWith( pPlayer, pOther )
	if not IsValid( pOther ) then return false end
	
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Buddies then return false end
	if not pOther:GetCharacterID() then return false end

	return saveTable.Buddies[pOther:GetCharacterID()] or false
end

function GM.Buddy:IsCarShared( pPlayer, pOwner )
	if not self:IsPlayerBuddyWith( pOwner, pPlayer ) then return false end
	return self:GetPlayerBuddyData( pOwner, pPlayer:GetCharacterID() ).Settings.ShareCar
end

function GM.Buddy:IsDoorShared( pPlayer, pOwner )
	if not self:IsPlayerBuddyWith( pOwner, pPlayer ) then return false end
	return self:GetPlayerBuddyData( pOwner, pPlayer:GetCharacterID() ).Settings.ShareDoors
end

function GM.Buddy:IsItemShared( pPlayer, pOwner )
	if not self:IsPlayerBuddyWith( pOwner, pPlayer ) then return false end
	return self:GetPlayerBuddyData( pOwner, pPlayer:GetCharacterID() ).Settings.ShareItems
end

function GM.Buddy:PlayerAddBuddy( pPlayer, intBuddyID )
	local otherPlayer = self:GetPlayerByBuddyID( intBuddyID )
	if not IsValid( otherPlayer ) then return end
	
	if pPlayer == otherPlayer or not IsValid( otherPlayer ) then return end
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not otherPlayer:GetCharacterID() then return end

	saveTable.Buddies = saveTable.Buddies or {}
	saveTable.Buddies[intBuddyID] = {
		Settings = {
			ShareCar = false,
			ShareDoors = false,
			ShareItems = false,
		},
		LastName = otherPlayer:Nick()
	}

	GAMEMODE.Net:SendBuddyUpdate( pPlayer, intBuddyID )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Buddies" )
	--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "Buddies", saveTable.Buddies )
end

function GM.Buddy:PlayerRemoveBuddy( pPlayer, intBuddyID )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Buddies then return end
	saveTable.Buddies[intBuddyID] = nil
	GAMEMODE.Net:SendBuddyUpdate( pPlayer, intBuddyID )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Buddies" )
	--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "Buddies", saveTable.Buddies )
end

function GM.Buddy:PlayerUpdateBuddyKey( pPlayer, intBuddyID, strKey, vaValue )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Buddies then return end
	if not saveTable.Buddies[intBuddyID] then return end
	if saveTable.Buddies[intBuddyID].Settings[strKey] == nil then return end
	if vaValue == nil then return end
	
	saveTable.Buddies[intBuddyID].Settings[strKey] = vaValue
	GAMEMODE.Net:SendBuddyUpdate( pPlayer, intBuddyID )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Buddies" )
	--GAMEMODE.SQL:InsdupCharacterDataStoreVar( pPlayer:GetCharacterID(), "Buddies", saveTable.Buddies )
end

hook.Add( "GamemodePlayerSelectCharacter", "SendBuddyData", function( pPlayer )
	GAMEMODE.Net:SendFullBuddyUpdate( pPlayer )
end )