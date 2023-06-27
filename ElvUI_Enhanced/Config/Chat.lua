local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)
local EE = E:GetModule("ElvUI_Enhanced")
local EDPS = E:GetModule("Enhanced_DPSLinks")

function EE:ChatOptions()
	local config = {
		type = "group",
		name = L["Chat"],
		args = {
			dpsLinks = {
				order = 1,
				type = "toggle",
				name = L["Filter DPS meters Spam"],
				desc = L["Replaces long reports from damage meters with a clickable hyperlink to reduce chat spam.\nWorks correctly only with general reports such as DPS or HPS. May fail to filter te report of other things"],
				get = function(info) return E.db.enhanced.chat.dpsLinks; end,
				set = function(info, value)
					E.db.enhanced.chat.dpsLinks = value
					EDPS:UpdateSettings()
				end
			}
		}
	}

	return config
end