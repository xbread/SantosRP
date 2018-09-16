--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local models = {
	"models/props_junk/cardboard_box004a.mdl",
	"models/props_junk/cardboard_box003a.mdl",
	"models/props_junk/cardboard_box002a.mdl",
	"models/props_junk/cardboard_box001a.mdl",
}

function ENT:Initialize()
	local mdl, _ = table.Random( models )
	self:SetModel( mdl )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetTrigger( true )
	self:PhysWake()

	self.m_intTouchDelay = CurTime() +5
end

function ENT:StartTouch( eEnt )
	if self.m_intTouchDelay > CurTime() then return end
	if not IsValid( eEnt ) or not eEnt:IsVehicle() or not eEnt.IsMailTruck then return end
	if self.ParentMailTruck == eEnt then
		self:Remove()
		eEnt:EmitSound( "physics/cardboard/cardboard_box_impact_soft".. math.random(1, 7).. ".wav" )
	end
end