--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local childEnts = {
	{
		ang	= Angle(-2.582, 77.558, -0.170),
		mdl	= "models/props_c17/tools_wrench01a.mdl",
		pos	= Vector(11.250488, -51.443359, 17.222664),
	},
	{
		ang	= Angle(-0.615, 0.802, 0.000),
		mdl	= "models/props_lab/partsbin01.mdl",
		pos	= Vector(-14.995117, -41.738281, 30.313736),
	},
	{
		ang	= Angle(-0.022, 2.401, 0.538),
		mdl	= "models/props_lab/bindergreen.mdl",
		pos	= Vector(-14.457520, -27.715332, 17.394966),
	},
	{
		ang	= Angle(-0.077, 5.790, 0.489),
		mdl	= "models/props_lab/bindergraylabel01b.mdl",
		pos	= Vector(-14.551270, -24.495605, 17.321388),
	},
	{
		ang	= Angle(0.077, 0.396, 16.749),
		mdl	= "models/props_lab/binderbluelabel.mdl",
		pos	= Vector(-12.513672, -17.217285, 17.760139),
	},
	{
		ang	= Angle(-0.330, 45.198, 8.855),
		mdl	= "models/props/cs_militia/circularsaw01.mdl",
		pos	= Vector(-14.291016, -7.043945, 17.163460),
	},
	{
		ang	= Angle(-0.000, 43.885, 0.000),
		mdl	= "models/props_junk/metal_paintcan001a.mdl",
		pos	= Vector(-13.734375, 20.567383, 23.844772),
	},
	{
		ang	= Angle(-1.192, -8.657, 0.005),
		mdl	= "models/props_lab/reciever01c.mdl",
		pos	= Vector(-13.358887, 33.544434, 19.244873),
	},
	{
		ang	= Angle(0.077, -23.055, 0.071),
		mdl	= "models/props_lab/desklamp01.mdl",
		pos	= Vector(-8.989258, 44.998535, 26.056831),
	},
	{
		ang	= Angle(0.110, -39.375, -0.082),
		mdl	= "models/props_junk/garbage_coffeemug001a.mdl",
		pos	= Vector(8.057129, 48.633789, 20.037590),
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
end

function ENT:OnRemove()
	for k, v in pairs( self.m_tblEnts ) do
		k:Remove()
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