--[[
	Name: cl_daynight.lua
	
		
]]--

GM.DayNight = (GAMEMODE or GM).DayNight or {}
GM.DayNight.m_intCurMinute = (GAMEMODE or GM).DayNight.m_intCurMinute or 1
GM.DayNight.m_intCurDay = (GAMEMODE or GM).DayNight.m_intCurDay or 1
GM.DayNight.m_intCurLightScale = (GAMEMODE or GM).DayNight.m_intCurLightScale or 1
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

function GM.DayNight:SetTime( intNewTime )
	if intNewTime ~= self:GetTime() then
		hook.Call( "GamemodeOnTimeChanged", GAMEMODE, self:GetTime(), intNewTime )
	end

	self:OnTimeChanged( self:GetTime(), intNewTime )
	self.m_intCurMinute = intNewTime
end

function GM.DayNight:GetTime()
	return self.m_intCurMinute
end

function GM.DayNight:SetDay( intNewDay )
	if intNewDay ~= self:GetDay() then
		hook.Call( "GamemodeOnDayChanged", GAMEMODE, self:GetDay(), intNewDay )
	end

	self:OnDayChanged( self:GetDay(), intNewDay )
	self.m_intCurDay = intNewDay
end

function GM.DayNight:GetDay()
	return self.m_intCurDay
end

function GM.DayNight:GetLightScale()
	return self.m_intCurLightScale
end

function GM.DayNight:SetupWorldFog()
	if not GAMEMODE.Config.FogLightingEnabled then return end

	local fade = math.Clamp( self:GetLightScale() *4, 0, 1 )
	fade = fade *0.33

	local fogData = {
		Color = Color( 10, 10, 10 ),
		Start = 1,
		End = 2,
		Density = Lerp( fade, 0.33, 0 ),
	}

	hook.Call( "GamemodeSetupWorldFog", GAMEMODE, fogData )

	render.FogMode( 1 )
	render.FogStart( fogData.Start )
	render.FogEnd( fogData.End )
	render.FogMaxDensity( fogData.Density )
	render.FogColor( fogData.Color.r, fogData.Color.g, fogData.Color.b )

	return true
end

function GM.DayNight:SetupSkyboxFog( intScale )
end

function GM.DayNight:OnTimeChanged( intOldTime, intNewTime )
	local found
	for _, data in pairs( self.m_tblSkyScalars ) do
		if data.Compare( self.m_intCurMinute ) then
			self.m_intCurLightScale = data.Scalar( self.m_intCurMinute )
			found = true
			break
		end
	end
	if not found then
		self.m_intCurLightScale = 0
	end
end

function GM.DayNight:OnDayChanged( intOldDay, intNewDay )
end