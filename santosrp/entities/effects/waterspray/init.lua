--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

local waterEmitter = ParticleEmitter( Vector(0) )
function EFFECT:Init( data )
	local time = CurTime()

	for i = 1, 6 do
		local pos = data:GetOrigin() +VectorRand() *4
		local particle = waterEmitter:Add( "effects/splash1", pos )

		particle:SetDieTime( 2 )
		particle:SetStartAlpha( 230 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand(4, 5) )
		particle:SetEndSize( math.Rand(8, 10) )
		particle:SetRoll( math.Rand(0, 10) )
		particle:SetRollDelta( math.Rand(-0.2, 0.2) )
		particle:SetVelocity( data:GetNormal() *1024 )
		particle:SetGravity( Vector(0, 0, -66) )
		particle:SetCollide( true )
		particle:SetColor( 237, 250, 250 )
		particle:SetCollideCallback( function( p )
			p:SetDieTime( (CurTime() -time) +0.33 )
			p:SetEndSize( 8 )
		end )
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end