AddCSLuaFile()

ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "Bobblehead"
ENT.Purpose			= "Stuff"

local FindOrCreateConstraintSystem, onStartConstraint, onFinishConstraint, CreateConstraintSystem, GarbageCollectConstraintSystems, Keepupright
local MAX_CONSTRAINTS_PER_SYSTEM = 100
local ConstraintSystems = {}
local BED_MODEL = "models/custommodels/stretcher.mdl" --"models/props_medicinalpractice/medic_stretcher_a.mdl"

function ENT:Initialize()
	if SERVER then
		self:SetModel( BED_MODEL )
		
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetTrigger( true )

		--self.LastReleased = CurTime() -5
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		
		local stretcher = ents.Create( "prop_vehicle_prisoner_pod" )
		stretcher:SetPos( self:LocalToWorld(Vector(21.093546, 40.069160, 24.104210)) )
		stretcher:SetModel( "models/vehicles/prisoner_pod_inner.mdl" )
		stretcher:SetAngles( self:LocalToWorldAngles(Angle(-85, 90, 0)) )
		stretcher:SetKeyValue( "vehiclescript", "scripts/vehicles/prisoner_pod.txt" )
		stretcher:Spawn()
		stretcher:Activate()
		stretcher:SetParent( self )
		stretcher:SetNoDraw( true )
		stretcher:SetCollisionGroup( COLLISION_GROUP_WORLD )

		self.Stretcher = stretcher
		stretcher.IsStretcher = true
		self:DeleteOnRemove( stretcher )

		self.AdminPhysGun = true
	end
end

function ENT:KickPlayer()
	local ply = self.Stretcher:GetDriver()
	ply.m_intStretcherExitTime = CurTime() +2
	if IsValid( ply ) then ply:ExitVehicle() end
	ply:SetPos( self:GetPos() )
	GAMEMODE.Util:UnstuckPlayer( ply, 72 )

	if ply:IsUncon() then
		ply:GoUncon()
	else
		if ply.m_bStretcherWasDead then
			ply.m_bStretcherWasDead = nil
			ply:Kill()
		end
	end
end

function ENT:Use( activator, caller, type, value )
	if not activator:IsPlayer() then return end -- Who the frig is pressing this shit!?
	
	if self.Stretcher:GetDriver():IsValid() and self:GetParent():IsValid() then
		net.Start( "Stretcher" )
			net.WriteEntity( self )
		net.Send( activator )
	elseif self:GetParent():IsValid() then
		self:UnHook( activator )
	elseif self.Stretcher:GetDriver():IsValid() then
		self:KickPlayer()
	end
end

if CLIENT then
	local function srp_stretcher( ent, choice )
		net.Start( "Stretcher" )
			net.WriteEntity( ent )
			net.WriteInt( choice, 3 )
		net.SendToServer()
	end

	--CLIENT
	net.Receive("Stretcher",function( len )	
		local ent = net.ReadEntity()
		GAMEMODE.Gui:Derma_Query(
			"What would you like to do?",
			"Stretcher",
			"Remove Stretcher",
			function()
				srp_stretcher( ent, 0 )
			end,
			"Remove Patient",
			function()
				srp_stretcher( ent, 1 )
			end
		)
	end )
else
	--SERVER
	util.AddNetworkString("Stretcher")
	net.Receive("Stretcher",function(len, ply)
		local ent, choice = net.ReadEntity(), net.ReadInt( 3 )
		if not IsValid( ent ) or not ent:GetClass() == "ent_stretcher" or ent:GetPos():Distance( ply:GetPos() ) > 200 then return end
		
		if choice == 0 then
			ent:UnHook( ply )
		else
			ent:ExitPlayer()
		end
	end )
end

function ENT:ExitPlayer()
	if self.Stretcher:GetDriver():IsValid() then
		self:KickPlayer()
	end
end

function ENT:UnHook( activator )
	local parent = self:GetParent()
	if IsValid( parent ) then
		self:SetParent()
		self.LastReleased = CurTime()
		self:EmitSound( Sound("weapons/crowbar/crowbar_impact1.wav") )
		self:PhysWake()
		self:SetPos( parent:LocalToWorld(Vector(28, -250, 58)) )
		activator:SetPos( parent:LocalToWorld(Vector(-20, -200, 10)) )
		
		Keepupright( self, self:GetPhysicsObject():GetAngles(), 0, 10000 )
	end
end

function ENT:StartTouch( other )
	--other = other.HitEntity
	if other:GetClass() == "prop_ragdoll" and IsValid( other.RagdollPlayer ) then
		if not other.RagdollPlayer:IsUncon() and other.RagdollPlayer:Alive() then return end
		if not IsValid( self.Stretcher:GetDriver() ) then
			local ply = other.RagdollPlayer
			if CurTime() < (ply.m_intStretcherExitTime or 0) then return end
			
			if ply:IsUncon() then
				ply:WakeUp( nil, true )
			else
				ply:UnRagdoll()
				ply:SetHealth( 1 )
				ply.m_bStretcherWasDead = true
			end

			timer.Simple( 0, function()
				if not IsValid( ply ) then return end
				ply:EnterVehicle( self.Stretcher )
			end )
		end
	end
end

function ENT:CanPlayerDrag( pPlayer )
	return GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_EMS
end

--Just some constraint bullshit because we *CANT* keepupright a nonprop. *Heavens* no.
function Keepupright( Ent, Ang, Bone, angularlimit )
	if not constraint.CanConstrain( Ent, Bone ) then return false end
	-- if ( Ent:GetClass() != "prop_physics" && Ent:GetClass() != "prop_ragdoll" ) then return false end
	if not angularlimit or angularlimit < 0 then return end
	
	local Phys = Ent:GetPhysicsObjectNum( Bone )
	-- Remove any KU's already on entity 
	constraint.RemoveConstraints( Ent, "Keepupright" )
	
	onStartConstraint( Ent )
		local Constraint = ents.Create( "phys_keepupright" )
		Constraint:SetAngles( Ang )
		Constraint:SetKeyValue( "angularlimit", angularlimit )
		Constraint:SetPhysConstraintObjects( Phys, Phys )
		Constraint:Spawn()
		Constraint:Activate()
	onFinishConstraint( Ent )

	constraint.AddConstraintTable( Ent, Constraint )

	Constraint:SetTable{
		Type = "Keepupright",
		Ent1 = Ent,
		Ang = Ang,
		Bone = Bone,
		angularlimit = angularlimit
	}

	-- This is a hack to keep the KeepUpright context menu in sync..
	Ent:SetNWBool( "IsUpright", true )
	return Constraint
end

function FindOrCreateConstraintSystem( Ent1, Ent2 )
	local System = nil
	Ent2 = Ent2 or Ent1

	-- Does Ent1 have a constraint system?
	if not Ent1:IsWorld() and Ent1:GetTable().ConstraintSystem and Ent1:GetTable().ConstraintSystem:IsValid() then
		System = Ent1:GetTable().ConstraintSystem
	end

	-- Don't add to this system - we have too many constraints on it already.
	if System and System:IsValid() and System:GetVar( "constraints", 0 ) > MAX_CONSTRAINTS_PER_SYSTEM then System = nil end
	
	-- Does Ent2 have a constraint system?
	if not System and not Ent2:IsWorld() and Ent2:GetTable().ConstraintSystem and Ent2:GetTable().ConstraintSystem:IsValid() then
		System = Ent2:GetTable().ConstraintSystem
	end
	
	-- Don't add to this system - we have too many constraints on it already.
	if System and System:IsValid() and System:GetVar( "constraints", 0 ) > MAX_CONSTRAINTS_PER_SYSTEM then System = nil end

	-- No constraint system yet (Or they're both full) - make a new one
	if not System or not System:IsValid() then
		--Msg("New Constrant System\n")
		System = CreateConstraintSystem()
	end
	
	Ent1.ConstraintSystem = System
	Ent2.ConstraintSystem = System

	System.UsedEntities = System.UsedEntities or {}
	table.insert( System.UsedEntities, Ent1 )
	table.insert( System.UsedEntities, Ent2 )

	local ConstraintNum = System:GetVar( "constraints", 0 )
	System:SetVar( "constraints", ConstraintNum +1 )

	--Msg("System has "..tostring( System:GetVar( "constraints", 0 ) ).." constraints\n")

	return System
end

function onStartConstraint( Ent1, Ent2 )
	-- Get constraint system
	local system = FindOrCreateConstraintSystem( Ent1, Ent2 )
	-- Any constraints called after this call will use this system
	SetPhysConstraintSystem( system )
end

function GarbageCollectConstraintSystems()
	for k, System in pairs( ConstraintSystems ) do
		-- System was already deleted (most likely by CleanUpMap)
		if not IsValid( System ) then
			ConstraintSystems[k] = nil
		else
			local Count = 0
			for id, ent in pairs( System.UsedEntities ) do
				if ent and ent:IsValid() then Count = Count +1 end
			end
			
			if Count == 0 then
				System:Remove()
				ConstraintSystems[k] = nil
			end
		end
	end
end

function onFinishConstraint( Ent1, Ent2 )
	-- Turn off constraint system override
	SetPhysConstraintSystem( NULL )
end

function CreateConstraintSystem()
	-- This is probably the best place to be calling this
	GarbageCollectConstraintSystems()

	local iterations = GetConVarNumber( "gmod_physiterations" )
	
	local System = ents.Create( "phys_constraintsystem" )
	System:SetKeyValue( "additionaliterations", iterations )
	System:Spawn()
	System:Activate()

	table.insert( ConstraintSystems, System )
	System.UsedEntities = {}

	return System
end