--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self.m_sndBurnSound = CreateSound( self, "weapons/flaregun/burn.wav" )
end

function ENT:OnRemove()
	if self.m_sndBurnSound then self.m_sndBurnSound:Stop() end
end

function ENT:Think()
	if not self:GetLit() then return end
	if not self.m_sndBurnSound:IsPlaying() then
		self.m_sndBurnSound:SetSoundLevel( 65 )
		self.m_sndBurnSound:Play()
	end
end