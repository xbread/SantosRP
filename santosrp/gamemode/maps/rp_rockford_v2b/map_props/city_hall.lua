--[[
	Name: city_hall.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "city_hall"
MapProp.m_tblSpawn = {
	{ mdl = 'models/props_interiors/bottles_shelf_break08.mdl',pos = Vector('-3902.218750 -5117.250000 753.500000'), ang = Angle('-3.076 43.198 1.362'), },
	{ mdl = 'models/props_c17/furniturechair001a.mdl',pos = Vector('-3891.906250 -5028.312500 740.156250'), ang = Angle('-0.088 100.195 -0.044'), },
	{ mdl = 'models/props_c17/furniturechair001a.mdl',pos = Vector('-3927.593750 -4998.906250 740.156250'), ang = Angle('-0.088 15.557 -0.044'), },
	{ mdl = 'models/props_c17/furniturechair001a.mdl',pos = Vector('-3861.875000 -4986.250000 740.187500'), ang = Angle('-0.088 -169.014 -0.044'), },
	{ mdl = 'models/props_c17/furniturechair001a.mdl',pos = Vector('-3905.093750 -4960.468750 740.156250'), ang = Angle('-0.088 -70.752 -0.044'), },
	{ mdl = 'models/props_interiors/dining_table_round.mdl',pos = Vector('-3898.781250 -4993.062500 720.468750'), ang = Angle('0.000 -33.179 -0.044'), },
	{ mdl = 'models/props/cs_office/shelves_metal1.mdl',pos = Vector('-4256.437500 -5113.437500 720.406250'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_office/file_box.mdl',pos = Vector('-4234.562500 -4652.437500 761.250000'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_office/bookshelf3.mdl',pos = Vector('-3814.968750 -4913.500000 720.406250'), ang = Angle('0.000 180.000 -0.176'), },
	{ mdl = 'models/props_c17/shelfunit01a.mdl',pos = Vector('-4148.093750 -5117.437500 719.000000'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props_c17/shelfunit01a.mdl',pos = Vector('-4197.500000 -5067.500000 719.031250'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/splayn/rp/lr/chair.mdl',pos = Vector('-4266.187500 -4877.281250 720.500000'), ang = Angle('0.000 -93.164 0.000'), },
	{ mdl = 'models/splayn/rp/lr/chair.mdl',pos = Vector('-4340.843750 -4890.218750 720.562500'), ang = Angle('-0.132 -68.203 -0.132'), },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('-3822.218750 -5516.843750 720.468750'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/props_wasteland/controlroom_desk001a.mdl',pos = Vector('-4688.093750 -5114.031250 737.312500'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('-3862.187500 -5803.187500 720.468750'), ang = Angle('0.000 -135.000 0.000'), },
	{ mdl = 'models/splayn/rp/lr/couch.mdl',pos = Vector('-4282.843750 -5019.562500 720.375000'), ang = Angle('-0.176 99.844 0.000'), },
	{ mdl = 'models/props/cs_office/vending_machine.mdl',pos = Vector('-4773.093750 -5109.718750 720.312500'), ang = Angle('0.000 179.912 -0.044'), },
	{ mdl = 'models/sunabouzu/theater_table.mdl',pos = Vector('-4292.437500 -4953.187500 736.406250'), ang = Angle('0.000 11.426 -0.044'), },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('-5382.281250 -4916.281250 720.437500'), ang = Angle('0.044 0.000 0.088'), },
	{ mdl = 'models/props/cs_office/coffee_mug2.mdl',pos = Vector('-5319.718750 -4719.687500 750.625000'), ang = Angle('-0.044 45.000 0.044'), },
	{ mdl = 'models/props_combine/breenchair.mdl',pos = Vector('-5301.843750 -4693.437500 720.156250'), ang = Angle('0.000 -90.088 0.000'), },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('-5361.937500 -5833.437500 720.375000'), ang = Angle('0.000 89.297 0.000'), },
	{ mdl = 'models/splayn/rp/lr/couch.mdl',pos = Vector('-4246.281250 -5794.156250 720.812500'), ang = Angle('-1.890 -0.220 0.000'), },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('-5227.906250 -4815.656250 720.406250'), ang = Angle('0.044 180.000 0.088'), },
	{ mdl = 'models/props/cs_office/table_meeting.mdl',pos = Vector('-5305.343750 -4867.781250 720.281250'), ang = Angle('0.000 90.000 0.000'), },
	{ mdl = 'models/props/cs_office/vending_machine.mdl',pos = Vector('-5281.781250 -5837.718750 720.281250'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/props/cs_office/bookshelf3.mdl',pos = Vector('-5015.406250 -5848.906250 720.312500'), ang = Angle('-0.044 89.956 0.000'), },
	{ mdl = 'models/props/cs_office/bookshelf2.mdl',pos = Vector('-4600.937500 -5048.218750 720.406250'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('-5227.906250 -4916.281250 720.531250'), ang = Angle('0.044 180.000 0.088'), },
	{ mdl = 'models/props_interiors/chairlobby01.mdl',pos = Vector('-4976.250000 -5803.093750 720.156250'), ang = Angle('0.000 89.604 -0.044'), },
	{ mdl = 'models/props/cs_assault/camera.mdl',pos = Vector('-4411.437500 -5855.500000 829.125000'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('-3822.125000 -5581.343750 720.375000'), ang = Angle('0.044 -179.956 0.044'), },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('-3929.500000 -5507.250000 751.750000'), ang = Angle('-0.132 -37.617 0.000'), },
	{ mdl = 'models/props/cs_office/shelves_metal1.mdl',pos = Vector('-4316.062500 -5841.531250 720.375000'), ang = Angle('-0.044 -89.956 0.044'), },
	{ mdl = 'models/props_c17/briefcase001a.mdl',pos = Vector('-4162.718750 -5815.125000 745.937500'), ang = Angle('0.000 162.598 -0.264'), },
	{ mdl = 'models/props_c17/bench01a.mdl',pos = Vector('-4146.718750 -5150.687500 739.750000'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props_interiors/bottles_shelf_break08.mdl',pos = Vector('-4018.250000 -4657.937500 720.375000'), ang = Angle('-1.055 95.405 0.352'), },
	{ mdl = 'models/props_combine/breenglobe.mdl',pos = Vector('-3994.531250 -4660.281250 760.593750'), ang = Angle('-0.088 -9.009 -0.044'), },
	{ mdl = 'models/props_c17/bench01a.mdl',pos = Vector('-4507.781250 -5150.687500 739.750000'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_havana/bookcase_small.mdl',pos = Vector('-3808.312500 -4624.843750 728.375000'), ang = Angle('0.000 90.088 -0.044'), },
	{ mdl = 'models/props/cs_havana/bookcase_small.mdl',pos = Vector('-3854.718750 -4576.375000 728.375000'), ang = Angle('0.000 -179.956 -0.044'), },
	{ mdl = 'models/props_interiors/bottles_shelf_break06.mdl',pos = Vector('-4018.062500 -4652.906250 720.593750'), ang = Angle('-85.122 -170.815 51.021'), },
	{ mdl = 'models/props/cs_office/sofa_chair.mdl',pos = Vector('-4003.531250 -4719.812500 720.406250'), ang = Angle('-0.088 114.829 -0.044'), },
	{ mdl = 'models/props_c17/bench01a.mdl',pos = Vector('-4295.250000 -5150.687500 739.750000'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/de_nuke/file_cabinet1_group.mdl',pos = Vector('-4193.906250 -4801.843750 720.218750'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props/de_nuke/file_cabinet1_group.mdl',pos = Vector('-4193.906250 -4737.343750 720.218750'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props/de_nuke/file_cabinet1_group.mdl',pos = Vector('-4193.906250 -4672.843750 720.218750'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props/de_nuke/file_cabinet1_group.mdl',pos = Vector('-4193.906250 -4608.343750 720.218750'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props_combine/breenclock.mdl',pos = Vector('-4029.468750 -4675.093750 755.906250'), ang = Angle('0.044 89.077 0.000'), },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('-4028.968750 -4658.625000 720.312500'), ang = Angle('-0.044 -90.044 -0.044'), },
	{ mdl = 'models/props_combine/breenchair.mdl',pos = Vector('-4032.718750 -4607.625000 720.156250'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_havana/bookcase_small.mdl',pos = Vector('-3919.281250 -4576.312500 728.250000'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('-3829.187500 -4715.750000 720.312500'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/props/cs_office/offpaintingj.mdl',pos = Vector('-3808.343750 -4717.375000 785.968750'), ang = Angle('0.000 90.000 0.000'), },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('-3815.093750 -4807.656250 720.468750'), ang = Angle('0.000 -179.868 -0.044'), },
	{ mdl = 'models/props/cs_office/bookshelf2.mdl',pos = Vector('-3815.031250 -4860.625000 720.500000'), ang = Angle('0.044 180.000 -0.044'), },
	{ mdl = 'models/props_unique/coffeepot01.mdl',pos = Vector('-3831.843750 -5102.531250 753.437500'), ang = Angle('-0.527 148.096 -0.352'), },
	{ mdl = 'models/props_interiors/styrofoam_cups.mdl',pos = Vector('-3813.718750 -5120.937500 767.312500'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/props_wasteland/controlroom_desk001b.mdl',pos = Vector('-3861.031250 -5111.968750 736.281250'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_office/vending_machine.mdl',pos = Vector('-3938.843750 -5109.031250 720.281250'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/props_combine/breenclock.mdl',pos = Vector('-4490.062500 -4707.156250 756.062500'), ang = Angle('-0.132 127.705 0.000'), },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('-4339.375000 -4587.812500 719.750000'), ang = Angle('0.132 -103.447 0.220'), },
	{ mdl = 'models/props_c17/furnituredrawer002a.mdl',pos = Vector('-4233.937500 -4695.281250 736.875000'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/props_combine/breenbust.mdl',pos = Vector('-4231.250000 -4696.531250 768.281250'), ang = Angle('0.044 -179.912 -0.088'), },
	{ mdl = 'models/props_c17/shelfunit01a.mdl',pos = Vector('-4234.468750 -4636.375000 719.125000'), ang = Angle('-0.088 89.956 0.044'), },
	{ mdl = 'models/props/cs_office/file_box.mdl',pos = Vector('-4301.812500 -4586.968750 741.812500'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/props_c17/shelfunit01a.mdl',pos = Vector('-4284.437500 -4586.468750 719.187500'), ang = Angle('0.000 180.000 0.000'), },
	{ mdl = 'models/splayn/rp/lr/chair.mdl',pos = Vector('-4400.906250 -4743.468750 720.500000'), ang = Angle('0.000 143.481 0.000'), },
	{ mdl = 'models/props_c17/furnituredrawer002a.mdl',pos = Vector('-4431.906250 -4776.750000 737.062500'), ang = Angle('0.044 128.848 -0.044'), },
	{ mdl = 'models/splayn/rp/lr/chair.mdl',pos = Vector('-4474.656250 -4801.562500 720.531250'), ang = Angle('0.000 117.290 0.000'), },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('-4501.625000 -4695.656250 720.437500'), ang = Angle('0.000 -51.592 -0.044'), },
	{ mdl = 'models/props_combine/breenchair.mdl',pos = Vector('-4548.281250 -4648.031250 720.406250'), ang = Angle('-0.308 -30.806 0.000'), },
	{ mdl = 'models/props_interiors/furniture_lamp01a.mdl',pos = Vector('-4553.250000 -4720.781250 753.750000'), ang = Angle('-0.352 46.538 -0.352'), },
	{ mdl = 'models/props/cs_office/bookshelf2.mdl',pos = Vector('-4600.968750 -4889.093750 720.343750'), ang = Angle('0.000 0.000 -0.044'), },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('-4600.843750 -4942.031250 720.437500'), ang = Angle('0.000 0.044 -0.044'), },
	{ mdl = 'models/props/cs_office/bookshelf3.mdl',pos = Vector('-4600.843750 -4995.125000 720.468750'), ang = Angle('0.000 0.044 0.000'), },
	{ mdl = 'models/props_lab/plotter.mdl',pos = Vector('-3959.531250 -5717.000000 720.281250'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props/cs_office/sofa.mdl',pos = Vector('-5434.781250 -5758.375000 720.312500'), ang = Angle('0.000 0.088 0.000'), },
	{ mdl = 'models/props/cs_office/file_cabinet1_group.mdl',pos = Vector('-4015.000000 -5841.875000 720.343750'), ang = Angle('0.000 90.000 0.000'), },
	{ mdl = 'models/splayn/rp/lr/couch.mdl',pos = Vector('-4076.500000 -5791.656250 720.406250'), ang = Angle('-0.044 179.780 0.000'), },
	{ mdl = 'models/props/cs_office/computer.mdl',pos = Vector('-5001.937500 -5582.250000 751.625000'), ang = Angle('-0.088 89.604 -0.088'), },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('-5068.375000 -5848.906250 720.281250'), ang = Angle('0.000 90.000 0.000'), },
	{ mdl = 'models/props_c17/suitcase_passenger_physics.mdl',pos = Vector('-3928.875000 -5580.062500 738.218750'), ang = Angle('0.000 -0.044 -0.615'), },
	{ mdl = 'models/sunabouzu/theater_table.mdl',pos = Vector('-5355.281250 -5757.812500 736.375000'), ang = Angle('-0.088 -0.044 -0.176'), },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('-5349.593750 -5529.156250 720.343750'), ang = Angle('0.000 -0.791 -0.044'), },
	{ mdl = 'models/props/cs_office/offcorkboarda.mdl',pos = Vector('-3808.406250 -5802.656250 786.750000'), ang = Angle('0.264 90.044 0.264'), },
	{ mdl = 'models/props/cs_office/file_box.mdl',pos = Vector('-4000.187500 -5840.937500 783.812500'), ang = Angle('0.044 2.988 -0.220'), },
	{ mdl = 'models/props/cs_office/trash_can.mdl',pos = Vector('-4359.968750 -5842.750000 720.406250'), ang = Angle('-0.483 86.484 0.000'), },
	{ mdl = 'models/props_interiors/chairlobby01.mdl',pos = Vector('-4975.750000 -5725.250000 720.156250'), ang = Angle('0.000 89.604 -0.044'), },
	{ mdl = 'models/props/cs_office/plant01.mdl',pos = Vector('-5436.125000 -5832.250000 719.781250'), ang = Angle('0.000 42.935 0.000'), },
	{ mdl = 'models/sunabouzu/theater_table.mdl',pos = Vector('-4159.218750 -5795.437500 736.437500'), ang = Angle('0.000 89.297 0.000'), },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('-5202.125000 -5529.718750 720.437500'), ang = Angle('0.000 -0.439 0.000'), },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('-5165.406250 -5529.281250 720.312500'), ang = Angle('0.088 0.000 0.044'), },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('-5311.312500 -5528.687500 720.312500'), ang = Angle('0.000 0.000 0.000'), },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('-4065.531250 -5528.218750 720.437500'), ang = Angle('-0.044 -179.692 0.044'), },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('-3927.750000 -5527.937500 720.250000'), ang = Angle('0.000 -179.868 0.000'), },
	{ mdl = 'models/props_lab/workspace001.mdl',pos = Vector('-3954.406250 -5780.031250 720.781250'), ang = Angle('-0.396 89.956 0.000'), },
	{ mdl = 'models/props_lab/securitybank.mdl',pos = Vector('-3862.062500 -5854.687500 719.750000'), ang = Angle('0.000 90.000 0.000'), },
	{ mdl = 'models/props_interiors/corkboardverticle01.mdl',pos = Vector('-4690.218750 -5127.156250 795.906250'), ang = Angle('0.000 90.000 0.000'), },
	{ mdl = 'models/props_interiors/chairlobby01.mdl',pos = Vector('-4976.000000 -5764.187500 720.156250'), ang = Angle('0.000 89.604 -0.044'), },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('-4104.500000 -5527.937500 720.250000'), ang = Angle('0.000 -179.868 0.000'), },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('-3889.312500 -5528.218750 720.437500'), ang = Angle('-0.044 -179.692 0.044'), },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('-4281.250000 -5527.937500 720.250000'), ang = Angle('0.000 -179.868 0.000'), },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('-4243.937500 -5528.218750 720.437500'), ang = Angle('-0.044 -179.692 0.044'), },
	{ mdl = 'models/props_combine/breendesk.mdl',pos = Vector('-5000.312500 -5588.062500 720.218750'), ang = Angle('0.000 -90.000 0.000'), },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('-5303.500000 -5029.562500 720.187500'), ang = Angle('0.000 90.000 0.000'), },
	{ mdl = 'models/props/cs_office/chair_office.mdl',pos = Vector('-5382.281250 -4815.656250 720.281250'), ang = Angle('0.044 0.000 0.088'), },
	{ mdl = 'models/props_interiors/styrofoam_cups.mdl',pos = Vector('-4630.375000 -5120.031250 768.562500'), ang = Angle('-0.176 89.912 -0.132'), },
	{ mdl = 'models/props_unique/coffeepot01.mdl',pos = Vector('-4640.031250 -5106.406250 754.750000'), ang = Angle('0.000 134.648 0.000'), },
	{ mdl = 'models/props/cs_office/bookshelf1.mdl',pos = Vector('-4600.875000 -5101.250000 720.500000'), ang = Angle('0.000 -0.088 -0.044'), },
}
MapProp.m_tblComputers = {
	{ class = "ent_computer_law", job = {"JOB_LAWYER", "JOB_PROSECUTOR"}, pos = Vector('-5163.187500 -5528.281250 751.687500'), ang = Angle('-0.088 180.000 -0.044'), },
	{ class = "ent_computer_law", job = {"JOB_LAWYER", "JOB_PROSECUTOR"}, pos = Vector('-5307.750000 -5527.531250 751.687500'), ang = Angle('0.000 179.648 0.000'), },
	{ class = "ent_computer_mayor", job = {"JOB_MAYOR"}, pos = Vector('-4057.343750 -4662.125000 751.656250'), ang = Angle('0.044 78.882 0.000'), },
	{ class = "ent_computer_judge", job = {"JOB_JUDGE"}, pos = Vector('-4480.843750 -4677.406250 751.718750'), ang = Angle('-0.132 142.866 -0.044'), },
}

function MapProp:CustomSpawn()
	for _, propData in pairs( self.m_tblComputers ) do
		local ent = ents.Create( propData.class or "ent_computer_base" )
		ent:SetPos( propData.pos )
		ent:SetAngles( propData.ang )
		ent.IsMapProp = true
		ent:SetJobsRequired( propData.job )
		ent:Spawn()
		ent:Activate()

		local phys = ent:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end
	end
end


GAMEMODE.Map:RegisterMapProp( MapProp )