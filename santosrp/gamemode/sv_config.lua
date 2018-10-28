--[[
	Name: sv_config.lua
	For: TalosLife
	By: TalosLife
]]--

 
 
--[[ errors?
	- make sure you have tmysql installed
	- make sure you have a website that allows database creations
	- make sure you have the correct version of tmysql that corresponds with your servers operating system
	- allow exteranl connections (if not done by default ask an administrator on your website) 

	examples:
	 - [hostname]: 127.0.0.1 or geteden.us <- custom domain
	 - [username]: bread
	 - [password]: advancedDataBasE@@passWorD
	 - [db name ]: geteden_santos 

	need help open up a support ticket on github (https://github.com/xbread/Open-Source-Santos/issues)

	
--]]

DEV_SERVER = false

if DEV_SERVER then
	GM.Config.SQLHostName = "#" -- Host name i.e localhost
	GM.Config.SQLUserName = "#" -- Username i.e bread
	GM.Config.SQLPassword = "#" -- Password i.e password
	GM.Config.SQLDBName = "#"   -- DB Name  i.e dbname_name
else
	GM.Config.SQLHostName = "#" -- Host name i.e localhost
	GM.Config.SQLUserName = "#" -- Username i.e bread
	GM.Config.SQLPassword = "#" -- Password i.e password
	GM.Config.SQLDBName = "#"   -- DB Name  i.e dbname_name
	end

GM.Config.SQLSnapshotRate = 5 *60 --Lower = less time between updates to sql. This value should be set with respect to the number of workers in use!
GM.Config.SQLReconnectInterval = 1 *60 --Time to wait before retrying a lost sql connection
GM.Config.SQLNumWriteWorkers = 8 --Number of connections to open to the sql server for writing player data with

--[[ IPB Settings ]]--
GM.Config.ServerRegion = "US" --Options: US, EU
GM.Config.IPBJobWhitelist = {
	["JOB_POLICE"] = { 4, 15, 23 },
	["JOB_FIREFIGHTER"] = { 4, 17, 24 },
	["JOB_EMS"] = { 4, 16, 25 },
	["JOB_MAYOR"] = { 27 },
	["JOB_PROSECUTOR"] = { 4, 41 },
	["JOB_LAWYER"] = { 4, 38 },
	["JOB_JUDGE"] = { 4, 40 },
}
GM.Config.IPBUlxGroups = {
	-- { group = "superadmin", ids = {4, (DEV_SERVER and 21 or nil)} },
	{ group = "rolad", ids = {29} },
	{ group = "headadmin", ids = {28} },
	{ group = "senior admin", ids = {12} },
	{ group = "admin", ids = {7} },
	{ group = "moderator", ids = {8} },
}

--[[ ServerNet Settings ]]--
GM.Config.ServerNetUseTLS_1_2 = false
GM.Config.ServerNetExtraAuth = false
GM.Config.ServerNetExtraAuthKey = ""
GM.Config.ServerNetPort = 37015
GM.Config.ServerNetPool = {
	DEV_SERVER and "192.168.1.85" or nil,
	not DEV_SERVER and (GM.Config.ServerRegion == "US" and "51.255.119.141" or "167.114.214.130") or nil,
}

--[[ Global Loadout Settings ]]--
GM.Config.GlobalLoadout = {
	"weapon_physgun",
	--"weapon_physcannon",
	--"weapon_fists",
	"weapon_keys",
	"weapon_srphands",
	"weapon_idcard",
}

--[[ Car Settings ]]--
GM.Config.UseCustomVehicleDamage = true
GM.Config.BaseCarFuelConsumption = 35

--[[ Property Settings ]]--
GM.Config.GovernemtDoorJobs = { --List of jobs that can lock government doors
	["JOB_POLICE"] = true,
	["JOB_EMS"] = true,
	["JOB_FIREFIGHTER"] = true,
	["JOB_SSERVICE"] = true,
	["JOB_SWAT"] = true,
	["JOB_MAYOR"] = true,
	["JOB_JUDGE"] = true,


}

--[[ Damage Settings ]]--
GM.Config.BleedDamage = 1
GM.Config.BleedInterval = 30
GM.Config.BleedBandageDuration = 60 *2 --Time a bandage should stop bleeding for
GM.Config.ItemDamageTakeCooldown = 45 --Time following a damage event to an item that a player should be blocked from picking the item back up

--[[ Fire System Settings ]]--
GM.Config.MaxFires = 256
GM.Config.MaxChildFires = 25
GM.Config.FireSpreadDistance = 80
GM.Config.FireNodeCount = 4
GM.Config.FireSpreadCount = 2
GM.Config.FireBurnEverything = true
GM.Config.FireSimRate = 6

--[[ Driving Test Questions ]]--
--Note: The questions table must be the same in the shared config, but without the answers!
GM.Config.DrivingTestRetakeDelay = 5 *60
GM.Config.MinCorrectDrivingTestQuestions = 5
GM.Config.DrivingTestQuestions_Answers = {
	{ Question = "What do you do when its a green light?", Options = { ["You begin to move"] = true, ["You stop"] = true, ["You turn off your engine"] = true } },
	{ Question = "What do you do if you see someone thats just crashed.", Options = { ["Continue driving"] = true, ["Call your friends"] = true, ["Investigate the scene"] = true } },
	{ Question = "Someone has just crashed into you and damaged your car.", Options = { ["Pull a weapon on him"] = true, ["Exchange insurance information"] = true, ["Talk shit to him while ramming his car"] = true } },
	{ Question = "Your car seems to be not functioning properly, what do you do?", Options = { ["Call the cops"] = true, ["Stand on the road to get someones attention"] = true, ["Phone up mechanical services"] = true } },
	{ Question = "You encounter a police road block and the officer tells you to turn around, do you", Options = { ["Ignore the officer and continue driving"] = true, ["Sit in your car and do nothing"] = true, ["Carefully turn around and drive"] = true } },
	{ Question = "You see a another driver driving recklessly, what do you do?", Options = { ["Inform the police"] = true, ["Drive recklessly yourself"] = true, ["Message your friend"] = true } },
	{ Question = "You have just accidentally crashed into a pole and you have injured yourself, what do you do?", Options = { ["Lie on the road and wait for someone to help"] = true, ["Follow someone until they help you"] = true, ["Call EMS"] = true } },
}

--[[ NPC Bank Item Storage Settings ]]--
GM.Config.BankStorage_MAX_UNIQUE_ITEMS = 10
GM.Config.BankStorage_MAX_NUM_ITEM = 20
GM.Config.BankStorage_VIP_MAX_UNIQUE_ITEMS = 50
GM.Config.BankStorage_VIP_MAX_NUM_ITEM = 100

--[[ NPC Drug Dealer Settings ]]--
GM.Config.DrugNPCMoveTime_Min = 15 *60
GM.Config.DrugNPCMoveTime_Max = 40 *60

--[[ NPC Jail Warden Settings ]]--
GM.Config.CopLawyerRequestCooldownTime = 60 --Time a player must wait after requesting a lawyer before they may do so again

--[[ Map Settings ]]--
--The smaller the fade min and max are, the sooner map props will stop drawing
GM.Config.DetailPropFadeMin = 1024
GM.Config.DetailPropFadeMax = 1700

--[[ Job Settings ]]--
GM.Config.JobPayInterval = 12 *60 --How often players should get paid
GM.Config.EMSReviveBonus = 100 --How much money to give an EMS player when they revive someone
GM.Config.FireBonus = 100 --How much money to give a firefighter player when they put out enough fires
GM.Config.FireExtinguishBonusCount = 50 --How many fires a player must put out before they get paid the bonus

--[[ Weather ]]--
GM.Config.WeatherRandomizer_MinTime = 60 *4
GM.Config.WeatherRandomizer_MaxTime = 60 *8
GM.Config.WeatherTable = {
	{ ID = "thunder_storm", MinTime = 60 *3.5, MaxTime = 60 *12, Chance = function() return math.random(1, 8) == 1 end },
	{ ID = "thunder_storm", MinTime = 60 *6, MaxTime = 60 *15, Chance = function() return math.random(1, 8) == 1 end },
	{ ID = "light_rain", MinTime = 60 *3.5, MaxTime = 60 *8, Chance = function() return math.random(1, 5) == 1 end },
	{ ID = "light_rain", MinTime = 60 *3.5, MaxTime = 60 *8, Chance = function() return math.random(1, 5) == 1 end },
	{ ID = "light_rain", MinTime = 60 *6, MaxTime = 60 *15, Chance = function() return math.random(1, 10) == 1 end },
}

--[[ Misc Settings ]]--
GM.Config.AdvertPrice = 20
GM.Config.MinDrugConfiscatePrice = 25
GM.Config.MaxDrugConfiscatePrice = 50
GM.Config.DefWalkSpeed = 110
GM.Config.DefRunSpeed = 220
GM.Config.MaxRunSpeed = 280

--[[ Hard Coded Ban List ]]--
GM.Config.Banned4Lyfe = {



}
