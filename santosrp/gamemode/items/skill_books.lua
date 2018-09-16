--[[
	Name: skill_books.lua
	For: TalosLife
	By: TalosLife
]]--

local function CanPlayerReadBook( pPlayer, tblItem )
	if GAMEMODE.Skills:GetPlayerLevel( pPlayer, tblItem.BookSkill ) ~= tblItem.GiveLevel -1 then
		pPlayer:AddNote( "You are not at the proper skill level to read this!" )
		return false
	end
end
local function OnSkillBookUsed( pPlayer, tblItem )
	local curLevelXP = GAMEMODE.Skills:GetXPForLevel( tblItem.BookSkill, tblItem.GiveLevel -1 )
	local curXP = GAMEMODE.Skills:GetPlayerXP( pPlayer, tblItem.BookSkill )
	local diffToLevel = curLevelXP -curXP
	GAMEMODE.Skills:GivePlayerXP( pPlayer, tblItem.BookSkill, diffToLevel )
end

--Skill books for gun smithing up to level 10
for i = 2, 10 do
	local Item = {}
	Item.Model = "models/props_lab/binderredlabel.mdl"
	Item.Weight = 2
	Item.Volume = 2
	Item.CanDrop = true
	Item.CanUse = true
	Item.BookSkill = "Gun Smithing"
	Item.GiveLevel = i

	Item.Name = ("Skill Book: %s %d"):format( Item.BookSkill, Item.GiveLevel )
	Item.Desc = ("Reading this book at level %d will advance you to level %d."):format( Item.GiveLevel -1, Item.GiveLevel )
	Item.Type = "type_book"
	Item.PlayerCanUse = function( tblItem, pPlayer )
		return CanPlayerReadBook( pPlayer, tblItem )
	end
	Item.OnUse = function( tblItem, pPlayer )
		OnSkillBookUsed( pPlayer, tblItem )
	end
	GM.Inv:RegisterItem( Item )
end

--Skill books for crafting up to level 10
for i = 2, 10 do
	local Item = {}
	Item.Model = "models/props_lab/binderredlabel.mdl"
	Item.Weight = 2
	Item.Volume = 2
	Item.CanDrop = true
	Item.CanUse = true
	Item.BookSkill = "Crafting"
	Item.GiveLevel = i

	Item.Name = ("Skill Book: %s %d"):format( Item.BookSkill, Item.GiveLevel )
	Item.Desc = ("Reading this book at level %d will advance you to level %d."):format( Item.GiveLevel -1, Item.GiveLevel )
	Item.Type = "type_book"
	Item.PlayerCanUse = function( tblItem, pPlayer )
		return CanPlayerReadBook( pPlayer, tblItem )
	end
	Item.OnUse = function( tblItem, pPlayer )
		OnSkillBookUsed( pPlayer, tblItem )
	end
	GM.Inv:RegisterItem( Item )
end

--Skill books for assembly up to level 10
for i = 2, 10 do
	local Item = {}
	Item.Model = "models/props_lab/binderredlabel.mdl"
	Item.Weight = 2
	Item.Volume = 2
	Item.CanDrop = true
	Item.CanUse = true
	Item.BookSkill = "Assembly"
	Item.GiveLevel = i

	Item.Name = ("Skill Book: %s %d"):format( Item.BookSkill, Item.GiveLevel )
	Item.Desc = ("Reading this book at level %d will advance you to level %d."):format( Item.GiveLevel -1, Item.GiveLevel )
	Item.Type = "type_book"
	Item.PlayerCanUse = function( tblItem, pPlayer )
		return CanPlayerReadBook( pPlayer, tblItem )
	end
	Item.OnUse = function( tblItem, pPlayer )
		OnSkillBookUsed( pPlayer, tblItem )
	end
	GM.Inv:RegisterItem( Item )
end