--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

function GAMEMODE.Net:RequestUpdateJobClothing( intSkin, strModel, tblBodyGroups )
	self:NewEvent( "ent", "clth_lck_apply" )
		net.WriteUInt( intSkin, 8 )
		net.WriteString( strModel )
		net.WriteUInt( table.Count(tblBodyGroups), 8 )
		for k, v in pairs( tblBodyGroups ) do
			net.WriteUInt( k, 8 )
			net.WriteUInt( v, 8 )
		end
	self:FireEvent()
end