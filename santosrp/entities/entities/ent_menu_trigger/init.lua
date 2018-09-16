--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props_c17/FurnitureShelf001b.mdl" )
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_BBOX )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:PhysWake()

	--self:GetPhysicsObject():EnableMotion( false )
end

function ENT:SetMenu( strMenu )
	self.m_strMenu = strMenu
end

function ENT:AcceptInput( strName, entActivator, entCaller )
	if not IsValid( entCaller ) or not entCaller:IsPlayer() then return end
	if strName ~= "Use" then return end

	entCaller.m_entLastMenuTrigger = self
	GAMEMODE.Net:ShowNWMenu( entCaller, self.m_strMenu )
end