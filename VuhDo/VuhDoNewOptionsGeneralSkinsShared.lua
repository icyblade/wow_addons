local GetNumRaidMembers = GetNumRaidMembers;
local GetNumPartyMembers = GetNumPartyMembers;
local twipe = table.wipe;
local tonumber = tonumber;
local pairs = pairs;
local ipairs = ipairs;
local _;
VUHDO_GROUP_SIZE = 1;

VUHDO_PROFILES = { };

local VUHDO_DEFAULT_PROFILES = {
	{
		["NAME"] = VUHDO_I18N_DEF_BIT_O_GRID,
		["CONFIG"] = {
			["DIRECTION"] = {
				["isAlways"] = false,
				["isDistanceText"] = false,
				["enable"] = true,
				["isDeadOnly"] = false,
				["scale"] = 50,
			},
			["MODE"] = 1,
			["IS_SHOW_GCD"] = false,
			["SHOW_PLAYER_TAGS"] = true,
			["SHOW_OVERHEAL"] = true,
			--["doCompress"] = true,
			["EMERGENCY_TRIGGER"] = 100,
			["SHOW_INCOMING"] = true,
			["HIDE_EMPTY_BUTTONS"] = false,
			["LOCK_CLICKS_THROUGH"] = false,
			["CUSTOM_DEBUFF"] = {
				["animate"] = true,
				["scale"] = 0.8,
				["isIcon"] = true,
				["selected"] = "",
				["TIMER_TEXT"] = {
					["X_ADJUST"] = 20,
					["USE_MONO"] = false,
					["Y_ADJUST"] = 26,
					["ANCHOR"] = "BOTTOMRIGHT",
					["USE_OUTLINE"] = false,
					["SCALE"] = 85,
					["COLOR"] = {
						["TG"] = 1,
						["R"] = 0,
						["TB"] = 1,
						["G"] = 0,
						["TR"] = 1,
						["TO"] = 1,
						["B"] = 0,
						["useBackground"] = true,
						["useText"] = true,
						["O"] = 1,
						["useOpacity"] = true,
					},
					["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
					["USE_SHADOW"] = true,
				},
				["yAdjust"] = -34,
				["isColor"] = false,
				["isStacks"] = false,
				["COUNTER_TEXT"] = {
					["X_ADJUST"] = -10,
					["USE_MONO"] = false,
					["Y_ADJUST"] = -15,
					["ANCHOR"] = "TOPLEFT",
					["USE_OUTLINE"] = false,
					["SCALE"] = 70,
					["COLOR"] = {
						["TG"] = 1,
						["R"] = 0,
						["TB"] = 0,
						["G"] = 0,
						["TR"] = 0,
						["TO"] = 1,
						["B"] = 0,
						["useBackground"] = true,
						["useText"] = true,
						["O"] = 1,
						["useOpacity"] = true,
					},
					["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
					["USE_SHADOW"] = true,
				},
				["point"] = "TOPRIGHT",
				["timer"] = true,
				["isName"] = false,
				["xAdjust"] = -2,
				["max_num"] = 3,
			},
			["SHOW_TEXT_OVERHEAL"] = true,
		},
		["LOCKED"] = false,
		["HARDLOCKED"] = true,
		["PANEL_POSITIONS"] = {
			{
				["y"] = 458.0802990022318,
				["x"] = 649.5469195970409,
				["orientation"] = "TOPLEFT",
				["relativePoint"] = "BOTTOMLEFT",
				["scale"] = 1,
				["height"] = 56,
				["growth"] = "TOPLEFT",
				["width"] = 56,
			}, -- [1]
		},
		["INDICATOR_CONFIG"] = {
			["CUSTOM"] = {
				["THREAT_BAR"] = {
					["invertGrowth"] = false,
					["turnAxis"] = false,
					["HEIGHT"] = 4,
					["WARN_AT"] = 85,
					["TEXTURE"] = "VuhDo - Polished Wood",
				},
				["MOUSEOVER_HIGHLIGHT"] = {
					["TEXTURE"] = "LiteStepLite",
				},
				["AGGRO_BAR"] = {
					["TEXTURE"] = "VuhDo - Polished Wood",
				},
				["BACKGROUND_BAR"] = {
					["TEXTURE"] = "VuhDo - Gradient",
				},
				["CLUSTER_BORDER"] = {
					["WIDTH"] = 2,
				},
				["SWIFTMEND_INDICATOR"] = {
					["SCALE"] = 1,
				},
				["SIDE_RIGHT"] = {
					["turnAxis"] = false,
					["vertical"] = true,
					["invertGrowth"] = false,
					["TEXTURE"] = "VuhDo - Plain White",
				},
				["BAR_BORDER"] = {
					["WIDTH"] = 1,
				},
				["HEALTH_BAR"] = {
					["turnAxis"] = true,
					["vertical"] = true,
					["invertGrowth"] = true,
				},
				["MANA_BAR"] = {
					["turnAxis"] = false,
					["invertGrowth"] = false,
					["TEXTURE"] = "VuhDo - Pipe, light",
				},
				["SIDE_LEFT"] = {
					["turnAxis"] = false,
					["vertical"] = true,
					["invertGrowth"] = false,
					["TEXTURE"] = "VuhDo - Plain White",
				},
			},
			["BOUQUETS"] = {
				["THREAT_BAR"] = "",
				["MOUSEOVER_HIGHLIGHT"] = VUHDO_I18N_GRID_MOUSEOVER_SINGLE,
				["AGGRO_BAR"] = "",
				["BACKGROUND_BAR"] = VUHDO_I18N_GRID_BACKGROUND_BAR,
				["HEALTH_BAR_PANEL"] = {
					"", -- [1]
					"", -- [2]
					"", -- [3]
					"", -- [4]
					"", -- [5]
					"", -- [6]
					"", -- [7]
					"", -- [8]
					"", -- [9]
					"", -- [10]
				},
				["SIDE_LEFT"] = "",
				["INCOMING_BAR"] = "",
				["CLUSTER_BORDER"] = "",
				["THREAT_MARK"] = "",
				["SIDE_RIGHT"] = "",
				["MANA_BAR"] = "",
				["BAR_BORDER"] = VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI,
				["HEALTH_BAR"] = VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_CLASS_COLOR,
				["DAMAGE_FLASH_BAR"] = "",
				["SWIFTMEND_INDICATOR"] = "",
			},
		},
		["ORIGINATOR_TOON"] = "Izaak",
		["PANEL_SETUP"] = {
			{
				["OVERHEAL_TEXT"] = {
					["show"] = false,
					["yAdjust"] = 0,
					["point"] = "LEFT",
					["scale"] = 1,
					["xAdjust"] = 0,
				},
				["POSITION"] = {
					["y"] = 458.0803,
					["x"] = 649.5469,
					["scale"] = 1,
					["relativePoint"] = "BOTTOMLEFT",
					["orientation"] = "TOPLEFT",
					["height"] = 56,
					["growth"] = "TOPLEFT",
					["width"] = 56,
				},
				["RAID_ICON"] = {
					["show"] = true,
					["yAdjust"] = -20,
					["point"] = "TOP",
					["scale"] = 1,
					["xAdjust"] = 0,
				},
				["frameStrata"] = "MEDIUM",
				["MODEL"] = {
					["ordering"] = 0,
					["groups"] = {
						1, -- [1]
						2, -- [2]
						3, -- [3]
						4, -- [4]
						5, -- [5]
						6, -- [6]
						7, -- [7]
						8, -- [8]
					},
					["sort"] = 0,
					["isReverse"] = false,
				},
				["PANEL_COLOR"] = {
					["BACK"] = {
						["useOpacity"] = true,
						["R"] = 0.235,
						["B"] = 0.235,
						["G"] = 0.235,
						["O"] = 0.87,
						["useBackground"] = true,
					},
					["HEADER"] = {
						["TG"] = 0.859,
						["R"] = 1,
						["TB"] = 0.38,
						["barTexture"] = "LiteStepLite",
						["G"] = 1,
						["TR"] = 1,
						["font"] = "Interface\\AddOns\\VuhDo\\Fonts\\Emblem.ttf",
						["TO"] = 1,
						["B"] = 1,
						["O"] = 0.4,
						["useText"] = true,
						["textSize"] = 10,
						["useBackground"] = true,
					},
					["BORDER"] = {
						["edgeSize"] = 16,
						["B"] = 0.458,
						["G"] = 0.45,
						["useOpacity"] = true,
						["R"] = 0.443,
						["useBackground"] = true,
						["file"] = "Interface\\Tooltips\\UI-Tooltip-Border",
						["O"] = 1,
						["insets"] = 4,
					},
					["barTexture"] = "VuhDo - Gradient",
					["TEXT"] = {
						["outline"] = false,
						["font"] = "Fonts\\FRIZQT__.TTF",
						["USE_MONO"] = false,
						["useText"] = true,
						["textSize"] = 11,
						["useOpacity"] = true,
						["textSizeLife"] = 8,
						["maxChars"] = 4,
					},
				},
				["HOTS"] = {
					["size"] = 36,
				},
				["SCALING"] = {
					["headerHeight"] = 16,
					["rowSpacing"] = 5,
					["arrangeHorizontal"] = false,
					["scale"] = 1,
					["maxColumnsWhenStructured"] = 8,
					["barWidth"] = 32,
					["columnSpacing"] = 5,
					["borderGapY"] = 12,
					["targetSpacing"] = 3,
					["targetOrientation"] = 1,
					["ommitEmptyWhenStructured"] = true,
					["showTarget"] = false,
					["maxRowsWhenLoose"] = 6,
					["sideLeftWidth"] = 6,
					["manaBarHeight"] = 3,
					["headerSpacing"] = 5,
					["borderGapX"] = 12,
					["sideRightWidth"] = 6,
					["totSpacing"] = 3,
					["isPlayerOnTop"] = true,
					["showHeaders"] = false,
					["totWidth"] = 30,
					["showTot"] = false,
					["isDamFlash"] = true,
					["headerWidth"] = 100,
					["isTarClassColBack"] = false,
					["targetWidth"] = 30,
					["isTarClassColText"] = true,
					["damFlashFactor"] = 0.75,
					["barHeight"] = 32,
					["alignBottom"] = false,
				},
				["LIFE_TEXT"] = {
					["show"] = true,
					["hideIrrelevant"] = false,
					["position"] = 4,
					["showTotalHp"] = false,
					["mode"] = 3,
					["verbose"] = false,
				},
				["ID_TEXT"] = {
					["showClass"] = false,
					["showName"] = true,
					["showTags"] = true,
					["position"] = "CENTER+CENTER",
					["_spacing"] = 18.99999430662054,
					["showPetOwners"] = false,
				},
			}, -- [1]
			["PANEL_COLOR"] = {
				["TEXT"] = {
					["TR"] = 0.965,
					["TO"] = 1,
					["TB"] = 0.996,
					["useText"] = true,
					["TG"] = 1,
				},
				["BARS"] = {
					["useOpacity"] = true,
					["R"] = 0.7,
					["B"] = 0.7,
					["G"] = 0.7,
					["O"] = 1,
					["useBackground"] = true,
				},
				["classColorsName"] = true,
			},
			["HOTS"] = {
				["SLOTS"] = {
					[10] = "BOUQUET_Hinweis Gruppenheilung",
				},
				["BARS"] = {
					["radioValue"] = 1,
					["width"] = 25,
				},
				["TIMER_TEXT"] = {
					["X_ADJUST"] = 0,
					["SCALE"] = 100,
					["USE_MONO"] = false,
					["Y_ADJUST"] = 0,
					["FONT"] = "Fonts\\ARIALN.TTF",
					["USE_SHADOW"] = false,
					["ANCHOR"] = "CENTER",
					["USE_OUTLINE"] = true,
				},
				["SLOTCFG"] = {
					["10"] = {
						["scale"] = 1.5,
						["mine"] = true,
						["others"] = false,
					},
				},
				["iconRadioValue"] = 3,
				["radioValue"] = 21,
				["COUNTER_TEXT"] = {
					["X_ADJUST"] = -25,
					["SCALE"] = 66,
					["USE_MONO"] = false,
					["Y_ADJUST"] = 0,
					["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
					["USE_SHADOW"] = false,
					["ANCHOR"] = "TOPLEFT",
					["USE_OUTLINE"] = true,
				},
				["stacksRadioValue"] = 1,
			},
			["BAR_COLORS"] = {
				["OVERHEAL_TEXT"] = {
					["useOpacity"] = true,
					["TO"] = 1,
					["TB"] = 0.8,
					["TG"] = 1,
					["useText"] = true,
					["TR"] = 0.8,
				},
				["HOT7"] = {
					["useBackground"] = true,
					["R"] = 1,
					["B"] = 1,
					["G"] = 1,
					["O"] = 0.75,
				},
				["HOT1"] = {
					["TG"] = 0.6,
					["countdownMode"] = 0,
					["R"] = 1,
					["TB"] = 0.6,
					["G"] = 0.3,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.3,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["useDebuffIconBossOnly"] = true,
				["BAR_FRAMES"] = {
					["useOpacity"] = true,
					["R"] = 0,
					["B"] = 0,
					["G"] = 0,
					["O"] = 0.7,
					["useBackground"] = true,
				},
				["HOT9"] = {
					["TG"] = 1,
					["countdownMode"] = 0,
					["R"] = 0.3,
					["TB"] = 1,
					["G"] = 1,
					["TR"] = 0.6,
					["TO"] = 1,
					["B"] = 1,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["HOT_CHARGE_3"] = {
					["TG"] = 1,
					["R"] = 0.3,
					["TB"] = 0.6,
					["G"] = 1,
					["TR"] = 0.6,
					["TO"] = 1,
					["B"] = 0.3,
					["useBackground"] = true,
					["O"] = 1,
					["useText"] = true,
				},
				["DEBUFF3"] = {
					["TG"] = 0.957,
					["R"] = 0.4,
					["TB"] = 1,
					["G"] = 0.4,
					["TR"] = 0.329,
					["TO"] = 1,
					["B"] = 0.8,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["INCOMING"] = {
					["TG"] = 0.8254,
					["R"] = 0,
					["TB"] = 0,
					["G"] = 0,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0,
					["useBackground"] = false,
					["useText"] = false,
					["O"] = 0.33,
					["useOpacity"] = true,
				},
				["DEBUFF4"] = {
					["TG"] = 0,
					["R"] = 0.7,
					["TB"] = 1,
					["G"] = 0,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.7,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["DEBUFF6"] = {
					["TG"] = 0.5,
					["R"] = 0.6,
					["TB"] = 0,
					["G"] = 0.3,
					["TR"] = 0.8,
					["TO"] = 1,
					["B"] = 0,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["HOT5"] = {
					["TG"] = 0.6,
					["countdownMode"] = 0,
					["R"] = 1,
					["TB"] = 1,
					["G"] = 0.3,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 1,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["HOTS"] = {
					["useColorText"] = true,
					["useColorBack"] = true,
					["isPumpDivineAegis"] = false,
					["isFadeOut"] = false,
					["isFlashWhenLow"] = false,
					["showShieldAbsorb"] = true,
					["WARNING"] = {
						["enabled"] = false,
						["lowSecs"] = 3,
						["R"] = 0.5,
						["TB"] = 0.6,
						["G"] = 0.2,
						["TR"] = 1,
						["TO"] = 1,
						["B"] = 0.2,
						["useBackground"] = true,
						["useText"] = true,
						["O"] = 1,
						["TG"] = 0.6,
					},
				},
				["HOT2"] = {
					["TG"] = 1,
					["countdownMode"] = 0,
					["R"] = 1,
					["TB"] = 0.6,
					["G"] = 1,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.3,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["DEAD"] = {
					["TG"] = 0.5,
					["R"] = 0.3,
					["TB"] = 0.5,
					["G"] = 0.3,
					["TR"] = 0.5,
					["TO"] = 1,
					["B"] = 0.3,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 0.5,
					["useOpacity"] = true,
				},
				["useDebuffIcon"] = false,
				["OFFLINE"] = {
					["TG"] = 0.5760533102985354,
					["R"] = 0.298,
					["TB"] = 0.576,
					["G"] = 0.298,
					["TR"] = 0.5760535455434231,
					["TO"] = 0.58,
					["B"] = 0.298,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 0.21,
					["useOpacity"] = true,
				},
				["OUTRANGED"] = {
					["TG"] = 0,
					["R"] = 0,
					["TB"] = 0,
					["G"] = 0,
					["TR"] = 0,
					["TO"] = 0.5,
					["B"] = 0,
					["useBackground"] = false,
					["useText"] = false,
					["O"] = 0.2,
					["useOpacity"] = true,
				},
				["CHARMED"] = {
					["TG"] = 0.31,
					["R"] = 0.51,
					["TB"] = 0.31,
					["G"] = 0.08254,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.263,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["HOT3"] = {
					["TG"] = 1,
					["countdownMode"] = 0,
					["R"] = 0,
					["TB"] = 1,
					["G"] = 1,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.1765,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["HOT4"] = {
					["TG"] = 0.815,
					["countdownMode"] = 0,
					["R"] = 0.301,
					["TB"] = 1,
					["G"] = 0.301,
					["TR"] = 0.7881,
					["TO"] = 1,
					["B"] = 1,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["DEBUFF2"] = {
					["TG"] = 0,
					["R"] = 0.8,
					["TB"] = 0,
					["G"] = 0.4,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.4,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["DEBUFF0"] = {
					["useBackground"] = false,
					["useText"] = false,
					["useOpacity"] = false,
				},
				["HOT8"] = {
					["useBackground"] = true,
					["R"] = 1,
					["B"] = 1,
					["G"] = 1,
					["O"] = 0.75,
				},
				["HOT10"] = {
					["TG"] = 1,
					["countdownMode"] = 0,
					["R"] = 0.3,
					["TB"] = 0.3,
					["G"] = 1,
					["TR"] = 0.6,
					["TO"] = 1,
					["B"] = 0.3,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["HOT_CHARGE_4"] = {
					["TG"] = 1,
					["R"] = 0.8,
					["TB"] = 1,
					["G"] = 0.8,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.8,
					["useBackground"] = true,
					["O"] = 1,
					["useText"] = true,
				},
				["DEBUFF1"] = {
					["TG"] = 1,
					["R"] = 0,
					["TB"] = 0.6861,
					["G"] = 0.592,
					["TR"] = 0,
					["TO"] = 1,
					["B"] = 0.8,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["HOT_CHARGE_2"] = {
					["TG"] = 1,
					["R"] = 1,
					["TB"] = 0.6,
					["G"] = 1,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.3,
					["useBackground"] = true,
					["O"] = 1,
					["useText"] = true,
				},
			},
		},
		["ORIGINATOR_CLASS"] = "PRIEST",
	}, -- [1]
	{
		["NAME"] = VUHDO_I18N_DEF_VUHDO_ESQUE,
		["CONFIG"] = {
			["DIRECTION"] = {
				["isAlways"] = false,
				["isDistanceText"] = false,
				["enable"] = true,
				["isDeadOnly"] = false,
				["scale"] = 75,
			},
			["MODE"] = 1,
			["IS_SHOW_GCD"] = false,
			["SHOW_PLAYER_TAGS"] = true,
			["SHOW_OVERHEAL"] = true,
			--["doCompress"] = true,
			["EMERGENCY_TRIGGER"] = 100,
			["SHOW_INCOMING"] = true,
			["HIDE_EMPTY_BUTTONS"] = false,
			["LOCK_CLICKS_THROUGH"] = false,
			["SHOW_TEXT_OVERHEAL"] = true,
		},
		["LOCKED"] = false,
		["HARDLOCKED"] = true,
		["PANEL_POSITIONS"] = {
			{
				["y"] = 731.9998928801197,
				["x"] = 42.82658437085802,
				["scale"] = 1,
				["relativePoint"] = "BOTTOMLEFT",
				["orientation"] = "TOPLEFT",
				["height"] = 55.9999836930366,
				["growth"] = "TOPLEFT",
				["width"] = 84.99999950797955,
			}, -- [1]
			{
				["y"] = 733.706721371843,
				["x"] = 131.5732897843692,
				["scale"] = 1,
				["relativePoint"] = "BOTTOMLEFT",
				["orientation"] = "TOPLEFT",
				["height"] = 30.99993554532138,
				["growth"] = "TOPLEFT",
				["width"] = 143.0000131439748,
			}, -- [2]
			{
				["y"] = 668.8535725358685,
				["x"] = 44.53297651073297,
				["scale"] = 1,
				["relativePoint"] = "BOTTOMLEFT",
				["orientation"] = "TOPLEFT",
				["height"] = 19.99999353344555,
				["growth"] = "TOPLEFT",
				["width"] = 84.99999051103423,
			}, -- [3]
			{
				["y"] = 685.2200237420952,
				["x"] = 140.9599377973693,
				["scale"] = 1,
				["relativePoint"] = "BOTTOMLEFT",
				["orientation"] = "TOPLEFT",
				["height"] = 82.99997856196622,
				["growth"] = "TOPLEFT",
				["width"] = 118.0000032332772,
			}, -- [4]
			{
				["y"] = 668,
				["x"] = 100,
				["scale"] = 1,
				["relativePoint"] = "BOTTOMLEFT",
				["orientation"] = "TOPLEFT",
				["height"] = 200,
				["growth"] = "TOPLEFT",
				["width"] = 200,
			}
		},
		["INDICATOR_CONFIG"] = {
			["CUSTOM"] = {
				["THREAT_BAR"] = {
					["invertGrowth"] = false,
					["turnAxis"] = false,
					["HEIGHT"] = 4,
					["WARN_AT"] = 85,
					["TEXTURE"] = "VuhDo - Polished Wood",
				},
				["MOUSEOVER_HIGHLIGHT"] = {
					["TEXTURE"] = "VuhDo - Aluminium",
				},
				["AGGRO_BAR"] = {
					["TEXTURE"] = "VuhDo - Polished Wood",
				},
				["BACKGROUND_BAR"] = {
					["TEXTURE"] = "VuhDo - Minimalist",
				},
				["CLUSTER_BORDER"] = {
					["WIDTH"] = 2,
				},
				["SWIFTMEND_INDICATOR"] = {
					["SCALE"] = 1,
				},
				["SIDE_RIGHT"] = {
					["turnAxis"] = false,
					["vertical"] = true,
					["invertGrowth"] = false,
					["TEXTURE"] = "VuhDo - Plain White",
				},
				["BAR_BORDER"] = {
					["WIDTH"] = 1,
				},
				["HEALTH_BAR"] = {
					["turnAxis"] = false,
					["vertical"] = false,
					["invertGrowth"] = false,
				},
				["MANA_BAR"] = {
					["turnAxis"] = false,
					["invertGrowth"] = false,
					["TEXTURE"] = "VuhDo - Pipe, light",
				},
				["SIDE_LEFT"] = {
					["turnAxis"] = false,
					["vertical"] = true,
					["invertGrowth"] = false,
					["TEXTURE"] = "VuhDo - Plain White",
				},
			},
			["BOUQUETS"] = {
				["THREAT_BAR"] = "",
				["MOUSEOVER_HIGHLIGHT"] = "",
				["AGGRO_BAR"] = "",
				["BACKGROUND_BAR"] = VUHDO_I18N_DEF_BAR_BACKGROUND_SOLID,
				["HEALTH_BAR_PANEL"] = {
					"", -- [1]
					"", -- [2]
					"", -- [3]
					"", -- [4]
					"", -- [5]
					"", -- [6]
					"", -- [7]
					"", -- [8]
					"", -- [9]
					"", -- [10]
				},
				["SIDE_LEFT"] = "",
				["INCOMING_BAR"] = "",
				["CLUSTER_BORDER"] = "",
				["THREAT_MARK"] = "",
				["SIDE_RIGHT"] = "",
				["MANA_BAR"] = VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ONLY,
				["BAR_BORDER"] = VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI_AGGRO,
				["HEALTH_BAR"] = VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH,
				["DAMAGE_FLASH_BAR"] = "",
				["SWIFTMEND_INDICATOR"] = VUHDO_I18N_DEF_ROLE_ICON,
			},
		},
		["ORIGINATOR_TOON"] = "Izaak",
		["PANEL_SETUP"] = {
			{
				["OVERHEAL_TEXT"] = {
					["show"] = true,
					["yAdjust"] = 0,
					["point"] = "LEFT",
					["scale"] = 1,
					["xAdjust"] = 0,
				},
				["POSITION"] = {
					["y"] = 731.9998928801197,
					["x"] = 42.82658437085802,
					["orientation"] = "TOPLEFT",
					["relativePoint"] = "BOTTOMLEFT",
					["scale"] = 1,
					["height"] = 55.9999836930366,
					["growth"] = "TOPLEFT",
					["width"] = 84.99999950797955,
				},
				["RAID_ICON"] = {
					["show"] = true,
					["yAdjust"] = -20,
					["point"] = "TOP",
					["scale"] = 1,
					["xAdjust"] = 0,
				},
				["frameStrata"] = "MEDIUM",
				["MODEL"] = {
					["ordering"] = 0,
					["groups"] = {
						1, -- [1]
						2, -- [2]
						3, -- [3]
						4, -- [4]
						5, -- [5]
						6, -- [6]
						7, -- [7]
						8, -- [8]
					},
					["sort"] = 0,
					["isReverse"] = false,
				},
				["TOOLTIP"] = {
					["BACKGROUND"] = {
						["useOpacity"] = true,
						["R"] = 0,
						["B"] = 0,
						["G"] = 0,
						["O"] = 1,
						["useBackground"] = true,
					},
					["inFight"] = false,
					["BORDER"] = {
						["useOpacity"] = true,
						["R"] = 0,
						["B"] = 0,
						["G"] = 0,
						["O"] = 1,
						["useBackground"] = true,
					},
					["showBuffs"] = false,
					["show"] = true,
					["x"] = 100,
					["position"] = 2,
					["SCALE"] = 1,
					["y"] = -100,
					["point"] = "TOPLEFT",
					["relativePoint"] = "TOPLEFT",
				},
				["PANEL_COLOR"] = {
					["BACK"] = {
						["useOpacity"] = true,
						["R"] = 0,
						["B"] = 0,
						["G"] = 0,
						["O"] = 0.4,
						["useBackground"] = true,
					},
					["HEADER"] = {
						["TG"] = 0.859,
						["R"] = 1,
						["TB"] = 0.38,
						["barTexture"] = "LiteStepLite",
						["G"] = 1,
						["TR"] = 1,
						["font"] = "Interface\\AddOns\\VuhDo\\Fonts\\Emblem.ttf",
						["TO"] = 1,
						["B"] = 1,
						["O"] = 0.4,
						["useText"] = true,
						["textSize"] = 10,
						["useBackground"] = true,
					},
					["BORDER"] = {
						["edgeSize"] = 8,
						["B"] = 0,
						["G"] = 0,
						["useOpacity"] = true,
						["R"] = 0,
						["useBackground"] = true,
						["file"] = "Interface\\Tooltips\\UI-Tooltip-Border",
						["O"] = 0.46,
						["insets"] = 1,
					},
					["barTexture"] = "VuhDo - Polished Wood",
					["TEXT"] = {
						["outline"] = false,
						["font"] = "Interface\\AddOns\\VuhDo\\Fonts\\Emblem.ttf",
						["USE_MONO"] = false,
						["useText"] = true,
						["textSize"] = 10,
						["useOpacity"] = true,
						["textSizeLife"] = 8,
						["maxChars"] = 0,
					},
				},
				["HOTS"] = {
					["size"] = 76,
				},
				["SCALING"] = {
					["headerHeight"] = 16,
					["rowSpacing"] = 2,
					["arrangeHorizontal"] = false,
					["scale"] = 1,
					["maxColumnsWhenStructured"] = 8,
					["barWidth"] = 75,
					["columnSpacing"] = 5,
					["borderGapY"] = 5,
					["targetSpacing"] = 3,
					["targetOrientation"] = 1,
					["ommitEmptyWhenStructured"] = true,
					["showTarget"] = false,
					["maxRowsWhenLoose"] = 6,
					["sideLeftWidth"] = 6,
					["manaBarHeight"] = 3,
					["headerSpacing"] = 5,
					["borderGapX"] = 5,
					["sideRightWidth"] = 6,
					["totSpacing"] = 3,
					["isPlayerOnTop"] = true,
					["showHeaders"] = true,
					["totWidth"] = 30,
					["showTot"] = false,
					["isDamFlash"] = true,
					["headerWidth"] = 100,
					["isTarClassColBack"] = false,
					["targetWidth"] = 30,
					["isTarClassColText"] = true,
					["damFlashFactor"] = 0.75,
					["barHeight"] = 25,
					["alignBottom"] = false,
				},
				["LIFE_TEXT"] = {
					["show"] = true,
					["hideIrrelevant"] = false,
					["position"] = 3,
					["showTotalHp"] = false,
					["mode"] = 1,
					["verbose"] = false,
				},
				["ID_TEXT"] = {
					["showClass"] = false,
					["showName"] = true,
					["showTags"] = true,
					["position"] = "BOTTOMRIGHT+BOTTOMRIGHT",
					["_spacing"] = 17.99999507979553,
					["showPetOwners"] = true,
				},
			}, -- [1]
			{
				["OVERHEAL_TEXT"] = {
					["show"] = true,
					["yAdjust"] = 0,
					["point"] = "LEFT",
					["scale"] = 1,
					["xAdjust"] = 0,
				},
				["POSITION"] = {
					["y"] = 733.706721371843,
					["x"] = 131.5732897843692,
					["orientation"] = "TOPLEFT",
					["relativePoint"] = "BOTTOMLEFT",
					["scale"] = 1,
					["height"] = 30.99993554532138,
					["growth"] = "TOPLEFT",
					["width"] = 143.0000131439748,
				},
				["RAID_ICON"] = {
					["show"] = true,
					["yAdjust"] = -20,
					["point"] = "TOP",
					["scale"] = 1,
					["xAdjust"] = 0,
				},
				["frameStrata"] = "MEDIUM",
				["MODEL"] = {
					["ordering"] = 0,
					["groups"] = {
						41, -- [1]
					},
					["sort"] = 0,
					["isReverse"] = false,
				},
				["TOOLTIP"] = {
					["BACKGROUND"] = {
						["useOpacity"] = true,
						["R"] = 0,
						["B"] = 0,
						["G"] = 0,
						["O"] = 1,
						["useBackground"] = true,
					},
					["inFight"] = false,
					["BORDER"] = {
						["useOpacity"] = true,
						["R"] = 0,
						["B"] = 0,
						["G"] = 0,
						["O"] = 1,
						["useBackground"] = true,
					},
					["showBuffs"] = false,
					["show"] = true,
					["x"] = 100,
					["position"] = 2,
					["SCALE"] = 1,
					["y"] = -100,
					["point"] = "TOPLEFT",
					["relativePoint"] = "TOPLEFT",
				},
				["PANEL_COLOR"] = {
					["BACK"] = {
						["useOpacity"] = true,
						["R"] = 0,
						["B"] = 0,
						["G"] = 0,
						["O"] = 0.4,
						["useBackground"] = true,
					},
					["HEADER"] = {
						["TG"] = 0.859,
						["R"] = 1,
						["TB"] = 0.38,
						["barTexture"] = "LiteStepLite",
						["G"] = 1,
						["TR"] = 1,
						["font"] = "Interface\\AddOns\\VuhDo\\Fonts\\Emblem.ttf",
						["TO"] = 1,
						["B"] = 1,
						["O"] = 0.4,
						["useText"] = true,
						["textSize"] = 10,
						["useBackground"] = true,
					},
					["BORDER"] = {
						["edgeSize"] = 8,
						["B"] = 0,
						["G"] = 0,
						["useOpacity"] = true,
						["R"] = 0,
						["useBackground"] = true,
						["file"] = "Interface\\Tooltips\\UI-Tooltip-Border",
						["O"] = 0.46,
						["insets"] = 1,
					},
					["barTexture"] = "VuhDo - Polished Wood",
					["TEXT"] = {
						["outline"] = false,
						["font"] = "Interface\\AddOns\\VuhDo\\Fonts\\Emblem.ttf",
						["USE_MONO"] = false,
						["useText"] = true,
						["textSize"] = 12,
						["useOpacity"] = true,
						["textSizeLife"] = 8,
						["maxChars"] = 0,
					},
				},
				["HOTS"] = {
					["size"] = 76,
				},
				["SCALING"] = {
					["headerHeight"] = 16,
					["rowSpacing"] = 2,
					["arrangeHorizontal"] = false,
					["scale"] = 1,
					["maxColumnsWhenStructured"] = 8,
					["barWidth"] = 100,
					["columnSpacing"] = 5,
					["borderGapY"] = 5,
					["targetSpacing"] = 3,
					["targetOrientation"] = 1,
					["ommitEmptyWhenStructured"] = false,
					["showTarget"] = true,
					["maxRowsWhenLoose"] = 6,
					["sideLeftWidth"] = 6,
					["manaBarHeight"] = 3,
					["headerSpacing"] = 5,
					["borderGapX"] = 5,
					["sideRightWidth"] = 6,
					["totSpacing"] = 3,
					["isPlayerOnTop"] = true,
					["showHeaders"] = true,
					["totWidth"] = 30,
					["showTot"] = false,
					["isDamFlash"] = true,
					["headerWidth"] = 100,
					["isTarClassColBack"] = false,
					["targetWidth"] = 30,
					["isTarClassColText"] = true,
					["damFlashFactor"] = 0.75,
					["barHeight"] = 26,
					["alignBottom"] = false,
				},
				["LIFE_TEXT"] = {
					["show"] = true,
					["hideIrrelevant"] = false,
					["position"] = 3,
					["showTotalHp"] = false,
					["mode"] = 1,
					["verbose"] = false,
				},
				["ID_TEXT"] = {
					["showClass"] = false,
					["showName"] = true,
					["showTags"] = true,
					["position"] = "BOTTOMRIGHT+BOTTOMRIGHT",
					["showPetOwners"] = true,
				},
			}, -- [2]
			{
				["OVERHEAL_TEXT"] = {
					["show"] = true,
					["yAdjust"] = 0,
					["point"] = "LEFT",
					["scale"] = 1,
					["xAdjust"] = 0,
				},
				["POSITION"] = {
					["y"] = 668.8535725358685,
					["x"] = 44.53297651073297,
					["orientation"] = "TOPLEFT",
					["relativePoint"] = "BOTTOMLEFT",
					["scale"] = 1,
					["height"] = 19.99999353344555,
					["growth"] = "TOPLEFT",
					["width"] = 84.99999051103423,
				},
				["RAID_ICON"] = {
					["show"] = true,
					["yAdjust"] = -20,
					["point"] = "TOP",
					["scale"] = 1,
					["xAdjust"] = 0,
				},
				["frameStrata"] = "MEDIUM",
				["MODEL"] = {
					["ordering"] = 1,
					["groups"] = {
						40, -- [1]
					},
					["sort"] = 0,
					["isReverse"] = false,
				},
				["TOOLTIP"] = {
					["BACKGROUND"] = {
						["useOpacity"] = true,
						["R"] = 0,
						["B"] = 0,
						["G"] = 0,
						["O"] = 1,
						["useBackground"] = true,
					},
					["inFight"] = false,
					["BORDER"] = {
						["useOpacity"] = true,
						["R"] = 0,
						["B"] = 0,
						["G"] = 0,
						["O"] = 1,
						["useBackground"] = true,
					},
					["showBuffs"] = false,
					["show"] = true,
					["x"] = 100,
					["position"] = 2,
					["SCALE"] = 1,
					["y"] = -100,
					["point"] = "TOPLEFT",
					["relativePoint"] = "TOPLEFT",
				},
				["PANEL_COLOR"] = {
					["BACK"] = {
						["useOpacity"] = true,
						["R"] = 0,
						["B"] = 0,
						["G"] = 0,
						["O"] = 0.4,
						["useBackground"] = true,
					},
					["HEADER"] = {
						["TG"] = 0.859,
						["R"] = 1,
						["TB"] = 0.38,
						["barTexture"] = "LiteStepLite",
						["G"] = 1,
						["TR"] = 1,
						["font"] = "Interface\\AddOns\\VuhDo\\Fonts\\Emblem.ttf",
						["TO"] = 1,
						["B"] = 1,
						["O"] = 0.4,
						["useText"] = true,
						["textSize"] = 10,
						["useBackground"] = true,
					},
					["BORDER"] = {
						["edgeSize"] = 8,
						["B"] = 0,
						["G"] = 0,
						["useOpacity"] = true,
						["R"] = 0,
						["useBackground"] = true,
						["file"] = "Interface\\Tooltips\\UI-Tooltip-Border",
						["O"] = 0.46,
						["insets"] = 1,
					},
					["barTexture"] = "VuhDo - Polished Wood",
					["TEXT"] = {
						["outline"] = false,
						["font"] = "Interface\\AddOns\\VuhDo\\Fonts\\Emblem.ttf",
						["USE_MONO"] = false,
						["useText"] = true,
						["textSize"] = 10,
						["useOpacity"] = true,
						["textSizeLife"] = 8,
						["maxChars"] = 0,
					},
				},
				["HOTS"] = {
					["size"] = 76,
				},
				["SCALING"] = {
					["headerHeight"] = 16,
					["rowSpacing"] = 2,
					["arrangeHorizontal"] = false,
					["scale"] = 1,
					["maxColumnsWhenStructured"] = 8,
					["barWidth"] = 75,
					["columnSpacing"] = 5,
					["borderGapY"] = 5,
					["targetSpacing"] = 3,
					["targetOrientation"] = 1,
					["ommitEmptyWhenStructured"] = false,
					["showTarget"] = false,
					["maxRowsWhenLoose"] = 6,
					["sideLeftWidth"] = 6,
					["manaBarHeight"] = 3,
					["headerSpacing"] = 5,
					["borderGapX"] = 5,
					["sideRightWidth"] = 6,
					["totSpacing"] = 3,
					["isPlayerOnTop"] = true,
					["showHeaders"] = true,
					["totWidth"] = 30,
					["showTot"] = false,
					["isDamFlash"] = true,
					["headerWidth"] = 100,
					["isTarClassColBack"] = false,
					["targetWidth"] = 30,
					["isTarClassColText"] = true,
					["damFlashFactor"] = 0.75,
					["barHeight"] = 25,
					["alignBottom"] = false,
				},
				["LIFE_TEXT"] = {
					["show"] = true,
					["hideIrrelevant"] = false,
					["position"] = 3,
					["showTotalHp"] = false,
					["mode"] = 1,
					["verbose"] = false,
				},
				["ID_TEXT"] = {
					["showClass"] = false,
					["showName"] = true,
					["showTags"] = true,
					["position"] = "BOTTOMRIGHT+BOTTOMRIGHT",
					["showPetOwners"] = true,
				},
			}, -- [3]
			{
				["OVERHEAL_TEXT"] = {
					["show"] = true,
					["yAdjust"] = 0,
					["point"] = "LEFT",
					["scale"] = 1,
					["xAdjust"] = 0,
				},
				["POSITION"] = {
					["y"] = 685.2200237420952,
					["x"] = 140.9599377973693,
					["orientation"] = "TOPLEFT",
					["relativePoint"] = "BOTTOMLEFT",
					["scale"] = 1,
					["height"] = 82.99997856196622,
					["growth"] = "TOPLEFT",
					["width"] = 118.0000032332772,
				},
				["RAID_ICON"] = {
					["show"] = true,
					["yAdjust"] = -20,
					["point"] = "TOP",
					["scale"] = 1,
					["xAdjust"] = 0,
				},
				["frameStrata"] = "MEDIUM",
				["MODEL"] = {
					["ordering"] = 0,
					["groups"] = {
						42, -- [1]
					},
					["sort"] = 0,
					["isReverse"] = false,
				},
				["TOOLTIP"] = {
					["BACKGROUND"] = {
						["useOpacity"] = true,
						["R"] = 0,
						["B"] = 0,
						["G"] = 0,
						["O"] = 1,
						["useBackground"] = true,
					},
					["inFight"] = false,
					["BORDER"] = {
						["useOpacity"] = true,
						["R"] = 0,
						["B"] = 0,
						["G"] = 0,
						["O"] = 1,
						["useBackground"] = true,
					},
					["showBuffs"] = false,
					["show"] = true,
					["x"] = 100,
					["position"] = 2,
					["SCALE"] = 1,
					["y"] = -100,
					["point"] = "TOPLEFT",
					["relativePoint"] = "TOPLEFT",
				},
				["PANEL_COLOR"] = {
					["BACK"] = {
						["useOpacity"] = true,
						["R"] = 0,
						["B"] = 0,
						["G"] = 0,
						["O"] = 0.4,
						["useBackground"] = true,
					},
					["HEADER"] = {
						["TG"] = 0.859,
						["R"] = 1,
						["TB"] = 0.38,
						["barTexture"] = "LiteStepLite",
						["G"] = 1,
						["TR"] = 1,
						["font"] = "Interface\\AddOns\\VuhDo\\Fonts\\Emblem.ttf",
						["TO"] = 1,
						["B"] = 1,
						["O"] = 0.4,
						["useText"] = true,
						["textSize"] = 10,
						["useBackground"] = true,
					},
					["BORDER"] = {
						["edgeSize"] = 8,
						["B"] = 0,
						["G"] = 0,
						["useOpacity"] = true,
						["R"] = 0,
						["useBackground"] = true,
						["file"] = "Interface\\Tooltips\\UI-Tooltip-Border",
						["O"] = 0.46,
						["insets"] = 1,
					},
					["barTexture"] = "VuhDo - Polished Wood",
					["TEXT"] = {
						["outline"] = false,
						["font"] = "Interface\\AddOns\\VuhDo\\Fonts\\Emblem.ttf",
						["USE_MONO"] = false,
						["useText"] = true,
						["textSize"] = 10,
						["useOpacity"] = true,
						["textSizeLife"] = 8,
						["maxChars"] = 0,
					},
				},
				["HOTS"] = {
					["size"] = 76,
				},
				["SCALING"] = {
					["headerHeight"] = 16,
					["rowSpacing"] = 2,
					["arrangeHorizontal"] = false,
					["scale"] = 1,
					["maxColumnsWhenStructured"] = 8,
					["barWidth"] = 75,
					["columnSpacing"] = 5,
					["borderGapY"] = 5,
					["targetSpacing"] = 3,
					["targetOrientation"] = 1,
					["ommitEmptyWhenStructured"] = false,
					["showTarget"] = true,
					["maxRowsWhenLoose"] = 6,
					["sideLeftWidth"] = 6,
					["manaBarHeight"] = 3,
					["headerSpacing"] = 5,
					["borderGapX"] = 5,
					["sideRightWidth"] = 6,
					["totSpacing"] = 3,
					["isPlayerOnTop"] = true,
					["showHeaders"] = true,
					["totWidth"] = 30,
					["showTot"] = false,
					["isDamFlash"] = true,
					["headerWidth"] = 100,
					["isTarClassColBack"] = false,
					["targetWidth"] = 30,
					["isTarClassColText"] = true,
					["damFlashFactor"] = 0.75,
					["barHeight"] = 25,
					["alignBottom"] = false,
				},
				["LIFE_TEXT"] = {
					["show"] = true,
					["hideIrrelevant"] = false,
					["position"] = 3,
					["showTotalHp"] = false,
					["mode"] = 1,
					["verbose"] = false,
				},
				["ID_TEXT"] = {
					["showClass"] = false,
					["showName"] = true,
					["showTags"] = true,
					["position"] = "BOTTOMRIGHT+BOTTOMRIGHT",
					["_spacing"] = 17.99999507979553,
					["showPetOwners"] = true,
				},
			}, -- [4]
			["PANEL_COLOR"] = {
				["TEXT"] = {
					["TR"] = 1,
					["TO"] = 1,
					["TB"] = 0,
					["useText"] = true,
					["TG"] = 0.82,
				},
				["BARS"] = {
					["useOpacity"] = true,
					["R"] = 0.7,
					["B"] = 0.7,
					["G"] = 0.7,
					["O"] = 1,
					["useBackground"] = true,
				},
				["classColorsName"] = false,
			},
			["HOTS"] = {
				["SLOTS"] = {
					[10] = "BOUQUET_" .. VUHDO_I18N_DEF_AOE_ADVICE,
				},
				["BARS"] = {
					["radioValue"] = 1,
					["width"] = 25,
				},
				["TIMER_TEXT"] = {
					["X_ADJUST"] = 25,
					["SCALE"] = 60,
					["USE_MONO"] = false,
					["Y_ADJUST"] = 0,
					["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
					["USE_SHADOW"] = false,
					["ANCHOR"] = "BOTTOMRIGHT",
					["USE_OUTLINE"] = true,
				},
				["iconRadioValue"] = 2,
				["radioValue"] = 20,
				["COUNTER_TEXT"] = {
					["X_ADJUST"] = -25,
					["SCALE"] = 66,
					["USE_MONO"] = false,
					["Y_ADJUST"] = 0,
					["FONT"] = "Interface\\AddOns\\VuhDo\\Fonts\\ariblk.ttf",
					["USE_SHADOW"] = false,
					["ANCHOR"] = "TOPLEFT",
					["USE_OUTLINE"] = true,
				},
				["stacksRadioValue"] = 3,
			},
			["BAR_COLORS"] = {
				["OVERHEAL_TEXT"] = {
					["useOpacity"] = true,
					["TO"] = 1,
					["TB"] = 0.8,
					["TG"] = 1,
					["useText"] = true,
					["TR"] = 0.8,
				},
				["HOT7"] = {
					["useBackground"] = true,
					["R"] = 1,
					["B"] = 1,
					["G"] = 1,
					["O"] = 0.75,
				},
				["CLUSTER_FAIR"] = {
					["TG"] = 1,
					["R"] = 0.8,
					["TB"] = 0,
					["G"] = 0.8,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0,
					["useBackground"] = true,
					["O"] = 1,
					["useText"] = true,
				},
				["HOT1"] = {
					["TG"] = 0.6,
					["countdownMode"] = 1,
					["R"] = 1,
					["TB"] = 0.6,
					["G"] = 0.3,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.3,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["useDebuffIconBossOnly"] = true,
				["EMERGENCY"] = {
					["TG"] = 0.82,
					["R"] = 1,
					["TB"] = 0,
					["G"] = 0,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["BAR_FRAMES"] = {
					["useOpacity"] = true,
					["R"] = 0,
					["B"] = 0,
					["G"] = 0,
					["O"] = 0.7,
					["useBackground"] = true,
				},
				["HOT9"] = {
					["TG"] = 1,
					["countdownMode"] = 1,
					["R"] = 0.3,
					["TB"] = 1,
					["G"] = 1,
					["TR"] = 0.6,
					["TO"] = 1,
					["B"] = 1,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["HOT_CHARGE_3"] = {
					["TG"] = 1,
					["R"] = 0.3,
					["TB"] = 0.6,
					["G"] = 1,
					["TR"] = 0.6,
					["TO"] = 1,
					["B"] = 0.3,
					["useBackground"] = true,
					["O"] = 1,
					["useText"] = true,
				},
				["DEBUFF3"] = {
					["TG"] = 0.957,
					["R"] = 0.4,
					["TB"] = 1,
					["G"] = 0.4,
					["TR"] = 0.329,
					["TO"] = 1,
					["B"] = 0.8,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["INCOMING"] = {
					["TG"] = 0.82,
					["R"] = 0,
					["TB"] = 0,
					["G"] = 0,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0,
					["useBackground"] = false,
					["useText"] = false,
					["O"] = 0.33,
					["useOpacity"] = true,
				},
				["HOT6"] = {
					["useBackground"] = true,
					["R"] = 1,
					["B"] = 1,
					["G"] = 1,
					["O"] = 0.75,
				},
				["DEBUFF4"] = {
					["TG"] = 0,
					["R"] = 0.7,
					["TB"] = 1,
					["G"] = 0,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.7,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["DEBUFF6"] = {
					["TG"] = 0.5,
					["R"] = 0.6,
					["TB"] = 0,
					["G"] = 0.3,
					["TR"] = 0.8,
					["TO"] = 1,
					["B"] = 0,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["HOT5"] = {
					["TG"] = 0.6,
					["countdownMode"] = 1,
					["R"] = 1,
					["TB"] = 1,
					["G"] = 0.3,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 1,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["HOTS"] = {
					["useColorText"] = true,
					["useColorBack"] = true,
					["isPumpDivineAegis"] = false,
					["isFadeOut"] = false,
					["isFlashWhenLow"] = false,
					["showShieldAbsorb"] = true,
					["WARNING"] = {
						["enabled"] = false,
						["lowSecs"] = 3,
						["R"] = 0.5,
						["TB"] = 0.6,
						["G"] = 0.2,
						["TR"] = 1,
						["TO"] = 1,
						["B"] = 0.2,
						["useBackground"] = true,
						["useText"] = true,
						["O"] = 1,
						["TG"] = 0.6,
					},
				},
				["HOT2"] = {
					["TG"] = 1,
					["countdownMode"] = 1,
					["R"] = 1,
					["TB"] = 0.6,
					["G"] = 1,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.3,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["DEAD"] = {
					["TG"] = 0.5,
					["R"] = 0.3,
					["TB"] = 0.5,
					["G"] = 0.3,
					["TR"] = 0.5,
					["TO"] = 1,
					["B"] = 0.3,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 0.5,
					["useOpacity"] = true,
				},
				["useDebuffIcon"] = false,
				["OFFLINE"] = {
					["TG"] = 0.576,
					["R"] = 0.298,
					["TB"] = 0.576,
					["G"] = 0.298,
					["TR"] = 0.576,
					["TO"] = 0.58,
					["B"] = 0.298,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 0.21,
					["useOpacity"] = true,
				},
				["OUTRANGED"] = {
					["TG"] = 0,
					["R"] = 0,
					["TB"] = 0,
					["G"] = 0,
					["TR"] = 0,
					["TO"] = 0.5,
					["B"] = 0,
					["useBackground"] = false,
					["useText"] = false,
					["O"] = 0.25,
					["useOpacity"] = true,
				},
				["CHARMED"] = {
					["TG"] = 0.31,
					["R"] = 0.51,
					["TB"] = 0.31,
					["G"] = 0.082,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.263,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["HOT3"] = {
					["TG"] = 1,
					["countdownMode"] = 1,
					["R"] = 1,
					["TB"] = 1,
					["G"] = 1,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 1,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["HOT4"] = {
					["TG"] = 0.6,
					["countdownMode"] = 1,
					["R"] = 0.3,
					["TB"] = 1,
					["G"] = 0.3,
					["TR"] = 0.6,
					["TO"] = 1,
					["B"] = 1,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["DEBUFF2"] = {
					["TG"] = 0,
					["R"] = 0.8,
					["TB"] = 0,
					["G"] = 0.4,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.4,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["DEBUFF0"] = {
					["useBackground"] = false,
					["useText"] = false,
					["useOpacity"] = false,
				},
				["HOT8"] = {
					["useBackground"] = true,
					["R"] = 1,
					["B"] = 1,
					["G"] = 1,
					["O"] = 0.75,
				},
				["HOT10"] = {
					["TG"] = 1,
					["countdownMode"] = 1,
					["R"] = 0.3,
					["TB"] = 0.3,
					["G"] = 1,
					["TR"] = 0.6,
					["TO"] = 1,
					["B"] = 0.3,
					["O"] = 1,
					["useBackground"] = true,
					["isFullDuration"] = false,
					["useText"] = true,
				},
				["HOT_CHARGE_4"] = {
					["TG"] = 1,
					["R"] = 0.8,
					["TB"] = 1,
					["G"] = 0.8,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.8,
					["useBackground"] = true,
					["O"] = 1,
					["useText"] = true,
				},
				["DEBUFF1"] = {
					["TG"] = 1,
					["R"] = 0,
					["TB"] = 0.6860000000000001,
					["G"] = 0.592,
					["TR"] = 0,
					["TO"] = 1,
					["B"] = 0.8,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 1,
					["useOpacity"] = true,
				},
				["HOT_CHARGE_2"] = {
					["TG"] = 1,
					["R"] = 1,
					["TB"] = 0.6,
					["G"] = 1,
					["TR"] = 1,
					["TO"] = 1,
					["B"] = 0.3,
					["useBackground"] = true,
					["O"] = 1,
					["useText"] = true,
				},
			},
		},
		["ORIGINATOR_CLASS"] = "PRIEST",
	}, -- [2]
};



--
local tAutoProfileIndices = { "1", "5", "10", "15", "25", "40" };
local tIndex, tKey;
local function VUHDO_getBestProfileForSpecAndSize(aSpec, aSize)
	for _, tIndex in ipairs(tAutoProfileIndices) do
		tKey = "SPEC_" .. aSpec .. "_" .. tIndex;
		if (VUHDO_CONFIG["AUTO_PROFILES"][tKey] ~= nil and aSize <= tonumber(tIndex)) then
			return VUHDO_CONFIG["AUTO_PROFILES"][tKey];
		end

	end

	return nil;
end



--
local function VUHDO_getBestProfileForSpec(aSpec)
	return VUHDO_CONFIG["AUTO_PROFILES"]["SPEC_" .. aSpec];
end



--
local function VUHDO_getBestProfileForSize(aSize)
	for _, tIndex in ipairs(tAutoProfileIndices) do
		if (VUHDO_CONFIG["AUTO_PROFILES"][tIndex] ~= nil and aSize <= tonumber(tIndex)) then
			return VUHDO_CONFIG["AUTO_PROFILES"][tIndex];
		end
	end

	return nil;
end



--
local tSpec;
function VUHDO_getBestProfileAfterSpecChange()
	tSpec = GetActiveTalentGroup(false);
	return VUHDO_getBestProfileForSpecAndSize(tSpec, VUHDO_GROUP_SIZE)
		or VUHDO_getBestProfileForSpec(tSpec)
		or VUHDO_getBestProfileForSize(VUHDO_GROUP_SIZE);
end



--
function VUHDO_getBestProfileAfterSizeChange()
	tSpec = GetActiveTalentGroup(false);
	return VUHDO_getBestProfileForSpecAndSize(tSpec, VUHDO_GROUP_SIZE)
		or VUHDO_getBestProfileForSize(VUHDO_GROUP_SIZE)
		or VUHDO_getBestProfileForSpec(tSpec);
end



--
VUHDO_DEBUG_AUTO_PROFILE = nil;
VUHDO_IS_SHOWN_BY_GROUP = true;
local tIndex;
local VUHDO_PROFILE_CFG;



--
local tGroupSize, tProfile;
function VUHDO_getAutoProfile()
	if (VUHDO_DEBUG_AUTO_PROFILE ~= nil) then
		tGroupSize = VUHDO_DEBUG_AUTO_PROFILE;
	elseif (GetNumRaidMembers() > 0 or VUHDO_IS_CONFIG) then
		tGroupSize = GetNumRaidMembers();

		if (not VUHDO_IS_SHOWN_BY_GROUP and VUHDO_CONFIG["SHOW_PANELS"]) then
			VUHDO_IS_SHOWN_BY_GROUP = true;
			VUHDO_timeReloadUI(0.1);
		end
	elseif (GetNumPartyMembers() > 0) then
		tGroupSize = GetNumPartyMembers() + 1;

		if (not VUHDO_IS_SHOWN_BY_GROUP) then
			if (not VUHDO_CONFIG["HIDE_PANELS_PARTY"] and VUHDO_CONFIG["SHOW_PANELS"]) then
				VUHDO_IS_SHOWN_BY_GROUP = true;
				VUHDO_timeReloadUI(0.1);
			end
		elseif (VUHDO_CONFIG["HIDE_PANELS_PARTY"]) then
			VUHDO_IS_SHOWN_BY_GROUP = false;
			VUHDO_timeReloadUI(0.1);
		end
	else
		tGroupSize = 1;
		twipe(VUHDO_MAINTANK_NAMES);

		if (not VUHDO_IS_SHOWN_BY_GROUP) then
			if (not VUHDO_CONFIG["HIDE_PANELS_SOLO"] and VUHDO_CONFIG["SHOW_PANELS"]) then
				VUHDO_IS_SHOWN_BY_GROUP = true;
				VUHDO_timeReloadUI(0.1);
			end
		elseif (VUHDO_CONFIG["HIDE_PANELS_SOLO"]) then
			VUHDO_IS_SHOWN_BY_GROUP = false;
			VUHDO_timeReloadUI(0.1);
		end
	end

	if (VUHDO_GROUP_SIZE ~= tGroupSize and tGroupSize > 0) then
		VUHDO_GROUP_SIZE = tGroupSize;
		tProfile = VUHDO_getBestProfileAfterSizeChange();
		if (tProfile ~= VUHDO_CONFIG["CURRENT_PROFILE"]) then
			return tProfile, tGroupSize;
		end
	end
	return nil, nil;

end


---------------------------------------------------------------------------------






VUHDO_PROFILE_MODEL_MATCH_ALL = 0;
VUHDO_PROFILE_MODEL_MATCH_CLASS = 1;
VUHDO_PROFILE_MODEL_MATCH_TOON = 2;
VUHDO_PROFILE_MODEL_MATCH_NEVER = 99;



--
function VUHDO_getProfileNamedCompressed(aName)
	local tIndex, tValue;
	for tIndex, tValue in pairs(VUHDO_PROFILES) do
		if (tValue["NAME"] == aName) then
			return tIndex, tValue;
		end
	end
	return nil, nil;
end



--
function VUHDO_getProfileNamed(aName)
	local tIndex, tValue;
	for tIndex, tValue in pairs(VUHDO_PROFILES) do
		if (tValue["NAME"] == aName) then
			local tNewValue = {
				["NAME"] = tValue["NAME"],
				["LOCKED"] = tValue["LOCKED"],
				["HARDLOCKED"] = tValue["HARDLOCKED"],
				["ORIGINATOR_CLASS"] = tValue["ORIGINATOR_CLASS"],
				["ORIGINATOR_TOON"] = tValue["ORIGINATOR_TOON"],
				["CONFIG"] = VUHDO_decompressIfCompressed(tValue["CONFIG"]),
				["PANEL_SETUP"] = VUHDO_decompressIfCompressed(tValue["PANEL_SETUP"]),
				["POWER_TYPE_COLORS"] = VUHDO_decompressIfCompressed(tValue["POWER_TYPE_COLORS"]),
				["SPELL_CONFIG"] = VUHDO_decompressIfCompressed(tValue["SPELL_CONFIG"]),
				["BUFF_SETTINGS"] = VUHDO_decompressIfCompressed(tValue["BUFF_SETTINGS"]),
				["BUFF_ORDER"] = VUHDO_decompressIfCompressed(tValue["BUFF_ORDER"]),
				["INDICATOR_CONFIG"] = VUHDO_decompressIfCompressed(tValue["INDICATOR_CONFIG"]),
				["PANEL_POSITIONS"] = tValue["PANEL_POSITIONS"]
			};

			return tIndex, tNewValue;
		end
	end
	return nil, nil;
end



--
local function VUHDO_createNewProfile(aName)
	local _, tProfile = VUHDO_getProfileNamedCompressed(VUHDO_CONFIG["CURRENT_PROFILE"]);
	local tCnt;

	local tPanelPositions = { };
	for tCnt = 1, 10 do -- VUHDO_MAX_PANELS
		tPanelPositions[tCnt] = VUHDO_deepCopyTable(VUHDO_PANEL_SETUP[tCnt]["POSITION"]);
	end

	return {
		["NAME"] = aName,
		["LOCKED"] = tProfile ~= nil and tProfile["LOCKED"],
		["HARDLOCKED"] = false,
		["ORIGINATOR_CLASS"] = VUHDO_PLAYER_CLASS,
		["ORIGINATOR_TOON"] = VUHDO_PLAYER_NAME,
		["CONFIG"] = VUHDO_compressTable(VUHDO_CONFIG),
		["PANEL_SETUP"] = VUHDO_compressTable(VUHDO_PANEL_SETUP),
		["POWER_TYPE_COLORS"] = VUHDO_compressTable(VUHDO_POWER_TYPE_COLORS),
		["SPELL_CONFIG"] = VUHDO_compressTable(VUHDO_SPELL_CONFIG),
		["BUFF_SETTINGS"] = VUHDO_compressTable(VUHDO_BUFF_SETTINGS),
		["BUFF_ORDER"] = VUHDO_compressTable(VUHDO_BUFF_ORDER),
		["INDICATOR_CONFIG"] = VUHDO_compressTable(VUHDO_INDICATOR_CONFIG),
		["PANEL_POSITIONS"] = tPanelPositions;
	};

end



--
function VUHDO_createNewProfileName(aName, aUnitName)
	local tIdx = 1;
	local tProfile = { };
	local tPrefix = aUnitName .. ": ";

	while (tProfile ~= nil) do
		tNewName = tPrefix .. aName;
		_, tProfile = VUHDO_getProfileNamedCompressed(tNewName);

		tIdx = tIdx + 1;
		tPrefix = aUnitName .. "(" .. tIdx .. "): ";
	end
	return tNewName;
end



local VUHDO_TARGET_PROFILE_NAME = nil;


--
local function VUHDO_askSaveProfileCallback(aButtonNum)
	local _, tProfile = VUHDO_getProfileNamedCompressed(VUHDO_TARGET_PROFILE_NAME);
	if (tProfile ~= nil and aButtonNum == 2 and tProfile["HARDLOCKED"]) then
		VUHDO_Msg("This profile is hardlocked. It has been copied locally.");
		aButtonNum = 1;
	end

	if (1 == aButtonNum) then -- Copy
		VUHDO_TARGET_PROFILE_NAME = VUHDO_createNewProfileName(VUHDO_TARGET_PROFILE_NAME, VUHDO_PLAYER_NAME);
		VUHDO_CONFIG["CURRENT_PROFILE"] = VUHDO_TARGET_PROFILE_NAME;
	elseif (2 == aButtonNum) then -- Overwrite
	elseif (3 == aButtonNum) then-- Discard
		return;
	end

	local tIndex, _ = VUHDO_getProfileNamedCompressed(VUHDO_TARGET_PROFILE_NAME);
	if (tIndex == nil) then
		tIndex = #VUHDO_PROFILES + 1;
	end

	VUHDO_PROFILES[tIndex] = VUHDO_createNewProfile(VUHDO_TARGET_PROFILE_NAME);
	if (1 == aButtonNum) then
		VUHDO_PROFILES[tIndex]["HARDLOCKED"] = false;
	end

	VUHDO_Msg(VUHDO_I18N_PROFILE_SAVED .. "\"" .. VUHDO_TARGET_PROFILE_NAME .. "\"");
	VUHDO_updateProfileSelectCombo();
end



--
function VUHDO_saveProfile(aName)
	local tExistingIndex, tExistingProfile = VUHDO_getProfileNamedCompressed(aName);
	if (tExistingProfile ~= nil)  then
		VUHDO_TARGET_PROFILE_NAME = aName;

		if (tExistingProfile["ORIGINATOR_TOON"] ~= VUHDO_PLAYER_NAME and not VUHDO_CONFIG["IS_ALWAYS_OVERWRITE_PROFILE"]) then

			VuhDoThreeSelectFrameText:SetText(
				VUHDO_I18N_PROFILE_OVERWRITE_1 .. " \"" .. aName .. "\" "
				.. VUHDO_I18N_PROFILE_OVERWRITE_2 .. " (" .. tExistingProfile["ORIGINATOR_TOON"] .. ")."
				.. VUHDO_I18N_PROFILE_OVERWRITE_3
			);
			VuhDoThreeSelectFrameButton1:SetText(VUHDO_I18N_COPY);
			VuhDoThreeSelectFrameButton2:SetText(VUHDO_I18N_OVERWRITE);
			VuhDoThreeSelectFrameButton3:SetText(VUHDO_I18N_DISCARD);
			VuhDoThreeSelectFrame:SetAttribute("callback", VUHDO_askSaveProfileCallback);
			VuhDoThreeSelectFrame:Show();
		else
			VUHDO_askSaveProfileCallback(2);
		end
	else
		VUHDO_TARGET_PROFILE_NAME = aName;
		VUHDO_askSaveProfileCallback(2);
	end
end



--
function VUHDO_saveCurrentProfile()
	local _, tProfile = VUHDO_getProfileNamedCompressed(VUHDO_CONFIG["CURRENT_PROFILE"]);
	if (tProfile ~= nil and not tProfile["LOCKED"]) then
		VUHDO_saveProfile(VUHDO_CONFIG["CURRENT_PROFILE"]);
	end
end



--
function VUHDO_saveCurrentProfilePanelPosition(aPanelNum)
	local _, tProfile = VUHDO_getProfileNamedCompressed(VUHDO_CONFIG["CURRENT_PROFILE"]);
	if (tProfile ~= nil) then
		if (tProfile["PANEL_POSITIONS"] == nil) then
			tProfile["PANEL_POSITIONS"] = { };
		end

		tProfile["PANEL_POSITIONS"][aPanelNum] = VUHDO_deepCopyTable(VUHDO_PANEL_SETUP[aPanelNum]["POSITION"]);
	end
end



--
local function VUHDO_isProfileRuleAllowed(tRule, aClass, aToon)
	if (VUHDO_PROFILE_MODEL_MATCH_ALL == tRule) then
		return true;
	elseif (VUHDO_PROFILE_MODEL_MATCH_CLASS == tRule) then
		return VUHDO_PLAYER_CLASS == aClass;
	elseif (VUHDO_PROFILE_MODEL_MATCH_TOON == tRule) then
		return VUHDO_PLAYER_NAME == aToon;
	elseif (VUHDO_PROFILE_MODEL_MATCH_NEVER == tRule) then
		return false;
	else
		return true;
	end
end




local VUHDO_PER_PANEL_PROFILE_MODEL = {
	["-root-"] = VUHDO_PROFILE_MODEL_MATCH_ALL,
}




local VUHDO_PROFILE_MODEL = {
	["CONFIG"] = {
		["-root-"] = VUHDO_PROFILE_MODEL_MATCH_ALL,

		["RANGE_SPELL"] = VUHDO_PROFILE_MODEL_MATCH_NEVER,
		["RANGE_PESSIMISTIC"] = VUHDO_PROFILE_MODEL_MATCH_NEVER,
		["CURRENT_PROFILE"] = VUHDO_PROFILE_MODEL_MATCH_NEVER,
		["IS_CLIQUE_COMPAT_MODE"] = VUHDO_PROFILE_MODEL_MATCH_NEVER,
		["AUTO_PROFILES"] = {
			["-root-"] = VUHDO_PROFILE_MODEL_MATCH_NEVER,
		},
		["CLUSTER"] = {
			["-root-"] = VUHDO_PROFILE_MODEL_MATCH_CLASS,
		},
		["AOE_ADVISOR"] = {
			["-root-"] = VUHDO_PROFILE_MODEL_MATCH_CLASS,
		},
	},

	["PANEL_SETUP"] = {
		["-root-"] = VUHDO_PROFILE_MODEL_MATCH_ALL,

		["HOTS"] = {
			["-root-"] = VUHDO_PROFILE_MODEL_MATCH_ALL,

			["SLOTS"] = {
				["-root-"] = VUHDO_PROFILE_MODEL_MATCH_CLASS,
			},

			["SLOTCFG"] = {
				["-root-"] = VUHDO_PROFILE_MODEL_MATCH_CLASS,
			},
		},

		[1] = VUHDO_PER_PANEL_PROFILE_MODEL,
		[2] = VUHDO_PER_PANEL_PROFILE_MODEL,
		[3] = VUHDO_PER_PANEL_PROFILE_MODEL,
		[4] = VUHDO_PER_PANEL_PROFILE_MODEL,
		[5] = VUHDO_PER_PANEL_PROFILE_MODEL,
		[6] = VUHDO_PER_PANEL_PROFILE_MODEL,
		[7] = VUHDO_PER_PANEL_PROFILE_MODEL,
		[8] = VUHDO_PER_PANEL_PROFILE_MODEL,
		[9] = VUHDO_PER_PANEL_PROFILE_MODEL,
		[10] = VUHDO_PER_PANEL_PROFILE_MODEL,
	},

	["POWER_TYPE_COLORS"] = {
		["-root-"] = VUHDO_PROFILE_MODEL_MATCH_ALL,
	},

	["SPELL_CONFIG"] = {
		["-root-"] = VUHDO_PROFILE_MODEL_MATCH_TOON,
	},

	["BUFF_SETTINGS"] = {
		["-root-"] = VUHDO_PROFILE_MODEL_MATCH_CLASS,

		["CONFIG"] = {
			["-root-"] = VUHDO_PROFILE_MODEL_MATCH_ALL,
		},
	},

	["BUFF_ORDER"] = {
		["-root-"] = VUHDO_PROFILE_MODEL_MATCH_CLASS,
	},

	["INDICATOR_CONFIG"] = {
		["-root-"] = VUHDO_PROFILE_MODEL_MATCH_ALL,
	},
};



--
local tOriginatorClass = nil;
local tOriginatorToon = nil;
local function VUHDO_smartLoadFromProfile(aDestArray, aSourceArray, aProfileModel, aDerivedRule)
	if (aSourceArray == nil) then
		return aDestArray;
	end

	if (aSourceArray["ORIGINATOR_CLASS"] ~= nil) then
		tOriginatorClass = aSourceArray["ORIGINATOR_CLASS"];
	end

	if (aSourceArray["ORIGINATOR_TOON"] ~= nil) then
		tOriginatorToon = aSourceArray["ORIGINATOR_TOON"];
	end

	local tRootRule;
	if (aProfileModel ~= nil) then
		tRootRule = aProfileModel["-root-"];
	else
		tRootRule = nil;
	end

	local tSourceValue;
	local tKey, tDestValue;
	for tKey, tDestValue in pairs(aDestArray) do

		tSourceValue = aSourceArray[tKey];
		if (tSourceValue ~= nil) then
			local tSubModel = (aProfileModel or { })[tKey];

			if ("table" == type(tSourceValue)) then

				if ("table" == type(tDestValue)) then
					aDestArray[tKey] = VUHDO_smartLoadFromProfile(aDestArray[tKey], aSourceArray[tKey], tSubModel, tRootRule or aDerivedRule);
				else
					VUHDO_Msg("Data structures incompatible in field: " .. tKey);
				end
			else -- Flacher Wert
				local tRule = tSubModel or tRootRule or aDerivedRule;
				if (VUHDO_isProfileRuleAllowed(tRule, tOriginatorClass, tOriginatorToon)) then
					aDestArray[tKey] = aSourceArray[tKey];
				--else
					--VUHDO_Msg("Prohibit: " .. tKey);
				end
			end
		end
	end

	return aDestArray;
end



--
local function VUHDO_fixDominantProfileSettings(aProfile)
	local tCnt;

	for tCnt = 1, VUHDO_MAX_PANELS do
		if (aProfile["PANEL_SETUP"][tCnt] ~= nil) then
			if (aProfile["PANEL_SETUP"][tCnt]["MODEL"].groups == nil) then
				VUHDO_PANEL_SETUP[tCnt]["MODEL"].groups = nil;
			else
				VUHDO_PANEL_SETUP[tCnt]["MODEL"].groups = VUHDO_deepCopyTable(aProfile["PANEL_SETUP"][tCnt]["MODEL"].groups);
			end
		else
			VUHDO_PANEL_SETUP[tCnt]["MODEL"].groups = nil;
		end
	end
end



--
function VUHDO_loadProfileNoInit(aName)
	local tIndex, tProfile = VUHDO_getProfileNamed(aName);
	local tCnt, tPanelPositions;
	if (tIndex == nil) then
		VUHDO_Msg(VUHDO_I18N_ERROR_NO_PROFILE .. "\"" .. aName .. "\" !", 1, 0.4, 0.4);
		return;
	end

	tOriginatorClass = tProfile["ORIGINATOR_CLASS"];
	tOriginatorToon = tProfile["ORIGINATOR_TOON"];

	VUHDO_CONFIG            = VUHDO_smartLoadFromProfile(VUHDO_CONFIG,            tProfile["CONFIG"],            VUHDO_PROFILE_MODEL["CONFIG"],            VUHDO_PROFILE_MODEL_MATCH_ALL);
	VUHDO_PANEL_SETUP       = VUHDO_smartLoadFromProfile(VUHDO_PANEL_SETUP,       tProfile["PANEL_SETUP"],       VUHDO_PROFILE_MODEL["PANEL_SETUP"],       VUHDO_PROFILE_MODEL_MATCH_ALL);
	VUHDO_POWER_TYPE_COLORS = VUHDO_smartLoadFromProfile(VUHDO_POWER_TYPE_COLORS, tProfile["POWER_TYPE_COLORS"], VUHDO_PROFILE_MODEL["POWER_TYPE_COLORS"], VUHDO_PROFILE_MODEL_MATCH_ALL);
	VUHDO_SPELL_CONFIG      = VUHDO_smartLoadFromProfile(VUHDO_SPELL_CONFIG,      tProfile["SPELL_CONFIG"],      VUHDO_PROFILE_MODEL["SPELL_CONFIG"],      VUHDO_PROFILE_MODEL_MATCH_ALL);
	VUHDO_BUFF_SETTINGS     = VUHDO_smartLoadFromProfile(VUHDO_BUFF_SETTINGS,     tProfile["BUFF_SETTINGS"],     VUHDO_PROFILE_MODEL["BUFF_SETTINGS"],     VUHDO_PROFILE_MODEL_MATCH_ALL);
	VUHDO_BUFF_ORDER        = VUHDO_smartLoadFromProfile(VUHDO_BUFF_ORDER,        tProfile["BUFF_ORDER"],        VUHDO_PROFILE_MODEL["BUFF_ORDER"],        VUHDO_PROFILE_MODEL_MATCH_ALL);
	VUHDO_INDICATOR_CONFIG  = VUHDO_smartLoadFromProfile(VUHDO_INDICATOR_CONFIG,  tProfile["INDICATOR_CONFIG"],  VUHDO_PROFILE_MODEL["INDICATOR_CONFIG"],  VUHDO_PROFILE_MODEL_MATCH_ALL);

	tPanelPositions = tProfile["PANEL_POSITIONS"];
	if (tPanelPositions ~= nil) then
		for tCnt = 1, 10 do -- VUHDO_MAX_PANELS
			if (tPanelPositions[tCnt] ~= nil) then
				VUHDO_PANEL_SETUP[tCnt]["POSITION"] = VUHDO_deepCopyTable(tPanelPositions[tCnt]);
			end
		end
	end

	-- @TODO: Warum werden die nicht direkt geladen (ipairs-Problem?)
	if (tProfile["CONFIG"]["CUSTOM_DEBUFF"] ~= nil and tProfile["CONFIG"]["CUSTOM_DEBUFF"]["STORED"] ~= nil) then
		VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED"] = VUHDO_deepCopyTable(tProfile["CONFIG"]["CUSTOM_DEBUFF"]["STORED"]);
	end

	VUHDO_fixDominantProfileSettings(tProfile);
	VUHDO_CONFIG["CURRENT_PROFILE"] = aName;
	VUHDO_Msg(VUHDO_I18N_PROFILE_LOADED .. aName);
	collectgarbage('collect');
end



--
function VUHDO_loadProfile(aName)
	VUHDO_loadProfileNoInit(aName);
	VUHDO_initAllBurstCaches();
	VUHDO_loadVariables();
	VUHDO_initPanelModels();
	VUHDO_initDynamicPanelModels();
	VUHDO_registerAllBouquets(false);
	VUHDO_initAllEventBouquets();
	VUHDO_initDebuffs();
	VUHDO_reloadUI();
	VUHDO_resetTooltip();
	VUHDO_initBlizzFrames();
	if (VUHDO_initCustomDebuffComboModel ~= nil) then
		VUHDO_initCustomDebuffComboModel();
	end
end



--
function VUHDO_initDefaultProfiles()
	if ((VUHDO_GLOBAL_CONFIG["PROFILES_VERSION"] or 1) < 2) then
		VUHDO_GLOBAL_CONFIG["PROFILES_VERSION"] = 2;
		local tProfile;
		for _, tProfile in ipairs(VUHDO_DEFAULT_PROFILES) do
			tinsert(VUHDO_PROFILES, tProfile);
		end
	end

	VUHDO_DEFAULT_PROFILES = nil;

	if ((VUHDO_GLOBAL_CONFIG["PROFILES_VERSION"] or 1) < 3) then
		VUHDO_GLOBAL_CONFIG["PROFILES_VERSION"] = 3;
		local _, tProfile = VUHDO_getProfileNamed(VUHDO_I18N_DEF_BIT_O_GRID);
		if (tProfile ~= nil) then
			tProfile["PANEL_SETUP"]["HOTS"]["SLOTS"][10] = "BOUQUET_" .. VUHDO_I18N_DEF_AOE_ADVICE;
		end
	end

end
