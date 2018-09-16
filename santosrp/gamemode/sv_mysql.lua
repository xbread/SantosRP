--[[
	Name: sv_mysql.lua
	For: SantosRP
	By: Ultra
]]--

require( "tmysql4" )

GM.SQL = (GAMEMODE or GM).SQL or {}
GM.SQL.m_intConnectRetryInterval = GM.Config.SQLReconnectInterval
GM.SQL.m_bVerbose = false

function GM.SQL:LogMsg( str )
	ErrorNoHalt( "[SQL] ".. str, "\n" )
end

function GM.SQL:LogDev( str, ... )
	if not self.m_bVerbose then return end
	ErrorNoHalt( "[SQL-DEBUG] ".. str, ..., "\n" )
end

function GM.SQL:Connect( strHostName, strUserName, strPassword, strDatabaseName )
	if self.m_bConnected then return end
	
	self:ConnectReadOnly( strHostName, strUserName, strPassword, strDatabaseName )
	self:ConnectWritePool( strHostName, strUserName, strPassword, strDatabaseName )
	self:InitWriteQueue()
	self.m_bConnected = true
	self:InitGamemodeTables()
end

function GM.SQL:IsConnected()
	return self.m_bConnected and true
end

function GM.SQL:Tick()
	self:TickPlayerIntervals()
end

function GM.SQL:PlayerInitialSpawn( pPlayer )
	self:AssignPlayerPoolID( pPlayer )
end

function GM.SQL:PlayerDisconnected( strSID64 )
	if not self:GetPlayerPoolID( strSID64 ) then return end
	self:CommitPlayerDiffs( strSID64 )
	self:UnrefPlayerPoolID( strSID64 )
end

function GM.SQL:ShutDown()
	for k, v in pairs( player.GetAll() ) do
		if not self:GetPlayerPoolID( v:SteamID64() ) then continue end
		self:CommitPlayerDiffs( v:SteamID64() )
		self:UnrefPlayerPoolID( v:SteamID64() )
	end
end

-- ----------------------------------------------------------------
-- Read Only

GM.SQL.m_tblReadQueue = (GAMEMODE or GM).SQL.m_tblReadQueue or {}

function GM.SQL:ConnectReadOnly( strHostName, strUserName, strPassword, strDatabaseName )
	local db, err = tmysql.initialize( strHostName, strUserName, strPassword, strDatabaseName )
	if not db then return error( "Unable to initialize a database connection! Error: ".. err ) end
	self:LogMsg( "Read-only database connected." )

	self.m_pDBReadOnly = db
	self.m_pDBReadOnly:Query( "SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;", function( tblData )
		self:LogMsg( "Read database set to read-only mode." )
		
		timer.Create( "KeepAliveReadDB", 10, 0, function()
			if not self.m_pDBReadOnly then return end
			self.m_pDBReadOnly:Query( "SELECT 5+5;" )
		end )
	end )
end

function GM.SQL:QueryReadOnly( strQuery, funcCallback )
	if not self.m_pDBReadOnly then return end
	if not self.m_bWaitingReconnect and self.m_pDBReadOnly:IsConnected() then --We can run this now
		self.m_pDBReadOnly:Query( strQuery, function( tblData )
			tblData = tblData[1]

			if tblData.status then --Query ran OK
				funcCallback( tblData.data )
			else
				self:LogMsg( "Read Query Error! Error: ".. tblData.error )
				--We lost connection, put this in the queue and try to start the reconnect loop
				if tblData.error and tblData.error:lower() == "mysql server has gone away" then
					table.insert( self.m_tblReadQueue, { strQuery, funcCallback } )
					self:ReconnectReadWorker()
				end
			end
		end )
	else
		--We lost connection, put this in the queue and try to start the reconnect loop
		table.insert( self.m_tblReadQueue, { strQuery, funcCallback } )
		self:ReconnectReadWorker()
	end
end

function GM.SQL:ReconnectReadWorker()
	if self.m_bWaitingReconnect then return end --We are already trying to reconnect right now

	self:LogMsg( "Attempting to reconnect the read-only database." )
	self.m_bWaitingReconnect = true

	self.m_pDBReadOnly:Query( "SELECT 5+5;", function( tblData )
		if tblData.error and tblData.error:lower() == "mysql server has gone away" then
			self:LogMsg( "Connection to read-only database failed, retrying in ".. self.m_intConnectRetryInterval.. " seconds..." )
			
			timer.Simple( self.m_intConnectRetryInterval +1, function()
				if not self.m_pDBReadOnly or not self.m_bWaitingReconnect then return end
				self.m_bWaitingReconnect = nil
				self:ReconnectReadWorker()
			end )
		else
			self:LogMsg( "Read-only database reconnected." )
			self.m_pDBReadOnly:Query( "SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;", function( tblData )
				if tblData.error and tblData.error:lower() == "mysql server has gone away" then
					self:LogMsg( "Connection to read-only database failed, retrying in ".. self.m_intConnectRetryInterval.. " seconds..." )

					timer.Simple( self.m_intConnectRetryInterval +1, function()
						if not self.m_pDBReadOnly or not self.m_bWaitingReconnect then return end
						self.m_bWaitingReconnect = nil
						self:ReconnectReadWorker()
					end )
				else
					self:LogMsg( "Read database set to read-only mode." )
					self.m_bWaitingReconnect = nil

					local runQueue = table.Copy( self.m_tblReadQueue )
					self.m_tblReadQueue = {}

					for k, v in ipairs( runQueue ) do
						self:QueryReadOnly( v[1], v[2] )
					end
				end
			end )
		end
	end )
end

-- ----------------------------------------------------------------
-- Write Pool

GM.SQL.m_intWritePoolSize = GM.Config.SQLNumWriteWorkers
GM.SQL.m_tblWorkerStatus = (GAMEMODE or GM).SQL.m_tblWorkerStatus or {}
GM.SQL.m_tblWritePool = (GAMEMODE or GM).SQL.m_tblWritePool or {}
GM.SQL.m_tblWriteQueue = (GAMEMODE or GM).SQL.m_tblWriteQueue or {}
GM.SQL.m_tblPlayerPoolIDs = (GAMEMODE or GM).SQL.m_tblPlayerPoolIDs or {}

GM.SQL.WORKER_RUNNING_QUERY = 0
GM.SQL.WORKER_CONNECTING = 1
GM.SQL.WORKER_IDLE = 2
GM.SQL.WORKER_LOCKED = 3

function GM.SQL:InitWriteQueue()
	for i = 1, self.m_intWritePoolSize do
		self.m_tblWriteQueue[i] = {}
	end
end

function GM.SQL:GetWriteQueue()
	return self.m_tblWriteQueue
end

function GM.SQL:ConnectWritePool( strHostName, strUserName, strPassword, strDatabaseName )
	for i = 1, self.m_intWritePoolSize do
		local db, err = tmysql.initialize( strHostName, strUserName, strPassword, strDatabaseName )
		if not db then return error( "Unable to initialize a database connection! Error: ".. err ) end
		self.m_tblWritePool[i] = db
		self:SetWorkerStatus( i, self.WORKER_IDLE )
		self:LogMsg( "Write worker #".. i.. " connected." )
	end

	timer.Create( "KeepAliveWriteDB", 10, 0, function()
		for k, v in pairs( self.m_tblWritePool ) do
			if v then v:Query( "SELECT 5+5;" ) end
		end
	end )
end

function GM.SQL:IsWorkerConnecting( intWorkerID )
	return self:GetWorkerStatus( intWorkerID ) == self.WORKER_CONNECTING
end

function GM.SQL:GetWorkerStatus( intWorkerID )
	return self.m_tblWorkerStatus[intWorkerID]
end

function GM.SQL:SetWorkerStatus( intWorkerID, intStatus )
	self.m_tblWorkerStatus[intWorkerID] = intStatus
end

function GM.SQL:ReconnectWorker( intWorkerID )
	if self:GetWorkerStatus( intWorkerID ) == self.WORKER_CONNECTING then return end
	if not self:GetWriteWorker( intWorkerID ) then return end
	
	self:SetWorkerStatus( intWorkerID, self.WORKER_CONNECTING )

	self:GetWriteWorker( intWorkerID ):Query( "SELECT 5+5;", function( tblData )
		if tblData.error and tblData.error:lower() == "mysql server has gone away" then
			self:LogMsg( "Connection to worker #".. intWorkerID.. " database failed, retrying in ".. self.m_intConnectRetryInterval.. " seconds..." )
			
			timer.Simple( self.m_intConnectRetryInterval +1, function()
				if not self:GetWriteWorker( intWorkerID ) or self:GetWorkerStatus( intWorkerID ) ~= self.WORKER_CONNECTING then return end
				self:SetWorkerStatus( intWorkerID, self.WORKER_LOCKED )
				self:ReconnectWorker( intWorkerID )
			end )
		else
			self:LogMsg( "Write worker #".. intWorkerID.. " reconnected." )
			self:SetWorkerStatus( intWorkerID, self.WORKER_IDLE )

			--Check for stuff in the queue
			if #self.m_tblWriteQueue[intWorkerID] > 0 then --We have queued queries, run the next one
				self:PooledQueryWrite( intWorkerID, self.m_tblWriteQueue[intWorkerID][1][1], self.m_tblWriteQueue[intWorkerID][1][2], 1 )
			end
		end
	end )
end

function GM.SQL:GetWriteWorker( intWorkerID )
	return self.m_tblWritePool[intWorkerID]
end

function GM.SQL:AssignPlayerPoolID( pPlayer )
	local counts = {}
	for i = 1, self.m_intWritePoolSize do
		counts[i] = 0
	end

	for k, v in pairs( self.m_tblPlayerPoolIDs ) do
		counts[v] = counts[v] +1
	end

	local idealID, curCount = -1, math.huge
	for id, v in pairs( counts ) do
		if curCount > v then
			curCount = v
			idealID = id
		end
	end

	if idealID == -1 then
		idealID = math.random( 1, self.m_intWritePoolSize )
	end

	self:LogDev( pPlayer:Nick().. "'s worker id is now ".. idealID )
	self.m_tblPlayerPoolIDs[pPlayer:SteamID64()] = idealID
end

function GM.SQL:GetPlayerPoolID( strSID64 )
	return self.m_tblPlayerPoolIDs[strSID64]
end

function GM.SQL:UnrefPlayerPoolID( strSID64 )
	self.m_tblPlayerPoolIDs[strSID64] = nil
end

function GM.SQL:PooledQueryWrite( intWorkerID, strQuery, funcCallback, intQueueIDX )
	local db = self:GetWriteWorker( intWorkerID )
	if not db then return end
	
	self:LogDev( "GM.SQL:PooledQueryWrite", "worker = ".. intWorkerID, "query = ".. strQuery )

	if db:IsConnected() then
		if self:GetWorkerStatus( intWorkerID ) == self.WORKER_IDLE then --We can run this now
			intQueueIDX = intQueueIDX or table.insert( self.m_tblWriteQueue[intWorkerID], { strQuery, funcCallback } )
			self:SetWorkerStatus( intWorkerID, self.WORKER_RUNNING_QUERY )

			db:Query( strQuery, function( tblData )
				tblData = tblData[1]

				if tblData.status then --Query ran OK
					table.remove( self.m_tblWriteQueue[intWorkerID], intQueueIDX ) --Pop this query off the queue
					self:SetWorkerStatus( intWorkerID, self.WORKER_IDLE )

					if #self.m_tblWriteQueue[intWorkerID] > 0 then --We have queued queries, run the next one
						self:PooledQueryWrite( intWorkerID, self.m_tblWriteQueue[intWorkerID][1][1], self.m_tblWriteQueue[intWorkerID][1][2], 1 )
					end

					if funcCallback then
						funcCallback( tblData.data, tblData )
					end
				else
					--We lost connection, keep this in the queue and try to start the reconnect loop
					if tblData.error and tblData.error:lower() == "mysql server has gone away" then
						self:ReconnectWorker( intWorkerID )
					else --We made some other kind of error, just keep running
						table.remove( self.m_tblWriteQueue[intWorkerID], intQueueIDX ) --Pop this query off the queue
						self:SetWorkerStatus( self.WORKER_IDLE )

						if #self.m_tblWriteQueue[intWorkerID] > 0 then --We have queued queries, run the next one
							self:PooledQueryWrite( intWorkerID, self.m_tblWriteQueue[intWorkerID][1][1], self.m_tblWriteQueue[intWorkerID][1][2], 1 )
						end
					end
				end
			end )
		else
			--We are already running a query, put this in the queue
			table.insert( self.m_tblWriteQueue[intWorkerID], { strQuery, funcCallback } )
		end
	else --We lost connection, put this in the queue and try to start the reconnect loop
		table.insert( self.m_tblWriteQueue[intWorkerID], { strQuery, funcCallback } )
		self:ReconnectWorker( intWorkerID )
	end
end