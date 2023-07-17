--[[ $Id: AceDB-3.0.lua 667 2008-06-11 14:34:58Z nevcairiel $ ]]
local ACEDB_MAJOR, ACEDB_MINOR = "AceDB-3.0", 8
local AceDB, oldminor = LibStub:NewLibrary(ACEDB_MAJOR, ACEDB_MINOR)

if not AceDB then return end -- No upgrade needed

local type = type
local pairs, next = pairs, next
local rawget, rawset = rawget, rawset
local setmetatable = setmetatable

AceDB.db_registry = AceDB.db_registry or {}
AceDB.frame = AceDB.frame or CreateFrame("Frame")

local CallbackHandler
local CallbackDummy = { Fire = function() end }

local DBObjectLib = {}

--[[-------------------------------------------------------------------------
	AceDB Utility Functions
---------------------------------------------------------------------------]]

-- Simple shallow copy for copying defaults
local function copyTable(src, dest)
	if type(dest) ~= "table" then dest = {} end
	if type(src) == "table" then
		for k,v in pairs(src) do
			if type(v) == "table" then
				-- try to index the key first so that the metatable creates the defaults, if set, and use that table
				v = copyTable(v, dest[k])
			end
			dest[k] = v
		end
	end
	return dest
end

-- Called to add defaults to a section of the database
--
-- When a ["*"] default section is indexed with a new key, a table is returned
-- and set in the host table.  These tables must be cleaned up by removeDefaults
-- in order to ensure we don't write empty default tables.
local function copyDefaults(dest, src)
	-- this happens if some value in the SV overwrites our default value with a non-table
	--if type(dest) ~= "table" then return end
	for k, v in pairs(src) do
		if k == "*" or k == "**" then
			if type(v) == "table" then
				-- This is a metatable used for table defaults
				local mt = {
					-- This handles the lookup and creation of new subtables
					__index = function(t,k)
							if k == nil then return nil end
							local tbl = {}
							copyDefaults(tbl, v)
							rawset(t, k, tbl)
							return tbl
						end,
				}
				setmetatable(dest, mt)
				-- handle already existing tables in the SV
				for dk, dv in pairs(dest) do
					if not rawget(src, dk) and type(dv) == "table" then
						copyDefaults(dv, v)
					end
				end
			else
				-- Values are not tables, so this is just a simple return
				local mt = {__index = function(t,k) return k~=nil and v or nil end}
				setmetatable(dest, mt)
			end
		elseif type(v) == "table" then
			if not rawget(dest, k) then rawset(dest, k, {}) end
			if type(dest[k]) == "table" then
				copyDefaults(dest[k], v)
				if src['**'] then
					copyDefaults(dest[k], src['**'])
				end
			end
		else
			if rawget(dest, k) == nil then
				rawset(dest, k, v)
			end
		end
	end
end

-- Called to remove all defaults in the default table from the database
local function removeDefaults(db, defaults, blocker)
	for k,v in pairs(defaults) do
		if k == "*" or k == "**" then
			if type(v) == "table" then
				-- Loop through all the actual k,v pairs and remove
				for key, value in pairs(db) do
					if type(value) == "table" then
						-- if the key was not explicitly specified in the defaults table, just strip everything from * and ** tables
						if defaults[key] == nil and (not blocker or blocker[key] == nil) then
							removeDefaults(value, v)
							-- if the table is empty afterwards, remove it
							if not next(value) then
								db[key] = nil
							end
						-- if it was specified, only strip ** content, but block values which were set in the key table
						elseif k == "**" then 
							removeDefaults(value, v, defaults[key])
						end
					end
				end
			elseif k == "*" then
				-- check for non-table default
				for key, value in pairs(db) do
					if defaults[key] == nil and v == value then
						db[key] = nil
					end
				end
			end
		elseif type(v) == "table" and type(db[k]) == "table" then
			-- if a blocker was set, dive into it, to allow multi-level defaults
			removeDefaults(db[k], v, blocker and blocker[k])
			if not next(db[k]) then
				db[k] = nil
			end
		else
			-- check if the current value matches the default, and that its not blocked by another defaults table
			if db[k] == defaults[k] and (not blocker or blocker[k] == nil) then
				db[k] = nil
			end
		end
	end
	-- remove all metatables from the db
	setmetatable(db, nil)
end

-- This is called when a table section is first accessed, to set up the defaults
local function initSection(db, section, svstore, key, defaults)
	local sv = rawget(db, "sv")
	
	local tableCreated
	if not sv[svstore] then sv[svstore] = {} end
	if not sv[svstore][key] then
		sv[svstore][key] = {}
		tableCreated = true
	end
	
	local tbl = sv[svstore][key]
	
	if defaults then
		copyDefaults(tbl, defaults)
	end
	rawset(db, section, tbl)
	
	return tableCreated, tbl
end

-- Metatable to handle the dynamic creation of sections and copying of sections.
local dbmt = {
	__index = function(t, section)
			local keys = rawget(t, "keys")
			local key = keys[section]
			if key then
				local defaultTbl = rawget(t, "defaults")
				local defaults = defaultTbl and defaultTbl[section]
				
				if section == "profile" then
					local new = initSection(t, section, "profiles", key, defaults)
					if new then
						-- Callback: OnNewProfile, database, newProfileKey
						t.callbacks:Fire("OnNewProfile", t, key)
					end
				elseif section == "profiles" then
					local sv = rawget(t, "sv")
					if not sv.profiles then sv.profiles = {} end
					rawset(t, "profiles", sv.profiles)
				elseif section == "global" then
					local sv = rawget(t, "sv")
					if not sv.global then sv.global = {} end
					if defaults then
						copyDefaults(sv.global, defaults)
					end
					rawset(t, section, sv.global)
				else
					initSection(t, section, section, key, defaults)
				end
			end
			
			return rawget(t, section)
		end
}

local function validateDefaults(defaults, keyTbl, offset)
	if not defaults then return end
	offset = offset or 0
	for k in pairs(defaults) do
		if not keyTbl[k] or k == "profiles" then
			error(("Usage: AceDBObject:RegisterDefaults(defaults): '%s' is not a valid datatype."):format(k), 3 + offset)
		end
	end
end

local preserve_keys = {
	["callbacks"] = true,
	["RegisterCallback"] = true,
	["UnregisterCallback"] = true,
	["UnregisterAllCallbacks"] = true,
	["children"] = true,
}

local realmKey = GetRealmName()
local charKey = UnitName("player") .. " - " .. realmKey
local _, classKey = UnitClass("player")
local _, raceKey = UnitRace("player")
local factionKey = UnitFactionGroup("player")
local factionrealmKey = factionKey .. " - " .. realmKey
-- Actual database initialization function
local function initdb(sv, defaults, defaultProfile, olddb, parent)
	-- Generate the database keys for each section
	
	-- Make a container for profile keys
	if not sv.profileKeys then sv.profileKeys = {} end
	
	-- Try to get the profile selected from the char db
	local profileKey = sv.profileKeys[charKey] or defaultProfile or charKey
	sv.profileKeys[charKey] = profileKey
	
	-- This table contains keys that enable the dynamic creation 
	-- of each section of the table.  The 'global' and 'profiles'
	-- have a key of true, since they are handled in a special case
	local keyTbl= {
		["char"] = charKey,
		["realm"] = realmKey,
		["class"] = classKey,
		["race"] = raceKey,
		["faction"] = factionKey,
		["factionrealm"] = factionrealmKey,
		["profile"] = profileKey,
		["global"] = true,
		["profiles"] = true,
	}
	
	validateDefaults(defaults, keyTbl, 1)
	
	-- This allows us to use this function to reset an entire database
	-- Clear out the old database
	if olddb then
		for k,v in pairs(olddb) do if not preserve_keys[k] then olddb[k] = nil end end
	end
	
	-- Give this database the metatable so it initializes dynamically
	local db = setmetatable(olddb or {}, dbmt)
	
	if not rawget(db, "callbacks") then 
		-- try to load CallbackHandler-1.0 if it loaded after our library
		if not CallbackHandler then CallbackHandler = LibStub:GetLibrary("CallbackHandler-1.0", true) end
		db.callbacks = CallbackHandler and CallbackHandler:New(db) or CallbackDummy
	end
	
	-- Copy methods locally into the database object, to avoid hitting
	-- the metatable when calling methods
	
	if not parent then
		for name, func in pairs(DBObjectLib) do
			db[name] = func
		end
	else
		-- hack this one in
		db.RegisterDefaults = DBObjectLib.RegisterDefaults
		db.ResetProfile = DBObjectLib.ResetProfile
	end
	
	-- Set some properties in the database object
	db.profiles = sv.profiles
	db.keys = keyTbl
	db.sv = sv
	--db.sv_name = name
	db.defaults = defaults
	db.parent = parent
	
	-- store the DB in the registry
	AceDB.db_registry[db] = true
	
	return db
end

-- handle PLAYER_LOGOUT
-- strip all defaults from all databases
local function logoutHandler(frame, event)
	if event == "PLAYER_LOGOUT" then
		for db in pairs(AceDB.db_registry) do
			db.callbacks:Fire("OnDatabaseShutdown", db)
			for section, key in pairs(db.keys) do
				if db.defaults and db.defaults[section] and rawget(db, section) then
					removeDefaults(db[section], db.defaults[section])
				end
			end
		end
	end
end

AceDB.frame:RegisterEvent("PLAYER_LOGOUT")
AceDB.frame:SetScript("OnEvent", logoutHandler)


--[[-------------------------------------------------------------------------
	AceDB Object Method Definitions
---------------------------------------------------------------------------]]

-- DBObject:RegisterDefaults(defaults)
-- defaults (table) - A table of defaults for this database
--
-- Sets the defaults table for the given database object by clearing any
-- that are currently set, and then setting the new defaults.
function DBObjectLib:RegisterDefaults(defaults)
	if defaults and type(defaults) ~= "table" then
		error("Usage: AceDBObject:RegisterDefaults(defaults): 'defaults' - table or nil expected.", 2)
	end
	
	validateDefaults(defaults, self.keys)
	
	-- Remove any currently set defaults
	if self.defaults then
		for section,key in pairs(self.keys) do
			if self.defaults[section] and rawget(self, section) then
				removeDefaults(self[section], self.defaults[section])
			end
		end
	end
	
	-- Set the DBObject.defaults table
	self.defaults = defaults
	
	-- Copy in any defaults, only touching those sections already created
	if defaults then
		for section,key in pairs(self.keys) do
			if defaults[section] and rawget(self, section) then
				copyDefaults(self[section], defaults[section])
			end
		end
	end
end

-- DBObject:SetProfile(name)
-- name (string) - The name of the profile to set as the current profile
--
-- Changes the profile of the database and all of it's namespaces to the
-- supplied named profile
function DBObjectLib:SetProfile(name)
	if type(name) ~= "string" then
		error("Usage: AceDBObject:SetProfile(name): 'name' - string expected.", 2)
	end
	
	-- changing to the same profile, dont do anything
	if name == self.keys.profile then return end
	
	local oldProfile = self.profile
	local defaults = self.defaults and self.defaults.profile
	
	if oldProfile and defaults then
		-- Remove the defaults from the old profile
		removeDefaults(oldProfile, defaults)
	end
	
	self.profile = nil
	self.keys["profile"] = name
	self.sv.profileKeys[charKey] = name

	-- populate to child namespaces
	if self.children then
		for _, db in pairs(self.children) do
			DBObjectLib.SetProfile(db, name)
		end
	end
	
	-- Callback: OnProfileChanged, database, newProfileKey
	self.callbacks:Fire("OnProfileChanged", self, name)
end

-- DBObject:GetProfiles(tbl)
-- tbl (table) - A table to store the profile names in (optional)
--
-- Returns a table with the names of the existing profiles in the database.
-- You can optionally supply a table to re-use for this purpose.
function DBObjectLib:GetProfiles(tbl)
	if tbl and type(tbl) ~= "table" then
		error("Usage: AceDBObject:GetProfiles(tbl): 'tbl' - table or nil expected.", 2)
	end

	-- Clear the container table
	if tbl then
		for k,v in pairs(tbl) do tbl[k] = nil end
	else
		tbl = {}
	end

	local curProfile = self.keys.profile
	
	local i = 0
	for profileKey in pairs(self.profiles) do
		i = i + 1
		tbl[i] = profileKey
		if curProfile and profileKey == curProfile then curProfile = nil end
	end

	-- Add the current profile, if it hasn't been created yet
	if curProfile then
		i = i + 1
		tbl[i] = curProfile
	end
	
	return tbl, i
end

-- DBObject:GetCurrentProfile()
--
-- Returns the current profile name used by the database
function DBObjectLib:GetCurrentProfile()
	return self.keys.profile
end

-- DBObject:DeleteProfile(name)
-- name (string) - The name of the profile to be deleted
--
-- Deletes a named profile.  This profile must not be the active profile.
function DBObjectLib:DeleteProfile(name, silent)
	if type(name) ~= "string" then
		error("Usage: AceDBObject:DeleteProfile(name): 'name' - string expected.", 2)
	end
	
	if self.keys.profile == name then
		error("Cannot delete the active profile in an AceDBObject.", 2)
	end
	
	if not rawget(self.sv.profiles, name) and not silent then
		error("Cannot delete profile '" .. name .. "'. It does not exist.", 2)
	end
	
	self.sv.profiles[name] = nil
	
	-- populate to child namespaces
	if self.children then
		for _, db in pairs(self.children) do
			DBObjectLib.DeleteProfile(db, name, true)
		end
	end
	
	-- Callback: OnProfileDeleted, database, profileKey
	self.callbacks:Fire("OnProfileDeleted", self, name)
end

-- DBObject:CopyProfile(name)
-- name (string) - The name of the profile to be copied into the current profile
--
-- Copies a named profile into the current profile, overwriting any conflicting
-- settings.
function DBObjectLib:CopyProfile(name, silent)
	if type(name) ~= "string" then
		error("Usage: AceDBObject:CopyProfile(name): 'name' - string expected.", 2)
	end
	
	if name == self.keys.profile then
		error("Cannot have the same source and destination profiles.", 2)
	end
	
	if not rawget(self.sv.profiles, name) and not silent then
		error("Cannot copy profile '" .. name .. "'. It does not exist.", 2)
	end
	
	-- Reset the profile before copying
	DBObjectLib.ResetProfile(self)
	
	local profile = self.profile
	local source = self.sv.profiles[name]
	
	copyTable(source, profile)
	
	-- populate to child namespaces
	if self.children then
		for _, db in pairs(self.children) do
			DBObjectLib.CopyProfile(db, name, true)
		end
	end
	
	-- Callback: OnProfileCopied, database, sourceProfileKey
	self.callbacks:Fire("OnProfileCopied", self, name)
end

-- DBObject:ResetProfile()
-- noChildren (boolean) - if set to true, the reset will not be populated to the child namespaces of this DB object
--
-- Resets the current profile
function DBObjectLib:ResetProfile(noChildren)
	local profile = self.profile
	
	for k,v in pairs(profile) do
		profile[k] = nil
	end
	
	local defaults = self.defaults and self.defaults.profile
	if defaults then
		copyDefaults(profile, defaults)
	end
	
	-- populate to child namespaces
	if self.children and not noChildren then
		for _, db in pairs(self.children) do
			DBObjectLib.ResetProfile(db)
		end
	end
	
	-- Callback: OnProfileReset, database
	self.callbacks:Fire("OnProfileReset", self)
end

-- DBObject:ResetDB(defaultProfile)
-- defaultProfile (string) - The profile name to use as the default
--
-- Resets the entire database, using the string defaultProfile as the default
-- profile.
function DBObjectLib:ResetDB(defaultProfile)
	if defaultProfile and type(defaultProfile) ~= "string" then
		error("Usage: AceDBObject:ResetDB(defaultProfile): 'defaultProfile' - string or nil expected.", 2)
	end
	
	local sv = self.sv
	for k,v in pairs(sv) do
		sv[k] = nil
	end
	
	local parent = self.parent
	
	initdb(sv, self.defaults, defaultProfile, self)
	
	-- fix the child namespaces
	if self.children then
		if not sv.namespaces then sv.namespaces = {} end
		for name, db in pairs(self.children) do
			if not sv.namespaces[name] then sv.namespaces[name] = {} end
			initdb(sv.namespaces[name], db.defaults, self.keys.profile, db, self)
		end
	end
	
		-- Callback: OnDatabaseReset, database
	self.callbacks:Fire("OnDatabaseReset", self)
	-- Callback: OnProfileChanged, database, profileKey
	self.callbacks:Fire("OnProfileChanged", self, self.keys["profile"])
	
	return self
end

-- DBObject:RegisterNamespace(name [, defaults])
-- name (string) - The name of the new namespace
-- defaults (table) - A table of values to use as defaults
--
-- Creates a new database namespace, directly tied to the database.  This
-- is a full scale database in it's own rights other than the fact that
-- it cannot control its profile individually
function DBObjectLib:RegisterNamespace(name, defaults)
	if type(name) ~= "string" then
		error("Usage: AceDBObject:RegisterNamespace(name, defaults): 'name' - string expected.", 2)
	end
	if defaults and type(defaults) ~= "table" then
		error("Usage: AceDBObject:RegisterNamespace(name, defaults): 'defaults' - table or nil expected.", 2)
	end
	if self.children and self.children[name] then
		error ("Usage: AceDBObject:RegisterNamespace(name, defaults): 'name' - a namespace with that name already exists.", 2)
	end
	
	local sv = self.sv
	if not sv.namespaces then sv.namespaces = {} end
	if not sv.namespaces[name] then
		sv.namespaces[name] = {}
	end
	
	local newDB = initdb(sv.namespaces[name], defaults, self.keys.profile, nil, self)
	
	if not self.children then self.children = {} end
	self.children[name] = newDB
	return newDB
end

--[[-------------------------------------------------------------------------
	AceDB Exposed Methods
---------------------------------------------------------------------------]]

-- AceDB:New(name, defaults, defaultProfile)
-- name (table or string) - The name of variable, or table to use for the database
-- defaults (table) - A table of database defaults
-- defaultProfile (string) - The name of the default profile
--
-- Creates a new database object that can be used to handle database settings
-- and profiles.
function AceDB:New(tbl, defaults, defaultProfile)
	if type(tbl) == "string" then
		local name = tbl
		tbl = getglobal(name)
		if not tbl then
			tbl = {}
			setglobal(name, tbl)
		end
	end
	
	if type(tbl) ~= "table" then
		error("Usage: AceDB:New(tbl, defaults, defaultProfile): 'tbl' - table expected.", 2)
	end
	
	if defaults and type(defaults) ~= "table" then
		error("Usage: AceDB:New(tbl, defaults, defaultProfile): 'defaults' - table expected.", 2)
	end
	
	if defaultProfile and type(defaultProfile) ~= "string" then
		error("Usage: AceDB:New(tbl, defaults, defaultProfile): 'defaultProfile' - string expected.", 2)
	end
	
	return initdb(tbl, defaults, defaultProfile)
end

-- upgrade existing databases
for db in pairs(AceDB.db_registry) do
	if not db.parent then
		for name,func in pairs(DBObjectLib) do
			db[name] = func
		end
	else
		db.RegisterDefaults = DBObjectLib.RegisterDefaults
	end
end
