--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local childEnts = {
	{ mdl = 'models/props_interiors/pot01a.mdl', pos = Vector('2.766113 -9.764648 -4.156464'), ang = Angle('-0.000 140.707 -0.505') },
	{ mdl = 'models/props_c17/metalpot001a.mdl', pos = Vector('-16.674316 -17.961914 -2.760132'), ang = Angle('0.258 166.718 0.148') },
	{ mdl = 'models/props_lab/Cleaver.mdl', pos = Vector('-15.673340 18.298828 20.184479'), ang = Angle('-0.000 -157.500 90.000') },
	{ mdl = 'models/props_c17/metalpot002a.mdl', pos = Vector('-15.583984 18.549805 -7.946648'), ang = Angle('-0.000 -22.500 0.000') },
	{ mdl = 'models/props_interiors/pot02a.mdl', pos = Vector('18.547363 24.694336 23.461761'), ang = Angle('-0.483 -78.300 -0.181') },
	{ mdl = 'models/weapons/w_knife_t.mdl', pos = Vector('-27.821777 23.747070 20.353127'), ang = Angle('3.604 -75.190 -90.374') },
	{ mdl = 'models/props_junk/food_pile02.mdl', pos = Vector('2.112305 -3.224609 20.035225'), ang = Angle('-0.000 135.000 0.000') },
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