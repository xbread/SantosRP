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
	if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= JOB_POLICE then return end
	GAMEMODE.Net:ShowNWMenu( pPlayer, "cop_police_locker" )
end

GAMEMODE.Net:RegisterEventHandle( "police", "get_locker_loadout", function( intMsgLen, pPlayer )
	local lockerEnt = pPlayer:GetEyeTrace().Entity
	if not IsValid( lockerEnt ) or lockerEnt:GetClass() ~= "ent_police_locker" then return end
	if pPlayer:GetPos():Distance( lockerEnt:GetPos() ) > 200 then return end

	for i = 1, net.ReadUInt( 16 ) do
		local itemName = net.ReadString()
		if not GAMEMODE.Inv:PlayerHasItem( pPlayer, itemName, GAMEMODE.Config.PoliceLockerItems[itemName] ) and not GAMEMODE.Inv:PlayerHasItemEquipped( pPlayer, itemName ) then
			local giveAmount = GAMEMODE.Config.PoliceLockerItems[itemName] -GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, itemName )
			GAMEMODE.Inv:GivePlayerItem( pPlayer, itemName, giveAmount )
		end
	end
end )