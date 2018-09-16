--[[
	Name: gas_pumps.lua
	For: SantosRP
	By: Ultra
]]--

local MapProp = {}
MapProp.ID = "gas_pumps"
MapProp.m_tblSpawn = {}

function MapProp:CustomSpawn()
	for k, v in pairs( ents.FindByModel("models/props_equipment/gas_pump.mdl") ) do
		local ent = ents.Create( "ent_fuelpump" )
		ent:SetPos( v:GetPos() )
		ent:SetAngles( v:GetAngles() )
		ent.IsMapProp = true
		ent:Spawn()
		ent:Activate()

		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end

		v:Remove()
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )