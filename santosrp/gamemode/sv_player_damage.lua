--[[
	Name: sv_player_damage.lua
	For: TalosLife
	By: TalosLife
]]--

GM.PlayerDamage = {}
GM.PlayerDamage.m_tblLimbs = {
	[HITGROUP_HEAD] = {
		Name = "Head",
		MaxHealth = 25,
		DmgScale = { [DMG_BULLET] = 20, [DMG_CRUSH] = 0.175, Other = 0.5 },
		BleedThreshold = 5,
		BoneBreakThreshold = 20,
		FXAttachID = "anim_attachment_head",
	},
	[HITGROUP_CHEST] = {
		Name = "Chest",
		MaxHealth = 100,
		DmgScale = { [DMG_CRUSH] = 0.175, Other = 1 },
		BleedThreshold = 5,
		BoneBreakThreshold = 25,
		FXAttachID = "chest",
	},
	[HITGROUP_STOMACH] = {
		Name = "Chest",
		MaxHealth = 100,
		DmgScale = { [DMG_CRUSH] = 0.175, Other = 1 },
		BleedThreshold = 5,
		BoneBreakThreshold = 25,
		FXAttachID = "chest",
	},
	[HITGROUP_LEFTARM] = {
		Name = "Left Arm",
		MaxHealth = 30,
		DmgScale = { [DMG_CRUSH] = 0.175, Other = 0.5 },
		BleedThreshold = 3,
		BoneBreakThreshold = 10,
		FXAttachID = "anim_attachment_LH",
	},
	[HITGROUP_RIGHTARM] = {
		Name = "Right Arm",
		MaxHealth = 30,
		DmgScale = { [DMG_CRUSH] = 0.175, Other = 0.5 },
		BleedThreshold = 3,
		BoneBreakThreshold = 10,
		FXAttachID = "anim_attachment_RH",
	},
	[HITGROUP_LEFTLEG] = {
		Name = "Left Leg",
		MaxHealth = 30,
		DmgScale = { [DMG_CRUSH] = 0.175, Other = 0.5 },
		BleedThreshold = 3,
		BoneBreakThreshold = 10
	},
	[HITGROUP_RIGHTLEG] = {
		Name = "Right Leg",
		MaxHealth = 30,
		DmgScale = { [DMG_CRUSH] = 0.175, Other = 0.5 },
		BleedThreshold = 3,
		BoneBreakThreshold = 10
	},
}
GM.PlayerDamage.m_tblDmgBreaksBones = { DMG_CRUSH, DMG_VEHICLE, DMG_FALL, DMG_BLAST, DMG_CLUB }
GM.PlayerDamage.m_tblDmgStartsBleeding = { DMG_BULLET, DMG_BUCKSHOT, DMG_SLASH, DMG_BLAST, DMG_BURN }
GM.PlayerDamage.m_intDmgBreaksBones = bit.bor( DMG_CRUSH, DMG_VEHICLE, DMG_FALL, DMG_BLAST, DMG_CLUB )
GM.PlayerDamage.m_intDmgStartsBleeding = bit.bor( DMG_BULLET, DMG_BUCKSHOT, DMG_SLASH, DMG_BLAST, DMG_BURN )

PrecacheParticleSystem( "blood_advisor_pierce_spray_b" )

function GM.PlayerDamage:InitPlayerLimbHealth( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	pPlayer.m_tblLimbMetaData = {}

	for k, v in pairs( self.m_tblLimbs ) do
		pPlayer.m_tblLimbMetaData[v.Name] = {
			Bleeding = false,
			Broken = false,
			BandageTime = nil,
		}

		if saveTable and saveTable.LimbDamage and saveTable.LimbDamage[v.Name] then
			GAMEMODE.Player:SetGameVar( pPlayer, "limb_hp_".. v.Name, math.Clamp(saveTable.LimbDamage[v.Name].Health, 0, v.MaxHealth), true )
			pPlayer.m_tblLimbMetaData[v.Name] = {
				Bleeding = saveTable.LimbDamage[v.Name].Bleeding,
				Broken = saveTable.LimbDamage[v.Name].Broken,
			}

			GAMEMODE.Player:SetGameVar( pPlayer, "limb_bld_".. v.Name, pPlayer.m_tblLimbMetaData[v.Name].Bleeding, true )
			GAMEMODE.Player:SetGameVar( pPlayer, "limb_brkn_".. v.Name, pPlayer.m_tblLimbMetaData[v.Name].Broken, true )
		else
			GAMEMODE.Player:SetGameVar( pPlayer, "limb_hp_".. v.Name, v.MaxHealth, true )
			GAMEMODE.Player:SetGameVar( pPlayer, "limb_bld_".. v.Name, false, true )
			GAMEMODE.Player:SetGameVar( pPlayer, "limb_brkn_".. v.Name, false, true )
		end
	end

	for k, v in pairs( pPlayer.m_tblLimbMetaData ) do
		local data = self:GetLimbHitgroup( k )
		if v.Broken and data then
			self:OnPlayerBreakLimb( pPlayer, data )
		end

		if v.Bleeding and data then
			self:OnPlayerLimbStartBleeding( pPlayer, data )
		end
	end
end

function GM.PlayerDamage:Tick()
	self:TickPlayerBleeding()
end

function GM.PlayerDamage:SetPlayerLimbHealth( pPlayer, intLimbID, intHealth, bDontNetwork )
	local limbData = self.m_tblLimbs[intLimbID]
	GAMEMODE.Player:SetGameVar( pPlayer, "limb_hp_".. limbData.Name, math.Clamp(math.ceil(intHealth), 0, limbData.MaxHealth), bDontNetwork )
	self:OnPlayerLimbHealthChanged( pPlayer, intLimbID, self:GetPlayerLimbHealth(pPlayer, intLimbID) )
end

function GM.PlayerDamage:GetPlayerLimbHealth( pPlayer, intLimbID )
	local limbData = self.m_tblLimbs[intLimbID]
	return GAMEMODE.Player:GetGameVar( pPlayer, "limb_hp_".. limbData.Name, 0 )
end

function GM.PlayerDamage:GetLimbs()
	return self.m_tblLimbs
end

function GM.PlayerDamage:GetLimbHitgroup( strLimbName )
	for k, v in pairs( self.m_tblLimbs ) do
		if v.Name == strLimbName then return k end
	end
end

function GM.PlayerDamage:PlayerHasDamagedLimbs( pPlayer, bOnlyHealth, intMinPercent )
	for k, v in pairs( self.m_tblLimbs ) do
		if self:GetPlayerLimbHealth( pPlayer, k ) < (intMinPercent and v.MaxHealth *intMinPercent or v.MaxHealth) then return true end
		if not bOnlyHealth then
			if self:IsPlayerLimbBroken( pPlayer, k ) then return true end
			if self:IsPlayerLimbBleeding( pPlayer, k ) then return true end
		end
	end

	return false
end

function GM.PlayerDamage:GetDamageScale( intLimbID, intDmgType )
	local scale = self.m_tblLimbs[intLimbID].DmgScale
	if type( scale ) == "table" then
		if scale[intDmgType] then
			scale = scale[intDmgType]
		else
			scale = scale.Other
		end
	end

	return scale
end

--[[ Bleeding ]]--
function GM.PlayerDamage:SetPlayerLimbBleeding( pPlayer, intLimbID, bBleeding, bDontNetwork )
	local last = pPlayer.m_tblLimbMetaData[self.m_tblLimbs[intLimbID].Name].Bleeding
	pPlayer.m_tblLimbMetaData[self.m_tblLimbs[intLimbID].Name].Bleeding = bBleeding
	GAMEMODE.Player:SetGameVar( pPlayer, "limb_bld_".. self.m_tblLimbs[intLimbID].Name, bBleeding, bDontNetwork or (last == bBleeding) )

	if bBleeding then
		self:OnPlayerLimbStartBleeding( pPlayer, intLimbID )
	else
		self:OnPlayerLimbStopBleeding( pPlayer, intLimbID )
	end

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	saveTable.LimbDamage = saveTable.LimbDamage or {}

	if not saveTable.LimbDamage[self.m_tblLimbs[intLimbID].Name] then return end
	saveTable.LimbDamage[self.m_tblLimbs[intLimbID].Name].Bleeding = bBleeding

	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "LimbDamage" )
end

function GM.PlayerDamage:IsPlayerLimbBleeding( pPlayer, intLimbID )
	return pPlayer.m_tblLimbMetaData[self.m_tblLimbs[intLimbID].Name].Bleeding
end

function GM.PlayerDamage:IsPlayerBleeding( pPlayer )
	for k, v in pairs( pPlayer.m_tblLimbMetaData or {} ) do
		if v.Bleeding then return true end
	end
	return false
end

function GM.PlayerDamage:ApplyPlayerLimbBandage( pPlayer, intLimbID, intDieTime )
	pPlayer.m_tblLimbMetaData[self.m_tblLimbs[intLimbID].Name].BandageTime = CurTime() +intDieTime
	GAMEMODE.Player:SetGameVar(
		pPlayer,
		"limb_bndg_".. self.m_tblLimbs[intLimbID].Name,
		pPlayer.m_tblLimbMetaData[self.m_tblLimbs[intLimbID].Name].BandageTime
	)
end

function GM.PlayerDamage:RemovePlayerLimbBandage( pPlayer, intLimbID, bDontNetwork )
	pPlayer.m_tblLimbMetaData[self.m_tblLimbs[intLimbID].Name].BandageTime = nil
	GAMEMODE.Player:SetGameVar( pPlayer, "limb_bndg_".. self.m_tblLimbs[intLimbID].Name, 0, bDontNetwork )
end

function GM.PlayerDamage:PlayerLimbHasBandage( pPlayer, intLimbID )
	return (pPlayer.m_tblLimbMetaData[self.m_tblLimbs[intLimbID].Name].BandageTime or 0) > CurTime()
end

function GM.PlayerDamage:OnPlayerLimbStartBleeding( pPlayer, intLimbID )
end

function GM.PlayerDamage:OnPlayerLimbStopBleeding( pPlayer, intLimbID )
end

function GM.PlayerDamage:TickPlayerBleeding()
	local time = CurTime()
	if (self.m_intLastBleedTick or 0) > time then return end
	self.m_intLastBleedTick = time +2

	local num
	for k, v in pairs( player.GetAll() ) do
		if not v.m_tblLimbMetaData then continue end
		
		--get the number of bleeding limbs
		--play blood effects
		num = 0
		for k2, v2 in pairs( v.m_tblLimbMetaData ) do
			if v2.Bleeding and not (v.BandageTime or 0 > time) then
				num = num +1
				--local data = self.m_tblLimbs[self:GetLimbHitgroup(k2) or 0]
				--if data and data.FXAttachID then
				--	ParticleEffectAttach( "blood_advisor_pierce_spray_b", PATTACH_POINT_FOLLOW, v, v:LookupAttachment(data.FXAttachID) or 0 )
				--end
			end
		end
		
		if (v.m_intLastBleedingTick or 0) > time then continue end
		v.m_intLastBleedingTick = time +GAMEMODE.Config.BleedInterval

		if num <= 0 then continue end
		if not v:Alive() or v:IsUncon() then continue end
		local dmg = GAMEMODE.Config.BleedDamage *num

		local dmgInfo = DamageInfo()
		dmgInfo:SetDamageType( DMG_DIRECT )
		dmgInfo:SetDamage( dmg )
		v:TakeDamageInfo( dmgInfo )
		v:AddNote( "You are bleeding!" )
	end
end

--[[ Broken Bones ]]--
function GM.PlayerDamage:SetPlayerLimbBroken( pPlayer, intLimbID, bBroken, bDontNetwork )
	local last = pPlayer.m_tblLimbMetaData[self.m_tblLimbs[intLimbID].Name].Broken
	pPlayer.m_tblLimbMetaData[self.m_tblLimbs[intLimbID].Name].Broken = bBroken
	GAMEMODE.Player:SetGameVar( pPlayer, "limb_brkn_".. self.m_tblLimbs[intLimbID].Name, bBroken, bDontNetwork or (last == bBroken) )
	
	if bBroken then
		self:OnPlayerBreakLimb( pPlayer, intLimbID )
	else
		self:OnPlayerFixBrokenLimb( pPlayer, intLimbID )
	end

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	saveTable.LimbDamage = saveTable.LimbDamage or {}

	if not saveTable.LimbDamage[self.m_tblLimbs[intLimbID].Name] then return end
	saveTable.LimbDamage[self.m_tblLimbs[intLimbID].Name].Broken = bBroken

	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "LimbDamage" )
end

function GM.PlayerDamage:IsPlayerLimbBroken( pPlayer, intLimbID )
	if not pPlayer.m_tblLimbMetaData[self.m_tblLimbs[intLimbID].Name] then return false end
	return pPlayer.m_tblLimbMetaData[self.m_tblLimbs[intLimbID].Name].Broken
end

function GM.PlayerDamage:PlayerHasBrokenBone( pPlayer )
	for k, v in pairs( pPlayer.m_tblLimbMetaData or {} ) do
		if v.Broken then return true end
	end
	return false
end

function GM.PlayerDamage:OnPlayerBreakLimb( pPlayer, intLimbID )
	local mod = 0
	if self:IsPlayerLimbBroken( pPlayer, HITGROUP_LEFTLEG ) then mod = mod +0.5 end
	if self:IsPlayerLimbBroken( pPlayer, HITGROUP_RIGHTLEG ) then mod = mod +0.5 end

	if mod > 0 then
		GAMEMODE.Player:ModifyMoveSpeed( pPlayer, "BrokenLimbs", -15 *mod, -1000 )
	end
end

function GM.PlayerDamage:OnPlayerFixBrokenLimb( pPlayer, intLimbID )
	local mod = 0
	if self:IsPlayerLimbBroken( pPlayer, HITGROUP_LEFTLEG ) then mod = mod +0.5 end
	if self:IsPlayerLimbBroken( pPlayer, HITGROUP_RIGHTLEG ) then mod = mod +0.5 end

	if mod > 0 then
		GAMEMODE.Player:ModifyMoveSpeed( pPlayer, "BrokenLimbs", -15 *mod, -1000 )
	else
		if GAMEMODE.Player:IsMoveSpeedModifierActive( pPlayer, "BrokenLimbs" ) then
			GAMEMODE.Player:RemoveMoveSpeedModifier( pPlayer, "BrokenLimbs" )
		end
	end
end

function GM.PlayerDamage:IsPlayerLimbCrippled( pPlayer, intLimbID )
	return self:GetPlayerLimbHealth( pPlayer, intLimbID ) <= 0 or self:IsPlayerLimbBroken( pPlayer, intLimbID )
end

function GM.PlayerDamage:HealPlayerLimbs( pPlayer )
	local vars = {}
	for k, v in pairs( self.m_tblLimbs ) do
		self:SetPlayerLimbHealth( pPlayer, k, v.MaxHealth, true )
		self:SetPlayerLimbBleeding( pPlayer, k, false, true )
		self:SetPlayerLimbBroken( pPlayer, k, false, true )
		vars["limb_hp_".. self.m_tblLimbs[k].Name] = true
		vars["limb_bld_".. self.m_tblLimbs[k].Name] = true
		vars["limb_brkn_".. self.m_tblLimbs[k].Name] = true
		vars["limb_bndg_".. self.m_tblLimbs[k].Name] = true
		self:OnPlayerFixBrokenLimb( pPlayer, k )
		self:OnPlayerLimbStopBleeding( pPlayer, k )
		self:RemovePlayerLimbBandage( pPlayer, k, true )
	end
	
	GAMEMODE.Net:SendGameVarBatchedUpdate( pPlayer, vars )
end

function GM.PlayerDamage:HealPlayerLimb( pPlayer, intLimbID )
	local vars, limbData = {}, self.m_tblLimbs[intLimbID]
	self:SetPlayerLimbHealth( pPlayer, intLimbID, limbData.MaxHealth, true  )
	self:SetPlayerLimbBleeding( pPlayer, intLimbID, false, true )
	self:SetPlayerLimbBroken( pPlayer, intLimbID, false, true )
	vars["limb_hp_".. limbData.Name] = true
	vars["limb_bld_".. limbData.Name] = true
	vars["limb_brkn_".. limbData.Name] = true
	vars["limb_bndg_".. self.m_tblLimbs[intLimbID].Name] = true

	self:OnPlayerFixBrokenLimb( pPlayer, intLimbID )
	self:OnPlayerLimbStopBleeding( pPlayer, intLimbID )
	self:RemovePlayerLimbBandage( pPlayer, intLimbID, true )
	GAMEMODE.Net:SendGameVarBatchedUpdate( pPlayer, vars )
end

--Modify bullet spread if some bones are broken
function GM.PlayerDamage:EntityFireBullets( eEnt, tblBullet )
	if not eEnt:IsPlayer() then return end
	local num = 0
	if self:IsPlayerLimbBroken( eEnt, HITGROUP_LEFTARM ) then num = num +0.009 end
	if self:IsPlayerLimbBroken( eEnt, HITGROUP_RIGHTARM ) then num = num +0.009 end
	if self:IsPlayerLimbBroken( eEnt, HITGROUP_CHEST ) then num = num +0.0075 end
	if self:IsPlayerLimbBroken( eEnt, HITGROUP_HEAD ) then num = num +0.0075 end

	tblBullet.Dir = tblBullet.Dir +Vector( math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1) ) *num
	return num > 0
end

--[[ Damage events ]]--
function GM.PlayerDamage:OnPlayerLimbHealthChanged( pPlayer, intLimbID, intLimbHealth )
	hook.Call( "GamemodeOnPlayerLimbHealthChanged", GAMEMODE, pPlayer, intLimbID, intHealth )

	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end
	saveTable.LimbDamage = saveTable.LimbDamage or {}
	saveTable.LimbDamage[self.m_tblLimbs[intLimbID].Name] = {
		Health = intLimbHealth,
		Bleeding = self:IsPlayerLimbBleeding( pPlayer, intLimbID ),
		Broken = self:IsPlayerLimbBroken( pPlayer, intLimbID )
	}

	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "data_store", "LimbDamage" )
end

function GM.PlayerDamage:PlayerLimbTakeDamage( pPlayer, intLimbID, intDmg, intDmgType, bNoTakeDamage )
	self:SetPlayerLimbHealth( pPlayer, intLimbID, self:GetPlayerLimbHealth(pPlayer, intLimbID) -intDmg )
	local newVal = self:GetPlayerLimbHealth( pPlayer, intLimbID )

	local playDamgSnd
	if table.HasValue( self.m_tblDmgStartsBleeding, bit.band(self.m_intDmgStartsBleeding, intDmgType) ) then
		if intDmg >= self.m_tblLimbs[intLimbID].BleedThreshold or newVal <= 0 then --bleeding
			self:SetPlayerLimbBleeding( pPlayer, intLimbID, true )
			playDamgSnd = true
		end
	end

	if table.HasValue( self.m_tblDmgBreaksBones, bit.band(self.m_intDmgBreaksBones, intDmgType) ) then
		if intDmg >= self.m_tblLimbs[intLimbID].BoneBreakThreshold or newVal <= 0 then --break bones
			self:SetPlayerLimbBroken( pPlayer, intLimbID, true )
			playDamgSnd = true
		end
	end

	local scale = self:GetDamageScale( intLimbID, bit.band(bit.bor(self.m_intDmgStartsBleeding, self.m_intDmgBreaksBones), intDmgType) )
	if not bNoTakeDamage then
		local dmgInfo = DamageInfo()
		dmgInfo:SetDamage( intDmg )
		dmgInfo:SetAttacker( Entity(0) )
		dmgInfo:SetInflictor( Entity(0) )
		dmgInfo:SetDamageType( intDmgType )

		dmgInfo:ScaleDamage( scale )
		pPlayer:TakeDamageInfo( dmgInfo )
	end

	return scale
end

--Passes damage to limbs for some kinds of damage, ie vehicle collisions
function GM.PlayerDamage:EntityTakeDamage( eEnt, pDamageInfo )
	if not IsValid( eEnt ) or not eEnt:IsPlayer() then return end
	local attacker = pDamageInfo:GetAttacker()
	
	if IsValid( attacker ) and attacker:IsVehicle() then
		pDamageInfo:ScaleDamage( 1 *(pDamageInfo:GetDamageForce():Length() /64000) )
		local dmg = pDamageInfo:GetDamage()
		local scale, num = 0, math.min( math.ceil(dmg /8), 7 )
		
		for i = 1, num do
			local data, limb = table.Random( self.m_tblLimbs ) --Random each time
			scale = scale +self:PlayerLimbTakeDamage( eEnt, limb, dmg, DMG_VEHICLE, true )
		end

		if dmg >= 5 and eEnt:Health() -pDamageInfo:GetDamage() > 0 then --If the vehicle damage is high enough, ragdoll them!
			if not eEnt:IsUncon() and not eEnt:IsRagdolled() then
				local ragEnt = eEnt:BecomeRagdoll( 10 )
				eEnt.m_intLastHealth = eEnt:Health() -pDamageInfo:GetDamage()
				eEnt:SetHealth( eEnt.m_intLastHealth )
				for i = 0, ragEnt:GetPhysicsObjectCount() -1 do
					local phys = ragEnt:GetPhysicsObjectNum( i )
					phys:ApplyForceCenter( (attacker:GetVelocity():GetNormalized() *-768) +Vector(0, 0, 1500) )
				end

				GAMEMODE.Util:PlayerEmitSound( eEnt, "Pain" )

				return true --Go ahead and block stuff in this case
			end
		elseif eEnt:Health() -pDamageInfo:GetDamage() <= 0 then
			eEnt:SetHealth( 0 ) --sh_uncon will run next and handle this
			return
		end

		return
	else
		local data, limb = table.Random( self.m_tblLimbs ) --Can't think of a better way to pick the limb in this case
		local scale = self:PlayerLimbTakeDamage( eEnt, limb, pDamageInfo:GetDamage(), pDamageInfo:GetDamageType(), true )
		
		if pDamageInfo:GetDamageType() == DMG_FALL or not eEnt:IsRagdolled() then
			if scale then pDamageInfo:ScaleDamage( scale ) end
			eEnt:SetHealth( math.max(0, eEnt:Health() -pDamageInfo:GetDamage()) )
		else
			pDamageInfo:ScaleDamage( 0 )
		end
		
		return true
	end
end

--Called to handle most kinds of damage for limbs
function GM.PlayerDamage:ScalePlayerDamage( pPlayer, intHitGroup, pDamageInfo )
	local limb = self.m_tblLimbs[intHitGroup]
	if not limb then return end
	
	local scale = self:PlayerLimbTakeDamage( pPlayer, intHitGroup, pDamageInfo:GetDamage() *0.33, pDamageInfo:GetDamageType(), true )
	if scale then pDamageInfo:ScaleDamage( scale ) end
	if pPlayer:IsRagdolled() then pDamageInfo:ScaleDamage( 0 ) end
end

--Called to handle fall damage for limbs
function GM.PlayerDamage:GetFallDamage( pPlayer, intVel )
	local dmg = intVel /8
	if dmg < 2 then return 0 end

	local scale = 2.25
	local num = 3
	scale = scale +self:PlayerLimbTakeDamage( pPlayer, HITGROUP_LEFTLEG, dmg /2, DMG_FALL, true )
	scale = scale +self:PlayerLimbTakeDamage( pPlayer, HITGROUP_RIGHTLEG, dmg /2, DMG_FALL, true )

	if dmg > 15 then --Damage other limbs too
		local numDamage = math.random( 1, 3 )
		local done = {}

		for i = 1, numDamage do
			local data, limb = table.Random( self.m_tblLimbs )
			if done[data.Name] then continue end
			done[data.Name] = true
			scale = scale +self:PlayerLimbTakeDamage( pPlayer, limb, dmg /3, DMG_FALL, true )
			num = num +1
		end
	end

	scale = scale /num
	dmg = dmg *scale
	if not pPlayer:IsUncon() and not pPlayer:IsRagdolled() then
		if pPlayer:Health() -dmg > 0 and dmg > 30 then
			GAMEMODE.Util:PlayerEmitSound( pPlayer, "Pain" )
			pPlayer:BecomeRagdoll( 10, true )
		elseif pPlayer:Health() -dmg <= 0 then
			GAMEMODE.Util:PlayerEmitSound( pPlayer, "Death" )
		end
	end

	if pPlayer.m_intLastHealth then
		pPlayer.m_intLastHealth = pPlayer.m_intLastHealth -dmg
	end

	return dmg
end

hook.Add( "GamemodeDefineGameVars", "DefinePlayerDamageVars", function( pPlayer )
	for k, v in pairs( GAMEMODE.PlayerDamage.m_tblLimbs ) do
		GAMEMODE.Player:DefineGameVar( pPlayer, "limb_hp_".. v.Name, 0, "UInt8", true )
		GAMEMODE.Player:DefineGameVar( pPlayer, "limb_bld_".. v.Name, false, "Bool", true )
		GAMEMODE.Player:DefineGameVar( pPlayer, "limb_brkn_".. v.Name, false, "Bool", true )
		GAMEMODE.Player:DefineGameVar( pPlayer, "limb_bndg_".. v.Name, 0, "Double", true )
	end
end )

hook.Add( "GamemodePlayerSelectCharacter", "ApplyPlayerDamageVars", function( pPlayer )
	GAMEMODE.PlayerDamage:InitPlayerLimbHealth( pPlayer )
end )

concommand.Add( "srp_dev_heal_me", function( pPlayer, strCmd, tblArgs )
	if not DEV_SERVER then
	if not pPlayer:IsSuperAdmin() then return end
	end

	GAMEMODE.PlayerDamage:HealPlayerLimbs( pPlayer )
	pPlayer:SetHealth( pPlayer:GetMaxHealth() )
end )