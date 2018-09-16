--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:Draw()
	self:DrawModel()
end

GAMEMODE.Net:RegisterEventHandle( "ent", "str_chst_o", function( intMsgLen, pPlayer )
	GAMEMODE.Gui:ShowStorageChestMenu( net.ReadEntity(), net.ReadTable() )
end )