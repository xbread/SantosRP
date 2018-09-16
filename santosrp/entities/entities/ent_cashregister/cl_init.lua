include "shared.lua"
ENT.RenderGroup = RENDERGROUP_BOTH

local GM = (GAMEMODE or GM)
GM.Net:RegisterEventHandle( "ent", "creg_open", function( intMsgLen, pPlayer )
	local register, money = net.ReadEntity(), net.ReadUInt(32)
	if not IsValid( register ) then return end
	
	local nearItems = {}
	local num = net.ReadUInt( 16 )
	if num > 0 then
		for i = 1, num do
			table.insert( nearItems, {
				Name = net.ReadString(),
				Ent = net.ReadEntity(),
			} )
		end
	end
	
	local listedItems = {}
	num = net.ReadUInt( 16 )
	if num > 0 then
		for i = 1, num do
			table.insert( listedItems, {
				Name = net.ReadString(),
				Price = net.ReadUInt( 32 ),
				Ent = net.ReadEntity(),
			} )
		end
	end
	
	GAMEMODE.Gui:ShowCashRegisterMenu( register, money, nearItems, listedItems )
end )

local inQuery
GM.Net:RegisterEventHandle( "ent", "creg_isq", function( intMsgLen, pPlayer )
	local buying = net.ReadEntity()
	if not IsValid( buying ) then return end
	
	if inQuery then return end
	inQuery = true

	GAMEMODE.Gui:Derma_Query(
		"Are you sure you want to buy this? Price: $".. buying:GetNWInt("register_price"),
		"Purchase item",
		"Ok",
		function()
			GAMEMODE.Net:NewEvent( "ent", "creg_rb" )
				net.WriteEntity( buying )
			GAMEMODE.Net:FireEvent( entCaller )

			inQuery = false
		end,
		"Cancel",
		function()
			inQuery = false
		end
	)
end )

g_CashRegisterPriceCache = g_CashRegisterPriceCache or {}
timer.Create( "update_itempricetags", 2, 0, function()
	g_CashRegisterPriceCache = {}

	local all = ents.GetAll()
	for k, v in pairs( all ) do
		if not IsValid( v ) then continue end
		if not v:GetNWInt( "register_price" ) or v:GetNWInt( "register_price" ) < 1 then
			continue
		end

		g_CashRegisterPriceCache[k] = v
	end
end )

local eye, ang, myPos, pos
hook.Add( "PostDrawTranslucentRenderables", "drawitems_forsale", function()
	eye = LocalPlayer():EyeAngles()
	ang = Angle( 0, eye.y - 90, 90 )
	myPos = LocalPlayer():GetPos()

	for k, v in pairs( g_CashRegisterPriceCache ) do
		if not IsValid( v ) or v:GetNWInt( "register_price", -1 ) < 1 then 
			g_CashRegisterPriceCache[k] = nil
			continue 
		end

		if v:GetPos():DistToSqr( myPos ) > 1024 ^2 then continue end
		
		pos = v:GetPos() +Vector( 0, 0, v:OBBMaxs().z +12 )

		local w1, w2, h1, h2
		cam.Start3D2D( pos, ang, 0.25 )
			surface.SetFont( "Trebuchet24" )
			surface.SetTextColor( 255, 255, 255, 255 )
			local str = "$".. string.Comma(GAMEMODE.Econ:ApplyTaxToSum("sales", v:GetNWInt("register_price", 0)))
			w1, h1 = surface.GetTextSize( v:GetNWString("itemID", "N/A") )
			w2, h2 = surface.GetTextSize( str )

			local w = math.max( w1, w2 )
			surface.SetTextPos( -(w1 /2), 0 )
			surface.DrawText( v:GetNWString("itemID", "N/A") )
			surface.SetTextPos( -(w2 /2), h1 )
			surface.DrawText( str )
			--draw.WordBox(2, -(w /2) -2, 0, str, "Trebuchet24", Color(0, 140, 0, 150), Color(255,255,255,255))
		cam.End3D2D()
	end
end )