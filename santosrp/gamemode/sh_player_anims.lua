--[[
	Name: sh_player_anims.lua
	For: TalosLife
	By: Bobblehead +Rustic7: Merged w/ GM
]]--

GM.PlayerAnims = (GAMEMODE or GM).PlayerAnims or {}
GM.PlayerAnims.m_tblAnims = (GAMEMODE or GM).PlayerAnims.m_tblAnims or {}

function GM.PlayerAnims:RegisterAnimSet( strAnimID, tblAnimData )
	self.m_tblAnims[strAnimID] = tblAnimData
end

GM.PlayerAnims:RegisterAnimSet( "hands_up", {
	["ValveBiped.Bip01_R_UpperArm"] = Angle(73,35,128),
	["ValveBiped.Bip01_L_Hand"] = Angle(-12,12,90),
	["ValveBiped.Bip01_L_Forearm"] = Angle(-28,-29,44),
	["ValveBiped.Bip01_R_Forearm"] = Angle(-22,1,15),
	["ValveBiped.Bip01_L_UpperArm"] = Angle(-77,-46,4),
	["ValveBiped.Bip01_R_Hand"] = Angle(33,39,-21),
	["ValveBiped.Bip01_L_Finger01"] = Angle(0,30,0),
	["ValveBiped.Bip01_L_Finger1"] = Angle(0,45,0),
	["ValveBiped.Bip01_L_Finger11"] = Angle(0,45,0),
	["ValveBiped.Bip01_L_Finger2"] = Angle(0,45,0),
	["ValveBiped.Bip01_L_Finger21"] = Angle(0,45,0),
	["ValveBiped.Bip01_L_Finger3"] = Angle(0,45,0),
	["ValveBiped.Bip01_L_Finger31"] = Angle(0,45,0),
	["ValveBiped.Bip01_R_Finger0"] = Angle(-10,0,0),
	["ValveBiped.Bip01_R_Finger11"] = Angle(0,30,0),
	["ValveBiped.Bip01_R_Finger2"] = Angle(20,25,0),
	["ValveBiped.Bip01_R_Finger21"] = Angle(0,45,0),
	["ValveBiped.Bip01_R_Finger3"] = Angle(20,35,0),
	["ValveBiped.Bip01_R_Finger31"] = Angle(0,45,0),
} )
GM.PlayerAnims:RegisterAnimSet( "cuffed", {
	["ValveBiped.Bip01_R_UpperArm"] = Angle(-38,18,-26),
	["ValveBiped.Bip01_L_Hand"] = Angle(0,0,119),
	["ValveBiped.Bip01_L_Forearm"] = Angle(31,3,58),
	["ValveBiped.Bip01_L_UpperArm"] = Angle(26,26,0),
	["ValveBiped.Bip01_R_Forearm"] = Angle(0,36,0),
	["ValveBiped.Bip01_R_Hand"] = Angle(45,34,-15),
	["ValveBiped.Bip01_L_Finger01"] = Angle(0,50,0),
	["ValveBiped.Bip01_R_Finger0"] = Angle(10,2,0),
	["ValveBiped.Bip01_R_Finger1"] = Angle(-10,0,0),
	["ValveBiped.Bip01_R_Finger11"] = Angle(0,-40,0),
	["ValveBiped.Bip01_R_Finger12"] = Angle(0,-30,0)
} )

--Adds an anim id layer to the player
function GM.PlayerAnims:ApplyAnimID( pPlayer, strAnimID )
	if not IsValid( pPlayer ) or not pPlayer:GetBoneCount() then return end
	if not self.m_tblAnims[strAnimID] then return end
	
	if not pPlayer.m_tblGameAnims then pPlayer.m_tblGameAnims = {} end
	pPlayer.m_tblGameAnims[strAnimID] = true

	hook.Call( "GamemodePlayerAnimApplied", GAMEMODE, pPlayer, strAnimID )
end

--Removes an anim id layer from the player
function GM.PlayerAnims:RemoveAnimID( pPlayer, strAnimID )
	if not IsValid( pPlayer ) then return end
	if not pPlayer.m_tblGameAnims then return end

	if pPlayer.m_tblGameAnims[strAnimID] then
		hook.Call( "GamemodePlayerAnimRemoved", GAMEMODE, pPlayer, strAnimID )
	end

	pPlayer.m_tblGameAnims[strAnimID] = nil

	if table.Count( pPlayer.m_tblGameAnims ) <= 0 and pPlayer:GetBoneCount() then
		for i = 1, pPlayer:GetBoneCount() -1 do
			local bone = pPlayer:LookupBone( pPlayer:GetBoneName(i) )
			if bone then
				pPlayer:ManipulateBoneAngles( bone, Angle(0, 0, 0) )
			end
		end

		pPlayer.m_tblGameAnims = nil
	end
end

--Removes all anim id layers from the player
function GM.PlayerAnims:ResetAnims( pPlayer )
	if not IsValid( pPlayer ) then return end
	if not pPlayer.m_tblGameAnims then return end

	for k, v in pairs( pPlayer.m_tblGameAnims ) do
		hook.Call( "GamemodePlayerAnimRemoved", GAMEMODE, pPlayer, k )
	end

	if pPlayer:GetBoneCount() then
		for i = 1, pPlayer:GetBoneCount() -1 do
			local bone = pPlayer:LookupBone( pPlayer:GetBoneName(i) )
			if bone then
				pPlayer:ManipulateBoneAngles( bone, Angle(0, 0, 0) )
			end
		end
	end

	pPlayer.m_tblGameAnims = nil
end

--Returns all the active anim id layers for the player
function GM.PlayerAnims:GetCurrentAnimIDs( pPlayer )
	return pPlayer.m_tblGameAnims
end

--Updates the bones for all players
function GM.PlayerAnims:ThinkPlayerBones()
	local bone
	for k, v in pairs( player.GetAll() ) do
		if not IsValid( v ) or not v.m_tblGameAnims then continue end
		
		local boneAngs = {} --Add all anim angles
		for animID, _ in pairs( v.m_tblGameAnims ) do
			for boneID, ang in pairs( self.m_tblAnims[animID] ) do
				bone = v:LookupBone( boneID )
				if bone then
					boneAngs[bone] = boneAngs[bone] or Angle( 0, 0, 0 )
					boneAngs[bone] = boneAngs[bone] +ang
				end
			end
		end

		--Apply final angles
		for bone, ang in pairs( boneAngs ) do
			v:ManipulateBoneAngles( bone, ang )
		end
	end
end

if SERVER then
	util.AddNetworkString "HandsUp"

	function GM.PlayerAnims:SetPlayerHandsUp( pPlayer, bHandsUp )
		net.Start( "HandsUp" )
			net.WriteEntity( pPlayer )
			net.WriteBool( bHandsUp )
		net.Broadcast()

		if bHandsUp then
			GAMEMODE.Player:ModifyMoveSpeed( pPlayer, "HandsUpDeBuff", 0, -1000 )
		else
			GAMEMODE.Player:RemoveMoveSpeedModifier( pPlayer, "HandsUpDeBuff" )
		end
	end
	
	hook.Add( "ShowSpare1", "Handsupdontshoot", function( ply )
		if ply:IsValid() and ply:Alive() and (not IsValid(ply:isHandcuffed()) ) and (not IsValid(ply:isZiptied())) then
			ply.HandsUp = not ply.HandsUp
			
			if ply:InVehicle() then
				ply.HandsUp = false
			end
			
			ply:SelectWeapon( "weapon_srphands" )
			GAMEMODE.PlayerAnims:SetPlayerHandsUp( ply, ply.HandsUp )

			local wep = ply:GetWeapon( "weapon_srphands" )
			if IsValid( wep ) and wep.SetWeaponHoldType then
				wep:SetWeaponHoldType( ply.HandsUp and "passive" or "normal" )
			end
		end
	end )

	hook.Add( "PlayerInitialSpawn", "Handsupdontshoot", function( ply )
		ply.HandsUp = false
	end )

	hook.Add( "DoPlayerDeath", "Handsupdontshoot", function( ply )
		ply.HandsUp = false

		local wep = ply:GetWeapon( "weapon_srphands" )
		if IsValid( wep ) and wep.SetWeaponHoldType then
			wep:SetWeaponHoldType( ply.HandsUp and "passive" or "normal" )
		end

		GAMEMODE.PlayerAnims:SetPlayerHandsUp( ply, ply.HandsUp )
	end )

	net.Receive( "HandsUp", function( leng, ply )
		if IsValid( ply ) and ply:Alive() and (not IsValid(ply:isHandcuffed()) ) and (not IsValid(ply:isZiptied())) then
			ply.HandsUp = not ply.HandsUp
			
			if ply:InVehicle() then
				ply.HandsUp = false
			end
			
			local wep = ply:GetWeapon( "weapon_srphands" )
			if IsValid( wep ) and wep.SetWeaponHoldType then
				wep:SetWeaponHoldType( ply.HandsUp and "passive" or "normal" )
			end

			ply:SelectWeapon( "weapon_srphands" )
			GAMEMODE.PlayerAnims:SetPlayerHandsUp( ply, ply.HandsUp )
		end
	end )

	hook.Add( "PlayerSwitchWeapon", "Handsupdontshoot", function( ply, old, new )
		if not (new and new:IsValid() and new:GetClass() == "weapon_srphands") then
			ply.HandsUp = false

			local wep = ply:GetWeapon( "weapon_srphands" )
			if IsValid( wep ) and wep.SetWeaponHoldType then
				wep:SetWeaponHoldType( "normal" )
			end

			GAMEMODE.PlayerAnims:SetPlayerHandsUp( ply, ply.HandsUp )
		end
	end )
	
	hook.Add( "PlayerEnteredVehicle", "handsupdontshoot", function( ply, veh )
		ply.HandsUp = false

		local wep = ply:GetWeapon( "weapon_srphands" )
		if IsValid( wep ) and wep.SetWeaponHoldType then
			wep:SetWeaponHoldType( "normal" )
		end

		GAMEMODE.PlayerAnims:SetPlayerHandsUp( ply, ply.HandsUp )
	end )
end

if CLIENT then
	net.Receive( "HandsUp", function()
		local ply = net.ReadEntity()
		local bool = net.ReadBool()
		ply.HandsUp = bool

		if IsValid( ply ) and bool and ply:Alive() then
			local wep = ply:GetWeapon( "weapon_srphands" )
			if IsValid( wep ) and wep.SetWeaponHoldType then
				wep:SetWeaponHoldType( "passive" )
			end

			GAMEMODE.PlayerAnims:RemoveAnimID( ply, "hands_up" ) --applyduhbones(ply,"r")
			GAMEMODE.PlayerAnims:ApplyAnimID( ply, "hands_up" ) --applyduhbones(ply,"hands_up")
		elseif IsValid( ply ) then
			local wep = ply:GetWeapon( "weapon_srphands" )
			if IsValid( wep ) and wep.SetWeaponHoldType then
				wep:SetWeaponHoldType( "normal" )
			end

			GAMEMODE.PlayerAnims:RemoveAnimID( ply, "hands_up" ) --applyduhbones(ply,"r")
		end
	end )
	
	concommand.Add( "hands_up", function( p, c, a )
		if IsValid( p ) and p:Alive() and (not IsValid(p:isHandcuffed()) ) and (not IsValid(p:isZiptied())) then
			net.Start( "HandsUp" )
			net.SendToServer()
		end
	end )
end