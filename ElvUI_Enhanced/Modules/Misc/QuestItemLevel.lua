local E, L, V, P, G = unpack(ElvUI)
local M = E:GetModule("Enhanced_Misc")
local LSM = E.Libs.LSM

local _G = _G

local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetQuestItemLink = GetQuestItemLink
local GetQuestLogItemLink = GetQuestLogItemLink
local ARMOR, ENCHSLOT_WEAPON = ARMOR, ENCHSLOT_WEAPON

function M:QuestInfo_Display()
	for i = 1, MAX_NUM_ITEMS do
		local item = _G["QuestInfoItem"..i]
		local icon = _G["QuestInfoItem"..i.."IconTexture"]
		local link = item.type and (QuestInfoFrame.questLog and GetQuestLogItemLink or GetQuestItemLink)(item.type, item:GetID())

		if not item.text then
			item.text = item:CreateFontString(nil, "OVERLAY")
			item.text:FontTemplate(LSM:Fetch("font", E.db.bags.itemLevelFont), E.db.bags.itemLevelFontSize, E.db.bags.itemLevelFontOutline)
			item.text:Point("BOTTOMRIGHT", icon, -1, 2)

			if E.private.skins.blizzard.enable and E.private.skins.blizzard.quest then
				item.text:SetParent(item.backdrop)
			end
		end
		item.text:SetText("")

		if link then
			local _, _, quality, itemlevel, _, itemType = GetItemInfo(link)

			if (itemlevel and itemlevel > 1) and quality and (itemType == ENCHSLOT_WEAPON or itemType == ARMOR) then
				item.text:SetText(itemlevel)
				item.text:SetTextColor(GetItemQualityColor(quality))
			end
		end
	end
end

function M:QuestItemLevel()
	if E.db.enhanced.general.questItemLevel then
		if not self:IsHooked("QuestInfo_Display") then
			self:SecureHook("QuestInfo_Display")
		end
	end
end