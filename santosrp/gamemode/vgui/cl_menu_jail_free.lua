--[[
	Name: cl_menu_jail_free.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_pnlAvatar = vgui.Create( "AvatarImage", self )

	self.m_pnlBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlBtn:SetFont( "CarMenuFont" )
	self.m_pnlBtn:SetText( "Release" )
	self.m_pnlBtn:SetAlpha( 150 )
	self.m_pnlBtn.DoClick = function()
		GAMEMODE.Gui:Derma_Query(
			"Are you sure you want to release this player early?",
			"Release Player From Jail",
			"Yes",
			function()
				GAMEMODE.Gui:StringRequest(
					"Release Player From Jail",
					"Enter Reason For Early Release",
					"",
					function( strText )
						GAMEMODE.Net:RequestFreePlayer( self.m_pPlayer, strText )
					end,
					function()
					end,
					"Submit",
					"Cancel",
					GAMEMODE.Config.MaxJailFreeReasonLen
				)
			end,
			"No",
			function()
			end
		)
	end

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )
	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )
	self.m_pnlNameLabel:SetFont( "CarMenuFont" )
end

function Panel:SetPlayer( pPlayer )
	self.m_pPlayer = pPlayer
	self.m_pnlNameLabel:SetText( pPlayer:Nick() )
	self.m_pnlAvatar:SetPlayer( pPlayer )
	self:InvalidateLayout()
end

function Panel:Think()
	if not IsValid( self.m_pPlayer ) or not GAMEMODE.Jail:IsPlayerInJail( self.m_pPlayer ) then
		self.m_pnlParentMenu:Populate()
	end
end

function Panel:Paint( intW, intH )
	surface.SetDrawColor( 50, 50, 50, 200 )
	surface.DrawRect( 0, 0, intW, intH )
end

function Panel:PerformLayout( intW, intH )
	local padding = 5

	self.m_pnlAvatar:SetPos( 0, 0 )
	self.m_pnlAvatar:SetSize( intH, intH )

	self.m_pnlNameLabel:SizeToContents()
	self.m_pnlNameLabel:SetWide( intW )
	self.m_pnlNameLabel:SetPos( (padding *2) +intH, (intH /2) -(self.m_pnlNameLabel:GetTall() /2) )

	self.m_pnlBtn:SetSize( 110, intH )
	self.m_pnlBtn:SetPos( intW -self.m_pnlBtn:GetWide(), 0 )
end
vgui.Register( "SRPJailFreeCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetDeleteOnClose( false )
	self:SetTitle( "Jail Release Menu" )
	self.m_pnlCanvas = vgui.Create( "SRP_ScrollPanel", self )
	self.m_tblCards = {}
end

function Panel:Populate()
	self.m_pnlCanvas:Clear( true )
	self.m_tblCards = {}

	for k, v in pairs( player.GetAll() ) do
		if not GAMEMODE.Jail:IsPlayerInJail( v ) then continue end
		self:CreatePlayerCard( v )
	end

	self:InvalidateLayout()
end

function Panel:CreatePlayerCard( pPlayer )
	local pnl = vgui.Create( "SRPJailFreeCard" )
	pnl:SetPlayer( pPlayer )
	pnl.m_pnlParentMenu = self
	self.m_pnlCanvas:AddItem( pnl )
	self.m_tblCards[#self.m_tblCards +1] = pnl

	return pnl
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )

	self.m_pnlCanvas:SetPos( 0, 24 )
	self.m_pnlCanvas:SetSize( intW, intH -24 )

	for _, pnl in pairs( self.m_tblCards ) do
		pnl:DockMargin( 0, 0, 0, 5 )
		pnl:SetTall( 64 )
		pnl:Dock( TOP )
	end
end

function Panel:Open()
	self:Populate()
	self:SetVisible( true )
	self:MakePopup()
end

function Panel:OnClose()
	GAMEMODE.Net:SendNPCDialogEvent( "cop_jail_warden_end_dialog" )
end
vgui.Register( "SRPJailFreeMenu", Panel, "SRP_Frame" )