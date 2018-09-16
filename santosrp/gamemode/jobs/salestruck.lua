--[[
	Name: salestruck.lua
	For: TalosLife
	By: TalosLife
]]--

--Job protocols start at 50 to save space for other things in the gamemode
GM.Net:AddProtocol( "sales_truck", 52 )

local Job = {}
Job.ID = 8
Job.Enum = "JOB_SALES_TRUCK"
Job.TeamColor = Color( 255, 100, 160, 255 )
Job.Name = "Sales Truck Driver"
Job.Pay = {
	{ PlayTime = 0, Pay = 40 },
	{ PlayTime = 4 *(60 *60), Pay = 65 },
	{ PlayTime = 12 *(60 *60), Pay = 75 },
	{ PlayTime = 24 *(60 *60), Pay = 90 },
}
Job.PlayerCap = GM.Config.Job_SalesTruck_PlayerCap or { Min = 2, MinStart = 8, Max = 6, MaxEnd = 60 }
Job.ParkingLotPos = GM.Config.SalesParkingZone
Job.TruckSpawns = GM.Config.SalesCarSpawns
Job.TruckID = "sales_truck"
Job.m_tblTruckTypes = {
	[1] = { Name = "Mechanic", Skin = 4, Items = {
	["Crafting Table"] = 1200,
	["Assembly Table"] = 1200,
	["Gun Smithing Table"] = 3200,
	["Road Flare"] = 30,
	["Terracotta Pot"] = 45,
	["Stove"] = 570,

	--fluids
	["Cleaning Solution"] = 60,
	["Bucket of Fertilizer"] = 40,
	["Potting Soil"] = 30,

	--crafting items
	["Wood Plank"] = 350,
	["Paint Bucket"] = 190,
	["Metal Bracket"] = 140,
	["Metal Bar"] = 175,
	["Metal Plate"] = 145,
	["Metal Pipe"] = 85,
	["Metal Hook"] = 90,
	["Metal Bucket"] = 90,
	["Plastic Bucket"] = 100,
	["Wrench"] = 75,
	["Pliers"] = 70,
	["Car Battery"] = 500,
	["Circular Saw"] = 300,
	["Cinder Block"] = 115,
	["Bleach"] = 70,
	["Radiator"] = 540,
	["Crowbar"] = 60,
	["Engine Block"] = 1500,
	["Large Cardboard Box"] = 60,
	["Plastic Crate"] = 60,
	["Chunk of Plastic"] = 85,
	["Cloth"] = 35,
	["Rubber Tire"] = 120,

	--misc building items
	["Concrete Barrier"] = 50,
	["Wire Fence 01"] = 75,
	["Wire Fence 02"] = 50,
	["Wire Fence 03"] = 100,
	["Large Blast Door"] = 400,
	["Blast Door"] = 250,
	["Large Wood Plank"] = 30,
	["Large Wood Fence"] = 80,
	["Wood Fence"] = 80,
	} },
}

function Job:OnPlayerJoinJob( pPlayer )
end

function Job:OnPlayerQuitJob( pPlayer )
	local curCar = GAMEMODE.Cars:GetCurrentPlayerCar( pPlayer )
	if curCar and curCar.Job and curCar.Job == JOB_TOW then
		curCar:Remove()
	end
end

if SERVER then
	function Job:PlayerLoadout( pPlayer )
	end

	function Job:OnPlayerSpawnSalesTruck( pPlayer, entCar, intTruckID )
		entCar.TruckID = intTruckID
		entCar.IsSalesTruck = true
		entCar:SetSkin( self.m_tblTruckTypes[intTruckID].Skin )
		entCar:SetNWInt( "sales_truck_id", intTruckID )
		pPlayer:AddNote( "You spawned your sales truck!" )
	end

	--Player wants to spawn a sales truck
	function Job:PlayerSpawnSalesTruck( pPlayer, intTruckID )
		local car = GAMEMODE.Cars:PlayerSpawnJobCar( pPlayer, self.TruckID, self.TruckSpawns, self.ParkingLotPos )
		if IsValid( car ) then
			self:OnPlayerSpawnSalesTruck( pPlayer, car, intTruckID )
		end
	end
	
	--Player wants to stow their sales truck
	function Job:PlayerStowSalesTruck( pPlayer )
		GAMEMODE.Cars:PlayerStowJobCar( pPlayer, self.ParkingLotPos )
	end

	function Job:PlayerBuyItem( pPlayer, entCar, strItem, intAmount )
		if not self.m_tblTruckTypes[entCar:GetNWInt("sales_truck_id", 0)] then return end
		if not self.m_tblTruckTypes[entCar:GetNWInt("sales_truck_id", 0)].Items[strItem] then return end
		intAmount = math.max( intAmount or 1, 1 )

		local itemPrice = self.m_tblTruckTypes[entCar:GetNWInt("sales_truck_id", 0)].Items[strItem]
		local itemPriceTaxed = GAMEMODE.Econ:ApplyTaxToSum( "sales", itemPrice *intAmount )
		local ownerPay = math.ceil( itemPrice *0.32 ) *intAmount
		local price = itemPriceTaxed +ownerPay

		if not pPlayer:CanAfford( price ) then
			pPlayer:AddNote( "You can't afford that!" )
			return
		end

		if GAMEMODE.Inv:GivePlayerItem( pPlayer, strItem, intAmount ) then
			pPlayer:TakeMoney( price )
			entCar:GetPlayerOwner():AddMoney( ownerPay )
			pPlayer:AddNote( "You purchased ".. intAmount.. " ".. strItem.. "." )
			entCar:GetPlayerOwner():AddNote( "You earned $".. ownerPay.. " by selling merchandise!" )
		else
			pPlayer:AddNote( "Your inventory is full!" )
		end
	end

	function GM.Net:OpenSalesTruckMenu( pPlayer, entSalesTruck )
		self:NewEvent( "sales_truck", "open" )
			net.WriteEntity( entSalesTruck )
		self:FireEvent( pPlayer )
	end

	GM.Net:RegisterEventHandle( "sales_truck", "b", function( intMsgLen, pPlayer )
		if not IsValid( pPlayer.UsedSalesTruck ) then return end
		if pPlayer.UsedSalesTruck:GetPos():Distance( pPlayer:GetPos() ) > 200 then return end
		
		local itemID, amount = net.ReadString(), net.ReadUInt( 8 )
		Job:PlayerBuyItem( pPlayer, pPlayer.UsedSalesTruck, itemID, amount )
	end )

	hook.Add( "PlayerUse", "UseSalesTruck", function( pPlayer, eEnt )
		if not IsValid( eEnt ) or not eEnt:IsVehicle() or not eEnt.IsSalesTruck then return end

		local dot = (pPlayer:GetEyeTrace().HitPos -eEnt:GetPos()):GetNormal():Dot( eEnt:GetForward() )
		if dot < -0.19 and CurTime() >(pPlayer.m_intLastUsedSalesTruck or 0) then
			GAMEMODE.Net:OpenSalesTruckMenu( pPlayer, eEnt )
			pPlayer.m_intLastUsedSalesTruck = CurTime() +1
			pPlayer.UsedSalesTruck = eEnt
			return false
		end
	end )
else
	function GM.Net:PlayerBuySalesTruckItem( strItemID, intAmount )
		self:NewEvent( "sales_truck", "b" )
			net.WriteString( strItemID )
			net.WriteUInt( intAmount or 1, 8 )
		self:FireEvent()
	end
	
	GM.Net:RegisterEventHandle( "sales_truck", "open", function( intMsgLen, pPlayer )
		local truckEnt = net.ReadEntity()
		GAMEMODE.Gui:ShowSalesTruckMenu( truckEnt )
	end )
end

GM.Jobs:Register( Job )