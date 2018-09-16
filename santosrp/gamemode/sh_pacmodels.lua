--[[
	Name: sh_pacmodels.lua
	For: TalosLife
	By: TalosLife
]]--

GM.PacModels = (GAMEMODE or GM).PacModels or {}
GM.PacModels.m_tblModels = (GAMEMODE or GM).PacModels.m_tblModels or {}
GM.PacModels.m_tblModelOverloads = (GAMEMODE or GM).PacModels.m_tblModelOverloads or {}
GM.PacModels.m_tblModelOverloadFaceIDs = (GAMEMODE or GM).PacModels.m_tblModelOverloadFaceIDs or {}

function GM.PacModels:Register( strModelName, tblModelData )
	self.m_tblModels[strModelName] = tblModelData
end

function GM.PacModels:GetModel( strModelName )
	return self.m_tblModels[strModelName]
end

function GM.PacModels:ValidModel( strModelName )
	return self.m_tblModels[strModelName] and true
end

--Use to register outfits that overload other outfits when worn on certain models
function GM.PacModels:RegisterOutfitModelOverload( strPACModelName, varModelName, strPACOverloadName, bTableValues )
	self.m_tblModelOverloads[strPACModelName] = self.m_tblModelOverloads[strPACModelName] or {}

	if type( varModelName ) == "string" then
		self.m_tblModelOverloads[strPACModelName][strModelName] = strPACOverloadName
	else
		for k, v in pairs( varModelName ) do
			self.m_tblModelOverloads[strPACModelName][bTableValues and v or k] = strPACOverloadName
		end
	end
end

--Will overload if the faceids from the player model match
function GM.PacModels:RegisterOutfitFaceIDOverload( strPACModelName, varFaceID, strPACOverloadName, bTableValues )
	self.m_tblModelOverloadFaceIDs[strPACModelName] = self.m_tblModelOverloadFaceIDs[strPACModelName] or {}

	if type( varFaceID ) == "string" then
		self.m_tblModelOverloadFaceIDs[strPACModelName][varFaceID] = strPACOverloadName
	else
		for k, v in pairs( varFaceID ) do
			self.m_tblModelOverloadFaceIDs[strPACModelName][bTableValues and v or k] = strPACOverloadName
		end
	end
end

--Will return an outfit overload if the given model has one, otherwise is the same as GetModel()
function GM.PacModels:GetOutfitForModel( strPACModelName, strModelName )
	if not self.m_tblModelOverloads[strPACModelName] then
		if self.m_tblModelOverloadFaceIDs[strPACModelName] then
			local overload = self.m_tblModelOverloadFaceIDs[strPACModelName][GAMEMODE.Util:GetModelFaceID(strModelName) or ""]
			if overload then
				return self:GetModel( overload )
			end
		end

		return self:GetModel( strPACModelName )
	end

	if self.m_tblModelOverloads[strPACModelName][strModelName] then
		return self:GetModel( self.m_tblModelOverloads[strPACModelName][strModelName] )
	else
		if self.m_tblModelOverloadFaceIDs[strPACModelName] then
			local overload = self.m_tblModelOverloadFaceIDs[strPACModelName][GAMEMODE.Util:GetModelFaceID(strModelName) or ""]
			if overload then
				return self:GetModel( overload )
			end
		end
		
		return self:GetModel( strPACModelName )
	end
end

if CLIENT then
	CreateClientConVar( "srp_pac_drawrange", (GM or GAMEMODE).Config.RenderDist_Level2, true, false )
	cvars.AddChangeCallback( "srp_pac_drawrange", function( _, _, val )
		for k, v in pairs( player.GetAll() ) do
			if not v.SetPACDrawDistance then continue end
			v:SetPACDrawDistance( GetConVarNumber("srp_pac_drawrange") )
		end
	end )

	function GM.PacModels:InvalidatePlayerOutfits( pPlayer, entWepSwitchTo )
		for k, v in pairs( pPlayer.pac_parts or {} ) do
			v:Remove()
		end

		if not pPlayer.AttachPACPart then
			pac.SetupENT( pPlayer )
			if pPlayer.SetPACDrawDistance then
				pPlayer:SetPACDrawDistance( GetConVarNumber("srp_pac_drawrange") )
			end
			pPlayer.m_tblEquipPACOutfits = {}
		end

		if pPlayer.m_tblEquipPACOutfits then
			for name, data in pairs( GAMEMODE.Inv.m_tblEquipmentSlots ) do
				local pdata = pPlayer.m_tblEquipPACOutfits[name] or {}
				if not pPlayer.m_tblEquipPACOutfits[name] then pPlayer.m_tblEquipPACOutfits[name] = pdata end

				if data.Type == "GAMEMODE_INTERNAL_PAC_ONLY" then
					local outfitID = GAMEMODE.Player:GetSharedGameVar( pPlayer, "eq_slot_".. name ) or ""
					if outfitID == "" then
						pdata.CurPacPart = nil
					else
						pdata.CurPacPart = GAMEMODE.PacModels:GetOutfitForModel( outfitID, pPlayer:GetModel() )
					end
				else
					local item = GAMEMODE.Inv:GetItem( GAMEMODE.Player:GetSharedGameVar(pPlayer, "eq_slot_".. name) or "" )
					if item and item.PacOutfit then
						--if item.EquipSlot == "PrimaryWeapon" or item.EquipSlot == "SecondaryWeapon" or item.EquipSlot == "AltWeapon" then
						--	if IsValid( entWepSwitchTo ) and entWepSwitchTo:GetClass() == item.EquipGiveClass then
						--		pdata.CurPacPart = nil
						--	else
						--		pdata.CurPacPart = GAMEMODE.PacModels:GetOutfitForModel( item.PacOutfit, pPlayer:GetModel() )
						--	end
						--else
							pdata.CurPacPart = GAMEMODE.PacModels:GetOutfitForModel( item.PacOutfit, pPlayer:GetModel() )
						--end
					else
						pdata.CurPacPart = nil
					end
				end
				
				if pdata.CurPacPart then
					pPlayer:AttachPACPart( pdata.CurPacPart, nil, true )
				end
			end
		end
	end

	function GM.PacModels:PlayerSwitchWeapon( pPlayer, entOldWep, entNewWep )
		--[[if not pPlayer.AttachPACPart then
			pac.SetupENT( pPlayer )
			pPlayer:SetPACDrawDistance( GetConVarNumber("srp_pac_drawrange") )
		end

		local invalid
		for slotName, _ in pairs( GAMEMODE.Inv.m_tblEquipmentSlots ) do
			item = GAMEMODE.Inv:GetItem( GAMEMODE.Player:GetSharedGameVar(pPlayer, "eq_slot_".. slotName, "") )
			if not item or not item.PacOutfit then continue end
			if not IsValid( entOldWep ) or not IsValid( entNewWep ) then continue end
			if item.EquipGiveClass == entOldWep:GetClass() or item.EquipGiveClass == entNewWep:GetClass() then
				invalid = true
				break
			end
		end

		if invalid then
			self:InvalidatePlayerOutfits( pPlayer, entNewWep )
		end]]--
	end
	
	function GM.PacModels:UpdatePlayers()
		if not self.m_intLastThink then self.m_intLastThink = CurTime() +0.1 end
		if self.m_intLastThink > CurTime() then return end
		self.m_intLastThink = CurTime() +0.1

		local ragdoll, item
		for k, v in pairs( player.GetAll() ) do
			--Track active weapon
			if not v.m_entLastActiveWeapon then
				v.m_entLastActiveWeapon = v:GetActiveWeapon()
			else
				if v:GetActiveWeapon() ~= v.m_entLastActiveWeapon then
					self:PlayerSwitchWeapon( v, v.m_entLastActiveWeapon, v:GetActiveWeapon() )
					v.m_entLastActiveWeapon = v:GetActiveWeapon()
				end
			end

			--Track and invalidate model changes
			if v.m_strLastModel then
				if v:GetModel() ~= v.m_strLastModel then
					self:InvalidatePlayerOutfits( v )
					v.m_strLastModel = v:GetModel()
				end
			else
				v.m_strLastModel = v:GetModel()
			end

			--Ragdoll outfits
			ragdoll = v:GetRagdoll()
			if IsValid( v:GetRagdollEntity() ) then
				ragdoll = v:GetRagdollEntity()
			end

			if v.AttachPACPart then
				if not v:Alive() or IsValid( ragdoll ) and not v.pac_ignored then
					pac.IgnoreEntity( v )
				elseif v:Alive() and not IsValid( ragdoll ) and v.pac_ignored then
					pac.UnIgnoreEntity( v )
				end
			end
			
			if IsValid( ragdoll ) and not ragdoll.m_bPacApplied then
				for slotName, _ in pairs( GAMEMODE.Inv.m_tblEquipmentSlots ) do
					item = GAMEMODE.Inv:GetItem( GAMEMODE.Player:GetSharedGameVar(v, "eq_slot_".. slotName, "") )
					if not item or not item.PacOutfit then continue end

					if not ragdoll.AttachPACPart then
						pac.SetupENT( ragdoll )
						ragdoll:SetPACDrawDistance( GetConVarNumber("srp_pac_drawrange") )
					end
					ragdoll:AttachPACPart( GAMEMODE.PacModels:GetOutfitForModel(item.PacOutfit, v:GetModel()), nil, true )
				end

				ragdoll.m_bPacApplied = true
			end
		end
	end
end