local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AB = E:GetModule("ActionBars")

local _G = _G
local pairs, select, unpack = pairs, select, unpack

-- TrinketMenu v5.0.4

local function LoadSkin()
	if not E.private.addOnSkins.TrinketMenu then return end

	-- Main Frame
	TrinketMenu_MainFrame:StripTextures()
	TrinketMenu_MainFrame:CreateBackdrop("Transparent")
	TrinketMenu_MainFrame.backdrop:Point("TOPLEFT", 5, -5)
	TrinketMenu_MainFrame.backdrop:Point("BOTTOMRIGHT", -5, 5)
	TrinketMenu_MainFrame:SetClampedToScreen(true)

--	TrinketMenu_MainFrame:SetScale(1)
--	TrinketMenu_MainFrame.SetScale = E.noop

	local function TrinketMenuQualityColors(link, frame)
		if link then
			local quality = select(3, GetItemInfo(link))

			if quality then
				frame:SetBackdropBorderColor(GetItemQualityColor(quality))
			else
				frame:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		else
			frame:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end
	end

	for i = 0, 1 do
		local item = _G["TrinketMenu_Trinket"..i]
		local icon = _G["TrinketMenu_Trinket"..i.."Icon"]
		local queue = _G["TrinketMenu_Trinket"..i.."Queue"]
		local color = AB.db.fontColor

		item:StripTextures()
		item:SetTemplate()
		item:StyleButton()
		item:SetBackdropColor(0, 0, 0, 0)
		item.backdropTexture:SetAlpha(0)

		item:HookScript("OnEvent", function(frame, event)
			local link = i == 0 and GetInventoryItemLink("player", 13) or GetInventoryItemLink("player", 14)

			if event == "PLAYER_ENTERING_WORLD" then
				E:Delay(0.1, function() TrinketMenuQualityColors(link, frame) end)
				item:UnregisterEvent("PLAYER_ENTERING_WORLD")
			else
				TrinketMenuQualityColors(link, frame)
			end
		end)
		item:RegisterEvent("PLAYER_ENTERING_WORLD")
		item:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()

		queue:SetTexCoord(unpack(E.TexCoords))
		queue:Point("TOPLEFT", 3, -3)

		_G["TrinketMenu_Trinket"..i.."Time"]:Kill()

		_G["TrinketMenu_Trinket"..i.."HotKey"]:SetTextColor(color.r, color.g, color.b)

		AB:FixKeybindText(item)

		E:RegisterCooldown(_G["TrinketMenu_Trinket"..i.."Cooldown"])
	end

	-- Menu Frame
	TrinketMenu_MenuFrame:StripTextures()
	TrinketMenu_MenuFrame:CreateBackdrop("Transparent")
	TrinketMenu_MenuFrame.backdrop:Point("TOPLEFT", 5, -5)
	TrinketMenu_MenuFrame.backdrop:Point("BOTTOMRIGHT", -5, 5)
	TrinketMenu_MenuFrame:SetClampedToScreen(true)

--	TrinketMenu_MenuFrame:SetScale(1)
--	TrinketMenu_MenuFrame.SetScale = E.noop

	for i = 1, 30 do
		local item = _G["TrinketMenu_Menu"..i]
		local icon = _G["TrinketMenu_Menu"..i.."Icon"]

		item:StripTextures()
		item:SetTemplate()
		item:StyleButton()
		item:SetBackdropColor(0, 0, 0, 0)
		item.backdropTexture:SetAlpha(0)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()

		_G["TrinketMenu_Menu"..i.."Time"]:Kill()

		E:RegisterCooldown(_G["TrinketMenu_Menu"..i.."Cooldown"])
	end

	hooksecurefunc(TrinketMenu, "BuildMenu", function()
		for i = 1, 30 do
			if not TrinketMenu.BaggedTrinkets[i] then return end

			TrinketMenuQualityColors(_G["TrinketMenu_Menu"..i], TrinketMenu.BaggedTrinkets[i].id)
		end
	end)

	-- Options
	TrinketMenu_Title:Point("TOP", 0, -5)

	TrinketMenu_OptFrame:StripTextures()
	TrinketMenu_OptFrame:CreateBackdrop("Transparent")

	TrinketMenu_SubOptFrame:StripTextures()
	TrinketMenu_SubOptFrame:CreateBackdrop("Transparent")

	for i = 1, 3 do
		local tab = _G["TrinketMenu_Tab"..i]

		S:HandleButton(tab)
		tab:Size(94, 24)

		if i == 1 then
			tab:Point("TOPRIGHT", -7, -22)
		else
			tab:Point("TOPRIGHT", _G["TrinketMenu_Tab"..i - 1], "TOPLEFT", -2, 0)
		end
	end

	local checkboxes = {
		TrinketMenu_Trinket0Check,
		TrinketMenu_Trinket1Check,
		TrinketMenu_OptLocked,
		TrinketMenu_OptShowIcon,
		TrinketMenu_OptDisableToggle,
		TrinketMenu_OptSquareMinimap,
		TrinketMenu_OptCooldownCount,
		TrinketMenu_OptLargeCooldown,
		TrinketMenu_OptShowTooltips,
		TrinketMenu_OptTooltipFollow,
		TrinketMenu_OptTinyTooltips,
		TrinketMenu_OptShowHotKeys,
		TrinketMenu_OptStopOnSwap,
		TrinketMenu_OptRedRange,
		TrinketMenu_OptKeepDocked,
		TrinketMenu_OptKeepOpen,
		TrinketMenu_OptMenuOnShift,
		TrinketMenu_OptMenuOnRight,
		TrinketMenu_OptNotify,
		TrinketMenu_OptNotifyThirty,
		TrinketMenu_OptNotifyChatAlso,
		TrinketMenu_OptSetColumns,
		TrinketMenu_SortPriority,
		TrinketMenu_SortKeepEquipped,
		TrinketMenu_OptHideOnLoad
	}

	for _, checkbox in pairs(checkboxes) do
		S:HandleCheckBox(checkbox)
	end

	TrinketMenu_LockButton:Hide()

	S:HandleCloseButton(TrinketMenu_CloseButton)
	TrinketMenu_CloseButton:Size(32)
	TrinketMenu_CloseButton:Point("TOPRIGHT", 6, 6)

	TrinketMenu_SubQueueFrame:StripTextures()

	TrinketMenu_SortListFrame:StripTextures()
	TrinketMenu_SortListFrame:CreateBackdrop("Transparent")
	TrinketMenu_SortListFrame.backdrop:Point("TOPLEFT", 4, -4)
	TrinketMenu_SortListFrame.backdrop:Point("BOTTOMRIGHT", -26, 8)

	TrinketMenu_SortScroll:StripTextures()

	S:HandleScrollBar(TrinketMenu_SortScrollScrollBar)

	TrinketMenu_SortDelay:StripTextures()
	S:HandleEditBox(TrinketMenu_SortDelay)

	for i = 1, 9 do
		local item = _G["TrinketMenu_Sort"..i]
		local icon = _G["TrinketMenu_Sort"..i.."Icon"]
		local highlight = _G["TrinketMenu_Sort"..i.."Highlight"]

		item:CreateBackdrop()
		item.backdrop:SetOutside(icon)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:Point("TOPLEFT", 1, -1)

		highlight:SetTexture(E.Media.Textures.Highlight)
		highlight:SetAlpha(0.35)
		highlight:SetInside()
	end

	TrinketMenu_MoveTop:Point("TOPLEFT", 3, -50)

	TrinketMenu_ProfilesFrame:StripTextures()

	TrinketMenu_ProfilesListFrame:StripTextures()
	TrinketMenu_ProfilesListFrame:CreateBackdrop("Transparent")

	TrinketMenu_ProfileName:StripTextures()
	S:HandleEditBox(TrinketMenu_ProfileName)

	S:HandleButton(TrinketMenu_ProfilesDelete)
	S:HandleButton(TrinketMenu_ProfilesLoad)
	S:HandleButton(TrinketMenu_ProfilesSave)
	S:HandleButton(TrinketMenu_ProfilesCancel)

	S:HandleSliderFrame(TrinketMenu_OptColumnsSlider)

	S:HandleSliderFrame(TrinketMenu_OptMainScaleSlider)
	TrinketMenu_OptMainScaleSlider:Point("TOPLEFT", TrinketMenu_OptSetColumnsText, "BOTTOMLEFT", 0, -35)
	TrinketMenu_OptMainScaleSliderText:Point("TOPLEFT", TrinketMenu_OptSetColumnsText, "BOTTOMLEFT", 0, -22)

	S:HandleSliderFrame(TrinketMenu_OptMenuScaleSlider)
	TrinketMenu_OptMenuScaleSlider:Point("TOPLEFT", TrinketMenu_OptMainScaleSlider, "BOTTOMLEFT", 0, -18)
	TrinketMenu_OptMenuScaleSliderText:Point("TOPLEFT", TrinketMenu_OptMainScaleSliderText, "BOTTOMLEFT", 0, -18)

	for i = 1, 7 do
		local item = _G["TrinketMenu_Profile"..i]

		S:HandleButtonHighlight(item)
	end

	S:HandleScrollBar(TrinketMenu_ProfileScrollScrollBar)
end

S:AddCallbackForAddon("TrinketMenu", "TrinketMenu", LoadSkin)