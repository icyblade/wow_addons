local E, L, V, P, G = unpack(ElvUI)
local M = E:GetModule("Enhanced_Misc")

local GetNumQuestLogEntries = GetNumQuestLogEntries
local GetQuestLogTitle = GetQuestLogTitle
local HybridScrollFrame_GetOffset = HybridScrollFrame_GetOffset
local QuestLogTitleButton_Resize = QuestLogTitleButton_Resize

local function ShowLevel()
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
	local numEntries = GetNumQuestLogEntries()
	local _, questIndex, title, level, isHeader

	for i, questLogTitle in ipairs(QuestLogScrollFrame.buttons) do
		questIndex = i + scrollOffset

		if questIndex <= numEntries then
			title, level, _, _, isHeader = GetQuestLogTitle(questIndex)

			if not isHeader then
				if questLogTitle.groupMates:IsShown() then
					questLogTitle.groupMates:Hide()
					questLogTitle:SetFormattedText("|cff4F8CC9%s|r[%d] %s", questLogTitle.groupMates:GetText() or "", level, title)
				else
					questLogTitle:SetFormattedText("[%d] %s", level, title)
				end

				QuestLogTitleButton_Resize(questLogTitle)
			end
		end
	end
end

function M:QuestLevelToggle()
	local enabled = E.db.enhanced.general.showQuestLevel

	for _, questLogTitle in ipairs(QuestLogScrollFrame.buttons) do
		if enabled then
			questLogTitle.check:Point("LEFT", 5, 0)
		else
			questLogTitle.check:Point("LEFT", questLogTitle.normalText, "RIGHT", 2, 0)
		end
	end

	if enabled then
		self:SecureHook("QuestLog_Update", ShowLevel)
		self:SecureHookScript(QuestLogScrollFrameScrollBar, "OnValueChanged", ShowLevel)
	else
		self:Unhook("QuestLog_Update")
		self:Unhook(QuestLogScrollFrameScrollBar, "OnValueChanged")
	end

	QuestLog_Update()
end