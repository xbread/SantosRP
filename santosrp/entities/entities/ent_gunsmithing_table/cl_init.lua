--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local childEnts = {
	{
		ang	= Angle("-0.000 -7.202 0.000"),
		mdl	= "models/props_c17/light_magnifyinglamp02.mdl",
		pos	= Vector("13.034180 -8.906738 34.504959"),
	},
	{
		ang	= Angle("-0.038 -90.209 0.242"),
		mdl	= "models/props/cs_militia/reload_bullet_tray.mdl",
		pos	= Vector("15.773926 23.966797 35.530815"),
	},
	{
		ang	= Angle("0.022 -102.272 0.258"),
		mdl	= "models/props/cs_militia/reload_bullet_tray.mdl",
		pos	= Vector("16.081055 30.519043 35.493958"),
	},
	{
		ang	= Angle("-0.000 -0.000 0.000"),
		mdl	= "models/props/cs_militia/reloadingpress01.mdl",
		pos	= Vector("26.365723 39.126953 35.027969"),
	},
	{
		ang	= Angle("-0.412 -10.981 0.016"),
		mdl	= "models/props/cs_militia/reload_scale.mdl",
		pos	= Vector("2.352051 28.119629 35.543251"),
	},
	{
		ang	= Angle("-0.088 -6.515 0.000"),
		mdl	= "models/props_lab/box01a.mdl",
		pos	= Vector("-16.341797 28.199707 38.855087"),
	},
	{
		ang	= Angle("-0.000 0.005 0.000"),
		mdl	= "models/items/boxbuckshot.mdl",
		pos	= Vector("-16.492676 14.416016 35.452354"),
	},
	{
		ang	= Angle("0.269 -7.059 -0.165"),
		mdl	= "models/items/boxbuckshot.mdl",
		pos	= Vector("-17.838379 3.371582 35.589462"),
	},
	{
		ang	= Angle("1.104 4.938 0.198"),
		mdl	= "models/items/357ammo.mdl",
		pos	= Vector("-10.173828 3.040039 35.461090"),
	},
	{
		ang	= Angle("0.956 175.880 -1.252"),
		mdl	= "models/weapons/w_pist_elite_dropped.mdl",
		pos	= Vector("-14.673340 -9.973145 36.831459"),
	},
	{
		ang	= Angle("-0.082 4.230 -0.027"),
		mdl	= "models/props_lab/partsbin01.mdl",
		pos	= Vector("-16.951660 -31.135254 48.591682"),
	},
	{
		ang	= Angle("-0.956 -80.502 0.016"),
		mdl	= "models/props_c17/tools_wrench01a.mdl",
		pos	= Vector("9.594237 -40.895508 35.490280"),
	},
	{
		ang	= Angle("2.884 68.346 0.187"),
		mdl	= "models/props_c17/tools_pliers01a.mdl",
		pos	= Vector("5.800781 -31.868652 35.121437"),
	},
	{
		ang	= Angle("0.077 -67.324 0.000"),
		mdl	= "models/gibs/metal_gib2.mdl",
		pos	= Vector("10.907715 -23.717285 36.608803"),
	},
	{
		ang	= Angle("-52.015 -155.023 -0.198"),
		mdl	= "models/gibs/metal_gib3.mdl",
		pos	= Vector("-4.105469 -17.558594 36.106522"),
	},
	{
		ang	= Angle("0.423 171.343 -0.110"),
		mdl	= "models/gibs/metal_gib5.mdl",
		pos	= Vector("1.416992 -15.117188 35.787628"),
	},
	{
		ang	= Angle("0.676 -14.854 -0.209"),
		mdl	= "models/gibs/metal_gib4.mdl",
		pos	= Vector("-2.489746 -8.081543 35.806221"),
	},
	{
		ang	= Angle("-87.094 -138.697 38.650"),
		mdl	= "models/gibs/metal_gib1.mdl",
		pos	= Vector("2.827148 -4.175293 36.319351"),
	},
	{
		ang	= Angle("-0.648 93.170 0.198"),
		mdl	= "models/items/boxmrounds.mdl",
		pos	= Vector("11.612793 -32.164551 10.181244"),
	},
	{
		ang	= Angle("-0.203 -92.576 0.000"),
		mdl	= "models/items/boxmrounds.mdl",
		pos	= Vector("12.092773 -19.324707 10.279152"),
	},
	{
		ang	= Angle("-0.093 -86.446 -0.088"),
		mdl	= "models/props_junk/cardboard_box004a.mdl",
		pos	= Vector("-13.354004 0.111328 14.260277"),
	},
	{
		ang	= Angle("-0.088 179.973 0.044"),
		mdl	= "models/props_junk/cardboard_box003a.mdl",
		pos	= Vector("-4.448242 24.318359 19.805267"),
	},
	{
		ang	= Angle("-0.000 -91.664 0.000"),
		mdl	= "models/items/boxsrounds.mdl",
		pos	= Vector("10.921387 17.796875 10.234894"),
	},
	{
		ang	= Angle("0.055 -91.143 -0.154"),
		mdl	= "models/items/boxsrounds.mdl",
		pos	= Vector("9.969727 24.189941 10.142799"),
	},
	{
		ang	= Angle("-1.373 -78.585 -0.192"),
		mdl	= "models/items/boxsrounds.mdl",
		pos	= Vector("11.020020 32.207520 10.105759"),
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