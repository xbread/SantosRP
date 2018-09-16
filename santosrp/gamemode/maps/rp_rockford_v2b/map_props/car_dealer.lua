--[[
	Name: car_dealer.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "car_dealer"
MapProp.m_tblSpawn = {
	{ mdl = 'models/props_c17/oildrum001.mdl',pos = Vector('-6310.062500 -1110.125000 0.468750'), ang = Angle('-0.132 -40.474 -0.132'), },
	{ mdl = 'models/props_trainstation/trainstation_clock001.mdl',pos = Vector('-5821.562500 -1090.406250 355.437500'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props_lab/binderbluelabel.mdl',pos = Vector('-5483.375000 -1110.781250 35.812500'), ang = Angle('-1.187 -125.596 88.726'), },
	{ mdl = 'models/props_c17/oildrum001.mdl',pos = Vector('-6320.906250 -1160.843750 14.343750'), ang = Angle('-65.391 -96.812 -89.956'), },
	{ mdl = 'models/props_junk/wood_crate002a.mdl',pos = Vector('-6266.062500 -1817.250000 20.437500'), ang = Angle('-0.088 -1.055 -0.088'), },
	{ mdl = 'models/items/item_item_crate.mdl',pos = Vector('-6257.968750 -1756.656250 0.468750'), ang = Angle('-0.044 -20.303 0.000'), },
	{ mdl = 'models/props_junk/wood_crate001a_damaged.mdl',pos = Vector('-6297.906250 -1753.375000 20.375000'), ang = Angle('-0.088 -26.235 0.044'), },
	{ mdl = 'models/props_junk/wood_crate002a.mdl',pos = Vector('-6307.156250 -1818.093750 20.500000'), ang = Angle('0.000 -0.044 0.000'), },
	{ mdl = 'models/props_lab/bindergreenlabel.mdl',pos = Vector('-5482.406250 -1098.156250 38.406250'), ang = Angle('-2.725 168.179 -87.539'), },
	{ mdl = 'models/props_junk/wood_crate001a_damaged.mdl',pos = Vector('-6296.093750 -1819.781250 60.875000'), ang = Angle('-0.044 13.052 0.132'), },
	{ mdl = 'models/props_junk/wood_crate001a_damaged.mdl',pos = Vector('-6273.125000 -1914.531250 38.187500'), ang = Angle('-0.176 12.876 0.044'), },
	{ mdl = 'models/props_warehouse/toolbox.mdl',pos = Vector('-5402.093750 -1127.187500 0.468750'), ang = Angle('-0.044 -103.315 0.044'), },
	{ mdl = 'models/props_wasteland/controlroom_desk001a.mdl',pos = Vector('-5508.187500 -1108.968750 16.906250'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props_junk/propane_tank001a.mdl',pos = Vector('-5580.843750 -1117.000000 18.187500'), ang = Angle('-1.406 -99.448 -0.791'), },
	{ mdl = 'models/props_junk/pushcart01a.mdl',pos = Vector('-6273.625000 -1910.656250 34.281250'), ang = Angle('-0.088 -51.943 0.000'), },
	{ mdl = 'models/props_c17/oildrum001.mdl',pos = Vector('-6281.500000 -1103.906250 0.468750'), ang = Angle('0.000 -40.078 0.000'), },
	{ mdl = 'models/props_lab/partsbin01.mdl',pos = Vector('-5532.406250 -1094.156250 47.343750'), ang = Angle('0.088 -90.044 0.132'), },
	{ mdl = 'models/props_lab/clipboard.mdl',pos = Vector('-5497.625000 -1116.406250 34.406250'), ang = Angle('-0.483 -101.294 0.352'), },
	{ mdl = 'models/props_c17/tools_wrench01a.mdl',pos = Vector('-5561.406250 -1112.656250 34.343750'), ang = Angle('-1.362 -63.325 -0.220'), },
	{ mdl = 'models/props_c17/oildrum001.mdl',pos = Vector('-5596.531250 -1105.500000 0.437500'), ang = Angle('-0.220 33.618 -0.220'), },
	{ mdl = 'models/props_c17/trappropeller_lever.mdl',pos = Vector('-5540.218750 -1118.218750 35.062500'), ang = Angle('87.363 -128.848 30.630'), },
	{ mdl = 'models/props_lab/partsbin01.mdl',pos = Vector('-5508.218750 -1094.125000 47.437500'), ang = Angle('-0.044 -90.000 0.088'), },
	{ mdl = 'models/props_lab/partsbin01.mdl',pos = Vector('-5556.625000 -1094.250000 47.437500'), ang = Angle('0.088 -89.956 0.044'), },
	{ mdl = 'models/props_c17/oildrum001.mdl',pos = Vector('-6295.593750 -1135.250000 0.406250'), ang = Angle('0.000 -43.154 0.000'), },
}
MapProp.m_tblCars = {
	{ mdl = 'models/tdmcars/fer_f12.mdl',pos = Vector('-4726.281250 -992.624939 -0.437500'), ang = Angle('0.000 -90.879 0.088'), },
	{ mdl = 'models/tdmcars/mitsu_evo8.mdl',pos = Vector('-5482.500000 -635.093750 0.343750'), ang = Angle('0.044 -146.250 -0.571'), },
	{ mdl = 'models/tdmcars/cad_escalade.mdl',pos = Vector('-6145.250000 -420.625000 -0.375000'), ang = Angle('0.000 -137.241 -0.044'), },
	{ mdl = 'models/tdmcars/toy_mr2gt.mdl',pos = Vector('-6010.375000 -822.093750 -0.531250'), ang = Angle('0.000 -114.829 0.088'), },
	{ mdl = 'models/tdmcars/bmwm1.mdl',pos = Vector('-5732.500000 -675.281250 -0.218750'), ang = Angle('-0.044 -179.253 0.220'), },
	{ mdl = 'models/tdmcars/jag_ftype.mdl',pos = Vector('-5032.365234 -988.593750 -1.531250'), ang = Angle('0.000 -90.308 0.044'), },
	{ mdl = 'models/tdmcars/vw_sciroccor.mdl',pos = Vector('-5318.250000 -447.562500 -0.718750'), ang = Angle('0.000 -129.419 -0.220'), },
}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblCars ) do
		local ent = ents.Create( "prop_physics" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
		ent:SetModel( propData.mdl )
		ent:SetCollisionGroup( COLLISION_GROUP_NONE )
		ent:SetMoveType( MOVETYPE_NONE )
		ent.IsMapProp = true
		ent:Spawn()
		ent:Activate()

		ent:SetSaveValue( "fademindist", GAMEMODE.Config.DetailPropFadeMin )
		ent:SetSaveValue( "fademaxdist", GAMEMODE.Config.DetailPropFadeMax )
		ent:SetPoseParameter( "vehicle_wheel_fl_height", 0.5 )
		ent:SetPoseParameter( "vehicle_wheel_fr_height", 0.5 )
		ent:SetPoseParameter( "vehicle_wheel_rl_height", 0.5 )
		ent:SetPoseParameter( "vehicle_wheel_rr_height", 0.5 )
		--ent:InvalidateBoneCache()

		local rand = math.random( 1, table.Count(GAMEMODE.Config.StockCarColors) )
		local idx = 0
		for k, v in pairs( GAMEMODE.Config.StockCarColors ) do
			idx = idx +1
			if idx == rand then
				ent:SetColor( v )
				break
			end
		end
		
		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end
end

GAMEMODE.Map:RegisterMapProp( MapProp )