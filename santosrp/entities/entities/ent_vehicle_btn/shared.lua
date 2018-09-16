AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= ""
ENT.Author			= "Bobblehead"
ENT.Purpose			= "Stuff"

DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "On" )
	self:NetworkVar( "Bool", 1, "IsToggle" )
	self:SetOn( false )
	self:SetIsToggle( true )
end

function ENT:Initialize()
	if SERVER then
		-- self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( ONOFF_USE )
		self:SetModel("models/maxofs2d/button_03.mdl")
		self.BlockPhysGun = true
	else
		self.PosePosition = 0
	end
end

function ENT:Use( activator, caller, type, value )
	if not activator:IsPlayer() then return end	-- Who the frig is pressing this shit!?
	
	if self:GetIsToggle() then
		if type == USE_ON then
			self:Toggle( not self:GetOn(), activator )
		end
		return
	end

	if IsValid( self.LastUser ) then return end	-- Someone is already using this button

	-- Switch off
	if self:GetOn() then 
		self:Toggle( false, activator )
		return
	end

	-- Switch on
	self:Toggle( true, activator )
	self:NextThink( CurTime() )
	self.LastUser = activator
end

function ENT:SetLabel( text )
	text = string.gsub( text, "\\", "" )
	text = string.sub( text, 0, 20 )
	
	if text ~= "" then
		text = ext
	end
	
	self:SetOverlayText( text )
end

function ENT:Think()
	self.BaseClass.Think( self )

	-- Add a world tip if the player is looking at it
	--if CLIENT then
	--	if ( self:GetOverlayText() != "" && self:BeingLookedAtByLocalPlayer() ) then
	--		AddWorldTip( self:EntIndex(), self:GetOverlayText(), 0.5, self:GetPos(), self.Entity  )
	--	end
	--	self:UpdateLever()
	--end

	-- If the player looks away while holding down use it will stay on
	-- Lets fix that..
	if SERVER and self:GetOn() and not self:GetIsToggle() then 
		if not IsValid( self.LastUser ) or not self.LastUser:KeyDown( IN_USE ) then
			self:Toggle( false, self.LastUser )
			self.LastUser = nil
		end	

		self:NextThink( CurTime() )
	end
end

-- Makes the button trigger the keys
function ENT:Toggle( bEnable, ply )
	if self.Extender then
		if bEnable then
			self:SetOn( true )
			self.Hook:SetExtended(true)
		else
			self:SetOn( false )
			self.Hook:SetExtended(false)
		end
	else
		if bEnable then
			self:SetOn( true )
			self.Hook:Release()
		else
			self:SetOn( false )
			self.Hook:Release()
		end
	end
end

-- Update the lever animation
function ENT:UpdateLever()
	local TargetPos = 0.0
	if self:GetOn() then TargetPos = 1.0 end

	self.PosePosition = math.Approach( self.PosePosition, TargetPos, FrameTime() *5.0 )	
	self:SetPoseParameter( "switch", self.PosePosition )
	self:InvalidateBoneCache()
end