if SERVER then AddCSLuaFile() end

ENT.Base = "ent_computer_base"
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:ChildInit()
	if SERVER then
		self:SetModel( "models/testmodels/macbook_pro.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:PhysWake()
	end

	if CLIENT and ValidPanel( self.m_pnlMenu ) then
		self.m_pnlMenu:SetWallpaper( "nomad/computer/wp_doj.png" )
	end
end