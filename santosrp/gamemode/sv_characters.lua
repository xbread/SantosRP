--[[
	Name: sv_characters.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Char = {}
GM.Char.SEX_MALE = 0
GM.Char.SEX_FEMALE = 1

function GM.Char:SendCharacterErrorMsg( pPlayer, strMsg )
	GAMEMODE.Net:SendCharacterErrorMsg( pPlayer, strMsg )
end

function GM.Char:NewCharacter()
	local newCharacter = {
		Name = { First = "", Last = "" },
		Model = { Base = "", Overload = nil },
		Sex = self.SEX_MALE,
		Skin = 0,
		Inventory = {},
		Equipped = {},
		Money = { Wallet = 0, Bank = 0 },
		Vehicles = {},
		SaveTable = {},
	}

	return newCharacter
end

function GM.Char:GetPlayerCharacters( pPlayer )
	if not pPlayer:GetGamemodeData() then return end
	return pPlayer:GetGamemodeData().Characters
end

function GM.Char:GetPlayerCharacter( pPlayer )
	return self:GetPlayerCharacters( pPlayer )[pPlayer:GetCharacterID()]
end

function GM.Char:GetCharacterSaveTable( pPlayer, intCharID )
	return self:GetPlayerCharacters( pPlayer )[intCharID].SaveTable
end

function GM.Char:GetCurrentSaveTable( pPlayer )
	if not pPlayer:GetGamemodeData() then return end
	if not pPlayer:GetGamemodeData().SelectedCharacter then return end
	return self:GetCharacterSaveTable( pPlayer, pPlayer:GetCharacterID() )
end

function GM.Char:PlayerCreateCharacter( pPlayer, tblChar )
	if not pPlayer:GetGamemodeData() then return end
	if pPlayer.m_bInCharCreateQuery then return end
	
	--[[ Validate the name ]]--
	--Check for valid data
	if type( tblChar.Name.First ) ~= "string" or type( tblChar.Name.Last ) ~= "string" then
		self:SendCharacterErrorMsg( pPlayer, "You must enter a first and last name." )
		return
	end

	--Check for 0 length
	if tblChar.Name.First:len() == 0 or tblChar.Name.Last:len() == 0 then
		self:SendCharacterErrorMsg( pPlayer, "You must enter a first and last name." )
		return
	end

	--Check for lazy people
	if tblChar.Name.First:lower() == "john" and tblChar.Name.Last:lower() == "doe" then
		self:SendCharacterErrorMsg( pPlayer, "Stop being lazy and think of a better name!" )
		return		
	end

	--Check for numbers
	if tblChar.Name.First:match( "[0-9]" ) or tblChar.Name.Last:match( "[0-9]" ) then
		self:SendCharacterErrorMsg( pPlayer, "Your name may not have any numbers in it." )
		return
	end

	--Check for banned chars
	if tblChar.Name.First:match( "[./&><-]" ) or tblChar.Name.Last:match( "[./&><-]" ) then
		self:SendCharacterErrorMsg( pPlayer, "Your name may not have any of the following characters - ./&><-" )
		return
	end

	--Check for over max length
	if tblChar.Name.First:len() == GAMEMODE.Config.NameLength.First then
		self:SendCharacterErrorMsg( pPlayer, ("Your first name may not exceed %s characters."):format(GAMEMODE.Config.NameLength.First) )
		return
	end
	if tblChar.Name.Last:len() == GAMEMODE.Config.NameLength.Last then
		self:SendCharacterErrorMsg( pPlayer, ("Your last name may not exceed %s characters."):format(GAMEMODE.Config.NameLength.Last) )
		return
	end

	--[[ Validate the sex and model ]]--
	if tblChar.Sex ~= self.SEX_MALE and tblChar.Sex ~= self.SEX_FEMALE then
		self:SendCharacterErrorMsg( pPlayer, "Internal Error: Invalid sex." )
		return
	end

	local modelList = GAMEMODE.Config.PlayerModels[tblChar.Sex == self.SEX_MALE and "Male" or "Female"]
	if not modelList[tblChar.Model or ""] then
		self:SendCharacterErrorMsg( pPlayer, "Internal Error: Invalid model." )
		return
	end

	--[[ Validate the skin ]]--
	if not GAMEMODE.Util:ValidPlayerSkin( tblChar.Model, tblChar.Skin or 0 ) then
		self:SendCharacterErrorMsg( pPlayer, "Internal Error: Invalid skin." )
		return
	end

	--Check if this name is already taken, if not then create the character
	pPlayer.m_bInCharCreateQuery = true
	GAMEMODE.SQL:CheckCharacterNameTaken( tblChar.Name.First, tblChar.Name.Last, function( bNameTaken )
		if not IsValid( pPlayer ) then return end
		if bNameTaken then
			self:SendCharacterErrorMsg( pPlayer, "This name is already in use!" )
			pPlayer.m_bInCharCreateQuery = false
			return
		end

		--Create the new character data
		local newChar = self:NewCharacter()
		newChar.Name.First = tblChar.Name.First
		newChar.Name.Last = tblChar.Name.Last
		newChar.Sex = tblChar.Sex
		newChar.Model.Base = tblChar.Model
		newChar.Skin = tblChar.Skin
		newChar.Money = {
			Wallet = GAMEMODE.Config.StartingMoney.Wallet,
			Bank = GAMEMODE.Config.StartingMoney.Bank,
		}

		GAMEMODE.SQL:InsertNewCharacter( pPlayer, newChar, function( intCharID )
			if not IsValid( pPlayer ) then return end
			pPlayer.m_bInCharCreateQuery = false
			self:GetPlayerCharacters(pPlayer)[intCharID] = newChar
			self:PlayerSelectCharacter( pPlayer, intCharID )
		end )
	end )
end

function GM.Char:PlayerSelectCharacter( pPlayer, intCharID )
	if not pPlayer:GetGamemodeData() then return end
	local selectedChar = self:GetPlayerCharacters( pPlayer )[intCharID]
	if not selectedChar then return end

	if self:GetPlayerCharacter( pPlayer ) then
		if pPlayer:GetGamemodeData().SelectedCharacter == intCharID then return end
	
		GAMEMODE.SQL:CommitPlayerDiffs( pPlayer:SteamID64() )

		--Player already had a character, remove any stuff on the map they own before they switch
		for k, v in pairs( ents.GetAll() ) do
			if v:GetPlayerOwner() == pPlayer then
				v:Remove()
			end
		end
	end

	pPlayer:GetGamemodeData().SelectedCharacter = intCharID
	GAMEMODE.SQL:ClearPlayerDiffTable( pPlayer:SteamID64() ) --Clear the sql diff table
	GAMEMODE.Jobs:SetPlayerJob( pPlayer, JOB_CIVILIAN ) --Set them to the civ job
	self:OnPlayerSelectCharacter( pPlayer, intCharID, selectedChar )

	pPlayer:KillSilent()
	pPlayer:Spawn()
end

function GM.Char:OnPlayerSelectCharacter( pPlayer, intCharID, tblChar )
	--Apply the new game vars for the selected character
	GAMEMODE.Player:SetGameVar( pPlayer, "money_wallet", tblChar.Money.Wallet, true )
	GAMEMODE.Player:SetGameVar( pPlayer, "money_bank", tblChar.Money.Bank, true )
	GAMEMODE.Player:SetGameVar( pPlayer, "char_skin", tblChar.Skin, true )
	GAMEMODE.Player:SetGameVar( pPlayer, "char_model_base", tblChar.Model.Base, true )
	GAMEMODE.Player:SetGameVar( pPlayer, "char_model_overload", tblChar.Model.Overload or "", true )
	GAMEMODE.Player:SetGameVar( pPlayer, "vehicles", tblChar.Vehicles, true )

	GAMEMODE.Player:SetSharedGameVar( pPlayer, "name_first", tblChar.Name.First, true )
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "name_last", tblChar.Name.Last, true )
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "char_id", intCharID, true )
	GAMEMODE.Player:SetSharedGameVar( pPlayer, "char_sex", tblChar.Sex, true )

	--Apply any saved equipment slots
	for slotName, data in pairs( GAMEMODE.Inv.m_tblEquipmentSlots ) do
		GAMEMODE.Player:SetSharedGameVar( pPlayer, "eq_slot_".. slotName, tblChar.Equipped[slotName] or "", true )
	end

	hook.Call( "GamemodePlayerSelectCharacter", GAMEMODE, pPlayer, intCharID, tblChar )

	--Let the player know we are loading all their stuff
	GAMEMODE.Net:SendPlayerLoadingCharacter( pPlayer )

	--Send all of this stuff on delays, maybe it will help with the spawn delay?
	local delayInterval = 1
	timer.Simple( delayInterval, function() --Send the players game vars
		if not IsValid( pPlayer ) then return end
		GAMEMODE.Net:SendFullGameVarUpdate( pPlayer )

		timer.Simple( delayInterval, function() --Send the players inventory
			if not IsValid( pPlayer ) then return end
			GAMEMODE.Net:SendFullInventoryUpdate( pPlayer )

			timer.Simple( delayInterval, function() --Send the players shared game vars
				if not IsValid( pPlayer ) then return end
				GAMEMODE.Net:SendFullSharedGameVarUpdate( pPlayer )

				timer.Simple( delayInterval, function() --Update the players in-game status
					if not IsValid( pPlayer ) then return end
					GAMEMODE.Net:SetPlayerInGame( pPlayer, true )
				end )
			end )
		end )
	end )

	--Send the new players game vars to everyone else
	GAMEMODE.Net:SendAllSharedGameVarUpdate( pPlayer )
end

hook.Add( "GamemodeDefineGameVars", "DefineCharacterVars", function( pPlayer )
	GAMEMODE.Player:DefineGameVar( pPlayer, "money_wallet", 0, "UInt32", true )
	GAMEMODE.Player:DefineGameVar( pPlayer, "money_bank", 0, "UInt32", true )
	GAMEMODE.Player:DefineGameVar( pPlayer, "char_skin", 0, "UInt8", true )
	GAMEMODE.Player:DefineGameVar( pPlayer, "char_model_base", "", "String", true )
	GAMEMODE.Player:DefineGameVar( pPlayer, "char_model_overload", "", "String", true )
	GAMEMODE.Player:DefineGameVar( pPlayer, "vehicles", {}, "Table", true )

	GAMEMODE.Player:DefineSharedGameVar( pPlayer, "name_first", "", "String", true )
	GAMEMODE.Player:DefineSharedGameVar( pPlayer, "name_last", "", "String", true )
	GAMEMODE.Player:DefineSharedGameVar( pPlayer, "char_id", 0, "UInt32", true )
	GAMEMODE.Player:DefineSharedGameVar( pPlayer, "char_sex", 0, "UInt4", true )
	
	for slotName, data in pairs( GAMEMODE.Inv.m_tblEquipmentSlots ) do
		GAMEMODE.Player:DefineSharedGameVar( pPlayer, "eq_slot_".. slotName, "", "String", true )
	end
end )