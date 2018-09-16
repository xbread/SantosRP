--[[
	Name: sv_bailout.lua
	For: TalosLife
	By: TalosLife
]]--

sound.Add{
	name = "Seatbelt.Chime",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 100 },
	sound = "taloslife/seatalarm.mp3"
}

GM.SeatBelts = {}

CreateConVar( "rp_bailout_speed", 300, {FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE,FCVAR_ARCHIVE}, "How fast a vehicle is moving before the player fles out when they try to exit." )
CreateConVar( "rp_windshield_enabled", 1, {FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE,FCVAR_ARCHIVE}, "Whether hitting a wall fast will toss you from the car." )
CreateConVar( "rp_windshield_threshold", 13, {FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE,FCVAR_ARCHIVE}, "How hard to hit a wall before being tossed through the windshield." )
local RAGDOLL_WINDOW = 0
local RAGDOLL_BAILOUT = 1

function GM.SeatBelts:PlayerToggleSeatBelt( pPlayer, bForce )
	if bForce ~= nil then
		pPlayer.m_bSeatBelt = bForce
	else
		pPlayer.m_bSeatBelt = not pPlayer.m_bSeatBelt
	end
	
	if pPlayer.m_bSeatBelt then
		pPlayer:StopSound( "Seatbelt.Chime" )
		pPlayer:EmitSound( "taloslife/seatbelt.wav" )		
	end

	pPlayer:SetNWBool( "SeatBelt", pPlayer.m_bSeatBelt )
end

function GM.SeatBelts:PlayerBailOut( pPlayer, entVehicle )
	if not IsValid( entVehicle ) or entVehicle.IsStretcher then return end
	pPlayer.m_bBecomeRagdollOnExit = RAGDOLL_BAILOUT
	pPlayer:ExitVehicle()
	pPlayer:SetEyeAngles( entVehicle:GetForward():Angle() )
	GAMEMODE.Util:PlayerEmitSound( pPlayer, "Fall" )
end

function GM.SeatBelts:EntityTakeDamage( eEnt, pDamageInfo )
	if not IsValid( eEnt ) or not eEnt:IsPlayer() or not eEnt:InVehicle() or not IsValid( eEnt:GetVehicle() ) then return end

	local veh, parent = eEnt:GetVehicle(), eEnt:GetVehicle():GetParent()
	if veh:GetClass() == "prop_vehicle_prisoner_pod" then
		if IsValid( parent ) and parent.VC_SeatTable then
			if table.HasValue( parent.VC_SeatTable, veh ) then --block this damage event, the parent vehicle will manage it
				return true
			end
		end
	end

	if veh:GetClass() ~= "prop_vehicle_jeep" then return end --only cars
	local threshold = GetConVarNumber( "rp_windshield_threshold" )
	if pDamageInfo:IsBulletDamage() or pDamageInfo:IsExplosionDamage() then
		return --In this case, don't eject them!
	end

	if pDamageInfo:GetDamage() >= threshold and GetConVarNumber( "rp_windshield_enabled" ) == 1 then
		for k, v in pairs( veh.VC_SeatTable or {} ) do
			if not IsValid( v:GetDriver() ) or v.IsStretcher then continue end
			local passenger = v:GetDriver()

			--Do more damage to players not wearing a seatbelt. For shame!
			local passDamage = pDamageInfo:GetDamage() *(passenger.m_bSeatBelt and 0.075 or 3.5)
			passenger:SetHealth( passenger:Health() -passDamage )
			--If wearing a seatbelt and the car and player health aren't at 0, don't eject them
			--If car health hits 0 or player health hits 0, eject them!
			if (veh.VC_Health or 1) > 0 and passenger:Health() > 0 and passenger.m_bSeatBelt then continue end

			passenger.m_entEjectedVehicle = veh
			v.m_intVehEjectSpeed = pDamageInfo:GetDamage() *10
			v.m_bBecomeRagdollOnExit = RAGDOLL_WINDOW
			passenger:SetEyeAngles( v:GetForward():Angle() )
			passenger:ExitVehicle()
		end

		local driver = eEnt
		if IsValid( driver ) then
			--Do more damage to players not wearing a seatbelt. For shame!
			pDamageInfo:ScaleDamage( not driver.m_bSeatBelt and 3.5 or 0.075 )
			driver:SetHealth( driver:Health() -pDamageInfo:GetDamage() )
			
			--If wearing a seatbelt and the car and player health aren't at 0, don't eject them
			--If car health hits 0 or player health hits 0, eject them!
			if (veh.VC_Health or 1) > 0 and driver:Health() > 0 and driver.m_bSeatBelt then return true end

			driver.m_intVehEjectSpeed = pDamageInfo:GetDamage() *10
			driver.m_bBecomeRagdollOnExit = RAGDOLL_WINDOW
			driver.m_entEjectedVehicle = veh
			driver:SetEyeAngles( veh:GetForward():Angle() )
			driver:ExitVehicle()
		end
	end

	return true
end

function GM.SeatBelts:PlayerEnteredVehicle( pPlayer, entVehicle )
	if not entVehicle.IsStretcher and not entVehicle.playerdynseat then
		if not entVehicle:GetClass():find( "jeep" ) then 
			if not IsValid( entVehicle:GetParent() ) then return end
			if not entVehicle:GetParent():GetClass():find( "jeep" ) then return end
		end

		pPlayer:StopSound( "Seatbelt.Chime" )
		timer.Simple( 0.25, function()
			if not IsValid( pPlayer ) then return end
			pPlayer:EmitSound( "Seatbelt.Chime" )
		end )
	end
end

function GM.SeatBelts:PlayerLeaveVehicle( pPlayer, entVehicle )
	pPlayer:StopSound( "Seatbelt.Chime" )
	self:PlayerToggleSeatBelt( pPlayer, false )

	if pPlayer.m_bBecomeRagdollOnExit == RAGDOLL_BAILOUT then
		pPlayer:SetLocalVelocity( entVehicle:GetVelocity() )
		pPlayer:SetPos( pPlayer:GetPos() +Vector(0, 0, 50) )
		pPlayer:BecomeRagdoll( 4, true )
		entVehicle:Fire( "HandBrakeOff", "1" )	
	elseif pPlayer.m_bBecomeRagdollOnExit == RAGDOLL_WINDOW then
		entVehicle = pPlayer.m_entEjectedVehicle or entVehicle
		pPlayer:SetPos( (entVehicle:GetForward() *30) +(entVehicle:GetUp() *60) +entVehicle:GetPos() )
		pPlayer:SetVelocity( pPlayer.m_intVehEjectSpeed *entVehicle:GetForward() )
		pPlayer:SetHealth( math.max(50, pPlayer:Health() -50))
		pPlayer:BecomeRagdoll( 10, true )
	end

	pPlayer.m_bBecomeRagdollOnExit = nil
	pPlayer.m_intVehEjectSpeed = nil
end

function GM.SeatBelts:KeyPress( pPlayer, intKey )
	if not pPlayer:InVehicle() or intKey ~= IN_USE then return end
	local veh = pPlayer:GetVehicle()
	if IsValid( veh:GetParent() ) then veh = veh:GetParent() end
	
	if veh:GetVelocity():Length() > GetConVarNumber( "rp_bailout_speed" ) then
		self:PlayerBailOut( pPlayer, veh )
	end
end

concommand.Add( "rp_seatbelt", function( pPlayer, strCmd, tblArgs )
	if pPlayer.m_bSeatBelt or not pPlayer:InVehicle() then return end
	if pPlayer:GetVehicle().IsStretcher or pPlayer:GetVehicle().playerdynseat then return end
	
	local veh = pPlayer:GetVehicle()
	if not veh:GetClass():find( "jeep" ) then 
		if not IsValid( veh:GetParent() ) then return end
		if not veh:GetParent():GetClass():find( "jeep" ) then return end
	end

	GAMEMODE.SeatBelts:PlayerToggleSeatBelt( pPlayer, true )
end )