--[[
	Name: cl_cinicam.lua
	For:
	By: TalosLife
]]--

GM.CiniCam = {}
GM.CiniCam.m_tblVars = {}

function GM.CiniCam:Running()
	return (self.m_tblVars.Done or self.m_tblVars.StartTime) and true or false
end

function GM.CiniCam:ClearCamera()
	self.m_tblVars = {}
end

function GM.CiniCam:CalcView( pPlayer, vecOrigin, angAngs, intFOV )
	if not self.m_tblVars.StartTime then return end

	return {
		origin = self.m_tblVars.Current.pos,
		angles = self.m_tblVars.Current.ang,
		fov = self.m_tblVars.Current.fov,
	}
end

function GM.CiniCam:Think()
	if not self.m_tblVars.StartTime then return end

	if RealTime() >= self.m_tblVars.StartTime +self.m_tblVars.Length then
		self.m_tblVars.Done = true

		if self.m_tblVars.Callback and not self.m_tblVars.DoneCallback then
			self.m_tblVars.DoneCallback = true
			self.m_tblVars.Callback()
		end
	end

	local frac = (RealTime() -self.m_tblVars.StartTime) /self.m_tblVars.Length

	local vecTo = self.m_tblVars.To.pos
	local angTo = self.m_tblVars.To.ang
	if IsValid( self.m_tblVars.Follow ) then
		vecTo = self.m_tblVars.Follow:LocalToWorld( vecTo )
		angTo = self.m_tblVars.Follow:LocalToWorldAngles( angTo )
	end

	frac = math.Clamp( frac, 0, 1 )
	self.m_tblVars.Current.pos = LerpVector( frac, self.m_tblVars.From.pos, vecTo )
	self.m_tblVars.Current.ang = LerpAngle( frac, self.m_tblVars.From.ang, angTo )
	self.m_tblVars.Current.fov = Lerp( frac, self.m_tblVars.From.fov, self.m_tblVars.To.fov )
end

function GM.CiniCam:JumpFromTo( vFrom, aFrom, intFovFrom, vTo, aTo, intFOVTo, intLen, funcCallback )
	self:ClearCamera()

	self.m_tblVars = {
		From = { pos = vFrom, ang = aFrom, fov = intFovFrom },
		To = { pos = vTo, ang = aTo, fov = intFOVTo },
		Current = { pos = vFrom, ang = aFrom, fov = intFovFrom },

		Callback = funcCallback,
		Length = intLen,
		StartTime = RealTime(),
	}
end

function GM.CiniCam:JumpFromToFollow( entFollow, vFrom, aFrom, intFovFrom, vTo, aTo, intFOVTo, intLen, funcCallback )
	self:ClearCamera()

	self.m_tblVars = {
		From = { pos = vFrom, ang = aFrom, fov = intFovFrom },
		To = { pos = vTo, ang = aTo, fov = intFOVTo },
		Current = { pos = vFrom, ang = aFrom, fov = intFovFrom },

		Callback = funcCallback,
		Length = intLen,
		StartTime = RealTime(),
		Follow = entFollow,
	}
end