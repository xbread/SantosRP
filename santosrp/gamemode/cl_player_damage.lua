--[[
	Name: cl_player_damage.lua
	For: TalosLife
	By: TalosLife
]]--

GM.PlayerDamage = (GAMEMODE or GM).PlayerDamage or {}
GM.PlayerDamage.m_tblLimbMetaData = (GAMEMODE or GM).PlayerDamage.m_tblLimbMetaData or {}
GM.PlayerDamage.m_tblLimbs = {
	[HITGROUP_HEAD] = { Name = "Head", MaxHealth = 25 },
	[HITGROUP_CHEST] = { Name = "Chest", MaxHealth = 100 },
	[HITGROUP_STOMACH] = { Name = "Chest", MaxHealth = 100 },
	[HITGROUP_LEFTARM] = { Name = "Left Arm", MaxHealth = 30 },
	[HITGROUP_RIGHTARM] = { Name = "Right Arm", MaxHealth = 30 },
	[HITGROUP_LEFTLEG] = { Name = "Left Leg", MaxHealth = 30 },
	[HITGROUP_RIGHTLEG] = { Name = "Right Leg", MaxHealth = 30 },
}

function GM.PlayerDamage:Initialize()
	for k, v in pairs( self.m_tblLimbs ) do
		if self.m_tblLimbMetaData[v.Name] then continue end
		self.m_tblLimbMetaData[v.Name] = { Bleeding = false, Broken = false }
	end
end

function GM.PlayerDamage:GetPlayerLimbHealth( intLimbID )
	local limbData = self.m_tblLimbs[intLimbID]
	return GAMEMODE.Player:GetGameVar( "limb_hp_".. limbData.Name, 0 )
end

function GM.PlayerDamage:GetLimbs()
	return self.m_tblLimbs
end

function GM.PlayerDamage:GetLimbHitgroup( strLimbName )
	for k, v in pairs( self.m_tblLimbs ) do
		if v.Name == strLimbName then return k end
	end
end

function GM.PlayerDamage:SetPlayerLimbBleeding( strLimbName, bBleeding )
	self.m_tblLimbMetaData[strLimbName].Bleeding = bBleeding
end

function GM.PlayerDamage:IsPlayerLimbBleeding( intLimbID )
	local limbData = self.m_tblLimbs[intLimbID]
	return self.m_tblLimbMetaData[limbData.Name].Bleeding
end

function GM.PlayerDamage:PlayerLimbHasBandage( intLimbID )
	local limbData = self.m_tblLimbs[intLimbID]
	return GAMEMODE.Player:GetGameVar( "limb_bndg_".. limbData.Name, 0 ) > CurTime()
end

function GM.PlayerDamage:GetPlayerBandageTimeLeft( intLimbID )
	return GAMEMODE.Player:GetGameVar( "limb_bndg_".. self.m_tblLimbs[intLimbID].Name, 0 ) -CurTime()
end

function GM.PlayerDamage:SetPlayerLimbBroken( strLimbName, bBroken )
	self.m_tblLimbMetaData[strLimbName].Broken = bBroken
end

function GM.PlayerDamage:IsPlayerLimbBroken( intLimbID )
	local limbData = self.m_tblLimbs[intLimbID]
	return self.m_tblLimbMetaData[limbData.Name].Broken
end

function GM.PlayerDamage:IsPlayerLimbCrippled( intLimbID )
	return self:GetPlayerLimbHealth( intLimbID ) <= 0 or self:IsPlayerLimbBroken( intLimbID )
end

function GM.PlayerDamage:GamemodeGameVarChanged( strVar, vaOld, vaNew )
	if not strVar:StartWith( "limb_" ) then return end
	local what = strVar:sub( 6 )

	if what:StartWith( "hp_" ) then
		local limb = what:sub( 4 )
		hook.Call( "GamemodeOnPlayerLimbHealthChanged", GAMEMODE, self:GetLimbHitgroup(limb), vaNew )
	elseif what:StartWith( "bld_" ) then
		local limb = what:sub( 5 )
		self:SetPlayerLimbBleeding( limb, vaNew )
		hook.Call( "GamemodeOnPlayerLimbBleedingChanged", GAMEMODE, self:GetLimbHitgroup(limb), vaNew )
	elseif what:StartWith( "brkn_" ) then
		local limb = what:sub( 6 )
		self:SetPlayerLimbBroken( limb, vaNew )
		hook.Call( "GamemodeOnPlayerLimbBrokenChanged", GAMEMODE, self:GetLimbHitgroup(limb), vaNew )
	end
end

hook.Add( "GamemodeDefineGameVars", "DefinePlayerDamageVars", function()
	for k, v in pairs( GAMEMODE.PlayerDamage.m_tblLimbs ) do
		GAMEMODE.Player:DefineGameVar( "limb_hp_".. v.Name, 0, "UInt8", true )
		GAMEMODE.Player:DefineGameVar( "limb_bld_".. v.Name, false, "Bool", true )
		GAMEMODE.Player:DefineGameVar( "limb_brkn_".. v.Name, false, "Bool", true )
		GAMEMODE.Player:DefineGameVar( "limb_bndg_".. v.Name, 0, "Double", true )
	end
end )