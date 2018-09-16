--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

function GAMEMODE.Net:RequestTakePoliceLockerItems( tblItems )
	self:NewEvent( "police", "get_locker_loadout" )
		net.WriteUInt( table.Count(tblItems), 16 )

		for k, v in pairs( tblItems ) do
			net.WriteString( k )
		end
	self:FireEvent()
end