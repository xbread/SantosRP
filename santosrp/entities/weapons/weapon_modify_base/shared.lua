
-----------------------------------------------------


if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )

end



-- SWEP.Base					 =		"weapon_base"



SWEP.PrintName	             =      "Weapon Modify Base"			

SWEP.Author			         =      "RayChamp"

SWEP.Instructions		     =      ""

SWEP.Purpose 		         =      ""



SWEP.Spawnable               =      false

SWEP.AdminOnly               =      false



SWEP.Primary.ClipSize		 =      -1

SWEP.Primary.DefaultClip	 =      -1

SWEP.Primary.Automatic		 =      false

SWEP.Primary.Ammo		     =      "none"



SWEP.Secondary.ClipSize		 =      -1

SWEP.Secondary.DefaultClip	 =      -1

SWEP.Secondary.Automatic	 =      false

SWEP.Secondary.Ammo		     =      "none"



--Misc Settings

SWEP.Weight			         =      5

SWEP.AutoSwitchTo		     =      true

SWEP.AutoSwitchFrom		     =      true

SWEP.Slot			         =      1

SWEP.SlotPos			     =      1

SWEP.DrawAmmo			     =      false

SWEP.DrawCrosshair		     =      false

SWEP.FiresUnderwater         =      false



SWEP.HoldType 				= "slam"
SWEP.ViewModelFOV 			= 70
SWEP.ViewModelFlip 			= false
SWEP.ViewModel 				= "models/katharsmodels/handcuffs/handcuffs-1.mdl"
SWEP.WorldModel 			= "models/katharsmodels/handcuffs/handcuffs-1.mdl"



function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )

end



function SWEP:GetViewModelPosition( pos, ang )

	local offset = ang:Right() * self.ViewPos.x + ang:Forward() * self.ViewPos.y + ang:Up() * self.ViewPos.z;



	ang:RotateAroundAxis( ang:Right(), self.ViewAng.x )

	ang:RotateAroundAxis( ang:Forward(), self.ViewAng.y )

	ang:RotateAroundAxis( ang:Up(), self.ViewAng.z )

	

	return pos + offset, ang 

end



function SWEP:DrawWorldModel()

	local pPlayer = self.Owner;



	if ( !IsValid( pPlayer ) ) then

		self.Weapon:DrawModel();

		return;

	end

	

	if ( !self.m_hHands ) then

		self.m_hHands = pPlayer:LookupAttachment( "anim_attachment_RH" );

	end



	local hand = pPlayer:GetAttachment( self.m_hHands );

	

	if ( !hand ) then return end



	local offset = hand.Ang:Right() * self.HoldPos.x + hand.Ang:Forward() * self.HoldPos.y + hand.Ang:Up() * self.HoldPos.z;



	hand.Ang:RotateAroundAxis( hand.Ang:Right(),	self.HoldAng.x );

	hand.Ang:RotateAroundAxis( hand.Ang:Forward(),	self.HoldAng.y );

	hand.Ang:RotateAroundAxis( hand.Ang:Up(),		self.HoldAng.z );



	self.Weapon:SetRenderOrigin( hand.Pos + offset )

	self.Weapon:SetRenderAngles( hand.Ang )



	self.Weapon:DrawModel()

	

	if ( self.CamRender ) then

		self:CamRender()

	end

end



SWEP.HoldPos = Vector( 2, 0, 0 )

SWEP.HoldAng = Vector( 10, 135, 15 )



SWEP.ViewAng = Vector( 0, 0, 0 )

SWEP.ViewPos = Vector( 0, 0, 0 )



SWEP.PrimaryWait = 1



function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + self.PrimaryWait )

	

	self:ShootEffects()

	if self.Primary.ClipSize > -1 then

		self:TakePrimaryAmmo(1)

	end

	

	if self:Clip1() < 1 and self.Primary.ClipSize > -1 then

		self:Reload()

		return

	end

	

	if ( CLIENT ) then return end

	

	if self.Primary.Sound then

		self:EmitSound(self.Primary.Sound)

	end

	

	local ent = self.Owner:GetEyeTrace().Entity

	

	if ( !IsValid( ent ) or ent:GetPos():Distance( self.Owner:GetPos() ) >= 300 ) then

		self:OnMiss( ent )

		return

	end	

	

	self:OnHit( ent )

end



function SWEP:OnHit(ent)



end



function SWEP:OnMiss(ent)



end



function SWEP:SecondaryAttack()

	if ( self:GetNextPrimaryFire() < CurTime() ) then

		self:PrimaryAttack()

	end

end