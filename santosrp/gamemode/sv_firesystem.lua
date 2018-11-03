--[[
 Note: fire system causes crash when a ragdoll is thrown in
]]

GM.FireSystem = {}
GM.FireSystem.m_tblCellGraph = {}
GM.FireSystem.m_intNodeCount = GM.Config.FireNodeCount
GM.FireSystem.m_intSpreadCount = GM.Config.FireSpreadCount --Max number of fires that can be created per sim tick
GM.FireSystem.m_intSpreadDist = GM.Config.FireSpreadDistance
GM.FireSystem.m_tblSpreadDirs = {}
GM.FireSystem.m_intRad = math.pi /180
GM.FireSystem.m_int2Pi = math.pi *2
GM.FireSystem.m_intCurSpreadCount = 0
GM.FireSystem.m_intMaxFires = GM.Config.MaxFires
GM.FireSystem.m_intMaxChildren = GM.Config.MaxChildFires
GM.FireSystem.m_bBurnAll = GM.Config.FireBurnEverything
GM.FireSystem.m_matBurnable = {
	[MAT_FLESH] = false,
	[MAT_DIRT] = true,
	[MAT_WOOD] = true,
	[MAT_GRASS] = true,
	[MAT_EGGSHELL] = true,
	[MAT_PLASTIC] = true,
	[MAT_ALIENFLESH] = true,
	[MAT_BLOODYFLESH] = false,
	[MAT_TILE] = true
}

function GM.FireSystem:Initialize()
	self:BuildSpreadDirs()

	timer.Create( "FireSimulate", GAMEMODE.Config.FireSimRate, 0, function()
		self:Simulate()
	end )
end

function GM.FireSystem:Tick()
	if not GAMEMODE.Config.AutoFiresEnabled then return end

	if not self.m_intLastAutoFire then
		self.m_intLastAutoFire = CurTime() +math.random( GAMEMODE.Config.AutoFireSpawnMinTime, GAMEMODE.Config.AutoFireSpawnMaxTime )
	end

	if self.m_intLastAutoFire > CurTime() then return end
	self.m_intLastAutoFire = CurTime() +math.random( GAMEMODE.Config.AutoFireSpawnMinTime, GAMEMODE.Config.AutoFireSpawnMaxTime )
	if GAMEMODE.Jobs:GetNumPlayers( JOB_FIREFIGHTER ) <= 0 then return end

	local tries = 0
	while tries < 3 do
		tries = tries +1
		local spot, _ = table.Random( GAMEMODE.Config.AutoFireSpawnPoints )

		local badSpot
		for k, v in pairs( ents.FindInSphere(spot, 1024) ) do
			if v:IsPlayer() then badSpot = true break end
			if v:GetClass() == "ent_fire" then badSpot = true break end
		end

		if badSpot then continue end
		local fire = ents.Create( "ent_fire" )
		fire:SetPos( spot )
		fire:Spawn()
		fire:Activate()
		break
	end
end

function GM.FireSystem:BuildSpreadDirs()
	for idx = 1, self.m_intNodeCount do
		local elevation = self.m_int2Pi *(idx /self.m_intNodeCount)
		local dirX = math.cos( elevation ) *self.m_intSpreadDist
		local dirY = math.sin( elevation ) *self.m_intSpreadDist

		self.m_tblSpreadDirs[idx] = Vector( dirX, dirY, 0 )
	end
end

function GM.FireSystem:NewFireNode( vecPos )
	local node = {
		Nodes = {},
		Pos = vecPos,
		Created = CurTime(),
	}

	node.Fire = ents.Create( "ent_fire" )
	node.Fire:SetPos( vecPos )
	node.Fire:Spawn()
	node.Fire:Activate()
	node.Fire.IsFireNode = true

	if node.Fire:WaterLevel() > 0 then
		node.Fire:Remove()
		return
	end

	self.m_intCurSpreadCount = self.m_intCurSpreadCount +1
	return node
end

function GM.FireSystem.SpreadFilter( entHit )
	if not IsValid( entHit ) then return end
	if entHit:GetClass() == "ent_fire" then return false end
end

function GM.FireSystem:CanBurn( eEnt )
	if IsValid( eEnt:GetPhysicsObject() ) then
		return self.m_matBurnable[eEnt:GetMaterialType()]
	end

	return true
end

function GM.FireSystem:ValidNodePosition( vecParent, vecChild )
	if #ents.FindByClass( "ent_fire" ) >= self.m_intMaxFires then
		return false
	end

	local upVec = Vector( 0, 0, 15 )
	local downVec = Vector( 0, 0, -15 )
	local parentPos = vecParent +upVec
	local spreadPos = vecParent +vecChild

	local tr = util.TraceLine{
		start = parentPos,
		endpos = spreadPos +upVec,
		filter = self.SpreadFilter,
	}

	local inAir = not util.TraceLine{
		start = spreadPos +upVec,
		endpos = spreadPos +downVec -upVec,
	}.Hit

	local range = math.floor((self.m_intSpreadDist /math.pi))
	if inAir or tr.HitPos:Distance( parentPos ) < self.m_intSpreadDist then
		return false
	end

	for k, v in pairs( ents.FindInSphere(spreadPos, 12) ) do
		if IsValid( v ) and v:GetClass() == "ent_fire" then
			return false
		end
	end

	local foundEnts, burnable = {}, 0
	for k, v in pairs( ents.FindInSphere(spreadPos, self.m_intSpreadDist -1) ) do
		if IsValid( v ) and v:GetClass() == "ent_fire" then continue end
		foundEnts[#foundEnts +1] = v

		if not self.m_bBurnAll and self:CanBurn( v ) then
			burnable = burnable +1
		end
	end

	if self.m_bBurnAll or (burnable > 0 or #foundEnts == 0) then
		return true
	end

	return false
end

function GM.FireSystem:RemoveNode( tblNode )
	if IsValid( tblNode.Fire ) then
		tblNode.Fire:Remove()
	end

	for k, v in pairs( tblNode.Nodes ) do
		self:RemoveNode( v )
	end
end

function GM.FireSystem:GetChildCount( tblNode, bOnlyVaild )
	local count = 0
	for k, v in pairs( tblNode.Nodes ) do
		if bOnlyVaild then
			if IsValid( v.Fire ) then
				count = count +1
			end
		else
			count = count +1
		end

		count = count +self:GetChildCount( v )
	end

	return count
end

function GM.FireSystem:PruneDeadNodes( tblNode )
	if not tblNode or not tblNode.Nodes then return end
	for k, v in pairs( tblNode.Nodes ) do
		if not self:HasValidChild( v ) then
			self:RemoveNode( v )
		else
			self:PruneDeadNodes( v )
		end
	end
end

function GM.FireSystem:HasValidChild( tblNode )
	for k, v in pairs( tblNode.Nodes ) do
		if IsValid( v.Fire ) then return true end
		if self:HasValidChild( v ) then return true end
 	end

 	return false
end

function GM.FireSystem:IterateChildren( tblNode, bOnlyUpdate )
	--Check child nodes and see if we can spread to there
	local childNode
	for nodeID = 1, self.m_intNodeCount do
		childNode = tblNode.Nodes[nodeID]

		if childNode then
			if IsValid( childNode.Fire ) or self:HasValidChild( childNode ) then
				self:IterateChildren( childNode, bOnlyUpdate )
				continue
			else
				self:RemoveNode( childNode )
				tblNode.Nodes[nodeID] = nil
			end
		end

		if not bOnlyUpdate and IsValid( tblNode.Fire ) and self:ValidNodePosition( tblNode.Pos, self.m_tblSpreadDirs[nodeID] ) then
			if self.m_intCurSpreadCount >= self.m_intSpreadCount then
				self.m_intCurSpreadCount = 0
				coroutine.yield()
				self:PruneDeadNodes( self.m_tblWorkingGraph )
				continue
			end

			tblNode.Nodes[nodeID] = self:NewFireNode( tblNode.Pos +self.m_tblSpreadDirs[nodeID] )
		end
	end
end

function GM.FireSystem.SimulateCoroutine( tblCellGraph )
	GAMEMODE.FireSystem.m_tblWorkingGraph = tblCellGraph

	--Iterate current nodes
	for idx, node in pairs( tblCellGraph ) do
		if not IsValid( node.Fire ) and not GAMEMODE.FireSystem:HasValidChild( node ) then
			GAMEMODE.FireSystem:RemoveNode( node )
			continue
		end

		if GAMEMODE.FireSystem:GetChildCount( node, true ) >= GAMEMODE.FireSystem.m_intMaxChildren then
			GAMEMODE.FireSystem:IterateChildren( node, true )
			continue
		end

		GAMEMODE.FireSystem:IterateChildren( node )
		coroutine.yield()
		GAMEMODE.FireSystem:PruneDeadNodes( tblCellGraph )
	end

	--Look for new fires we haven't spread yet
	for k, v in pairs( ents.FindByClass("ent_fire") ) do
		if IsValid( v ) and not v.IsFireNode then
			--Add this node as a root
			table.insert( tblCellGraph, {
				Nodes = {},
				Pos = v:GetPos(),
				Created = CurTime(),
				Fire = v,
			} )

			v.IsFireNode = true
		end
	end

	return tblCellGraph
end

function GM.FireSystem:Simulate()
	if not self.m_coFireThread then
		self.m_coFireThread = coroutine.create( self.SimulateCoroutine )
		local b, ret = coroutine.resume( self.m_coFireThread, self.m_tblCellGraph )
		if type( ret ) == "table" then
			self.m_tblCellGraph = ret
		end
	else
		local status = coroutine.status( self.m_coFireThread )

		if status == "dead" then
			self.m_coFireThread = nil
			self:Simulate()
		elseif status == "suspended" then
			local b, ret = coroutine.resume( self.m_coFireThread )
			if type( ret ) == "table" then
				self.m_tblCellGraph = ret
			end
		end
	end

	--Purge old fire if no firefighters are on
	if GAMEMODE.Jobs:GetNumPlayers( JOB_FIREFIGHTER ) > 0 then return end
	for k, v in pairs( self.m_tblCellGraph ) do
		if CurTime() > v.Created +120 then
			self:RemoveNode( v )
			self.m_tblCellGraph[k] = nil
		end
	end
end

function GM.FireSystem:OnEntityCreated( eEnt )
	if eEnt:GetClass() == "env_explosion" then
		timer.Simple( 0, function()
			if not IsValid( eEnt ) then return end

			local Fire = ents.Create( "ent_fire" )
			Fire:SetPos( eEnt:GetPos() )
			Fire:Spawn()
			Fire:Activate()
		end )
	end
end

concommand.Add( "srp_dev_clear_fire", function( pPlayer )
	if IsValid( pPlayer ) and not pPlayer:IsSuperAdmin() then return end

	for k, v in pairs( ents.FindByClass("ent_fire") ) do
		if not IsValid( v) then continue end
		v:Remove()
	end
end )
