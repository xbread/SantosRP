if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.PrintName = "Molotov Cocktail"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = ""
SWEP.Instructions = "Left Click: Throw"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = "models/weapons/v_molotov.mdl"
SWEP.WorldModel = "models/weapons/w_beerbot.mdl"

function SWEP:Initialize()
	self:SetWeaponHoldType( "melee" )
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:EmitSound( "npc/vort/claw_swing".. math.random(1, 2).. ".wav" )
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Weapon:SetNextPrimaryFire( CurTime() +1 )
	self.Weapon:SetNextSecondaryFire( CurTime() +1 )

	if SERVER then
		local Molotov = ents.Create( "ent_molotov" )
		Molotov:SetPos( self.Owner:GetShootPos() +self.Owner:GetAimVector() *20 )
		Molotov:Spawn()
		Molotov:GetPhysicsObject():ApplyForceCenter( self.Owner:GetAimVector() *1500 )

		--Inventory item HAX
		local count = 0
		for itemID, num in pairs( self.Owner:GetInventory() or {} ) do
			if GAMEMODE.Inv:GetItem( itemID ).EquipGiveClass == "weapon_molotov" then
				count = count +num
			end
		end

		for slotName, itemID in pairs( self.Owner:GetEquipment() or {} ) do
			if GAMEMODE.Inv:GetItem( itemID or "" ).EquipGiveClass == "weapon_molotov" then
				count = count +1
			end
		end

		if count > 1 then
			GAMEMODE.Inv:TakePlayerItem( self.Owner, "Molotov Cocktail", 1 )
		else
			if count > 0 then
				if GAMEMODE.Inv:PlayerHasItemEquipped( self.Owner, "Molotov Cocktail" ) then
					for slotName, itemID in pairs( self.Owner:GetEquipment() or {} ) do
						if itemID ~= "Molotov Cocktail" then continue end
						GAMEMODE.Inv:DeletePlayerEquipItem( self.Owner, slotName )
					end
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end