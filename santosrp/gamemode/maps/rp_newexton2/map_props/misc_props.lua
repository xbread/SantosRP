--[[
	Name: misc_props.lua
	For: SantosRP
	By: Heavy Bob - GGS.SX
]]--

local MapProp = {}
MapProp.ID = "misc_props"
MapProp.m_tblSpawn = {
{ mdl = 'models/heracles421/bob_customs/bobcustoms.mdl',pos = Vector('-2112.329346 -2303.243652 263.676239'), ang = Angle('0.000 90 0.000') },
}

GAMEMODE.Map:RegisterMapProp( MapProp )