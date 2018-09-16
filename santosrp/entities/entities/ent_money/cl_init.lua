--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"
ENT.RenderGroup = RENDERGROUP_BOTH

local modelPos = {
	["models/props/cs_assault/dollar.mdl"] = { pos = Vector(-2, 1.15, 0.9), ang = Angle(0, 0, 0), scale = 0.0175 },
	["models/props/cs_assault/money.mdl"] = { pos = Vector(-3.25, 1.15, 0.9), ang = Angle(0, 0, 0), scale = 0.0175 },
	["models/props/cs_assault/moneypallet03e.mdl"] = { pos = Vector(-16, -32, 48), ang = Angle(0, 0, 90), scale = 0.066 },
	["models/props/cs_assault/moneypallet.mdl"] = { pos = Vector(-19, -32, 48), ang = Angle(0, 0, 90), scale = 0.066 },
}

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()

	local posData = modelPos[self:GetModel():lower()]
	if not posData then return end
	cam.Start3D2D( self:LocalToWorld(posData.pos), self:LocalToWorldAngles(posData.ang), posData.scale )
		surface.SetTextColor( 120, 230, 110, 255 )
		surface.SetFont( "SRP_DoorFont" )
		surface.SetTextPos( 0, 0 )
		surface.DrawText( "$".. string.Comma(self:GetMoney()) )
	cam.End3D2D()
end