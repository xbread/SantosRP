--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local colBlack = Color( 0, 0, 0, 255 )
local childEnts = {
	{ mdl = 'models/props_junk/garbage_metalcan002a.mdl', pos = Vector('-11.745893 -6.824680 38.397804'), ang = Angle('-0.000 -157.505 0.000') },
	{ mdl = 'models/props_junk/garbage_plasticbottle002a.mdl', pos = Vector('-3.906046 32.695015 11.496689'), ang = Angle('-90.000 -129.672 0.000') },
	{ mdl = 'models/props_junk/garbage_metalcan002a.mdl', pos = Vector('18.091637 41.620152 38.017441'), ang = Angle('1.637 142.152 -0.890') },
	{ mdl = 'models/gibs/metal_gib1.mdl', pos = Vector('-11.935516 -2.229691 42.089348'), ang = Angle('-0.000 0.000 -90.000') },
	{ mdl = 'models/props_junk/glassjug01.mdl', pos = Vector('0.189270 28.648115 54.962952'), ang = Angle('-0.000 22.495 -180.000') },
	{ mdl = 'models/props_junk/garbage_carboard002a.mdl', pos = Vector('4.651484 20.323162 35.199402'), ang = Angle('-0.000 14.084 0.000') },
	{ mdl = 'models/props_junk/garbage_bag001a.mdl', pos = Vector('15.717618 -7.988873 39.388092'), ang = Angle('-0.000 -67.505 0.000') },
	{ mdl = 'models/props_lab/reciever01d.mdl', pos = Vector('0.376644 28.615442 37.020805'), ang = Angle('-0.000 -157.505 0.000') },
	{ mdl = 'models/props_lab/jar01a.mdl', pos = Vector('-9.875704 -40.446808 42.048050'), ang = Angle('-0.000 -116.071 0.000') },
	{ mdl = 'models/gibs/metal_gib1.mdl', pos = Vector('-11.936415 -11.599136 42.089348'), ang = Angle('-0.000 179.995 -90.000') },
	{ mdl = 'models/props_junk/garbage_milkcarton001a.mdl', pos = Vector('9.644963 -22.240061 42.953514'), ang = Angle('-0.000 -175.682 0.000') },
	{ mdl = 'models/gibs/metal_gib1.mdl', pos = Vector('-7.175930 -6.640121 42.089348'), ang = Angle('-0.000 -90.000 -90.000') },
	{ mdl = 'models/props_junk/glassbottle01a_chunk01a.mdl', pos = Vector('4.621895 -4.375931 36.173195'), ang = Angle('-17.814 68.461 97.119') },
	{ mdl = 'models/props_lab/tpplug.mdl', pos = Vector('0.341858 28.658049 35.099480'), ang = Angle('-90.000 -157.500 0.000') },
	{ mdl = 'models/items/car_battery01.mdl', pos = Vector('-9.636549 -33.888420 15.486183'), ang = Angle('-0.000 94.351 0.000') },
	{ mdl = 'models/props_junk/propanecanister001a.mdl', pos = Vector('-12.839035 -20.848013 19.813965'), ang = Angle('-0.000 112.489 0.000') },
	{ mdl = 'models/props_lab/jar01b.mdl', pos = Vector('-6.724887 -32.190517 39.933441'), ang = Angle('-0.000 -42.264 0.000') },
	{ mdl = 'models/props_junk/garbage_metalcan002a.mdl', pos = Vector('19.527611 33.342365 37.705750'), ang = Angle('-89.072 -124.788 170.958') },
	{ mdl = 'models/props_lab/reciever01d.mdl', pos = Vector('-18.022181 -27.645733 33.152489'), ang = Angle('-0.000 179.995 0.000') },
	{ mdl = 'models/props_junk/metalgascan.mdl', pos = Vector('-4.186302 4.857091 14.155884'), ang = Angle('-89.857 7.174 -15.079') },
	{ mdl = 'models/gibs/metal_gib5.mdl', pos = Vector('-15.736785 -14.952654 35.229675'), ang = Angle('-0.000 134.995 0.000') },
	{ mdl = 'models/props_junk/gascan001a.mdl', pos = Vector('-5.095324 3.955139 22.619293'), ang = Angle('89.703 16.617 -173.661') },
	{ mdl = 'models/props_lab/reciever01d.mdl', pos = Vector('-18.021088 -16.230816 33.152489'), ang = Angle('-0.000 179.995 0.000') },
	{ mdl = 'models/props_junk/garbage_plasticbottle002a.mdl', pos = Vector('0.498408 -40.801197 43.988304'), ang = Angle('-0.000 127.068 0.000') },
	{ mdl = 'models/props_interiors/pot02a.mdl', pos = Vector('15.917537 12.051575 38.055901'), ang = Angle('0.862 162.642 0.225') },
	{ mdl = 'models/props_c17/metalpot001a.mdl', pos = Vector('9.894333 25.946440 16.488853'), ang = Angle('-0.000 118.867 0.000') },
	{ mdl = 'models/props_junk/garbage_plasticbottle001a.mdl', pos = Vector('13.535419 -36.739395 45.459244'), ang = Angle('-0.104 22.819 0.071') },
	{ mdl = 'models/props_junk/glassbottle01a_chunk02a.mdl', pos = Vector('1.314281 -8.164310 36.584801'), ang = Angle('22.500 -156.094 90.000') },
	{ mdl = 'models/props_junk/garbage_plasticbottle003a.mdl', pos = Vector('1.467742 -30.891010 45.636337'), ang = Angle('-0.000 87.094 0.000') },
	{ mdl = 'models/props_junk/garbage_plasticbottle001a.mdl', pos = Vector('-14.074349 22.834478 20.300209'), ang = Angle('-0.747 161.268 0.692') },
	{ mdl = 'models/props_lab/jar01a.mdl', pos = Vector('-13.804393 36.188580 17.002899'), ang = Angle('-0.000 -135.005 0.000') },
	{ mdl = 'models/props_junk/plasticbucket001a.mdl', pos = Vector('8.178818 -24.360891 15.978844'), ang = Angle('-0.000 -112.506 0.000') },
	{ mdl = 'models/props_wasteland/gear02.mdl', pos = Vector('-11.816809 -6.739529 37.025360'), ang = Angle('-0.000 112.489 -90.000') },
	{ mdl = 'models/gibs/metal_gib1.mdl', pos = Vector('-16.425442 -6.639234 42.089348'), ang = Angle('-0.000 89.995 -90.000') },
}

--Blender
local blenderSound = "ambient/machines/spin_loop.wav"

--Burner
local burnerGasLoop = "ambient/machines/gas_loop_1.wav"
local burnerFireLoop = "ambient/fire/fire_small_loop1.wav"

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

	self.m_sndGasFlow = CreateSound( self, burnerGasLoop )
	self.m_sndBurnerFlame = CreateSound( self, burnerFireLoop )
	self.m_sndBlender = CreateSound( self, blenderSound )

	self.m_intLastBurnerThink = 0
end

function ENT:OnRemove()
	for k, v in pairs( self.m_tblEnts ) do
		k:Remove()
	end

	if self.m_sndGasFlow then self.m_sndGasFlow:Stop() end
	if self.m_sndBurnerFlame then self.m_sndBurnerFlame:Stop() end
	if self.m_sndBlender then self.m_sndBlender:Stop() end
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
	if self:GetBurnerOn() then
		if not self.m_sndGasFlow:IsPlaying() then
			self.m_sndGasFlow:SetSoundLevel( 50 )
			self.m_sndGasFlow:Play()
		end

		if not self.m_sndBurnerFlame:IsPlaying() then
			self.m_sndBurnerFlame:SetSoundLevel( 50 )
			self.m_sndBurnerFlame:Play()
		end
	else
		if self.m_sndGasFlow:IsPlaying() then
			self.m_sndGasFlow:Stop()
		end

		if self.m_sndBurnerFlame:IsPlaying() then
			self.m_sndBurnerFlame:Stop()
		end
	end

	if self:GetBlenderOn() then
		if not self.m_sndBlender:IsPlaying() then
			self.m_sndBlender:SetSoundLevel( 58 )
			self.m_sndBlender:Play()
		end
	else
		if self.m_sndBlender:IsPlaying() then
			self.m_sndBlender:Stop()
		end
	end
end

function ENT:ThinkBurnerFX()
	self.m_intLastBurnerThink = CurTime() +0.05
	if not self:GetBurnerOn() then return end
	
	local effectData = EffectData()
	effectData:SetOrigin( self:LocalToWorld(Vector(-11.75, -6.75, 43)) )
	util.Effect( "burnerFx", effectData )
end

function ENT:Think()
	self:ThinkSounds()

	if CurTime() > self.m_intLastBurnerThink then
		self:ThinkBurnerFX()
	end
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

	--Fuel/Burner Info
	local camPos = self:LocalToWorld( Vector(-23.966, -22.6, 32.7) )
	local camAng = self:LocalToWorldAngles( Angle(0, 270, 90) )
	cam.Start3D2D( camPos, camAng, 0.05 )
		self:DrawBar( 0, -(48 /2), 96, 48, Color(255, 50, 50, 255), self:GetBurnerFuel(), self.BurnerMaxFuel )
		
		surface.SetFont( "DermaLarge" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( 5, -16 )
		surface.DrawText( "Fuel" )
	cam.End3D2D()

	--Blender Info
	local itemData = GAMEMODE.Inv:GetItem( self:GetBlendingID() or "" )

	camPos = self:LocalToWorld( Vector(-7, 31.05, 36.65) )
	camAng = self:LocalToWorldAngles( Angle(0, 292.5, 90) )
	cam.Start3D2D( camPos, camAng, 0.05 )
		if itemData and itemData.DrugLab_BlenderVars then
			self:DrawBar( 0, -(48 /2), 96, 48, Color(255, 50, 50, 255), self:GetBlenderProgress(), itemData.DrugLab_BlenderVars.BlendProgress )
			surface.SetFont( "DermaLarge" )
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetTextPos( 5, -16 )
			surface.DrawText( tostring(math.ceil((self:GetBlenderProgress() /itemData.DrugLab_BlenderVars.BlendProgress) *100)).. "%" )
		else
			self:DrawBar( 0, -(48 /2), 96, 48, Color(255, 50, 50, 255), 0, 1 )
		end
	cam.End3D2D()

	if itemData and itemData.DrugLab_BlenderVars then
		camPos = self:LocalToWorld( Vector(0, 28, 58) )
		camAng = self:LocalToWorldAngles( Angle(0, 300, 90) )

		cam.Start3D2D( camPos, camAng, 0.05 )
			draw.SimpleText(
				self:GetBlendingID().. "->".. itemData.DrugLab_BlenderVars.GiveItem,
				"DermaLarge",
				0,
				0,
				color_white,
				TEXT_ALIGN_CENTER
			)
		cam.End3D2D()
	end
end