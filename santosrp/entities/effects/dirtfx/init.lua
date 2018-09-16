--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

local dirtEmitter = ParticleEmitter( Vector(0) )
local dirtMats = {
	{ "particle/particle_debris_01", Color(255, 255, 255, 255) },
	{ "particle/particle_debris_02", Color(255, 255, 255, 255) },
	{ "particle/particle_smokegrenade", Color(80, 60, 10, 255) },
	{ "particle/particle_smokegrenade", Color(80, 60, 10, 255) },
	{ "particle/particle_smokegrenade", Color(80, 60, 10, 255) },
}

function EFFECT:Init( data )
	for i = 1, 16 do
		local pos = data:GetOrigin() +VectorRand() *4
		local mat = table.Random( dirtMats )
		local particle = dirtEmitter:Add( mat[1], pos )

		particle:SetColor( mat[2] )
		particle:SetDieTime( math.Rand(5, 8) )
		particle:SetStartAlpha( 230 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random(4, 8) )
		particle:SetEndSize( math.random(8, 10) )
		particle:SetRoll( math.Rand(0, 10) )
		particle:SetRollDelta( math.Rand(-0.2, 0.2) )
		particle:SetVelocity( data:GetNormal() *math.random(32, 128) )
		particle:SetGravity( Vector(0, 0, -250) )
		particle:SetCollide( true )
		particle:SetColor( data:GetStart().x, data:GetStart().y, data:GetStart().z ) --hax
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end