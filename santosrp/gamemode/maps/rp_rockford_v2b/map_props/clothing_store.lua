--[[
	Name: clothing_store.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "clothing_store"
MapProp.m_tblSpawn = {}

MapProp.m_tblMenuTriggers = {
	{ pos = Vector(1759.966309, 4077.968750, 606.514526), ang = Angle('0 -90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(1679.929199, 4077.968750, 606.514526), ang = Angle('0 -90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(1599.954468, 4077.968750, 606.514526), ang = Angle('0 -90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },

	{ pos = Vector(1600.067627, 3730.031250, 606.514526), ang = Angle('0 90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(1680.604370, 3730.031250, 606.514526), ang = Angle('0 90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(1760.076538, 3735.031250, 606.514526), ang = Angle('0 90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
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