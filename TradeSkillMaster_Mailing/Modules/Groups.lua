-- ------------------------------------------------------------------------------ --
--                            TradeSkillMaster_Mailing                            --
--            http://www.curse.com/addons/wow/tradeskillmaster_mailing            --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local TSM = select(2, ...)
local Groups = TSM:NewModule("Groups", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Mailing") -- loads the localization table
local private = {dryRun=nil, frame=nil}


function Groups:OnEnable()
	Groups:RegisterEvent("MAIL_CLOSED", function()
		if private.frame then
			private.frame.button:SetText(L["Mail Selected Groups"])
			private.frame.button:Enable()
		end
	end)
end

function Groups:CreateTab(parent)
	Groups:RegisterEvent("MAIL_CLOSED", function() TSMAPI.Delay:Cancel("mailingResendDelay") end)
	
	local BFC = TSMAPI.GUI:GetBuildFrameConstants()
	local frameInfo = {
		type = "Frame",
		key = "groupsTab",
		hidden = true,
		points = "ALL",
		scripts = {"OnShow", "OnHide"},
		children = {
			{
				type = "GroupTreeFrame",
				key = "groupTree",
				groupTreeInfo = {"Mailing", "Mailing_Send"},
				points = {{"TOPLEFT", 5, -5}, {"BOTTOMRIGHT", -5, 35}},
			},
			{
				type = "Button",
				key = "button",
				text = L["Mail Selected Groups"],
				textHeight = 15,
				tooltip = L["|cff99ffffShift-Click|r to automatically re-send after the amount of time specified in the TSM_Mailing options.\n|cff99ffffCtrl-Click|r to perform a dry-run where Mailing doesn't send anything, but prints out what it would send (useful for testing your operations)."],
				size = {0, 25},
				points = {{"BOTTOMLEFT", 5, 5}, {"BOTTOMRIGHT", -5, 5}},
				scripts = {"OnClick"},
			},
		},
		handlers = {
			OnShow = function(self)
				private.frame = self
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
							ButtonPos = {x = 200, y = -200},
							HighLightBox = {x = 0, y = -65, width = TOTAL_WIDTH, height = 325},
							ToolTipDir = "RIGHT",
							ToolTipText = L["Here you can select groups with TSM_Mailing operations to be automatically mailed to other characters."],
						},
						{
							ButtonPos = {x = 300, y = -380},
							HighLightBox = {x = 0, y = -390, width = TOTAL_WIDTH, height = 35},
							ToolTipDir = "RIGHT",
							ToolTipText = L["Click this button to automatically mail items in the groups which you have selected."],
						},
					}
					
					self.helpBtn = CreateFrame("Button", nil, private.frame, "MainHelpPlateButton")
					self.helpBtn:SetPoint("TOPLEFT", 50, 100)
					self.helpBtn:SetScript("OnClick", function() TSM.MailTab:ToggleHelpPlate(private.frame, helpPlateInfo, self.helpBtn, true) end)
					self.helpBtn:SetScript("OnHide", function() if HelpPlate_IsShowing(helpPlateInfo) then TSM.MailTab:ToggleHelpPlate(private.frame, helpPlateInfo, self.helpBtn, false) end end)
					if not TSM.db.global.helpPlatesShown.groups then
						TSM.db.global.helpPlatesShown.groups = true
						TSM.MailTab:ToggleHelpPlate(private.frame, helpPlateInfo, self.helpBtn, false)
					end
				end
			end,
			OnHide = function() TSMAPI.Delay:Cancel("mailingGroupsRepeat") end,
			button = {
				OnClick = function(self)
					if IsControlKeyDown() then
						private:StartSending(true)
					elseif IsShiftKeyDown() then
						TSMAPI.Delay:AfterTime("mailingResendDelay", 0.1, private.StartSending, TSM.db.global.resendDelay * 60)
					else
						private:StartSending()
					end
				end,
			},
		},
	}
	return frameInfo
end

local badOperations = {}
function Groups:ValidateOperation(operation, operationName)
	if not operation then return end
	if operation.target == "" then
		-- operation is invalid (no target)
		if not badOperations[operationName] then
			TSM:Printf(L["Skipping operation '%s' because there is no target."], operationName)
			badOperations[operationName] = true
		end
		return
	end
	return true
end

function private:StartSending(dryRun)
	if private.isSending then return end
	private.dryRun = dryRun

	-- get a table of how many of each item we have in our bags
	local inventoryItems = {}
	for bag, slot, itemString, quantity, locked in TSMAPI.Inventory:BagIterator(true, false, true) do
		inventoryItems[itemString] = (inventoryItems[itemString] or 0) + quantity
	end

	local badOperations = {}
	local targets = {}
	for _, data in pairs(private.frame.groupTree:GetSelectedGroupInfo()) do
		for _, operationName in ipairs(data.operations) do
			TSMAPI.Operations:Update("Mailing", operationName)
			local operation = TSM.operations[operationName]
			if Groups:ValidateOperation(operation, operationName) then
				-- operation is valid
				for itemString in pairs(data.items) do
					local numAvailable = (inventoryItems[itemString] or 0) - operation.keepQty
					if numAvailable > 0 then
						local quantity, reserveQty = 0, 0
						if operation.maxQtyEnabled then
							if not operation.restock then
								quantity = min(numAvailable, operation.maxQty)
							else
								local targetQty = Groups:GetTargetQuantity(operation.target, itemString, operation.restockSources)
								if TSMAPI.Player:IsPlayer(operation.target) and targetQty <= operation.maxQty then
									quantity = numAvailable
								else
									quantity = min(numAvailable, operation.maxQty - targetQty)
								end
								if TSMAPI.Player:IsPlayer(operation.target) then
									-- if using restock and target == player ensure that subsequent operations don't take reserved bag inventory
									reserveQty = numAvailable - (targetQty - operation.maxQty)
								end
							end
						else
							quantity = numAvailable
						end
						if quantity > 0 then
							inventoryItems[itemString] = inventoryItems[itemString] - quantity
							targets[operation.target] = targets[operation.target] or {}
							targets[operation.target][itemString] = quantity
						elseif reserveQty > 0 then -- some of the bag inventory is reserved so make unavailable for next operation
							inventoryItems[itemString] = inventoryItems[itemString] - reserveQty
						end
					else -- as available quantity was used up by this operation make sure its not available for any subsequent operations
						inventoryItems[itemString] = nil
					end
				end
			end
		end
	end

	for target in pairs(targets) do
		if TSMAPI.Player:IsPlayer(target) then
			targets[target] = nil
		end
	end

	private.targets = targets
	private:SendNextTarget()
end

function Groups:GetTargetQuantity(player, itemString, sources)
	if player then
		player = strmatch(player, "^[^-]+"):trim()
	end
	local num = TSMAPI.Inventory:GetBagQuantity(itemString, player) + TSMAPI.Inventory:GetMailQuantity(itemString, player) + TSMAPI.Inventory:GetAuctionQuantity(itemString, player)
	if sources then
		if sources.guild then
			num = num + TSMAPI.Inventory:GetGuildQuantity(itemString, TSMAPI.Player:GetPlayerGuild(player))
		end
		if sources.bank then
			num = num + TSMAPI.Inventory:GetBankQuantity(itemString, player) + TSMAPI.Inventory:GetReagentBankQuantity(itemString, player)
		end
	end
	return num
end

function private:SendNextTarget()
	local target, items = next(private.targets)
	if not target then
		private.frame.button:SetText(L["Mail Selected Groups"])
		private.frame.button:Enable()
		private.isSending = nil
		private.dryRun = nil
		TSM:Print(L["Done sending mail."])
		return
	end

	TSM:LOG_INFO("Sending items to %s", tostring(target))
	private.isSending = true
	private.targets[target] = nil
	private.frame.button:SetText(L["Sending..."])
	private.frame.button:Disable()
	if not TSM.AutoMail:SendItems(items, target, private.SendNextTarget, nil, private.dryRun) then
		private:SendNextTarget()
	end
end
