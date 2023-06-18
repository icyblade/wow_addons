local E, L, V, P, G = unpack(ElvUI)
local EE = E:GetModule("ElvUI_Enhanced")

function EE:GetOptions()
	if not E.Options.args.elvuiPlugins then
		E.Options.args.elvuiPlugins = {
			order = 50,
			type = "group",
			name = "|cff00fcceE|r|cffe5e3e3lvUI |r|cff00fcceP|r|cffe5e3e3lugins|r",
			args = {}
		}
	end

	E.Options.args.elvuiPlugins.args.enhanced = {
		type = "group",
		childGroups = "tab",
		name = "|cff00fcceE|r|cffe5e3e3nhanced",
		args = {
			generalGroup = EE:GeneralOptions(),
			blizzardGroup = EE:BlizzardOptions(),
			chatGroup = EE:ChatOptions(),
			minimapGroup = EE:MinimapOptions(),
			mapGroup = EE:MapOptions(),
			namePlatesGroup = EE:NamePlatesOptions(),
			tooltipGroup = EE:TooltipOptions(),
			unitframesGroup = EE:UnitFrameOptions(),
			miscGroup = EE:MiscOptions()
		}
	}

	E.Options.args.elvuiPlugins.args.enhanced.args.generalGroup.order = 1
	E.Options.args.elvuiPlugins.args.enhanced.args.blizzardGroup.order = 2
end