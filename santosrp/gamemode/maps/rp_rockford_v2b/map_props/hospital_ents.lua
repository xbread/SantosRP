--[[
	Name: hospital_ents.lua
	
		
]]--

local MapProp = {}
MapProp.ID = "hospital_ents"
MapProp.m_tblSpawn = {
	--{ mdl = 'models/pg_props/pg_hospital/pg_roll_table.mdl',pos = Vector('-6744.309082 7069.275391 292.758972'), ang = Angle('0.428 119.949 0.110'), },
	--{ mdl = 'models/pg_props/pg_hospital/pg_roll_table.mdl',pos = Vector('-6740.299805 7204.214844 292.694946'), ang = Angle('-0.060 -50.422 -0.374'), },
	--{ mdl = 'models/pg_props/pg_hospital/pg_oplight.mdl',pos = Vector('-6684.240723 7164.379395 448.521606'), ang = Angle('0.000 0.000 0.000'), },
	--{ mdl = 'models/props_equipment/surgicaltray_01.mdl',pos = Vector('-6739.729004 7206.403320 327.377167'), ang = Angle('0.110 -11.843 -0.516'), },
	--{ mdl = 'models/pg_props/pg_hospital/pg_oplight.mdl',pos = Vector('-6684.256348 7036.735352 448.007385'), ang = Angle('0.000 0.000 0.000'), },
	--{ mdl = 'models/props_equipment/surgicaltray_01.mdl',pos = Vector('-6743.733398 7069.319336 327.401886'), ang = Angle('0.247 29.306 -0.341'), },
}

function MapProp:CustomSpawn()
	--self.m_entSurgeryBed1 = ents.Create( "ent_ems_surgery_bed" )
	--self.m_entSurgeryBed1:SetPos( Vector(-6672.580566, 7040.103516, 292.316711) )
	--self.m_entSurgeryBed1:SetAngles( Angle(0, 90, 0) )
	--self.m_entSurgeryBed1:Spawn()
	--self.m_entSurgeryBed1:Activate()
	--self.m_entSurgeryBed1.IsMapProp = true

	--self.m_entHeartMon1 = ents.Create( "ent_ems_heart_mon" )
	--self.m_entHeartMon1:SetPos( Vector(-6754.341309, 7038.824707, 292.445313) )
	--self.m_entHeartMon1:SetAngles( Angle(0, 0, 0) )
	--self.m_entHeartMon1:Spawn()
	--self.m_entHeartMon1:Activate()
	--self.m_entHeartMon1.IsMapProp = true
	--self.m_entHeartMon1:SetBedEntity( self.m_entSurgeryBed1 )

	--self.m_entSurgeryBed2 = ents.Create( "ent_ems_surgery_bed" )
	--self.m_entSurgeryBed2:SetPos( Vector(-6674.209473, 7169.687988, 292.258636) )
	--self.m_entSurgeryBed2:SetAngles( Angle(0, 90, 0) )
	--self.m_entSurgeryBed2:Spawn()
	--self.m_entSurgeryBed2:Activate()
	--self.m_entSurgeryBed2.IsMapProp = true

	--self.m_entHeartMon2 = ents.Create( "ent_ems_heart_mon" )
	--self.m_entHeartMon2:SetPos( Vector(-6754.332520, 7169.642578, 292.441284) )
	--self.m_entHeartMon2:SetAngles( Angle(0, 0, 0) )
	--self.m_entHeartMon2:Spawn()
	--self.m_entHeartMon2:Activate()
	--self.m_entHeartMon2.IsMapProp = true
	--self.m_entHeartMon2:SetBedEntity( self.m_entSurgeryBed2 )

	self.m_entBloodAnalyzer = ents.Create( "ent_blood_analyzer" )
	self.m_entBloodAnalyzer:SetPos( Vector(445.361572, -5528.031250, 95.031250) )
	self.m_entBloodAnalyzer:SetAngles( Angle(0, -90, 0) )
	self.m_entBloodAnalyzer:Spawn()
	self.m_entBloodAnalyzer:Activate()
	self.m_entBloodAnalyzer.IsMapProp = true
end

GAMEMODE.Map:RegisterMapProp( MapProp )