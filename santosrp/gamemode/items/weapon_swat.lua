local Item = {}
Item.Name = "Police Issued Suppressor"
Item.Desc = "Suppressor attachment."
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 2
Item.Volume = 1
Item.CanDrop = false
Item.CanEquip = false
Item.JobItem = "JOB_SWAT" 
Item.DropClass = "prop_physics"
Item.WeaponAttachENT = "suppressor"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Police Issued EoTech 553"
Item.Desc = "EoTech 553 attachment."
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 2
Item.Volume = 1
Item.CanDrop = false
Item.CanEquip = false
Item.JobItem = "JOB_SWAT" 
Item.DropClass = "prop_physics"
Item.WeaponAttachENT = "eotech"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Police Issued Foregrip"
Item.Desc = "Foregrip attachment."
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 2
Item.Volume = 1
Item.CanDrop = false
Item.CanEquip = false
Item.JobItem = "JOB_SWAT" 
Item.DropClass = "prop_physics"
Item.WeaponAttachENT = "foregrip"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Police Issued CompM4"
Item.Desc = "CompM4 attachment."
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 2
Item.Volume = 1
Item.CanDrop = false
Item.CanEquip = false
Item.JobItem = "JOB_SWAT" 
Item.DropClass = "prop_physics"
Item.WeaponAttachENT = "compm4"
GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Police Issued ELCAN C79"
Item.Desc = "ELCAN C79 attachment."
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 2
Item.Volume = 1
Item.CanDrop = false
Item.CanEquip = false
Item.JobItem = "JOB_SWAT" 
Item.DropClass = "prop_physics"
Item.WeaponAttachENT = "c79"
GM.Inv:RegisterItem( Item )

--------------------------------------


local Item = {}
Item.Name = "Night Stick"
Item.Desc = "A night stick."
Item.Type = "type_weapon"
Item.Model = "models/sal/nightstick.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "night stick"
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_nightstick"
Item.DropClass = "weapon_nightstick"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Radar Gun"
Item.Desc = "A radar gun. Used to determine the speed of a moving vehicle."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_toolgun.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "radar gun"
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_radargun"
Item.DropClass = "weapon_radargun"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Spike Strip"
Item.Desc = "A deployable spike strip."
Item.Type = "type_weapon"
Item.Model = "models/myproject/SpikeStrip001.mdl"
Item.Weight = 10
Item.Volume = 15
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "spike strip"
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_roadspikes"
Item.DropClass = "weapon_roadspikes"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Battering Ram"
Item.Desc = "A ram used to force open doors for players with warrants."
Item.Type = "type_weapon"
Item.Model = "models/weapons/custom/w_batram.mdl"
Item.Weight = 8
Item.Volume = 15
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "battering ram"
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_doorram"
Item.DropClass = "weapon_doorram"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Taser"
Item.Desc = "A taser."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_pistol.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "taser"
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_taser"
Item.DropClass = "weapon_taser"
Item.PacOutfit = "taser_belt"

GM.PacModels:Register( Item.PacOutfit, {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
					[1] = {
						["children"] = {
							[1] = {
								["children"] = {
								},
								["self"] = {
									["Angles"] = Angle(-0.00036541512235999, -90, -0.00027235379093327),
									["ClassName"] = "clip",
									["UniqueID"] = "4162125740",
									["Position"] = Vector(-2.06103515625, 3.232421875, 0.734375),
								},
							},
							[2] = {
								["children"] = {
								},
								["self"] = {
									["Event"] = "weapon_class",
									["UniqueID"] = "1467435601",
									["Operator"] = "equal",
									["ClassName"] = "event",
									["Arguments"] = "weapon_taser@@1",
								},
							},
						},
						["self"] = {
							["UniqueID"] = "2086877014",
							["Scale"] = Vector(1, 0.89999997615814, 1),
							["Angles"] = Angle(-4.3115571315866e-005, -90, -86.656455993652),
							["Size"] = 0.775,
							["ClassName"] = "model",
							["Position"] = Vector(-0.9697265625, 0.0517578125, 2.33056640625),
							["Bone"] = "spine",
							["Model"] = "models/sal/stungun.mdl",
							["EditorExpand"] = true,
						},
					},
				},
				["self"] = {
					["UniqueID"] = "2403179842",
					["Model"] = "models/weapons/w_eq_eholster.mdl",
					["Scale"] = Vector(1, 1.3999999761581, 1),
					["EditorExpand"] = true,
					["Angles"] = Angle(-57.896198272705, -37.184963226318, -132.74348449707),
					["Size"] = 0.575,
					["Position"] = Vector(-2.6552734375, 7.5830078125, 4.28369140625),
					["Color"] = Vector(136, 136, 136),
					["Bone"] = "spine",
					["Brightness"] = 0.9,
					["ClassName"] = "model",
				},
			},
		},
		["self"] = {
			["EditorExpand"] = true,
			["UniqueID"] = "464675880",
			["ClassName"] = "group",
			["Name"] = "my outfit",
			["Description"] = "add parts to me!",
		},
	},
} )
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue M4A1"
Item.Desc = "An M4A1 rifle."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_rif_m4a1.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "police issue M4A1"
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "fas2_m4a1"
Item.DropClass = "fas2_m4a1"
Item.PacOutfit = "m4_back"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue SR-25"
Item.Desc = "An SR-25 rifle."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_sr25.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "police issue SR-25"
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "fas2_sr25"
Item.DropClass = "fas2_sr25"
Item.PacOutfit = "sr25_back"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue P226"
Item.Desc = "A P226 pistol."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_pist_p228.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "police issue P226"
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "fas2_p226"
Item.DropClass = "fas2_p226"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue Glock-20"
Item.Desc = "A Glock-20 pistol."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_pist_glock18.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "police issue Glock-20"
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "fas2_glock20"
Item.DropClass = "fas2_glock20"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue 10x25MM 60 Rounds"
Item.Desc = "60 rounds of 10x25MM ammunition."
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanUse = true
Item.LimitID = "police issue 10x25MM rounds"
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.DropClass = "fas2_ammo_10x25"

Item.PlayerCanUse = function( _, pPlayer )
	if pPlayer:GetAmmoCount( "10x25MM" ) > 60 then
		pPlayer:AddNote( "You can't equip that much ammo!" )
		return false
	end

	return true
end
Item.OnUse = function( _, pPlayer )
	pPlayer:GiveAmmo( 60, "10x25MM" )
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue 5.56x45MM 60 Rounds"
Item.Desc = "60 rounds of 60 Rounds ammunition."
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 4
Item.Volume = 2
Item.CanDrop = false
Item.CanUse = true
Item.LimitID = "police issue 556X45 rounds"
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.DropClass = "fas2_ammo_556x45"

Item.PlayerCanUse = function( _, pPlayer )
	if pPlayer:GetAmmoCount( "5.56x45MM" ) > 60 then
		pPlayer:AddNote( "You can't equip that much ammo!" )
		return false
	end

	return true
end
Item.OnUse = function( _, pPlayer )
	pPlayer:GiveAmmo( 60, "5.56x45MM" )
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue .357 SIG 30 Rounds"
Item.Desc = ".357 SIG 30 Rounds"
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 4
Item.Volume = 2
Item.CanDrop = false
Item.CanUse = true
Item.LimitID = "police issue 357sig rounds"
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.DropClass = "fas2_ammo_357sig"

Item.PlayerCanUse = function( _, pPlayer )
	if pPlayer:GetAmmoCount( ".357 SIG" ) > 30 then
		pPlayer:AddNote( "You can't equip that much ammo!" )
		return false
	end

	return true
end
Item.OnUse = function( _, pPlayer )
	pPlayer:GiveAmmo( 30, ".357 SIG" )
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


--[[local Item = {}
Item.Name = "Police Issue M3 Super 90"
Item.Desc = "An M3 Super 90 shotgun."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_shot_m3super90.mdl"
Item.Weight = 14
Item.Volume = 11
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "police issue M3 Super 90"
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "fas2_m3s90"
Item.DropClass = "fas2_m3s90"
Item.PacOutfit = "m3_back"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )]]--


--[[local Item = {}
Item.Name = "Police Issue 12 Gauge 16 Rounds"
Item.Desc = "16 rounds of 12 gauge ammunition."
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 8
Item.Volume = 5
Item.CanDrop = false
Item.CanUse = true
Item.LimitID = "police issue 12 gauge rounds"
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.DropClass = "fas2_ammo_12gauge"

Item.PlayerCanUse = function( _, pPlayer )
	if pPlayer:GetAmmoCount( "12 Gauge" ) > 16 then
		pPlayer:AddNote( "You can't equip that much ammo!" )
		return false
	end

	return true
end
Item.OnUse = function( _, pPlayer )
	pPlayer:GiveAmmo( 16, "12 Gauge" )
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )]]--


local Item = {}
Item.Name = "Police Issue M24"
Item.Desc = "An M24 bolt action rifle."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_m24.mdl"
Item.Weight = 6
Item.Volume = 12
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "police issue M24"
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "fas2_m24"
Item.DropClass = "fas2_m24"
Item.PacOutfit = "m24_back"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue 7.62x51MM 40 Rounds"
Item.Desc = "40 rounds of 7.62x51MM ammunition."
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 2
Item.Volume = 2
Item.CanDrop = false
Item.CanUse = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "police issue 7.62x51MM rounds"
Item.DropClass = "fas2_ammo_762x51"

Item.PlayerCanUse = function( _, pPlayer )
	if pPlayer:GetAmmoCount( "7.62x51MM" ) > 40 then
		pPlayer:AddNote( "You can't equip that much ammo!" )
		return false
	end

	return true
end
Item.OnUse = function( _, pPlayer )
	pPlayer:GiveAmmo( 40, "7.62x51MM" )
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue MP5A5"
Item.Desc = "An MP5A5 sub-machine gun."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_smg_mp5.mdl"
Item.Weight = 4
Item.Volume = 8
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "police issue MP5A5"
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "fas2_mp5a5"
Item.DropClass = "fas2_mp5a5"
Item.PacOutfit = "mp5_back"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue 9x19MM 60 Rounds"
Item.Desc = "60 rounds of 9x19MM ammunition."
Item.Type = "type_ammo"
Item.Model = "models/Items/BoxMRounds.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanUse = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "police issue 9x19MM rounds"
Item.DropClass = "fas2_ammo_9x19"

Item.PlayerCanUse = function( _, pPlayer )
	if pPlayer:GetAmmoCount( "9x19MM" ) > 60 then
		pPlayer:AddNote( "You can't equip that much ammo!" )
		return false
	end

	return true
end
Item.OnUse = function( _, pPlayer )
	pPlayer:GiveAmmo( 60, "9x19MM" )
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "Police Issue Traffic Cone"
Item.Desc = "A traffic cone."
Item.Model = "models/props_junk/TrafficCone001a.mdl"
Item.Weight = 1
Item.Volume = 1
Item.HealthOverride = 5000
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "traffic cone"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 10 )
Item.CollidesWithCars = true


local Item = {}
Item.Name = "Police Issue Traffic Board"
Item.Desc = "A traffic trailer board."
Item.Model = "models/noble/trailermessageboard/trailermessageboard.mdl"
Item.Weight = 2
Item.Volume = 8
Item.HealthOverride = 5000
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "traffictrailer"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )
Item.CollidesWithCars = true


local Item = {}
Item.Name = "Police Issue Traffic Barrel"
Item.Desc = "A traffic trailer barrel."
Item.Model = "models/noble/trafficbarrel/traffic_barrel.mdl"
Item.Weight = 2
Item.Volume = 8
Item.HealthOverride = 5000
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "trafficbarell"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 10 )
Item.CollidesWithCars = true


local Item = {}
Item.Name = "Police Issue Checkpoint"
Item.Desc = "A traffic checkpoint"
Item.Model = "models/noble/checkpoint.mdl"
Item.Weight = 2
Item.Volume = 8
Item.HealthOverride = 5000
Item.CanDrop = true
Item.RemoveDropOnDeath = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "checkpoint"
Item.SetupEntity = function( _, eEnt )
	eEnt.CanPlayerPickup = function( eEnt, pPlayer, bCanUse )
		return eEnt:GetPlayerOwner() == pPlayer
	end
end
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )
Item.CollidesWithCars = true


local Item = {}
Item.Name = "Police Issue Flash Grenade"
Item.Desc = "A flash bang."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_eq_flashbang.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = false
Item.CanEquip = true
Item.EquipSlot = "AltWeapon"
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.EquipGiveClass = "weapon_fas_grenadeflash"
Item.DropClass = "weapon_fas_grenadeflash"
GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Police Badge"
Item.Desc = "A police badge."
Item.Type = "type_weapon"
Item.Model = "models/freeman/policebadge.mdl"
Item.Weight = 1
Item.Volume = 2
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "policebadgebelt"
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "policebadge"
Item.DropClass = "policebadge"
Item.PacOutfit = "badge_swep"

GM.PacModels:Register( Item.PacOutfit, {
[1] = {
	["children"] = {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Event"] = "weapon_class",
						["UniqueID"] = "2504900514",
						["Operator"] = "equal",
						["ClassName"] = "event",
						["Arguments"] = "policebadge@@1",
					},
				},
			},
			["self"] = {
				["Position"] = Vector(-0.935546875, 7.64453125, -2.5904235839844),
				["Angles"] = Angle(19.057590484619, 100.15154266357, 91.137382507324),
				["UniqueID"] = "1311205654",
				["Size"] = 0.775,
				["EditorExpand"] = true,
				["Bone"] = "spine",
				["Model"] = "models/freeman/policebadge.mdl",
				["ClassName"] = "model",
			},
		},
	},
	["self"] = {
		["EditorExpand"] = true,
		["UniqueID"] = "1469844187",
		["ClassName"] = "group",
		["Name"] = "my outfit",
		["Description"] = "add parts to me!",
	},
},
} )
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


----------------------- undercover

local Item = {}
Item.Name = "Police Issue Glock-20 Undercover"
Item.Desc = "A Glock-20 Undercover pistol."
Item.Type = "type_weapon"
Item.Model = "models/weapons/w_pist_glock18.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "police issue glock-20under"
Item.EquipSlot = "SecondaryWeapon"
Item.EquipGiveClass = "fas2_glock20"
Item.DropClass = "fas2_glock20"
Item.PacOutfit = "police_glock20under"

GM.PacModels:Register( Item.PacOutfit, {
[1] = {
	["children"] = {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
						[1] = {
							["children"] = {
							},
							["self"] = {
								["ClassName"] = "clip",
								["UniqueID"] = "3206592900",
								["Position"] = Vector(-4.3078002929688, -0.001129150390625, 0.00408935546875),
							},
						},
						[2] = {
							["children"] = {
							},
							["self"] = {
								["Event"] = "weapon_class",
								["UniqueID"] = "2611304446",
								["Operator"] = "equal",
								["ClassName"] = "event",
								["Arguments"] = "fas2_glock20@@1",
							},
						},
					},
					["self"] = {
						["Position"] = Vector(-2.4718017578125, -0.03851318359375, 3.6764984130859),
						["Angles"] = Angle(-88.52262878418, -91.430488586426, -85.904075622559),
						["UniqueID"] = "132086741",
						["Size"] = 1.125,
						["EditorExpand"] = true,
						["Bone"] = "right thigh",
						["Model"] = "models/weapons/w_glock20.mdl",
						["ClassName"] = "model",
					},
				},
			},
			["self"] = {
				["UniqueID"] = "4133426788",
				["Scale"] = Vector(0.89999997615814, 0.89999997615814, 1.1000000238419),
				["Angles"] = Angle(-10.149306297302, -90.032623291016, 90.381484985352),
				["Size"] = 0.675,
				["ClassName"] = "model",
				["Position"] = Vector(2.2319641113281, -0.8544921875, -3.130126953125),
				["Bone"] = "right thigh",
				["Model"] = "models/weapons/w_eq_eholster.mdl",
				["EditorExpand"] = true,
			},
		},
	},
	["self"] = {
		["EditorExpand"] = true,
		["UniqueID"] = "1603873607",
		["ClassName"] = "group",
		["Name"] = "my outfit",
		["Description"] = "add parts to me!",
	},
},
} )
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}

Item.Name = "Police Issue Concrete Barrier"

Item.Desc = "A concrete barrier."

Item.Model = "models/props_c17/concrete_barrier001a.mdl"

Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job

Item.Weight = 34

Item.Volume = 28

Item.HealthOverride = 2500

Item.CanDrop = true

Item.RemoveDropOnDeath = true

Item.CollidesWithCars = true

Item.DropClass = "prop_physics_multiplayer"

GM.Inv:RegisterItem( Item )


local Item = {}
Item.Name = "Police Shield"
Item.Desc = "A riot shield."
Item.Type = "type_weapon"
Item.Model = "models/drover/shield.mdl"
Item.Weight = 6
Item.Volume = 12
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "policeshield"
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "weapon_policeshield"
Item.DropClass = "weapon_policeshield"
Item.PacOutfit = "police_riotshield"
GM.PacModels:Register( Item.PacOutfit, {
[1] = {
	["children"] = {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Event"] = "weapon_class",
						["UniqueID"] = "2755210038",
						["Operator"] = "equal",
						["ClassName"] = "event",
						["Arguments"] = "weapon_policeshield@@1",
					},
				},
			},
			["self"] = {
				["Position"] = Vector(-0.00091552734375, -4.51171875, -0.00244140625),
				["Angles"] = Angle(64.38939666748, 0.31539425253868, -2.8768904209137),
				["UniqueID"] = "3476991687",
				["Size"] = 0.85,
				["EditorExpand"] = true,
				["Bone"] = "spine 2",
				["Model"] = "models/drover/2w_shield.mdl",
				["ClassName"] = "model",
			},
		},
	},
	["self"] = {
		["EditorExpand"] = true,
		["UniqueID"] = "1220108399",
		["ClassName"] = "group",
		["Name"] = "my outfit",
		["Description"] = "add parts to me!",
	},
},
} )
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )


local Item = {}
Item.Name = "SWAT Shield"
Item.Desc = "A riot shield."
Item.Type = "type_weapon"
Item.Model = "models/drover/shield.mdl"
Item.Weight = 6
Item.Volume = 12
Item.CanDrop = false
Item.CanEquip = true
Item.JobItem = "JOB_SWAT" --This item can only be possessed by by players with this job
Item.LimitID = "policeshield"
Item.EquipSlot = "PrimaryWeapon"
Item.EquipGiveClass = "weapon_policeshield"
Item.DropClass = "weapon_policeshield"
Item.PacOutfit = "police_riotshield"
GM.PacModels:Register( Item.PacOutfit, {
[1] = {
	["children"] = {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Event"] = "weapon_class",
						["UniqueID"] = "2755210038",
						["Operator"] = "equal",
						["ClassName"] = "event",
						["Arguments"] = "weapon_policeshield@@1",
					},
				},
			},
			["self"] = {
				["Position"] = Vector(-0.00091552734375, -4.51171875, -0.00244140625),
				["Angles"] = Angle(64.38939666748, 0.31539425253868, -2.8768904209137),
				["UniqueID"] = "3476991687",
				["Size"] = 0.85,
				["EditorExpand"] = true,
				["Bone"] = "spine 2",
				["Model"] = "models/drover/2w_shield.mdl",
				["ClassName"] = "model",
			},
		},
	},
	["self"] = {
		["EditorExpand"] = true,
		["UniqueID"] = "1220108399",
		["ClassName"] = "group",
		["Name"] = "my outfit",
		["Description"] = "add parts to me!",
	},
},
} )
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )