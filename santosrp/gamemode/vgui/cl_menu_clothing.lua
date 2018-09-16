--[[
	Name: cl_menu_clothing.lua
	For: TalosLife
	By: TalosLife
]]--

local Panel = {}
function Panel:BuildList()
	self.m_tblList = {}
	self.m_intCurSelection = 0

	local defModel = ClientsideModel( GAMEMODE.Player:GetGameVar("char_model_base", "") )
	local curModel = LocalPlayer():GetModel()

	for i = 0, defModel:SkinCount() -1 do
		local idx = table.insert( self.m_tblList, {
			--Type = "skin",
			Skin = i,
			Model = defModel:GetModel(),
		} )

		if curModel == defModel:GetModel() then
			if LocalPlayer():GetSkin() == i then
				self.m_intCurSelection = idx
			end
		end
	end

	for k, v in pairs( GAMEMODE.Config.PlayerModelOverloads[GAMEMODE.Player:GetSharedGameVar(LocalPlayer(), "char_sex", 0) == 0 and "Male" or "Female"] ) do
		if defModel:GetModel():find( k ) then
			for _, mdl in pairs( v ) do
				--Add all the skins for this overload model
				local haxModel = ClientsideModel( mdl )
				for i = 0, haxModel:SkinCount() -1 do
					local idx = table.insert( self.m_tblList, {
						--Type = "model",
						Skin = i,
						Model = mdl,
					} )

					if curModel == mdl then
						if LocalPlayer():GetSkin() == i then
							self.m_intCurSelection = idx
						end
					end		
				end

				haxModel:Remove()
			end

			break
		end
	end

	defModel:Remove()
end

function Panel:GetCurrentSelection()
	return self.m_tblList[self.m_intCurSelection]
end

function Panel:NextSelection()
	self.m_intCurSelection = self.m_intCurSelection +1
	if #self.m_tblList < self.m_intCurSelection then
		self.m_intCurSelection = 1
	end

	if not GAMEMODE.Util:ValidPlayerSkin( self:GetCurrentSelection().Model, self:GetCurrentSelection().Skin ) then
		self:NextSelection()
		return
	end

	local cur = self:GetCurrentSelection()
	self.m_pnlCharacter:SetModel( cur.Model )
	self.m_pnlCharacter.Entity:SetSkin( cur.Skin )
	self.m_pnlCharacter.Entity:SetPos( Vector(0, 0, 30) )
end

function Panel:PrevSelection()
	self.m_intCurSelection = self.m_intCurSelection -1
	if self.m_intCurSelection <= 0 then
		self.m_intCurSelection = #self.m_tblList
	end

	if not GAMEMODE.Util:ValidPlayerSkin( self:GetCurrentSelection().Model, self:GetCurrentSelection().Skin ) then
		self:PrevSelection()
		return
	end

	local cur = self:GetCurrentSelection()
	self.m_pnlCharacter:SetModel( cur.Model )
	self.m_pnlCharacter.Entity:SetSkin( cur.Skin )
	self.m_pnlCharacter.Entity:SetPos( Vector(0, 0, 30) )
end

function Panel:Init()
	self:SetTitle( "Clothing Selection" )
	self:SetDeleteOnClose( false )
	self.m_colBtnText = Color( 220, 220, 220, 150 )
	self.m_colBtnTextDis = Color( 150, 150, 150, 150 )

	self.m_pnlCharacter = vgui.Create( "DModelPanel", self )
	self.m_pnlCharacter:SetCamPos( Vector(50, 0, 60) )
	self.m_pnlCharacter:SetLookAt( Vector(0, 0, 60) )
	self.m_pnlCharacter:SetFOV( 50 )
	self.m_pnlCharacter.LayoutEntity = function( pnl, ent )
		ent.GetPlayerColor = function() return pnl.ColVector or Vector(1,1,1) end
		ent:SetPoseParameter( "head_yaw", ((gui.MouseX() /ScrW()) -0.45) *200 )
		ent:SetPoseParameter( "head_pitch", ((gui.MouseY() /ScrH()) -0.3) *200 )
	end

	self.m_pnlBtnNext = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnNext:SetFont( "DermaLarge" )
	self.m_pnlBtnNext:SetText( "<" )
	self.m_pnlBtnNext.DoClick = function( pnl )
		self:NextSelection()
	end

	self.m_pnlBtnPrev = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnPrev:SetFont( "DermaLarge" )
	self.m_pnlBtnPrev:SetText( ">" )
	self.m_pnlBtnPrev.DoClick = function( pnl )
		self:PrevSelection()
	end

	self.m_pnlBtnBuySkin = vgui.Create( "SRP_Button", self )
	self.m_pnlBtnBuySkin:SetText( ("Purchase Clothes ($%s)"):format(GAMEMODE.Config.ClothingPrice) )
	self.m_pnlBtnBuySkin.m_strBtnText = ("Purchase Clothes ($%s)"):format( GAMEMODE.Config.ClothingPrice )
	self.m_pnlBtnBuySkin.DoClick = function( pnl )
		GAMEMODE.Net:BuyCharacterClothing( self:GetCurrentSelection().Skin, self:GetCurrentSelection().Model )
		self:Close()
	end

	self.m_pnlBtnBuySkin.Think = function( pnl )
		local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", GAMEMODE.Config.ClothingPrice )
		self.m_pnlBtnBuySkin:SetText( ("Purchase Clothes ($%s)"):format(price) )
		pnl:SetDisabled( LocalPlayer():GetSkin() == self:GetCurrentSelection().Skin and LocalPlayer():GetModel() == self:GetCurrentSelection().Model )
	end
end

function Panel:PerformLayout( intW, intH )
	DFrame.PerformLayout( self, intW, intH )
	local padding, titleHeight = 5, 32

	local cx, cy = self.m_pnlCharacter:GetPos()
	self.m_pnlBtnNext:SetSize( 64, 64 )
	self.m_pnlBtnNext:SetPos( cx -self.m_pnlBtnNext:GetWide() -padding, (intH /2) -(self.m_pnlBtnNext:GetTall() /2) )

	self.m_pnlBtnPrev:SetSize( 64, 64 )
	self.m_pnlBtnPrev:SetPos( cx +self.m_pnlCharacter:GetWide() +padding, (intH /2) -(self.m_pnlBtnPrev:GetTall() /2) )

	self.m_pnlBtnBuySkin:SetSize( intW, 48 )
	self.m_pnlBtnBuySkin:SetPos( 0, intH -self.m_pnlBtnBuySkin:GetTall() )

	self.m_pnlCharacter:SetSize( intW *0.33 -(padding *2), intH -(padding *2) -titleHeight -self.m_pnlBtnBuySkin:GetTall() -padding )
	self.m_pnlCharacter:SetPos( (intW /2) -(self.m_pnlCharacter:GetWide() /2), titleHeight +padding )
end

function Panel:Open()
	self:BuildList()

	local cur = self:GetCurrentSelection()
	if not cur then self:SetVisible( false ) return end
	
	self.m_pnlCharacter:SetModel( cur.Model )
	self.m_pnlCharacter.Entity:SetSkin( cur.Skin )
	self.m_pnlCharacter.Entity:SetPos( Vector(0, 0, 30) )

	self:SetVisible( true )
	self:MakePopup()
end

function Panel:OnClose()
	GAMEMODE.Net:SendNPCDialogEvent( "clothing_clerk_end_dialog" )
end
vgui.Register( "SRPClothingMenu", Panel, "SRP_Frame" )