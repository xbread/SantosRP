--[[
	Name: cl_networking.lua
	
		
]]--

GM.Net = (GAMEMODE or GM).Net or {}
GM.Net.m_bVerbose = false
GM.Net.m_tblProtocols = (GAMEMODE or GM).Net.m_tblProtocols or { Names = {}, IDs = {} }
GM.Net.m_tblVarLookup = {
	Write = {
		["UInt4"] = { func = net.WriteUInt, size = 4 },
		["UInt8"] = { func = net.WriteUInt, size = 8 },
		["UInt16"] = { func = net.WriteUInt, size = 16 },
		["UInt32"] = { func = net.WriteUInt, size = 32 },
		["Int4"] = { func = net.WriteInt, size = 4 },
		["Int8"] = { func = net.WriteInt, size = 8 },
		["Int16"] = { func = net.WriteInt, size = 16 },
		["Int32"] = { func = net.WriteInt, size = 32 },
		["Angle"] = { func = net.WriteAngle },
		["Bit"] = { func = net.WriteBit },
		["Bool"] = { func = net.WriteBool },
		["Color"] = { func = net.WriteColor },
		["Double"] = { func = net.WriteDouble },
		["Entity"] = { func = net.WriteEntity },
		["Float"] = { func = net.WriteFloat },
		["Normal"] = { func = net.WriteNormal },
		["String"] = { func = net.WriteString },
		["Table"] = { func = net.WriteTable },
		["Vector"] = { func = net.WriteVector },
	},
	Read = {
		["UInt4"] = { func = net.ReadUInt, size = 4 },
		["UInt8"] = { func = net.ReadUInt, size = 8 },
		["UInt16"] = { func = net.ReadUInt, size = 16 },
		["UInt32"] = { func = net.ReadUInt, size = 32 },
		["Int4"] = { func = net.ReadInt, size = 4 },
		["Int8"] = { func = net.ReadInt, size = 8 },
		["Int16"] = { func = net.ReadInt, size = 16 },
		["Int32"] = { func = net.ReadInt, size = 32 },
		["Angle"] = { func = net.ReadAngle },
		["Bit"] = { func = net.ReadBit },
		["Bool"] = { func = net.ReadBool },
		["Color"] = { func = net.ReadColor },
		["Double"] = { func = net.ReadDouble },
		["Entity"] = { func = net.ReadEntity },
		["Float"] = { func = net.ReadFloat },
		["Normal"] = { func = net.ReadNormal },
		["String"] = { func = net.ReadString },
		["Table"] = { func = net.ReadTable },
		["Vector"] = { func = net.ReadVector },
	},
}

function GM.Net:Initialize()
	net.Receive( "gm_netmsg", function( intMsgLen, ... )
		local id, name = net.ReadUInt( 8 ), net.ReadString()
		if not id or not name then return end
		if self.m_bVerbose then print( intMsgLen, id, name ) end

		local event_data = GAMEMODE.Net:GetEventHandleByID( id, name )
		if not event_data then return end
		if event_data.meta then
			event_data.func( event_data.meta, intMsgLen, ... )
		else
			event_data.func( intMsgLen, ... )
		end
	end )
end

function GM.Net:AddProtocol( strProtocol, intNetID )
	if self.m_tblProtocols.Names[strProtocol] then return end
	self.m_tblProtocols.Names[strProtocol] = { ID = intNetID, Events = {} }
	self.m_tblProtocols.IDs[intNetID] = self.m_tblProtocols.Names[strProtocol]
end

function GM.Net:IsProtocol( strProtocol )
	return self.m_tblProtocols.Names[strProtocol] and true or false
end

function GM.Net:RegisterEventHandle( strProtocol, strMsgName, funcHandle, tblHandleMeta )
	if not self:IsProtocol( strProtocol ) then
		return
	end

	self.m_tblProtocols.Names[strProtocol].Events[strMsgName] = { func = funcHandle, meta = tblHandleMeta }
end

function GM.Net:GetEventHandle( strProtocol, strMsgName )
	if not self:IsProtocol( strProtocol ) then return end
	return self.m_tblProtocols.Names[strProtocol].Events[strMsgName]
end

function GM.Net:GetEventHandleByID( intNetID, strMsgName )
	return self.m_tblProtocols.IDs[intNetID].Events[strMsgName]
end

function GM.Net:GetProtocolIDByName( strProtocol )
	return self.m_tblProtocols.Names[strProtocol].ID
end

function GM.Net:NewEvent( strProtocol, strMsgName )
	if self.m_bVerbose then print( "New outbound net message: ".. strProtocol.. ":".. strMsgName ) end
	net.Start( "gm_netmsg" )
	net.WriteUInt( self:GetProtocolIDByName(strProtocol), 8 )
	net.WriteString( strMsgName )
end

function GM.Net:FireEvent()
	if self.m_bVerbose then print( "Sending outbound net message to server." ) end
	net.SendToServer()
end


-- ----------------------------------------------------------------
-- Core Gamemode Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "game", 0 )
GM.Net:AddProtocol( "ent", 255 )

--Player is ready for initial game data
function GM.Net:SendPlayerReady()
	self:NewEvent( "game", "ready" )
	self:FireEvent()
end

--The server is updating our in-game status
GM.Net:RegisterEventHandle( "game", "g", function( intMsgLen, pPlayer )
	GAMEMODE.m_bInGame = net.ReadBit() == 1
	hook.Call( "GamemodeGameStatusChanged", GAMEMODE, GAMEMODE.m_bInGame )
end )

--The server is loading the character we selected
GM.Net:RegisterEventHandle( "game", "load", function( intMsgLen, pPlayer )
	hook.Call( "GamemodeLoadingCharacter", GAMEMODE )
end )

--A game var has changed on the server
GM.Net:RegisterEventHandle( "game", "v", function( intMsgLen, pPlayer )
	local key = net.ReadString()
	local varData = GAMEMODE.Net.m_tblVarLookup.Read[GAMEMODE.Player:GetGameVarType( key )]
	GAMEMODE.Player:SetGameVar( key, varData.func(varData.size) )
end )

--A batched game var update was sent from the server
GM.Net:RegisterEventHandle( "game", "v_batch", function( intMsgLen, pPlayer )
	local numVars = net.ReadUInt( 16 )

	local key, varData
	for i = 1, numVars do
		key = net.ReadString()
		varData = GAMEMODE.Net.m_tblVarLookup.Read[GAMEMODE.Player:GetGameVarType( key )]
		GAMEMODE.Player:SetGameVar( key, varData.func(varData.size) )
	end
end )

--A full game var update was sent from the server
GM.Net:RegisterEventHandle( "game", "v_full", function( intMsgLen, pPlayer )
	local numVars = net.ReadUInt( 16 )

	local key, varData
	for i = 1, numVars do
		key = net.ReadString()
		varData = GAMEMODE.Net.m_tblVarLookup.Read[GAMEMODE.Player:GetGameVarType( key )]
		GAMEMODE.Player:SetGameVar( key, varData.func(varData.size) )
	end
end )

--A shared game var has changed on the server
GM.Net:RegisterEventHandle( "game", "vs", function( intMsgLen, pPlayer )
	local playerOwner = net.ReadString()
	local key = net.ReadString()
	local varData = GAMEMODE.Net.m_tblVarLookup.Read[GAMEMODE.Player:GetSharedGameVarType( key )]
	GAMEMODE.Player:SetSharedGameVar( playerOwner, key, varData.func(varData.size) )
end )

--A full shared game var update was sent from the server
GM.Net:RegisterEventHandle( "game", "vs_full", function( intMsgLen, pPlayer )
	local playerOwner = net.ReadString()
	local numVars = net.ReadUInt( 16 )

	local key, varData
	for i = 1, numVars do
		key = net.ReadString()
		varData = GAMEMODE.Net.m_tblVarLookup.Read[GAMEMODE.Player:GetSharedGameVarType( key )]
		GAMEMODE.Player:SetSharedGameVar( playerOwner, key, varData.func(varData.size) )
	end
end )

--A combined update of entity owners was sent from the server
GM.Net:RegisterEventHandle( "game", "e_owners", function( intMsgLen, pPlayer )
	local num = net.ReadUInt( 16 )

	for i = 1, num do
		local entIdx = net.ReadUInt( 16 )
		local entOwner = net.ReadEntity()
		GAMEMODE:GetEntityOwnerTable()[entIdx] = entOwner
	end
end )

--A single entity owner update was sent from the server
GM.Net:RegisterEventHandle( "game", "e_owner", function( intMsgLen, pPlayer )
	GAMEMODE:GetEntityOwnerTable()[net.ReadUInt( 16 )] = net.ReadEntity()
end )

--Send an npc dialog event to the server
function GM.Net:SendNPCDialogEvent( strEventName, tblArgs )
	self:NewEvent( "game", "npcd" )
		net.WriteString( strEventName )
		net.WriteTable( tblArgs or {} )
	self:FireEvent()
end

--Sever is sending us an open dialog event
GM.Net:RegisterEventHandle( "game", "npcd_s", function( intMsgLen, pPlayer )
	GAMEMODE.Dialog:OpenDialog( net.ReadString() )
end )

--Sever is sending us an open nwmenu event
GM.Net:RegisterEventHandle( "game", "nw_menu", function( intMsgLen, pPlayer )
	GAMEMODE.Gui:ShowNWMenu( net.ReadString() )
end )

--Server wants to show us a hint
GM.Net:RegisterEventHandle( "game", "note", function( intMsgLen, pPlayer )
	GAMEMODE.HUD:AddNote( net.ReadString(), net.ReadUInt(4), net.ReadUInt(8) )
end )

--Player wants to buy an item from an npc
function GM.Net:RequestBuyNPCItem( strNPCID, strItemID, intAmount )
	self:NewEvent( "game", "npc_b" )
		net.WriteString( strNPCID )
		net.WriteString( strItemID )
		net.WriteUInt( intAmount, 8 )
	self:FireEvent()
end

--Player wants to sell an item to an npc
function GM.Net:RequestSellNPCItem( strNPCID, strItemID, intAmount )
	self:NewEvent( "game", "npc_s" )
		net.WriteString( strNPCID )
		net.WriteString( strItemID )
		net.WriteUInt( intAmount, 8 )
	self:FireEvent()
end

--Server sent all character info to us
GM.Net:RegisterEventHandle( "game", "char_f", function( intMsgLen, pPlayer )
	local numChars = net.ReadUInt( 4 )
	local chars = {}

	for i = 1, numChars do
		chars[net.ReadUInt( 32 )] = {
			Name = {
				First = net.ReadString(),
				Last = net.ReadString(),
			},
			Model = net.ReadString(),
			Skin = net.ReadUInt( 8 ),
		}
	end

	GAMEMODE.Char.m_tblCharacters = chars
	hook.Call( "GamemodeOnCharacterUpdate", GAMEMODE, GAMEMODE.Char.m_tblCharacters )
end )

--Request to select a character
function GM.Net:RequestSelectCharacter( intCharID )
	self:NewEvent( "game", "char_s" )
		net.WriteUInt( intCharID, 32 )
	self:FireEvent()
end

--Request to submit a new character
function GM.Net:RequestCreateCharacter( tblData )
	self:NewEvent( "game", "char_n" )
		net.WriteString( tblData.Name.First )
		net.WriteString( tblData.Name.Last )
		net.WriteString( tblData.Model )
		net.WriteUInt( tblData.Sex, 4 )
		net.WriteUInt( tblData.Skin, 8 )
	self:FireEvent()
end

--Server sent us an error message while submitting a character
GM.Net:RegisterEventHandle( "game", "char_e", function( intMsgLen, pPlayer )
	hook.Call( "GamemodeCharacterCreateError", GAMEMODE, net.ReadString() )
end )

--Player wants to buy a custom license plate
function GM.Net:RequestBuyPlate( strPlate )
	self:NewEvent( "game", "buy_lp" )
		net.WriteString( strPlate )
	self:FireEvent()
end

--Player wants to submit a driving test
function GM.Net:SubmitDrivingTest( tblAnswers )
	self:NewEvent( "game", "d_test" )
		net.WriteTable( tblAnswers )
	self:FireEvent()
end

--Player wants to deposit funds in their bank account
function GM.Net:RequestDepositBankFunds( entATM, intAmount )
	self:NewEvent( "game", "atm_dep" )
		net.WriteEntity( entATM )
		net.WriteUInt( intAmount, 32 )
	self:FireEvent()
end

--Player wants to withdraw funds from their bank account
function GM.Net:RequestWithdrawBankFunds( entATM, intAmount )
	self:NewEvent( "game", "atm_wdr" )
		net.WriteEntity( entATM )
		net.WriteUInt( intAmount, 32 )
	self:FireEvent()
end

--Player wants to transfer funds from their bank account to another player's account
function GM.Net:RequestBankTransfer( entATM, intAmount, strPhoneNum )
	self:NewEvent( "game", "atm_tfr" )
		net.WriteEntity( entATM )
		net.WriteUInt( intAmount, 32 )
		net.WriteString( strPhoneNum )
	self:FireEvent()
end

--Update clientside fuel data for a car
GM.Net:RegisterEventHandle( "game", "c_fuel", function( intMsgLen, pPlayer )
	GAMEMODE.Cars:UpdateCarFuel( net.ReadUInt(16), net.ReadUInt(8), net.ReadUInt(8) )
end )

--Player wants to drop money on the ground
function GM.Net:RequestDropMoney( intAmount, bOwnerless )
	self:NewEvent( "game", "d_money" )
		net.WriteUInt( intAmount, 32 )
		net.WriteBit( bOwnerless )
	self:FireEvent()
end

-- ----------------------------------------------------------------
-- Clothing Shop Netcode
-- ----------------------------------------------------------------
--Player wants to buy a new outfit
function GM.Net:BuyCharacterClothing( intSkin, strModel )
	self:NewEvent( "game", "npcc_b" )
		net.WriteString( strModel )
		net.WriteUInt( intSkin, 8 )
	self:FireEvent()
end

--Player wants to buy an item from the clothing accessories menu
function GM.Net:BuyCharacterClothingItem( strItemID )
	self:NewEvent( "game", "buy_c_item" )
		net.WriteString( strItemID )
	self:FireEvent()
end

-- ----------------------------------------------------------------
-- Inventory Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "inv", 1 )

--The server sent us a full inventory update
GM.Net:RegisterEventHandle( "inv", "f", function( intMsgLen, pPlayer )
	local numItems = net.ReadUInt( 16 )
	local tbl = {}

	if numItems == 0 then
		LocalPlayer():SetInventory( tbl )
	else
		for i = 1, numItems do
			tbl[net.ReadString()] = net.ReadUInt( 16 )
		end

		LocalPlayer():SetInventory( tbl )
	end

	GAMEMODE:PrintDebug( 0, "Got full inventory update" )

	hook.Call( "GamemodeOnInventoryUpdated", GAMEMODE, LocalPlayer():GetInventory() or {} )
end )

--The server sent us an update for a new item
GM.Net:RegisterEventHandle( "inv", "s", function( intMsgLen, pPlayer )
	local itemName, itemAmount = net.ReadString(), net.ReadUInt( 16 )
	LocalPlayer():GetInventory()[itemName] = itemAmount > 0 and itemAmount or nil

	GAMEMODE:PrintDebug( 0, "Got update for item ".. itemName.. " - amount ".. itemAmount )
	hook.Call( "GamemodeOnInventoryUpdated", GAMEMODE, LocalPlayer():GetInventory() or {} )
end )

function GM.Net:RequestDropItem( strItemID, intAmount, bOwnerless )
	self:NewEvent( "inv", "d" )
		net.WriteString( strItemID )
		net.WriteUInt( intAmount, 8 )
		net.WriteBit( bOwnerless and true )
	self:FireEvent()
end

function GM.Net:RequestUseItem( strItemID )
	self:NewEvent( "inv", "u" )
		net.WriteString( strItemID )
	self:FireEvent()
end

function GM.Net:RequestEquipItem( strSlot, strItemID )
	self:NewEvent( "inv", "e" )
		net.WriteString( strSlot )
		net.WriteString( strItemID and strItemID or "nil" )
	self:FireEvent()
end

--Player wants to craft an item
function GM.Net:RequestCraftItem( strItemID )
	self:NewEvent( "inv", "craft" )
		net.WriteString( strItemID )
	self:FireEvent()
end

--Player wants to abort crafting something
function GM.Net:RequestAbortCraft()
	self:NewEvent( "inv", "c_abort" )
	self:FireEvent()
end

--Server sent us current crafting data
GM.Net:RegisterEventHandle( "inv", "c_start", function( intMsgLen, pPlayer )
	hook.Call( "GamemodeOnStartCrafting", GAMEMODE, net.ReadString(), net.ReadFloat() )
end )

--Server sent us an end crafting event
GM.Net:RegisterEventHandle( "inv", "c_end", function( intMsgLen, pPlayer )
	hook.Call( "GamemodeOnEndCrafting", GAMEMODE, net.ReadString() )
end )

-- ----------------------------------------------------------------
-- Bank Item Storage Netcode
-- ----------------------------------------------------------------
--Request to move an item from inventory to the bank
function GM.Net:MoveItemToNPCBank( strItemID, intAmount )
	self:NewEvent( "inv", "npcb_d" )
		net.WriteString( strItemID )
		net.WriteUInt( intAmount, 8 )
	self:FireEvent()
end

--Request to move an item from the bank to inventory
function GM.Net:TakeItemFromBank( strItemID, intAmount )
	self:NewEvent( "inv", "npcb_w" )
		net.WriteString( strItemID )
		net.WriteUInt( intAmount, 8 )
	self:FireEvent()
end

--Sever sent us an update about items in the bank
GM.Net:RegisterEventHandle( "inv", "npcb_upd", function( intMsgLen, pPlayer )
	GAMEMODE.m_tblBankItems = net.ReadTable()
	hook.Call( "GamemodeOnGetBankUpdate", GAMEMODE, GAMEMODE.m_tblBankItems )
end )

-- ----------------------------------------------------------------
-- Bank Lost And Found Storage Netcode
-- ----------------------------------------------------------------
--Player wants to move an item from the lost and found to their inventory
function GM.Net:TakeItemFromLostAndFound( strItemID, intAmount )
	self:NewEvent( "inv", "npcb_lw" )
		net.WriteString( strItemID )
		net.WriteUInt( intAmount, 8 )
	self:FireEvent()
end

--Player wants to destroy an item in lost and found
function GM.Net:DestroyLostAndFoundItem( strItemID )
	self:NewEvent( "inv", "npcb_ld" )
		net.WriteString( strItemID )
	self:FireEvent()
end

--Send player an update about items in the bank
GM.Net:RegisterEventHandle( "inv", "npcb_lupd", function( intMsgLen, pPlayer )
	GAMEMODE.m_tblLostItems = net.ReadTable()
	hook.Call( "GamemodeOnGetLostAndFoundUpdate", GAMEMODE, GAMEMODE.m_tblLostItems )
end )

 -- ----------------------------------------------------------------
-- Trunk Netcode
-- ----------------------------------------------------------------
--Request to move an item from inventory to the trunk
function GM.Net:MoveItemToTrunk( intCarIndex, strItemID, intAmount )
	self:NewEvent( "inv", "trunk_d" )
	net.WriteUInt( intCarIndex, 32 )
	net.WriteString( strItemID )
	net.WriteUInt( intAmount, 8 )
	self:FireEvent()
end

--Request to move an item from the trunk to inventory
function GM.Net:TakeItemFromTrunk( intCarIndex, strItemID, intAmount )
	self:NewEvent( "inv", "trunk_w" )
	net.WriteUInt( intCarIndex, 32 )
	net.WriteString( strItemID )
	net.WriteUInt( intAmount, 8 )
	self:FireEvent()
end

--Sever sent us an update about items in the trunk
GM.Net:RegisterEventHandle( "inv", "trunk_upd", function( intMsgLen, pPlayer )
	local eCar = ents.GetByIndex(net.ReadUInt(32))
	eCar.TrunkItems = net.ReadTable()
	hook.Call( "GamemodeOnGetTrunkUpdate" )
end )


-- ----------------------------------------------------------------
-- Vehicle Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "veh", 2 )

--Player wants to buy a car
function GM.Net:RequestBuyCar( strCarUID, intColorIDX )
	self:NewEvent( "veh", "b" )
		net.WriteString( strCarUID )
		net.WriteUInt( intColorIDX, 8 )
	self:FireEvent()
end

--Player wants to sell a car
function GM.Net:RequestSellCar( strCarUID )
	self:NewEvent( "veh", "s" )
		net.WriteString( strCarUID )
	self:FireEvent()
end

--Player wants to spawn a car
function GM.Net:RequestSpawnCar( strCarUID )
	self:NewEvent( "veh", "sp" )
		net.WriteString( strCarUID )
	self:FireEvent()
end

--Player wants to stow a car
function GM.Net:RequestStowCar()
	self:NewEvent( "veh", "st" )
	self:FireEvent()
end

-- ----------------------------------------------------------------
-- Jail Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "jail", 3 )

--Player wants to send a player to jail
function GM.Net:RequestJailPlayer( pPlayer, intTime, strReason )
	self:NewEvent( "jail", "t" )
		net.WriteEntity( pPlayer )
		net.WriteUInt( intTime, 32 )
		net.WriteString( strReason )
	self:FireEvent()
end

--Player wants to free a player from jail
function GM.Net:RequestFreePlayer( pPlayer, strReason )
	self:NewEvent( "jail", "f" )
		net.WriteEntity( pPlayer )
		net.WriteString( strReason )
	self:FireEvent()
end

--Player wants to bail a player out of jail
function GM.Net:RequestBailPlayer( pPlayer )
	self:NewEvent( "jail", "b" )
		net.WriteEntity( pPlayer )
	self:FireEvent()
end

--Player wants to warrant another player
function GM.Net:RequestWarrantPlayer( pPlayer, strReason )
	self:NewEvent( "jail", "w" )
		net.WriteEntity( pPlayer )
		net.WriteString( strReason )
	self:FireEvent()
end

--Player wants to revoke another player's warrant
function GM.Net:RequestRevokePlayerWarrant( pPlayer )
	self:NewEvent( "jail", "wr" )
		net.WriteEntity( pPlayer )
	self:FireEvent()
end

-- ----------------------------------------------------------------
-- Cop Computer Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "cop_computer", 4 )

--Player wants to get another player's rap sheet
function GM.Net:RequestPlayerRapSheet( pPlayer )
	self:NewEvent( "cop_computer", "r" )
		net.WriteEntity( pPlayer )
	self:FireEvent()
end

--The server sent us a player's main rap sheet
GM.Net:RegisterEventHandle( "cop_computer", "s", function( intMsgLen, pPlayer )
	local playerOwner = net.ReadEntity()
	local len = net.ReadUInt( 32 )
	local data = util.JSONToTable( util.Decompress(net.ReadData(len)) )
	hook.Call( "GamemodeGetRapSheet", GAMEMODE, playerOwner, data.JailData, data.LicenseData )
end )

--Player wants to revoke another players drivers license
function GM.Net:RequestRevokePlayerLicense( pPlayer, intDuration )
	self:NewEvent( "cop_computer", "rl" )
		net.WriteEntity( pPlayer )
		net.WriteUInt( intDuration, 16 )
	self:FireEvent()
end

--Player wants to place a dot on another players drivers license
function GM.Net:RequestDotPlayerLicense( pPlayer, strReason )
	self:NewEvent( "cop_computer", "d" )
		net.WriteEntity( pPlayer )
		net.WriteString( strReason )
	self:FireEvent()
end

-- ----------------------------------------------------------------
-- Ticket Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "ticket", 5 )

--Player wants to ticket another player
function GM.Net:RequestTicketPlayer( pPlayer, strReason, intPrice )
	self:NewEvent( "ticket", "gp" )
		net.WriteEntity( pPlayer )
		net.WriteString( strReason )
		net.WriteUInt( intPrice, 16 )
	self:FireEvent()
end

--Players wants to leave a ticket on a car for the owner
function GM.Net:RequestTicketCar( entVeh, strReason, intPrice )
	self:NewEvent( "ticket", "ge" )
		net.WriteEntity( entVeh )
		net.WriteString( strReason )
		net.WriteUInt( intPrice, 16 )
	self:FireEvent()
end

--Player wants to pay off a ticket
function GM.Net:RequestPayTicket( intTicketID )
	self:NewEvent( "ticket", "p" )
		net.WriteUInt( intTicketID, 8 )
	self:FireEvent()
end

--Player wants to get a list of their unpaid tickets
function GM.Net:RequestTicketList()
	self:NewEvent( "ticket", "rup" )
	self:FireEvent()
end

--Server sent us a list of our unpaid tickets
GM.Net:RegisterEventHandle( "ticket", "gt", function( intMsgLen, pPlayer )
	hook.Call( "GamemodeGetUnpaidTickets", GAMEMODE, net.ReadTable() )
end )

-- ----------------------------------------------------------------
-- Phone Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "phone", 6 )

--Dial a number
function GM.Net:DialPhoneNumber( strNumber )
	self:NewEvent( "phone", "dial" )
		net.WriteString( strNumber )
	self:FireEvent()
end

--Player wants to end a call
function GM.Net:HangUpPhone()
	self:NewEvent( "phone", "h_up" )
	self:FireEvent()
end

--Player wants to accept an incoming call
function GM.Net:AcceptCall()
	self:NewEvent( "phone", "accept" )
	self:FireEvent()
end

--Server sent us an incoming call
GM.Net:RegisterEventHandle( "phone", "inc", function( intMsgLen, pPlayer )
	hook.Call( "GamemodePhoneCallIncoming", GAMEMODE, net.ReadString() )
end )

--Server is telling us our call went though and is now ringing
GM.Net:RegisterEventHandle( "phone", "out", function( intMsgLen, pPlayer )
	hook.Call( "GamemodePhoneCallOutgoing", GAMEMODE, net.ReadString() )
	GAMEMODE.m_bPhoneCall = true
end )

--Our call has started
GM.Net:RegisterEventHandle( "phone", "start", function( intMsgLen, pPlayer )
	hook.Call( "GamemodePhoneCallStart", GAMEMODE, net.ReadString() )
end )

--Our call has ended
GM.Net:RegisterEventHandle( "phone", "end", function( intMsgLen, pPlayer )
	hook.Call( "GamemodePhoneCallEnd", GAMEMODE )
	GAMEMODE.m_bPhoneCall = false
end )

--We dialed a bad number
GM.Net:RegisterEventHandle( "phone", "err", function( intMsgLen, pPlayer )
	hook.Call( "GamemodePhoneBadNumber", GAMEMODE )
end )

--We called a player that is already in a call with someone else
GM.Net:RegisterEventHandle( "phone", "busy", function( intMsgLen, pPlayer )
	hook.Call( "GamemodePhoneBusy", GAMEMODE )
end )

--TEXT MESSAGES
-- -------------

--Player wants to send a message to someone
function GM.Net:SendTextMessage( strNumber, strMsg )
	self:NewEvent( "phone", "s_txt" )
		net.WriteString( strNumber )
		net.WriteString( strMsg )
	self:FireEvent()

	hook.Call( "GamemodePhoneSendTextMessage", GAMEMODE, strNumber, strMsg )
end

--Player sent us a message
GM.Net:RegisterEventHandle( "phone", "r_txt", function( intMsgLen, pPlayer )
	hook.Call( "GamemodePhoneGetTextMessage", GAMEMODE, net.ReadString(), net.ReadString() )
end )

--SENDING IMAGES
-- -------------

--Player wants to send an image to someone
function GM.Net:SendImageMessage( strNumber, strImageData, strOrigPath, strOrigName )
	if self.m_bSendingImage then return end
	self.m_bSendingImage = true

	self.m_strSendingData = strImageData
	self.m_intNumImageParts = math.ceil( #strImageData /65536 )
	self.m_intCurPart = 0

	self:NewEvent( "phone", "s_jpg_header" )
		net.WriteString( strNumber )
		net.WriteUInt( self.m_intNumImageParts, 8 )
	self:FireEvent()

	hook.Call( "GamemodePhoneSendImageMessage", GAMEMODE, strNumber, strImageData, strOrigPath, strOrigName )
end

--Send the next part of the image data to the sever
function GM.Net:SendImagePart()
	if self.m_intCurPart > self.m_intNumImageParts then return end
	self.m_intCurPart = self.m_intCurPart +1

	local partData = self.m_strSendingData:sub(
		(self.m_intCurPart -1) *65536,
		self.m_intCurPart *65536
	)

	self:NewEvent( "phone", "s_jpg_next_part" )
		net.WriteUInt( #partData, 32 )
		net.WriteData( partData, #partData )
	self:FireEvent()
end

--Server wants the next part of the image data
GM.Net:RegisterEventHandle( "phone", "s_jpg_next_part", function( intMsgLen, pPlayer )
	GAMEMODE.Net:SendImagePart()
end )

--Server got all the parts of our image
GM.Net:RegisterEventHandle( "phone", "s_jpg_done", function( intMsgLen, pPlayer )
	GAMEMODE.Net.m_bSendingImage = false
end )

--GETTING IMAGES
-- -------------

--Someone is sending us an image
GM.Net:RegisterEventHandle( "phone", "r_jpg_header", function( intMsgLen, pPlayer )
	GAMEMODE.Net.m_bGettingImage = true
	GAMEMODE.Net.m_strGettingImageFrom = net.ReadString()
	GAMEMODE.Net.m_intNumGettingImageParts = net.ReadUInt( 8 )
	GAMEMODE.Net.m_intCurGettingImagePart = 0
	GAMEMODE.Net.m_strGettingImageData = ""

	GAMEMODE.Net:RequestNextImagePart()
end )

--Ask the server for the next part of the incoming image data
function GM.Net:RequestNextImagePart()
	self:NewEvent( "phone", "r_jpg_next_part" )
	self:FireEvent()
end

--Server has sent us the next part of the image data
GM.Net:RegisterEventHandle( "phone", "r_jpg_next_part", function( intMsgLen, pPlayer )
	GAMEMODE.Net.m_intCurGettingImagePart = GAMEMODE.Net.m_intCurGettingImagePart +1

	local size = net.ReadUInt( 32 )
	local partData = net.ReadData( size )
	GAMEMODE.Net.m_strGettingImageData = GAMEMODE.Net.m_strGettingImageData.. partData

	if GAMEMODE.Net.m_intCurGettingImagePart >= GAMEMODE.Net.m_intNumGettingImageParts then
		GAMEMODE.Net.m_bGettingImage = false
		hook.Call( "GamemodePhoneGetImageMessage", GAMEMODE, GAMEMODE.Net.m_strGettingImageFrom, GAMEMODE.Net.m_strGettingImageData )
		GAMEMODE.Net.m_strGettingImageData = nil
	end
end )

-- ----------------------------------------------------------------
-- Drugs Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "drugs", 7 )

GM.Net:RegisterEventHandle( "drugs", "n", function( intMsgLen, pPlayer )
	local effectName, idx = net.ReadString(), net.ReadUInt( 16 )
	local time, len, power = net.ReadDouble(), net.ReadDouble(), net.ReadDouble()
	GAMEMODE.Drugs:ApplyEffect( effectName, idx, time, len, power )
end )

GM.Net:RegisterEventHandle( "drugs", "r", function( intMsgLen, pPlayer )
	GAMEMODE.Drugs:RemoveEffect( net.ReadString(), net.ReadUInt( 16 ) )
end )

GM.Net:RegisterEventHandle( "drugs", "c", function( intMsgLen, pPlayer )
	GAMEMODE.Drugs:ClearDrugEffects()
end )

-- ----------------------------------------------------------------
-- Buddy Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "buddy", 8 )

GM.Net:RegisterEventHandle( "buddy", "f_upd", function( intMsgLen, pPlayer )
	local num = net.ReadUInt( 16 )
	local buddies = {}

	if num > 0 then
		for i = 1, num do
			buddies[net.ReadUInt( 32 )] = net.ReadTable()
		end
	end

	GAMEMODE.Buddy:SetBuddyTable( buddies )
	hook.Call( "GamemodeOnBuddyUpdate", GAMEMODE )
end )

GM.Net:RegisterEventHandle( "buddy", "upd", function( intMsgLen, pPlayer )
	local buddyID, hasData = net.ReadUInt( 32 ), net.ReadBit() == 1
	local data

	if hasData then data = net.ReadTable() end
	GAMEMODE.Buddy:GetBuddyTable()[buddyID] = hasData and data or nil
	hook.Call( "GamemodeOnBuddyUpdate", GAMEMODE )
end )

function GM.Net:RequestEditBuddyKey( intBuddyID, strKey, bValue )
	self:NewEvent( "buddy", "edit_key" )
		net.WriteUInt( intBuddyID, 32 )
		net.WriteString( strKey )
		net.WriteBit( bValue )
	self:FireEvent()
end

function GM.Net:RequestAddBuddy( intBuddyID )
	self:NewEvent( "buddy", "add" )
		net.WriteUInt( intBuddyID, 32 )
	self:FireEvent()
end

function GM.Net:RequestRemoveBuddy( intBuddyID )
	self:NewEvent( "buddy", "del" )
		net.WriteUInt( intBuddyID, 32 )
	self:FireEvent()
end

-- ----------------------------------------------------------------
-- Property Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "property", 9 )

function GM.Net:RequestBuyProperty( strName )
	self:NewEvent( "property", "b" )
		net.WriteString( strName )
	self:FireEvent()
end

function GM.Net:RequestSellProperty( strName )
	self:NewEvent( "property", "s" )
		net.WriteString( strName )
	self:FireEvent()
end

--[[function GM.Net:RequestSetDoorTitle( strText )
	self:NewEvent( "property", "t" )
		net.WriteUInt( GAMEMODE.Property.NET_SET_TITLE, 8 )
		net.WriteString( strText )
	self:FireEvent()
end]]--

function GM.Net:ReadProperty()
	local tbl = {}
	tbl.Name = net.ReadString()
	tbl.Owner = net.ReadEntity()
	tbl.ID = net.ReadUInt( 16 )
	tbl.Doors = {}

	local count = net.ReadUInt( 8 )
	if count == 0 then return end
	for i = 1, count do
		local idx = net.ReadUInt( 32 )
		tbl.Doors[idx] = true
		GAMEMODE.Property.m_tblDoorCache[idx] = tbl
	end

	GAMEMODE.Property.m_tblProperties[tbl.Name].Doors = tbl.Doors
	GAMEMODE.Property.m_tblProperties[tbl.Name].Owner = tbl.Owner
	GAMEMODE.Property.m_tblProperties[tbl.Name].ID = tbl.ID
end

GM.Net:RegisterEventHandle( "property", "upd", function( intMsgLen, pPlayer )
	GAMEMODE.Net:ReadProperty()
end )

GM.Net:RegisterEventHandle( "property", "fupd", function( intMsgLen, pPlayer )
	GAMEMODE.Property.m_tblDoorCache = {}
	local count = net.ReadUInt( 16 )
	if count == 0 then return end

	for i = 1, count do
		GAMEMODE.Net:ReadProperty()
	end
end )

--[[GM.Net:RegisterEventHandle( "property", "dmn", function( intMsgLen, pPlayer )
	--!REWRITE THIS FUNCTION!--
	SRP_CS_OpenDoorOptions( net.ReadEntity(), net.ReadTable() )
	--!REWRITE THIS FUNCTION!--
end )]]--

-- ----------------------------------------------------------------
-- Car Radios Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "cradio", 10 )

GM.Net:RegisterEventHandle( "cradio", "p", function( intMsgLen, pPlayer )
	local ent, id = net.ReadEntity(), net.ReadUInt( 32 )
	local data = GAMEMODE.CarRadio.m_tblStations[id]
	GAMEMODE.CarRadio:StartStream( ent, data.Url.. (data.NoConcat and "" or id) )
end )

GM.Net:RegisterEventHandle( "cradio", "pc", function( intMsgLen, pPlayer )
	GAMEMODE.CarRadio:StartStream( net.ReadEntity(), "http://yp.shoutcast.com/sbin/tunein-station.pls?id=".. net.ReadUInt(32) )
end )

GM.Net:RegisterEventHandle( "cradio", "s", function( intMsgLen, pPlayer )
	GAMEMODE.CarRadio:StopStream( net.ReadEntity() )
end )

GM.Net:RegisterEventHandle( "cradio", "fupd", function( intMsgLen, pPlayer )
	local num = net.ReadUInt( 16 )
	if num == 0 then return end
	
	for i = 1, num do
		local ent, id = net.ReadEntity(), net.ReadUInt( 32 )
		local url = GAMEMODE.CarRadio.m_tblCarStreams[id] and GAMEMODE.CarRadio.m_tblStations[id].Url.. id or nil
		if not url then url = "http://yp.shoutcast.com/sbin/tunein-station.pls?id=".. id end
		GAMEMODE.CarRadio:StartStream( ent, url )
	end
end )

function GM.Net:RequestPlayCarRadio( intID )
	self:NewEvent( "cradio", "rp" )
		net.WriteUInt( intID, 32 )
	self:FireEvent()
end

function GM.Net:RequestPlayCustomCarRadio( intID )
	if not intID then return end
	self:NewEvent( "cradio", "rpc" )
		net.WriteUInt( intID, 32 )
	self:FireEvent()
end

function GM.Net:RequestStopCarRadio()
	self:NewEvent( "cradio", "rs" )
	self:FireEvent()
end

-- ----------------------------------------------------------------
-- Item Radios Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "iradio", 11 )

GM.Net:RegisterEventHandle( "iradio", "p", function( intMsgLen, pPlayer )
	local ent, id = net.ReadEntity(), net.ReadUInt( 32 )
	local data = GAMEMODE.CarRadio.m_tblStations[id]
	GAMEMODE.PropRadio:StartStream( ent, data.Url.. (data.NoConcat and "" or id) )
end )

GM.Net:RegisterEventHandle( "iradio", "pc", function( intMsgLen, pPlayer )
	GAMEMODE.PropRadio:StartStream( net.ReadEntity(), "http://yp.shoutcast.com/sbin/tunein-station.pls?id=".. net.ReadUInt(32) )
end )

GM.Net:RegisterEventHandle( "iradio", "s", function( intMsgLen, pPlayer )
	GAMEMODE.PropRadio:StopStream( net.ReadEntity() )
end )

GM.Net:RegisterEventHandle( "iradio", "m", function( intMsgLen, pPlayer )
	GAMEMODE.Gui:ShowPropRadioMenu()
end )

GM.Net:RegisterEventHandle( "iradio", "fupd", function( intMsgLen, pPlayer )
	local num = net.ReadUInt( 16 )
	if num == 0 then return end
	
	for i = 1, num do
		local ent, id = net.ReadEntity(), net.ReadUInt( 32 )
		local url = GAMEMODE.PropRadio.m_tblPropStreams[id] and GAMEMODE.PropRadio.m_tblPropStreams[id].Url.. id or nil
		if not url then url = "http://yp.shoutcast.com/sbin/tunein-station.pls?id=".. id end
		GAMEMODE.PropRadio:StartStream( ent, url )
	end
end )

function GM.Net:RequestPlayPropRadio( eEnt, intID )
	self:NewEvent( "iradio", "rp" )
		net.WriteEntity( eEnt )
		net.WriteUInt( intID, 32 )
	self:FireEvent()
end

function GM.Net:RequestPlayCustomPropRadio( eEnt, intID )
	self:NewEvent( "iradio", "rpc" )
		net.WriteEntity( eEnt )
		net.WriteUInt( intID, 32 )
	self:FireEvent()
end

function GM.Net:RequestStopPropRadio( eEnt )
	self:NewEvent( "iradio", "rs" )
		net.WriteEntity( eEnt )
	self:FireEvent()
end

-- ----------------------------------------------------------------
-- Chat Radios Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "chat_radio", 12 )

function GM.Net:RequestChangeChatRadioChannel( intNewChanID )
	self:NewEvent( "chat_radio", "rs" )
		net.WriteUInt( intNewChanID, 8 )
	self:FireEvent()
end

function GM.Net:RequestMuteChatRadio( bMuted )
	self:NewEvent( "chat_radio", "rm" )
		net.WriteBit( bMuted )
	self:FireEvent()
end

GM.Net:RegisterEventHandle( "chat_radio", "c", function( intMsgLen, pPlayer )
	if net.ReadBit() == 0 then
		GAMEMODE.ChatRadio:SetCurrentChannel( nil )
		return
	end

	GAMEMODE.ChatRadio:SetCurrentChannel( net.ReadUInt(8) )
end )

-- ----------------------------------------------------------------
-- Weather Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "weather", 13 )

GM.Net:RegisterEventHandle( "weather", "b_str", function( intMsgLen, pPlayer )
	GAMEMODE.Weather:StartType( net.ReadString(), net.ReadUInt(32), net.ReadUInt(16) )
end )

GM.Net:RegisterEventHandle( "weather", "b_sto", function( intMsgLen, pPlayer )
	GAMEMODE.Weather:StopType( net.ReadString() )
end )

GM.Net:RegisterEventHandle( "weather", "fupd", function( intMsgLen, pPlayer )
	local num = net.ReadUInt( 8 )
	if num == 0 then return end
	
	for i = 1, num do
		GAMEMODE.Weather:StartType( net.ReadString(), net.ReadUInt(32), net.ReadUInt(16) )
	end
end )

GM.Net:RegisterEventHandle( "weather", "t", function( intMsgLen, pPlayer )
	GAMEMODE.DayNight:SetTime( net.ReadUInt(32) )
end )

GM.Net:RegisterEventHandle( "weather", "d", function( intMsgLen, pPlayer )
	GAMEMODE.DayNight:SetDay( net.ReadUInt(8) )
end )

GM.Net:RegisterEventHandle( "weather", "fupd_time", function( intMsgLen, pPlayer )
	GAMEMODE.DayNight:SetDay( net.ReadUInt(8) )
	GAMEMODE.DayNight:SetTime( net.ReadUInt(32) )
end )

-- ----------------------------------------------------------------
-- Economy Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "econ", 14 )

GM.Net:RegisterEventHandle( "econ", "fupd_t", function( intMsgLen, pPlayer )
	local numTaxes = net.ReadUInt( 8 )
	for i = 1, numTaxes do
		GAMEMODE.Econ:SetTaxRate( net.ReadString(), net.ReadFloat() )
	end
end )

GM.Net:RegisterEventHandle( "econ", "upd_t", function( intMsgLen, pPlayer )
	GAMEMODE.Econ:SetTaxRate( net.ReadString(), net.ReadFloat() )
end )

GM.Net:RegisterEventHandle( "econ", "upd_tb", function( intMsgLen, pPlayer )
	local numTaxes = net.ReadUInt( 8 )
	for i = 1, numTaxes do
		GAMEMODE.Econ:SetTaxRate( net.ReadString(), net.ReadFloat() )
	end
end )

GM.Net:RegisterEventHandle( "econ", "fupd_b", function( intMsgLen, pPlayer )
	local numBills = net.ReadUInt( 8 )
	if numBills <= 0 then
		g_GamemodeUnPaidBills = {}
		hook.Call( "GamemodeOnBillsUpdated", GAMEMODE, g_GamemodeUnPaidBills )
		return
	end
		
	local bills = {}
	for i = 1, numBills do
		bills[net.ReadUInt( 8 )] = {
			Type = net.ReadString(),
			Name = net.ReadString(),
			Cost = net.ReadUInt( 16 ),
			LifeTime = net.ReadUInt( 32 ),
			IssueTime = net.ReadUInt( 32 ),
			MetaData = net.ReadBool() and net.ReadTable() or {},
		}
	end

	g_GamemodeUnPaidBills = bills
	hook.Call( "GamemodeOnBillsUpdated", GAMEMODE, g_GamemodeUnPaidBills )
end )

function GM.Net:RequestPayBill( intBillIDX )
	self:NewEvent( "econ", "pay_b" )
		net.WriteUInt( intBillIDX, 8 )
	self:FireEvent()
end

function GM.Net:RequestBillUpdate()
	self:NewEvent( "econ", "rbupd" )
	self:FireEvent()
end

function GM.Net:RequestPayAllBills()
	self:NewEvent( "econ", "pay_a" )
	self:FireEvent()
end

