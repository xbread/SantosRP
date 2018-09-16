--[[
	Name: sv_bank_storage.lua
	For: TalosLife
	By: TalosLife
]]--

GM.BankStorage = {}
GM.BankStorage.MAX_UNIQUE_ITEMS = GM.Config.BankStorage_MAX_UNIQUE_ITEMS
GM.BankStorage.MAX_NUM_ITEM = GM.Config.BankStorage_MAX_NUM_ITEM
GM.BankStorage.VIP_MAX_UNIQUE_ITEMS = GM.Config.BankStorage_VIP_MAX_UNIQUE_ITEMS
GM.BankStorage.VIP_MAX_NUM_ITEM = GM.Config.BankStorage_VIP_MAX_NUM_ITEM

function GM.BankStorage:RemoveFromBank( pPlayer, strItem, intNum )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "bank_storage" then return end

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	saveTable.BankItems = saveTable.BankItems or {}

	if not saveTable.BankItems[strItem] then return end
	local count = saveTable.BankItems[strItem]	
	intNum = math.min( intNum, count )

	if not GAMEMODE.Inv:GivePlayerItem( pPlayer, strItem, intNum ) then
		return
	end

	saveTable.BankItems[strItem] = count -intNum
	if saveTable.BankItems[strItem] == 0 then
		saveTable.BankItems[strItem] = nil
	end

	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "BankItems" )
	self:SendBankUpdate( pPlayer )
end

function GM.BankStorage:AddToBank( pPlayer, strItem, intNum )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "bank_storage" then return end

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	saveTable.BankItems = saveTable.BankItems or {}

	if not saveTable.BankItems[strItem] then
		if table.Count( saveTable.BankItems ) +1 > (pPlayer:CheckGroup("vip") and self.VIP_MAX_UNIQUE_ITEMS or self.MAX_UNIQUE_ITEMS) then
			pPlayer:AddNote( "You cannot store any more unique items!" )
			return
		end
	end

	local data = GAMEMODE.Inv:GetItem( strItem )
	if not data or data.JobItem then return end
	
	local item = GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, strItem )
	if not item or item == 0 then return end
	intNum = math.min( intNum, item )

	saveTable.BankItems[strItem] = saveTable.BankItems[strItem] or 0
	if saveTable.BankItems[strItem] +intNum > (pPlayer:CheckGroup("vip") and self.VIP_MAX_NUM_ITEM or self.MAX_NUM_ITEM) then
		pPlayer:AddNote( "You cannot store any more of that item!" )
		return
	end
	
	GAMEMODE.Inv:TakePlayerItem( pPlayer, strItem, intNum )
	saveTable.BankItems[strItem] = saveTable.BankItems[strItem] +intNum

	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "BankItems" )
	self:SendBankUpdate( pPlayer )
end

function GM.BankStorage:SendBankUpdate( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	if saveTable.BankItems then
		for k, v in pairs( saveTable.BankItems ) do
			if not GAMEMODE.Inv:GetItem( k ) then saveTable.BankItems[k] = nil end	
		end
	end
	
	GAMEMODE.Net:SendPlayerBankItemUpdate( pPlayer, saveTable.BankItems or {} )
end

function GM.BankStorage:CommitLostAndFound( strSID64 )
	local gameData = GAMEMODE.Player:GetData( strSID64 )
	if not gameData or not gameData.SelectedCharacter then return end
	
	local charData = gameData.Characters[gameData.SelectedCharacter]
	if not charData or not charData.SaveTable or not charData.SaveTable.LostAndFound then return end
	
	GAMEMODE.SQL:InsdupCharacterDataStoreVar(
		GAMEMODE.SQL:GetPlayerPoolID( strSID64 ),
		gameData.SelectedCharacter,
		"LostAndFound",
		charData.SaveTable.LostAndFound
	)
end

function GM.BankStorage:ClearLostAndFound( pPlayer, bNoCommit )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.LostAndFound then return end
	saveTable.LostAndFound = {}
	
	if not bNoCommit then
		GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "LostAndFound" )
	end
end

function GM.BankStorage:AddToLostAndFound( pPlayer, strItem, intNum, bNoSend, bNoCommit )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end

	local data = GAMEMODE.Inv:GetItem( strItem )
	if not data or data.JobItem then return end
	
	saveTable.LostAndFound = saveTable.LostAndFound or {}
	saveTable.LostAndFound[strItem] = saveTable.LostAndFound[strItem] or 0
	saveTable.LostAndFound[strItem] = saveTable.LostAndFound[strItem] +intNum

	if not bNoCommit then
		GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "LostAndFound" )
	end

	if not bNoSend then self:SendLostAndFoundUpdate( pPlayer ) end
end

function GM.BankStorage:RemoveFromLostAndFound( pPlayer, strItem, intNum, bNoSend )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "bank_storage" then return end

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	saveTable.LostAndFound = saveTable.LostAndFound or {}

	if not saveTable.LostAndFound[strItem] then return end
	local count = saveTable.LostAndFound[strItem]
	intNum = math.min( intNum, count )

	if not GAMEMODE.Inv:GivePlayerItem( pPlayer, strItem, intNum ) then
		return
	end

	saveTable.LostAndFound[strItem] = saveTable.LostAndFound[strItem] -intNum
	if saveTable.LostAndFound[strItem] <= 0 then
		saveTable.LostAndFound[strItem] = nil
	end

	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "LostAndFound" )
	if not bNoSend then self:SendLostAndFoundUpdate( pPlayer ) end
end

function GM.BankStorage:DestroyLostAndFoundItem( pPlayer, strItem, intNum, bNoSend )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "bank_storage" then return end

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.LostAndFound then return end
	if not saveTable.LostAndFound[strItem] then return end
	
	saveTable.LostAndFound[strItem] = nil

	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "LostAndFound" )
	if not bNoSend then self:SendLostAndFoundUpdate( pPlayer ) end
end

function GM.BankStorage:SendLostAndFoundUpdate( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	if saveTable.LostAndFound then
		for k, v in pairs( saveTable.LostAndFound ) do
			if not GAMEMODE.Inv:GetItem( k ) then saveTable.LostAndFound[k] = nil end	
		end
	end
	
	GAMEMODE.Net:SendLostAndFoundUpdate( pPlayer, saveTable.LostAndFound or {} )
end

hook.Add( "GamemodePlayerSelectCharacter", "SendBankItems", function( pPlayer )
	GAMEMODE.BankStorage:SendBankUpdate( pPlayer )

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.LostAndFound then return end
	GAMEMODE.Net:SendLostAndFoundUpdate( pPlayer, saveTable.LostAndFound )
	if table.Count( saveTable.LostAndFound ) > 0 then
		pPlayer:AddNote( "You have items at lost and found! Claim them at the bank.", nil, 20 )
	end
end )