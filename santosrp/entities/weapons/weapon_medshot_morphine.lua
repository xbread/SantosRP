SWEP.PrintName		= "Morphine Applicator"
SWEP.Author			= "Nomad"
SWEP.Instructions	= "Left click to heal another player, right click to heal yourself."
SWEP.Base 			= "weapon_sck_base"
SWEP.ViewModel 		= "models/weapons/c_pistol.mdl"
SWEP.WorldModel 	= "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV	= 55

SWEP.Spawnable		= false
SWEP.Slot 			= 5
SWEP.UseHands 		= true

SWEP.HoldType 		= "slam"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.ShowWorldModel 		= true
SWEP.ShowViewModel 			= true

SWEP.WElements = {
	["vial"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.814, 2.069, -3.504), angle = Angle(-94.06, 0, 0), size = Vector(0.653, 0.653, 0.653), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.VElements = {
	["vial"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(0, 0, -5.169), angle = Angle(0, 90, 0), size = Vector(0.51, 0.51, 0.605), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() +1 )

	local ent = util.TraceLine{
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() +self.Owner:GetAimVector() *100,
		filter = { self, self.Owner }
	}.Entity

	if SERVER then
		if not self:HasInventoryAmmo() then return end
		if not IsValid( ent ) or not ent:IsPlayer() then return end
		if not GAMEMODE.PlayerDamage:PlayerHasBrokenBone( ent ) then return end
		
		for k, v in pairs( GAMEMODE.PlayerDamage:GetLimbs() ) do
			if GAMEMODE.PlayerDamage:IsPlayerLimbBroken( ent, k ) then
				GAMEMODE.PlayerDamage:SetPlayerLimbBroken( ent, k, false )
				GAMEMODE.Drugs:PlayerApplyEffect( ent, "morphine", 60, 2 )
				break
			end
		end

		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self:TakeInventoryAmmo()
		ent:EmitSound( "items/medshot4.wav" )
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() +1 )
	local ent = self.Owner

	if SERVER then
		if not self:HasInventoryAmmo() then return end
		if not IsValid( ent ) or not ent:IsPlayer() then return end
		if not GAMEMODE.PlayerDamage:PlayerHasBrokenBone( ent ) then return end
		
		for k, v in pairs( GAMEMODE.PlayerDamage:GetLimbs() ) do
			if GAMEMODE.PlayerDamage:IsPlayerLimbBroken( ent, k ) then
				GAMEMODE.PlayerDamage:SetPlayerLimbBroken( ent, k, false )
				GAMEMODE.Drugs:PlayerApplyEffect( ent, "morphine", 60, 2 )
				break
			end
		end

		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self:TakeInventoryAmmo()
		ent:EmitSound( "items/medshot4.wav" )
	end
end

function SWEP:TakeInventoryAmmo()
	if SERVER then
		local govItem = "Government Issue Medical Supplies"
		local civItem = "Medical Supplies"

		if not GAMEMODE.Inv:TakePlayerItem( self.Owner, govItem, 1 ) then
			GAMEMODE.Inv:TakePlayerItem( self.Owner, civItem, 1 )
		end

		if GAMEMODE.Inv:GetPlayerItemAmount( self.Owner, govItem ) <= 0 then
			if GAMEMODE.Inv:GetPlayerItemAmount( self.Owner, civItem ) <= 0 then
				local has, slot = GAMEMODE.Inv:PlayerHasItemEquipped( self.Owner, "Morphine Applicator" )

				if has then
					if GAMEMODE.Inv:GivePlayerItem( self.Owner, self.Owner:GetEquipSlot(slot) ) then
						GAMEMODE.Inv:DeletePlayerEquipItem( self.Owner, slot )
					end
				end
			end
		end
	end
end

function SWEP:HasInventoryAmmo()
	local govItem = "Government Issue Medical Supplies"
	local civItem = "Medical Supplies"

	if SERVER then
		if GAMEMODE.Inv:GetPlayerItemAmount( self.Owner, govItem ) > 0 then return true end
		return GAMEMODE.Inv:GetPlayerItemAmount( self.Owner, civItem ) > 0
	else
		if self.Owner ~= LocalPlayer() then return true end
		if GAMEMODE.Inv:PlayerHasItem( govItem, 1 ) then return true end
		if GAMEMODE.Inv:PlayerHasItem( civItem, 1 ) then return true end
		return false
	end
end

function SWEP:FireAnimationEvent( _, _, intEvent )
	if intEvent == 5001 or intEvent == 6001 then return true end
end

function SWEP:Think()
end