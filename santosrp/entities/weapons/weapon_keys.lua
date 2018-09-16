if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	SWEP.PrintName = "Keys"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Kunit"
SWEP.Instructions = "Left click lock, right click unlock."
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Base = "weapon_sck_base"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Sound = "doors/door_latch3.wav"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 62.5
SWEP.ViewModelFlip = true
SWEP.UseHands = false
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/santosrp/key/car_key.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["Detonator"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -10), angle = Angle(0, 0, 0) },
	["Slam_base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["Keys"] = { type = "Model", model = "models/santosrp/key/car_key.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.959, -1.933, 2.69), angle = Angle(7.727, 7.168, 161.57), size = Vector(1.21, 1.21, 1.21), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["Keys"] = { type = "Model", model = "models/santosrp/key/car_key.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.637, 1.254, -0.427), angle = Angle(0, 0, -75.82), size = Vector(1.136, 1.136, 1.136), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.IronSightsPos = Vector(4.239, 0, -0.88)
SWEP.IronSightsAng = Vector(0, 0, 27.34)

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() +0.5 )
	if SERVER then
		GAMEMODE.Property:ToggleLock( self.Owner, 2 )
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() +0.5 )
	if SERVER then
		GAMEMODE.Property:ToggleLock( self.Owner, 1 )
	end
end