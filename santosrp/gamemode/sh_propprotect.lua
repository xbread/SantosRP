--[[
	Name: sh_propprotect.lua
	For: santosrp
	By: santosrp
]]--

GM.PropProtect = (GAMEMODE or GM).PropProtect or {}

local emeta = debug.getregistry().Entity
GM.PropProtect.m_tblOwners = (GAMEMODE or GM).PropProtect.m_tblOwners or {}

if SERVER then
	GM.PropProtect.m_tblMapProps = (GAMEMODE or GM).PropProtect.m_tblMapProps or {}

	local BlockedEntities = {"func_breakable", "func_physbox", "prop_door_rotating", "prop_dynamic", "ent_money", "gmod_sw_door", "prop_vehicle_pod", "texstickers_carplate", "type_drug", "lithium_obsidian_printer", "npc_lsd_dealer", "sent_base_lsd", "ent_coffee_maker", "lithium_donator_printer", "ent_fire", "savedprop", "env_sun", "gmod_sent", "jukebox", "casinokit_machine", "casinokit_seat", "casinokit_dealernpc", "casinokit_slot_fruits", "casinokit_slot_videobj", "casinokit_slot_videopoker", "casinokit_roulette", "casinokit_craps", "casinokit_blackjack", "sent_arc_slotmachine"}

	function GM.PropProtect:PhysgunPickup( pPlayer, eEnt )
		if GAMEMODE.PropProtect.m_tblMapProps[eEnt] then
			return false
		end

		if table.HasValue( BlockedEntities, eEnt:GetClass() ) then return false end

		if eEnt.BlockPhysGun then return false end
		if eEnt.AdminPhysGun then
			if not pPlayer:IsSuperAdmin() and not pPlayer:IsAdmin() then
				return false
			end
			
			return true
		end

		if eEnt:IsPlayer() and not pPlayer:IsSuperAdmin() then return false end

		if IsValid( eEnt:GetPlayerOwner() ) then
			if eEnt:GetPlayerOwner() ~= pPlayer and not GAMEMODE.Buddy:IsItemShared( pPlayer, eEnt:GetPlayerOwner() ) and not pPlayer:IsSuperAdmin() then
				return false
			end

			if eEnt:GetPlayerOwner():IsSuperAdmin() and not pPlayer:IsSuperAdmin() then return false end
		end

		return true
	end

	function GM.PropProtect:GravGunPickupAllowed( pPlayer, eEnt )
		if GAMEMODE.PropProtect.m_tblMapProps[eEnt] then
			return false
		end

		if eEnt.BlockPhysGun then return false end
		if eEnt.AdminPhysGun then
			if not pPlayer:IsSuperAdmin() and not pPlayer:IsAdmin() and not pPlayer:GetUserGroup() == "moderator" then
				return false
			end
			
			return
		end

		
		if eEnt:IsPlayer() and not pPlayer:IsSuperAdmin() then return false end
		
		if IsValid( eEnt:GetPlayerOwner() ) then
			if eEnt:GetPlayerOwner() ~= pPlayer and not GAMEMODE.Buddy:IsItemShared( pPlayer, eEnt:GetPlayerOwner() ) then
				return false
			end
		end

		return true
	end

	function GM.PropProtect:PlayerUse( pPlayer, eEnt )
		if IsValid( eEnt:GetPlayerOwner() ) and eEnt:GetClass() ~= "whk_tv" then
			if eEnt:IsVehicle() then
				if eEnt.IsLocked then return true end
			else
				if eEnt:GetPlayerOwner() ~= pPlayer and not GAMEMODE.Buddy:IsItemShared( pPlayer, eEnt:GetPlayerOwner() ) then
					if eEnt.CanPlayerUse then
						if eEnt.CanPlayerUse and not eEnt:CanPlayerUse( pPlayer ) then
							return true
						end
					else
						return true
					end
				else
					if eEnt.CanPlayerUse and not eEnt:CanPlayerUse( pPlayer ) then
						return true
					end
				end
			end
		else
			if eEnt.CanPlayerUse and not eEnt:CanPlayerUse( pPlayer ) then
				return true
			end
		end
	end

	function GM.PropProtect:InitPostEntity()
		for k, v in pairs( ents.GetAll() ) do
			GAMEMODE.PropProtect.m_tblMapProps[v] = true
		end
	end

	function GM.PropProtect:PlayerDisconnected( eEnt )
		if eEnt.m_bMapCleaned then return end
		local clearedLostAndFound = false
		
		for k, v in pairs( ents.GetAll() ) do
			if v:GetPlayerOwner() == eEnt then
				if not IsValid( v ) then continue end

				if v.IsItem then
					if v.CanSendToLostAndFound then
						if v:CanSendToLostAndFound() then
							if not clearedLostAndFound then
								GAMEMODE.BankStorage:ClearLostAndFound( eEnt, true )
								clearedLostAndFound = true
							end

							if v.OnAddToLostAndFound then
								v:OnAddToLostAndFound( eEnt )
							end
							
							GAMEMODE.BankStorage:AddToLostAndFound( eEnt, v.ItemID, 1, true, true )
						end
					else
						if not clearedLostAndFound then
							GAMEMODE.BankStorage:ClearLostAndFound( eEnt, true )
							clearedLostAndFound = true
						end

						if v.OnAddToLostAndFound then
							v:OnAddToLostAndFound( eEnt )
						end

						GAMEMODE.BankStorage:AddToLostAndFound( eEnt, v.ItemID, 1, true, true )
					end					
				end

				v:Remove()
			elseif v.CreatedBySID and v.CreatedBySID == eEnt:SteamID() then
				v:Remove()
			end
		end

		eEnt.m_bMapCleaned = true
	end

	function GM.PropProtect:PlayerDisconnectedGameEvent( strSID64 )
		local pl = player.GetBySteamID64( strSID64 )
		if IsValid( pl ) and not pl.m_bMapCleaned then
			self:PlayerDisconnected( pl )
		end

		GAMEMODE.BankStorage:CommitLostAndFound( strSID64 )
	end
	
	function GM.PropProtect:EntityRemoved( eEnt )
		if eEnt:IsPlayer() and not eEnt.m_bMapCleaned then
			self:PlayerDisconnected( eEnt )
		end

		if GAMEMODE.PropProtect.m_tblOwners[eEnt:EntIndex()] then
			eEnt:SetPlayerOwner( NULL )
		end
	end
	
	function emeta:SetPlayerOwner( pPlayer )
		local last = GAMEMODE.PropProtect.m_tblOwners[self:EntIndex()]
		GAMEMODE.PropProtect.m_tblOwners[self:EntIndex()] = pPlayer
		GAMEMODE.Net:SendEntityOwner( nil, self ) --Broadcast this to all players

		if self.OnPlayerOwnerChanged then
			self:OnPlayerOwnerChanged( last, pPlayer )
		end
	end

	local entsPerMsg = 768
	--This player just joined and is ready for game info, send them a full update of all entity owners
	hook.Add( "GamemodeOnPlayerReady", "StreamEntityOwners", function( pPlayer )
		local sendBuffer = {}

		--There could be a very large amount of ents with owners
		--It might not ever exceed the net message max size, but fuck it, split it cause reasons
		local count, packet = 0, 1
		for k, v in pairs( ents.GetAll() ) do
			if not IsValid( v:GetPlayerOwner() ) then continue end
			if not sendBuffer[packet] then sendBuffer[packet] = {} end
			
			count = count +1
			table.insert( sendBuffer[packet], v )

			if count >= entsPerMsg then
				count = 0
				packet = packet +1
			end
		end

		for i = 1, packet do
			GAMEMODE.Net:SendEntityOwners( pPlayer, sendBuffer[i] )
		end
	end )
end

function emeta:GetPlayerOwner()
	return GAMEMODE.PropProtect.m_tblOwners[self:EntIndex()]
end

function GM:GetEntityOwnerTable()
	return GAMEMODE.PropProtect.m_tblOwners
end

hook.Add( "EntityRemoved", "UnrefOwner", function( eEnt )
	GAMEMODE.PropProtect.m_tblOwners[eEnt:EntIndex()] = nil
end )