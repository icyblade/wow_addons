local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
local Astrolabe = DongleStub("Astrolabe-1.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Spy")
local _

Spy = LibStub("AceAddon-3.0"):NewAddon("Spy", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0")
Spy.Version = "3.1.6"
Spy.DatabaseVersion = "1.1"
Spy.Signature = "[Spy]"
Spy.ButtonLimit = 10
Spy.MaximumPlayerLevel = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]
Spy.MapNoteLimit = 20
Spy.MapProximityThreshold = 0.02
Spy.CurrentMapNote = 1
Spy.ZoneID = {}
Spy.KOSGuild = {}
Spy.CurrentList = {}
Spy.NearbyList = {}
Spy.LastHourList = {}
Spy.ActiveList = {}
Spy.InactiveList = {}
Spy.PlayerCommList = {}
Spy.ListAmountDisplayed = 0
Spy.ButtonName = {}
Spy.EnabledInZone = false
Spy.InInstance = false
Spy.AlertType = nil
Spy.UpgradeMessageSent = false

Spy.options = {
	name = L["Spy"],
	type = "group",
	args = {
		General = {
			name = L["GeneralSettings"],
			desc = L["GeneralSettings"],
			type = "group",
			order = 1,
			args = {
				intro1 = {
					name = L["SpyDescription1"],
					type = "description",
					order = 1,
				},
				Enabled = {
					name = L["EnableSpy"],
					desc = L["EnableSpyDescription"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return Spy.db.profile.Enabled
					end,
					set = function(info, value)
						Spy:EnableSpy(value, true)
					end,
				},
				EnabledInBattlegrounds = {
					name = L["EnabledInBattlegrounds"],
					desc = L["EnabledInBattlegroundsDescription"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return Spy.db.profile.EnabledInBattlegrounds
					end,
					set = function(info, value)
						Spy.db.profile.EnabledInBattlegrounds = value
						Spy:ZoneChangedEvent()
					end,
				},
				EnabledInArenas = {
					name = L["EnabledInArenas"],
					desc = L["EnabledInArenasDescription"],
					type = "toggle",
					order = 3,
					width = "full",
					get = function(info)
						return Spy.db.profile.EnabledInArenas
					end,
					set = function(info, value)
						Spy.db.profile.EnabledInArenas = value
						Spy:ZoneChangedEvent()
					end,
				},
				EnabledInWintergrasp = {
					name = L["EnabledInWintergrasp"],
					desc = L["EnabledInWintergraspDescription"],
					type = "toggle",
					order = 4,
					width = "full",
					get = function(info)
						return Spy.db.profile.EnabledInWintergrasp
					end,
					set = function(info, value)
						Spy.db.profile.EnabledInWintergrasp = value
						Spy:ZoneChangedEvent()
					end,
				},
				DisableWhenPVPUnflagged = {
					name = L["DisableWhenPVPUnflagged"],
					desc = L["DisableWhenPVPUnflaggedDescription"],
					type = "toggle",
					order = 5,
					width = "full",
					get = function(info)
						return Spy.db.profile.DisableWhenPVPUnflagged
					end,
					set = function(info, value)
						Spy.db.profile.DisableWhenPVPUnflagged = value
						Spy:ZoneChangedEvent()
					end,
				},
				intro2 = {
					name = L["SpyDescription2"],
					type = "description",
					order = 6,
				},
			},
		},
		DisplayOptions = {
			name = L["DisplayOptions"],
			desc = L["DisplayOptions"],
			type = "group",
			order = 2,
			args = {
				intro = {
					name = L["DisplayOptionsDescription"],
					type = "description",
					order = 1,
				},
				ShowOnDetection = {
					name = L["ShowOnDetection"],
					desc = L["ShowOnDetectionDescription"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return Spy.db.profile.ShowOnDetection
					end,
					set = function(info, value)
						Spy.db.profile.ShowOnDetection = value
					end,
				},
				HideSpy = {
					name = L["HideSpy"],
					desc = L["HideSpyDescription"],
					type = "toggle",
					order = 3,
					width = "full",
					get = function(info)
						return Spy.db.profile.HideSpy
					end,
					set = function(info, value)
						Spy.db.profile.HideSpy = value
						if Spy.db.profile.HideSpy and Spy:GetNearbyListSize() == 0 then
							Spy.MainWindow:Hide()
						end
					end,
				},
				Lock = {
					name = L["LockSpy"],
					desc = L["LockSpyDescription"],
					type = "toggle",
					order = 4,
					width = "full",
					get = function(info) 
						return Spy.db.profile.Locked
					end,
					set = function(info, value)
						Spy.db.profile.Locked = value
						Spy:LockWindows(value)
					end,
				},
				ResizeSpy = {
					name = L["ResizeSpy"],
					desc = L["ResizeSpyDescription"],
					type = "toggle",
					order = 5,
					width = "full",
					get = function(info)
						return Spy.db.profile.ResizeSpy
					end,
					set = function(info, value)
						Spy.db.profile.ResizeSpy = value
						if value then Spy:RefreshCurrentList() end
					end,
				},
				DisplayWinLossStatistics = {
					name = L["TooltipDisplayWinLoss"],
					desc = L["TooltipDisplayWinLossDescription"],
					type = "toggle",
					order = 6,
					width = "full",
					get = function(info)
						return Spy.db.profile.DisplayWinLossStatistics
					end,
					set = function(info, value)
						Spy.db.profile.DisplayWinLossStatistics = value
					end,
				},
				DisplayKOSReason = {
					name = L["TooltipDisplayKOSReason"],
					desc = L["TooltipDisplayKOSReasonDescription"],
					type = "toggle",
					order = 7,
					width = "full",
					get = function(info)
						return Spy.db.profile.DisplayKOSReason
					end,
					set = function(info, value)
						Spy.db.profile.DisplayKOSReason = value
					end,
				},
				DisplayLastSeen = {
					name = L["TooltipDisplayLastSeen"],
					desc = L["TooltipDisplayLastSeenDescription"],
					type = "toggle",
					order = 8,
					width = "full",
					get = function(info)
						return Spy.db.profile.DisplayLastSeen
					end,
					set = function(info, value)
						Spy.db.profile.DisplayLastSeen = value
					end,
				},
--[[				InvertSpy = {
					name = L["InvertSpy"],
					desc = L["InvertSpyDescription"],
					type = "toggle",
					order = 9,
					width = "full",
					get = function(info)
						return Spy.db.profile.InvertSpy
					end,
					set = function(info, value)
						Spy.db.profile.InvertSpy = value
--						if value then Spy:InvertSpy() end
					end,
				},]]
			},
		},
		AlertOptions = {
			name = L["AlertOptions"],
			desc = L["AlertOptions"],
			type = "group",
			order = 3,
			args = {
				intro = {
					name = L["AlertOptionsDescription"],
					type = "description",
					order = 1,
				},
				Announce = {
					name = L["Announce"],
					type = "group",
					order = 2,
					inline = true,
					args = {
						None = {
							name = L["None"],
							desc = L["NoneDescription"],
							type = "toggle",
							order = 1,
							get = function(info)
								return Spy.db.profile.Announce == "None"
							end,
							set = function(info, value)
								Spy.db.profile.Announce = "None"
							end,
						},
						Self = {
							name = L["Self"],
							desc = L["SelfDescription"],
							type = "toggle",
							order = 2,
							get = function(info)
								return Spy.db.profile.Announce == "Self"
							end,
							set = function(info, value)
								Spy.db.profile.Announce = "Self"
							end,
						},
						Party = {
							name = L["Party"],
							desc = L["PartyDescription"],
							type = "toggle",
							order = 3,
							get = function(info)
								return Spy.db.profile.Announce == "Party"
							end,
							set = function(info, value)
								Spy.db.profile.Announce = "Party"
							end,
						},
						Guild = {
							name = L["Guild"],
							desc = L["GuildDescription"],
							type = "toggle",
							order = 4,
							get = function(info)
								return Spy.db.profile.Announce == "Guild"
							end,
							set = function(info, value)
								Spy.db.profile.Announce = "Guild"
							end,
						},
						Raid = {
							name = L["Raid"],
							desc = L["RaidDescription"],
							type = "toggle",
							order = 5,
							get = function(info)
								return Spy.db.profile.Announce == "Raid"
							end,
							set = function(info, value)
								Spy.db.profile.Announce = "Raid"
							end,
						},
						LocalDefense = {
							name = L["LocalDefense"],
							desc = L["LocalDefenseDescription"],
							type = "toggle",
							order = 6,
							get = function(info)
								return Spy.db.profile.Announce == "LocalDefense"
							end,
							set = function(info, value)
								Spy.db.profile.Announce = "LocalDefense"
							end,
						},
					},
				},
				OnlyAnnounceKoS = {
					name = L["OnlyAnnounceKoS"],
					desc = L["OnlyAnnounceKoSDescription"],
					type = "toggle",
					order = 3,
					width = "full",
					get = function(info)
						return Spy.db.profile.OnlyAnnounceKoS
					end,
					set = function(info, value)
						Spy.db.profile.OnlyAnnounceKoS = value
					end,
				},
				WarnOnStealth = {
					name = L["WarnOnStealth"],
					desc = L["WarnOnStealthDescription"],
					type = "toggle",
					order = 4,
					width = "full",
					get = function(info)
						return Spy.db.profile.WarnOnStealth
					end,
					set = function(info, value)
						Spy.db.profile.WarnOnStealth = value
					end,
				},
				WarnOnKOS = {
					name = L["WarnOnKOS"],
					desc = L["WarnOnKOSDescription"],
					type = "toggle",
					order = 5,
					width = "full",
					get = function(info)
						return Spy.db.profile.WarnOnKOS
					end,
					set = function(info, value)
						Spy.db.profile.WarnOnKOS = value
					end,
				},
				WarnOnKOSGuild = {
					name = L["WarnOnKOSGuild"],
					desc = L["WarnOnKOSGuildDescription"],
					type = "toggle",
					order = 6,
					width = "full",
					get = function(info)
						return Spy.db.profile.WarnOnKOSGuild
					end,
					set = function(info, value)
						Spy.db.profile.WarnOnKOSGuild = value
					end,
				},
				DisplayWarningsInErrorsFrame = {
					name = L["DisplayWarningsInErrorsFrame"],
					desc = L["DisplayWarningsInErrorsFrameDescription"],
					type = "toggle",
					order = 7,
					width = "full",
					get = function(info)
						return Spy.db.profile.DisplayWarningsInErrorsFrame
					end,
					set = function(info, value)
						Spy.db.profile.DisplayWarningsInErrorsFrame = value
					end,
				},
				EnableSound = {
					name = L["EnableSound"],
					desc = L["EnableSoundDescription"],
					type = "toggle",
					order = 8,
					width = "full",
					get = function(info)
						return Spy.db.profile.EnableSound
					end,
					set = function(info, value)
						Spy.db.profile.EnableSound = value
					end,
				},
			},
		},
		ListOptions = {
			name = L["ListOptions"],
			desc = L["ListOptions"],
			type = "group",
			order = 4,
			args = {
				intro = {
					name = L["ListOptionsDescription"],
					type = "description",
					order = 1,
				},
				RemoveUndetected = {
					name = L["RemoveUndetected"],
					type = "group",
					order = 2,
					inline = true,
					args = {
						OneMinute = {
							name = L["1Min"],
							desc = L["1MinDescription"],
							type = "toggle",
							order = 1,
							get = function(info)
								return Spy.db.profile.RemoveUndetected == "OneMinute"
							end,
							set = function(info, value)
								Spy.db.profile.RemoveUndetected = "OneMinute"
								Spy:UpdateTimeoutSettings()
							end,
						},
						TwoMinutes = {
							name = L["2Min"],
							desc = L["2MinDescription"],
							type = "toggle",
							order = 2,
							get = function(info)
								return Spy.db.profile.RemoveUndetected == "TwoMinutes"
							end,
							set = function(info, value)
								Spy.db.profile.RemoveUndetected = "TwoMinutes"
								Spy:UpdateTimeoutSettings()
							end,
						},
						FiveMinutes = {
							name = L["5Min"],
							desc = L["5MinDescription"],
							type = "toggle",
							order = 3,
							get = function(info)
								return Spy.db.profile.RemoveUndetected == "FiveMinutes"
							end,
							set = function(info, value)
								Spy.db.profile.RemoveUndetected = "FiveMinutes"
								Spy:UpdateTimeoutSettings()
							end,
						},
						TenMinutes = {
							name = L["10Min"],
							desc = L["10MinDescription"],
							type = "toggle",
							order = 4,
							get = function(info)
								return Spy.db.profile.RemoveUndetected == "TenMinutes"
							end,
							set = function(info, value)
								Spy.db.profile.RemoveUndetected = "TenMinutes"
								Spy:UpdateTimeoutSettings()
							end,
						},
						FifteenMinutes = {
							name = L["15Min"],
							desc = L["15MinDescription"],
							type = "toggle",
							order = 5,
							get = function(info)
								return Spy.db.profile.RemoveUndetected == "FifteenMinutes"
							end,
							set = function(info, value)
								Spy.db.profile.RemoveUndetected = "FifteenMinutes"
								Spy:UpdateTimeoutSettings()
							end,
						},
						Never = {
							name = L["Never"],
							desc = L["NeverDescription"],
							type = "toggle",
							order = 6,
							get = function(info)
								return Spy.db.profile.RemoveUndetected == "Never"
							end,
							set = function(info, value)
								Spy.db.profile.RemoveUndetected = "Never"
								Spy:UpdateTimeoutSettings()
							end,
						},
					},
				},
				ShowNearbyList = {
					name = L["ShowNearbyList"],
					desc = L["ShowNearbyListDescription"],
					type = "toggle",
					order = 4,
					width = "full",
					get = function(info)
						return Spy.db.profile.ShowNearbyList
					end,
					set = function(info, value)
						Spy.db.profile.ShowNearbyList = value
					end,
				},
				PrioritiseKoS = {
					name = L["PrioritiseKoS"],
					desc = L["PrioritiseKoSDescription"],
					type = "toggle",
					order = 5,
					width = "full",
					get = function(info)
						return Spy.db.profile.PrioritiseKoS
					end,
					set = function(info, value)
						Spy.db.profile.PrioritiseKoS = value
					end,
				},
			},
		},
		MinimapOptions = {
			name = L["MinimapOptions"],
			desc = L["MinimapOptions"],
			type = "group",
			order = 5,
			args = {
				intro = {
					name = L["MinimapOptionsDescription"],
					type = "description",
					order = 1,
				},
				MinimapTracking = {
					name = L["MinimapTracking"],
					desc = L["MinimapTrackingDescription"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return Spy.db.profile.MinimapTracking
					end,
					set = function(info, value)
						Spy.db.profile.MinimapTracking = value
					end,
				},
				MinimapDetails = {
					name = L["MinimapDetails"],
					desc = L["MinimapDetailsDescription"],
					type = "toggle",
					order = 3,
					width = "full",
					get = function(info)
						return Spy.db.profile.MinimapDetails
					end,
					set = function(info, value)
						Spy.db.profile.MinimapDetails = value
					end,
				},
				DisplayOnMap = {
					name = L["DisplayOnMap"],
					desc = L["DisplayOnMapDescription"],
					type = "toggle",
					order = 4,
					width = "full",
					get = function(info)
						return Spy.db.profile.DisplayOnMap
					end,
					set = function(info, value)
						Spy.db.profile.DisplayOnMap = value
					end,
				},
				MapDisplayLimit = {
					name = L["MapDisplayLimit"],
					type = "group",
					order = 5,
					inline = true,
					args = {
						None = {
							name = L["LimitNone"],
							desc = L["LimitNoneDescription"],
							type = "toggle",
							order = 1,
							width = "full",
							get = function(info)
								return Spy.db.profile.MapDisplayLimit == "None"
							end,
							set = function(info, value)
								Spy.db.profile.MapDisplayLimit = "None"
							end,
						},
						SameZone = {
							name = L["LimitSameZone"],
							desc = L["LimitSameZoneDescription"],
							type = "toggle",
							order = 2,
							width = "full",
							get = function(info)
								return Spy.db.profile.MapDisplayLimit == "SameZone"
							end,
							set = function(info, value)
								Spy.db.profile.MapDisplayLimit = "SameZone"
							end,
						},
						SameContinent = {
							name = L["LimitSameContinent"],
							desc = L["LimitSameContinentDescription"],
							type = "toggle",
							order = 3,
							width = "full",
							get = function(info)
								return Spy.db.profile.MapDisplayLimit == "SameContinent"
							end,
							set = function(info, value)
								Spy.db.profile.MapDisplayLimit = "SameContinent"
							end,
						},
					},
				},
			},
		},
		DataOptions = {
			name = L["DataOptions"],
			desc = L["DataOptions"],
			type = "group",
			order = 6,
			args = {
				intro = {
					name = L["DataOptionsDescription"],
					type = "description",
					order = 1,
				},
				PurgeData = {
					name = L["PurgeData"],
					type = "group",
					order = 2,
					inline = true,
					args = {
						OneDay = {
							name = L["OneDay"],
							desc = L["OneDayDescription"],
							type = "toggle",
							order = 1,
							get = function(info)
								return Spy.db.profile.PurgeData == "OneDay"
							end,
							set = function(info, value)
								Spy.db.profile.PurgeData = "OneDay"
							end,
						},
						FiveDays = {
							name = L["FiveDays"],
							desc = L["FiveDaysDescription"],
							type = "toggle",
							order = 2,
							get = function(info)
								return Spy.db.profile.PurgeData == "FiveDays"
							end,
							set = function(info, value)
								Spy.db.profile.PurgeData = "FiveDays"
							end,
						},
						TenDays = {
							name = L["TenDays"],
							desc = L["TenDaysDescription"],
							type = "toggle",
							order = 3,
							get = function(info)
								return Spy.db.profile.PurgeData == "TenDays"
							end,
							set = function(info, value)
								Spy.db.profile.PurgeData = "TenDays"
							end,
						},
						ThirtyDays = {
							name = L["ThirtyDays"],
							desc = L["ThirtyDaysDescription"],
							type = "toggle",
							order = 4,
							get = function(info)
								return Spy.db.profile.PurgeData == "ThirtyDays"
							end,
							set = function(info, value)
								Spy.db.profile.PurgeData = "ThirtyDays"
							end,
						},
						SixtyDays = {
							name = L["SixtyDays"],
							desc = L["SixtyDaysDescription"],
							type = "toggle",
							order = 5,
							get = function(info)
								return Spy.db.profile.PurgeData == "SixtyDays"
							end,
							set = function(info, value)
								Spy.db.profile.PurgeData = "SixtyDays"
							end,
						},
						NinetyDays = {
							name = L["NinetyDays"],
							desc = L["NinetyDaysDescription"],
							type = "toggle",
							order = 6,
							get = function(info)
								return Spy.db.profile.PurgeData == "NinetyDays"
							end,
							set = function(info, value)
								Spy.db.profile.PurgeData = "NinetyDays"
							end,
						},
					},
				},
				ShareData = {
					name = L["ShareData"],
					desc = L["ShareDataDescription"],
					type = "toggle",
					order = 3,
					width = "full",
					get = function(info)
						return Spy.db.profile.ShareData
					end,
					set = function(info, value)
						Spy.db.profile.ShareData = value
					end,
				},
				UseData = {
					name = L["UseData"],
					desc = L["UseDataDescription"],
					type = "toggle",
					order = 4,
					width = "full",
					get = function(info)
						return Spy.db.profile.UseData
					end,
					set = function(info, value)
						Spy.db.profile.UseData = value
					end,
				},
				ShareKOSBetweenCharacters = {
					name = L["ShareKOSBetweenCharacters"],
					desc = L["ShareKOSBetweenCharactersDescription"],
					type = "toggle",
					order = 5,
					width = "full",
					get = function(info)
						return Spy.db.profile.ShareKOSBetweenCharacters
					end,
					set = function(info, value)
						Spy.db.profile.ShareKOSBetweenCharacters = value
						if value then Spy:RegenerateKOSCentralList() end
					end,
				},
			},
		},
	},
}

Spy.optionsSlash = {
	name = L["SlashCommand"],
	order = -3,
	type = "group",
	args = {
		intro = {
			name = L["SpySlashDescription"],
			type = "description",
			order = 1,
			cmdHidden = true,
		},
		enable = {
			name = L["Enable"],
			desc = L["EnableDescription"],
			type = 'execute',
			order = 2,
			func = function()
				Spy:EnableSpy(true, true)
			end,
			dialogHidden = true
		},
		reset = {
			name = L["Reset"],
			desc = L["ResetDescription"],
			type = 'execute',
			order = 3,
			func = function()
				Spy:ResetMainWindow()
			end,
			dialogHidden = true
		},
		config = {
			name = L["Config"],
			desc = L["ConfigDescription"],
			type = 'execute',
			order = 4,
			func = function()
				Spy:ShowConfig()
			end,
			dialogHidden = true
		},
		kos = {
			name = L["KOS"],
			desc = L["KOSDescription"],
			type = 'input',
			order = 5,
			pattern = "%a",
			set = function(info, value)
				Spy:ToggleKOSPlayer(not SpyPerCharDB.KOSData[value], value)
			end,
			dialogHidden = true
		},
		ignore = {
			name = L["Ignore"],
			desc = L["IgnoreDescription"],
			type = 'input',
			order = 6,
			pattern = "%a",
			set = function(info, value)
				Spy:ToggleIgnorePlayer(not SpyPerCharDB.IgnoreData[value], value)
			end,
			dialogHidden = true
		},
	},
}

local Default_Profile = {
	profile = {
		Colors = {
			["Window"] = {
				["Title"] = { r = 1, g = 1, b = 1, a = 1 },
				["Background"]= { r = 24/255, g = 24/255, b = 24/255, a = 1 },
				["Title Text"] = { r = 1, g = 1, b = 1, a = 1 },
			},
			["Other Windows"] = {
				["Title"] = { r = 1, g = 0, b = 0, a = 1 },
				["Background"]= { r = 24/255, g = 24/255, b = 24/255, a = 1 },
				["Title Text"] = { r = 1, g = 1, b = 1, a = 1 },
			},
			["Bar"] = {
				["Bar Text"] = { r = 1, g = 1, b = 1 },
			},
			["Warning"] = {
				["Warning Text"] = { r = 1, g = 1, b = 1 },
			},
			["Tooltip"] = {
				["Title Text"] = { r = 0.8, g = 0.3, b = 0.22 },
				["Details Text"] = { r = 1, g = 1, b = 1 },
				["Location Text"] = { r = 1, g = 0.82, b = 0 },
				["Reason Text"] = { r = 1, g = 0, b = 0 },
			},
			["Alert"] = {
				["Background"]= { r = 0, g = 0, b = 0, a = 0.4 },
				["Icon"] = { r = 1, g = 1, b = 1, a = 0.5 },
				["KOS Border"] = { r = 1, g = 0, b = 0, a = 0.4 },
				["KOS Text"] = { r = 1, g = 0, b = 0 },
				["KOS Guild Border"] = { r = 1, g = 0.82, b = 0, a = 0.4 },
				["KOS Guild Text"] = { r = 1, g = 0.82, b = 0 },
				["Stealth Border"] = { r = 0.6, g = 0.2, b = 1, a = 0.4 },
				["Stealth Text"] = { r = 0.6, g = 0.2, b = 1 },
				["Away Border"] = { r = 0, g = 1, b = 0, a = 0.4 },
				["Away Text"] = { r = 0, g = 1, b = 0 },
				["Location Text"] = { r = 1, g = 0.82, b = 0 },
				["Name Text"] = { r = 1, g = 1, b = 1 },
			},
			["Class"] = {
				["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45, a = 0.6 },
				["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79, a = 0.6 },
				["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0, a = 0.6 },
				["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, a = 0.6 },
				["MAGE"] = { r = 0.41, g = 0.8, b = 0.94, a = 0.6 },
				["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41, a = 0.6 },
				["DRUID"] = { r = 1.0, g = 0.49, b = 0.04, a = 0.6 },
				["SHAMAN"] = { r = 0.14, g = 0.35, b = 1.0, a = 0.6 },
				["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, a = 0.6 },
				["DEATHKNIGHT"] = { r = 0.77, g = 0.12, b = 0.23, a = 0.6 },
                ["MONK"] = { r = 0.00, g = 1.00, b = 0.59, a = 0.6 },
				["PET"] = { r = 0.09, g = 0.61, b = 0.55, a = 0.6 },
				["MOB"] = { r = 0.58, g = 0.24, b = 0.63, a = 0.6 },
				["UNKNOWN"] = { r = 0.1, g = 0.1, b = 0.1, a = 0.6 },
				["HOSTILE"] = { r = 0.7, g = 0.1, b = 0.1, a = 0.6 },
				["UNGROUPED"] = { r = 0.63, g = 0.58, b = 0.24, a = 0.6 },
				
			},
		},
		MainWindow={
			Buttons={
				ClearButton=true,
				LeftButton=true,
				RightButton=true,
			},
			RowHeight=20,
			RowSpacing=2,
			TextHeight=12,
			AutoHide=false,
			BarText={
				RankNum = true,
				PerSec = true,
				Percent = true,
				NumFormat = 1,
			},
			Position={
				x = 4,
				y = 740,
				w = 130,
				h = 44,
			}
		},
		AlertWindowNameSize=14,
		AlertWindowLocationSize=10,
		BarTexture="blend",
		MainWindowVis=true,
		CurrentList=1,
		Locked=false,
		Font="Friz Quadrata TT",
		Scaling=1,
		Enabled=true,
		EnabledInBattlegrounds=true,
		EnabledInArenas=true,
		EnabledInWintergrasp=true,
		DisableWhenPVPUnflagged=false,
		MinimapTracking=true,
		MinimapDetails=true,
		DisplayOnMap=true,
		MapDisplayLimit="None",
		DisplayWinLossStatistics=true,
		DisplayKOSReason=true,
		DisplayLastSeen=true,
		ShowOnDetection=true,
		HideSpy=false,
		InvertSpy=false,
--		SpyLocked=false,
		ResizeSpy=true,
		Announce="Self",
		OnlyAnnounceKoS=false,
		WarnOnStealth=true,
		WarnOnKOS=true,
		WarnOnKOSGuild=true,
		DisplayWarningsInErrorsFrame=false,
		EnableSound=true,
		RemoveUndetected="OneMinute",
		ShowNearbyList=true,
		PrioritiseKoS=true,
		PurgeData="NinetyDays",
		ShareData=true,
		UseData=true,
		ShareKOSBetweenCharacters=true,
	}
}

SM:Register("statusbar", "blend", [[Interface\Addons\Spy\Textures\bar-blend.tga]])

function Spy:CheckDatabase()
	if not SpyPerCharDB or not SpyPerCharDB.PlayerData then
		SpyPerCharDB = {}
	end
	SpyPerCharDB.version = Spy.DatabaseVersion
	if not SpyPerCharDB.PlayerData then
		SpyPerCharDB.PlayerData = {}
	end
	if not SpyPerCharDB.IgnoreData then
		SpyPerCharDB.IgnoreData = {}
	end
	if not SpyPerCharDB.KOSData then
		SpyPerCharDB.KOSData = {}
	end
	if SpyDB.kosData == nil then SpyDB.kosData = {} end
	if SpyDB.kosData[Spy.RealmName] == nil then SpyDB.kosData[Spy.RealmName] = {} end
	if SpyDB.kosData[Spy.RealmName][Spy.FactionName] == nil then SpyDB.kosData[Spy.RealmName][Spy.FactionName] = {} end
	if SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName] == nil then SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName] = {} end
	if SpyDB.removeKOSData == nil then SpyDB.removeKOSData = {} end
	if SpyDB.removeKOSData[Spy.RealmName] == nil then SpyDB.removeKOSData[Spy.RealmName] = {} end
	if SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName] == nil then SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName] = {} end
	if Spy.db.profile == nil then Spy.db.profile = Default_Profile.profile end
	if Spy.db.profile.Colors == nil then Spy.db.profile.Colors = Default_Profile.profile.Colors end
	if Spy.db.profile.Colors["Window"] == nil then Spy.db.profile.Colors["Window"] = Default_Profile.profile.Colors["Window"] end
	if Spy.db.profile.Colors["Window"]["Title"] == nil then Spy.db.profile.Colors["Window"]["Title"] = Default_Profile.profile.Colors["Window"]["Title"] end
	if Spy.db.profile.Colors["Window"]["Background"] == nil then Spy.db.profile.Colors["Window"]["Background"] = Default_Profile.profile.Colors["Window"]["Background"] end
	if Spy.db.profile.Colors["Window"]["Title Text"] == nil then Spy.db.profile.Colors["Window"]["Title Text"] = Default_Profile.profile.Colors["Window"]["Title Text"] end
	if Spy.db.profile.Colors["Other Windows"] == nil then Spy.db.profile.Colors["Other Windows"] = Default_Profile.profile.Colors["Other Windows"] end
	if Spy.db.profile.Colors["Other Windows"]["Title"] == nil then Spy.db.profile.Colors["Other Windows"]["Title"] = Default_Profile.profile.Colors["Other Windows"]["Title"] end
	if Spy.db.profile.Colors["Other Windows"]["Background"] == nil then Spy.db.profile.Colors["Other Windows"]["Background"] = Default_Profile.profile.Colors["Other Windows"]["Background"] end
	if Spy.db.profile.Colors["Other Windows"]["Title Text"] == nil then Spy.db.profile.Colors["Other Windows"]["Title Text"] = Default_Profile.profile.Colors["Other Windows"]["Title Text"] end
	if Spy.db.profile.Colors["Bar"] == nil then Spy.db.profile.Colors["Bar"] = Default_Profile.profile.Colors["Bar"] end
	if Spy.db.profile.Colors["Bar"]["Bar Text"] == nil then Spy.db.profile.Colors["Bar"]["Bar Text"] = Default_Profile.profile.Colors["Bar"]["Bar Text"] end
	if Spy.db.profile.Colors["Warning"] == nil then Spy.db.profile.Colors["Warning"] = Default_Profile.profile.Colors["Warning"] end
	if Spy.db.profile.Colors["Warning"]["Warning Text"] == nil then Spy.db.profile.Colors["Warning"]["Warning Text"] = Default_Profile.profile.Colors["Warning"]["Warning Text"] end
	if Spy.db.profile.Colors["Tooltip"] == nil then Spy.db.profile.Colors["Tooltip"] = Default_Profile.profile.Colors["Tooltip"] end
	if Spy.db.profile.Colors["Tooltip"]["Title Text"] == nil then Spy.db.profile.Colors["Tooltip"]["Title Text"] = Default_Profile.profile.Colors["Tooltip"]["Title Text"] end
	if Spy.db.profile.Colors["Tooltip"]["Details Text"] == nil then Spy.db.profile.Colors["Tooltip"]["Details Text"] = Default_Profile.profile.Colors["Tooltip"]["Details Text"] end
	if Spy.db.profile.Colors["Tooltip"]["Location Text"] == nil then Spy.db.profile.Colors["Tooltip"]["Location Text"] = Default_Profile.profile.Colors["Tooltip"]["Location Text"] end
	if Spy.db.profile.Colors["Tooltip"]["Reason Text"] == nil then Spy.db.profile.Colors["Tooltip"]["Reason Text"] = Default_Profile.profile.Colors["Tooltip"]["Reason Text"] end
	if Spy.db.profile.Colors["Alert"] == nil then Spy.db.profile.Colors["Alert"] = Default_Profile.profile.Colors["Alert"] end
	if Spy.db.profile.Colors["Alert"]["Background"] == nil then Spy.db.profile.Colors["Alert"]["Background"] = Default_Profile.profile.Colors["Alert"]["Background"] end
	if Spy.db.profile.Colors["Alert"]["Icon"] == nil then Spy.db.profile.Colors["Alert"]["Icon"] = Default_Profile.profile.Colors["Alert"]["Icon"] end
	if Spy.db.profile.Colors["Alert"]["KOS Border"] == nil then Spy.db.profile.Colors["Alert"]["KOS Border"] = Default_Profile.profile.Colors["Alert"]["KOS Border"] end
	if Spy.db.profile.Colors["Alert"]["KOS Text"] == nil then Spy.db.profile.Colors["Alert"]["KOS Text"] = Default_Profile.profile.Colors["Alert"]["KOS Text"] end
	if Spy.db.profile.Colors["Alert"]["KOS Guild Border"] == nil then Spy.db.profile.Colors["Alert"]["KOS Guild Border"] = Default_Profile.profile.Colors["Alert"]["KOS Guild Border"] end
	if Spy.db.profile.Colors["Alert"]["KOS Guild Text"] == nil then Spy.db.profile.Colors["Alert"]["KOS Guild Text"] = Default_Profile.profile.Colors["Alert"]["KOS Guild Text"] end
	if Spy.db.profile.Colors["Alert"]["Stealth Border"] == nil then Spy.db.profile.Colors["Alert"]["Stealth Border"] = Default_Profile.profile.Colors["Alert"]["Stealth Border"] end
	if Spy.db.profile.Colors["Alert"]["Stealth Text"] == nil then Spy.db.profile.Colors["Alert"]["Stealth Text"] = Default_Profile.profile.Colors["Alert"]["Stealth Text"] end
	if Spy.db.profile.Colors["Alert"]["Away Border"] == nil then Spy.db.profile.Colors["Alert"]["Away Border"] = Default_Profile.profile.Colors["Alert"]["Away Border"] end
	if Spy.db.profile.Colors["Alert"]["Away Text"] == nil then Spy.db.profile.Colors["Alert"]["Away Text"] = Default_Profile.profile.Colors["Alert"]["Away Text"] end
	if Spy.db.profile.Colors["Alert"]["Location Text"] == nil then Spy.db.profile.Colors["Alert"]["Location Text"] = Default_Profile.profile.Colors["Alert"]["Location Text"] end
	if Spy.db.profile.Colors["Alert"]["Name Text"] == nil then Spy.db.profile.Colors["Alert"]["Name Text"] = Default_Profile.profile.Colors["Alert"]["Name Text"] end
	if Spy.db.profile.Colors["Class"] == nil then Spy.db.profile.Colors["Class"] = Default_Profile.profile.Colors["Class"] end
	if Spy.db.profile.Colors["Class"]["HUNTER"] == nil then Spy.db.profile.Colors["Class"]["HUNTER"] = Default_Profile.profile.Colors["Class"]["HUNTER"] end
	if Spy.db.profile.Colors["Class"]["WARLOCK"] == nil then Spy.db.profile.Colors["Class"]["WARLOCK"] = Default_Profile.profile.Colors["Class"]["WARLOCK"] end
	if Spy.db.profile.Colors["Class"]["PRIEST"] == nil then Spy.db.profile.Colors["Class"]["PRIEST"] = Default_Profile.profile.Colors["Class"]["PRIEST"] end
	if Spy.db.profile.Colors["Class"]["PALADIN"] == nil then Spy.db.profile.Colors["Class"]["PALADIN"] = Default_Profile.profile.Colors["Class"]["PALADIN"] end
	if Spy.db.profile.Colors["Class"]["MAGE"] == nil then Spy.db.profile.Colors["Class"]["MAGE"] = Default_Profile.profile.Colors["Class"]["MAGE"] end
	if Spy.db.profile.Colors["Class"]["ROGUE"] == nil then Spy.db.profile.Colors["Class"]["ROGUE"] = Default_Profile.profile.Colors["Class"]["ROGUE"] end
	if Spy.db.profile.Colors["Class"]["DRUID"] == nil then Spy.db.profile.Colors["Class"]["DRUID"] = Default_Profile.profile.Colors["Class"]["DRUID"] end
	if Spy.db.profile.Colors["Class"]["SHAMAN"] == nil then Spy.db.profile.Colors["Class"]["SHAMAN"] = Default_Profile.profile.Colors["Class"]["SHAMAN"] end
	if Spy.db.profile.Colors["Class"]["WARRIOR"] == nil then Spy.db.profile.Colors["Class"]["WARRIOR"] = Default_Profile.profile.Colors["Class"]["WARRIOR"] end
	if Spy.db.profile.Colors["Class"]["DEATHKNIGHT"] == nil then Spy.db.profile.Colors["Class"]["DEATHKNIGHT"] = Default_Profile.profile.Colors["Class"]["DEATHKNIGHT"] end
	if Spy.db.profile.Colors["Class"]["MONK"] == nil then Spy.db.profile.Colors["Class"]["MONK"] = Default_Profile.profile.Colors["Class"]["MONK"] end
	if Spy.db.profile.Colors["Class"]["PET"] == nil then Spy.db.profile.Colors["Class"]["PET"] = Default_Profile.profile.Colors["Class"]["PET"] end
	if Spy.db.profile.Colors["Class"]["MOB"] == nil then Spy.db.profile.Colors["Class"]["MOB"] = Default_Profile.profile.Colors["Class"]["MOB"] end
	if Spy.db.profile.Colors["Class"]["UNKNOWN"] == nil then Spy.db.profile.Colors["Class"]["UNKNOWN"] = Default_Profile.profile.Colors["Class"]["UNKNOWN"] end
	if Spy.db.profile.Colors["Class"]["HOSTILE"] == nil then Spy.db.profile.Colors["Class"]["HOSTILE"] = Default_Profile.profile.Colors["Class"]["HOSTILE"] end
	if Spy.db.profile.Colors["Class"]["UNGROUPED"] == nil then Spy.db.profile.Colors["Class"]["UNGROUPED"] = Default_Profile.profile.Colors["Class"]["UNGROUPED"] end
	if Spy.db.profile.MainWindow == nil then Spy.db.profile.MainWindow = Default_Profile.profile.MainWindow end
	if Spy.db.profile.MainWindow.Buttons == nil then Spy.db.profile.MainWindow.Buttons = Default_Profile.profile.MainWindow.Buttons end
	if Spy.db.profile.MainWindow.Buttons.ClearButton == nil then Spy.db.profile.MainWindow.Buttons.ClearButton = Default_Profile.profile.MainWindow.Buttons.ClearButton end
	if Spy.db.profile.MainWindow.Buttons.LeftButton == nil then Spy.db.profile.MainWindow.Buttons.LeftButton = Default_Profile.profile.MainWindow.Buttons.LeftButton end
	if Spy.db.profile.MainWindow.Buttons.RightButton == nil then Spy.db.profile.MainWindow.Buttons.RightButton = Default_Profile.profile.MainWindow.Buttons.RightButton end
	if Spy.db.profile.MainWindow.RowHeight == nil then Spy.db.profile.MainWindow.RowHeight = Default_Profile.profile.MainWindow.RowHeight end
	if Spy.db.profile.MainWindow.RowSpacing == nil then Spy.db.profile.MainWindow.RowSpacing = Default_Profile.profile.MainWindow.RowSpacing end
	if Spy.db.profile.MainWindow.TextHeight == nil then Spy.db.profile.MainWindow.TextHeight = Default_Profile.profile.MainWindow.TextHeight end
	if Spy.db.profile.MainWindow.AutoHide == nil then Spy.db.profile.MainWindow.AutoHide = Default_Profile.profile.MainWindow.AutoHide end
	if Spy.db.profile.MainWindow.BarText == nil then Spy.db.profile.MainWindow.BarText = Default_Profile.profile.MainWindow.BarText end
	if Spy.db.profile.MainWindow.BarText.RankNum == nil then Spy.db.profile.MainWindow.BarText.RankNum = Default_Profile.profile.MainWindow.BarText.RankNum end
	if Spy.db.profile.MainWindow.BarText.PerSec == nil then Spy.db.profile.MainWindow.BarText.PerSec = Default_Profile.profile.MainWindow.BarText.PerSec end
	if Spy.db.profile.MainWindow.BarText.Percent == nil then Spy.db.profile.MainWindow.BarText.Percent = Default_Profile.profile.MainWindow.BarText.Percent end
	if Spy.db.profile.MainWindow.BarText.NumFormat == nil then Spy.db.profile.MainWindow.BarText.NumFormat = Default_Profile.profile.MainWindow.BarText.NumFormat end
	if Spy.db.profile.MainWindow.Position == nil then Spy.db.profile.MainWindow.Position = Default_Profile.profile.MainWindow.Position end
	if Spy.db.profile.MainWindow.Position.x == nil then Spy.db.profile.MainWindow.Position.x = Default_Profile.profile.MainWindow.Position.x end
	if Spy.db.profile.MainWindow.Position.y == nil then Spy.db.profile.MainWindow.Position.y = Default_Profile.profile.MainWindow.Position.y end
	if Spy.db.profile.MainWindow.Position.w == nil then Spy.db.profile.MainWindow.Position.w = Default_Profile.profile.MainWindow.Position.w end
	if Spy.db.profile.MainWindow.Position.h == nil then Spy.db.profile.MainWindow.Position.h = Default_Profile.profile.MainWindow.Position.h end
	if Spy.db.profile.AlertWindowNameSize == nil then Spy.db.profile.AlertWindowNameSize = Default_Profile.profile.AlertWindowNameSize end
	if Spy.db.profile.AlertWindowLocationSize == nil then Spy.db.profile.AlertWindowLocationSize = Default_Profile.profile.AlertWindowLocationSize end
	if Spy.db.profile.BarTexture == nil then Spy.db.profile.BarTexture = Default_Profile.profile.BarTexture end
	if Spy.db.profile.MainWindowVis == nil then Spy.db.profile.MainWindowVis = Default_Profile.profile.MainWindowVis end
	if Spy.db.profile.CurrentList == nil then Spy.db.profile.CurrentList = Default_Profile.profile.CurrentList end
	if Spy.db.profile.Locked == nil then Spy.db.profile.Locked = Default_Profile.profile.Locked end
	if Spy.db.profile.Font == nil then Spy.db.profile.Font = Default_Profile.profile.Font end
	if Spy.db.profile.Scaling == nil then Spy.db.profile.Scaling = Default_Profile.profile.Scaling end
	if Spy.db.profile.Enabled == nil then Spy.db.profile.Enabled = Default_Profile.profile.Enabled end
	if Spy.db.profile.EnabledInBattlegrounds == nil then Spy.db.profile.EnabledInBattlegrounds = Default_Profile.profile.EnabledInBattlegrounds end
	if Spy.db.profile.EnabledInArenas == nil then Spy.db.profile.EnabledInArenas = Default_Profile.profile.EnabledInArenas end
	if Spy.db.profile.EnabledInWintergrasp == nil then Spy.db.profile.EnabledInWintergrasp = Default_Profile.profile.EnabledInWintergrasp end
	if Spy.db.profile.DisableWhenPVPUnflagged == nil then Spy.db.profile.DisableWhenPVPUnflagged = Default_Profile.profile.DisableWhenPVPUnflagged end
	if Spy.db.profile.MinimapTracking == nil then Spy.db.profile.MinimapTracking = Default_Profile.profile.MinimapTracking end
	if Spy.db.profile.MinimapDetails == nil then Spy.db.profile.MinimapDetails = Default_Profile.profile.MinimapDetails end
	if Spy.db.profile.DisplayOnMap == nil then Spy.db.profile.DisplayOnMap = Default_Profile.profile.DisplayOnMap end
	if Spy.db.profile.MapDisplayLimit == nil then Spy.db.profile.MapDisplayLimit = Default_Profile.profile.MapDisplayLimit end
	if Spy.db.profile.DisplayWinLossStatistics == nil then Spy.db.profile.DisplayWinLossStatistics = Default_Profile.profile.DisplayWinLossStatistics end
	if Spy.db.profile.DisplayKOSReason == nil then Spy.db.profile.DisplayKOSReason = Default_Profile.profile.DisplayKOSReason end
	if Spy.db.profile.DisplayLastSeen == nil then Spy.db.profile.DisplayLastSeen = Default_Profile.profile.DisplayLastSeen end
	if Spy.db.profile.ShowOnDetection == nil then Spy.db.profile.ShowOnDetection = Default_Profile.profile.ShowOnDetection end
	if Spy.db.profile.HideSpy == nil then Spy.db.profile.HideSpy = Default_Profile.profile.HideSpy end
	if Spy.db.profile.InvertSpy == nil then Spy.db.profile.InvertSpy = Default_Profile.profile.InvertSpy end
	if Spy.db.profile.ResizeSpy == nil then Spy.db.profile.ResizeSpy = Default_Profile.profile.ResizeSpy end
	if Spy.db.profile.Announce == nil then Spy.db.profile.Announce = Default_Profile.profile.Announce end
	if Spy.db.profile.OnlyAnnounceKoS == nil then Spy.db.profile.OnlyAnnounceKoS = Default_Profile.profile.OnlyAnnounceKoS end
	if Spy.db.profile.WarnOnStealth == nil then Spy.db.profile.WarnOnStealth = Default_Profile.profile.WarnOnStealth end
	if Spy.db.profile.WarnOnKOS == nil then Spy.db.profile.WarnOnKOS = Default_Profile.profile.WarnOnKOS end
	if Spy.db.profile.WarnOnKOSGuild == nil then Spy.db.profile.WarnOnKOSGuild = Default_Profile.profile.WarnOnKOSGuild end
	if Spy.db.profile.DisplayWarningsInErrorsFrame == nil then Spy.db.profile.DisplayWarningsInErrorsFrame = Default_Profile.profile.DisplayWarningsInErrorsFrame end
	if Spy.db.profile.EnableSound == nil then Spy.db.profile.EnableSound = Default_Profile.profile.EnableSound end
	if Spy.db.profile.RemoveUndetected == nil then Spy.db.profile.RemoveUndetected = Default_Profile.profile.RemoveUndetected end
	if Spy.db.profile.ShowNearbyList == nil then Spy.db.profile.ShowNearbyList = Default_Profile.profile.ShowNearbyList end
	if Spy.db.profile.PrioritiseKoS == nil then Spy.db.profile.PrioritiseKoS = Default_Profile.profile.PrioritiseKoS end
	if Spy.db.profile.PurgeData == nil then Spy.db.profile.PurgeData = Default_Profile.profile.PurgeData end
	if Spy.db.profile.ShareData == nil then Spy.db.profile.ShareData = Default_Profile.profile.ShareData end
	if Spy.db.profile.UseData == nil then Spy.db.profile.UseData = Default_Profile.profile.UseData end
	if Spy.db.profile.ShareKOSBetweenCharacters == nil then Spy.db.profile.ShareKOSBetweenCharacters = Default_Profile.profile.ShareKOSBetweenCharacters end
end

function Spy:ResetProfile()
	Spy.db.profile = Default_Profile.profile
	Spy:CheckDatabase()
end

function Spy:HandleProfileChanges()
	Spy:CreateMainWindow()
	Spy:UpdateTimeoutSettings()
--	Spy:SetSpyLocked()
	Spy:LockWindows(Spy.db.profile.Locked)
end

function Spy:RegisterModuleOptions(name, optionTbl, displayName)
	Spy.options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Spy", displayName, "Spy", name)
end

function Spy:SetupOptions()
	self.optionsFrames = {}

 	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Spy", Spy.options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Spy Commands", Spy.optionsSlash, "spy")

	local ACD3 = LibStub("AceConfigDialog-3.0")
	self.optionsFrames.Spy = ACD3:AddToBlizOptions("Spy", nil, nil, "General")
	self.optionsFrames.DisplayOptions = ACD3:AddToBlizOptions("Spy", L["DisplayOptions"], "Spy", "DisplayOptions")
	self.optionsFrames.AlertOptions = ACD3:AddToBlizOptions("Spy", L["AlertOptions"], "Spy", "AlertOptions")
	self.optionsFrames.ListOptions = ACD3:AddToBlizOptions("Spy", L["ListOptions"], "Spy", "ListOptions")
	self.optionsFrames.DataOptions = ACD3:AddToBlizOptions("Spy", L["MinimapOptions"], "Spy", "MinimapOptions")
	self.optionsFrames.DataOptions = ACD3:AddToBlizOptions("Spy", L["DataOptions"], "Spy", "DataOptions")

	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), L["Profiles"])
	Spy.options.args.Profiles.order = -2
end

function Spy:UpdateTimeoutSettings()
	if not Spy.db.profile.RemoveUndetected or Spy.db.profile.RemoveUndetected == "OneMinute" then
		Spy.ActiveTimeout = 30
		Spy.InactiveTimeout = 60
	elseif Spy.db.profile.RemoveUndetected == "TwoMinutes" then
		Spy.ActiveTimeout = 60
		Spy.InactiveTimeout = 120
	elseif Spy.db.profile.RemoveUndetected == "FiveMinutes" then
		Spy.ActiveTimeout = 150
		Spy.InactiveTimeout = 300
	elseif Spy.db.profile.RemoveUndetected == "TenMinutes" then
		Spy.ActiveTimeout = 300
		Spy.InactiveTimeout = 600
	elseif Spy.db.profile.RemoveUndetected == "FifteenMinutes" then
		Spy.ActiveTimeout = 450
		Spy.InactiveTimeout = 900
	elseif Spy.db.profile.RemoveUndetected == "Never" then
		Spy.ActiveTimeout = 30
		Spy.InactiveTimeout = -1
	else
		Spy.ActiveTimeout = 150
		Spy.InactiveTimeout = 300
	end
end

function Spy:ResetMainWindow()
	Spy:EnableSpy(true, true)
	Spy:CreateMainWindow()
	Spy:RestoreMainWindowPosition(Default_Profile.profile.MainWindow.Position.x, Default_Profile.profile.MainWindow.Position.y, Default_Profile.profile.MainWindow.Position.w, 44)
	Spy:RefreshCurrentList()
end

function Spy:ShowConfig()
	-- Open the profiles tab first so the menu expands
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Spy)
end

function Spy:OnEnable(first)
	Spy.timeid = Spy:ScheduleRepeatingTimer("ManageExpirations", 10, true)
	Spy:RegisterEvent("ZONE_CHANGED", "ZoneChangedEvent")
	Spy:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChangedEvent")
	Spy:RegisterEvent("PLAYER_ENTERING_WORLD", "ZoneChangedEvent")
	Spy:RegisterEvent("UNIT_FACTION", "ZoneChangedEvent")
	Spy:RegisterEvent("PLAYER_TARGET_CHANGED", "PlayerTargetEvent")
	Spy:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "PlayerMouseoverEvent")
	Spy:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "CombatLogEvent")
--	Spy:RegisterEvent("WORLD_MAP_UPDATE", "WorldMapUpdateEvent")
	Spy:RegisterEvent("PLAYER_REGEN_ENABLED", "LeftCombatEvent")
	Spy:RegisterEvent("PLAYER_DEAD", "PlayerDeadEvent")
	Spy:RegisterComm(Spy.Signature, "CommReceived")
	Spy.IsEnabled = true
	Spy:RefreshCurrentList()
end

function Spy:OnDisable()
	if not Spy.IsEnabled then
		return
	end
	if Spy.timeid then
		Spy:CancelTimer(Spy.timeid)
		Spy.timeid = nil
	end
	Spy:UnregisterEvent("ZONE_CHANGED")
	Spy:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	Spy:UnregisterEvent("PLAYER_ENTERING_WORLD")
	Spy:UnregisterEvent("UNIT_FACTION")
	Spy:UnregisterEvent("PLAYER_TARGET_CHANGED")
	Spy:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	Spy:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Spy:UnregisterEvent("WORLD_MAP_UPDATE")
	Spy:UnregisterEvent("PLAYER_REGEN_ENABLED")
	Spy:UnregisterEvent("PLAYER_DEAD")
	Spy:UnregisterComm(Spy.Signature)
	Spy.IsEnabled = false
end

function Spy:EnableSpy(value, changeDisplay, hideEnabledMessage)
	Spy.db.profile.Enabled = value
	if value then
		if changeDisplay and not InCombatLockdown() then Spy.MainWindow:Show() end
		Spy:OnEnable()
		if not hideEnabledMessage then DEFAULT_CHAT_FRAME:AddMessage(L["SpyEnabled"]) end
	else
		if changeDisplay and not InCombatLockdown() then Spy.MainWindow:Hide() end
		Spy:OnDisable()
		DEFAULT_CHAT_FRAME:AddMessage(L["SpyDisabled"])
	end
end

function Spy:BuildZoneIDTable_z(continentIndex, zoneIndex, zoneName, next, ...)
	zoneIndex = zoneIndex + 1
	Spy.ZoneID[zoneName] = {}
	Spy.ZoneID[zoneName].continentIndex = continentIndex
	Spy.ZoneID[zoneName].zoneIndex = zoneIndex
	if next then Spy:BuildZoneIDTable_z(continentIndex, zoneIndex, next, ...) end
end

function Spy:BuildZoneIDTable(zoneIndex, continentName, next, ...)
	zoneIndex = zoneIndex + 1
	Spy:BuildZoneIDTable_z(zoneIndex, 0, GetMapZones(zoneIndex))
	if next then Spy:BuildZoneIDTable(zoneIndex, next, ...) end
end

function Spy:GetZoneID(zoneName)
	if not Spy.ZoneID[zoneName] then
		return nil
	end
	return Spy.ZoneID[zoneName].continentIndex, Spy.ZoneID[zoneName].zoneIndex
end

function Spy:OnInitialize()
	WorldMapFrame:Show()
	WorldMapFrame:Hide()

	Spy.RealmName = GetRealmName()
--	Spy.FactionName, _ = UnitFactionGroup("player")
    Spy.FactionName = select(1, UnitFactionGroup("player"))
	if Spy.FactionName == "Alliance" then
		Spy.EnemyFactionName = "Horde"
	else
		Spy.EnemyFactionName = "Alliance"
	end
	Spy.CharacterName = UnitName("player")

	Spy.ValidClasses = {}
	Spy.ValidClasses["DEATHKNIGHT"] = true
	Spy.ValidClasses["DRUID"] = true
	Spy.ValidClasses["HUNTER"] = true
	Spy.ValidClasses["MAGE"] = true
	Spy.ValidClasses["MONK"] = true --++
	Spy.ValidClasses["PALADIN"] = true
	Spy.ValidClasses["PRIEST"] = true
	Spy.ValidClasses["ROGUE"] = true
	Spy.ValidClasses["SHAMAN"] = true
	Spy.ValidClasses["WARLOCK"] = true
	Spy.ValidClasses["WARRIOR"] = true

	Spy.ValidRaces = {}
	Spy.ValidRaces["Blood Elf"] = true
	Spy.ValidRaces["Draenei"] = true
	Spy.ValidRaces["Dwarf"] = true
	Spy.ValidRaces["Goblin"] = true
	Spy.ValidRaces["Gnome"] = true
	Spy.ValidRaces["Human"] = true
	Spy.ValidRaces["Night Elf"] = true
	Spy.ValidRaces["Orc"] = true
	Spy.ValidRaces["Pandaren"] = true --++
	Spy.ValidRaces["Tauren"] = true
	Spy.ValidRaces["Troll"] = true
	Spy.ValidRaces["Undead"] = true
	Spy.ValidRaces["Worgen"] = true
	

	local acedb = LibStub:GetLibrary("AceDB-3.0")

	Spy.db = acedb:New("SpyDB", Default_Profile)
	Spy:CheckDatabase()

	self.db.RegisterCallback(self, "OnNewProfile", "ResetProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "ResetProfile")
	self.db.RegisterCallback(self, "OnProfileChanged", "HandleProfileChanges")
	self.db.RegisterCallback(self, "OnProfileCopied", "HandleProfileChanges")
	self:SetupOptions()

	SpyTempTooltip = CreateFrame("GameTooltip", "SpyTempTooltip", nil, "GameTooltipTemplate")
	SpyTempTooltip:SetOwner(UIParent, "ANCHOR_NONE")

	Spy:RegenerateKOSGuildList()
	if Spy.db.profile.ShareKOSBetweenCharacters then
		Spy:RemoveLocalKOSPlayers()
		Spy:RegenerateKOSCentralList()
		Spy:RegenerateKOSListFromCentral()
	end
	Spy:PurgeUndetectedData()
	Spy:CreateMainWindow()
	Spy:UpdateTimeoutSettings()
--	Spy:SetSpyLocked()
--	Spy:LockWindows(Spy.db.profile.Locked)

	SM.RegisterCallback(Spy, "LibSharedMedia_Registered", "UpdateBarTextures")
	SM.RegisterCallback(Spy, "LibSharedMedia_SetGlobal", "UpdateBarTextures")
	if Spy.db.profile.BarTexture then
		Spy:SetBarTextures(Spy.db.profile.BarTexture)
	end

	Spy:LockWindows(Spy.db.profile.Locked)
	Spy:BuildZoneIDTable(0, GetMapContinents())
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", Spy.FilterNotInParty)
	DEFAULT_CHAT_FRAME:AddMessage(L["LoadDescription"])
end

function Spy:ZoneChangedEvent()
 	local zone = GetZoneText() 	
	if zone == "" then
		-- zone hasn't loaded yet, try again in 5 seconds.
		self:ScheduleTimer("ZoneChangedEvent",5)
--		print("[Spy] Delayed for...5 seconds while game is loading.")
		return
	end
--	print(zone)
	Spy.InInstance = false
	local pvpType = GetZonePVPInfo()
	if pvpType == "sanctuary" or GetZoneText() == "" then
		Spy.EnabledInZone = false
	else
		Spy.EnabledInZone = true

		local inInstance, instanceType = IsInInstance()
		if inInstance then
			Spy.InInstance = true
			if instanceType == "party" or instanceType == "raid" or (not Spy.db.profile.EnabledInBattlegrounds and instanceType == "pvp") or (not Spy.db.profile.EnabledInArenas and instanceType == "arena") then
				Spy.EnabledInZone = false
			end
		elseif pvpType == "combat" then
			if not Spy.db.profile.EnabledInWintergrasp then
				Spy.EnabledInZone = false
			end
		elseif (pvpType == "friendly" or pvpType == nil) then
			if UnitIsPVP("player") == nil and Spy.db.profile.DisableWhenPVPUnflagged then
				Spy.EnabledInZone = false
			end
		end
	end

	if Spy.EnabledInZone then
		if not Spy.db.profile.HideSpy then
			if not InCombatLockdown() then Spy.MainWindow:Show() end
			Spy:RefreshCurrentList()
		end
	else
		if not InCombatLockdown() then Spy.MainWindow:Hide() end
	end
end

function Spy:PlayerTargetEvent()
	local name = GetUnitName("target", true)
	if name and UnitIsPlayer("target") and not SpyPerCharDB.IgnoreData[name] then
		local playerData = SpyPerCharDB.PlayerData[name]
		if UnitIsEnemy("player", "target") then
			name = string.gsub(name, " %- ", "-")

			local learnt = true
			if playerData and playerData.isGuess == false then learnt = false end

--			local _, class = UnitClass("target")
			local x, class = UnitClass("target")
--			local class = select(2,UnitClass("target"))
--			local race, _ = UnitRace("target")
			local race = select(1,UnitRace("target"))
			local level = tonumber(UnitLevel("target"))
			local guild = GetGuildInfo("target")
			local guess = false
			if level <= 0 then
				guess = true
				level = nil
			end

			Spy:UpdatePlayerData(name, class, level, race, guild, true, guess)
			if Spy.EnabledInZone then
				Spy:AddDetected(name, time(), learnt)
			end
		elseif playerData then
			Spy:RemovePlayerData(name)
		end
	end
end

function Spy:PlayerMouseoverEvent()
	local name = GetUnitName("mouseover", true)
	if name and UnitIsPlayer("mouseover") and not SpyPerCharDB.IgnoreData[name] then
		local playerData = SpyPerCharDB.PlayerData[name]
		if UnitIsEnemy("player", "mouseover") then
			name = string.gsub(name, " %- ", "-")

			local learnt = true
			if playerData and playerData.isGuess == false then learnt = false end

--			local _, class = UnitClass("mouseover")
			local x, class = UnitClass("mouseover")
--			local class = select(2,UnitClass("mouseover"))
--			local race, _ = UnitRace("mouseover")
			local race = select(1,UnitRace("mouseover"))
			local level = tonumber(UnitLevel("mouseover"))
			local guild = GetGuildInfo("mouseover")
			local guess = false
			if level <= 0 then
				guess = true
				level = nil
			end

			Spy:UpdatePlayerData(name, class, level, race, guild, true, guess)
			if Spy.EnabledInZone then
				Spy:AddDetected(name, time(), learnt)
			end
		elseif playerData then
			Spy:RemovePlayerData(name)
		end
	end
end

function Spy:CombatLogEvent(_, timestamp, event, _, srcGUID, srcName, srcFlags, sourceRaidFlags, dstGUID, dstName, dstFlags, destRaidFlags, ...)
	if Spy.EnabledInZone then
		local arg9, arg10 = select(1, ...)

		-- analyse the source unit
		if bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE and srcGUID and srcName and not SpyPerCharDB.IgnoreData[srcName] then
			local srcType = bit.band(tonumber("0x"..strsub(srcGUID, 3, 5)), 0x00F)
			if srcType == 0 or srcType == 8 then
				local learnt = false
				local detected = true
				local playerData = SpyPerCharDB.PlayerData[srcName]
				if not playerData or playerData.isGuess then
					learnt, playerData = Spy:ParseUnitAbility(true, event, srcName, srcFlags, arg9, arg10)
				end
				if not learnt then
					detected = Spy:UpdatePlayerData(srcName, nil, nil, nil, nil, true, nil)
				end

				if detected then
					Spy:AddDetected(srcName, timestamp, learnt)
					if event == "SPELL_AURA_APPLIED" and (arg10 == L["Stealth"] or arg10 == L["Prowl"]) then
						Spy:AlertStealthPlayer(srcName)
					end
				end

				if dstGUID == UnitGUID("player") then
					Spy.LastAttack = srcName
				end
			end
		end

		-- analyse the destination unit
		if bit.band(dstFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE and dstGUID and dstName and not SpyPerCharDB.IgnoreData[dstName] then
			local dstType = bit.band(tonumber("0x"..strsub(dstGUID, 3, 5)), 0x00F)
			if dstType == 0 or dstType == 8 then
				local learnt = false
				local detected = true
				local playerData = SpyPerCharDB.PlayerData[dstName]
				if not playerData or playerData.isGuess then
					learnt, playerData = Spy:ParseUnitAbility(false, event, dstName, dstFlags, arg9, arg10)
				end
				if not learnt then
					detected = Spy:UpdatePlayerData(dstName, nil, nil, nil, nil, true, nil)
				end

				if detected then
					Spy:AddDetected(dstName, timestamp, learnt)
				end
			end
		end

		-- update win statistics
		if event == "PARTY_KILL" then
			if srcGUID == UnitGUID("player") and dstName then
				local playerData = SpyPerCharDB.PlayerData[dstName]
				if playerData then
					if not playerData.wins then playerData.wins = 0 end
					playerData.wins = playerData.wins + 1
				end
			end
		end
	end
end

function Spy:LeftCombatEvent()
	Spy.LastAttack = nil
	Spy:RefreshCurrentList()
end

function Spy:PlayerDeadEvent()
	if Spy.LastAttack then
		local playerData = SpyPerCharDB.PlayerData[Spy.LastAttack]
		if playerData then
			if not playerData.loses then playerData.loses = 0 end
			playerData.loses = playerData.loses + 1
		end
	end
end

--[[function Spy:WorldMapUpdateEvent() -- causes a stack overflow when going in to instances and hearthing
	for i = 1, Spy.MapNoteLimit do
		local note = Spy.MapNoteList[i]
		if note.displayed then
			Astrolabe:PlaceIconOnWorldMap(WorldMapDetailFrame, note.worldIcon, Astrolabe:GetMapID(note.continentIndex, note.zoneIndex), 0, note.mapX, note.mapY)
			Astrolabe:PlaceIconOnMinimap(note.miniIcon, Astrolabe:GetMapID(note.continentIndex, note.zoneIndex), 0, note.mapX, note.mapY)
		end
	end
end]]

function Spy:CommReceived(prefix, message, distribution, source)
	if Spy.EnabledInZone and Spy.db.profile.UseData then
		if prefix == Spy.Signature and message and source ~= Spy.CharacterName then
			local version, player, class, level, race, zone, subZone, mapX, mapY, guild = strsplit("|", message)
			if player ~= nil and (not Spy.InInstance or zone == GetZoneText()) then
				if not Spy.PlayerCommList[player] then
--++				if tonumber(version) > tonumber(Spy.Version) and not Spy.UpgradeMessageSent then
					if version > Spy.Version and not Spy.UpgradeMessageSent then
						DEFAULT_CHAT_FRAME:AddMessage(L["UpgradeAvailable"])
						Spy.UpgradeMessageSent = true
					end
					if strlen(class) > 0 then
						if not Spy.ValidClasses[class] then
							return
						end
					else
						class = nil
					end
					if strlen(level) > 0 then
						level = tonumber(level)
						if type(level) == "number" then
							if level < 1 or level > Spy.MaximumPlayerLevel or math.floor(level) ~= level then
								return
							end
						else
							return
						end
					else
						level = nil
					end
					if strlen(race) > 0 then
						if not Spy.ValidRaces[race] then
							return
						end
						if (Spy.EnemyFactionName == "Alliance" and race ~= "Draenei" and race ~= "Dwarf" and race ~= "Gnome" and race ~= "Human" and race ~= "Pandaren" and race ~= "Night Elf" and race ~= "Worgen") --++
						or (Spy.EnemyFactionName == "Horde" and race ~= "Blood Elf" and race ~= "Goblin" and race ~= "Orc" and race ~= "Pandaren" and race ~= "Tauren" and race ~= "Troll" and race ~= "Undead") then --++
							return
						end
					else
						race = nil
					end
					if strlen(zone) > 0 then
						if not Spy:GetZoneID(zone) then
							return
						end
					else
						zone = nil
					end
					if strlen(subZone) == 0 then
						subZone = nil
					end
					if strlen(mapX) > 0 then
						mapX = tonumber(mapX)
						if type(mapX) == "number" and mapX >= 0 and mapX <= 1 then
							mapX = math.floor(mapX * 100) / 100
						else
							return
						end
					else
						mapX = nil
					end
					if strlen(mapY) > 0 then
						mapY = tonumber(mapY)
						if type(mapY) == "number" and mapY >= 0 and mapY <= 1 then
							mapY = math.floor(mapY * 100) / 100
						else
							return
						end
					else
						mapY = nil
					end
					if strlen(guild) > 0 then
						if strlen(guild) > 24 then
							return
						end
					else
						guild = nil
					end

					local learnt, playerData = Spy:ParseUnitDetails(player, class, level, race, zone, subZone, mapX, mapY, guild)
					if playerData and playerData.isEnemy and not SpyPerCharDB.IgnoreData[player] then
						Spy.PlayerCommList[player] = Spy.CurrentMapNote
						Spy:AddDetected(player, time(), learnt, source)
						if Spy.db.profile.DisplayOnMap then
							Spy:ShowMapNote(player)
						end
					end
				end
			end
		end
	end
end

function Spy:TrackHumanoids()
	local tooltip = GameTooltipTextLeft1:GetText()
	if tooltip and tooltip ~= Spy.LastTooltip then
		tooltip = Spy:ParseMinimapTooltip(tooltip)
		if Spy.db.profile.MinimapDetails then
			GameTooltipTextLeft1:SetText(tooltip)
			Spy.LastTooltip = tooltip
		end
		GameTooltip:Show()
	end
end

function Spy:FilterNotInParty(frame, event, message)
	if (event == ERR_NOT_IN_GROUP or event == ERR_NOT_IN_RAID) then
		return true
	end
	return false
end

function Spy:ShowMapNote(player)
	local playerData = SpyPerCharDB.PlayerData[player]
	if playerData then
		local currentContinentIndex, currentZoneIndex = Spy:GetZoneID(GetZoneText())
		local continentIndex, zoneIndex = Spy:GetZoneID(playerData.zone)
		local mapX, mapY = playerData.mapX, playerData.mapY
		if continentIndex ~= nil and zoneIndex ~= nil and type(playerData.mapX) == "number" and type(playerData.mapY) == "number" and (Spy.db.profile.MapDisplayLimit == "None" or (Spy.db.profile.MapDisplayLimit == "SameZone" and zoneIndex == currentZoneIndex) or (Spy.db.profile.MapDisplayLimit == "SameContinent" and continentIndex == currentContinentIndex)) then
			local note = Spy.MapNoteList[Spy.CurrentMapNote]
			note.displayed = true
			note.continentIndex = continentIndex
			note.zoneIndex = zoneIndex
			note.mapX = mapX
			note.mapY = mapY

			Astrolabe:PlaceIconOnWorldMap(WorldMapDetailFrame, note.worldIcon, Astrolabe:GetMapID(continentIndex, zoneIndex), 0, mapX, mapY) -- Floor mod			
			Astrolabe:PlaceIconOnMinimap(note.miniIcon, Astrolabe:GetMapID(note.continentIndex, note.zoneIndex), 0, note.mapX, note.mapY)	-- Floor mod		
--			Astrolabe:PlaceIconOnWorldMap(WorldMapDetailFrame, note.worldIcon, Astrolabe:GetMapID(continentIndex, zoneIndex), 1, mapX, mapY) -- original
--			Astrolabe:PlaceIconOnMinimap(note.miniIcon, Astrolabe:GetMapID(note.continentIndex, note.zoneIndex), 1, note.mapX, note.mapY) -- original

			for i = 1, Spy.MapNoteLimit do
				if i ~= Spy.CurrentMapNote and Spy.MapNoteList[i].displayed then
					if continentIndex == Spy.MapNoteList[i].continentIndex and zoneIndex == Spy.MapNoteList[i].zoneIndex and abs(mapX - Spy.MapNoteList[i].mapX) < Spy.MapProximityThreshold and abs(mapY - Spy.MapNoteList[i].mapY) < Spy.MapProximityThreshold then
						Spy.MapNoteList[i].displayed = false
						Spy.MapNoteList[i].worldIcon:Hide()
						Astrolabe:RemoveIconFromMinimap(Spy.MapNoteList[i].miniIcon)
						for player in pairs(Spy.PlayerCommList) do
							if Spy.PlayerCommList[player] == i then
								Spy.PlayerCommList[player] = Spy.CurrentMapNote
							end
						end
					end
				end
			end

			Spy.CurrentMapNote = Spy.CurrentMapNote + 1
			if Spy.CurrentMapNote > Spy.MapNoteLimit then
				Spy.CurrentMapNote = 1
			end
		end
	end
end

function Spy:GetPlayerLocation(playerData)
	local location = playerData.zone
	local mapX = playerData.mapX
	local mapY = playerData.mapY
	if location and playerData.subZone and playerData.subZone ~= "" and playerData.subZone ~= location then
		location = playerData.subZone..", "..location
	end
	if mapX and mapX ~= 0 and mapY and mapY ~= 0 then
		location = location.." ("..math.floor(tonumber(mapX) * 100)..","..math.floor(tonumber(mapY) * 100)..")"
	end
	return location
end
