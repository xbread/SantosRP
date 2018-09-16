--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife 
]]--

include "shared.lua"

local colBlack = Color( 0, 0, 0, 255 )
local childEnts = {
	{ mdl = 'models/props_pipes/pipe01_90degree01.mdl', pos = Vector('20.385130 -39.390255 24.641167'), ang = Angle('90.000 90.000 0.000') },
	{ mdl = 'models/props_wasteland/prison_pipefaucet001a.mdl', pos = Vector('13.948706 -42.970890 -12.201790'), ang = Angle('-0.000 -157.495 0.000') },
	{ mdl = 'models/props_wasteland/laundry_washer003.mdl', pos = Vector('40.149094 -6.841177 -7.543961'), ang = Angle('-0.000 -179.995 0.000') },
	{ mdl = 'models/props_lab/jar01a.mdl', pos = Vector('28.163609 -28.321272 -29.180725'), ang = Angle('-67.500 -89.994 -89.995') },
	{ mdl = 'models/props_pipes/pipe01_90degree01.mdl', pos = Vector('89.620544 -4.477542 23.235191'), ang = Angle('90.000 -89.995 0.000') },
	{ mdl = 'models/props_pipes/valve003.mdl', pos = Vector('36.184135 -29.815374 -20.850571'), ang = Angle('50.625 -89.994 0.000') },
	{ mdl = 'models/props_pipes/pipe01_90degree01.mdl', pos = Vector('36.140099 -31.409189 -12.127876'), ang = Angle('-90.000 -179.989 0.000') },
	{ mdl = 'models/props_lab/powerbox02a.mdl', pos = Vector('30.373186 26.523241 9.912941'), ang = Angle('-0.000 45.006 0.000') },
	{ mdl = 'models/props_lab/powerbox02c.mdl', pos = Vector('80.723701 -26.136477 2.226059'), ang = Angle('-45.000 -89.994 -179.995') },
	{ mdl = 'models/props_pipes/pipe01_90degree01.mdl', pos = Vector('28.835567 -39.385109 24.624527'), ang = Angle('90.000 -89.995 0.000') },
	{ mdl = 'models/props_junk/propane_tank001a.mdl', pos = Vector('68.670105 13.379761 -30.153702'), ang = Angle('44.973 90.000 -90.005') },
	{ mdl = 'models/props_junk/propane_tank001a.mdl', pos = Vector('39.335018 13.377312 -30.157303'), ang = Angle('44.973 90.000 -90.005') },
	{ mdl = 'models/props_pipes/pipe01_straight01_long.mdl', pos = Vector('15.066709 -4.420185 23.460869'), ang = Angle('-0.000 -90.000 0.000') },
	{ mdl = 'models/props_pipes/valve003.mdl', pos = Vector('53.364677 -29.813602 -20.850571'), ang = Angle('50.625 -89.994 0.000') },
	{ mdl = 'models/props_c17/canister01a.mdl', pos = Vector('55.799145 -27.467911 -29.154762'), ang = Angle('-67.500 90.006 -90.000') },
	{ mdl = 'models/props_pipes/pipe01_scurve01_long.mdl', pos = Vector('34.014023 -39.262848 7.517586'), ang = Angle('-0.000 -89.994 -89.995') },
	{ mdl = 'models/props_lab/reciever01a.mdl', pos = Vector('51.119675 -28.455603 -3.834244'), ang = Angle('-0.000 -89.994 0.000') },
	{ mdl = 'models/props_pipes/pipe01_straight01_long.mdl', pos = Vector('61.863949 -4.415753 23.460869'), ang = Angle('-0.000 -90.000 0.000') },
	{ mdl = 'models/props_lab/powerbox02b.mdl', pos = Vector('80.656723 -29.050730 -11.276031'), ang = Angle('-0.000 -90.000 0.000') },
	{ mdl = 'models/props_pipes/pipe01_90degree01.mdl', pos = Vector('20.398802 -39.403439 16.718758'), ang = Angle('-90.000 -179.994 0.000') },
}

local sndMachine = "santosrp/gel_pump_start_lp_03.wav"

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self.m_tblEnts = {}

	for k, v in pairs( childEnts ) do
		local ent = ClientsideModel( v.mdl, RENDERGROUP_BOTH )
		ent:SetPos( self:LocalToWorld(v.pos) )
		ent:SetAngles( self:LocalToWorldAngles(v.ang) )
		ent:SetParent( self )
		self.m_tblEnts[ent] = k
	end

	self.m_sndMachine = CreateSound( self, sndMachine )
end

function ENT:OnRemove()
	for k, v in pairs( self.m_tblEnts ) do
		k:Remove()
	end

	if self.m_sndMachine then self.m_sndMachine:Stop() end
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

function ENT:ThinkSounds()
	if self:GetChamberOn() then
		if not self.m_sndMachine:IsPlaying() then
			self.m_sndMachine:SetSoundLevel( 60 )
			self.m_sndMachine:Play()
		end
	else
		if self.m_sndMachine:IsPlaying() then
			self.m_sndMachine:Stop()
		end
	end
end

function ENT:Think()
	self:ThinkSounds()
end

function ENT:DrawBar( intX, intY, intW, intH, colColor, intCur, intMax )
	surface.SetDrawColor( colBlack )
	surface.DrawRect( intX, intY, intW, intH )

	local padding = 1
	local wide = (intCur /intMax) *(intW -(padding *2))
	surface.SetDrawColor( colColor )
	surface.DrawRect( intX +padding, intY +padding, wide, intH -(padding *2) )
end

function ENT:DrawTranslucent()
	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > GAMEMODE.Config.RenderDist_Level1 ^2 then
		return
	end

	local camPos = self:LocalToWorld( Vector(40.1, -8.9, 17) )
	local camAng = self:LocalToWorldAngles( Angle(0, 0, 44) )
	cam.Start3D2D( camPos, camAng, 0.075 )
		local w, h = 426, 302
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, w, h )

		local y = 5
		for i = 1, 3 do
			if not self:GetTankFluidType( i ) or self:GetTankFluidType( i ) == "" then continue end
			self:DrawBar( 5, y, w -10, 32, Color(255, 50, 50, 255), self:GetTankAmount(i), self.MaxTankFluid )
			
			draw.SimpleText(
				self:GetTankFluidType(i) .. " (".. self:GetTankAmount(i).. "ml/".. self.MaxTankFluid.. "ml)",
				"Trebuchet24",
				10,
				y +3,
				Color( 255, 255, 255, 255 ),
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_LEFT
			)

			y = y +32 +5
		end

		if self:GetOutputFluidID() ~= "" then
			self:DrawBar( 5, h -32 -5, w -10, 32, Color(255, 50, 50, 255), self:GetOutputFluidAmount(), self.MaxTankFluid )

			draw.SimpleText(
				self:GetOutputFluidID() .. " (".. self:GetOutputFluidAmount(i).. "ml/".. self.MaxTankFluid.. "ml)",
				"Trebuchet24",
				10,
				h -32 -2,
				Color( 255, 255, 255, 255 ),
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_LEFT
			)
		end
	cam.End3D2D()
end