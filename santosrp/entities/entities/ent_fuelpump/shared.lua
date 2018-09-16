--[[
	Name: shared.lua
	For: SantosRP
	By: TalosLife
]]--

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Purpose			= ""
ENT.m_tblHoseSlots = {
	{ pos = Vector(0.588378, -17.75, 36.531387), ang = Angle(0, 0, 0) },
	--{ pos = Vector(0.588380, 17.75, 36.531387), ang = Angle(0, 0, 0) },

	--{ pos = Vector(-22.75, -17.75, 36.531387), ang = Angle(0, 180, 0) },
	--{ pos = Vector(-22.75, 17.75, 36.531387), ang = Angle(0, 180, 0) },
}
ENT.m_tblHosePoints = {
	{ pos = Vector(0, -28, 24), ang = Angle(90, 0, 0) },
	--{ pos = Vector(0), ang = Angle(0, 0, 0) },

	--{ pos = Vector(0), ang = Angle(0, 180, 0) },
	--{ pos = Vector(-22, 29, 24), ang = Angle(90, 180, 0) },
}

function ENT:GetHoseSlot( intID )
	return self:LocalToWorld( self.m_tblHoseSlots[intID].pos ), self:LocalToWorldAngles( self.m_tblHoseSlots[intID].ang )
end

function ENT:GetHosePoint( intID )
	return self:LocalToWorld( self.m_tblHosePoints[intID].pos ), self:LocalToWorldAngles( self.m_tblHosePoints[intID].ang )
end