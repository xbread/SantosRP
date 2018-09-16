include( "shared.lua" )

local Mat = Material( "santosrp/blue.png", "vertexlitgeneric" )
local matBeam = Material( "cable/blue_elec" )
local Cables = {}

function ENT:Initialize()
	table.insert( Cables, self )
end

function ENT:Draw()
end

hook.Add( "PostDrawTranslucentRenderables", "DrawCables", function()
	for k, self in pairs( Cables ) do
		if not IsValid( self ) then Cables[k] = nil continue end
		local Pump = self:GetOwner()
		
		if not IsValid( Pump ) then Cables[k] = nil continue end
		
		local vm = false
		if Pump == LocalPlayer() then
			Pump = Pump:GetViewModel()
			vm = true
		end
		
		if not IsValid( Pump ) then Cables[k] = nil continue end
		
		local Pos, Ang = self:GetPos(), self:GetAngles()
		local Pos2, Ang2 = Pump:GetPos(), Pump:GetAngles()
		
		local CurvePos1
		if vm then
			local attachment = Pump:GetAttachment( 1 )
			if not attachment then
				Cables[k] = nil
				continue
			end
			CurvePos1 = attachment.Pos
			-- CurvePos1 = Pos2+Pump:GetUp()*-4+Pump:GetRight()*4+Pump:GetForward()*20
		else
			local bone = Pump:LookupBone( "ValveBiped.Bip01_R_Hand" )
			if bone then
				local pos, ang = Pump:GetBonePosition( bone )
				CurvePos1 = pos
			else
				CurvePos1 = Pos2
			end
			-- CurvePos1 = Pos2 + Pump:GetUp()*70 + Pump:GetRight() * 20
		end
		
		local CurveAng1 = Pump:GetForward():Angle()
		local CurvePos2 = Pos +self:GetForward() *5
		local CurveAng2 = -Ang:Up():Angle() -Angle( 80, 0, 0 )
		
		-- self:SetRenderBoundsWS(Pos,Pos2)

		local Curve = nil
		if EyePos():Distance(self:GetPos()) > GAMEMODE.Config.RenderDist_Level1 then
			Curve = GAMEMODE.Util:BezierCurve( CurvePos1, CurveAng1, CurvePos2, CurveAng2, 30, 3 )
		else
			Curve = GAMEMODE.Util:BezierCurve( CurvePos1, CurveAng1, CurvePos2, CurveAng2, 30, 16 )
		end
		
		-- render.SetMaterial(Mat)
		-- CurveToMesh(Curve,.1,3)
		
		render.SetMaterial( matBeam )
		local count = #Curve

		render.StartBeam( count )
			for k, v in ipairs( Curve ) do
				render.AddBeam( v, 0.3, 1, Color(255, 255, 255) )
			end
		render.EndBeam()
	end
end )