-- ------------------------------------------------------------------------------ --
--                           TradeSkillMaster_Destroying                          --
--           http://www.curse.com/addons/wow/tradeskillmaster_destroying          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local GUI = TSM:NewModule("GUI", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Destroying")
local private = { data = {}, ignore = {}, threadId = nil, hidden = nil }



-- ============================================================================
-- Module Functions
-- ============================================================================

function GUI:OnEnable()
	private:CreateDestroyingFrame()
	private:AutoShow()
	GUI:RegisterEvent("BAG_UPDATE", function() TSMAPI.Delay:AfterTime("destroyingBagUpdate", 0.2, private.AutoShow) end)
end

function GUI:ShowFrame()
	private.threadId = TSMAPI.Threading:Start(private.DestroyingThread, 0.7, private.StopDestroying)
	if TSM.db.global.autoStack then
		private:Stack()
	end
end

function GUI:UpdateST()
	private:UpdateSTData()
end



-- ============================================================================
-- GUI Creation Functions
-- ============================================================================

function private:CreateDestroyingFrame()
	if private.frame then return end

	local frameDefaults = {
		x = 850,
		y = 450,
		width = 300,
		height = 300,
		scale = 1,
	}
	local color = TSMAPI.Design:GetInlineColor("link")
	local BFC = TSMAPI.GUI:GetBuildFrameConstants()
	local frameInfo = {
		type = "MovableFrame",
		name = "TSMDestroyingFrame",
		movableDefaults = frameDefaults,
		children = {
			{
				type = "Text",
				text = format("TSM_Destroying - %s", strfind(TSM._version, "@") and "Dev" or TSM._version),
				textFont = { TSMAPI.Design:GetContentFont(), 18 },
				points = { { "TOP", BFC.PARENT, 0, -3 } },
			},
			{
				type = "HLine",
				offset = -24,
			},
			{
				type = "VLine",
				offset = 0,
				size = { 2, 22 },
				points = { { "TOPRIGHT", -25, -1 } },
			},
			{
				type = "Button",
				key = "closeBtn",
				text = "X",
				textHeight = 18,
				size = { 19, 19 },
				points = { { "TOPRIGHT", -3, -3 } },
				scripts = { "OnClick" },
			},
			{
				type = "Text",
				text = format(L["%sLeft-Click|r to ignore an item for this session.\n%sShift-Left-Click|r to ignore an item permanently. You can remove items from permanent ignore in the Destroying options."], color, color),
				textFont = { TSMAPI.Design:GetContentFont("small") },
				justify = { "LEFT", "TOP" },
				points = { { "TOPLEFT", 3, -26 }, { "TOPRIGHT", -3, -26 } },
			},
			{
				type = "ScrollingTableFrame",
				key = "st",
				stDisableSelection = true,
				stCols = { { name = L["Item"], width = 0.75 }, { name = L["Stack Size"], width = 0.25, align = "CENTER" } },
				points = { { "TOPLEFT", 3, -75 }, { "BOTTOMRIGHT", -3, 50 } },
				scripts = { "OnClick", "OnEnter", "OnLeave" },
			},
			{
				type = "Button",
				key = "combineBtn",
				isSecure = true,
				text = L["Combine Partial Stacks"],
				textHeight = 14,
				size = { 0, 20 },
				points = { { "BOTTOMLEFT", 3, 26 }, { "BOTTOMRIGHT", -3, 26 } },
				scripts = { "OnClick" },
			},
			{
				type = "Button",
				name = "TSMDestroyButton",
				key = "destroyBtn",
				isSecure = true,
				text = L["Destroy Next"],
				textHeight = 14,
				size = { 0, 20 },
				points = { { "BOTTOMLEFT", 3, 3 }, { "BOTTOMRIGHT", -3, 3 } },
				scripts = { "PreClick" },
			},
		},
		handlers = {
			closeBtn = {
				OnClick = function()
					if InCombatLockdown() then return end
					TSM:Print(L["Hiding frame for the remainder of this session. Typing '/tsm destroy' will open the frame again."])
					private.hidden = true
					private.StopDestroying()
					private.frame:Hide()
				end,
			},
			st = {
				OnClick = function(_, data, self, button)
					if not data then return end
					if button == "LeftButton" then
						if IsShiftKeyDown() then
							TSM.db.global.ignore[data.itemString] = true
							TSM:Printf(L["Ignoring all %s permanently. You can undo this in the Destroying options."], data.link)
							TSM.Options:UpdateIgnoreST()
						else
							private.ignore[data.itemString] = true
							TSM:Printf(L["Ignoring all %s this session (until your UI is reloaded)."], data.link)
						end
						private:UpdateSTData()
					end
				end,
				OnEnter = function(_, data, self)
					if not data then return end
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetHyperlink(data.link)
					GameTooltip:Show()
				end,
				OnLeave = function()
					GameTooltip:ClearLines()
					GameTooltip:Hide()
				end,
			},
			combineBtn = {
				OnClick = private.Stack,
			},
			destroyBtn = {
				PreClick = function(self)
					if InCombatLockdown() then
						return
					elseif not self:IsVisible() then
						self:SetAttribute("macrotext1", "")
						return
					elseif IsAltKeyDown() or IsControlKeyDown() or IsShiftKeyDown() then
						TSM:Print(L["Make sure not to press any modifier keys when clicking the 'Destroy Next' button!"])
						self:SetAttribute("macrotext1", "")
						return
					end
					-- send the pre-click event
					private.pendingButtonClick = true
					TSMAPI.Threading:SendMsg(private.threadId, { "EV_BUTTON_PRECLICK" }, true)
					private.pendingButtonClick = false
				end,
			},
		},
	}
	private.frame = TSMAPI.GUI:BuildFrame(frameInfo)
	private.frame:SetFrameStrata("HIGH")
	TSMAPI.Design:SetFrameBackdropColor(private.frame)
	-- update the frame size for TSM3
	private.frame:Show()
	private.frame:SetWidth(frameDefaults.width)
	private.frame:SetHeight(frameDefaults.height)
	private.frame:SavePositionAndSize()
	private.frame:Hide()

	private.frame.destroyBtn:SetAttribute("type1", "macro")
	private.frame.destroyBtn:SetAttribute("macrotext1", "")

	local helpPlateInfo = {
		FramePos = { x = 0, y = 0 },
		FrameSize = { width = 300, height = 300 },
		{
			ButtonPos = { x = 230, y = -150 },
			HighLightBox = { x = 0, y = -75, width = 300, height = 175 },
			ToolTipDir = "RIGHT",
			ToolTipText = L["Here you can view all items in your bags which can be destroyed (disenchanted, milled, or prospected). They will be destroyed in the order they are listed (top to bottom)."],
		},
		{
			ButtonPos = { x = 20, y = -240 },
			HighLightBox = { x = 0, y = -250, width = 300, height = 25 },
			ToolTipDir = "LEFT",
			ToolTipText = L["This button will combine stacks to allow for maximum milling / prospecting."],
		},
		{
			ButtonPos = { x = 240, y = -265 },
			HighLightBox = { x = 0, y = -275, width = 300, height = 25 },
			ToolTipDir = "RIGHT",
			ToolTipText = L["This button will destroy (disenchant, mill, or prospect) the next item in the list."],
		},
	}

	local mainHelpBtn = CreateFrame("Button", nil, private.frame, "MainHelpPlateButton")
	mainHelpBtn:SetPoint("TOPLEFT", private.frame, -25, 30)
	mainHelpBtn:SetScript("OnClick", function() private:ToggleHelpPlate(private.frame, helpPlateInfo, mainHelpBtn, true) end)
	mainHelpBtn:SetScript("OnHide", function() if HelpPlate_IsShowing(helpPlateInfo) then private:ToggleHelpPlate(private.frame, helpPlateInfo, mainHelpBtn, false) end end)

	if not TSM.db.global.helpPlatesShown.destroyingFrame then
		TSM.db.global.helpPlatesShown.destroyingFrame = true
		private:ToggleHelpPlate(private.frame, helpPlateInfo, mainHelpBtn, false)
	end
end

function private:ToggleHelpPlate(frame, info, btn, isUser)
	if not HelpPlate_IsShowing(info) then
		HelpPlate:SetParent(frame)
		HelpPlate:SetFrameStrata("DIALOG")
		HelpPlate_Show(info, frame, btn, isUser)
	else
		HelpPlate:SetParent(UIParent)
		HelpPlate:SetFrameStrata("DIALOG")
		HelpPlate_Hide(isUser)
	end
end



-- ============================================================================
-- GUI Updating Functions
-- ============================================================================

function private:UpdateSTData()
	if InCombatLockdown() then return end

	local stData = {}
	for bag, slot, itemString, quantity in TSMAPI.Inventory:BagIterator(nil, TSM.db.global.includeSoulbound) do
		if not private.ignore[itemString] and not TSM.db.global.ignore[itemString] then
			local spell, perDestroy = TSM:IsDestroyable(itemString)
			local deSpellName = GetSpellInfo(TSM.spells.disenchant)
			local deValue = spell == deSpellName and TSMAPI:GetCustomPriceValue("Destroy", itemString)
			local vendorSell = (TSM.db.global.deAboveVendor and TSMAPI:GetCustomPriceValue("VendorSell", itemString)) or 0
			local deAbovePrice = TSMAPI:GetCustomPriceValue(TSM.db.global.deAbovePrice, itemString) or 0

			local link = GetContainerItemLink(bag, slot)
			if spell and not deValue or (spell == deSpellName and (deValue and deValue >= deAbovePrice and deValue >= vendorSell)) then
				if quantity >= perDestroy then
					local row = {
						cols = {
							{
								value = link,
							},
							{
								value = quantity
							},
						},
						itemString = itemString,
						link = link,
						quantity = quantity,
						bag = bag,
						slot = slot,
						spell = spell,
						perDestroy = perDestroy,
						numDestroys = floor(quantity / perDestroy),
					}
					tinsert(stData, row)
				end
			end
		end
	end

	if #stData == 0 then
		private.frame.destroyBtn:Disable()
		private.frame:Hide()
	elseif TSM.db.global.autoShow and not private.frame:IsVisible() then
		private.frame.destroyBtn:Enable()
		private.frame:Show()
	end

	private.data = CopyTable(stData)
	private.frame.st:SetData(stData)
end

function private:AutoShow()
	if TSM.db.global.autoShow and not private.threadId and not private.hidden and not InCombatLockdown() then
		GUI:ShowFrame()
	end
end



-- ============================================================================
-- Stacking Functions
-- ============================================================================

-- combine partial stacks
function private:Stack()
	local partialStacks = {}
	for bag, slot, itemString, quantity in TSMAPI.Inventory:BagIterator(nil, TSM.db.global.includeSoulbound) do
		local spell = TSM:IsDestroyable(itemString)
		if spell and not private.ignore[itemString] and not TSM.db.global.ignore[itemString] then
			partialStacks[itemString] = partialStacks[itemString] or {}
			tinsert(partialStacks[itemString], { bag, slot })
		end
	end

	for itemString, locations in pairs(partialStacks) do
		for i = #locations, 2, -1 do
			local quantity = select(2, GetContainerItemInfo(unpack(locations[i])))
			local maxStack = select(8, GetItemInfo(itemString))
			if quantity == 0 or quantity == maxStack or not maxStack then break end

			for j = 1, i - 1 do
				local targetQuantity = select(2, GetContainerItemInfo(unpack(locations[j])))
				if targetQuantity ~= maxStack then
					PickupContainerItem(unpack(locations[i]))
					PickupContainerItem(unpack(locations[j]))
				end
			end
		end
	end
end



-- ============================================================================
-- Destroy Thread
-- ============================================================================

-- STATES: ST_READY, ST_CASTING_PENDING, ST_CASTING_STARTED, ST_CASTING_COMPLETE, ST_LOOTING_STARTED, ST_LOOTING_COMPLETE
-- EVENTS: EV_UPDATE_GUI, EV_BUTTON_PRECLICK, EV_CAST_STARTED, EV_CAST_FAILED, EV_CAST_SUCCEEDED, EV_LOOT_OPENED, EV_LOOT_CLOSED
function private.DestroyingThread(self)
	self:SetThreadName("DESTROYING_MAIN")
	-- check that we have things to destroy
	private.frame:Show()
	private:UpdateSTData()
	if #private.data == 0 then
		return
	end

	local currentState = "ST_READY"
	local context = {}
	self:RegisterEvent("BAG_UPDATE", function() TSMAPI.Delay:AfterFrame("destroyingThreadMsgBucket", 5, function() TSMAPI.Threading:SendMsg(private.threadId, { "EV_UPDATE_GUI" }) end) end)
	self:RegisterEvent("LOOT_OPENED", function() self:SendMsgToSelf("EV_LOOT_OPENED") end)
	self:RegisterEvent("LOOT_CLOSED", function() self:SendMsgToSelf("EV_LOOT_CLOSED") end)
	self:RegisterEvent("UNIT_SPELLCAST_START", function(_, unit, spell) if private:ValidateSpellEvent(unit, spell, context) then self:SendMsgToSelf("EV_CAST_STARTED") end end)
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", function(_, unit, spell) if private:ValidateSpellEvent(unit, spell, context) then self:SendMsgToSelf("EV_CAST_FAILED") end end)
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", function(_, unit, spell) if private:ValidateSpellEvent(unit, spell, context) then self:SendMsgToSelf("EV_CAST_SUCCEEDED") end end)
	self:RegisterEvent("UNIT_SPELLCAST_FAILED", function(_, unit, spell) if private:ValidateSpellEvent(unit, spell, context) then self:SendMsgToSelf("EV_CAST_FAILED") end end)
	private.frame.destroyBtn:Enable()

	local eventTriggered = {}
	local eventList = {}
	while true do
		-- collect pending events
		local startingState = currentState
		wipe(eventTriggered)
		wipe(eventList)
		while true do
			local event = unpack(self:ReceiveMsg())
			if not eventTriggered[event] then
				tinsert(eventList, event)
			end
			eventTriggered[event] = true
			if self:GetNumMsgs() == 0 then
				break
			end
		end

		-- process EV_UPDATE_GUI regardless of current state
		if eventTriggered.EV_UPDATE_GUI then
			private:UpdateSTData()
			if #private.data == 0 then
				if currentState == "ST_READY" then
					return
				end
			end
		end

		if eventTriggered.EV_CAST_STARTED then
			if currentState == "ST_CASTING_PENDING" then
				-- cast started successfully
				currentState = "ST_CASTING_STARTED"
			end
		end

		if eventTriggered.EV_CAST_FAILED then
			if currentState == "ST_CASTING_PENDING" then
				-- cast failed, return to the ready state
				currentState = "ST_READY"
			elseif currentState == "ST_CASTING_STARTED" then
				-- cast failed, return to the ready state
				currentState = "ST_READY"
			end
		end

		if eventTriggered.EV_CAST_SUCCEEDED then
			if currentState == "ST_CASTING_STARTED" or currentState == "ST_CASTING_PENDING" then
				-- cast completed successfully
				currentState = "ST_CASTING_COMPLETE"
			end
		end

		if eventTriggered.EV_LOOT_OPENED then
			if currentState == "ST_CASTING_COMPLETE" then
				-- add to the log
				local temp = { result = {}, time = time() }
				temp.item = context.target.itemString
				if temp.item and GetNumLootItems() > 0 then
					for i = 1, GetNumLootItems() do
						local itemString = TSMAPI.Item:ToItemString(GetLootSlotLink(i))
						local quantity = select(3, GetLootSlotInfo(i)) or 0
						if itemString and quantity > 0 then
							temp.result[itemString] = quantity
						end
					end
					if context.target.spell == GetSpellInfo(TSM.spells.disenchant) then
						temp.isDraenicEnchanting = TSM:HasDraenicEnchanting()
					end
					TSM.db.global.history[context.target.spell] = TSM.db.global.history[context.target.spell] or {}
					tinsert(TSM.db.global.history[context.target.spell], temp)
				end

				private.frame.destroyBtn:Disable()
				currentState = "ST_LOOTING_STARTED"
				context.target = nil
				CloseLoot()
			end
		end

		if eventTriggered.EV_LOOT_CLOSED then
			if currentState == "ST_LOOTING_STARTED" then
				currentState = "ST_LOOTING_COMPLETE"
			end
		end

		if eventTriggered.EV_BUTTON_PRECLICK then
			if not private.pendingButtonClick then
				-- skip this button click
				private.frame.destroyBtn:SetAttribute("macrotext1", "")
			else
				if currentState == "ST_READY" or currentState == "ST_CASTING_STARTED" then
					local target, backupTarget
					for _, data in ipairs(private.data) do
						local quantity, locked = select(2, GetContainerItemInfo(data.bag, data.slot))
						if not locked and (quantity or 0) >= data.perDestroy then
							if data == context.target then
								backupTarget = data
							else
								target = data
								break
							end
						end
					end
					target = target or backupTarget
					if target then
						if target.spell == GetSpellInfo(TSM.spells.milling) and TSMAPI.Inventory:GetBagQuantity("i:114942") > 0 then
							-- use the draenic mortar
							local mortarName = TSMAPI.Item:GetInfo("i:114942")
							private.frame.destroyBtn:SetAttribute("macrotext1", format("/use %s;\n/use %d %d", mortarName, target.bag, target.slot))
						else
							private.frame.destroyBtn:SetAttribute("macrotext1", format("/cast %s;\n/use %d %d", target.spell, target.bag, target.slot))
						end
						if currentState == "ST_READY" then
							context.target = target
							currentState = "ST_CASTING_PENDING"
						end
					else
						private.frame.destroyBtn:SetAttribute("macrotext1", "")
					end
				end
				ClearCursor()
				private.frame.destroyBtn:Disable()
			end
		end

		-- do some state-based things every time
		if currentState == "ST_READY" then
			context.enabledNext = nil
			private.frame.destroyBtn:Enable()
		elseif currentState == "ST_LOOTING_COMPLETE" then
			private.frame.destroyBtn:Disable()
			currentState = "ST_READY"
		end

		TSM:LOG_INFO("%s %s %s", startingState, currentState, table.concat(eventList, ", "))
	end
end

function private.StopDestroying()
	TSMAPI.Threading:Kill(private.threadId)
	private.threadId = nil
	wipe(private.data)
	private.frame:Hide()
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private:SendThreadEventBucket(msg, numFrames)
	if not private.threadId then return end
	TSMAPI.Delay:AfterFrame("destroyingThreadBucket_" .. msg, numFrames, function() TSMAPI.Threading:SendMsg(private.threadId, { msg }) end)
end

function private:ValidateSpellEvent(unit, spell, context)
	if unit ~= "player" then
		return false
	end
	if context.target and spell == context.target.spell then
		return true
	end
	return false
end