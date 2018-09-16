--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/testmodels/macbook_pro.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:PhysWake()

	self.m_tblCoreApps = {}
	self.m_tblApps = {}
	self.m_tblStaticApps = {}
	for k, v in pairs( GAMEMODE.Apps:GetComputerApps() ) do
		if v.CoreApp then
			self.m_tblCoreApps[k] = v
		end
	end

	local hookID = ("UpdateLaptopApps_%p"):format( self )
	hook.Add( "GamemodePlayerSetJob", hookID, function( pPlayer )
		if not IsValid( self ) then hook.Remove( "GamemodePlayerSetJob", hookID ) return end
		if pPlayer == self:GetPlayerOwner() then
			self:RebuildAppList( pPlayer )
		end
	end )

	self:ChildInit()
end

function ENT:ChildInit()
end

function ENT:OnPlayerOwnerChanged( pLastOwner, pNewOwner )
	self:RebuildAppList( pNewOwner )
end

function ENT:RebuildAppList( pOwner )
	local apps = {}
	for k, v in pairs( self.m_tblCoreApps ) do
		apps[k] = v
	end

	--load the player's cloud os data and add saved apps to the core app list
	--update and inform current user if any

	if IsValid( pOwner ) then
		hook.Call( "GamemodeBuildPlayerComputerApps", GAMEMODE, pOwner, eEnt, apps )
	end
	
	if self.m_tblStaticApps then
		for k, v in pairs( self.m_tblStaticApps ) do
			apps[v] = GAMEMODE.Apps:GetComputerApps()[v]
		end
	end

	self.m_tblApps = apps

	if IsValid( self.m_pCurrentUser ) then
		GAMEMODE.Net:SendPlayerUseComputerEnt( self.m_pCurrentUser, self )
	end
end

function ENT:SetStaticApps( tblApps )
	self.m_tblStaticApps = tblApps
end

function ENT:GetInstalledApps()
	return self.m_tblApps
end

function ENT:SetJobsRequired( tblJobEnums )
	if not tblJobEnums then self.m_tblJobIDs = nil return end
	self.m_tblJobIDs = {}
	for k, v in pairs( tblJobEnums ) do
		self.m_tblJobIDs[v] = true
	end
end

function ENT:Use( pPlayer )
	if not IsValid( pPlayer ) or not pPlayer:IsPlayer() then return end
	if self.m_tblJobIDs and not self.m_tblJobIDs[GAMEMODE.Jobs:GetPlayerJobEnum(pPlayer)] then return end
	
	if IsValid( self.m_pCurrentUser ) then
		self:PlayerQuitComputer()
	end

	if not IsValid( self:GetPlayerOwner() ) and self.IsMapProp then
		self:RebuildAppList( pPlayer )
	end

	self.m_pCurrentUser = pPlayer
	pPlayer.m_entUsingComputer = self
	self:PlayerUseComputer()
end

function ENT:PlayerUseComputer()
	if not IsValid( self.m_pCurrentUser ) then self.m_pCurrentUser = nil return end
	if self.m_pCurrentUser:IsIncapacitated() then self.m_pCurrentUser = nil return end
	if self.m_pCurrentUser:GetPos():Distance( self:GetPos() ) > 150 then self.m_pCurrentUser = nil return end
	
	self.m_pCurrentUser:Freeze( true )
	GAMEMODE.Net:SendPlayerUseComputerEnt( self.m_pCurrentUser, self )
end

function ENT:PlayerQuitComputer()
	if not IsValid( self.m_pCurrentUser ) then self.m_pCurrentUser = nil return end
	self.m_pCurrentUser:Freeze( false )
	GAMEMODE.Net:SendPlayerQuitComputerEnt( self.m_pCurrentUser, self )
	self.m_pCurrentUser.m_entUsingComputer = nil
	self.m_pCurrentUser = nil
end

function ENT:Think()
	if not self.m_pCurrentUser or not IsValid( self.m_pCurrentUser ) then return end
	if self.m_pCurrentUser:GetPos():Distance( self:GetPos() ) > 150 or
		self.m_pCurrentUser:IsIncapacitated() or
		(self.m_tblJobIDs and not self.m_tblJobIDs[GAMEMODE.Jobs:GetPlayerJobEnum(self.m_pCurrentUser)]) then

		self:PlayerQuitComputer()
	else
		if IsValid( self.m_pCurrentUser:GetActiveWeapon() ) and self.m_pCurrentUser:GetActiveWeapon():GetClass() ~= "weapon_srphands" then
			self.m_pCurrentUser:SelectWeapon( "weapon_srphands" )
		end
	end
end


local pmeta = debug.getregistry().Player
function pmeta:IsUsingComputer()
	return IsValid( self.m_entUsingComputer )
end

function pmeta:GetActiveComputer()
	return self.m_entUsingComputer
end

-- Netcode
-- ----------------------------------------------------------------
GAMEMODE.Net:RegisterEventHandle( "ent", "comp_rquit", function( intMsgLen, pPlayer )
	if not pPlayer.m_entUsingComputer or not IsValid( pPlayer.m_entUsingComputer ) then return end
	pPlayer.m_entUsingComputer:PlayerQuitComputer()
end )

function GAMEMODE.Net:SendPlayerUseComputerEnt( pPlayer, entComputer )
	self:NewEvent( "ent", "comp_use" )
		net.WriteEntity( entComputer )
		net.WriteUInt( table.Count(entComputer.m_tblApps), 8 )
		for k, v in pairs( entComputer.m_tblApps ) do
			net.WriteString( k )
		end
	self:FireEvent( pPlayer )
end

function GAMEMODE.Net:SendPlayerQuitComputerEnt( pPlayer, entComputer )
	self:NewEvent( "ent", "comp_quit" )
		net.WriteEntity( entComputer )
	self:FireEvent( pPlayer )
end