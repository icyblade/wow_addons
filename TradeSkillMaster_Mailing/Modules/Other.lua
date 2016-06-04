-- ------------------------------------------------------------------------------ --
--                            TradeSkillMaster_Mailing                            --
--            http://www.curse.com/addons/wow/tradeskillmaster_mailing            --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...)
local Other = TSM:NewModule("Other", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Mailing") -- loads the localization table
local private = { frame = nil }


function Other:CreateTab()
	local BFC = TSMAPI.GUI:GetBuildFrameConstants()
	local frameInfo = {
		type = "Frame",
		key = "otherTab",
		hidden = true,
		points = "ALL",
		scripts = { "OnShow" },
		children = {
			{
				type = "Frame",
				key = "deBox",
				size = { 0, 80 },
				points = { { "TOPLEFT", 5, -5 }, { "TOPRIGHT", -5, -5 } },
				children = {
					{
						type = "Text",
						text = L["Mail Disenchantables"],
						textSize = "normal",
						justify = { "CENTER", "TOP" },
						size = { 0, 20 },
						points = { { "TOPLEFT", 5, -5 }, { "TOPRIGHT", -5, -5 } },
					},
					{
						type = "Text",
						text = L["Target Player:"],
						textSize = "small",
						justify = { "LEFT", "MIDDLE" },
						size = { 0, 20 },
						points = { { "TOPLEFT", 5, -30 } },
					},
					{
						type = "InputBox",
						key = "targetBox",
						text = TSM.db.factionrealm.deMailTarget,
						tooltip = L["Enter name of the character disenchantable items should be sent to."] .. "\n\n" .. TSM.SPELLING_WARNING,
						size = { 0, 20 },
						points = { { "TOPLEFT", BFC.PREV, "TOPRIGHT", 5, 0 }, { "TOPRIGHT", -5, -30 } },
						scripts = { "OnEnterPressed" },
					},
					{
						type = "Button",
						key = "btn",
						text = "",
						textHeight = 15,
						tooltip = L["Click this button to send all disenchantable items in your bags to the specified character. You can set the maximum quality to be sent in the options."],
						size = { 0, 20 },
						points = { { "TOPLEFT", 5, -55 }, { "TOPRIGHT", -5, -55 } },
						scripts = { "OnClick" },
					},
				},
			},
			{
				type = "Frame",
				key = "sendGoldBox",
				size = { 0, 80 },
				points = { { "TOPLEFT", BFC.PREV, "BOTTOMLEFT", 0, -50 }, { "TOPRIGHT", BFC.PREV, "BOTTOMRIGHT", 0, -50 } },
				children = {
					{
						type = "Text",
						text = L["Send Excess Gold to Banker"],
						textSize = "normal",
						justify = { "CENTER", "TOP" },
						size = { 0, 20 },
						points = { { "TOPLEFT", 5, -5 }, { "TOPRIGHT", -5, -5 } },
					},
					{
						type = "Text",
						text = L["Target Player:"],
						textSize = "small",
						justify = { "LEFT", "MIDDLE" },
						size = { 0, 20 },
						points = { { "TOPLEFT", 5, -30 } },
					},
					{
						type = "InputBox",
						key = "targetBox",
						text = TSM.db.char.goldMailTarget,
						tooltip = L["Enter the name of the player you want to send excess gold to."] .. "\n\n" .. TSM.SPELLING_WARNING,
						size = { 80, 20 },
						points = { { "TOPLEFT", BFC.PREV, "TOPRIGHT", 5, 0 } },
						scripts = { "OnEnterPressed" },
					},
					{
						type = "Text",
						text = L["Limit (In Gold):"],
						textSize = "small",
						justify = { "LEFT", "MIDDLE" },
						size = { 0, 20 },
						points = { { "TOPLEFT", BFC.PREV, "TOPRIGHT", 15, 0 } },
					},
					{
						type = "InputBox",
						key = "goldBox",
						numeric = true,
						text = TSM.db.char.goldKeepAmount,
						tooltip = L["This is maximum amount of gold you want to keep on the current player. Any amount over this limit will be send to the specified character."],
						size = { 80, 20 },
						points = { { "TOPLEFT", BFC.PREV, "TOPRIGHT", 5, 0 }, { "TOPRIGHT", -5, -30 } },
						scripts = { "OnEnterPressed" },
					},
					{
						type = "Button",
						key = "btn",
						text = "",
						textHeight = 15,
						tooltip = L["Click this button to send excess gold to the specified character (Maximum of 200k per mail)."],
						size = { 0, 20 },
						points = { { "TOPLEFT", 5, -55 }, { "TOPRIGHT", -5, -55 } },
						scripts = { "OnClick" },
					},
				},
			},
		},
		handlers = {
			OnShow = function(self)
				private.frame = self
				private:UpdateDisenchantButton()
				private:UpdateSendGoldButton()

				if not self.helpBtn then
					local TOTAL_WIDTH = private.frame:GetParent():GetWidth()
					local helpPlateInfo = {
						FramePos = { x = 0, y = 70 },
						FrameSize = { width = TOTAL_WIDTH, height = private.frame:GetHeight() },
						{
							ButtonPos = { x = 100, y = -20 },
							HighLightBox = { x = 70, y = -35, width = TOTAL_WIDTH - 70, height = 30 },
							ToolTipDir = "DOWN",
							ToolTipText = L["These buttons change what is shown in the mailbox frame. You can view your inbox, automatically mail items in groups, quickly send items to other characters, and more in the various tabs."],
						},
						{
							ButtonPos = { x = 340, y = -75 },
							HighLightBox = { x = 0, y = -75, width = TOTAL_WIDTH, height = 80 },
							ToolTipDir = "RIGHT",
							ToolTipText = L["This feature makes it easy to mail all of your disenchantable items to a specific character. You can change the maximum quality of items to be sent in the options."],
						},
						{
							ButtonPos = { x = 340, y = -205 },
							HighLightBox = { x = 0, y = -205, width = TOTAL_WIDTH, height = 80 },
							ToolTipDir = "RIGHT",
							ToolTipText = L["This feature makes it easy to maintain a specific amount of gold on the current character."],
						},
					}

					self.helpBtn = CreateFrame("Button", nil, private.frame, "MainHelpPlateButton")
					self.helpBtn:SetPoint("TOPLEFT", 50, 100)
					self.helpBtn:SetScript("OnClick", function() TSM.MailTab:ToggleHelpPlate(private.frame, helpPlateInfo, self.helpBtn, true) end)
					self.helpBtn:SetScript("OnHide", function() if HelpPlate_IsShowing(helpPlateInfo) then TSM.MailTab:ToggleHelpPlate(private.frame, helpPlateInfo, self.helpBtn, false) end end)
					if not TSM.db.global.helpPlatesShown.other then
						TSM.db.global.helpPlatesShown.other = true
						TSM.MailTab:ToggleHelpPlate(private.frame, helpPlateInfo, self.helpBtn, false)
					end
				end
			end,
			deBox = {
				targetBox = {
					OnEnterPressed = function(self)
						TSM.db.factionrealm.deMailTarget = self:GetText():trim()
						self:ClearFocus()
						private:UpdateDisenchantButton()
					end,
				},
				btn = {
					OnClick = function(self)
						local target = TSM.db.factionrealm.deMailTarget
						if target == "" or target == UnitName("player") then return end
						local items = {}
						local hasItems
						for bag, slot, itemString, quantity in TSMAPI.Inventory:BagIterator() do
							if TSMAPI.Item:IsDisenchantable(itemString) and not TSMAPI.Groups:GetPath(TSMAPI.Item:ToBaseItemString(itemString, true)) and not TSMAPI.Item:IsSoulbound(bag, slot) then
								local quality = select(3, TSMAPI.Item:GetInfo(itemString))
								if (quality >= 2 and quality <= TSM.db.global.deMaxQuality) then
									items[itemString] = (items[itemString] or 0) + quantity
									hasItems = true
								end
							end
						end
						if hasItems then
							local function callback()
								TSM:Printf(L["Sent all disenchantable items to %s."], target)
								private:UpdateDisenchantButton()
							end

							self:Disable()
							self:SetText(L["Sending..."])
							TSM.AutoMail:SendItems(items, target, callback)
						end
					end,
				},
			},
			sendGoldBox = {
				targetBox = {
					OnEnterPressed = function(self)
						TSM.db.char.goldMailTarget = self:GetText():trim()
						self:ClearFocus()
						private:UpdateSendGoldButton()
					end,
				},
				goldBox = {
					OnEnterPressed = function(self)
						TSM.db.char.goldKeepAmount = tonumber(self:GetText():trim())
						self:ClearFocus()
					end,
				},
				btn = {
					OnClick = function()
						if not TSM.db.char.goldKeepAmount then
							TSM:Print(L["Not sending any gold as you either did not enter a limit or did not press enter to store the limit."])
							return
						end
						local extra = (GetMoney() - 30) - (TSM.db.char.goldKeepAmount * COPPER_PER_GOLD)
						if extra <= 0 then
							TSM:Print(L["Not sending any gold as you have less than the specified limit."])
							return
						else
							extra = min(extra, 200000 * COPPER_PER_GOLD)
						end
						SetSendMailMoney(extra)
						SendMail(TSM.db.char.goldMailTarget, L["TSM_Mailing Excess Gold"], "")
						TSM:Printf(L["Sent %s to %s."], TSMAPI:MoneyToString(extra), TSM.db.char.goldMailTarget)
					end,
				},
			},
		},
	}
	return frameInfo
end

function private:UpdateDisenchantButton()
	local btn = private.frame.deBox.btn
	if TSM.db.factionrealm.deMailTarget ~= "" then
		btn:Enable()
		btn:SetText(format(L["Send Disenchantable Items to %s"], TSM.db.factionrealm.deMailTarget))
	else
		btn:Disable()
		btn:SetText(L["No Target Player"])
	end
end

function private:UpdateSendGoldButton()
	local btn = private.frame.sendGoldBox.btn
	if TSM.db.char.goldMailTarget == "" then
		btn:Disable()
		btn:SetText(L["Not Target Specified"])
	elseif TSMAPI.Player:IsPlayer(TSM.db.char.goldMailTarget) then
		btn:Disable()
		btn:SetText(L["Target is Current Player"])
	else
		btn:Enable()
		btn:SetText(format(L["Send Excess Gold to %s"], TSM.db.char.goldMailTarget))
	end
end