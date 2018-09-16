--[[
	Name: hardware_clerk.lua
	
		
]]--

local NPCMeta = {}
NPCMeta.Name = "Hardware Clerk"
NPCMeta.UID = "hardware_clerk"
NPCMeta.SubText = "Purchase hardware here"
NPCMeta.Model = "models/odessa.mdl"
NPCMeta.Sounds = {
	StartDialog = {
		"vo/streetwar/sniper/ba_hearcat.wav",
		"vo/streetwar/rubble/ba_illbedamned.wav",
		"vo/k_lab/ba_hesback01.wav",
		"vo/k_lab/ba_thingaway01.wav",
	},
	EndDialog = {
		"vo/k_lab/ba_geethanks.wav",
		"vo/streetwar/nexus/ba_done.wav",
		"vo/k_lab/ba_itsworking04.wav",
	}
}
--[itemID] = priceToBuy,
NPCMeta.ItemsForSale = {
	--ents
	["Crafting Table"] = 100,
	["Assembly Table"] = 100,
	["Engine Overhaul"] = 5000,
	["Vehicle Repair Kit"] = 3500,
	["Gun Smithing Table"] = 175,
	["Road Flare"] = 5,
	["Terracotta Pot"] = 15,
	["Stove"] = 75,

	--fluids
	["Cleaning Solution"] = 4,
	["Bucket of Fertilizer"] = 5,
	["Potting Soil"] = 5,

	--crafting items
	["Wood Plank"] = 20,
	["Paint Bucket"] = 5,
	["Metal Bracket"] = 15,
	["Metal Bar"] = 10,
	["Metal Plate"] = 13,
	["Metal Pipe"] = 11,
	["Metal Hook"] = 7,
	["Metal Bucket"] = 12,
	["Plastic Bucket"] = 8,
	["Wrench"] = 15,
	["Pliers"] = 15,
	["Car Battery"] = 50,
	["Circular Saw"] = 42,
	["Cinder Block"] = 10,
	["Bleach"] = 3,
	["Radiator"] = 40,
	["Crowbar"] = 10,
	["Engine Block"] = 105,
	["Large Cardboard Box"] = 3,
	["Plastic Crate"] = 12,
	["Chunk of Plastic"] = 2,
	["Cloth"] = 3,
	["Rubber Tire"] = 50,

	--misc building items
	["Concrete Barrier"] = 20,
	["Wire Fence 01"] = 25,
	["Wire Fence 02"] = 25,
	["Wire Fence 03"] = 25,
	["Large Blast Door"] = 45,
	["Blast Door"] = 35,
	["Large Wood Plank"] = 4,
	["Large Wood Fence"] = 25,
	["Wood Fence"] = 18,
}
--[itemID] = priceToSell,
NPCMeta.ItemsCanBuy = {}
for k, v in pairs( NPCMeta.ItemsForSale ) do
	NPCMeta.ItemsCanBuy[k] = math.ceil( v *0.66 )
end

function NPCMeta:OnPlayerTalk( entNPC, pPlayer )
	GAMEMODE.Net:ShowNPCDialog( pPlayer, "hardware_clerk" )
	
	if (entNPC.m_intLastSoundTime or 0) < CurTime() then
		local snd, _ = table.Random( self.Sounds.StartDialog )
		entNPC:EmitSound( snd, 60 )
		entNPC.m_intLastSoundTime = CurTime() +2
	end
end

function NPCMeta:OnPlayerEndDialog( pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= self.UID then return end

	if (pPlayer.m_entTalkingNPC.m_intLastSoundTime or 0) < CurTime() then
		local snd, _ = table.Random( self.Sounds.EndDialog )
		pPlayer.m_entTalkingNPC:EmitSound( snd, 60 )
		pPlayer.m_entTalkingNPC.m_intLastSoundTime = CurTime() +2
	end

	pPlayer.m_entTalkingNPC = nil
end

if SERVER then
	--RegisterDialogEvents is called when the npc is registered! This is before the gamemode loads so GAMEMODE is not valid yet.
	function NPCMeta:RegisterDialogEvents()
	end
elseif CLIENT then
	function NPCMeta:RegisterDialogEvents()
		GM.Dialog:RegisterDialog( "hardware_clerk", self.StartDialog, self )
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
			GAMEMODE.Net:SendNPCDialogEvent( self.UID.. "_end_dialog" )
			GAMEMODE.Dialog:HideDialog()
		end )
	end
end

GM.NPC:Register( NPCMeta )