if SERVER then AddCSLuaFile() end



ENT.Base 			= "base_anim"

ENT.PrintName		= ""

ENT.Author			= ""

ENT.Contact			= ""

ENT.Purpose			= ""

ENT.Instructions	= ""



function ENT:Initialize()

	if CLIENT then return end

	self:SetModel( "models/Items/ammocrate_smg1.mdl" )

	self:PhysicsInit( SOLID_VPHYSICS )

	self:SetMoveType( MOVETYPE_VPHYSICS )

	self:SetSolid( SOLID_VPHYSICS )

	self:PhysWake()



	self.m_tblSeats = {}

end



function ENT:Setup( strModel, tblSeats )

	self:SetModel( strModel )

	self:PhysicsInit( SOLID_VPHYSICS )

	self:SetMoveType( MOVETYPE_VPHYSICS )

	self:SetSolid( SOLID_VPHYSICS )

	self:SetUseType( SIMPLE_USE )

	self:PhysWake()



	for k, v in pairs( tblSeats or {} ) do

		local Seat = ents.Create( "prop_vehicle_prisoner_pod" )

		Seat:SetModel( "models/nova/jeep_seat.mdl" )

		Seat:SetPos( self:LocalToWorld(v.pos) )

		Seat:SetAngles( self:LocalToWorldAngles(v.ang) )



		Seat:SetKeyValue( "limitview", 0 )

		Seat:SetKeyValue( "vehiclescript", "scripts/vehicles/prisoner_pod.txt" )



		Seat:Spawn()

		Seat:Activate()

		Seat:SetParent( self )

		Seat:SetNoDraw( true )

		Seat:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

		Seat.IsFurnSeat = true

		Seat.BlockPhysGun = true

		self:DeleteOnRemove( Seat )

		self.m_tblSeats[k] = Seat

	end

end



if SERVER then

	function ENT:OnRemove()

		for k, v in pairs( self.m_tblSeats ) do

			if IsValid( v ) and IsValid( v:GetDriver() ) then

				v:GetDriver():ExitVehicle()

			end

		end

	end

	

	hook.Add( "CanPlayerEnterVehicle", "FurnitureSeats", function( pPlayer, entVeh )

		if not entVeh.IsFurnSeat then return end

		if not IsValid( entVeh:GetParent() ) then return end

		return entVeh:GetParent():GetVelocity():Length() < 15

	end )



	hook.Add( "PlayerEnteredVehicle", "FurnitureSeats", function( pPlayer, entVeh )

		if not entVeh.IsFurnSeat then return end

		if not IsValid( entVeh:GetParent() ) then return end

		entVeh:GetParent():GetPhysicsObject():EnableMotion( false )

		entVeh:GetParent().BlockPhysGun = true

	end )



	hook.Add( "PlayerLeaveVehicle", "FurniturePosSet", function( pPlayer, entVeh )

		if not entVeh.IsFurnSeat then return end

		pPlayer:GodEnable()

		pPlayer:SetPos( entVeh:GetPos() +(entVeh:GetForward() *512) +(entVeh:GetUp() *32) )

		pPlayer:SetVelocity( Vector(0) )



		timer.Simple( 0, function()

			pPlayer:GodDisable()

			if not IsValid( pPlayer ) or not IsValid( entVeh ) then return end

			pPlayer:SetPos( entVeh:GetPos() +(entVeh:GetForward() *48) +(entVeh:GetUp() *32) )

			pPlayer:SetVelocity( Vector(0) )

			GAMEMODE.Util:UnstuckPlayer( pPlayer )



			local empty = true

			for _, v in pairs( entVeh:GetParent().m_tblSeats ) do

				if IsValid( v:GetDriver() ) then

					empty = false

					break

				end

			end

			if empty then

				entVeh:GetParent():GetPhysicsObject():EnableMotion( true )

				entVeh:GetParent().BlockPhysGun = false

			end

		end )

	end )



	hook.Add( "GamemodePlayerPickupItem", "BlockUsedSeats", function( pPlayer, eEnt )

		if IsValid( eEnt ) and eEnt:GetClass() == "ent_base_seat" then

			for k, v in pairs( eEnt.m_tblSeats or {} ) do

				if IsValid( v:GetDriver() ) then return false end

			end

		end

	end )



	hook.Add( "PhysgunPickup", "BlockUsedSeats", function( pPlayer, eEnt )

		if IsValid( eEnt ) and eEnt:GetClass() == "ent_base_seat" then

			for k, v in pairs( eEnt.m_tblSeats or {} ) do

				if IsValid( v:GetDriver() ) then return false end

			end

		end

	end )

end