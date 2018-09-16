--[[
	Name: sv_trunk.lua
]]--

GM.TrunkStorage = {}

-- Add item to trunk without getting it from owner
function GM.TrunkStorage:AddToTrunkForce(intCarIndex, strItem, intNum )
	local eCar = ents.GetByIndex(intCarIndex)
	eCar.TrunkItems = eCar.TrunkItems or {}

	local data = GAMEMODE.Inv:GetItem( strItem )

	if not eCar.TrunkItems[strItem] then
		eCar.TrunkItems[strItem] = 0
	end

	eCar.TrunkItems[strItem] = eCar.TrunkItems[strItem] +intNum

	self:SendTrunkUpdate( eCar )
end

function GM.TrunkStorage:AddToTrunk( pPlayer, intCarIndex, strItem, intNum )
	local eCar = ents.GetByIndex(intCarIndex)
	eCar.TrunkItems = eCar.TrunkItems or {}

	local data = GAMEMODE.Inv:GetItem( strItem )
	if not data then return end
	if data.JobItem and eCar:GetPlayerOwner() != pPlayer then return end
	if data.JobItem and data.JobItem != eCar.CarData.Job then return end
	local item = GAMEMODE.Inv:GetPlayerItemAmount( pPlayer, strItem )
	if not item or item == 0 then return end
	intNum = math.min( intNum, item )

	if not eCar.TrunkItems[strItem] then
		eCar.TrunkItems[strItem] = 0
	end
	
	GAMEMODE.Inv:TakePlayerItem( pPlayer, strItem, intNum )
	eCar.TrunkItems[strItem] = eCar.TrunkItems[strItem] +intNum

	self:SendTrunkUpdate( eCar )
end

-- Remove item from trunk without getting it to owner
function GM.TrunkStorage:RemoveFromTrunkForce( intCarIndex, strItem, intNum )
	local eCar = ents.GetByIndex(intCarIndex)
	eCar.TrunkItems = eCar.TrunkItems or {}

	if not eCar.TrunkItems[strItem] then return end
	local count = eCar.TrunkItems[strItem]	
	intNum = math.min( intNum, count )

	eCar.TrunkItems[strItem] = count -intNum
	if eCar.TrunkItems[strItem] == 0 then
		eCar.TrunkItems[strItem] = nil
	end

	self:SendTrunkUpdate( eCar )
end

function GM.TrunkStorage:RemoveFromTrunk( pPlayer, intCarIndex, strItem, intNum )
	local eCar = ents.GetByIndex(intCarIndex)
	eCar.TrunkItems = eCar.TrunkItems or {}

	if not eCar.TrunkItems[strItem] then return end
	local count = eCar.TrunkItems[strItem]	
	intNum = math.min( intNum, count )

	local data = GAMEMODE.Inv:GetItem( strItem )
	if not data then return end
	if data.JobItem and eCar:GetPlayerOwner() != pPlayer then return end
	if data.JobItem and data.JobItem != eCar.CarData.Job then return end

	if not GAMEMODE.Inv:GivePlayerItem( pPlayer, strItem, intNum ) then
		return
	end

	eCar.TrunkItems[strItem] = count -intNum
	if eCar.TrunkItems[strItem] == 0 then
		eCar.TrunkItems[strItem] = nil
	end

	self:SendTrunkUpdate( eCar )
end

function GM.TrunkStorage:SendTrunkUpdate( eCar )
	if eCar.TrunkItems then
		for k, v in pairs( eCar.TrunkItems ) do
			if not GAMEMODE.Inv:GetItem( k ) then eCar.TrunkItems[k] = nil end	
		end
	end
	
	GAMEMODE.Net:SendTrunkItemUpdate( eCar:EntIndex(), eCar.TrunkItems or {} )
end

local intLastHit  = CurTime();
hook.Add( "PlayerUse", "OpenTrunkSRP", function(pPlayer, eEnt)
	if eEnt:GetClass():find( "jeep" ) then --Player is locking/unlocking a vehicle
		local vecPos = eEnt:GetPos() + eEnt:GetForward()*eEnt:OBBMins().y;
		if vecPos:Distance(pPlayer:GetPos()) > 60 then return end 
		if intLastHit > CurTime() then return end
		
		intLastHit = CurTime() + 1
		if eEnt.IsTrunkLocked then pPlayer:AddNote("Trunk is locked.") return end
		GAMEMODE.Net:SendTrunkItemUpdate( eEnt:EntIndex(), eEnt.TrunkItems or {} )
		pPlayer:SendLua('GAMEMODE.Gui:ShowTrunk('..eEnt:EntIndex()..')')
	end
end)