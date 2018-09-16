AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props_c17/cashregister01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	self.m_intMoney = 0
	self.m_tblListedItems = {}
end

function ENT:CanPlayerPickup( pPlayer, bCanUse )
	if self:GetPlayerOwner() == pPlayer and self.m_intMoney > 0 then
		pPlayer:AddMoney( self.m_intMoney )
		pPlayer:AddNote( "You took $".. self.m_intMoney.. " from the cash register." )
		self.m_intMoney = 0
	end

	return bCanUse
end

function ENT:OnRemove()
	--Auto unlist stuff
	for k, v in pairs( self.m_tblListedItems ) do
		if IsValid( k ) then
			k.m_tblSaleData = nil
			k:SetNWInt( "register_price", -1 )
		end
	end
end

function ENT:AddMoney( int )
	self.m_intMoney = self.m_intMoney +int
end

function ENT:TakeMoney( int )
	self.m_intMoney = self.m_intMoney -int
end

function ENT:OnRemove()
	for k, v in pairs( ents.GetAll() ) do
		if IsValid( v ) and v.m_tblSaleData then
			if v.m_tblSaleData.register == self then
				v.m_tblSaleData = nil
				v:SetNWInt( "register_price", -1 )
			end
		end
	end
end

function ENT:AcceptInput( strName, entActivator, entCaller )
	if not IsValid( self:GetPlayerOwner() ) then return end
	if not IsValid( entCaller ) or not entCaller:IsPlayer() then return end
	if strName ~= "Use" then return end
	if entCaller ~= self:GetPlayerOwner() then return end
	self:OpenMenu( entCaller )
end

function ENT:OpenMenu( pPlayer )
	local near = {}
	for k, v in pairs( ents.FindInSphere(self:GetPos(), self.ItemRange) ) do
		if not IsValid( v ) or not v.ItemID or v.m_tblSaleData then continue end
		if v:GetPlayerOwner() ~= self:GetPlayerOwner() then continue end
		if v == self or v.ItemTakeBlocked then continue end
		near[v] = true
	end

	local data = {}
	for k, v in pairs( self.m_tblListedItems ) do
		if not IsValid( k ) then self.m_tblListedItems[k] = nil end
	end

	GAMEMODE.Net:NewEvent( "ent", "creg_open" )
		net.WriteEntity( self )
		net.WriteUInt( self.m_intMoney, 32 )

		net.WriteUInt( table.Count(near), 16 )
		for k, v in pairs( near ) do
			net.WriteString( k.ItemID )
			net.WriteEntity( k )
		end

		net.WriteUInt( table.Count(self.m_tblListedItems), 16 )
		for k, v in pairs( self.m_tblListedItems ) do
			net.WriteString( k.ItemID )
			net.WriteUInt( k.m_tblSaleData.price, 32 )
			net.WriteEntity( k )
		end
	GAMEMODE.Net:FireEvent( pPlayer )
end

GAMEMODE.Net:RegisterEventHandle( "ent", "creg_rs", function( intMsgLen, pPlayer )
	local register = net.ReadEntity()
	if not IsValid( register ) or register:GetClass() ~= "ent_cashregister" or register:GetPlayerOwner() ~= pPlayer then return end
	if register:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end

	local selling = net.ReadEntity()
	if not IsValid( selling ) or not selling.ItemID or selling:GetPlayerOwner() ~= pPlayer then return end
	if selling == register or selling.ItemTakeBlocked then return end
	if selling:GetPos():Distance( register:GetPos() ) > register.ItemRange then return end

	local price = net.ReadUInt( 32 )
	if price < 1 then
		pPlayer:AddNote( "You must enter a price greater than 0!" )
		return
	end

	selling.m_tblSaleData = {
		price = price,
		register = register,
	}
	
	selling:SetNWInt( "register_price", price )
	selling:SetNWString( "itemID", selling.ItemID or "" )
	pPlayer:AddNote( "You put an item up for sale!" )

	register.m_tblListedItems[selling] = true
	register:OpenMenu( pPlayer )
end )

GAMEMODE.Net:RegisterEventHandle( "ent", "creg_ruls", function( intMsgLen, pPlayer )
	local register = net.ReadEntity()
	if not IsValid( register ) or register:GetClass() ~= "ent_cashregister" or register:GetPlayerOwner() ~= pPlayer then return end
	if register:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end

	local unlist = net.ReadEntity()
	if not IsValid( unlist ) or not unlist.ItemID or unlist:GetPlayerOwner() ~= pPlayer then return end
	if unlist == register then return end
	if not unlist.m_tblSaleData or not register.m_tblListedItems[unlist] then return end
	
	unlist.m_tblSaleData = nil
	unlist:SetNWInt( "register_price", -1 )
	pPlayer:AddNote( "You are no longer selling that item!" )

	register.m_tblListedItems[unlist] = nil
	register:OpenMenu( pPlayer )
end )

GAMEMODE.Net:RegisterEventHandle( "ent", "creg_rb", function( intMsgLen, pPlayer )
	local buying = net.ReadEntity()
	if not IsValid( buying ) or not buying.m_tblSaleData or not IsValid( buying.m_tblSaleData.register ) then return end
	if not IsValid( buying.m_tblSaleData.register:GetPlayerOwner() ) then return end
	if buying:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end

	local price = buying.m_tblSaleData.price
	price = GAMEMODE.Econ:ApplyTaxToSum( "sales", price )
	
	if not pPlayer:CanAfford( price ) then
		pPlayer:AddNote( "You can't afford that!" )
		return
	end

	if GAMEMODE.Inv:GivePlayerItem( pPlayer, buying.ItemID, 1 ) then
		buying.m_tblSaleData.register.m_tblListedItems[buying] = true
		buying.m_tblSaleData.register:AddMoney( buying.m_tblSaleData.price )
		buying.m_tblSaleData.register:GetPlayerOwner():AddNote( "You sold 1 ".. buying.ItemID.. " for $".. string.Comma(buying.m_tblSaleData.price).. "!" )
		
		pPlayer:TakeMoney( price )
		pPlayer:AddNote( "You purchased 1 ".. buying.ItemID.. " for $".. price )
		buying.m_tblSaleData = nil
		buying:Remove()
	end
end )

GAMEMODE.Net:RegisterEventHandle( "ent", "creg_rtm", function( intMsgLen, pPlayer )
	local register = net.ReadEntity()
	if not IsValid( register ) or register:GetPlayerOwner() ~= pPlayer then return end
	if register:GetClass() ~= "ent_cashregister" then return end
	if register.m_intMoney <= 0 then return end
	if register:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end
	
	pPlayer:AddNote( "You took $".. register.m_intMoney.. " from the cash register." )
	pPlayer:AddMoney( register.m_intMoney )
	register.m_intMoney = 0
	register:OpenMenu( pPlayer )
end )

hook.Add( "PlayerUse", "!_CashRegister", function( pPlayer, eEnt )
	if not eEnt.m_tblSaleData then return end
	if eEnt:GetPlayerOwner() ~= pPlayer then
		return false
	end
end )

hook.Add( "GamemodePlayerPickupItem", "BlockItemsForSale", function( pPlayer, eEnt )
	if eEnt.m_tblSaleData and eEnt:GetPlayerOwner() ~= pPlayer then
		GAMEMODE.Net:NewEvent( "ent", "creg_isq" )
			net.WriteEntity( eEnt )
		GAMEMODE.Net:FireEvent( pPlayer )

		return false
	end
end )