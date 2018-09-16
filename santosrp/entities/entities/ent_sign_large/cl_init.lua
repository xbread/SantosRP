--[[
	Name: cl_init.lua
	For: SantosRP
	By: TalosLife
]]--

include "shared.lua"

surface.CreateFont( "SignLargeFont_Fixed", {
	size = 94,
	font = "BudgetLabel",
	weight = 400,
} )

function ENT:Initialize()
	self.m_vecCamPos = Vector( 14.803040, 0.7, 25.132034 )
	self.m_angCamAng = Angle( 0, -180, 90 )

	if g_LargeSignEntCache[self:EntIndex()] then
		self:SetText( g_LargeSignEntCache[self:EntIndex()] or "" )
	end
end

function ENT:WrapString( strText, intLimit, strIndent, indent1 )
	strIndent = strIndent or ""
	indent1 = indent1 or strIndent
	intLimit = intLimit or 72

	local here = 1 -#indent1
	return indent1.. strText:gsub( "(%s+)()(%S+)()", function( sp, st, word, fi )
		if fi -here > intLimit then
			here = st -#strIndent
			return "\n".. strIndent.. word
		end
	end )
end

function ENT:SetText( strText )
	if strText:len() > self.m_intMaxTextLen then return end
	self.m_strText = strText
	--self.m_strDrawText = self:WrapString( strText, 20 )
	self.m_tblExplodedText = string.Explode( "\n", self.m_strText )

	if #self.m_tblExplodedText > self.m_intMaxLines then
		self.m_tblExplodedText = nil
		self.m_strDrawText = nil
		return
	end
end

function ENT:GetText()
	return self.m_strText or ""
end

function ENT:RenderText()
	render.PushFilterMag( TEXFILTER.POINT )
	render.PushFilterMin( TEXFILTER.POINT ) 
	cam.Start3D2D( self:LocalToWorld(self.m_vecCamPos), self:LocalToWorldAngles(self.m_angCamAng), 0.035 )
		render.ClearStencil()
		render.SetStencilEnable( true )
		render.SetStencilReferenceValue( 1 )
		render.SetStencilTestMask( 1 )
		render.SetStencilWriteMask( 1 )

		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
		render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )

		surface.SetDrawColor( 30, 30, 30, 255 )
		surface.DrawRect( 0, 0, 845, 1245 )

		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilPassOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
			surface.SetDrawColor( 30, 30, 30, 255 )
			surface.DrawRect( 0, 0, 845, 1245 )

			local yPos, w, h = 0, nil, nil
			for k, v in pairs( self.m_tblExplodedText or {} ) do
				draw.SimpleText(
					v,
					"SignLargeFont_Fixed",
					15,
					yPos,
					self.m_colTextColor,
					TEXT_ALIGN_LEFT,
					TEXT_ALIGN_LEFT
				)

				surface.SetFont( "SignLargeFont_Fixed" )
				w, h = surface.GetTextSize( v )
				yPos = yPos +h
			end
		render.SetStencilEnable( false )
	cam.End3D2D()
	render.PopFilterMin()
	render.PopFilterMag()
end

function ENT:Draw()
	self:DrawModel()
	self:RenderText()
end

function ENT:RequestSetText( strText )
	GAMEMODE.Net:RequestSetLargeSignText( self, strText )
end

g_LargeSignEntCache = g_LargeSignEntCache or {}
GAMEMODE.Net:RegisterEventHandle( "ent", "lsgn_sndt", function( intMsgLen, pPlayer )
	local entIndex = net.ReadUInt( 16 )
	local text = net.ReadString()
	g_LargeSignEntCache[entIndex] = text

	local ent = ents.GetByIndex( entIndex )
	if IsValid( ent ) and ent:GetClass() == "ent_sign_large" then
		ent:SetText( text )
	end
end )

GAMEMODE.Net:RegisterEventHandle( "ent", "lsgn_sm", function( intMsgLen, pPlayer )
	if ValidPanel( g_LargeSignMenu ) then
		g_LargeSignMenu:Remove()
	end

	g_LargeSignMenu = vgui.Create( "SRPLargeSignMenu" )
	g_LargeSignMenu:SetTitle( "Sign Menu" )
	g_LargeSignMenu:SetSize( 480, 500 )
	g_LargeSignMenu:Center()
	g_LargeSignMenu:SetEntity( net.ReadEntity() )
	g_LargeSignMenu:SetVisible( true )
	g_LargeSignMenu:MakePopup()
end )

function GAMEMODE.Net:RequestSetLargeSignText( entSign, strText )
	self:NewEvent( "ent", "lsgn_st" )
		net.WriteEntity( entSign )
		net.WriteString( strText )
	self:FireEvent( pPlayer )
end