--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props_c17/TrapPropeller_Engine.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetTrigger( true )
	self:PhysWake()
end

function ENT:StartTouch( eEnt )
	if not IsValid( eEnt ) or not eEnt:IsVehicle() or not eEnt.UID then return end
	if self.m_bUsed then return end
	if not self.m_intLastTouch then self.m_intLastTouch = 0 end
	if CurTime() <= self.m_intLastTouch then return end
	self.m_intLastTouch = CurTime() +1
	
	if GAMEMODE.Cars:GetCarHealth( eEnt ) >= GAMEMODE.Cars:GetCarMaxHealth( eEnt ) then return end
	if GAMEMODE.Cars:GetCarHealth( eEnt ) > 0 then return end
	if eEnt:IsOnFire() then
		if IsValid( self:GetPlayerOwner() ) then
			self:GetPlayerOwner():AddNote( "You can't fix that while it is on fire!" )
		end

		return
	end

	eEnt:EmitSound( "items/smallmedkit1.wav", 70 )
	GAMEMODE.Cars:SetCarHealth( eEnt, GAMEMODE.Cars:GetCarMaxHealth( eEnt ) *math.Rand(0.1, 0.15) )

	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( "cball_explode", effectdata )

	self:Remove()
	self.m_bUsed = true

	local posLocal = eEnt:WorldToLocal( self:GetPos() )
	local idx = 1
	local sounds = {
		"npc/dog/dog_servo8.wav",
		"npc/dog/dog_servo7.wav",
		"npc/dog/dog_servo12.wav",
	}
	timer.Create( ("EmitSound%p"):format(self), 1, 3, function()
		if not IsValid( eEnt ) then return end
		eEnt:EmitSound( sounds[idx] )
		idx = idx +1
	end )
end