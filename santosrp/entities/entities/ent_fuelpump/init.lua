--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props_equipment/gas_pump.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()

	local ent = ents.Create( "ent_fuelhose" )
	ent:SetPos( self.m_tblHoseSlots[1].pos )
	ent:SetAngles( self.m_tblHoseSlots[1].ang )
	ent:Spawn()
	ent:Activate()
	ent:SetOwner( self )
	ent:SetParent( self )
	self.m_entHose = ent
	self:DeleteOnRemove( ent )
end

function ENT:Use( pPlayer )
	local car = self.m_entHose:GetParent()
	if not IsValid( car ) or not car:IsVehicle() then return end
	
	if car:GetFuel() < car:GetMaxFuel() then
		local price = GAMEMODE.Econ:ApplyTaxToSum( "fuel", GAMEMODE.Config.BaseFuelCost )
		if pPlayer:CanAfford( price ) then
			car:AddFuel( 1 )
			pPlayer:TakeMoney( price )
			self.m_entHose:EmitSound( "ambient/water/water_spray1.wav", 70, 70 )
		else
			pPlayer:AddNote( "You can't afford to buy fuel!" )
		end
	else
		pPlayer:AddNote( "You already have a full tank of fuel." )
	end
end