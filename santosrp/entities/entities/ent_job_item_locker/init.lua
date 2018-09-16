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
	GAMEMODE.Net:ShowNWMenu( pPlayer, "job_item_locker" )
end

local function updatePlayer( pPlayer )
	GAMEMODE.Net:NewEvent( "ent", "joblock_upd" )
	GAMEMODE.Net:FireEvent( pPlayer )
end

GAMEMODE.Net:RegisterEventHandle( "ent", "joblock_take", function( intMsgLen, pPlayer )
	local locker = net.ReadEntity()
	if not IsValid( locker ) or locker:GetClass() ~= "ent_job_item_locker" then return end
	if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= locker:GetJobID() then return end
	if pPlayer:GetPos():Distance( locker:GetPos() ) > 200 then return end

	local itemName = net.ReadString()
	if not locker:GetItems()[itemName] then return end

	local itemNum = math.Clamp( net.ReadUInt(16), 0, locker:GetItems()[itemName] -GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, itemName ) )
	if itemNum <= 0 then return end
	
	if not GAMEMODE.Inv:PlayerHasItemEquipped( pPlayer, itemName ) then
		if GAMEMODE.Inv:GivePlayerItem( pPlayer, itemName, itemNum ) then
			updatePlayer( pPlayer )
		end
	end
end )

GAMEMODE.Net:RegisterEventHandle( "ent", "joblock_add", function( intMsgLen, pPlayer )
	local locker = net.ReadEntity()
	if not IsValid( locker ) or locker:GetClass() ~= "ent_job_item_locker" then return end
	if GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) ~= locker:GetJobID() then return end
	if pPlayer:GetPos():Distance( locker:GetPos() ) > 200 then return end

	local itemName = net.ReadString()
	if not locker:GetItems()[itemName] then return end

	local itemNum = math.Clamp( net.ReadUInt(16), 0, GAMEMODE.Inv:GetPlayerItemAmount(pPlayer, itemName) )
	if itemNum <= 0 then return end
	
	if GAMEMODE.Inv:TakePlayerItem( pPlayer, itemName, itemNum ) then
		updatePlayer( pPlayer )
	end
end )