--[[
	Name: cl_characters.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Char = (GAMEMODE or GM).Char or {}
GM.Char.m_tblCharacters = (GAMEMODE or GM).Char.m_tblCharacters or {}
GM.Char.SEX_MALE = 0
GM.Char.SEX_FEMALE = 1

function GM.Char:Initialize()
end

function GM.Char:GetPlayerCharacters()
	return self.m_tblCharacters
end

hook.Add( "GamemodeDefineGameVars", "DefineCharacterVars", function()
	GAMEMODE.Player:DefineGameVar( "money_wallet", 0, "UInt32" )
	GAMEMODE.Player:DefineGameVar( "money_bank", 0, "UInt32" )
	GAMEMODE.Player:DefineGameVar( "char_skin", 0, "UInt8" )
	GAMEMODE.Player:DefineGameVar( "char_model_base", "", "String" )
	GAMEMODE.Player:DefineGameVar( "char_model_overload", "", "String" )
	GAMEMODE.Player:DefineGameVar( "vehicles", {}, "Table" )

	GAMEMODE.Player:DefineSharedGameVar( "name_first", "", "String", true )
	GAMEMODE.Player:DefineSharedGameVar( "name_last", "", "String", true )
	GAMEMODE.Player:DefineSharedGameVar( "char_id", 0, "UInt32", true )
	GAMEMODE.Player:DefineSharedGameVar( "char_sex", 0, "UInt4", true )

	for slotName, data in pairs( GAMEMODE.Inv.m_tblEquipmentSlots ) do
		GAMEMODE.Player:DefineSharedGameVar( "eq_slot_".. slotName, "", "String", true )
	end
end )