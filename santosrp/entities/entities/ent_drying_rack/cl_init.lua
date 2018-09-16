--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local childEnts = {
	{
		ang	= Angle(0, 0, 0),
		mdl	= "models/freeman/ventfan_2.mdl",
		pos	= Vector(-35.110855, -0.196898, 72.611099),
	},
	{
		ang	= Angle(0, 0, 0),
		mdl	= "models/freeman/ventfan_2.mdl",
		pos	= Vector(-35.110855, -0.196898, 34.029213),
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

	self.m_sndFanHum = CreateSound( self, "ambient/tones/fan2_loop.wav" )
	self.m_sndFanHum:SetSoundLevel( 60 )
	self.m_sndFanHum:Play()
end

function ENT:OnRemove()
	for k, v in pairs( self.m_tblEnts ) do
		k:Remove()
	end

	if self.m_sndFanHum then
		self.m_sndFanHum:Stop()
	end
end

function ENT:Draw()
	self:DrawModel()

	for k, v in pairs( self.m_tblEnts ) do
		if IsValid( k ) and IsValid( k:GetParent() ) then break end
		if not IsValid( k ) then continue end
		
		k:SetPos( self:LocalToWorld(childEnts[v].pos) )
		k:SetAngles( self:LocalToWorldAngles(childEnts[v].ang) )
		k:SetParent( self )
	end
end