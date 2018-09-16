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

net.Receive( "ItemBox", function( intMsgLen )
	GAMEMODE.Gui:ShowItemBoxMenu( net.ReadEntity(), net.ReadTable() )
end )