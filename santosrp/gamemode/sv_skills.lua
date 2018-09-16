--[[
	Name: sv_skills.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Skills = (GAMEMODE or GM).Skills or {}
GM.Skills.m_tblSkills = (GAMEMODE or GM).Skills.m_tblSkills or {}

function GM.Skills:Initialize()
	for k, v in pairs( GAMEMODE.Config.Skills ) do
		self:RegisterSkill( k, v.MaxLevel, v.Const, v.ReductionRatio )
	end
end

function GM.Skills:RegisterSkill( strSkill, intMaxLevel, intXPConst, intReduceRatio )
	self.m_tblSkills[strSkill] = { Max = intMaxLevel, Const = intXPConst, Ratio = intReduceRatio }
end

function GM.Skills:GetSkills()
	return self.m_tblSkills
end

function GM.Skills:GetMaxLevel( strSkill )
	return self.m_tblSkills[strSkill].Max
end

function GM.Skills:GetReductionFactor( pPlayer, strSkill, intLevelTo )
	--ReductionRatio
	local diffToCurrent = self:GetPlayerLevel( pPlayer, strSkill ) -intLevelTo
	if diffToCurrent <= 0 then
		return 0
	end

	return self.m_tblSkills[strSkill].Ratio *diffToCurrent
end

function GM.Skills:GetPlayerXP( pPlayer, strSkill )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return 0 end
	if not saveTable.Skills or not saveTable.Skills[strSkill] then return 0 end
	return saveTable.Skills[strSkill]
end

function GM.Skills:SetPlayerXP( pPlayer, strSkill, intXP )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	saveTable.Skills = saveTable.Skills or {}
	
	if not saveTable.Skills[strSkill] then
		saveTable.Skills[strSkill] = 0
	end

	local lastLevel = self:GetPlayerLevel( pPlayer, strSkill )
	saveTable.Skills[strSkill] = intXP
	local newLevel = self:GetPlayerLevel( pPlayer, strSkill )

	if lastLevel ~= newLevel then
		self:OnPlayerLevelUp( pPlayer, strSkill, lastLevel, newLevel )
	end

	GAMEMODE.Player:SetGameVar( pPlayer, "skill_".. strSkill, saveTable.Skills[strSkill] )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Skills" )
end

function GM.Skills:GetPlayerLevel( pPlayer, strSkill )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return 1 end
	if not saveTable.Skills or not saveTable.Skills[strSkill] then return 1 end
	
	local skillData = self.m_tblSkills[strSkill]
	return math.min( math.floor(skillData.Const *math.sqrt(saveTable.Skills[strSkill]) ) +1, skillData.Max )
end

function GM.Skills:GetXPForLevel( strSkill, intLevel )
	local skillData = self.m_tblSkills[strSkill]
	local x = intLevel /skillData.Const
	return x *x
end

function GM.Skills:GivePlayerXP( pPlayer, strSkill, intXP )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	saveTable.Skills = saveTable.Skills or {}

	if not saveTable.Skills[strSkill] then
		saveTable.Skills[strSkill] = 0
	end

	local skillData = self.m_tblSkills[strSkill]
	local lastLevel = self:GetPlayerLevel( pPlayer, strSkill )
	if lastLevel >= skillData.Max then return end

	saveTable.Skills[strSkill] = saveTable.Skills[strSkill] +intXP
	local newLevel = self:GetPlayerLevel( pPlayer, strSkill )

	if lastLevel ~= newLevel then
		self:OnPlayerLevelUp( pPlayer, strSkill, lastLevel, newLevel )
	end

	GAMEMODE.Player:SetGameVar( pPlayer, "skill_".. strSkill, saveTable.Skills[strSkill] )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "Skills" )
end

function GM.Skills:OnPlayerLevelUp( pPlayer, strSkill, intOldLevel, intNewLevel )
	local skillData = self.m_tblSkills[strSkill]
	if intNewLevel >= skillData.Max then
		local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
		if not saveTable or not saveTable.Skills or not saveTable.Skills[strSkill] then return end
		local maxXP = self:GetXPForLevel( strSkill, skillData.Max )

		if saveTable.Skills[strSkill] > maxXP then
			saveTable.Skills[strSkill] = maxXP
		end
	end

	pPlayer:AddNote( "You leveled up your ".. strSkill.. " skill!" )
	hook.Call( "GamemodePlayerLevelUpSkill", GAMEMODE, pPlayer, strSkill, intOldLevel, intNewLevel )
end

function GM.Skills:DefineCharacterSkills( pPlayer )
	for k, v in pairs( self.m_tblSkills ) do
		GAMEMODE.Player:DefineGameVar( pPlayer, "skill_".. k, 0, "UInt32", true )
	end
end

function GM.Skills:ApplySavedCharacterSkills( pPlayer )
	--reset everything
	for k, v in pairs( self.m_tblSkills ) do
		GAMEMODE.Player:SetGameVar( pPlayer, "skill_".. k, 0, true )
	end

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Skills then return end

	for k, v in pairs( saveTable.Skills ) do
		if not self.m_tblSkills[k] then continue end
		GAMEMODE.Player:SetGameVar( pPlayer, "skill_".. k, v, true )
	end
end

--[[ Game Vars ]]--
hook.Add( "GamemodeDefineGameVars", "DefineSkillVars", function( pPlayer )
	GAMEMODE.Skills:DefineCharacterSkills( pPlayer )
end )

hook.Add( "GamemodePlayerSelectCharacter", "ApplySkillVars", function( pPlayer )
	GAMEMODE.Skills:ApplySavedCharacterSkills( pPlayer )
end )

concommand.Add( "srp_dev_give_xp", function( pPlayer, strCmd, tblArgs )
	if not pPlayer:IsSuperAdmin() then return end
	
	local skill = tostring( tblArgs[1] )
	local num = tonumber( tblArgs[2] )
	GAMEMODE.Skills:GivePlayerXP( pPlayer, skill, num )
end )

concommand.Add( "srp_dev_set_level", function( pPlayer, strCmd, tblArgs )
	if not pPlayer:IsSuperAdmin() then return end
	
	local skill = tostring( tblArgs[1] )
	local level = tonumber( tblArgs[2] )
	GAMEMODE.Skills:SetPlayerXP( pPlayer, skill, GAMEMODE.Skills:GetXPForLevel(skill, level) )
end )

--[[concommand.Add( "srp_dev_set_level_vip", function( pPlayer, strCmd, tblArgs )
	if not pPlayer:IsSuperAdmin() then return end

	local skill = "Stamina"
	local level = 19
	GAMEMODE.Skills:SetPlayerXP( pPlayer, skill, GAMEMODE.Skills:GetXPForLevel(skill, level) )
end )--]]