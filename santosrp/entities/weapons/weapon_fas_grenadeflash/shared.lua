// Variables that are used on both client and server
local ManualHolster	= CreateClientConVar("sim_manualholster_t", 1, true, false)		// Enable/Disable
SWEP.Base = "weapon_fas_sim_base"

SWEP.HoldType = "grenade"
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_flashbang.mdl"
SWEP.ViewModelFOV  		= 70

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Recoil		= 5
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 1.5

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 199				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "flashgrenade"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"				// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.GrenadeType			= "sim_fas_flashgrenade"
SWEP.GrenadeName			= "weapon_fas_grenadeflash"
SWEP.GrenadeTime			= 3
SWEP.CookGrenade			= true
SWEP.RunArmOffset 		= Vector (0, 0, 0)
SWEP.RunArmAngle 		= Vector (0, 0, 0)
SWEP.WeaponName = "weapon_fas_grenadeflash"
SWEP.WeaponEntName = "sim_fas_flashgrenade_ent"
SWEP.ItemName = "Flash Grenade"
SWEP.ItemName2 = "Police Issue Flash Grenade"

/*---------------------------------------------------------
   Name: SWEP:Throw()
---------------------------------------------------------*/
function SWEP:Throw()
	local knife = ents.Create(self.WeaponEntName)
	knife:SetAngles(self.Owner:EyeAngles())

	local pos = self.Owner:GetShootPos()
	pos = pos + self.Owner:GetForward() * 30
	pos = pos + self.Owner:GetRight() * 0
	pos = pos + self.Owner:GetUp() * -40

	knife:SetPos(pos)
	knife:Spawn()
	knife:Activate()
					
	local phys = knife:GetPhysicsObject()
	phys:SetVelocity(self.Owner:GetAimVector() * 50)
	phys:AddAngleVelocity(Vector(0, 0, 0))
	
	--if self.Owner:GetAmmoCount(self.Primary.Ammo) > 1 then
	--	self.Owner:RemoveAmmo(1, self.Primary.Ammo)
	--else
	--	self.Owner:RemoveAmmo(1, self.Primary.Ammo)
	--	self.Owner:StripWeapon(self.WeaponName)
	--end

	if SERVER then
		RunConsoleCommand("lastinv")
	end
end		

/*---------------------------------------------------------
   Name: SWEP:Reload()
   Desc: Reload is being pressed.
---------------------------------------------------------*/
function SWEP:Reload()
		
	--if self.Owner:KeyDown(IN_USE) and self.Weapon:GetDTBool(0) then
	--	self.Weapon:SetNextPrimaryFire(CurTime() + 10)
	--	self.Weapon:SetNextSecondaryFire(CurTime() + 10)
	--	self.ActionDelay = (CurTime() + 10)
	--	self:SetIronsights(false)
	--	self:Throw()
	--end
end
	
/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Holst/Deploy your fucking weapon
	if (not self.Owner:IsNPC() and not self.Owner:KeyDown(IN_SPEED) and not self.Owner:KeyDown(IN_RELOAD) and self.Owner:KeyDown(IN_USE)) then
		
		if (SERVER) then
			--bHolsted = !self.Weapon:GetDTBool(0)
			--self:SetHolsted(bHolsted)
		end

		self.Weapon:SetNextPrimaryFire(CurTime() + 1.0)
		self.Weapon:SetNextSecondaryFire(CurTime() + 1.0)

		return
	end

	if (not self:CanPrimaryAttack()) then return end	

	if (self.Owner:GetNetworkedInt("Throw") > CurTime() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or self.Owner:GetNetworkedInt("Primed") != 0 or self.Weapon:GetNetworkedBool("Holsted")) then return end

	self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)

	self.Owner:SetNetworkedInt("Primed", 1)
	self.Owner:SetNetworkedInt("Throw", CurTime() + 1)
	self.Owner:SetNetworkedBool("Cooked", false)
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	// I used the cooking script of Wizey as an example.
	if not self.CookGrenade then return end
	if self.Owner:GetNetworkedBool("Reloading") then return end
	if self.Owner:GetNetworkedInt("Primed") == 0 then return end
	if self.Owner:GetNetworkedInt("Primed") == 2 then return end

	self.Owner:SetNetworkedBool("Reloading", true)
	timer.Simple(self.GrenadeTime + 0.1, function() if not IsValid( self ) then return end if not IsValid(self.Owner) then return end self.Owner:SetNetworkedBool("Reloading", false) end)

	self.Weapon:EmitSound("Default.ClipEmpty_Rifle", 60)

	self.Owner:SetNetworkedBool("Cooked", true)
	self.NextExplode = CurTime() + self.GrenadeTime

	timer.Simple(self.GrenadeTime, function()
		if not IsValid( self ) then return end
		if not IsValid(self.Owner) then return end
		if  not IsFirstTimePredicted() then return end

		if self.Owner:GetNetworkedBool("Cooked") and self.Weapon:GetOwner():GetActiveWeapon():GetClass() == self.GrenadeName and self.Owner:Alive() then
			if self.Owner:GetNetworkedInt("Primed") == 1 then
				local grenade = ents.Create(self.GrenadeType)

				local pos = self.Owner:GetShootPos()
					pos = pos + self.Owner:GetForward() * 1
					pos = pos + self.Owner:GetRight() * 7
	
					if self.Owner:KeyDown(IN_SPEED) then
						pos = pos + self.Owner:GetUp() * -4
					else
						pos = pos + self.Owner:GetUp() * 1
					end

				grenade:SetPos(pos)

				grenade:GetAngles(Vector(math.random(1, 100), math.random(1, 100), math.random(1, 100)))
				grenade:SetOwner(self.Owner)
				grenade:SetNetworkedInt("Cook", 0)
				grenade:Spawn()

				self.Owner:SetNetworkedInt("Primed", 0)
				self.Owner:SetNetworkedBool("Cooked", false)

				timer.Simple(0.6, function()
					if not IsValid( self ) then return end
					if not IsValid(self.Owner) then return end

					if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
						self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
						self.Owner:SetNetworkedInt("Primed", 0)
					else
						self.Owner:SetNetworkedInt("Primed", 0)
						self.Owner:ConCommand("lastinv")
					end
				end)
			end			
		end 
	end)
end

/*---------------------------------------------------------
   Name: SWEP:Think()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:Think()

	self:SecondThink()
	
	if self.Weapon:Clip1() > 0 and self.IdleDelay < CurTime() and self.IdleApply then
		local WeaponModel = self.Weapon:GetOwner():GetActiveWeapon():GetClass()

		if self.Owner and self.Weapon:GetOwner():GetActiveWeapon():GetClass() == WeaponModel and self.Owner:Alive() then
			if self.Weapon:GetDTBool(3) and self.Type == 2 then
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
			else
				self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			end
			

			if self.AllowPlaybackRate and not self.Weapon:GetDTBool(1) then
				self.Owner:GetViewModel():SetPlaybackRate(1)
			else
				self.Owner:GetViewModel():SetPlaybackRate(0)
			end		
		end

		self.IdleApply = false
	elseif self.Weapon:Clip1() == 0 then
		self.IdleApply = false
	end
	
	if self.Weapon:GetDTBool(1) and self.Owner:KeyDown(IN_SPEED) then
		self:SetIronsights(false)
	end

	if (self.Owner:KeyDown(IN_SPEED) and self.Owner:GetNetworkedInt("Primed") == 0) or self.Weapon:GetNetworkedBool("Holsted") then
		if self.Rifle or self.Sniper or self.Shotgun then

			self:SetWeaponHoldType("passive")
	
		elseif self.Pistol then
		
			self:SetWeaponHoldType("normal")
		end
	else
		self:SetWeaponHoldType(self.HoldType)
	end

	if (self.Owner:GetNetworkedInt("Primed") == 1 and not self.Owner:KeyDown(IN_ATTACK)) then
		if self.Owner:GetNetworkedInt("Throw") < CurTime() then
			self.Owner:SetNetworkedInt("Primed", 2)
			self.Owner:SetNetworkedInt("Throw", CurTime() + 1.5)

			if not self.Owner:Crouching() then
				self.Weapon:SendWeaponAnim(ACT_VM_THROW)
			end

			self.Owner:SetAnimation(PLAYER_ATTACK1)

			timer.Simple(0.35, function()
				if not IsValid( self ) or not IsValid(self.Owner) then return end
				self.Owner:ViewPunch(Angle(math.Rand(1, 2), math.Rand(0, 0), math.Rand(0, 0)))
				self:ThrowGrenade()
			end )
		end
	end

	if self.Owner:GetNetworkedBool("Cooked") and self.Owner:GetNetworkedBool("LastShootCook") < CurTime() then
		if ((game.SinglePlayer() and SERVER) or CLIENT) then
			self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
			self.Owner:EmitSound("Default.ClipEmpty_Rifle")
		end

		self.Owner:SetNetworkedBool("LastShootCook", CurTime() + 1)
	end
end


/*---------------------------------------------------------
   Name: SWEP:Holster()
   Desc: Weapon wants to holster.
	   Return true to allow the weapon to holster.
---------------------------------------------------------*/
function SWEP:Holster()

	self.Owner:SetNetworkedInt("Primed", 0)
	self.Owner:SetNetworkedInt("Throw", CurTime())
	--self:ResetSpeed()
	--if ManualHolster:GetBool() then
		--if self.Weapon:GetDTBool(0) or self.Owner:InVehicle() then
		--if self.Owner:InVehicle() then
		--	return true
		--end
	--else	
		return true
	--end
end


/*---------------------------------------------------------
   Name: SWEP:Deploy()
   Desc: Whip it out.
---------------------------------------------------------*/
function SWEP:Deploy()

	--if self.Weapon:GetDTBool(0) then
	--	bHolsted = !self.Weapon:GetDTBool(0)
	--	self:SetHolsted(bHolsted)
	--end	
	self:SetHolsted( false )

	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	local Animation = self.Owner:GetViewModel()
	Animation:SetSequence(Animation:LookupSequence("deploy_first"))

	self.Weapon:SetNextPrimaryFire(CurTime() + self.DeployDelay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.DeployDelay)
	self.ActionDelay 	= (CurTime() + self.DeployDelay)
	self.Owner:SetNetworkedInt("Throw", CurTime() + self.DeployDelay)

	self.Owner:SetNetworkedBool("LastShootCook", CurTime())

	--if self.Weapon:GetDTBool(0) then
		return true
	--end
end

/*---------------------------------------------------------
   Name: SWEP:ThrowGrenade()
---------------------------------------------------------*/
function SWEP:ThrowGrenade()

	if (self.Owner:GetNetworkedInt("Primed") != 2 or CLIENT) then return end

	if self.CookGrenade and not self.Owner:GetNetworkedBool("Cooked") then
		self.NextExplode = CurTime() + self.GrenadeTime
		self.Weapon:EmitSound("Grenadf.Primer", 60)
	end

	local grenade = ents.Create(self.GrenadeType)

	if self.CookGrenade then
		self.Owner:SetNetworkedBool("Cooked", false)

		local RemainingTime = self.NextExplode - CurTime()
		grenade:SetNetworkedInt("Cook", CurTime() + RemainingTime)
	end

	local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetRight() * 7

		if self.Owner:KeyDown(IN_SPEED) and not self.Owner:Crouching() then
			pos = pos + self.Owner:GetUp() * -4
		elseif not self.Owner:Crouching() then
			pos = pos + self.Owner:GetForward() * -6
			pos = pos + self.Owner:GetUp() * 1
		else
			pos = pos + self.Owner:GetForward() * 1
			pos = pos + self.Owner:GetUp() * -24
		end

	grenade:SetPos(pos)
	grenade:GetAngles(Angle(math.random(1, 100), math.random(1, 100), math.random(1, 100)))
	grenade:SetOwner(self.Owner)
	grenade:Spawn()

	local phys = grenade:GetPhysicsObject()

	if self.Owner:KeyDown(IN_FORWARD) then
		self.Force = 6400
	elseif self.Owner:KeyDown(IN_BACK) then
		self.Force = 4200
	else
		self.Force = 5000
	end


	if not self.Owner:Crouching() then
		phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 1.2 + Vector(0, 0, 200))
	else
		phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 1.2 + Vector(0, 0, 0))
	end

	phys:AddAngleVelocity(Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))

	if SERVER then
		--Inventory item HAX
		local count = 0
		for itemID, num in pairs( self.Owner:GetInventory() or {} ) do
			if not GAMEMODE.Inv:GetItem( itemID or "" ) then continue end
			if GAMEMODE.Inv:GetItem( itemID ).EquipGiveClass == self.WeaponName then
				count = count +num
			end
		end

		for slotName, itemID in pairs( self.Owner:GetEquipment() or {} ) do
			if not GAMEMODE.Inv:GetItem( itemID or "" ) then continue end
			if GAMEMODE.Inv:GetItem( itemID ).EquipGiveClass == self.WeaponName then
				count = count +1
			end
		end

		if count > 1 then
			if not GAMEMODE.Inv:TakePlayerItem( self.Owner, self.ItemName2, 1 ) then
				GAMEMODE.Inv:TakePlayerItem( self.Owner, self.ItemName, 1 )
			end
		else
			if count > 0 then
				if GAMEMODE.Inv:PlayerHasItemEquipped( self.Owner, self.ItemName ) or GAMEMODE.Inv:PlayerHasItemEquipped( self.Owner, self.ItemName2 ) then
					for slotName, itemID in pairs( self.Owner:GetEquipment() or {} ) do
						if itemID ~= self.ItemName and itemID ~= self.ItemName2 then continue end
						GAMEMODE.Inv:DeletePlayerEquipItem( self.Owner, slotName )
					end
				end
			end
		end
	end

	timer.Simple(0.6, function()
		if not IsValid( self ) or not IsValid(self.Owner) then return end

		if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			self.Owner:SetNetworkedInt("Primed", 0)
		else
			self.Owner:SetNetworkedInt("Primed", 0)
			self.Weapon:Remove()
			self.Owner:ConCommand("lastinv")
		end
	end)
end