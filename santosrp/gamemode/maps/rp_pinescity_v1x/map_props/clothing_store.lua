--[[
	Name: clothing_store.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "clothing_store"
MapProp.m_tblSpawn = {}

MapProp.m_tblMenuTriggers = {
	--shop 1
	{ pos = Vector(-11304.031250, -12775.680664, 341.629822), ang = Angle('0 180 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(-11192.031250, -12840.033203, 341.629822), ang = Angle('0 180 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(-11591.968750, -12776.158203, 341.629822), ang = Angle('0 0 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(-11447.830078, -12807.968750, 341.629822), ang = Angle('0 90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(-11623.898438, -12919.968750, 341.629822), ang = Angle('0 90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(-11271.628906, -12919.968750, 341.629822), ang = Angle('0 90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },

	--shop 2
	{ pos = Vector(4255.968750, 12640.254883, 125.278244), ang = Angle('0 180 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(4367.968750, 12464.150391, 125.278244), ang = Angle('0 180 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(4367.968750, 12816.394531, 125.278244), ang = Angle('0 180 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(4223.704590, 12783.968750, 125.278244), ang = Angle('0 -90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(4287.943848, 12895.968750, 125.278244), ang = Angle('0 -90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(4224.327148, 12496.031250, 125.278244), ang = Angle('0 90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
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