--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

local waterFxEmitter = ParticleEmitter( Vector(0) )
local waterFxMats = {
	{ "effects/splash1" },
}

function EFFECT:Init( data )
	for i = 1, 16 do
		local pos = data:GetOrigin() +(VectorRand())
		local mat = table.Random( waterFxMats )
		local particle = waterFxEmitter:Add( mat[1], pos )

		particle:SetDieTime( math.Rand(5, 8) )
		particle:SetStartAlpha( 230 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand(0.5, 2) )
		particle:SetEndSize( math.random(8, 10) )
		particle:SetRoll( math.Rand(0, 10) )
		particle:SetRollDelta( math.Rand(-0.2, 0.2) )
		particle:SetVelocity( data:GetNormal() *math.random(32, 128) )
		particle:SetGravity( Vector(0, 0, -200) )
		particle:SetCollide( true )
		particle:SetColor( data:GetStart().x, data:GetStart().y, data:GetStart().z ) --hax
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end