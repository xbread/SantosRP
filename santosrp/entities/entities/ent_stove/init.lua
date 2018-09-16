--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local baseModel = "models/props_interiors/stove03_industrial.mdl"
local burnerBtnData = {
	{ mdl = 'models/maxofs2d/button_02.mdl', pos = Vector('14.849575 8.5 36'), ang = Angle('0.011 -89.984 -67.582') },
	{ mdl = 'models/maxofs2d/button_02.mdl', pos = Vector('14.849575 12.5 36'), ang = Angle('0.011 -89.984 -67.582') },
	{ mdl = 'models/maxofs2d/button_02.mdl', pos = Vector('14.849575 16.5 36'), ang = Angle('0.011 -89.984 -67.582') },
	{ mdl = 'models/maxofs2d/button_02.mdl', pos = Vector('14.849575 20.5 36'), ang = Angle('0.011 -89.984 -67.582') },
}
local burnerBtnScale = 0.15

local burnerOffSound = "ambient/fire/mtov_flame2.wav"
local burnerSparks = {
	"ambient/energy/spark1.wav",
	"ambient/energy/spark3.wav",
	"ambient/energy/spark4.wav",
}

function ENT:Initialize()
	self:SetModel( baseModel )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetTrigger( true )
	self:PhysWake()

	self.m_tblBurners = {}
	self.m_tblPots = {}
	for k, v in pairs( burnerBtnData ) do
		local btn = ents.Create( "ent_button" )
		btn:SetModel( v.mdl )
		btn:SetPos( self:LocalToWorld(v.pos) )
		btn:SetAngles( self:LocalToWorldAngles(v.ang) )
		btn:Spawn()
		btn:Activate()
		btn:SetCollisionBounds( Vector(-burnerBtnScale, -burnerBtnScale, -burnerBtnScale), Vector(burnerBtnScale, burnerBtnScale, burnerBtnScale) )
		btn:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		btn:SetModelScale( burnerBtnScale )
		btn:SetIsToggle( true )
		btn:SetParent( self )
		btn.BlockPhysGun = true
		self:DeleteOnRemove( btn )

		btn:SetCallback( function( _, pPlayer, bToggle )
			if bToggle then
				local snd, _ = table.Random( burnerSparks )
				self:EmitSound( snd )

				if self:GetBurnerFuel() > 0 then
					self:SetBurnerOn( k, bToggle )
				end
			else
				self:EmitSound( burnerOffSound )
				self:SetBurnerOn( k, bToggle )
			end
		end )

		table.insert( self.m_tblBurners, btn )
	end
	
	local btn = ents.Create( "ent_button" )
	btn:SetModel( "models/maxofs2d/button_02.mdl" )
	btn:SetPos( self:LocalToWorld(Vector('14.849575 -10.5 40.5')) )
	btn:SetAngles( self:LocalToWorldAngles(Angle('0.011 -89.984 -67.582')) )
	btn:Spawn()
	btn:Activate()
	btn:SetCollisionBounds( Vector(-burnerBtnScale, -burnerBtnScale, -burnerBtnScale), Vector(burnerBtnScale, burnerBtnScale, burnerBtnScale) )
	btn:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	btn:SetModelScale( burnerBtnScale )
	btn:SetIsToggle( true )
	btn:SetParent( self )
	btn.BlockPhysGun = true
	self:DeleteOnRemove( btn )

	btn:SetCallback( function( _, pPlayer, bToggle )
		self:SetOvenOn( bToggle )
	end )

	self.m_intLastBurnerTick = 0
	self.m_intLastOvenTick = 0
end

function ENT:OnRemove()
	for k, v in pairs( self.m_tblPots ) do
		if IsValid( v ) and v:GetParent() == self then
			v:Remove()
		end
	end
end

function ENT:AttachPotEntity( entPot )
	if table.Count( self.m_tblPots ) >= 4 then return end
	if table.HasValue( self.m_tblPots, entPot ) then return end
	
	local idx = table.insert( self.m_tblPots, entPot )
	if not self.BurnerPos[idx] then self.m_tblPots[idx] = nil return end

	entPot:SetPos( self:LocalToWorld(self.BurnerPos[idx].pos) )
	entPot:SetAngles( self:LocalToWorldAngles(self.BurnerPos[idx].ang) )
	entPot:SetParent( self )
	entPot.BurnerIndex = idx
	entPot:OnPotAttached( self )

	self["SetHasPot".. idx]( self, true )
end

function ENT:OnPotRemoved( entPot )
	for k, v in pairs( self.m_tblPots ) do
		if v == entPot then
			self.m_tblPots[k] = nil
			self["SetHasPot".. k]( self, false )
			break
		end
	end

	entPot:SetParent()
	entPot:SetPos( self:LocalToWorld(Vector(42, -8, 16)) )
	entPot:SetVelocity( Vector(0) )
end

function ENT:PotHasHeat( entPot )
	if not table.HasValue( self.m_tblPots, entPot ) or entPot:GetParent() ~= self then return false end
	if not entPot.BurnerIndex then return false end
	return self:GetBurnerOn( entPot.BurnerIndex )
end

function ENT:ThinkOven()
	self.m_intLastOvenTick = CurTime() +1

	if not self:GetOvenOn() then
		if self:GetOvenProgress() > 0 then
			if self.m_intOvenDoneTime then self.m_intOvenDoneTime = nil end
			
			self:SetOvenProgress( math.max(
				self:GetOvenProgress() -(self.m_tblOvenVars.OvenAmountPerTick *3),
				0
			) )
		end
		
		return
	end

	if not self:GetOvenID() or self:GetOvenID() == "" then return end
	if self:GetOvenProgress() >= self.m_tblOvenVars.OvenProgress then
		if not self.m_intOvenDoneTime then self.m_intOvenDoneTime = CurTime() end
		if CurTime() > self.m_intOvenDoneTime +self.m_tblOvenVars.OvenMaxOverTime then
			self.m_tblOvenVars = nil
			self:SetOvenID( "" )
			self:SetOvenProgress( 0 )		
			local fire = ents.Create( "ent_fire" )
			fire:SetPos( self:GetPos() )
			fire:Spawn()
			fire:Activate()
			self.m_intOvenDoneTime = nil
		end

		return
	end

	self:SetOvenProgress( math.min(
		self:GetOvenProgress() +self.m_tblOvenVars.OvenAmountPerTick,
		self.m_tblOvenVars.OvenProgress
	) )
end

function ENT:ThinkBurner()
	self.m_intLastBurnerTick = CurTime() +1
	if self:GetLitBurnerNum() <= 0 then return end
	
	self:SetBurnerFuel( math.max(self:GetBurnerFuel() -self.BurnerFuelPerTick, 0) )
	if self:GetBurnerFuel() <= 0 then
		for k, v in pairs( self.m_tblBurners ) do
			v:Toggle( false )
		end
	end
end

function ENT:Think()
	if CurTime() > self.m_intLastOvenTick then
		self:ThinkOven()
	end

	if CurTime() > self.m_intLastBurnerTick then
		self:ThinkBurner()
	end
end

function ENT:AcceptInput( strName, entActivator, entCaller )
	if not IsValid( entCaller ) or not entCaller:IsPlayer() then return end
	if strName ~= "Use" then return end

	if not self:GetOvenID() or self:GetOvenID() == "" then return end
	if self:GetOvenProgress() >= self.m_tblOvenVars.OvenProgress then
		local curTime = CurTime() -(self.m_intOvenDoneTime or CurTime())
		local scalar = (self.m_tblOvenVars.OvenMaxOverTime -curTime) /self.m_tblOvenVars.OvenMaxOverTime

		--weight the score with the player's skill
		local plLevel = GAMEMODE.Skills:GetPlayerLevel( entCaller, self.m_tblOvenVars.Skill )
		local maxLevel = GAMEMODE.Skills:GetMaxLevel( self.m_tblOvenVars.Skill )

		local skillCurve = 100 -(2 ^-(plLevel /(0.32 *maxLevel)) *(self.m_tblOvenVars.SkillWeight *100))
		skillCurve = (100 -skillCurve) /100
		scalar = math.max( scalar -skillCurve, 0 )

		local giveItem, giveAmount
		for k, v in pairs( self.m_tblOvenVars.GiveItems ) do
			if scalar >= v.MinQuality then
				giveItem = v.GiveItem
				giveAmount = v.GiveAmount
			end
		end

		if not giveItem or not giveAmount then return end
		if GAMEMODE.Inv:GivePlayerItem( entCaller, giveItem, giveAmount ) then
			entCaller:AddNote( "You collected ".. giveAmount.. " ".. giveItem.. " from the oven." )

			local giveXPData
			for k, v in ipairs( self.m_tblOvenVars.GiveXP ) do
				if scalar >= v.MinQuality then
					giveXPData = v
				end
			end
			if giveXPData then
				GAMEMODE.Skills:GivePlayerXP( entCaller, self.m_tblOvenVars.Skill, giveXPData.GiveAmount )
			end

			self.m_tblOvenVars = nil
			self:SetOvenID( "" )
			self:SetOvenProgress( 0 )
			self.m_intOvenDoneTime = nil
		end
	end
end

function ENT:PhysicsCollide( tblData, entOther )
	entOther = tblData.HitEntity
	if not IsValid( entOther ) then return end

	if entOther:GetClass() == "ent_cooking_pot" then
		if table.Count( self.m_tblPots ) >= 4 then
			local freeSlot = false
			for k, v in pairs( self.m_tblPots ) do
				if IsValid( v ) and v:GetParent() == self then
					continue
				end

				freeSlot = true
			end

			if not freeSlot then return end
		end

		self:AttachPotEntity( entOther )
		return	
	end

	if not entOther.IsItem then return end
	if entOther.m_bRemoveWaiting then return end

	if entOther:GetClass() == "ent_fuelcan" then
		if self:GetBurnerFuel() >= self.BurnerMaxFuel then return end
		local addFuel = math.min( 1, math.max(self.BurnerMaxFuel -self:GetBurnerFuel(), 0) )
		if addFuel == 0 then return end

		self:SetBurnerFuel( self:GetBurnerFuel() +addFuel )
		self:EmitSound( "ambient/water/water_spray1.wav", 70, 70 )

		entOther.m_bRemoveWaiting = true
		entOther.ItemTakeBlocked = true
		entOther:Remove()
		return
	end

	local data = GAMEMODE.Inv:GetItem( entOther.ItemID )
	if not data or not data.Cooking_OvenVars then return end
	
	if self:GetOvenID() and self:GetOvenID() ~= "" then
		return
	end

	self:SetOvenID( entOther.ItemID )
	self.m_tblOvenVars = data.Cooking_OvenVars

	entOther.m_bRemoveWaiting = true
	entOther.ItemTakeBlocked = true
	entOther:Remove()
end

function ENT:CanPlayerPickup( pPlayer, bCanUse )
	for k, v in pairs( self.m_tblPots ) do
		if IsValid( v ) and v:GetParent() == self then return false end
	end
	
	return bCanUse
end

function ENT:CanPlayerUse( pPlayer )
	return true
end

function ENT:CanSendToLostAndFound()
	return true
end