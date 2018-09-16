--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local childEnts = {
	{
		ang	= Angle("-0.357 -77.091 -0.137"),
		mdl	= "models/items/car_battery01.mdl",
		pos	= Vector("5.317383 -25.025879 15.847824"),
	},
	{
		ang	= Angle("-0.000 -174.771 0.000"),
		mdl	= "models/props_junk/cardboard_box003a.mdl",
		pos	= Vector("7.938965 18.419922 19.237038"),
	},
	{
		ang	= Angle("-0.148 -115.675 -0.066"),
		mdl	= "models/props_junk/cardboard_box004a.mdl",
		pos	= Vector("0.917969 18.861816 26.587463"),
	},
	{
		ang	= Angle("0.780 63.968 0.555"),
		mdl	= "models/props_junk/metal_paintcan001a.mdl",
		pos	= Vector("11.854980 29.065430 41.922859"),
	},
	{
		ang	= Angle("0.335 -93.389 -0.220"),
		mdl	= "models/props_c17/tools_wrench01a.mdl",
		pos	= Vector("-7.830078 31.603027 35.284798"),
	},
	{
		ang	= Angle("-0.236 -85.732 -0.060"),
		mdl	= "models/props_c17/tools_pliers01a.mdl",
		pos	= Vector("-6.113770 25.357910 35.084610"),
	},
	{
		ang	= Angle("-0.044 -170.178 -0.044"),
		mdl	= "models/props_lab/clipboard.mdl",
		pos	= Vector("1.704590 19.653320 35.301979"),
	},
	{ 
		ang	= Angle("-0.280 148.563 -176.089"),
		mdl	= "models/gibs/manhack_gib03.mdl",
		pos	= Vector("-1.856445 11.644531 38.467674"),
	},
	{
		ang	= Angle("-0.406 -22.753 -89.934"),
		mdl	= "models/items/battery.mdl",
		pos	= Vector("2.986816 -0.922852 37.585129"),
	},
	{
		ang	= Angle("86.418 -152.611 33.344"),
		mdl	= "models/gibs/metal_gib1.mdl",
		pos	= Vector("-6.173828 7.387207 36.155235"),
	},
	{
		ang	= Angle("-2.186 155.495 0.137"),
		mdl	= "models/gibs/metal_gib4.mdl",
		pos	= Vector("-1.512207 2.593262 35.684074"),
	},
	{
		ang	= Angle("-1.505 -101.052 -0.610"),
		mdl	= "models/props_lab/reciever01c.mdl",
		pos	= Vector("-5.920898 -9.108887 37.474236"),
	},
	{
		ang	= Angle("-0.764 -116.977 52.191"),
		mdl	= "models/weapons/w_crowbar.mdl",
		pos	= Vector("6.981934 -1.987793 35.685638"),
	},
	{
		ang	= Angle("0.027 151.282 -0.038"),
		mdl	= "models/props_lab/desklamp01.mdl",
		pos	= Vector("8.522461 -9.674805 43.875412"),
	},
	{ 
		ang	= Angle("0.198 -82.892 -89.923"),
		mdl	= "models/props/cs_office/computer_caseb_p4a.mdl",
		pos	= Vector("-0.364258 -35.243652 38.815651"),
	},
	{
		ang	= Angle("-0.198 98.542 89.813"),
		mdl	= "models/props/cs_office/computer_caseb_p7a.mdl",
		pos	= Vector("-1.632324 -24.895508 32.766151"),
	},
	{
		ang	= Angle("-8.289 127.936 8.877"),
		mdl	= "models/props/cs_office/computer_caseb_p3a.mdl",
		pos	= Vector("-3.186035 -26.049316 33.726471"),
	},
	{
		ang	= Angle("-2.796 86.193 -14.150"),
		mdl	= "models/props/cs_office/computer_caseb_p2a.mdl",
		pos	= Vector("2.062988 -22.712891 29.840782"),
	}
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