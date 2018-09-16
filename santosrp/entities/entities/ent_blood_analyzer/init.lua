--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props_lab/reciever_cart.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
end

function ENT:AnalyzeBloodSample( pPlayer, tblSample )
	self.m_tblCurSample = table.Copy( tblSample )

	GAMEMODE.Net:BroadcastAnalyzedBloodSample( self, tblSample )
	self:EmitSound( "buttons/button5.wav" )
end

function ENT:Use( pPlayer )
	if not IsValid( pPlayer ) or not pPlayer:IsPlayer() then return end
	if not self.m_tblCurSample then return end
	if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_EMS then return end
	
	GAMEMODE.Net:BroadcastClearAnalyzedBloodSample( self )
	self.m_tblCurSample = nil
	self:EmitSound( "buttons/button19.wav" )
end

function GAMEMODE.Net:BroadcastAnalyzedBloodSample( eEnt, tblSample )
	self:NewEvent( "ent", "bld_ana" )
		net.WriteUInt( eEnt:EntIndex(), 16 )
		net.WriteString( tblSample.OwnerName )
		net.WriteString( tblSample.OwnerSID64 )

		local num = table.Count( tblSample.Drugs )
		net.WriteBool( num > 0 )

		if num > 0 then
			net.WriteUInt( num, 8 )

			for k, v in pairs( tblSample.Drugs ) do
				net.WriteString( k )
				net.WriteUInt( v, 8 )
			end
		end
	self:BroadcastEvent()
end

function GAMEMODE.Net:BroadcastClearAnalyzedBloodSample( eEnt )
	self:NewEvent( "ent", "bld_ana_c" )
		net.WriteUInt( eEnt:EntIndex(), 16 )
	self:BroadcastEvent()
end