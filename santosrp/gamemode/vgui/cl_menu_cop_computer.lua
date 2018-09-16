
-----------------------------------------------------
--[[

	Name: cl_menu_cop_computer.lua

	For: SantosRP

	By: Ultra

]]--



surface.CreateFont( "CopMenuFont", {size = 16, weight = 400, font = "DermaLarge"} )



local Panel = {}

function Panel:Init()

	hook.Add( "GamemodeGetRapSheet", "CopMenuRapSheet", function( pPlayer, tblArrestData, tblLicenseData )

		self:LoadData( pPlayer, tblArrestData, tblLicenseData )

		self:GetParent():OpenResults()

	end )



	hook.Add( "GamemodeSharedGameVarChanged", "CopMenuRapSheet", function( pPlayer, strVar, valOld, valNew )

		if pPlayer ~= self.m_pPlayer then return end

		if strVar ~= "warrant" and strVar ~= "arrested" then return end

		self:Refresh()

	end )



	local btnColor = Color( 10, 10, 10, 200 )

	local btnMouseOverColor = Color( 40, 40, 40, 200 )

	local btnDepressedColor = Color( 0, 0, 0, 200 )



	self.m_pnlAvatar = vgui.Create( "AvatarImage", self )

	self.m_pnlNameLabel = vgui.Create( "DLabel", self )

	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )

	self.m_pnlNameLabel:SetFont( "CopMenuFont" )



	self.m_pnlBtnBack = vgui.Create( "SRP_Button", self )

	self.m_pnlBtnBack:SetFont( "CopMenuFont" )

	self.m_pnlBtnBack:SetColor( btnColor )

	self.m_pnlBtnBack:SetMouseOverColor( btnMouseOverColor )

	self.m_pnlBtnBack:SetDepressedColor( btnDepressedColor )

	self.m_pnlBtnBack:SetText( "Back" )

	self.m_pnlBtnBack.DoClick = function()

		self:GetParent():OpenSearch()

	end



	self.m_pnlBtnRefresh = vgui.Create( "SRP_Button", self )

	self.m_pnlBtnRefresh:SetFont( "CopMenuFont" )

	self.m_pnlBtnRefresh:SetColor( btnColor )

	self.m_pnlBtnRefresh:SetMouseOverColor( btnMouseOverColor )

	self.m_pnlBtnRefresh:SetDepressedColor( btnDepressedColor )

	self.m_pnlBtnRefresh:SetText( "Refresh" )

	self.m_pnlBtnRefresh.DoClick = function()

		if not IsValid( self.m_pPlayer ) then return end

		self:Refresh()

	end 



	self.m_pnlContainer = vgui.Create( "SRP_ScrollPanel", self )



	self.m_pnlWarrantContainer = vgui.Create( "DPanelList", self.m_pnlContainer )

	self.m_pnlContainer:AddItem( self.m_pnlWarrantContainer )



	self.m_pnlArrestContainer = vgui.Create( "DPanelList", self.m_pnlContainer )

	self.m_pnlContainer:AddItem( self.m_pnlArrestContainer )



	--Arrest data

	self.m_pnlArrestLabel = vgui.Create( "DLabel", self.m_pnlContainer )

	self.m_pnlArrestLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlArrestLabel:SetTextColor( Color(255, 255, 255, 255) )

	self.m_pnlArrestLabel:SetFont( "CarMenuFont" )

	self.m_pnlArrestLabel:SetText( "Arrest History" )

	self.m_pnlContainer:AddItem( self.m_pnlArrestLabel )



	self.m_pnlBtnWarrant = vgui.Create( "SRP_Button", self.m_pnlContainer )

	self.m_pnlBtnWarrant:SetFont( "CopMenuFont" )

	self.m_pnlBtnWarrant:SetColor( btnColor )

	self.m_pnlBtnWarrant:SetMouseOverColor( btnMouseOverColor )

	self.m_pnlBtnWarrant:SetDepressedColor( btnDepressedColor )

	self.m_pnlBtnWarrant:SetText( "Issue Warrant" )

	self.m_pnlBtnWarrant.DoClick = function()

		if not IsValid( self.m_pPlayer ) then return end

		GAMEMODE.Gui:StringRequest(

			"Warrant Player",

			"Enter Reason For Warrant",

			"",

			function( strText )

				if not IsValid( self.m_pPlayer ) then return end

				GAMEMODE.Net:RequestWarrantPlayer( self.m_pPlayer, strText )

			end,

			function()

			end,

			"Submit",

			nil,

			GAMEMODE.Config.MaxWarrantReasonLength

		)

	end

	self.m_pnlContainer:AddItem( self.m_pnlBtnWarrant )



	self.m_pnlArrestList = vgui.Create( "SRP_ListView", self.m_pnlContainer )

	self.m_pnlArrestList:AddColumn( "Date" ):SetFixedWidth( 125 )

	self.m_pnlArrestList:AddColumn( "Duration" ):SetFixedWidth( 90 )

	self.m_pnlArrestList:AddColumn( "Arrested By" )

	self.m_pnlArrestList:AddColumn( "Arrest Reason" )

	self.m_pnlArrestList:AddColumn( "Release Reason" )

	self.m_pnlContainer:AddItem( self.m_pnlArrestList )



	--Dot/License data/Plate number

	self.m_pnlLicenseIDLabel = vgui.Create( "DLabel", self.m_pnlContainer )

	self.m_pnlLicenseIDLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlLicenseIDLabel:SetTextColor( Color(255, 255, 255, 255) )

	self.m_pnlLicenseIDLabel:SetFont( "CarMenuFont" )

	self.m_pnlLicenseIDLabel:SetText( "License ID: " )

	self.m_pnlContainer:AddItem( self.m_pnlLicenseIDLabel )



	self.m_pnlPlateNumberLabel = vgui.Create( "DLabel", self.m_pnlContainer )

	self.m_pnlPlateNumberLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlPlateNumberLabel:SetTextColor( Color(255, 255, 255, 255) )

	self.m_pnlPlateNumberLabel:SetFont( "CarMenuFont" )

	self.m_pnlPlateNumberLabel:SetText( "License Plate: " )

	self.m_pnlContainer:AddItem( self.m_pnlLicenseIDLabel )



	self.m_pnlDotLabel = vgui.Create( "DLabel", self.m_pnlContainer )

	self.m_pnlDotLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlDotLabel:SetTextColor( Color(255, 255, 255, 255) )

	self.m_pnlDotLabel:SetFont( "CarMenuFont" )

	self.m_pnlDotLabel:SetText( "License Warnings" )

	self.m_pnlContainer:AddItem( self.m_pnlDotLabel )



	self.m_pnlBtnAddDot = vgui.Create( "SRP_Button", self.m_pnlContainer )

	self.m_pnlBtnAddDot:SetFont( "CopMenuFont" )

	self.m_pnlBtnAddDot:SetColor( btnColor )

	self.m_pnlBtnAddDot:SetMouseOverColor( btnMouseOverColor )

	self.m_pnlBtnAddDot:SetDepressedColor( btnDepressedColor )

	self.m_pnlBtnAddDot:SetText( "Place Warning On License" )

	self.m_pnlBtnAddDot.DoClick = function()

		GAMEMODE.Gui:StringRequest(

			"Place Warning On Drivers License",

			"Enter A Description For This Warning",

			"",

			function( strText )

				if not IsValid( self.m_pPlayer ) then return end

				GAMEMODE.Net:RequestDotPlayerLicense( self.m_pPlayer, strText )

				self:DelayRefresh()

			end,

			function()

			end,

			"Submit",

			nil,

			GAMEMODE.Config.MaxLicenseDotReasonLength

		)

	end

	self.m_pnlBtnAddDot.Think = function()

		if not IsValid( self.m_pPlayer ) then return end

		self.m_pnlBtnAddDot:SetDisabled( not GAMEMODE.License:PlayerHasLicense(self.m_pPlayer) )

	end

	self.m_pnlContainer:AddItem( self.m_pnlBtnAddDot )



	self.m_pnlBtnRevokeLicense = vgui.Create( "SRP_Button", self.m_pnlContainer )

	self.m_pnlBtnRevokeLicense:SetFont( "CopMenuFont" )

	self.m_pnlBtnRevokeLicense:SetColor( btnColor )

	self.m_pnlBtnRevokeLicense:SetMouseOverColor( btnMouseOverColor )

	self.m_pnlBtnRevokeLicense:SetDepressedColor( btnDepressedColor )

	self.m_pnlBtnRevokeLicense:SetText( "Revoke Drivers License" )

	self.m_pnlBtnRevokeLicense.DoClick = function()

		local str = "Enter Duration Player's License Should Be Revoked For (In Minutes)\nMinimum Time: %s minute(s) Maximum Time: %s minute(s)"

		str = str:format( GAMEMODE.Config.MinLicenseRevokeTime /60, GAMEMODE.Config.MaxLicenseRevokeTime /60 )



		GAMEMODE.Gui:StringRequest(

			"Revoke Drivers License",

			str,

			"",

			function( strText )

				if not IsValid( self.m_pPlayer ) then return end

				GAMEMODE.Net:RequestRevokePlayerLicense( self.m_pPlayer, (tonumber(strText) or 0) *60 )

				self:DelayRefresh()

			end,

			function()

			end,

			"Revoke"

		)

	end

	self.m_pnlBtnRevokeLicense.Think = function()

		if not IsValid( self.m_pPlayer ) then return end

		self.m_pnlBtnRevokeLicense:SetDisabled( not GAMEMODE.License:PlayerHasLicense(self.m_pPlayer) )



		if self.m_pnlBtnRevokeLicense:GetDisabled() then

			self.m_pnlBtnRevokeLicense:SetText( "Player Has No License" )

			self.m_pnlBtnRevokeLicense:SetTextColorOverride( Color(255, 255, 255, 255) )

		else

			self.m_pnlBtnRevokeLicense:SetText( "Revoke Drivers License" )

			self.m_pnlBtnRevokeLicense:SetTextColorOverride( nil )

		end

	end



	self.m_pnlDotList = vgui.Create( "SRP_ListView", self.m_pnlContainer )

	self.m_pnlDotList:AddColumn( "Date" ):SetFixedWidth( 125 )

	self.m_pnlDotList:AddColumn( "Issued By" )

	self.m_pnlDotList:AddColumn( "Reason" )

	self.m_pnlContainer:AddItem( self.m_pnlDotList )



	--Unpaid tickets

	self.m_pnlUnpaidTicketLabel = vgui.Create( "DLabel", self.m_pnlContainer )

	self.m_pnlUnpaidTicketLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlUnpaidTicketLabel:SetTextColor( Color(255, 255, 255, 255) )

	self.m_pnlUnpaidTicketLabel:SetFont( "CarMenuFont" )

	self.m_pnlUnpaidTicketLabel:SetText( "Unpaid Tickets" )

	self.m_pnlContainer:AddItem( self.m_pnlUnpaidTicketLabel )



	self.m_pnlUnpaidTicketList = vgui.Create( "SRP_ListView", self.m_pnlContainer )

	self.m_pnlUnpaidTicketList:AddColumn( "Date" ):SetFixedWidth( 125 )

	self.m_pnlUnpaidTicketList:AddColumn( "Given By" )

	self.m_pnlUnpaidTicketList:AddColumn( "Reason" )

	self.m_pnlUnpaidTicketList:AddColumn( "Price" )

	self.m_pnlContainer:AddItem( self.m_pnlUnpaidTicketList )



	--Paid tickets

	self.m_pnlPaidTicketLabel = vgui.Create( "DLabel", self.m_pnlContainer )

	self.m_pnlPaidTicketLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlPaidTicketLabel:SetTextColor( Color(255, 255, 255, 255) )

	self.m_pnlPaidTicketLabel:SetFont( "CarMenuFont" )

	self.m_pnlPaidTicketLabel:SetText( "Paid Tickets" )

	self.m_pnlContainer:AddItem( self.m_pnlPaidTicketLabel )



	self.m_pnlPaidTicketList = vgui.Create( "SRP_ListView", self.m_pnlContainer )

	self.m_pnlPaidTicketList:AddColumn( "Date" ):SetFixedWidth( 125 )

	self.m_pnlPaidTicketList:AddColumn( "Given By" )

	self.m_pnlPaidTicketList:AddColumn( "Reason" )

	self.m_pnlPaidTicketList:AddColumn( "Price" )

	self.m_pnlContainer:AddItem( self.m_pnlPaidTicketList )



	--Owned properties

	self.m_pnlPropertyLabel = vgui.Create( "DLabel", self.m_pnlContainer )

	self.m_pnlPropertyLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlPropertyLabel:SetTextColor( Color(255, 255, 255, 255) )

	self.m_pnlPropertyLabel:SetFont( "CarMenuFont" )

	self.m_pnlPropertyLabel:SetText( "Owned Properties" )

	self.m_pnlContainer:AddItem( self.m_pnlPropertyLabel )



	self.m_pnlPropertyList = vgui.Create( "SRP_ListView", self.m_pnlContainer )

	self.m_pnlPropertyList:AddColumn( "Type" ):SetFixedWidth( 90 )

	self.m_pnlPropertyList:AddColumn( "Property Name" )

	self.m_pnlContainer:AddItem( self.m_pnlPropertyList )



	--this just adds padding to the end of the scroll list

	self.m_pnlPadding = vgui.Create( "EditablePanel", self.m_pnlContainer )

	self.m_pnlContainer:AddItem( self.m_pnlPadding )

end



function Panel:LoadData( pPlayer, tblArrestData, tblLicenseData )

	self.m_pPlayer = pPlayer

	self.m_tblArrestData = tblArrestData

	self.m_tblLicenseData = tblLicenseData



	self.m_pnlAvatar:SetPlayer( pPlayer )

	self.m_pnlNameLabel:SetText( pPlayer:Nick().. " - Rap Sheet" )



	if GAMEMODE.Player:GetSharedGameVar( pPlayer, "driver_license", "" ) == "" then

		self.m_pnlLicenseIDLabel:SetText( "License ID: No License!" )

	else

		self.m_pnlLicenseIDLabel:SetText( "License ID: ".. GAMEMODE.Player:GetSharedGameVar(pPlayer, "driver_license", "No License!") )

	end



	if IsValid( pPlayer:GetNWEntity("CurrentCar") ) then

		self.m_pnlPlateNumberLabel:SetText( "License Plate: ".. pPlayer:GetNWEntity("CurrentCar"):GetNWString("plate_serial") )

	else

		self.m_pnlPlateNumberLabel:SetText( "License Plate: No Car!" )

	end

	

	self:Populate()

end



function Panel:Populate()

	self.m_pnlArrestList:Clear( true )

	self.m_pnlDotList:Clear( true )

	self.m_pnlWarrantContainer:Clear( true )

	self.m_pnlArrestContainer:Clear( true )

	self.m_pnlUnpaidTicketList:Clear( true )

	self.m_pnlPaidTicketList:Clear( true )

	self.m_pnlPropertyList:Clear( true )



	if self.m_tblArrestData.Warrant then

		local btnColor = Color( 10, 10, 10, 200 )

		local btnMouseOverColor = Color( 40, 40, 40, 200 )

		local btnDepressedColor = Color( 0, 0, 0, 200 )



		local warrantCard = vgui.Create( "EditablePanel" )



		local warrantLabel = vgui.Create( "DLabel", warrantCard )

		warrantLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

		warrantLabel:SetTextColor( Color(255, 50, 50, 255) )

		warrantLabel:SetFont( "CarMenuFont" )

		warrantLabel:SetText( "Player Has Active Warrant!" )

		warrantLabel:SizeToContents()



		local warrantInfoBtn = vgui.Create( "SRP_Button", warrantCard )

		warrantInfoBtn:SetFont( "CopMenuFont" )

		warrantInfoBtn:SetColor( btnColor )

		warrantInfoBtn:SetMouseOverColor( btnMouseOverColor )

		warrantInfoBtn:SetDepressedColor( btnDepressedColor )

		warrantInfoBtn:SetText( "Info" )

		warrantInfoBtn:SetTooltip(  )

		warrantInfoBtn.DoClick = function()

			GAMEMODE.Gui:Derma_Message(

				self.m_tblArrestData.Warrant.WarrantReason .."\n\nIssued By: ".. self.m_tblArrestData.Warrant.WarrantBy,

				"Warrant Data"

			)

		end



		local warrantRevokeBtn = vgui.Create( "SRP_Button", warrantCard )

		warrantRevokeBtn:SetFont( "CopMenuFont" )

		warrantRevokeBtn:SetColor( btnColor )

		warrantRevokeBtn:SetMouseOverColor( btnMouseOverColor )

		warrantRevokeBtn:SetDepressedColor( btnDepressedColor )

		warrantRevokeBtn:SetText( "Revoke Warrant" )

		warrantRevokeBtn.DoClick = function()

			if not IsValid( self.m_pPlayer ) then return end

			GAMEMODE.Net:RequestRevokePlayerWarrant( self.m_pPlayer )

		end



		warrantCard.PerformLayout = function( _, intW, intH )

			warrantLabel:SetPos( 0, -3 )



			warrantInfoBtn:SetSize( 40, warrantLabel:GetTall() )

			warrantInfoBtn:SetPos( 10 +warrantLabel:GetWide(), 0 )



			warrantRevokeBtn:SetSize( 110, warrantLabel:GetTall() )

			warrantRevokeBtn:SetPos( intW -warrantRevokeBtn:GetWide(), 0 )

		end



		self.m_pnlWarrantContainer:AddItem( warrantCard )

		self.m_pnlWarrantContainer:SetTall( warrantLabel:GetTall() )

	end



	if IsValid( self.m_pPlayer ) and GAMEMODE.Player:GetSharedGameVar( self.m_pPlayer, "arrested" ) then

		local arrestCard = vgui.Create( "EditablePanel" )



		local arrestLabel = vgui.Create( "DLabel", arrestCard )

		arrestLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

		arrestLabel:SetTextColor( Color(255, 50, 50, 255) )

		arrestLabel:SetFont( "CarMenuFont" )

		arrestLabel:SetText( "Player Is Currently In Jail!" )

		arrestLabel:SizeToContents()



		arrestCard.PerformLayout = function( _, intW, intH )

			arrestLabel:SetPos( 0, -3 )

		end



		self.m_pnlArrestContainer:AddItem( arrestCard )

		self.m_pnlArrestContainer:SetTall( arrestLabel:GetTall() )		

	end



	for k, v in pairs( self.m_tblArrestData.ArrestRecord or {} ) do

		self.m_pnlArrestList:AddLine( os.date("%X - %m/%d/%Y", v.Date or 0), (v.Duration /60).. " minutes", v.ArrestedBy, v.ArrestReason, v.LeaveReason )

	end



	for k, v in pairs( self.m_tblLicenseData.Dots or {} ) do

		self.m_pnlDotList:AddLine( os.date("%X - %m/%d/%Y", v.Date or 0), v.GivenBy, v.Reason )

	end



	for k, v in pairs( self.m_tblLicenseData.UnpiadTickets or {} ) do

		self.m_pnlUnpaidTicketList:AddLine( os.date("%X - %m/%d/%Y", v.Date or 0), v.GivenBy, v.Reason, "$".. string.Comma(v.Price) )

	end



	for k, v in pairs( self.m_tblLicenseData.PaidTickets or {} ) do

		self.m_pnlPaidTicketList:AddLine( os.date("%X - %m/%d/%Y", v.Date or 0), v.GivenBy, v.Reason, "$".. string.Comma(v.Price) )

	end	



	if IsValid( self.m_pPlayer ) then

		local data

		for k, v in pairs( GAMEMODE.Property:GetPropertiesByOwner(self.m_pPlayer) ) do

			data = GAMEMODE.Property:GetPropertyByName( v )

			self.m_pnlPropertyList:AddLine( data.Cat, data.Name )

		end

	end

	

	self:InvalidateLayout()

end



function Panel:Refresh()

	GAMEMODE.Net:RequestPlayerRapSheet( self.m_pPlayer )

end



function Panel:DelayRefresh()

	timer.Simple( 0.75, function()

		if not ValidPanel( self ) or not IsValid( self.m_pPlayer ) then return end

		self:Refresh()

	end )

end



function Panel:Paint( intW, intH )

	surface.SetDrawColor( 30, 30, 30, 150 )

	surface.DrawRect( 0, 0, intW, 42 )

end



function Panel:PerformLayout( intW, intH )

	local padding = 5

	local vbarWide = 15

	self.m_pnlAvatar:SetPos( padding, padding )

	self.m_pnlAvatar:SetSize( 32, 32 )



	self.m_pnlBtnBack:SetSize( 60, 32 )

	self.m_pnlBtnBack:SetPos( intW -self.m_pnlBtnBack:GetWide() -padding, padding )



	self.m_pnlBtnRefresh:SetSize( 60, 32 )

	self.m_pnlBtnRefresh:SetPos( intW -self.m_pnlBtnBack:GetWide() -self.m_pnlBtnRefresh:GetWide() -(padding *2), padding )



	self.m_pnlNameLabel:SizeToContents()

	self.m_pnlNameLabel:SetPos( self.m_pnlAvatar:GetWide() +(padding *2), padding +(self.m_pnlAvatar:GetTall() /2) -(self.m_pnlNameLabel:GetTall() /2) )



	self.m_pnlContainer:SetPos( 0, (padding *2) +self.m_pnlAvatar:GetTall() )

	self.m_pnlContainer:SetSize( intW, intH -(padding *2) -self.m_pnlAvatar:GetTall() )



	local y = padding



	--Warrant

	if self.m_tblArrestData.Warrant then

		self.m_pnlWarrantContainer:SetPos( padding, y )

		self.m_pnlWarrantContainer:SetWide( intW -(padding *2) -vbarWide )

		y = y +self.m_pnlWarrantContainer:GetTall()

	else

		self.m_pnlWarrantContainer:SetSize( 0, 0 )

		self.m_pnlWarrantContainer:SetPos( 0, 0 )

	end



	if IsValid( self.m_pPlayer ) and GAMEMODE.Player:GetSharedGameVar( self.m_pPlayer, "arrested" ) then

		self.m_pnlArrestContainer:SetPos( padding, y )

		self.m_pnlArrestContainer:SetWide( intW -(padding *2) -vbarWide )

		y = y +self.m_pnlArrestContainer:GetTall()

	else

		self.m_pnlArrestContainer:SetSize( 0, 0 )

		self.m_pnlArrestContainer:SetPos( 0, 0 )

	end



	--License ID

	self.m_pnlLicenseIDLabel:SizeToContents()

	self.m_pnlLicenseIDLabel:SetPos( padding, y )



	--Plate Number

	y = y +padding +self.m_pnlLicenseIDLabel:GetTall()

	self.m_pnlPlateNumberLabel:SizeToContents()

	self.m_pnlPlateNumberLabel:SetPos( padding, y )



	--Arrest

	y = y +padding +self.m_pnlPlateNumberLabel:GetTall()

	self.m_pnlArrestLabel:SizeToContents()

	self.m_pnlArrestLabel:SetPos( padding, y )



	self.m_pnlBtnWarrant:SetSize( 100, self.m_pnlArrestLabel:GetTall() )

	self.m_pnlBtnWarrant:SetPos( intW -self.m_pnlBtnWarrant:GetWide() -padding -vbarWide, y )

	

	y = y +padding +self.m_pnlArrestLabel:GetTall()

	self.m_pnlArrestList:SetPos( 0, y )

	self.m_pnlArrestList:SetSize( intW -vbarWide, 128 )



	--Dots

	y = y +padding +self.m_pnlArrestList:GetTall()

	self.m_pnlDotLabel:SizeToContents()

	self.m_pnlDotLabel:SetPos( padding, y )



	self.m_pnlBtnAddDot:SetSize( 160, self.m_pnlDotLabel:GetTall() )

	self.m_pnlBtnAddDot:SetPos( intW -self.m_pnlBtnAddDot:GetWide() -padding -vbarWide, y )



	self.m_pnlBtnRevokeLicense:SetSize( 150, self.m_pnlDotLabel:GetTall() )

	self.m_pnlBtnRevokeLicense:SetPos( intW -self.m_pnlBtnAddDot:GetWide() -self.m_pnlBtnRevokeLicense:GetWide() -(padding *2) -vbarWide, y )



	y = y +padding +self.m_pnlDotLabel:GetTall()

	self.m_pnlDotList:SetPos( 0, y )

	self.m_pnlDotList:SetSize( intW -vbarWide, 128 )



	--Unpaid Tickets

	y = y +padding +self.m_pnlDotList:GetTall()

	self.m_pnlUnpaidTicketLabel:SizeToContents()

	self.m_pnlUnpaidTicketLabel:SetPos( padding, y )



	y = y +padding +self.m_pnlUnpaidTicketLabel:GetTall()

	self.m_pnlUnpaidTicketList:SetPos( 0, y )

	self.m_pnlUnpaidTicketList:SetSize( intW -vbarWide, 128 )



	--Paid Tickets

	y = y +padding +self.m_pnlUnpaidTicketList:GetTall()

	self.m_pnlPaidTicketLabel:SizeToContents()

	self.m_pnlPaidTicketLabel:SetPos( padding, y )



	y = y +padding +self.m_pnlPaidTicketLabel:GetTall()

	self.m_pnlPaidTicketList:SetPos( 0, y )

	self.m_pnlPaidTicketList:SetSize( intW -vbarWide, 128 )



	--Properties

	y = y +padding +self.m_pnlPaidTicketList:GetTall()

	self.m_pnlPropertyLabel:SizeToContents()

	self.m_pnlPropertyLabel:SetPos( padding, y )



	y = y +padding +self.m_pnlPropertyLabel:GetTall()

	self.m_pnlPropertyList:SetPos( 0, y )

	self.m_pnlPropertyList:SetSize( intW -vbarWide, 128 )



	--Padding

	y = y +self.m_pnlPropertyList:GetTall()

	self.m_pnlPadding:SetPos( padding, y )

	self.m_pnlPadding:SetSize( intW -(padding *2) -vbarWide, padding )

end

vgui.Register( "SRPCopComputer_Result", Panel, "EditablePanel" )



-- ----------------------------------------------------------------



local function FindPlayerByName( strName )

	if strName == "" then return end

	for k, v in pairs( player.GetAll() ) do

		if v:Nick():lower():Trim():match( strName:lower():Trim() ) then

			return v

		end

	end

end



local function FindPlayerByPlateNumber( strPlateNumber )

	if strPlateNumber == "" then return end

	for k, v in pairs( player.GetAll() ) do

		if not IsValid( v:GetNWEntity("CurrentCar") ) then continue end

		if v:GetNWEntity( "CurrentCar" ):GetNWString( "plate_serial" ):lower():Trim():find( strPlateNumber:lower():Trim(), nil, true ) then

			return v

		end

	end

end



local function FindPlayerByLicenseID( strID )

	if strID == "" then return end

	for k, v in pairs( player.GetAll() ) do

		if GAMEMODE.Player:GetSharedGameVar( v, "driver_license", "" ) == "" then continue end

		if GAMEMODE.Player:GetSharedGameVar( v, "driver_license", "" ):lower():Trim() == strID:lower():Trim() then

			return v

		end

	end

end



local function FindPlayerByPropertyName( strName )

	if strName == "" then return end

	for name, data in pairs( GAMEMODE.Property:GetProperties() ) do

		if name:lower():match( strName:lower():Trim() ) then

			if GAMEMODE.Property:IsPropertyOwned( name ) then

				return GAMEMODE.Property:GetOwner( name )

			end

		end

	end

end



local Panel = {}

function Panel:Init()

	local btnColor = Color( 10, 10, 10, 100 )

	local btnMouseOverColor = Color( 40, 40, 40, 100 )

	local btnDepressedColor = Color( 0, 0, 0, 100 )



	self.m_pnlContainer = vgui.Create( "EditablePanel", self )



	self.m_pnlNameLabel = vgui.Create( "DLabel", self.m_pnlContainer )

	self.m_pnlNameLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlNameLabel:SetTextColor( Color(255, 255, 255, 255) )

	self.m_pnlNameLabel:SetFont( "CarMenuFont" )

	self.m_pnlNameLabel:SetText( "Search By Name" )

	self.m_pnlNameSearch = vgui.Create( "DTextEntry", self.m_pnlContainer )

	self.m_pnlBtnSearchName = vgui.Create( "SRP_Button", self.m_pnlContainer )

	self.m_pnlBtnSearchName:SetFont( "CopMenuFont" )

	self.m_pnlBtnSearchName:SetColor( btnColor )

	self.m_pnlBtnSearchName:SetMouseOverColor( btnMouseOverColor )

	self.m_pnlBtnSearchName:SetDepressedColor( btnDepressedColor )

	self.m_pnlBtnSearchName:SetText( "Search" )

	self.m_pnlBtnSearchName.DoClick = function()

		local pl = FindPlayerByName( self.m_pnlNameSearch:GetValue() )

		if not IsValid( pl ) then return end

		GAMEMODE.Net:RequestPlayerRapSheet( pl )

	end

	self.m_pnlNameSearch.OnEnter = self.m_pnlBtnSearchName.DoClick



	self.m_pnlNPlateLabel = vgui.Create( "DLabel", self.m_pnlContainer )

	self.m_pnlNPlateLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlNPlateLabel:SetTextColor( Color(255, 255, 255, 255) )

	self.m_pnlNPlateLabel:SetFont( "CarMenuFont" )

	self.m_pnlNPlateLabel:SetText( "Search By License Plate Number" )

	self.m_pnlPlateSearch = vgui.Create( "DTextEntry", self.m_pnlContainer )

	self.m_pnlBtnSearchPlate = vgui.Create( "SRP_Button", self.m_pnlContainer )

	self.m_pnlBtnSearchPlate:SetFont( "CopMenuFont" )

	self.m_pnlBtnSearchPlate:SetColor( btnColor )

	self.m_pnlBtnSearchPlate:SetMouseOverColor( btnMouseOverColor )

	self.m_pnlBtnSearchPlate:SetDepressedColor( btnDepressedColor )

	self.m_pnlBtnSearchPlate:SetText( "Search" )

	self.m_pnlBtnSearchPlate.DoClick = function()

		local pl = FindPlayerByPlateNumber( self.m_pnlPlateSearch:GetValue() )

		if not IsValid( pl ) then return end

		GAMEMODE.Net:RequestPlayerRapSheet( pl )

	end

	self.m_pnlPlateSearch.OnEnter = self.m_pnlBtnSearchPlate.DoClick



	--Note: This has been converted to search for the owner of a property name

	self.m_pnlLicenseLabel = vgui.Create( "DLabel", self.m_pnlContainer )

	self.m_pnlLicenseLabel:SetExpensiveShadow( 2, Color(0, 0, 0, 255) )

	self.m_pnlLicenseLabel:SetTextColor( Color(255, 255, 255, 255) )

	self.m_pnlLicenseLabel:SetFont( "CarMenuFont" )

	self.m_pnlLicenseLabel:SetText( "Search By Property Name" )

	self.m_pnlLicenseSearch = vgui.Create( "DTextEntry", self.m_pnlContainer )

	self.m_pnlBtnSearchLicense = vgui.Create( "SRP_Button", self.m_pnlContainer )

	self.m_pnlBtnSearchLicense:SetFont( "CopMenuFont" )

	self.m_pnlBtnSearchLicense:SetColor( btnColor )

	self.m_pnlBtnSearchLicense:SetMouseOverColor( btnMouseOverColor )

	self.m_pnlBtnSearchLicense:SetDepressedColor( btnDepressedColor )

	self.m_pnlBtnSearchLicense:SetText( "Search" )

	self.m_pnlBtnSearchLicense.DoClick = function()

		--local pl = FindPlayerByLicenseID( self.m_pnlLicenseSearch:GetValue() )

		local pl = FindPlayerByPropertyName( self.m_pnlLicenseSearch:GetValue() )

		if not IsValid( pl ) then return end

		GAMEMODE.Net:RequestPlayerRapSheet( pl )

	end

	self.m_pnlLicenseSearch.OnEnter = self.m_pnlBtnSearchLicense.DoClick

end



function Panel:PerformLayout( intW, intH )

	local padding = 10



	self.m_pnlNameLabel:SizeToContents()

	self.m_pnlNPlateLabel:SizeToContents()

	self.m_pnlLicenseLabel:SizeToContents()

	self.m_pnlBtnSearchName:SetSize( 60, 25 )

	self.m_pnlBtnSearchPlate:SetSize( 60, 25 )

	self.m_pnlBtnSearchLicense:SetSize( 60, 25 )



	local yOffset = 128

	--Search By Name

	--Label

	self.m_pnlNameLabel:SetPos( (intW /2) -(self.m_pnlNameLabel:GetWide() /2), yOffset )

	local contentTall = self.m_pnlNameLabel:GetTall() +padding +yOffset



	--Text Box

	self.m_pnlNameSearch:SetSize( intW *0.8, 25 )

	self.m_pnlNameSearch:SetPos( (intW /2) -(self.m_pnlNameSearch:GetWide() /2) -(self.m_pnlBtnSearchName:GetWide() /2), contentTall )

	contentTall = contentTall +self.m_pnlNameSearch:GetTall() +padding

	--Button

	local x, y = self.m_pnlNameSearch:GetPos()

	self.m_pnlBtnSearchName:SetPos( x +self.m_pnlNameSearch:GetWide(), y )



	--Search By Plate

	--Label

	self.m_pnlNPlateLabel:SetPos( (intW /2) -(self.m_pnlNPlateLabel:GetWide() /2), contentTall )

	contentTall = contentTall +self.m_pnlNPlateLabel:GetTall() +padding

	--Text Box

	self.m_pnlPlateSearch:SetSize( intW *0.8, 25 )

	self.m_pnlPlateSearch:SetPos( (intW /2) -(self.m_pnlPlateSearch:GetWide() /2) -(self.m_pnlBtnSearchPlate:GetWide() /2), contentTall )

	contentTall = contentTall +self.m_pnlPlateSearch:GetTall() +padding

	--Button

	local x, y = self.m_pnlPlateSearch:GetPos()

	self.m_pnlBtnSearchPlate:SetPos( x +self.m_pnlPlateSearch:GetWide(), y )



	--Search By ID

	--Label

	self.m_pnlLicenseLabel:SetPos( (intW /2) -(self.m_pnlLicenseLabel:GetWide() /2), contentTall )

	contentTall = contentTall +self.m_pnlLicenseLabel:GetTall() +padding

	--Text Box

	self.m_pnlLicenseSearch:SetSize( intW *0.8, 25 )

	self.m_pnlLicenseSearch:SetPos( (intW /2) -(self.m_pnlLicenseSearch:GetWide() /2) -(self.m_pnlBtnSearchLicense:GetWide() /2), contentTall )

	contentTall = contentTall +self.m_pnlLicenseSearch:GetTall() +padding

	--Button

	local x, y = self.m_pnlLicenseSearch:GetPos()

	self.m_pnlBtnSearchLicense:SetPos( x +self.m_pnlLicenseSearch:GetWide(), y )



	self.m_pnlContainer:SetSize( intW, contentTall )

	self.m_pnlContainer:SetPos( 0, ((intH -24) /2) -(self.m_pnlContainer:GetTall() /2) )

end

vgui.Register( "SRPCopComputer_Search", Panel, "EditablePanel" )



-- ----------------------------------------------------------------



local Panel = {}

function Panel:Init()

	--self:SetDeleteOnClose( false )

	--self:SetTitle( "Santos Police Dept. Criminal Database" )



	self.m_pnlResult = vgui.Create( "SRPCopComputer_Result", self )

	self.m_pnlResult:SetVisible( false )

	self.m_pnlResult:SetPos( 0, 0 )



	self.m_pnlSearch = vgui.Create( "SRPCopComputer_Search", self )

	self.m_pnlSearch:SetPos( 0, 0 )

end



function Panel:OpenSearch( bSkipAnim )

	self:GetParent():ShowSearchBackground()

	if not bSkipAnim and self.m_pnlResult:IsVisible() then

		self.m_pnlResult:MoveTo( self:GetWide(), 0, 0.2, 0, 2, function()

			self.m_pnlResult:SetVisible( false )

		end )



		self.m_pnlSearch:SetPos( -self:GetWide(), 0 )

		self.m_pnlSearch:MoveTo( 0, 0, 0.2, 0, 2, function()

			self.m_pnlSearch:SetVisible( true )

		end )

	else

		self.m_pnlSearch:SetPos( 0, 0 )

		self.m_pnlResult:SetVisible( false )

	end

	

	self.m_pnlSearch:SetVisible( true )

end



function Panel:OpenResults()

	self:GetParent():ShowResultsBackground()

	if self.m_pnlSearch:IsVisible() then

		self.m_pnlSearch:SetPos( 0, 0 )

		self.m_pnlSearch:MoveTo( -self:GetWide(), 0, 0.2, 0, 2, function()

			self.m_pnlSearch:SetVisible( false )

		end )



		self.m_pnlResult:SetPos( self:GetWide(), 0 )

		self.m_pnlResult:MoveTo( 0, 0, 0.2, 0, 2, function()

			self.m_pnlResult:SetVisible( true )

		end )

	end

	

	self.m_pnlResult:SetVisible( true )

end



function Panel:PerformLayout( intW, intH )

	--DFrame.PerformLayout( self, intW, intH )



	self.m_pnlSearch:SetSize( intW, intH )

	self.m_pnlResult:SetSize( intW, intH )

end



function Panel:Open()

	self:OpenSearch( true )

end

vgui.Register( "SRPCopComputerMenu", Panel, "EditablePanel" )



-- ----------------------------------------------------------------



local Panel = {}

function Panel:Init()

	--self:SetDeleteOnClose( false )

	--self:SetTitle( "Santos Police Dept. Criminal Database" )



	self.m_pnlMenu = vgui.Create( "SRPCopComputerMenu", self )

	self.m_matMainBG = Material( "nomad/cop_pc_2z.png", "noclamp smooth" )
	self.m_matSubBG = Material( "nomad/cop_pc_2z.png", "noclamp smooth" )



	self.m_matCurBG = self.m_matMainBG

end



function Panel:ShowSearchBackground()

	self.m_matCurBG = self.m_matMainBG

end



function Panel:ShowResultsBackground()

	self.m_matCurBG = self.m_matSubBG

end



function Panel:Paint( intW, intH )

	if not self.m_matCurBG then return end

	surface.SetMaterial( self.m_matCurBG )

	surface.SetDrawColor( 255, 255, 255, 255 )

	surface.DrawTexturedRect( 0, 0, intW, intH )

end



function Panel:PerformLayout( intW, intH )

	self.m_pnlMenu:SetPos( 137, 68 )

	self.m_pnlMenu:SetSize( 544, 338 )

end



function Panel:Think()

	if self:IsVisible() then

		if self.m_bHangOpen then

			if not input.IsKeyDown( KEY_R ) then

				self.m_bHangOpen = false

			end



			return

		end



		local focus = vgui.GetKeyboardFocus()

		if focus == self or focus == self.m_pnlMenu then

			if input.IsKeyDown( KEY_R ) then

				self:SetVisible( false )

			end

		end

	end

end



function Panel:Open()

	self:SetVisible( true )

	self:MakePopup()

	self.m_pnlMenu:Open()

	self.m_bHangOpen = true

end

vgui.Register( "SRPCopComputerSkinnedMenu", Panel, "EditablePanel" )