--[[
	Name: clothing_store.lua
	For: SantosRP
	By: Ultra
]]--

local MapProp = {}
MapProp.ID = "clothing_store"
MapProp.m_tblSpawn = {
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2345.402588 -3059.934814 109.607994'), ang = Angle('0.000 0.088 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2603.844482 -2966.632568 109.496979'), ang = Angle('0.000 -90.000 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2622.725830 -2960.240967 103.795334'), ang = Angle('0.000 0.000 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2352.467773 -3078.512695 103.698364'), ang = Angle('0.000 89.995 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2603.391113 -3075.550781 109.632820'), ang = Angle('0.000 -89.995 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2631.015869 -2979.372803 109.613655'), ang = Angle('0.000 89.995 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2622.679688 -3068.833496 103.817268'), ang = Angle('0.000 0.000 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2454.260498 -3059.744873 109.512169'), ang = Angle('0.000 0.000 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2611.432617 -2987.235596 103.684921'), ang = Angle('0.000 179.995 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2630.492676 -3088.356445 109.672638'), ang = Angle('0.000 90.000 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2434.479492 -3067.433105 103.490486'), ang = Angle('0.000 -89.995 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2611.458496 -3095.951172 103.706543'), ang = Angle('0.000 -179.995 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2326.201904 -3067.346680 103.723083'), ang = Angle('0.000 -90.000 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2332.715576 -3085.989258 109.560822'), ang = Angle('0.000 179.995 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2461.723389 -3078.586182 103.690659'), ang = Angle('0.000 90.000 0.000') },
	{ mdl = 'models/props/de_tides/vending_tshirt.mdl',pos = Vector('-2441.680664 -3086.506836 109.732529'), ang = Angle('0.000 -179.995 0.000') },
}

MapProp.m_tblMenuTriggers = {
	{ pos = Vector('-2719.968750 -2853.100098 140'), ang = Angle('0 0 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector('-2623.488525 -3186.968750 140'), ang = Angle('0 90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector('-2428.817627 -3186.968750 140'), ang = Angle('0 90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector('-2233.399658 -3186.968750 140'), ang = Angle('0 90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblMenuTriggers ) do
		local ent = ents.Create( "ent_menu_trigger" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
		ent:SetMenu( propData.menu )
		ent.IsMapProp = true
		ent:Spawn()
		ent:Activate()
		ent:SetText( propData.msg )
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )