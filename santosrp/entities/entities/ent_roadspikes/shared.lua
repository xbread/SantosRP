ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

if SERVER then return end
function ENT:Initialize()
	self.DeployPos = 0
end

function ENT:Think()
	if(self:GetNWInt("deployed")) then
		self.DeployPos = math.Clamp(self.DeployPos + FrameTime() * 2, 0.1, 1)
	else
		self.DeployPos = math.Clamp(self.DeployPos - FrameTime() * 2, 0.1, 1)
	end
end

function ENT:Draw()
	local o = self:GetPos()
	local v = Vector((1 - self.DeployPos) * self:OBBMaxs().x, 0, 0)
	v:Rotate(self:GetAngles())
	
	self:SetRenderOrigin(o - v)
	local mat = Matrix()
	mat:Scale(Vector(self.DeployPos, self.DeployPos, 1))
	
	self:EnableMatrix("RenderMultiply",mat)
	self:DrawModel()
	
	self:SetRenderOrigin(o)
end