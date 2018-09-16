--[[
    Name: vapes.lua
    For: Cosmic Gaming
    By: Cheese
]]--


local Item = {}
Item.Name = "American Vape"
Item.Desc = "A vape"
Item.Type = "type_weapon"
Item.Model = "models/swamponions/vape.mdl"
Item.Weight = 4
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "weapon_vape_american"
Item.CanEquip = true
Item.Illegal = false
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_vape_american"


GM.Inv:RegisterItem( Item )



local Item = {}
Item.Name = "Custom Vape"
Item.Desc = "A Vape"
Item.Type = "type_weapon"
Item.Model = "models/swamponions/vape.mdl"
Item.Weight = 3
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "weapon_vape_custom"
Item.CanEquip = true
Item.Illegal = false
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_vape_custom"

GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Hallucinogenic Vape"
Item.Desc = "A Vape"
Item.Type = "type_weapon"
Item.Model = "models/swamponions/vape.mdl"
Item.Weight = 3
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "weapon_vape_hallucinogenic"
Item.CanEquip = true
Item.Illegal = false
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_vape_hallucinogenic"

GM.Inv:RegisterItem( Item )

local Item = {}
Item.Name = "Flavored Vape"
Item.Desc = "A Vape"
Item.Type = "type_weapon"
Item.Model = "models/swamponions/vape.mdl"
Item.Weight = 3
Item.Volume = 5
Item.CanDrop = true
Item.DropClass = "weapon_vape_juicy"
Item.CanEquip = true
Item.Illegal = false
Item.EquipSlot = "AltWeapon"
Item.EquipGiveClass = "weapon_vape_juicy"

GM.Inv:RegisterItem( Item )