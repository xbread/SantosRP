--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props/CS_militia/table_kitchen.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
end

function ENT:AcceptInput( strName, entActivator, entCaller )
	if not IsValid( entCaller ) or not entCaller:IsPlayer() then return end
	if strName ~= "Use" then return end

	entCaller.m_entUsedCraftingEnt = self
	GAMEMODE.Net:ShowNWMenu( entCaller, "assembly_table" )
end