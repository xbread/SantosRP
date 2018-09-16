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

	for k, v in pairs( ents.GetAll() ) do
		if v:GetModel() == "models/statua/shell/shellpump1.mdl" then
			v:Remove()
		end
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )