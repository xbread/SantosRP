--[[
	Name: cl_menu_jail_bail.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:Init()
	self.m_colPrice = Color( 120, 230, 110, 255 )

	self.m_pnlAvatar = vgui.Create( "AvatarImage", self )

	self.m_pnlBtn = vgui.Create( "SRP_Button", self )
	self.m_pnlBtn:SetFont( "CarMenuFont" )
	self.m_pnlBtn:SetText( "Release" )
	self.m_pnlBtn:SetAlpha( 150 )
	self.m_pnlBtn.DoClick = function()
		GAMEMODE.Gui:Derma_Query(
			"Are you sure you want to bail out this player?",
			"Bail Player Out Of Jail",
			"Yes",
			function()
				GAMEMODE.Net:RequestBailPlayer( self.m_pPlayer )
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

	self.m_pnlPriceLabel = vgui.Create( "DLabel", self )
	self.m_pnlPriceLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )
	self.m_pnlPriceLabel:SetTextColor( self.m_colPrice )
	self.m_pnlPriceLabel:SetFont( "Trebuchet24" )
end

function Panel:SetPlayer( pPlayer )
	self.m_pPlayer = pPlayer
	self.m_pnlNameLabel:SetText( pPlayer:Nick() )
	self.m_pnlAvatar:SetPlayer( pPlayer )
	self.m_pnlPriceLabel:SetText( "Bail Cost: $".. string.Comma(GAMEMODE.Jail:GetPlayerBailPrice(pPlayer) or 0) )

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
	self.m_pnlNameLabel:SetPos( (padding *2) +intH, (intH /2) -self.m_pnlNameLabel:GetTall() )

	self.m_pnlPriceLabel:SizeToContents()
	self.m_pnlPriceLabel:SetWide( intW )
	self.m_pnlPriceLabel:SetPos( (padding *2) +intH, (intH /2) +(self.m_pnlNameLabel:GetTall() /2) -(self.m_pnlNameLabel:GetTall() /2) )

	self.m_pnlBtn:SetSize( 110, intH )
	self.m_pnlBtn:SetPos( intW -self.m_pnlBtn:GetWide(), 0 )
end
vgui.Register( "SRPJailBailCard", Panel, "EditablePanel" )

-- ----------------------------------------------------------------

local Panel = {}
function Panel:Init()
	self:SetDeleteOnClose( false )
	self:SetTitle( "Jail Bail Out Menu" )
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
	local pnl = vgui.Create( "SRPJailBailCard" )
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
vgui.Register( "SRPJailBailMenu", Panel, "SRP_Frame" )