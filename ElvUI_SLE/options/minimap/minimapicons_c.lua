local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local SMB = SLE:GetModule("SquareMinimapButtons")
local function configTable()
	if not SLE.initialized then return end
	E.Options.args.sle.args.modules.args.minimap.args.mapicons = {
		type = "group",
		name = L["Minimap Buttons"],
		order = 6,
		args = {
			mapiconsenable = {
				type = "toggle",
				name = L["Enable"],
				order = 1,
				desc = L["Enable/Disable Square Minimap Buttons."],
				get = function(info) return E.private.sle.minimap.mapicons.enable end,
				set = function(info, value) E.private.sle.minimap.mapicons.enable = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
			barenable = {
				order = 2,
				type = "toggle",
				name = L["Bar Enable"],
				desc = L["Enable/Disable Square Minimap Bar."],
				disabled = function() return not E.private.sle.minimap.mapicons.enable end,
				get = function(info) return E.private.sle.minimap.mapicons.barenable end,
				set = function(info, value) E.private.sle.minimap.mapicons.barenable = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
			skindungeon = {
				order = 3,
				type = 'toggle',
				name = L["Skin Dungeon"],
				desc = L["Skin dungeon icon."],
				disabled = function() return not E.private.sle.minimap.mapicons.enable end,
				get = function(info) return E.db.sle.minimap.mapicons.skindungeon end,
				set = function(info, value) E.db.sle.minimap.mapicons.skindungeon = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
			skinmail = {
				order = 4,
				type = 'toggle',
				name = L["Skin Mail"],
				desc = L["Skin mail icon."],
				disabled = function() return not E.private.sle.minimap.mapicons.enable end,
				get = function(info) return E.db.sle.minimap.mapicons.skinmail end,
				set = function(info, value) E.db.sle.minimap.mapicons.skinmail = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
			iconsize = {
				order = 5,
				type = 'range',
				name = L["Button Size"],
				desc = L["The size of the minimap buttons when not anchored to the minimap."],
				min = 12, max = 40, step = 1,
				disabled = function() return not E.private.sle.minimap.mapicons.enable end,
				get = function(info) return E.db.sle.minimap.mapicons.iconsize end,
				set = function(info, value) E.db.sle.minimap.mapicons.iconsize = value; SMB:Update(SLE_SquareMinimapButtonBar) end,
			},
			iconperrow = {
				order = 6,
				type = 'range',
				name = L["Icons Per Row"],
				desc = L["Anchor mode for displaying the minimap buttons are skinned."],
				min = 1, max = 30, step = 1,
				disabled = function() return not E.private.sle.minimap.mapicons.enable or not E.private.sle.minimap.mapicons.barenable end,
				get = function(info) return E.db.sle.minimap.mapicons.iconperrow end,
				set = function(info, value) E.db.sle.minimap.mapicons.iconperrow = value; SMB:Update(SLE_SquareMinimapButtonBar) end,
			},
			spacing = {
				order = 7,
				type = 'range',
				name = L["Button Spacing"],
				min = -4, max = 10, step = 1,
				disabled = function() return not E.private.sle.minimap.mapicons.enable or not E.private.sle.minimap.mapicons.barenable end,
				get = function(info) return E.db.sle.minimap.mapicons.spacing end,
				set = function(info, value) E.db.sle.minimap.mapicons.spacing = value; SMB:Update(SLE_SquareMinimapButtonBar) end,
			},
			iconmouseover = {
				order = 8,
				name = L["Mouse Over"],
				desc = L["Show minimap buttons on mouseover."],
				type = "toggle",
				disabled = function() return not E.private.sle.minimap.mapicons.enable or not E.private.sle.minimap.mapicons.barenable end,
				get = function(info) return E.db.sle.minimap.mapicons.iconmouseover end,
				set = function(info, value) E.db.sle.minimap.mapicons.iconmouseover = value; SMB:ChangeMouseOverSetting() end,
			},
			template = {
				order = 9,
				name = L["Backdrop Template"],
				type = "select",
				disabled = function() return not E.private.sle.minimap.mapicons.enable or not E.private.sle.minimap.mapicons.barenable end,
				get = function(info) return E.private.sle.minimap.mapicons.template end,
				set = function(info, value) E.private.sle.minimap.mapicons.template = value; E:StaticPopup_Show("PRIVATE_RL") end,
				values = {
					["NoBackdrop"] = NONE,
					["Default"] = DEFAULT,
					["Transparent"] = L["Transparent"],
				},
			},
			growth_hor = {
				order = 10,
				name = L["Horizontal Growth"],
				type = "select",
				disabled = function() return not E.private.sle.minimap.mapicons.enable or not E.private.sle.minimap.mapicons.barenable end,
				get = function(info) return E.db.sle.minimap.mapicons.growth_hor end,
				set = function(info, value) E.db.sle.minimap.mapicons.growth_hor = value; SMB:Update(SLE_SquareMinimapButtonBar) end,
				values = {
					["Right"] = L["Right"],
					["Left"] = L["Left"],
				},
			},
			growth_vert = {
				order = 11,
				name = L["Vertical Growth"],
				type = "select",
				disabled = function() return not E.private.sle.minimap.mapicons.enable or not E.private.sle.minimap.mapicons.barenable end,
				get = function(info) return E.db.sle.minimap.mapicons.growth_vert end,
				set = function(info, value) E.db.sle.minimap.mapicons.growth_vert = value; SMB:Update(SLE_SquareMinimapButtonBar) end,
				values = {
					["Down"] = L["Down"],
					["Up"] = L["Up"],
				},
			},
		},
	}
end

T.tinsert(SLE.Configs, configTable)
