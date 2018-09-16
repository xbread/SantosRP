--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

local waterEmitter = ParticleEmitter( Vector(0) )
function EFFECT:Init( data )
	local pos = data:GetOrigin() +VectorRand() *0.1
	local particle = waterEmitter:Add( "effects/slime1", pos )

	particle:SetColor( 255, 255, 0 )
	particle:SetDieTime( 2 )
	particle:SetStartAlpha( 230 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random(3, 5) )
	particle:SetEndSize( math.random(5, 6) )
	particle:SetRoll( math.Rand(0, 10) )
	particle:SetRollDelta( math.Rand(-0.2, 0.2) )
	particle:SetVelocity( data:GetNormal() *150 )
	particle:SetGravity( Vector(0, 0, -600) )
	particle:SetCollide( true )
	particle:SetCollideCallback( function( _, vecPos, vecNorm )
		util.Decal( "BeerSplash", vecPos +vecNorm, vecPos -vecNorm )
	end )
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end