--[[
	Name: cl_drugs.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Drugs = (GAMEMODE or GM).Drugs or {}
GM.Drugs.m_tblEffects = (GAMEMODE or GM).Drugs.m_tblEffects or {}
GM.Drugs.m_tblCurEffects = (GAMEMODE or GM).Drugs.m_tblCurEffects or {}

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

function GM.Drugs:ApplyEffect( strEffectName, intIDX, intTime, intDuration, intPower )
	self.m_tblCurEffects[strEffectName] = self.m_tblCurEffects[strEffectName] or {}
	self.m_tblCurEffects[strEffectName][intIDX] = {
		time = intTime,
		len = intDuration,
		power = intPower or 1
	}

	local effectData = self:GetEffect( strEffectName )
	if effectData and effectData.OnStart then
		effectData:OnStart()
	end
end

function GM.Drugs:RemoveEffect( strEffectName, intIDX )
	if not self.m_tblCurEffects[strEffectName] then return end
	
	table.remove( self.m_tblCurEffects[strEffectName], intIDX or 1 )
	if table.Count( self.m_tblCurEffects[strEffectName] ) <= 0 then
		self.m_tblCurEffects[strEffectName] = nil
	end

	local effectData = self:GetEffect( strEffectName )
	if effectData and effectData.OnStop then
		effectData:OnStop()
	end
end

function GM.Drugs:ClearDrugEffects()
	for name, data in pairs( self.m_tblCurEffects ) do
		for k, _ in pairs( data ) do
			self.m_tblCurEffects[name][k] = nil

			local effectData = self:GetEffect( name )
			if effectData and effectData.OnStop then
				effectData:OnStop()
			end
		end
	end

	self.m_tblCurEffects = {}
end

function GM.Drugs:GetEffectPower( strEffectName )
	if not self.m_tblCurEffects[strEffectName] then return 0 end
	local count = 0
	for k, v in pairs( self.m_tblCurEffects[strEffectName] ) do
		count = count +v.power
	end
	return count
end

function GM.Drugs:RenderScreenspaceEffects()
	for k, v in pairs( self.m_tblCurEffects ) do
		self:GetEffect( k ):RenderScreenspaceEffects()
	end
end

function GM.Drugs:GetMotionBlurValues( intW, intH, intForward, intRot )
	for k, v in pairs( self.m_tblCurEffects ) do
		intW, intH, intForward, intRot = self:GetEffect( k ):GetMotionBlurValues( intW, intH, intForward, intRot )
	end

	return intW, intH, intForward, intRot
end