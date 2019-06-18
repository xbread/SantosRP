--[[
	Name: sv_manifest.lua
	For: santosrp
	By: santosrp
]]--

AddCSLuaFile "santosrp/gamemode/cl_init.lua"
AddCSLuaFile "santosrp/gamemode/cl_manifest.lua"
AddCSLuaFile "santosrp/gamemode/cl_networking.lua"
AddCSLuaFile "santosrp/gamemode/cl_player.lua"
AddCSLuaFile "santosrp/gamemode/cl_player_damage.lua"
AddCSLuaFile "santosrp/gamemode/cl_characters.lua"
AddCSLuaFile "santosrp/gamemode/cl_inventory.lua"
AddCSLuaFile "santosrp/gamemode/cl_gui.lua"
AddCSLuaFile "santosrp/gamemode/cl_npcs.lua"
AddCSLuaFile "santosrp/gamemode/cl_properties.lua"
AddCSLuaFile "santosrp/gamemode/cl_calcview.lua"
AddCSLuaFile "santosrp/gamemode/cl_cinicam.lua"
AddCSLuaFile "santosrp/gamemode/cl_cars.lua"
AddCSLuaFile "santosrp/gamemode/cl_jobs.lua"
AddCSLuaFile "santosrp/gamemode/cl_jail.lua"
AddCSLuaFile "santosrp/gamemode/cl_map.lua"
AddCSLuaFile "santosrp/gamemode/cl_hud.lua"
AddCSLuaFile "santosrp/gamemode/cl_hud_car.lua"
AddCSLuaFile "santosrp/gamemode/cl_license.lua"
AddCSLuaFile "santosrp/gamemode/cl_3d2dvgui.lua"
AddCSLuaFile "santosrp/gamemode/cl_skills.lua"
AddCSLuaFile "santosrp/gamemode/cl_drugs.lua"
AddCSLuaFile "santosrp/gamemode/cl_needs.lua"
AddCSLuaFile "santosrp/gamemode/cl_buddies.lua"
AddCSLuaFile "santosrp/gamemode/cl_chatradios.lua"
AddCSLuaFile "santosrp/gamemode/cl_weather.lua"
AddCSLuaFile "santosrp/gamemode/cl_daynight.lua"
AddCSLuaFile "santosrp/gamemode/cl_apps.lua"

AddCSLuaFile "santosrp/gamemode/sh_config.lua"
AddCSLuaFile "santosrp/gamemode/sh_init.lua"
AddCSLuaFile "santosrp/gamemode/sh_propprotect.lua"
AddCSLuaFile "santosrp/gamemode/sh_economy.lua"
AddCSLuaFile "santosrp/gamemode/sh_gmodhands.lua"
AddCSLuaFile "santosrp/gamemode/sh_npcdialog.lua"
--AddCSLuaFile "santosrp/gamemode/sh_chatbox.lua"
AddCSLuaFile "santosrp/gamemode/sh_util.lua"
AddCSLuaFile "santosrp/gamemode/sh_car_radios.lua"
AddCSLuaFile "santosrp/gamemode/sh_item_radios.lua"
AddCSLuaFile "santosrp/gamemode/sh_unconscious.lua"
AddCSLuaFile "santosrp/gamemode/sh_santos_customs.lua"
AddCSLuaFile "santosrp/gamemode/sh_cars_misc.lua"
AddCSLuaFile "santosrp/gamemode/sh_pacmodels.lua"
AddCSLuaFile "santosrp/gamemode/sh_chat.lua"
AddCSLuaFile "santosrp/gamemode/sh_player_anims.lua"

include "santosrp/gamemode/sh_config.lua"
include "santosrp/gamemode/sh_propprotect.lua"
include "santosrp/gamemode/sh_economy.lua"
include "santosrp/gamemode/sh_gmodhands.lua"
include "santosrp/gamemode/sh_npcdialog.lua"
include "santosrp/gamemode/sh_chatbox.lua"
include "santosrp/gamemode/sh_util.lua"
include "santosrp/gamemode/sh_car_radios.lua"
include "santosrp/gamemode/sh_item_radios.lua"
include "santosrp/gamemode/sh_unconscious.lua"
include "santosrp/gamemode/sh_santos_customs.lua"
include "santosrp/gamemode/sh_cars_misc.lua"
include "santosrp/gamemode/sh_pacmodels.lua"
include "santosrp/gamemode/sh_chat.lua"
include "santosrp/gamemode/sh_player_anims.lua"

include "santosrp/gamemode/sv_config.lua"
include "santosrp/gamemode/sv_networking.lua"
--include "santosrp/gamemode/sv_servernet.lua"
include "santosrp/gamemode/sv_player.lua"
include "santosrp/gamemode/sv_entity.lua"
include "santosrp/gamemode/sv_player_damage.lua"
include "santosrp/gamemode/sv_entity_damage.lua"
include "santosrp/gamemode/sv_characters.lua"
include "santosrp/gamemode/sv_chatradios.lua"
include "santosrp/gamemode/sv_jobs.lua"
include "santosrp/gamemode/sv_economy.lua"
include "santosrp/gamemode/sv_trunk_storage.lua"
include "santosrp/gamemode/sv_inventory.lua"
include "santosrp/gamemode/sv_npcs.lua"
include "santosrp/gamemode/sv_properties.lua"
include "santosrp/gamemode/sv_cars.lua"
include "santosrp/gamemode/sv_map.lua"
include "santosrp/gamemode/sv_jail.lua"
include "santosrp/gamemode/sv_license.lua"
include "santosrp/gamemode/sv_mysql.lua"
include "santosrp/gamemode/sv_mysql_player.lua"
include "santosrp/gamemode/sv_firesystem.lua"
include "santosrp/gamemode/sv_bailout.lua"
include "santosrp/gamemode/sv_bank_storage.lua"
include "santosrp/gamemode/sv_phone.lua"
include "santosrp/gamemode/sv_santos_customs.lua"
include "santosrp/gamemode/sv_skills.lua"
include "santosrp/gamemode/sv_drugs.lua"
include "santosrp/gamemode/sv_needs.lua"
include "santosrp/gamemode/sv_buddies.lua"
include "santosrp/gamemode/sv_pvs_buffer.lua"
include "santosrp/gamemode/sv_chop_shop.lua"
include "santosrp/gamemode/sv_daynight.lua"
include "santosrp/gamemode/sv_weather.lua"
include "santosrp/gamemode/sv_apps.lua"
--include "santosrp/gamemode/sv_ipbgroups.lua"

--Load vgui
local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "vgui/*.lua", "LUA" )
for k, v in pairs( foundFiles ) do
	AddCSLuaFile( GM.Config.GAMEMODE_PATH.. "vgui/".. v )
end

--Add resources
local function FilesInDir( strDir, b )
	local files, folders = file.Find( strDir.. "/*", "GAME" )
	local ret = {}

	for k, file in pairs( files ) do
		ret[k] = strDir.. "/".. file
	end

	for k, folder in pairs( folders ) do
		for k2, v2 in pairs( FilesInDir(strDir.. "/".. folder, true) ) do
			table.insert( ret, v2 )
		end
	end

	return ret
end

--content
resource.AddWorkshop( "666607951" ) -- Talos Life Content - Miscellaneous 1
resource.AddWorkshop( "666610986" ) -- Talos Life Content - Sound 1
resource.AddWorkshop( "666615048" ) -- Talos Life Content - Sound 2
resource.AddWorkshop( "666618487" ) -- Talos Life Content - Materials 1
resource.AddWorkshop( "666620131" ) -- Talos Life Content - Materials 2
resource.AddWorkshop( "666622276" ) -- Talos Life Content - Materials 3
resource.AddWorkshop( "666632034" ) -- Talos Life Content - Models 4
resource.AddWorkshop( "666633517" ) -- Talos Life Content - Models 5
resource.AddWorkshop( "666636527" ) -- Talos Life Content - Models 7
resource.AddWorkshop( "666635080" ) -- Talos Life Content - Models 6
resource.AddWorkshop( "666623204" ) -- Talos Life Content - Materials 4
resource.AddWorkshop( "666623483" ) -- Talos Life Content - Materials 5
resource.AddWorkshop( "666624754" ) -- Talos Life Content - Materials 6
resource.AddWorkshop( "666626259" ) -- Talos Life Content - Materials 7
resource.AddWorkshop( "666627837" ) -- Talos Life Content - Materials 8
resource.AddWorkshop( "666628225" ) -- Talos Life Content - Materials 9
resource.AddWorkshop( "666647069" ) -- Talos Life Content - Models 1
resource.AddWorkshop( "666629480" ) -- Talos Life Content - Models 2
resource.AddWorkshop( "666630507" ) -- Talos Life Content - Models 3
resource.AddWorkshop( "666637883" ) -- Talos Life Content - Models 8
resource.AddWorkshop( "666639400" ) -- Talos Life Content - Models 9
resource.AddWorkshop( "666640635" ) -- Talos Life Content - Models 10
resource.AddWorkshop( "666641956" ) -- Talos Life Content - Models 11
resource.AddWorkshop( "218869210" ) -- SGM Shared Textures
resource.AddWorkshop( "656404692" ) -- Error
resource.AddWorkshop( "649494135" ) -- Error
resource.AddWorkshop( "765278949" ) -- SGM SWAT Van & Fire Truck [RePack]
resource.AddWorkshop( "112606459" ) -- TDMCars - Base Pack
resource.AddWorkshop( "349281554" ) -- TDMCars - Emergency Vehicles pack
resource.AddWorkshop( "811143553" ) -- Etc Stuff
resource.AddWorkshop( "811177502" ) -- Firetruck
resource.AddWorkshop( "811179747" ) -- VGUI
resource.AddWorkshop( "649293142" ) -- Talos Life Content - Player Models - Materials
resource.AddWorkshop( "649293875" ) -- Talos Life Content - Player Models - Models
resource.AddWorkshop( "802923282" ) -- 2017 Ford F-150 Raptor
resource.AddWorkshop( "632470227" ) -- VCMod Content
resource.AddWorkshop( "331844753" ) -- Suburban Medic Skin
resource.AddWorkshop( "544200183" ) -- Vending Prop Pack
resource.AddWorkshop( "812631049" ) -- Cars
resource.AddWorkshop( "332400957" ) -- 2014 Chevrolet C7 Stingray
resource.AddWorkshop( "631148832" ) -- Casino Kit: Base contents
resource.AddWorkshop( "450304784" ) -- dfb
resource.AddWorkshop( "728137762" ) -- CityRP Content 26
resource.AddWorkshop( "753721064" ) -- CityRP Content 33
resource.AddWorkshop( "728085954" ) -- CityRP Content 15
resource.AddWorkshop( "728080756" ) -- CityRP Content 13
resource.AddWorkshop( "728065994" ) -- CityRP Content 11
resource.AddWorkshop( "538347004" ) -- RP_EvoCity2_v5p Content Pt.1
resource.AddWorkshop( "538207599" ) -- EvoCity2_v5p
resource.AddWorkshop( "538350412" ) -- RP_EvoCity2_v5p Content Pt.2
resource.AddWorkshop( "320396634" ) -- [LW] Lamborghini Huracan LP610-4
resource.AddWorkshop( "622810630" ) -- RP Rockford v2 (Map File Only)
resource.AddWorkshop( "328735857" ) -- RP Rockford (Models/Materials Only)
resource.AddWorkshop( "446701063" ) -- [LW] W Motors Lykan Hypersport
resource.AddWorkshop( "735920465" ) -- Monolith: Roleplay Playermodels - EMS Model Pack
resource.AddWorkshop( "180567595" ) -- SligWolf's Limousine
resource.AddWorkshop( "829570353" ) -- Aerial Ladder Truck
resource.AddWorkshop( "261062245" ) -- Evocity V33X/V4b1/V2P Hl2 Ep1 & Ep2 textures/models
resource.AddWorkshop( "757398699" ) -- Error
resource.AddWorkshop( "840867366" ) -- Cadillac
resource.AddWorkshop( "840869917" ) -- Audi RS7
resource.AddWorkshop( "851582686" ) -- Error
resource.AddWorkshop( "394277409" ) -- SligWolf's Garbage Truck
resource.AddWorkshop( "853543795" ) -- [Photon] EvoCity Fire & EMS Skin Pack (EvoRP) (4K)
resource.AddWorkshop( "853515746" ) -- [TDM] Orion VII NG - Bus RATP
resource.AddWorkshop( "394277409" ) -- SligWolf's Garbage Truck




--fas2
resource.AddWorkshop( "201027715" )
resource.AddWorkshop( "183140076" )
resource.AddWorkshop( "181656972" )
resource.AddWorkshop( "181283903" )
resource.AddWorkshop( "183139624" )
resource.AddWorkshop( "180507408" )
resource.AddWorkshop( "201027186" )
resource.AddWorkshop( "104502728" )
