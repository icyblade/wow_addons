local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.MobInfo2 then return end

	-- Options
	MI2_OptionsFrame:StripTextures()
	MI2_FrmLootList:StripTextures()
	MI2_GeneralOptionsBox1:StripTextures()

	for i = 1, 5 do
		local tab = _G["MI2_OptionsTabFrameTab"..i]

		S:HandleTab(tab)
	end

	S:HandleTab(MI2_SearchResultFrameTab1)
	S:HandleTab(MI2_SearchResultFrameTab2)

	local templates = {
		MI2_OptionsFrame,
		MI2_OptionsTabFrame,
		MI2_FrmTooltipContent,
		MI2_FrmTooltipLayout,
		MI2_FrmItemTooltip,
		MI2_FrmHealthValueOptions,
		MI2_FrmManaValueOptions,
		MI2_FrmImportDatabase,
	}

	local checkboxes = {
		MI2_OptSaveBasicInfo,
		MI2_OptShowMobInfo,
		MI2_OptUseGameTT,
		MI2_OptShowItemInfo,
		MI2_OptShowTargetInfo,
		MI2_OptShowMMButton,
		MI2_OptShowHealth,
		MI2_OptShowXp,
		MI2_OptShowKills,
		MI2_OptShowCloth,
		MI2_OptShowTotal,
		MI2_OptShowIV,
		MI2_OptShowDamage,
		MI2_OptShowResists,
		MI2_OptShowLowHpAction,
		MI2_OptShowMana,
		MI2_OptShowQuality,
		MI2_OptShowNo2lev,
		MI2_OptShowLoots,
		MI2_OptShowEmpty,
		MI2_OptShowCoin,
		MI2_OptShowLocation,
		MI2_OptShowIGrey,
		MI2_OptShowIWhite,
		MI2_OptShowIGreen,
		MI2_OptShowIBlue,
		MI2_OptShowIPurple,
		MI2_OptShowItems,
		MI2_OptShowClothSkin,
		MI2_OptMouseTooltip,
		MI2_OptSmallFont,
		MI2_OptCompactMode,
		MI2_OptHideAnchor,
		MI2_OptOtherTooltip,
		MI2_OptCombinedMode,
		MI2_OptKeypressMode,
		MI2_OptShowItemPrice,
		MI2_OptItemTooltip,
		MI2_OptTargetHealth,
		MI2_OptHealthPercent,
		MI2_OptTargetMana,
		MI2_OptManaPercent,
		MI2_OptSaveCharData,
		MI2_OptSaveResist,
		MI2_OptSaveItems,
		MI2_OptSavePlayerHp,
		MI2_OptImportOnlyNew,
		MI2_OptSearchNormal,
		MI2_OptSearchElite,
		MI2_OptSearchBoss,
	}

	local buttons = {
		MI2_OptBtnDone,
		MI2_OptDefault,
		MI2_OptAllOn,
		MI2_OptAllOff,
		MI2_OptClearMobDb,
		MI2_OptClearHealthDb,
		MI2_OptClearPlayerDb,
		MI2_OptClearTarget,
		MI2_OptTrimDownMobData,
		MI2_OptImportMobData,
		MI2_OptSortByValue,
		MI2_OptSortByItem,
		MI2_OptDeleteSearch,
	}

	local sliders = {
		MI2_OptMMButtonPos,
		MI2_OptTargetFontSize,
		MI2_OptHealthPosX,
		MI2_OptHealthPosY,
		MI2_OptManaPosX,
		MI2_OptManaPosY,
	}

	local dropdowns = {
		MI2_OptTooltipMode,
		MI2_OptTargetFont,
		MI2_OptItemsQuality,
	}

	local editboxes = {
		MI2_OptItemFilter,
		MI2_OptSearchMinLevel,
		MI2_OptSearchMaxLevel,
		MI2_OptSearchMinLoots,
		MI2_OptSearchMaxLoots,
		MI2_OptSearchMobName,
		MI2_OptSearchItemName,
	}

	for _, object in pairs(templates) do
		object:SetTemplate("Transparent")
	end
	for _, object in pairs(checkboxes) do
		S:HandleCheckBox(object)
	end
	for _, object in pairs(buttons) do
		S:HandleButton(object)
	end
	for _, object in pairs(sliders) do
		S:HandleSliderFrame(object)
	end
	for _, object in pairs(dropdowns) do
		S:HandleDropDownBox(object)
	end
	for _, object in pairs(editboxes) do
		S:HandleEditBox(object)
	end

	-- Results
	MI2_SearchResultFrame:SetTemplate("Transparent")

	for i = 1, 14 do
		local result = _G["MI2_SearchResult"..i]
		--S:HandleButtonHighlight(result)
	end
end

S:AddCallbackForAddon("MobInfo2", "MobInfo2", LoadSkin)