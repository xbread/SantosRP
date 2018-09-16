--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	if self.ConfigInit then
		self:ConfigInit()
	end
end

function ENT:SetPourSound( strSound )
	self.m_sndPourSound = CreateSound( self, strSound )
	self.m_sndPourSound:SetSoundLevel( 65 )
end

function ENT:OnRemove()
	if self.m_sndPourSound then
		self.m_sndPourSound:Stop()
	end
end

function ENT:Think()
	if self:GetPouring() then
		if self.m_sndPourSound and not self.m_sndPourSound:IsPlaying() then
			self.m_sndPourSound:PlayEx( 0.33, 100 )
		end
	else
		if self.m_sndPourSound and self.m_sndPourSound:IsPlaying() then
			self.m_sndPourSound:Stop()
		end
	end
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > GAMEMODE.Config.RenderDist_Level1 ^2 then
		return
	end

	local min, max = self:GetRenderBounds()
	local tall = max.z -min.z
	local camPos = self:GetPos() +Vector( 0, 0, tall +5 )
	local camAng = Angle( 0, LocalPlayer():EyeAngles().y -90, 90 )
	cam.Start3D2D( camPos, camAng, 0.05 )
		draw.SimpleText(
			self:GetDisplayText(),
			"DermaLarge",
			0,
			0,
			color_white,
			TEXT_ALIGN_CENTER
		)
	cam.End3D2D()
end