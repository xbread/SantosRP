--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local baseModel = "models/props/CS_militia/table_shed.mdl"
local drugLabExplodeSound = "ambient/explosions/explode_3.wav"

local blenderBtnData = { mdl = 'models/maxofs2d/button_slider.mdl', pos = Vector('-2.436463 27.369314 40.042908'), ang = Angle('67.500 -157.505 0.000') }
local blenderBtnScale = 0.33

local potStandData = { mdl = 'models/hunter/blocks/cube025x025x025.mdl', pos = Vector('-12.011904 -7.018746 39.844383'), ang = Angle('-0.000 179.995 0.000') }
local burnerBtnData = { mdl = 'models/maxofs2d/button_02.mdl', pos = Vector('-19.188425 -22.386162 34.876381'), ang = Angle('-0.000 89.995 0.000') }
local burnerBtnScale = 0.2

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

	self.m_entBtnBurner = ents.Create( "ent_button" )
	self.m_entBtnBurner:SetModel( burnerBtnData.mdl )
	self.m_entBtnBurner:SetPos( self:LocalToWorld(burnerBtnData.pos) )
	self.m_entBtnBurner:SetAngles( self:LocalToWorldAngles(burnerBtnData.ang) )
	self.m_entBtnBurner:Spawn()
	self.m_entBtnBurner:Activate()
	self.m_entBtnBurner:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.m_entBtnBurner:SetModelScale( burnerBtnScale )
	self.m_entBtnBurner:SetIsToggle( true )
	self.m_entBtnBurner:SetParent( self )
	self.m_entBtnBurner.BlockPhysGun = true
	self:DeleteOnRemove( self.m_entBtnBurner )

	self.m_entBtnBurner:SetCallback( function( _, pPlayer, bToggle )
		if bToggle then
			local snd, _ = table.Random( burnerSparks )
			self:EmitSound( snd )

			if self:GetBurnerFuel() > 0 then
				self:SetBurnerOn( bToggle )
			end
		else
			self:EmitSound( burnerOffSound )
			self:SetBurnerOn( bToggle )
		end
	end )

	self.m_entBtnBlender = ents.Create( "ent_button" )
	self.m_entBtnBlender:SetModel( blenderBtnData.mdl )
	self.m_entBtnBlender:SetPos( self:LocalToWorld(blenderBtnData.pos) )
	self.m_entBtnBlender:SetAngles( self:LocalToWorldAngles(blenderBtnData.ang) )
	self.m_entBtnBlender:Spawn()
	self.m_entBtnBlender:Activate()
	self.m_entBtnBlender:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.m_entBtnBlender:SetModelScale( blenderBtnScale )
	self.m_entBtnBlender:SetIsToggle( true )
	self.m_entBtnBlender:SetParent( self )
	self.m_entBtnBlender.BlockPhysGun = true
	self:DeleteOnRemove( self.m_entBtnBurner )

	self.m_entBtnBlender:SetCallback( function( _, pPlayer, bToggle )
		self:SetBlenderOn( bToggle )
	end )

	self.m_intLastBlenderTick = 0
	self.m_intLastBurnerTick = 0
end

function ENT:OnRemove()
	if IsValid( self.m_entAttachedPot ) and self.m_entAttachedPot:GetParent() == self then
		self.m_entAttachedPot:Remove()
	end
end

function ENT:AttachPotEntity( entPot )
	self.m_entAttachedPot = entPot
	entPot:SetPos( self:LocalToWorld(Vector(-12, -6.75, 52)) )
	entPot:SetAngles( self:LocalToWorldAngles(Angle(0, -90, 0)) )
	entPot:SetParent( self )
	entPot:OnPotAttached( self )
end

function ENT:OnPotRemoved( entPot )
	entPot:SetParent()
	entPot:SetPos( self:LocalToWorld(Vector(-42, 0, 16)) )
	entPot:SetVelocity( Vector(0) )
end

function ENT:PotHasHeat( entPot )
	if self.m_entAttachedPot ~= entPot or entPot:GetParent() ~= self then return false end
	return self:GetBurnerOn()
end

function ENT:ThinkBlender()
	self.m_intLastBlenderTick = CurTime() +1

	if not self:GetBlenderOn() then return end

	if not self:GetBlendingID() or self:GetBlendingID() == "" then return end
	if self:GetBlenderProgress() >= self.m_tblBlendingVars.BlendProgress then
		return
	end

	self:SetBlenderProgress( math.min(
		self:GetBlenderProgress() +self.m_tblBlendingVars.BlendAmountPerTick,
		self.m_tblBlendingVars.BlendProgress
	) )
end

function ENT:ThinkBurner()
	self.m_intLastBurnerTick = CurTime() +1
	if not self:GetBurnerOn() then return end
	
	self:SetBurnerFuel( math.max(self:GetBurnerFuel() -self.BurnerFuelPerTick, 0) )
	if self:GetBurnerFuel() <= 0 then
		self.m_entBtnBurner:Toggle( false )
	end
end

function ENT:Think()
	if CurTime() > self.m_intLastBlenderTick then
		self:ThinkBlender()
	end

	if CurTime() > self.m_intLastBurnerTick then
		self:ThinkBurner()
	end
end

function ENT:AcceptInput( strName, entActivator, entCaller )
	if not IsValid( entCaller ) or not entCaller:IsPlayer() then return end
	if strName ~= "Use" then return end

	if GAMEMODE.Jobs:GetPlayerJobID( entCaller ) == JOB_POLICE then
		if self:GetPlayerOwner() ~= entCaller and not GAMEMODE.Buddy:IsItemShared( entCaller, self:GetPlayerOwner() ) then
			if IsValid( self.m_entAttachedPot ) and self.m_entAttachedPot:GetParent() == self then
				self.m_entAttachedPot:Remove()
			end

			self:Remove()
			
			local rand = math.random( GAMEMODE.Config.MinDrugConfiscatePrice, GAMEMODE.Config.MaxDrugConfiscatePrice )
			pPlayer:AddNote( "You confiscated illegal drug equipment!" )
			entCaller:AddNote( "A $".. string.Comma(rand).. " bonus has been transferred to your bank account." )
			entCaller:AddBankMoney( rand )
			return
		end
	end

	if not self:GetBlendingID() or self:GetBlendingID() == "" then return end
	if self:GetBlenderProgress() >= self.m_tblBlendingVars.BlendProgress then
		local giveItem, giveAmount = self.m_tblBlendingVars.GiveItem, self.m_tblBlendingVars.GiveAmount

		if GAMEMODE.Inv:GivePlayerItem( entCaller, giveItem, giveAmount ) then
			entCaller:AddNote( "You collected ".. giveAmount.. " ".. giveItem.. " from the blender." )
			self.m_tblBlendingVars = nil
			self:SetBlendingID( "" )
			self:SetBlenderProgress( 0 )
		end
	end
end

function ENT:PhysicsCollide( tblData, entOther )
	entOther = tblData.HitEntity
	if not IsValid( entOther ) then return end

	if entOther:GetClass() == "ent_cooking_pot" then
		if IsValid( self.m_entAttachedPot ) and self.m_entAttachedPot:GetParent() == self then
			return
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
	if not data or not data.DrugLab_BlenderVars then return end
	
	if self:GetBlendingID() and self:GetBlendingID() ~= "" then
		return
	end

	self:SetBlendingID( entOther.ItemID )
	self.m_tblBlendingVars = data.DrugLab_BlenderVars

	entOther.m_bRemoveWaiting = true
	entOther.ItemTakeBlocked = true
	entOther:Remove()
end

function ENT:CanPlayerPickup( pPlayer, bCanUse )
	if IsValid( self.m_entAttachedPot ) and self.m_entAttachedPot:GetParent() == self then
		return false
	end
	
	return bCanUse
end

function ENT:CanPlayerUse( pPlayer )
	return true
end

function ENT:CanSendToLostAndFound()
	return true
end