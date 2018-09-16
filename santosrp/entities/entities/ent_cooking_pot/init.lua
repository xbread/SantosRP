--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

util.AddNetworkString "CookingPot"

function ENT:Initialize()
	self:SetModel( "models/props_c17/metalPot001a.mdl" )
	self:SetModelScale( 0.9 )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysWake()

	self.m_tblItems = {}
	self.m_tblFluids = {}
end

function ENT:AcceptInput( strName, entActivator, entCaller )
	if not IsValid( entCaller ) or not entCaller:IsPlayer() then return end
	if strName ~= "Use" then return end

	if IsValid( self:GetParent() ) then
		if self:HasValidRecipe() and self:GetIsCooking() then
			local time = self:GetProgress()
			local data = self:GetCookingRecipe()

			if time <= data.MinTime then --they didn't wait long enough
				--don't clear it, just let them try again
				if self:GetParent().OnPotRemoved then
					self:GetParent():OnPotRemoved( self )
				end

				self.BlockPhysGun = false
				self.ItemTakeBlocked = false
			elseif time > data.MaxTime then --they over cooked it
				self:ClearContents()

				if data.OverCookMsg then
					entCaller:AddNote( data.OverCookMsg )
				end

				if self:GetParent().OnPotRemoved then
					self:GetParent():OnPotRemoved( self )
				end
				self.BlockPhysGun = false
				self.ItemTakeBlocked = false
			else
				--compute the recipe likeness and the cooking duration likeness
				--score it and give the correct item
				--give cooking xp
				--weight the combined likeness score with the cooking skill
				local itemLikeness = {}
				local fluidLikeness = {}

				--print "--------------------------------------"
				
				--compute item likeness 
				for itemName, num in pairs( self.m_tblItems ) do
					local minAmount = data.Items[itemName].MinAmount
					local maxAmount = data.Items[itemName].MaxAmount
					local idealAmount = data.Items[itemName].IdealAmount
					--num = num -minAmount

					local plotTotal = 1 -(maxAmount -num) /maxAmount
					local plotDiff = 1 -(idealAmount -num) /idealAmount

					if num > idealAmount then
						num = num -idealAmount
						local max = maxAmount -idealAmount
						--print( "over ideal, under ideal plotDiff was ", plotDiff )
						plotDiff = (max -num) /max
					end
					itemLikeness[itemName] = plotDiff

					--print( itemName, plotTotal, plotDiff )
				end

				--compute fluid likeness
				for fluidName, num in pairs( self.m_tblFluids ) do
					local minAmount = data.Fluids[fluidName].MinAmount
					local maxAmount = data.Fluids[fluidName].MaxAmount
					local idealAmount = data.Fluids[fluidName].IdealAmount
					--num = num -minAmount

					local plotTotal = 1 -(maxAmount -num) /maxAmount
					local plotDiff = 1 -(idealAmount -num) /idealAmount

					if num > idealAmount then
						num = num -idealAmount
						local max = maxAmount -idealAmount
						--print( "over ideal, under ideal plotDiff was ", plotDiff )
						plotDiff = (max -num) /max
					end
					fluidLikeness[fluidName] = plotDiff

					--print( fluidName, plotTotal, plotDiff )
				end

				--combine all likeness scores into a total average score, then figure out what to give them
				local numItems = table.Count( itemLikeness )
				local numFluids = table.Count( fluidLikeness )
				local score = 0

				for k, v in pairs( itemLikeness ) do
					score = score +v
				end

				for k, v in pairs( fluidLikeness ) do
					score = score +v
				end
				score = math.max( score /(numItems +numFluids), 0 )

				--print "--------------------------------------"
				--print( "fluidItemScore = ", score )

				--weight the score with the player's skill
				local plLevel = GAMEMODE.Skills:GetPlayerLevel( entCaller, data.Skill )
				local maxLevel = GAMEMODE.Skills:GetMaxLevel( data.Skill )

				local skillCurve = 100 -(2 ^-(plLevel /(0.32 *maxLevel)) *(data.SkillWeight *100))
				skillCurve = (100 -skillCurve) /100
				score = math.max( score -skillCurve, 0 )

				--print( "skillCurve = ", skillCurve )
				--print( "skillAdjustedScore = ", score )
				--print "--------------------------------------"

				--weight the score with the the cooking time
				local duration = data.MaxTime -data.MinTime
				local timeScalar = 1 -(duration -(time -data.MinTime)) /duration

				local timeWeight = data.TimeWeight or -2
				local timeCurve = timeWeight *(timeScalar -(data.IdealTimePercent or 0.5)) ^2 +1
				local baseCurveVal = timeWeight *(0 -(data.IdealTimePercent or 0.5)) ^2 +1

				--print( "duration = ", duration, "time = ", time -data.MinTime, "timeScale = ", timeScalar )
				--print( "real = ", 1 -timeCurve )

				score = math.max( score -(1 -timeCurve), 0 )
				--print( "final score [".. score.. "]" )

				local giveItemData
				for k, v in ipairs( data.GiveItems ) do
					if score >= v.MinQuality then
						giveItemData = v
					end
				end

				if giveItemData then
					if GAMEMODE.Inv:GivePlayerItem( entCaller, giveItemData.GiveItem, giveItemData.GiveAmount ) then
						self:ClearContents()
						if self:GetParent().OnPotRemoved then
							self:GetParent():OnPotRemoved( self )
						end
						self.BlockPhysGun = false
						self.ItemTakeBlocked = false

						local giveXPData
						for k, v in ipairs( data.GiveXP ) do
							if score >= v.MinQuality then
								giveXPData = v
							end
						end

						if giveXPData then
							GAMEMODE.Skills:GivePlayerXP( entCaller, data.Skill, giveXPData.GiveAmount )
						end
					end
				end

				--
			end
		else
			if self:GetParent().OnPotRemoved then
				self:GetParent():OnPotRemoved( self )
			end

			self.BlockPhysGun = false
			self.ItemTakeBlocked = false
		end
	end
end

function ENT:OnPotAttached( entParent )
	self.BlockPhysGun = true
	self.ItemTakeBlocked = true
	self:UpdateCookingRecipe()
end

function ENT:HasValidRecipe()
	return self.m_tblCurRecipe ~= nil
end

function ENT:GetCookingRecipe()
	return self.m_tblCurRecipe
end

function ENT:UpdateCookingRecipe()
	local numItems, numFluids = table.Count( self.m_tblItems ), table.Count( self.m_tblFluids )
	for k, v in pairs( GAMEMODE.Inv:GetItems() ) do
		if not v.CookingPotVars then continue end
		local vars = v.CookingPotVars

		local hasMatch = true
		if numItems == table.Count( vars.Items ) then
			for itemName, num in pairs( self.m_tblItems ) do
				if not vars.Items[itemName] or num > vars.Items[itemName].MaxAmount or num < vars.Items[itemName].MinAmount then
					hasMatch = false
					break
				end
			end
		else
			hasMatch = false
		end
		
		if not hasMatch then continue end
		
		if numFluids == table.Count( vars.Fluids ) then
			for fluidName, num in pairs( self.m_tblFluids ) do
				if not vars.Fluids[fluidName] or num > vars.Fluids[fluidName].MaxAmount or num < vars.Fluids[fluidName].MinAmount then
					hasMatch = false
					break
				end
			end
		else
			hasMatch = false
		end

		if not hasMatch then continue end
		self.m_tblCurRecipe = v.CookingPotVars
		self:SetItemID( k )
		return
	end

	self.m_tblCurRecipe = nil
end

function ENT:ThinkCooking()
	if self:GetProgress() >= self.MaxCookingTime then --Over max time, just start a fire
		if not self.m_bCreatedFire then
			self.m_bCreatedFire = true
			self:ClearContents()
			
			local fire = ents.Create( "ent_fire" )
			fire:SetPos( self:GetPos() )
			fire:Spawn()
			fire:Activate()
		end
	elseif self:HasValidRecipe() and self:GetProgress() > self:GetCookingRecipe().MaxTime then
		if self.m_bCreatedFire then return end
		
		if self:GetCookingRecipe().OverTimeExplode then
			self.m_bCreatedFire = true
			self:Explode()
		elseif self:GetCookingRecipe().OverTimeStartFire then
			self.m_bCreatedFire = true
			local fire = ents.Create( "ent_fire" )
			fire:SetPos( self:GetPos() )
			fire:Spawn()
			fire:Activate()
		end

		if self.m_bCreatedFire then
			self:ClearContents()
		end
	end
end

function ENT:Think()
	if self:GetIsCooking() then
		if not IsValid( self:GetParent() ) or not self:HasHeat() then
			self:SetIsCooking( false )	
			return
		end

		if CurTime() >= (self.m_intLastProgress or 0) then
			self:SetProgress( math.min(self.MaxCookingTime, self:GetProgress() +1) )
			self.m_intLastProgress = CurTime() +1
		end

		self:ThinkCooking()
	else
		if IsValid( self:GetParent() ) and self:HasHeat() then
			self:SetIsCooking( true )
		end

		if not self.m_intDecayStart then return end
		if CurTime() > (self.m_intLastDecay or 0) then
			self:SetProgress( math.max(0, self:GetProgress() -1) )
			self.m_intLastDecay = CurTime() +0.33

			if self:GetProgress() <= 0 then
				self.m_intDecayStart = nil
				self.m_intLastDecay = nil
			end
		end
	end
end

function ENT:HasHeat()
	if not IsValid( self:GetParent() ) then return false end
	return self:GetParent():PotHasHeat( self )
end

function ENT:OnCookingStatusChanged( _, bOld, bNew )
	if bOld and not bNew then
		self.m_bCreatedFire = nil
		self.m_intDecayStart = CurTime()
	end
end

function ENT:Explode()
	local explodeEnt = ents.Create( "env_explosion" )
	explodeEnt:SetKeyValue( "iMagnitude", "100" )
	explodeEnt:SetPos( self:GetPos() )
	explodeEnt:SetOwner( self )
	explodeEnt:Spawn()
	explodeEnt:Fire( "explode" )
end

function ENT:ClearContents()
	self.m_tblFluids = {}
	self.m_tblItems = {}
	self:NetworkContents()
	self.m_tblCurRecipe = nil
	self:SetProgress( 0 )
end

function ENT:ReceiveFluid( strLiquidID, intAmount )
	if self:GetIsCooking() then return false end
	
	if not self.m_tblFluids[strLiquidID] then
		if table.Count( self.m_tblFluids ) >= self.MaxNumFluids then
			return false
		end
	end

	self.m_tblFluids[strLiquidID] = self.m_tblFluids[strLiquidID] or 0
	self.m_tblFluids[strLiquidID] = math.min( self.m_tblFluids[strLiquidID] +intAmount, self.MaxFluidAmount )
	self:NetworkContents()

	return true
end

function ENT:GetFluid( strLiquidID )
	return self.m_tblFluids[strLiquidID] or 0
end

function ENT:HasFluid( strLiquidID )
	return self.m_tblFluids[strLiquidID] and true
end

function ENT:PhysicsCollide( tblData, entOther )
	entOther = tblData.HitEntity
	if not IsValid( entOther ) then return end
	if not entOther.IsItem then return end
	if entOther.m_bRemoveWaiting then return end

	local itemData = GAMEMODE.Inv:GetItem( entOther.ItemID )
	if not itemData or not itemData.CanCook then return end

	if self:AddItem( entOther.ItemID, 1 ) then
		entOther.m_bRemoveWaiting = true
		entOther.ItemTakeBlocked = true
		entOther:Remove()
	end
end

function ENT:AddItem( strItemID, intAmount )
	if self:GetIsCooking() then return false end

	if not self.m_tblItems[strItemID] then
		if table.Count( self.m_tblItems ) >= self.MaxNumItems then
			return false
		end
	end

	self.m_tblItems[strItemID] = self.m_tblItems[strItemID] or 0
	self.m_tblItems[strItemID] = math.min( self.m_tblItems[strItemID] +intAmount, self.MaxItemAmount )
	self:NetworkContents()

	return true
end

function ENT:GetItem( strItemID )
	return self.m_tblItems[strItemID] or 0
end

function ENT:HasItem( strItemID )
	return self.m_tblItems[strItemID] and true
end

function ENT:NetworkContents( pPlayer )
	net.Start( "CookingPot" )
		net.WriteUInt( self:EntIndex(), 32 )

		net.WriteUInt( table.Count(self.m_tblFluids), 8 )
		for k, v in pairs( self.m_tblFluids ) do
			net.WriteString( k )
			net.WriteUInt( v, 16 )
		end

		net.WriteUInt( table.Count(self.m_tblItems), 8 )
		for k, v in pairs( self.m_tblItems ) do
			net.WriteString( k )
			net.WriteUInt( v, 8 )
		end
	if pPlayer then
		net.Send( pPlayer )
	else
		net.Broadcast()
	end
end

function ENT:CanSendToLostAndFound()
	return true
end