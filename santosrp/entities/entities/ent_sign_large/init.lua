--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props/cs_office/offpaintinga.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()
end

function ENT:WrapString( strText, intLimit, strIndent, indent1 )
	strIndent = strIndent or ""
	indent1 = indent1 or strIndent
	intLimit = intLimit or 72

	local here = 1 -#indent1
	return indent1.. strText:gsub( "(%s+)()(%S+)()", function( sp, st, word, fi )
		if fi -here > intLimit then
			here = st -#strIndent
			return "\n".. strIndent.. word
		end
	end )
end

function ENT:SetText( str )
	self.m_strText = str
	GAMEMODE.Net:NetworkLargeSignText( self )
end

function ENT:GetText()
	return self.m_strText
end

function ENT:Use( pPlayer )
	if not IsValid( pPlayer ) or not pPlayer:IsPlayer() then return end
	if self:GetPlayerOwner() ~= pPlayer then return end
		
	GAMEMODE.Net:OpenLargeSignMenu( self, pPlayer )
end

GAMEMODE.Net:RegisterEventHandle( "ent", "lsgn_st", function( intMsgLen, pPlayer )
	local ent = net.ReadEntity()
	if not IsValid( ent ) or ent:GetClass() ~= "ent_sign_large" then return end
	if ent:GetPlayerOwner() ~= pPlayer then return end
	
	local str = net.ReadString()
	if str:len() > ent.m_intMaxTextLen then return end
	
	ent:SetText( str )
end )

function GAMEMODE.Net:NetworkLargeSignText( entSign, pPlayer )
	self:NewEvent( "ent", "lsgn_sndt" )
		net.WriteUInt( entSign:EntIndex(), 16 )
		net.WriteString( entSign:GetText() or "" )
	if pPlayer then self:FireEvent( pPlayer ) else self:BroadcastEvent() end
end

function GAMEMODE.Net:OpenLargeSignMenu( entSign, pPlayer )
	self:NewEvent( "ent", "lsgn_sm" )
		net.WriteEntity( entSign )
	self:FireEvent( pPlayer )
end

hook.Add( "GamemodeOnPlayerReady", "SendSigns", function( pPlayer )
	timer.Simple( 8, function()
		if not IsValid( pPlayer ) then return end
		for k, v in pairs( ents.FindByClass("ent_sign_large") ) do
			GAMEMODE.Net:NetworkLargeSignText( v, pPlayer )
		end
	end )
end )