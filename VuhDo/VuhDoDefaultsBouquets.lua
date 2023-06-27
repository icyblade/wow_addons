VUHDO_DEFAULT_BOUQUETS = {
	["VERSION"] = 1,
	["SELECTED"] = VUHDO_I18N_DEF_BOUQUET_TANK_COOLDOWNS,
	["STORED"] = {
		[VUHDO_I18N_DEF_BOUQUET_TANK_COOLDOWNS] = {
			{
				["name"] = GetSpellInfo(12975), -- "Last Stand",
				["mine"] = true, ["others"] = true,	["icon"] = 1,
				["color"] = {
					["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1,	["bright"] = 1.0 },
			},
			{
				["name"] = GetSpellInfo(871), -- "Shield Wall",
				["mine"] = true, ["others"] = true,	["icon"] = 1,
				["color"] = {
					["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = GetSpellInfo(61336), -- "Survival Instincts",
				["mine"] = true, ["others"] = true, ["icon"] = 1,
				["color"] = {
					["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = GetSpellInfo(22842), -- "Frenzied Regeneration",
				["mine"] = true, ["others"] = true, ["icon"] = 1,
				["color"] = {
					["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1,	["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_PW_S_WEAKENED_SOUL] = {
			{
				["name"] = GetSpellInfo(6788), -- "Weakened Soul",
				["mine"] = true, ["others"] = true,	["icon"] = 9,
				["color"] = {
					["R"] = 1, ["G"] = 0.623, ["B"] = 0.305, ["O"] = 1,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = GetSpellInfo(17), -- "Powerword: Shield",
				["mine"] = true, ["icon"] = 8,
				["color"] = {
					["R"] = 0.074, ["G"] = 0.749, ["B"] = 1, ["O"] = 1,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI_AGGRO] = {
			{
				["name"] = "AGGRO", -- "Aggro",
				["mine"] = false, ["icon"] = 2,
				["color"] = {
					["R"] = 1, ["G"] = 0, ["B"] = 0, ["O"] = 1,
					["TR"] = 1, ["TG"] = 0, ["TB"] = 0, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
			{
				["name"] = "PLAYER_TARGET", -- "Player Target",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 0.9, ["G"] = 0.9, ["B"] = 0.9, ["O"] = 1,
					["TR"] = 0.7, ["TG"] = 0.7, ["TB"] = 0.7, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "MOUSE_TARGET", -- "Mouse Target",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 0.635, ["G"] = 0.470, ["B"] = 0.113, ["O"] = 1,
					["TR"] = 0.4, ["TG"] = 0.4, ["TB"] = 0.4, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "ALWAYS",
				["mine"] = true, ["icon"] = 1,
				["color"] = {
					["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.7,
					["TR"] = 0.1, ["TG"] = 0.1, ["TB"] = 0.1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},

		[VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI] = {
			{
				["name"] = "PLAYER_TARGET", -- "Player Target",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 0.9, ["G"] = 0.9, ["B"] = 0.9, ["O"] = 1,
					["TR"] = 0.7, ["TG"] = 0.7, ["TB"] = 0.7, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "MOUSE_TARGET", -- "Mouse Target",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 0.635, ["G"] = 0.470, ["B"] = 0.113, ["O"] = 1,
					["TR"] = 0.4, ["TG"] = 0.4, ["TB"] = 0.4, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
			{
				["name"] = "ALWAYS", -- "Always",
				["mine"] = true, ["icon"] = 1,
				["color"] = {
					["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.7,
					["TR"] = 0.1, ["TG"] = 0.1, ["TB"] = 0.1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_BORDER_SIMPLE] = {
			{
				["name"] = "ALWAYS", -- "Always",
				["mine"] = true, ["icon"] = 1,
				["color"] = {
					["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.7,
					["TR"] = 0.1, ["TG"] = 0.1, ["TB"] = 0.1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_SWIFTMENDABLE] = {
			{
				["name"] = "STATUS_ACTIVE",
				["mine"] = true, ["icon"] = 1,
				["color"] = {
					["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "SWIFTMEND",
				["mine"] = true, ["icon"] = 6,
				["color"] = {
					["R"] = 1, ["G"] = 0, ["B"] = 0, ["O"] = 1,
					["TR"] = 1, ["TG"] = 0, ["TB"] = 0, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_MOUSEOVER_SINGLE] = {
			{
				["name"] = "MOUSE_TARGET",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 0.7,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 0.75,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_MOUSEOVER_MULTI] = {
			{
				["name"] = "MOUSE_TARGET",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 0.75,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 0.75,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
			{
				["name"] = "MOUSE_GROUP",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 0.6,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 0.25,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1,	["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_AGGRO_INDICATOR] = {
			{
				["name"] = "AGGRO",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 1, ["G"] = 0, ["B"] = 0, ["O"] = 1,
					["TR"] = 1, ["TG"] = 0, ["TB"] = 0, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_CLUSTER_MOUSE_HOVER] = {
			{
				["name"] = "STATUS_ACTIVE",
				["mine"] = true, ["icon"] = 1,
				["color"] = {
					["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "MOUSE_CLUSTER",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 1, ["G"] = 0.5, ["B"] = 0, ["O"] = 0.8,
					["TR"] = 1, ["TG"] = 0.5, ["TB"] = 0, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_THREAT_MARKS] = {
			{
				["name"] = "STATUS_ACTIVE",
				["mine"] = true, ["icon"] = 1,
				["color"] = {
					["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "THREAT_LEVEL_HIGH",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 1, ["G"] = 0, ["B"] = 0, ["O"] = 1,
					["TR"] = 1, ["TG"] = 0.5, ["TB"] = 0, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
			{
				["name"] = "THREAT_LEVEL_MEDIUM",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 1, ["G"] = 0.5, ["B"] = 0, ["O"] = 1,
					["TR"] = 1, ["TG"] = 0.5, ["TB"] = 0, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ALL] = {
			{
				["name"] = "NO_RANGE",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
					["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.25,
					["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 2, ["bright"] = 1.0 },
			},
			{
				["name"] = "STATUS_MANA",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 0, ["G"] = 0, ["B"] = 1, ["O"] = 1,
					["TR"] = 0, ["TG"] = 0, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
			},
			{
				["name"] = "STATUS_OTHER_POWERS",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
					["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ONLY] = {
			{
				["name"] = "NO_RANGE",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
					["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.25,
					["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 2, ["bright"] = 1.0 },
			},
			{
				["name"] = "STATUS_MANA",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 0, ["G"] = 0, ["B"] = 1, ["O"] = 1,
					["TR"] = 0, ["TG"] = 0, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
		},


		[VUHDO_I18N_DEF_BOUQUET_BAR_THREAT] = {
			{
				["name"] = "THREAT_ABOVE",
				["mine"] = true, ["others"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 1, ["G"] = 0, ["B"] = 1, ["O"] = 1,
					["TR"] = 1, ["TG"] = 0, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 85, ["radio"] = 1, ["bright"] = 1.0 },
			},
			{
				["name"] = "STATUS_THREAT",
				["mine"] = true, ["icon"] = 2,
				["color"] = {
					["R"] = 0, ["G"] = 1, ["B"] = 1, ["O"] = 1,
					["TR"] = 0, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
					["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
					["isManuallySet"] = true,
				},
				["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0	},
			},
		},
	},
};



VUHDO_DEFAULT_BACKGROUND_BOUQUETS = {
	[VUHDO_I18N_DEF_BAR_BACKGROUND_SOLID] = {
		{
			["name"] = "DISCONNECTED",
			["mine"] = true, ["icon"] = 2,
			["color"] = {
				["R"] = 0.298, ["G"] = 0.298, ["B"] = 0.298, ["O"] = 0.21,
				["TR"] = 0.576, ["TG"] = 0.576, ["TB"] = 0.576,
				["TO"] = 0.58, ["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
		{
			["name"] = "NO_RANGE",
			["mine"] = true, ["icon"] = 2,
			["color"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
				["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.25,
				["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
		{
			["name"] = "DEBUFF_BAR_COLOR",
			["mine"] = true, ["icon"] = 1,
			["color"] = {
				["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
				["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 0.4 },
		},
		{
			["name"] = "ALWAYS",
			["mine"] = true, ["icon"] = 1,
			["color"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.7,
				["TR"] = 0.1, ["TG"] = 0.1, ["TB"] = 0.1, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
	},


	[VUHDO_I18N_DEF_BAR_BACKGROUND_CLASS_COLOR] = {
		{
			["name"] = "DISCONNECTED",
			["mine"] = true, ["icon"] = 2,
			["color"] = {
				["R"] = 0.298, ["G"] = 0.298, ["B"] = 0.298, ["O"] = 0.21,
				["TR"] = 0.576, ["TG"] = 0.576, ["TB"] = 0.576,
				["TO"] = 0.58, ["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
		{
			["name"] = "NO_RANGE",
			["mine"] = true, ["icon"] = 1,
			["color"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.25,
				["TR"] = 0, ["TG"] = 0, ["TB"] = 0, ["TO"] = 0.25,
				["useText"] = false, ["useBackground"] = false, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
		{
			["name"] = "DEBUFF_BAR_COLOR",
			["mine"] = true, ["icon"] = 1,
			["color"] = {
				["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
				["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1.0 },
		},
		{
			["name"] = "CLASS_COLOR",
			["mine"] = true, ["icon"] = 1,
			["color"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 0, ["O"] = 0.7,
				["TR"] = 0.1, ["TG"] = 0.1, ["TB"] = 0.1, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 0.4 },
		},
	},
}


VUHDO_DEFAULT_ALTERNATE_POWERS_BOUQUET = {
	[VUHDO_I18N_DEF_ALTERNATE_POWERS] = {
		{
			["name"] = "ALTERNATE_POWERS_ABOVE",
			["mine"] = true, ["icon"] = 2,
			["color"] = {
				["R"] = 1, ["G"] = 0, ["B"] = 0, ["O"] = 1,
				["TR"] = 1, ["TG"] = 0, ["TB"] = 0, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 80, ["radio"] = 2, ["bright"] = 1 },
		},
		{
			["name"] = "ALTERNATE_POWERS_ABOVE",
			["mine"] = true, ["icon"] = 2,
			["color"] = {
				["R"] = 1, ["G"] = 1, ["B"] = 0, ["O"] = 1,
				["TR"] = 1, ["TG"] = 1, ["TB"] = 0, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 50, ["radio"] = 2, ["bright"] = 1 },
		},
		{
			["name"] = "STATUS_ALTERNATE_POWERS",
			["mine"] = true, ["icon"] = 1,
			["color"] = {
				["R"] = 0, ["G"] = 1, ["B"] = 0, ["O"] = 1,
				["TR"] = 0, ["TG"] = 1, ["TB"] = 0, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1	},
		},
	},
}



VUHDO_DEFAULT_HOLY_POWER_BOUQUET = {
	[VUHDO_I18N_DEF_PLAYER_HOLY_POWER] = {
		{
			["name"] = "OWN_HOLY_POWER_EQUALS",
			["mine"] = true, ["icon"] = 12,
			["color"] = {
				["R"] = 0.6, ["G"] = 1, ["B"] = 0.6, ["O"] = 1,
				["TR"] = 0.6, ["TG"] = 1, ["TB"] = 0.6, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 3, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "OWN_HOLY_POWER_EQUALS",
			["mine"] = true, ["icon"] = 11,
			["color"] = {
				["R"] = 1, ["G"] = 1, ["B"] = 0.4, ["O"] = 1,
				["TR"] = 1, ["TG"] = 1, ["TB"] = 0.4, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 2, ["radio"] = 1, ["bright"] = 1	},
		},
		{
			["name"] = "OWN_HOLY_POWER_EQUALS",
			["mine"] = true, ["icon"] = 10,
			["color"] = {
				["R"] = 1, ["G"] = 0.4, ["B"] = 0.4, ["O"] = 1,
				["TR"] = 1, ["TG"] = 0.4, ["TB"] = 0.4, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1, ["bright"] = 1	},
		},
	},
}



VUHDO_DEFAULT_ROLE_ICON_BOUQUET = {
	[VUHDO_I18N_DEF_ROLE_ICON] = {
		{
			["name"] = "ROLE_ICON",
			["mine"] = true, ["icon"] = 1,
			["color"] = {
				["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
				["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
}



VUHDO_DEFAULT_AOE_ADVICE_BOUQUET = {
	[VUHDO_I18N_DEF_AOE_ADVICE] = {
		{
			["name"] = "AOE_ADVICE",
			["mine"] = true, ["icon"] = 1,
			["color"] = {
				["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
				["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
}



VUHDO_DEFAULT_DIRECTION_ARROW_BOUQUET = {
	[VUHDO_I18N_DEF_DIRECTION_ARROW] = {
		{
			["name"] = "DIRECTION",
			["mine"] = true, ["icon"] = 1,
			["color"] = {
				["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
				["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 3, ["radio"] = 2, ["bright"] = 1 },
		},
	},
}



VUHDO_DEFAULT_WRACK_BOUQUET = {
	[VUHDO_I18N_DEF_WRACK] = {
		{
			["name"] = "DURATION_ABOVE",
			["mine"] = true, ["icon"] = 9,
			["color"] = {
				["R"] = 1, ["G"] = 0, ["B"] = 0, ["O"] = 1,
				["TR"] = 1, ["TG"] = 0, ["TB"] = 0, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 10, ["radio"] = 2, ["bright"] = 1 },
		},
		{
			["name"] = "DURATION_ABOVE",
			["mine"] = true, ["icon"] = 8,
			["color"] = {
				["R"] = 1, ["G"] = 1, ["B"] = 0, ["O"] = 1,
				["TR"] = 1, ["TG"] = 1, ["TB"] = 0, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 8, ["radio"] = 2, ["bright"] = 1 },
		},

		{
			["name"] = GetSpellInfo(89421), -- "Wrack",
			["mine"] = true, ["others"] = true,	["icon"] = 1, ["alive"] = true,
			["color"] = {
				["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
				["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 1, ["radio"] = 1,	["bright"] = 1.0 },
		},

	},
}



VUHDO_DEFAULT_TANKS_CDS_EXTD_BOUQUET = {
	[VUHDO_I18N_DEF_TANK_CDS_EXTENDED] = {
	},
}



--
VUHDO_DEFAULT_GRID_BOUQUETS = {
		[VUHDO_I18N_GRID_MOUSEOVER_SINGLE] = {
			{
				["name"] = "MOUSE_TARGET",
				["color"] = {
					["TG"] = 1,
					["R"] = 0.6196078431372549,
					["TB"] = 1,
					["G"] = 0.5411764705882353,
					["TR"] = 1,
					["isManuallySet"] = true,
					["TO"] = 0.75,
					["B"] = 0.1843137254901961,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 0.6,
					["useOpacity"] = true,
				},
				["custom"] = {
					1, -- [1]
					["bright"] = 1,
					["radio"] = 1,
				},
				["icon"] = 2,
				["mine"] = true,
			}, -- [1]
		},
		[VUHDO_I18N_GRID_BACKGROUND_BAR] = {
			{
				["name"] = "DISCONNECTED",
				["color"] = {
					["TG"] = 0.576,
					["R"] = 0.298,
					["TB"] = 0.576,
					["G"] = 0.298,
					["TR"] = 0.576,
					["isManuallySet"] = true,
					["TO"] = 0.58,
					["B"] = 0.298,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 0.21,
					["useOpacity"] = true,
				},
				["custom"] = {
					1, -- [1]
					["bright"] = 1,
					["radio"] = 1,
				},
				["icon"] = 2,
				["mine"] = true,
			}, -- [1]
			{
				["name"] = "NO_RANGE",
				["color"] = {
					["TG"] = 0,
					["R"] = 0,
					["TB"] = 0,
					["G"] = 0,
					["TR"] = 0,
					["isManuallySet"] = true,
					["TO"] = 0.25,
					["B"] = 0,
					["useBackground"] = false,
					["useText"] = false,
					["O"] = 0.25,
					["useOpacity"] = true,
				},
				["custom"] = {
					1, -- [1]
					["bright"] = 1,
					["radio"] = 1,
				},
				["icon"] = 1,
				["mine"] = true,
			}, -- [2]
			{
				["name"] = "CLASS_COLOR",
				["color"] = {
					["TG"] = 0.1,
					["R"] = 0,
					["TB"] = 0.1,
					["G"] = 0,
					["TR"] = 0.1,
					["isManuallySet"] = true,
					["TO"] = 1,
					["B"] = 0,
					["useBackground"] = true,
					["useText"] = true,
					["O"] = 0.7,
					["useOpacity"] = true,
				},
				["custom"] = {
					1, -- [1]
					["bright"] = 0.2000000029802322,
					["radio"] = 1,
				},
				["icon"] = 1,
				["mine"] = true,
			}, -- [3]
		},
}



--
VUHDO_DEFAULT_ROLE_COLOR_BOUQUET = {
	[VUHDO_I18N_DEF_ROLE_COLOR] = {
		{
			["name"] = "ROLE_TANK",
			["icon"] = 6,
			["color"] = {
				["R"] = 0, ["G"] = 0, ["B"] = 1, ["O"] = 1,
				["TR"] = 0, ["TG"] = 0, ["TB"] = 1, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 0, ["radio"] = 1, ["bright"] = 1 },
		},
		{
			["name"] = "ROLE_DAMAGE",
			["icon"] = 6,
			["color"] = {
				["R"] = 1, ["G"] = 0, ["B"] = 0, ["O"] = 1,
				["TR"] = 1, ["TG"] = 0, ["TB"] = 0, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 0, ["radio"] = 1, ["bright"] = 1	},
		},
		{
			["name"] = "ROLE_HEALER",
			["icon"] = 6,
			["color"] = {
				["R"] = 0, ["G"] = 1, ["B"] = 0, ["O"] = 1,
				["TR"] = 0, ["TG"] = 1, ["TB"] = 0, ["TO"] = 1,
				["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
				["isManuallySet"] = true,
			},
			["custom"] = { [1] = 0, ["radio"] = 1, ["bright"] = 1	},
		},
	},
}



--
VUHDO_DEFAULT_INDICATOR_CONFIG = {
	["BOUQUETS"] = {
		["AGGRO_BAR"] = "",
		["BACKGROUND_BAR"] = VUHDO_I18N_DEF_BAR_BACKGROUND_SOLID,
		["BAR_BORDER"] = VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI_AGGRO,
		["CLUSTER_BORDER"] = "",
		["DAMAGE_FLASH_BAR"] = "",
		["HEALTH_BAR"] = VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH,
		["HEALTH_BAR_PANEL"] = {
			[1] = "",
			[2] = "",
			[3] = "",
			[4] = "",
			[5] = "",
			[6] = "",
			[7] = "",
			[8] = "",
			[9] = "",
			[10] = "",
		},
		["INCOMING_BAR"] = "",
		["MANA_BAR"] = VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ONLY,
		["MOUSEOVER_HIGHLIGHT"] = "",
		["SWIFTMEND_INDICATOR"] = "",
		["THREAT_BAR"] = "",
		["THREAT_MARK"] = "",
		["SIDE_LEFT"] = "",
		["SIDE_RIGHT"] = "",
	},

	["CUSTOM"] = {
		["AGGRO_BAR"] = {
			["TEXTURE"] = "VuhDo - Polished Wood",
		},
		["BACKGROUND_BAR"] = {
			["TEXTURE"] = "VuhDo - Minimalist",
		},
		["BAR_BORDER"] = {
			["WIDTH"] = 1,
			["FILE"] = "Interface\\AddOns\\VuhDo\\Images\\white_square_16_16",
			["ADJUST"] = 0.000001,
		},
		["CLUSTER_BORDER"] = {
			["WIDTH"] = 2,
			["FILE"] = "Interface\\AddOns\\VuhDo\\Images\\white_square_16_16",
		},
		["MANA_BAR"] = {
			["TEXTURE"] = "VuhDo - Pipe, light",
			["invertGrowth"] = false,
			["turnAxis"] = false,
		},
		["MOUSEOVER_HIGHLIGHT"] = {
			["TEXTURE"] = "VuhDo - Aluminium",
		},
		["SWIFTMEND_INDICATOR"] = {
			["SCALE"] = 1,
		},
		["THREAT_BAR"] = {
			["HEIGHT"] = 4,
			["WARN_AT"] = 85,
			["TEXTURE"] = "VuhDo - Polished Wood",
			["invertGrowth"] = false,
			["turnAxis"] = false,
		},
		["HEALTH_BAR"] = {
			["invertGrowth"] = false,
			["vertical"] = false,
			["turnAxis"] = false,
		},
		["SIDE_LEFT"] = {
			["TEXTURE"] = "VuhDo - Plain White",
			["invertGrowth"] = false,
			["vertical"] = true,
			["turnAxis"] = false,
		},
		["SIDE_RIGHT"] = {
			["TEXTURE"] = "VuhDo - Plain White",
			["invertGrowth"] = false,
			["vertical"] = true,
			["turnAxis"] = false,
		},
	}
}



VUHDO_SANE_BOUQUET_ITEM = {
	["name"] = VUHDO_I18N_BOUQUET_NEW_ITEM_NAME,
	["mine"] = true,
	["others"] = true,
	["icon"] = 2,
	["color"] = {
		["R"] = 1, ["G"] = 1, ["B"] = 1, ["O"] = 1,
		["TR"] = 1, ["TG"] = 1, ["TB"] = 1, ["TO"] = 1,
		["useText"] = true, ["useBackground"] = true, ["useOpacity"] = true,
		["isManuallySet"] = false,
	},
	["custom"] = {
		[1] = 1,
		["radio"] = 1,
		["bright"] = 1.0,
	},
};


local pairs = pairs;

--
local tKey, tValue;
local function VUHDO_addDefaultBouquet(aName)
	if (aName == nil) then
		return;
	end
	aName = VUHDO_decompressIfCompressed(aName);
	for tKey, tValue in pairs(aName) do
		VUHDO_BOUQUETS["STORED"][tKey] = VUHDO_deepCopyTable(aName[tKey]);
	end
end



--
local tCopy;
local function VUHDO_deepCopyColor(aColorTable)
	tCopy = VUHDO_deepCopyTable(aColorTable);
	tCopy["R"] = tCopy["R"] or 1;
	tCopy["G"] = tCopy["G"] or 1;
	tCopy["B"] = tCopy["B"] or 1;
	tCopy["O"] = tCopy["O"] or 1;
	tCopy["TR"] = tCopy["TR"] or 1;
	tCopy["TG"] = tCopy["TG"] or 1;
	tCopy["TB"] = tCopy["TB"] or 1;
	tCopy["TO"] = tCopy["TO"] or 1;
	return tCopy;
end



--
local function VUHDO_createBouquetItem(anEvent, aColor)
	local tItem = VUHDO_deepCopyTable(VUHDO_SANE_BOUQUET_ITEM);
	tItem["name"] = anEvent;
	if (aColor ~= nil) then
		tItem["color"] = VUHDO_deepCopyColor(aColor);
	end
	tItem["color"]["isManuallySet"] = true;
	return tItem;
end



--
local tItem;
local tBouquet;
local tTextColor;
local tColor;
local function _VUHDO_buildGenericHealthBarBouquet(aType, aName)
	tBouquet = { };

	-- Disconnected
	tItem = VUHDO_createBouquetItem("DISCONNECTED", VUHDO_PANEL_SETUP["BAR_COLORS"]["OFFLINE"]);
	tBouquet[1] = tItem;

	-- Out of Range
	tColor = VUHDO_PANEL_SETUP["BAR_COLORS"]["OUTRANGED"];
	if (tColor["useText"] or tColor["useBackground"] or tColor["useOpacity"]) then
		tItem = VUHDO_createBouquetItem("NO_RANGE", tColor);
		tBouquet[#tBouquet + 1] = tItem;
	end

	-- Resurrection
	tItem = VUHDO_createBouquetItem("RESURRECTION", { ["TR"] = 0.4, ["TG"] = 1, ["TB"] = 0.4, ["useText"] = true });
	tBouquet[#tBouquet + 1] = tItem;

	-- Dead
	tItem = VUHDO_createBouquetItem("DEAD", VUHDO_PANEL_SETUP["BAR_COLORS"]["DEAD"]);
	tBouquet[#tBouquet + 1] = tItem;


	-- Overheal Erheller
	if (VUHDO_CONFIG["SHOW_OVERHEAL"]) then
		tItem = VUHDO_createBouquetItem("OVERHEAL_HIGHLIGHT", nil);
		tBouquet[#tBouquet + 1] = tItem;
	end

	-- Debuff Color
	tItem = VUHDO_createBouquetItem("DEBUFF_BAR_COLOR", nil);
	tBouquet[#tBouquet + 1] = tItem;


	-- Raid Icon color
	if (VUHDO_PANEL_SETUP["BAR_COLORS"]["RAID_ICONS"]["enable"] and VUHDO_PANEL_SETUP["BAR_COLORS"]["RAID_ICONS"]["enable"]) then
		tItem = VUHDO_createBouquetItem("RAID_ICON_COLOR", nil);
		tBouquet[#tBouquet + 1] = tItem;
	end

	if (VUHDO_CONFIG["MODE"] == VUHDO_MODE_NEUTRAL) then

		-- Irrelevant
		if (VUHDO_CONFIG["EMERGENCY_TRIGGER"] < 100) then
			tItem = VUHDO_createBouquetItem("HEALTH_ABOVE", VUHDO_PANEL_SETUP["BAR_COLORS"]["IRRELEVANT"]);
			tItem["custom"][1] = VUHDO_CONFIG["EMERGENCY_TRIGGER"];
			tBouquet[#tBouquet + 1] = tItem;
		end

		-- Health Bar Texts
		if (VUHDO_PANEL_SETUP["PANEL_COLOR"]["classColorsName"]) then
			tItem = VUHDO_createBouquetItem("CLASS_COLOR", nil);
			tItem["color"]["useBackground"] = false;
			tItem["color"]["useOpacity"] = false;
			tBouquet[#tBouquet + 1] = tItem;
		else
			tTextColor = VUHDO_PANEL_SETUP["PANEL_COLOR"]["TEXT"];
			tItem = VUHDO_createBouquetItem("ALWAYS", tTextColor);
			tItem["color"]["useBackground"] = false;
			tItem["color"]["useOpacity"] = false;
			tBouquet[#tBouquet + 1] = tItem;
		end

		-- Health Bar
		if (aType == 0) then
			tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["GOOD"]);
			tItem["color"]["useOpacity"] = true;
			tItem["custom"]["grad_med"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["FAIR"]);
			tItem["custom"]["grad_med"]["useOpacity"] = true;
			tItem["custom"]["grad_low"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["LOW"]);
			tItem["custom"]["grad_low"]["useOpacity"] = true;
			tItem["custom"]["radio"] = 3; -- gradient
		elseif (aType == 1) then
			tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["PANEL_COLOR"]["BARS"]);
			tItem["custom"]["radio"] = 2; -- class color
		else -- Solid == 2, Chimaeron == 3
			tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["PANEL_COLOR"]["BARS"]);
			tItem["custom"]["radio"] = 1; -- solid
		end

		tItem["color"]["mode"] = nil;
		tBouquet[#tBouquet + 1] = tItem;

	else
		if (VUHDO_PANEL_SETUP["PANEL_COLOR"]["classColorsName"]) then
			tItem = VUHDO_createBouquetItem("CLASS_COLOR", nil);
			tItem["color"]["useBackground"] = false;
			tItem["color"]["useOpacity"] = false;
			tBouquet[#tBouquet + 1] = tItem;
		end

		-- Emergency
		tItem = VUHDO_createBouquetItem("EMERGENCY_COLOR", VUHDO_PANEL_SETUP["BAR_COLORS"]["EMERGENCY"]);
		tItem["custom"][1] = VUHDO_CONFIG["EMERGENCY_TRIGGER"];
		tBouquet[#tBouquet + 1] = tItem;

		-- No Emergency Bar
		tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["BAR_COLORS"]["NO_EMERGENCY"]);
		tItem["custom"]["radio"] = 1; -- solid
		tBouquet[#tBouquet + 1] = tItem;
	end

	VUHDO_BOUQUETS["STORED"][aName] = tBouquet;
end



--
function VUHDO_buildGenericHealthBarBouquet()
	_VUHDO_buildGenericHealthBarBouquet(0, VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH);
	_VUHDO_buildGenericHealthBarBouquet(1, VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_CLASS_COLOR);
	_VUHDO_buildGenericHealthBarBouquet(2, VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_SOLID);
end



--
local tBouquet;
function VUHDO_buildGenericTargetHealthBouquet()
	tBouquet = { };

	-- Disconnected
	tItem = VUHDO_createBouquetItem("DISCONNECTED", VUHDO_PANEL_SETUP["BAR_COLORS"]["OFFLINE"]);
	tBouquet[1] = tItem;

	-- Out of Range
	tColor = VUHDO_PANEL_SETUP["BAR_COLORS"]["OUTRANGED"];
	if (tColor["useText"] or tColor["useBackground"] or tColor["useOpacity"]) then
		tItem = VUHDO_createBouquetItem("NO_RANGE", tColor);
		tBouquet[#tBouquet + 1] = tItem;
	end

	-- Dead
	tItem = VUHDO_createBouquetItem("DEAD", VUHDO_PANEL_SETUP["BAR_COLORS"]["DEAD"]);
	tBouquet[#tBouquet + 1] = tItem;

	-- Tapped
	tItem = VUHDO_createBouquetItem("TAPPED", VUHDO_PANEL_SETUP["BAR_COLORS"]["TAPPED"]);
	tBouquet[#tBouquet + 1] = tItem;

	-- Raid Icon color
	if (VUHDO_PANEL_SETUP["BAR_COLORS"]["RAID_ICONS"]["enable"] and VUHDO_PANEL_SETUP["BAR_COLORS"]["RAID_ICONS"]["enable"]) then
		tItem = VUHDO_createBouquetItem("RAID_ICON_COLOR", nil);
		tBouquet[#tBouquet + 1] = tItem;
	end

	-- 1=enemy, 2=solid, 3=class color, 4=gradient
	-- Health Bar Texts
	if (VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]["modeText"] == 1) then
		tItem = VUHDO_createBouquetItem("ENEMY_STATE", nil);
		tItem["color"]["useBackground"] = false;
		tItem["color"]["useOpacity"] = false;
		tBouquet[#tBouquet + 1] = tItem;
	elseif (VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]["modeText"] == 2) then
		tTextColor = VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"];
		tItem = VUHDO_createBouquetItem("ALWAYS", tTextColor);
		tItem["color"]["useBackground"] = false;
		tItem["color"]["useOpacity"] = false;
		tBouquet[#tBouquet + 1] = tItem;
	elseif (VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]["modeText"] == 3) then
		tItem = VUHDO_createBouquetItem("CLASS_COLOR", nil);
		tItem["color"]["useBackground"] = false;
		tItem["color"]["useOpacity"] = false;
		tBouquet[#tBouquet + 1] = tItem;
	end

	if (VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]["modeBack"] == 1) then
		tItem = VUHDO_createBouquetItem("ENEMY_STATE", nil);
		tItem["custom"]["radio"] = 1; -- solid
		tBouquet[#tBouquet + 1] = tItem;

		tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]);
		tItem["custom"]["radio"] = 1; -- solid
	elseif (VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]["modeBack"] == 2) then
		tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]);
		tItem["custom"]["radio"] = 1; -- solid
	elseif (VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]["modeBack"] == 3) then
		tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["BAR_COLORS"]["TARGET"]);
		tItem["custom"]["radio"] = 2; -- class color
	else
		tItem = VUHDO_createBouquetItem("STATUS_HEALTH", VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["GOOD"]);
		tItem["color"]["useOpacity"] = true;
		tItem["custom"]["grad_med"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["FAIR"]);
		tItem["custom"]["grad_med"]["useOpacity"] = true;
		tItem["custom"]["grad_low"] = VUHDO_deepCopyColor(VUHDO_PANEL_SETUP["BAR_COLORS"]["LIFE_LEFT"]["LOW"]);
		tItem["custom"]["grad_low"]["useOpacity"] = true;
		tItem["custom"]["radio"] = 3; -- gradient
	end

	tBouquet[#tBouquet + 1] = tItem;
	VUHDO_BOUQUETS["STORED"][VUHDO_I18N_DEF_BOUQUET_TARGET_HEALTH] = tBouquet;
end



--
local function VUHDO_AddSpellBouquetItem(aBouquetName, ...)
	local tCnt;
	local tId, tNewItem;
	for tCnt = 1, select("#", ...) do
		tId = select(tCnt, ...);
		tNewItem = VUHDO_deepCopyTable(VUHDO_SANE_BOUQUET_ITEM);
		tName = GetSpellInfo(tId);
		tNewItem["name"] = tName;
		tNewItem["icon"] = 1;
		tNewItem["color"]["isManuallySet"] = true;
		tinsert(VUHDO_BOUQUETS["STORED"][aBouquetName], tNewItem);
	end

	return tNewItem;
end



--
local tSpecial;
local tItem;
local function VUHDO_ensureBouquetItemSanity(aName, anIndex)
	VUHDO_BOUQUETS["STORED"][aName][anIndex] = VUHDO_ensureSanity(
		"VUHDO_BOUQUETS.STORED",
		VUHDO_BOUQUETS["STORED"][aName][anIndex],
		VUHDO_SANE_BOUQUET_ITEM
	);

	tItem = VUHDO_BOUQUETS["STORED"][aName][anIndex];
	if (tItem["custom"]["radio"] == 3) then
		if (tItem["custom"]["grad_med"] == nil) then
			tItem["custom"]["grad_med"]  = {
				["R"] = 0.6, ["G"] = 0.6, ["B"] = 0.6, ["O"] = 1,
				["TR"] = 0.6, ["TG"] = 0.6, ["TB"] = 0.6, ["TO"] = 1,
				["useText"] = false, ["useBackground"] = true, ["useOpacity"] = true,
			};
		end

		if (tItem["custom"]["grad_low"] == nil) then
			tItem["custom"]["grad_low"] = {
				["R"] = 0.3, ["G"] = 0.3, ["B"] = 0.3, ["O"] = 1,
				["TR"] = 0.3, ["TG"] = 0.3, ["TB"] = 0.3, ["TO"] = 1,
				["useText"] = false, ["useBackground"] = true, ["useOpacity"] = true,
			};
		end

		tSpecial = VUHDO_BOUQUET_BUFFS_SPECIAL[tItem["name"]]; -- Statusbalken haben keine Textfarbe
		if (tSpecial ~= nil and tSpecial["custom_type"] == VUHDO_BOUQUET_CUSTOM_TYPE_STATUSBAR) then
			tItem["color"].TR, tItem["color"].TG, tItem["color"].TB, tItem["color"].useText = nil, nil, nil, false;
			tItem["custom"]["grad_med"].TR, tItem["custom"]["grad_med"].TG, tItem["custom"]["grad_med"].TB, tItem["custom"]["grad_med"].useText = nil, nil, nil, false;
			tItem["custom"]["grad_low"].TR, tItem["custom"]["grad_low"].TG, tItem["custom"]["grad_low"].TB, tItem["custom"]["grad_low"].useText = nil, nil, nil, false;
		end

	else -- kein gradient
		tItem["custom"]["grad_med"] = nil;
		tItem["custom"]["grad_low"] = nil;
	end
end



--
local tName, tAllInfos, tIndex, tInfo;
function VUHDO_ensureAllBouquetItemsSanity()
	VUHDO_decompressAllBouquets();

	for tName, tAllInfos in pairs(VUHDO_BOUQUETS["STORED"]) do

		if (tAllInfos == nil or "table" ~= type(tAllInfos)) then
			VUHDO_BOUQUETS["STORED"][tName] = { };
		end

		for tIndex, tInfo in pairs(VUHDO_BOUQUETS["STORED"][tName]) do
			tInfo["name"] = strtrim(tInfo["name"] or "");
			if (tInfo["name"] == "") then
				tremove(tAllInfos, tIndex);
			else
				VUHDO_ensureBouquetItemSanity(tName, tIndex);
			end
		end
	end
end



--
function VUHDO_loadDefaultBouquets()
	if (VUHDO_BOUQUETS == nil) then
		VUHDO_BOUQUETS = VUHDO_decompressOrCopy(VUHDO_DEFAULT_BOUQUETS);
	end
	VUHDO_DEFAULT_BOUQUETS = VUHDO_compressTable(VUHDO_DEFAULT_BOUQUETS);

	if (VUHDO_BOUQUETS["VERSION"] < 2) then
		VUHDO_BOUQUETS["VERSION"] = 2;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_BACKGROUND_BOUQUETS);
	end
	VUHDO_DEFAULT_BACKGROUND_BOUQUETS = nil;

	if (VUHDO_BOUQUETS["VERSION"] < 3) then
		VUHDO_BOUQUETS["VERSION"] = 3;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_ALTERNATE_POWERS_BOUQUET);
	end
	VUHDO_DEFAULT_ALTERNATE_POWERS_BOUQUET = nil;

	if (VUHDO_BOUQUETS["VERSION"] < 4) then
		VUHDO_BOUQUETS["VERSION"] = 4;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_TANKS_CDS_EXTD_BOUQUET);

		VUHDO_AddSpellBouquetItem(VUHDO_I18N_DEF_TANK_CDS_EXTENDED,
			49222, --Bone Shield
			48792, --Icebound Fortitude
			55233, --Vampiric Blood
			48707, --Anti-Magic Shell
			50461, --Anti-Magic Zone

			642, --Divine Shield
			498, --Divine Protection
			31850, --Ardent Defender
			1022, --Hand of Protection
			6940, --Hand of Sacrifice
			70940, --Divine Guardian
			64205, --Divine Sacrifine
			86659, --Ancient Guardian

			871, --Shield Wall
			2565, --Shield Block
			12975, --Last Stand
			3411, --Intervene
			55694, --Enraged Regeneration

			22812, --Barkskin
			61336, --Survival Instincts
			22842 --Frenzied Regeneration
		);

	end
	if (VUHDO_BOUQUETS["VERSION"] < 5) then
		VUHDO_BOUQUETS["VERSION"] = 5;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_HOLY_POWER_BOUQUET);
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_ROLE_ICON_BOUQUET);
	end
	VUHDO_DEFAULT_HOLY_POWER_BOUQUET = nil;
	VUHDO_DEFAULT_ROLE_ICON_BOUQUET = nil;

	if (VUHDO_BOUQUETS["VERSION"] < 6) then
		VUHDO_BOUQUETS["VERSION"] = 6;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_AOE_ADVICE_BOUQUET);
	end
	VUHDO_DEFAULT_AOE_ADVICE_BOUQUET = nil;

	if (VUHDO_BOUQUETS["VERSION"] < 7) then
		VUHDO_BOUQUETS["VERSION"] = 7;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_WRACK_BOUQUET);
	end
	VUHDO_DEFAULT_WRACK_BOUQUET = nil;

	if (VUHDO_BOUQUETS["VERSION"] < 8) then
		VUHDO_BOUQUETS["VERSION"] = 8;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_DIRECTION_ARROW_BOUQUET);
	end
	VUHDO_DEFAULT_DIRECTION_ARROW_BOUQUET = nil;

	if (VUHDO_BOUQUETS["VERSION"] < 9) then
		VUHDO_BOUQUETS["VERSION"] = 9;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_GRID_BOUQUETS);
	end
	VUHDO_DEFAULT_GRID_BOUQUETS = nil;

	if (VUHDO_BOUQUETS["VERSION"] < 10) then
		VUHDO_BOUQUETS["VERSION"] = 10;
		VUHDO_addDefaultBouquet(VUHDO_DEFAULT_ROLE_COLOR_BOUQUET);
	end
	VUHDO_DEFAULT_ROLE_COLOR_BOUQUET = nil;

	VUHDO_buildGenericHealthBarBouquet();
	VUHDO_buildGenericTargetHealthBouquet();

	if (VUHDO_INDICATOR_CONFIG == nil) then
		VUHDO_INDICATOR_CONFIG = VUHDO_decompressOrCopy(VUHDO_DEFAULT_INDICATOR_CONFIG);

		if ("DRUID" == VUHDO_PLAYER_CLASS) then
			VUHDO_INDICATOR_CONFIG["BOUQUETS"]["SWIFTMEND_INDICATOR"] = VUHDO_I18N_DEF_BOUQUET_SWIFTMENDABLE;
		else
			VUHDO_INDICATOR_CONFIG["BOUQUETS"]["SWIFTMEND_INDICATOR"] = VUHDO_I18N_DEF_ROLE_ICON;
		end
	end

	VUHDO_ensureSanity("VUHDO_INDICATOR_CONFIG", VUHDO_INDICATOR_CONFIG, VUHDO_DEFAULT_INDICATOR_CONFIG);
	VUHDO_DEFAULT_INDICATOR_CONFIG = VUHDO_compressTable(VUHDO_DEFAULT_INDICATOR_CONFIG);
	VUHDO_ensureAllBouquetItemsSanity();
end
