--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local matLight = Material( "sprites/light_ignorez" )

function ENT:Initialize()
	self.m_colLight = Color( 255, 255, 255, 255 )
	self.PixVis = util.GetPixelVisibleHandle()

	self.m_sndLightHum = CreateSound( self, "ambient/machines/fluorescent_hum_1.wav" )
end

function ENT:OnRemove()
	self.m_sndLightHum:Stop()
end

function ENT:Think()
	if self:GetOn() then
		if not self.m_sndLightHum:IsPlaying() then
			self.m_sndLightHum:SetSoundLevel( 50 )
			self.m_sndLightHum:PlayEx( 0.75, 100 )
		end
	else
		if self.m_sndLightHum:IsPlaying() then
			self.m_sndLightHum:Stop()
		end
	end

	if not self:GetOn() then return end
	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > (GAMEMODE.Config.RenderDist_Level1 ^2) then
		return
	end

	local LightPos = self:LocalToWorld( Vector(5, 0, 4) )
	local dlight = DynamicLight( self:EntIndex() )
	if dlight then
		dlight.Pos = LightPos
		dlight.r = self.m_colLight.r
		dlight.g = self.m_colLight.g
		dlight.b = self.m_colLight.b
		dlight.Brightness = 4
		dlight.Decay = 128 *5
		dlight.Size = 128
		dlight.DieTime = CurTime() + 1
	end
end

function ENT:Draw()
	self:DrawModel()

	if not self:GetOn() then return end
	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > (GAMEMODE.Config.RenderDist_Level1 ^2) then
		return
	end

	local up = self:GetAngles():Up()
	local LightPos = self:LocalToWorld( Vector(5, 0, 4) )
	render.SetMaterial( matLight )
	
	local Visibile = util.PixelVisible( LightPos, 4, self.PixVis )	
	if not Visibile or Visibile < 0.55 then return end
	local c = self.m_colLight
	local Alpha = 255 *Visibile

	render.DrawSprite( LightPos -up *5, 8, 8, Color(255, 255, 255, Alpha), Visibile )
	render.DrawSprite( LightPos -up *5, 64, 64, Color(c.r, c.g, c.b, 64), Visibile )
end