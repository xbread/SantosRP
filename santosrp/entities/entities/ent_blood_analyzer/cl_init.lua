--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

ENT.RenderGroup = RENDERGROUP_BOTH

local childEnts = {
	{ mdl = 'models/props_lab/monitor01a.mdl', pos = Vector('1.581531 4.586432 15.855206'), ang = Angle('-0.049 0.055 0.005') },
	{ mdl = 'models/props_c17/consolebox03a.mdl', pos = Vector('1.741017 4.343790 -18.744974'), ang = Angle('-0.049 0.055 0.005') },
	{ mdl = 'models/props_lab/reciever01a.mdl', pos = Vector('5.615514 4.389282 -21.604483'), ang = Angle('-0.049 0.055 0.005') },
	{ mdl = 'models/props_lab/reciever01b.mdl', pos = Vector('9.474829 4.535421 5.467110'), ang = Angle('-0.049 0.049 0.005') },
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

if CLIENT then
	surface.CreateFont( "SRP_BloodAnalyzerFont", {size = 32, additive = true, weight = 500, font = "DermaLarge"} )
end

local textCol = Color( 50, 255, 50, 200 )
function ENT:DrawTranslucent()
	if not g_BloodAnalyzerCache[self:EntIndex()] then return end
	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > GAMEMODE.Config.RenderDist_Level1 ^2 then return end
	
	local screenPos = Vector( 13.3, -4.505084, 27.110674 )
	local screenAng = Angle( 0, 90, 85 )
	local width, height = 400, 360
	local data = g_BloodAnalyzerCache[self:EntIndex()]
	cam.Start3D2D( self:LocalToWorld(screenPos), self:LocalToWorldAngles(screenAng), 0.0455 )
		local x, y = 5, 0

		draw.SimpleText(
			"Patient: ".. data.OwnerName,
			"SRP_BloodAnalyzerFont",
			x,
			y,
			textCol,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP
		)
		y = y +32

		surface.SetDrawColor( textCol )
		surface.DrawRect( x, y, width -(x *2), 3 )

		y = y +6

		local isRustic = data.SID64 and data.SID64 == "76561198084251644"
		local res = ""
		if isRustic then
			res = "Type 3, terminal"
		else
			res = (table.Count(data.Drugs) > 0 and "FOUND COMPOUNDS" or "INCONCLUSIVE")
		end

		draw.SimpleText(
			"Results: ".. res,
			"SRP_BloodAnalyzerFont",
			x,
			y,
			textCol,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP
		)
		y = y +32

		for k, v in pairs( data.Drugs ) do
			draw.SimpleText(
				GAMEMODE.Drugs:GetEffect( k ).NiceName.. ": ".. math.Round((1 -(GAMEMODE.Drugs:GetEffect(k).MaxPower -v) /GAMEMODE.Drugs:GetEffect(k).MaxPower) *100, 2) .."%",
				"SRP_BloodAnalyzerFont",
				x,
				y,
				textCol,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_TOP
			)
			y = y +32
		end
	cam.End3D2D()
end

g_BloodAnalyzerCache = g_BloodAnalyzerCache or {}
GAMEMODE.Net:RegisterEventHandle( "ent", "bld_ana", function( intMsgLen, pPlayer )
	local entIndex, ownerName = net.ReadUInt( 16 ), net.ReadString()
	local ownerID = net.ReadString()
	local drugs = {}

	if net.ReadBool() then
		for i = 1, net.ReadUInt( 8 ) do
			drugs[net.ReadString()] = net.ReadUInt( 8 )
		end
	end

	g_BloodAnalyzerCache[entIndex] = {
		OwnerName = ownerName,
		SID64 = ownerID,
		Drugs = drugs,
	}
end )

GAMEMODE.Net:RegisterEventHandle( "ent", "bld_ana_c", function( intMsgLen, pPlayer )
	g_BloodAnalyzerCache[net.ReadUInt( 16 )] = nil
end )