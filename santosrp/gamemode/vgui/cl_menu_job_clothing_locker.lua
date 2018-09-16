local Panel = {}
function Panel:BuildList()
	self.m_tblList = {}
	self.m_intCurSelection = 0
	self.m_tblCurBodyGroups = {}
	local jobPath = GAMEMODE.Jobs:GetPlayerJob(LocalPlayer()):GetPlayerModel(LocalPlayer())
	local jobModel = ClientsideModel( jobPath )
	if jobModel:SkinCount() > 1 then
		for i = 0, jobModel:SkinCount() -1 do
			local idx = table.insert( self.m_tblList, {
				Skin = i,
				Model = jobPath,
			} )
			if LocalPlayer():GetSkin() == i and LocalPlayer():GetModel() == jobModel:GetModel() then
				self.m_intCurSelection = idx
			end
		end
	else
		self.m_intCurSelection = table.insert( self.m_tblList, {
			Skin = LocalPlayer():GetSkin(),
			Model = jobModel:GetModel(),
		} )
	end
	jobModel:Remove()
	if GAMEMODE.Jobs:GetPlayerJob( LocalPlayer() ).CanWearCivClothing then
		local civModel = GAMEMODE.Jobs:GetJobByID( JOB_CIVILIAN ):GetPlayerModel( LocalPlayer() )
		local civSkin = GAMEMODE.Player:GetGameVar( "char_skin", 0 )
		local idx = table.insert( self.m_tblList, {
			Skin = civSkin,
			Model = civModel,
		} )
		if LocalPlayer():GetSkin() == civSkin and LocalPlayer():GetModel() == civModel then
			self.m_intCurSelection = idx
		end
	end
	if GAMEMODE.Jobs:GetPlayerJob( LocalPlayer() ).ClothingLockerExtraModels then
		for k, v in pairs( GAMEMODE.Jobs:GetPlayerJob(LocalPlayer()).ClothingLockerExtraModels ) do
			local valid, mdl = GAMEMODE.Util:FaceMatchPlayerModel(
				GAMEMODE.Player:GetGameVar( LocalPlayer(), "char_model_base", "" ),
				GAMEMODE.Player:GetSharedGameVar( LocalPlayer(), "char_sex", GAMEMODE.Char.SEX_MALE ) == GAMEMODE.Char.SEX_MALE,
				v
			)
			if not valid then
				if GAMEMODE.Player:GetSharedGameVar( LocalPlayer(), "char_sex", GAMEMODE.Char.SEX_MALE ) == GAMEMODE.Char.SEX_MALE then
					mdl = v.Male_Fallback
				else
					mdl = v.Female_Fallback
				end
			end
			local tempModel = ClientsideModel( mdl )
			if tempModel:SkinCount() > 1 then
				for i = 0, tempModel:SkinCount() -1 do
					local idx = table.insert( self.m_tblList, {
						Skin = i,
						Model = mdl,
					} )
					if LocalPlayer():GetSkin() == i and LocalPlayer():GetModel() == tempModel:GetModel() then
						self.m_intCurSelection = idx
					end
				end
			else
				local idx = table.insert( self.m_tblList, {
					Skin = LocalPlayer():GetSkin(),
					Model = tempModel:GetModel(),
				} )
				if LocalPlayer():GetModel() == tempModel:GetModel() then
					self.m_intCurSelection = idx
				end
			end
			
			tempModel:Remove()
		end
	end
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
	if self.m_pnlCharacter then
		if self.m_pnlCharacter:GetModel() ~= cur.Model then
			self.m_tblCurBodyGroups = {}
		end
	end
	self.m_pnlCharacter:SetModel( cur.Model )
	self.m_pnlCharacter.Entity:SetSkin( cur.Skin )
	self.m_pnlCharacter.Entity:SetPos( Vector(0, 0, 30) )
	self:UpdateBodyGroups()
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
	if self.m_pnlCharacter then
		if self.m_pnlCharacter:GetModel() ~= cur.Model then
			self.m_tblCurBodyGroups = {}
		end
	end
	self.m_pnlCharacter:SetModel( cur.Model )
	self.m_pnlCharacter.Entity:SetSkin( cur.Skin )
	self.m_pnlCharacter.Entity:SetPos( Vector(0, 0, 30) )
	self:UpdateBodyGroups()
end
function Panel:UpdateBodyGroups()
	for k, v in pairs( self.m_tblCurBodyGroups ) do
		self.m_pnlCharacter.Entity:SetBodygroup( k, v )
	end
end
function Panel:ApplyBodygroup( intID, intValue )
	self.m_tblCurBodyGroups[intID] = intValue
	self.m_pnlCharacter.Entity:SetBodygroup( intID, intValue )
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
	self.m_pnlBtnBuySkin:SetText( "Apply Clothes" )
	self.m_pnlBtnBuySkin.m_strBtnText = "Apply Clothes"
	self.m_pnlBtnBuySkin.DoClick = function( pnl )
		if not self:GetCurrentSelection() then return end
		GAMEMODE.Net:RequestUpdateJobClothing( self:GetCurrentSelection().Skin, self:GetCurrentSelection().Model, self.m_tblCurBodyGroups )
		self:Close()
	end
	self.m_pnlBodyGroups = vgui.Create( "SRP_Button", self )
	self.m_pnlBodyGroups:SetFont( "DermaLarge" )
	self.m_pnlBodyGroups:SetText( "Edit Body Groups" )
	self.m_pnlBodyGroups:SetAlpha( 200 )
	self.m_pnlBodyGroups.DoClick = function()
		local contextMenu = DermaMenu( self )
		local ent = self.m_pnlCharacter.Entity
		local options = ent:GetBodyGroups()
		for k, v in pairs( options ) do
			if v.num <= 1 then continue end
			if v.num == 2 then -- If there's only 2 options, add it as a checkbox instead of a submenu
				local current = ent:GetBodygroup( v.id )
				local opposite = 1
				if current == opposite then opposite = 0 end
				local option = contextMenu:AddOption( v.name, function() self:ApplyBodygroup( v.id, opposite ) end )
				if current == 1 then
					option:SetChecked( true )
				end
			else -- More than 2 options we add our own submenu
				local groups = contextMenu:AddSubMenu( v.name )
				for i = 1, v.num do
					local modelname = "model #" .. i
					if v.submodels and v.submodels[i -1] ~= "" then modelname = v.submodels[i -1] end
					local option = groups:AddOption( modelname, function() self:ApplyBodygroup( v.id, i -1 ) end )
					if ent:GetBodygroup( v.id ) == i -1 then
						option:SetChecked( true )
					end
				end
			end
		end
		contextMenu:Open()
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
	self.m_pnlBodyGroups:SetSize( 250, 32 )
	self.m_pnlBodyGroups:SetPos( intW -self.m_pnlBodyGroups:GetWide(), 24 )
end
function Panel:Open()
	self:BuildList()
	local cur = self:GetCurrentSelection()
	if not cur then self:SetVisible( false ) return end
	self.m_pnlCharacter:SetModel( cur.Model )
	self.m_pnlCharacter.Entity:SetSkin( cur.Skin )
	self.m_pnlCharacter.Entity:SetPos( Vector(0, 0, 30) )
	for k, v in pairs( LocalPlayer():GetBodyGroups() ) do
		self.m_pnlCharacter.Entity:SetBodygroup( v.id, LocalPlayer():GetBodygroup(v.id) )
	end
	self:SetVisible( true )
	self:MakePopup()
end
function Panel:Close()
	self:SetVisible( false )
end
vgui.Register( "SRPJobClothingLockerMenu", Panel, "SRP_Frame" )