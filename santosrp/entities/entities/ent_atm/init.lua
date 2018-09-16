--[[
	Name: init.lua
	For: SantosRP
	By: TalosLife
]]--

AddCSLuaFile "cl_init.lua"
AddCSLuaFile "shared.lua"
include "shared.lua"

function ENT:Initialize()
	self:SetModel( "models/props_unique/atm01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysWake()
end

function ENT:PlayerMakeDeposit( pPlayer, intAmount )
	if pPlayer:GetPos():Distance( self:GetPos() ) >self.m_intMaxUseRange then return end

	local amount = math.min( intAmount, pPlayer:GetMoney() )
	pPlayer:TakeMoney( amount )
	pPlayer:AddBankMoney( amount )
	pPlayer:AddNote( "You deposited $".. string.Comma(amount) )
end

function ENT:PlayerMakeWithdraw( pPlayer, intAmount )
	if pPlayer:GetPos():Distance( self:GetPos() ) >self.m_intMaxUseRange then return end
	
	local amount = math.min( intAmount, pPlayer:GetBankMoney() )
	pPlayer:TakeBankMoney( amount )
	pPlayer:AddMoney( amount )
	pPlayer:AddNote( "You withdrew $".. string.Comma(amount) )
end

function ENT:PlayerMakeTransfer( pPlayer, intAmount, strPhoneNum )
	if pPlayer:GetPos():Distance( self:GetPos() ) >self.m_intMaxUseRange then return end

	local foundPlayer
	for k, v in pairs( player.GetAll() ) do
		if GAMEMODE.Player:GetGameVar( v, "phone_number", "" ) == strPhoneNum then
			foundPlayer = v
			break
		end
	end

	if not IsValid( foundPlayer ) then
		pPlayer:AddNote( "Unable to locate target bank account!" )
		return
	end
	
	local amount = math.min( intAmount, pPlayer:GetBankMoney() )
	pPlayer:TakeBankMoney( amount )
	foundPlayer:AddBankMoney( amount )
	pPlayer:AddNote( "You transfered $".. string.Comma(amount).. " to account #".. strPhoneNum )
end