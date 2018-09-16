if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName		= "Welding Torch"
SWEP.Author			= "Ultra"
SWEP.Instructions	= "Aim at a car and hold left click to repair it."
SWEP.Base 			= "weapon_sck_base"
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV	= 70

SWEP.Spawnable		= false
SWEP.Slot 			= 5
SWEP.UseHands 		= false

SWEP.HoldType 		= "pistol"

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

SWEP.VElements = {
	["vm_weld"] = { type = "Model", model = "models/props_silo/welding_torch.mdl", bone = "ValveBiped.muzzle", rel = "", pos = Vector(-18.713, 3.181, -0.009), angle = Angle(-0.311, -96.331, 34.599), size = Vector(1.261, 1.261, 1.261), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["wm_weld"] = { type = "Model", model = "models/props_silo/welding_torch.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.921, 1.781, 1.427), angle = Angle(92.996, -69.224, 11.053), size = Vector(1.016, 1.016, 1.016), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Welding" )
end

function SWEP:PrimaryAttack()
	if self.m_intNextWeldTrace then return end
	self.m_intNextWeldTrace = CurTime() +1
end

function SWEP:SecondaryAttack()
end

function SWEP:WeldTrace()
	if (self.m_intWeldFX or 0) > CurTime() then return end
	self.m_intWeldFX = CurTime() +0.1

	local tr = util.TraceLine{
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() +self.Owner:GetAimVector() *64,
		filter = { self, self.Owner }
	}

	if not IsValid( tr.Entity ) then return end
	local effectData = EffectData()
	effectData:SetOrigin( tr.HitPos )
	effectData:SetNormal( tr.HitNormal )
	util.Effect( "StunstickImpact", effectData )

	if not self.m_intNextWeldTrace then return end
	if self.m_intNextWeldTrace > CurTime() then return end
	self.m_intNextWeldTrace = CurTime() +1

	if not IsValid( tr.Entity ) or not tr.Entity:IsVehicle() or not tr.Entity.UID then return end
	local cur, max = GAMEMODE.Cars:GetCarHealth( tr.Entity ), GAMEMODE.Cars:GetCarMaxHealth( tr.Entity )
	if cur >= max *0.33 then return end
	
	GAMEMODE.Cars:SetCarHealth( tr.Entity, math.min(cur +math.Round(max *0.01), max *0.33) )
end

function SWEP:Think()
	if SERVER then
		if not IsValid( self.Owner ) then return end

		if self.Owner:KeyDown( IN_ATTACK ) and not self.Owner:InVehicle() then
			if GAMEMODE.Util:VectorInRange( self.Owner:GetPos(),
				GAMEMODE.Config.TowWelderZone.Min,
				GAMEMODE.Config.TowWelderZone.Max ) then
				
				if not self:GetWelding() then
					self:SetWelding( true )
				end

				self:WeldTrace()
			else
				if not self.m_bHintedGarageZone then
					self.Owner:AddNote( "You must be inside the tow garage to use this tool." )
					self.m_bHintedGarageZone = true
				end

				if self:GetWelding() then
					self:SetWelding( false )
				end
			end
		else
			self.m_bHintedGarageZone = nil
			
			if self:GetWelding() then
				self:SetWelding( false )
			end
		end
	else
		if self:GetWelding() and IsValid( self.Owner ) and not self.Owner:InVehicle() then
			if not self.m_sndWelding or not self.m_sndWelding:IsPlaying() then
				self.m_sndWelding = self.m_sndWelding or CreateSound( self, "ambient/levels/outland/ol11_welding_loop.wav" )
				self.m_sndWelding:Play()
			end

			if CurTime() >(self.m_intLastFx or 0) then
				self.m_intLastFx = CurTime() +0.1

				--local effectData = EffectData()
				--effectData:SetOrigin( self.Owner:GetShootPos() +(self.Owner:GetAimVector() *24) )
				--util.Effect( "ManhackSparks", effectData )
			end
		else
			if self.m_sndWelding and self.m_sndWelding:IsPlaying() then
				self.m_sndWelding:Stop()
			end

			if self.m_intLastFx then self.m_intLastFx = nil end
		end
	end
end

local MAT_HEALTH_ICON = Material( "icon16/heart.png" )
local colGreen = Color( 50, 255, 50, 255 )
local colRed = Color( 255, 50, 50, 255 )
local iconSize = 16
hook.Add( "HUDPaint", "DrawWelderHud", function()
	if not IsValid( LocalPlayer() ) or not IsValid( LocalPlayer():GetActiveWeapon() ) then return end
	if LocalPlayer():GetActiveWeapon():GetClass() ~= "weapon_vehicle_welder" then return end
	if LocalPlayer():InVehicle() then return end
	
	local ent = LocalPlayer():GetEyeTrace().Entity
	if not IsValid( ent ) or not ent:IsVehicle() then return end
	if ent:GetPos():DistToSqr( LocalPlayer():GetPos() ) > 36000 then return end
	
	local pos = ent:LocalToWorld( ent:OBBCenter() ):ToScreen()
	local cur, max = GAMEMODE.Cars:GetCarHealth( ent ), GAMEMODE.Cars:GetCarMaxHealth( ent )

	draw.SimpleText(
		math.max( math.floor(cur), 0 ).. "/".. max,
		"Trebuchet24",
		pos.x,
		pos.y,
		cur >= max *0.33 and colGreen or colRed,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_TOP
	)

	surface.SetMaterial( MAT_HEALTH_ICON )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( pos.x -(iconSize /2), pos.y -iconSize, iconSize, iconSize )			
end )