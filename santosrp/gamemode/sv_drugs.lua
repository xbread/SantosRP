--[[
	Name: sv_drugs.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Drugs = {}
GM.Drugs.m_tblEffects = {}

function GM.Drugs:RegisterEffect( tblEffect )
	self.m_tblEffects[tblEffect.Name] = tblEffect

	if tblEffect.PacOutfit and tblEffect.PacOutfitSlot then
		GM.Inv:RegisterEquipSlot( tblEffect.PacOutfitSlot.Name, tblEffect.PacOutfitSlot.Data )
	end
end

function GM.Drugs:GetEffect( strName )
	return self.m_tblEffects[strName]
end

function GM.Drugs:GetEffects()
	return self.m_tblEffects
end

function GM.Drugs:PlayerApplyEffect( pPlayer, strEffectName, intDuration, intPower )
	local effectData = self:GetEffect( strEffectName )
	if not effectData then return false end
	if effectData.MaxPower <= self:GetPlayerEffectPower( pPlayer, strEffectName ) then return false end

	pPlayer.m_tblDrugData = pPlayer.m_tblDrugData or {}
	if not pPlayer.m_tblDrugData[strEffectName] then
		pPlayer.m_tblDrugData[strEffectName] = {}
	end
	
	local idx = table.insert( pPlayer.m_tblDrugData[strEffectName], {
		time = CurTime(),
		len = intDuration,
		power = intPower or 1
	} )


	--If this drug has a pac outfit, apply it if it is not already
	if effectData.PacOutfit and effectData.PacOutfitSlot then
		if pPlayer:GetEquipment()[effectData.PacOutfitSlot.Name] ~= effectData.PacOutfit then
			GAMEMODE.Inv:SetPlayerEquipSlotValue( pPlayer, effectData.PacOutfitSlot.Name, effectData.PacOutfit )
		end
	end

	if effectData.OnStart then
		effectData:OnStart( pPlayer )
	end

	--net update
	GAMEMODE.Net:SendPlayerDrugEffect( pPlayer, strEffectName, idx, CurTime(), intDuration, intPower )
	return true
end

function GM.Drugs:PlayerRemoveEffect( pPlayer, strEffectName, intIDX )
	table.remove( pPlayer.m_tblDrugData[strEffectName], idx )
	if table.Count( pPlayer.m_tblDrugData[strEffectName] ) <= 0 then
		pPlayer.m_tblDrugData[strEffectName] = nil
	end

	local effectData = self:GetEffect( strEffectName )
	if effectData and effectData.OnStop then
		effectData:OnStop( pPlayer )
	end

	--If this drug has a pac outfit, remove it if this drug is no longer in effect
	if effectData.PacOutfit and effectData.PacOutfitSlot then
		if self:GetPlayerEffectPower( pPlayer, strEffectName ) <= 0 then
			if pPlayer:GetEquipment()[effectData.PacOutfitSlot.Name] == effectData.PacOutfit then
				GAMEMODE.Inv:SetPlayerEquipSlotValue( pPlayer, effectData.PacOutfitSlot.Name, "" )
			end
		end
	end

	--net update
	GAMEMODE.Net:RemovePlayerDrugEffect( pPlayer, strEffectName, intIDX )
end

function GM.Drugs:ClearPlayerDrugEffects( pPlayer )
	pPlayer.m_tblDrugData = {}
	GAMEMODE.Net:ClearPlayerDrugEffects( pPlayer )
end

function GM.Drugs:GetPlayerEffectPower( pPlayer, strEffectName )
	if not pPlayer.m_tblDrugData or not pPlayer.m_tblDrugData[strEffectName] then return 0 end
	local count = 0
	for k, v in pairs( pPlayer.m_tblDrugData[strEffectName] ) do
		count = count +v.power
	end
	return count
end

function GM.Drugs:UpdatePlayerEffects()
	for k, v in pairs( player.GetAll() ) do
		if not v.m_tblDrugData then continue end
		for k, _ in pairs( v.m_tblDrugData ) do
			if self:GetEffect( k ).Think then
				self:GetEffect( k ):Think( v )
			end
		end
	end

	local time = CurTime()
	if not self.m_intLastThink then self.m_intLastThink = 0 end
	if time < self.m_intLastThink then return end
	self.m_intLastThink = time +1

	for k, v in pairs( player.GetAll() ) do
		if not v:Alive() or not v.m_tblDrugData then continue end
		
		for name, data in pairs( v.m_tblDrugData ) do
			for idx, effect in pairs( data ) do
				if time > effect.time +effect.len then
					self:PlayerRemoveEffect( v, name, idx )
					break
				end
			end
		end
	end
end

function GM.Drugs:Tick()
	self:UpdatePlayerEffects()
end

function GM.Drugs:PlayerDeath( pPlayer )
	self:ClearPlayerDrugEffects( pPlayer )
end