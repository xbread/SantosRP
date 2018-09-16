--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local colBlack = Color( 0, 0, 0, 255 )
local childEnts = {	{ mdl = 'models/props_pipes/valve003.mdl', pos = Vector('9.296378 -0.072948 21.417440'), ang = Angle('89.911 111.806 111.812') },
	{ mdl = 'models/props_pipes/pipe02_45degree01.mdl', pos = Vector('0.035572 -26.930359 31.260754'), ang = Angle('44.918 90.027 -89.948') },
	{ mdl = 'models/props_pipes/valve003.mdl', pos = Vector('5.112483 -0.137689 66.721214'), ang = Angle('89.911 111.806 111.812') },
	{ mdl = 'models/props_lab/reciever01d.mdl', pos = Vector('4.142025 0.275324 46.929153'), ang = Angle('0.033 -0.005 0.082') },
	{ mdl = 'models/props_c17/pottery01a.mdl', pos = Vector('0.087657 -26.535456 33.672646'), ang = Angle('0.063 -112.506 -0.062') },
	{ mdl = 'models/props_pipes/pipe02_45degree01.mdl', pos = Vector('0.075168 -16.788900 21.179264'), ang = Angle('-44.918 -89.973 -90.041') },
	{ mdl = 'models/props_wasteland/prison_pipefaucet001a.mdl', pos = Vector('-29.027960 -15.423793 17.604469'), ang = Angle('-0.033 179.995 -0.082') },
	{ mdl = 'models/props_pipes/pipe02_lcurve01_long.mdl', pos = Vector('-25.341085 0.012717 59.360310'), ang = Angle('-0.082 89.995 -89.962') },
	{ mdl = 'models/props_c17/oildrum001.mdl', pos = Vector('-28.342527 0.124435 -0.009248'), ang = Angle('-0.110 90.000 0.022') },
	{ mdl = 'models/props_lab/reciever01d.mdl', pos = Vector('-1.106484 -3.101328 46.897270'), ang = Angle('0.063 -112.506 -0.062') },
}

local sndBoil = "ambient/machines/deep_boil.wav"
local sndMachine = "ambient/machines/refinery_loop_1.wav"

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

	self.m_sndBoil = CreateSound( self, sndBoil )
	self.m_sndMachine = CreateSound( self, sndMachine )
end

function ENT:OnRemove()
	for k, v in pairs( self.m_tblEnts ) do
		k:Remove()
	end

	if self.m_sndBoil then self.m_sndBoil:Stop() end
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
	if self:GetStillOn() then
		if not self.m_sndBoil:IsPlaying() then
			self.m_sndBoil:SetSoundLevel( 58 )
			self.m_sndBoil:Play()
		end

		if not self.m_sndMachine:IsPlaying() then
			self.m_sndMachine:SetSoundLevel( 58 )
			self.m_sndMachine:Play()
		end
	else
		if self.m_sndBoil:IsPlaying() then
			self.m_sndBoil:Stop()
		end

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

	local data = GAMEMODE.Inv:GetItem( self:GetItemID() or "" )
	if not data or not data.StillVars then return end
	
	--Fluid Amount
	local camPos = self:LocalToWorld( Vector(-8, -6.5, 46.5) )
	local camAng = self:LocalToWorldAngles( Angle(0, 337.5, 90) )
	cam.Start3D2D( camPos, camAng, 0.05 )
		self:DrawBar( 0, -(48 /2), 96, 48, Color(255, 50, 50, 255), self:GetFluidAmount(), self.MaxFluid )
		
		surface.SetFont( "DermaLarge" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( 5, -16 )
		surface.DrawText( "Fluid" )
	cam.End3D2D()

	--ID
	local camPos = self:LocalToWorld( Vector(9.9, -4.8, 46.5) )
	local camAng = self:LocalToWorldAngles( Angle(0, 90, 90) )
	cam.Start3D2D( camPos, camAng, 0.05 )
		self:DrawBar( 0, -(48 /2), 96, 48, Color(255, 50, 50, 255), self:GetProgress(), self.MaxProgress )
		
		surface.SetFont( "Trebuchet18" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( 5, -19 )
		surface.DrawText( data.Name.. " ->" )
		surface.SetTextPos( 5, 0 )
		surface.DrawText( data.StillVars.GiveItem )
	cam.End3D2D()
end