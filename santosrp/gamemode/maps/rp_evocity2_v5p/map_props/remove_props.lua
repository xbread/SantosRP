--[[
	Name: remove_props.lua
	For: SantosRP
	By: Ultra
]]--

local MapProp = {}
MapProp.ID = "remove_props"
MapProp.m_tblSpawn = {}
MapProp.m_tblRemove = {
	{ mdl = 'models/u4lab/chair_office_a.mdl', pos = Vector('-663.865845 -1715.992676 -403.239410'), ang = Angle('0.357 0.000 0.005') },
	{ mdl = 'models/u4lab/chair_office_a.mdl', pos = Vector('-665.944702 -1652.008057 -403.277527'), ang = Angle('0.132 0.000 -0.005') },
	{ mdl = 'models/props_wasteland/controlroom_desk001b.mdl', pos = Vector('-625.833252 -1683.997192 -411.125702'), ang = Angle('-0.335 -179.725 -0.038') },
	{ mdl = 'models/props/cs_office/chair_office.mdl', pos = Vector('-178.470001 -1344.979980 468.281006'), ang = Angle('-0.335 -179.725 -0.038') },

	{ class = 'func_button', pos = Vector('-2888.000000 3471.510010 132.990005') },
	{ class = 'func_button', pos = Vector('-2664.000000 3471.510010 132.990005') },
	{ class = 'func_button', pos = Vector('-2879.000000 3091.510010 132.990005') },
	{ class = 'func_button', pos = Vector('-2451.000000 3091.510010 132.990005') },
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