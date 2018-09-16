--[[
	Name: remove_props.lua
	For: santosrp
	By: GGS.SX
]]--

local MapProp = {}
MapProp.ID = "remove_props"

MapProp.m_tblSpawn = {}

MapProp.m_tblRemove = {
	-- prop_physics
	{ class = 'prop_physics', pos = Vector('278.000000 4118.000000 -13345.281250') },
	{ class = 'prop_physics', pos = Vector('-13930.000000 2806.000000 -13497.281250') },
	{ class = 'prop_physics', pos = Vector('-13930.000000 2474.000000 -13497.281250') },
	{ class = 'prop_physics', pos = Vector('-13930.000000 2474.000000 -13497.281250') },
	{ class = 'prop_physics', pos = Vector('278.000000 3786.000000 -13345.281250') },
	{ class = 'prop_physics', pos = Vector('298.000000 3786.000000 -13345.281250') },
	{ class = 'prop_physics', pos = Vector('298.000000 4118.000000 -13345.281250') },
	{ class = 'prop_physics', pos = Vector('278.000000 4118.000000 -13345.281250') },
	{ class = 'prop_dynamic', pos = Vector('-13910.000000 2806.000000 -13497.281250') },
	{ class = 'prop_dynamic', pos = Vector('-13930.000000 2806.000000 -13497.281250') },
	{ class = 'prop_dynamic', pos = Vector('-13930.000000 2474.000000 -13497.281250') },
	{ class = 'prop_dynamic', pos = Vector('-13910.000000 2474.000000 -13497.281250') },
	{ class = 'prop_dynamic', pos = Vector('298.000000 3786.000000 -13345.281250') },
	{ class = 'prop_dynamic', pos = Vector('278.000000 3786.000000 -13345.281250') },
	{ class = 'prop_dynamic', pos = Vector('278.000000 4118.000000 -13345.281250') },
	{ class = 'prop_dynamic', pos = Vector('298.000000 4118.000000 -13345.281250') },
}

function MapProp:CustomSpawn()
	for k, v in pairs( self.m_tblRemove ) do
		for _, ent in pairs( ents.FindInSphere(v.pos, 5) ) do
			if v.mdl then
				if ent:GetModel() == v.mdl then ent:Remove() end
			elseif v.class then
				if ent:GetClass() == v.class then ent:Remove() end
			end
		end
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )