--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local Mat = CreateMaterial( "fireHose1", "VertexLitGeneric", {
	["$basetexture"] = "color/black",
	["$vertexcolor"] = "1",
} )

function ENT:Initialize()
	self.m_matHose = Mat
end

function ENT:Draw()
	self:DrawModel()
	
	local Car = self:GetOwner()
	if not IsValid( Car ) then return end
	if LocalPlayer():EyePos():Distance( self:GetPos() ) > GAMEMODE.Config.RenderDist_Level0 then return end
	
	Car.Hose = self
	local Pos, Ang = self:GetPos(), self:GetAngles()
	local Pos2, Ang2 = Car:LocalToWorld(Vector(-30, -4, 0)), Car:GetAngles()
	
	local CurvePos1, CurveAng1 = Car:GetHosePoint( 1 )
	
	local CurvePos2 = Pos +(self:GetUp() * -9) +(self:GetForward() *5.8)
	local CurveAng2 = (self:GetUp() *-1):Angle()
	
	self:SetRenderBoundsWS( Pos, Pos2 )
	
	if FrameNumber() % 2 == 0 then
		self.m_tblCurve = GAMEMODE.Util:BezierCurve( CurvePos1, CurveAng1, CurvePos2, CurveAng2, 30, 6 )
	end
	
	if not self.m_tblCurve then return end
	render.SetMaterial( self.m_matHose )
	GAMEMODE.Util:CurveToMesh( self.m_tblCurve, 4, 4 )
	--collectgarbage()
end