SWEP.PrintName		= "Blood Draw Syringe"
SWEP.Author			= "Nomad"
SWEP.Instructions	= "Left click to draw a sample of another player's blood, right click to draw a sample of your own blood. With a loaded blood sample, left click on a blood analyzer to see the results for this sample."
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

function SWEP:SetupDataTables()
	self:NetworkVar( "String", 0, "DrawName" )
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() +1 )

	local ent = util.TraceLine{
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() +self.Owner:GetAimVector() *100,
		filter = { self, self.Owner }
	}.Entity

	if SERVER then
		if not IsValid( ent ) then return end

		if ent:IsPlayer() then
			if not self:HasInventoryAmmo() then return end

			self:SamplePlayerBlood( ent )

			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self:TakeInventoryAmmo()
			ent:EmitSound( "items/medshot4.wav" )

			if math.random( 1, 3 ) == 1 then
				GAMEMODE.Util:PlayerEmitSound( ent, "Pain" )
			end
		elseif ent:GetClass() == "ent_blood_analyzer" then
			--
			if not self.m_tblCurBloodSample then return end
			ent:AnalyzeBloodSample( self.Owner, self.m_tblCurBloodSample )
			self.m_tblCurBloodSample = nil
			self:SetDrawName( "" )
		end
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() +1 )
	local ent = self.Owner

	if SERVER then
		if not self:HasInventoryAmmo() then return end
		if not IsValid( ent ) or not ent:IsPlayer() then return end
		
		self:SamplePlayerBlood( ent )

		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self:TakeInventoryAmmo()
		ent:EmitSound( "items/medshot4.wav" )
	end
end

function SWEP:SamplePlayerBlood( pPlayer )
	self.m_tblCurBloodSample = {
		OwnerEnt = pPlayer,
		OwnerSID64 = pPlayer:SteamID64(),
		OwnerName = pPlayer:Nick(),
		Drugs = {},
	}

	for k, v in pairs( GAMEMODE.Drugs:GetEffects() ) do
		if GAMEMODE.Drugs:GetPlayerEffectPower( pPlayer, k ) > 0 then
			self.m_tblCurBloodSample.Drugs[k] = GAMEMODE.Drugs:GetPlayerEffectPower( pPlayer, k )
		end
	end

	self:SetDrawName( pPlayer:Nick() )
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

function SWEP:DrawHUD()
	if self:GetDrawName() == "" then return end
	draw.SimpleTextOutlined(
		("Blood sample: %s"):format( self:GetDrawName() ),
		"DermaLarge",
		ScrW() -10,
		ScrH() *0.66,
		color_white,
		TEXT_ALIGN_RIGHT,
		TEXT_ALIGN_CENTER,
		1,
		color_black
	)
end