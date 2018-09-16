if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	SWEP.PrintName = "Battering Ram"
	SWEP.Slot = 5
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "RayChamp"
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = "Use to force open doors owned by players with active warrants."

SWEP.ViewModel = Model("models/weapons/custom/v_batram.mdl")
SWEP.WorldModel = Model("models/weapons/custom/w_batram.mdl")

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "rpg"

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

function SWEP:Initialize()
	self:SetHoldType( "normal" )
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity

	if not IsValid( ent ) or not ent.m_tblPropertyData then return end
	if ent:GetPos():Distance( self.Owner:GetPos() ) > 150 then return end
	
	local data = GAMEMODE.Property:GetPropertyByDoor( ent )
	if not data or not IsValid( data.Owner ) then
		self.Owner:AddNote( "Nobody owns this door." )
		return
	end
	
	if not GAMEMODE.Jail:PlayerHasWarrant( data.Owner ) then
		self.Owner:AddNote( "The owner is not warranted." ) 
		return
	end
	
	self.Owner:ViewPunch( Angle(-10, 0, 0) )
	ent:Fire( "unlock", "", 1 )
	ent:Fire( "open", "", 1 )
end