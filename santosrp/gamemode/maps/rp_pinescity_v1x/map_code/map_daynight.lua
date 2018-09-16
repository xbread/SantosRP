if CLIENT then return end

hook.Add( "InitPostEntity", "GetParalakeNightLights", function()
	for k, v in pairs( ents.GetAll() ) do
		if v:GetName() ~= "Paralake_Streetlights" then continue end
		table.insert( GAMEMODE.DayNight.m_tblNightLights, v )
	end

	GAMEMODE.DayNight.m_bHasNightLights = true
end )

hook.Add( "GamemodeOnTimeChanged", "FireParalakeNightLights", function( intOldTime, intNewTime )
	if intNewTime < 300 or intNewTime >= 1290 then
		if not GAMEMODE.DayNight:NightLightsOn() then
			GAMEMODE.DayNight:TurnOnNightLights()
		end
	else
		if GAMEMODE.DayNight:NightLightsOn() then
			GAMEMODE.DayNight:TurnOffNightLights()
		end
	end
end )