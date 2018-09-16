--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

local fireMats = {
	"effects/fire_cloud1.vtf",
	"effects/fire_cloud2.vtf",
}

function EFFECT:Init( data )
	local emitter = ParticleEmitter( Vector(0) )

	for i = 1, 3 do
		local pos = data:GetOrigin() +Vector(math.Rand(-0.15, 0.15), math.Rand(-0.15, 0.15), 0)
		local particle = emitter:Add( table.Random(fireMats), pos )
	
		particle:SetDieTime( math.Rand(0.33, 0.65) )
		particle:SetStartAlpha( 130 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand(1.66, 2) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand(0, math.pi *2) )
		particle:SetRollDelta( math.Rand(0.5, 1) *(math.random(0,1) == 1 and 1 or -1) )
		particle:SetVelocity( Vector(math.random(-1,1),math.random(-1,1), math.random(4, 6)) )
	end

	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end