--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props_c17/lockers001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	self:GetPhysicsObject():EnableMotion( false )
end

function ENT:Use( pPlayer )
	if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= self:GetJobID() then return end
	GAMEMODE.Net:ShowNWMenu( pPlayer, "job_clothing_locker" )
end

GAMEMODE.Net:RegisterEventHandle( "ent", "clth_lck_apply", function( intMsgLen, pPlayer )
	local lockerEnt = pPlayer:GetEyeTrace().Entity
	if not IsValid( lockerEnt ) or lockerEnt:GetClass() ~= "ent_job_clothing_locker" then return end
	if lockerEnt:GetJobID() ~= GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) then return end
	if pPlayer:GetPos():Distance( lockerEnt:GetPos() ) > 200 then return end

	local skinID = net.ReadUInt( 8 )
	local model = net.ReadString():lower()
	local numGroups = net.ReadUInt( 8 )
	local groups = {}

	if numGroups > 0 then
		for i = 1, numGroups do
			groups[net.ReadUInt(8)] = net.ReadUInt( 8 )
		end
	end

	local baseModel = GAMEMODE.Jobs:GetJobByID( JOB_CIVILIAN ):GetPlayerModel( pPlayer )
	local jobModel = GAMEMODE.Jobs:GetJobByID( lockerEnt:GetJobID() ):GetPlayerModel( pPlayer, true )

	if model ~= baseModel:lower() and model ~= jobModel:lower() then return end
	
	if model == baseModel:lower() then
		if GAMEMODE.Jobs:GetPlayerJob( pPlayer ).CanWearCivClothing then
			pPlayer:SetSkin( GAMEMODE.Player:GetGameVar(pPlayer, "char_skin", 0) )
			pPlayer:SetModel( baseModel )
			pPlayer.m_bJobCivModelOverload = true
			pPlayer.m_tblSelectedJobModelBGroups = nil
		end
	else
		pPlayer.m_bJobCivModelOverload = false
		pPlayer.m_intSelectedJobModelSkin = skinID
		pPlayer.m_tblSelectedJobModelBGroups = groups
		pPlayer:SetModel( jobModel )
		pPlayer:SetSkin( skinID )
		for k, v in pairs( pPlayer:GetBodyGroups() ) do
			if groups[v.id] then
				if groups[v.id] > pPlayer:GetBodygroupCount( v.id ) -1 then continue end
				pPlayer:SetBodygroup( v.id, groups[v.id] )
			end
		end
	end
end )