--[[
	Name: cl_hud_car.lua
	By: unknown/1.0 devs
]]--

local seatbelt_mat = Material( "santosrp/seatbelt.png", "unlitgeneric smooth" )
local MAT_CARSPEED = Material( "santosrp/speed.png" )
local MAT_NEEDLE = Material( "santosrp/needle.png" )
local MAT_FUEL = Material( "santosrp/fuel.png" )

function GM.HUD:DrawCarHUD()
	local pl = LocalPlayer()
	local Vehicle = pl:GetVehicle()
	if not IsValid( Vehicle ) then return end
	if Vehicle:GetClass() ~= "prop_vehicle_jeep" then return end

	--Speedometer
	local Vel = GAMEMODE.Util:ConvertUnitsToKM( Vehicle:GetVelocity():Length() *60 *60 )
	local MaxSpeed = 200
	local C = math.Clamp( Vel /MaxSpeed, 0, 1 )

	local Fuel = Vehicle:GetFuel()
	local MaxFuel = Vehicle:GetMaxFuel()
	surface.SetDrawColor( 255, 255, 255, 255 )	
	surface.SetMaterial( MAT_CARSPEED ) 
	surface.DrawTexturedRect( ScrW() -380, ScrH() -400, 400, 400 )
	surface.SetMaterial( MAT_FUEL ) 
	surface.DrawTexturedRect( ScrW() -660, ScrH() -400, 400, 400 )

	--Speed
	local buf = -45 +-Vel
	surface.SetMaterial( MAT_NEEDLE ) 
	surface.DrawTexturedRectRotated( ScrW() -180, ScrH() -10, 260, 260, buf )

	--180 degrees of room from -95 to -180, so 85 degrees
	local degrees = 85
	local dbuf = degrees /MaxFuel
	local nbuf = dbuf *Fuel
	local buf = -95 +-nbuf
	surface.SetMaterial( MAT_NEEDLE ) 
	surface.DrawTexturedRectRotated( ScrW() -465, ScrH() -10, 150, 150, buf )
	if pl:InVehicle() and not pl:GetNWBool( "SeatBelt" ) then
		surface.SetMaterial( seatbelt_mat )
		surface.SetDrawColor( 255, 60, 0, 255 )
		surface.DrawTexturedRect( ScrW() -194, ScrH() -100, 32, 32 )
	end
end