--[[
	Name: sh_santos_customs.lua
	For: TalosLife
	By: TalosLife
]]--

GM.CarShop = GM.CarShop or {}
GM.CarShop.m_tblUpgrades = {
	["Engine"] = {
		["Stock"] = {
			StockPart = true,
			ID = 1,
			Price = 0,
			Params = {
				["engine"] = {
					["maxSpeed"] = 0,
					["horsepower"] = 0,
				},
			},
		},
		["Street"] = {
			ID = 2,
			Price = 10000,
			Params = {
				["engine"] = {
					["maxSpeed"] = 10,
					["horsepower"] = 25,
				},
			},
		},
		["Race"] = {
			ID = 3,
			Price = 30000,
			VIP = true,
			Params = {
				["engine"] = {
					["maxSpeed"] = 20,
					["horsepower"] = 35,
				},
			},
		},
		["Pro"] = {
			ID = 4,
			Price = 45000,
			VIP = true,
			Params = {
				["engine"] = {
					["maxSpeed"] = 30,
					["horsepower"] = 55,
				},
			},
		},
	},

	["NOS"] = {
		["Stock"] = {
			StockPart = true,
			ID = 1,
			Price = 0,
			Params = {
				["engine"] = {
					["boostDelay"] = 0,
					["boostDuration"] = 0,
					["boostForce"] = 0,
					["boostMaxSpeed"] = 0,
					["torqueBoost"] = false,
				},
			},
		},
		["Street"] = {
			ID = 2,
			Price = 10000,
			Params = {
				["engine"] = {
					["boostDelay"] = 50,
					["boostDuration"] = 2.5,
					["boostForce"] = 0.4,
					["boostMaxSpeed"] = 2,
					["torqueBoost"] = true,
				},
			},
		},
		["Race"] = {
			ID = 3,
			Price = 25000,
			VIP = true,
			Params = {
				["engine"] = {
					["boostDelay"] = 40,
					["boostDuration"] = 3.5,
					["boostForce"] = 0.5,
					["boostMaxSpeed"] = 3,
					["torqueBoost"] = true,
				},
			},
		},
		["Pro"] = {
			ID = 4,
			Price = 45000,
			VIP = true,
			Params = {
				["engine"] = {
					["boostDelay"] = 30,
					["boostDuration"] = 5.5,
					["boostForce"] = 0.6,
					["boostMaxSpeed"] = 5,
					["torqueBoost"] = true,
				},
			},
		},
	},
}

GM.CarShop.m_funcBaseCostScalar = GM.Util:DefinePolynomialCurveScalar( 0.0035999, -8.9509, 19.895, -13.884, 3.9551 )
GM.CarShop.m_funcDamageCostScalar = GM.Util:DefinePolynomialCurveScalar( 0.077941, 0.7412, -2.5531, 2.4895, 0.24982 )
function GM.CarShop:GetRepairCost( intCarCost, intHealth, intMaxHealth )
	local maxCost, maxCarCost = 45000, 8000000
	local curCost = math.min( maxCarCost, intCarCost )
	local scalar = math.Clamp( self.m_funcBaseCostScalar(curCost /maxCarCost), 0, 1 )
	
	local baseMaxCost = math.Clamp( math.ceil(maxCost *scalar), 0, maxCost )
	local dmgScale = 1 -self.m_funcDamageCostScalar( intHealth /intMaxHealth )
	local cost = math.max( math.ceil(baseMaxCost *math.Clamp(dmgScale, 0, 1)), 50 )
	return GAMEMODE.Econ:ApplyTaxToSum( "car_insurance", cost )
end

hook.Add( "GamemodeCalcVehicleValue", "AddUpgradeValue", function( entCar, tblPriceData )
	for strType, strID in pairs( entCar.m_tblUpgrades or {} ) do
		if not GAMEMODE.CarShop.m_tblUpgrades[strType] or not GAMEMODE.CarShop.m_tblUpgrades[strType][strID] then return end
		tblPriceData.Value = tblPriceData.Value +GAMEMODE.CarShop.m_tblUpgrades[strType][strID].Price
	end
end )

if SERVER then return end

g_VehicleGlowCache = g_VehicleGlowCache or {}
hook.Add( "NetworkEntityCreated", "CacheCars_SantosShop", function( eEnt )
	if not eEnt.GetClass then return end --wtf?
	if eEnt:GetClass() ~= "prop_vehicle_jeep" then return end
	g_VehicleGlowCache[eEnt] = true
end )

hook.Add( "Think", "RenderStreetGlow", function()
	local idx = 16384
	local curTime, lightDieTime = CurTime(), FrameTime() *6
	local lightDecay, lightBrightness, lightSize = 1000 *lightDieTime, 6, 96

	for car, _ in pairs( g_VehicleGlowCache ) do
		if not IsValid( car ) then g_VehicleGlowCache[car] = nil continue end
		if not car:GetNWBool( "glow_on" ) and not car.m_colGlowPreview then continue end
		if not car:GetNWVector( "glow_col" ) then continue end
		if car:GetPos():DistToSqr( LocalPlayer():GetPos() ) >(2048 ^2) then continue end
		car:DrawShadow( false )
		car:DestroyShadow()
		
		local center = car:OBBCenter()
		local mins, maxs = car:OBBMins(), car:OBBMaxs()
		local color = car:GetNWVector( "glow_col" )
		local glowPos

		if car.m_colGlowPreview then
			color = Vector(
				car.m_colGlowPreview.r,
				car.m_colGlowPreview.g,
				car.m_colGlowPreview.b
			)
		end

		if color.x == -1 then continue end
		local distDown = center:Distance( Vector(0, 0, mins.z) ) -4

		--Forward and rear lights
		local distForward = center:Distance( Vector(mins.x, mins.y, car:OBBCenter().z) ) *0.5
		
		--Front
		glowPos = car:LocalToWorld( center ) +(car:GetAngles():Right() *-distForward) +(car:GetAngles():Up() *-distDown)	
		local dlight = DynamicLight( idx )
		idx = idx +1
		if dlight then
			dlight.pos = glowPos
			dlight.r = color.x
			dlight.g = color.y
			dlight.b = color.z
			dlight.brightness = lightBrightness
			dlight.Decay = 1000
			dlight.Size = lightSize
			dlight.DieTime = curTime +lightDieTime
			dlight.nomodel = true
		end

		--Back
		glowPos = car:LocalToWorld( center ) +(car:GetAngles():Right() *distForward) +(car:GetAngles():Up() *-distDown)	
		local dlight = DynamicLight( idx )
		idx = idx +1
		if dlight then
			dlight.pos = glowPos
			dlight.r = color.x
			dlight.g = color.y
			dlight.b = color.z
			dlight.brightness = lightBrightness
			dlight.Decay = 1000
			dlight.Size = lightSize
			dlight.DieTime = curTime +lightDieTime
			dlight.nomodel = true
		end

		--Side lights
		local distSide = center:Distance( Vector(mins.x, 0, car:OBBCenter().z) ) *0.15

		--center
		glowPos = car:LocalToWorld( center ) +(car:GetAngles():Up() *-distDown)	
		local dlight = DynamicLight( idx )
		idx = idx +1
		if dlight then
			dlight.pos = glowPos
			dlight.r = color.x
			dlight.g = color.y
			dlight.b = color.z
			dlight.brightness = lightBrightness
			dlight.Decay = 1000
			dlight.Size = lightSize +16
			dlight.DieTime = curTime +lightDieTime
			dlight.nomodel = true
		end
	end
end )

local lastGlowPress = 0
hook.Add( "Tick", "CarModBinds", function()
	if input.IsKeyDown( KEY_G ) then
		if not IsValid( LocalPlayer():GetVehicle() ) then return end
		if LocalPlayer():GetVehicle():GetClass() ~= "prop_vehicle_jeep" then return end
		if vgui.CursorVisible() then return end
		
		if lastGlowPress > CurTime() then return end
		lastGlowPress = CurTime() +1

		RunConsoleCommand( "srp_toggle_streetglow" )
	end
end )