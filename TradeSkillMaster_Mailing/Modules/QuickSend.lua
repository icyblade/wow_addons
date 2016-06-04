-- ------------------------------------------------------------------------------ --
--                            TradeSkillMaster_Mailing                            --
--            http://www.curse.com/addons/wow/tradeskillmaster_mailing            --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...)
local QuickSend = TSM:NewModule("QuickSend", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Mailing") -- loads the localization table
local private = {frame=nil, itemLink=nil, quantity=0, target="", cod=0}


function QuickSend:CreateTab()
	local BFC = TSMAPI.GUI:GetBuildFrameConstants()
	local frameInfo = {
		type = "Frame",
		key = "quickSendTab",
		hidden = true,
		points = "ALL",
		scripts = {"OnShow"},
		children = {
			{
				type = "Text",
				text = L["This tab allows you to quickly send any quantity of an item to another character. You can also specify a COD to set on the mail (per item)."],
				textSize = "normal",
				justify = {"LEFT", "TOP"},
				size = {0, 50},
				points = {{"TOPLEFT", 5, -5}, {"TOPRIGHT", -5, -5}},
			},
			{
				type = "HLine",
				offset = -55,
			},
			{
				type = "Text",
				text = L["Item (Drag Into Box):"],
				textSize = "small",
				justify = {"LEFT", "CENTER"},
				size = {0, 20},
				points = {{"TOPLEFT", 5, -65}},
			},
			{
				type = "InputBox",
				key = "itemBox",
				tooltip = L["Drag (or place) the item that you want to send into this editbox."],
				size = {0, 20},
				points = {{"TOPLEFT", BFC.PREV, "TOPRIGHT", 5, 0}, {"TOPRIGHT", -95, -65}},
				scripts = {"OnEditFocusGained", "OnReceiveDrag", "OnMouseDown"},
			},
			{
				type = "Button",
				key = "itemClearBtn",
				text = L["Clear"],
				textHeight = 15,
				tooltip = L["Clicking this button clears the item box."],
				size = {0, 20},
				points = {{"TOPLEFT", BFC.PREV, "TOPRIGHT", 5, 0}, {"TOPRIGHT", -5, -65}},
				scripts = {"OnClick"},
			},
			{
				type = "Text",
				text = L["Target:"],
				textSize = "small",
				justify = {"LEFT", "CENTER"},
				size = {0, 20},
				points = {{"TOPLEFT", 5, -95}},
			},
			{
				type = "InputBox",
				key = "targetBox",
				tooltip = L["Enter the name of the player you want to send this item to."].."\n\n"..TSM.SPELLING_WARNING,
				autoComplete = AUTOCOMPLETE_LIST.MAIL,
				size = {100, 20},
				points = {{"TOPLEFT", BFC.PREV, "TOPRIGHT", 5, 0}},
				scripts = {"OnEnterPressed", "OnEditFocusLost", "OnTabPressed"},
			},
			{
				type = "Text",
				text = L["Max Quantity:"],
				textSize = "small",
				justify = {"LEFT", "CENTER"},
				size = {0, 20},
				points = {{"TOPLEFT", BFC.PREV, "TOPRIGHT", 20, 0}},
			},
			{
				type = "InputBox",
				key = "qtyBox",
				numeric = true,
				text = private.quantity,
				tooltip = L["This is the maximum number of the specified item to send when you click the button below. Setting this to 0 will send ALL items."],
				size = {0, 20},
				points = {{"TOPLEFT", BFC.PREV, "TOPRIGHT", 5, 0}, {"TOPRIGHT", -5, -95}},
				scripts = {"OnEnterPressed", "OnEditFocusLost", "OnTabPressed"},
			},
			{
				type = "Text",
				text = L["COD Amount (per Item):"],
				textSize = "small",
				justify = {"LEFT", "CENTER"},
				size = {0, 20},
				points = {{"TOPLEFT", 5, -125}},
			},
			{
				type = "InputBox",
				key = "codBox",
				text = TSMAPI:MoneyToString(private.cod),
				tooltip = L["Enter the desired COD amount (per item) to send this item with. Setting this to '0c' will result in no COD being set."],
				size = {0, 20},
				points = {{"TOPLEFT", BFC.PREV, "TOPRIGHT", 5, 0}, {"TOPRIGHT", -5, -125}},
				scripts = {"OnEnterPressed"},
			},
			{
				type = "Button",
				key = "btn",
				text = "",
				textHeight = 15,
				tooltip = L["Click this button to mail the item to the specified character."].."\n\n"..TSMAPI.Design:GetInlineColor("link")..L["Shift-Click|r to leave the fields populated after sending."],
				size = {0, 40},
				points = {{"TOPLEFT", 5, -155}, {"TOPRIGHT", -5, -155}},
				scripts = {"OnClick"},
			},
		},
		handlers = {
			OnShow = function(self)
				private.frame = self
				private.frame.btn:GetFontString():SetWidth(private.frame.btn:GetWidth())
				private.frame.btn:GetFontString():SetHeight(private.frame.btn:GetHeight())
				private:UpdateSendButton()
				
				if not self.helpBtn then
					local TOTAL_WIDTH = private.frame:GetParent():GetWidth()
					local helpPlateInfo = {
						FramePos = {x = 0, y = 70},
						FrameSize = {width = TOTAL_WIDTH, height = private.frame:GetHeight()},
						{
							ButtonPos = {x = 100, y = -20},
							HighLightBox = {x = 70, y = -35, width = TOTAL_WIDTH-70, height = 30},
							ToolTipDir = "DOWN",
							ToolTipText = L["These buttons change what is shown in the mailbox frame. You can view your inbox, automatically mail items in groups, quickly send items to other characters, and more in the various tabs."],
						},
						{
							ButtonPos = {x = 340, y = -120},
							HighLightBox = {x = 0, y = -130, width = TOTAL_WIDTH, height = 30},
							ToolTipDir = "RIGHT",
							ToolTipText = L["Specify the item to be mailed here."],
						},
						{
							ButtonPos = {x = 340, y = -150},
							HighLightBox = {x = 0, y = -160, width = TOTAL_WIDTH, height = 30},
							ToolTipDir = "RIGHT",
							ToolTipText = L["Specify the target player and the maximum quantity to send."],
						},
						{
							ButtonPos = {x = 300, y = -180},
							HighLightBox = {x = 0, y = -190, width = TOTAL_WIDTH, height = 30},
							ToolTipDir = "RIGHT",
							ToolTipText = L["Optionally specify a per-item COD amount."],
						},
						{
							ButtonPos = {x = 300, y = -210},
							HighLightBox = {x = 0, y = -220, width = TOTAL_WIDTH, height = 40},
							ToolTipDir = "RIGHT",
							ToolTipText = L["Lastly, click this button to send the mail."],
						},
					}
					
					self.helpBtn = CreateFrame("Button", nil, private.frame, "MainHelpPlateButton")
					self.helpBtn:SetPoint("TOPLEFT", 50, 100)
					self.helpBtn:SetScript("OnClick", function() TSM.MailTab:ToggleHelpPlate(private.frame, helpPlateInfo, self.helpBtn, true) end)
					self.helpBtn:SetScript("OnHide", function() if HelpPlate_IsShowing(helpPlateInfo) then TSM.MailTab:ToggleHelpPlate(private.frame, helpPlateInfo, self.helpBtn, false) end end)
					if not TSM.db.global.helpPlatesShown.quickSend then
						TSM.db.global.helpPlatesShown.quickSend = true
						TSM.MailTab:ToggleHelpPlate(private.frame, helpPlateInfo, self.helpBtn, false)
					end
				end
			end,
			itemBox = {
				OnEditFocusGained = "ClearFocus",
				OnReceiveDrag = function()
					local cType, _, link = GetCursorInfo()
					if cType == "item" then
						private.frame.itemBox:SetText(link)
						private.itemLink = link
						ClearCursor()
						private:UpdateSendButton()
					end
				end,
				OnMouseDown = function()
					local cType, _, link = GetCursorInfo()
					if cType == "item" then
						private.frame.itemBox:SetText(link)
						private.itemLink = link
						ClearCursor()
						private:UpdateSendButton()
					end
				end,
			},
			itemClearBtn = {
				OnClick = function()
					private.itemLink = nil
					private.frame.itemBox:SetText("")
					private:UpdateSendButton()
				end,
			},
			targetBox = {
				OnEnterPressed = "ClearFocus",
				OnEditFocusLost = function(self)
					self:HighlightText(0, 0)
					private.target = self:GetText():trim()
					private:UpdateSendButton()
				end,
				OnTabPressed = function(self)
					self:ClearFocus()
					private.frame.qtyBox:SetFocus()
					private.frame.qtyBox:HighlightText()
				end,
			},
			qtyBox = {
				OnEnterPressed = "ClearFocus",
				OnEditFocusLost = function(self)
					self:HighlightText(0, 0)
					private.quantity = self:GetNumber()
					private:UpdateSendButton()
				end,
				OnTabPressed = function(self)
					self:ClearFocus()
					private.frame.codBox:SetFocus()
					private.frame.codBox:HighlightText()
				end,
			},
			codBox = {
				OnEnterPressed = function(self)
					local copper = TSMAPI:MoneyFromString(self:GetText():trim())
					if copper then
						private.cod = copper
						self:SetText(TSMAPI:MoneyToString(copper))
						self:ClearFocus()
						private:UpdateSendButton()
					else
						self:SetFocus()
					end
				end,
			},
			btn = {
				OnClick = function(self)
					local itemString = TSMAPI.Item:ToItemString(private.itemLink)
					local numHave = 0
					for _, _, iString, quantity in TSMAPI.Inventory:BagIterator() do
						if iString == itemString then
							numHave = numHave + quantity
						end
					end
					local quantity
					if private.quantity == 0 then
						quantity = numHave
					else
						quantity = min(private.quantity, numHave)
					end
					
					local clearOnSend = not IsShiftKeyDown()
					TSM.AutoMail:SendItems({[itemString]=quantity}, private.target, function() private:UpdateSendButton(clearOnSend) end, private.cod > 0 and private.cod)
					self:SetText(L["Sending..."])
					self:Disable()
				end,
			},
		},
	}
	return frameInfo
end

function private:UpdateSendButton(didSend)
	local btn = private.frame.btn
	if didSend then
		private.itemLink = nil
		private.quantity = 0
		private.cod = 0
		private.target = ""
		private.frame.itemBox:SetText("")
		private.frame.qtyBox:SetNumber(0)
		private.frame.codBox:SetText("")
		private.frame.targetBox:SetText("")
	end
	if not private.itemLink then
		btn:Disable()
		btn:SetText(L["No Item Specified"])
	elseif private.target == "" then
		btn:Disable()
		btn:SetText(L["No Target Specified"])
	else
		btn:Enable()
		if private.cod > 0 then
			if private.quantity == 0 then
				btn:SetText(format(L["Send all %s to %s - %s per Item COD"], private.itemLink, private.target, TSMAPI:MoneyToString(private.cod)))
			else
				btn:SetText(format(L["Send %sx%d to %s - %s per Item COD"], private.itemLink, private.quantity, private.target, TSMAPI:MoneyToString(private.cod)))
			end
		else
			if private.quantity == 0 then
				btn:SetText(format(L["Send all %s to %s - No COD"], private.itemLink, private.target))
			else
				btn:SetText(format(L["Send %sx%d to %s - No COD"], private.itemLink, private.quantity, private.target))
			end
		end
	end
end