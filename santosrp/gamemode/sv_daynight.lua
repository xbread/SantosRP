--[[
	Name: sv_daynight.lua
	
		 (Heavily modified from TehBigA's work <3)
]]--

GM.DayNight = (GAMEMODE or GM).DayNight or {}
GM.DayNight.m_intTimeScale = 0.5
GM.DayNight.m_tblMapEnts = (GAMEMODE or GM).DayNight.m_tblMapEnts or {}
GM.DayNight.m_tblNightLights = (GAMEMODE or GM).DayNight.m_tblNightLights or {}
GM.DayNight.m_tblTimeData = {
	Length = 1440,
	Start = 300,
	End = 1290,

	Dawn = 390,
	Dawn_Start = 300,
	Dawn_End = 450,

	Noon = 720,

	Dusk = 1260,
	Dusk_Start = 1200,
	Dusk_End = 1290,

	Low = string.byte( "a" ),
	High = string.byte( "z" )
}
GM.DayNight.m_tblSkyboxData = {
	ColorTop = { r = 0.2, g = 0.3, b = 1 },
	ColorBottom = { r = 0.6, g = 0.8, b = 1 },
}
GM.DayNight.m_tblSkyScalars = {
	{ --Night time after midnight
		Compare = function( int ) return int < 300 end,
		Scalar = function( int ) return 0 end
	},
	{ --Dawn start to dawn end (0 to 0.1)
		Compare = function( int ) return int >= 300 and int < 315 end,
		Scalar = function( int ) return ((int -300) /14) *0.1 end
	},
	{ --Dawn start to dawn end (0 to 0.3)
		Compare = function( int ) return int >= 315 and int < 450 end,
		Scalar = function( int ) return (((int -315) /134) *0.2) +0.1 end
	},
	{ --Morning (0.3 to 1)
		Compare = function( int ) return int >= 450 and int < 660 end,
		Scalar = function( int ) return (((int -450) /209) *0.7) +0.3 end
	},
	{ --Mid-day
		Compare = function( int ) return int >= 660 and int < 980 end,
		Scalar = function( int ) return 1 end
	},
	{ --Afternoon (1 to 0.3)
		Compare = function( int ) return int >= 980 and int < 1200 end,
		Scalar = function( int ) return ((((int -1199) /219) *0.7) *-1) +0.3 end
	},
	{ --Dusk start to dusk end (0.3 to 0.1)
		Compare = function( int ) return int >= 1200 and int < 1290 end,
		Scalar = function( int ) return ((((int -1289) /89) *0.2) *-1) +0.1 end
	},
	{ --Dusk start to dusk end (0.1 to 0)
		Compare = function( int ) return int >= 1290 and int < 1305 end,
		Scalar = function( int ) return (((int -1304) /15) *0.1) *-1 end
	},
	{ --Dusk end to midnight
		Compare = function( int ) return int >= 1305 and int < 1440 end,
		Scalar = function( int ) return 0 end
	},
}

function GM.DayNight:InitPostEntity()
	local foundLightEnv, foundSunFX, foundSkyPaint = self:FindMapEntities()
	self.m_bHasNightLights = self:FindNightLights()

	if foundLightEnv then
		self:SetSunFadePattern( string.char(self.m_tblTimeData.Low) )
	end

	if foundSunFX then
		self:SetSunMaterial( "sprites/light_glow02_add_noz.vmt" )
		self:SetSunOverlayMaterial( "sprites/light_glow02_add_noz.vmt" )
	end

	if foundSkyPaint then
		self:SetStarScale( 1 )
		self:SetHDRScale( 0.66 )
		self:SetStarTexture( "skybox/starfield" )
	end

	self.m_intCurMinute = 360
	self.m_intCurDay = 1
	self:BuildLightTable()
end

function GM.DayNight:PlayerInitialSpawn( pPlayer )
	GAMEMODE.Net:SendTimeFullUpdate( pPlayer )
end

function GM.DayNight:FindMapEntities()
	local bFoundLightEnv, bFoundSunFX, bFoundSkyPaint
	for _, ent in pairs( ents.GetAll() ) do
		if ent:GetClass() == "light_environment" then
			self.m_tblMapEnts.Sun = self.m_tblMapEnts.Sun or {}
			table.insert( self.m_tblMapEnts.Sun, ent )
			bFoundLightEnv = true
		elseif ent:GetClass() == "env_sun" then
			self.m_tblMapEnts.SunFX = self.m_tblMapEnts.SunFX or {}
			table.insert( self.m_tblMapEnts.SunFX, ent )
			bFoundSunFX = true
		elseif ent:GetClass() == "env_skypaint" then
			self.m_tblMapEnts.SkyPaint = self.m_tblMapEnts.SkyPaint or {}
			table.insert( self.m_tblMapEnts.SkyPaint, ent )
			ent:SetKeyValue( "drawstars", "1" )
			bFoundSkyPaint = true
		end
	end

	return bFoundLightEnv, bFoundSunFX, bFoundSkyPaint
end

function GM.DayNight:FindNightLights()
	if table.Count( self.m_tblNightLights ) > 0 then return true end
	
	local found = {}
	for _, ent in pairs( ents.GetAll() ) do
		if ent:GetName() == "nightlight1" or ent:GetName() == "nightlight2" then
			table.insert( found, ent )
		end
	end

	self.m_tblNightLights = found

	return table.Count( found ) > 0
end

function GM.DayNight:FindSkyPaintEntity()
	if IsValid( self.m_entSkyPaint ) then return self.m_entSkyPaint end

	for _, ent in pairs( ents.GetAll() ) do
		if ent:GetClass() == "env_skypaint" then
			self.m_tblMapEnts.SkyPaint = self.m_tblMapEnts.SkyPaint or {}
			table.insert( self.m_tblMapEnts.SkyPaint, ent )
			ent:SetKeyValue( "drawstars", "1" )
		end
	end

	self:SetStarScale( 1 )
	self:SetHDRScale( 0.66 )
	self:SetStarTexture( "skybox/starfield" )
end

function GM.DayNight:BuildLightTable()
	self.m_tblLightTable = {}
	
	for i = 1, self.m_tblTimeData.Length do
		local letter = string.char( self.m_tblTimeData.Low )
		local color = Color( 0, 0, 0, 0 )
		
		-- calculate which letter to use in the light pattern.
		if i >= self.m_tblTimeData.Dawn_Start and i < self.m_tblTimeData.Dawn_End then
			local progress = (self.m_tblTimeData.Dawn_End -i) /(self.m_tblTimeData.Dawn_End -self.m_tblTimeData.Dawn_Start)
			local letter_progress = 1 -math.EaseInOut( progress, 0, 1 )
						
			letter = ( (self.m_tblTimeData.High -self.m_tblTimeData.Low) *letter_progress ) +self.m_tblTimeData.Low
			letter = math.ceil( letter )
			letter = string.char( letter )
		elseif i >= self.m_tblTimeData.Dusk_Start and i < self.m_tblTimeData.Dusk_End then
			local progress = (i -self.m_tblTimeData.Dusk_Start) /(self.m_tblTimeData.Dusk_End -self.m_tblTimeData.Dusk_Start)
			local letter_progress = 1 -math.EaseInOut( progress , 0 , 1 )
						
			letter = ( (self.m_tblTimeData.High -self.m_tblTimeData.Low) *letter_progress ) +self.m_tblTimeData.Low
			letter = math.ceil( letter )
			letter = string.char( letter )
		elseif (i > 0 and i < self.m_tblTimeData.Dawn_Start) or (i >= self.m_tblTimeData.Dusk_End and i <= 1440) then
			letter = string.char( self.m_tblTimeData.Low )
		else
			letter = string.char( self.m_tblTimeData.High )
		end
		
		-- calculate colors.
		if i >= self.m_tblTimeData.Dawn_Start and i <= self.m_tblTimeData.Dawn_End then
			-- golden dawn.
			local frac = (i -self.m_tblTimeData.Dawn_Start) /(self.m_tblTimeData.Dawn_End -self.m_tblTimeData.Dawn_Start)
			if i < self.m_tblTimeData.Dawn then
				color.r = 100 *frac
				color.g = 64 *frac
			else
				color.r = 100 -(100 *frac)
				color.g = 64 -(64 *frac)
			end
		elseif i >= self.m_tblTimeData.Dusk_Start and i <= self.m_tblTimeData.Dusk_End then
			-- red dusk.
			local frac = (i -self.m_tblTimeData.Dusk_Start) /(self.m_tblTimeData.Dusk_End -self.m_tblTimeData.Dusk_Start)
			if i < self.m_tblTimeData.Dusk then
				color.r = 40 *frac
			else
				color.r = 40 -(40 *frac)
			end
		elseif i >= self.m_tblTimeData.Dusk_End or i <= self.m_tblTimeData.Dawn_Start then
			-- blue hinted night sky.
			if i > self.m_tblTimeData.Dusk_End then
				local frac = (i -self.m_tblTimeData.Dusk_End) /(self.m_tblTimeData.Length -self.m_tblTimeData.Dusk_End)
				color.r = 1 *frac
				color.g = 1 *frac
				color.b = 2 *frac
			else
				local frac = i /self.m_tblTimeData.Dawn_Start
				color.r = 1 -(1 *frac)
				color.g = 1 -(1 *frac)
				color.b = 2 -(2 *frac)
			end
		end

		self.m_tblLightTable[i] = {}
		--[[self.m_tblLightTable[i].Alpha = 0

		if i >= self.m_tblTimeData.Dawn_Start and i <= self.m_tblTimeData.Dawn_End then
			local progress = (self.m_tblTimeData.Dawn_End -i) /(self.m_tblTimeData.Dawn_End -self.m_tblTimeData.Dawn_Start)
			self.m_tblLightTable[i].Alpha = math.floor( 250 *progress )
		elseif i >= self.m_tblTimeData.Dusk_Start and i <= self.m_tblTimeData.Dusk_End then
			local progress = (i -self.m_tblTimeData.Dusk_Start) /(self.m_tblTimeData.Dusk_End -self.m_tblTimeData.Dusk_Start)
			self.m_tblLightTable[i].Alpha = math.floor( 250 *progress )
		elseif (i >= 0 and i <= self.m_tblTimeData.Dawn_Start) or (i >= self.m_tblTimeData.Dusk_End and i <= 1440) then
			self.m_tblLightTable[i].Alpha = 250
		end]]--
	
		self.m_tblLightTable[i].Pattern = letter
		self.m_tblLightTable[i].Color = math.floor( color.r ).. " ".. math.floor( color.g ).. " ".. math.floor( color.b )
	end
end

function GM.DayNight:GetLightTable()
	return self.m_tblLightTable
end

--[[ Sun Entity ]]--
function GM.DayNight:GetSunEnts()
	return self.m_tblMapEnts.Sun
end

function GM.DayNight:HasSunEnt()
	return self.m_tblMapEnts.Sun and IsValid( self.m_tblMapEnts.Sun[1] )
end

function GM.DayNight:SetSunFadePattern( strChar )
	if not self:HasSunEnt() then return end
	local newPattern = hook.Call( "GamemodeUpdateMapLighting", GAMEMODE, strChar, self.m_intCurLightIndex or 0 )
	for _, ent in pairs( self.m_tblMapEnts.Sun ) do
		ent:Fire( "FadeToPattern", newPattern or strChar, "0" )
		ent:Activate()
	end
end

--[[ Sun FX Entity ]]--
function GM.DayNight:GetSunFXEnts()
	return self.m_tblMapEnts.SunFX
end

function GM.DayNight:HasSunFXEnt()
	return self.m_tblMapEnts.SunFX and IsValid( self.m_tblMapEnts.SunFX[1] )
end

function GM.DayNight:SetSunMaterial( strMat )
	if not self:HasSunFXEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SunFX ) do
		ent:SetKeyValue( "material", strMat )
	end
end

function GM.DayNight:SetSunOverlayMaterial( strMat )
	if not self:HasSunFXEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SunFX ) do
		ent:SetKeyValue( "overlaymaterial", strMat )
	end
end

function GM.DayNight:SetSunAngle( strAxis, intAng )
	if not self:HasSunFXEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SunFX ) do
		ent:Fire( "AddOutput", strAxis.. " ".. intAng, "0" )
		ent:Activate()
	end
end

--[[ Skypaint Entity ]]--
function GM.DayNight:GetSkyPaintEnt()
	return self.m_tblMapEnts.SkyPaint
end

function GM.DayNight:HasSkyPaintEnt()
	return self.m_tblMapEnts.SkyPaint and IsValid( self.m_tblMapEnts.SkyPaint[1] )
end

function GM.DayNight:SetSunNormal( veNorm )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "sunnormal", ("%f %f %f"):format(
			veNorm.x,
			veNorm.y,
			veNorm.z
		) )
	end
end

function GM.DayNight:SetStarScale( intScale )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "starscale", tostring(intScale) )
	end
end

function GM.DayNight:SetStarSpeed( intSpeed )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "starspeed", tostring(intSpeed) )
	end
end

function GM.DayNight:SetStarTexture( strStarTex )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "startexture", strStarTex )
	end
end

function GM.DayNight:SetSkyTopColor( intR, intG, intB )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "topcolor", ("%f %f %f"):format(
			intR,
			intG,
			intB
		), 0.01, 1 )
	end
end

function GM.DayNight:SetSkyBottomColor( intR, intG, intB )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "bottomcolor", ("%f %f %f"):format(
			intR,
			intG,
			intB
		), 0.005, 1 )
	end
end

function GM.DayNight:SetSunColor( intR, intG, intB )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "suncolor", ("%f %f %f"):format(
			intR,
			intG,
			intB
		) )
	end
end

function GM.DayNight:SetDuskColor( intR, intG, intB )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "duskcolor", ("%f %f %f"):format(
			intR,
			intG,
			intB
		) )
	end
end

function GM.DayNight:SetDuskIntensity( intValue )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "duskintensity", tostring(intValue) )
	end
end

function GM.DayNight:SetDuskScale( intValue )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "duskscale", tostring(intValue) )
	end
end

function GM.DayNight:SetStarFade( intValue )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "starfade", tostring(intValue) )
	end
end

function GM.DayNight:SetSkyFadeBias( intValue )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "fadebias", tostring(intValue) )
	end
end

function GM.DayNight:SetSunSize( intValue )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "sunsize", tostring(intValue) )
	end
end

function GM.DayNight:SetHDRScale( intValue )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "hdrscale", tostring(intValue) )
	end
end

function GM.DayNight:SetDrawStars( bDraw )
	if not self:HasSkyPaintEnt() then return end
	for _, ent in pairs( self.m_tblMapEnts.SkyPaint ) do
		ent:SetKeyValue( "drawstars", bDraw and "1" or "0" )
	end
end

--[[ Night Lights ]]--
function GM.DayNight:TurnOnNightLights()
	if not self.m_bHasNightLights then return end
	for _, ent in pairs( self.m_tblNightLights ) do
		if not IsValid( ent ) then continue end
		ent:Fire( "SetPattern", "mmnmmommommnonmmonqnmmo" )
		ent:Fire( "TurnOn", "", "0" )
	end
	
	timer.Simple( 0.66, function()
		if not self.m_bNightLightsOn then return end
		for _, ent in pairs( self.m_tblNightLights ) do
			if not IsValid( ent ) then continue end
			ent:Fire( "SetPattern", "z", "0" )
			ent:Fire( "FireUser1", "", "0" )
		end
	end )

	self.m_bNightLightsOn = true
end

function GM.DayNight:TurnOffNightLights()
	if not self.m_bHasNightLights then return end
	for _, ent in pairs( self.m_tblNightLights ) do
		ent:Fire( "TurnOff", "", "0" )
		ent:Fire( "FireUser2", "", "0" )
	end

	self.m_bNightLightsOn = false
end

function GM.DayNight:NightLightsOn()
	return self.m_bNightLightsOn
end

--[[ Day Night ]]--
function GM.DayNight:GetTime()
	return self.m_intCurMinute
end

function GM.DayNight:GetDay()
	return self.m_intCurDay
end

function GM.DayNight:ScaleSkyColor( intValue )
	if not self:HasSkyPaintEnt() then
		if not self.m_intFindSkyPaintTries then self.m_intFindSkyPaintTries = 0 end
		if self.m_intFindSkyPaintTries >= 5 then return end
		self.m_intFindSkyPaintTries = self.m_intFindSkyPaintTries +1
		self:FindSkyPaintEntity()
		return
	end

	local topCol = {
		r = self.m_tblSkyboxData.ColorTop.r *intValue,
		g = self.m_tblSkyboxData.ColorTop.g *intValue,
		b = self.m_tblSkyboxData.ColorTop.b *intValue
	}
	local bottomCol = {
		r = self.m_tblSkyboxData.ColorBottom.r *intValue,
		g = self.m_tblSkyboxData.ColorBottom.g *intValue,
		b = self.m_tblSkyboxData.ColorBottom.b *intValue
	}
	local sunCol = {
		r = 0,
		g = 0,
		b = 0
	}
	local duskAmount = 0

	if intValue > 0.25 then
		duskAmount = 0
	elseif intValue <= 0.25 then
		local val = intValue
		local scalar

		if val <= 0.125 then
			scalar = Lerp( (0.125 -val) /0.125, 1, 0 )
		else
			val = val -0.125
			scalar = Lerp( (0.125 -val) /0.125, 0, 1 )
		end

		duskAmount = scalar
	else
		duskAmount = 0
	end

	local nTpCol, nBtCol, nSunCol, nDuskNum = hook.Call( "GamemodeOnSkyboxUpdate", GAMEMODE, topCol, bottomCol, sunCol, duskAmount )
	if nTpCol then
		topCol = nTpCol
		bottomCol = nBtCol
		sunCol = nSunCol
		duskAmount = nDuskNum
	end

	self:SetSkyTopColor(
		topCol.r,
		topCol.g,
		topCol.b
	)
	self:SetSkyBottomColor(
		bottomCol.r,
		bottomCol.g,
		bottomCol.b
	)
	self:SetSunColor(
		sunCol.r,
		sunCol.g,
		sunCol.b
	)
	self:SetDuskIntensity( duskAmount )
	
	if self.m_intCurMinute < 300 or self.m_intCurMinute > 1290 then
		self:SetStarFade( 5 )
	else
		local fade = math.Clamp((intValue -0.05) *8, 0, 1)
		self:SetStarFade( (1 -fade) *5 )
	end
end

function GM.DayNight:Think()
	if not self.m_intCurMinute then return end
	if not self.m_tblLightTable then return end
	
	local time = CurTime()
	if time < (self.m_intNextThink or 0) then return end
	self.m_intNextThink = time +0.1
	self.m_intCurMinute = self.m_intCurMinute +(0.1 *self.m_intTimeScale)

	local sunFXAngle = 720
	if self.m_intCurMinute < 300 or self.m_intCurMinute >= 1290 then
		sunFXAngle = 90 --270
	else
		if self.m_intCurMinute < 720 then
			sunFXAngle = 360 - ( ((self.m_intCurMinute -300) /419) *89 )
		elseif self.m_intCurMinute == 720 then
			sunFXAngle = 269
		elseif self.m_intCurMinute > 720 then
			sunFXAngle = 360 -( 180 -((1289 -self.m_intCurMinute) /568) *89 )
		end
	end
	
	self:SetSunAngle( "pitch", sunFXAngle )
	self:SetSunNormal( self:GetSunFXEnts()[1]:GetInternalVariable("m_vDirection") )

	if math.floor( self.m_intCurMinute ) ~= (self.m_intLastMinute or 0) then
		if math.floor( self.m_intCurMinute ) >= self.m_tblTimeData.Length then
			self.m_intCurMinute = 0
			local lastDay = self.m_intCurDay
			self.m_intCurDay = self.m_intCurDay +1
			if self.m_intCurDay > 7 then self.m_intCurDay = 1 end
			self:OnDayChanged( lastDay, self.m_intCurDay )
		end

		self:OnTimeChanged( (self.m_intLastMinute or 0), self.m_intCurMinute )
		self.m_intLastMinute = math.floor( self.m_intCurMinute )
	end
	
	self.m_intCurLightIndex = math.Clamp( math.Round(self.m_intCurMinute), 1, self.m_tblTimeData.Length )
	self:SetSunFadePattern( self.m_tblLightTable[self.m_intCurLightIndex].Pattern )
	
	local found
	for _, data in pairs( self.m_tblSkyScalars ) do
		if data.Compare( self.m_intCurMinute ) then
			self:ScaleSkyColor( data.Scalar(self.m_intCurMinute) )
			found = true
			break
		end
	end
	if not found then
		self:ScaleSkyColor( 0 )
	end
end

function GM.DayNight:OnDayChanged( intLastDay, intNewDay )
	hook.Call( "GamemodeOnDayChanged", GAMEMODE, intLastDay, intNewDay )
	GAMEMODE.Net:BroadcastDayUpdate()
end

function GM.DayNight:OnTimeChanged( intLastTime, intNewTime )
	hook.Call( "GamemodeOnTimeChanged", GAMEMODE, intLastTime, intNewTime )
	GAMEMODE.Net:BroadcastTimeUpdate()
end

concommand.Add( "srp_dev_set_time", function( pPlayer, strCmd, tblArgs )
	if IsValid( pPlayer ) and not pPlayer:IsSuperAdmin() then return end
	GAMEMODE.DayNight.m_intCurMinute = math.Clamp( math.Round(tonumber(tblArgs[1])), 1, GAMEMODE.DayNight.m_tblTimeData.Length )
end )

concommand.Add( "srp_dev_set_timescale", function( pPlayer, strCmd, tblArgs )
	if IsValid( pPlayer ) and not pPlayer:IsSuperAdmin() then return end
	GAMEMODE.DayNight.m_intTimeScale = tonumber( tblArgs[1] )
end )