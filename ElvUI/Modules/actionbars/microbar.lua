local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local AB = E:GetModule('ActionBars');

--Cache global variables
--Lua functions
local _G = _G
local assert = assert
--WoW API / Variables
local CreateFrame = CreateFrame
local UpdateMicroButtonsParent = UpdateMicroButtonsParent
local RegisterStateDriver = RegisterStateDriver
local InCombatLockdown = InCombatLockdown

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: ElvUI_MicroBar, MainMenuBarPerformanceBar, MainMenuMicroButton
-- GLOBALS: MICRO_BUTTONS, CharacterMicroButton, GuildMicroButtonTabard
-- GLOBALS: GuildMicroButton, MicroButtonPortrait, CollectionsMicroButtonAlert

local function Button_OnEnter()
	if AB.db.microbar.mouseover then
		E:UIFrameFadeIn(ElvUI_MicroBar, 0.2, ElvUI_MicroBar:GetAlpha(), AB.db.microbar.alpha)
	end
end

local function Button_OnLeave()
	if AB.db.microbar.mouseover then
		E:UIFrameFadeOut(ElvUI_MicroBar, 0.2, ElvUI_MicroBar:GetAlpha(), 0)
	end
end

function AB:HandleMicroButton(button)
	assert(button, 'Invalid micro button name.')

	local pushed = button:GetPushedTexture()
	local normal = button:GetNormalTexture()
	local disabled = button:GetDisabledTexture()

	button:SetParent(ElvUI_MicroBar)
	button.Flash:SetTexture(nil)
	button:GetHighlightTexture():Kill()
	button:HookScript('OnEnter', Button_OnEnter)
	button:HookScript('OnLeave', Button_OnLeave)

	local f = CreateFrame("Frame", nil, button)
	f:SetFrameLevel(1)
	f:SetFrameStrata("BACKGROUND")
	f:Point("BOTTOMLEFT", button, "BOTTOMLEFT", 2, 0)
	f:Point("TOPRIGHT", button, "TOPRIGHT", -2, -28)
	f:SetTemplate("Default", true)
	button.backdrop = f

	pushed:SetTexCoord(0.17, 0.87, 0.5, 0.908)
	pushed:SetInside(f)

	normal:SetTexCoord(0.17, 0.87, 0.5, 0.908)
	normal:SetInside(f)

	if disabled then
		disabled:SetTexCoord(0.17, 0.87, 0.5, 0.908)
		disabled:SetInside(f)
	end
end

function AB:MainMenuMicroButton_SetNormal()
	MainMenuBarPerformanceBar:Point("TOPLEFT", MainMenuMicroButton, "TOPLEFT", 9, -36);
end

function AB:MainMenuMicroButton_SetPushed()
	MainMenuBarPerformanceBar:Point("TOPLEFT", MainMenuMicroButton, "TOPLEFT", 8, -37);
end

function AB:UpdateMicroButtonsParent()
	for i=1, #MICRO_BUTTONS do
		_G[MICRO_BUTTONS[i]]:SetParent(ElvUI_MicroBar);
	end
end

local __buttons = {}
-- if(C_StorePublic.IsEnabled()) then
	__buttons[10] = "StoreMicroButton"
	for i=10, #MICRO_BUTTONS do
		__buttons[i + 1] = MICRO_BUTTONS[i]
	end
-- end

function AB:UpdateMicroBarVisibility()
	if InCombatLockdown() then
		AB.NeedsUpdateMicroBarVisibility = true
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
		return
	end

	local visibility = self.db.microbar.visibility
	if visibility and visibility:match('[\n\r]') then
		visibility = visibility:gsub('[\n\r]','')
	end

	RegisterStateDriver(ElvUI_MicroBar.visibility, "visibility", (self.db.microbar.enabled and visibility) or "hide");
end

function AB:UpdateMicroPositionDimensions()
	if not ElvUI_MicroBar then return end

	local numRows = 1
	local prevButton = ElvUI_MicroBar
	for i=1, (#MICRO_BUTTONS) do
		local button = _G[__buttons[i]] or _G[MICRO_BUTTONS[i]]
		local lastColumnButton = i-self.db.microbar.buttonsPerRow;
		lastColumnButton = _G[__buttons[lastColumnButton]] or _G[MICRO_BUTTONS[lastColumnButton]]

		button:Width(28)
		button:Height(58)
		button:ClearAllPoints();

		if prevButton == ElvUI_MicroBar then
			button:Point("TOPLEFT", prevButton, "TOPLEFT", -2, 28)
		elseif (i - 1) % self.db.microbar.buttonsPerRow == 0 then
			button:Point('TOP', lastColumnButton, 'BOTTOM', 0, 27);
			numRows = numRows + 1
		else
			button:Point('LEFT', prevButton, 'RIGHT', -3, 0);
		end

		prevButton = button
	end

	if AB.db.microbar.mouseover then
		ElvUI_MicroBar:SetAlpha(0)
	else
		ElvUI_MicroBar:SetAlpha(self.db.microbar.alpha)
	end

	AB.MicroWidth = ((_G["CharacterMicroButton"]:GetWidth() - 3) * self.db.microbar.buttonsPerRow)-1
	AB.MicroHeight = (((_G["CharacterMicroButton"]:GetHeight() - 26) * numRows)-numRows)-1
	ElvUI_MicroBar:Size(AB.MicroWidth, AB.MicroHeight)

	if ElvUI_MicroBar.mover then
		if self.db.microbar.enabled then
			E:EnableMover(ElvUI_MicroBar.mover:GetName())
		else
			E:DisableMover(ElvUI_MicroBar.mover:GetName())
		end
	end

	self:UpdateMicroBarVisibility()
end

function AB:UpdateMicroButtons()
	GuildMicroButtonTabard:ClearAllPoints()
	GuildMicroButtonTabard:Point("TOP", GuildMicroButton.backdrop, "TOP", 0, 25)
	self:UpdateMicroPositionDimensions()
end

function AB:SetupMicroBar()
	local microBar = CreateFrame('Frame', 'ElvUI_MicroBar', E.UIParent)
	microBar:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -48)

	microBar.visibility = CreateFrame('Frame', nil, E.UIParent, 'SecureHandlerStateTemplate')
	microBar.visibility:SetScript("OnShow", function() microBar:Show() end)
	microBar.visibility:SetScript("OnHide", function() microBar:Hide() end)

	E.FrameLocks["ElvUI_MicroBar"] = true;
	for i=1, #MICRO_BUTTONS do
		self:HandleMicroButton(_G[MICRO_BUTTONS[i]])
	end

	MicroButtonPortrait:SetInside(CharacterMicroButton.backdrop)

	self:SecureHook('MainMenuMicroButton_SetPushed')
	self:SecureHook('MainMenuMicroButton_SetNormal')
	self:SecureHook('UpdateMicroButtonsParent')
	self:SecureHook('MoveMicroButtons', 'UpdateMicroPositionDimensions')
	self:SecureHook('UpdateMicroButtons')
	UpdateMicroButtonsParent(microBar)
	self:MainMenuMicroButton_SetNormal()
	self:UpdateMicroPositionDimensions()
	MainMenuBarPerformanceBar:Kill()
	CollectionsMicroButtonAlert:Kill()
	E:CreateMover(microBar, 'MicrobarMover', L["Micro Bar"], nil, nil, nil, 'ALL,ACTIONBARS');
end