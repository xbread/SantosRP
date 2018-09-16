ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= "Bobblehead"
ENT.Purpose			= "Stuff"

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "AttachedTo" )
	self:SetAttachedTo( NULL )

	if SERVER then
		self:NetworkVarNotify( "AttachedTo", self.AttachChanged )
	end
end

function ENT:CanPlayerDrag( pPlayer )
	return GAMEMODE.Jobs:GetPlayerJobID( pPlayer ) == JOB_TOW
end