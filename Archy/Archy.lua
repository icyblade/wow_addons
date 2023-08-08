-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
local _G = getfenv(0)

local math = _G.math
local table = _G.table

local ipairs = _G.ipairs
local pairs = _G.pairs
local setmetatable = _G.setmetatable
local tonumber = _G.tonumber
local tostring = _G.tostring
local unpack = _G.unpack

-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub

local ADDON_NAME, private = ...
local Archy = LibStub("AceAddon-3.0"):NewAddon("Archy", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceBucket-3.0", "AceTimer-3.0", "LibSink-2.0")
Archy.version = _G.GetAddOnMetadata(ADDON_NAME, "Version")
_G["Archy"] = Archy


local Astrolabe = _G.DongleStub("Astrolabe-1.0")
local Dialog = LibStub("LibDialog-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Archy", false)
local LDBI = LibStub("LibDBIcon-1.0")
local LSM = LibStub("LibSharedMedia-3.0")
local QTip = LibStub("LibQTip-1.0")
local Toast = LibStub("LibToast-1.0")

local LDB_object = LibStub("LibDataBroker-1.1"):NewDataObject("Archy", {
	type = "data source",
	icon = [[Interface\Icons\trade_archaeology]],
	iconCoords = { 0.075, 0.925, 0.075, 0.925 },
	text = "Archy",
})

if not LSM then
	_G.LoadAddOn("LibSharedMedia-3.0")
	LSM = LibStub("LibSharedMedia-3.0", true)
end

if LSM then
	local DEFAULT_LSM_FONT = "Arial Narrow"

	if not LSM:IsValid("font", DEFAULT_LSM_FONT) then
		DEFAULT_LSM_FONT = LSM:GetDefault("font")
	end
end

-----------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------
local DIG_SITES = private.dig_sites
local ARTIFACTS = private.artifacts_db
local MAX_ARCHAEOLOGY_RANK = _G.PROFESSION_RANKS[#_G.PROFESSION_RANKS][1]
local MAP_FILENAME_TO_MAP_ID = {} -- Popupated in OnInitialize()
local MAP_ID_TO_CONTINENT_ID = {} -- Popupated in OnInitialize()
local MAP_ID_TO_ZONE_ID = {} -- Popupated in OnInitialize()
local MAP_ID_TO_ZONE_NAME = {} -- Popupated in OnInitialize()
local MINIMAP_SIZES = {
	indoor = {
		[0] = 300,
		[1] = 240,
		[2] = 180,
		[3] = 120,
		[4] = 80,
		[5] = 50,
	},
	outdoor = {
		[0] = 466 + 2 / 3,
		[1] = 400,
		[2] = 333 + 1 / 3,
		[3] = 266 + 2 / 6,
		[4] = 200,
		[5] = 133 + 1 / 3,
	},
	indoor_scale = {
		[0] = 1,
		[1] = 1.25,
		[2] = 5 / 3,
		[3] = 2.5,
		[4] = 3.75,
		[5] = 6,
	},
	outdoor_scale = {
		[0] = 1,
		[1] = 7 / 6,
		[2] = 1.4,
		[3] = 1.75,
		[4] = 7 / 3,
		[5] = 3.5,
	},
}

local PROFILE_DEFAULTS = {
	profile = {
		general = {
			enabled = true,
			show = true,
			stealthMode = false,
			icon = {
				hide = false
			},
			locked = false,
			confirmSolve = true,
			showSkillBar = true,
			sinkOptions = {
				sink20OutputSink = L["Toast"],
			},
			easyCast = false,
			autoLoot = true,
			theme = "Graphical",
			manualTrack = false,
		},
		artifact = {
			show = true,
			position = {
				"TOPRIGHT",
				"TOPRIGHT",
				-200,
				-425
			},
			anchor = "TOPRIGHT",
			positionX = 100,
			positionY = -300,
			scale = 0.75,
			alpha = 1,
			filter = true,
			announce = true,
			keystoneAnnounce = true,
			ping = true,
			keystonePing = true,
			blacklist = {},
			autofill = {},
			style = "Compact",
			borderAlpha = 1,
			bgAlpha = 0.5,
			font = {
				name = "Friz Quadrata TT",
				size = 14,
				shadow = true,
				outline = "",
				color = {
					r = 1,
					g = 1,
					b = 1,
					a = 1
				}
			},
			fragmentFont = {
				name = "Friz Quadrata TT",
				size = 14,
				shadow = true,
				outline = "",
				color = {
					r = 1,
					g = 1,
					b = 1,
					a = 1
				}
			},
			keystoneFont = {
				name = "Friz Quadrata TT",
				size = 12,
				shadow = true,
				outline = "",
				color = {
					r = 1,
					g = 1,
					b = 1,
					a = 1
				}
			},
			fragmentBarColors = {
				["Normal"] = {
					r = 1,
					g = 0.5,
					b = 0
				},
				["Solvable"] = {
					r = 0,
					g = 1,
					b = 0
				},
				["Rare"] = {
					r = 0,
					g = 0.4,
					b = 0.8
				},
				["AttachToSolve"] = {
					r = 1,
					g = 1,
					b = 0
				},
				["FirstTime"] = {
					r = 1,
					g = 1,
					b = 1
				},
			},
			fragmentBarTexture = "Blizzard Parchment",
			borderTexture = "Blizzard Dialog Gold",
			backgroundTexture = "Blizzard Parchment",
		},
		digsite = {
			show = true,
			position = { "TOPRIGHT", "TOPRIGHT", -200, -200 },
			anchor = "TOPRIGHT",
			positionX = 400,
			positionY = -300,
			scale = 0.75,
			alpha = 1,
			style = "Extended",
			sortByDistance = true,
			announceNearest = true,
			distanceIndicator = {
				enabled = true,
				green = 40,
				yellow = 80,
				position = {
					"CENTER",
					"CENTER",
					0,
					0
				},
				anchor = "TOPLEFT",
				undocked = false,
				showSurveyButton = true,
				font = {
					name = "Friz Quadrata TT",
					size = 16,
					shadow = false,
					outline = "OUTLINE",
					color = {
						r = 1,
						g = 1,
						b = 1,
						a = 1
					}
				},
			},
			borderAlpha = 1,
			bgAlpha = 0.5,
			font = {
				name = "Friz Quadrata TT",
				size = 18,
				shadow = true,
				outline = "",
				color = {
					r = 1,
					g = 1,
					b = 1,
					a = 1
				}
			},
			zoneFont = {
				name = "Friz Quadrata TT",
				size = 14,
				shadow = true,
				outline = "",
				color = {
					r = 1,
					g = 0.82,
					b = 0,
					a = 1
				}
			},
			minimal = {
				showDistance = false,
				showZone = false,
				showDigCounter = true,
			},
			borderTexture = "Blizzard Dialog Gold",
			backgroundTexture = "Blizzard Parchment",
		},
		minimap = {
			show = true,
			nearest = true,
			fragmentNodes = true,
			fragmentIcon = "CyanDot",
			fragmentColorBySurveyDistance = true,
			useBlobDistance = true,
		},
		tooltip = {
			filter_continent = false,
			scale = 1,
		},
		tomtom = {
			enabled = true,
			distance = 125,
			ping = true,
		},
	},
}
local SECURE_ACTION_BUTTON -- Populated in OnInitialize()
local SITES_PER_CONTINENT = 4
local SURVEY_SPELL_ID = 80451
local FISHING_SPELL_NAME = (GetSpellInfo(7620)) or ""
local ZONE_DATA = {}
local ZONE_ID_TO_NAME = {} -- Popupated in OnInitialize()
local MAP_CONTINENTS = {} -- Popupated in CacheMapData()

_G.BINDING_HEADER_ARCHY = "Archy"
_G.BINDING_NAME_OPTIONSARCHY = L["BINDING_NAME_OPTIONS"]
_G.BINDING_NAME_TOGGLEARCHY = L["BINDING_NAME_TOGGLE"]
_G.BINDING_NAME_SOLVEARCHY = L["BINDING_NAME_SOLVE"]
_G.BINDING_NAME_SOLVE_WITH_KEYSTONESARCHY = L["BINDING_NAME_SOLVESTONE"]
_G.BINDING_NAME_ARTIFACTSARCHY = L["BINDING_NAME_ARTIFACTS"]
_G.BINDING_NAME_DIGSITESARCHY = L["BINDING_NAME_DIGSITES"]

-----------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------
local artifactSolved = {
	raceId = 0,
	name = ""
}

local current_continent
local continent_digsites = {}
local distanceIndicatorActive = false
local is_looting = false
local overrideOn = false
local keystoneIDToRaceID = {}
local keystoneLootRaceID -- this is to force a refresh after the BAG_UPDATE event
local digsitesTrackingID -- set in HasArchaeology()
local lastSite = {}
local nearestSite
local player_position = {
	map = 0,
	level = 0,
	x = 0,
	y = 0
}

local raceNameToID = {} -- TODO: Currently unused; see if it should be removed
local survey_location = {
	map = 0,
	level = 0,
	x = 0,
	y = 0
}

local tooltipModes, tooltipMode = {"artifacts_digsites","overall_completion"}, 1

local has_announced, has_pinged = {}, {}

local tomtomPoint, tomtomActive, tomtomFrame, tomtomSite

local prevTheme

-----------------------------------------------------------------------
-- Function upvalues
-----------------------------------------------------------------------
local Blizzard_SolveArtifact
local ClearTomTomPoint, UpdateTomTomPoint, RefreshTomTom
local UpdateMinimapPOIs
local CacheMapData, UpdateAllSites

-----------------------------------------------------------------------
-- Metatables.
-----------------------------------------------------------------------
local race_data, race_data_uncached = {}, {}
setmetatable(race_data, {
	__index = function(t, k)
		if _G.GetNumArchaeologyRaces() == 0 then
			return
		end
		local raceName, raceTexture, itemID, currencyAmount = _G.GetArchaeologyRaceInfo(k)
		local itemName, _, _, _, _, _, _, _, _, itemTexture, _ = _G.GetItemInfo(itemID)
		
		t[k] = {
			name = raceName,
			currency = currencyAmount,
			texture = raceTexture,
			keystone = {
				id = itemID,
				name = itemName,
				texture = itemTexture,
				inventory = 0
			}
		}
		if itemID and itemID > 0 and (not itemName or itemName == "") then 
			race_data_uncached[k] = itemID
			Archy:RegisterEvent("GET_ITEM_INFO_RECEIVED") -- Drii: ticket 391, fill in missing data when the keystone gets cached
		end
		return t[k]
	end
})
private.race_data = race_data

local artifacts = {}
setmetatable(artifacts, {
	__index = function(t, k)
		if k then
			t[k] = {
				name = "",
				tooltip = "",
				icon = "",
				sockets = 0,
				keystones_added = 0,
				fragments = 0,
				keystone_adjustment = 0,
				fragments_required = 0,
			}
			return t[k]
		end
	end
})

local function POI_OnEnter(self)
	if not self.tooltip then
		return
	end
	_G.GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	_G.GameTooltip:SetText(self.tooltip, _G.NORMAL_FONT_COLOR[1], _G.NORMAL_FONT_COLOR[2], _G.NORMAL_FONT_COLOR[3], 1) --, true)
end

local function POI_OnLeave(self)
	_G.GameTooltip:Hide()
end

local ARROW_UPDATE_THRESHOLD = 0.1

local function Arrow_OnUpdate(self, elapsed)
	self.t = self.t + elapsed

	if self.t < ARROW_UPDATE_THRESHOLD then
		return
	end
	local square_half = math.sqrt(0.5)
	local rad_135 = math.rad(135)
	self.t = 0

	if _G.IsInInstance() then
		self:Hide()
		return
	end

	if not self.active then
		return
	end

	local edge = Astrolabe:IsIconOnEdge(self)

	if self.type == "site" then
		if edge then
			if self.icon:IsShown() then self.icon:Hide()
			end
			if not self.arrow:IsShown() then self.arrow:Show()
			end

			-- Rotate the icon, as required
			local angle = Astrolabe:GetDirectionToIcon(self)
			angle = angle + rad_135

			if _G.GetCVar("rotateMinimap") == "1" then
				local cring = _G.GetPlayerFacing()
				angle = angle - cring
			end

			local sin, cos = math.sin(angle) * square_half, math.cos(angle) * square_half
			self.arrow:SetTexCoord(0.5 - sin, 0.5 + cos, 0.5 + cos, 0.5 + sin, 0.5 - cos, 0.5 - sin, 0.5 + sin, 0.5 - cos)
		else
			if not self.icon:IsShown() then self.icon:Show()
			end
			if self.arrow:IsShown() then self.arrow:Hide()
			end
		end
	elseif edge then
		if self.icon:IsShown() then self.icon:Hide()
		end
	else
		if not self.icon:IsShown() then self.icon:Show()
		end
	end
end

local pois = setmetatable({}, {
	__index = function(t, k)
		local poi = _G.CreateFrame("Frame", "ArchyMinimap_POI" .. k, _G.Minimap)
		poi:SetWidth(10)
		poi:SetHeight(10)
		poi:SetScript("OnEnter", POI_OnEnter)
		poi:SetScript("OnLeave", POI_OnLeave)

		local arrow = _G.CreateFrame("Frame", nil, poi)
		arrow:SetPoint("CENTER", poi)
		arrow:SetScript("OnUpdate", Arrow_OnUpdate)
		arrow:SetWidth(32)
		arrow:SetHeight(32)

		local arrowtexture = arrow:CreateTexture(nil, "OVERLAY")
		arrowtexture:SetTexture([[Interface\Minimap\ROTATING-MINIMAPGUIDEARROW]]) -- [[Interface\Archeology\Arch-Icon-Marker]])
		arrowtexture:SetAllPoints(arrow)
		arrow.texture = arrowtexture
		arrow.t = 0
		arrow.poi = poi
		arrow:Hide()
		poi.useArrow = false
		poi.arrow = arrow
		poi:Hide()
		return poi
	end
})


-----------------------------------------------------------------------
-- Local helper functions
-----------------------------------------------------------------------
local clickToMove
local function SuspendClickToMove()
	if not private.db.general.easyCast or IsUsableSpell(FISHING_SPELL_NAME) then return end -- we're not using easy cast, no need to mess with click to move
	if private.db.general.show then -- Archy enabled
		if _G.GetCVarBool("autointeract") then -- and click to move 'on'
			_G.SetCVar("autointeract","0") -- suspend it
			clickToMove = "1" -- and store previous state
		end
	else                           -- archy disabled
		if clickToMove and clickToMove == "1" then -- did we suspend click to move previously?
			_G.SetCVar("autointeract","1") -- restore it
			clickToMove = nil
		end
	end
end

local function AnnounceNearestSite()
	if not nearestSite or not nearestSite.distance or nearestSite.distance == 999999 then
		return
	end
	local site_name = ("%s%s|r"):format(_G.GREEN_FONT_COLOR_CODE, nearestSite.name)
	local site_zone = ("%s%s|r"):format(_G.GREEN_FONT_COLOR_CODE, nearestSite.zoneName)

	Archy:Pour(L["Nearest Dig Site is: %s in %s (%.1f yards away)"]:format(site_name, site_zone, nearestSite.distance), 1, 1, 1)
end

-- returns the rank and max rank for the players archaeology skill
local function GetArchaeologyRank()
	local _, _, archaeology_index = _G.GetProfessions()

	if not archaeology_index then
		return
	end
	local _, _, rank, maxRank = _G.GetProfessionInfo(archaeology_index)
	return rank, maxRank
end

local function GetAchievementProgress()
	local rare, common = NONE, NONE
	local rare_ach, common_ach, completed = 4854, 5315 -- "I had it in my hand" (Title: Assistant Professor), "Digger"
	-- local id, name, points, completed, month, day, year, description, flags, icon, rewardText = GetAchievementInfo(achID);
	if select(4, GetAchievementInfo(rare_ach)) then -- completed
		rare = select(11, GetAchievementInfo(rare_ach)) -- rewardText
		rare_ach, completed = GetNextAchievement(rare_ach)
		while rare_ach and completed do
			rare = select(11, GetAchievementInfo(rare_ach))
			rare_ach, completed = GetNextAchievement(rare_ach)
		end
	end
	if select(4, GetAchievementInfo(common_ach)) then -- completed
		common = select(2, GetAchievementInfo(common_ach)) -- name
		common_ach, completed = GetNextAchievement(common_ach)
		while common_ach and completed do
			common = select(2, GetAchievementInfo(common_ach))
			common_ach, completed = GetNextAchievement(common_ach)
		end
	end
	return rare:gsub("^.+:",""):trim(), common
end

local count_descriptors = {["rare_counts"]=true,["common_counts"]=true,["total_counts"]=true}
local function GetArtifactsDelta(race_id, missing_data)
	wipe(missing_data)
	local rare_count, common_count, total_count = 0,0,0
	local rare_missing, common_missing, total_missing = 0,0,0
	
	for artifact,info in pairs(ARTIFACTS) do 
		if info.raceid == race_id then 
			if info.rarity==0 then 
				common_count = common_count + 1
			else
				rare_count = rare_count + 1
			end
			total_count = total_count + 1
			missing_data[artifact] = info -- flag all race artifacts as missing
		end
	end
	
	-- then remove the ones we've already solved at least once so we have the actual missing.
	local artifact_index, artifact, _, completionCount = 1
	artifact, _, _, _, _, _, _, _, completionCount = _G.GetArtifactInfoByRace(race_id, artifact_index)
	if artifact and completionCount > 0 and missing_data[artifact] then -- TODO: Maybe display "in progress" but not yet obtained artifacts different?
		missing_data[artifact] = nil
		artifact_index = artifact_index + 1
	end
	while artifact do
		artifact, _, _, _, _, _, _, _, completionCount = _G.GetArtifactInfoByRace(race_id, artifact_index)
		if artifact and completionCount > 0 and missing_data[artifact] then
			missing_data[artifact] = nil
		end
		artifact_index = artifact_index + 1
	end
	for artifact,info in pairs(missing_data) do
		if info.rarity==0 then
			common_missing = common_missing + 1
		else
			rare_missing = rare_missing + 1
		end
		total_missing = total_missing + 1
	end
	missing_data["rare_counts"] = {rare_count - rare_missing, rare_count}
	missing_data["common_counts"] = {common_count - common_missing, common_count}
	missing_data["total_counts"] = {total_count - total_missing, total_count}

	return rare_count - rare_missing, rare_count, common_count - common_missing, common_count, total_count - total_missing, total_count
end

local function GetArtifactStats(race_id, name)
	local num_artifacts = _G.GetNumArtifactsByRace(race_id)

	if not num_artifacts then
		return
	end

	for artifact_index = 1, num_artifacts do
		local artifact_name, _, _, _, _, _, _, firstCompletionTime, completionCount = _G.GetArtifactInfoByRace(race_id, artifact_index)
		if name == artifact_name then
			return artifact_index, firstCompletionTime, completionCount
		end
	end

end

-- Returns true if the player has the archaeology secondary skill
local function HasArchaeology()
	local _, _, arch = _G.GetProfessions()
	if arch then
		for i=1, _G.GetNumTrackingTypes() do
			if (_G.GetTrackingInfo(i))==_G.MINIMAP_TRACKING_DIGSITES then
				digsitesTrackingID = i
				break
			end
		end
	end
	return arch
end

local function IsTaintable()
	return (private.in_combat or _G.InCombatLockdown() or (_G.UnitAffectingCombat("player") or _G.UnitAffectingCombat("pet")))
end

function private:ResetPositions()
	self.db.digsite.distanceIndicator.position = { unpack(PROFILE_DEFAULTS.profile.digsite.distanceIndicator.position) }
	self.db.digsite.distanceIndicator.anchor = PROFILE_DEFAULTS.profile.digsite.distanceIndicator.anchor
	self.db.digsite.distanceIndicator.undocked = PROFILE_DEFAULTS.profile.digsite.distanceIndicator.undocked
	self.db.digsite.position = { unpack(PROFILE_DEFAULTS.profile.digsite.position) }
	self.db.digsite.anchor = PROFILE_DEFAULTS.profile.digsite.anchor
	self.db.artifact.position = { unpack(PROFILE_DEFAULTS.profile.artifact.position) }
	self.db.artifact.anchor = PROFILE_DEFAULTS.profile.artifact.anchor
	Archy:ConfigUpdated()
	Archy:UpdateFramePositions()
end

local function ShouldBeHidden()
	return (not private.db.general.show or not current_continent or _G.UnitIsGhost("player") or _G.IsInInstance() or not HasArchaeology())
end

local function UpdateRaceArtifact(race_id)
	local race = race_data[race_id]

	if not race then
		-- @??? Maybe use a wipe statement here
		artifacts[race_id] = nil
		return
	end
	race_data[race_id].keystone.inventory = _G.GetItemCount(race_data[race_id].keystone.id) or 0

	if _G.GetNumArtifactsByRace(race_id) == 0 then
		return
	end

	if _G.ArchaeologyFrame and _G.ArchaeologyFrame:IsVisible() then
		_G.ArchaeologyFrame_ShowArtifact(race_id)
	end
	_G.SetSelectedArtifact(race_id)

	local name, _, rarity, icon, spellDescription, numSockets = _G.GetSelectedArtifactInfo()
	local base, adjust, total = _G.GetArtifactProgress()
	local artifact = artifacts[race_id]

	artifact.canSolve = _G.CanSolveArtifact()
	artifact.fragments = base
	artifact.fragments_required = total
	artifact.sockets = numSockets
	artifact.icon = icon
	artifact.tooltip = spellDescription
	artifact.rare = (rarity ~= 0)
	artifact.name = name
	artifact.canSolveStone = nil -- Drii: stores whether we can actually solve with current user selection
	artifact.canSolveInventory = nil -- Drii: stores whether we would be able to solve if using all inventory stones
	artifact.keystone_adjustment = 0
	artifact.completionCount = 0

	local prevAdded = math.min(artifact.keystones_added, race_data[race_id].keystone.inventory, numSockets)

	if private.db.artifact.autofill[race_id] then
		prevAdded = math.min(race_data[race_id].keystone.inventory, numSockets)
	end
	artifact.keystones_added = math.min(race_data[race_id].keystone.inventory, numSockets) -- Drii: sets it to keystones in inventory
	-- Drii: this whole section looks like a needlessly convoluted way of doing things but hey 'if it's not broken don't fix it' 
	-- cosmetic changes only; don't fancy wading through 10 tail calls if I break something :P
	if artifact.keystones_added > 0 and numSockets > 0 then
		for i = 1, math.min(artifact.keystones_added, numSockets) do -- Drii: adds any available keystones regardless of autofill settings
			_G.SocketItemToArtifact() 
			if not _G.ItemAddedToArtifact(i) then
				break
			end
			if i == prevAdded then
				_, adjust = _G.GetArtifactProgress()
				artifact.keystone_adjustment = adjust -- Drii: set adjustment to actual user selection and move along
				artifact.canSolveStone = _G.CanSolveArtifact()
			end
		end
		artifact.canSolveInventory = _G.CanSolveArtifact()

		if prevAdded > 0 and artifact.keystone_adjustment <= 0 then -- Drii: keep our user value if there's one
			_, adjust = _G.GetArtifactProgress() -- Drii: or get the current fill if not
			artifact.keystone_adjustment = adjust
			artifact.canSolveStone = _G.CanSolveArtifact()
		end
	end
	artifact.keystones_added = prevAdded -- Drii: and here it sets it back to what the user chose by clicking Archy socket and relies on the overridden SolveArtifact to remove the extra keystones back out when solving.

	_G.RequestArtifactCompletionHistory()

	if not private.db.general.show or private.db.artifact.blacklist[race_id] then
		return
	end

	if not has_announced[artifact.name] and ((private.db.artifact.announce and artifact.canSolve) or (private.db.artifact.keystoneAnnounce and artifact.canSolveInventory)) then
		has_announced[artifact.name] = true
		Archy:Pour(L["You can solve %s Artifact - %s (Fragments: %d of %d)"]:format("|cFFFFFF00" .. race_data[race_id].name .. "|r", "|cFFFFFF00" .. artifact.name .. "|r", artifact.fragments + artifact.keystone_adjustment, artifact.fragments_required), 1, 1, 1)
	end

	if not has_pinged[artifact.name] and ((private.db.artifact.ping and artifact.canSolve) or (private.db.artifact.keystonePing and artifact.canSolveInventory)) then
		has_pinged[artifact.name] = true
		_G.PlaySoundFile([[Interface\AddOns\Archy\Media\dingding.mp3]])
	end
end

local function SolveRaceArtifact(race_id, use_stones)
	-- The check for race_id exists because its absence means we're calling this function from the default UI and should NOT perform any of the actions within the block.
	if race_id then
		local artifact = artifacts[race_id]

		_G.SetSelectedArtifact(race_id)
		artifactSolved.raceId = race_id
		artifactSolved.name = _G.GetSelectedArtifactInfo()
		artifact.name = artifactSolved.name
		keystoneLootRaceID = race_id

		if _G.type(use_stones) == "boolean" then
			if use_stones then
				artifact.keystones_added = math.min(race_data[race_id].keystone.inventory, artifact.sockets)
			else
				artifact.keystones_added = 0
			end
		end

		if artifact.keystones_added > 0 then
			for index = 1, artifact.keystones_added do
				_G.SocketItemToArtifact()

				if not _G.ItemAddedToArtifact(index) then
					break
				end
			end
		elseif artifact.sockets > 0 then
			for index = 1, artifact.sockets do
				_G.RemoveItemFromArtifact()
			end
		end
	end
	Blizzard_SolveArtifact()
end

local function ToggleDistanceIndicator()
	if IsTaintable() then
		private.regen_toggle_distance = true
		return
	end

	if not private.db.digsite.distanceIndicator.enabled or ShouldBeHidden() then
		private.distance_indicator_frame:Hide()
		return
	end
	private.distance_indicator_frame:Show()

	if distanceIndicatorActive then
		private.distance_indicator_frame.circle:SetAlpha(1) 
	else 
		if private.db.digsite.distanceIndicator.undocked and private.db.digsite.distanceIndicator.showSurveyButton then
			private.distance_indicator_frame.circle:SetAlpha(0.25) -- Drii: allow the distance indicator to show at reduced alpha for dragging when undocked
		else
			private.distance_indicator_frame.circle:SetAlpha(0)
		end
	end

	if private.db.digsite.distanceIndicator.showSurveyButton then
		private.distance_indicator_frame.surveyButton:Show()
		private.distance_indicator_frame:SetWidth(52 + private.distance_indicator_frame.surveyButton:GetWidth())
	else
		private.distance_indicator_frame.surveyButton:Hide()
		private.distance_indicator_frame:SetWidth(42)
	end
end

Dialog:Register("ArchyConfirmSolve", {
	text = "",
	on_show = function(self, data)
		self.text:SetFormattedText(L["Your Archaeology skill is at %d of %d.  Are you sure you would like to solve this artifact before visiting a trainer?"], data.rank, data.max_rank)
	end,
	buttons = {
		{
			text = _G.YES,
			on_click = function(self, data)
				if data.race_index then
					SolveRaceArtifact(data.race_index, data.use_stones)
				else
					Blizzard_SolveArtifact()
				end
			end,
		},
		{
			text = _G.NO,
		},
	},
	sound = "levelup2",
	show_while_dead = false,
	hide_on_escape = true,
})

-- Drii: temporary workaround for ticket 384
Dialog:Register("ArchyTomTomError",{
	text = "",
	on_show = function(self, data)
		self.text:SetFormattedText("%s%s|r\nIncompatible TomTom setting detected. \"%s%s|r\".\nDo you want to reset it?", "|cFFFFCC00", ADDON_NAME, "|cFFFFCC00", TomTomLocals and TomTomLocals["Enable automatic quest objective waypoints"] or "")
	end,
	buttons = {
		{
			text = _G.YES .. " (reloads UI)",
			on_click = function(self, data)
				TomTom.profile.poi.setClosest = false
				TomTom:EnableDisablePOIIntegration()
				_G.ReloadUI()
			end,
		},
		{
			text = _G.NO,
		},
		{
			text = _G.IGNORE,
			on_click = function(self, data)
				private.db.tomtom.noerrorwarn = Archy.version -- Drii: don't warn again for this version
			end,
		},
	},
	show_while_dead = true,
	hide_on_escape = true,
})

-----------------------------------------------------------------------
-- LDB_object methods
-----------------------------------------------------------------------
local Archy_cell_provider, Archy_cell_prototype = QTip:CreateCellProvider()
local Archy_LDB_Tooltip

local function Archy_cell_script(_, what, button)
	if what == "mode" then -- header was clicked, cycle display mode
		local nextmode = tooltipMode+1
		tooltipMode = tooltipModes[nextmode] and nextmode or 1
	end
	local key,value = (":"):split(what)
	if key == "raceid" and value then -- race was clicked show/hide uncomplete artifacts lists
		for race_id,_ in pairs(race_data) do
			if tonumber(value) ~= race_id then
				race_data[race_id].expand = nil
			else
				race_data[race_id].expand = not race_data[race_id].expand
			end
		end
	end
	if key == "spellid" and value then -- project link was clicked
		Archy:Print((GetSpellLink(tonumber(value))))
	end
	Archy:LDBTooltipShow()
end

function Archy_cell_prototype:InitializeCell()
	local bar = self:CreateTexture(nil, "OVERLAY", self)
	self.bar = bar
	bar:SetWidth(100)
	bar:SetHeight(12)
	bar:SetPoint("LEFT", self, "LEFT", 1, 0)

	local bg = self:CreateTexture(nil, "BACKGROUND")
	self.bg = bg
	bg:SetWidth(102)
	bg:SetHeight(14)
	bg:SetTexture(0, 0, 0, 0.5)
	bg:SetPoint("LEFT", self)

	local fs = self:CreateFontString(nil, "OVERLAY")
	self.fs = fs
	fs:SetAllPoints(self)
	fs:SetFontObject(_G.GameTooltipText)
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1, -1)
	self.r, self.g, self.b = 1, 1, 1
end

function Archy_cell_prototype:SetupCell(tooltip, data, justification, font, r, g, b)
	local barTexture = [[Interface\TargetingFrame\UI-StatusBar]]
	local bar = self.bar
	local fs = self.fs
	--[[    { -- artifacts
    1 artifact.fragments,
    2 artifact.keystone_adjustment,
    3 artifact.fragments_required,
    4 raceData[race_id].keystone.inventory,
    5 artifact.sockets,
    6 artifact.keystones_added,
    7 artifact.canSolve,
    8 artifact.canSolveStone,
    9 artifact.canSolveInventory,
   10 artifact.rare }
   				{ -- rares overall progress
   	1 progress[1], -- done
   	2 progress[2], -- total }
]]
	if tooltipMode == 1 then -- artifacts_digsites
		local perc = math.min((data.fragments + data.keystone_adjustment) / data.fragments_required * 100, 100)
		local bar_colors = private.db.artifact.fragmentBarColors
	
		if data.canSolve then
			self.r, self.g, self.b = bar_colors["Solvable"].r, bar_colors["Solvable"].g, bar_colors["Solvable"].b
		elseif data.canSolveInventory then
			self.r, self.g, self.b = bar_colors["AttachToSolve"].r, bar_colors["AttachToSolve"].g, bar_colors["AttachToSolve"].b
		elseif data.rare then
			self.r, self.g, self.b = bar_colors["Rare"].r, bar_colors["Rare"].g, bar_colors["Rare"].b
		else
			self.r, self.g, self.b = bar_colors["Normal"].r, bar_colors["Normal"].g, bar_colors["Normal"].b
		end
		bar:SetVertexColor(self.r, self.g, self.b)
		bar:SetWidth(perc)
	
		local adjust = ""
		if data.keystone_adjustment > 0 then
			adjust = "(+" .. tostring(data.keystone_adjustment) .. ")"
		end
	
		fs:SetFormattedText("%d%s / %d", data.fragments, adjust, data.fragments_required)
	elseif tooltipMode == 2 then -- overall_completion
		local perc = math.min((data[1] / data[2]) * 100, 100)
		local bar_colors = private.db.artifact.fragmentBarColors
	
		if data[1] > 0 and data[1] == data[2] then -- all done
			self.r, self.g, self.b = bar_colors["Solvable"].r, bar_colors["Solvable"].g, bar_colors["Solvable"].b
		elseif data[1] > 0 and data[1] < data[2] then
			self.r, self.g, self.b = bar_colors["AttachToSolve"].r, bar_colors["AttachToSolve"].g, bar_colors["AttachToSolve"].b
		else
			self.r, self.g, self.b = 0.0, 0.0, 0.0
		end
		bar:SetVertexColor(self.r, self.g, self.b)
		bar:SetWidth(perc)
	
		fs:SetFormattedText("%d / %d", data[1], data[2])
	end
	
	bar:SetTexture(barTexture)
	bar:Show()
	fs:SetFontObject(font or tooltip:GetFont())
	fs:SetJustifyH("CENTER")
	fs:SetTextColor(1, 1, 1)	
	fs:Show()
	
	return bar:GetWidth() + 2, bar:GetHeight() + 2
end

function Archy_cell_prototype:ReleaseCell()
	self.r, self.g, self.b = 1, 1, 1
end

function Archy_cell_prototype:getContentHeight()
	return self.bar:GetHeight() + 2
end

local progress_data, missing_data = {}, {}
function Archy:LDBTooltipShow()
	local num_columns, column_index, line
	if tooltipMode == 1 then -- artifacts_digsites
		num_columns, column_index, line = 10, 0, 0
		Archy_LDB_Tooltip = QTip:Acquire("ArchyTooltip", num_columns, "CENTER", "LEFT", "LEFT", "LEFT", "RIGHT", "RIGHT", "RIGHT", "RIGHT", "RIGHT")
	elseif tooltipMode == 2 then -- overall_completion
		num_columns, column_index, line = 6, 0, 0
		Archy_LDB_Tooltip = QTip:Acquire("ArchyTooltip", num_columns, "CENTER", "LEFT", "LEFT", "LEFT", "RIGHT")
	end
	Archy_LDB_Tooltip:Hide()
	Archy_LDB_Tooltip:Clear()

	local line = Archy_LDB_Tooltip:AddHeader(".")
	Archy_LDB_Tooltip:SetCell(line, 1, ("%s%s%s"):format(_G.ORANGE_FONT_COLOR_CODE, "Archy", "|r") .. "*", "CENTER", num_columns)
	Archy_LDB_Tooltip:SetCellScript(line, 1, "OnMouseDown", Archy_cell_script, "mode")

	if HasArchaeology() then
		if tooltipMode == 1 then
			line = Archy_LDB_Tooltip:AddLine(".")
			local rank, maxRank = GetArchaeologyRank()
			local skill = ("%d/%d"):format(rank, maxRank)
	
			if maxRank < MAX_ARCHAEOLOGY_RANK and (maxRank - rank) <= 25 then
				skill = ("%s - |cFFFF0000%s|r"):format(skill, L["Visit a trainer!"])
			elseif maxRank == MAX_ARCHAEOLOGY_RANK and rank == maxRank then
				skill = ("%s%s|r"):format(_G.GREEN_FONT_COLOR_CODE, "MAX")
			end
			Archy_LDB_Tooltip:SetCell(line, 1, ("%s%s|r%s"):format(_G.NORMAL_FONT_COLOR_CODE, _G.SKILL .. ": ", skill), "CENTER", num_columns)
	
			line = Archy_LDB_Tooltip:AddLine(".")
			Archy_LDB_Tooltip:SetCell(line, 1, ("%s%s|r"):format("|cFFFFFF00", L["Artifacts"]), "LEFT", num_columns)
			Archy_LDB_Tooltip:AddSeparator()
	
			line = Archy_LDB_Tooltip:AddLine(".")
			Archy_LDB_Tooltip:SetCell(line, 1, " ", "LEFT", 1)
			Archy_LDB_Tooltip:SetCell(line, 2, _G.NORMAL_FONT_COLOR_CODE .. _G.RACE .. "|r", "LEFT", 1)
			Archy_LDB_Tooltip:SetCell(line, 3, " ", "LEFT", 1)
			Archy_LDB_Tooltip:SetCell(line, 4, _G.NORMAL_FONT_COLOR_CODE .. L["Artifact"] .. "|r", "LEFT", 2)
			Archy_LDB_Tooltip:SetCell(line, 6, _G.NORMAL_FONT_COLOR_CODE .. L["Progress"] .. "|r", "CENTER", 1)
			Archy_LDB_Tooltip:SetCell(line, 7, _G.NORMAL_FONT_COLOR_CODE .. L["Keys"] .. "|r", "CENTER", 1)
			Archy_LDB_Tooltip:SetCell(line, 8, _G.NORMAL_FONT_COLOR_CODE .. L["Sockets"] .. "|r", "CENTER", 1)
			Archy_LDB_Tooltip:SetCell(line, 9, _G.NORMAL_FONT_COLOR_CODE .. L["Completed"] .. "|r", "CENTER", 2)
	
			for race_id, artifact in pairs(artifacts) do
				if artifact.fragments_required > 0 then
					line = Archy_LDB_Tooltip:AddLine(" ")
					Archy_LDB_Tooltip:SetCell(line, 1, " " .. ("|T%s:18:18:0:1:128:128:4:60:4:60|t"):format(race_data[race_id].texture), "LEFT", 1)
					Archy_LDB_Tooltip:SetCell(line, 2, race_data[race_id].name, "LEFT", 1)
					Archy_LDB_Tooltip:SetCell(line, 3, " " .. ("|T%s:18:18|t"):format(artifact.icon), "LEFT", 1)
	
					local artifactName = artifact.name
	
					if artifact.rare then
						artifactName = ("%s%s|r"):format("|cFF0070DD", artifactName)
					end
	
					Archy_LDB_Tooltip:SetCell(line, 4, artifactName, "LEFT", 2)
	
					progress_data.fragments = artifact.fragments
					progress_data.keystone_adjustment = artifact.keystone_adjustment
					progress_data.fragments_required = artifact.fragments_required
					progress_data.race_keystone_inventory = race_data[race_id].keystone.inventory
					progress_data.sockets = artifact.sockets
					progress_data.keystones_added = artifact.keystones_added
					progress_data.canSolve = artifact.canSolve
					progress_data.canSolveStone = artifact.canSolveStone
					progress_data.canSolveInventory = artifact.canSolveInventory
					progress_data.rare = artifact.rare
	
					Archy_LDB_Tooltip:SetCell(line, 6, progress_data, Archy_cell_provider, 1, 0, 0)
					Archy_LDB_Tooltip:SetCell(line, 7, (race_data[race_id].keystone.inventory > 0) and race_data[race_id].keystone.inventory or "", "CENTER", 1)
					Archy_LDB_Tooltip:SetCell(line, 8, (artifact.sockets > 0) and artifact.sockets or "", "CENTER", 1)
	
					local _, _, completionCount = GetArtifactStats(race_id, artifact.name)
					Archy_LDB_Tooltip:SetCell(line, 9, completionCount or _G.UNKNOWN, "CENTER", 2)
				end
			end
			local site_stats = Archy.db.char.digsites.stats
	
			line = Archy_LDB_Tooltip:AddLine(" ")
			line = Archy_LDB_Tooltip:AddLine(" ")
			Archy_LDB_Tooltip:SetCell(line, 1, ("%s%s|r"):format("|cFFFFFF00", L["Dig Sites"]), "LEFT", num_columns)
			Archy_LDB_Tooltip:AddSeparator()
	
			for continent_id, continent_sites in pairs(continent_digsites) do
				if #continent_sites > 0 and (not private.db.tooltip.filter_continent or continent_id == MAP_ID_TO_CONTINENT_ID[current_continent]) then
					local continent_name
					for _, zone in pairs(ZONE_DATA) do
						if zone.continent == continent_id and zone.id == 0 then
							continent_name = zone.name
							break
						end
					end

					line = Archy_LDB_Tooltip:AddLine(" ")
					Archy_LDB_Tooltip:SetCell(line, 1, "  " .. _G.ORANGE_FONT_COLOR_CODE .. continent_name .. "|r", "LEFT", num_columns) -- Drii: ticket 384
	
					line = Archy_LDB_Tooltip:AddLine(" ")
					Archy_LDB_Tooltip:SetCell(line, 1, " ", "LEFT", 1)
					Archy_LDB_Tooltip:SetCell(line, 2, _G.NORMAL_FONT_COLOR_CODE .. L["Fragment"] .. "|r", "LEFT", 2)
					Archy_LDB_Tooltip:SetCell(line, 4, _G.NORMAL_FONT_COLOR_CODE .. L["Dig Site"] .. "|r", "LEFT", 1)
					Archy_LDB_Tooltip:SetCell(line, 5, _G.NORMAL_FONT_COLOR_CODE .. _G.ZONE .. "|r", "LEFT", 2)
					Archy_LDB_Tooltip:SetCell(line, 7, _G.NORMAL_FONT_COLOR_CODE .. L["Surveys"] .. "|r", "CENTER", 1)
					Archy_LDB_Tooltip:SetCell(line, 8, _G.NORMAL_FONT_COLOR_CODE .. L["Digs"] .. "|r", "CENTER", 1)
					Archy_LDB_Tooltip:SetCell(line, 9, _G.NORMAL_FONT_COLOR_CODE .. _G.ARCHAEOLOGY_RUNE_STONES .. "|r", "CENTER", 1)
					Archy_LDB_Tooltip:SetCell(line, 10, _G.NORMAL_FONT_COLOR_CODE .. L["Keys"] .. "|r", "CENTER", 1)
	
					for _, site in pairs(continent_sites) do
						line = Archy_LDB_Tooltip:AddLine(" ")
						Archy_LDB_Tooltip:SetCell(line, 1, " " .. ("|T%s:18:18:0:1:128:128:4:60:4:60|t"):format(race_data[site.raceId].texture), "LEFT", 1)
						Archy_LDB_Tooltip:SetCell(line, 2, race_data[site.raceId].name, "LEFT", 2)
						Archy_LDB_Tooltip:SetCell(line, 4, site.name, "LEFT", 1)
						Archy_LDB_Tooltip:SetCell(line, 5, site.zoneName, "LEFT", 2)
						Archy_LDB_Tooltip:SetCell(line, 7, site_stats[site.id].surveys, "CENTER", 1)
						Archy_LDB_Tooltip:SetCell(line, 8, site_stats[site.id].looted, "CENTER", 1)
						Archy_LDB_Tooltip:SetCell(line, 9, site_stats[site.id].fragments, "CENTER", 1)
						Archy_LDB_Tooltip:SetCell(line, 10, site_stats[site.id].keystones, "CENTER", 1)
					end
					line = Archy_LDB_Tooltip:AddLine(" ")
				end
			end
		elseif tooltipMode == 2 then
			line = Archy_LDB_Tooltip:AddLine(".")
			local rare_achiev, common_achiev = GetAchievementProgress()
			local achiev = ("%s%s|r - %s%s|r"):format(_G.ITEM_QUALITY_COLORS[3].hex, rare_achiev, _G.ITEM_QUALITY_COLORS[1].hex, common_achiev)
			Archy_LDB_Tooltip:SetCell(line, 1, ("%s%s|r%s"):format(_G.NORMAL_FONT_COLOR_CODE, _G.ACHIEVEMENTS .. ": ", achiev), "CENTER", num_columns)
	
			line = Archy_LDB_Tooltip:AddLine(".")
			Archy_LDB_Tooltip:SetCell(line, 1, ("%s%s|r"):format("|cFFFFFF00", _G.ACHIEVEMENT_CATEGORY_PROGRESS), "LEFT", num_columns)
			Archy_LDB_Tooltip:AddSeparator()
			
			line = Archy_LDB_Tooltip:AddLine(".")
			Archy_LDB_Tooltip:SetCell(line, 1, " ", "LEFT", 1)
			Archy_LDB_Tooltip:SetCell(line, 2, _G.NORMAL_FONT_COLOR_CODE .. _G.RACE .. "|r", "LEFT", 1)
			Archy_LDB_Tooltip:SetCell(line, 3, _G.NORMAL_FONT_COLOR_CODE .. _G.ITEM_QUALITY3_DESC .. "|r", "LEFT", 1)
			Archy_LDB_Tooltip:SetCell(line, 5, _G.NORMAL_FONT_COLOR_CODE .. _G.ITEM_QUALITY1_DESC .. "|r", "LEFT", 1)
			Archy_LDB_Tooltip:SetCell(line, 6, _G.NORMAL_FONT_COLOR_CODE .. L["Total"] .. "|r", "RIGHT", 1)
			
			local all_rare_done, all_rare_count, all_common_done, all_common_count, all_total_done, all_total_count = 0,0,0,0,0,0
			for race_id,_ in pairs(artifacts) do
				local rare_done, rare_count, common_done, common_count, total_done, total_count = GetArtifactsDelta(race_id, missing_data)
				if total_count > 0 then -- skip races that are not yet implemented
					line = Archy_LDB_Tooltip:AddLine(" ")
					Archy_LDB_Tooltip:SetCell(line, 1, " " .. ("|T%s:18:18:0:1:128:128:4:60:4:60|t"):format(race_data[race_id].texture), "LEFT", 1)
					Archy_LDB_Tooltip:SetCell(line, 2, race_data[race_id].name .. "*", "LEFT", 1)
					Archy_LDB_Tooltip:SetCellScript(line, 2, "OnMouseDown", Archy_cell_script, "raceid:"..race_id)
					Archy_LDB_Tooltip:SetCell(line, 3, missing_data.rare_counts, Archy_cell_provider, 1, 0, 0)
					Archy_LDB_Tooltip:SetCell(line, 5, missing_data.common_counts, Archy_cell_provider, 1, 0, 0)
					Archy_LDB_Tooltip:SetCell(line, 6, total_done .. "/" .. total_count, "RIGHT", 1)
					all_rare_done = all_rare_done + rare_done
					all_rare_count = all_rare_count + rare_count
					all_common_done = all_common_done + common_done
					all_common_count = all_common_count + common_count
					all_total_done = all_total_done + total_done
					all_total_count = all_total_count + total_count
				end
			end
			if all_rare_done > 0 or all_rare_count > 0 or all_common_done > 0 or all_common_count > 0 or all_total_done > 0 or all_total_count > 0 then
				Archy_LDB_Tooltip:AddSeparator()
				line = Archy_LDB_Tooltip:AddLine(" ")
				Archy_LDB_Tooltip:SetCell(line, 1, " ", "LEFT", 1)
				Archy_LDB_Tooltip:SetCell(line, 2, _G.NORMAL_FONT_COLOR_CODE .. L["Total"] .. "|r", "LEFT", 1)
				Archy_LDB_Tooltip:SetCell(line, 3, all_rare_done .. "/" .. all_rare_count, "LEFT", 1)
				Archy_LDB_Tooltip:SetCell(line, 5, all_common_done .. "/" .. all_common_count, "LEFT", 1)
				Archy_LDB_Tooltip:SetCell(line, 6, all_total_done .. "/" .. all_total_count, "RIGHT", 1)
			end
			
			for race_id,_ in pairs(artifacts) do
				if race_data[race_id].expand then
					line = Archy_LDB_Tooltip:AddLine(" ")
					line = Archy_LDB_Tooltip:AddLine(" ")
					Archy_LDB_Tooltip:SetCell(line, 1, ("%s%s|r"):format("|cFFFFFF00",race_data[race_id].name), "LEFT", num_columns)
					Archy_LDB_Tooltip:AddSeparator()
					line = Archy_LDB_Tooltip:AddLine(" ")
					Archy_LDB_Tooltip:SetCell(line, 1, " ", "LEFT", 1)
					Archy_LDB_Tooltip:SetCell(line, 2, _G.NORMAL_FONT_COLOR_CODE .._G.ITEM_MISSING:format(_G.ITEM_QUALITY3_DESC) .. "|r", "LEFT", 1)
					Archy_LDB_Tooltip:SetCell(line, 3, _G.NORMAL_FONT_COLOR_CODE .._G.ITEM_MISSING:format(_G.ITEM_QUALITY1_DESC) .. "|r", "LEFT", 2)
					GetArtifactsDelta(race_id, missing_data)
					local startline, endline
					for artifact,info in pairs(missing_data) do -- rares first
						if not count_descriptors[artifact] and info.rarity > 0 then
							line = Archy_LDB_Tooltip:AddLine(" ")
							Archy_LDB_Tooltip:SetCell(line, 1, " ", "LEFT", 1)
							Archy_LDB_Tooltip:SetCell(line, 2, ("%s%s|r"):format(_G.ITEM_QUALITY_COLORS[3].hex,artifact) .. "*", "LEFT", 1)
							Archy_LDB_Tooltip:SetCellScript(line, 2, "OnMouseDown", Archy_cell_script, "spellid:"..info.spellid)
							if not startline then startline = line end
							endline = line
						end
					end	
					if endline and endline >= startline then -- commons next (not exhaustive)
						local line, cell = startline, 3
						for artifact,info in pairs(missing_data) do 
							if not count_descriptors[artifact] and info.rarity == 0 then
								if line <= endline and cell <= 5 then
									Archy_LDB_Tooltip:SetCell(line, cell, ("%s%s|r"):format(_G.ITEM_QUALITY_COLORS[1].hex,artifact), "LEFT", 2)
									cell = cell + 2
									if cell > 5 then line = line + 1; cell = 3 end
								else
									break
								end
							end
						end
					end
					break
				end
			end
		end
	else
		line = Archy_LDB_Tooltip:AddLine(" ")
		Archy_LDB_Tooltip:SetCell(line, 1, L["Learn Archaeology in your nearest major city!"], "CENTER", num_columns)
	end
	line = Archy_LDB_Tooltip:AddLine(" ")
	line = Archy_LDB_Tooltip:AddLine(" ") Archy_LDB_Tooltip:SetCell(line, 1, "|cFF00FF00" .. L["*Interactive tooltip region(s)"] .. "|r", "LEFT", num_columns)
	line = Archy_LDB_Tooltip:AddLine(" ") Archy_LDB_Tooltip:SetCell(line, 1, "|cFF00FF00" .. L["Left-Click to toggle Archy"] .. "|r", "LEFT", num_columns)
	line = Archy_LDB_Tooltip:AddLine(" ") Archy_LDB_Tooltip:SetCell(line, 1, "|cFF00FF00" .. L["Shift Left-Click to toggle Archy's on-screen lists"] .. "|r", "LEFT", num_columns)
	line = Archy_LDB_Tooltip:AddLine(" ") Archy_LDB_Tooltip:SetCell(line, 1, "|cFF00FF00" .. L["Ctrl Left-Click to open Archy's options"] .. "|r", "LEFT", num_columns)
	line = Archy_LDB_Tooltip:AddLine(" ") Archy_LDB_Tooltip:SetCell(line, 1, "|cFF00FF00" .. L["Right-Click to lock/unlock Archy"] .. "|r", "LEFT", num_columns)
	line = Archy_LDB_Tooltip:AddLine(" ") Archy_LDB_Tooltip:SetCell(line, 1, "|cFF00FF00" .. L["Middle-Click to display the Archaeology window"] .. "|r", "LEFT", num_columns)

	Archy_LDB_Tooltip:UpdateScrolling()
	Archy_LDB_Tooltip:Show()
end

function LDB_object:OnEnter()
	if IsTaintable() then
		return
	end
	Archy_LDB_Tooltip = QTip:Acquire("ArchyTooltip")
	Archy_LDB_Tooltip:SetScale(private.db.tooltip.scale)
	Archy_LDB_Tooltip:SetAutoHideDelay(0.25, self)
	Archy_LDB_Tooltip:EnableMouse()
	Archy_LDB_Tooltip:SmartAnchorTo(self)
	
	Archy:LDBTooltipShow()
end

function LDB_object:OnLeave()
	-- This empty function is required for LDB displays which refuse to call an OnEnter without an OnLeave.
end

function LDB_object:OnClick(button, down)
	if button == "LeftButton" then
		if _G.IsShiftKeyDown() then
			private.db.general.stealthMode = not private.db.general.stealthMode
			Archy:ConfigUpdated()
		elseif _G.IsControlKeyDown() then
			_G.InterfaceOptionsFrame_OpenToCategory(Archy.optionsFrame)
		else
			private.db.general.show = not private.db.general.show
			Archy:ConfigUpdated()
		end
	elseif button == "RightButton" then
		private.db.general.locked = not private.db.general.locked
		Archy:Print(private.db.general.locked and _G.LOCKED or _G.UNLOCK)
		Archy:ConfigUpdated()
	elseif button == "MiddleButton" then
		Archy:ShowArchaeology()
	end
end

-----------------------------------------------------------------------
-- AddOn methods
-----------------------------------------------------------------------
function Archy:ShowArchaeology()
	if _G.IsAddOnLoaded("Blizzard_ArchaeologyUI") then
		if _G.ArchaeologyFrame:IsShown() then
			_G.HideUIPanel(_G.ArchaeologyFrame)
		else
			_G.ShowUIPanel(_G.ArchaeologyFrame)
		end
		return true
	end
	local loaded, reason = _G.LoadAddOn("Blizzard_ArchaeologyUI")

	if loaded then
		if _G.ArchaeologyFrame:IsShown() then
			_G.HideUIPanel(_G.ArchaeologyFrame)
		else
			_G.ShowUIPanel(_G.ArchaeologyFrame)
		end
		return true
	else
		Archy:Print(L["ArchaeologyUI not loaded: %s Try opening manually."]:format(_G["ADDON_" .. reason]))
		return false
	end
end

-- extract the itemid from the itemlink
local function GetIDFromLink(link)
	if not link then
		return
	end
	local found, _, str = link:find("^|c%x+|H(.+)|h%[.+%]")

	if not found then
		return
	end

	local _, id = (":"):split(str)
	return tonumber(id)
end

-- deformat substitute
local function MatchFormat(msg, pattern)
	return msg:match(pattern:gsub("(%%s)", "(.+)"):gsub("(%%d)", "(.+)"))
end


-- return the player, itemlink and quantity of the item in the chat_msg_loot
local function ParseLootMessage(msg)
	local player = _G.UnitName("player")
	local item, quantity = MatchFormat(msg, _G.LOOT_ITEM_SELF_MULTIPLE)

	if item and quantity then
		return player, item, tonumber(quantity)
	end
	quantity = 1
	item = MatchFormat(msg, _G.LOOT_ITEM_SELF)

	if item then
		return player, item, tonumber(quantity)
	end
	player, item, quantity = MatchFormat(msg, _G.LOOT_ITEM_MULTIPLE)

	if player and item and quantity then
		return player, item, tonumber(quantity)
	end
	quantity = 1
	player, item = MatchFormat(msg, _G.LOOT_ITEM)

	return player, item, tonumber(quantity)
end

local CONFIG_UPDATE_FUNCTIONS = {
	artifact = function(option)
		if option == "autofill" then
			for race_id = 1, _G.GetNumArchaeologyRaces() do
				UpdateRaceArtifact(race_id)
			end
		elseif option == "color" then
			Archy:RefreshRacesDisplay()
		else
			Archy:UpdateRacesFrame()
			Archy:RefreshRacesDisplay()
			Archy:SetFramePosition(private.races_frame)
		end
	end,
	digsite = function(option)
		if option == "tooltip" then
			UpdateAllSites()
		end
		Archy:UpdateSiteDistances()
		Archy:UpdateDigSiteFrame()

		if option == "font" then 
			Archy:ResizeDigSiteDisplay()
		else
			Archy:RefreshDigSiteDisplay()
		end
		Archy:SetFramePosition(private.digsite_frame)
		Archy:SetFramePosition(private.distance_indicator_frame)
		ToggleDistanceIndicator()
	end,
	minimap = function(option)
		UpdateMinimapPOIs(true)
	end,
	tomtom = function(option)
		local db = private.db

		if db.tomtom.enabled and private.tomtomExists then
			if _G.TomTom.profile then
				_G.TomTom.profile.arrow.arrival = db.tomtom.distance
				_G.TomTom.profile.arrow.enablePing = db.tomtom.ping
			end
		end
		RefreshTomTom()
	end,
}

function Archy:ConfigUpdated(namespace, option)
	if namespace then
		CONFIG_UPDATE_FUNCTIONS[namespace](option)
	else
		self:UpdateRacesFrame()
		self:RefreshRacesDisplay()
		self:UpdateDigSiteFrame()
		self:RefreshDigSiteDisplay()
		self:UpdateTracking()
		ToggleDistanceIndicator()
		UpdateMinimapPOIs(true)
		RefreshTomTom()
		SuspendClickToMove()
	end
end


function Archy:SolveAnyArtifact(use_stones)
	local found = false
	for race_id, artifact in pairs(artifacts) do
		if not private.db.artifact.blacklist[race_id] and (artifact.canSolve or (use_stones and artifact.canSolveInventory)) then
			SolveRaceArtifact(race_id, use_stones)
			found = true
			break
		end
	end

	if not found then
		self:Print(L["No artifacts were solvable"])
	end
end

function Archy:SocketClicked(keystone_button, mouse_button, down)
	local race_id = keystone_button:GetParent():GetParent():GetID()

	if mouse_button == "LeftButton" then
		if artifacts[race_id].keystones_added < artifacts[race_id].sockets and artifacts[race_id].keystones_added < race_data[race_id].keystone.inventory then
			artifacts[race_id].keystones_added = artifacts[race_id].keystones_added + 1
		end
	else
		if artifacts[race_id].keystones_added > 0 then
			artifacts[race_id].keystones_added = artifacts[race_id].keystones_added - 1
		end
	end
	UpdateRaceArtifact(race_id)
	Archy:RefreshRacesDisplay()
end

--[[ Dig Site List Functions ]] --
local function IncrementDigCounter(id)
	local site_stats = Archy.db.char.digsites.stats
	site_stats[id].counter = (site_stats[id].counter or 0) + 1
end

local function CompareAndResetDigCounters(a, b)
	if not a or not b or (#a == 0) or (#b == 0) then
		return
	end

	for _, siteA in pairs(a) do
		local exists = false
		for _, siteB in pairs(b) do
			if siteA.id == siteB.id then
				exists = true
				break
			end
		end

		if not exists then
			--			print(("CompareAndResetDigCounters: Resetting counter for %s"):format(siteA.id))
			Archy.db.char.digsites.stats[siteA.id].counter = 0
		end
	end
end

local DIG_LOCATION_TEXTURE = 177
local function GetContinentSites(continent_id)
	local new_sites = {}
	-- Drii: and this solves the mystery of "location of the digsite is gone missing" ticket 351; 
	-- function fails to populate continent_digsites if showing digsites on the worldmap has been toggled off by the user.
	-- So make sure we enable and show blobs and restore the setting at the end.
	local showDig = _G.GetCVarBool("digSites")
	if not showDig then
		_G.SetCVar("digSites","1")
		_G.WorldMapArchaeologyDigSites:Show()
		_G.WorldMapShowDigSites:SetChecked(1)
		_G.RefreshWorldMap()
		showDig = "0"
	end
	for index = 1, _G.GetNumMapLandmarks() do
		local name, description, texture_index, px, py = _G.GetMapLandmarkInfo(index)

		if texture_index == DIG_LOCATION_TEXTURE then
			local zone_name, map_file, texPctX, texPctY, texX, texY, scrollX, scrollY = _G.UpdateMapHighlight(px, py)
			local site = DIG_SITES[name]
			local mc, fc, mz, fz, zoneID = 0, 0, 0, 0, 0
			mc, fc = Astrolabe:GetMapID(continent_id, 0)
			mz = site.map
			zoneID = MAP_ID_TO_ZONE_ID[mz]

			if site then
				local x, y = Astrolabe:TranslateWorldMapPosition(mc, fc, px, py, mz, fz)

				local raceName, raceCrestTexture = _G.GetArchaeologyRaceInfo(site.race)

				local digsite = {
					continent = mc,
					zoneId = zoneID,
					zoneName = MAP_ID_TO_ZONE_NAME[mz] or _G.UNKNOWN,
					mapFile = map_file,
					map = mz,
					level = fz,
					x = x,
					y = y,
					name = name,
					raceId = site.race,
					id = site.blob_id,
					distance = 999999,
				}
				table.insert(new_sites, digsite)
			end
		end
	end
	if showDig == "0" then -- restore initial setting
		_G.SetCVar("digSites",showDig)
		_G.WorldMapArchaeologyDigSites:Hide()
		_G.WorldMapShowDigSites:SetChecked(nil)
		_G.RefreshWorldMap()
	end
	return new_sites
end

CacheMapData = function()
	if not next(MAP_CONTINENTS) then MAP_CONTINENTS = { _G.GetMapContinents() } end
	for continent_id, continent_name in pairs(MAP_CONTINENTS) do
		_G.SetMapZoom(continent_id)
		local map_id = _G.GetCurrentMapAreaID()
		local map_file_name = _G.GetMapInfo()

		MAP_ID_TO_CONTINENT_ID[map_id] = continent_id
		ZONE_DATA[map_id] = {
			continent = continent_id,
			map = map_id,
			level = 0,
			mapFile = map_file_name,
			id = 0,
			name = continent_name
		}
		MAP_FILENAME_TO_MAP_ID[map_file_name] = map_id
		MAP_ID_TO_ZONE_NAME[map_id] = continent_name

		for zone_id, zone_name in pairs{ _G.GetMapZones(continent_id) } do
			_G.SetMapZoom(continent_id, zone_id)
			local map_id = _G.GetCurrentMapAreaID()
			local level = _G.GetCurrentMapDungeonLevel()
			local map_file_name = _G.GetMapInfo()
			MAP_FILENAME_TO_MAP_ID[map_file_name] = map_id
			MAP_ID_TO_ZONE_ID[map_id] = zone_id
			MAP_ID_TO_ZONE_NAME[map_id] = zone_name
			ZONE_ID_TO_NAME[zone_id] = zone_name
			ZONE_DATA[map_id] = {
				continent = zone_id,
				map = map_id,
				level = level,
				mapFile = map_file_name,
				id = zone_id,
				name = zone_name
			}
		end
	end
	if next(ZONE_DATA) then
		CacheMapData = nil
	end
end

local function UpdateSite(continent_id)
	_G.SetMapZoom(continent_id)

	local sites = GetContinentSites(continent_id)

	if #sites > 0 then
		if continent_digsites[continent_id] then
			CompareAndResetDigCounters(continent_digsites[continent_id], sites)
			CompareAndResetDigCounters(sites, continent_digsites[continent_id])
		end
		continent_digsites[continent_id] = sites
	end
end

UpdateAllSites = function()
	-- Set this for restoration at the end of the loop since it's changed when UpdateSite() is called.
	local original_map_id = _G.GetCurrentMapAreaID()
	if CacheMapData then CacheMapData() end -- Drii: runs only until ZONE_DATA is populated
	if next(MAP_CONTINENTS) then
		for continent_id, continent_name in pairs(MAP_CONTINENTS) do
			UpdateSite(continent_id)
		end
	end
	_G.SetMapByID(original_map_id)
end

function Archy:IsSiteBlacklisted(name)
	return self.db.char.digsites.blacklist[name]
end

function Archy:ToggleSiteBlacklist(name)
	self.db.char.digsites.blacklist[name] = not self.db.char.digsites.blacklist[name]
end

local function SortSitesByDistance(a, b)
	if Archy:IsSiteBlacklisted(a.name) and not Archy:IsSiteBlacklisted(b.name) then
		return 1 < 0
	elseif not Archy:IsSiteBlacklisted(a.name) and Archy:IsSiteBlacklisted(b.name) then
		return 0 < 1
	end

	if (a.distance == -1 and b.distance == -1) or (not a.distance and not b.distance) then
		return a.zoneName .. ":" .. a.name < b.zoneName .. ":" .. b.name
	else
		return (a.distance or 0) < (b.distance or 0)
	end
end

local function SortSitesByName(a, b)
	return a.zoneName .. ":" .. a.name < b.zoneName .. ":" .. b.name
end

function Archy:UpdateSiteDistances()
	if not continent_digsites[MAP_ID_TO_CONTINENT_ID[current_continent]] or (#continent_digsites[MAP_ID_TO_CONTINENT_ID[current_continent]] == 0) then
		nearestSite = nil
		return
	end
	local distance, nearest

	for index = 1, SITES_PER_CONTINENT do
		local site = continent_digsites[MAP_ID_TO_CONTINENT_ID[current_continent]][index]

		if site.poi then
			site.distance = Astrolabe:GetDistanceToIcon(site.poi)
		else
			site.distance = Astrolabe:ComputeDistance(player_position.map, player_position.level, player_position.x, player_position.y, site.map, site.level, site.x, site.y)
		end
		if not Archy:IsSiteBlacklisted(site.name) then
			if not distance or site.distance < distance then
				distance = site.distance
				nearest = site
			end
		end
	end

	if nearest and (not nearestSite or nearestSite.id ~= nearest.id) then
		-- nearest dig site has changed
		nearestSite = nearest
		tomtomActive = true
		RefreshTomTom()
		UpdateMinimapPOIs()

		if private.db.digsite.announceNearest and private.db.general.show then
			AnnounceNearestSite()
		end
	end

	-- Sort sites
	local sites = continent_digsites[MAP_ID_TO_CONTINENT_ID[current_continent]]
	if private.db.digsite.sortByDistance then
		table.sort(sites, SortSitesByDistance)
	else -- sort by zone then name
		table.sort(sites, SortSitesByName)
	end
end

function Archy:ImportOldStatsDB()
	local site_stats = self.db.char.digsites.stats

	for key, st in pairs(self.db.char.digsites) do
		if type(key)=="string" and key ~= "blacklist" and key ~= "stats" and key ~= "counter" and key ~= "" then
			if DIG_SITES[key] then -- Drii: DIG_SITES has a custom metatable so this would add ANY key passed and set it to the EMPTY_DIGSITE table; was this corrupting the SV? ticket 380
				local site = DIG_SITES[key]
				if type(site.blob_id) == "number" and site.blob_id > 0 then -- Drii: make sure we're not puting whatever trash was passed into the stats SV.
					site_stats[site.blob_id].surveys = (site_stats[site.blob_id].surveys or 0) + (st.surveys or 0)
					site_stats[site.blob_id].fragments = (site_stats[site.blob_id].fragments or 0) + (st.fragments or 0)
					site_stats[site.blob_id].looted = (site_stats[site.blob_id].looted or 0) + (st.looted or 0)
					site_stats[site.blob_id].keystones = (site_stats[site.blob_id].keystones or 0) + (st.keystones or 0)
					self.db.char.digsites[key] = nil
				end
			end
		end
	end
	-- Drii: let's also try to fix whatever crap was put in the SV by the old version of this function so users don't have to delete their variables.
	if next(site_stats) then
		for blobid, _ in pairs(site_stats) do
			if type(blobid)=="number" and blobid > 0 then
			else
				site_stats[blobid] = nil
			end
		end
	end
	
end

--[[ Survey Functions ]] --
local function AddSurveyNode(siteId, map, level, x, y)
	local newNode = {
		m = map,
		f = level,
		x = x,
		y = y
	}
	local exists = false

	if not Archy.db.global.surveyNodes then
		Archy.db.global.surveyNodes = {}
	end

	if not Archy.db.global.surveyNodes[siteId] then
		Archy.db.global.surveyNodes[siteId] = {}
	end

	for _, node in pairs(Archy.db.global.surveyNodes[siteId]) do
		local distance = Astrolabe:ComputeDistance(newNode.m, newNode.f, newNode.x, newNode.y, node.m, node.f, node.x, node.y)

		if not distance or _G.IsInInstance() then
			distance = 0
		end

		if distance <= 10 then
			exists = true
			break
		end
	end
	if not exists then
		table.insert(Archy.db.global.surveyNodes[siteId], newNode)
	end
end

local DISTANCE_COLOR_TEXCOORDS = {
	green = {
		0, 0.24609375, 0, 1
	},
	yellow = {
		0.24609375, 0.5, 0, 1
	},
	red = {
		0.5, 0.75, 0, 1
	},
}
local function SetDistanceIndicatorColor(color)
	private.distance_indicator_frame.circle.texture:SetTexCoord(unpack(DISTANCE_COLOR_TEXCOORDS[color]))
	private.distance_indicator_frame.circle:SetAlpha(1)
	ToggleDistanceIndicator()
end

local function UpdateDistanceIndicator()
	if survey_location.x == 0 and survey_location.y == 0 or _G.IsInInstance() then
		return
	end
	local distance = Astrolabe:ComputeDistance(player_position.map, player_position.level, player_position.x, player_position.y, survey_location.map, survey_location.level, survey_location.x, survey_location.y)

	if not distance then
		distance = 0
	end
	local greenMin, greenMax = 0, private.db.digsite.distanceIndicator.green
	local yellowMin, yellowMax = greenMax, private.db.digsite.distanceIndicator.yellow
	local redMin, redMax = yellowMax, 500

	if distance >= greenMin and distance <= greenMax then
		SetDistanceIndicatorColor("green")
	elseif distance >= yellowMin and distance <= yellowMax then
		SetDistanceIndicatorColor("yellow")
	elseif distance >= redMin and distance <= redMax then
		SetDistanceIndicatorColor("red")
	else
		ToggleDistanceIndicator()
		return
	end
	private.distance_indicator_frame.circle.distance:SetFormattedText("%1.f", distance)
end


--[[ Minimap Functions ]] --
local sitePool = {}
local surveyPool = {}
local allPois = {}
local sitePoiCount, surveyPoiCount = 0, 0

local function GetSitePOI(siteId, map, level, x, y, tooltip)
	local poi = table.remove(sitePool)

	if not poi then
		sitePoiCount = sitePoiCount + 1
		poi = _G.CreateFrame("Frame", "ArchyMinimap_SitePOI" .. sitePoiCount, _G.Minimap)
		poi.index = sitePoiCount
		poi:SetWidth(10)
		poi:SetHeight(10)

		table.insert(allPois, poi)

		poi.icon = poi:CreateTexture("BACKGROUND")
		poi.icon:SetTexture([[Interface\Archeology\Arch-Icon-Marker.blp]])
		poi.icon:SetPoint("CENTER", 0, 0)
		poi.icon:SetHeight(14)
		poi.icon:SetWidth(14)
		poi.icon:Hide()

		poi.arrow = poi:CreateTexture("BACKGROUND")
		poi.arrow:SetTexture([[Interface\Minimap\ROTATING-MINIMAPGUIDEARROW.tga]])
		poi.arrow:SetPoint("CENTER", 0, 0)
		poi.arrow:SetWidth(32)
		poi.arrow:SetHeight(32)
		poi.arrow:Hide()
		poi:Hide()
	end
	poi:SetScript("OnEnter", POI_OnEnter)
	poi:SetScript("OnLeave", POI_OnLeave)
	poi:SetScript("OnUpdate", Arrow_OnUpdate)
	poi.type = "site"
	poi.tooltip = tooltip
	poi.location = {
		map,
		level,
		x,
		y
	}
	poi.active = true
	poi.siteId = siteId
	poi.t = 0
	return poi
end

local function ClearSitePOI(poi)
	if not poi then
		return
	end
	Astrolabe:RemoveIconFromMinimap(poi)
	poi.icon:Hide()
	poi.arrow:Hide()
	poi:Hide()
	poi.active = false
	poi.tooltip = nil
	poi.location = nil
	poi.siteId = nil
	poi:SetScript("OnEnter", nil)
	poi:SetScript("OnLeave", nil)
	poi:SetScript("OnUpdate", nil)
	table.insert(sitePool, poi)
end

local function GetSurveyPOI(siteId, map, level, x, y, tooltip)
	local poi = table.remove(surveyPool)

	if not poi then
		surveyPoiCount = surveyPoiCount + 1
		poi = _G.CreateFrame("Frame", "ArchyMinimap_SurveyPOI" .. surveyPoiCount, _G.Minimap)
		poi.index = surveyPoiCount
		poi:SetWidth(8)
		poi:SetHeight(8)

		table.insert(allPois, poi)

		poi.icon = poi:CreateTexture("BACKGROUND")
		poi.icon:SetTexture([[Interface\AddOns\Archy\Media\Nodes]])

		if private.db.minimap.fragmentIcon == "Cross" then
			poi.icon:SetTexCoord(0, 0.46875, 0, 0.453125)
		else
			poi.icon:SetTexCoord(0, 0.234375, 0.5, 0.734375)
		end
		poi.icon:SetPoint("CENTER", 0, 0)
		poi.icon:SetHeight(8)
		poi.icon:SetWidth(8)
		poi.icon:Hide()

		poi:Hide()
	end
	poi:SetScript("OnEnter", POI_OnEnter)
	poi:SetScript("OnLeave", POI_OnLeave)
	poi:SetScript("OnUpdate", Arrow_OnUpdate)
	poi.type = "survey"
	poi.tooltip = tooltip
	poi.location = {
		map,
		level,
		x,
		y
	}
	poi.active = true
	poi.siteId = siteId
	poi.t = 0
	return poi
end

local function ClearSurveyPOI(poi)
	if not poi then
		return
	end
	Astrolabe:RemoveIconFromMinimap(poi)
	poi.icon:Hide()
	poi:Hide()
	poi.active = nil
	poi.tooltip = nil
	poi.siteId = nil
	poi.location = nil
	poi:SetScript("OnEnter", nil)
	poi:SetScript("OnLeave", nil)
	poi:SetScript("OnUpdate", nil)
	table.insert(surveyPool, poi)
end

-- TODO: Figure out if this should be used somewhere - it currently is not, and should maybe be removed.
local function CreateMinimapPOI(index, type, loc, title, siteId)
	local poi = pois[index]
	local poiButton = _G.CreateFrame("Frame", nil, poi)
	poiButton.texture = poiButton:CreateTexture(nil, "OVERLAY")

	if type == "site" then
		poi.useArrow = true
		poiButton.texture:SetTexture([[Interface\Archeology\Arch-Icon-Marker.blp]])
		poiButton:SetWidth(14)
		poiButton:SetHeight(14)
	else
		poi.useArrow = false
		poiButton.texture:SetTexture([[Interface\AddOns\Archy\Media\Nodes]])
		if private.db.minimap.fragmentIcon == "Cross" then
			poiButton.texture:SetTexCoord(0, 0.46875, 0, 0.453125)
		else
			poiButton.texture:SetTexCoord(0, 0.234375, 0.5, 0.734375)
		end
		poiButton:SetWidth(8)
		poiButton:SetHeight(8)
	end
	poiButton.texture:SetAllPoints(poiButton)
	poiButton:SetPoint("CENTER", poi)
	poiButton:SetScale(1)
	poiButton:SetParent(poi)
	poiButton:EnableMouse(false)
	poi.poiButton = poiButton
	poi.index = index
	poi.type = type
	poi.title = title
	poi.location = loc
	poi.active = true
	poi.siteId = siteId
	pois[index] = poi
	return poi
end

-- TODO: Figure out if this should be used somewhere - it currently is not, and should maybe be removed.
local function UpdateMinimapEdges()
	for id, poi in pairs(allPois) do
		if poi.active then
			local edge = Astrolabe:IsIconOnEdge(poi)
			if poi.type == "site" then
				if edge then
					poi.icon:Hide()
					poi.arrow:Show()
				else
					poi.icon:Show()
					poi.arrow:Hide()
				end
			else
				if edge then
					poi.icon:Hide()
					poi:Hide()
				else
					poi.icon:Show()
					poi:Show()
				end
			end
		end
	end
end

local lastNearestSite

local function GetContinentSiteIDs()
	local validSiteIDs = {}

	if private.db.general.show and private.db.minimap.show then
		return validSiteIDs
	end

	if continent_digsites[MAP_ID_TO_CONTINENT_ID[current_continent]] then
		for _, site in pairs(continent_digsites[MAP_ID_TO_CONTINENT_ID[current_continent]]) do
			table.insert(validSiteIDs, site.id)
		end
	end
	return validSiteIDs
end

local function ClearAllPOIs()
	for idx, poi in ipairs(allPois) do
		if poi.type == "site" then
			ClearSitePOI(poi)
		elseif poi.type == "survey" then
			ClearSurveyPOI(poi)
		end
	end
end

local function ClearInvalidPOIs()
	local validSiteIDs = GetContinentSiteIDs()

	for idx, poi in ipairs(allPois) do
		if not validSiteIDs[poi.siteId] then
			if poi.type == "site" then
				ClearSitePOI(poi)
			else
				ClearSurveyPOI(poi)
			end
		elseif poi.type == "survey" and lastNearestSite.id ~= nearestSite.id and lastNearestSite.id == poi.siteId then
			ClearSurveyPOI(poi)
		end
	end
end

function UpdateMinimapPOIs(force)
	if _G.WorldMapButton:IsVisible() then
		return
	end
	if lastNearestSite == nearestSite and not force then
		return
	end
	lastNearestSite = nearestSite

	local sites = continent_digsites[MAP_ID_TO_CONTINENT_ID[current_continent]]

	if not sites or #sites == 0 or _G.IsInInstance() then
		ClearAllPOIs()
		return
	end
	ClearInvalidPOIs()

	if not player_position.x and not player_position.y then
		return
	end
	local i = 1

	for _, site in pairs(sites) do
		site.poi = GetSitePOI(site.id, site.map, site.level, site.x, site.y, ("%s\n(%s)"):format(site.name, site.zoneName))
		site.poi.active = true

		Astrolabe:PlaceIconOnMinimap(site.poi, site.map, site.level, site.x, site.y)

		if (not private.db.minimap.nearest or (nearestSite and nearestSite.id == site.id)) and private.db.general.show and private.db.minimap.show then
			site.poi:Show()
			site.poi.icon:Show()
		else
			site.poi:Hide()
			site.poi.icon:Hide()
		end

		if nearestSite and nearestSite.id == site.id then
			if not site.surveyPOIs then
				site.surveyPOIs = {}
			end

			if Archy.db.global.surveyNodes[site.id] and private.db.minimap.fragmentNodes then
				for index, node in pairs(Archy.db.global.surveyNodes[site.id]) do
					site.surveyPOIs[index] = GetSurveyPOI(site.id, node.m, node.f, node.x, node.y, ("%s #%d\n%s\n(%s)"):format(L["Survey"], index, site.name, site.zoneName))

					local POI = site.surveyPOIs[index]
					POI.active = true

					Astrolabe:PlaceIconOnMinimap(POI, node.m, node.f, node.x, node.y)

					if private.db.general.show then
						POI:Show()
						POI.icon:Show()
					else
						POI:Hide()
						POI.icon:Hide()
					end
					Arrow_OnUpdate(POI, 5)
				end
			end
		end

		Arrow_OnUpdate(site.poi, 5)
	end
	--UpdateMinimapEdges()
	if private.db.minimap.fragmentColorBySurveyDistance and private.db.minimap.fragmentIcon ~= "CyanDot" then
		for id, poi in pairs(allPois) do
			if poi.active and poi.type == "survey" then
				poi.icon:SetTexCoord(0, 0.234375, 0.5, 0.734375)
			end
		end
	end
end

--[[ TomTom Functions ]] --
-- clear the waypoint we gave tomtom
function ClearTomTomPoint()
	if not tomtomPoint then
		return
	end
	tomtomPoint = _G.TomTom:RemoveWaypoint(tomtomPoint)
end

function UpdateTomTomPoint()
	if not tomtomSite and not nearestSite then
		-- we have no information to pass tomtom
		ClearTomTomPoint()
		return
	end

	if nearestSite then
		tomtomSite = nearestSite
	else
		nearestSite = tomtomSite
	end

	if not tomtomFrame then
		tomtomFrame = _G.CreateFrame("Frame")
	end

	if not tomtomFrame:IsShown() then
		tomtomFrame:Show()
	end
	local waypointExists

	if _G.TomTom.WaypointExists then -- do we have the legit TomTom?
		waypointExists = _G.TomTom:WaypointExists(MAP_ID_TO_CONTINENT_ID[tomtomSite.continent], tomtomSite.zoneId, tomtomSite.x * 100, tomtomSite.y * 100, tomtomSite.name .. "\n" .. tomtomSite.zoneName)
	end

	if not waypointExists then -- waypoint doesn't exist or we have a TomTom emulator
		ClearTomTomPoint()
		tomtomPoint = _G.TomTom:AddZWaypoint(MAP_ID_TO_CONTINENT_ID[tomtomSite.continent], tomtomSite.zoneId, tomtomSite.x * 100, tomtomSite.y * 100, tomtomSite.name .. "\n" .. tomtomSite.zoneName, false, false, false, false, false, true)
	end
end

function RefreshTomTom()
	if private.db.general.show and private.db.tomtom.enabled and private.tomtomExists and tomtomActive then
		UpdateTomTomPoint()
	else
		if private.db.tomtom.enabled and not private.tomtomExists then
			-- TomTom (or emulator) was disabled, disabling TomTom support
			private.db.tomtom.enabled = false
			Archy:Print("TomTom doesn't exist... disabling it")
		end

		if tomtomPoint then
			ClearTomTomPoint()
			tomtomPoint = nil
		end

		if tomtomFrame then
			if tomtomFrame:IsShown() then
				tomtomFrame:Hide()
			end
			tomtomFrame = nil
		end
	end
end

--[[ Slash command handler ]] --
local function SlashHandler(msg, editbox)
	local command = msg:lower()

	if command == L["config"]:lower() then
		_G.InterfaceOptionsFrame_OpenToCategory(Archy.optionsFrame)
	elseif command == L["stealth"]:lower() then
		private.db.general.stealthMode = not private.db.general.stealthMode
		Archy:ConfigUpdated()
	elseif command == L["dig sites"]:lower() then
		private.db.digsite.show = not private.db.digsite.show
		Archy:ConfigUpdated('digsite')
	elseif command == L["artifacts"]:lower() then
		private.db.artifact.show = not private.db.artifact.show
		Archy:ConfigUpdated('artifact')
	elseif command == _G.SOLVE:lower() then
		Archy:SolveAnyArtifact()
	elseif command == L["solve stone"]:lower() then
		Archy:SolveAnyArtifact(true)
	elseif command == L["nearest"]:lower() or command == L["closest"]:lower() then
		AnnounceNearestSite()
	elseif command == L["reset"]:lower() then
		private:ResetPositions()
	elseif command == ("TomTom"):lower() then
		private.db.tomtom.enabled = not private.db.tomtom.enabled
		RefreshTomTom()
	elseif command == _G.MINIMAP_LABEL:lower() then
		private.db.minimap.show = not private.db.minimap.show
		Archy:ConfigUpdated('minimap')
	elseif command == "test" then
		private.races_frame:SetBackdropBorderColor(1, 1, 1, 0.5)
	else
		Archy:Print(L["Available commands are:"])
		Archy:Print("|cFF00FF00" .. L["config"] .. "|r - " .. L["Shows the Options"])
		Archy:Print("|cFF00FF00" .. L["stealth"] .. "|r - " .. L["Toggles the display of the Artifacts and Dig Sites lists"])
		Archy:Print("|cFF00FF00" .. L["dig sites"] .. "|r - " .. L["Toggles the display of the Dig Sites list"])
		Archy:Print("|cFF00FF00" .. L["artifacts"] .. "|r - " .. L["Toggles the display of the Artifacts list"])
		Archy:Print("|cFF00FF00" .. _G.SOLVE .. "|r - " .. L["Solves the first artifact it finds that it can solve"])
		Archy:Print("|cFF00FF00" .. L["solve stone"] .. "|r - " .. L["Solves the first artifact it finds that it can solve (including key stones)"])
		Archy:Print("|cFF00FF00" .. L["nearest"] .. "|r or |cFF00FF00" .. L["closest"] .. "|r - " .. L["Announces the nearest dig site to you"])
		Archy:Print("|cFF00FF00" .. L["reset"] .. "|r - " .. L["Reset the window positions to defaults"])
		Archy:Print("|cFF00FF00" .. "TomTom" .. "|r - " .. L["Toggles TomTom Integration"])
		Archy:Print("|cFF00FF00" .. _G.MINIMAP_LABEL .. "|r - " .. L["Toggles the dig site icons on the minimap"])
	end
end

Toast:Register("Archy_Toast", function(toast, ...)
	toast:SetTitle(ADDON_NAME)
	toast:SetText(...)
	toast:SetIconTexture([[Interface\Archeology\Arch-Icon-Marker]])
end)

local function SpawnToast(source, text, r, g, b, ...)
	Toast:Spawn("Archy_Toast", text)
end

function Archy:OnInitialize() -- @ADDON_LOADED (1)
	self.db = LibStub("AceDB-3.0"):New("ArchyDB", PROFILE_DEFAULTS, 'Default')
	self.db.RegisterCallback(self, "OnNewProfile", "OnProfileUpdate")
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileUpdate")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileUpdate")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileUpdate")

	local about_panel = LibStub:GetLibrary("LibAboutPanel", true)

	if about_panel then
		self.optionsFrame = about_panel.new(nil, "Archy")
	end
	self:RegisterSink(L["Toast"], L["Toast"], L["Shows messages in a toast window."], SpawnToast)
	self:SetSinkStorage(Archy.db.profile.general.sinkOptions)
	self:SetupOptions()

	if not self.db.global.surveyNodes then
		self.db.global.surveyNodes = {}
	end

	if not self.db.char.digsites then
		self.db.char.digsites = {
			stats = {},
			blacklist = {}
		}
	end
	
	if not self.db.char.digsites.stats then self.db.char.digsites.stats = {} end -- Drii: ticket 362,363 old Archy SV that had self.db.char.digsites but no stats, blacklist tables?
	setmetatable(self.db.char.digsites.stats, {
		__index = function(t, k)
			if k then
				t[k] = {
					surveys = 0,
					fragments = 0,
					looted = 0,
					keystones = 0,
					counter = 0
				}
				return t[k]
			end
		end
	})

	if not self.db.char.digsites.blacklist then self.db.char.digsites.blacklist = {} end -- Drii: ticket 362,363
	setmetatable(self.db.char.digsites.blacklist, {
		__index = function(t, k)
			if k then
				t[k] = false
				return t[k]
			end
		end
	})
	private.db = self.db.profile
	prevTheme = private.db and private.db.general and private.db.general.theme or PROFILE_DEFAULTS.profile.general.theme

	if not private.db.data then
		private.db.data = {}
	end
	private.db.data.imported = false

	LDBI:Register("Archy", LDB_object, private.db.general.icon)
	
	if not SECURE_ACTION_BUTTON then
		local button_name = "Archy_SurveyButton"
		local button = _G.CreateFrame("Button", button_name, _G.UIParent, "SecureActionButtonTemplate")
		button:SetPoint("LEFT", _G.UIParent, "RIGHT", 10000, 0)
		button:Hide()
		button:SetFrameStrata("LOW")
		button:EnableMouse(true)
		button:RegisterForClicks("RightButtonUp")
		button.name = button_name
		button:SetAttribute("type", "spell")
		button:SetAttribute("spell", SURVEY_SPELL_ID)
		button:SetAttribute("action", nil)
	
		button:SetScript("PostClick", function()
			if not IsTaintable() then
				_G.ClearOverrideBindings(_G[button_name])
				overrideOn = false
			else
				private.regen_clear_override = true
			end
		end)
	
		SECURE_ACTION_BUTTON = button
	end
	
	do
		local clicked_time
		local ACTION_DOUBLE_WAIT = 0.4
		local MIN_ACTION_DOUBLECLICK = 0.05

		_G.WorldFrame:HookScript("OnMouseDown", function(frame, button, down)
			if button == "RightButton" and private.db.general.easyCast and _G.ArchaeologyMapUpdateAll() > 0 and not IsTaintable() and not ShouldBeHidden() and not IsUsableSpell(FISHING_SPELL_NAME) then
				local perform_survey = false

				if not is_looting and clicked_time then
					local pressTime = _G.GetTime()
					local doubleTime = pressTime - clicked_time

					if doubleTime < ACTION_DOUBLE_WAIT and doubleTime > MIN_ACTION_DOUBLECLICK then
						clicked_time = nil
						perform_survey = true
					end
				end
				clicked_time = _G.GetTime()

				if perform_survey then
					-- We're stealing the mouse-up event, make sure we exit MouseLook
					if _G.IsMouselooking() and not IsTaintable() then
						_G.MouselookStop()
					end
					_G.SetOverrideBindingClick(SECURE_ACTION_BUTTON, true, "BUTTON2", SECURE_ACTION_BUTTON.name)
					overrideOn = true
				end
			end
		end)
	end
	self:ImportOldStatsDB()
	
end

function Archy:UpdateFramePositions()
	self:SetFramePosition(private.distance_indicator_frame)
	self:SetFramePosition(private.digsite_frame)
	self:SetFramePosition(private.races_frame)
end

local function InitializeFrames()
	if IsTaintable() then
		private.regen_create_frames = true
		return
	end
	private.digsite_frame = _G.CreateFrame("Frame", "ArchyDigSiteFrame", _G.UIParent, (private.db.general.theme == "Graphical" and "ArchyDigSiteContainer" or "ArchyMinDigSiteContainer"))
	private.digsite_frame.children = setmetatable({}, {
		__index = function(t, k)
			if k then
				local f = _G.CreateFrame("Frame", "ArchyDigSiteChildFrame" .. k, private.digsite_frame, (private.db.general.theme == "Graphical" and "ArchyDigSiteRowTemplate" or "ArchyMinDigSiteRowTemplate"))
				f:Show()
				t[k] = f
				return f
			end
		end
	})
	private.races_frame = _G.CreateFrame("Frame", "ArchyArtifactFrame", _G.UIParent, (private.db.general.theme == "Graphical" and "ArchyArtifactContainer" or "ArchyMinArtifactContainer"))
	private.races_frame.children = setmetatable({}, {
		__index = function(t, k)
			if k then
				local f = _G.CreateFrame("Frame", "ArchyArtifactChildFrame" .. k, private.races_frame, (private.db.general.theme == "Graphical" and "ArchyArtifactRowTemplate" or "ArchyMinArtifactRowTemplate"))
				f:Show()
				t[k] = f
				return f
			end
		end
	})

	private.distance_indicator_frame = _G.CreateFrame("Frame", "ArchyDistanceIndicatorFrame", _G.UIParent, "ArchyDistanceIndicator")
	private.distance_indicator_frame.surveyButton:SetText(_G.GetSpellInfo(SURVEY_SPELL_ID))
	private.distance_indicator_frame.surveyButton:SetWidth(private.distance_indicator_frame.surveyButton:GetTextWidth() + 20)
	private.distance_indicator_frame.circle:SetScale(0.65)
	
	private.frames_init_done = true
	
	Archy:UpdateFramePositions()
	Archy:UpdateDigSiteFrame()
	Archy:UpdateRacesFrame()
end

local timer_handle

function Archy:OnEnable() -- @PLAYER_LOGIN (2)
	_G["SLASH_ARCHY1"] = "/archy"
	_G.SlashCmdList["ARCHY"] = SlashHandler

	--    self:RegisterEvent("ARTIFACT_UPDATE", "ArtifactUpdated")
	self:RegisterEvent("ARTIFACT_COMPLETE")
	self:RegisterEvent("ARTIFACT_DIG_SITE_UPDATED")
	self:RegisterEvent("CHAT_MSG_LOOT", "LootReceived")
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	self:RegisterEvent("LOOT_OPENED", "OnPlayerLooting")
	self:RegisterEvent("LOOT_CLOSED", "OnPlayerLooting")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("SKILL_LINES_CHANGED", "UpdateSkillBar")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("QUEST_LOG_UPDATE") -- Drii: delay loading Blizzard_ArchaeologyUI until QUEST_LOG_UPDATE so races main page doesn't bug.

	self:RegisterBucketEvent("ARTIFACT_HISTORY_READY", 0.2)
	self:RegisterBucketEvent("BAG_UPDATE", 0.2)

	private.db.general.locked = false

	InitializeFrames()
	self:UpdateTracking()
	tomtomActive = true
	private.tomtomExists = (_G.TomTom and _G.TomTom.AddZWaypoint and _G.TomTom.RemoveWaypoint) and true or false
	-- Drii: workaround for TomTom bug ticket 384
 	private.tomtomPoiIntegration = private.tomtomExists and (_G.TomTom.profile and _G.TomTom.profile.poi and _G.TomTom.EnableDisablePOIIntegration) and true or false

	-- Check for minimap AddOns.
	local mbf = LibStub("AceAddon-3.0"):GetAddon("Minimap Button Frame", true)
	if mbf then
		local foundMBF = false
		if _G.MBF.db.profile.MinimapIcons then
			for i, button in pairs(_G.MBF.db.profile.MinimapIcons) do
				local lower_button = button:lower()
	
				if lower_button == "archyminimap" or lower_button == "archyminimap_" then
					foundMBF = true
					break
				end
			end
	
			if not foundMBF then
				table.insert(_G.MBF.db.profile.MinimapIcons, "ArchyMinimap")
				self:Print("Adding Archy to the MinimapButtonFrame protected items list")
			end
		end		
	end

end

function Archy:OnDisable()
	self:CancelTimer(timer_handle)
end

function Archy:OnProfileUpdate(event, database, ProfileKey)
	local newTheme
	if database then
		if event == "OnProfileChanged" or event == "OnProfileCopied" then
			newTheme = database.profile and database.profile.general and database.profile.general.theme or PROFILE_DEFAULTS.profile.general.theme
		elseif event == "OnProfileReset" or event == "OnNewProfile" then
			newTheme = database.defaults and database.defaults.profile and database.defaults.profile.general and database.defaults.profile.general.theme
		end
	end
	private.db = database and database.profile or self.db.profile
	if newTheme ~= prevTheme then
		_G.ReloadUI() 
	end
	if private.frames_init_done then -- Drii: ticket 394 'OnNewProfile' fires for fresh installations too it seems.
		self:ConfigUpdated()
		self:UpdateFramePositions()
	end
end

-----------------------------------------------------------------------
-- Event handlers.
-----------------------------------------------------------------------
function Archy:ADDON_LOADED(event, addon)
	if addon == "Blizzard_BattlefieldMinimap" then
		if not private.battlefield_hooked then
			_G.BattlefieldMinimap:HookScript("OnShow",Archy.UpdateTracking)
			private.battlefield_hooked = true
		end
		Archy:UnregisterEvent("ADDON_LOADED")
	end
end

function Archy:GET_ITEM_INFO_RECEIVED(event)
	for k, itemID in next, race_data_uncached, nil do
		local itemName, _, _, _, _, _, _, _, _, itemTexture, _ = _G.GetItemInfo(itemID)
		if itemName and itemTexture then
			race_data_uncached[k] = nil
			race_data[k].keystone.name = itemName
			race_data[k].keystone.texture = itemTexture
		end
	end
	if not next(race_data_uncached) then
		Archy:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
	end
end

function Archy:ARTIFACT_COMPLETE(event, name)
	for race_id, artifact in pairs(artifacts) do
		if artifact.name == name then
			if has_pinged[name] then has_pinged[name] = nil end       -- Drii: see if this helps with ticket 377 
			if has_announced[name] then has_announced[name] = nil end -- (alerts not working if the same common artifact pops up after solving it)
			UpdateRaceArtifact(race_id) -- this is still the artifact that was just solved when the event fires
			self:ScheduleTimer(function() UpdateRaceArtifact(race_id) Archy:RefreshRacesDisplay() end, 2)
			break
		end
	end
end

function Archy:ARTIFACT_HISTORY_READY()
	for race_id, artifact in pairs(artifacts) do
		local _, _, completionCount = GetArtifactStats(race_id, artifact.name)
		if completionCount then
			artifact.completionCount = completionCount
		end
	end
	self:RefreshRacesDisplay()
end

function Archy:ArtifactUpdated()
	-- ignore this event for now as it's can break other Archaeology UIs
	-- Would have been nice if Blizzard passed the race index or artifact name with the event
end

function Archy:ARTIFACT_DIG_SITE_UPDATED()
	if not current_continent then
		return
	end
	UpdateAllSites()
	self:UpdateSiteDistances()
	self:RefreshDigSiteDisplay()
end

function Archy:BAG_UPDATE()
	if not current_continent or not keystoneLootRaceID then
		return
	end
	UpdateRaceArtifact(keystoneLootRaceID)
	self:RefreshRacesDisplay()
	keystoneLootRaceID = nil
end

function Archy:CURRENCY_DISPLAY_UPDATE()
	if not current_continent or _G.GetNumArchaeologyRaces() == 0 then
		return
	end

	for race_id = 1, _G.GetNumArchaeologyRaces() do
		local _, _, _, currencyAmount = _G.GetArchaeologyRaceInfo(race_id)
		local diff = currencyAmount - (race_data[race_id].currency or 0)

		race_data[race_id].currency = currencyAmount

		if diff < 0 then
			-- we've spent fragments, aka. Solved an artifact
			artifacts[race_id].keystones_added = 0

			if artifactSolved.raceId > 0 then
				local _, _, completionCount = GetArtifactStats(race_id, artifactSolved.name)
				self:Pour(L["You have solved |cFFFFFF00%s|r Artifact - |cFFFFFF00%s|r (Times completed: %d)"]:format(race_data[race_id].name, artifactSolved.name, completionCount or 0), 1, 1, 1)

				artifactSolved.raceId = 0
				artifactSolved.name = ""
			end

		elseif diff > 0 then
			local site_stats = self.db.char.digsites.stats
			-- we've gained fragments, aka. Successfully dug at a dig site

			-- update the artifact info
			UpdateRaceArtifact(race_id)

			distanceIndicatorActive = false
			ToggleDistanceIndicator()
			
			if type(lastSite.id) == "number" and lastSite.id > 0 then -- Drii: for now let's just avoid the error
				IncrementDigCounter(lastSite.id) -- Drii: ticket 380 lastSite.id passed is nil or not a number; why?
				site_stats[lastSite.id].looted = (site_stats[lastSite.id].looted or 0) + 1
				site_stats[lastSite.id].fragments = site_stats[lastSite.id].fragments + diff
	
				AddSurveyNode(lastSite.id, player_position.map, player_position.level, player_position.x, player_position.y)
			end

			survey_location.map = 0
			survey_location.level = 0
			survey_location.x = 0
			survey_location.y = 0

			UpdateMinimapPOIs(true)
			self:RefreshDigSiteDisplay()
		end
	end
	self:RefreshRacesDisplay()
end

function Archy:LootReceived(event, msg)
	local _, itemLink, amount = ParseLootMessage(msg)

	if not itemLink then
		return
	end
	local itemID = GetIDFromLink(itemLink)
	local race_id = keystoneIDToRaceID[itemID]

	if race_id then
		self.db.char.digsites.stats[lastSite.id].keystones = self.db.char.digsites.stats[lastSite.id].keystones + 1
		keystoneLootRaceID = race_id
	end
end

function Archy:QUEST_LOG_UPDATE() -- (4)
	-- Hook and overwrite the default SolveArtifact function to provide confirmations when nearing cap
	if not Blizzard_SolveArtifact then
		if not _G.IsAddOnLoaded("Blizzard_ArchaeologyUI") then 
			local loaded, reason = _G.LoadAddOn("Blizzard_ArchaeologyUI")
			if not loaded then
				Archy:Print(L["ArchaeologyUI not loaded: %s SolveArtifact hook not installed."]:format(_G["ADDON_" .. reason]))
			end
		end
		Blizzard_SolveArtifact = _G.SolveArtifact
		function _G.SolveArtifact(race_index, use_stones)
			local rank, max_rank = GetArchaeologyRank()
			if private.db.general.confirmSolve and max_rank < MAX_ARCHAEOLOGY_RANK and (rank + 25) >= max_rank then
				Dialog:Spawn("ArchyConfirmSolve", {
					race_index = race_index,
					use_stones = use_stones,
					rank = rank,
					max_rank = max_rank
				})
			else
				return SolveRaceArtifact(race_index, use_stones)
			end
		end
	end
	if private.frames_init_done then Archy:ConfigUpdated() end
	self:UnregisterEvent("QUEST_LOG_UPDATE")
	self.QUEST_LOG_UPDATE = nil
end

function Archy:PLAYER_ENTERING_WORLD() -- (3)
 	_G.SetMapToCurrentZone()
	-- Two timers are needed here: If we force a call to UpdatePlayerPosition() too soon, the site distances will not update properly and the notifications may vanish just as the player is able to see them.
	if not timer_handle then
		self:ScheduleTimer(function()
			if private.frames_init_done then
				self:UpdateDigSiteFrame()
				self:UpdateRacesFrame()
			end
			timer_handle = self:ScheduleRepeatingTimer("UpdatePlayerPosition", 0.2)
		end, 1)
	end
	self:ScheduleTimer("UpdatePlayerPosition", 2, true)

	if private.db.tomtom.noerrorwarn and ( private.db.tomtom.noerrorwarn == Archy.version ) then
	  -- 
	elseif private.tomtomPoiIntegration and TomTom.profile.poi.setClosest and not private.tomtomWarning then 
		private.tomtomWarning = true 
		Dialog:Spawn("ArchyTomTomError") 
	end -- Drii: temporary workaround for ticket 384
-- 	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
-- 	self.PLAYER_ENTERING_WORLD = nil
end

function Archy:PLAYER_REGEN_DISABLED()
	private.in_combat = true
	if Archy_LDB_Tooltip and Archy_LDB_Tooltip:IsShown() then Archy_LDB_Tooltip:Hide() end
end

function Archy:PLAYER_REGEN_ENABLED()
	private.in_combat = nil

	if private.regen_create_frames then
		private.regen_create_frames = nil
		InitializeFrames()
	end

	if private.regen_toggle_distance then
		private.regen_toggle_distance = nil
		ToggleDistanceIndicator()
	end
	
	if private.regen_update_tracking then
		private.regen_update_tracking = nil
		self:UpdateTracking()
	end
	
	if private.regen_clear_override then
		private.regen_clear_override = nil
		_G.ClearOverrideBindings(SECURE_ACTION_BUTTON.name)
		overrideOn = false
	end	

	if private.regen_update_digsites then
		private.regen_update_digsites = nil
		self:UpdateDigSiteFrame()
	end
	
	if private.regen_update_races then
		private.regen_update_races = nil
		self:UpdateRacesFrame()
	end
	
end

function Archy:UNIT_SPELLCAST_SUCCEEDED(event, unit, spell, rank, line_id, spell_id)
	if unit ~= "player" or spell_id ~= SURVEY_SPELL_ID then
		return
	end
	
	if not player_position or not nearestSite then
		survey_location.map = 0
		survey_location.level = 0
		survey_location.x = 0
		survey_location.y = 0
		return
	end
	survey_location.x = player_position.x
	survey_location.y = player_position.y
	survey_location.map = player_position.map
	survey_location.level = player_position.level

	distanceIndicatorActive = true
	lastSite = nearestSite
	self.db.char.digsites.stats[lastSite.id].surveys = self.db.char.digsites.stats[lastSite.id].surveys + 1

	ToggleDistanceIndicator()
	UpdateDistanceIndicator()

	if private.distance_indicator_frame.surveyButton and private.distance_indicator_frame.surveyButton:IsShown() then
		local now = GetTime()
		local start, duration, enable = GetSpellCooldown(SURVEY_SPELL_ID)
		if start > 0 and duration > 0 and now < (start + duration) then
			if duration <= 1.5 then -- gcd
				self:ScheduleTimer(function() CooldownFrame_SetTimer(private.distance_indicator_frame.surveyButton.cooldown, GetSpellCooldown(SURVEY_SPELL_ID)) end, (start+duration)-now)
			elseif duration > 1.5 then -- in case they ever take it off the gcd
				CooldownFrame_SetTimer(private.distance_indicator_frame.surveyButton.cooldown, start, duration, enable)
			end
		end
	end
	
	if private.db.minimap.fragmentColorBySurveyDistance then
		local min_green, max_green = 0, private.db.digsite.distanceIndicator.green or 0
		local min_yellow, max_yellow = max_green, private.db.digsite.distanceIndicator.yellow or 0
		local min_red, max_red = max_yellow, 500

		for id, poi in pairs(allPois) do
			if poi.active and poi.type == "survey" then
				local distance = Astrolabe:GetDistanceToIcon(poi)

				if distance >= min_green and distance <= max_green then
					poi.icon:SetTexCoord(0.75, 1, 0.5, 0.734375)
				elseif distance >= min_yellow and distance <= max_yellow then
					poi.icon:SetTexCoord(0.5, 0.734375, 0.5, 0.734375)
				elseif distance >= min_red and distance <= max_red then
					poi.icon:SetTexCoord(0.25, 0.484375, 0.5, 0.734375)
				end
			end
		end
	end
	tomtomActive = false
	RefreshTomTom()
	self:RefreshDigSiteDisplay()
end

function Archy:UpdateSkillBar()
	if not current_continent or not HasArchaeology() then
		return
	end
	local races_frame = private.races_frame

	if not races_frame or not races_frame.skillBar then
		return
	end
	local rank, maxRank = GetArchaeologyRank()

	races_frame.skillBar:SetMinMaxValues(0, maxRank)
	races_frame.skillBar:SetValue(rank)
	races_frame.skillBar.text:SetFormattedText("%s : %d/%d", _G.GetArchaeologyInfo(), rank, maxRank)
end

--[[ Positional functions ]] --
function Archy:UpdatePlayerPosition(force)
	if not private.db.general.show and not force then
		return
	end
	if not HasArchaeology() or _G.IsInInstance() or _G.UnitIsGhost("player") then
		return
	end
	if force then _G.RequestArtifactCompletionHistory() end
	
	if not private.frames_init_done then return end
	
	if _G.GetCurrentMapAreaID() == -1 then
		self:UpdateSiteDistances()
		self:UpdateDigSiteFrame()
		self:RefreshDigSiteDisplay()
		return
	end
	local map, level, x, y = Astrolabe:GetCurrentPlayerPosition()

	if not map or not level or (x == 0 and y == 0) then
		return
	end
	
	if player_position.x ~= x or player_position.y ~= y or player_position.map ~= map or player_position.level ~= level or force then
		player_position.x, player_position.y, player_position.map, player_position.level = x, y, map, level

		self:RefreshAll()
	end
	local continent = Astrolabe:GetMapInfo(map, level) -- Drii: can return nil
	
	if current_continent == continent then
		if force and current_continent then 
			UpdateAllSites()
			ToggleDistanceIndicator()
		elseif force and not continent then
			self:ScheduleTimer("UpdatePlayerPosition", 1, true) -- Drii: get the edge case where continent and current_continent are both nil (nil==nil is true)
		end
		return
	end
	current_continent = continent
	
	if force then ToggleDistanceIndicator() end

	if #race_data == 0 then
		for race_id = 1, _G.GetNumArchaeologyRaces() do
			local race = race_data[race_id] -- metatable should load the data

			if race then
				raceNameToID[race.name] = race_id
				keystoneIDToRaceID[race.keystone.id] = race_id
			end
		end 
		_G.RequestArtifactCompletionHistory()
	end
	ClearTomTomPoint()
	RefreshTomTom()
	UpdateAllSites()

	if _G.GetNumArchaeologyRaces() > 0 then
		for race_id = 1, _G.GetNumArchaeologyRaces() do
			UpdateRaceArtifact(race_id)
		end
		self:UpdateRacesFrame()
		self:RefreshRacesDisplay()
	end
	if force then self:UpdateSiteDistances() end
	self:UpdateDigSiteFrame()
	self:RefreshDigSiteDisplay()
	self:UpdateFramePositions()
end

function Archy:RefreshAll()
	if not _G.IsInInstance() then
		self:UpdateSiteDistances()
		UpdateDistanceIndicator()
		UpdateMinimapPOIs()
	end
	self:RefreshDigSiteDisplay()
end


--[[ UI functions ]] --
local function FontString_SetShadow(fs, hasShadow)
	if hasShadow then
		fs:SetShadowColor(0, 0, 0, 1)
		fs:SetShadowOffset(1, -1)
	else
		fs:SetShadowColor(0, 0, 0, 0)
		fs:SetShadowOffset(0, 0)
	end
end

local function BattleFieldMinimap_Digsites(show)
	if not _G.BattlefieldMinimap then
		Archy:RegisterEvent("ADDON_LOADED")
		return
	end
	if not _G.BattlefieldMinimap:IsShown() then
		if not private.battlefield_hooked then
			_G.BattlefieldMinimap:HookScript("OnShow",Archy.UpdateTracking)
			private.battlefield_hooked = true
		end
		return
	end
	if show then
		if not private.battlefield_digsites then
			private.battlefield_digsites = CreateFrame("ArchaeologyDigSiteFrame","ArchyBattleFieldDigsites",_G.BattlefieldMinimap)
			private.battlefield_digsites:SetSize(225,150)
			private.battlefield_digsites:SetPoint("TOPLEFT", _G.BattlefieldMinimap)
			private.battlefield_digsites:SetPoint("BOTTOMRIGHT", _G.BattlefieldMinimap)
			local tex = private.battlefield_digsites:CreateTexture("ArchyBattleFieldDigsitesTexture", "OVERLAY")
			tex:SetAllPoints()
			private.battlefield_digsites:SetFillAlpha(128)
			private.battlefield_digsites:SetFillTexture("Interface\\WorldMap\\UI-ArchaeologyBlob-Inside")
			private.battlefield_digsites:SetBorderTexture("Interface\\WorldMap\\UI-ArchaeologyBlob-Outside")
			private.battlefield_digsites:EnableSmoothing(true)
			private.battlefield_digsites:SetBorderScalar(0.1)			
			private.battlefield_digsites.lastUpdate = 0
			local function BattlefieldDigsites_OnUpdate(self, elapsed)
				if private.battlefield_digsites.lastUpdate > TOOLTIP_UPDATE_TIME then
					private.battlefield_digsites:DrawNone();
					local numEntries = _G.ArchaeologyMapUpdateAll();
					for i = 1, numEntries do
						local blobID = _G.ArcheologyGetVisibleBlobID(i);
						private.battlefield_digsites:DrawBlob(blobID, true);
					end
					private.battlefield_digsites.lastUpdate = 0
				else
					private.battlefield_digsites.lastUpdate = private.battlefield_digsites.lastUpdate + elapsed
				end
			end
			private.battlefield_digsites:SetScript("OnUpdate",BattlefieldDigsites_OnUpdate)
		end
		private.battlefield_digsites:Show()
	else
		if private.battlefield_digsites then
			private.battlefield_digsites:Hide()
		end
	end
end

function Archy:UpdateTracking()
	if not HasArchaeology() or private.db.general.manualTrack then return end -- do nothing if user has selected to manually configure tracking and blobs.
	if IsTaintable() then -- Drii: need the check for battlefield blobs, if we don't provide those it can be removed
		private.regen_update_tracking = true
		return
	end
	-- manage minimap tracking
	if digsitesTrackingID then
		_G.SetTracking(digsitesTrackingID, private.db.general.show)
	end
	-- manage worldmap and battlefield map digsites display
	_G.SetCVar("digSites", private.db.general.show and "1" or "0")
	local showDig = _G.GetCVarBool("digSites")
	if showDig then 
		_G.WorldMapArchaeologyDigSites:Show()
		BattleFieldMinimap_Digsites(true)
	else
		_G.WorldMapArchaeologyDigSites:Hide()
		BattleFieldMinimap_Digsites(false)
	end
	_G.WorldMapShowDigSites:SetChecked(showDig)
	_G.RefreshWorldMap()
end

function Archy:UpdateRacesFrame()
	if IsTaintable() then
		private.regen_update_races = true
		return
	end
	local races_frame = private.races_frame

	races_frame:SetScale(private.db.artifact.scale)
	races_frame:SetAlpha(private.db.artifact.alpha)

	local is_movable = not private.db.general.locked
	races_frame:SetMovable(is_movable)
	races_frame:EnableMouse(is_movable)

	if is_movable then
		races_frame:RegisterForDrag("LeftButton")
	else
		races_frame:RegisterForDrag()
	end

	local artifact_font_data = private.db.artifact.font
	local artifact_fragment_font_data = private.db.artifact.fragmentFont

	local font = LSM:Fetch("font", artifact_font_data.name)
	local fragment_font = LSM:Fetch("font", artifact_fragment_font_data.name)
	local keystone_font = LSM:Fetch("font", private.db.artifact.keystoneFont.name)

	for _, child in pairs(races_frame.children) do
		if private.db.general.theme == "Graphical" then
			child.fragmentBar.artifact:SetFont(font, artifact_font_data.size, artifact_font_data.outline)
			child.fragmentBar.artifact:SetTextColor(artifact_font_data.color.r, artifact_font_data.color.g, artifact_font_data.color.b, artifact_font_data.color.a)

			child.fragmentBar.fragments:SetFont(fragment_font, artifact_fragment_font_data.size, artifact_fragment_font_data.outline)
			child.fragmentBar.fragments:SetTextColor(artifact_fragment_font_data.color.r, artifact_fragment_font_data.color.g, artifact_fragment_font_data.color.b, artifact_fragment_font_data.color.a)

			child.fragmentBar.keystones.count:SetFont(keystone_font, private.db.artifact.keystoneFont.size, private.db.artifact.keystoneFont.outline)
			child.fragmentBar.keystones.count:SetTextColor(private.db.artifact.keystoneFont.color.r, private.db.artifact.keystoneFont.color.g, private.db.artifact.keystoneFont.color.b, private.db.artifact.keystoneFont.color.a)

			FontString_SetShadow(child.fragmentBar.artifact, artifact_font_data.shadow)
			FontString_SetShadow(child.fragmentBar.fragments, artifact_fragment_font_data.shadow)
			FontString_SetShadow(child.fragmentBar.keystones.count, private.db.artifact.keystoneFont.shadow)
		else
			child.fragments.text:SetFont(font, artifact_font_data.size, artifact_font_data.outline)
			child.fragments.text:SetTextColor(artifact_font_data.color.r, artifact_font_data.color.g, artifact_font_data.color.b, artifact_font_data.color.a)

			child.sockets.text:SetFont(font, artifact_font_data.size, artifact_font_data.outline)
			child.sockets.text:SetTextColor(artifact_font_data.color.r, artifact_font_data.color.g, artifact_font_data.color.b, artifact_font_data.color.a)

			child.artifact.text:SetFont(font, artifact_font_data.size, artifact_font_data.outline)
			child.artifact.text:SetTextColor(artifact_font_data.color.r, artifact_font_data.color.g, artifact_font_data.color.b, artifact_font_data.color.a)

			FontString_SetShadow(child.fragments.text, artifact_font_data.shadow)
			FontString_SetShadow(child.sockets.text, artifact_font_data.shadow)
			FontString_SetShadow(child.artifact.text, artifact_font_data.shadow)
		end
	end

	local borderTexture = LSM:Fetch('border', private.db.artifact.borderTexture) or [[Interface\None]]
	local backgroundTexture = LSM:Fetch('background', private.db.artifact.backgroundTexture) or [[Interface\None]]
	races_frame:SetBackdrop({
		bgFile = backgroundTexture,
		edgeFile = borderTexture,
		tile = false,
		edgeSize = 8,
		tileSize = 8,
		insets = {
			left = 2,
			top = 2,
			right = 2,
			bottom = 2
		}
	})
	races_frame:SetBackdropColor(1, 1, 1, private.db.artifact.bgAlpha)
	races_frame:SetBackdropBorderColor(1, 1, 1, private.db.artifact.borderAlpha)


	if not IsTaintable() then
		local height = races_frame.container:GetHeight() + ((private.db.general.theme == "Graphical") and 15 or 25)
		if private.db.general.showSkillBar and private.db.general.theme == "Graphical" then
			height = height + 30
		end
		races_frame:SetHeight(height)
		races_frame:SetWidth(races_frame.container:GetWidth() + ((private.db.general.theme == "Graphical") and 45 or 0))
	end

	if races_frame:IsVisible() then
		if private.db.general.stealthMode or not private.db.artifact.show or ShouldBeHidden() then
			races_frame:Hide()
		end
	else
		if not private.db.general.stealthMode and private.db.artifact.show and not ShouldBeHidden() then
			races_frame:Show()
		end
	end
end

-- returns a list of race ids for the continent map id
local function ContinentRaces(continent_id)
	local races = {}
	for _, site in pairs(DIG_SITES) do
		if site.continent == MAP_ID_TO_CONTINENT_ID[continent_id] and not _G.tContains(races, site.race) then
			table.insert(races, site.race)
		end
	end
	return races
end

function Archy:RefreshRacesDisplay()
	if ShouldBeHidden() or _G.GetNumArchaeologyRaces() == 0 then
		return
	end
	local maxWidth, maxHeight = 0, 0
	self:UpdateSkillBar()

	local races_frame = private.races_frame
	local topFrame = races_frame.container
	local hiddenAnchor = races_frame
	local count = 0

	if private.db.general.theme == "Minimal" then
		races_frame.title.text:SetText(L["Artifacts"])
	end

	for _, child in pairs(races_frame.children) do
		child:Hide()
	end

	for race_id, race in pairs(race_data) do
		local child = races_frame.children[race_id]
		local artifact = artifacts[race_id]
		local _, _, completionCount = GetArtifactStats(race_id, artifact.name)
		child:SetID(race_id)

		if private.db.general.theme == "Graphical" then
			child.solveButton:SetText(_G.SOLVE)
			child.solveButton:SetWidth(child.solveButton:GetTextWidth() + 20)
			child.solveButton.tooltip = _G.SOLVE

			if child.style ~= private.db.artifact.style then
				if private.db.artifact.style == "Compact" then
					child.crest:ClearAllPoints()
					child.crest:SetPoint("TOPLEFT", child, "TOPLEFT", 0, 0)

					child.icon:ClearAllPoints()
					child.icon:SetPoint("LEFT", child.crest, "RIGHT", 0, 0)
					child.icon:SetWidth(32)
					child.icon:SetHeight(32)
					child.icon.texture:SetWidth(32)
					child.icon.texture:SetHeight(32)

					child.crest.text:Hide()
					child.crest:SetWidth(36)
					child.crest:SetHeight(36)
					child.solveButton:SetText("")
					child.solveButton:SetWidth(34)
					child.solveButton:SetHeight(34)
					child.solveButton:SetNormalTexture([[Interface\ICONS\TRADE_ARCHAEOLOGY_AQIR_ARTIFACTFRAGMENT]])
					child.solveButton:SetDisabledTexture([[Interface\ICONS\TRADE_ARCHAEOLOGY_AQIR_ARTIFACTFRAGMENT]])
					child.solveButton:GetDisabledTexture():SetBlendMode("MOD")

					child.solveButton:ClearAllPoints()
					child.solveButton:SetPoint("LEFT", child.fragmentBar, "RIGHT", 5, 0)
					child.fragmentBar.fragments:ClearAllPoints()
					child.fragmentBar.fragments:SetPoint("RIGHT", child.fragmentBar.keystones, "LEFT", -7, 2)
					child.fragmentBar.keystone1:Hide()
					child.fragmentBar.keystone2:Hide()
					child.fragmentBar.keystone3:Hide()
					child.fragmentBar.keystone4:Hide()
					child.fragmentBar.artifact:SetWidth(160)

					child:SetWidth(315 + child.solveButton:GetWidth())
					child:SetHeight(36)
				else
					child.icon:ClearAllPoints()
					child.icon:SetPoint("TOPLEFT", child, "TOPLEFT", 0, 0)
					child.icon:SetWidth(36)
					child.icon:SetHeight(36)
					child.icon.texture:SetWidth(36)
					child.icon.texture:SetHeight(36)

					child.icon:Show()
					child.crest.text:Show()
					child.crest:SetWidth(24)
					child.crest:SetHeight(24)
					child.crest:ClearAllPoints()
					child.crest:SetPoint("TOPLEFT", child.icon, "BOTTOMLEFT", 0, 0)
					child.solveButton:SetHeight(24)
					child.solveButton:SetNormalTexture(nil)
					child.solveButton:SetDisabledTexture(nil)
					child.solveButton:ClearAllPoints()
					child.solveButton:SetPoint("TOPRIGHT", child.fragmentBar, "BOTTOMRIGHT", 0, -3)
					child.fragmentBar.fragments:ClearAllPoints()
					child.fragmentBar.fragments:SetPoint("RIGHT", child.fragmentBar, "RIGHT", -5, 2)
					child.fragmentBar.keystones:Hide()
					child.fragmentBar.artifact:SetWidth(200)

					child:SetWidth(295)
					child:SetHeight(70)
				end
			end

			child.crest.texture:SetTexture(race.texture)
			child.crest.tooltip = race.name .. "\n" .. _G.NORMAL_FONT_COLOR_CODE .. L["Key Stones:"] .. "|r " .. race.keystone.inventory
			child.crest.text:SetText(race.name)
			child.icon.texture:SetTexture(artifact.icon)
			child.icon.tooltip = _G.HIGHLIGHT_FONT_COLOR_CODE .. artifact.name .. "|r\n" .. _G.NORMAL_FONT_COLOR_CODE .. artifact.tooltip .. "\n\n" .. _G.HIGHLIGHT_FONT_COLOR_CODE .. L["Solved Count: %s"]:format(_G.NORMAL_FONT_COLOR_CODE .. (completionCount or "0") .. "|r") .. "\n\n" .. _G.GREEN_FONT_COLOR_CODE .. L["Left-Click to open artifact in default Archaeology UI"] .. "|r"

			-- setup the bar texture here
			local barTexture = (LSM and LSM:Fetch('statusbar', private.db.artifact.fragmentBarTexture)) or _G.DEFAULT_STATUSBAR_TEXTURE
			child.fragmentBar.barTexture:SetTexture(barTexture)
			child.fragmentBar.barTexture:SetHorizTile(false)
			--            if db.artifact.fragmentBarTexture == "Archy" then
			--                child.fragmentBar.barTexture:SetTexCoord(0, 0.810546875, 0.40625, 0.5625)            -- can solve with keystones if they were attached
			--            else
			--                child.fragmentBar.barTexture:SetTexCoord(0, 0, 0.77525001764297, 0.810546875)
			--            end


			local barColor
			if artifact.rare then
				barColor = private.db.artifact.fragmentBarColors["Rare"]
				child.fragmentBar.barBackground:SetTexCoord(0, 0.72265625, 0.3671875, 0.7890625) -- rare
			else
				if completionCount == 0 then
					barColor = private.db.artifact.fragmentBarColors["FirstTime"]
				else
					barColor = private.db.artifact.fragmentBarColors["Normal"]
				end
				child.fragmentBar.barBackground:SetTexCoord(0, 0.72265625, 0, 0.411875) -- bg
			end
			child.fragmentBar:SetMinMaxValues(0, artifact.fragments_required)
			child.fragmentBar:SetValue(math.min(artifact.fragments + artifact.keystone_adjustment, artifact.fragments_required))

			local adjust = (artifact.keystone_adjustment > 0) and (" (|cFF00FF00+%d|r)"):format(artifact.keystone_adjustment) or ""
			child.fragmentBar.fragments:SetFormattedText("%d%s / %d", artifact.fragments, adjust, artifact.fragments_required)
			child.fragmentBar.artifact:SetText(artifact.name)
			child.fragmentBar.artifact:SetWordWrap(true)

			local endFound = false
			local artifactNameSize = child.fragmentBar:GetWidth() - 10

			if private.db.artifact.style == "Compact" then
				artifactNameSize = artifactNameSize - 40

				if artifact.sockets > 0 then
					child.fragmentBar.keystones.tooltip = L["%d Key stone sockets available"]:format(artifact.sockets) .. "\n" .. L["%d %ss in your inventory"]:format(race.keystone.inventory or 0, race.keystone.name or L["Key stone"])
					child.fragmentBar.keystones:Show()

					if child.fragmentBar.keystones and child.fragmentBar.keystones.count then
						child.fragmentBar.keystones.count:SetFormattedText("%d/%d", artifact.keystones_added, artifact.sockets)
					end

					if artifact.keystones_added > 0 then
						child.fragmentBar.keystones.icon:SetTexture(race.keystone.texture)
					else
						child.fragmentBar.keystones.icon:SetTexture(nil)
					end
				else
					child.fragmentBar.keystones:Hide()
				end
			else
				for keystone_index = 1, (_G.ARCHAEOLOGY_MAX_STONES or 4) do
					local field = "keystone" .. keystone_index

					if keystone_index > artifact.sockets or not race.keystone.name then
						child.fragmentBar[field]:Hide()
					else
						child.fragmentBar[field].icon:SetTexture(race.keystone.texture)

						if keystone_index <= artifact.keystones_added then
							child.fragmentBar[field].icon:Show()
							child.fragmentBar[field].tooltip = _G.ARCHAEOLOGY_KEYSTONE_REMOVE_TOOLTIP:format(race.keystone.name)
							child.fragmentBar[field]:Enable()
						else
							child.fragmentBar[field].icon:Hide()
							child.fragmentBar[field].tooltip = _G.ARCHAEOLOGY_KEYSTONE_ADD_TOOLTIP:format(race.keystone.name)
							child.fragmentBar[field]:Enable()

							if endFound then
								child.fragmentBar[field]:Disable()
							end
							endFound = true
						end
						child.fragmentBar[field]:Show()
					end
				end
			end

			if artifact.canSolve or (artifact.keystones_added > 0 and artifact.canSolveStone) then -- Drii: actual user-filled sockets enough to solve so enable the manual solve button
				child.solveButton:Enable()
				barColor = private.db.artifact.fragmentBarColors["Solvable"]
			else
				if artifact.canSolveInventory then -- Drii: solve available with stones from inventory but not enough socketed
					barColor = private.db.artifact.fragmentBarColors["AttachToSolve"]
				end
				child.solveButton:Disable()
			end

			child.fragmentBar.barTexture:SetVertexColor(barColor.r, barColor.g, barColor.b, 1)

			artifactNameSize = artifactNameSize - child.fragmentBar.fragments:GetStringWidth()
			child.fragmentBar.artifact:SetWidth(artifactNameSize)

		else
			local fragmentColor = (artifact.canSolve and "|cFF00FF00" or (artifact.canSolveStone and "|cFFFFFF00" or ""))
			local nameColor = (artifact.rare and "|cFF0070DD" or ((completionCount and completionCount > 0) and _G.GRAY_FONT_COLOR_CODE or ""))
			child.fragments.text:SetFormattedText("%s%d/%d", fragmentColor, artifact.fragments, artifact.fragments_required)

			if race_data[race_id].keystone.inventory > 0 or artifact.sockets > 0 then
				child.sockets.text:SetFormattedText("%d/%d", race_data[race_id].keystone.inventory, artifact.sockets)
				child.sockets.tooltip = L["%d Key stone sockets available"]:format(artifact.sockets) .. "\n" .. L["%d %ss in your inventory"]:format(race.keystone.inventory or 0, race.keystone.name or L["Key stone"])
			else
				child.sockets.text:SetText("")
				child.sockets.tooltip = nil
			end
			child.crest:SetNormalTexture(race_data[race_id].texture)
			child.crest:SetHighlightTexture(race_data[race_id].texture)
			child.crest.tooltip = artifact.name .. "\n" .. _G.NORMAL_FONT_COLOR_CODE .. _G.RACE .. " - " .. "|r" .. _G.HIGHLIGHT_FONT_COLOR_CODE .. race_data[race_id].name .. "\n\n" .. _G.GREEN_FONT_COLOR_CODE .. L["Left-Click to solve without key stones"] .. "\n" .. L["Right-Click to solve with key stones"]

			child.artifact.text:SetFormattedText("%s%s", nameColor, artifact.name)
			child.artifact.tooltip = _G.HIGHLIGHT_FONT_COLOR_CODE .. artifact.name .. "|r\n" .. _G.NORMAL_FONT_COLOR_CODE .. artifact.tooltip .. "\n\n" .. _G.HIGHLIGHT_FONT_COLOR_CODE .. L["Solved Count: %s"]:format(_G.NORMAL_FONT_COLOR_CODE .. (completionCount or "0") .. "|r") .. "\n\n" .. _G.GREEN_FONT_COLOR_CODE .. L["Left-Click to open artifact in default Archaeology UI"] .. "|r"

			child.artifact:SetWidth(child.artifact.text:GetStringWidth())
			child.artifact:SetHeight(child.artifact.text:GetStringHeight())
			child:SetWidth(child.fragments:GetWidth() + child.sockets:GetWidth() + child.crest:GetWidth() + child.artifact:GetWidth() + 30)
		end

		if not private.db.artifact.blacklist[race_id] and artifact.fragments_required > 0 and (not private.db.artifact.filter or _G.tContains(ContinentRaces(current_continent), race_id)) then
			child:ClearAllPoints()

			if topFrame == races_frame.container then
				child:SetPoint("TOPLEFT", topFrame, "TOPLEFT", 0, 0)
			else
				child:SetPoint("TOPLEFT", topFrame, "BOTTOMLEFT", 0, -5)
			end
			topFrame = child
			child:Show()
			maxHeight = maxHeight + child:GetHeight() + 5
			maxWidth = (maxWidth > child:GetWidth()) and maxWidth or child:GetWidth()
			count = count + 1
		else
			child:Hide()
		end
	end
	local containerXofs = 0

	if private.db.general.theme == "Graphical" and private.db.artifact.style == "Compact" then
		maxHeight = maxHeight + 10
		containerXofs = -10
	end

	races_frame.container:SetHeight(maxHeight)
	races_frame.container:SetWidth(maxWidth)

	if races_frame.skillBar then
		races_frame.skillBar:SetWidth(maxWidth)
		races_frame.skillBar.border:SetWidth(maxWidth + 9)

		if private.db.general.showSkillBar then
			races_frame.skillBar:Show()
			races_frame.container:ClearAllPoints()
			races_frame.container:SetPoint("TOP", races_frame.skillBar, "BOTTOM", containerXofs, -10)
			maxHeight = maxHeight + 30
		else
			races_frame.skillBar:Hide()
			races_frame.container:ClearAllPoints()
			races_frame.container:SetPoint("TOP", races_frame, "TOP", containerXofs, -20)
			maxHeight = maxHeight + 10
		end
	else
		races_frame.container:ClearAllPoints()
		races_frame.container:SetPoint("TOP", races_frame, "TOP", containerXofs, -20)
		maxHeight = maxHeight + 10
	end

	if not IsTaintable() then
		if count == 0 then
			races_frame:Hide()
		end
		races_frame:SetHeight(maxHeight + ((private.db.general.theme == "Graphical") and 15 or 25))
		races_frame:SetWidth(maxWidth + ((private.db.general.theme == "Graphical") and 45 or 0))
	end
end

function Archy:UpdateDigSiteFrame()
	if IsTaintable() then
		private.regen_update_digsites = true
		return
	end
	private.digsite_frame:SetScale(private.db.digsite.scale)
	private.digsite_frame:SetAlpha(private.db.digsite.alpha)

	local borderTexture = LSM:Fetch('border', private.db.digsite.borderTexture) or [[Interface\None]]
	local backgroundTexture = LSM:Fetch('background', private.db.digsite.backgroundTexture) or [[Interface\None]]
	private.digsite_frame:SetBackdrop({ bgFile = backgroundTexture, edgeFile = borderTexture, tile = false, edgeSize = 8, tileSize = 8, insets = { left = 2, top = 2, right = 2, bottom = 2 } })
	private.digsite_frame:SetBackdropColor(1, 1, 1, private.db.digsite.bgAlpha)
	private.digsite_frame:SetBackdropBorderColor(1, 1, 1, private.db.digsite.borderAlpha)

	local font = LSM:Fetch("font", private.db.digsite.font.name)
	local zoneFont = LSM:Fetch("font", private.db.digsite.zoneFont.name)
	local digsite_font = private.db.digsite.font

	for _, siteFrame in pairs(private.digsite_frame.children) do
		siteFrame.site.name:SetFont(font, digsite_font.size, digsite_font.outline)
		siteFrame.digCounter.value:SetFont(font, digsite_font.size, digsite_font.outline)
		siteFrame.site.name:SetTextColor(digsite_font.color.r, digsite_font.color.g, digsite_font.color.b, digsite_font.color.a)
		siteFrame.digCounter.value:SetTextColor(digsite_font.color.r, digsite_font.color.g, digsite_font.color.b, digsite_font.color.a)
		FontString_SetShadow(siteFrame.site.name, digsite_font.shadow)
		FontString_SetShadow(siteFrame.digCounter.value, digsite_font.shadow)

		if private.db.general.theme == "Graphical" then
			local zone_font = private.db.digsite.zoneFont

			siteFrame.zone.name:SetFont(zoneFont, zone_font.size, zone_font.outline)
			siteFrame.distance.value:SetFont(zoneFont, zone_font.size, zone_font.outline)
			siteFrame.zone.name:SetTextColor(zone_font.color.r, zone_font.color.g, zone_font.color.b, zone_font.color.a)
			siteFrame.distance.value:SetTextColor(zone_font.color.r, zone_font.color.g, zone_font.color.b, zone_font.color.a)
			FontString_SetShadow(siteFrame.zone.name, zone_font.shadow)
			FontString_SetShadow(siteFrame.distance.value, zone_font.shadow)
		else
			siteFrame.zone.name:SetFont(font, digsite_font.size, digsite_font.outline)
			siteFrame.distance.value:SetFont(font, digsite_font.size, digsite_font.outline)
			siteFrame.zone.name:SetTextColor(digsite_font.color.r, digsite_font.color.g, digsite_font.color.b, digsite_font.color.a)
			siteFrame.distance.value:SetTextColor(digsite_font.color.r, digsite_font.color.g, digsite_font.color.b, digsite_font.color.a)
			FontString_SetShadow(siteFrame.zone.name, digsite_font.shadow)
			FontString_SetShadow(siteFrame.distance.value, digsite_font.shadow)
		end
	end

	local continent_id = MAP_ID_TO_CONTINENT_ID[current_continent]

	if private.digsite_frame:IsVisible() then
		if private.db.general.stealthMode or not private.db.digsite.show or ShouldBeHidden() or not continent_digsites[continent_id] or #continent_digsites[continent_id] == 0 then
			private.digsite_frame:Hide()
		end
	else
		if not private.db.general.stealthMode and private.db.digsite.show and not ShouldBeHidden() and continent_digsites[continent_id] and #continent_digsites[continent_id] > 0 then
			private.digsite_frame:Show()
		end
	end
end

function Archy:ShowDigSiteTooltip(digsite)
	local site_id = digsite:GetParent():GetID()
	local normal_font = _G.NORMAL_FONT_COLOR_CODE
	local highlight_font = _G.HIGHLIGHT_FONT_COLOR_CODE
	local site_stats = self.db.char.digsites.stats

	digsite.tooltip = digsite.name:GetText()
	digsite.tooltip = digsite.tooltip .. ("\n%s%s%s%s|r"):format(normal_font, _G.ZONE .. ": ", highlight_font, digsite:GetParent().zone.name:GetText())
	digsite.tooltip = digsite.tooltip .. ("\n\n%s%s %s%s|r"):format(normal_font, L["Surveys:"], highlight_font, site_stats[site_id].surveys or 0)
	digsite.tooltip = digsite.tooltip .. ("\n%s%s %s%s|r"):format(normal_font, L["Digs"] .. ": ", highlight_font, site_stats[site_id].looted or 0)
	digsite.tooltip = digsite.tooltip .. ("\n%s%s %s%s|r"):format(normal_font, _G.ARCHAEOLOGY_RUNE_STONES .. ": ", highlight_font, site_stats[site_id].fragments or 0)
	digsite.tooltip = digsite.tooltip .. ("\n%s%s %s%s|r"):format(normal_font, L["Key Stones:"], highlight_font, site_stats[site_id].keystones or 0)
	digsite.tooltip = digsite.tooltip .. "\n\n" .. _G.GREEN_FONT_COLOR_CODE .. L["Left-Click to view the zone map"]

	if self:IsSiteBlacklisted(digsite.siteName) then
		digsite.tooltip = digsite.tooltip .. "\n" .. L["Right-Click to remove from blacklist"]
	else
		digsite.tooltip = digsite.tooltip .. "\n" .. L["Right-Click to blacklist"]
	end
	_G.GameTooltip:SetOwner(digsite, "ANCHOR_BOTTOMRIGHT")
	_G.GameTooltip:SetText(digsite.tooltip, _G.NORMAL_FONT_COLOR[1], _G.NORMAL_FONT_COLOR[2], _G.NORMAL_FONT_COLOR[3], 1, true)
end

function Archy:ResizeDigSiteDisplay()
	if private.db.general.theme == "Graphical" then
		self:ResizeGraphicalDigSiteDisplay()
	else
		self:ResizeMinimalDigSiteDisplay()
	end
end

function Archy:ResizeMinimalDigSiteDisplay()
	local maxWidth, maxHeight = 0, 0
	local topFrame = private.digsite_frame.container
	local siteIndex = 0
	local maxNameWidth, maxZoneWidth, maxDistWidth, maxDigCounterWidth = 0, 0, 70, 20

	for _, siteFrame in pairs(private.digsite_frame.children) do
		siteIndex = siteIndex + 1
		siteFrame.zone:SetWidth(siteFrame.zone.name:GetStringWidth())
		siteFrame.distance:SetWidth(siteFrame.distance.value:GetStringWidth())
		siteFrame.site:SetWidth(siteFrame.site.name:GetStringWidth())
		local width
		local nameWidth = siteFrame.site:GetWidth()
		local zoneWidth = siteFrame.zone:GetWidth()
		if maxNameWidth < nameWidth then maxNameWidth = nameWidth
		end
		if maxZoneWidth < zoneWidth then maxZoneWidth = zoneWidth
		end
		if maxDistWidth < siteFrame.distance:GetWidth() then maxDistWidth = siteFrame.distance:GetWidth()
		end
		maxHeight = maxHeight + siteFrame:GetHeight() + 5

		siteFrame:ClearAllPoints()
		if siteIndex == 1 then siteFrame:SetPoint("TOP", topFrame, "TOP", 0, 0) else siteFrame:SetPoint("TOP", topFrame, "BOTTOM", 0, -5)
		end
		topFrame = siteFrame
	end

	if not private.db.digsite.minimal.showDistance then
		maxDistWidth = 0
	end

	if not private.db.digsite.minimal.showZone then
		maxZoneWidth = 0
	end

	if not private.db.digsite.minimal.showDigCounter then
		maxDigCounterWidth = 0
	end
	maxWidth = 57 + maxDigCounterWidth + maxNameWidth + maxZoneWidth + maxDistWidth

	for _, siteFrame in pairs(private.digsite_frame.children) do
		siteFrame.zone:SetWidth(maxZoneWidth == 0 and 1 or maxZoneWidth)
		siteFrame.site:SetWidth(maxNameWidth)
		siteFrame.distance:SetWidth(maxDistWidth == 0 and 1 or maxDistWidth)
		siteFrame:SetWidth(maxWidth)
		siteFrame.distance:SetAlpha(private.db.digsite.minimal.showDistance and 1 or 0)
		siteFrame.zone:SetAlpha(private.db.digsite.minimal.showZone and 1 or 0)
	end
	private.digsite_frame.container:SetWidth(maxWidth)
	private.digsite_frame.container:SetHeight(maxHeight)

	if not IsTaintable() then
		local cpoint, crelTo, crelPoint, cxOfs, cyOfs = private.digsite_frame.container:GetPoint()

		-- private.digsite_frame:SetHeight(private.digsite_frame.container:GetHeight() + cyOfs + 40)
		private.digsite_frame:SetHeight(maxHeight + cyOfs + 40)
		private.digsite_frame:SetWidth(maxWidth + cxOfs + 30)
	end
end

function Archy:ResizeGraphicalDigSiteDisplay()
	local maxWidth, maxHeight = 0, 0
	local topFrame = private.digsite_frame.container
	local siteIndex = 0

	for _, siteFrame in pairs(private.digsite_frame.children) do
		siteIndex = siteIndex + 1
		siteFrame.zone:SetWidth(siteFrame.zone.name:GetStringWidth())
		siteFrame.distance:SetWidth(siteFrame.distance.value:GetStringWidth())
		siteFrame.site:SetWidth(siteFrame.site.name:GetStringWidth())

		local width
		local nameWidth = siteFrame.site:GetWidth()
		local zoneWidth = siteFrame.zone:GetWidth() + 10

		if nameWidth > zoneWidth then
			width = siteFrame.crest:GetWidth() + nameWidth + siteFrame.digCounter:GetWidth() + 6
		else
			width = siteFrame.crest:GetWidth() + zoneWidth + siteFrame.distance:GetWidth() + 6
		end

		if width > maxWidth then
			maxWidth = width
		end
		maxHeight = maxHeight + siteFrame:GetHeight() + 5

		siteFrame:ClearAllPoints()

		if siteIndex == 1 then
			siteFrame:SetPoint("TOP", topFrame, "TOP", 0, 0)
		else
			siteFrame:SetPoint("TOP", topFrame, "BOTTOM", 0, -5)
		end
		topFrame = siteFrame
	end

	for _, siteFrame in pairs(private.digsite_frame.children) do
		siteFrame:SetWidth(maxWidth)
	end
	private.digsite_frame.container:SetWidth(maxWidth)
	private.digsite_frame.container:SetHeight(maxHeight)

	if not IsTaintable() then
		local cpoint, crelTo, crelPoint, cxOfs, cyOfs = private.digsite_frame.container:GetPoint()
		-- private.digsite_frame:SetHeight(private.digsite_frame.container:GetHeight() + cyOfs + 40) -- masahikatao on wowinterface
		private.digsite_frame:SetHeight(maxHeight + cyOfs + 40)
		private.digsite_frame:SetWidth(maxWidth + cxOfs + 30)
	end
end

function Archy:RefreshDigSiteDisplay()
	if ShouldBeHidden() then
		return
	end
	local continent_id = MAP_ID_TO_CONTINENT_ID[current_continent]

	if not continent_id or not continent_digsites[continent_id] or #continent_digsites[continent_id] == 0 then
		return
	end

	for _, site_frame in pairs(private.digsite_frame.children) do
		site_frame:Hide()
	end

	for _, site in pairs(continent_digsites[continent_id]) do
		if not site.distance then
			return
		end
	end

	for site_index, site in pairs(continent_digsites[continent_id]) do
		local site_frame = private.digsite_frame.children[site_index]
		local count = self.db.char.digsites.stats[site.id].counter

		if private.db.general.theme == "Graphical" then
			if site_frame.style ~= private.db.digsite.style then
				if private.db.digsite.style == "Compact" then
					site_frame.crest:SetWidth(20)
					site_frame.crest:SetHeight(20)
					site_frame.crest.icon:SetWidth(20)
					site_frame.crest.icon:SetHeight(20)
					site_frame.zone:Hide()
					site_frame.distance:Hide()
					site_frame:SetHeight(24)
				else
					site_frame.crest:SetWidth(40)
					site_frame.crest:SetHeight(40)
					site_frame.crest.icon:SetWidth(40)
					site_frame.crest.icon:SetHeight(40)
					site_frame.zone:Show()
					site_frame.distance:Show()
					site_frame:SetHeight(40)
				end
			end
			site_frame.digCounter.value:SetText(count or "")
		else
			site_frame.digCounter.value:SetFormattedText("%d/3", count or 0)
		end

		site_frame.distance.value:SetFormattedText(L["%d yards"], site.distance)

		if self:IsSiteBlacklisted(site.name) then
			site_frame.site.name:SetFormattedText("|cFFFF0000%s", site.name)
		else
			site_frame.site.name:SetText(site.name)
		end

		if site_frame.site.siteName ~= site.name then
			site_frame.crest.icon:SetTexture(race_data[site.raceId].texture)
			site_frame.crest.tooltip = race_data[site.raceId].name
			site_frame.zone.name:SetText(site.zoneName)
			site_frame.site.siteName = site.name
			site_frame.site.zoneId = site.zoneId
			site_frame:SetID(site.id)
		end
		site_frame:Show()
	end
	self:ResizeDigSiteDisplay()
end

function Archy:SetFramePosition(frame)
	if frame.isMoving or ( frame:IsProtected() and IsTaintable() ) then
		return
	end
	local bPoint, bRelativePoint, bXofs, bYofs
	local bRelativeTo = _G.UIParent

	if frame == private.digsite_frame then
		bPoint, bRelativePoint, bXofs, bYofs = unpack(private.db.digsite.position)
	elseif frame == private.races_frame then
		bPoint, bRelativePoint, bXofs, bYofs = unpack(private.db.artifact.position)
	elseif frame == private.distance_indicator_frame then
		if not private.db.digsite.distanceIndicator.undocked then
			bRelativeTo = private.digsite_frame
			bPoint, bRelativePoint, bXofs, bYofs = "CENTER", "TOPLEFT", 50, -5
			frame:SetParent(private.digsite_frame)
		else
			frame:SetParent(_G.UIParent)
			bPoint, bRelativePoint, bXofs, bYofs = unpack(private.db.digsite.distanceIndicator.position)
		end
	end
	frame:ClearAllPoints()
	frame:SetPoint(bPoint, bRelativeTo, bRelativePoint, bXofs, bYofs)
	frame:SetFrameLevel(2)

	if frame:GetParent() == _G.UIParent and not IsTaintable() and not private.db.general.locked then -- Drii: ticket 390
		frame:SetUserPlaced(false)
	end
end

function Archy:SaveFramePosition(frame)
	local bPoint, bRelativeTo, bRelativePoint, bXofs, bYofs = frame:GetPoint()
	local width, height
	local anchor, position

	if frame == private.digsite_frame then
		anchor = Archy.db.profile.digsite.anchor
		position = Archy.db.profile.digsite.position
	elseif frame == private.races_frame then
		anchor = Archy.db.profile.artifact.anchor
		position = Archy.db.profile.artifact.position
	elseif frame == private.distance_indicator_frame then
		anchor = Archy.db.profile.digsite.distanceIndicator.anchor
		position = Archy.db.profile.digsite.distanceIndicator.position
	end

	if not anchor or not position then
		return
	end

	if anchor == bPoint then
		position = { bPoint, bRelativePoint, bXofs, bYofs }
	else
		width = frame:GetWidth()
		height = frame:GetHeight()

		if bPoint == "TOP" then
			bXofs = bXofs - (width / 2)
		elseif bPoint == "LEFT" then
			bYofs = bYofs + (height / 2)
		elseif bPoint == "BOTTOMLEFT" then
			bYofs = bYofs + height
		elseif bPoint == "TOPRIGHT" then
			bXofs = bXofs - width
		elseif bPoint == "RIGHT" then
			bYofs = bYofs + (height / 2)
			bXofs = bXofs - width
		elseif bPoint == "BOTTOM" then
			bYofs = bYofs + height
			bXofs = bXofs - (width / 2)
		elseif bPoint == "BOTTOMRIGHT" then
			bYofs = bYofs + height
			bXofs = bXofs - width
		elseif bPoint == "CENTER" then
			bYofs = bYofs + (height / 2)
			bXofs = bXofs - (width / 2)
		end

		if anchor == "TOPRIGHT" then
			bXofs = bXofs + width
		elseif anchor == "BOTTOMRIGHT" then
			bYofs = bYofs - height
			bXofs = bXofs + width
		elseif anchor == "BOTTOMLEFT" then
			bYofs = bYofs - height
		end

		position = {
			anchor,
			bRelativePoint,
			bXofs,
			bYofs
		}
		if frame == private.digsite_frame then
			private.db.digsite.position = position
		elseif frame == private.races_frame then
			private.db.artifact.position = position
		elseif frame == private.distance_indicator_frame then
			private.db.digsite.distanceIndicator.position = position
		end
	end

end

function Archy:OnPlayerLooting(event, ...)
	is_looting = (event == "LOOT_OPENED")
	local autoLootEnabled = ...

	if autoLootEnabled == 1 then
		return
	end

	if not is_looting or not private.db.general.autoLoot then
		return
	end

	for slotNum = 1, _G.GetNumLootItems() do
		if _G.LootSlotIsCurrency(slotNum) then
			_G.LootSlot(slotNum)
		elseif _G.LootSlotIsItem(slotNum) then
			local link = _G.GetLootSlotLink(slotNum)

			if link then
				local itemID = GetIDFromLink(link)

				if itemID and keystoneIDToRaceID[itemID] then
					_G.LootSlot(slotNum)
				end
			end
		end
	end
end


