--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props_vehicles/carparts_wheel01a.mdl" )
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
	
	if GAMEMODE.Cars:FixVehicleWheels( eEnt ) then
		self:Remove()
		self.m_bUsed = true

		local posLocal = eEnt:WorldToLocal( self:GetPos() )
		local idx = 1
		local sounds = {
			"npc/dog/dog_servo8.wav",
			"npc/dog/dog_servo7.wav",
		}
		eEnt:EmitSound( "npc/dog/dog_servo12.wav" )
		timer.Create( ("EmitSound%p"):format(self), 1, 2, function()
			if not IsValid( eEnt ) then return end
			eEnt:EmitSound( sounds[idx] )
			idx = idx +1
		end )
	end
end