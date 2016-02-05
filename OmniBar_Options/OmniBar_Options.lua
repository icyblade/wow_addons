local _, L = ...

local OmniBar = OmniBar

function OmniBarOptionsPanel_OnLoad(self)
	-- Set localized text
	OmniBarOptionsPanelVersionLabel:SetText(L.VERSION_LABEL)
	OmniBarOptionsPanelAuthorLabel:SetText(L.AUTHOR_LABEL)
	OmniBarOptionsPanelReset:SetText(L.RESET_BUTTON)
	OmniBarOptionsPanelTest:SetText(L.TEST_BUTTON)
	OmniBarOptionsPanelTest.tooltipText = L.TEST_BUTTON
	OmniBarOptionsPanelReset.tooltipText = L.RESET_BUTTON
	OmniBarOptionsPanelReset.tooltipRequirement = L.RESET_BUTTON_TOOLTIP
	OmniBarOptionsPanelTest.tooltipRequirement = L.TEST_BUTTON_TOOLTIP
	OmniBarOptionsPanelLockText:SetText(L.LOCK)
	OmniBarOptionsPanelLock.tooltipText = L.LOCK
	OmniBarOptionsPanelLock.tooltipRequirement = L.LOCK_TOOLTIP
	OmniBarOptionsPanelCenterLockText:SetText(L.CENTER_LOCK)
	OmniBarOptionsPanelCenterLock.tooltipText = L.CENTER_LOCK
	OmniBarOptionsPanelCenterLock.tooltipRequirement = L.CENTER_LOCK_TOOLTIP
	OmniBarOptionsPanelShowUnusedText:SetText(L.SHOW_UNUSED_ICONS)
	OmniBarOptionsPanelShowUnused.tooltipText = L.SHOW_UNUSED_ICONS
	OmniBarOptionsPanelShowUnused.tooltipRequirement = L.SHOW_UNUSED_ICONS_TOOLTIP
	OmniBarOptionsPanelAsEnemiesAppearText:SetText(L.AS_ENEMIES_APPEAR)
	OmniBarOptionsPanelAsEnemiesAppear.tooltipText = L.AS_ENEMIES_APPEAR
	OmniBarOptionsPanelAsEnemiesAppear.tooltipRequirement = L.AS_ENEMIES_APPEAR_TOOLTIP
	OmniBarOptionsPanelGrowUpwardText:SetText(L.GROW_ROWS_UPWARD)
	OmniBarOptionsPanelGrowUpward.tooltipText = L.GROW_ROWS_UPWARD
	OmniBarOptionsPanelGrowUpward.tooltipRequirement = L.GROW_ROWS_UPWARD_TOOLTIP
	OmniBarOptionsPanelCountdownCountText:SetText(L.COUNTDOWN_COUNT)
	OmniBarOptionsPanelCountdownCount.tooltipText = L.COUNTDOWN_COUNT
	OmniBarOptionsPanelCountdownCount.tooltipRequirement = L.COUNTDOWN_COUNT_TOOLTIP
	OmniBarOptionsPanelShowBorderText:SetText(L.SHOW_BORDER)
	OmniBarOptionsPanelShowBorder.tooltipText = L.SHOW_BORDER
	OmniBarOptionsPanelShowBorder.tooltipRequirement = L.SHOW_BORDER_TOOLTIP
	OmniBarOptionsPanelHighlightTargetText:SetText(L.HIGHLIGHT_TARGET)
	OmniBarOptionsPanelHighlightTarget.tooltipText = L.HIGHLIGHT_TARGET
	OmniBarOptionsPanelHighlightTarget.tooltipRequirement = L.HIGHLIGHT_TARGET_TOOLTIP
	OmniBarOptionsPanelHighlightFocusText:SetText(L.HIGHLIGHT_FOCUS)
	OmniBarOptionsPanelHighlightFocus.tooltipText = L.HIGHLIGHT_FOCUS
	OmniBarOptionsPanelHighlightFocus.tooltipRequirement = L.HIGHLIGHT_FOCUS_TOOLTIP
	OmniBarOptionsPanelUseGlobalText:SetText(L.USE_GLOBAL_SETTINGS)
	OmniBarOptionsPanelUseGlobal.tooltipText = L.USE_GLOBAL_SETTINGS
	OmniBarOptionsPanelUseGlobal.tooltipRequirement = L.USE_GLOBAL_SETTINGS_TOOLTIP
	OmniBarOptionsPanelShowArenaText:SetText(L.SHOW_IN_ARENAS)
	OmniBarOptionsPanelShowArena.tooltipText = L.SHOW_IN_ARENAS
	OmniBarOptionsPanelShowArena.tooltipRequirement = L.SHOW_IN_ARENAS_TOOLTIP
	OmniBarOptionsPanelShowRatedBattlegroundText:SetText(L.SHOW_IN_RATED_BATTLEGROUNDS)
	OmniBarOptionsPanelShowRatedBattleground.tooltipText = L.SHOW_IN_RATED_BATTLEGROUNDS
	OmniBarOptionsPanelShowRatedBattleground.tooltipRequirement = L.SHOW_IN_RATED_BATTLEGROUNDS_TOOLTIP
	OmniBarOptionsPanelShowBattlegroundText:SetText(L.SHOW_IN_BATTLEGROUNDS)
	OmniBarOptionsPanelShowBattleground.tooltipText = L.SHOW_IN_BATTLEGROUNDS
	OmniBarOptionsPanelShowBattleground.tooltipRequirement = L.SHOW_IN_BATTLEGROUNDS_TOOLTIP
	OmniBarOptionsPanelShowWorldText:SetText(L.SHOW_IN_WORLD)
	OmniBarOptionsPanelShowWorld.tooltipText = L.SHOW_IN_WORLD
	OmniBarOptionsPanelShowWorld.tooltipRequirement = L.SHOW_IN_WORLD_TOOLTIP
	OmniBarOptionsPanelShowAshranText:SetText(L.SHOW_IN_ASHRAN)
	OmniBarOptionsPanelShowAshran.tooltipText = L.SHOW_IN_ASHRAN
	OmniBarOptionsPanelShowAshran.tooltipRequirement = L.SHOW_IN_ASHRAN_TOOLTIP
	OmniBarOptionsPanelTrackMultipleText:SetText(L.TRACK_MULTIPLE_PLAYERS)
	OmniBarOptionsPanelTrackMultiple.tooltipText = L.TRACK_MULTIPLE_PLAYERS
	OmniBarOptionsPanelTrackMultiple.tooltipRequirement = L.TRACK_MULTIPLE_PLAYERS_TOOLTIP
	OmniBarOptionsPanelGlowText:SetText(L.GLOW_ICONS)
	OmniBarOptionsPanelGlow.tooltipText = L.GLOW_ICONS
	OmniBarOptionsPanelGlow.tooltipRequirement = L.GLOW_ICONS_TOOLTIP
	OmniBarOptionsPanelTooltipsText:SetText(L.TOOLTIPS)
	OmniBarOptionsPanelTooltips.tooltipText = L.TOOLTIPS
	OmniBarOptionsPanelTooltips.tooltipRequirement = L.TOOLTIPS_TOOLTIP
	OmniBarOptionsPanelSizeTitle:SetText(L.SIZE)
	OmniBarOptionsPanelSizeDescription:SetText(L.SIZE_DESCRIPTION)
	OmniBarOptionsPanelUnusedAlphaTitle:SetText(L.UNUSED_ICON_TRANSPARENCY)
	OmniBarOptionsPanelUnusedAlphaDescription:SetText(L.UNUSED_ICON_TRANSPARENCY_DESCRIPTION)
	OmniBarOptionsPanelSwipeAlphaTitle:SetText(L.SWIPE_TRANSPARENCY)
	OmniBarOptionsPanelSwipeAlphaDescription:SetText(L.SWIPE_TRANSPARENCY_DESCRIPTION)
	OmniBarOptionsPanelColumnsTitle:SetText(L.COLUMNS)
	OmniBarOptionsPanelColumnsDescription:SetText(L.COLUMNS_DESCRIPTION)
	OmniBarOptionsPanelPaddingTitle:SetText(L.PADDING)
	OmniBarOptionsPanelPaddingDescription:SetText(L.PADDING_DESCRIPTION)
end

function OmniBarOptionsPanelLock_Update(value)
	OmniBar.settings.locked = value == "1"
	OmniBar_Position(OmniBar)
end

function OmniBarOptionsPanelCenterLock_Update(value)
	OmniBar.settings.center = value == "1"
	if OmniBar.settings.center then
		OmniBar_Center(OmniBar)
		OmniBar_LoadPosition(OmniBar)
		OmniBar_SavePosition(OmniBar)
	end
end

function OmniBarOptionsPanelShowUnused_Update(value)
	OmniBar.settings.showUnused = value == "1"
	if OmniBar.settings.showUnused then
		OmniBarOptionsPanelAsEnemiesAppear:Enable()
	else
		OmniBarOptionsPanelAsEnemiesAppear:Disable()
	end
	OmniBar_OnEvent(OmniBar, "PLAYER_ENTERING_WORLD")
end

function OmniBarOptionsPanelAsEnemiesAppear_Update(value)
	OmniBar.settings.adaptive = value == "1"
	OmniBar_OnEvent(OmniBar, "PLAYER_ENTERING_WORLD")
end

function OmniBarOptionsPanelGrowUpward_Update(value)
	OmniBar.settings.growUpward = value == "1"
	OmniBar_Position(OmniBar)
end

function OmniBarOptionsPanelCountdownCount_Update(value)
	OmniBar.settings.noCooldownCount = value == "0"
	OmniBar_RefreshIcons(OmniBar)
	OmniBar_UpdateIcons(OmniBar)
end

function OmniBarOptionsPanelShowBorder_Update(value)
	OmniBar.settings.border = value == "1"
	OmniBar_UpdateIcons(OmniBar)
end

function OmniBarOptionsPanelHighlightTarget_Update(value)
	OmniBar.settings.noHighlightTarget = value == "0"
	OmniBar_UpdateBorders(OmniBar)
end

function OmniBarOptionsPanelHighlightFocus_Update(value)
	OmniBar.settings.noHighlightFocus = value == "0"
	OmniBar_UpdateBorders(OmniBar)
end

function OmniBarOptionsPanelUseGlobal_Update(value)
	OmniBar_LoadSettings(OmniBar, value == "1" and 0 or 1)
	OmniBarOptions:refresh()

	-- Refresh the cooldowns
	i = 1
	while _G["OmniBarOptionsPanel" .. i] do
		_G["OmniBarOptionsPanel" .. i]:refresh()
		i = i + 1
	end
end

function OmniBarOptionsPanelShowArena_Update(value)
	OmniBar.settings.noArena = value == "0"
	OmniBar_OnEvent(OmniBar, "PLAYER_ENTERING_WORLD")
end

function OmniBarOptionsPanelShowRatedBattleground_Update(value)
	OmniBar.settings.noRatedBattleground = value == "0"
	OmniBar_OnEvent(OmniBar, "PLAYER_ENTERING_WORLD")
end

function OmniBarOptionsPanelShowBattleground_Update(value)
	OmniBar.settings.noBattleground = value == "0"
	OmniBar_OnEvent(OmniBar, "PLAYER_ENTERING_WORLD")
end

function OmniBarOptionsPanelShowWorld_Update(value)
	OmniBar.settings.noWorld = value == "0"
	OmniBar_OnEvent(OmniBar, "PLAYER_ENTERING_WORLD")
end

function OmniBarOptionsPanelShowAshran_Update(value)
	OmniBar.settings.noAshran = value == "0"
	OmniBar_OnEvent(OmniBar, "PLAYER_ENTERING_WORLD")
end

function OmniBarOptionsPanelTrackMultiple_Update(value)
	OmniBar.settings.noMultiple = value == "0"
	OmniBar_OnEvent(OmniBar, "PLAYER_ENTERING_WORLD")
end

function OmniBarOptionsPanelGlow_Update(value)
	OmniBar.settings.noGlow = value == "0"
end

function OmniBarOptionsPanelTooltips_Update(value)
	OmniBar.settings.noTooltips = value == "0"
end

local function OmniBarOptionsPanelSizeSlider_OnValueChanged(self, value)
	_G[self:GetName() .. "High"]:SetText(value)
	OmniBar.settings.size = value
	OmniBar.container:SetScale(value/OmniBar.BASE_ICON_SIZE)
end

function OmniBarOptionsPanelSize_OnLoad(self)
	self.slider:SetMinMaxValues(10, 200)
	self.slider:SetScript("OnValueChanged", OmniBarOptionsPanelSizeSlider_OnValueChanged)
end

function OmniBarOptionsPanelColumnsSlider_OnValueChanged(self, value)
	_G[self:GetName() .. "High"]:SetText(value >= 100 and L.Unlimited or value)
	OmniBar.settings.columns = value < 100 and value or 0
	OmniBar_Position(OmniBar)
end

function OmniBarOptionsPanelPaddingSlider_OnValueChanged(self, value)
	_G[self:GetName() .. "High"]:SetText(value)
	OmniBar.settings.padding = value
	OmniBar_Position(OmniBar)
end

function OmniBarOptionsPanelUnusedAlphaSlider_OnValueChanged(self, value)
	_G[self:GetName() .. "High"]:SetText(value.."%")
	OmniBar.settings.unusedAlpha = value/100
	OmniBar_UpdateIcons(OmniBar)
end

function OmniBarOptionsPanelSwipeAlphaSlider_OnValueChanged(self, value)
	_G[self:GetName() .. "High"]:SetText(value.."%")
	OmniBar.settings.swipeAlpha = value/100
	OmniBar_UpdateIcons(OmniBar)
end

OmniBarOptions.refresh = function()
	OmniBarOptionsPanelLock:SetChecked(OmniBar.settings.locked)
	OmniBarOptionsPanelShowUnused:SetChecked(OmniBar.settings.showUnused)
	OmniBarOptionsPanelAsEnemiesAppear:SetChecked(OmniBar.settings.adaptive)
	if OmniBar.settings.showUnused then
		OmniBarOptionsPanelAsEnemiesAppear:Enable()
	else
		OmniBarOptionsPanelAsEnemiesAppear:Disable()
	end
	OmniBarOptionsPanelUseGlobal:SetChecked(OmniBar.profile == "Default")
	OmniBarOptionsPanelGrowUpward:SetChecked(OmniBar.settings.growUpward)
	OmniBarOptionsPanelCountdownCount:SetChecked(not OmniBar.settings.noCooldownCount)
	OmniBarOptionsPanelCenterLock:SetChecked(OmniBar.settings.center)
	OmniBarOptionsPanelShowBorder:SetChecked(OmniBar.settings.border)
	OmniBarOptionsPanelHighlightTarget:SetChecked(not OmniBar.settings.noHighlightTarget)
	OmniBarOptionsPanelHighlightFocus:SetChecked(not OmniBar.settings.noHighlightFocus)
	OmniBarOptionsPanelShowArena:SetChecked(not OmniBar.settings.noArena)
	OmniBarOptionsPanelShowRatedBattleground:SetChecked(not OmniBar.settings.noRatedBattleground)
	OmniBarOptionsPanelShowBattleground:SetChecked(not OmniBar.settings.noBattleground)
	OmniBarOptionsPanelShowWorld:SetChecked(not OmniBar.settings.noWorld)
	OmniBarOptionsPanelShowAshran:SetChecked(not OmniBar.settings.noAshran)
	OmniBarOptionsPanelTrackMultiple:SetChecked(not OmniBar.settings.noMultiple)
	OmniBarOptionsPanelGlow:SetChecked(not OmniBar.settings.noGlow)
	OmniBarOptionsPanelTooltips:SetChecked(not OmniBar.settings.noTooltips)
	OmniBarOptionsPanelSizeSlider:SetValue(OmniBar.settings.size)
	OmniBarOptionsPanelPaddingSlider:SetValue(OmniBar.settings.padding or 0)
	OmniBarOptionsPanelColumnsSlider:SetValue(OmniBar.settings.columns and OmniBar.settings.columns > 0 and OmniBar.settings.columns or 100)
	OmniBarOptionsPanelUnusedAlphaSlider:SetValue(OmniBar.settings.unusedAlpha and OmniBar.settings.unusedAlpha*100 or 1)
	OmniBarOptionsPanelSwipeAlphaSlider:SetValue(OmniBar.settings.swipeAlpha and OmniBar.settings.swipeAlpha*100 or 65)
end

local subIndex = 1
local function CreateSub(name)
	local OptionsPanelFrame = CreateFrame("Frame", "OmniBarOptionsPanel"..subIndex)
	OptionsPanelFrame.spells = {}
	OptionsPanelFrame.parent = "OmniBar"
	OptionsPanelFrame.name = LOCALIZED_CLASS_NAMES_MALE[name] or L[name]

	local index, parent = 1
	for spellID, cooldown in pairs(OmniBar.cooldowns) do
		if not cooldown.parent then -- make sure it isn't a child
			if cooldown.class == name then
				local spell = CreateFrame("CheckButton", "OmniBarOptionsPanel"..subIndex.."Item"..index, OptionsPanelFrame, "OptionsCheckButtonTemplate")
				local text = GetSpellInfo(spellID) or ""
				-- Truncate long spell names
				if string.len(text) > 25 then
					text = string.sub(text, 0, 22) .. "..."
				end
				_G["OmniBarOptionsPanel"..subIndex.."Item"..index.."Text"]:SetText(text)

				-- Show the spell tooltip
				spell.spellID = spellID
				spell:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetSpellByID(self.spellID)
				end)
				spell:SetScript("OnLeave", function(self)
					GameTooltip:Hide()
				end)

				spell.setFunc = function(value)
					if not OmniBar.settings.cooldowns[spellID] then OmniBar.settings.cooldowns[spellID] = {} end
					local enabled = value == "1"
					OmniBar.settings.cooldowns[spellID].enabled = enabled
					if enabled then OmniBar_CreateIcon(OmniBar) end
					OmniBar_RefreshIcons(OmniBar)
					OmniBar_UpdateIcons(OmniBar)
					local i = 1
					while _G["OmniBarOptionsPanel"..i] do
						_G["OmniBarOptionsPanel"..i]:refresh()
						i = i + 1
					end
				end

				if index > 1 then
					-- Split into columns if we're showing all cooldowns
					if (index-1) % 3 == 0 then
						spell:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -2)
						parent = spell
					else
						spell:SetPoint("TOPLEFT", left, "TOPLEFT", 190, 0)
					end
				else
					spell:SetPoint("TOPLEFT", 24, -24)
					parent = spell
				end
				left = spell
				index = index + 1
				spell.spellID = spellID
				table.insert(OptionsPanelFrame.spells, spell)
			end
		end
	end
	
	OptionsPanelFrame.default = OmniBarOptions.default
	OptionsPanelFrame.refresh = function(self)
		for i = 1, #self.spells do
			self.spells[i]:SetChecked(OmniBar_IsSpellEnabled(OmniBar, self.spells[i].spellID))
		end
	end

	InterfaceOptions_AddCategory(OptionsPanelFrame)
	subIndex = subIndex + 1
	InterfaceAddOnsList_Update()
end

for i in pairs(CLASS_SORT_ORDER) do
	CreateSub(CLASS_SORT_ORDER[i])
end
