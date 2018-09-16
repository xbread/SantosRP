--[[
	Name: sv_mysql_player.lua
	For: TalosLife
	By: TalosLife, Thanks to TehBigA for help!
]]--

GM.SQL.m_tblDiffFlags = (GAMEMODE or GM).SQL.m_tblDiffFlags or {}
GM.SQL.m_intSnapshotInterval = (GAMEMODE or GM).Config.SQLSnapshotRate

function GM.SQL:LogPlayerQuery( intCharID, strQuery )
	if true then return end
	
	if not file.IsDir( "sql_log", "DATA" ) then file.CreateDir( "sql_log" ) end
	if not file.Exists( "sql_log/log_".. intCharID.. ".txt", "DATA" ) then
		file.Write( "sql_log/log_".. intCharID.. ".txt", "" )
	end

	file.Append( "sql_log/log_".. intCharID.. ".txt", os.date().. " - ".. strQuery.. "\n\n" )
end

function GM.SQL:LogPlayerDiff( strSID64, strData )
	if true then return end
	
	if not file.IsDir( "sql_diff_log", "DATA" ) then file.CreateDir( "sql_diff_log" ) end
	if not file.Exists( "sql_diff_log/log_".. strSID64.. ".txt", "DATA" ) then
		file.Write( "sql_diff_log/log_".. strSID64.. ".txt", "" )
	end

	file.Append( "sql_diff_log/log_".. strSID64.. ".txt", os.date().. " - ".. strData.. "\n\n" )
end

function GM.SQL:InitGamemodeTables()
	self:LogMsg( "Initializing gamemode tables..." )

	self:PooledQueryWrite( 1, [[CREATE TABLE IF NOT EXISTS `players` (
		`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
		`steamid` VARCHAR(255) NOT NULL,
		PRIMARY KEY (`id`),
		INDEX `steamid` (`steamid`)
	) ENGINE=InnoDB;]] )

	self:PooledQueryWrite( 2, [[CREATE TABLE IF NOT EXISTS `characters` (
		`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
		`player_id` INT(10) UNSIGNED NOT NULL,
		`first_name` VARCHAR(255) NOT NULL DEFAULT 'Minge',
		`last_name` VARCHAR(255) NOT NULL DEFAULT 'Bag',
		`sex` ENUM('male','female') NULL DEFAULT NULL,
		`model` VARCHAR(255) NOT NULL,
		`model_override` VARCHAR(255) NULL DEFAULT NULL,
		`skin` SMALLINT NOT NULL DEFAULT 0,
		`money_held` INT(10) UNSIGNED NOT NULL DEFAULT '0',
		`money_bank` INT(10) UNSIGNED NOT NULL DEFAULT '0',
		`vehicles` LONGTEXT NULL,
		`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		PRIMARY KEY (`id`),
		INDEX `player_id` (`player_id`),
		INDEX `first_name_last_name` (`first_name`, `last_name`)
	) ENGINE=InnoDB;]] )

	self:PooledQueryWrite( 3, [[CREATE TABLE IF NOT EXISTS `character_inventory` (
		`character_id` INT(10) UNSIGNED NOT NULL,
		`item_name` VARCHAR(255) NOT NULL,
		`item_count` INT(10) UNSIGNED NOT NULL,
		UNIQUE INDEX `character_id_item_name` (`character_id`, `item_name`),
		INDEX `character_id` (`character_id`)
	) ENGINE=InnoDB;]] )

	self:PooledQueryWrite( 4, [[CREATE TABLE IF NOT EXISTS  `character_equipped` (
		`character_id` INT(10) UNSIGNED NOT NULL,
		`slot_name` VARCHAR(255) NOT NULL,
		`item_name` VARCHAR(255) NOT NULL,
		UNIQUE INDEX `character_id_slot_name` (`character_id`, `slot_name`),
		INDEX `character_id` (`character_id`)
	) ENGINE=InnoDB;]] )

	self:PooledQueryWrite( 5, [[CREATE TABLE IF NOT EXISTS `character_data_store` (
		`character_id` INT(10) UNSIGNED NOT NULL,
		`key` VARCHAR(255) NOT NULL,
		`value` LONGTEXT NULL,
		UNIQUE INDEX `character_id_key` (`character_id`, `key`),
		INDEX `character_id` (`character_id`),
		INDEX `key` (`key`)
	) ENGINE=InnoDB;]] )

	hook.Call( "GamemodeInitSQLTables", GAMEMODE )
end

--Player data
local pmeta = debug.getregistry().Player
function pmeta:GetPlayerSQLID()
	return self.m_intSQLID
end

function pmeta:SetPlayerSQLID( intID )
	self.m_intSQLID = tonumber( intID )
end

function GM.SQL:LoadPlayerID( pPlayer, funcOnLoaded )
	self:QueryReadOnly( ([[SELECT p.id FROM players p WHERE p.steamid = '%s']]):format(pPlayer:SteamID()), function( tblData, q )
		if not IsValid( pPlayer ) then return end
		
		local pl = tblData[1]
		if not pl or not pl.id then
			self:InsertNewPlayer( pPlayer, funcOnLoaded )
		else
			pPlayer:SetPlayerSQLID( pl.id )
			funcOnLoaded( pl.id )
		end
	end )
end

function GM.SQL:InsertNewPlayer( pPlayer, funcOnInsert )
	self:PooledQueryWrite( self:GetPlayerPoolID(pPlayer:SteamID64()), ([[INSERT INTO players SET steamid='%s']]):format(pPlayer:SteamID()), function( tblData, q )
		if not IsValid( pPlayer ) then return end
		
		local plID = q.lastid
		pPlayer:SetPlayerSQLID( plID )
		funcOnInsert( plID )
	end )
end

--Character data
function GM.SQL:InsertNewCharacter( pPlayer, tblCharData, funcCallback )
	self:PooledQueryWrite( self:GetPlayerPoolID(pPlayer:SteamID64()), ([[INSERT INTO characters SET
		player_id=%d,
		first_name='%s',
		last_name='%s',
		sex='%s',
		model='%s',
		model_override='%s',
		skin=%d,
		money_held=%d,
		money_bank=%d,
		vehicles='%s'
	]] ):format(
		pPlayer:GetPlayerSQLID(),
		SQLStr( tblCharData.Name.First, true ),
		SQLStr( tblCharData.Name.Last, true ),
		tblCharData.Sex == 0 and "male" or "female",
		tblCharData.Model.Base,
		tblCharData.Model.Overload,
		tblCharData.Skin,
		tblCharData.Money.Wallet,
		tblCharData.Money.Bank,
		util.TableToJSON( tblCharData.Vehicles )
	), function( tblData, q )
		local charID = q.lastid
		local workerID = self:GetPlayerPoolID( pPlayer:SteamID64() )

		--insert inventory
		self:InsertCharacterFullInventory( workerID, charID, tblCharData.Inventory )
		--insert equipped
		self:InsertCharacterFullEquippedItems( workerID, charID, tblCharData.Equipped )
		--insert save table
		self:InsertCharacterFullDataStore( workerID, charID, tblCharData.SaveTable )

		if not IsValid( pPlayer ) then return end
		funcCallback( charID )
	end )
end

function GM.SQL:LoadPlayerCharacters( pPlayer, funcOnLoaded )
	self:QueryReadOnly( ([[SELECT c.* FROM characters c JOIN players p ON p.id = c.player_id WHERE p.steamid = '%s']]):format(pPlayer:SteamID()), function( tblData, q )
		if not IsValid( pPlayer ) then return end
		local characters = {}
		local to_load = #tblData
		local char_loaded = function()
			to_load = to_load - 1

			if to_load == 0 then
				funcOnLoaded( characters )
			end
		end

		if to_load == 0 then
			funcOnLoaded( characters )
			return
		end

		for k, v in ipairs( tblData ) do
			local char = {
				Id = v.id,
				Name = {
					First = v.first_name,
					Last = v.last_name,
				},
				Sex = v.sex == "male" and 0 or 1,
				Model = {
					Base = v.model,
					Overload = v.model_override,
				},
				Skin = v.skin,
				Money = {
					Wallet = v.money_held,
					Bank = v.money_bank,
				},
				Vehicles = util.JSONToTable( v.vehicles or "" ),
			}
			
			characters[v.id] = char

			self:LoadCharacterData( char, char_loaded )
		end
	end )
end

function GM.SQL:LoadCharacterData( tblCharacter, funcOnLoaded )
	local inv, equip, data_store
	local part_loaded = function()
		if inv and equip and data_store then
			funcOnLoaded()
		end
	end

	self:LoadCharacterInventory( tblCharacter.Id, function( tblData )
		tblCharacter.Inventory = tblData
		inv = true
		part_loaded()
	end )

	self:LoadCharacterEquippedItems( tblCharacter.Id, function( tblData )
		tblCharacter.Equipped = tblData
		equip = true
		part_loaded()
	end )

	self:LoadCharacterDataStore( tblCharacter.Id, function( tblData )
		tblCharacter.SaveTable = tblData
		data_store = true
		part_loaded()
	end )
end

function GM.SQL:GetPlayerNumCharacters( intPlyID, funcCallback )
	self:QueryReadOnly( ([[SELECT COUNT(1) count FROM characters c WHERE player_id = %d]]):format(intPlyID), function( tblData, q )
		funcCallback( tblData[1].count )
	end )
end

function GM.SQL:CheckCharacterNameTaken( strFirstName, strLastName, funcCallback )
	self:QueryReadOnly( ([[SELECT 1 FROM characters c WHERE first_name = '%s' AND last_name = '%s']]):format(SQLStr(strFirstName, true), SQLStr(strLastName, true)), function( tblData, q )
		funcCallback( tblData[1] and true or false )
	end )
end

--Functions to update character vars
function GM.SQL:UpdateCharacterFirstName( intPoolID, intCharID, strNameFirst )
	self:LogPlayerQuery( intCharID, ([[UPDATE characters SET first_name='%s' WHERE id=%d]]):format(SQLStr(strNameFirst, true), intCharID) )
	self:PooledQueryWrite( intPoolID, ([[UPDATE characters SET first_name='%s' WHERE id=%d]]):format(SQLStr(strNameFirst, true), intCharID) )
end

function GM.SQL:UpdateCharacterLastName( intPoolID, intCharID, strNameLast )
	self:LogPlayerQuery( intCharID, ([[UPDATE characters SET last_name='%s' WHERE id=%d]]):format(SQLStr(strNameLast, true), intCharID) )
	self:PooledQueryWrite( intPoolID, ([[UPDATE characters SET last_name='%s' WHERE id=%d]]):format(SQLStr(strNameLast, true), intCharID) )
end

function GM.SQL:UpdateCharacterModel( intPoolID, intCharID, strModel )
	self:LogPlayerQuery( intCharID, ([[UPDATE characters SET model='%s' WHERE id=%d]]):format(SQLStr(strModel, true), intCharID) )
	self:PooledQueryWrite( intPoolID, ([[UPDATE characters SET model='%s' WHERE id=%d]]):format(SQLStr(strModel, true), intCharID) )
end

function GM.SQL:UpdateCharacterModelOverload( intPoolID, intCharID, strModelOverload )
	self:LogPlayerQuery( intCharID, ([[UPDATE characters SET model_override='%s' WHERE id=%d]]):format(SQLStr(strModelOverload, true), intCharID) )
	self:PooledQueryWrite( intPoolID, ([[UPDATE characters SET model_override='%s' WHERE id=%d]]):format(SQLStr(strModelOverload, true), intCharID) )
end

function GM.SQL:UpdateCharacterSex( intPoolID, intCharID, intSex )
	self:LogPlayerQuery( intCharID, ([[UPDATE characters SET sex='%s' WHERE id=%d]]):format(intSex == 0 and "male" or "female", intCharID) )
	self:PooledQueryWrite( intPoolID, ([[UPDATE characters SET sex='%s' WHERE id=%d]]):format(intSex == 0 and "male" or "female", intCharID) )
end

function GM.SQL:UpdateCharacterSkin( intPoolID, intCharID, intSkin )
	self:LogPlayerQuery( intCharID, ([[UPDATE characters SET skin=%d WHERE id=%d]]):format(intSkin, intCharID) )
	self:PooledQueryWrite( intPoolID, ([[UPDATE characters SET skin=%d WHERE id=%d]]):format(intSkin, intCharID) )
end

function GM.SQL:UpdateCharacterMoneyWallet( intPoolID, intCharID, intWalletMoney )
	self:LogPlayerQuery( intCharID, ([[UPDATE characters SET money_held=%d WHERE id=%d]]):format(intWalletMoney, intCharID) )
	self:PooledQueryWrite( intPoolID, ([[UPDATE characters SET money_held=%d WHERE id=%d]]):format(intWalletMoney, intCharID) )
end

function GM.SQL:UpdateCharacterMoneyBank( intPoolID, intCharID, intBankMoney )
	self:LogPlayerQuery( intCharID, ([[UPDATE characters SET money_bank=%d WHERE id=%d]]):format(intBankMoney, intCharID) )
	self:PooledQueryWrite( intPoolID, ([[UPDATE characters SET money_bank=%d WHERE id=%d]]):format(intBankMoney, intCharID) )
end

function GM.SQL:UpdateCharacterVehicles( intPoolID, intCharID, tblVehicles )
	self:LogPlayerQuery( intCharID, ([[UPDATE characters SET vehicles='%s' WHERE id=%d]]):format(util.TableToJSON(tblVehicles), intCharID) )
	self:PooledQueryWrite( intPoolID, ([[UPDATE characters SET vehicles='%s' WHERE id=%d]]):format(util.TableToJSON(tblVehicles), intCharID) )
end

--Character inventory data
function GM.SQL:LoadCharacterInventory( intCharID, funcOnLoaded )
	self:QueryReadOnly( ([[SELECT inv.* FROM character_inventory inv WHERE inv.character_id = %d]]):format(intCharID), function( tblData, q )
		local decoded = {}
		for idx, v in ipairs( tblData ) do
			if not GAMEMODE.Inv:GetItem( v.item_name ) then continue end
			decoded[v.item_name] = v.item_count
		end

		funcOnLoaded( decoded )
	end )
end

function GM.SQL:InsdupCharacterInventoryItem( intPoolID, intCharID, strItemID, intAmount )
	self:LogPlayerQuery( intCharID, ([[INSERT INTO character_inventory (character_id, item_name, item_count) VALUES (%d, '%s', %d) ON DUPLICATE KEY UPDATE item_count=%d]]):format(intCharID, SQLStr(strItemID, true), intAmount, intAmount) )
	self:PooledQueryWrite( intPoolID, ([[INSERT INTO character_inventory (character_id, item_name, item_count) VALUES (%d, '%s', %d) ON DUPLICATE KEY UPDATE item_count=%d]]):format(intCharID, SQLStr(strItemID, true), intAmount, intAmount) )
end

function GM.SQL:InsertCharacterInventoryItem( intPoolID, intCharID, strItemID, intAmount )
	self:LogPlayerQuery( intCharID, ([[INSERT INTO character_inventory SET character_id=%d, item_name='%s', item_count=%d]]):format(intCharID, SQLStr(strItemID, true), intAmount) )
	self:PooledQueryWrite( intPoolID, ([[INSERT INTO character_inventory SET character_id=%d, item_name='%s', item_count=%d]]):format(intCharID, SQLStr(strItemID, true), intAmount) )
end

function GM.SQL:UpdateCharacterInventoryItem( intPoolID, intCharID, strItemID, intAmount )
	self:LogPlayerQuery( intCharID, ([[UPDATE character_inventory SET item_count=%d WHERE character_id=%d AND item_name='%s']]):format(intAmount, intCharID, SQLStr(strItemID, true)) )
	self:PooledQueryWrite( intPoolID, ([[UPDATE character_inventory SET item_count=%d WHERE character_id=%d AND item_name='%s']]):format(intAmount, intCharID, SQLStr(strItemID, true)) )
end

function GM.SQL:RemoveCharacterInventoryItem( intPoolID, intCharID, strItemID )
	self:LogPlayerQuery( intCharID, ([[DELETE FROM character_inventory WHERE character_id=%d AND item_name='%s']]):format(intCharID, SQLStr(strItemID, true)) )
	self:PooledQueryWrite( intPoolID, ([[DELETE FROM character_inventory WHERE character_id=%d AND item_name='%s']]):format(intCharID, SQLStr(strItemID, true)) )
end

function GM.SQL:InsertCharacterFullInventory( intPoolID, intCharID, tblInventory )
	for itemName, itemAmount in pairs( tblInventory ) do
		self:InsdupCharacterInventoryItem( intPoolID, intCharID, itemName, itemAmount )
	end
end

--Character equip data
function GM.SQL:LoadCharacterEquippedItems( intCharID, funcOnLoaded )
	self:QueryReadOnly( ([[SELECT eq.* FROM character_equipped eq WHERE eq.character_id = %d]]):format(intCharID), function( tblData, q )
		local decoded = {}
		for idx, v in ipairs( tblData ) do
			if v.item_name and v.item_name ~= "" then
				if not GAMEMODE.Inv:GetItem( v.item_name ) then continue end
			end
			
			decoded[v.slot_name] = v.item_name
		end

		funcOnLoaded( decoded )
	end )
end

function GM.SQL:InsdupCharacterEquippedItem( intPoolID, intCharID, strSlotID, strItemID )
	self:LogPlayerQuery( intCharID, ([[INSERT INTO character_equipped (character_id, slot_name, item_name) VALUES (%d, '%s', '%s') ON DUPLICATE KEY UPDATE item_name='%s']]):format(intCharID, SQLStr(strSlotID, true), SQLStr(strItemID, true), SQLStr(strItemID, true)) )
	self:PooledQueryWrite( intPoolID, ([[INSERT INTO character_equipped (character_id, slot_name, item_name) VALUES (%d, '%s', '%s') ON DUPLICATE KEY UPDATE item_name='%s']]):format(intCharID, SQLStr(strSlotID, true), SQLStr(strItemID, true), SQLStr(strItemID, true)) )
end

function GM.SQL:InsertCharacterEquippedItem( intPoolID, intCharID, strSlotID, strItemID )
	self:LogPlayerQuery( intCharID, ([[INSERT INTO character_equipped SET character_id=%d, slot_name='%s', item_name='%s']]):format(intCharID, SQLStr(strSlotID, true), SQLStr(strItemID, true)) )
	self:PooledQueryWrite( intPoolID, ([[INSERT INTO character_equipped SET character_id=%d, slot_name='%s', item_name='%s']]):format(intCharID, SQLStr(strSlotID, true), SQLStr(strItemID, true)) )
end

function GM.SQL:UpdateCharacterEquippedSlot( intPoolID, intCharID, strSlotID, strItemID )
	self:LogPlayerQuery( intCharID, ([[UPDATE character_equipped SET item_name='%s' WHERE character_id=%d AND slot_name='%s']]):format(SQLStr(strItemID, true), intCharID, SQLStr(strSlotID, true)) )
	self:PooledQueryWrite( intPoolID, ([[UPDATE character_equipped SET item_name='%s' WHERE character_id=%d AND slot_name='%s']]):format(SQLStr(strItemID, true), intCharID, SQLStr(strSlotID, true)) )
end

function GM.SQL:RemoveCharacterEquippedSlot( intPoolID, intCharID, strSlotID )
	self:LogPlayerQuery( intCharID, ([[DELETE FROM character_equipped WHERE character_id=%d AND slot_name='%s']]):format(intCharID, SQLStr(strSlotID, true)) )
	self:PooledQueryWrite( intPoolID, ([[DELETE FROM character_equipped WHERE character_id=%d AND slot_name='%s']]):format(intCharID, SQLStr(strSlotID, true)) )
end

function GM.SQL:InsertCharacterFullEquippedItems( intPoolID, intCharID, tblEquipped )
	for slotName, itemName in pairs( tblEquipped ) do
		self:InsdupCharacterEquippedItem( intPoolID, intCharID, slotName, itemName )
	end
end

--Character data store
function GM.SQL:LoadCharacterDataStore( intCharID, funcOnLoaded )
	self:QueryReadOnly( ([[SELECT ds.* FROM character_data_store ds WHERE ds.character_id = %d]]):format(intCharID), function( tblData, q )
		local decoded = {}
		for idx, v in ipairs( tblData ) do
			decoded[v.key] = util.JSONToTable( v.value )
		end

		funcOnLoaded( decoded )
	end )
end

function GM.SQL:InsdupCharacterDataStoreVar( intPoolID, intCharID, strVar, vaValue )
	local strValue = util.TableToJSON( vaValue )
	self:LogPlayerQuery( intCharID, ([[INSERT INTO character_data_store (character_id, `key`, value) VALUES (%d, '%s', '%s') ON DUPLICATE KEY UPDATE value='%s']]):format(intCharID, SQLStr(strVar, true), SQLStr(strValue, true), SQLStr(strValue, true)) )
	self:PooledQueryWrite( intPoolID, ([[INSERT INTO character_data_store (character_id, `key`, value) VALUES (%d, '%s', '%s') ON DUPLICATE KEY UPDATE value='%s']]):format(intCharID, SQLStr(strVar, true), SQLStr(strValue, true), SQLStr(strValue, true)) )
end

function GM.SQL:InsertCharacterDataStoreVar( intPoolID, intCharID, strVar, vaValue )
	local strValue = util.TableToJSON( vaValue )
	self:LogPlayerQuery( intCharID, ([[INSERT INTO character_data_store SET character_id=%d, `key`='%s', value='%s']]):format(intCharID, SQLStr(strVar, true), SQLStr(strValue, true)) )
	self:PooledQueryWrite( intPoolID, ([[INSERT INTO character_data_store SET character_id=%d, `key`='%s', value='%s']]):format(intCharID, SQLStr(strVar, true), SQLStr(strValue, true)) )
end

function GM.SQL:UpdateCharacterDataStoreVar( intPoolID, intCharID, strVar, vaValue )
	local strValue = util.TableToJSON( vaValue )
	self:LogPlayerQuery( intCharID, ([[UPDATE character_data_store SET value='%s' WHERE character_id=%d AND `key`='%s']]):format(SQLStr(strVar, true), intCharID, SQLStr(strValue, true)) )
	self:PooledQueryWrite( intPoolID, ([[UPDATE character_data_store SET value='%s' WHERE character_id=%d AND `key`='%s']]):format(SQLStr(strVar, true), intCharID, SQLStr(strValue, true)) )
end

function GM.SQL:RemoveCharacterDataStoreVar( intPoolID, intCharID, strVar )
	self:LogPlayerQuery( intCharID, ([[DELETE FROM character_data_store WHERE character_id=%d AND `key`='%s']]):format(intCharID, SQLStr(strVar, true)) )
	self:PooledQueryWrite( intPoolID, ([[DELETE FROM character_data_store WHERE character_id=%d AND `key`='%s']]):format(intCharID, SQLStr(strVar, true)) )
end

function GM.SQL:InsertCharacterFullDataStore( intPoolID, intCharID, tblSaveTable )
	for k, v in pairs( tblSaveTable ) do
		self:InsdupCharacterDataStoreVar( intPoolID, intCharID, tostring(k), util.TableToJSON{ [1] = v } ) --JSON ONLY TAKES TABLES? FUCK YOU GARRY.
	end
end

-- ------------------------------------------------------------------------------
-- Snapshot Updates

function GM.SQL:CommitPlayerDiffs( strSID64 )
	local gameData = GAMEMODE.Player:GetData( strSID64 )
	if not gameData then return end
	
	local charID = gameData.SelectedCharacter
	if not charID then return end
	
	local charData = gameData.Characters[charID]
	if not charData then return end
	
	local workerID = self:GetPlayerPoolID( strSID64 ) or 1
	local diffFlags = gameData.SQLDiffTable
	if not diffFlags or not diffFlags.Flags then return end

	self:LogPlayerDiff( strSID64, "NumDiff = ".. table.Count(diffFlags.Flags).. " - DataPointer = ".. tostring(gameData).. " - CharDataPointer = ".. tostring(charData) )

	for k, v in pairs( diffFlags.Flags ) do
		self.m_tblDiffFlags[k]( workerID, charID, charData, diffFlags.Flags )
	end

	self:ClearPlayerDiffTable( strSID64 )
end

function GM.SQL:RegisterDiffFlag( strFlagID, funcUpdate )
	self.m_tblDiffFlags[strFlagID] = funcUpdate
end

function GM.SQL:ClearPlayerDiffTable( strSID64 )
	if not GAMEMODE.Player:GetData( strSID64 ) then return end
	GAMEMODE.Player:GetData( strSID64 ).SQLDiffTable = {
		Flags = {},
		NextSnapshot = CurTime() +(self.m_intSnapshotInterval or 300)
	}
end

function GM.SQL:MarkDiffDirty( pPlayer, strFlagID, strSubFlag )
	local data = pPlayer:GetGamemodeData()
	if not data or not data.SQLDiffTable then return end
	if not self.m_tblDiffFlags[strFlagID] then return end

	if strSubFlag then
		data.SQLDiffTable.Flags[strFlagID] = data.SQLDiffTable.Flags[strFlagID] or {}
		data.SQLDiffTable.Flags[strFlagID][strSubFlag] = true
	else
		data.SQLDiffTable.Flags[strFlagID] = true
	end
end

function GM.SQL:GetPlayerDiffFlags( pPlayer )
	if not pPlayer:GetGamemodeData() or not pPlayer:GetGamemodeData().SQLDiffTable then return {} end
	return pPlayer:GetGamemodeData().SQLDiffTable.Flags or {}
end

function GM.SQL:TickPlayerIntervals()
	if CurTime() <= (self.m_intLastInterval or 0) then return end
	self.m_intLastInterval = CurTime() +1

	local time, data = CurTime(), nil
	for k, v in pairs( player.GetAll() ) do
		data = v:GetGamemodeData()
		if not data or not data.SQLDiffTable or not data.SQLDiffTable.Flags then continue end
		if data.SQLDiffTable.NextSnapshot >= time then continue end
		self:CommitPlayerDiffs( v:SteamID64() )
	end
end

GM.SQL:RegisterDiffFlag( "money_wallet", function( intWorkerID, intCharID, tblCharData, tblDiffFlags )
	GAMEMODE.SQL:UpdateCharacterMoneyWallet( intWorkerID, intCharID, tblCharData.Money.Wallet )
end )

GM.SQL:RegisterDiffFlag( "money_bank", function( intWorkerID, intCharID, tblCharData, tblDiffFlags )
	GAMEMODE.SQL:UpdateCharacterMoneyBank( intWorkerID, intCharID, tblCharData.Money.Bank )
end )

GM.SQL:RegisterDiffFlag( "skin", function( intWorkerID, intCharID, tblCharData, tblDiffFlags )
	GAMEMODE.SQL:UpdateCharacterSkin( intWorkerID, intCharID, tblCharData.Skin )
end )

GM.SQL:RegisterDiffFlag( "model_overload", function( intWorkerID, intCharID, tblCharData, tblDiffFlags )
	GAMEMODE.SQL:UpdateCharacterModelOverload( intWorkerID, intCharID, tblCharData.Model.Overload )
end )

GM.SQL:RegisterDiffFlag( "vehicles", function( intWorkerID, intCharID, tblCharData, tblDiffFlags )
	GAMEMODE.SQL:UpdateCharacterVehicles( intWorkerID, intCharID, tblCharData.Vehicles )
end )

GM.SQL:RegisterDiffFlag( "inventory", function( intWorkerID, intCharID, tblCharData, tblDiffFlags )
	if not tblDiffFlags["inventory"] then return end
	if not tblCharData.Inventory then return end
	
	for itemName, _ in pairs( tblDiffFlags["inventory"] ) do
		local itemNum = tblCharData.Inventory[itemName] or 0
		if itemNum <= 0 then
			GAMEMODE.SQL:RemoveCharacterInventoryItem( intWorkerID, intCharID, itemName )
		else
			GAMEMODE.SQL:InsdupCharacterInventoryItem( intWorkerID, intCharID, itemName, itemNum )
		end
	end
end )

GM.SQL:RegisterDiffFlag( "equipped", function( intWorkerID, intCharID, tblCharData, tblDiffFlags )
	if not tblDiffFlags["equipped"] then return end
	if not tblCharData.Equipped then return end
	
	for slotName, _ in pairs( tblDiffFlags["equipped"] ) do
		local itemName = tblCharData.Equipped[slotName]
		if not itemName then
			GAMEMODE.SQL:RemoveCharacterEquippedSlot( intWorkerID, intCharID, slotName )
		else
			GAMEMODE.SQL:InsdupCharacterEquippedItem( intWorkerID, intCharID, slotName, itemName )
		end
	end
end )

GM.SQL:RegisterDiffFlag( "data_store", function( intWorkerID, intCharID, tblCharData, tblDiffFlags )
	if not tblDiffFlags["data_store"] then return end
	if not tblCharData.SaveTable then return end
	
	for tableName, _ in pairs( tblDiffFlags["data_store"] ) do
		local data = tblCharData.SaveTable[tableName]
		if not data then
			GAMEMODE.SQL:RemoveCharacterDataStoreVar( intWorkerID, intCharID, tableName )
		else
			GAMEMODE.SQL:InsdupCharacterDataStoreVar( intWorkerID, intCharID, tableName, data )
		end
	end
end )