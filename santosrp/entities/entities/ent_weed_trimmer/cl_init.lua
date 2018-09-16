--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local childEnts = {
	{
		ang	= Angle(-0.011, -2.769, -0.005),
		mdl	= "models/props_c17/grinderclamp01a.mdl",
		pos	= Vector(-0.063179, -24.012234, 11.650133),
	},
}

function ENT:Initialize()
	self.m_tblEnts = {}

	for k, v in pairs( childEnts ) do
		local ent = ClientsideModel( v.mdl, RENDERGROUP_BOTH )
		ent:SetPos( self:LocalToWorld(v.pos) )
		ent:SetAngles( self:LocalToWorldAngles(v.ang) )
		ent:SetParent( self )
		self.m_tblEnts[ent] = k
	end

	self.m_sndTrimmer = CreateSound( self, "ambient/atmosphere/laundry_amb.wav" )
end

function ENT:OnRemove()
	for k, v in pairs( self.m_tblEnts ) do
		k:Remove()
	end

	if self.m_sndTrimmer then
		self.m_sndTrimmer:Stop()
	end
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

function ENT:Think()
	if self:GetRunning() then
		if not self.m_sndTrimmer:IsPlaying() then
			self.m_sndTrimmer:SetSoundLevel( 68 )
			self.m_sndTrimmer:PlayEx( 1, 100 )
		end
	else
		if self.m_sndTrimmer:IsPlaying() then
			self.m_sndTrimmer:Stop()
		end
	end
end