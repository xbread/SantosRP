
-----------------------------------------------------
if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName	= "Hands"
SWEP.Author		= "The Maw"
SWEP.Purpose    = "Nothing"
SWEP.ViewModel	= "models/weapons/c_medkit.mdl"
SWEP.WorldModel	= ""

SWEP.AnimPrefix	 			= "rpg"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "FriskStart" )
end

function SWEP:Initialize()
	self:SetHoldType( "normal" )
	self.Time = 0
	self.Range = 140
	self.FriskRange = 80
	self.FriskDuration = 6
end

function SWEP:OnRemove()
	if self.m_bFrisking then self:OnStopFrisking() end
	self.Owner.m_entFriskInspecting = nil
	self.Owner.m_entFirskingWep = nil
	self.m_entFriskInspecting = nil
end

function SWEP:Think()
	if self.Drag and (not self.Owner:KeyDown(IN_ATTACK) or not IsValid(self.Drag.Entity)) then
		self.Drag = nil
	end

	if self.m_bFrisking then
		if not self.Owner:KeyDown( IN_ATTACK2 ) then
			self:OnStopFrisking()
		elseif not IsValid( self.m_entFriskTarget ) or self.m_entFriskTarget:GetPos():Distance( self.Owner:GetPos() ) > self.FriskRange then
			self:OnStopFrisking()
		else
			if CurTime() > self.m_intFriskStart +self.FriskDuration then
				local target = self.m_entFriskTarget

				if not IsValid( target ) or target:GetPos():Distance( self.Owner:GetPos() ) > self.FriskRange then
					return
				end

				self:OnStopFrisking()

				if target:IsPlayer() then
					self:OnStartInspecting( target )
				elseif target:IsRagdoll() then
					self:FriskRandomItem( target.RagdollPlayer )
				end
			else
				if CurTime() > (self.m_intSoundTime or 0) then
					self.m_intSoundTime = CurTime() +math.Rand( 0.75, 1.25 )
					self.Owner:EmitSound( "npc/zombie/foot".. math.random(1, 3).. ".wav", 75, math.random(64, 80), 1 )
				end
			end
		end
	elseif self.m_entFriskInspecting then
		if not IsValid( self.m_entFriskInspecting ) or
			self.m_entFriskInspecting:GetPos():Distance( self.Owner:GetPos() ) > self.FriskRange or
			self.m_entFriskInspecting:IsRagdoll() or
			not self.m_entFriskInspecting:Alive() then

			self:OnStopInspecting()
			return
		end
	end
end


--[[ Frisking ]]--
local FRISK_CLOSE_MENU = 0
local FRISK_OPEN_MENU = 1
local FRISK_TAKE_ITEMS = 2
local FRISK_DESTROY_ITEM = 3

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if IsValid( self.Owner:GetVehicle() ) then return end

	local Pos = self.Owner:GetShootPos()
	local Aim = self.Owner:GetAimVector()
	local ent = util.TraceLine{
			start = Pos,
			endpos = Pos +Aim *self.FriskRange,
			filter = { self, self.Owner },
	}.Entity

	if not IsValid( ent ) then return end
	if ent:IsPlayer() and (ent:HasWeapon("weapon_handcuffed") or ent:HasWeapon("weapon_ziptied")) then
		if self.m_bFrisking then return end
		self:OnStartFrisking( ent )
	elseif ent:IsRagdoll() and IsValid( ent.RagdollPlayer ) and ent.RagdollPlayer:IsUncon() then
		self:OnStartFrisking( ent )
	end
end

function SWEP:OnStartFrisking( pTarget )
	if not IsValid( pTarget ) or not pTarget:IsPlayer() then return end
	if pTarget:HasWeapon( "weapon_handcuffed" ) and GAMEMODE.Jobs:GetPlayerJobID( self.Owner ) ~= JOB_POLICE then
		return
	end

	self.m_bFrisking = true
	self.m_intFriskStart = CurTime()
	self:SetFriskStart( self.m_intFriskStart +self.FriskDuration )
	self.m_entFriskTarget = pTarget
	self.Owner.m_bIsFrisking = true
	self.Owner.m_entFirskingWep = self
end

function SWEP:OnStopFrisking()
	self.m_bFrisking = nil
	self.m_intFriskStart = nil
	self:SetFriskStart( 0 )
	self.m_entFriskTarget = nil
	self.Owner.m_bIsFrisking = nil
	self.Owner.m_entFirskingWep = nil
	self.m_intSoundTime = nil
end

function SWEP:FriskRandomItem( pTarget )
	if not IsValid( pTarget ) then return end
	
	local items, num = {}, 0
	for k, v in pairs( pTarget:GetInventory() ) do
		local data = GAMEMODE.Inv:GetItem( k )
		if not data or data.NoFrisk or data.JobItem or not data.Illegal or v <= 0 then continue end
		
		items[k] = v
		num = num +1
	end

	for k, v in pairs( pTarget:GetEquipment() ) do
		local slot = GAMEMODE.Inv.m_tblEquipmentSlots[k]
		if not slot or slot.Internal then continue end
		
		local data = GAMEMODE.Inv:GetItem( v )
		if not data or data.NoFrisk or data.JobItem or not data.Illegal then continue end
		items[v] = (items[v] or 0) +1
		num = num +1
	end

	if num <= 0 then self.Owner:AddNote( "You found nothing" ) return end
	local v, k = table.Random( items )
	if v > 1 then v = math.random( 1, v ) end
	local data = GAMEMODE.Inv:GetItem( k )

	local taken = 0
	local b, slot = GAMEMODE.Inv:PlayerHasItemEquipped( pTarget, k )
	if b then
		taken = taken +1
		GAMEMODE.Inv:DeletePlayerEquipItem( pTarget, slot )
	end

	if taken < v then
		if GAMEMODE.Inv:TakePlayerItem( pTarget, k, v -taken ) then
			taken = v
		end
	end
	
	if not GAMEMODE.Inv:GivePlayerItem( self.Owner, k, taken ) then
		local spawnPos = util.TraceLine{
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() +self.Owner:GetAimVector() *150,
			filter = self.Owner,
		}.HitPos

		GAMEMODE.Inv:MakeItemBox( self.Owner, spawnPos, Angle(0, self.Owner:GetAimVector():Angle().y, 0), { [k] = taken } )
	end

	self.Owner:AddNote( "You found ".. taken.. " ".. data.Name )
end

function SWEP:OnStartInspecting( pTarget )
	self.m_entFriskInspecting = pTarget
	self.Owner.m_entFriskInspecting = pTarget
	self.Owner.m_entFirskingWep = self
	self.Owner:Freeze( self:NetworkOpenMenu() )
end

function SWEP:OnStopInspecting()
	self.m_entFriskInspecting = nil
	self.Owner.m_entFriskInspecting = nil
	self.Owner.m_entFirskingWep = nil
	self:NetworkCloseMenu()
	self.Owner:Freeze( false )
end

function SWEP:NetworkOpenMenu()
	local items, num = {}, 0
	for k, v in pairs( self.m_entFriskInspecting:GetInventory() ) do
		local data = GAMEMODE.Inv:GetItem( k )
		if not data or data.NoFrisk or v <= 0 then continue end
		if self.m_entFriskInspecting:HasWeapon( "weapon_ziptied" ) and (not data.Illegal and not data.JobItem) then continue end
		
		items[k] = v
		num = num +1
	end

	for k, v in pairs( self.m_entFriskInspecting:GetEquipment() ) do
		local slot = GAMEMODE.Inv.m_tblEquipmentSlots[k]
		if not slot or slot.Internal then continue end
		
		local data = GAMEMODE.Inv:GetItem( v )
		if not data or data.NoFrisk then continue end
		if self.m_entFriskInspecting:HasWeapon( "weapon_ziptied" ) and (not data.Illegal and not data.JobItem) then continue end

		items[v] = (items[v] or 0) +1
		num = num +1
	end

	if num <= 0 then self:NetworkCloseMenu() return false end

	net.Start( "gm_frisk" )
		net.WriteUInt( FRISK_OPEN_MENU, 8 )
		net.WriteEntity( self.m_entFriskInspecting )
		net.WriteUInt( num, 16 )
		for k, v in pairs( items ) do
			net.WriteString( k )
			net.WriteUInt( v, 32 )
		end
	net.Send( self.Owner )

	return true
end

function SWEP:NetworkCloseMenu()
	net.Start( "gm_frisk" )
		net.WriteUInt( FRISK_CLOSE_MENU, 8 )
	net.Send( self.Owner )
end

function SWEP:InspectTakeItems( tblItems )
	if not IsValid( self.m_entFriskInspecting ) or self.m_entFriskInspecting:IsRagdoll() then return end

	local valid = {}
	for k, v in pairs( tblItems ) do
		local data = GAMEMODE.Inv:GetItem( k )
		if data.JobItem or data.NoFrisk then continue end
		if self.m_entFriskInspecting:HasWeapon( "weapon_ziptied" ) and not data.Illegal then continue end

		local taken = 0
		--Check for anything equipped first
		local b, slot = GAMEMODE.Inv:PlayerHasItemEquipped( self.m_entFriskInspecting, k )
		if b then
			taken = taken +1
			GAMEMODE.Inv:DeletePlayerEquipItem( self.m_entFriskInspecting, slot )
		end

		if taken >= v then valid[k] = taken continue end
		--We want more than what is equipped

		if GAMEMODE.Inv:PlayerHasItem( self.m_entFriskInspecting, k ) then
			local num = GAMEMODE.Inv:GetPlayerItemAmount( self.m_entFriskInspecting, k )
			num = math.max( num, 0 )

			--num = math.min( num, math.max(v -(valid[k] and valid[k] or 0), 0) )
			valid[k] = math.Clamp( taken +num, taken, v )
			GAMEMODE.Inv:TakePlayerItem( self.m_entFriskInspecting, k, valid[k] -taken )
		end
	end

	if table.Count( valid ) > 0 then
		local spawnPos = util.TraceLine{
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() +self.Owner:GetAimVector() *150,
			filter = self.Owner,
		}.HitPos

		local box = GAMEMODE.Inv:MakeItemBox( self.Owner, spawnPos, Angle(0, self.Owner:GetAimVector():Angle().y, 0), valid )
		if GAMEMODE.Jobs:GetPlayerJobID( self.Owner ) == JOB_POLICE and self.m_entFriskInspecting:HasWeapon( "weapon_handcuffed" ) then
			box:SetOwnerName( self.m_entFriskInspecting:Nick() )
			self.Owner:DontDeleteOnRemove( box )
		end
	end

	if not self:NetworkOpenMenu() then
		self:OnStopInspecting()
	end
end

function SWEP:InspectDestroyItem( strItemID, intAmount )
	if not IsValid( self.m_entFriskInspecting ) or self.m_entFriskInspecting:IsRagdoll() then return end
	local data = GAMEMODE.Inv:GetItem( strItemID )
	if data.NoFrisk then return end
	if self.m_entFriskInspecting:HasWeapon( "weapon_ziptied" ) and (not data.Illegal and not data.JobItem) then return end
	
	local taken = 0
	local b, slot = GAMEMODE.Inv:PlayerHasItemEquipped( self.m_entFriskInspecting, strItemID )
	if b then
		taken = taken +1
		GAMEMODE.Inv:DeletePlayerEquipItem( self.m_entFriskInspecting, slot )
	end

	if taken < intAmount then
		--We want more than what is equipped
		if GAMEMODE.Inv:PlayerHasItem( self.m_entFriskInspecting, strItemID ) then
			local num = GAMEMODE.Inv:GetPlayerItemAmount( self.m_entFriskInspecting, strItemID )
			num = math.min( num, math.max(intAmount -taken, 0) )
			taken = num
			GAMEMODE.Inv:TakePlayerItem( self.m_entFriskInspecting, strItemID, num )
		end
	end
	
	if not self:NetworkOpenMenu() then
		self:OnStopInspecting()
	end
end

--In case the hands are no longer active
local updateRate, lastUpdate = 1, 0
hook.Add( "Tick", "UpdateFriskingPlayers", function()
	if lastUpdate > CurTime() then return end
	for k, v in pairs( player.GetAll() ) do
		if not v.m_bFrisking and not v.m_entFriskInspecting then continue end
		if not IsValid( v:GetActiveWeapon() ) or v:GetActiveWeapon():GetClass() ~= "weapon_srphands" then
			if v.m_bFrisking then
				if IsValid( v.m_entFirskingWep ) then
					v.m_entFirskingWep:OnStopFrisking()
				else
					v.m_bFrisking = nil
					v.m_entFirskingWep = nil
				end
			elseif v.m_entFriskInspecting then
				if IsValid( v.m_entFirskingWep ) then
					v.m_entFirskingWep:OnStopInspecting()
				else
					v.m_entFriskInspecting = nil
					v.m_entFirskingWep = nil
				end
			end
		end
	end
end )

if SERVER then
	util.AddNetworkString "gm_frisk"

	net.Receive( "gm_frisk", function( intMsgLen, pPlayer )
		if not IsValid( pPlayer.m_entFriskInspecting ) or not IsValid( pPlayer.m_entFirskingWep ) then
			return
		end

		local option = net.ReadUInt( 8 )
		if option == FRISK_CLOSE_MENU then
			pPlayer.m_entFirskingWep:OnStopInspecting()
		elseif option == FRISK_TAKE_ITEMS then
			local num = net.ReadUInt( 16 )
			local items = {}
			for i = 1, num do
				items[net.ReadString()] = net.ReadUInt( 32 )
			end

			pPlayer.m_entFirskingWep:InspectTakeItems( items )
		elseif option == FRISK_DESTROY_ITEM then
			pPlayer.m_entFirskingWep:InspectDestroyItem( net.ReadString(), net.ReadUInt(32) )
		end
	end )
elseif CLIENT then
	net.Receive( "gm_frisk", function( intMsgLen, pPlayer )
		local option = net.ReadUInt( 8 )
		if option == FRISK_OPEN_MENU then
			local target = net.ReadEntity()
			local num = net.ReadUInt( 16 )
			local items = {}

			for i = 1, num do
				items[net.ReadString()] = net.ReadUInt( 32 )
			end

			if ValidPanel( g_FriskMenu ) and g_FriskMenu:IsVisible() then
				g_FriskMenu:Update( target, items )
			else
				if ValidPanel( g_FriskMenu ) then g_FriskMenu:Remove() end
				g_FriskMenu = vgui.Create( "SRPFriskMenu" )
				g_FriskMenu:SetSize( 800, 480 )
				g_FriskMenu:Center()
				g_FriskMenu:Update( target, items )
				g_FriskMenu:Open()
			end
		elseif option == FRISK_CLOSE_MENU then
			if ValidPanel( g_FriskMenu ) then g_FriskMenu:Remove() end
		end
	end )
end


--[[ Dragging ]]--
function SWEP:PrimaryAttack()
	local Pos = self.Owner:GetShootPos()
	local Aim = self.Owner:GetAimVector()
	
	local Tr = util.TraceLine{
		start = Pos,
		endpos = Pos +Aim *self.Range,
		filter = player.GetAll(),
	}
	
	local HitEnt = Tr.Entity
	if self.Drag then 
		HitEnt = self.Drag.Entity
	else
		if SERVER and IsValid( HitEnt ) and GAMEMODE.Property:GetPropertyByDoor( HitEnt ) then
			self.Owner:EmitSound( "physics/wood/wood_crate_impact_hard3.wav" )
			self:SetNextPrimaryFire( CurTime() +0.25 )
			return
		end

		if not IsValid( HitEnt ) or HitEnt:GetMoveType() ~= MOVETYPE_VPHYSICS or
			HitEnt:IsVehicle() or HitEnt:GetNWBool( "NoDrag", false ) or
			HitEnt.BlockDrag or
			(HitEnt:GetClass() == "prop_physics_multiplayer" and HitEnt:GetDTBool(30)) or
			IsValid( HitEnt:GetParent() ) then 
			return
		end

		if HitEnt.CanPlayerDrag and not HitEnt:CanPlayerDrag( self.Owner ) then
			return
		end
		
		if not self.Drag then
			self.Drag = {
				OffPos = HitEnt:WorldToLocal(Tr.HitPos),
				Entity = HitEnt,
				Fraction = Tr.Fraction,
			}
		end
	end
	
	if CLIENT or not IsValid( HitEnt ) then return end
	
	local Phys = HitEnt:GetPhysicsObject()
	if IsValid( Phys ) then
		local Pos2 = Pos +Aim *self.Range *self.Drag.Fraction
		local OffPos = HitEnt:LocalToWorld( self.Drag.OffPos )
		local Dif = Pos2 -OffPos
		local Nom = (Dif:GetNormal() *math.min(1, Dif:Length() /100) *500 -Phys:GetVelocity()) *Phys:GetMass()
		
		Phys:ApplyForceOffset( Nom, OffPos )
		Phys:AddAngleVelocity( -Phys:GetAngleVelocity() /4 )
	end
end


if CLIENT then
	local x, y = ScrW() /2, ScrH() /2
	local MainCol = Color( 255, 255, 255, 255 )
	local Col = Color( 255, 255, 255, 255 )
	local box_w = 200
	local box_h = 40

	function SWEP:DrawHUD()
		if IsValid( self.Owner:GetVehicle() ) then return end
		local Pos = self.Owner:GetShootPos()
		local Aim = self.Owner:GetAimVector()
		
		local Tr = util.TraceLine{
			start = Pos,
			endpos = Pos +Aim *self.Range,
			filter = player.GetAll(),
		}
		
		local HitEnt = Tr.Entity
		if IsValid( HitEnt ) and HitEnt:GetMoveType() == MOVETYPE_VPHYSICS and
			not self.rDag and
			not HitEnt.BlockDrag and
			not HitEnt:IsVehicle() and
			not IsValid( HitEnt:GetParent() ) and
			not HitEnt:GetNWBool( "NoDrag", false ) and
			not (HitEnt:GetClass() == "prop_physics_multiplayer" and HitEnt:GetDTBool(30)) and
			not (HitEnt.CanPlayerDrag and not HitEnt:CanPlayerDrag(self.Owner)) and
			not HitEnt.HideDragOverlay
			then

			self.Time = math.min( 1, self.Time +2 *FrameTime() )
		else
			self.Time = math.max( 0, self.Time -2 *FrameTime() )
		end
		
		if self.Time > 0 then
			Col.a = MainCol.a *self.Time

			draw.SimpleText(
				"Drag",
				"DermaLarge",
				x,
				y,
				Col,
				TEXT_ALIGN_CENTER
			)
		end
		
		if self.Drag and IsValid( self.Drag.Entity ) then
			local Pos2 = Pos +Aim *100 *self.Drag.Fraction
			local OffPos = self.Drag.Entity:LocalToWorld( self.Drag.OffPos )
			local Dif = Pos2 -OffPos
			
			local A = OffPos:ToScreen()
			local B = Pos2:ToScreen()
			
			surface.DrawRect( A.x -2, A.y -2, 4, 4, MainCol )
			surface.DrawRect( B.x -2, B.y -2, 4, 4, MainCol )
			surface.DrawLine( A.x, A.y, B.x, B.y, MainCol )
		end

		local time = self:GetFriskStart()
		if time > CurTime() then
			local perc = 1 -( (time -CurTime()) /self.FriskDuration )
			
			local x = (ScrW() /2) -(box_w /2)
			local y = ScrH() -box_h *2
			
			draw.RoundedBox( 6, x, y, box_w, box_h, Color(0, 0, 0, 200) )
			draw.RoundedBox( 6, x +2, y +2, (box_w -4) *perc, box_h -4, Color(230, 60, 60) )
			draw.SimpleText( "Frisking", "handcuffTextSmall", (box_w /2) +x, (box_h /2) +y, color_white, 1, 1 )
		end
	end
end

function SWEP:PreDrawViewModel( vm, pl, wep )
	return true
end