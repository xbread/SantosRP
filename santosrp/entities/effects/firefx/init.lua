--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

local smokeMats = {
	"santosrp/effects/tornado_smoke",
	--"particle/smoke_black_smokestack001",
}

local fireMats = {
	--"santosrp/effects/perp2_flame.vtf",
	"santosrp/effects/fire_03.vtf",
	--"effects/fire_cloud1.vtf",
	--"effects/fire_cloud2.vtf",
}

local emberMats = {
	"effects/fire_embers1.vtf",
	"effects/fire_embers2.vtf",
	"effects/fire_embers3.vtf",
}

local function smokeCollide( part )
	part:SetCollide( false )
end

function EFFECT:Init( data )
	local emitter = ParticleEmitter( Vector(0) )

	for i = 1, 1 do
		local pos = data:GetOrigin() +Vector(math.Rand(-6,6), math.Rand(-6,6), 48)
		local particle = emitter:Add( table.Random(smokeMats), pos )

		particle:SetDieTime( math.Rand(1.5, 2) )
		particle:SetStartAlpha( 230 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random(32, 48) )
		particle:SetEndSize( 100 )
		particle:SetRoll( math.Rand(0, 10) )
		particle:SetRollDelta( math.Rand(-0.2, 0.2) )
		particle:SetVelocity( Vector(math.random(25,30),math.random(25,30), math.random(96, 140)) )
		particle:SetCollide( true )
		particle:SetCollideCallback( smokeCollide )
	end

	for i = 1, 2 do
		local pos = data:GetOrigin() +Vector(math.random(-28, 28), math.random(-28, 28), 0)
		local particle = emitter:Add( table.Random(fireMats), pos )
	
		particle:SetDieTime( math.Rand(2, 3) )
		particle:SetStartAlpha( 130 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random(74, 96) )
		particle:SetEndSize( 10 )
		particle:SetRoll( math.Rand(0, math.pi *2) )
		particle:SetRollDelta( math.Rand(0.5, 1) *(math.random(0,1) == 1 and 1 or -1) )
		particle:SetVelocity( Vector(math.random(-10,10),math.random(-10,10), math.random(10, 25)) )
	end

	--[[for i = 1, 1 do
		local pos = data:GetOrigin() +Vector(math.random(-32, 32), math.random(-32, 32), 70)
		local particle = emitter:Add( table.Random(emberMats), pos )

		particle:SetDieTime( math.Rand(4, 6) )
		particle:SetStartAlpha( 230 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random(2, 4) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand(0, 10) )
		particle:SetRollDelta( math.Rand(-0.2, 0.2) )
		particle:SetVelocity( Vector(math.random(20,35),math.random(20,35), math.random(65, 80)) )
	end]]--

	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end