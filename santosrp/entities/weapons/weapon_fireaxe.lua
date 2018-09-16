
-----------------------------------------------------
--[[

	Name: weapon_fireaxe.lua

	For: SantosRP

	By: Ultra

]]--



if SERVER then

	AddCSLuaFile()

end



SWEP.PrintName		= "Fire Axe"

SWEP.Author			= "Nomad"

SWEP.Instructions	= "Left click to break objects in your way or force open doors."

SWEP.Base 			= "weapon_sck_base"

SWEP.ViewModel 		= "models/weapons/c_crowbar.mdl"

SWEP.WorldModel 	= "models/weapons/w_crowbar.mdl"

SWEP.ViewModelFOV	= 60



SWEP.Spawnable		= false

SWEP.Slot 			= 5

SWEP.UseHands 		= true



SWEP.HoldType 		= "melee2"



SWEP.Primary.ClipSize		= -1

SWEP.Primary.DefaultClip	= -1

SWEP.Primary.Automatic		= true

SWEP.Primary.Ammo			= "none"



SWEP.Secondary.ClipSize		= -1

SWEP.Secondary.DefaultClip	= -1

SWEP.Secondary.Automatic	= false

SWEP.Secondary.Ammo			= "none"

SWEP.ShowWorldModel 		= false

SWEP.ShowViewModel 			= false



SWEP.WElements = {

	["element_name"] = { type = "Model", model = "models/props_forest/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.374, 1.3, -1.558), angle = Angle(-4.803, 4.464, 86.739), size = Vector(0.963, 0.963, 0.963), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }

}



SWEP.VElements = {

	["element_name"] = { type = "Model", model = "models/props_forest/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.371, 1.554, 0), angle = Angle(2.851, -14.461, 88.958), size = Vector(1.156, 1.156, 1.156), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }

}



local unitVec = Vector( 1, 1, 1 )

function SWEP:PrimaryAttack()

	if self:GetNextPrimaryFire() > CurTime() then return end

	self:SetNextPrimaryFire( CurTime() +1.5 )

	self:SendWeaponAnim( ACT_VM_MISSCENTER )



	local tr = util.TraceHull{

		start = self.Owner:GetShootPos(),

		endpos = self.Owner:GetShootPos() +self.Owner:GetAimVector() *40,

		filter = { self, self.Owner },

		mins = unitVec *-8,

		maxs = unitVec *8

	}

	local hit = tr.Hit and IsValid( tr.Entity )



	if not hit then

		self:EmitSound( "weapons/iceaxe/iceaxe_swing1.wav" )

	else

		self:EmitSound( "weapons/knife/knife_hit_0".. math.random(1, 5).. ".wav" )

	end



	if IsFirstTimePredicted() then

		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		if CLIENT then return end

		

		if not hit then

			self.Owner:ViewPunch( Angle(8, 0, 0) )

		else

			self.Owner:ViewPunch( Angle(-10, 0, 0) )



			if tr.Entity.IsItem or tr.Entity:IsPlayer() then

				local dmg = DamageInfo()

				dmg:SetDamage( 15 )

				dmg:SetDamageType( DMG_CLUB )

				dmg:SetAttacker( self.Owner )

				dmg:SetInflictor( self )

				tr.Entity:TakeDamageInfo( dmg )

			elseif tr.Entity:IsVehicle() then

				local dmg = DamageInfo()

				dmg:SetDamage( 7 )

				dmg:SetDamageType( DMG_CLUB )

				dmg:SetAttacker( self.Owner )

				dmg:SetInflictor( self )

				tr.Entity:TakeDamageInfo( dmg )

			elseif GAMEMODE.Util:IsDoor( tr.Entity ) and math.random( 1, 5 ) == 1 then

				--HACK: rp_rockford bank door

				if tr.Entity:MapCreationID() == 3733 then return end

				tr.Entity:Fire( "unlock", "", 1 )

				tr.Entity:Fire( "open", "", 1 )

			end

		end

	end

end



function SWEP:SecondaryAttack()

end



function SWEP:FireAnimationEvent( _, _, intEvent )

	if intEvent == 5001 or intEvent == 6001 then return true end

end



function SWEP:Think()

end