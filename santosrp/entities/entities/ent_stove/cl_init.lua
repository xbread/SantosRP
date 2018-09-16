--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local colBlack = Color( 0, 0, 0, 255 )
local childEnts = {
	{ mdl = 'models/hunter/plates/plate1x1.mdl', mat = "phoenix_storms/dome", pos = Vector('-19.799755 9.856929 27.685066'), ang = Angle('-89.922 -8.144 8.166') },
	{ mdl = 'models/hunter/plates/plate1x1.mdl', mat = "phoenix_storms/dome", pos = Vector('-19.794846 -7.213078 27.681782'), ang = Angle('-89.922 -8.144 8.166') },
}

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
		ent:SetMaterial( v.mat )
		ent:SetParent( self )
		self.m_tblEnts[ent] = k
	end

	self.m_sndGasFlow = CreateSound( self, burnerGasLoop )
	self.m_sndBurnerFlame = CreateSound( self, burnerFireLoop )

	self.m_intLastBurnerThink = 0
end

function ENT:OnRemove()
	for k, v in pairs( self.m_tblEnts ) do
		k:Remove()
	end

	if self.m_sndGasFlow then self.m_sndGasFlow:Stop() end
	if self.m_sndBurnerFlame then self.m_sndBurnerFlame:Stop() end
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
	if self:GetLitBurnerNum() > 0 then
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
end

function ENT:ThinkBurnerFX()
	self.m_intLastBurnerThink = CurTime() +0.05

	for i = 1, 4 do
		if not self:GetBurnerOn( i ) then continue end

		if not self["GetHasPot".. i]( self ) then
			local effectData = EffectData()
			effectData:SetOrigin( self:LocalToWorld(self.BurnerPos[i].fxPos) )
			util.Effect( "burnerFx", effectData )
		else
			local effectData = EffectData()
			effectData:SetOrigin( self:LocalToWorld(self.BurnerPos[i].fxPos) )
			util.Effect( "burnerPotFx", effectData )
		end
	end
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
	local camPos = self:LocalToWorld( Vector(-18.2, -30.5, 50.25) )
	local camAng = self:LocalToWorldAngles( Angle(0, 90, 90) )
	cam.Start3D2D( camPos, camAng, 0.05 )
		self:DrawBar( 0, -(32 /2), 675, 32, Color(255, 50, 50, 255), self:GetBurnerFuel(), self.BurnerMaxFuel )
		
		local str = tostring(math.ceil((self:GetBurnerFuel() /self.BurnerMaxFuel) *100)).. "%"
			draw.SimpleText(
				"(".. str.. ") Burner Fuel",
				"DermaLarge",
				675 /2,
				(32 /2),
				color_white,
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_BOTTOM
			)
	cam.End3D2D()

	--Oven Info
	local itemData = GAMEMODE.Inv:GetItem( self:GetOvenID() or "" )

	camPos = self:LocalToWorld( Vector(-18.2, -30.5, 48.5) )
	camAng = self:LocalToWorldAngles( Angle(0, 90, 90) )
	cam.Start3D2D( camPos, camAng, 0.05 )
		if itemData and itemData.Cooking_OvenVars then
			self:DrawBar( 0, -(32 /2), 675, 32, Color(255, 50, 50, 255), self:GetOvenProgress(), itemData.Cooking_OvenVars.OvenProgress )

			local str = tostring(math.ceil((self:GetOvenProgress() /itemData.Cooking_OvenVars.OvenProgress) *100)).. "%"
			draw.SimpleText(
				"(".. str.. ") Oven: ".. self:GetOvenID().. "->".. itemData.Cooking_OvenVars.GiveItem,
				"DermaLarge",
				675 /2,
				(32 /2),
				color_white,
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_BOTTOM
			)
		else
			self:DrawBar( 0, -(32 /2), 675, 32, Color(255, 50, 50, 255), 0, 1 )
		end
	cam.End3D2D()
end