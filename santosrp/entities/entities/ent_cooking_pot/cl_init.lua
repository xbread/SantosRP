--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

local colBlack = Color( 0, 0, 0, 255 )
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
end

function ENT:OnRemove()
	g_CookingPotNetVars[self:EntIndex()] = nil
end

function ENT:Think()
	if CurTime() > (self.m_intLastVarCheck or 0) then
		if not g_CookingPotNetVars[self:EntIndex()] then
			net.Start( "CookingPot" )
				net.WriteUInt( self:EntIndex(), 32 )
			net.SendToServer()

			self.m_intLastVarCheck = CurTime() +3
		else
			self.m_intLastVarCheck = CurTime() +1
		end
	end
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawBar( intX, intY, intW, intH, colColor, intCur, intMax )
	surface.SetDrawColor( colBlack )
	surface.DrawRect( intX, intY, intW, intH )

	local padding = 1
	local wide = (intCur /intMax) *(intW -(padding *2))
	surface.SetDrawColor( colColor )
	surface.DrawRect( intX +padding, intY +padding, wide, intH -(padding *2) )
end

function ENT:DrawTranslucent()
	if not g_CookingPotNetVars[self:EntIndex()] then return end
	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > GAMEMODE.Config.RenderDist_Level1 ^2 then
		return
	end

	--Fluid Amount
	local camPos = self:LocalToWorld( Vector(0, 0, 9) )
	local camAng = self:LocalToWorldAngles( Angle(0, 0, 90) )
	cam.Start3D2D( camPos, camAng, 0.05 )
		local y = 0
		local barWide = 350

		--cooking time bar
		local data = GAMEMODE.Inv:GetItem( self:GetItemID() or "" )
		if data and self:GetProgress() > 0 then
			local time = self:GetProgress()
			self:DrawBar( -(barWide /2), y, barWide, 32, Color(255, 50, 50, 255), time, self.MaxCookingTime )

			draw.SimpleText(
				GAMEMODE.Util:FormatTime( time ),
				"DermaLarge",
				-(barWide /2) +5,
				y,
				Color( 255, 255, 255, 255 ),
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_LEFT
			)

			y = y -32 -5
		end

		for k, v in pairs( g_CookingPotNetVars[self:EntIndex()].Fluids ) do
			self:DrawBar( -(barWide /2), y, barWide, 32, Color(255, 50, 50, 255), v, self.MaxFluidAmount )
			draw.SimpleText(
				k.. " (".. v.. "ml/".. self.MaxFluidAmount.. "ml)",
				"Trebuchet24",
				-(barWide /2) +5,
				y +3,
				Color( 255, 255, 255, 255 ),
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_LEFT
			)
			y = y -32 -5
		end

		for k, v in pairs( g_CookingPotNetVars[self:EntIndex()].Items ) do
			self:DrawBar( -(barWide /2), y, barWide, 32, Color(255, 50, 50, 255), v, self.MaxItemAmount )
			draw.SimpleText(
				k.. " (".. v.. "/".. self.MaxItemAmount.. ")",
				"Trebuchet24",
				-(barWide /2) +5,
				y +3,
				Color( 255, 255, 255, 255 ),
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_LEFT
			)
			y = y -32 -5
		end
	cam.End3D2D()
end

g_CookingPotNetVars = g_CookingPotNetVars or {}
net.Receive( "CookingPot", function( intMsgLen )
	local entIndex = net.ReadUInt( 32 )
	
	local numFluids = net.ReadUInt( 8 )
	local fluids = {}
	for i = 1, numFluids do
		fluids[net.ReadString()] = net.ReadUInt( 16 )
	end

	local numItems = net.ReadUInt( 8 )
	local items = {}
	for i = 1, numItems do
		items[net.ReadString()] = net.ReadUInt( 8 )
	end
	
	g_CookingPotNetVars[entIndex] = {
		Fluids = fluids,
		Items = items,
	}
end )