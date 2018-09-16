--[[
	Name: sv_entity.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Entity = {}

function GM.Entity:Dissolve( eEnt )
	if eEnt.m_bDissolving then return end
	if eEnt:IsPlayer() then return end
	eEnt.m_bDissolving = true

	local dissolver = ents.Create( "env_entity_dissolver" )
	dissolver:SetPos( eEnt:LocalToWorld(eEnt:OBBCenter()) )
	dissolver:SetKeyValue( "dissolvetype", 3 )
	dissolver:Spawn()
	dissolver:Activate()
	
	local name = "Dissolving_".. math.random()
	eEnt:SetName( name )
	dissolver:Fire( "Dissolve", name, 0 )
	dissolver:Fire( "Kill", eEnt, 0.10 )
end