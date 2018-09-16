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
end

function ENT:DrawBar( intX, intY, intW, intH, colColor, intCur, intMax )
	surface.SetDrawColor( colBlack )
	surface.DrawRect( intX, intY, intW, intH )

	local padding = 1
	local tall = (intCur /intMax) *(intH -(padding *2))
	surface.SetDrawColor( colColor )
	surface.DrawRect( intX +padding, intY +padding, intW -(padding *2), tall )
end

function ENT:DrawTranslucent()
	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > (GAMEMODE.Config.RenderDist_Level1 ^2) then
		return
	end

	local camPos = self:LocalToWorld( Vector(6, 20, -4) )
	local camAng = self:LocalToWorldAngles( Angle(0, 180, -105) )
	local itemData = self:GetGrowingID() or ""
	itemData = GAMEMODE.Inv:GetItem( itemData )
	
	if itemData and itemData.DrugGrowthVars then
		camPos = self:LocalToWorld( Vector(7.75, 20, -4) )
	end
	
	cam.Start3D2D( camPos, camAng, 0.15 )
		local x, padding, barTall = 0, 5, 96
		self:DrawBar( x, 0, 16, barTall, Color(80, 60, 10, 255), self:GetDirt(), self.MaxDirt )
		x = x +16 +padding

		self:DrawBar( x, 0, 16, barTall, Color(50, 50, 255, 255), self:GetWater(), self.MaxWater )
		if itemData and itemData.DrugGrowthVars then
			local y = barTall *(itemData.DrugGrowthVars.WaterRequirement or 0)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawRect( x , y, 16, 1 )
		end

		x = x +16 +padding
		self:DrawBar( x, 0, 16, barTall, Color(180, 50, 255, 255), self:GetNutrients(), self.MaxNutrients )
		if itemData and itemData.DrugGrowthVars then
			local y = barTall *(itemData.DrugGrowthVars.NutrientRequirement or 0)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawRect( x , y, 16, 1 )
		end

		x = x +16 +padding
		self:DrawBar( x, 0, 16, barTall, Color(255, 255, 0, 255), self:GetLight(), self.MaxLight )
		if itemData and itemData.DrugGrowthVars then
			local y = barTall *(itemData.DrugGrowthVars.LightRequirement or 0)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawRect( x , y, 16, 1 )
		end

		if itemData and itemData.DrugGrowthVars then
			x = x +16 +padding
			self:DrawBar( x, 0, 16, barTall, Color(255, 50, 50, 255), self:GetPlantHealth(), itemData.DrugGrowthVars.PlantHealth or 100 )			
		end
	cam.End3D2D()
end