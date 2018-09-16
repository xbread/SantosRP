--[[
	Name: sv_npcs.lua
	For: TalosLife
	By: TalosLife
]]--

GM.NPC = {}
GM.NPC.m_tblNPCRegister = {}

function GM.NPC:LoadNPCs()
	GM:PrintDebug( 0, "->LOADING NPCs" )

	local foundFiles, foundFolders = file.Find( GM.Config.GAMEMODE_PATH.. "npcs/*.lua", "LUA" )
	GM:PrintDebug( 0, "\tFound ".. #foundFiles.. " files." )

	for k, v in pairs( foundFiles ) do
		GM:PrintDebug( 0, "\tLoading ".. v )
		include( GM.Config.GAMEMODE_PATH.. "npcs/".. v )
		AddCSLuaFile( GM.Config.GAMEMODE_PATH.. "npcs/".. v )
	end

	GM:PrintDebug( 0, "->NPCs LOADED" )
end

function GM.NPC:Register( tblNPC )
	self.m_tblNPCRegister[tblNPC.UID] = tblNPC

	if tblNPC.RegisterDialogEvents then
		if tblNPC.OnPlayerEndDialog then
			GM.Dialog:RegisterDialogEvent( tblNPC.UID.. "_end_dialog", tblNPC.OnPlayerEndDialog, tblNPC )
		end

		tblNPC:RegisterDialogEvents()
	end
end

function GM.NPC:GetNPCMeta( strNPCUID )
	return self.m_tblNPCRegister[strNPCUID]
end

function GM.NPC:Initialize()
	for k, v in pairs( self.m_tblNPCRegister ) do
		if v.Initialize then v:Initialize() end
	end
end

function GM.NPC:InitPostEntity()
end

function GM.NPC:PlayerBuyNPCItem( pPlayer, strNPCID, strItemID, intAmount )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= strNPCID then return end

	local npc = self:GetNPCMeta( strNPCID )
	if not npc or not npc.ItemsForSale then return end
	
	local price = npc.ItemsForSale[strItemID] *intAmount
	if not npc.NoSalesTax then
		price = GAMEMODE.Econ:ApplyTaxToSum( "sales", price )
	end
	
	if not pPlayer:CanAfford( price ) then
		pPlayer:AddNote( "You can't afford that!" )
		return
	end

	if GAMEMODE.Inv:GivePlayerItem( pPlayer, strItemID, intAmount ) then
		pPlayer:TakeMoney( price )
		pPlayer:AddNote( "You purchased ".. intAmount.. " ".. strItemID )
	else
		pPlayer:AddNote( "There is not enough space in your inventory for that!" )
	end
end

function GM.NPC:PlayerSellNPCItem( pPlayer, strNPCID, strItemID, intAmount )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= strNPCID then return end

	local npc = self:GetNPCMeta( strNPCID )
	if not npc or not npc.ItemsCanBuy then return end
	
	local amt = GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, strItemID )
	if not amt or amt <= 0 then return end
	intAmount = math.min( intAmount, amt )
	
	local price = npc.ItemsCanBuy[strItemID] *intAmount

	if GAMEMODE.Inv:TakePlayerItem( pPlayer, strItemID, intAmount ) then
		pPlayer:AddMoney( price )
		pPlayer:AddNote( "You sold ".. intAmount.. " ".. strItemID )
	end
end