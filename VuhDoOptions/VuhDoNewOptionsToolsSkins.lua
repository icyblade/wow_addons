VUHDO_CURRENT_PROFILE = "";

VUHDO_PROFILE_TABLE_MODEL = { };

--
function VUHDO_initProfileTableModels(aButton)
	local tIndex, tValue;

	table.wipe(VUHDO_PROFILE_TABLE_MODEL);
	VUHDO_PROFILE_TABLE_MODEL[1] = { "", "-- " .. VUHDO_I18N_EMPTY_HOTS .. " --" };
	for tIndex, tValue in ipairs(VUHDO_PROFILES) do
		VUHDO_PROFILE_TABLE_MODEL[tIndex + 1] = { tValue["NAME"], tValue["NAME"] };
	end

	table.sort(VUHDO_PROFILE_TABLE_MODEL,
	function(anInfo, anotherInfo)
		return anInfo[1] < anotherInfo[1];
	end
	);

end



local VUHDO_PROFILE_COMBO = nil;
local VUHDO_PROFILE_EDIT = nil;



--
function VUHDO_setProfileCombo(aComboBox)
	VUHDO_PROFILE_COMBO = aComboBox;
end



--
function VUHDO_setProfileEditBox(anEditBox)
	VUHDO_PROFILE_EDIT = anEditBox;
end



--
function VUHDO_updateProfileSelectCombo()
	VUHDO_initProfileTableModels();
	VUHDO_lnfComboBoxInitFromModel(VUHDO_PROFILE_COMBO);
	VUHDO_lnfEditBoxInitFromModel(VUHDO_PROFILE_EDIT);
end



--
local function VUHDO_clearProfileIfInSlot(aProfileName, aSlot)
	if (VUHDO_CONFIG["AUTO_PROFILES"][aSlot] == aProfileName) then
		VUHDO_CONFIG["AUTO_PROFILES"][aSlot] = nil;
		--VUHDO_Msg("Removing " .. aProfileName .. " from " .. aSlot);
	end
end



--
local tCnt;
local function VUHDO_deleteAutoProfile(aName)
	for tCnt = 1, 40 do
		VUHDO_clearProfileIfInSlot(aName, "" .. tCnt);
		VUHDO_clearProfileIfInSlot(aName, "SPEC_1_" .. tCnt);
		VUHDO_clearProfileIfInSlot(aName, "SPEC_2_" .. tCnt);
	end

	VUHDO_clearProfileIfInSlot(aName, "SPEC_1");
	VUHDO_clearProfileIfInSlot(aName, "SPEC_2");
end



--
local tCnt;
local function VUHDO_isAutoProfileButtonEnabled(aButtonIndex)
	if (VUHDO_CONFIG["AUTO_PROFILES"][aButtonIndex] == VUHDO_CURRENT_PROFILE) then
		return true;
	elseif (strfind(aButtonIndex, "SPEC", 1, true) ~= nil) then
		for tCnt = 1, 40 do
			if (VUHDO_CONFIG["AUTO_PROFILES"][aButtonIndex .. "_" .. tCnt] == VUHDO_CURRENT_PROFILE) then
				return true;
			end
		end
		return false;
	else -- Gruppenbutton
		return VUHDO_CONFIG["AUTO_PROFILES"]["SPEC_1_" .. aButtonIndex] == VUHDO_CURRENT_PROFILE
			or VUHDO_CONFIG["AUTO_PROFILES"]["SPEC_2_" .. aButtonIndex] == VUHDO_CURRENT_PROFILE;
	end
end



--
function VUHDO_skinsInitAutoCheckButton(aButton, anIndex)
	aButton:SetChecked(VUHDO_isAutoProfileButtonEnabled(anIndex));
	VUHDO_lnfCheckButtonClicked(aButton);
end



--
function VUHDO_skinsLockCheckButtonClicked(aButton)
	local tIndex, tProfile = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);
	if (tIndex ~= nil) then
		if (aButton:GetChecked()) then -- Achtung GetChecked liefert 1<->nil => Problem mit model consistency checker
			tProfile["LOCKED"] = true;
		else
			tProfile["LOCKED"] = false;
		end
	end
end



--
function VUHDO_skinsInitLockCheckButton(aButton)
	local tIndex, tProfile = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);
	aButton:SetChecked(tIndex ~= nil and tProfile["LOCKED"]);
	VUHDO_lnfCheckButtonClicked(aButton);
end



--
local tCnt;
local tButton;
local function VUHDO_updateAllAutoProfiles(aPanel)
	for tCnt = 1, 40 do
		tButton = VUHDO_GLOBAL[aPanel:GetName() .. "AutoEnablePanel" .. tCnt .. "CheckButton"];
		if (tButton ~= nil) then
			VUHDO_skinsInitAutoCheckButton(tButton, "" .. tCnt);
		end
	end

	tButton = VUHDO_GLOBAL[aPanel:GetName() .. "AutoEnablePanelSpec1CheckButton"];
	VUHDO_skinsInitAutoCheckButton(tButton, "SPEC_1");

	tButton = VUHDO_GLOBAL[aPanel:GetName() .. "AutoEnablePanelSpec2CheckButton"];
	VUHDO_skinsInitAutoCheckButton(tButton, "SPEC_2");

	tButton = VUHDO_GLOBAL[aPanel:GetName() .. "SettingsPanelLockCheckButton"];
	VUHDO_skinsInitLockCheckButton(tButton);
end



--
local tCnt, tGroupSize, tPrefix;
local function VUHDO_clearProfileFromPrefix(aProfileName, ...)
	for tCnt = 1, select('#', ...) do
		tPrefix = select(tCnt, ...);
		for tGroupSize = 1, 40 do
			VUHDO_clearProfileIfInSlot(aProfileName, tPrefix .. tGroupSize);
		end
	end
end




--
local tExistIndex;
local tIsSpec1;
local tIsSpec2;
local tPrefix;
local tIsGroupFound;
function VUHDO_skinsSaveAutoProfileButtonEnablement(aPanel, aProfileName)

	tExistIndex, _ = VUHDO_getProfileNamedCompressed(aProfileName);
	if (tExistIndex == nil) then
		return;
	end

	tIsSpec1 = VUHDO_GLOBAL[aPanel:GetName() .. "AutoEnablePanelSpec1CheckButton"]:GetChecked();
	tIsSpec2 = VUHDO_GLOBAL[aPanel:GetName() .. "AutoEnablePanelSpec2CheckButton"]:GetChecked();

	if (tIsSpec1 and not tIsSpec2) then
		tPrefix = "SPEC_1_";
		VUHDO_clearProfileFromPrefix(aProfileName, "", "SPEC_2_");
	elseif(tIsSpec2 and not tIsSpec1) then
		tPrefix = "SPEC_2_";
		VUHDO_clearProfileFromPrefix(aProfileName, "", "SPEC_1_");
	else
		tPrefix = "";
		VUHDO_clearProfileFromPrefix(aProfileName, "SPEC_1_", "SPEC_2_");
	end

	tIsGroupFound = false;
	for tCnt = 1, 40 do
		tButton = VUHDO_GLOBAL[aPanel:GetName() .. "AutoEnablePanel" .. tCnt .. "CheckButton"];
		if (tButton ~= nil) then
			if (tButton:GetChecked()) then
				VUHDO_CONFIG["AUTO_PROFILES"][tPrefix .. tCnt] = aProfileName;
				tIsGroupFound = true;
			elseif (VUHDO_CONFIG["AUTO_PROFILES"][tPrefix .. tCnt] == aProfileName) then
				VUHDO_CONFIG["AUTO_PROFILES"][tPrefix .. tCnt] = nil;
			end
		end
	end

	if (tIsGroupFound) then
		if (tIsSpec1 and not tIsSpec2) then
			VUHDO_clearProfileIfInSlot(aProfileName, "SPEC_1");
		elseif(tIsSpec2 and not tIsSpec1) then
			VUHDO_clearProfileIfInSlot(aProfileName, "SPEC_2");
		end
	else
		if (tIsSpec1 and not tIsSpec2) then
			VUHDO_CONFIG["AUTO_PROFILES"]["SPEC_1"] = aProfileName;
		elseif(tIsSpec2 and not tIsSpec1) then
			VUHDO_CONFIG["AUTO_PROFILES"]["SPEC_2"] = aProfileName;
		else
			VUHDO_clearProfileIfInSlot(aProfileName, "SPEC_1");
			VUHDO_clearProfileIfInSlot(aProfileName, "SPEC_2");
		end
	end

end



--
local tOldValue;
function VUHDO_profileComboValueChanged(aComboBox, aValue)
	tOldValue = VUHDO_lnfGetValueFromModel(aComboBox);
	if (aValue ~= tOldValue) then
		VUHDO_skinsSaveAutoProfileButtonEnablement(aComboBox:GetParent():GetParent(), tOldValue);
	end

	VUHDO_updateAllAutoProfiles(aComboBox:GetParent():GetParent());
end



--
function VUHDO_skinsAutoCheckButtonClicked(aButton, anIndex)
	local tExistIndex, _ = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);
	if (tExistIndex == nil) then
		VUHDO_Msg(VUHDO_I18N_ERROR_NO_PROFILE .. "\"" .. VUHDO_CURRENT_PROFILE .. "\" !", 1, 0.4, 0.4);
		aButton:SetChecked(false);
		VUHDO_lnfCheckButtonClicked(aButton);
		return;
	end

	--[[if (aButton:GetChecked()) then
		VUHDO_CONFIG["AUTO_PROFILES"][anIndex] = VUHDO_CURRENT_PROFILE;
	else
		VUHDO_CONFIG["AUTO_PROFILES"][anIndex] = nil;
	end]]
end





-- Delete -------------------------------


--
function VUHDO_deleteProfile(aName)
	local tIndex, _ = VUHDO_getProfileNamedCompressed(aName);

	if (tIndex ~= nil) then
		tremove(VUHDO_PROFILES, tIndex);
		VUHDO_deleteAutoProfile(aName);
		if (VUHDO_CURRENT_PROFILE == VUHDO_CONFIG["CURRENT_PROFILE"]) then
			VUHDO_CURRENT_PROFILE = "";
			VUHDO_CONFIG["CURRENT_PROFILE"] = "";
		else
			VUHDO_CURRENT_PROFILE = VUHDO_CONFIG["CURRENT_PROFILE"];
		end
		VUHDO_updateProfileSelectCombo();
		VUHDO_Msg(VUHDO_I18N_DELETED_PROFILE .. " \"" .. aName .."\".");
	end
end



--
function VUHDO_yesNoDeleteProfileCallback(aDecision)
	if (VUHDO_YES == aDecision) then
		VUHDO_deleteProfile(VuhDoYesNoFrame:GetAttribute("profileName"));
		VUHDO_updateProfileSelectCombo();
	end
end



--
function VUHDO_deleteProfileClicked(aButton)

	if ((VUHDO_CURRENT_PROFILE or "") == "") then
		VUHDO_Msg(VUHDO_I18N_MUST_ENTER_SELECT_PROFILE);
		return;
	end

	local tIndex, _ = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);
	if (tIndex == nil) then
		VUHDO_Msg(VUHDO_I18N_ERROR_NO_PROFILE .. "\"" .. VUHDO_CURRENT_PROFILE .. "\" !", 1, 0.4, 0.4);
		return;
	end

	VuhDoYesNoFrameText:SetText(VUHDO_I18N_REALLY_DELETE_PROFILE .. " \"" .. VUHDO_CURRENT_PROFILE .. "\"?");
	VuhDoYesNoFrame:SetAttribute("callback", VUHDO_yesNoDeleteProfileCallback);
	VuhDoYesNoFrame:SetAttribute("profileName", VUHDO_CURRENT_PROFILE);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_saveProfileClicked(aButton)
	if ((VUHDO_CURRENT_PROFILE or "") == "") then
		VUHDO_Msg(VUHDO_I18N_MUST_ENTER_SELECT_PROFILE);
		return;
	end

	local _, tProfile = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);
	if (tProfile ~= nil and tProfile["LOCKED"]) then
		VUHDO_Msg("Profile " .. VUHDO_CURRENT_PROFILE .. " is currently locked. Please unlock before saving.");
		return;
	end
	VUHDO_CONFIG["CURRENT_PROFILE"] = VUHDO_CURRENT_PROFILE;
	VUHDO_skinsSaveAutoProfileButtonEnablement(aButton:GetParent():GetParent(), VUHDO_CURRENT_PROFILE);
	VUHDO_saveProfile(VUHDO_CURRENT_PROFILE);
end



--
function VUHDO_loadProfileClicked(aButton)
	if ((VUHDO_CURRENT_PROFILE or "") == "") then
		VUHDO_Msg(VUHDO_I18N_MUST_ENTER_SELECT_PROFILE);
		return;
	end

	local tIndex, _ = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);
	if (tIndex == nil) then
		VUHDO_Msg(VUHDO_I18N_ERROR_NO_PROFILE .. "\"" .. VUHDO_CURRENT_PROFILE .. "\" !", 1, 0.4, 0.4);
		return;
	end

	VuhDoYesNoFrameText:SetText("Loading a profile will overwrite\nyour current settings. Proceed?");
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_CONFIG["CURRENT_PROFILE"] = VUHDO_CURRENT_PROFILE;
				VUHDO_loadProfile(VUHDO_CURRENT_PROFILE);
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_shareCurrentProfile(aUnitName, aProfileName)
	local _, tProfile = VUHDO_getProfileNamedCompressed(aProfileName);
	if (tProfile == nil) then
		VUHDO_Msg("There is no profile named \"" .. aProfileName .. "\"", 1, 0.4, 0.4);
		return;
	end
	if (tProfile["HARDLOCKED"]) then
		VUHDO_Msg("You cannot share hardlocked profiles. Please make a copy before.", 1, 0.4, 0.4);
		return;
	end
	local tQuestion = VUHDO_PLAYER_NAME .. " requests to transmit\nProfile " .. aProfileName .. " to you.\nThis will take about 60 secs. Proceed?"
	VUHDO_startShare(aUnitName, tProfile, sCmdProfileDataChunk, sCmdProfileDataEnd, tQuestion);
end
