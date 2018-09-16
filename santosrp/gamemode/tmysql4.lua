pcall(require, "tmysql4")

local tmysql_loaded = tmysql ~= nil -- Checking the result of "require" doesn't seem to work

local DATABASE = {}

DATABASE.KEYWORD_AUTOINCREMENT = "auto_increment"
DATABASE.QUERY_LISTTABLES = "show tables;"

function DATABASE.IsAvailable() -- Can this database type be used at all?
	return tmysql_loaded
end

function DATABASE:IsConnected()
	return self.db ~= nil
end

function DATABASE:RawDB()
	if not self:IsConnected() then
		self:Connect(self.Config)
		return self.db
	end
	return self.db
end

function DATABASE:Connect(details)
	if not details.user or not details.password or not details.database then
		return false, "TMysql4 connection requires username, password and database"
	end
	local db, err = tmysql.initialize( details.host or "localhost",
								details.user,
								details.password,
								details.database,
								details.port or 3306,
								details.socket or "",
								CLIENT_FOUND_ROWS)

	if not db then
		return false, err
	end
	self.db = db

	return true
end

function DATABASE:RawQuery(onSuccess, onError, fquery)

	local db = self:RawDB()
	if not db then
		FDB.Error("RawDB not available!")
	end

	db:Query(fquery, function(results)
		local res = results[1]

		if not res.status then
			FDB.Warn("Query failed! SQL: " .. fquery .. ". Err: " .. res.error)
			if onError then
				onError(res.error, fquery)
			end
			return
		end

		if res.affected then self.LastAffectedRows = res.affected end
		if res.lastid then self.LastAutoIncrement = res.lastid end

		if onSuccess then onSuccess(res.data) end
	end)
end

function DATABASE:Wait()
	return false
end

function DATABASE:GetInsertedId()
	return self.LastAutoIncrement
end

function DATABASE:GetAffectedRows()
	return self.LastAffectedRows or 0
end

function DATABASE:GetRowCount()
	return self.LastRowCount
end

-- Transaction stuff

-- TODO, we could fake transactions by adding queries to a table until commit/fallback
function DATABASE:StartTransaction()
	return self:BlockingQuery("START TRANSACTION;") ~= false
end

function DATABASE:Commit()
	return self:BlockingQuery("COMMIT;") ~= false
end

function DATABASE:Rollback()
	return self:BlockingQuery("ROLLBACK;") ~= false
end

FDB.RegisterDatabase("tmysql4", DATABASE)