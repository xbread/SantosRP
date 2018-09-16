--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife   
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local baseModel = "models/props_wasteland/laundry_washer001a.mdl"
local powerBtnData = { mdl = 'models/maxofs2d/button_03.mdl', pos = Vector('80.839577 -28.981621 4.908806'), ang = Angle('45.000 -90.000 0.000') }
local powerBtnScale = 0.4
local sndOn = "buttons/lever5.wav"

local dumpBtnData = { mdl = 'models/maxofs2d/button_03.mdl', pos = Vector('12 -42 -28'), ang = Angle('0 90 0') }
local sndDumpOn = "ambient/machines/squeak_3.wav"
local sndDumpOff = "ambient/machines/squeak_5.wav"

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
		if bToggle then
			self:SetChamberOn( bToggle )
			self:EmitSound( sndOn )
		else
			self:SetChamberOn( bToggle )
		end
	end )

	self.m_entBtnDump = ents.Create( "ent_button" )
	self.m_entBtnDump:SetModel( dumpBtnData.mdl )
	self.m_entBtnDump:SetPos( self:LocalToWorld(dumpBtnData.pos) )
	self.m_entBtnDump:SetAngles( self:LocalToWorldAngles(dumpBtnData.ang) )
	self.m_entBtnDump:Spawn()
	self.m_entBtnDump:Activate()
	self.m_entBtnDump:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.m_entBtnDump:SetIsToggle( true )
	self.m_entBtnDump:SetParent( self )
	self.m_entBtnDump:SetNoDraw( true )
	self.m_entBtnDump.BlockPhysGun = true
	self:DeleteOnRemove( self.m_entBtnDump )

	self.m_entBtnDump:SetCallback( function( _, pPlayer, bToggle )
		if bToggle then
			self.m_entBtnDump:EmitSound( sndDumpOn )
			self.m_bDumping = true
			self.m_intLastDump = CurTime() +1
		else
			self.m_entBtnDump:EmitSound( sndDumpOff )
			self.m_bDumping = false
		end
	end )
end

function ENT:SetTankFluidType( intTankID, strFluidType )
	self["SetFluidID".. intTankID]( self, strFluidType )
end

function ENT:SetTankAmount( intTankID, intAmount )
	self["SetFluidAmount".. intTankID]( self, intAmount )

	if intAmount <= 0 then
		self:SetTankFluidType( intTankID, "" )
	end
end

function ENT:ThinkEffect()
	if not self.m_intLastEffect then
		self.m_intLastEffect = 0
	end

	if CurTime() > self.m_intLastEffect then
		self.m_intLastEffect = CurTime() +0.05

		local effectData = EffectData()
		effectData:SetOrigin( self:LocalToWorld(Vector(16, -49, -15)) )
		effectData:SetNormal( Vector(0, 0, -1) )
		util.Effect( "waterFx", effectData )
	end
end

function ENT:ThinkFluidLogic()
	for k, v in pairs( GAMEMODE.Inv:GetItems() ) do
		if not v.ReactionChamberVars then continue end
		
		--See if we have everything this item wants
		local breakContinue = false
		for matName, amount in pairs( v.ReactionChamberVars.Mats ) do
			if not self:HasFluidID( matName, amount ) then
				breakContinue = true
				break
			end
		end
		if breakContinue then continue end
		
		--We are currently making this item
		self.m_tblChamberVars = v.ReactionChamberVars

		for matName, amount in pairs( v.ReactionChamberVars.Mats ) do
			local id = self:GetFluidTankID( matName )
			if not id then continue end
			self:SetTankAmount( id, math.max(self:GetTankAmount(id) -amount, 0) )
		end

		if self:GetOutputFluidID() ~= v.ReactionChamberVars.GiveItem then
			if self:GetOutputFluidAmount() <= 0 then
				self:SetOutputFluidID( v.ReactionChamberVars.GiveItem )
			else
				return
			end
		end

		self:SetOutputFluidAmount( math.min(self:GetOutputFluidAmount() +v.ReactionChamberVars.MakeAmount, self.MaxTankFluid) )
	end
end

function ENT:Think()
	if self:GetChamberOn() then
		if CurTime() > (self.m_intLastFluidThink or 0) then
			self:ThinkFluidLogic()
			self.m_intLastFluidThink = CurTime() +(self.m_tblChamberVars and self.m_tblChamberVars.Interval or 1)
		end
	end

	if self.m_bDumping then
		if self:HasTankFluid() or self:GetOutputFluidAmount() > 0 then
			self:ThinkEffect()

			if CurTime() > (self.m_intLastDump or 0) then
				self.m_intLastDump = CurTime() +1
			
				for i = 1, 3 do
					if self:GetTankAmount( i ) > 0 then
						self:SetTankAmount( i, math.max(self:GetTankAmount(i) -25, 0) )
						return
					end
				end

				self:SetOutputFluidAmount( math.max(self:GetOutputFluidAmount() -25, 0) )
				if self:GetOutputFluidAmount() <= 0 then
					self:SetOutputFluidID( "" )
				end
			end
		end
	end
end

function ENT:AcceptInput( strName, entActivator, entCaller )
	if not IsValid( entCaller ) or not entCaller:IsPlayer() then return end
	if strName ~= "Use" then return end

	if GAMEMODE.Jobs:GetPlayerJobID( entCaller ) == JOB_POLICE then
		if self:GetPlayerOwner() ~= entCaller and not GAMEMODE.Buddy:IsItemShared( entCaller, self:GetPlayerOwner() ) then
			self:Remove()

			local rand = math.random( GAMEMODE.Config.MinDrugConfiscatePrice, GAMEMODE.Config.MaxDrugConfiscatePrice )
			pPlayer:AddNote( "You confiscated illegal drug equipment!" )
			entCaller:AddNote( "A $".. string.Comma(rand).. " bonus has been transferred to your bank account." )
			entCaller:AddBankMoney( rand )
			return
		end
	end
	
	if not self.m_tblChamberVars then return end
	if self:GetOutputFluidAmount() >= self.m_tblChamberVars.MinGiveAmount then
		if GAMEMODE.Inv:GivePlayerItem( entCaller, self.m_tblChamberVars.GiveItem, self.m_tblChamberVars.GiveAmount ) then
			entCaller:AddNote( "You collected ".. self.m_tblChamberVars.GiveAmount.. " ".. self.m_tblChamberVars.GiveItem.. " from the reaction chamber." )
			self:SetOutputFluidAmount( math.max(self:GetOutputFluidAmount() -self.m_tblChamberVars.MinGiveAmount, 0) )
			if self:GetOutputFluidAmount() <= 0 then
				self:SetOutputFluidID( "" )
			end
		end
	end
end

function ENT:ReceiveFluid( strLiquidID, intAmount )
	local id
	local found = false
	for i = 1, 3 do
		if self:GetTankFluidType( i ) == strLiquidID then
			id = i
			found = true
			break
		end
	end
	
	if not found then
		id = self:GetFreeTankID()
		if not id then return end
	end
	
	self:SetTankAmount( id, math.min(self:GetTankAmount(id) +intAmount, self.MaxTankFluid) )
	if self:GetTankFluidType( id ) ~= strLiquidID then
		self:SetTankFluidType( id, strLiquidID )
	end
end

function ENT:CanPlayerPickup( pPlayer, bCanUse )
	for i = 1, 3 do
		if self["GetFluidAmount".. i]( self ) > 0 then
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