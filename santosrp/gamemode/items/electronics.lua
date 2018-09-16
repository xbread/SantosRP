--[[
	Name: electronics.lua
	For: TalosLife
	By: TalosLife
]]--

if DEV_SERVER then
	local Item = {}
	Item.Name = "Dev Computer"
	Item.Desc = "Dev test item."
	Item.Model = "models/testmodels/macbook_pro.mdl"
	Item.Type = "type_electronics"
	Item.Weight = 12
	Item.Volume = 14
	Item.HealthOverride = 3000
	Item.CanDrop = true
	Item.LimitID = "computer"
	Item.DropClass = "ent_computer_base"
	Item.SetupEntity = function( _, entItem )
		--stuff
	end
	GM.Inv:RegisterItem( Item )
	GM.Inv:RegisterItemLimit( Item.LimitID, 1 )
end

--[[
	Name: electronics.lua
	For: TalosLife
	By: TalosLife
]]--

local Item = {}
Item.Name = "Stational Radio Civ"
Item.Desc = "Use this on your shop to communicate with your friends or play music"
Item.Type = "type_electronics"
Item.Model = "models/gspeak/militaryradio.mdl"
Item.Weight = 1
Item.Volume = 2
Item.HealthOverride = 3000
Item.CanDrop = true
Item.LimitID = "stational radiociv"
Item.DropClass = "radio_ent_civ"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1, { ["vip"] = 1 } )

--[[local Item = {}
Item.Name = "Civ Radio"
Item.Desc = "Civ Radio"
Item.Type = "type_weapon"
Item.Model = "models/gspeak/funktronics.mdl"
Item.Weight = 1
Item.Volume = 1
Item.HealthOverride = 3000
Item.CanDrop = true
Item.CanEquip = true
Item.Illegal = true
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_gspeak_radio_civ"
Item.DropClass = "weapon_gspeak_radio_civ"
GM.Inv:RegisterItem( Item )]]

local Item = {}
Item.Name = "Cash Register"
Item.Desc = "A cash register that allows the user to safely manage a store."
Item.Model = "models/props_c17/cashregister01a.mdl"
Item.Type = "type_electronics"
Item.Weight = 15
Item.Volume = 20
Item.HealthOverride = 3000
Item.CanDrop = true
Item.LimitID = "cash register"
Item.DropClass = "ent_cashregister"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1, { ["vip"] = 1 } )


local Item = {}
Item.Name = "Radio"
Item.Desc = "A portable radio. Plays shoutcast streams."
Item.Type = "type_electronics"
Item.Model = "models/props/cs_office/radio.mdl"
Item.Weight = 2
Item.Volume = 4
Item.CanDrop = true
Item.LimitID = "radio"
Item.DropClass = "whk_musicplayer"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )

local Item = {}
Item.Name = "Television"
Item.Desc = "A flat screen TV. Plays youtube videos and twitch.tv streams."
Item.Type = "type_electronics"
Item.Model = "models/props/cs_office/TV_plasma.mdl"
Item.Weight = 10
Item.Volume = 15
Item.CanDrop = true
Item.LimitID = "television"
Item.DropClass = "whk_tv"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1 )

local Item = {}
Item.Name = "Large Sign"
Item.Desc = "A large digital sign. Displays text that a user programs into the sign."
Item.Type = "type_electronics"
Item.Model = "models/props/cs_office/offpaintinga.mdl"
Item.Weight = 5
Item.Volume = 12
Item.CanDrop = true
Item.LimitID = "sign"
Item.DropClass = "ent_sign_large"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 1, { ["vip"] = 2 } )

local Item = {}
Item.Name = "Box Fan"
Item.Desc = "A box fan."
Item.Model = "models/freeman/ventfan.mdl"
Item.Type = "type_electronics"
Item.Weight = 6
Item.Volume = 14
Item.HealthOverride = 500
Item.CanDrop = true
Item.LimitID = "fan"
Item.DropClass = "ent_box_fan"

Item.CraftingEntClass = "ent_assembly_table"
Item.CraftingTab = "Machines"
Item.CraftSkill = "Crafting"
Item.CraftSkillLevel = 1
Item.CraftSkillXP = 5
Item.CraftRecipe = {
	["Metal Plate"] = 1,
	["Car Battery"] = 1,
	["Wrench"] = 1,
	
}
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 2 } )

local Item = {}
Item.Name = "Large Lamp"
Item.Desc = "A lamp meant for lighting large rooms."
Item.Type = "type_electronics"
Item.Model = "models/props_c17/light_decklight01_off.mdl"
Item.Weight = 20
Item.Volume = 30
Item.HealthOverride = 500
Item.CanDrop = true
Item.LimitID = "lamp"
Item.DropClass = "ent_hid_lamp"
GM.Inv:RegisterItem( Item )
GM.Inv:RegisterItemLimit( Item.LimitID, 2, { ["vip"] = 2 } )