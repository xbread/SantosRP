if SERVER then
	AddCSLuaFile()
elseif CLIENT then
	SWEP.PrintName = "Road Spikes"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "SantosRP"
SWEP.Instructions = "Left Click: Deploy Roadspikes"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.LockSound = "doors/door_latch1.wav"
SWEP.UnlockSound = "doors/door_latch3.wav"

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

SWEP.ViewModel = "models/myproject/SpikeStrip001.mdl"
SWEP.WorldModel = "models/myproject/SpikeStrip001.mdl"

function SWEP:Initialize()
	self:SetWeaponHoldType("fist")
end

function SWEP:CanPrimaryAttack ( ) return true end

function SWEP:PrimaryAttack()
	if(SERVER) then
		if(not self.Owner:Crouching()) then
			self.Owner:AddNote("You need to crouch before you can put down or pickup the road spikes.")
			self:SetNextPrimaryFire(CurTime() + 1)
		return end
		
		if(IsValid(self.Owner.RoadSpikesEntity)) then
			if(self.Owner.RoadSpikesEntity:GetPos():Distance(self.Owner:GetPos()) < 160) then
				self.Owner.RoadSpikesEntity:RemoveSpikes()
				self.Owner.RoadSpikesEntity = nil
				
				self:SetNextPrimaryFire(CurTime() + 1)
			else
				self.Owner:AddNote("You've already deployed your road spikes. Get back to retrieve it.")
				self:SetNextPrimaryFire(CurTime() + 1)
			end
			return
		end
		
		self.Owner.RoadSpikesEntity = ents.Create("ent_roadspikes")
		self.Owner.RoadSpikesEntity.OwnerID = self.Owner:SteamID()
		self.Owner.RoadSpikesEntity:SetNWString("owner", self.Owner:Nick() .. "  " .. self.Owner:SteamID())
		
		local v = Vector(150, 0, 0)
		v:Rotate(Angle(0, self.Owner:GetAngles().y, 0))
		
		local tr = {}
		tr.start = self.Owner:GetPos() + v
		tr.endpos = tr.start - Vector(0, 0, 1000)
		tr.filter = {self.Owner}
		local tr = util.TraceLine(tr)
		
		self.Owner.RoadSpikesEntity:SetPos(tr.HitPos)
		self.Owner.RoadSpikesEntity:SetAngles(Angle(0, self.Owner:GetAngles().y -45, 0))
		self.Owner.RoadSpikesEntity:Spawn()
		self.Owner.RoadSpikesEntity:Activate()
	end
	
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
end

if(SERVER) then return end

function SWEP:Deploy()
	if(IsValid(self.Owner:GetViewModel())) then
		--local Mat = Matrix()
		--Mat:Scale(Vector(1, 1, 0.1))
		--self.Owner:GetViewModel():EnableMatrix("RenderMultiply",Mat)
	end
end

function SWEP:Holster()
	if(IsValid(self.Owner:GetViewModel())) then
		self.Owner:GetViewModel():SetModelScale(1,0)
	end
end

function SWEP:DrawWorldModel()
	if IsValid( self.Owner ) then
		local iBone = self.Owner:LookupBone("ValveBiped.Bip01_L_Hand")
		if(iBone) then
			self:SetRenderOrigin(self.Owner:GetBonePosition(iBone) + self:GetUp() * 1 + self:GetForward() * 3 + self:GetRight() * 2)
			self:SetRenderAngles(Angle(self.Owner:EyeAngles().p, self.Owner:GetAngles().y, 0))
			local Mat = Matrix()
			Mat:Scale(Vector(1, 0.1, 1))
			self:EnableMatrix("RenderMultiply",Mat)
		end
	end
	
	self:DrawModel()
end

function SWEP:GetViewModelPosition(vPos, aAngles)
	vPos = vPos + LocalPlayer():GetUp()
	vPos = vPos + LocalPlayer():GetAimVector() *64
	vPos = vPos + LocalPlayer():GetRight() * 8
	aAngles:RotateAroundAxis(aAngles:Right(), 0)
	aAngles:RotateAroundAxis(aAngles:Forward(), 90)
	aAngles:RotateAroundAxis(aAngles:Up(), 0)
	return vPos, aAngles
end
