--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

local valueModels = {
	{ [0] = "models/props/cs_assault/Dollar.mdl" },
	{ [100] = "models/props/cs_assault/Money.mdl" },
	{ [100000] = "models/props/cs_assault/MoneyPallet03E.mdl" },
	{ [1000000] = "models/props/cs_assault/MoneyPallet.mdl" },
}

function ENT:Initialize()
	self:SetUseType( SIMPLE_USE )
end

function ENT:SpawnFunction( pPlayer )
	local spawnPos = util.TraceLine{
		start = pPlayer:GetShootPos(),
		endpos = pPlayer:GetShootPos() +pPlayer:GetAimVector() *150,
		filter = pPlayer,
	}.HitPos

	return spawnPos +Vector(0, 0, 0)
end

function ENT:SetAmount( intAmount )
	local model = valueModels[0]

	for _, tbl in ipairs( valueModels ) do
		for k, v in pairs( tbl ) do
			if k <= intAmount then
				model = v
			end
			
			break
		end
	end

	self:SetModel( model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetMoney( intAmount )
end

function ENT:Use( pPlayer )
	pPlayer:AddMoney( self:GetMoney() )
	pPlayer:AddNote( "You picked up $".. string.Comma(self:GetMoney()) ) 
	self:Remove()
end