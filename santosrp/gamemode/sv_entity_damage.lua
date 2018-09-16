--[[
	Name: sv_entity_damage.lua
	For: TalosLife
	By: TalosLife
]]--

GM.EntityDamage = {}

--[[ Damage for dropped items ]]--
function GM.EntityDamage:InitItemHealth( entItem )
	local itemData = GAMEMODE.Inv:GetItem( entItem.ItemID or "" )
	if not itemData then return end
	entItem.m_flMaxHealth = itemData.HealthOverride or 100
	entItem.m_flHealth = itemData.HealthOverride or 100
end

function GM.EntityDamage:SetItemHealth( entItem, intNewHealth )
	entItem.m_flHealth = math.Clamp( intNewHealth, 0, entItem.m_flMaxHealth )
end

function GM.EntityDamage:GetItemHealth( entItem )
	return entItem.m_flHealth or 0
end

function GM.EntityDamage:GetItemMaxHealth( entItem )
	return entItem.m_flMaxHealth or 0
end

function GM.EntityDamage:EntityTakeDamage( eEnt, pDamageInfo )
	if not eEnt.IsItem then return end
	self:SetItemHealth( eEnt, math.max(self:GetItemHealth(eEnt) -pDamageInfo:GetDamage(), 0) )
	self:OnDropEntityDamaged( eEnt, pDamageInfo, self:GetItemHealth(eEnt) )
end

function GM.EntityDamage:OnDropEntityDamaged( eEnt, pDamageInfo, intNewHealth )
	if intNewHealth <= 0 then
		if not eEnt.m_bDissolving then
			GAMEMODE.Entity:Dissolve( eEnt )
		end
	else
		--update color
		self:UpdateItemHealthColor( eEnt )
	end

	eEnt.m_intLastDmgTime = CurTime() +GAMEMODE.Config.ItemDamageTakeCooldown
end

function GM.EntityDamage:UpdateItemHealthColor( eEnt )
	local hp, max = self:GetItemHealth( eEnt ), self:GetItemMaxHealth( eEnt )
	local scalar = math.Clamp( hp /max, 0, 1 )
	eEnt:SetColor( Color(255 *scalar, 255 *scalar, 255 *scalar, 255) )
end

hook.Add( "PlayerDroppedItem", "InitItemHealth", function( pPlayer, strItemID, bOwnerless, ent )
	GAMEMODE.EntityDamage:InitItemHealth( ent )
end )

hook.Add( "GamemodePlayerPickupItem", "DamageCooldown", function( pPlayer, eEnt )
	if eEnt.m_bDissolving then return false end
	if eEnt.m_intLastDmgTime and eEnt.m_intLastDmgTime > CurTime() then
		pPlayer:AddNote( "This item was recently damaged!" )
		pPlayer:AddNote( ("You won't be able to pick this item up for another %s seconds."):format( math.ceil(eEnt.m_intLastDmgTime -CurTime())) )
		return false
	end
end )