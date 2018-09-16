--[[
	Name: sh_unconscious.lua
	For: santosrp
	By: Maw, Unknown? past devs, Rustic7
]]--

GM.Uncon = {}

if gspeak then
	function gspeak:player_alive( pPlayer )
		if not pPlayer:Alive() then return false end
		return not pPlayer:IsUncon()
	end
end

local pmeta = debug.getregistry().Player
function pmeta:IsUncon()
	return self:GetNWBool( "Uncon", false )
end

function pmeta:GetRagdoll()
	return self:GetNWEntity( "pl_ragdoll" )
end

function pmeta:IsRagdolled()
	return IsValid( self:GetRagdoll() )
end

--HACK!! This should maybe get gspeak to play nice
g_OldPlayerGetPos = g_OldPlayerGetPos or debug.getregistry().Entity.GetPos
debug.getregistry().Player.GetPos = function( pPlayer, ... )
	if pPlayer:IsRagdolled() then
		return pPlayer:GetRagdoll():GetPos()
	end

	return g_OldPlayerGetPos( pPlayer, ... )
end

if SERVER then
	function pmeta:BecomeRagdoll( intDuration, bNoWakeOnMotion )
		if IsValid( self:GetNWEntity("pl_ragdoll") ) then self:GetNWEntity( "pl_ragdoll" ):Remove() end
		
		local ragdoll = ents.Create( "prop_ragdoll" )
		ragdoll.RagdollPlayer = self
		ragdoll:SetPos( self:GetPos() +(vector_up *6))
		ragdoll:SetAngles( self:GetAngles() )
		ragdoll:SetModel( self:GetModel() )
		ragdoll:SetSkin( self:GetSkin() )
		ragdoll:Spawn()
		ragdoll:Activate()
		ragdoll:SetCollisionGroup( COLLISION_GROUP_VEHICLE )
		ragdoll.AdminPhysGun = true
		self:SetParent( ragdoll ) -- So their player will match up (position-wise) with where their ragdoll is.
		self:DeleteOnRemove( ragdoll )
		
		-- Copy bodygroups
		for k, v in pairs( self:GetBodyGroups() ) do
			ragdoll:SetBodygroup( v.id, self:GetBodygroup(v.id) )
		end

		-- Set velocity for each peice of the ragdoll
		local velocity = self:GetVelocity()
		velocity = Vector(
			math.Clamp( velocity.x, -5000, 5000 ),
			math.Clamp( velocity.y, -5000, 5000 ),
			math.Clamp( velocity.z, -5000, 5000 )
		)

		local idx = 1
		while true do
			local phys_obj = ragdoll:GetPhysicsObjectNum( idx )
			idx = idx +1

			if IsValid( phys_obj ) then
				phys_obj:SetVelocity( velocity )
			else
				break
			end
		end

		hook.Call( "GamemodeOnPlayerRagdolled", GAMEMODE, self, ragdoll )

		self.m_intLastHealth = self:Health()
		self:Spectate( OBS_MODE_CHASE )
		self:SpectateEntity( ragdoll )
		self:StripWeapons()
		self:SetNWEntity( "pl_ragdoll", ragdoll )

		if intDuration and intDuration > 0 then
			timer.Simple( intDuration, function()
				if IsValid( self ) and not self:Alive() then return end
				
				if IsValid( ragdoll ) and bNoWakeOnMotion and ragdoll:GetVelocity():Length() > 50 then
					local timerID = "CheckForRagdollMotion".. self:EntIndex()

					timer.Create( timerID, intDuration, 0, function()
						if not IsValid( self ) or not IsValid( ragdoll ) or not self:Alive() then
							timer.Destroy( timerID )
							return
						end

						if ragdoll:GetVelocity():Length() <= 50 then
							timer.Destroy( timerID )
							self:UnRagdoll()
						end
					end )
				elseif IsValid( self ) and IsValid( ragdoll ) then
					self:UnRagdoll()
				end
			end )
		end

		return ragdoll
	end

	function pmeta:UnRagdoll( bNoSpawn, bIgnoreHealth )
		local health = self:Health()
		local ragdoll = self:GetNWEntity( "pl_ragdoll" )
		self:SetParent()
		self:UnSpectate()

		if not IsValid( ragdoll ) then
			if not bNoSpawn then self:Spawn() end
		else
			local pos = ragdoll:GetPos() +Vector( 0, 0, 1 )
			if not bNoSpawn then
				self:Spawn()
			end

			local yaw = ragdoll:GetAngles().yaw
			self:SetAngles( Angle(0, yaw, 0) )
			self:SetPos( pos )
			self:SetVelocity( ragdoll:GetVelocity() )	
			ragdoll:Remove()

			GAMEMODE.Util:UnstuckPlayer( self )
		end

		if not bIgnoreHealth then
			self:SetHealth( math.max(1, health) )-- math.max(1, self.m_intLastHealth) )
		end

		hook.Call( "GamemodeOnPlayerUnRagdolled", GAMEMODE, self )
	end

	function pmeta:GoUncon( bDontRagdoll, bPlayerDead )
		--if self:IsUncon() then return end
		hook.Call( "GamemodePrePlayerGoUncon", {}, self )
		self:SendLua( [[GAMEMODE:OnSpawnMenuClose()]] )

		self.m_intOldHealth = self:Health()
		self:SetNWBool( "Uncon", true )

		if not bDontRagdoll then
			self:BecomeRagdoll( nil, true ).IsUncon = true
		end

		local noMedics = GAMEMODE.Jobs:GetNumPlayers( JOB_EMS ) <= 0
		if bPlayerDead then
			self:SetNWFloat( "StartDie", CurTime() -(7 *60) )
		else
			self:SetNWFloat( "StartDie", CurTime() -(noMedics and 3 *60 or 0) )
		end
		hook.Call( "GamemodePlayerGoUncon", {}, self )
		
		local index = self:EntIndex()
		timer.Create( "Moan".. index, 15, 0, function()
			if IsValid( self ) and self:IsUncon() then 
				self:EmitSound( "vo/npc/male01/moan0".. math.random(1, 5), 85 )
			else
				timer.Destroy( "Moan".. index )
			end
		end )

		self.NextBeat = CurTime()
	end

	function pmeta:WakeUp( bNoSpawn, bKeepVars, bIgnoreHealth )
		if self:IsUncon() then
			local health = self:Health()
			self.m_bKeepUnconOnSpawn = true
			self:UnRagdoll( bNoSpawn, bIgnoreHealth )

			if not bKeepVars then
				self:SetNWBool( "Uncon", false )
				self:SetNWFloat( "StartDie", 0 )
				self.NextBeat = nil
				self:EmitSound( "vo/npc/male01/moan04.wav", 90, 90, 1, CHAN_VOICE )
				timer.Destroy( "Moan".. self:EntIndex() )

				if not bIgnoreHealth then
					self:SetHealth( math.max(1, health) ) --self.m_intLastHealth or 0) )
				end
			end

			if self:InVehicle() and self:GetVehicle().IsStretcher then
				self:ExitVehicle()
			end
		end
	end

	function GM.Uncon:HealthOverTime( int ) --x = health, y = time. Quadratic health loss system.
		return ( -(int *int) /(600 *12) ) +50
	end

	function GM.Uncon:BeatsPerSecond( int ) --x = beats, y = time. Heart slows down before death.
		return ( ((-int *int) /(600 *12)) +110 ) /60
	end
	
	function GM.Uncon:Tick()
		for k, v in pairs( player.GetAll() ) do
			if not v:IsUncon() then continue end
			
			if v:InVehicle() then
				if not v:GetVehicle().IsStretcher then
					v:ExitVehicle()
					return
				end

				v:SetNWFloat( "StartDie", CurTime() )
			end
			
			local startdie = v:GetNWFloat( "StartDie" )
			v:SetHealth( math.Round(self:HealthOverTime(CurTime() -startdie)) )
			
			if v:Health() < 1 then
				--On Death.
				local rag = v:GetNWEntity( "pl_ragdoll" )
				local positions = {}

				if IsValid( rag ) then
					for i = 0, rag:GetBoneCount() -1 do
						positions[i] = rag:GetBonePosition( i )
					end
				end
				
				v:WakeUp( nil, nil, true )
				v.m_bSkipDeathWait = true
				hook.Call( "GamemodeOnCharacterDeath", GAMEMODE, v )
				v:Kill()
				
				local deathrag = v:GetRagdollEntity()
				if IsValid( deathrag ) then
					for k, v in pairs( positions ) do
						if not deathrag.SetBonePosition then continue end --wtf is with that error?
						deathrag:SetBonePosition( k, v )
					end
				end
			end

			if v.NextBeat and CurTime() >= v.NextBeat then
				v.NextBeat = CurTime() +self:BeatsPerSecond( CurTime() -startdie )

				if IsValid( v:GetRagdoll() ) then
					--v:GetRagdoll():EmitSound( "santosrp/heartbeat.wav", 60, 100, 1, CHAN_AUTO )
				end
			end
		end
	end

	function GM.Uncon:PlayerSpawn( pPlayer )
		if pPlayer:IsUncon() then
			if pPlayer.m_bKeepUnconOnSpawn then
				pPlayer.m_bKeepUnconOnSpawn = nil
				return
			end
			
			pPlayer:WakeUp( true )
		elseif pPlayer:IsRagdolled() then
			pPlayer:UnRagdoll( true )
		end
	end

	function GM.Uncon:EntityTakeDamage( eEnt, pDamageInfo )
		if eEnt:IsPlayer() then
			if pDamageInfo:GetDamage() >= eEnt:Health() then
				eEnt:GoUncon()
				return true
			end
		end

		--if eEnt:IsPlayer() then
		--	if not eEnt:IsUncon() then
		--		if pDamageInfo:GetDamageType() == 17 then
		--			pDamageInfo:ScaleDamage( 0.5 )
		--		end
--
		--		if pDamageInfo:GetDamage() <= 80 and pDamageInfo:GetDamage() >= eEnt:Health() then
		--			eEnt:GoUncon()
		--			return true
		--		end
		--	else
		--		--Finish him faster if it's intentional.
		--		if pDamageInfo:GetAttacker():IsPlayer() then
		--			pDamageInfo:ScaleDamage( 1.5 )
		--		end
		--	end
		--end
		
		if eEnt:IsRagdoll() then
			if IsValid( eEnt.RagdollPlayer ) then --and eEnt.RagdollPlayer:IsUncon() then
				if eEnt.RagdollPlayer:Alive() then
					pDamageInfo:ScaleDamage( 0.33 )
					eEnt.RagdollPlayer:TakeDamageInfo( pDamageInfo )
					
					if eEnt:GetBonePosition(eEnt:LookupBone('ValveBiped.Bip01_Head1')):Distance(pDamageInfo:GetDamagePosition()) <10 then
						eEnt.RagdollPlayer:WakeUp( nil, nil, true )
						eEnt.RagdollPlayer.m_bSkipDeathWait = true
						hook.Call( "GamemodeOnCharacterDeath", GAMEMODE, eEnt.RagdollPlayer )
						eEnt.RagdollPlayer:Kill()
					end
				end
				return true
			end
		end
	end
	
	function GM.Uncon:PlayerDeath( pPlayer )
		--
	end

	function GM:CreateEntityRagdoll( eEnt, entRagdoll )
		if eEnt:IsPlayer() and entRagdoll then entRagdoll:Remove() end
	end
	
	function GM.Uncon:CanPlayerEnterVehicle( pPlayer, entCar )
		if pPlayer:IsUncon() and not entCar.IsStretcher then return false end
	end

	function GM.Uncon:DoPlayerDeath( pPlayer, pAttacker, pDamageInfo )
		if pPlayer:IsUncon() then
			pPlayer:WakeUp()
		end

		if not pPlayer:IsRagdolled() then
			pPlayer:BecomeRagdoll( 0 )
		end
	end

	concommand.Add( "srp_dev_unrag", function( pPlayer )
		if not DEV_SERVER then
			if not pPlayer:IsSuperAdmin() then return end
		end
		
		if pPlayer:IsUncon() then
			pPlayer:WakeUp()
		elseif pPlayer:IsRagdolled() then
			pPlayer:UnRagdoll()
		end
	end )
else
	local mat = Material( "nomad/vignette_death.png", "unlitgeneric ignorez" )

	function GM.Uncon:PaintUnconOverlay()
		local ply = LocalPlayer()

		if ply:IsUncon() then
			DrawMotionBlur( 0.055, 1, 0.001 )
			surface.SetMaterial( mat )
			surface.SetDrawColor( Color(255, 255, 255, 255) )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
			
			draw.NoTexture()
			surface.SetDrawColor( Color(0, 0, 0, (math.abs(math.cos(RealTime() *0.2)) +.2) *255) )
			surface.DrawRect( 0, 0, ScrW(), ScrH() )

			if not ply:InVehicle() then
				local timeelapsed = CurTime() -ply:GetNWFloat( "StartDie" )
				local text = string.ToMinutesSeconds( 600 -timeelapsed )
				draw.SimpleText( text, "Trebuchet24", ScrW() /2, 200, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( text, "Trebuchet24", ScrW() /2 +2, 200 +2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				local text = "Stabilized"
				draw.SimpleText( text, "Trebuchet24", ScrW() /2, 200, Color(0, 200, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( text, "Trebuchet24", ScrW() /2 +2, 200+2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
	end
end