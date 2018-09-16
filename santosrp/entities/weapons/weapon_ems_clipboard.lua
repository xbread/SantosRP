if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName		= "Patient Clipboard"
SWEP.Author			= "Ultra"
SWEP.Instructions	= "Left click on a player to view in depth health info."
SWEP.Base 			= "weapon_sck_base"
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV	= 70

SWEP.Spawnable		= false
SWEP.Slot 			= 5
SWEP.UseHands 		= false

SWEP.HoldType 		= "normal"

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
	["clipmodel"] = { type = "Model", model = "models/props_lab/clipboard.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(0, 2.65, -0.06), angle = Angle(-17.557, -89.32, -169.508), size = Vector(1.241, 1.241, 1.241), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["clipmodel"] = { type = "Model", model = "models/props_lab/clipboard.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(1.536, -0.304, 8.281), angle = Angle(73.939, 1.149, -3.539), size = Vector(1.279, 1.279, 1.279), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Initialize()
	self.BaseClass.Initialize( self )

	if CLIENT then
		self.m_tblHealthData = {
			Limbs = {},
			Health = 0,
			Target = NULL,
		}
	end
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() +1 )

	if SERVER then
		local ent = util.TraceLine{
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() +self.Owner:GetAimVector() *100,
			filter = { self, self.Owner }
		}.Entity

		if not IsValid( ent ) or not ent:IsPlayer() then return end
		GAMEMODE.Net:SendPlayerEMSClipboardData( self.Owner, ent )
	end
end

function SWEP:SecondaryAttack()
end

if CLIENT then
	surface.CreateFont( "SRP_ClipboardFont", {size = 32, weight = 500, font = "DermaLarge"} )
	surface.CreateFont( "SRP_ClipboardFont2", {size = 24, weight = 500, font = "DermaLarge"} )
end

function SWEP:DrawBar( intX, intY, intW, intH, intNum, intMax )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( intX, intY, intW, intH )

	local scalar = 1 -((intMax -intNum) /intMax)
	surface.SetDrawColor( 255, 50, 50, 255 )
	surface.DrawRect( intX +1, intY +1, (intW -2) *scalar, intH -2 )

	draw.SimpleTextOutlined(
		intNum.. "/".. intMax.. "HP",
		"SRP_ClipboardFont2",
		intX +(intW /2), intY,
		color_white,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_TOP,
		2,
		color_black
	)
end

local MAT_BLEED = Material( "icon16/bullet_red.png" )
local MAT_BROKEN = Material( "icon16/bullet_orange.png" )
function SWEP:PostDrawViewModel( entVM, entWep, pPlayer )
	render.SetBlend( 1 )

	if not self.VElements then return end
	if not self.VElements["clipmodel"] then return end
	if not self.VElements["clipmodel"].modelEnt then return end
	local elm = self.VElements["clipmodel"]
	local mdl = elm.modelEnt

	local camoffset = Vector( -4.927246, -3.227539, 0.625366 ) *1.241
	local angOffset = Angle( 0, 90, 0 )

	local pos, ang = self:GetBoneOrientation( self.VElements, elm, entVM )
	pos = pos +(ang:Forward() *elm.pos.x +ang:Right() *elm.pos.y +ang:Up() *elm.pos.z)
	mdl:SetPos( pos )

	ang:RotateAroundAxis(ang:Up(), elm.angle.y)
	ang:RotateAroundAxis(ang:Right(), elm.angle.p)
	ang:RotateAroundAxis(ang:Forward(), elm.angle.r)
	mdl:SetAngles( ang )

	local wide, tall = 525, 740
	cam.Start3D2D( mdl:LocalToWorld(camoffset), mdl:LocalToWorldAngles( angOffset ), 0.015 )
	cam.IgnoreZ( true )
		surface.SetDrawColor( 230, 230, 220, 255 )
		surface.DrawRect( 0, 0, wide, tall )
		local x, y = 5, 0

		draw.SimpleText(
			"Patient: ".. (IsValid( self.m_tblHealthData.Target ) and self.m_tblHealthData.Target:Nick() or ""),
			"SRP_ClipboardFont",
			x,
			y,
			color_black,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP
		)
		y = y +32
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( x, y, wide -(x *2), 3 )

		if IsValid( self.m_tblHealthData.Target ) then
			draw.SimpleText(
				"Sex: ".. (GAMEMODE.Player:GetSharedGameVar(self.m_tblHealthData.Target, "char_sex", 0) == 0 and "Male" or "Female"),
				"SRP_ClipboardFont",
				x,
				y,
				color_black,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_TOP
			)
			y = y +32
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect( x, y, wide -(x *2), 3 )

			y = y +32

			draw.SimpleText(
				"Patient Physical:",
				"SRP_ClipboardFont",
				x,
				y,
				color_black,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_TOP
			)
			local barWide = 200
			self:DrawBar( wide -barWide -5, y +4, barWide, 32 -5, self.m_tblHealthData.Target:Health(), 100 )
			y = y +32
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect( x, y, wide -(x *2), 3 )

			local done = {}
			for k, v in pairs( self.m_tblHealthData.Limbs ) do
				if not GAMEMODE.PlayerDamage:GetLimbs()[k] then continue end
				if done[GAMEMODE.PlayerDamage:GetLimbs()[k].Name] then continue end
				done[GAMEMODE.PlayerDamage:GetLimbs()[k].Name] = true

				draw.SimpleText(
					GAMEMODE.PlayerDamage:GetLimbs()[k].Name,
					"SRP_ClipboardFont",
					x,
					y,
					color_black,
					TEXT_ALIGN_LEFT,
					TEXT_ALIGN_TOP
				)

				local barWide = 200
				self:DrawBar( wide -barWide -5, y +4, barWide, 32 -5, v.Health, GAMEMODE.PlayerDamage:GetLimbs()[k].MaxHealth )
				
				local isBroken = v.Broken
				local isBleeding = v.Bleeding
				if isBroken or isBleeding then
					y = y +32
					local xi = x
					if isBroken then
						surface.SetMaterial( MAT_BROKEN )
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.DrawTexturedRect( xi, y -2, 32, 32 )

						draw.SimpleText(
							"Broken!",
							"SRP_ClipboardFont2",
							xi +32 +2, y,
							color_black,
							TEXT_ALIGN_LEFT,
							TEXT_ALIGN_TOP
						)

						local a, b = surface.GetTextSize( "Broken!" )
						xi = xi +32 +2 +a +10
					end

					if isBleeding then
						surface.SetMaterial( MAT_BLEED )
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.DrawTexturedRect( xi, y -2, 32, 32 )

						draw.SimpleText(
							"Bleeding!",
							"SRP_ClipboardFont2",
							xi +32 +2, y,
							color_black,
							TEXT_ALIGN_LEFT,
							TEXT_ALIGN_TOP
						)

						local a, b = surface.GetTextSize( "Bleeding!" )
						xi = xi +32 +2 +a +10
					end
				end

				y = y +32
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( x, y, wide -(x *2), 3 )
			end
		end
	cam.IgnoreZ( false )
	cam.End3D2D()
end