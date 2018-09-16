--[[
	Name: remove_props.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "remove_props"
MapProp.m_tblSpawn = {}
MapProp.m_tblRemove = {
	--{ class = 'prop_door_rotating', pos = Vector('-9115.000000 10639.000000 343.000000') },

	--{ class = 'func_door_rotating', pos = Vector('-8656.000000 9679.990234 314.000000') },
	--{ class = 'func_door_rotating', pos = Vector('-8656.000000 9392.000000 314.000000') },

	--jail doors
	
	{ class = "prop_dynamic", pos = Vector('-7281.000000 10378.000000 -723.979980') },
	{ class = "prop_dynamic", pos = Vector('-7440.000000 10378.000000 -723.979980') },
	{ class = "prop_dynamic", pos = Vector('-7599.000000 10378.000000 -723.979980') },
	{ class = "prop_dynamic", pos = Vector('-7758.000000 10378.000000 -724.000000') },
	{ class = "prop_dynamic", pos = Vector('-7763.000000 10566.000000 -723.979980') },
	{ class = "prop_dynamic", pos = Vector('-7604.000000 10566.000000 -723.979980') },
	{ class = "prop_dynamic", pos = Vector('-7445.000000 10566.000000 -723.979980') },
	{ class = "prop_dynamic", pos = Vector('-7286.000000 10566.000000 -723.979980') },
	{ class = "prop_dynamic", pos = Vector('-7866.000000 10473.000000 -716.000000') },
	
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