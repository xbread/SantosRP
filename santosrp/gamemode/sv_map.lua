--[[
	Name: sv_map.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Map = {}
GM.Map.m_tblPropRegister = {}
GM.Map.m_tblNPCRegister = {}
GM.Map.m_tblMapProps = {}
GM.Map.m_tblGameNPCs = {}

function GM.Map:Load()
	self:LoadMapCode()
end

function GM.Map:Initialize()
	self:LoadMapProps()
	self:LoadMapNPCs()
end

function GM.Map:InitPostEntity()
	self:SpawnMapProps()
	self:SpawnNPCs()
end

--[[ Map props ]]--
function GM.Map:LoadMapProps()
	GAMEMODE:PrintDebug( 0, "->LOADING MAP PROPS" )

	local map = game.GetMap():gsub(".bsp", "")
	local path = GAMEMODE.Config.GAMEMODE_PATH.. "maps/".. map.. "/map_props/"

	local foundFiles, foundFolders = file.Find( path.. "*.lua", "LUA" )
	GAMEMODE:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GAMEMODE:PrintDebug( 0, "\tLoading ".. v )
		include( path.. v )
	end

	GAMEMODE:PrintDebug( 0, "->MAP PROPS LOADED" )
end

function GM.Map:RegisterMapProp( tblMapProp )
	self.m_tblPropRegister[tblMapProp.ID] = tblMapProp
end

function GM.Map:SpawnMapProps()
	for id, data in pairs( self.m_tblPropRegister ) do
		self.m_tblMapProps[id] = {}

		for _, propData in pairs( data.m_tblSpawn ) do
			local ent = ents.Create( "prop_physics" )
			ent:SetPos( propData.pos )
			ent:SetAngles( propData.ang )
			ent:SetModel( propData.mdl )
			ent:SetCollisionGroup( COLLISION_GROUP_NONE )
			ent:SetMoveType( MOVETYPE_NONE )
			ent.IsMapProp = true
			ent.MapPropID = id
			ent:Spawn()
			ent:Activate()
			ent:SetSaveValue( "fademindist", GAMEMODE.Config.DetailPropFadeMin )
			ent:SetSaveValue( "fademaxdist", GAMEMODE.Config.DetailPropFadeMax )

			local phys = ent:GetPhysicsObject()
			if IsValid( phys ) then
				phys:EnableMotion( false )
			end
		end

		if data.CustomSpawn then
			data:CustomSpawn()
		end
	end
end

function GM.Map:EntityTakeDamage( eEnt, pDamageInfo )
	if eEnt.IsMapProp then return true end
end

function GM.Map:PhysgunPickup( pPlayer, eEnt )
	if eEnt.IsMapProp then
		return false
	end
end

--[[ Map NPCs ]]--
function GM.Map:LoadMapNPCs()
	GAMEMODE:PrintDebug( 0, "->LOADING MAP NPCs" )

	local map = game.GetMap():gsub(".bsp", "")
	local path = GAMEMODE.Config.GAMEMODE_PATH.. "maps/".. map.. "/map_npcs/"

	local foundFiles, foundFolders = file.Find( path.. "*.lua", "LUA" )
	GAMEMODE:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GAMEMODE:PrintDebug( 0, "\tLoading ".. v )
		include( path.. v )
	end

	GAMEMODE:PrintDebug( 0, "->MAP NPCs LOADED" )
end

function GM.Map:RegisterNPCSpawn( tblNPC )
	self.m_tblNPCRegister[#self.m_tblNPCRegister +1] = tblNPC
end

function GM.Map:SpawnNPCs()
	for k, data in pairs( self.m_tblNPCRegister ) do
		local npcMeta = GAMEMODE.NPC:GetNPCMeta( data.UID )
		if not npcMeta then continue end
		
		for k, v in pairs( data.pos ) do
			local ent = ents.Create( "ent_npc_interactive" )
			ent:SetPos( v )
			ent:SetAngles( data.angs[k] )
			ent.UID = npcMeta.UID
			ent:SetNPCData( npcMeta )
			ent.IsMapProp = true
			ent:Spawn()
			ent:Activate()
			ent:SetModel( npcMeta.Model )
			table.insert( self.m_tblGameNPCs, ent )

			if npcMeta.OnSpawn then
				npcMeta:OnSpawn( ent )
			end
		end
	end
end

--[[ Map Code ]]--
function GM.Map:LoadMapCode()
	GM:PrintDebug( 0, "->LOADING MAP CODE" )

	local map = game.GetMap():gsub(".bsp", "")
	local path = GM.Config.GAMEMODE_PATH.. "maps/".. map.. "/map_code/"

	local foundFiles, foundFolders = file.Find( path.. "*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( path.. v )
		AddCSLuaFile( path.. v )
	end

	GM:PrintDebug( 0, "->MAP CODE LOADED" )
end