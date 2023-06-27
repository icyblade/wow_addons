
VUHDO_FRAME_STRATA_COMBO_MODEL = {
	{ "BACKGROUND", VUHDO_I18N_VERY_LOW },
	{ "LOW", VUHDO_I18N_LOW },
	{ "MEDIUM", VUHDO_I18N_MEDIUM_LOW },
	{ "HIGH", VUHDO_I18N_MEDIUM },
	{ "DIALOG", VUHDO_I18N_MEDIUM_HIGH },
	{ "FULLSCREEN", VUHDO_I18N_HIGH },
	{ "FULLSCREEN_DIALOG", VUHDO_I18N_VERY_HIGH },
	{ "TOOLTIP", VUHDO_I18N_ULTRA },

}

--
local tCnt, tFrame, tTexture;
local VUHDO_RAID_TARGET_COMBO_MODEL = nil;
function VUHDO_getRaidTargetComboModel(aComboBox)
	local tParent = VUHDO_GLOBAL[aComboBox:GetName() .. "SelectPanel"];

	if (VUHDO_RAID_TARGET_COMBO_MODEL == nil) then
		VUHDO_RAID_TARGET_COMBO_MODEL = { };
		for tCnt = 1, 8 do
			tFrame = CreateFrame("Frame", tParent:GetName() .. "Ri" .. tCnt, tParent, "VuhDoRaidTargetIconTemplate");
			tTexture = VUHDO_GLOBAL[tFrame:GetName() .. "I"];
			VUHDO_setRaidTargetIconTexture(tTexture, tCnt);
			tinsert(VUHDO_RAID_TARGET_COMBO_MODEL, { tCnt, tFrame } );
		end
	end

	return VUHDO_RAID_TARGET_COMBO_MODEL;
end

