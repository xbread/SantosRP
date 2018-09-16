--[[
	Name: home_items_clerk.lua
	For: SantosRP
	By: Ultra
]]--

local NPCMeta = {}
NPCMeta.Name = "Home Items Clerk"
NPCMeta.UID = "home_items_clerk"
NPCMeta.SubText = "Purchase items here"
NPCMeta.Model = "models/Humans/Group02/Female_02.mdl"

--[itemID] = priceToBuy,
NPCMeta.ItemsForSale = {

	--furniture
	["Sofa 1"] = 300,
	["Sofa 2"] = 300,
	["Sofa 3"] = 300,
	["Chair 1"] = 50,
	["Chair 2"] = 50,
	["Chair 3"] = 50,
	["Chair 4"] = 50,
	["Chair 5"] = 50,
	["Desk Chair 1"] = 350,
	["Desk Chair 2"] = 100,
	["Stool"] = 65,
	["Drawer Set 1"] = 150,
	["Drawer Set 2"] = 200,
	["Dresser"] = 200,
	["Cupboard"] = 200,
	["Round Table"] = 125,
	["Table"] = 100,
	["Coffee Table"] = 180,
	["Shelf Unit 1"] = 300,
	["Shelf Unit 2"] = 150,
	["Desk"] = 200,
	["Fancy Desk"] = 400,
	["Vanity Set"] = 150,
	["File Cabinet"] = 50,
	["Large File Cabinet"] = 80,
	["Washing Machine"] = 250,

	--wall hangings
	["Wall Clock"] = 15,

	--ents
	["Storage Chest"] = 750,
}

--[itemID] = priceToSell,
NPCMeta.ItemsCanBuy = {}
for k, v in pairs( NPCMeta.ItemsForSale ) do
	NPCMeta.ItemsCanBuy[k] = math.ceil( v *0.66 )
end
function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "home_items_clerk" )
end
if SERVER then

	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "home_items_clerk", self.StartDialog, self )
	end
	function NPCMeta:StartDialog()
		GAMEMODE.Dialog:ShowDialog()
		GAMEMODE.Dialog:SetModel( self.Model )
		GAMEMODE.Dialog:SetTitle( self.Name )
		GAMEMODE.Dialog:SetPrompt( "You gonna buy something pal?" )
		GAMEMODE.Dialog:AddOption( "Show me what you have for sale.", function()
			GAMEMODE.Gui:ShowNPCShopMenu( self.UID )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "I would like to return some items.", function()
			GAMEMODE.Gui:ShowNPCSellMenu( self.UID )
			GAMEMODE.Dialog:HideDialog()
		end )
		GAMEMODE.Dialog:AddOption( "Never mind, I have to go.", function()
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )