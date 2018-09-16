--[[
	Name: cl_skills.lua
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

function GM.Skills:GetReductionFactor( strSkill, intLevelTo )
	--ReductionRatio
	local diffToCurrent = self:GetPlayerLevel( strSkill ) -intLevelTo
	if diffToCurrent <= 0 then
		return 0
	end

	return self.m_tblSkills[strSkill].Ratio *diffToCurrent
end

function GM.Skills:GetPlayerXP( strSkill )
	return GAMEMODE.Player:GetGameVar( "skill_"..strSkill, 0 )
end

function GM.Skills:GetPlayerLevel( strSkill )
	local xp = GAMEMODE.Player:GetGameVar( "skill_"..strSkill, 0 )
	local skillData = self.m_tblSkills[strSkill]
	return math.floor( skillData.Const *math.sqrt(xp) ) +1
end

function GM.Skills:GetXPForLevel( strSkill, intLevel )
	local skillData = self.m_tblSkills[strSkill]
	local x = intLevel /skillData.Const
	return x *x
end

function GM.Skills:DefineCharacterSkills()
	for k, v in pairs( GAMEMODE.Config.Skills ) do
		GAMEMODE.Player:DefineGameVar( "skill_".. k, 0, "UInt32" )
	end
end

--[[ Game Vars ]]--
hook.Add( "GamemodeDefineGameVars", "DefineSkillVars", function()
	GAMEMODE.Skills:DefineCharacterSkills()
end )