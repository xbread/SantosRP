--[[
	Name: sv_networking.lua
	
		
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

util.AddNetworkString "gm_netmsg"

function GM.Net:Initialize()
	net.Receive( "gm_netmsg", function( intMsgLen, pPlayer, ... )
		local id, name = net.ReadUInt( 8 ), net.ReadString()
		if not id or not name then return end
		if self.m_bVerbose then print( pPlayer, id, name ) end

		local event_data = GAMEMODE.Net:GetEventHandleByID( id, name )
		if not event_data then
			ServerLog( ("Invalid net message header sent by %s! Got protocol[%s]:id[%s]\n"):format(pPlayer:Nick(), id, name) )
			return
		end

		--lprof.PushScope()
		if event_data.meta then
			event_data.func( event_data.meta, intMsgLen, pPlayer, ... )
		else
			event_data.func( intMsgLen, pPlayer, ... )
		end
		--lprof.PopScope( "gm_netmsg:(".. pPlayer:Nick().. ")[".. id.. "][".. name.. "]" )
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
	self.m_strCurProtocol = strProtocol
	self.m_strCurName = strMsgName

	net.Start( "gm_netmsg" )
	net.WriteUInt( self:GetProtocolIDByName(strProtocol), 8 )
	net.WriteString( strMsgName )
end

function GM.Net:FireEvent( pPlayer )
	if self.m_bVerbose and type(pPlayer) ~= "table" then print( ("Sending outbound net message to %s"):format(pPlayer:Nick()) ) end
	if DBugR then
		DBugR.Profilers.Net:AddNetData( "GM.Net[".. self.m_strCurProtocol.. "][".. self.m_strCurName.. "]", net.BytesWritten() )
	end

	net.Send( pPlayer )
end

function GM.Net:BroadcastEvent()
	if DBugR then
		DBugR.Profilers.Net:AddNetData( "GM.Net[".. self.m_strCurProtocol.. "][".. self.m_strCurName.. "]", net.BytesWritten() )
	end
	net.Broadcast()
end


-- ----------------------------------------------------------------
-- Core Gamemode Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "game", 0 )
GM.Net:AddProtocol( "ent", 255 )

--Player is ready for initial game data
GM.Net:RegisterEventHandle( "game", "ready", function( intMsgLen, pPlayer )
	GAMEMODE.Player:PlayerReadyForData( pPlayer )
end )

--Update a client's in-game status
function GM.Net:SetPlayerInGame( pPlayer, bInGame )
	self:NewEvent( "game", "g" )
		net.WriteBit( bInGame )
	self:FireEvent( pPlayer )
end

function GM.Net:SendPlayerLoadingCharacter( pPlayer )
	self:NewEvent( "game", "load" )
	self:FireEvent( pPlayer )
end

--Send a game var update to a player
function GM.Net:UpdateGameVar( pPlayer, strKey )
	if not pPlayer:GetGamemodeData() then return end
	if not pPlayer:GetGamemodeData().GameVars[strKey] then return end
	
	local varData = self.m_tblVarLookup.Write[GAMEMODE.Player:GetGameVarType( pPlayer, strKey )]

	self:NewEvent( "game", "v" )
		net.WriteString( strKey )
		varData.func( pPlayer:GetGamemodeData().GameVars[strKey].Value, varData.size )
	self:FireEvent( pPlayer )
end

--Sends a shared game var update to everyone or just a single player
function GM.Net:UpdateSharedGameVar( pPlayer, strKey, pSendTo )
	if not pPlayer:GetGamemodeData() then return end
	if not pPlayer:GetGamemodeData().SharedGameVars[strKey] then return end

	local varData = self.m_tblVarLookup.Write[GAMEMODE.Player:GetSharedGameVarType( pPlayer, strKey )]
	self:NewEvent( "game", "vs" )
		net.WriteString( pPlayer:SteamID64() )
		net.WriteString( strKey )
		varData.func( pPlayer:GetGamemodeData().SharedGameVars[strKey].Value, varData.size )
	
	if IsValid( pSendTo ) then
		self:FireEvent( pSendTo )
	else
		self:BroadcastEvent()
	end
end

--Send a batch of game vars in a single message
function GM.Net:SendGameVarBatchedUpdate( pPlayer, tblVarsToSend )
	if not pPlayer:GetGamemodeData() then return end
	local varTable = pPlayer:GetGamemodeData().GameVars

	self:NewEvent( "game", "v_batch" )
		net.WriteUInt( table.Count(tblVarsToSend), 16 )

		local varData
		for key, data in pairs( varTable ) do
			if not tblVarsToSend[key] then continue end
			
			net.WriteString( key )
			varData = self.m_tblVarLookup.Write[data.Type]
			varData.func( data.Value, varData.size )
		end
	self:FireEvent( pPlayer )	
end

--Combine all game vars into a single message
function GM.Net:SendFullGameVarUpdate( pPlayer )
	if not pPlayer:GetGamemodeData() then return end
	local varTable = pPlayer:GetGamemodeData().GameVars

	--Only send stuff that is different from default!
	local send = {}
	for key, data in pairs( varTable ) do
		if data.Defualt == data.Value then continue end
		send[key] = true
	end

	self:NewEvent( "game", "v_full" )
		net.WriteUInt( table.Count(send), 16 )

		local varData
		for key, data in pairs( varTable ) do
			if not send[key] then continue end
			net.WriteString( key )
			varData = self.m_tblVarLookup.Write[data.Type]
			varData.func( data.Value, varData.size )
		end
	self:FireEvent( pPlayer )
end

--Combine all shared game vars into a single message
function GM.Net:SendFullSharedGameVarUpdate( pPlayer, pSendTo )
	if not pPlayer:GetGamemodeData() then return end
	local varTable = pPlayer:GetGamemodeData().SharedGameVars

	--Only send stuff that is different from default!
	local send = {}
	for key, data in pairs( varTable ) do
		if data.Defualt == data.Value then continue end
		send[key] = true
	end

	self:NewEvent( "game", "vs_full" )
		net.WriteString( pPlayer:SteamID64() )
		net.WriteUInt( table.Count(send), 16 )

		local varData
		for key, data in pairs( varTable ) do
			if not send[key] then continue end
			net.WriteString( key )
			varData = self.m_tblVarLookup.Write[data.Type]
			varData.func( data.Value, varData.size )			
		end
	if IsValid( pSendTo ) then
		self:FireEvent( pSendTo )
	else
		self:BroadcastEvent()
	end
end

--Send every single players shared game vars to a new player
--Split this up into delayed blocks to help with lag
function GM.Net:SendAllSharedGameVarUpdate( pPlayer )
	local blocks = { {} }
	local curBlock = 1
	local count = 0
	for k, v in pairs( player.GetAll() ) do
		if v == pPlayer then continue end
		if not blocks[curBlock] then blocks[curBlock] = {} end
		
		count = count +1
		table.insert( blocks[curBlock], v )

		if count >= 4 then
			count = 0
			curBlock = curBlock +1
		end
	end

	--Send a block of 4 updates every 0.1 seconds
	for i = 1, curBlock do
		timer.Simple( 1 *(i *0.1), function()
			if not IsValid( pPlayer ) then return end
			if not blocks[i] then return end
			
			for k, v in pairs( blocks[i] ) do
				if not IsValid( v ) then continue end
				self:SendFullSharedGameVarUpdate( v, pPlayer )
			end
		end )
	end
end

--Combine a large amount of entity owners into a single message
function GM.Net:SendEntityOwners( pPlayer, tblEnts )
	if not tblEnts then return end

	self:NewEvent( "game", "e_owners" )
		net.WriteUInt( #tblEnts, 16 )
		for i = 1, #tblEnts do
			net.WriteUInt( tblEnts[i]:EntIndex(), 16 )
			net.WriteEntity( tblEnts[i]:GetPlayerOwner() )
		end
	if IsValid( pPlayer ) then
		self:FireEvent( pPlayer )
	else
		self:BroadcastEvent()
	end
end

--Send a single entity owner to a client
function GM.Net:SendEntityOwner( pPlayer, eEnt )
	self:NewEvent( "game", "e_owner" )
		net.WriteUInt( eEnt:EntIndex(), 16 )
		net.WriteEntity( eEnt:GetPlayerOwner() )
	if IsValid( pPlayer ) then
		self:FireEvent( pPlayer )
	else
		self:BroadcastEvent()
	end
end

--Player is trying to run an npc dialog event
GM.Net:RegisterEventHandle( "game", "npcd", function( intMsgLen, pPlayer )
	local eventName, args = net.ReadString(), net.ReadTable()
	GAMEMODE.Dialog:FireDialogEvent( pPlayer, eventName, unpack(args) )
end )

--Opens an npc dialog
function GM.Net:ShowNPCDialog( pPlayer, strDialogID )
	self:NewEvent( "game", "npcd_s" )
		net.WriteString( strDialogID )
	self:FireEvent( pPlayer )
end

--Opens an nw menu
function GM.Net:ShowNWMenu( pPlayer, strMenuID )
	self:NewEvent( "game", "nw_menu" )
		net.WriteString( strMenuID )
	self:FireEvent( pPlayer )
end

--Send a hint to a player
function GM.Net:SendHint( pPlayer, strMsg, intIcon, intDuration )
	self:NewEvent( "game", "note" )
		net.WriteString( strMsg )
		net.WriteUInt( intIcon or 0, 4 )
		net.WriteUInt( intDuration or 10, 8 )
	self:FireEvent( pPlayer )
end

--Player wants to buy an item from an npc
GM.Net:RegisterEventHandle( "game", "npc_b", function( intMsgLen, pPlayer )
	GAMEMODE.NPC:PlayerBuyNPCItem( pPlayer, net.ReadString(), net.ReadString(), net.ReadUInt(8) )
end )

--Player wants to sell an item to an npc
GM.Net:RegisterEventHandle( "game", "npc_s", function( intMsgLen, pPlayer )
	GAMEMODE.NPC:PlayerSellNPCItem( pPlayer, net.ReadString(), net.ReadString(), net.ReadUInt(8) )
end )

--Send all character info to a player
function GM.Net:SendPlayerCharacters( pPlayer )
	self:NewEvent( "game", "char_f" )
		net.WriteUInt( table.Count(pPlayer:GetCharacters()), 4 )

		for k, v in pairs( pPlayer:GetCharacters() ) do
			net.WriteUInt( v.Id, 32 )
			net.WriteString( v.Name.First )
			net.WriteString( v.Name.Last )
			net.WriteString( util.IsValidModel(v.Model.Overload) and v.Model.Overload or v.Model.Base )
			net.WriteUInt( v.Skin or 0, 8 )
		end
	self:FireEvent( pPlayer )
end

--Request to select a character
GM.Net:RegisterEventHandle( "game", "char_s", function( intMsgLen, pPlayer )
	local charID = net.ReadUInt( 32 )
	local chars = GAMEMODE.Char:GetPlayerCharacters( pPlayer )
	if not chars or not chars[charID] then return end
	if GAMEMODE.Char:GetPlayerCharacter( pPlayer ) then return end
	
	GAMEMODE.Char:PlayerSelectCharacter( pPlayer, charID )
end )

--Request to submit a new character
GM.Net:RegisterEventHandle( "game", "char_n", function( intMsgLen, pPlayer )
	if not pPlayer:GetPlayerSQLID() then return end
	if pPlayer:HasValidCharacter() then return end
	if pPlayer.m_intLastCharSubmit and pPlayer.m_intLastCharSubmit > CurTime() then return end
	pPlayer.m_intLastCharSubmit = CurTime() +1.5
	
	local nameFirst, nameLast = net.ReadString(), net.ReadString()
	local model, sex, skin = net.ReadString(), net.ReadUInt( 4 ), net.ReadUInt( 8 )

	GAMEMODE.SQL:GetPlayerNumCharacters( pPlayer:GetPlayerSQLID(), function( strNumChars )
		if tonumber( strNumChars ) >= GAMEMODE.Config.MaxCharacters then
			return
		end

		GAMEMODE.Char:PlayerCreateCharacter( pPlayer, {
			Name = {
				First = nameFirst,
				Last = nameLast,
			},
			Model = model,
			Sex = sex,
			Skin = skin
		} )
	end )
end )

--Player made an error in character creation
function GM.Net:SendCharacterErrorMsg( pPlayer, strMsg )
	self:NewEvent( "game", "char_e" )
		net.WriteString( strMsg )
	self:FireEvent( pPlayer )
end

--Player wants to buy a custom license plate
GM.Net:RegisterEventHandle( "game", "buy_lp", function( intMsgLen, pPlayer )
	GAMEMODE.License:PlayerBuyPlate( pPlayer, net.ReadString() )
end )

--Player wants to submit a driving test
GM.Net:RegisterEventHandle( "game", "d_test", function( intMsgLen, pPlayer )
	GAMEMODE.License:PlayerSubmitDrivingTest( pPlayer, net.ReadTable() )
end )

--Player wants to deposit funds in their bank account
GM.Net:RegisterEventHandle( "game", "atm_dep", function( intMsgLen, pPlayer )
	local ent, amount = net.ReadEntity(), net.ReadUInt( 32 )
	if not IsValid( ent ) or ent:GetClass() ~= "ent_atm" then return end
	ent:PlayerMakeDeposit( pPlayer, amount )
end )

--Player wants to withdraw funds from their bank account
GM.Net:RegisterEventHandle( "game", "atm_wdr", function( intMsgLen, pPlayer )
	local ent, amount = net.ReadEntity(), net.ReadUInt( 32 )
	if not IsValid( ent ) or ent:GetClass() ~= "ent_atm" then return end
	ent:PlayerMakeWithdraw( pPlayer, amount )
end )

--Player wants to transfer funds from their bank account to another player's account
GM.Net:RegisterEventHandle( "game", "atm_tfr", function( intMsgLen, pPlayer )
	local ent, amount, phoneNum = net.ReadEntity(), net.ReadUInt( 32 ), net.ReadString()
	if not IsValid( ent ) or ent:GetClass() ~= "ent_atm" then return end
	ent:PlayerMakeTransfer( pPlayer, amount, phoneNum )
end )

--Update clientside fuel data for a car
function GM.Net:SendCarFuelUpdate( entCar, pPlayer )
	self:NewEvent( "game", "c_fuel" )
		net.WriteUInt( entCar:EntIndex(), 16 )
		net.WriteUInt( entCar:GetFuel(), 8 )
		net.WriteUInt( entCar:GetMaxFuel(), 8 )
	if pPlayer then
		self:FireEvent( pPlayer )
	else
		self:BroadcastEvent()
	end
end

--Player wants to drop money on the ground
GM.Net:RegisterEventHandle( "game", "d_money", function( intMsgLen, pPlayer )
	GAMEMODE.Inv:PlayerDropMoney( pPlayer, net.ReadUInt(32), net.ReadBit() == 1 )
end )

-- ----------------------------------------------------------------
-- Clothing Shop Netcode
-- ----------------------------------------------------------------
--Player wants to buy a new outfit
GM.Net:RegisterEventHandle( "game", "npcc_b", function( intMsgLen, pPlayer )
	local model, skinIdx = net.ReadString(), net.ReadUInt( 8 )
	if pPlayer:GetSkin() == skinIdx and pPlayer:GetModel() == model then return end
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "clothing_clerk" then return end
	if not GAMEMODE.Util:ValidPlayerSkin( model, skinIdx ) then return end

	local baseModel = GAMEMODE.Player:GetGameVar( pPlayer, "char_model_base", "" )
	if model ~= baseModel then
		local valid = false
		for k, v in pairs( GAMEMODE.Config.PlayerModelOverloads[GAMEMODE.Player:GetSharedGameVar(pPlayer, "char_sex", 0) == 0 and "Male" or "Female"] or {} ) do
			if baseModel:find( k ) then
				for _, mdl in pairs( v ) do
					if mdl == model then valid = true break end
				end

				break
			end
		end

		if not valid then return end
	end

	local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", GAMEMODE.Config.ClothingPrice )
	if not pPlayer:CanAfford( price ) then pPlayer:AddNote( "You can't afford new clothes." ) return end
	pPlayer:TakeMoney( price )
	pPlayer:SetModel( model )
	pPlayer:SetSkin( skinIdx )
	pPlayer:AddNote( "You purchased new clothes for $".. price.. "!" )
	
	GAMEMODE.Char:GetPlayerCharacter( pPlayer ).Skin = skinIdx
	GAMEMODE.Player:SetGameVar( pPlayer, "char_skin", skinIdx )
--	GAMEMODE.SQL:UpdateCharacterSkin( pPlayer:GetCharacterID(), skinIdx )
	GAMEMODE.SQL:MarkDiffDirty( pPlayer, "skin" )

	local lastOverload = GAMEMODE.Char:GetPlayerCharacter( pPlayer ).Model.Overload
	if model ~= baseModel then
		if model ~= lastOverload then
			GAMEMODE.Char:GetPlayerCharacter( pPlayer ).Model.Overload = model
			GAMEMODE.SQL:MarkDiffDirty( pPlayer, "model_overload" )
		end
		
		GAMEMODE.Player:SetGameVar( pPlayer, "char_model_overload", model )
		--GAMEMODE.SQL:UpdateCharacterModelOverload( pPlayer:GetCharacterID(), model )
	else
		if GAMEMODE.Char:GetPlayerCharacter( pPlayer ).Model.Overload then
			GAMEMODE.Char:GetPlayerCharacter( pPlayer ).Model.Overload = nil
			GAMEMODE.SQL:MarkDiffDirty( pPlayer, "model_overload" )
		end

		GAMEMODE.Player:SetGameVar( pPlayer, "char_model_overload", "" )
		--GAMEMODE.SQL:UpdateCharacterModelOverload( pPlayer:GetCharacterID(), "" )
	end
end )

--Player wants to buy an item from the clothing accessories menu
GM.Net:RegisterEventHandle( "game", "buy_c_item", function( intMsgLen, pPlayer )
	local itemID = net.ReadString()
	local item = GAMEMODE.Inv:GetItem( itemID )
	if not item or not item.ClothingMenuPrice then return end
	
	if not IsValid( pPlayer.m_entLastMenuTrigger ) or pPlayer:GetPos():Distance( pPlayer.m_entLastMenuTrigger:GetPos() ) > 200 then return end
	local price = GAMEMODE.Econ:ApplyTaxToSum( "sales", item.ClothingMenuPrice )
	if pPlayer:CanAfford( price ) then
		if GAMEMODE.Inv:GivePlayerItem( pPlayer, itemID, 1 ) then
			pPlayer:TakeMoney( price )
			pPlayer:AddNote( "You purchased 1 ".. item.Name )
		else
			pPlayer:AddNote( "There is not enough space in your inventory for that!" )
		end
	else
		pPlayer:AddNote( "You can't afford that!" )
	end
end )

-- ----------------------------------------------------------------
-- Inventory Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "inv", 1 )

function GM.Net:SendFullInventoryUpdate( pPlayer )
	local data = pPlayer:GetInventory()

	self:NewEvent( "inv", "f" )
		net.WriteUInt( table.Count(data), 16 )

		for itemName, amount in pairs( data ) do
			net.WriteString( itemName )
			net.WriteUInt( amount, 16 )
		end
	self:FireEvent( pPlayer )
end

function GM.Net:SendInventoryUpdate( pPlayer, strItem, intAmount )
	self:NewEvent( "inv", "s" )
		net.WriteString( strItem )
		net.WriteUInt( intAmount, 16 )
	self:FireEvent( pPlayer )
end

--Player wants to drop an item
GM.Net:RegisterEventHandle( "inv", "d", function( intMsgLen, pPlayer )
	local itemID, itemAmount = net.ReadString(), net.ReadUInt( 8 )
	GAMEMODE.Inv:PlayerDropItem( pPlayer, itemID, itemAmount, net.ReadBit() == 1 )
end )

--Player wants to use an item
GM.Net:RegisterEventHandle( "inv", "u", function( intMsgLen, pPlayer )
	GAMEMODE.Inv:PlayerUseItem( pPlayer, net.ReadString() )
end )

--Player wants to equip an item
GM.Net:RegisterEventHandle( "inv", "e", function( intMsgLen, pPlayer )
	local itemSlot = net.ReadString()
	local itemID = net.ReadString()
	if itemID == "nil" then itemID = nil end
	
	GAMEMODE.Inv:PlayerEquipItem( pPlayer, itemSlot, itemID )
end )

--Player wants to craft an item
GM.Net:RegisterEventHandle( "inv", "craft", function( intMsgLen, pPlayer )
	GAMEMODE.Inv:PlayerCraftItem( pPlayer, net.ReadString() )
end )

--Player wants to abort crafting something
GM.Net:RegisterEventHandle( "inv", "c_abort", function( intMsgLen, pPlayer )
	GAMEMODE.Inv:PlayerAbortCraft( pPlayer )
end )

--Tell a player they've started crafting something
function GM.Net:SendPlayerCraftData( pPlayer, strItemID, intStartTime )
	self:NewEvent( "inv", "c_start" )
		net.WriteString( strItemID )
		net.WriteFloat( intStartTime )
	self:FireEvent( pPlayer )
end

--Tell a player they've finished crafting something
function GM.Net:SendPlayerCraftEnd( pPlayer, strItemID )
	self:NewEvent( "inv", "c_end" )
		net.WriteString( strItemID )
	self:FireEvent( pPlayer )
end

-- ----------------------------------------------------------------
-- Trunk Netcode
-- ----------------------------------------------------------------
--Player wants to move an item from inventory to the trunk
GM.Net:RegisterEventHandle( "inv", "trunk_d", function( intMsgLen, pPlayer )
	GAMEMODE.TrunkStorage:AddToTrunk( pPlayer, net.ReadUInt(32), net.ReadString(), net.ReadUInt(8) )
end )

--Player wants to move an item from the trunk to inventory
GM.Net:RegisterEventHandle( "inv", "trunk_w", function( intMsgLen, pPlayer )
	GAMEMODE.TrunkStorage:RemoveFromTrunk( pPlayer, net.ReadUInt(32), net.ReadString(), net.ReadUInt(8) )
end )

--Send player an update about items in the trunk
function GM.Net:SendTrunkItemUpdate( intCarIndex, tblItems )
	self:NewEvent( "inv", "trunk_upd" )
		net.WriteUInt( intCarIndex, 32 )
		net.WriteTable( tblItems )
	self:BroadcastEvent()
end

-- ----------------------------------------------------------------
-- Bank Item Storage Netcode
-- ----------------------------------------------------------------
--Player wants to move an item from inventory to the bank
GM.Net:RegisterEventHandle( "inv", "npcb_d", function( intMsgLen, pPlayer )
	GAMEMODE.BankStorage:AddToBank( pPlayer, net.ReadString(), net.ReadUInt(8) )
end )

--Player wants to move an item from the bank to inventory
GM.Net:RegisterEventHandle( "inv", "npcb_w", function( intMsgLen, pPlayer )
	GAMEMODE.BankStorage:RemoveFromBank( pPlayer, net.ReadString(), net.ReadUInt(8) )
end )

--Send player an update about items in the bank
function GM.Net:SendPlayerBankItemUpdate( pPlayer, tblItems )
	self:NewEvent( "inv", "npcb_upd" )
		net.WriteTable( tblItems )
	self:FireEvent( pPlayer )
end

-- ----------------------------------------------------------------
-- Bank Lost And Found Storage Netcode
-- ----------------------------------------------------------------
--Player wants to move an item from the lost and found to their inventory
GM.Net:RegisterEventHandle( "inv", "npcb_lw", function( intMsgLen, pPlayer )
	GAMEMODE.BankStorage:RemoveFromLostAndFound( pPlayer, net.ReadString(), net.ReadUInt(8) )
end )

GM.Net:RegisterEventHandle( "inv", "npcb_ld", function( intMsgLen, pPlayer )
	GAMEMODE.BankStorage:DestroyLostAndFoundItem( pPlayer, net.ReadString(), net.ReadUInt(8) )
end )

--Send player an update about items in the bank
function GM.Net:SendLostAndFoundUpdate( pPlayer, tblItems )
	self:NewEvent( "inv", "npcb_lupd" )
		net.WriteTable( tblItems )
	self:FireEvent( pPlayer )
end

-- ----------------------------------------------------------------
-- Vehicle Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "veh", 2 )

--Player wants to buy a car
GM.Net:RegisterEventHandle( "veh", "b", function( intMsgLen, pPlayer )
	local carID = net.ReadString()
	local carColor = net.ReadUInt( 8 )

	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "car_dealer" then return end
	GAMEMODE.Cars:PlayerBuyCar( pPlayer, carID, carColor )
end )

--Player wants to sell a car
GM.Net:RegisterEventHandle( "veh", "s", function( intMsgLen, pPlayer )
	local carID = net.ReadString()

	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "car_dealer" then return end
	GAMEMODE.Cars:PlayerSellCar( pPlayer, carID )
end )

--Player wants to spawn a car
GM.Net:RegisterEventHandle( "veh", "sp", function( intMsgLen, pPlayer )
	local carID = net.ReadString()

	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "car_spawn" then return end
	GAMEMODE.Cars:PlayerSpawnCar( pPlayer, carID )
end )

--Player wants to stow a car
GM.Net:RegisterEventHandle( "veh", "st", function( intMsgLen, pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "car_spawn" then return end
	GAMEMODE.Cars:PlayerStowCar( pPlayer )
end )

-- ----------------------------------------------------------------
-- Jail Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "jail", 3 )

--Player wants to send a player to jail
GM.Net:RegisterEventHandle( "jail", "t", function( intMsgLen, pPlayer )
	GAMEMODE.Jail:PlayerSendPlayerToJail( pPlayer, net.ReadEntity(), net.ReadUInt(32), net.ReadString() )
end )

--Player wants to free a player from jail
GM.Net:RegisterEventHandle( "jail", "f", function( intMsgLen, pPlayer )
	GAMEMODE.Jail:PlayerReleasePlayerFromJail( pPlayer, net.ReadEntity(), net.ReadString() )
end )

--Player wants to bail a player out of jail
GM.Net:RegisterEventHandle( "jail", "b", function( intMsgLen, pPlayer )
	GAMEMODE.Jail:BailPlayerFromJail( pPlayer, net.ReadEntity() )
end )

--Player wants to warrent another player
GM.Net:RegisterEventHandle( "jail", "w", function( intMsgLen, pPlayer )
	GAMEMODE.Jail:PlayerWarrantPlayer( pPlayer, net.ReadEntity(), net.ReadString() )
end )

--Player wants to revoke another player's warrent
GM.Net:RegisterEventHandle( "jail", "wr", function( intMsgLen, pPlayer )
	GAMEMODE.Jail:PlayerRemovePlayerWarrant( pPlayer, net.ReadEntity() )
end )

-- ----------------------------------------------------------------
-- Cop Computer Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "cop_computer", 4 )

--Send a player another player's rap sheet
function GM.Net:SendPlayerRapSheet( pPlayer, pTarget )
	if not IsValid( pTarget ) then return end

	local sendTbl = {
		JailData = GAMEMODE.Jail:GetCopComputerData( pTarget ), --Arrest record, warrant
		LicenseData = GAMEMODE.License:GetCopComputerData( pTarget ), --License dots, plate number, tickets
	}
	local data = util.Compress( util.TableToJSON(sendTbl) )

	self:NewEvent( "cop_computer", "s" )
		net.WriteEntity( pTarget )
		net.WriteUInt( #data, 32 )
		net.WriteData( data, #data ) --serialize and compress cause too lazy to split the message atm
	self:FireEvent( pPlayer )
end

--Player wants to get another player's rap sheet
GM.Net:RegisterEventHandle( "cop_computer", "r", function( intMsgLen, pPlayer )
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) then return end
	if pPlayer.m_intLastRapSheetRequest then
		if pPlayer.m_intLastRapSheetRequest > CurTime() then return end
	end

	pPlayer.m_intLastRapSheetRequest = CurTime() +1
	GAMEMODE.Net:SendPlayerRapSheet( pPlayer, net.ReadEntity() )
end )

--Player wants to revoke another players drivers license
GM.Net:RegisterEventHandle( "cop_computer", "rl", function( intMsgLen, pPlayer )
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) then return end
	GAMEMODE.License:PlayerRevokePlayerLicense( pPlayer, net.ReadEntity(), net.ReadUInt(16) )
end )

--Player wants to place a dot on another players drivers license
GM.Net:RegisterEventHandle( "cop_computer", "d", function( intMsgLen, pPlayer )
	if not GAMEMODE.Jobs:PlayerIsJob( pPlayer, JOB_POLICE ) then return end
	GAMEMODE.License:PlayerDotLicense( pPlayer, net.ReadEntity(), net.ReadString() )
end )

-- ----------------------------------------------------------------
-- Ticket Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "ticket", 5 )

--Player wants to ticket another player
GM.Net:RegisterEventHandle( "ticket", "gp", function( intMsgLen, pPlayer )
	GAMEMODE.License:PlayerTicketPlayer( pPlayer, net.ReadEntity(), net.ReadString(), net.ReadUInt(16) )
end )

--Players wants to leave a ticket on a car for the owner
GM.Net:RegisterEventHandle( "ticket", "ge", function( intMsgLen, pPlayer )
	GAMEMODE.License:PlayerTicketPlayerCar( pPlayer, net.ReadEntity(), net.ReadString(), net.ReadUInt(16) )
end )

--Player wants to pay off a ticket
GM.Net:RegisterEventHandle( "ticket", "p", function( intMsgLen, pPlayer )
	if GAMEMODE.License:PlayerPayTicket( pPlayer, net.ReadUInt(8) ) then
		GAMEMODE.Net:SendTicketList( pPlayer )
	end
end )

--Player wants to get a list of their unpaid tickets
GM.Net:RegisterEventHandle( "ticket", "rup", function( intMsgLen, pPlayer )
	GAMEMODE.Net:SendTicketList( pPlayer )
end )

--Send them a list of unpaid tickets
function GM.Net:SendTicketList( pPlayer )
	self:NewEvent( "ticket", "gt" )
		net.WriteTable( GAMEMODE.License:GetPlayerUnpiadTickets(pPlayer) )
	self:FireEvent( pPlayer )
end

-- ----------------------------------------------------------------
-- Phone Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "phone", 6 )

--Player dialed a number
GM.Net:RegisterEventHandle( "phone", "dial", function( intMsgLen, pPlayer )
	GAMEMODE.Phone:PlayerCallNumber( pPlayer, net.ReadString() )
end )

GM.Net:RegisterEventHandle( "phone", "h_up", function( intMsgLen, pPlayer )
	GAMEMODE.Phone:PlayerDenyCall( pPlayer )
end )

GM.Net:RegisterEventHandle( "phone", "accept", function( intMsgLen, pPlayer )
	GAMEMODE.Phone:PlayerAnswerCall( pPlayer )
end )

function GM.Net:SendOutgoingCall( pPlayer, pCalling )
	self:NewEvent( "phone", "out" )
		net.WriteString( GAMEMODE.Player:GetGameVar(pCalling, "phone_number") )
	self:FireEvent( pPlayer )
end

function GM.Net:SendIncomingCall( pPlayer, pCaller )
	self:NewEvent( "phone", "inc" )
		net.WriteString( GAMEMODE.Player:GetGameVar(pCaller, "phone_number") )
	self:FireEvent( pPlayer )
end

--Our call has started
function GM.Net:SendCallStart( pPlayer )
	self:NewEvent( "phone", "start" )
		net.WriteString( GAMEMODE.Player:GetGameVar(pPlayer.m_pCallingPlayer or pPlayer, "phone_number") )
	self:FireEvent( pPlayer )
end

function GM.Net:SendCallEnd( pPlayer )
	self:NewEvent( "phone", "end" )
	self:FireEvent( pPlayer )
end

function GM.Net:SendDialFailed( pPlayer )
	self:NewEvent( "phone", "err" )
	self:FireEvent( pPlayer )
end

function GM.Net:SendBusySignal( pPlayer )
	self:NewEvent( "phone", "busy" )
	self:FireEvent( pPlayer )
end

--Player is sending a text message to someone
GM.Net:RegisterEventHandle( "phone", "s_txt", function( intMsgLen, pPlayer )
	local sendToNum, textData = net.ReadString(), net.ReadString()
	GAMEMODE.Phone:PlayerSendTextMessage( pPlayer, textData, sendToNum )
end )

--Send a text message from someone to a player
function GM.Net:SendTextMessage( pPlayer, strSenderNumber, strMessage )
	self:NewEvent( "phone", "r_txt" )
		net.WriteString( strSenderNumber )
		net.WriteString( strMessage )
	self:FireEvent( pPlayer )
end

--GETTING IMAGES
-- -------------

--Player wants to send an image to someone
GM.Net:RegisterEventHandle( "phone", "s_jpg_header", function( intMsgLen, pPlayer )
	GAMEMODE.Phone:PlayerSendPlayerImage( pPlayer, net.ReadString(), net.ReadUInt(8) )
end )

--Player sent the next part of an image
GM.Net:RegisterEventHandle( "phone", "s_jpg_next_part", function( intMsgLen, pPlayer )
	local size = net.ReadUInt( 32 )
	local strPartData = net.ReadData( size )
	GAMEMODE.Phone:PlayerSendImagePart( pPlayer, strPartData )
end )

--Ask a player for the next part of an image they are sending
function GM.Net:RequestNextImagePart( pPlayer )
	self:NewEvent( "phone", "s_jpg_next_part" )
	self:FireEvent( pPlayer )
end

--Tell a player the server has got all the image parts
function GM.Net:SendImagePartsDone( pPlayer )
	self:NewEvent( "phone", "s_jpg_done" )
	self:FireEvent( pPlayer )
end

--SENDING IMAGES
-- -------------

--Send image data to a player
function GM.Net:SendImageDataToPlayer( pPlayer, strSenderNumber, strImageData )
	if pPlayer.m_bGettingImage then return end

	pPlayer.m_bGettingImage = true
	pPlayer.m_strGettingData = strImageData
	pPlayer.m_intNumGettingImageParts = math.ceil( #strImageData /65536 )
	pPlayer.m_intCurGettingImagePart = 0

	self:NewEvent( "phone", "r_jpg_header" )
		net.WriteString( strSenderNumber )
		net.WriteUInt( pPlayer.m_intNumGettingImageParts, 8 )
	self:FireEvent( pPlayer )
end

--Player wants the next part of the image data
GM.Net:RegisterEventHandle( "phone", "r_jpg_next_part", function( intMsgLen, pPlayer )
	GAMEMODE.Net:SendImagePart( pPlayer )
end )

--Send the next part of an image to a player
function GM.Net:SendImagePart( pPlayer )
	if not pPlayer.m_bGettingImage then return end
	pPlayer.m_intCurGettingImagePart = pPlayer.m_intCurGettingImagePart +1

	local partData = pPlayer.m_strGettingData:sub(
		(pPlayer.m_intCurGettingImagePart -1) *65536,
		pPlayer.m_intCurGettingImagePart *65536
	)

	self:NewEvent( "phone", "r_jpg_next_part" )
		net.WriteUInt( #partData, 32 )
		net.WriteData( partData, #partData )
	self:FireEvent( pPlayer )

	if pPlayer.m_intCurGettingImagePart >= pPlayer.m_intNumGettingImageParts then
		pPlayer.m_bGettingImage = false
	end
end

-- ----------------------------------------------------------------
-- Drugs Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "drugs", 7 )

function GM.Net:SendPlayerDrugEffect( pPlayer, strEffectName, intIDX, intTime, intDuration, intPower )
	self:NewEvent( "drugs", "n" )
		net.WriteString( strEffectName )
		net.WriteUInt( intIDX, 16 )
		net.WriteDouble( intTime )
		net.WriteDouble( intDuration )
		net.WriteDouble( intPower )
	self:FireEvent( pPlayer )
end

function GM.Net:RemovePlayerDrugEffect( pPlayer, strEffectName, intIDX )
	self:NewEvent( "drugs", "r" )
		net.WriteString( strEffectName )
		net.WriteUInt( intIDX, 16 )
	self:FireEvent( pPlayer )
end

function GM.Net:ClearPlayerDrugEffects( pPlayer )
	self:NewEvent( "drugs", "c" )
	self:FireEvent( pPlayer )
end

-- ----------------------------------------------------------------
-- Buddy Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "buddy", 8 )

function GM.Net:SendFullBuddyUpdate( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable then return end

	local t = saveTable.Buddies or {}
	self:NewEvent( "buddy", "f_upd" )
		net.WriteUInt( table.Count(t), 16 )
		for k, v in pairs( t ) do
			net.WriteUInt( k, 32 )
			net.WriteTable( v )
		end
	self:FireEvent( pPlayer )
end

function GM.Net:SendBuddyUpdate( pPlayer, intBuddyID )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Buddies then return end
	self:NewEvent( "buddy", "upd" )
		net.WriteUInt( intBuddyID, 32 )
		net.WriteBit( saveTable.Buddies[intBuddyID] and true )

		if saveTable.Buddies[intBuddyID] then
			net.WriteTable( saveTable.Buddies[intBuddyID] )
		end
	self:FireEvent( pPlayer )
end

GM.Net:RegisterEventHandle( "buddy", "edit_key", function( intMsgLen, pPlayer )
	GAMEMODE.Buddy:PlayerUpdateBuddyKey( pPlayer, net.ReadUInt( 32 ), net.ReadString(), net.ReadBit() == 1 )
end )

GM.Net:RegisterEventHandle( "buddy", "add", function( intMsgLen, pPlayer )
	GAMEMODE.Buddy:PlayerAddBuddy( pPlayer, net.ReadUInt( 32 ) )
end )

GM.Net:RegisterEventHandle( "buddy", "del", function( intMsgLen, pPlayer )
	GAMEMODE.Buddy:PlayerRemoveBuddy( pPlayer, net.ReadUInt( 32 ) )
end )

-- ----------------------------------------------------------------
-- Property Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "property", 9 )

function GM.Net:WriteProperty( tblData )
	net.WriteString( tblData.Name )
	net.WriteEntity( tblData.Owner )
	net.WriteUInt( tblData.ID, 16 )

	--Write door data
	local count = table.Count( tblData.Doors )
	net.WriteUInt( count, 8 )
	for k, v in pairs( tblData.Doors ) do
		net.WriteUInt( k, 32 )
	end
end

function GM.Net:NetworkProperty( strName, pPlayer )
	local data = GAMEMODE.Property:GetPropertyByName( strName )
	if not data then return end
	
	self:NewEvent( "property", "upd" )
		self:WriteProperty( data )
	if IsValid( pPlayer ) then
		self:FireEvent( pPlayer )
	else
		self:BroadcastEvent()
	end
end

function GM.Net:SendFullPropertyUpdate( pPlayer )
	self:NewEvent( "property", "fupd" )
		net.WriteUInt( table.Count(GAMEMODE.Property.m_tblProperties), 16 )

		for name, data in pairs( GAMEMODE.Property.m_tblProperties ) do
			self:WriteProperty( data )
		end
	self:FireEvent( pPlayer )
end

--[[function GM.Net:NetworkOpenDoorMenu( pPlayer, entDoor )
	self:NewEvent( "property", "dmn" )
		net.WriteUInt( self.NET_OPEN_DOOR_MENU, 8 )
		net.WriteEntity( entDoor )
		net.WriteTable( entDoor.m_tblPropertyData.Friends )
	self:FireEvent( pPlayer )
end]]--

GM.Net:RegisterEventHandle( "property", "b", function( intMsgLen, pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "property_buy" then return end
	if pPlayer:IsIncapacitated() then return end
	GAMEMODE.Property:PlayerBuyProperty( net.ReadString(), pPlayer )
end )

GM.Net:RegisterEventHandle( "property", "s", function( intMsgLen, pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "property_buy" then return end
	if pPlayer:IsIncapacitated() then return end
	GAMEMODE.Property:PlayerSellProperty( net.ReadString(), pPlayer )
end )

--[[GM.Net:RegisterEventHandle( "property", "t", function( intMsgLen, pPlayer )
	local ent = pPlayer:GetEyeTrace().Entity
	if not IsValid( ent ) then return end
	if pPlayer:IsIncapacitated() then return end
	
	local data = GAMEMODE.Property:GetPropertyByDoor( ent )
	if not data then return end
	if data.Owner ~= pPlayer then return end
	
	if not IsValid( data.Doors[ent:EntIndex()] ) then return end
	local str = net.ReadString()
	if str:len() > 50 then
		pPlayer:AddNote( "This title is too long!" )
		return
	end

	GAMEMODE.Property:SetDoorTitle( ent, str )
end )]]--

-- ----------------------------------------------------------------
-- Car Radios Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "cradio", 10 )

function GM.Net:NetworkCarRadioPlay( entVeh, intStationID, bIsCustom )
	if bIsCustom then
		self:NetworkCarRadioPlayCustom( entVeh, intStationID )
		return
	end
	
	self:NewEvent( "cradio", "p" )
		net.WriteEntity( entVeh )
		net.WriteUInt( intStationID, 32 )
	self:BroadcastEvent()
end

function GM.Net:NetworkCarRadioPlayCustom( entVeh, intStationID )
	self:NewEvent( "cradio", "pc" )
		net.WriteEntity( entVeh )
		net.WriteUInt( intStationID, 32 )
	self:BroadcastEvent()
end

function GM.Net:NetworkCarRadioStop( entVeh )
	self:NewEvent( "cradio", "s" )
		net.WriteEntity( entVeh )
	self:BroadcastEvent()
end

function GM.Net:SendFullCarRadioUpdate( pPlayer )
	local foundCars = {}
	for k, v in pairs( ents.FindByClass("prop_vehicle_jeep") ) do
		if not v.m_intCurrentRadioStation then continue end
		foundCars[#foundCars +1] = v
	end

	self:NewEvent( "cradio", "fupd" )
		net.WriteUInt( #foundCars, 16 )

		for k, v in pairs( foundCars ) do
			net.WriteEntity( v )
			net.WriteUInt( v.m_intCurrentRadioStation, 32 )
		end
	self:FireEvent( pPlayer )
end

GM.Net:RegisterEventHandle( "cradio", "rp", function( intMsgLen, pPlayer )
	local veh = pPlayer:GetVehicle()
	if not IsValid( veh ) or veh:GetDriver() ~= pPlayer then return end
	if veh:GetClass() ~= "prop_vehicle_jeep" then return end

	GAMEMODE.CarRadio:PlayStation( veh, net.ReadUInt(32) )
end )

GM.Net:RegisterEventHandle( "cradio", "rpc", function( intMsgLen, pPlayer )
	if not pPlayer:CheckGroup( "vip" ) then return end

	local veh = pPlayer:GetVehicle()
	if not IsValid( veh ) or veh:GetDriver() ~= pPlayer then return end
	if veh:GetClass() ~= "prop_vehicle_jeep" then return end

	GAMEMODE.CarRadio:PlayStation( veh, net.ReadUInt(32), true )
end )

GM.Net:RegisterEventHandle( "cradio", "rs", function( intMsgLen, pPlayer )
	local veh = pPlayer:GetVehicle()
	if not IsValid( veh ) or veh:GetDriver() ~= pPlayer then return end
	if veh:GetClass() ~= "prop_vehicle_jeep" then return end

	GAMEMODE.CarRadio:StopStation( veh )
end )

-- ----------------------------------------------------------------
-- Item Radios Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "iradio", 11 )

function GM.Net:NetworkPropRadioPlay( entRadio, intStationID, bIsCustom )
	if bIsCustom then
		self:NetworkPropRadioPlayCustom( entRadio, intStationID )
		return
	end
	
	self:NewEvent( "iradio", "p" )
		net.WriteEntity( entRadio )
		net.WriteUInt( intStationID, 32 )
	self:BroadcastEvent()
end

function GM.Net:NetworkPropRadioPlayCustom( entRadio, intStationID )
	self:NewEvent( "iradio", "pc" )
		net.WriteEntity( entRadio )
		net.WriteUInt( intStationID, 32 )
	self:BroadcastEvent()
end

function GM.Net:NetworkPropRadioStop( entRadio )
	self:NewEvent( "iradio", "s" )
		net.WriteEntity( entRadio )
	self:BroadcastEvent()
end

function GM.Net:SendFullPropRadioUpdate( pPlayer )
	local foundRadios = {}
	for k, v in pairs( ents.FindByClass("ent_itemradio") ) do
		if not v.m_intCurrentRadioStation then continue end
		foundRadios[#foundRadios +1] = v
	end

	self:NewEvent( "iradio", "fupd" )
		net.WriteUInt( #foundRadios, 16 )

		for k, v in pairs( foundRadios ) do
			net.WriteEntity( v )
			net.WriteUInt( v.m_intCurrentRadioStation, 32 )
		end
	self:FireEvent( pPlayer )
end

function GM.Net:NetworkOpenRadioMenu( pPlayer )
	self:NewEvent( "iradio", "m" )
		net.WriteEntity( entRadio )
	self:FireEvent( pPlayer )
end

GM.Net:RegisterEventHandle( "iradio", "rp", function( intMsgLen, pPlayer )
	local ent = net.ReadEntity()
	if not IsValid( ent ) or ent:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end
	if ent:GetClass() ~= "ent_itemradio" then return end

	GAMEMODE.PropRadio:PlayStation( ent, net.ReadUInt(32) )
end )

GM.Net:RegisterEventHandle( "iradio", "rpc", function( intMsgLen, pPlayer )
	if not pPlayer:CheckGroup( "vip" ) then return end

	local ent = net.ReadEntity()
	if not IsValid( ent ) or ent:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end
	if ent:GetClass() ~= "ent_itemradio" then return end

	GAMEMODE.PropRadio:PlayStation( ent, net.ReadUInt(32), true )
end )

GM.Net:RegisterEventHandle( "iradio", "rs", function( intMsgLen, pPlayer )
	local ent = net.ReadEntity()
	if not IsValid( ent ) or ent:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end
	if ent:GetClass() ~= "ent_itemradio" then return end

	GAMEMODE.PropRadio:StopStation( ent )
end )

-- ----------------------------------------------------------------
-- Chat Radios Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "chat_radio", 12 )

GM.Net:RegisterEventHandle( "chat_radio", "rs", function( intMsgLen, pPlayer )
	GAMEMODE.ChatRadio:PlayerSetChannel( pPlayer, net.ReadUInt(8) )
end )

GM.Net:RegisterEventHandle( "chat_radio", "rm", function( intMsgLen, pPlayer )
	GAMEMODE.ChatRadio:PlayerMuteRadio( pPlayer, net.ReadBit() == 1 )
end )

function GM.Net:SendPlayerChatRadioChannel( pPlayer, intChan )
	self:NewEvent( "chat_radio", "c" )
		net.WriteBit( intChan ~= nil )
		if intChan ~= nil then
			net.WriteUInt( intChan, 8 )
		end
	self:FireEvent( pPlayer )
end

-- ----------------------------------------------------------------
-- Weather Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "weather", 13 )

function GM.Net:BroadcastWeatherStart( strTypeID )
	self:NewEvent( "weather", "b_str" )
		net.WriteString( strTypeID )
		net.WriteUInt( GAMEMODE.Weather:GetActiveTypeData(strTypeID).Start, 32 )
		net.WriteUInt( GAMEMODE.Weather:GetActiveTypeData(strTypeID).RunTime, 16 )
	self:BroadcastEvent()
end

function GM.Net:BroadcastWeatherStop( strTypeID )
	self:NewEvent( "weather", "b_sto" )
		net.WriteString( strTypeID )
	self:BroadcastEvent()
end

function GM.Net:SendClientWeatherUpdate( pPlayer )
	self:NewEvent( "weather", "fupd" )
		net.WriteUInt( table.Count(GAMEMODE.Weather.m_tblActiveTypes), 8 )
		for k, v in pairs( GAMEMODE.Weather.m_tblActiveTypes ) do
			net.WriteString( k )
			net.WriteUInt( v.Start, 32 )
			net.WriteUInt( v.RunTime, 16 )			
		end
	self:FireEvent( pPlayer )
end

function GM.Net:BroadcastTimeUpdate()
	self:NewEvent( "weather", "t" )
		net.WriteUInt( GAMEMODE.DayNight:GetTime(), 32 )
	self:BroadcastEvent()
end

function GM.Net:BroadcastDayUpdate()
	self:NewEvent( "weather", "d" )
		net.WriteUInt( GAMEMODE.DayNight:GetDay(), 8 )
	self:BroadcastEvent()
end

function GM.Net:SendTimeFullUpdate( pPlayer )
	self:NewEvent( "weather", "fupd_time" )
		net.WriteUInt( GAMEMODE.DayNight:GetDay(), 8 )
		net.WriteUInt( GAMEMODE.DayNight:GetTime(), 32 )
	self:FireEvent( pPlayer )
end

-- ----------------------------------------------------------------
-- Economy Netcode
-- ----------------------------------------------------------------
GM.Net:AddProtocol( "econ", 14 )

function GM.Net:SendTaxFullUpdate( pPlayer )
	self:NewEvent( "econ", "fupd_t" )
		net.WriteUInt( table.Count(GAMEMODE.Econ:GetTaxes()), 8 )
		for k, v in pairs( GAMEMODE.Econ:GetTaxes() ) do
			net.WriteString( k )
			net.WriteFloat( v.Value )
		end
	if pPlayer then
		self:FireEvent( pPlayer )
	else
		self:BroadcastEvent()
	end
end

function GM.Net:SendTaxUpdate( pPlayer, strTaxID )
	self:NewEvent( "econ", "upd_t" )
		net.WriteString( strTaxID )
		net.WriteFloat( GAMEMODE.Econ:GetTaxData(strTaxID).Value )
	if pPlayer then
		self:FireEvent( pPlayer )
	else
		self:BroadcastEvent()
	end
end

function GM.Net:SendTaxUpdateBatch( pPlayer, tblIDs )
	self:NewEvent( "econ", "upd_tb" )
		net.WriteUInt( table.Count(tblIDs), 8 )

		for k, v in pairs( tblIDs ) do
			net.WriteString( k )
			net.WriteFloat( GAMEMODE.Econ:GetTaxData(k).Value )
		end	
	if pPlayer then
		self:FireEvent( pPlayer )
	else
		self:BroadcastEvent()
	end
end

function GM.Net:SendPlayerBills( pPlayer )
	local saveTable = GAMEMODE.Char:GetCurrentSaveTable( pPlayer )
	if not saveTable or not saveTable.Bills then return end

	self:NewEvent( "econ", "fupd_b" )
		net.WriteUInt( table.Count(saveTable.Bills), 8 )

		for k, v in pairs( saveTable.Bills ) do
			net.WriteUInt( k, 8 )
			net.WriteString( v.Type )
			net.WriteString( v.Name )
			net.WriteUInt( v.Cost, 16 )
			net.WriteUInt( v.LifeTime, 32 )
			net.WriteUInt( v.IssueTime, 32 )

			net.WriteBool( v.MetaData.Shared ~= nil )
			if v.MetaData.Shared then
				net.WriteTable( v.MetaData.Shared )
			end
		end
	self:FireEvent( pPlayer )
end

GM.Net:RegisterEventHandle( "econ", "pay_b", function( intMsgLen, pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "bank_storage" then return end
	GAMEMODE.Econ:PlayerPayBill( pPlayer, net.ReadUInt(8) )
end )

GM.Net:RegisterEventHandle( "econ", "rbupd", function( intMsgLen, pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "bank_storage" then return end
	
	if pPlayer.m_intLastBillRUpd or 0 > CurTime() then return end
	pPlayer.m_intLastBillRUpd = CurTime() +2
	GAMEMODE.Net:SendPlayerBills( pPlayer )
end )

GM.Net:RegisterEventHandle( "econ", "pay_a", function( intMsgLen, pPlayer )
	if not pPlayer:WithinTalkingRange() then return end
	if pPlayer:GetTalkingNPC().UID ~= "bank_storage" then return end
	GAMEMODE.Econ:PlayerPayAllBills( pPlayer )
end )