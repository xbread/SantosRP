--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local potNoDirt = "models/freeman/Marijuana/pot_empty.mdl"
local potDirt = "models/freeman/Marijuana/pot.mdl"

function ENT:Initialize()
	--Light
	self.m_intLightDecayTime = 2
	self.m_intLightDecay = 50
	self.m_intLastLightTime = 0

	--Water
	self.m_intWaterDecayTime = 2
	self.m_intWaterDecay = 2
	self.m_intLastWaterTime = 0

	--Nutrients
	self.m_intNutrientDecayTime = 2
	self.m_intNutrientDecay = 1
	self.m_intLastNutrientTime = 0

	self.m_intLastWindTime = 0

	--Current growth stage models
	self.m_tblCurModels = {}
	self.m_intCurrentStage = 0

	self:SetModel( potNoDirt )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
	self:SetTrigger( true )
	self:NextThink( CurTime() +1 )
end

function ENT:SetGrowingItem( strItemID )
	self:SetGrowingID( strItemID )
	self.m_tblGrowingItem = GAMEMODE.Inv:GetItem( strItemID )

	local params = self.m_tblGrowingItem.DrugGrowthVars
	--Water
	self.m_intWaterReq = params.WaterRequirement
	self.m_intWaterDecayTime = params.WaterDecayTime
	self.m_intWaterDecay = params.WaterDecay
	self.m_intWaterDamageAmt = params.WaterDamageAmount
	self.m_intWaterDamageTime = params.WaterDamageInterval
	self.m_intWaterLastDamage = CurTime()

	--Light
	self.m_intLightReq = params.LightRequirement
	self.m_intLightDecayTime = params.LightDecayTime
	self.m_intLightDecay = params.LightDecay
	self.m_intLightDamageAmt = params.LightDamageAmount
	self.m_intLightDamageTime = params.WaterDamageInterval
	self.m_intLightLastDamage = CurTime()

	--Nutrients
	self.m_intNutrientReq = params.NutrientRequirement
	self.m_intNutrientDecayTime = params.NutrientDecayTime
	self.m_intNutrientDecay = params.NutrientDecay
	self.m_intNutrientDamageAmt = params.NutrientDamageAmount
	self.m_intNutrientDamageTime = params.NutrientDamageInterval
	self.m_intNutrientLastDamage = CurTime()

	--Growth stages
	self.m_tblGrowthModelStages = params.GrowModels
	self.m_intStageTime = params.GrowStageTime
	self.m_intLastStageTime = 0
	self.m_intCurrentStage = 0

	self.m_strGiveItem = params.GiveItem
	self.m_intGiveItemAmt = params.GiveItemAmount

	--Plant health
	self:SetPlantHealth( params.PlantHealth )

	self:AdvanceGrowingStage()
end

function ENT:AdvanceGrowingStage()
	self.m_intLastStageTime = CurTime()
	if self.m_intCurrentStage >= #self.m_tblGrowthModelStages then
		return
	end

	self.m_intCurrentStage = self.m_intCurrentStage +1
	for k, v in pairs( self.m_tblCurModels ) do
		if IsValid( v ) then v:Remove() end
	end

	self.m_tblCurModels = {}
	for k, v in pairs( self.m_tblGrowthModelStages[self.m_intCurrentStage] or {} ) do
		local mdl = ents.Create( "prop_dynamic" )
		mdl:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		mdl:SetMoveType( MOVETYPE_NONE )
		mdl:SetSolid( SOLID_NONE )
		mdl:SetModel( v.mdl )
		mdl:SetPos( self:LocalToWorld(v.pos or Vector(0, 0, 0)) )

		if v.ang == "random_yaw" then
			mdl:SetAngles( self:LocalToWorldAngles(Angle(0, math.random(-180, 180), 0)) )
		else
			mdl:SetAngles( self:LocalToWorldAngles(v.ang or Angle(0, 0, 0)) )
		end
		mdl.m_angBaseAng = self:WorldToLocalAngles( mdl:GetAngles() )

		for k, v in pairs( v.bgroups or {} ) do
			mdl:SetBodygroup( k, v )
		end
		if v.color then
			mdl:SetColor( v.color )
		end
		if v.mat then
			mdl:SetMaterial( v.mat )
		end
		if v.scale then
			mdl:SetModelScale( v.scale )
		end

		mdl:SetParent( self )
		self:DeleteOnRemove( mdl )
		table.insert( self.m_tblCurModels, mdl )
	end
end

function ENT:Think()
	local time = CurTime()
	local inWater = self:WaterLevel() == 3

	if self:GetLight() > 0 then
		if time > self.m_intLastLightTime +self.m_intLightDecayTime then
			self:ReceiveLight( self:GetLight() -self.m_intLightDecay )
		end
	end

	if self:GetGrowingID() and self:GetGrowingID() ~= "" then
		if self:GetWind() > 0 then
			local scale = math.cos( CurTime() ) *(self:GetWind() /self.MaxWind)
			local swayAmt = 5
			self.m_angModelSway = Angle( swayAmt *scale, swayAmt *scale, 0 )
		else
			self.m_angModelSway = Angle( 0, 0, 0 )
		end

		for k, v in pairs( self.m_tblCurModels ) do
			v:SetAngles( self:LocalToWorldAngles(v.m_angBaseAng +self.m_angModelSway) )
		end

		if not inWater and self:GetWind() > 0 then
			if time > self.m_intLastWindTime +1 then
				self:SetWind( math.max(0, self:GetWind() -15) )
				self.m_intLastWindTime = time
			end
		elseif inWater or time > self.m_intLastWindTime +5 then
			self.m_intLastWindTime = time
			self:SetPlantHealth( math.max(0, self:GetPlantHealth() -1) )
		end

		if time > self.m_intLightLastDamage +self.m_intLightDamageTime then
			self.m_intLightLastDamage = time +self.m_intLightDamageTime

			if self:GetLight() <= 0 or inWater then
				self:SetPlantHealth( math.max(0, self:GetPlantHealth() -self.m_intLightDamageAmt) )
			end
		end
	
		if self:GetWater() > 0 then
			if time > self.m_intLastWaterTime +self.m_intWaterDecayTime then
				self:SetWater( math.max(0, self:GetWater() -self.m_intWaterDecay) )
				self.m_intLastWaterTime = time
			end
		end
		if time > self.m_intWaterLastDamage +self.m_intWaterDamageTime then
			self.m_intWaterLastDamage = time +self.m_intWaterDamageTime

			if self:GetWater() <= 0 then
				self:SetPlantHealth( math.max(0, self:GetPlantHealth() -self.m_intWaterDamageAmt) )
			end
		end

		if self:GetNutrients() > 0 then
			if time > self.m_intLastNutrientTime +self.m_intNutrientDecayTime then
				self:SetNutrients( math.max(0, self:GetNutrients() -self.m_intNutrientDecay) )
				self.m_intLastNutrientTime = time
			end
		end
		if time > self.m_intNutrientLastDamage +self.m_intNutrientDamageTime then
			self.m_intNutrientLastDamage = time +self.m_intNutrientDamageTime

			if self:GetNutrients() <= 0 then
				self:SetPlantHealth( math.max(0, self:GetPlantHealth() -self.m_intNutrientDamageAmt) )
			end
		end

		local lacksNeeds = inWater or false
		if self:GetLight() < (self.MaxLight *self.m_intLightReq) then
			lacksNeeds = true
		end
		if self:GetNutrients() < (self.MaxNutrients *self.m_intNutrientReq) then
			lacksNeeds = true
		end
		if self:GetWater() < (self.MaxWater *self.m_intWaterReq) then
			lacksNeeds = true
		end

		if self:GetPlantHealth() <= 0 then
			self:ClearGrowingPlant()
			return
		end

		if self.m_intCurrentStage > 0 then
			if CurTime() > self.m_intLastStageTime +self.m_intStageTime then
				self.m_intLastStageTime = time

				if not lacksNeeds then
					self:AdvanceGrowingStage()
				end
			end
		end
	end

	self:NextThink( 0 )
end

function ENT:ReceiveFluid( strLiquidID, intAmount )
	if self:GetDirt() < self.MaxDirt then
		if strLiquidID == "Dirt" then
			self:SetDirt( math.min(self.MaxDirt, self:GetDirt() +intAmount) )

			if self:GetDirt() >= self.MaxDirt then
				self:SetModel( potDirt )
			end
		end
		
		return
	end
	
	if strLiquidID == "Water" then
		if self:GetWater() < self.MaxWater then
			self:SetWater( math.min(self.MaxWater, self:GetWater() +intAmount) )
			self.m_intLastWaterTime = CurTime()
		end

	elseif strLiquidID == "Nutrients" then
		if self:GetNutrients() < self.MaxNutrients then
			self:SetNutrients( math.min(self.MaxNutrients, self:GetNutrients() +intAmount) )
			self.m_intLastNutrientTime = CurTime()
		end
	else
		--kill the plant
	end
end

function ENT:ReceiveLight( intAmount )
	if self:GetLight() == math.min( self.MaxLight, intAmount ) then
		self.m_intLastLightTime = CurTime()
		return
	end
	
	self:SetLight( math.min(self.MaxLight, intAmount) )
	self.m_intLastLightTime = CurTime()
end

function ENT:ReceiveWind( intAmount )
	if self:GetWind() == math.min( self.MaxWind, intAmount ) then
		self.m_intLastWindTime = CurTime()
		return
	end
	
	self:SetWind( math.min(self.MaxWind, intAmount) )
	self.m_intLastWindTime = CurTime()
end

function ENT:ReceiveItem( strItemID )
	local itemData = GAMEMODE.Inv:GetItem( strItemID )
	if not itemData then return false end

	if not self:GetGrowingID() or self:GetGrowingID() == "" then
		if self:GetDirt() < self.MaxDirt then return false end

		if itemData.CanPlant then
			self:SetGrowingItem( strItemID )
			return true
		end
	end
end

function ENT:StartTouch( entOther )
	if not entOther.IsItem then return end
	if entOther.m_bTouchHandled then return end
	if self:ReceiveItem( entOther.ItemID ) then
		entOther:Remove()
		entOther.m_bTouchHandled = true
	end
end

function ENT:ClearGrowingPlant()
	self:SetGrowingID( "" )
	self.m_intCurrentStage = 0

	for k, v in pairs( self.m_tblCurModels ) do
		if IsValid( v ) then v:Remove() end
	end

	self.m_tblCurModels = {}

	self:SetDirt( 0 )
	self:SetWater( 0 )
	self:SetNutrients( 0 )
	self:SetModel( potNoDirt )
end

function ENT:CanPlayerPickup( pPlayer, bCanUse )
	if self:GetGrowingID() and self:GetGrowingID() ~= "" then
		if self.m_intCurrentStage < #self.m_tblGrowthModelStages then
			return false
		end
	end
	
	return bCanUse
end

function ENT:CanPlayerUse( pPlayer )
	return true
end

function ENT:CanSendToLostAndFound()
	return true
end

function ENT:Use( pPlayer )
	if not self:GetGrowingID() or self:GetGrowingID() == "" then return end

	if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_POLICE then
		if self:GetPlayerOwner() ~= pPlayer and not GAMEMODE.Buddy:IsItemShared( pPlayer, self:GetPlayerOwner() ) then

			self:ClearGrowingPlant()

			local rand = math.random( GAMEMODE.Config.MinDrugConfiscatePrice, GAMEMODE.Config.MaxDrugConfiscatePrice )
			pPlayer:AddNote( "You confiscated an illegal drug!" )
			pPlayer:AddNote( "A $".. string.Comma(rand).. " bonus has been transferred to your bank account." )
			pPlayer:AddBankMoney( rand )
			return
		end
	end
	
	if self.m_intCurrentStage < #self.m_tblGrowthModelStages then
		return
	end

	if GAMEMODE.Inv:GivePlayerItem( pPlayer, self.m_strGiveItem, self.m_intGiveItemAmt ) then
		pPlayer:AddNote( "You harvested ".. self.m_intGiveItemAmt.. " ".. self.m_strGiveItem.. "." )
		self:ClearGrowingPlant()
	end
end