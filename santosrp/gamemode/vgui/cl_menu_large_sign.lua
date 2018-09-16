local signPos = Vector( -27.395447, 8, 38.821747 )
local signAng = Angle( 20.248, 9.762, 0 )
local MAX_LEN = 40
local MAX_LINES = 18


surface.CreateFont( "SignLargeFont_Preview", {
	size = 22,
	font = "Chawp",
	weight = 500,
} )

local Panel = {}
function Panel:Init()
	self:SetTitle( "Sign Menu" )
	self.m_pnlApplyBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlApplyBtn:SetFont( "CarMenuFont" )
	self.m_pnlApplyBtn:SetText( "Apply" )
	self.m_pnlApplyBtn:SetAlpha( 150 )
	self.m_pnlApplyBtn.DoClick = function()
		self.m_entSign:RequestSetText( self.m_pnlText:GetValue() )
	end

	self.m_pnlText = vgui.Create( "DTextEntry", self )
	self.m_pnlText:SetMultiline( true )
	self.m_pnlText:SetFont( "SignLargeFont_Preview" )



	function self.m_pnlText:AllowInput( intKey )
		local text = self:GetValue():sub( 0, self:GetCaretPos() )
		local lines = string.Explode( "\n", self:GetValue() )

		local line = 1
		for v in string.gmatch( text, "\n" ) do
			line = line + 1
		end

		if string.len(lines[line]) >= MAX_LEN then
			return true
		end
	end



	function self.m_pnlText:OnKeyCodeTyped( intKey )
		local lines = string.Explode( "\n", self:GetValue() )
		if #lines +1 > MAX_LINES and intKey == KEY_ENTER then
			return true
		end
	end



	function self.m_pnlText.OnValueChange( _, strValue )
		self.m_entSign.m_tblExplodedPreviewText = string.Explode( "\n", strValue )
	end
	function self.m_pnlText.GetUpdateOnType() return true end
end



function Panel:SetEntity( eEnt )
	if not eEnt.GetText then return end
	self.m_entSign = eEnt
	self.m_pnlText:SetValue( eEnt:GetText() )

	GAMEMODE.CiniCam:JumpFromTo( LocalPlayer():EyePos(), EyeAngles(), LocalPlayer():GetFOV(), 
		eEnt:LocalToWorld(signPos),
		eEnt:LocalToWorldAngles(signAng),
		LocalPlayer():GetFOV(),
		1,
		function()
		end
	)
end

function Panel:Think()
	if not IsValid( self.m_entSign ) then
		self:Close()
	end
end



function Panel:Close()
	self:SetVisible( false )
	self.m_entSign.m_tblExplodedPreviewText = nil
	self:Remove()
	GAMEMODE.CiniCam:ClearCamera()
end



function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )
	self.m_pnlApplyBtn:SetSize( intW, 32 )
	self.m_pnlApplyBtn:SetPos( 0, intH -self.m_pnlApplyBtn:GetTall() )
	self.m_pnlText:SetPos( 0, 24 )
	self.m_pnlText:SetSize( intW, intH -24 -self.m_pnlApplyBtn:GetTall() )
end

vgui.Register( "SRPLargeSignMenu", Panel, "SRP_Frame" )