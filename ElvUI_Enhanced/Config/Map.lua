local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)
local EE = E:GetModule("ElvUI_Enhanced")
local MFC = E:GetModule("Enhanced_FogClear")

function EE:MapOptions()
	local config = {
		type = "group",
		name = L["Map"],
		args = {
			fogClear ={
				order = 1,
				type = "group",
				name = L["Fog of War"],
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["ENABLE"],
						get = function(info) return E.db.enhanced.map.fogClear.enable end,
						set = function(info, value)
							E.db.enhanced.map.fogClear.enable = value
							MFC:UpdateFog()
						end
					},
					overlay = {
						order = 2,
						type = "color",
						name = L["Overlay Color"],
						hasAlpha = true,
						get = function(info)
							local t = E.db.enhanced.map.fogClear.color
							local d = P.enhanced.map.fogClear.color
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(_, r, g, b, a)
							local color = E.db.enhanced.map.fogClear.color
							color.r, color.g, color.b, color.a = r, g, b, a
							MFC:UpdateWorldMapOverlays()
						end,
						disabled = function() return not E.db.enhanced.map.fogClear.enable end
					}
				}
			}
		}
	}

	return config
end