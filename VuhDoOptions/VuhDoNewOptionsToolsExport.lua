local _;
VUHDO_CUSTOM_DEBUFF_PROFILE = nil;
VUHDO_EXPORT_CUDE_TO_RADIO_VALUE = 3;
--VUHDO_EXPORT_CUDE_IS_REPLACE = false;



--
local function VUHDO_broadcastCustomDebuffsToProfile(aDestProfile, anIsReplace)
	local tIndex, tProfile;

	if (VUHDO_CONFIG["CURRENT_PROFILE"] == aDestProfile) then
		return;
	end

	tIndex, tProfile = VUHDO_getProfileNamed(aDestProfile);
	if (tIndex == nil) then
		VUHDO_Msg(format(VUHDO_I18N_PROFILE_NOT_EXISTS, aDestProfile or VUHDO_I18N_NOT_SELECTED));
		return;
	end

	if (tProfile["LOCKED"] or tProfile["HARDLOCKED"]) then
		VUHDO_Msg("Profile " .. aDestProfile .. " is locked/hardlocked, skipping.");
		return;
	end

	if (tProfile["CONFIG"]["CUSTOM_DEBUFF"] == nil) then -- Default-Profile haben keins...
		return;
	end

	if (anIsReplace) then
		tProfile["CONFIG"]["CUSTOM_DEBUFF"]["STORED"] = { };
		tProfile["CONFIG"]["CUSTOM_DEBUFF"]["STORED_SETTINGS"] = { };
	end

	for _, tDebuffName in pairs(VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED"]) do
		local tSettings = VUHDO_deepCopyTable(VUHDO_CONFIG["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName]);
		tProfile["CONFIG"]["CUSTOM_DEBUFF"]["STORED_SETTINGS"][tDebuffName] = tSettings;

		if (VUHDO_tableUniqueAdd(tProfile["CONFIG"]["CUSTOM_DEBUFF"]["STORED"], tDebuffName)) then
			VUHDO_Msg(format(VUHDO_I18N_ADDED_X_TO_Y, tDebuffName, aDestProfile));
		end
	end

	VUHDO_PROFILES[tIndex]["CONFIG"] = tProfile["CONFIG"];

	VUHDO_Msg(format(VUHDO_I18N_PROFILE_EXPORTED_TO, aDestProfile));
end



--
local function VUHDO_broadcastCustomDebuffsToAllProfiles(anIsSameToonOnly, anIsReplace)
	for _, tProfile in pairs(VUHDO_PROFILES) do
		if (VUHDO_PLAYER_NAME == tProfile["ORIGINATOR_TOON"] or not anIsSameToonOnly) then
			VUHDO_broadcastCustomDebuffsToProfile(tProfile["NAME"], anIsReplace);
		end
	end

	VUHDO_Msg(VUHDO_I18N_CUDE_EXPORT_DONE);
end



--
function VUHDO_profilesReplaceCudeClicked(_, anIsReplace)
	--VUHDO_EXPORT_CUDE_IS_REPLACE = anIsReplace;

	VuhDoYesNoFrameText:SetText(VUHDO_I18N_REALLY_EXPORT_CUDES);
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then

				if (VUHDO_EXPORT_CUDE_TO_RADIO_VALUE == 1) then -- all
					VUHDO_broadcastCustomDebuffsToAllProfiles(false, anIsReplace);
				elseif(VUHDO_EXPORT_CUDE_TO_RADIO_VALUE == 2) then -- own toon
					VUHDO_broadcastCustomDebuffsToAllProfiles(true, anIsReplace);
				else -- selected profile
					VUHDO_broadcastCustomDebuffsToProfile(VUHDO_CUSTOM_DEBUFF_PROFILE, anIsReplace);
				end

				VUHDO_initAllBurstCaches();
				VUHDO_initCustomDebuffComboModel();
			end
		end
	);
	VuhDoYesNoFrame:Show();
end

