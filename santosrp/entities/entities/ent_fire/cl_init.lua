--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

function ENT:Initialize()
	--ParticleEffectAttach( "fire_medium_02_nosmoke", PATTACH_ABSORIGIN_FOLLOW, self, 0 )
end

function ENT:Draw()
end

function ENT:Think()
	if not self.m_intLastThink then
		self.m_intLastThink = 0
	end

	if CurTime() < self.m_intLastThink then return end
	self.m_intLastThink = CurTime() +0.5

	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( "fireFx", effectdata )
end