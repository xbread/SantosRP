--[[
	Name: shared.lua
	For: SantosRP
	By: TalosLife
]]--

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Purpose			= ""

PrecacheParticleSystem( "fire_medium_02_nosmoke" )
PrecacheParticleSystem( "fire_medium_01" )

--[[hook.Add( "ShouldCollide", "FireCollide", function( entA, entB )
	if entA:GetClass() == "santos_fire" and entB:IsPlayer() then return false end
	if entB:GetClass() == "santos_fire" and entA:IsPlayer() then return false end
end )]]--