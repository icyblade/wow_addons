local pairs = pairs;
local ipairs = ipairs;
local InCombatLockdown = InCombatLockdown;


local VUHDO_BUFF_PANEL_BASE_HEIGHT = nil;
local VUHDO_BUFF_PANEL_BASE_WIDTH = nil;
local VUHDO_IN_PANEL_HEIGHT;
local VUHDO_PANEL_OFFSET_Y;
local VUHDO_PANEL_OFFSET_X;
local VUHDO_PANEL_WIDTH = 0;
local VUHDO_PANEL_HEIGHT = 0;
local VUHDO_BUFF_PANEL_GAP_X = 4;
local VUHDO_BUFF_PANEL_GAP_TOP = 4;


--
local tBuffName;
local tPostfix;
local tColor;
local tButton;
local tSwatch;
local tIsSingle;
local tTarget;
local function VUHDO_addBuffSwatch(aBuffPanel, aGroupName, aBuffInfo, aBuffTarget, aCategSpec)
	if (aBuffInfo == nil) then
		return nil;
	end

	tBuffName = aBuffInfo[1];

	if (VUHDO_MULTICAST_BUFFS[aCategSpec] ~= nil and VUHDO_MULTICAST_BUFFS[aCategSpec][tBuffName] ~= nil) then
		SetMultiCastSpell(VUHDO_MULTICAST_BUFFS[aCategSpec]["SLOT"], VUHDO_MULTICAST_BUFFS[aCategSpec][tBuffName]);
	end

	tPostfix = tBuffName .. (aBuffTarget or "");

	tSwatch = VUHDO_getOrCreateBuffSwatch("VuhDoBuffSwatch_" .. tPostfix, aBuffPanel);
	tSwatch:SetAttribute("buff", aBuffInfo);
	tSwatch:SetAttribute("target", aBuffTarget);
	tSwatch:SetAttribute("buffname", aCategSpec);

	VUHDO_GLOBAL[tSwatch:GetName() .. "GroupLabelLabel"]:SetText(aGroupName);

	tSwatch:SetPoint("TOPLEFT", aBuffPanel:GetName(), "TOPLEFT", VUHDO_BUFF_PANEL_BASE_WIDTH, -VUHDO_BUFF_PANEL_BASE_HEIGHT);
	tColor = VUHDO_BUFF_SETTINGS["CONFIG"]["SWATCH_BORDER_COLOR"];
	tSwatch:SetBackdropBorderColor(tColor["R"], tColor["G"], tColor["B"], tColor["O"]);
	tSwatch:Show();

	tButton = VUHDO_GLOBAL[tSwatch:GetName() .. "GlassButton"];
	if (tButton:GetAttribute("unit") == nil) then
		VUHDO_setupAllBuffButtonsTo(tButton, tBuffName, "player", tBuffName);
	end

	VUHDO_IN_PANEL_HEIGHT = VUHDO_BUFF_PANEL_BASE_HEIGHT + tSwatch:GetHeight();
	VUHDO_updateBuffSwatch(tSwatch);
	tIsSingle = VUHDO_isUseSingleBuff(tSwatch);
	if (tIsSingle ~= 2) then
		if (tIsSingle) then
			tTarget = tSwatch:GetAttribute("lowtarget");
			VUHDO_setupAllBuffButtonsTo(tButton, tBuffName, tTarget, tBuffName);
		else
			tTarget = tSwatch:GetAttribute("goodtarget");
			VUHDO_setupAllBuffButtonUnits(tButton, tTarget);
		end
	end

	return tSwatch;
end



--
local tCategBuffs, tBuffInfo;
local function VUHDO_getBuffInfoForName(aBuffName)
	for _, tCategBuffs in pairs(VUHDO_CLASS_BUFFS[VUHDO_PLAYER_CLASS]) do
		for _, tBuffInfo in pairs(tCategBuffs) do
			if (aBuffName == tBuffInfo[1]) then
				return tBuffInfo;
			end
		end
	end

	return nil;
end



--
local function VUHDO_addBuffPanel(aCategorySpec)
	local tCategName = strsub(aCategorySpec, 3);
	local tSettings = VUHDO_BUFF_SETTINGS[tCategName];
	local tCategBuffs = VUHDO_CLASS_BUFFS[VUHDO_PLAYER_CLASS][aCategorySpec];
	local tSampleVariant = tCategBuffs[1];
	local tBuffPanel, tSwatch;
	local tIcon;
	local tTargetType;
	local tIconFrame;
	local tTexture;
	local tLabelText;

	-- Happens on emergency login
	if (VUHDO_BUFFS[tSampleVariant[1]] == nil) then
		return nil;
	end

	tTargetType = tSampleVariant[2];
	tLabelText = VUHDO_BUFF_SETTINGS[tCategName]["buff"] or tSampleVariant[1];
	tBuffPanel = VUHDO_getOrCreateBuffPanel("VuhDoBuffPanel" .. tLabelText);

	if (VUHDO_BUFF_SETTINGS["CONFIG"]["COMPACT"]) then
		VUHDO_BUFF_PANEL_BASE_WIDTH = 24;
		VUHDO_BUFF_PANEL_BASE_HEIGHT = 0;
	else
		VUHDO_BUFF_PANEL_BASE_WIDTH = 0;
		VUHDO_BUFF_PANEL_BASE_HEIGHT = 30;
	end

	tIcon = (VUHDO_BUFFS[tLabelText] ~= nil and VUHDO_BUFFS[tLabelText]["icon"] ~= nil)
		and VUHDO_BUFFS[tLabelText]["icon"]
		or VUHDO_BUFFS[tSampleVariant[1]]["icon"];

	if (tIcon == nil) then
		return nil;
	end

	local tLabel = VUHDO_GLOBAL[tBuffPanel:GetName() .. "BuffNameLabelLabel"];
	if (VUHDO_BUFF_SETTINGS["CONFIG"]["SHOW_LABEL"] and not VUHDO_BUFF_SETTINGS["CONFIG"]["COMPACT"]) then
		tLabel:SetText(tLabelText);
		tLabel:Show();
	else
		tLabel:Hide();
	end

	tTexture = VUHDO_GLOBAL[tBuffPanel:GetName() .. "IconTextureTexture"];
	tTexture:SetTexture(tIcon);

	tIconFrame = VUHDO_GLOBAL[tBuffPanel:GetName() .. "IconTexture"];
	tIconFrame:ClearAllPoints();
	if (VUHDO_BUFF_SETTINGS["CONFIG"]["COMPACT"]) then
		tIconFrame:SetPoint("TOPLEFT", tBuffPanel:GetName(), "TOPLEFT" , 0, 0);
	else
		tIconFrame:SetPoint("TOPLEFT", tBuffPanel:GetName(), "TOPLEFT" , 3, -3);
	end

	if (VUHDO_LibButtonFacade ~= nil) then
		VUHDO_LibButtonFacade:Group("VuhDo", VUHDO_I18N_BUFF_WATCH):AddButton(tIconFrame, {
			["Icon"] = tTexture,
		});
	end

	VUHDO_IN_PANEL_HEIGHT = 0;
	tSwatch = nil;

	if (VUHDO_BUFF_TARGET_SINGLE == tTargetType) then
		local tVariants = VUHDO_getBuffInfoForName(tSettings["buff"]) or VUHDO_getBuffInfoForName(tSampleVariant[1]);
		if (tVariants ~= nil) then
			tSwatch = VUHDO_addBuffSwatch(tBuffPanel, VUHDO_I18N_PLAYER, tVariants, "S", aCategorySpec);
		end
	elseif (VUHDO_BUFF_TARGET_UNIQUE == tTargetType) then
		if (tSettings["name"] == nil) then
			tSettings["name"] = VUHDO_PLAYER_NAME;
		end
		tSwatch = VUHDO_addBuffSwatch(tBuffPanel, tSettings["name"], tCategBuffs[1], "N" .. tSettings["name"], aCategorySpec);
	else
		local tVariants = VUHDO_getBuffInfoForName(tSettings["buff"]) or VUHDO_getBuffInfoForName(tSampleVariant[1]);
		if (tVariants ~= nil) then
			tSwatch = VUHDO_addBuffSwatch(tBuffPanel, VUHDO_I18N_PLAYER, tVariants, "S", aCategorySpec);
		end
	end

	if (tSwatch ~= nil) then
		tBuffPanel:SetPoint("TOPLEFT", "VuhDoBuffWatchMainFrame", "TOPLEFT", VUHDO_PANEL_OFFSET_X, -VUHDO_PANEL_OFFSET_Y);
		tBuffPanel:SetWidth(tSwatch:GetWidth() + VUHDO_BUFF_PANEL_BASE_WIDTH);
		tBuffPanel:SetHeight(VUHDO_IN_PANEL_HEIGHT);
		VUHDO_GLOBAL[tBuffPanel:GetName() .. "BuffNameLabel"]:SetWidth(tBuffPanel:GetWidth() - 30);
		tBuffPanel:Show();
	end

	return tBuffPanel;
end



--
local function VUHDO_addAllBuffPanels()
	local tCategSpec, tCategName;
	local tAllClassBuffs = VUHDO_CLASS_BUFFS[VUHDO_PLAYER_CLASS];
	local tBuffPanel;
	local tColPanels;

	VUHDO_PANEL_OFFSET_Y = VUHDO_BUFF_PANEL_GAP_TOP;
	VUHDO_PANEL_OFFSET_X = VUHDO_BUFF_PANEL_GAP_X;
	VUHDO_PANEL_HEIGHT = VUHDO_BUFF_PANEL_GAP_TOP;
	VUHDO_PANEL_WIDTH = VUHDO_BUFF_PANEL_GAP_X;
	VUHDO_IN_GRID_MAX_X = 0;

	tColPanels = 0;
	local tIndex = 0;

	for _, _ in pairs(tAllClassBuffs) do
		for tCategSpec, _ in pairs(tAllClassBuffs) do
			tCategName = strsub(tCategSpec, 3);

			local tNumber = VUHDO_BUFF_ORDER[tCategSpec] == nil
				and tonumber(strsub(tCategSpec, 1, 2))
				or VUHDO_BUFF_ORDER[tCategSpec];

			local tCategSettings = VUHDO_BUFF_SETTINGS[tCategName];
			if (tNumber == tIndex + 1) then
				tIndex = tIndex + 1;
				if (tCategSettings ~= nil and tCategSettings["enabled"]) then

					tBuffPanel = VUHDO_addBuffPanel(tCategSpec);
					if (tBuffPanel ~= nil) then
						tColPanels = tColPanels + 1;

						VUHDO_PANEL_OFFSET_Y = VUHDO_PANEL_OFFSET_Y + VUHDO_IN_PANEL_HEIGHT;

						if (VUHDO_PANEL_OFFSET_Y > VUHDO_PANEL_HEIGHT) then
							VUHDO_PANEL_HEIGHT = VUHDO_PANEL_OFFSET_Y;
						end

						if (VUHDO_PANEL_OFFSET_X > VUHDO_PANEL_WIDTH) then
							VUHDO_PANEL_WIDTH = VUHDO_PANEL_OFFSET_X;
						end

						if (tColPanels >= VUHDO_BUFF_SETTINGS["CONFIG"]["PANEL_MAX_BUFFS"]) then
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

	if (tBuffPanel ~= nil) then
		VUHDO_PANEL_WIDTH = VUHDO_PANEL_WIDTH + tBuffPanel:GetWidth();
	end

	return tBuffPanel;
end




--
function VUHDO_reloadBuffPanel()
	if (InCombatLockdown()) then
		return;
	end

	if (VUHDO_BUFF_SETTINGS["CONFIG"] == nil) then
		if (VuhDoBuffWatchMainFrame ~= nil) then
			VuhDoBuffWatchMainFrame:Hide();
		end
		return;
	end

	VUHDO_REFRESH_BUFFS_TIMER = 0;
	VUHDO_resetBuffSwatchInfos();
	VUHDO_resetAllBuffPanels();

	if (VUHDO_CLASS_BUFFS[VUHDO_PLAYER_CLASS] == nil) then
		return;
	end

	if (VuhDoBuffWatchMainFrame == nil) then
		CreateFrame("Frame", "VuhDoBuffWatchMainFrame", UIParent, "VuhDoBuffWatchMainFrameTemplate");
	end

	local tBuffPanel = VUHDO_addAllBuffPanels();

	if (VUHDO_PANEL_HEIGHT < 10) then
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


	local tColor = VUHDO_BUFF_SETTINGS["CONFIG"]["PANEL_BG_COLOR"];
	VuhDoBuffWatchMainFrame:SetBackdropColor(tColor["R"], tColor["G"], tColor["B"], tColor["O"]);
	tColor = VUHDO_BUFF_SETTINGS["CONFIG"]["PANEL_BORDER_COLOR"];
	VuhDoBuffWatchMainFrame:SetBackdropBorderColor(tColor["R"], tColor["G"], tColor["B"], tColor["O"]);
	VuhDoBuffWatchMainFrame:SetScale(VUHDO_BUFF_SETTINGS["CONFIG"]["SCALE"]);

	if (VUHDO_BUFF_SETTINGS["CONFIG"]["SHOW"]) then
		VuhDoBuffWatchMainFrame:Show();
		if (VUHDO_LibButtonFacade ~= nil) then
			VUHDO_LibButtonFacade:Group("VuhDo", VUHDO_I18N_BUFF_WATCH):Skin(VUHDO_BUFF_SETTINGS["CONFIG"]["BUTTON_FACADE"]);
		end
	else
		VuhDoBuffWatchMainFrame:Hide();
	end

	VUHDO_REFRESH_BUFFS_TIMER = VUHDO_BUFF_SETTINGS["CONFIG"]["REFRESH_SECS"];
end



--
function VUHDO_setTotemSlotTo(aSlotNum)
	local tType, tCurrentSpellId, _ = GetActionInfo(aSlotNum);

	if ("spell" ~= tType) then
		return;
	end

	local tCategSpec, tCategSpells;
	local tSpellName, tSpellId;

	for tCategSpec, tCategSpells in pairs(VUHDO_MULTICAST_BUFFS) do

		if (tCategSpells["SLOT"] == aSlotNum) then
			for tSpellName, tSpellId in pairs(tCategSpells) do

				if (tCurrentSpellId == tSpellId) then
					local tCategName = strsub(tCategSpec, 3);
					if (VUHDO_BUFF_SETTINGS[tCategName]["buff"] ~= tSpellName) then -- wichtig, damit wir uns nicht selbst auslösen => Endlosschleife
						VUHDO_BUFF_SETTINGS[tCategName]["buff"] = tSpellName;
						VUHDO_reloadBuffPanel();
					end
					return;
				end

			end
			--VUHDO_xMsg("Error unknown totem id:", tCurrentSpellId, " for slot:", aSlotNum);
		end

	end
end
