AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel("models/myproject/SpikeStrip001.mdl")
	
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	self:DrawShadow(false)
	
	self:SetNWBool("deployed", true)
	
	self.ActiveTime = CurTime()
	self.AdminPhysGun = true
end

function ENT:RemoveSpikes()
	self:SetNWBool("deployed", false)
	timer.Simple(1, function()
		self:Remove()
		self = nil
	end)
end

function ENT:Think(ent)
	if(not self.OwnerID) then self:Remove() return end
	local bRemove = true
	for k, v in pairs(player.GetAll()) do
		if(v:SteamID() == self.OwnerID) then
			bRemove = false
		end
	end
	if(bRemove) then self:Remove() return end
	
	local tr = {}
	tr.start = self:GetPos() + self:OBBMins() + Vector(0, 0, 20)
	tr.endpos = self:GetPos() + self:OBBMaxs() + Vector(0, 0, 20)
	tr.filter = {self}
	local tr = util.TraceLine(tr)
	local ent = tr.Entity
	
	local tr2 = {}
	tr2.start = self:GetPos() + self:OBBMins() + Vector(0, 0, 50)
	tr2.endpos = self:GetPos() + self:OBBMaxs() + Vector(0, 0, 50)
	tr2.filter = {self}
	local tr2 = util.TraceLine(tr2)
	local ent2 = tr2.Entity
	
	local objEnt = NULL
	
	if(IsValid(ent2) and ent2:IsVehicle()) then
		objEnt = ent
	elseif(IsValid(ent) and ent:IsVehicle()) then
		objEnt = ent
	end
	
	if(not IsValid(objEnt) ) then return end
	
	if(self.ActiveTime + 0.66 > CurTime()) then return end
	
	if(objEnt:IsVehicle() and objEnt:GetVelocity():Length() > 5 and objEnt:GetDriver():IsValid() and not objEnt.TiresBroken) then
		objEnt:EmitSound("weapons/flaregun/fire.wav")
		objEnt.TiresBroken = true

		local oldSteering = objEnt:GetSteeringDegrees()
		objEnt:SetSteeringDegrees( 15 )
		objEnt:SetMaxThrottle( 0.25 )
		objEnt:SetMaxReverseThrottle( 0.25 )

		timer.Simple( 120, function()
			if not IsValid( objEnt ) then return end
			objEnt:SetSteeringDegrees( oldSteering )
			objEnt:SetMaxReverseThrottle( -1 )
			objEnt:SetMaxThrottle( 1 )
			objEnt.TiresBroken = false
		end )
	end
end