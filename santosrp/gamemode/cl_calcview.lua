--[[
	Name: cl_calcview.lua
	For: TalosLife
	By: TalosLife
]]--

vgui.GetWorldPanel():SetWorldClicker( false )  ---?

GM.Camera = {}
GM.Camera.m_conThirdPerson = CreateClientConVar( "srp_cam_third", 0, true, false )
GM.Camera.m_conSideMove = CreateClientConVar( "srp_cam_side", 24, true, false )
GM.Camera.m_conBackMove = CreateClientConVar( "srp_cam_back", 72, true, false )

--Table of weapon classes that will force the camera to first person when active
GM.Camera.m_tblFirstPersonWeps = {
	["weapon_phone"] = true,
}

local keyStateC, keyStateAlt
local lastViewAngle
local freeLookData = {}
local MAX_FREELOOK_UP = -45
local MAX_FREELOOK_DOWN = 45

local MIN_DIST_BACK = 24
local MIN_DIST_SIDE = 0
local MAX_DIST_BACK = 128
local MAX_DIST_SIDE = 32

local MovieMode_Pos = Vector(0,0,0)
local MovieMode_Ang = Vector(0,0,0)
function ToggleMovieMode() 
	MAIN_MOVIEMODE = !MAIN_MOVIEMODE 
	
	local lp = LocalPlayer()
	
	MovieMode_Pos = lp:GetShootPos()
	MovieMode_Ang = lp:GetAimVector()
end

function GM.Camera:LimitPos( vecPos, pPlayer, tblFilter )
	local vehicle = pPlayer:GetVehicle()

	local trData = {
		start = pPlayer:EyePos(),
		endpos = vecPos,
		mins = pPlayer:OBBMins() /2,
		maxs = pPlayer:OBBMaxs() /2,
		filter = tblFilter or { pPlayer },
	}

	local trForward = util.TraceHull( trData )
	if IsValid( trForward.Entity ) and trForward.Entity:IsPlayer() then
		table.insert( trData.filter, trForward.Entity )
		return self:LimitPos( vecPos, pPlayer, trData.filter )
	end

	if trForward.Hit and trForward.Entity ~= pPlayer and not trForward.Entity:IsPlayer() then
		return trForward.HitPos +trForward.HitNormal *1
	end
	
	return vecPos
end

function GM.Camera:LimitFreeLookAngles( angOld, angCur )
	print( angCur )
	angCur.p = math.Clamp( angCur.p, MAX_FREELOOK_DOWN, MAX_FREELOOK_UP )
	return angCur
end
--[[
function GM:CalcViewModelView( entWeapon, entViewModel, vecOldPos, angOldAng, vecPos, angAngles ) 
	-- Controls the position of all viewmodels
	local func = entWeapon.GetViewModelPosition
	if ( func ) then
		local pos, ang = func( entWeapon, vecPos *1, angAngles *1 )
		vm_origin = pos or vm_origin
		vm_angles = ang or vm_angles
	end

	-- Controls the position of individual viewmodels
	func = entWeapon.CalcViewModelView
	if ( func ) then
		local pos, ang = func( entWeapon, entViewModel, vecOldPos *1, angOldAng *1, vecPos *1, angAngles *1 )
		vm_origin = pos or vm_origin
		vm_angles = ang or vm_angles
	end

	--Toggle Freelook
	local IN_FREELOOK = LocalPlayer():KeyDown( IN_WALK ) and not LocalPlayer():InVehicle()
	if not keyStateAlt and IN_FREELOOK then
		keyStateAlt = true
		freeLookData.vm_origin = LocalPlayer():WorldToLocal( vm_origin )
		freeLookData.vm_angles = vm_angles
	elseif keyStateAlt and not IN_FREELOOK then
		keyStateAlt = false
		freeLookData = {}
	end

	if keyStateAlt and self.Camera.m_angCurFeelook then
		--local localAngs = LocalPlayer():WorldToLocalAngles( freeLookData.vm_angles )
		local ang = Angle( 0, 0, 0 )
		ang.y = freeLookData.vm_angles.y

		--if LocalPlayer():EyeAngles().p > MAX_FREELOOK_UP then
		----	ang.p = LocalPlayer():EyeAngles().p +MAX_FREELOOK_UP
		--elseif self.m_angCurFeelook.p > MAX_FREELOOK_DOWN then
		--	--ang.p = LocalPlayer():EyeAngles().p -MAX_FREELOOK_DOWN
		--	--print( ang.p )
		--end

		return LocalPlayer():LocalToWorld( freeLookData.vm_origin ), ang --freeLookData.vm_angles
	end
end]]--

function GM:CalcView( pPlayer, vecOrigin, ... )
	local viewData = self.Camera:CalcView( pPlayer, vecOrigin, ... )

	if viewData then
		if viewData.origin then g_CamPos = viewData.origin end
		return viewData
	end
end

function GM.Camera:CalcView( pPlayer, vecOrigin, angAngs, intFOV )
	if GAMEMODE.CiniCam:Running() then
		return GAMEMODE.CiniCam:CalcView( pPlayer, vecOrigin, angAngs, intFOV )
	end

	--Toggle the thirdperson convar
	if input.IsKeyDown( KEY_F1 ) and (not IsValid(vgui.GetKeyboardFocus())) then
		if not keyStateC then
			RunConsoleCommand( "srp_cam_third", self.m_conThirdPerson:GetInt() == 1 and "0" or "1" )
			keyStateC = true
		end
	else
		if keyStateC then keyStateC = false end
	end

	--Toggle Freelook
	local IN_FREELOOK = LocalPlayer():KeyDown( IN_WALK ) and not LocalPlayer():InVehicle()
	if not keyStateAlt and IN_FREELOOK then
		keyStateAlt = true
		--freeLookData.vm_origin = LocalPlayer():WorldToLocal( vm_origin )
		--freeLookData.vm_angles = vm_angles
	elseif keyStateAlt and not IN_FREELOOK then
		keyStateAlt = false
		freeLookData = {}
	end

	if IsValid( pPlayer:GetRagdoll() ) then
		local eyes = pPlayer:GetRagdoll():GetAttachment( pPlayer:GetRagdoll():LookupAttachment("eyes") )
		if eyes then
			return {
				origin = eyes.Pos,
				angles = eyes.Ang,
			}
		end
	elseif pPlayer:InVehicle() then
		local VC = pPlayer:GetVehicle()
		if IsValid( VC ) and VC:GetThirdPersonMode() then
			local Or = VC:GetPos()
			Or.z = vecOrigin.z

			local dist = VC:OBBMins():Distance( VC:OBBCenter() )
			dist = dist +((VC:GetCameraDistance() +1) *50)

			local tr = util.TraceLine{
				start = Or,
				endpos = Or -angAngs:Forward() *(dist *1.5),
				filter = { VC, pPlayer },
				mask = MASK_SOLID_BRUSHONLY,
			}
			
			local view = {}
			view.origin = tr.HitPos
			view.zfar = 65536
			return view
		end
	elseif self.m_conThirdPerson:GetInt() == 1 and (IsValid(LocalPlayer():GetActiveWeapon()) and not self.m_tblFirstPersonWeps[LocalPlayer():GetActiveWeapon():GetClass()]) then
		local backDistance = math.Clamp( self.m_conBackMove:GetInt(), MIN_DIST_BACK, MAX_DIST_BACK ) *-1
		local sideDistance = math.Clamp( self.m_conSideMove:GetInt(), MIN_DIST_SIDE, MAX_DIST_SIDE ) *1

		local view = {}
		view.origin = pPlayer:EyePos() +(pPlayer:EyeAngles():Forward() *backDistance) +(pPlayer:EyeAngles():Right() *sideDistance)
		view.origin = self:LimitPos( view.origin, pPlayer )
		view.angles = angAngs
		view.fov = intFOV
		view.zfar = 65536

		if keyStateAlt and not freeLookData.angles then
			freeLookData.angles = angAngs
		end

		if keyStateAlt then
			view.angles = angAngs --self:LimitFreeLookAngles( freeLookData.angles, angAngs )
			self.m_angCurFeelook = view.angles
			--return view
		end

		lastViewAngle = view.angles

		return view
	else
		if MAIN_MOVIEMODE then
			MovieMode_Pos = MovieMode_Pos +(vecOrigin -MovieMode_Pos) /32
			MovieMode_Ang = MovieMode_Ang +(angAngs:Forward() -MovieMode_Ang) /32
			
			local view = {}
			view.origin	= MovieMode_Pos
			view.angles	= MovieMode_Ang:Angle()
			view.zfar = 65536
			return view
		else
			return { zfar = 65536 }
		end
	end
end

function GM.Camera:DrawCrosshair()
	if self.m_conThirdPerson:GetInt() ~= 1 then return end
	if IsValid( LocalPlayer():GetActiveWeapon() ) and self.m_tblFirstPersonWeps[LocalPlayer():GetActiveWeapon():GetClass()] then return end
	
	local wide = 8 --crosshar size
	local drawPos = util.TraceLine{
		start = LocalPlayer():GetShootPos(),
		endpos = LocalPlayer():GetShootPos() +(LocalPlayer():GetAimVector() *9e9),
		filter = LocalPlayer(),
		mask = MASK_SHOT,
	}.HitPos:ToScreen()

	surface.SetDrawColor( 255, 0, 0, 255 )
	surface.DrawRect( drawPos.x -(wide /2), drawPos.y, wide +1, 1 )
	surface.DrawRect( drawPos.x, drawPos.y -(wide /2), 1, wide +1 )	
end

hook.Add( "HUDPaint", "ThirdpersonCrosshair", function()
	if LocalPlayer():InVehicle() or LocalPlayer():IsUsingComputer() then return end
	GAMEMODE.Camera:DrawCrosshair()
end )

function GM.Camera:ShouldDrawLocalPlayer()
	if LocalPlayer():InVehicle() then
		return false
	end
	
	if not IsValid( LocalPlayer():GetActiveWeapon() ) then return end
	if GAMEMODE.Camera.m_conThirdPerson:GetInt() == 1 and not GAMEMODE.Camera.m_tblFirstPersonWeps[LocalPlayer():GetActiveWeapon():GetClass()] then
		return true
	end
end

hook.Add( "PrePlayerDraw", "FixPlayerModel", function( pPlayer )
	if not freeLookData.angles then return end
	if pPlayer ~= LocalPlayer() then return end

	pPlayer:SetRenderAngles( Angle(0, freeLookData.angles.y, 0) )
end )

hook.Add( "CreateMove", "FreeLook_MoveFix", function( CUserCmd )
	if not freeLookData.angles then return end
	local moveVec = Vector( CUserCmd:GetForwardMove(), CUserCmd:GetSideMove(), 0 )
	local moveNormal = moveVec:GetNormal()
	local newMoveVec = (moveNormal:Angle() +(LocalPlayer():EyeAngles() -freeLookData.angles)):Forward() *moveVec:Length()

	CUserCmd:SetForwardMove( newMoveVec.x )
	CUserCmd:SetSideMove( newMoveVec.y )
end )