--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

function GAMEMODE.Net:RequestMoveJobItemFromLocker( entLocker, strItemID, intAmount )
	self:NewEvent( "ent", "joblock_take" )
		net.WriteEntity( entLocker )
		net.WriteString( strItemID )
		net.WriteUInt( intAmount, 16 )
	self:FireEvent()
end

function GAMEMODE.Net:RequestMoveJobItemToLocker( entLocker, strItemID, intAmount )
	self:NewEvent( "ent", "joblock_add" )
		net.WriteEntity( entLocker )
		net.WriteString( strItemID )
		net.WriteUInt( intAmount, 16 )
	self:FireEvent()
end

GAMEMODE.Net:RegisterEventHandle( "ent", "joblock_upd", function( intMsgLen, pPlayer )
	hook.Call( "GamemodeRefreshJobLockerMenu", GAMEMODE )
end )