--[[
	Name: sh_lightrain.lua
	For: TalosLife
	By: TalosLife
]]--

local vector_up, vector_down = Vector( 0, 0, 1 ), Vector( 0, 0, -1 )

local Rain = {}
Rain.ID = "light_rain"
Rain.Name = "Light Rain"
Rain.m_tblThunderTime = { min = 30, max = 75 }
Rain.m_bHasLightning = false

Rain.m_intIndoorFadeTime = 3
Rain.m_intVolumeOutside = 0.125
Rain.m_intVolumeInside = 0.05
Rain.m_intPitchOutside = 100
Rain.m_intPitchInside = 60
Rain.m_convRainAmount = GetConVar( "srp_max_rain_particles" ) or CreateClientConVar( "srp_max_rain_particles", "0", true, false )
Rain.m_convVolume = GetConVar( "srp_rain_volume" ) or CreateClientConVar( "srp_rain_volume", "0", true, false )
Rain.m_convThunderVolume = GetConVar( "srp_rain_thunder_volume" ) or CreateClientConVar( "srp_rain_thunder_volume", "0", true, false )
Rain.m_intPartUpdateRate = 0.2

Rain.m_tblTraceVectors = {
	Vector( 9.352347, 11.727472, 0 ),
	Vector( -3.337814, 14.623919, 0 ),
	Vector( -13.514533, 6.508256, 0 ),
	Vector( -13.514533, -6.508256, 0 ),
	Vector( -3.337814, -14.623919, 0 ),
	Vector( 9.352347, -11.727472, 0 ),
	Vector( 15, 0, 0 ),
}
Rain.m_tblSounds = {
	Lightning = {
		"taloslife/weather/lightning_strike_1.mp3",
		"taloslife/weather/lightning_strike_2.mp3",
		"taloslife/weather/lightning_strike_3.mp3",
		"taloslife/weather/lightning_strike_4.mp3",
	},
	Thunder = {
		[1] = {	--Close
			"taloslife/weather/thunder_close01.mp3",
			"taloslife/weather/thunder_close02.mp3",
			"taloslife/weather/thunder_close03.mp3",
			"taloslife/weather/thunder_close04.mp3",
		}, 
		[2] = {	--Kinda Close
			"taloslife/weather/thunder_1.mp3",
			"taloslife/weather/thunder_2.mp3",
			"taloslife/weather/thunder_3.mp3",
			"taloslife/weather/thunder_distant01.mp3",
			"taloslife/weather/thunder_distant02.mp3",
			"taloslife/weather/thunder_distant03.mp3",
		}, 
		[3] = {	--Distant
			"taloslife/weather/thunder_far_away_1.mp3",
			"taloslife/weather/thunder_far_away_2.mp3",
		}, 
	},
	RainLoop = "taloslife/weather/crucial_waterrain_light_loop.wav",
}

function Rain:Start( intStartTime, intDuration, intTimeOffset )
	self.m_intStartTime = intStartTime
	self.m_intStartOffset = intTimeOffset or 0
	self.m_intDuration = intDuration
	self.m_intOutdoorFadeStart = nil
	self.m_intIndoorFadeStart = nil

	--these were random, but lets hard code them so we don't have to network it lol
	self.m_intFadeInRainTime = 25 --math.random( self.m_tblRainTime.min, self.m_tblRainTime.max )
	self.m_intFadeOutRainTime = 30 --math.random( self.m_tblRainTime.min, self.m_tblRainTime.max )
	self.m_intFadeInTime = 25 +self.m_intFadeInRainTime --math.random( self.m_tblFadeInTime.min, self.m_tblFadeInTime.max ) +self.m_intFadeInRainTime
	self.m_intFadeOutTime = 30 +self.m_intFadeOutRainTime --math.random( self.m_tblFadeOutTime.min, self.m_tblFadeOutTime.max ) +self.m_intFadeOutRainTime

	self.m_intDurationToFadeOut = intDuration -self.m_intFadeOutTime

	--reset some stuff
	self.m_bFadingIn = false
	self.m_bFadingOut = false
	self.m_intRainScaler = 0
	self.m_intStopTime = nil
	self.m_intStartRainFadeTime = nil
	self.m_intFadeOffset = nil
	self.m_intFadeInOffset = nil

	self.m_angAngleUp = Angle( -90, 0, 0 )

	if CLIENT then
		self.m_intRainMat = Material( "taloslife/weather/rain_bunch" )
		self.m_tblRainParts	= {}

		self.m_pEmitter = ParticleEmitter( Vector(0) )
		self.m_pEmitter3D = ParticleEmitter( Vector(0), true )
	
		self.m_pRainSound = CreateSound( LocalPlayer(), self.m_tblSounds.RainLoop )
	end
end

function Rain:Stop()
	if CLIENT then
		self.m_pRainSound:Stop()
	end
end

local indoorsMask = bit.bor( MASK_SOLID, MASK_SPLITAREAPORTAL, MASK_SHOT_PORTAL, MASK_BLOCKLOS )
function Rain:Indoors( pPlayer )
	local pl = SERVER and pPlayer or LocalPlayer()
	if pl:InVehicle() and not pl:GetVehicle():GetThirdPersonMode() then return true end

	local bIndoors, plyPos, tr = 0, (SERVER and pPlayer or LocalPlayer()):GetPos(), nil
	local zPos = GAMEMODE.Config.Weather_SkyZPos
	if not zPos then
		zPos = util.TraceLine{
			start = plyPos, 
			endpos = plyPos +(vector_up *1500),
			filter = LocalPlayer()
		}

		zPos = zPos.HitSky and zPos.HitPos.z or (plyPos +Vector(0, 0, 1500)).z
	end
	
	local temp = Vector( plyPos.x, plyPos.y, zPos )
	local dist = vector_up *(zPos -plyPos.z -60)
	local trFilter = { pl, pl:GetVehicle(), IsValid(pl:GetVehicle()) and pl:GetVehicle():GetParent() }
	for _, vec in pairs( self.m_tblTraceVectors ) do
		tr = util.TraceLine{
			start = temp +vec, 
			endpos = temp +vec -dist,
			filter = trFilter,
			mask = indoorsMask
		}

		if tr.Hit then
			bIndoors = bIndoors +1
		end
	end

	return bIndoors >= 5
end

function Rain:Think()
	if not self.m_pRainSound then return end
	
	local time = CurTime() +self.m_intStartOffset
	if self.m_bFadingOut or time > self.m_intStartTime +self.m_intDurationToFadeOut then
		if not self.m_intStopTime then
			self:FadeOut()
		end
		
		self:UpdateFadeOut()
	elseif time <= self.m_intStartTime +self.m_intFadeInTime then
		if not self.m_bFadingIn then
			self:FadeIn()
		end
		
		self:UpdateFadeIn()
	else
		self.m_bFadingIn = false
		self.m_bFadingOut = false

		if CLIENT then
			self:UpdateRainFX( 1 )
			self:UpdateRainSounds( 1 )
			self:PlayThunderFX()
		end
	end
end

function Rain:FadeIn()
	self.m_bFadingIn = true

	if self.m_intStartOffset > self.m_intFadeInRainTime then
		self.m_intFadeInOffset = self.m_intStartOffset -self.m_intFadeInRainTime
	end
end

function Rain:FadeOut()
	self.m_bFadingOut = true
	self.m_intStopTime = CurTime()

	if self.m_intStartOffset > self.m_intDurationToFadeOut then
		self.m_intFadeOffset = self.m_intStartOffset -self.m_intDurationToFadeOut
	end
end

function Rain:UpdateFadeIn()
	local time = CurTime() +(self.m_intFadeInOffset or 0)
	if CLIENT then
		self:PlayThunderFX()
	end
	
	if time +self.m_intStartOffset <= self.m_intStartTime +self.m_intFadeInRainTime then
		return
	end

	if not self.m_intStartRainFadeTime then
		self.m_intStartRainFadeTime = CurTime()
	end

	if CLIENT then
		local rainScaler = (time -self.m_intStartRainFadeTime) /self.m_intFadeInRainTime
		self:UpdateRainFX( Lerp(rainScaler, 0, 1) )
		self:UpdateRainSounds( Lerp(rainScaler, 0, 1) )
	end
end

function Rain:UpdateFadeOut()
	local time = CurTime() +(self.m_intFadeOffset or 0)

	if CLIENT then
		self:PlayThunderFX()

		if time < self.m_intStopTime +self.m_intFadeOutRainTime then --During rain particle fade out
			local rainScaler = (time -self.m_intStopTime) /self.m_intFadeOutRainTime
			self:UpdateRainFX( Lerp(rainScaler, 1, 0) )
			self:UpdateRainSounds( Lerp(rainScaler, 1, 0) )

			return
		end

		if self.m_pRainSound:IsPlaying() then
			self.m_pRainSound:FadeOut( 1 )
		end
	elseif SERVER then
		if time > self.m_intStopTime +self.m_intFadeOutTime then
			GAMEMODE.Weather:StopType( self.ID )
		end
	end
end

--FX
if CLIENT then
	function Rain:PlayThunderFX()
		if not self.m_intLastThunderTime then
			self.m_intLastThunderTime = math.random( self.m_tblThunderTime.min, self.m_tblThunderTime.max ) +CurTime()
			return
		end

		if CurTime() >= self.m_intLastThunderTime then
			if self.m_bHasLightning and math.random( 1, 2 ) == 1 and (not self.m_bFadingIn and not self.m_bFadingOut) then
				local volume = math.Clamp( math.Rand(0.4, 1) *(self.m_convThunderVolume:GetInt() /100), 0, 1 )
				sound.Play( table.Random(self.m_tblSounds.Lightning), LocalPlayer():GetPos(), 140, math.random(70, 120), volume )
				self.m_intLastLightFX = CurTime()
				return
			end

			local pos = LocalPlayer():GetPos() +Vector( math.random(-100, 100), math.random(-100, 100), 50 )
			local volume = math.Clamp( (self.m_intRainScaler <= 0.3 and math.Rand(0.6, 0.8) or math.Rand(0.8, 0.9)) *(self.m_convThunderVolume:GetInt() /100), 0, 1 )
			sound.Play( table.Random(self.m_tblSounds.Thunder[3]), pos, 120, math.random(70, 120), volume )

			self.m_intLastThunderTime = nil
		end
	end

	function Rain:UpdateRainFX( intRainScaler )
		if CurTime() < (self.m_intLastPartUpdate or 0) +self.m_intPartUpdateRate then
			return
		end
		self.m_intLastPartUpdate = CurTime()

		--rain stuff
		self:AddRainParts( math.Round(self.m_convRainAmount:GetInt() *intRainScaler))
		self.m_intRainScaler = intRainScaler
	end

	function Rain:UpdateRainSounds( intScaler )
		if not self.m_intCurVolume then
			self.m_intCurVolume = self.m_intVolumeOutside
			self.m_intCurPitch = self.m_intPitchOutside
		end

		if self:Indoors() then
			if not self.m_intIndoorFadeStart then
				self.m_intIndoorFadeStart = CurTime()
				self.m_intOutdoorFadeStart = nil
			end

			local fadeScaler = math.min( (CurTime() -self.m_intIndoorFadeStart) /self.m_intIndoorFadeTime, 1 )
			self.m_intCurVolume = Lerp( fadeScaler, self.m_intCurVolume, self.m_intVolumeInside )
			self.m_intCurPitch = Lerp( fadeScaler, self.m_intCurPitch, self.m_intPitchInside )
		else
			if not self.m_intOutdoorFadeStart then
				self.m_intOutdoorFadeStart = CurTime()
				self.m_intIndoorFadeStart = nil
			end

			local fadeScaler = math.min( (CurTime() -self.m_intOutdoorFadeStart) /self.m_intIndoorFadeTime, 1 )
			self.m_intCurVolume = Lerp( fadeScaler, self.m_intCurVolume, self.m_intVolumeOutside )
			self.m_intCurPitch = Lerp( fadeScaler, self.m_intCurPitch, self.m_intPitchOutside )
		end

		self.m_intCurVolume = self.m_intCurVolume *intScaler

		if not self.m_pRainSound:IsPlaying() then
			self.m_pRainSound:PlayEx( 0, self.m_intVolumeOutside *(self.m_convVolume:GetInt() /100) )
		else
			self.m_pRainSound:ChangeVolume( self.m_intCurVolume *(self.m_convVolume:GetInt() /100), 0 )
			self.m_pRainSound:ChangePitch( self.m_intCurPitch, 0 )
		end
	end
elseif SERVER then
	function Rain:GamemodeUpdateMapLighting( strPattern, intLightIndex )
		local bTime = GAMEMODE.DayNight:GetTime() < 795
		local targetLightIndex = bTime and math.min(intLightIndex, 500) or math.max(1090, intLightIndex)
		local time = CurTime()

		if time <= self.m_intStartTime +self.m_intFadeInTime then
			if self.m_intStartRainFadeTime then
				local lightScalar = (CurTime() -self.m_intStartRainFadeTime) /self.m_intFadeInRainTime
				local diff = Lerp( lightScalar, intLightIndex, targetLightIndex )
				return GAMEMODE.DayNight:GetLightTable()[math.ceil(diff)].Pattern
			else
				return strPattern
			end
		elseif time > self.m_intStartTime +self.m_intDurationToFadeOut then
			if self.m_intStopTime then
				local lightScalar = (CurTime() -self.m_intStopTime) /self.m_intFadeOutRainTime
				local diff = Lerp( lightScalar, targetLightIndex, intLightIndex )
				return GAMEMODE.DayNight:GetLightTable()[math.ceil(diff)].Pattern
			else
				return strPattern
			end
		else
			return GAMEMODE.DayNight:GetLightTable()[targetLightIndex].Pattern
		end
	end

	function Rain:GamemodeOnSkyboxUpdate( tblTopColor, tblBottomColor, tblSunColor, intDuskAmount )
		local time = CurTime()
		local targetScale = 0.225

		if time <= self.m_intStartTime +self.m_intFadeInTime then
			if self.m_intStartRainFadeTime then
				local lightScalar = (CurTime() -self.m_intStartRainFadeTime) /self.m_intFadeInRainTime
				local diff = Lerp( lightScalar, 1, targetScale )
				
				return {
						r = tblTopColor.r *diff,
						g = tblTopColor.g *diff,
						b = tblTopColor.b *diff,
					},
					{
						r = tblBottomColor.r *diff,
						g = tblBottomColor.g *diff,
						b = tblBottomColor.b *diff,
					},
					tblSunColor,
					intDuskAmount *diff
			else
				return tblTopColor, tblBottomColor, tblSunColor, intDuskAmount
			end
		elseif time > self.m_intStartTime +self.m_intDurationToFadeOut then
			if self.m_intStopTime then
				local lightScalar = (CurTime() -self.m_intStopTime) /self.m_intFadeOutRainTime
				local diff = Lerp( lightScalar, targetScale, 1 )
				
				return {
						r = tblTopColor.r *diff,
						g = tblTopColor.g *diff,
						b = tblTopColor.b *diff,
					},
					{
						r = tblBottomColor.r *diff,
						g = tblBottomColor.g *diff,
						b = tblBottomColor.b *diff,
					},
					tblSunColor,
					intDuskAmount *diff
			else
				return tblTopColor, tblBottomColor, tblSunColor, intDuskAmount
			end
		else
			return {
					r = tblTopColor.r *targetScale,
					g = tblTopColor.g *targetScale,
					b = tblTopColor.b *targetScale,
				},
				{
					r = tblBottomColor.r *targetScale,
					g = tblBottomColor.g *targetScale,
					b = tblBottomColor.b *targetScale,
				},
				tblSunColor,
				intDuskAmount *targetScale
		end
	end
end

--Render stuff
if CLIENT then
	function Rain:AddRainParts( intAmount )
		local zPos = GAMEMODE.Config.Weather_SkyZPos
		if not zPos then
			local vecPlayerPos = LocalPlayer():GetPos()
			zPos = util.TraceLine{
				start = vecPlayerPos, 
				endpos = vecPlayerPos +(vector_up *1500),
				filter = LocalPlayer()
			}

			zPos = zPos.HitSky and zPos.HitPos.z or (vecPlayerPos +Vector(0, 0, 1500)).z
		end
		
		local time = CurTime()
		for i = 1, intAmount do
			table.insert( self.m_tblRainParts, {
				relpos = Vector( math.Rand(-250, 250), math.Rand(-250, 250), zPos ),
				vel = Vector( 0, 0, math.Rand(1024, 1500) ),
				start = time
			} )
		end
	end

	local sw, sh = ScrW(), ScrH()
	local time, ftime, tr, temp
	local trMask = bit.bor( MASK_WATER, MASK_SOLID )
	local rainColor = Color( 200, 200, 255, 255 )
	local plyPos, faceAng
	local abs, fnTrace, fnQuad = math.abs, util.TraceLine, render.DrawQuadEasy
	function Rain:UpdateRenderRain()
		local time, ftime, tr, temp, tempScreen = CurTime(), FrameTime(), nil, Vector( 0, 0, 0 ), nil
		local plyPos, faceAng = LocalPlayer():GetPos(), Angle(0, EyeAngles().y, 0):Forward() *-1
		plyPos = plyPos +(faceAng *-200)

		render.SetMaterial( self.m_intRainMat )
		render.SuppressEngineLighting( true )
		render.OverrideAlphaWriteEnable( true, false )
			for k, v in pairs( self.m_tblRainParts ) do
				if time >= v.start +6 then
					self.m_tblRainParts[k] = nil
					continue
				end

				v.relpos.z = v.relpos.z -(v.vel.z *ftime)
				temp.x = plyPos.x +v.relpos.x
				temp.y = plyPos.y +v.relpos.y
				temp.z = v.relpos.z

				if abs( temp.z -plyPos.z ) > 1024 then continue end
				tempScreen = temp:ToScreen()
				tr = fnTrace{ start = temp, endpos = temp +(vector_down *64), mask = trMask }
				if tr and tr.Hit then
					self.m_tblRainParts[k] = nil
					if tempScreen.x > sw or tempScreen.x <= 0 then continue end
					if tempScreen.y > sh or tempScreen.y <= 0 then continue end		
					fnQuad(
						tr.HitPos +tr.HitNormal *32,
						faceAng,
						20, 36,
						rainColor,
						180
					)

					if k % 2 == 0 then
						self:FX_RainHit( tr.HitPos, tr.MatType == MAT_SLOSH )
					end
				else
					if tempScreen.x > sw or tempScreen.x <= 0 then continue end
					if tempScreen.y > sh or tempScreen.y <= 0 then continue end
					fnQuad(
						temp,
						faceAng,
						20, 36,
						rainColor,
						180
					)
				end
			end
		render.OverrideAlphaWriteEnable( false )
		render.SuppressEngineLighting( false )
	end

	function Rain:FX_RainHit( vecHitPos, bHitWater )
		if bHitWater then
			bHitWater = self.m_pEmitter3D:Add( "taloslife/weather/warp_ripple", vecHitPos )
			bHitWater:SetColor( 255, 255, 255, 255 )
			bHitWater:SetDieTime( 0.6 )
			bHitWater:SetStartSize( math.Rand(4, 8) )
			bHitWater:SetEndSize( 0 )
			bHitWater:SetAngles( self.m_angAngleUp )
			return
		end

		bHitWater = self.m_pEmitter:Add( "taloslife/weather/warp_ripple", vecHitPos )
		bHitWater:SetColor( 255, 255, 255, 255 )
		bHitWater:SetDieTime( 0.15 )
		bHitWater:SetStartSize( math.Rand(2, 3) )
		bHitWater:SetEndSize( 1 )
		bHitWater = self.m_pEmitter:Add( "particle/water/waterdrop_001a", vecHitPos )
		bHitWater:SetColor( 255, 255, 255, 255 )
		bHitWater:SetDieTime( 0.15 )
		bHitWater:SetStartSize( math.Rand(0.25, 0.5) )
		bHitWater:SetEndSize( 0 )
	end

	function Rain:RenderScreenspaceEffects()
		if self.m_intLastLightFX and not self:Indoors() and GAMEMODE.Config.LightSensitiveMode:GetInt() == 0 then
			local time = CurTime()

			if time <= (self.m_intLastLightFX +0.2) then
				local scaler = Lerp((time -self.m_intLastLightFX) /0.2, 0.75, 1)
				DrawBloom( scaler, math.Rand(1.75, 2.75), 9, 9, 2, 1, 0.1, 0.1, 0.1 )
				DrawColorModify{
					["$pp_colour_addr"] = 0,
					["$pp_colour_addg"] = 0,
					["$pp_colour_addb"] = 0.02,
					["$pp_colour_brightness"] = Lerp((time -self.m_intLastLightFX) /0.2, 0.33, 0),
					["$pp_colour_contrast"] = 1,
					["$pp_colour_colour"] = Lerp((time -self.m_intLastLightFX) /0.2, 0.2, 1),
					["$pp_colour_mulr"] = 0,
					["$pp_colour_mulg"] = 0,
					["$pp_colour_mulb"] = 0.02
				}
			else
				self.m_intLastLightFX = nil
			end
		else
			--[[DrawColorModify{
				["$pp_colour_addr"] = 0,
				["$pp_colour_addg"] = 0,
				["$pp_colour_addb"] = 0,
				["$pp_colour_brightness"] = 0,
				["$pp_colour_contrast"] = Lerp( self.m_intRainScaler, 1, 0.95 ),
				["$pp_colour_colour"] = Lerp( self.m_intRainScaler, 1, 0.98 ),
				["$pp_colour_mulr"] = 0,
				["$pp_colour_mulg"] = 0,
				["$pp_colour_mulb"] = 0
			}]]--
		end
	end

	function Rain:PostDrawTranslucentRenderables()
		self:UpdateRenderRain()
	end

	function Rain:GamemodeSetupWorldFog( tblFogData )
		tblFogData.Color = Color(
			tblFogData.Color.r +Lerp( self.m_intRainScaler, 0, 3.5 ),
			tblFogData.Color.g +Lerp( self.m_intRainScaler, 0, 3.5 ),
			tblFogData.Color.b +Lerp( self.m_intRainScaler, 0, 3.5 )
		)
		tblFogData.Density = math.min( 0.9, Lerp(self.m_intRainScaler, 0, 0.075) +tblFogData.Density )
	end
end

GM.Weather:RegisterType( Rain )