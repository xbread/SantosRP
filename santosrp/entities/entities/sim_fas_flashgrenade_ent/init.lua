AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize

   This is the spawn function. It's called when a client calls the entity to be spawned.
   If you want to make your SENT spawnable you need one of these functions to properly create the entity.
   ply is the name of the player that is spawning it.
   tr is the trace from the player's eyes.
---------------------------------------------------------*/
function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create("sim_fas_flashgrenade_ent")
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	
	return ent
end


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	// Use the helibomb model just for the shadow (because it's about the same size)
	self:SetModel("models/weapons/w_eq_flashbang_thrown.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end

	self:SetUseType(SIMPLE_USE)
end