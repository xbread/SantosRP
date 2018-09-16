--[[
	Name: clothing_store.lua
	For: santosrp
	By: santosrp
]]--

local MapProp = {}
MapProp.ID = "clothing_store"
MapProp.m_tblSpawn = {}

MapProp.m_tblMenuTriggers = {
	{ pos = Vector(1760, 3737, -13365), ang = Angle('-89 88 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
	{ pos = Vector(5169.540527, -3247.585693, 168.883133), ang = Angle('0 -90 0'), msg = "(Use) Purchase Clothing", menu = "clothing_items_store" },
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