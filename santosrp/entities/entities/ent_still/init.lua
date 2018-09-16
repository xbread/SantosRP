--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local baseModel = "models/props_pipes/valve002.mdl"
local powerBtnData = { mdl = 'models/maxofs2d/button_03.mdl', pos = Vector('4.492420 -3.771758 58.931824'), ang = Angle('89.911 111.807 156.812') }
local powerBtnScale = 0.2
local sndOn = "buttons/lever5.wav"
local dumpBtnData = { mdl = 'models/maxofs2d/button_03.mdl', pos = Vector('-32 -12 0'), ang = Angle('0 90 0') }
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
			self:SetStillOn( bToggle )
			self:EmitSound( sndOn )
		else
			self:SetStillOn( bToggle )
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

	timer.Simple( 0, function()
		if not IsValid( self ) then return end
		
		self.m_entFluidCatch = ents.Create( "prop_physics" )
		self.m_entFluidCatch:SetModel( "models/props_junk/MetalBucket01a.mdl" )
		self.m_entFluidCatch:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		self.m_entFluidCatch:SetPos( self:LocalToWorld(Vector(0, -27, 36)) )
		self.m_entFluidCatch:SetAngles( self:LocalToWorldAngles(Angle(0, 0, 0)) )
		self.m_entFluidCatch:Spawn()
		self.m_entFluidCatch:Activate()
		self.m_entFluidCatch:GetPhysicsObject():SetMass( 1 )
		self.m_entFluidCatch.BlockPhysGun = true
		self.m_pWeldFluidCatch = constraint.Weld( self.m_entFluidCatch, self, 0, 0, 0 )
		self.m_entFluidCatch:SetNoDraw( true )
		self:DeleteOnRemove( self.m_entFluidCatch )
	
		self.m_entFluidCatch.ReceiveFluid = function( _, strLiquidID, intAmount )
			if self:GetItemID() and self:GetItemID() ~= "" and self:GetItemID() ~= strLiquidID then return end
			if not GAMEMODE.Inv:GetItem( strLiquidID ) then return end
			
			if self:GetItemID() ~= strLiquidID then
				local data = GAMEMODE.Inv:GetItem( strLiquidID )
				if not data.StillVars then return end
				
				self:SetItemID( strLiquidID )
				self.m_tblStillVars = data.StillVars
			end
			
			self:SetFluidAmount( math.min(self:GetFluidAmount() +intAmount, self.MaxFluid) )
		end
	end )

	self.m_intLastFluidInterval = 0
end

function ENT:ThinkFluidInterval()
	local data = GAMEMODE.Inv:GetItem( self:GetItemID() or "" )
	if not data or not data.StillVars then return end
	
	self.m_intLastFluidInterval = CurTime() +data.StillVars.FluidStillInterval
	local amount = math.min( self:GetFluidAmount(), data.StillVars.FluidStillRate )
	if amount <= 0 then return end
	
	if self:GetProgress() +amount > self.MaxProgress then
		amount = math.max( self.MaxProgress -self:GetProgress(), 0 )
		if amount <= 0 then return end
	end
	
	self:SetProgress( self:GetProgress() +amount )
	self:SetFluidAmount( self:GetFluidAmount() -amount )
end

function ENT:ThinkEffect()
	if not self.m_intLastEffect then
		self.m_intLastEffect = 0
	end

	if CurTime() > self.m_intLastEffect then
		self.m_intLastEffect = CurTime() +0.05

		local effectData = EffectData()
		effectData:SetOrigin( self:LocalToWorld(Vector(-29, -22, 15)) )
		effectData:SetNormal( Vector(0, 0, -1) )
		util.Effect( "waterFx", effectData )
	end
end

function ENT:Think()
	if self:GetStillOn() then
		if not self.m_tblStillVars then return end

		if CurTime() > self.m_intLastFluidInterval then
			self:ThinkFluidInterval()
		end
	end

	if self.m_bDumping then
		if self:GetFluidAmount() > 0 or self:GetProgress() > 0 then
			self:ThinkEffect()

			if CurTime() > (self.m_intLastDump or 0) then
				self.m_intLastDump = CurTime() +1

				if self:GetFluidAmount() > 0 then
					self:SetFluidAmount( math.max(0, self:GetFluidAmount() -10) )
				else
					self:SetProgress( math.max(0, self:GetProgress() -10) )

					if self:GetProgress() <= 0 then
						if self:GetItemID() ~= "" then
							self:SetItemID( "" )
						end
					end
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
			entCaller:AddNote( "You confiscated illegal drug equipment!" )
			entCaller:AddNote( "A $".. string.Comma(rand).. " bonus has been transferred to your bank account." )
			entCaller:AddBankMoney( rand )
			return
		end
	end
	
	if not self:GetItemID() or self:GetItemID() == "" then
		return
	end

	local data = GAMEMODE.Inv:GetItem( self:GetItemID() or "" )
	if not data or not data.StillVars then return end

	if self:GetProgress() >= data.StillVars.FluidAmountPerItem then
		if GAMEMODE.Inv:GivePlayerItem( entCaller, data.StillVars.GiveItem, data.StillVars.GiveAmount ) then
			entCaller:AddNote( "You collected ".. data.StillVars.GiveAmount.. " ".. data.StillVars.GiveItem.. " from the still." )

			self:SetProgress( self:GetProgress() -data.StillVars.FluidAmountPerItem )
			if self:GetProgress() <= 0 and self:GetFluidAmount() <= 0 then
				self:SetItemID( "" )
				self.m_tblStillVars = nil
			end
		end
	end
end

function ENT:CanPlayerPickup( pPlayer, bCanUse )
	if self:GetProgress() > 0 or self:GetFluidAmount() > 0 then
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