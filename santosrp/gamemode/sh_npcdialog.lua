--[[
	Name: sh_npcdialog.lua
	For: TalosLife
	By: TalosLife
]]--

GM.Dialog = {}

if CLIENT then
	GM.Dialog.m_tblDialogIDs = {}

	function GM.Dialog:RegisterDialog( strDialogID, funcOpenDialog, tblMeta )
		self.m_tblDialogIDs[strDialogID] = { func = funcOpenDialog, meta = tblMeta }
	end

	function GM.Dialog:OpenDialog( strDialogID )
		local data = self.m_tblDialogIDs[strDialogID]
		if not data then return end
		data.func( data.meta )
	end

	function GM.Dialog:ShowDialog()
		if not ValidPanel( self.m_pnlNPCDialog ) then
			self.m_pnlNPCDialog = vgui.Create( "SRPNPCDialog" )
			self.m_pnlNPCDialog:SetSize( 600, 134 )
			self.m_pnlNPCDialog:SetPos( (ScrW() /2) -(self.m_pnlNPCDialog:GetWide() /2), (ScrH() *0.8) -self.m_pnlNPCDialog:GetTall() )
		end

		self.m_pnlNPCDialog:SetVisible( true )
		self.m_pnlNPCDialog:MakePopup()

		self:Clear()
	end

	function GM.Dialog:HideDialog()
		self.m_pnlNPCDialog:SetVisible( false )
	end

	function GM.Dialog:SetPrompt( strPrompt )
		self.m_pnlNPCDialog:SetPrompt( strPrompt )
	end

	function GM.Dialog:SetTitle( strTitle )
		self.m_pnlNPCDialog:SetTitle( strTitle )
	end

	function GM.Dialog:SetModel( strModel )
		self.m_pnlNPCDialog:SetModel( strModel )
	end

	function GM.Dialog:AddOption( strText, funcCallback )
		self.m_pnlNPCDialog:AddOption( strText, funcCallback )
	end

	function GM.Dialog:Clear()
		self.m_pnlNPCDialog:Clear()
	end
elseif SERVER then
	GM.Dialog.m_tblDialogEvents = {}

	function GM.Dialog:RegisterDialogEvent( strEventName, funcCallback, tblCallbackMeta )
		self.m_tblDialogEvents[strEventName] = { func = funcCallback, meta = tblCallbackMeta }
	end

	function GM.Dialog:FireDialogEvent( pPlayer, strEventName, ... )
		if not self.m_tblDialogEvents[strEventName] then return end
		local data = self.m_tblDialogEvents[strEventName]

		if data.meta then
			data.func( data.meta, pPlayer, ... )
		else
			data.func( pPlayer, ... )
		end
	end
end