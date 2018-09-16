SWEP.Doors = {}
SWEP.Doors["prop_door_rotating"] = true

if SERVER then
	AddCSLuaFile()
	resource.AddWorkshop("461261004")
end

if CLIENT then
	SWEP.PrintName = "PoleCam"			
	SWEP.Author = "CustomHQ"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.Right = true
	SWEP.RightD = 1
	SWEP.Forward = 1
	SWEP.ForwardD = 1
	SWEP.Rotate = 0
	SWEP.Show  = true
	SWEP.WannaDoor = false
	SWEP.Enable = false
end

function SWEP:Initialize()
	self.AlreadyUsed = 0
	self:SetWeaponHoldType("ar2")
	self.CanUse = CurTime()
	self.LastTrack = CurTime()-20
	self.ange = 0
end

SWEP.Instructions = ""
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Category = "CustomHQ"

SWEP.ViewModelFOV = 57
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Primary.Damage = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.WorldModel = Model("models/weapons/custom/w_polecam.mdl")
SWEP.ViewModel = Model("models/weapons/custom/v_polecam.mdl")
SWEP.Indicator = 0

function SWEP:Deploy()
	self:SetWeaponHoldType("ar2")
	self.Indicator = CurTime() - 1
	self.WannaDoor = false
	self.ange = 0
	self.Enable = false

	timer.Simple(0.8,function()
		self.Enable = true
		self.Weapon:EmitSound(Sound("Weapon_Pistol.Empty"))
	end)

	if CLIENT then self:SetWeaponHoldType("ar2") self.Enable = false end
	
	return true
end

function SWEP:Holster()
	return true
end
 
function SWEP:OnDrop()

end

function SWEP:OnRemove()

end

function SWEP:Think()
	if not self.WannaDoor then return end
	if self.Doors[self.Owner:GetEyeTrace().Entity:GetClass()] then
		local dist =  self.Owner:GetPos():Distance(self.Owner:GetEyeTrace().Entity:GetPos())
		if dist > 80 then self.WannaDoor = false self.Weapon:SendWeaponAnim(ACT_VM_HITLEFT)	self.Right = false	 return end
	else
		self.WannaDoor = false
		self.Weapon:SendWeaponAnim(ACT_VM_HITLEFT)
		self.Right = false
	end
end

function SWEP:PrimaryAttack()
	self:SetWeaponHoldType("ar2")

	if self.Doors[self.Owner:GetEyeTrace().Entity:GetClass()] then
		local dist =  self.Owner:GetPos():Distance(self.Owner:GetEyeTrace().Entity:GetPos())
		if dist > 80 then self.WannaDoor = false return end

		timer.Simple(2,function()
			self.WannaDoor = true
		end)

		timer.Simple(0.4,function()
			self.Weapon:EmitSound(Sound("Weapon_Pistol.Empty"))
		end)

		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
end

function SWEP:SecondaryAttack()
	if self.Indicator < CurTime() then
		self.Indicator = CurTime() +1
		self.Right = !self.Right

		timer.Simple(0.4,function()
			if self.WannaDoor then return end
			self.Weapon:EmitSound(Sound("Weapon_Pistol.Empty"))
		end)

		if self.Right then
			if not self.WannaDoor then self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )  end
			self.RightD = 1
			if CLIENT and self.WannaDoor then self:RotateCam(180) end
		else
			if not self.WannaDoor then self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )  end
			self.RightD = -1
			if CLIENT and self.WannaDoor then self:RotateCam(0) end
		end
	end
end

function SWEP:Reload()
end

function SWEP:GetViewModelPosition(pos, ang )
	self.Forward = 1
	self.ForwardD = 1
	self.Rotate = 0
--	pos = pos + self.Owner:GetRight()*-10  
	if not self.WannaDoor then return pos,ang end
	if self.Doors[self.Owner:GetEyeTrace().Entity:GetClass()] then
	local dist =  self.Owner:GetPos():Distance(self.Owner:GetEyeTrace().Entity:GetPos())
	if dist > 80 then self.WannaDoor = false return pos,ang end
		local f = self.Owner:GetAngles().y
		local res = 0
		
		local ownA = self.Owner:EyeAngles()
		self.Owner:SetEyeAngles(Angle(40,ownA.y,ownA.r))
		self.Forward = dist/40
		self.ForwardD = 0
		if 90 > f-30 or (f+30 > 90 and f+30< 140) then
			res = 90
		end
		if f>-50 and f<50 then
			res = 0 
		end
		if f<-50 then 
			res = -90
		end
		if math.abs(f) > 150 then
			res = 180
		end

		local sel = res - f
		if sel > 300 then sel = sel - 360 end
		sel = sel*5
		sel = math.Clamp(sel,-20,20)
		self.Rotate = sel

		return pos, ang
	end
end

SWEP.OnceReload = false

if CLIENT then
	SWEP.mat = surface.GetTextureID("effects/tvscreen_noise003a")
	SWEP.rt	= GetRenderTarget("Dde",512,512)
	SWEP.mot = Material("dde") 

	local CamData = {}
	CamData.x = 0
	CamData.y = 0
	CamData.w = 512 
	CamData.h = 512

	function SWEP:ViewModelDrawn()
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		local bone = vm:LookupBone("screen") 
		if (!bone) then return end	
		
		local pos, ang = Vector(0,0,0), Angle(0,0,0)
		
		local m = vm:GetBoneMatrix(bone)
		
		if (m) then
			pos, ang = m:GetTranslation(), m:GetAngles()
		else
			return 
		end		

		ang:RotateAroundAxis(ang:Forward(),90)
		ang:RotateAroundAxis(ang:Right(), 17.62)
		ang:RotateAroundAxis(ang:Up(), -90)

		cam.Start3D2D(pos+ang:Right()*0.63+ang:Up()*2.4+ang:Forward()*0.8, ang, 0.03)
			self:DrawScreen(0,0,20,20)
		cam.End3D2D()
	end
	i = 0

	function SWEP:RotateCam(ang)
		if ang == 0 then self.ang = 0 self.ange = 179 else self.ange = 1 self.ang = 180 end
	end

	function SWEP:DrawHUD()				
		CamData.angles = LocalPlayer():EyeAngles()+Angle(0,90*self.RightD*self.ForwardD-self.Rotate,0) 
		CamData.origin = LocalPlayer():GetShootPos()+LocalPlayer():GetForward()*70*self.Forward +Vector(0,0,0)+LocalPlayer():GetRight()*0
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		local bone = vm:LookupBone("cam") 
		if (!bone) then return end	
		
		local pos, ang = Vector(0,0,0), Angle(0,0,0)
		local m = vm:GetBoneMatrix(bone)
		if (m) then
			pos, ang = m:GetTranslation(), m:GetAngles()
			CamData.angles		=   Angle(ang.p+180,ang.y-self.Rotate,0)
			CamData.origin		= pos + ang:Forward()*-3 + ang:Right()*-1.3 + ang:Up()*0
		else
			return 
		end
	 
		local drM = 0
		if self.WannaDoor then drM = 90 
		else
			vm:ManipulateBoneAngles(bone, Angle(0,0,0) )
		end
		if self.ange >0 and self.ange <180 then
			if self.ang == 0 then self.ange = self.ange - 1
			else self.ange = self.ange + 1 end
			vm:ManipulateBoneAngles(bone, Angle(self.ange+drM,0,0) )
		end
		
		self.Show = true
		if self.ForwardD != 0 then
			local tr = util.TraceLine( {
				start =CamData.origin,
				endpos =CamData.origin + ang:Forward()*-6*self.RightD,
				filter = LocalPlayer()
			} )
			if tr.Entity != NULL then self.Show = false  end
			
			local tr = util.TraceLine( {
				start =CamData.origin,
				endpos =CamData.origin + ang:Right()*70
			} )
			if tr.Entity != NULL then self.Show = false  end
			
			local tr = util.TraceLine( {
				start =CamData.origin,
				endpos =CamData.origin + ang:Forward()*6
			} )
			if tr.Entity != NULL then self.Show = false  end
		else
			local tr = util.TraceLine( {
				start =CamData.origin,
			endpos =CamData.origin + CamData.angles:Forward()*6
			} )

			if tr.Entity != NULL then self.Show = false  end
		end
		
		local OldRT	= render.GetRenderTarget()
		self.mot:SetTexture( "$basetexture", self.rt )
		render.SetRenderTarget( self.rt )
		render.ClearDepth()
		render.RenderView( CamData )
		render.SetRenderTarget( OldRT )
	end

	function SWEP:DrawScreen(x, y, w, h)
		self.Enable = true
		surface.SetDrawColor(62,62,62,255)
		surface.SetTexture(0)
		surface.DrawTexturedRect(-60,-46,100,70)

		if self.Enable then
			if self.Show then
				surface.SetDrawColor(255,255,255,100)
				surface.SetMaterial(self.mot)
				surface.DrawTexturedRect(-60,-46,100,70)
			else
				surface.SetDrawColor(2,2,2,255)
				surface.DrawTexturedRect(-60,-46,100,70)
			end

			surface.SetDrawColor(255,5,2,255)
			surface.SetTexture(self.mat)
			surface.DrawTexturedRect(-60,-46,100,70)
			-- draw border
		end

		surface.SetDrawColor( 0, 0, 0, 220 )
		surface.DrawOutlinedRect(-60,-46,100,70)
	end
end