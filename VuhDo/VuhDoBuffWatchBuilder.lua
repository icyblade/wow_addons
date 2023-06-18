local _;
local _G = _G;

local pairs = pairs;

local VUHDO_BUFF_PANEL_BASE_HEIGHT;
local VUHDO_BUFF_PANEL_BASE_WIDTH;
local VUHDO_IN_PANEL_HEIGHT;
local VUHDO_PANEL_OFFSET_Y;
local VUHDO_PANEL_OFFSET_X;
local VUHDO_PANEL_WIDTH = 0;
local VUHDO_PANEL_HEIGHT = 0;
local VUHDO_BUFF_PANEL_GAP_X = 4;
local VUHDO_BUFF_PANEL_GAP_TOP = 4;



--
local function VUHDO_addBuffSwatch(aBuffPanel, aGroupName, aBuffInfo, aBuffTarget, aCategSpec)
	if not aBuffInfo then return nil; end

	local tBuffName = aBuffInfo[1];
	local tPostfix = tBuffName .. aBuffInfo[2] .. (aBuffTarget or "");

	local tSwatch = VUHDO_getOrCreateBuffSwatch("VuhDoBuffSwatch_" .. tPostfix, aBuffPanel);
	tSwatch:SetAttribute("buff", aBuffInfo);
	tSwatch:SetAttribute("target", aBuffTarget);
	tSwatch:SetAttribute("buffname", aCategSpec);

	_G[tSwatch:GetName() .. "GroupLabelLabel"]:SetText(aGroupName);

	tSwatch:SetPoint("TOPLEFT", aBuffPanel:GetName(), "TOPLEFT", VUHDO_BUFF_PANEL_BASE_WIDTH, -VUHDO_BUFF_PANEL_BASE_HEIGHT);
	tSwatch:SetBackdropBorderColor(VUHDO_backColor(VUHDO_BUFF_SETTINGS["CONFIG"]["SWATCH_BORDER_COLOR"]));
	tSwatch:Show();

	local tButton = _G[tSwatch:GetName() .. "GlassButton"];
	if not tButton:GetAttribute("unit") then
		VUHDO_setupAllBuffButtonsTo(tButton, tBuffName, "player", aBuffInfo[2]);
	end

	VUHDO_IN_PANEL_HEIGHT = VUHDO_BUFF_PANEL_BASE_HEIGHT + tSwatch:GetHeight();
	VUHDO_updateBuffSwatch(tSwatch);

	local tIsSingle = VUHDO_isUseSingleBuff(tSwatch);
	if tIsSingle ~= 2 then
		if tIsSingle then
			VUHDO_setupAllBuffButtonsTo(tButton, tBuffName, tSwatch:GetAttribute("lowtarget"), aBuffInfo[2]);
		else
			VUHDO_setupAllBuffButtonUnits(tButton, tSwatch:GetAttribute("goodtarget"));
		end
	end

	return tSwatch;
end



--
function VUHDO_getBuffInfoForName(aBuffName, aCategoryName)
	for _, tBuffInfo in pairs(VUHDO_getPlayerClassBuffs()[aCategoryName]) do
		if aBuffName == tBuffInfo[1] then
			return tBuffInfo;
		end
	end

	return nil;
end



--
local function VUHDO_addBuffPanel(aCategorySpec)
	local tCategName = aCategorySpec;
	local tSettings = VUHDO_BUFF_SETTINGS[tCategName];
	local tFirstVariant = VUHDO_getPlayerClassBuffs()[aCategorySpec][1];
	local tBuffPanel, tSwatch;
	local tIcon;
	local tTargetType;
	local tIconFrame;
	local tTexture;
	local tLabelText;

	-- Happens on emergency login
	if not VUHDO_BUFFS[tFirstVariant[1]] then	return nil; end

	tTargetType = tFirstVariant[2];
	tLabelText = VUHDO_BUFF_SETTINGS[tCategName]["buff"] or tFirstVariant[1];
	tBuffPanel = VUHDO_getOrCreateBuffPanel("VuhDoBuffPanel" .. tLabelText .. tTargetType);

	if VUHDO_BUFF_SETTINGS["CONFIG"]["COMPACT"] then
		VUHDO_BUFF_PANEL_BASE_WIDTH = 24;
		VUHDO_BUFF_PANEL_BASE_HEIGHT = 0;
	else
		VUHDO_BUFF_PANEL_BASE_WIDTH = 0;
		VUHDO_BUFF_PANEL_BASE_HEIGHT = 30;
	end

	tIcon = (VUHDO_BUFFS[tLabelText] ~= nil and VUHDO_BUFFS[tLabelText]["icon"] ~= nil)
		and VUHDO_BUFFS[tLabelText]["icon"]	or VUHDO_BUFFS[tFirstVariant[1]]["icon"];

	if not tIcon then return nil; end

	local tLabel = _G[tBuffPanel:GetName() .. "BuffNameLabelLabel"];
	tLabel:SetText(tLabelText);
	tLabel:SetShown(VUHDO_BUFF_SETTINGS["CONFIG"]["SHOW_LABEL"] and not VUHDO_BUFF_SETTINGS["CONFIG"]["COMPACT"]);

	tIconFrame = _G[tBuffPanel:GetName() .. "IconTexture"];
	tTexture = _G[tIconFrame:GetName() .. "Texture"];
	tTexture:SetTexture(tIcon);

	local tGap = VUHDO_BUFF_SETTINGS["CONFIG"]["COMPACT"] and 0 or 3
	tIconFrame:SetPoint("TOPLEFT", tBuffPanel:GetName(), "TOPLEFT" , tGap, -tGap);

	if VUHDO_LibButtonFacade then
		VUHDO_LibButtonFacade:Group("VuhDo", VUHDO_I18N_BUFF_WATCH):AddButton(tIconFrame, { ["Icon"] = tTexture });
	end

	VUHDO_IN_PANEL_HEIGHT = 0;
	tSwatch = nil;

	if VUHDO_BUFF_TARGET_UNIQUE == tTargetType then
		if not tSettings["name"] then tSettings["name"] = VUHDO_PLAYER_NAME; end
		tSwatch = VUHDO_addBuffSwatch(tBuffPanel, tSettings["name"], tFirstVariant, "N" .. tSettings["name"], aCategorySpec);
	else
		local tVariants = VUHDO_getBuffInfoForName(tSettings["buff"], aCategorySpec) or VUHDO_getBuffInfoForName(tFirstVariant[1], aCategorySpec);
		if tVariants then
			tSwatch = VUHDO_addBuffSwatch(tBuffPanel, VUHDO_I18N_PLAYER, tVariants, "S", aCategorySpec);
		end
	end

	if tSwatch then
		tBuffPanel:SetPoint("TOPLEFT", "VuhDoBuffWatchMainFrame", "TOPLEFT", VUHDO_PANEL_OFFSET_X, -VUHDO_PANEL_OFFSET_Y);
		tBuffPanel:SetWidth(tSwatch:GetWidth() + VUHDO_BUFF_PANEL_BASE_WIDTH);
		tBuffPanel:SetHeight(VUHDO_IN_PANEL_HEIGHT);
		_G[tBuffPanel:GetName() .. "BuffNameLabel"]:SetWidth(tBuffPanel:GetWidth() - 30);
		tBuffPanel:Show();
	end

	return tBuffPanel;
end



--
local function VUHDO_addAllBuffPanels()
	local tBuffPanel;
	local tColPanels;

	VUHDO_PANEL_OFFSET_Y = VUHDO_BUFF_PANEL_GAP_TOP;
	VUHDO_PANEL_OFFSET_X = VUHDO_BUFF_PANEL_GAP_X;
	VUHDO_PANEL_HEIGHT = VUHDO_BUFF_PANEL_GAP_TOP;
	VUHDO_PANEL_WIDTH = VUHDO_BUFF_PANEL_GAP_X;
	VUHDO_IN_GRID_MAX_X = 0;

	tColPanels = 0;
	local tIndex = 0;

	for _, _ in pairs(VUHDO_getPlayerClassBuffs()) do
		for tCategName, _ in pairs(VUHDO_getPlayerClassBuffs()) do

			if VUHDO_BUFF_ORDER[tCategName] == tIndex + 1 then
				tIndex = tIndex + 1;
				if (VUHDO_BUFF_SETTINGS[tCategName] or { })["enabled"] then

					tBuffPanel = VUHDO_addBuffPanel(tCategName);
					if tBuffPanel then
						tColPanels = tColPanels + 1;

						VUHDO_PANEL_OFFSET_Y = VUHDO_PANEL_OFFSET_Y + VUHDO_IN_PANEL_HEIGHT;

						if VUHDO_PANEL_OFFSET_Y > VUHDO_PANEL_HEIGHT then
							VUHDO_PANEL_HEIGHT = VUHDO_PANEL_OFFSET_Y;
						end

						if VUHDO_PANEL_OFFSET_X > VUHDO_PANEL_WIDTH then
							VUHDO_PANEL_WIDTH = VUHDO_PANEL_OFFSET_X;
						end

						if tColPanels >= VUHDO_BUFF_SETTINGS["CONFIG"]["PANEL_MAX_BUFFS"] then
							VUHDO_PANEL_OFFSET_Y = VUHDO_BUFF_PANEL_GAP_TOP;
							VUHDO_PANEL_OFFSET_X = VUHDO_PANEL_OFFSET_X + tBuffPanel:GetWidth();
							VUHDO_IN_GRID_MAX_X = 0;

							tColPanels = 0;
						end
					end
				end

			end
		end
	end

	if tBuffPanel then
		VUHDO_PANEL_WIDTH = VUHDO_PANEL_WIDTH + tBuffPanel:GetWidth();
	end
end



--
local sIsForceHide = false;
function VUHDO_setBuffWatchForceHide(anIsForce)
	sIsForceHide = anIsForce;
end



--
function VUHDO_reloadBuffPanel()
	if InCombatLockdown() or sIsForceHide then return; end

	if not VUHDO_BUFF_SETTINGS["CONFIG"] then
		if VuhDoBuffWatchMainFrame then	VuhDoBuffWatchMainFrame:Hide(); end
		return;
	end

	VUHDO_resetBuffSwatchInfos();
	VUHDO_resetAllBuffPanels();

	if not VuhDoBuffWatchMainFrame then
		CreateFrame("Frame", "VuhDoBuffWatchMainFrame", UIParent, "VuhDoBuffWatchMainFrameTemplate");
	end

	VUHDO_addAllBuffPanels();

	if VUHDO_PANEL_HEIGHT < 10 then
		VUHDO_PANEL_HEIGHT = 24;
		VUHDO_PANEL_WIDTH = 150;
		VuhDoBuffWatchMainFrameInfoLabel:Show();
	else
		VuhDoBuffWatchMainFrameInfoLabel:Hide();
	end

	VuhDoBuffWatchMainFrame:ClearAllPoints();
	local tPosition = VUHDO_BUFF_SETTINGS["CONFIG"]["POSITION"];
	VuhDoBuffWatchMainFrame:SetPoint(tPosition["point"], "UIParent", tPosition["relativePoint"], tPosition["x"], tPosition["y"]);
	VuhDoBuffWatchMainFrame:SetWidth(VUHDO_PANEL_WIDTH + VUHDO_BUFF_PANEL_GAP_X);
	VuhDoBuffWatchMainFrame:SetHeight(VUHDO_PANEL_HEIGHT + VUHDO_BUFF_PANEL_GAP_TOP);
	VuhDoBuffWatchMainFrame:SetBackdropColor(VUHDO_backColor(VUHDO_BUFF_SETTINGS["CONFIG"]["PANEL_BG_COLOR"]));
	VuhDoBuffWatchMainFrame:SetBackdropBorderColor(VUHDO_backColor(VUHDO_BUFF_SETTINGS["CONFIG"]["PANEL_BORDER_COLOR"]));
	VuhDoBuffWatchMainFrame:SetScale(VUHDO_BUFF_SETTINGS["CONFIG"]["SCALE"]);

	if VUHDO_BUFF_SETTINGS["CONFIG"]["SHOW"] then
		VuhDoBuffWatchMainFrame:Show();
		if VUHDO_LibButtonFacade then
			VUHDO_LibButtonFacade:Group("VuhDo", VUHDO_I18N_BUFF_WATCH):Skin(VUHDO_BUFF_SETTINGS["CONFIG"]["BUTTON_FACADE"]);
		end
	else
		VuhDoBuffWatchMainFrame:Hide();
	end
end
