--[[
    Name: cop_cars.lua
   
       
]]--
 
local Car = {}
Car.Make = "Audi"
Car.Name = "Audi S4 Police"
Car.UID = "s4_copaudi"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/tdmcars/emergency/aud_s4_pred.mdl"
Car.Script = "scripts/vehicles/TDMCars/aud_s4.txt"
Car.FuellTank = 120
Car.FuelConsumption = 20
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Taurus"
Car.Name = "Ford Taurus 2013"
Car.UID = "taurus_201_cop"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/tdmcars/emergency/for_taurus_13.mdl"
Car.Script = "scripts/vehicles/lwcars/jag_xfr_pol.txt"
Car.FuellTank = 120
Car.FuelConsumption = 20
Car.VehicleTable = "fortauruspoltdm"
GM.Cars:RegisterJobCar( Car )

local Car = {}
Car.Make = "Taurus"
Car.Name = "Ford Taurus 2013"
Car.UID = "taurus_201_copsp"
Car.Job = "JOB_STATE_POLICE"
Car.Desc = ""
Car.Model = "models/tdmcars/emergency/for_taurus_13.mdl"
Car.Script = "scripts/vehicles/lwcars/jag_xfr_pol.txt"
Car.FuellTank = 120
Car.FuelConsumption = 20
Car.VehicleTable = "fortauruspoltdm"
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "?"
Car.Name = "HSVW427 Police"
Car.UID = "bmw_m4_2013_cop"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/tdmcars/hsvw427_pol.mdl"
Car.Script = "scripts/vehicles/tdmcars/hsvw427.txt"
Car.FuellTank = 120
Car.FuelConsumption = 20
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Ford"
Car.Name = "2017 Ford Raptor"
Car.UID = "ford_f150_police"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/sentry/17raptor_cop.mdl"
Car.Script = "scripts/vehicles/sentry/17raptor.txt"
Car.FuellTank = 120
Car.FuelConsumption = 20
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Ford"
Car.Name = "Crown Victoria"
Car.UID = "ford_crown_victoria_cop"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/tdmcars/emergency/for_crownvic.mdl"
Car.Script = "scripts/vehicles/TDMCars/for_crownvic.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )

local Car = {}
Car.Make = "Dodge"
Car.Name = "Charger SRT8 2012 Police"
Car.UID = "ford_charger_srt8_2012_cop"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/tdmcars/emergency/dod_charger12.mdl"
Car.Script = "scripts/vehicles/tdmcars/chargersrt8.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Audi"
Car.Name = "Audi RS4 Cop"
Car.UID = "audi_rs4_cop"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/tdmcars/aud_rs4avant_pol_pr.mdl"
Car.Script = "scripts/vehicles/tdmcars/rs4avant.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Dodge"
Car.Name = "Charger SRT8 Police"
Car.UID = "chargersrt8poltdm"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/tdmcars/emergency/chargersrt8.mdl"
Car.Script = "scripts/vehicles/tdmcars/chargersrt8.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )

local Car = {}
Car.Make = "Dodge"
Car.Name = "Charger SRT8 Police"
Car.UID = "chargersrt8poltdmsp"
Car.Job = "JOB_STATE_POLICE"
Car.Desc = ""
Car.Model = "models/tdmcars/emergency/chargersrt8.mdl"
Car.Script = "scripts/vehicles/tdmcars/chargersrt8.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )


 
local Car = {}
Car.Make = "Mercedes"
Car.Name = "E350 Police"
Car.UID = "mercedes_e350_cop"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/tdmcars/emergency/mer_eclass.mdl"
Car.Script = "scripts/vehicles/TDMCars/mer_eclass.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Mitsubishi"
Car.Name = "Evo Mitsubishi Police"
Car.UID = "mitsubishi_evo_x_cop"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/tdmcars/emergency/mitsu_evox.mdl"
Car.Script = "scripts/vehicles/TDMCars/mitsu_evox.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Ford"
Car.Name = "2013 Explorer"
Car.UID = "ford_explorer_2013_cop"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/sentry/explorer.mdl"
Car.Script = "scripts/vehicles/sentry/explorer.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Ford"
Car.Name = "2010 Taurus SHO"
Car.UID = "ford_taurus_sho_2010_cop"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/sentry/taurussho.mdl"
Car.Script = "scripts/vehicles/tdmcars/for_taurus_13.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Chevrolet"
Car.Name = "Suburban Police Cruiser"
Car.UID = "chevrolet_suburban_police_cruiser_cop"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/LoneWolfie/chev_suburban_pol.mdl"
Car.Script = "scripts/vehicles/LWCars/chev_suburban.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Chevrolet"
Car.Name = "Chevrolet Suburban Police Cruiser Undercover"
Car.UID = "chevrolet_suburban_police_cruiser_und"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/LoneWolfie/chev_suburban_pol_und.mdl"
Car.Script = "scripts/vehicles/LWCars/chev_suburban.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Jaguar"
Car.Name = "XFR Special Escort Group"
Car.UID = "jaguar_xfr_special_escort_group_cop"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/LoneWolfie/jaguar_xfr_pol_und.mdl"
Car.Script = "scripts/vehicles/lwcars/jag_xfr_pol.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Vandoorn"
Car.Name = "Swat Van"
Car.UID = "vandoorn_swat_van_cop"
Car.Job = "JOB_SWAT"
Car.Desc = ""
Car.Model = "models/sentry/swatvan.mdl"
Car.Script = "scripts/vehicles/sentry/vswat.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )
 
local Car = {}
Car.Make = "Chevrolet"
Car.Name = "Impala LS Police Cruiser"
Car.UID = "chevrolet_impala_ls_police_cruiser_cop"
Car.Job = "JOB_POLICE"
Car.Desc = ""
Car.Model = "models/LoneWolfie/chev_impala_09_police.mdl"
Car.Script = "scripts/vehicles/lwcars/jag_xfr_pol.txt"
Car.FuellTank = 70
Car.FuelConsumption = 9
GM.Cars:RegisterJobCar( Car )

local Car = {}
Car.Make = "Lamborghini"
Car.Name = "Lamborghini Veneno Police"
Car.UID = "laborghini_veneno"
Car.Job = "JOB_POLICE"
Car.Desc = "A police Sports Car"
Car.Model = "models/sentry/veneno_new_cop.mdl"
Car.Script = "scripts/vehicles/sentry/veneno_new.txt"
Car.FuellTank = 120
Car.FuelConsumption = 44
GM.Cars:RegisterJobCar( Car )