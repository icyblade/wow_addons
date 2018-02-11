-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak/Detheroc/Mal'Ganis
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local SUG = TMW.SUG
local strlowerCache = TMW.strlowerCache

local _, pclass = UnitClass("Player")


local Module = SUG:NewModule("talents", SUG:GetModule("spell"))
Module.noMin = true
Module.showColorHelp = false
Module.helpText = L["SUG_TOOLTIPTITLE_GENERIC"]
Module.table = {}

function Module:OnInitialize()
	-- nothing
end
function Module:Table_Get()
	wipe(self.table)

	for tier = 1, MAX_TALENT_TIERS do
		for column = 1, NUM_TALENT_COLUMNS do
			local id, name = GetTalentInfo(tier, column, 1)
			
			local lower = name and strlowerCache[name]
			if lower then
				self.table[id] = lower
			end
		end
	end

	return self.table
end
function Module:Table_GetSorter()
	return nil
end
function Module:Entry_AddToList_1(f, id)
	local id, name, iconTexture = GetTalentInfoByID(id) -- restore case

	f.Name:SetText(name)
	f.ID:SetText(id)

	f.tooltipmethod = "SetHyperlink"
	f.tooltiparg = GetTalentLink(id)

	f.insert = name
	f.insert2 = id

	f.Icon:SetTexture(iconTexture)
end
Module.Entry_Colorize_1 = TMW.NULLFUNC



local Module = SUG:NewModule("pvptalents", SUG:GetModule("talents"))
Module.table = {}

function Module:Table_Get()
	wipe(self.table)

	for tier = 1, MAX_TALENT_TIERS do
		for column = 1, NUM_TALENT_COLUMNS do
			local id, name = GetPvpTalentInfo(tier, column, 1)
			
			local lower = name and strlowerCache[name]
			if lower then
				self.table[id] = lower
			end
		end
	end

	return self.table
end
function Module:Entry_AddToList_1(f, id)
	local id, name, iconTexture = GetPvpTalentInfoByID(id) -- restore case

	f.Name:SetText(name)
	f.ID:SetText(id)

	f.tooltipmethod = "SetHyperlink"
	f.tooltiparg = GetPvpTalentLink(id)

	f.insert = name
	f.insert2 = id

	f.Icon:SetTexture(iconTexture)
end
