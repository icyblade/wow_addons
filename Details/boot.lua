-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> global name declaration
_detalhes = LibStub("AceAddon-3.0"):NewAddon("_detalhes", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0", "NickTag-1.0")

_detalhes.build_counter = 8050
_detalhes.alpha_build_counter = 7269 --if this is higher than the regular counter, use it instead
_detalhes.game_version = "v5.4.8"
_detalhes.userversion = _detalhes.game_version .. "." .. _detalhes.build_counter
_detalhes.realversion = 200 --core version, this is used to check API version for scripts and plugins (see alias below)
_detalhes.APIVersion = _detalhes.realversion --core version
_detalhes.version = _detalhes.userversion .. " (core " .. _detalhes.realversion .. ")" --simple stirng to show to players

_detalhes.BFACORE = 131 --core version on BFA launch

Details = _detalhes

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> initialization stuff

do

	local _detalhes = _G._detalhes

	_detalhes.resize_debug = {}

	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
--[[
|cFFFFFF00v4.3.4.8048.200 (|cFFFFCC00December 16th, 2021|r|cFFFFFF00)|r:\n
|cFFFFFF00-|r Wallpaper and class backgrounds restored\n
|cFFFFFF00-|r Removed references to icons that don't exist in Cataclysm\n\n
--]]

	Loc ["STRING_VERSION_LOG"] = "|cFFFFFF00v4.3.4.8047.200 (|cFFFFCC00December 16th, 2021|r|cFFFFFF00)|r:\n|cFFFFFF00-|r Wallpaper and class backgrounds restored\n|cFFFFFF00-|r Removed references to icons that don't exist in Cataclysm\n\n|cFFFFFF00v4.3.4.8038.200 (|cFFFFCC00September 29th, 2021|r|cFFFFFF00)|r:\n|cFFFFFF00-|r /details bh command was showing incorrect data\n|cFFFFFF00-|r Improved feral guardian detection\n\n|cFFFFFF00v4.3.4.8032.200 (|cFFFFCC00September 28th, 2021|r|cFFFFFF00)|r:\n|cFFFFFF00-|r Added \"/details bh\" slash command to check your Baradin Hold lockout\n|cFFFFFF00-|r Various slash command performance enchancements\n|cFFFFFF00-|r Important nil check fixes\n|cFFFFFF00-|r Will no longer add dungeons to storage\n|cFFFFFF00-|r Improved rest tracking\n|cFFFFFF00-|r Extra dot ticks while the player is resting and not in combat will no longer trigger extra logs\n\n|cFFFFFF00v4.3.4.8009.200 (|cFFFFCC00September 20th, 2021|r|cFFFFFF00)|r:\n|cFFFFFF00-|r Absorbed healing (healing denied by Searing Plasma for example) now counts towards healing\n|cFFFFFF00-|r 4.0 instances were missing map names\n|cFFFFFF00-|r Statistics window should only show raids\n\n|cFFFFFF00v4.3.4.8000.200 (|cFFFFCC00September 19th, 2021|r|cFFFFFF00)|r:\n|cFFFFFF00-|r Updated for Cataclysm\n\n"

	Loc ["STRING_DETAILS1"] = "|cffffaeaeDetails!:|r"

	_detalhes.print = function(frame, ...)
		print(Loc ["STRING_DETAILS1"],...)
	end

	--> startup
		_detalhes.initializing = true
		_detalhes.enabled = true
		_detalhes.__index = _detalhes
		_detalhes._tempo = time()
		_detalhes.debug_chr = false
		_detalhes.opened_windows = 0
		_detalhes.last_combat_time = 0

	--> containers
		--> armazenas as fun��es do parser - All parse functions
			_detalhes.parser = {}
			_detalhes.parser_functions = {}
			_detalhes.parser_frame = CreateFrame ("Frame")
			_detalhes.parser_frame:Hide()

			_detalhes.MacroList = {
				{Name = "Click on Your Own Bar", Desc = "To open the player details window on your character, like if you click on your bar in the damage window. The number '1' is the window number where it'll click.", MacroText = "/script Details:OpenPlayerDetails(1)"},
				{Name = "Open Encounter Breakdown", Desc = "Open the encounter breakdown plugin. Details! Encounter Breakdown (plugin) must be enabled.", MacroText = "/script Details:OpenPlugin ('Encounter Breakdown')"},
				{Name = "Open Damage per Phase", Desc = "Open the encounter breakdown plugin in the phase tab. Details! Encounter Breakdown (plugin) must be enabled.", MacroText = "/script Details:OpenPlugin ('Encounter Breakdown'); local a=Details_EncounterDetails and Details_EncounterDetails.buttonSwitchPhases:Click()"},
				{Name = "Reset Data", Desc = "Reset the overall and regular segments data. Use 'ResetSegmentOverallData' to reset only the overall.", MacroText = "/script Details:ResetSegmentData()"},
				{Name = "Change What the Window Shows", Desc = "Make a window show different data. SetDisplay uses (segment, displayGroup, displayID), the menu from the sword icon is in order (damage = group 1, overheal is: displayGroup 2 displayID 3.", MacroText = "/script Details:GetWindow(1):SetDisplay( DETAILS_SEGMENTID_CURRENT, 4, 5 )"},
				{Name = "Toggle Window Height to Max Size", Desc = "Make a window be 450 pixel height, pressing the macro again toggle back to the original size. The number '1' if the window number. Hold a click in any window to show their number.", MacroText = "/script Details:GetWindow(1):ToggleMaxSize()"},
			--	/script Details:OpenPlugin ('Advanced Death Logs'); local a = Details_DeathGraphsModeEnduranceButton and Details_DeathGraphsModeEnduranceButton.MyObject:Click()

				{Name = "Report What is Shown In the Window", Desc = "Report the current data shown in the window, the number 1 is the window number, replace it to report another window.", MacroText = "/script Details:FastReportWindow(1)"},

			}

		--> armazena os escudos - Shields information for absorbs
			_detalhes.escudos = {}
		--> armazena as fun��es dos frames - Frames functions
			_detalhes.gump = _G ["DetailsFramework"]
			function _detalhes:GetFramework()
				return self.gump
			end
			GameCooltip = GameCooltip2
		--> anima��es dos icones
			_detalhes.icon_animations = {
				load = {
					in_use = {},
					available = {},
				},
			}
		--> armazena as fun��es para inicializa��o dos dados - Metatable functions
			_detalhes.refresh = {}
		--> armazena as fun��es para limpar e guardas os dados - Metatable functions
			_detalhes.clear = {}
		--> armazena a config do painel de fast switch
			_detalhes.switch = {}
		--> armazena os estilos salvos
			_detalhes.savedStyles = {}
		--> armazena quais atributos possue janela de atributos - contain attributes and sub attributos wich have a detailed window (left click on a row)
			_detalhes.row_singleclick_overwrite = {}
		--> report
			_detalhes.ReportOptions = {}
		--> armazena os buffs registrados - store buffs ids and functions
			_detalhes.Buffs = {} --> initialize buff table
		-->  cache de grupo
			_detalhes.cache_damage_group = {}
			_detalhes.cache_healing_group = {}
			_detalhes.cache_npc_ids = {}
		--> cache de specs
			_detalhes.cached_specs = {}
			_detalhes.cached_talents = {}
		--> ignored pets
			_detalhes.pets_ignored = {}
			_detalhes.pets_no_owner = {}
			_detalhes.pets_players = {}
		--> dual candidates
			_detalhes.duel_candidates = {}
		--> armazena as skins dispon�veis para as janelas
			_detalhes.skins = {}
		--> armazena os hooks das fun��es do parser
			_detalhes.hooks = {}
		--> informa��es sobre a luta do boss atual
			_detalhes.encounter_end_table = {}
			_detalhes.encounter_table = {}
			_detalhes.encounter_counter = {}
			_detalhes.encounter_dungeons = {}
		--> reliable char data sources
		--> actors that are using details! and sent character data, we don't need query inspect on these actors
			_detalhes.trusted_characters = {}
		--> informa��es sobre a arena atual
			_detalhes.arena_table = {}
			_detalhes.arena_info = {
				--> need to get the new mapID for 8.0.1
				[562] = {file = "LoadScreenBladesEdgeArena", coords = {0, 1, 0.29296875, 0.9375}}, -- Circle of Blood Arena
				[617] = {file = "LoadScreenDalaranSewersArena", coords = {0, 1, 0.29296875, 0.857421875}}, --Dalaran Arena
				[559] = {file = "LoadScreenNagrandArenaBattlegrounds", coords = {0, 1, 0.341796875, 1}}, --Ring of Trials
				--[980] = {file = "LoadScreenTolvirArena", coords = {0, 1, 0.29296875, 0.857421875}}, --Tol'Viron Arena
				[572] = {file = "LoadScreenRuinsofLordaeronBattlegrounds", coords = {0, 1, 0.341796875, 1}}, --Ruins of Lordaeron
				-- [1134] = {file = "LoadingScreen_Shadowpan_bg", coords = {0, 1, 0.29296875, 0.857421875}}, -- Tiger's Peak
				--> legion, thanks @pas06 on curse forge for the mapIds
				-- [1552] = {file = "LoadingScreen_ArenaValSharah_wide", coords = {0, 1, 0.29296875, 0.857421875}}, -- Ashmane's Fall
				-- [1504] = {file = "LoadingScreen_BlackrookHoldArena_wide", coords = {0, 1, 0.29296875, 0.857421875}}, --Black Rook Hold

				--"LoadScreenOrgrimmarArena", --Ring of Valor
			}

			function _detalhes:GetArenaInfo (mapid)
				local t = _detalhes.arena_info [mapid]
				if (t) then
					return t.file, t.coords
				end
			end
			_detalhes.battleground_info = {
				--> need to get the nwee mapID for 8.0.1
				[611] = {file = "LoadScreenWarsongGulch", coords = {0, 1, 121/512, 484/512}}, --warsong gulch
				[489] = {file = "LoadScreenWarsongGulch", coords = {0, 1, 121/512, 484/512}}, --warsong gulch
				--[727] = {file = "LoadScreenSilvershardMines", coords = {0, 1, 251/1024, 840/1024}}, --silvershard mines
				[529] = {file = "LoadscreenArathiBasin", coords = {0, 1, 126/512, 430/512}}, --arathi basin
				[566] = {file = "LoadScreenNetherBattlegrounds", coords = {0, 1, 142/512, 466/512}}, --eye of the storm
				[30] = {file = "LoadScreenPvpBattleground", coords = {0, 1, 127/512, 500/512}}, --alterac valley
				[761] = {file = "LoadScreenGilneasBG2", coords = {0, 1, 281/1024, 878/1024}}, --the battle for gilneas
				[726] = {file = "LoadScreenTwinPeaksBG", coords = {0, 1, 294/1024, 876/1024}}, --twin peaks
				--[998] = {file = "LoadScreenValleyofPower", coords = {0, 1, 257/1024, 839/1024}}, --temple of kotmogu
				-- [1105] = {file = "LoadScreen_GoldRush", coords = {0, 1, 264/1024, 840/1024}}, --deepwind gorge
				[607] = {file = "LoadScreenNorthrendBG", coords = {0, 1, 302/1024, 879/1024}}, --strand of the ancients
				[628] = {file = "LOADSCREENISLEOFCONQUEST", coords = {0, 1, 297/1024, 878/1024}}, --isle of conquest
				--[] = {file = "", coords = {0, 1, 0, 0}}, --
			}
			function _detalhes:GetBattlegroundInfo (mapid)
				local t = _detalhes.battleground_info [mapid]
				if (t) then
					return t.file, t.coords
				end
			end

		--> tokenid
			_detalhes.TokenID = {
				["SPELL_PERIODIC_DAMAGE"] = 1,
				["SPELL_EXTRA_ATTACKS"] = 2,
				["SPELL_DAMAGE"] = 3,
				["SPELL_BUILDING_DAMAGE"] = 4,
				["SWING_DAMAGE"] = 5,
				["RANGE_DAMAGE"] = 6,
				["DAMAGE_SHIELD"] = 7,
				["DAMAGE_SPLIT"] = 8,
				["RANGE_MISSED"] = 9,
				["SWING_MISSED"] = 10,
				["SPELL_MISSED"] = 11,
				["SPELL_PERIODIC_MISSED"] = 12,
				["SPELL_BUILDING_MISSED"] = 13,
				["DAMAGE_SHIELD_MISSED"] = 14,
				["ENVIRONMENTAL_DAMAGE"] = 15,
				["SPELL_HEAL"] = 16,
				["SPELL_PERIODIC_HEAL"] = 17,
				["SPELL_AURA_APPLIED"] = 18,
				["SPELL_AURA_REMOVED"] = 19,
				["SPELL_AURA_REFRESH"] = 20,
				["SPELL_AURA_APPLIED_DOSE"] = 21,
				["SPELL_ENERGIZE"] = 22,
				["SPELL_PERIODIC_ENERGIZE"] = 23,
				["SPELL_CAST_START"] = 24,
				["SPELL_CAST_SUCCESS"] = 25,
				["SPELL_DISPEL"] = 26,
				["SPELL_STOLEN"] = 27,
				["SPELL_AURA_BROKEN"] = 29,
				["SPELL_AURA_BROKEN_SPELL"] = 29,
				["SPELL_RESURRECT"] = 30,
				["SPELL_INTERRUPT"] = 31,
				["UNIT_DIED"] = 32,
				["UNIT_DESTROYED"] = 33,
			}

		--> armazena instancias inativas
			_detalhes.unused_instances = {}
			--_detalhes.default_skin_to_use = "Minimalistic"
			_detalhes.default_skin_to_use = "Minimalistic"
			_detalhes.instance_title_text_timer = {}
		--> player detail skin
			_detalhes.playerdetailwindow_skins = {}

		_detalhes.BitfieldSwapDebuffsIDs = {265646, 272407, 269691, 273401, 269131, 260900, 260926, 284995, 292826, 311367, 310567, 308996, 307832}

		--> auto run code
		_detalhes.RunCodeTypes = {
			{Name = "On Initialization", Desc = "Run code when Details! initialize or when a profile is changed.", Value = 1, ProfileKey = "on_init"},
			{Name = "On Zone Changed", Desc = "Run code when the zone where the player is in has changed (e.g. entered in a raid).", Value = 2, ProfileKey = "on_zonechanged"},
			{Name = "On Enter Combat", Desc = "Run code when the player enters in combat.", Value = 3, ProfileKey = "on_entercombat"},
			{Name = "On Leave Combat", Desc = "Run code when the player left combat.", Value = 4, ProfileKey = "on_leavecombat"},
			{Name = "On Spec Change", Desc = "Run code when the player has changed its specialization.", Value = 5, ProfileKey = "on_specchanged"},
			{Name = "On Enter/Leave Group", Desc = "Run code when the player has entered or left a party or raid group.", Value = 6, ProfileKey = "on_groupchange"},
		}

		--> tooltip
			_detalhes.tooltip_backdrop = {
				bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
				edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
				tile = true,
				edgeSize = 16,
				tileSize = 16,
				insets = {left = 3, right = 3, top = 4, bottom = 4}
			}
			_detalhes.tooltip_border_color = {1, 1, 1, 1}
			_detalhes.tooltip_spell_icon = {file = [[Interface\CHARACTERFRAME\UI-StateIcon]], coords = {36/64, 58/64, 7/64, 26/64}}
			_detalhes.tooltip_target_icon = {file = [[Interface\Addons\Details\images\icons]], coords = {0, 0.03125, 0.126953125, 0.15625}}

		--> icons
			_detalhes.attribute_icons = [[Interface\AddOns\Details\images\atributos_icones]]
			function _detalhes:GetAttributeIcon (attribute)
				return _detalhes.attribute_icons, 0.125 * (attribute - 1), 0.125 * attribute, 0, 1
			end

		--> colors
			_detalhes.default_backdropcolor = {.094117, .094117, .094117, .8}
			_detalhes.default_backdropbordercolor = {0, 0, 0, 1}

	--> Plugins

		--> plugin templates

		_detalhes.gump:NewColor ("DETAILS_PLUGIN_BUTTONTEXT_COLOR", 0.9999, 0.8196, 0, 1)

		_detalhes.gump:InstallTemplate ("button", "DETAILS_PLUGINPANEL_BUTTON_TEMPLATE",
			{
				backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
				backdropcolor = {0, 0, 0, .5},
				backdropbordercolor = {0, 0, 0, .5},
				onentercolor = {0.3, 0.3, 0.3, .5},
			}
		)
		_detalhes.gump:InstallTemplate ("button", "DETAILS_PLUGINPANEL_BUTTONSELECTED_TEMPLATE",
			{
				backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
				backdropcolor = {0, 0, 0, .5},
				backdropbordercolor = {1, 1, 0, 1},
				onentercolor = {0.3, 0.3, 0.3, .5},
			}
		)

		_detalhes.gump:InstallTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE",
			{
				backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
				backdropcolor = {1, 1, 1, .5},
				backdropbordercolor = {0, 0, 0, 1},
				onentercolor = {1, 1, 1, .9},
				textcolor = "DETAILS_PLUGIN_BUTTONTEXT_COLOR",
				textsize = 10,
				width = 120,
				height = 20,
			}
		)
		_detalhes.gump:InstallTemplate ("button", "DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE",
			{
				backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
				backdropcolor = {1, 1, 1, .5},
				backdropbordercolor = {1, .7, 0, 1},
				onentercolor = {1, 1, 1, .9},
				textcolor = "DETAILS_PLUGIN_BUTTONTEXT_COLOR",
				textsize = 10,
				width = 120,
				height = 20,
			}
		)

		_detalhes.gump:InstallTemplate ("button", "DETAILS_TAB_BUTTON_TEMPLATE",
			{
				width = 100,
				height = 20,
			},
			"DETAILS_PLUGIN_BUTTON_TEMPLATE"
		)
		_detalhes.gump:InstallTemplate ("button","DETAILS_TAB_BUTTONSELECTED_TEMPLATE",
			{
				width = 100,
				height = 20,
			},
			"DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE"
		)

		_detalhes.PluginsGlobalNames = {}
		_detalhes.PluginsLocalizedNames = {}

		--> raid -------------------------------------------------------------------
			--> general function for raid mode plugins
				_detalhes.RaidTables = {}
			--> menu for raid modes
				_detalhes.RaidTables.Menu = {}
			--> plugin objects for raid mode
				_detalhes.RaidTables.Plugins = {}
			--> name to plugin object
				_detalhes.RaidTables.NameTable = {}
			--> using by
				_detalhes.RaidTables.InstancesInUse = {}
				_detalhes.RaidTables.PluginsInUse = {}

		--> solo -------------------------------------------------------------------
			--> general functions for solo mode plugins
				_detalhes.SoloTables = {}
			--> maintain plugin menu
				_detalhes.SoloTables.Menu = {}
			--> plugins objects for solo mode
				_detalhes.SoloTables.Plugins = {}
			--> name to plugin object
				_detalhes.SoloTables.NameTable = {}

		--> toolbar -------------------------------------------------------------------
			--> plugins container
				_detalhes.ToolBar = {}
			--> current showing icons
				_detalhes.ToolBar.Shown = {}
				_detalhes.ToolBar.AllButtons = {}
			--> plugin objects
				_detalhes.ToolBar.Plugins = {}
			--> name to plugin object
				_detalhes.ToolBar.NameTable = {}
				_detalhes.ToolBar.Menu = {}

		--> statusbar -------------------------------------------------------------------
			--> plugins container
				_detalhes.StatusBar = {}
			--> maintain plugin menu
				_detalhes.StatusBar.Menu = {}
			--> plugins object
				_detalhes.StatusBar.Plugins = {}
			--> name to plugin object
				_detalhes.StatusBar.NameTable = {}

	--> constants
		--[[global]] DETAILS_HEALTH_POTION_LIST = {
			[250870] = true, --Coastal Healing Potion
			[250872] = true, --Coastal Rejuvenation Potion
			[6262] = true, --Warlock's Healthstone
		}
		--[[global]] DETAILS_HEALTH_POTION_ID = 250870
		--[[global]] DETAILS_REJU_POTION_ID = 250872
		--[[global]] DETAILS_MANA_POTION_ID = 250871
		--[[global]] DETAILS_FOCUS_POTION_ID = 252753

		--[[global]] DETAILS_INT_POTION_ID = 279151
		--[[global]] DETAILS_AGI_POTION_ID = 279152
		--[[global]] DETAILS_STR_POTION_ID = 279153
		--[[global]] DETAILS_STAMINA_POTION_ID = 279154

		_detalhes._detalhes_props = {
			DATA_TYPE_START = 1,	--> Something on start
			DATA_TYPE_END = 2,	--> Something on end

			MODO_ALONE = 1,	--> Solo
			MODO_GROUP = 2,	--> Group
			MODO_ALL = 3,		--> Everything
			MODO_RAID = 4,	--> Raid
		}
		_detalhes.modos = {
			alone = 1, --> Solo
			group = 2,	--> Group
			all = 3,	--> Everything
			raid = 4	--> Raid
		}

		_detalhes.divisores = {
			abre = "(",	--> open
			fecha = ")",	--> close
			colocacao = ". " --> dot
		}

		_detalhes.role_texcoord = {
			DAMAGER = "72:130:69:127",
			HEALER = "72:130:2:60",
			TANK = "5:63:69:127",
			NONE = "139:196:69:127",
		}

		_detalhes.role_texcoord_normalized = {
			DAMAGER = {72/256, 130/256, 69/256, 127/256},
			HEALER = {72/256, 130/256, 2/256, 60/256},
			TANK = {5/256, 63/256, 69/256, 127/256},
			NONE = {139/256, 196/256, 69/256, 127/256},
		}

		_detalhes.classid_to_classstring = {
			"WARRIOR",
			"PALADIN",
			"HUNTER",
			"ROGUE",
			"PRIEST",
			"DEATHKNIGHT",
			"SHAMAN",
			"MAGE",
			"WARLOCK",
			"DRUID",
			"MONK"
		}

		_detalhes.classstring_to_classid = {}

		for k,v in ipairs(_detalhes.classid_to_classstring) do
			_detalhes.classstring_to_classid[v] = k
		end

		_detalhes.segmentos = {
			label = Loc ["STRING_SEGMENT"]..": ",
			overall = Loc ["STRING_TOTAL"],
			overall_standard = Loc ["STRING_OVERALL"],
			current = Loc ["STRING_CURRENT"],
			current_standard = Loc ["STRING_CURRENTFIGHT"],
			past = Loc ["STRING_FIGHTNUMBER"]
		}

		_detalhes._detalhes_props["modo_nome"] = {
				[_detalhes._detalhes_props["MODO_ALONE"]] = Loc ["STRING_MODE_SELF"],
				[_detalhes._detalhes_props["MODO_GROUP"]] = Loc ["STRING_MODE_GROUP"],
				[_detalhes._detalhes_props["MODO_ALL"]] = Loc ["STRING_MODE_ALL"],
				[_detalhes._detalhes_props["MODO_RAID"]] = Loc ["STRING_MODE_RAID"]
		}

		--[[global]] DETAILS_MODE_SOLO = 1
		--[[global]] DETAILS_MODE_RAID = 4
		--[[global]] DETAILS_MODE_GROUP = 2
		--[[global]] DETAILS_MODE_ALL = 3

		_detalhes.icones = {
			--> report window
			report = {
					up = [[Interface\FriendsFrame\UI-Toast-ToastIcons]],
					down = [[Interface\ItemAnimations\MINIMAP\TRACKING\Profession]],
					disabled = [[Interface\ItemAnimations\MINIMAP\TRACKING\Profession]],
					highlight = nil
				}
		}

		_detalhes.missTypes = {"ABSORB", "BLOCK", "DEFLECT", "DODGE", "EVADE", "IMMUNE", "MISS", "PARRY", "REFLECT", "RESIST"} --> do not localize-me

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> frames

	local _CreateFrame = CreateFrame --api locals
	local _UIParent = UIParent --api locals

	--> Info Window
		_detalhes.janela_info = _CreateFrame ("Frame", "DetailsPlayerDetailsWindow", _UIParent)
		_detalhes.PlayerDetailsWindow = _detalhes.janela_info

	--> Event Frame
		_detalhes.listener = _CreateFrame ("Frame", nil, _UIParent)
		_detalhes.listener:RegisterEvent ("ADDON_LOADED")
		_detalhes.listener:SetFrameStrata ("LOW")
		_detalhes.listener:SetFrameLevel (9)
		_detalhes.listener.FrameTime = 0

		_detalhes.overlay_frame = _CreateFrame ("Frame", nil, _UIParent)
		_detalhes.overlay_frame:SetFrameStrata ("TOOLTIP")

	--> Pet Owner Finder
		_CreateFrame ("GameTooltip", "DetailsPetOwnerFinder", nil, "GameTooltipTemplate")


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> plugin defaults
	--> backdrop
	_detalhes.PluginDefaults = {}

	_detalhes.PluginDefaults.Backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
	edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,
	insets = {left = 1, right = 1, top = 1, bottom = 1}}
	_detalhes.PluginDefaults.BackdropColor = {0, 0, 0, .6}
	_detalhes.PluginDefaults.BackdropBorderColor = {0, 0, 0, 1}

	function _detalhes.GetPluginDefaultBackdrop()
		return _detalhes.PluginDefaults.Backdrop, _detalhes.PluginDefaults.BackdropColor, _detalhes.PluginDefaults.BackdropBorderColor
	end


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> functions

	_detalhes.empty_function = function() end
	_detalhes.empty_table = {}

	--> register textures and fonts for shared media
		local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")
		--default bars
		SharedMedia:Register ("statusbar", "Details D'ictum", [[Interface\AddOns\Details\images\bar4]])
		SharedMedia:Register ("statusbar", "Details Vidro", [[Interface\AddOns\Details\images\bar4_vidro]])
		SharedMedia:Register ("statusbar", "Details D'ictum (reverse)", [[Interface\AddOns\Details\images\bar4_reverse]])
		--flat bars
		SharedMedia:Register ("statusbar", "Details Serenity", [[Interface\AddOns\Details\images\bar_serenity]])
		SharedMedia:Register ("statusbar", "BantoBar", [[Interface\AddOns\Details\images\BantoBar]])
		SharedMedia:Register ("statusbar", "Skyline", [[Interface\AddOns\Details\images\bar_skyline]])
		SharedMedia:Register ("statusbar", "WorldState Score", [[Interface\WorldStateFrame\WORLDSTATEFINALSCORE-HIGHLIGHT]])
		SharedMedia:Register ("statusbar", "DGround", [[Interface\AddOns\Details\images\bar_background]])
		SharedMedia:Register ("statusbar", "Details Flat", [[Interface\AddOns\Details\images\bar_background]])

		--window bg and bar border
		SharedMedia:Register ("background", "Details Ground", [[Interface\AddOns\Details\images\background]])
		SharedMedia:Register ("border", "Details BarBorder 1", [[Interface\AddOns\Details\images\border_1]])
		SharedMedia:Register ("border", "Details BarBorder 2", [[Interface\AddOns\Details\images\border_2]])
		SharedMedia:Register ("border", "Details BarBorder 3", [[Interface\AddOns\Details\images\border_3]])
		SharedMedia:Register ("border", "1 Pixel", [[Interface\Buttons\WHITE8X8]])
		--misc fonts
		SharedMedia:Register ("font", "Oswald", [[Interface\Addons\Details\fonts\Oswald-Regular.otf]])
		SharedMedia:Register ("font", "Nueva Std Cond", [[Interface\Addons\Details\fonts\NuevaStd-Cond.otf]])
		SharedMedia:Register ("font", "Accidental Presidency", [[Interface\Addons\Details\fonts\Accidental Presidency.ttf]])
		SharedMedia:Register ("font", "TrashHand", [[Interface\Addons\Details\fonts\TrashHand.TTF]])
		SharedMedia:Register ("font", "Harry P", [[Interface\Addons\Details\fonts\HARRYP__.TTF]])
		SharedMedia:Register ("font", "FORCED SQUARE", [[Interface\Addons\Details\fonts\FORCED SQUARE.ttf]])

		SharedMedia:Register ("sound", "d_gun1", [[Interface\Addons\Details\sounds\sound_gun2.ogg]])
		SharedMedia:Register ("sound", "d_gun2", [[Interface\Addons\Details\sounds\sound_gun3.ogg]])
		SharedMedia:Register ("sound", "d_jedi1", [[Interface\Addons\Details\sounds\sound_jedi1.ogg]])
		SharedMedia:Register ("sound", "d_whip1", [[Interface\Addons\Details\sounds\sound_whip1.ogg]])

	--> global 'vardump' for dump table contents over chat panel
		function vardump(t)
			if type (t) ~= "table" then
				return
			end
			for a, b in pairs(t) do
				print(a, b)
			end
		end

	--> global 'table_deepcopy' copies a full table
		function table_deepcopy(orig)
			local orig_type = type(orig)
			local copy
			if orig_type == "table" then
				copy = {}
				for orig_key, orig_value in next, orig, nil do
					copy[table_deepcopy(orig_key)] = table_deepcopy(orig_value)
				end
			else
				copy = orig
			end
			return copy
		end

	--> delay messages
		function _detalhes:DelayMsg (msg)
			_detalhes.delaymsgs = _detalhes.delaymsgs or {}
			_detalhes.delaymsgs [#_detalhes.delaymsgs+1] = msg
		end
		function _detalhes:ShowDelayMsg()
			if (_detalhes.delaymsgs and #_detalhes.delaymsgs > 0) then
				for _, msg in ipairs (_detalhes.delaymsgs) do
					print (msg)
				end
			end
			_detalhes.delaymsgs = {}
		end

	--> print messages
		function _detalhes:Msg (...)
			if (self.__name) then
				--> yes, we have a name!
				print ("|cffffaeae" .. self.__name .. "|r |cffcc7c7c(plugin)|r:", ...)
			else
				self:print(...)
			end
		end

	--> welcome
		function _detalhes:WelcomeMsgLogon()

			self:Msg ("you can always reset the addon running the command |cFFFFFF00'/details reinstall'|r if it does fail to load after being updated.")

			function self:wipe_combat_after_failed_load()
				self.tabela_historico = self.historico:NovoHistorico()
				self.tabela_overall = self.combate:NovaTabela()
				self.tabela_vigente = self.combate:NovaTabela (nil, self.tabela_overall)
				self.tabela_pets = self.container_pets:NovoContainer()
				self:UpdateContainerCombatentes()

				_detalhes_database.tabela_overall = nil
				_detalhes_database.tabela_historico = nil

				self:Msg ("seems failed to load, please type /reload to try again.")
			end
			self:ScheduleTimer ("wipe_combat_after_failed_load", 5)

		end
		_detalhes.failed_to_load = _detalhes:ScheduleTimer ("WelcomeMsgLogon", 20)

	--> key binds
		--> header
			_G ["BINDING_HEADER_Details"] = "Details!"
			_G ["BINDING_HEADER_DETAILS_KEYBIND_SEGMENTCONTROL"] = Loc ["STRING_KEYBIND_SEGMENTCONTROL"]
			_G ["BINDING_HEADER_DETAILS_KEYBIND_SCROLLING"] = Loc ["STRING_KEYBIND_SCROLLING"]
			_G ["BINDING_HEADER_DETAILS_KEYBIND_WINDOW_CONTROL"] = Loc ["STRING_KEYBIND_WINDOW_CONTROL"]
			_G ["BINDING_HEADER_DETAILS_KEYBIND_BOOKMARK"] = Loc ["STRING_KEYBIND_BOOKMARK"]
			_G ["BINDING_HEADER_DETAILS_KEYBIND_REPORT"] = Loc ["STRING_KEYBIND_WINDOW_REPORT_HEADER"]

		--> keys

			_G ["BINDING_NAME_DETAILS_TOGGLE_ALL"] = Loc ["STRING_KEYBIND_TOGGLE_WINDOWS"]

			_G ["BINDING_NAME_DETAILS_RESET_SEGMENTS"] = Loc ["STRING_KEYBIND_RESET_SEGMENTS"]
			_G ["BINDING_NAME_DETAILS_SCROLL_UP"] = Loc ["STRING_KEYBIND_SCROLL_UP"]
			_G ["BINDING_NAME_DETAILS_SCROLL_DOWN"] = Loc ["STRING_KEYBIND_SCROLL_DOWN"]

			_G ["BINDING_NAME_DETAILS_REPORT_WINDOW1"] = format (Loc ["STRING_KEYBIND_WINDOW_REPORT"], 1)
			_G ["BINDING_NAME_DETAILS_REPORT_WINDOW2"] = format (Loc ["STRING_KEYBIND_WINDOW_REPORT"], 2)

			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW1"] = format (Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 1)
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW2"] = format (Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 2)
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW3"] = format (Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 3)
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW4"] = format (Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 4)
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW5"] = format (Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 5)

			_G ["BINDING_NAME_DETAILS_BOOKMARK1"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 1)
			_G ["BINDING_NAME_DETAILS_BOOKMARK2"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 2)
			_G ["BINDING_NAME_DETAILS_BOOKMARK3"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 3)
			_G ["BINDING_NAME_DETAILS_BOOKMARK4"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 4)
			_G ["BINDING_NAME_DETAILS_BOOKMARK5"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 5)
			_G ["BINDING_NAME_DETAILS_BOOKMARK6"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 6)
			_G ["BINDING_NAME_DETAILS_BOOKMARK7"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 7)
			_G ["BINDING_NAME_DETAILS_BOOKMARK8"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 8)
			_G ["BINDING_NAME_DETAILS_BOOKMARK9"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 9)
			_G ["BINDING_NAME_DETAILS_BOOKMARK10"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 10)

end
