if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	SWEP.PrintName = "Ticket Giver"
	SWEP.Slot = 5
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Base 					 =      "weapon_modify_base"

SWEP.PrintName	             =      "Ticket Giver"			
SWEP.Author			         =      "RayChamp"
SWEP.Instructions		     =      ""
SWEP.Purpose 		         =      ""

SWEP.Spawnable               =      true
SWEP.AdminOnly               =      false

SWEP.Primary.ClipSize		 =      -1
SWEP.Primary.DefaultClip	 =      -1
SWEP.Primary.Automatic		 =      false
SWEP.Primary.Ammo		     =      "none"

SWEP.Secondary.ClipSize		 =      -1
SWEP.Secondary.DefaultClip	 =      -1
SWEP.Secondary.Automatic	 =      false
SWEP.Secondary.Ammo		     =      "none"

--Misc Settings
SWEP.Weight			         =      5
SWEP.AutoSwitchTo		     =      true
SWEP.AutoSwitchFrom		     =      true
SWEP.Slot			         =      5
SWEP.SlotPos			     =      2
SWEP.DrawAmmo			     =      false
SWEP.DrawCrosshair		     =      false
SWEP.FiresUnderwater         =      false

SWEP.HoldType 				 = "pistol"
SWEP.ViewModelFOV 			 = 70
SWEP.ViewModelFlip 			 = false
SWEP.ViewModel 				 = "models/sal/notepad.mdl"
SWEP.WorldModel 			 = "models/sal/notepad.mdl"

SWEP.HoldPos 				 = Vector( 2, 2, 0 )
SWEP.HoldAng 				 = Vector( 90, 90, 15 )

SWEP.ViewAng 				 = Vector( 90, 0, 0 )
SWEP.ViewPos 				 = Vector( 4, 9, -3 )

if CLIENT then
	local function ShowTicketMenu( target, name )
		GAMEMODE.Gui:StringRequest( "Ticket Cost?", "How much will this ticket cost for "..name.."?", "", function( txt )
			local price = tonumber( txt )
			if price then
				GAMEMODE.Gui:StringRequest( "Ticket Reason?", "What is the reason for this ticket for "..name.."?", "", function( strReason )
					if not IsValid( target ) then return end
					if not target:IsPlayer() then
						GAMEMODE.Net:RequestTicketCar( target, strReason, price )
					else
						GAMEMODE.Net:RequestTicketPlayer( target, strReason, price )
					end
				end )
			end
		end )
	end

	net.Receive( "ticketRequest", function()
		local target = net.ReadEntity()
		local name = "this vehicle"
		
		if ( target:IsPlayer() ) then
			name = target:Nick()
		end
		
		ShowTicketMenu( target, name )
	end )
else
	util.AddNetworkString "ticketRequest"
end

function SWEP:OnHit( ent )
	ent = self.Owner:GetEyeTrace().Entity
	if ( !ent:IsPlayer() and !ent:IsVehicle() ) then return end

	if ( ent.GetDriver and IsValid(ent:GetDriver()) ) then
		ent = ent:GetDriver()
	end

	net.Start( "ticketRequest" )
		net.WriteEntity( ent )
	net.Send( self.Owner )
end