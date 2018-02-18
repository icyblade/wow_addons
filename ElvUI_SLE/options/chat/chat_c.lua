local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local C = SLE:GetModule("Chat")
local NONE, INVITE = NONE, INVITE
local function configTable()
	if not SLE.initialized then return end
	local function CreateJustify(i)
		local config = {
			order = i + 1,
			type = "select",
			name = L["Frame "..i],
			get = function(info) return E.db.sle.chat.justify["frame"..i] end,
			set = function(info, value)	E.db.sle.chat.justify["frame"..i] = value; C:JustifyChat(i) end,
			values = {
				LEFT = L["Left"],
				RIGHT = L["Right"],
				CENTER = L["Center"],
			},
		}
		return config
	end

	E.Options.args.sle.args.modules.args.chat = {
		order = 7,
		type = "group",
		name = L["Chat"],
		childGroups = 'tab',
		disabled = function() return not E.private.chat.enable end,
		args = {
			header = { order = 1, type = "header", name = L["Chat"] },
			editreset = {
				order = 3, type = 'execute',
				name = L["Reset Editbox History"], desc = L["Clears the editbox history and will reload your UI."],
				func = function() E:StaticPopup_Show("SLE_EDIT_HISTORY_CLEAR") end,
			},
			header2 = { order = 4, type = "description", name = "" },
			guildmaster = {
				order = 5, type = "toggle",
				name = L["Guild Master Icon"],
				desc = L["Displays an icon near your Guild Master in chat.\n\n|cffFF0000Note:|r Some messages in chat history may disappear on login."],
				get = function(info) return E.db.sle.chat.guildmaster end,
				set = function(info, value)	E.db.sle.chat.guildmaster = value; C:GMIconUpdate() end,
			},
			editboxhistory = {
				order = 6, type = "range",
				name = L["Chat Editbox History"],
				desc = L["The amount of messages to save in the editbox history.\n\n|cffFF0000Note:|r To disable, set to 0."],
				min = 5, max = 50, step = 1,
				get = function(info) return E.db.sle.chat.editboxhistory end,
				set = function(info, value) E.db.sle.chat.editboxhistory = value; end,
			},
			chatMax = {
				order = 7, type = "range",
				name = L["Chat Max Messages"],
				desc = L["The amount of messages to save in chat window.\n\n|cffFF0000Warning:|r Can increase the amount of memory needed. Also changing this setting will clear the chat in all windows, leaving just lines saved in chat history."],
				min = 10, max = 5000, step = 1,
				disabled = function() return not E.private.chat.enable or SLE._Compatibility["ElvUI_CustomTweaks"] end,
				get = function(info) return E.private.sle.chat.chatMax end,
				set = function(info, value) E.private.sle.chat.chatMax = value; C:UpdateChatMax() end,
			},
			dpsSpam = {
				order = 8, type = "toggle",
				name = L["Filter DPS meters' Spam"],
				desc = L["Replaces long reports from damage meters with a clickable hyperlink to reduce chat spam.\nWorks correctly only with general reports such as DPS or HPS. May fail to filter the report of other things."],
				get = function(info) return E.db.sle.chat.dpsSpam end,
				set = function(info, value)	E.db.sle.chat.dpsSpam = value; C:SpamFilter() end,
			},
			combathide = {
				order = 9, type = "select",
				name = L["Hide In Combat"],
				get = function(info) return E.db.sle.chat.combathide end,
				set = function(info, value)	E.db.sle.chat.combathide = value; end,
				values = {
					["NONE"] = NONE,
					["BOTH"] = L["Both"],
					["LEFT"] = L["Left"],
					["RIGHT"] = L["Right"],
				}
			},
			setupDelay = {
				order = 10,
				type = "range",
				name = L["Chat Setup Delay"],
				desc = L["Manages the delay before S&L will execute hooks to ElvUI's chat positioning. Prevents some weird positioning issues."],
				hidden = function() return not E.global.sle.advanced.general end,
				min = 0.5, max = 10, step = .1,
				get = function(info) return E.global.sle.advanced.chat[ info[#info] ] end,
				set = function(info, value) E.global.sle.advanced.chat[ info[#info] ] = value; E:StaticPopup_Show("GLOBAL_RL") end,
			},
			textureAlpha = {
				order = 20, type = "group",
				name = L["Texture Alpha"],
				args = {
					enable = {
						order = 1, type = "toggle",
						name = L["Enable"],
						desc = L["Allows separate alpha setting for textures in chat"],
						get = function(info) return E.db.sle.chat.textureAlpha.enable end,
						set = function(info, value)	E.db.sle.chat.textureAlpha.enable = value; E:UpdateMedia() end,
					},
					alpha = {
						order = 2, type = "range",
						name = L["Alpha"],
						isPercent = true,
						disabled = function() return not E.db.sle.chat.textureAlpha.enable end,
						min = 0, max = 1, step = 0.01,
						get = function(info) return E.db.sle.chat.textureAlpha.alpha end,
						set = function(info, value)	E.db.sle.chat.textureAlpha.alpha = value; E:UpdateMedia() end,
					},
				},
			},
			justify = {
				order = 30, type = "group",
				name = L["Chat Frame Justify"],
				args = {
					frame1 = CreateJustify(1),
					frame2 = CreateJustify(2),
					frame3 = CreateJustify(3),
					frame4 = CreateJustify(4),
					frame5 = CreateJustify(5),
					frame6 = CreateJustify(6),
					frame7 = CreateJustify(7),
					frame8 = CreateJustify(8),
					frame9 = CreateJustify(9),
					frame10 = CreateJustify(10),
					identify = {
						order = 12, type = "execute",
						name = L["Identify"],
						desc = L["Shows the message in each chat frame containing frame's number."],
						func = function() C:IdentifyChatFrames() end,
					},
				},
			},
			invite = {
				order = 15,
				type = "group",
				name = INVITE,
				get = function(info) return E.db.sle.chat.invite[ info[#info] ]  end,
				set = function(info, value) E.db.sle.chat.invite[ info[#info] ]  = value; end,
				args = {
					altInv = {
						order = 1,
						type = "toggle",
						name = L["Alt-Click Invite"],
						desc = L["Allows you to invite people by alt-clicking their names in chat."],
					},
					invLinks = {
						order = 2,
						type = "toggle",
						name = L["Invite links"],
						desc = L["Converts specified keywords to links that automatically invite message's author to group."],
						set = function(info, value) E.db.sle.chat.invite[ info[#info] ]  = value; C:SpamFilter() end,
					},
					color = {
						type = 'color',
						order = 3,
						name = L["Link Color"],
						hasAlpha = false,
						disabled = function() return not E.db.sle.chat.invite.invLinks end,
						get = function(info)
							local t = E.db.sle.chat.invite[ info[#info] ]
							local d = P.sle.chat.invite[info[#info]]
							return t.r, t.g, t.b, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.sle.chat.tab[ info[#info] ] = {}
							local t = E.db.sle.chat.invite[ info[#info] ]
							t.r, t.g, t.b = r, g, b
						end,
					},
					keys = {
						order = 4,
						type = "input",
						name = L["Invite Keywords"],
						width = "full",
						multiline = true,
						disabled = function() return not E.db.sle.chat.invite.invLinks end,
						set = function(info, value) E.db.sle.chat.invite[ info[#info] ]  = value; C:CreateInvKeys() end,
					},
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)
