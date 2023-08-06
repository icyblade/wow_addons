local GatherMate = LibStub("AceAddon-3.0"):GetAddon("GatherMate2")
local Config = GatherMate:NewModule("Config","AceEvent-3.0")
local Display = GatherMate:GetModule("Display")
local L = LibStub("AceLocale-3.0"):GetLocale("GatherMate2", false)

-- Databroker support
local DataBroker = LibStub:GetLibrary("LibDataBroker-1.1",true)

--[[
	Code here for configuring the mod, and making the minimap button
]]

-- Setup keybinds (these need to be global strings to show up properly in ESC -> Key Bindings)
BINDING_HEADER_GatherMate = "GatherMate2"
BINDING_NAME_TOGGLE_GATHERMATE2_MINIMAPICONS = L["Keybind to toggle Minimap Icons"]

-- A helper function for keybindings
local KeybindHelper = {}
do
	local t = {}
	function KeybindHelper:MakeKeyBindingTable(...)
		for k in pairs(t) do t[k] = nil end
		for i = 1, select("#", ...) do
			local key = select(i, ...)
			if key ~= "" then
				tinsert(t, key)
			end
		end
		return t
	end
end


local prof_options = {
	always          = L["Always show"],
	with_profession = L["Only with profession"],
	active          = L["Only while tracking"],
	never           = L["Never show"],
}
local prof_options2 = { -- For Gas, which doesn't have tracking as a skill
	always           = L["Always show"],
	with_profession  = L["Only with profession"],
	never            = L["Never show"],
}
local prof_options3 = {
	always          = L["Always show"],
	active          = L["Only while tracking"],
	never           = L["Never show"],
}
local prof_options4 = { -- For Archaeology, which doesn't have tracking as a skill
	always           = L["Always show"],
	active			 = L["Only with digsite"],
	with_profession  = L["Only with profession"],
	never            = L["Never show"],
}

local db
local imported = {}
-- setup the options, we need to reference GatherMate for this

local function get(k) return db[k.arg] end
local function set(k, v) db[k.arg] = v; Config:UpdateConfig(); end

local generalOptions = {
	type = "group",
	get = function(k) return db.show[k.arg] end,
	set = function(k, v) db.show[k.arg] = v; Config:UpdateConfig(); end,
	args = {
		desc = {
			order = 0,
			type = "description",
			name = L["Selected databases are shown on both the World Map and Minimap."],
		},
		showMinerals = {
			order = 1,
			name = L["Show Mining Nodes"],
			desc = L["Toggle showing mining nodes."],
			type = "select",
			values = prof_options,
			arg = "Mining"
		},
		showHerbs = {
			order = 2,
			name = L["Show Herbalism Nodes"],
			desc = L["Toggle showing herbalism nodes."],
			type = "select",
			values = prof_options,
			arg = "Herb Gathering"
		},
		showFishes = {
			order = 3,
			name = L["Show Fishing Nodes"],
			desc = L["Toggle showing fishing nodes."],
			type = "select",
			values = prof_options,
			arg = "Fishing"
		},
		showGases = {
			order = 4,
			name = L["Show Gas Clouds"],
			desc = L["Toggle showing gas clouds."],
			type = "select",
			values = prof_options2,
			arg = "Extract Gas"
		},
		showTreasure = {
			order = 5,
			name = L["Show Treasure Nodes"],
			desc = L["Toggle showing treasure nodes."],
			type = "select",
			values = prof_options3,
			arg = "Treasure"
		},
		showArchaeology = {
			order = 6,
			name = L["Show Archaeology Nodes"],
			desc = L["Toggle showing archaeology nodes."],
			type = "select",
			values = prof_options4,
			arg = "Archaeology"
		},
	},
}

local minimapOptions = {
	type = "group",
	get = get,
	set = set,
	args = {
		desc = {
			order = 0,
			type = "description",
			name = L["Control various aspects of node icons on both the World Map and Minimap."],
		},
		showMinimapIcons = {
			order = 1,
			name = L["Show Minimap Icons"],
			desc = L["Toggle showing Minimap icons."],
			type = "toggle",
			arg = "showMinimap",
		},
		showWorldMapIcons = {
			order = 2,
			name = L["Show World Map Icons"],
			desc = L["Toggle showing World Map icons."],
			type = "toggle",
			arg = "showWorldMap",
		},
		minimapTooltips = {
			order = 3,
			name = L["Minimap Icon Tooltips"],
			desc = L["Toggle showing Minimap icon tooltips."],
			type = "toggle",
			arg = "minimapTooltips",
			disabled = function() return not db.showMinimap end,
		},
		minimapNodeRange = {
			order = 4,
			type = "toggle",
			name = L["Show Nodes on Minimap Border"],
			desc = L["Shows more Nodes that are currently out of range on the minimap's border."],
			arg = "nodeRange",
		},
		togglekey = {
			order = 5,
			name = L["Keybind to toggle Minimap Icons"],
			desc = L["Keybind to toggle Minimap Icons"],
			type = "keybinding",
			width = "full",
			get = function(info)
				return table.concat(KeybindHelper:MakeKeyBindingTable(GetBindingKey("TOGGLE_GATHERMATE2_MINIMAPICONS")), ", ")
			end,
			set = function(info, key)
				if key == "" then
					local t = KeybindHelper:MakeKeyBindingTable(GetBindingKey("TOGGLE_GATHERMATE2_MINIMAPICONS"))
					for i = 1, #t do
						SetBinding(t[i])
					end
				else
					local oldAction = GetBindingAction(key)
					local frame = LibStub("AceConfigDialog-3.0").OpenFrames["GatherMate"]
					if frame then
						if ( oldAction ~= "" and oldAction ~= "TOGGLE_GATHERMATE2_MINIMAPICONS" ) then
							frame:SetStatusText(KEY_UNBOUND_ERROR:format(GetBindingText(oldAction, "BINDING_NAME_")))
						else
							frame:SetStatusText(KEY_BOUND)
						end
					end
					SetBinding(key, "TOGGLE_GATHERMATE2_MINIMAPICONS")
				end
				SaveBindings(GetCurrentBindingSet())
			end,
		},
		iconScale = {
			order = 10,
			name = L["World Map Icon Scale"],
			desc = L["Icon scaling, this lets you enlarge or shrink your icons on the World Map."],
			type = "range",
			min = 0.5, max = 5, step = 0.01,
			arg = "scale",
		},
		miconScale = {
			order = 11,
			name = L["Minimap Icon Scale"],
			desc = L["Icon scaling, this lets you enlarge or shrink your icons on the Minimap."],
			type = "range",
			min = 0.5, max = 5, step = 0.01,
			arg = "miniscale",
		},
		iconAlpha = {
			order = 12,
			name = L["Icon Alpha"],
			desc = L["Icon alpha value, this lets you change the transparency of the icons. Only applies on World Map."],
			type = "range",
			min = 0.1, max = 1, step = 0.05,
			arg = "alpha",
		},
		tracking = {
			order = 20,
			name = L["Tracking Circle Color"],
			desc = L["Color of the tracking circle."],
			type = "group",
			inline = true,
			get = function(info)
				local t = db.trackColors[info.arg]
				return t.Red, t.Green, t.Blue, t.Alpha
			end,
			set = function(info, r, g, b, a)
				local t = db.trackColors[info.arg]
				t.Red = r
				t.Green = g
				t.Blue = b
				t.Alpha = a
				Config:UpdateConfig()
			end,
			args = {
				trackingColorMine = {
					order = 1,
					name = L["Mineral Veins"],
					desc = L["Color of the tracking circle."],
					type = "color",
					hasAlpha = true,
					arg = "Mining",
				},
				trackingColorHerb = {
					order = 2,
					name = L["Herb Bushes"],
					desc = L["Color of the tracking circle."],
					type = "color",
					hasAlpha = true,
					arg = "Herb Gathering",
				},
				trackingColorFish = {
					order = 3,
					name = L["Fishing"],
					desc = L["Color of the tracking circle."],
					type = "color",
					hasAlpha = true,
					arg = "Fishing",
				},
				trackingColorGas = {
					order = 4,
					name = L["Gas Clouds"],
					desc = L["Color of the tracking circle."],
					type = "color",
					hasAlpha = true,
					arg = "Extract Gas",
				},
				trackingColorTreasure = {
					order = 6,
					name = L["Treasure"],
					desc = L["Color of the tracking circle."],
					type = "color",
					hasAlpha = true,
					arg = "Treasure",
				},
				trackingColorArchaelogy = {
					order = 7,
					name = L["Archaeology"],
					desc = L["Color of the tracking circle."],
					type = "color",
					hasAlpha = true,
					arg = "Archaeology",
				},
				space = {
					order = 10,
					name = "",
					desc = "",
					type = "description",
					width = "full",
				},
				trackDistance = {
					order = 15,
					name = L["Tracking Distance"],
					desc = L["The distance in yards to a node before it turns into a tracking circle"],
					type = "range",
					min = 50, max = 240, step = 5,
					get = get,
					set = set,
					arg = "trackDistance",
				},
				trackShow = {
					order = 20,
					name = L["Show Tracking Circle"],
					desc = L["Toggle showing the tracking circle."],
					type = "select",
					get = get,
					set = set,
					values = prof_options,
					arg = "trackShow",
				},
			},
		},
	},
}

-- Setup some storage arrays by db to sort node names and zones alphabetically
local withLvlFormat = "(%d) %s"
local delocalizedZones = {}
local denormalizedNames = {}
local sortedFilter = setmetatable({}, {__index = function(t, k)
	local new = {}
	table.wipe(delocalizedZones)
	if k == "zones" then
		for index, zoneID in pairs(GatherMate.mapData:GetAllMapIDs()) do
			local name = GatherMate.mapData:MapLocalize(zoneID)
			new[name] = name
			delocalizedZones[name] = zoneID
		end
	else
		local map = GatherMate.nodeIDs[k]
		for name in pairs(map) do
			local idx = #new+1
			new[idx] = name
			denormalizedNames[name] = name
		end
		local minSkill = GatherMate.nodeMinHarvest[k]
		if minSkill then
			-- We only end up creating one function per tracked type anyway
			table.sort(new, function(a, b)
				local mA, mB = minSkill[map[a]], minSkill[map[b]]
				if mA == mB then return map[a] > map[b]
				else return mA > mB end
			end)
			for i, v in next, new do
				new[i] = withLvlFormat:format(minSkill[map[v]], v)
				denormalizedNames[new[i]] = v
			end
		else
			table.sort(new)
		end
	end
	rawset(t, k, new)
	return new
end})

-- Setup some helper functions
local ConfigFilterHelper = {}
function ConfigFilterHelper:SelectAll(info)
	local db = db.filter[info.arg]
	local nids = GatherMate.nodeIDs[info.arg]
	for k, v in pairs(nids) do
		db[v] = true
	end
	Config:UpdateConfig()
end
function ConfigFilterHelper:SelectNone(info)
	local db = db.filter[info.arg]
	local nids = GatherMate.nodeIDs[info.arg]
	for k, v in pairs(nids) do
		db[v] = false
	end
	Config:UpdateConfig()
end
function ConfigFilterHelper:SetState(info, nodeIndex, state)
	local nodeName = sortedFilter[info.arg][nodeIndex]
	if nodeName:find("^%(%d+%)") then nodeName = nodeName:match("^%(%d+%) (.*)$") end
	db.filter[info.arg][GatherMate.nodeIDs[info.arg][nodeName]] = state
	Config:UpdateConfig()
end
function ConfigFilterHelper:GetState(info, nodeIndex)
	local nodeName = sortedFilter[info.arg][nodeIndex]
	if nodeName:find("^%(%d+%)") then nodeName = nodeName:match("^%(%d+%) (.*)$") end
	return db.filter[info.arg][GatherMate.nodeIDs[info.arg][nodeName]]
end

local ImportHelper = {}

function ImportHelper:GetImportStyle(info,k)
	return db["importers"][info.arg].Style
end
function ImportHelper:SetImportStyle(info,k,state)
	db["importers"][info.arg].Style = k
end
function ImportHelper:GetImportDatabase(info,k)
	return db["importers"][info.arg].Databases[k]
end
function ImportHelper:SetImportDatabase(info,k,state)
	db["importers"][info.arg].Databases[k] = state
end
function ImportHelper:GetAutoImport(info, k)
	return db["importers"][info.arg].autoImport
end
function ImportHelper:SetAutoImport(info,state)
	db["importers"][info.arg].autoImport = state
end
function ImportHelper:GetBCOnly(info,k)
	return db["importers"][info.arg].bcOnly
end
function ImportHelper:SetBCOnly(info,state)
	db["importers"][info.arg].bcOnly = state
end
function ImportHelper:GetExpacOnly(info,k)
	return db["importers"][info.arg].expacOnly
end
function ImportHelper:SetExpacOnly(info,state)
	db["importers"][info.arg].expacOnly = state
end
function ImportHelper:GetExpac(info,k)
	return db["importers"][info.arg].expac
end
function ImportHelper:SetExpac(info,state)
	db["importers"][info.arg].expac = state
end

local filterOptions = {
	type = "group",
	name = L["Filters"],
	order = 2,
	get = get,
	set = set,
	childGroups = "tab",
	handler = ConfigFilterHelper,
	args = {
		heading = {
			order = 0,
			type = "description",
			name = L["Filter_Desc"],
			width = "full",
		},
	},
}
filterOptions.args.herbs = {
	type = "group",
	name = L["Herbalism"],
	desc = L["Select the herb nodes you wish to display."],
	args = {
		select_all = {
			order = 1,
			name = L["Select All"],
			desc = L["Select all nodes"],
			type = "execute",
			func = "SelectAll",
			arg = "Herb Gathering",
		},
		select_none = {
			order = 2,
			desc = L["Clear node selections"],
			name = L["Select None"],
			type = "execute",
			func = "SelectNone",
			arg = "Herb Gathering",
		},
		herblist = {
			order = 3,
			name = L["Herb Bushes"],
			type = "multiselect",
			values = sortedFilter["Herb Gathering"],
			set = "SetState",
			get = "GetState",
			arg = "Herb Gathering",
		},
	},
}
filterOptions.args.mines = {
	type = "group",
	name = L["Mining"],
	desc = L["Select the mining nodes you wish to display."],
	args = {
		select_all = {
			order = 1,
			name = L["Select All"],
			desc = L["Select all nodes"],
			type = "execute",
			func = "SelectAll",
			arg = "Mining",
		},
		select_none = {
			order = 2,
			desc = L["Clear node selections"],
			name = L["Select None"],
			type = "execute",
			func = "SelectNone",
			arg = "Mining",
		},
		minelist = {
			order = 3,
			name = L["Mineral Veins"],
			type = "multiselect",
			values = sortedFilter["Mining"],
			set = "SetState",
			get = "GetState",
			arg = "Mining",
		},
	},
}
filterOptions.args.fish = {
	type = "group",
	name = L["Fishing"],
	args = {
		select_all = {
			order = 1,
			name = L["Select All"],
			desc = L["Select all nodes"],
			type = "execute",
			func = "SelectAll",
			arg = "Fishing",
		},
		select_none = {
			order = 2,
			desc = L["Clear node selections"],
			name = L["Select None"],
			type = "execute",
			func = "SelectNone",
			arg = "Fishing",
		},
		fishlist = {
			order = 3,
			name = L["Fishes"],
			type = "multiselect",
			desc = L["Select the fish nodes you wish to display."],
			values = sortedFilter["Fishing"],
			set = "SetState",
			get = "GetState",
			arg = "Fishing",
		},
	},
}
filterOptions.args.gas = {
	type = "group",
	name = L["Gas Clouds"],
	args = {
		select_all = {
			order = 1,
			name = L["Select All"],
			desc = L["Select all nodes"],
			type = "execute",
			func = "SelectAll",
			arg = "Extract Gas",
		},
		select_none = {
			order = 2,
			name = L["Select None"],
			desc = L["Clear node selections"],
			type = "execute",
			func = "SelectNone",
			arg = "Extract Gas",
		},
		gaslist = {
			order = 3,
			name = L["Gas Clouds"],
			desc = L["Select the gas clouds you wish to display."],
			type = "multiselect",
			values = sortedFilter["Extract Gas"],
			set = "SetState",
			get = "GetState",
			arg = "Extract Gas",
		},
	},
}
filterOptions.args.treasure = {
	type = "group",
	name = L["Treasure"],
	args = {
		select_all = {
			order = 1,
			name = L["Select All"],
			desc = L["Select all nodes"],
			type = "execute",
			func = "SelectAll",
			arg = "Treasure",
		},
		select_none = {
			order = 2,
			name = L["Select None"],
			desc = L["Clear node selections"],
			type = "execute",
			func = "SelectNone",
			arg = "Treasure",
		},
		treasurelist = {
			order = 3,
			name = L["Treasure"],
			desc = L["Select the treasure you wish to display."],
			type = "multiselect",
			values = sortedFilter["Treasure"],
			set = "SetState",
			get = "GetState",
			arg = "Treasure",
		},
	},
}
filterOptions.args.archaeology = {
	type = "group",
	name = L["Archaeology"],
	args = {
		select_all = {
			order = 1,
			name = L["Select All"],
			desc = L["Select all nodes"],
			type = "execute",
			func = "SelectAll",
			arg = "Archaeology",
		},
		select_none = {
			order = 2,
			name = L["Select None"],
			desc = L["Clear node selections"],
			type = "execute",
			func = "SelectNone",
			arg = "Archaeology",
		},
		diglist = {
			order = 3,
			name = L["Archaeology"],
			desc = L["Select the archaeology nodes you wish to display."],
			type = "multiselect",
			values = sortedFilter["Archaeology"],
			set = "SetState",
			get = "GetState",
			arg = "Archaeology",
		},
	},
}

local selectedDatabase, selectedNode, selectedZone = "Extract Gas", 0, nil

-- Cleanup config tree
local maintenanceOptions = {
	type = "group",
	name = L["Database Maintenance"],
	get = get,
	set = set,
	args = {
		desc = {
			order = 1,
			type = "description",
			name = L["Cleanup_Desc"],
		},
		cleanup = {
			name = L["Cleanup Database"],
			desc = L["Cleanup your database by removing duplicates. This takes a few moments, be patient."],
			type = "execute",
			handler = GatherMate,
			func = "CleanupDB",
			order = 5,
			width = "full",
		},
		cleanup_range = {
			order = 10,
			name = L["Cleanup radius"],
			type = "group",
			get = function(info)
				return db.cleanupRange[info.arg]
			end,
			set = function(info, v)
				db.cleanupRange[info.arg] = v
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["CLEANUP_RADIUS_DESC"],
				},
				Mine = {
					order = 5,
					name = L["Mineral Veins"],
					desc = L["Cleanup radius"],
					type = "range",
					min = 0, max = 30, step = 1,
					arg = "Mining",
				},
				Herb = {
					order = 5,
					name = L["Herb Bushes"],
					desc = L["Cleanup radius"],
					type = "range",
					min = 0, max = 30, step = 1,
					arg = "Herb Gathering",
				},
				Fish = {
					order = 5,
					name = L["Fishes"],
					desc = L["Cleanup radius"],
					type = "range",
					min = 0, max = 30, step = 1,
					arg = "Fishing",
				},
				Gas = {
					order = 5,
					name = L["Gas Clouds"],
					desc = L["Cleanup radius"],
					type = "range",
					min = 0, max = 100, step = 1,
					arg = "Extract Gas",
				},
				Treasure = {
					order = 5,
					name = L["Treasure"],
					desc = L["Cleanup radius"],
					type = "range",
					min = 0, max = 30, step = 1,
					arg = "Treasure",
				},
				Archaeology = {
					order = 5,
					name = L["Archaeology"],
					desc = L["Cleanup radius"],
					type = "range",
					min = 0, max = 30, step = 1,
					arg = "Archaeology",
				}
			},
		},
		deleteSelective = {
			order = 20,
			name = L["Delete Specific Nodes"],
			type = "group",
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["DELETE_SPECIFIC_DESC"],
				},
				selectDB = {
					order = 30,
					name = L["Select Database"],
					desc = L["Select Database"],
					type = "select",
					values = {
						["Fishing"] = L["Fishes"],
						["Treasure"] = L["Treasure"],
						["Herb Gathering"] = L["Herb Bushes"],
						["Mining"] = L["Mineral Veins"],
						["Extract Gas"] = L["Gas Clouds"],
						["Archaeology"] = L["Archaeology"],
					},
					get = function() return selectedDatabase end,
					set = function(k, v)
						selectedDatabase = v
						selectedNode = 0
					end,
				},
				selectNode = {
					order = 40,
					name = L["Select Node"],
					desc = L["Select Node"],
					type = "select",
					values = function()
						return sortedFilter[selectedDatabase]
					end,
					get = function() return selectedNode end,
					set = function(k, v) selectedNode = v end,
				},
				selectZone = {
					order = 50,
					name = L["Select Zone"],
					desc = L["Select Zone"],
					type = "select",
					values = sortedFilter["zones"],
					get = function() return selectedZone end,
					set = function(k, v) selectedZone = v end,
				},
				delete = {
					order = 60,
					name = L["Delete"],
					desc = L["Delete selected node from selected zone"],
					type = "execute",
					confirm = true,
					confirmText = L["Are you sure you want to delete all of the selected node from the selected zone?"],
					func = function()
						if selectedZone and selectedNode ~= 0 then
							local nodeName = sortedFilter[selectedDatabase][selectedNode]
							nodeName = denormalizedNames[nodeName]
							GatherMate:DeleteNodeFromZone(selectedDatabase, GatherMate.nodeIDs[selectedDatabase][nodeName], delocalizedZones[selectedZone])
						end
					end,
					disabled = function()
						return selectedNode == 0 or selectedZone == nil
					end,
				},
			},
		},
		delete = {
			order = 30,
			name = L["Delete Entire Database"],
			type = "group",
			func = function(info)
				GatherMate:ClearDB(info.arg)
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["DELETE_ENTIRE_DESC"],
				},
				Mine = {
					order = 5,
					name = L["Mineral Veins"],
					desc = L["Delete Entire Database"],
					type = "execute",
					arg = "Mining",
					confirm = true,
					confirmText = L["Are you sure you want to delete all nodes from this database?"],
				},
				Herb = {
					order = 5,
					name = L["Herb Bushes"],
					desc = L["Delete Entire Database"],
					type = "execute",
					arg = "Herb Gathering",
					confirm = true,
					confirmText = L["Are you sure you want to delete all nodes from this database?"],
				},
				Fish = {
					order = 5,
					name = L["Fishes"],
					desc = L["Delete Entire Database"],
					type = "execute",
					arg = "Fishing",
					confirm = true,
					confirmText = L["Are you sure you want to delete all nodes from this database?"],
				},
				Gas = {
					order = 5,
					name = L["Gas Clouds"],
					desc = L["Delete Entire Database"],
					type = "execute",
					arg = "Extract Gas",
					confirm = true,
					confirmText = L["Are you sure you want to delete all nodes from this database?"],
				},
				Treasure = {
					order = 5,
					name = L["Treasure"],
					desc = L["Delete Entire Database"],
					type = "execute",
					arg = "Treasure",
					confirm = true,
					confirmText = L["Are you sure you want to delete all nodes from this database?"],
				},
				Archaeology = {
					order = 5,
					name = L["Archaeology"],
					desc = L["Delete Entire Database"],
					type = "execute",
					arg = "Archaeology",
					confirm = true,
					confirmText = L["Are you sure you want to delete all nodes from this database?"],
				},
			},
		},
		dblocking = {
			order = 11,
			name = L["Database Locking"],
			type = "group",
			get = function(info)
				return db.dbLocks[info.arg]
			end,
			set = function(info,v)
				db.dbLocks[info.arg] = v
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["DATABASE_LOCKING_DESC"],
				},
				Mine = {
					order = 5,
					name = L["Mineral Veins"],
					desc = L["Database locking"],
					type = "toggle",
					arg = "Mining",
				},
				Herb = {
					order = 5,
					name = L["Herb Bushes"],
					desc = L["Database locking"],
					type = "toggle",
					arg = "Herb Gathering",
				},
				Fish = {
					order = 5,
					name = L["Fishes"],
					desc = L["Database locking"],
					type = "toggle",
					arg = "Fishing",
				},
				Gas = {
					order = 5,
					name = L["Gas Clouds"],
					desc = L["Database locking"],
					type = "toggle",
					arg = "Extract Gas",
				},
				Treasure = {
					order = 5,
					name = L["Treasure"],
					desc = L["Database locking"],
					type = "toggle",
					arg = "Treasure",
				},
				Archaeology = {
					order = 5,
					name = L["Archaeology"],
					desc = L["Database locking"],
					type = "toggle",
					arg = "Archaeology",
				}
			}
		},
	},
}


-- GatherMateData Import config tree
local importOptions = {
	type = "group",
	name = L["Import Data"],
	order = 10,
	args = {},
	get = get,
	set = set,
	childGroups = "tab",
}
ImportHelper.db_options = {
	["Merge"] = L["Merge"],
	["Overwrite"] = L["Overwrite"]
}
ImportHelper.db_tables = {
	["Herbs"] = L["Herbalism"],
	["Mines"] = L["Mining"],
	["Gases"] = L["Gas Clouds"],
	["Fish"] = L["Fishing"],
	["Treasure"] = L["Treasure"],
	["Archaeology"] = L["Archaeology"],
}
ImportHelper.expac_data = {
	["TBC"] = L["The Burning Crusades"],
	["WRATH"] = L["Wrath of the Lich King"],
	["CATACLYSM"] = L["Cataclysm"],
}
imported["GatherMate2_Data"] = false
importOptions.args.GatherMateData = {
	type = "group",
	name = "GatherMate2Data", -- addon name to import from, don't localize
	handler = ImportHelper,
	disabled = function()
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo("GatherMate2_Data")
		-- disable if the addon is not enabled, or
		-- disable if there is a reason why it can't be loaded ("MISSING" or "DISABLED")
		return not enabled or (reason ~= nil)
	end,
	args = {
		desc = {
			order = 0,
			type = "description",
			name = L["Importing_Desc"],
		},
		loadType = {
			order = 1,
			name = L["Import Style"],
			desc = L["Merge will add GatherMate2Data to your database. Overwrite will replace your database with the data in GatherMate2Data"],
			type = "select",
			values = ImportHelper.db_options,
			set = "SetImportStyle",
			get = "GetImportStyle",
			arg = "GatherMate2_Data",
		},
		loadDatabase = {
			order = 2,
			name = L["Databases to Import"],
			desc = L["Databases you wish to import"],
			type = "multiselect",
			values = ImportHelper.db_tables,
			set = "SetImportDatabase",
			get = "GetImportDatabase",
			arg = "GatherMate2_Data",
		},
		stylebox = {
			order = 4,
			type = "group",
			name = L["Import Options"],
			inline = true,
			args = {
				loadExpacToggle = {
					order = 4,
					name = L["Expansion Data Only"],
					type = "toggle",
					get = "GetExpacOnly",
					set = "SetExpacOnly",
					arg = "GatherMate2_Data"
				},
				loadExpansion = {
					order = 4,
					name = L["Expansion"],
					desc = L["Only import selected expansion data from WoWhead"],
					type = "select",
					get  = "GetExpac",
					set  = "SetExpac",
					values = ImportHelper.expac_data,
					arg  = "GatherMate2_Data",
				},
				loadAuto = {
					order = 5,
					name = L["Auto Import"],
					desc = L["Automatically import when ever you update your data module, your current import choice will be used."],
					type = "toggle",
					get = "GetAutoImport",
					set = "SetAutoImport",
					arg = "GatherMate2_Data",
				},
			}
		},
		loadData = {
			order = 8,
			name = L["Import GatherMate2Data"],
			desc = L["Load GatherMate2Data and import the data to your database."],
			type = "execute",
			func = function()
				local loaded, reason = LoadAddOn("GatherMate2_Data")
				local GatherMateData = LibStub("AceAddon-3.0"):GetAddon("GatherMate2_Data")
				if loaded then
					local dataVersion = tonumber(GatherMateData.generatedVersion:match("%d+"))
					local filter = nil
					if db.importers["GatherMate2_Data"].expacOnly then
						filter = db.importers["GatherMate2_Data"].expac
					end
					GatherMateData:PerformMerge(db.importers["GatherMate2_Data"].Databases,db.importers["GatherMate2_Data"].Style,filter)
					GatherMateData:CleanupImportData()
					print(L["GatherMate2Data has been imported."])
					Config:SendMessage("GatherMate2ConfigChanged")
					db["importers"]["GatherMate2_Data"]["lastImport"] = dataVersion
					imported["GatherMate2_Data"] = true
				else
					print(L["Failed to load GatherMateData due to "]..reason)
				end
			end,
			disabled = function()
				local cm = 0
				if db["importers"]["GatherMate2_Data"].Databases["Mines"] then cm = 1 end
				if db["importers"]["GatherMate2_Data"].Databases["Herbs"] then cm = 1 end
				if db["importers"]["GatherMate2_Data"].Databases["Gases"] then cm = 1 end
				if db["importers"]["GatherMate2_Data"].Databases["Fish"] then cm = 1 end
				if db["importers"]["GatherMate2_Data"].Databases["Treasure"] then cm = 1 end
				if db["importers"]["GatherMate2_Data"].Databases["Archaeology"] then cm = 1 end
				return imported["GatherMate2_Data"] or (cm == 0 and not imported["GatherMate2_Data"])
			end,
		}
	},
}

local faqOptions = {
	type = "group",
	name = L["Frequently Asked Questions"],
	args = {
		desc = {
			type = "description",
			name = L["FAQ_TEXT"],
			width = "full",
			fontSize = "medium",
		},
	},
}
local ConversionHelper = {}
ConversionHelper.dbList = {}
ConversionHelper.zoneList = {}
ConversionHelper.importZones = {}
ConversionHelper.importDBs = {}
ConversionHelper.dbList["Fishing"] = L["Fishing"]
ConversionHelper.dbList["Treasure"] = L["Treasure"]
ConversionHelper.dbList["Herb Gathering"] = L["Herb Bushes"]
ConversionHelper.dbList["Mining"] = L["Mineral Veins"]
ConversionHelper.dbList["Extract Gas"] = L["Gas Clouds"]

function ConversionHelper:DBSelectAll()
	for k,v in pairs(self.dbList) do
		self.importDBs[k]=true
	end
	Config:UpdateConfig()
end

function ConversionHelper:DBSelectNone()
	for k,v in pairs(self.dbList) do
		self.importDBs[k]=false
	end
	Config:UpdateConfig()
end

function ConversionHelper:ZoneSelectAll()
	for k,v in pairs(self.zoneList) do
		self.importZones[k]=true
	end
	Config:UpdateConfig()
end

function ConversionHelper:ZoneSelectNone()
	for k,v in pairs(self.zoneList) do
		self.importZones[k]=false
	end
	Config:UpdateConfig()
end


function ConversionHelper:PopulateZoneList()
	local continentList = {GetMapContinents()}
	for cID = 1, #continentList do
		for zID, zname in ipairs({GetMapZones(cID)}) do
			SetMapZoom(cID, zID)
			local mapfile = GetMapInfo()
			local lname = GatherMate.mapData:MapLocalize(mapfile)
			ConversionHelper.zoneList[mapfile] = lname
		end
	end
end

function ConversionHelper:GetSelectedDB(info,k)
	return self.importDBs[k]
end
function ConversionHelper:SetSelectedDB(info, k , state)
	self.importDBs[k] = state
end
function ConversionHelper:GetSelectedZone(info,k)
	return self.importZones[k]
end
function ConversionHelper:SetSelectedZone(info, k , state)
	self.importZones[k] = state
end

function ConversionHelper:ConvertDatabase()
	local GM1 = LibStub("AceAddon-3.0"):GetAddon("GatherMate")
	for nodeType,nodeName in pairs(self.importDBs) do
		for zone,zoneLocal in pairs(self.importZones) do
			for coord, nodeID in GM1:GetNodesForZone(self.zoneList[zone], nodeType) do
				-- We should decode the location here and add it to the new DB with default level of 0
				local x,y = GM1:getXY(coord)
				-- Now encoded it to the new format
				local newcoord = GatherMate.mapData:EncodeLoc(x,y,0)
				GatherMate:InjectNode(GatherMate.mapData:MapAreaId(zone), newcoord ,nodeType, nodeID)
			end
		end
	end
	print(L["GatherMate data has been imported."])
end

ConversionHelper:PopulateZoneList()
-- Legacy GatherMate Data

importOptions.args.LegacyData = {
	type = "group",
	name = L["GatherMate Conversion"], -- addon name to import from, don't localize
	handler = ConversionHelper,
	disabled = function()
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo("GatherMate")
		-- disable if the addon is not enabled, or
		-- disable if there is a reason why it can't be loaded ("MISSING" or "DISABLED")
		return not enabled or (reason ~= nil)
	end,
	args = {
		desc = {
			order = 0,
			type = "description",
			name = L["Conversion_Desc"],
		},
		dbSelection = {
			order = 1,
			type = "group",
			name = "",
			guiInline = true,
			args = {
				selectDBs = {
					order = 1,
					name = L["Select Databases"],
					desc = L["Select Databases"],
					type = "multiselect",
					values = ConversionHelper.dbList,
					get = "GetSelectedDB",
					set = "SetSelectedDB",
				},
				select_all = {
					order = 2,
					name = L["Select All"],
					desc = L["Select all databases"],
					type = "execute",
					func = "DBSelectAll",
				},
				select_none = {
					order = 2,
					name = L["Select None"],
					desc = L["Clear database selections"],
					type = "execute",
					func = "DBSelectNone",
				},
			},
		},
		zoneSelection = {
			order = 2,
			type = "group",
			name = "Select Zones",
			guiInline = true,
			args = {
				zones = {
					order = 1,
					name = "",
					desc = L["Select Zones"],
					type = "multiselect",
					values = ConversionHelper.zoneList,
					get = "GetSelectedZone",
					set = "SetSelectedZone",
				},
				select_all = {
					order = 2,
					name = L["Select All"],
					desc = L["Select all zones"],
					type = "execute",
					func = "ZoneSelectAll",
				},
				select_none = {
					order = 2,
					name = L["Select None"],
					desc = L["Clear zone selections"],
					type = "execute",
					func = "ZoneSelectNone",
				},
			},
		},
		conversionAction = {
			order = 99,
			type = "execute",
			name = L["Convert Databses"],
			desc = L["Conversion_Desc"],
			func = "ConvertDatabase",
			disabled = function()
				local dbCount = 0
				local zoneCount = 0
				for k,v in pairs(ConversionHelper.importDBs) do
					if v then dbCount = dbCount + 1 end
				end
				for k,v in pairs(ConversionHelper.importZones) do
					if v then zoneCount = zoneCount + 1 end
				end
				return dbCount == 0 or zoneCount == 0
			end
		}
	},
}


--[[
	Initialize the Config System
]]

local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")

local function findPanel(name, parent)
	for i, button in next, InterfaceOptionsFrameAddOns.buttons do
		if button.element then
			if name and button.element.name == name then return button
			elseif parent and button.element.parent == parent then return button
			end
		end
	end
end
function Config:OnInitialize()
	db = GatherMate.db.profile

	self.importHelper = ImportHelper

	acr:RegisterOptionsTable("GatherMate 2", generalOptions)
	local options = acd:AddToBlizOptions("GatherMate 2", "GatherMate 2")
	options:HookScript("OnShow", function()
		local p = findPanel("GatherMate 2")
		if p and p.element.collapsed then OptionsListButtonToggle_OnClick(p.toggle) end
	end)

	acr:RegisterOptionsTable("GM2/Minimap", minimapOptions)
	acd:AddToBlizOptions("GM2/Minimap", "Minimap", "GatherMate 2")

	acr:RegisterOptionsTable("GM2/Filter", filterOptions)
	acd:AddToBlizOptions("GM2/Filter", "Filters", "GatherMate 2")

	acr:RegisterOptionsTable("GM2/Maintenance", maintenanceOptions)
	acd:AddToBlizOptions("GM2/Maintenance", "Maintenance", "GatherMate 2")

	acr:RegisterOptionsTable("GM2/Import", importOptions)
	acd:AddToBlizOptions("GM2/Import", "Import", "GatherMate 2")

	acr:RegisterOptionsTable("GM2/Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(GatherMate2.db))
	acd:AddToBlizOptions("GM2/Profiles", "Profiles", "GatherMate 2")

	acr:RegisterOptionsTable("GM2/FAQ", faqOptions)
	acd:AddToBlizOptions("GM2/FAQ", "FAQ", "GatherMate 2")

	local function openOptions()
		InterfaceOptionsFrame_OpenToCategory("GatherMate 2")
	end

	SLASH_GatherMate21 = "/gathermate"
	SlashCmdList.GatherMate2 = openOptions

	self:RegisterMessage("GatherMate2ConfigChanged")
	if DataBroker then
		local launcher = DataBroker:NewDataObject("GatherMate2", {
			type = "launcher",
			icon = "Interface\\AddOns\\GatherMate2\\Artwork\\Icon.tga",
			OnClick = openOptions,
		})
	end
end

function Config:OnEnable()
	self:CheckAutoImport()
end

function Config:UpdateConfig()
	self:SendMessage("GatherMate2ConfigChanged")
end

function Config:GatherMate2ConfigChanged()
	db = GatherMate.db.profile
end

function Config:CheckAutoImport()
	for k,v in pairs(db.importers) do
		local verline = GetAddOnMetadata(k, "X-Generated-Version")
		if verline and v["autoImport"] then
			local dataVersion = tonumber(verline:match("%d+"))
			if dataVersion and dataVersion > v["lastImport"] then
				local loaded, reason = LoadAddOn(k)
				local addon = LibStub("AceAddon-3.0"):GetAddon(k)
				if loaded then
					local filter = nil
					if v.expacOnly then
						filter = v.expac
					end
					addon:PerformMerge(v.Databases,v.Style,filter)
					addon:CleanupImportData()
					imported[k] = true
					Config:SendMessage("GatherMate2ConfigChanged")
					v["lastImport"] = dataVersion
					print(L["Auto import complete for addon "]..k)
				end
			end
		end
	end
end

-- Allows an external import module to insert their aceopttable into the Importing tree
-- returns a reference to the saved variables state for the addon
function Config:RegisterImportModule(moduleName, optionsTable)
	importOptions.args[moduleName] = optionsTable
	return db.importers[moduleName]
end
-- Allows an external module to insert their aceopttable
function Config:RegisterModule(moduleName, optionsTable)
	acr:RegisterOptionsTable("GM2/" .. moduleName, optionsTable)
	acd:AddToBlizOptions("GM2/" .. moduleName, moduleName, "GatherMate 2")
end

