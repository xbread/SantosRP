--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local baseModel = "models/props_unique/coffeemachine01.mdl"
local powerBtnData = { mdl = 'models/maxofs2d/button_01.mdl', pos = Vector('8.500417 4.349771 18.218307'), ang = Angle('90.000 89.989 0.000') }
local powerBtnScale = 0.15

function ENT:Initialize()
	self:SetModel( baseModel )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetTrigger( true )
	self:PhysWake()

	self.m_entBtnPower = ents.Create( "ent_button" )
	self.m_entBtnPower:SetModel( powerBtnData.mdl )
	self.m_entBtnPower:SetPos( self:LocalToWorld(powerBtnData.pos) )
	self.m_entBtnPower:SetAngles( self:LocalToWorldAngles(powerBtnData.ang) )
	self.m_entBtnPower:Spawn()
	self.m_entBtnPower:Activate()
	self.m_entBtnPower:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.m_entBtnPower:SetModelScale( powerBtnScale )
	self.m_entBtnPower:SetIsToggle( true )
	self.m_entBtnPower:SetParent( self )
	self.m_entBtnPower.BlockPhysGun = true
	self:DeleteOnRemove( self.m_entBtnPower )

	self.m_entBtnPower:SetCallback( function( _, pPlayer, bToggle )
		self:SetOn( bToggle )
		self.m_entBtnPower:EmitSound( "buttons/lightswitch2.wav" )
	end )
end

function ENT:Think()
	if not self:GetOn() then return end
	
	if CurTime() > (self.m_intLastTick or 0) then
		self.m_intLastTick = CurTime() +1

		if self:GetCoffeeAmount() +self.MakeCoffeePerTick <= self.MaxCoffeeAmount then
			if self:GetWaterAmount() >= self.UseWaterPerTick and self:GetCoffeeGrainAmount() >= self.UseCoffeeGrainPerTick then
				self:SetWaterAmount( math.max(self:GetWaterAmount() -self.UseWaterPerTick, 0) )
				self:SetCoffeeGrainAmount( math.max(self:GetCoffeeGrainAmount() -self.UseCoffeeGrainPerTick, 0) )

				self:SetCoffeeAmount( math.min(self:GetCoffeeAmount() +self.MakeCoffeePerTick, self.MaxCoffeeAmount) )
			end
		end
	end
end

function ENT:ReceiveFluid( strLiquidID, intAmount )
	if self:GetOn() then return false end
	
	if strLiquidID == "Water" then
		self:SetWaterAmount( math.min(self:GetWaterAmount() +intAmount, self.MaxWaterAmount) )
		return true
	elseif strLiquidID == "Ground Coffee" then
		self:SetCoffeeGrainAmount( math.min(self:GetCoffeeGrainAmount() +intAmount, self.MaxCoffeeGrainAmount) )
		return true
	end

	return false
end

function ENT:AcceptInput( strName, entActivator, entCaller )
	if not IsValid( entCaller ) or not entCaller:IsPlayer() then return end
	if strName ~= "Use" then return end

	if self:GetCoffeeAmount() >= self.CoffeeAmountPerItem then
		local giveItem = "Coffee"
		if GAMEMODE.Inv:GivePlayerItem( entCaller, giveItem, 1 ) then
			entCaller:AddNote( "You collected 1 ".. giveItem.. " from the coffee maker." )
			self:SetCoffeeAmount( math.max(self:GetCoffeeAmount() -self.CoffeeAmountPerItem, 0) )
		end
	end
end

function ENT:CanPlayerPickup( pPlayer, bCanUse )
	if self:GetOn() then return false end
	return bCanUse
end

function ENT:CanPlayerUse( pPlayer )
	return true
end

function ENT:CanSendToLostAndFound()
	return true
end