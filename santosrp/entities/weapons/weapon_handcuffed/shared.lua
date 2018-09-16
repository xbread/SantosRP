
-----------------------------------------------------

if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base 					 =      "weapon_modify_base"

SWEP.PrintName	             =      "Handcuffed"			
SWEP.Author			         =      "RayChamp"
SWEP.Instructions		     =      ""
SWEP.Purpose 		         =      ""

SWEP.Spawnable               =      true
SWEP.AdminOnly               =      false

SWEP.Primary.ClipSize		 =      -1
SWEP.Primary.DefaultClip	 =      -1
SWEP.Primary.Automatic		 =      false
SWEP.Primary.Ammo		     =      "none"

SWEP.Secondary.ClipSize		 =      -1
SWEP.Secondary.DefaultClip	 =      -1
SWEP.Secondary.Automatic	 =      false
SWEP.Secondary.Ammo		     =      "none"

--Misc Settings
SWEP.Weight			         =      100
SWEP.AutoSwitchTo		     =      true
SWEP.AutoSwitchFrom		     =      true
SWEP.Slot			         =      1
SWEP.SlotPos			     =      1
SWEP.DrawAmmo			     =      false
SWEP.DrawCrosshair		     =      false
SWEP.FiresUnderwater         =      false

SWEP.HoldType 				= "passive"
SWEP.ViewModelFOV 			= 70
SWEP.ViewModelFlip 			= false
SWEP.ViewModel 				= "models/katharsmodels/handcuffs/handcuffs-1.mdl"
SWEP.WorldModel 			= ""

SWEP.HoldPos 				= Vector( -3, 1, 1 )
SWEP.HoldAng 				= Vector( -20, 100, 0 )

SWEP.ViewAng 				= Vector( -20, 90, 0 )
SWEP.ViewPos 				= Vector( 0, 7, -3 )

SWEP.BreakAmount			= 20

local PMeta = FindMetaTable( "Player" )
function PMeta:getNumHandcuffed()
	local num = 0
	for k,v in pairs( player.GetAll() ) do
		local cuff = v:isHandcuffed()
		
		if ( cuff and cuff.handcuffer == self ) then
			num = num +1
		end
	end
	
	return num
end

function PMeta:getHandcuffedPlayers()
	local tbl = {}
	for k,v in pairs( player.GetAll() ) do
		local cuff = v:isHandcuffed()
		
		if ( cuff and cuff.handcuffer == self ) then
			table.insert( tbl, v )
		end
	end
	
	return tbl
end

function PMeta:isHandcuffed()
	return self:GetWeapon( "weapon_handcuffed" )
end

function PMeta:hasHandcuffed()
	for k,v in pairs( player.GetAll() ) do
		local cuff = v:isHandcuffed()
		
		if ( cuff and cuff.handcuffer == self ) then
			return true
		end
	end
	
	return false
end

if ( CLIENT ) then
	surface.CreateFont("handcuffText", {
		size = 45,
		font = "coolvetica",
		weight = 400,
		antialias = true
	})
	
	surface.CreateFont("handcuffTextSmall", {
		size = 23,
		font = "coolvetica",
		weight = 400,
		antialias = true
	})

	function SWEP:drawCam()
		local wep = LocalPlayer():GetWeapon("weapon_handcuffer")
		if IsValid(wep) then
			if wep:GetNWEntity("Dragging") == self.Owner then
				draw.SimpleTextOutlined( "Dragging", "handcuffText", 0, 0, Color(60,60,255), 1, 1, 2, color_black )
				return
			end
		end

		draw.SimpleTextOutlined( "Handcuffed", "handcuffText", 0, 0, color_white, 1, 1, 2, color_black )
	end

	function SWEP:DrawHUD()
		local x = ScrW()/2
		local y = ScrH() - 100
		local box_w = 350
		local box_h = 90
		
		surface.SetDrawColor( 0, 0, 0, 220 )
		surface.DrawRect( x-(box_w/2), y-(box_h/2), box_w, box_h )
		
		draw.SimpleTextOutlined( "You are handcuffed!", "handcuffText", x, y-10, color_white, 1, 1, 1, color_black )
		draw.SimpleText( "You can be uncuffed by others around you, but for now you're stuck.", "DermaDefault", x, y + 25, color_white, 1, 1 )
		
		local cnt = self:GetNWInt("break_amount")
		
		if ( cnt > 0 ) then
			draw.SimpleText( "Release Status: "..cnt.."/"..self.BreakAmount, "DermaDefault", x, y - 35, Color( 220, 20, 20 ), 1, 1 )
		end
	end
end



function SWEP:Initialize()
	self:SetHoldType( self.HoldType )

	timer.Simple( 0, function()
		if not IsValid( self ) or not IsValid( self.Owner ) then return end
		GAMEMODE.PlayerAnims:ResetAnims( self.Owner )
		self.m_pCuffedPlayer = self.Owner

		if SERVER then
			if not IsValid( self ) or not IsValid( self.Owner ) then return end
			
			self.Owner.HandsUp = false
			local wep = self.Owner:GetWeapon( "weapon_srphands" )
			if IsValid( wep ) and wep.SetWeaponHoldType then
				wep:SetWeaponHoldType( "normal" )
			end

			GAMEMODE.PlayerAnims:SetPlayerHandsUp( self.Owner, false )
			GAMEMODE.Player:ModifyMoveSpeed( self.Owner, "CuffedMoveDeBuff", 0, -1000 )
		end
		
		GAMEMODE.PlayerAnims:ApplyAnimID( self.Owner, "cuffed" )
		hook.Call( "GamemodeOnPlayerCuffed", GAMEMODE, self.Owner )
	end )
end

function SWEP:OnRemove()
	self.m_bRemoving = true

	if IsValid( self.handcuffer ) then
		hook.Call( "GamemodePlayerUnDragCuffedPlayer", GAMEMODE, self.handcuffer, self.Owner )
		self.handcuffer = NULL
	end

	local pl = self.m_pCuffedPlayer
	if IsValid( pl ) then
		if SERVER then
			GAMEMODE.Player:RemoveMoveSpeedModifier( pl, "CuffedMoveDeBuff" )
		end
		
		GAMEMODE.PlayerAnims:ResetAnims( pl )
		hook.Call( "GamemodeOnPlayerUnCuffed", GAMEMODE, pl )
	end

	if IsValid( self.Owner ) then
		self.Owner.CuffedEnt = nil
	end
end

function SWEP:AttemptBreak( saver )
	if ( CLIENT ) then return end
	-- self:SetNWInt("break_amount", self:GetNWInt("break_amount")+1)
	-- if ( self:GetNWInt("break_amount")>=self.BreakAmount) then
		-- self:Break()
	-- end
end

function SWEP:Think()
	if ( CLIENT ) then return end
	
	if ( self.lastThink or 0 ) > CurTime() then return end
	if IsValid( self.Owner ) and not self.Owner.CuffedEnt then self.Owner.CuffedEnt = self end
	
	--[[if IsValid( self.Owner ) then
		if not GAMEMODE.Player:IsMoveSpeedModifierActive( self.Owner, "CuffMovePenalty" ) then
			GAMEMODE.Player:ModifyMoveSpeed( self.Owner, "CuffMovePenalty", 0, -1000 )
			self.m_pPlayerModified = self.Owner
		end
	end]]--
	
	local amount = self:GetNWInt( "break_amount" )
	if ( amount > 0 ) then
		self:SetNWInt( "break_amount", amount - 1 )
	end
	
	self.lastThink = CurTime() + 1
end

function SWEP:Break( entHandcuffer )
	self:EmitSound(Sound("weapons/crowbar/crowbar_impact1.wav"))
	self:Remove()
end

if ( SERVER ) then
	hook.Add( "KeyPress", "pressEOnHandcuffed", function( ply, key )
		if ( key != IN_USE ) then return end
		
		local ent = ply:GetEyeTrace().Entity
		
		if ( !IsValid( ent ) or ent:GetPos():Distance( ply:GetPos() ) >= 150 or !ent:IsPlayer() ) then return end
		
		local cuff = ent:isHandcuffed()
		
		if ( IsValid( cuff ) ) then
			cuff:AttemptBreak( ply )
		end
	end )
end

hook.Add( "GamemodeOnPlayerRagdolled", "StoreCuffedState", function( pPlayer, entRagdoll )
	if not IsValid( pPlayer:isHandcuffed() ) then return end
	pPlayer.m_bWasCuffed = true
	pPlayer:StripWeapon( "weapon_handcuffed" )
end )

hook.Add( "GamemodeOnPlayerUnRagdolled", "RestoreCuffedState", function( pPlayer )
	if not pPlayer.m_bWasCuffed then return end
	pPlayer.m_bWasCuffed = false
	pPlayer:Give( "weapon_handcuffed" )
	pPlayer:SetActiveWeapon( pPlayer:GetWeapon("weapon_handcuffed") )	
end )

hook.Add( "GamemodeOnCharacterDeath", "ClearCuffedState", function( pPlayer )
	pPlayer.m_bWasCuffed = false
end )

hook.Add( "PlayerLeaveVehicle", "leaveDaVehicleCuffer", function( ply, veh )
	local cuffers = {}
	
	for k,v in pairs( player.GetAll() ) do
		local cuffs = v:isHandcuffed()
		
		if ( cuffs and cuffs.handcuffer == ply and v != ply ) then
			if ( IsValid( v:GetVehicle() ) ) then
				table.insert( cuffers, v )
			end
		end
	end
	
	for k,v in pairs( cuffers ) do
		v:ExitVehicle()
	end
end )

hook.Add( "CanExitVehicle", "stopLeaveVehicle", function( veh, ply )
	local cuff = ply:isHandcuffed()

	if ( cuff ) then
		local owner = cuff.handcuffer
		
		if ( IsValid( owner ) ) then
			return !IsValid( owner:GetVehicle() ) 
		end
	end
end )


hook.Add( "PlayerEnteredVehicle", "enterVehicleCuffer", function( ply, veh )
	local cuffers = {}
	
	for k,v in pairs( player.GetAll() ) do
		local cuffs = v:isHandcuffed()
		
		if ( cuffs and cuffs.handcuffer == ply and v != ply ) then
			table.insert( cuffers, v )
		end
	end
	
	local seats = {}
	
	for k,v in pairs( ents.GetAll() ) do
		if ( v:IsVehicle() and v:GetParent() == veh ) then
			table.insert( seats, v )
		end
	end
	
	for k,v in pairs( cuffers ) do
		if ( seats[ k ] ) then
			v:EnterVehicle( seats[ k ] )
		end
	end
end )

local getTable = debug.getregistry().Entity.GetTable
local isCuffed = debug.getregistry().Player.isHandcuffed
local alive = debug.getregistry().Player.Alive
local pTbl
local function moveHook( ply, mv, cmd )
	pTbl = getTable( ply )

	if not pTbl.CuffedEnt then return end
	local cuffs = isCuffed( ply ) --ply:isHandcuffed()
	if not cuffs or not IsValid( cuffs ) then return end
	
	mv:SetMaxClientSpeed( mv:GetMaxClientSpeed()*0.6 )
	
	local officer = cuffs.handcuffer
	if ( !IsValid(officer) ) then return end // Nowhere to move to
	if officer==ply then return end
	if not alive( officer ) then
		cuffs.handcuffer = nil
		return
	end


	local TargetPoint = (officer:IsPlayer() and officer:GetShootPos()) or officer:GetPos()
	local MoveDir = (TargetPoint - ply:GetPos()):GetNormal()
	local ShootPos = ply:GetShootPos() + (Vector(0,0, (ply:Crouching() and 0)))
	local Distance = 64
	local distFromTarget = ShootPos:Distance( TargetPoint )
	if distFromTarget <= Distance +5 then return end
	
	if ply:InVehicle() then
		if SERVER and (distFromTarget>(Distance*3)) then
			ply:ExitVehicle()
		end
		
		return
	end
	
	local TargetPos = TargetPoint - (MoveDir*Distance)
	local xDif = math.abs(ShootPos[1] - TargetPos[1])
	local yDif = math.abs(ShootPos[2] - TargetPos[2])
	local zDif = math.abs(ShootPos[3] - TargetPos[3])
	
	local speedMult = 3+ ( (xDif + yDif)*0.5)^1.01
	local vertMult = math.max((math.Max(300-(xDif + yDif), -10)*0.08)^1.01  + (zDif/2),0)
	
	if officer:GetGroundEntity()==ply then vertMult = -vertMult end
	
	local TargetVel = (TargetPos - ShootPos):GetNormal() * 10
	TargetVel[1] = TargetVel[1]*speedMult
	TargetVel[2] = TargetVel[2]*speedMult
	TargetVel[3] = TargetVel[3]*vertMult
	
	local dir = mv:GetVelocity()
	local clamp = 50
	local vclamp = 20
	local accel = 200
	local vaccel = 30*(vertMult/50)
	
	dir[1] = (dir[1]>TargetVel[1]-clamp or dir[1]<TargetVel[1]+clamp) and math.Approach(dir[1], TargetVel[1], accel) or dir[1]
	dir[2] = (dir[2]>TargetVel[2]-clamp or dir[2]<TargetVel[2]+clamp) and math.Approach(dir[2], TargetVel[2], accel) or dir[2]
	
	if ShootPos[3] < TargetPos[3] then
		dir[3] = (dir[3]>TargetVel[3]-vclamp or dir[3]<TargetVel[3]+vclamp) and math.Approach(dir[3], TargetVel[3], vaccel) or dir[3]
		if vertMult > 0 then pTbl.Cuff_ForceJump = ply end
	end
	
	mv:SetVelocity( dir )
end
hook.Add( "SetupMove", "Cuffs Move Penalty", moveHook )