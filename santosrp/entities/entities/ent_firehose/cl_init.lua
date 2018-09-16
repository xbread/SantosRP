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
	self.m_pWaterSound = CreateSound( self, "ambient/levels/canals/dam_water_loop2.wav" )
	self.m_pWaterSound:ChangePitch( 255, 0 )
	self.m_pWaterSound:SetSoundLevel( 80 )
end

function ENT:OnRemove()
	if self.m_pWaterSound then self.m_pWaterSound:Stop() end
end

function ENT:Think()
	local Car = self:GetOwner()
	if IsValid( Car ) and not IsValid( Car.Hose) then Car.Hose = self end

	if self:GetOn() then
		if not self.m_pWaterSound:IsPlaying() then
			self.m_pWaterSound:PlayEx( 0.25, 255 )
		end

		local data = EffectData()
		data:SetOrigin( self:GetPos() )
		data:SetNormal( self:GetAngles():Forward() *-1 )
		util.Effect( "waterSpray", data )
	else
		if self.m_pWaterSound:IsPlaying() then
			self.m_pWaterSound:Stop()
		end
	end
end

function ENT:Draw()
	self:DrawModel()
	
	local Car = self:GetOwner()
	if not IsValid( Car ) then return end
	
	Car.Hose = self
	
	local Pos, Ang = self:GetPos(), self:GetAngles()
	local Pos2, Ang2 = Car:LocalToWorld(Vector(-35, -15, -2)), Car:GetAngles()
	
	local CurvePos1 = Pos2 +Car:GetUp() *48 +Car:GetRight() *15 +Car:GetForward()*-8
	local CurveAng1 = (Car:GetRight() *-10):Angle()
	
	local CurvePos2 = Pos +(self:GetForward() *10)
	local CurveAng2 = Ang
	
	self:SetRenderBoundsWS( Pos, Pos2 )
	
	local Curve = nil
	if EyePos():Distance( self:GetPos() ) > GAMEMODE.Config.RenderDist_Level1 then	
		Curve = GAMEMODE.Util:BezierCurve( CurvePos1, CurveAng1, CurvePos2, CurveAng2, 30, 3 )
	else
		Curve = GAMEMODE.Util:BezierCurve( CurvePos1, CurveAng1, CurvePos2, CurveAng2, 30, 16 )
	end
	
	render.SetMaterial( Mat )
	GAMEMODE.Util:CurveToMesh( Curve, 12, 10 )
end