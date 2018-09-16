--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local colBlack = Color( 0, 0, 0, 255 )
local childEnts = {}

local sndBoil = "ambient/machines/deep_boil.wav"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self.m_tblEnts = {}

	for k, v in pairs( childEnts ) do
		local ent = ClientsideModel( v.mdl, RENDERGROUP_BOTH )
		ent:SetPos( self:LocalToWorld(v.pos) )
		ent:SetAngles( self:LocalToWorldAngles(v.ang) )
		ent:SetParent( self )
		self.m_tblEnts[ent] = k
	end

	self.m_sndBoil = CreateSound( self, sndBoil )
end

function ENT:OnRemove()
	for k, v in pairs( self.m_tblEnts ) do
		k:Remove()
	end

	if self.m_sndBoil then self.m_sndBoil:Stop() end
end

function ENT:Draw()
	for k, v in pairs( self.m_tblEnts ) do
		if IsValid( k ) and IsValid( k:GetParent() ) then break end
		if not IsValid( k ) then continue end

		k:SetPos( self:LocalToWorld(childEnts[v].pos) )
		k:SetAngles( self:LocalToWorldAngles(childEnts[v].ang) )
		k:SetParent( self )
	end

	self:DrawModel()
end

function ENT:ThinkSounds()
	if self:GetOn() then
		if not self.m_sndBoil:IsPlaying() then
			self.m_sndBoil:SetSoundLevel( 58 )
			self.m_sndBoil:Play()
		end
	else
		if self.m_sndBoil:IsPlaying() then
			self.m_sndBoil:Stop()
		end
	end
end

function ENT:Think()
	self:ThinkSounds()
end

function ENT:DrawBar( intX, intY, intW, intH, colColor, intCur, intMax )
	surface.SetDrawColor( colBlack )
	surface.DrawRect( intX, intY, intW, intH )

	local padding = 1
	local wide = (intCur /intMax) *(intW -(padding *2))
	surface.SetDrawColor( colColor )
	surface.DrawRect( intX +padding, intY +padding, wide, intH -(padding *2) )
end

function ENT:DrawTranslucent()
	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > GAMEMODE.Config.RenderDist_Level1 ^2 then
		return
	end

	local camPos = self:LocalToWorld( Vector(0, -6.5, 24) )
	local camAng = self:LocalToWorldAngles( Angle(0, 90, 90) )
	cam.Start3D2D( camPos, camAng, 0.05 )
		local y = 0

		self:DrawBar( 0, y, 256, 32, Color(255, 50, 50, 255), self:GetCoffeeAmount(), self.MaxCoffeeAmount )
		draw.SimpleText(
			"Coffee",
			"DermaLarge",
			(256 /2),
			y,
			Color( 255, 255, 255, 255 ),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_LEFT
		)
		y = y -32 -5

		self:DrawBar( 0, y, 256, 32, Color(255, 50, 50, 255), self:GetWaterAmount(), self.MaxWaterAmount )
		draw.SimpleText(
			"Water",
			"DermaLarge",
			(256 /2),
			y,
			Color( 255, 255, 255, 255 ),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_LEFT
		)
		y = y -32 -5

		self:DrawBar( 0, y, 256, 32, Color(255, 50, 50, 255), self:GetCoffeeGrainAmount(), self.MaxCoffeeGrainAmount )
		draw.SimpleText(
			"Ground Coffee",
			"DermaLarge",
			(256 /2),
			y,
			Color( 255, 255, 255, 255 ),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_LEFT
		)
		y = y -32 -5
	cam.End3D2D()
end