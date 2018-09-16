if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	SWEP.PrintName = "Radar Gun"
	SWEP.Slot = 5
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.PrintName			= "Radar Gun"
SWEP.Author				= "Bobblehead"
SWEP.Purpose    		= "Get vehicle speed"

SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"

SWEP.ViewModelFOV		= 54

SWEP.DrawCrosshair		= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Delay			= .1
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.RenderGroup = RENDERGROUP_BOTH

function SWEP:Initialize()
	self:SetHoldType( "pistol" )
	self.DispSpeed = 0
end

if CLIENT then
		
	//Copied from swep construction kit.
	local function ResetBonePositions(self,vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end
	local allbones
	local hasGarryFixedBoneScalingYet = false
	local function UpdateBonePositions(self,vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			ResetBonePositions(self,vm)
		end
		   
	end
	local function GetBoneOrientation(self,ent)
		
		local bone, pos, ang
		
		
		bone = ent:LookupBone("Hand")
		
		if (!bone) then return end
		
		pos, ang = Vector(0,0,0), Angle(0,0,0)
		local m = ent:GetBoneMatrix(bone)
		if (m) then
			pos, ang = m:GetTranslation(), m:GetAngles()
		end
		
		if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
			ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
			ang.r = -ang.r // Fixes mirrored models
		end

		return pos, ang
	end
	--[[
	SWEP.VElements = {
		["screen"] = { type = "Quad", bone = "Python", rel = "", pos = Vector(-0.051, -2, -0.9), angle = Angle(1, 1, 48), size = 0.06, draw_func = nil},
		["model"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "Python", rel = "screen", pos = Vector(0, 0, -0.7), angle = Angle(0, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = true, material = "", skin = 0, bodygroup = {} }
	}
	]]
	function SWEP:ViewModelDrawn()
		local vm = self.Owner:GetViewModel()
		-- for i=0,vm:GetBoneCount() do print(vm:GetBoneName(i)) end
		if !IsValid(vm) then return end

		UpdateBonePositions(self,vm)
		local pos, ang = GetBoneOrientation(self, vm )
		local offset = Vector(.08, -5.18, 3.5)
		local offsetAng = Angle(180, 0, -45)
		local size = 0.059
		local drawpos = pos + ang:Forward() * offset.x + ang:Right() * offset.y + ang:Up() * offset.z
		ang:RotateAroundAxis(ang:Up(), offsetAng.y)
		ang:RotateAroundAxis(ang:Right(), offsetAng.p)
		ang:RotateAroundAxis(ang:Forward(), offsetAng.r)
		
		cam.Start3D2D(drawpos, ang, size)
			local x,y,w,h = -20,-20,40,40
	
	
			//Draw Background:
			draw.RoundedBox( 0, x, y, w, h, Color(40,40,40,255) )
			surface.SetDrawColor( 255, 255, 255, 100 )
			surface.DrawOutlinedRect( -20, -20, 40, 40 )
			
			draw.SimpleText(self.DispSpeed, "Trebuchet24", 0, 0,Color(200,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText("MPH", "Default", 0, 12,Color(200,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			
		cam.End3D2D()
		
		
	end
	
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	local ent = self.Owner:GetEyeTrace().Entity
	if ent:IsValid() and ent:IsVehicle() then
		self.DispSpeed = math.Round(((ent:GetVelocity():Length() * 60 * 60) / 52493.44 * 100)/100, 1)
		self:EmitSound(Sound("buttons/blip2.wav"))
	else
		self.DispSpeed = 0
		self:EmitSound(Sound("buttons/blip1.wav"))
	end
end

function SWEP:DrawHUD()
	local w,h = ScrW(),ScrH()
	
	surface.DrawCircle(w/2,h/2,5,Color(255,255,255))
end

function SWEP:SecondaryAttack()
end
