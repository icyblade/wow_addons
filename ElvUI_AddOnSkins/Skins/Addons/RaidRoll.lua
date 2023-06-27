local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if not E.private.addOnSkins.RaidRoll then return end

	RR_RollFrame:SetTemplate("Transparent")
	RR_NAME_FRAME:SetTemplate("Default")

	S:HandleCloseButton(RR_Close_Button, RR_RollFrame)

	S:HandleSliderFrame(RaidRoll_Slider_ID)

	S:HandleButton(RaidRoll_AnnounceWinnerButton)
	S:HandleButton(RR_Roll_5SecAndAnnounce)
	S:HandleButton(RR_Roll_RollButton)
	S:HandleButton(RR_Last)
	S:HandleButton(RR_Clear)
	S:HandleButton(RR_Next)
	S:HandleButton(RaidRoll_OptionButton)

	RR_Frame:SetTemplate("Transparent")
	RR_Frame:Width(185)
	RR_Frame:Point("TOP", RR_RollFrame, "BOTTOM", 0, 1)

	S:HandleCheckBox(RaidRoll_Catch_All)
	RaidRoll_Catch_All:SetFrameLevel(RR_Frame:GetFrameLevel() + 2)

	S:HandleCheckBox(RaidRoll_Allow_All)
	RaidRoll_Allow_All:SetFrameLevel(RR_Frame:GetFrameLevel() + 2)

	S:HandleCheckBox(RaidRollCheckBox_ExtraRolls)
	RaidRollCheckBox_ExtraRolls:SetFrameLevel(RR_Frame:GetFrameLevel() + 2)

	S:HandleButton(Raid_Roll_ClearSymbols)
	S:HandleButton(Raid_Roll_ClearRolls)
	S:HandleButton(RaidRoll_ExtraOptionButton)

	for i = 1, 5 do
		_G["Raid_Roll_SetSymbol"..i]:StyleButton()
	end

	-- Interface Options
	S:HandleCheckBox(RR_RollCheckBox_Unannounced_panel)
	S:HandleCheckBox(RR_RollCheckBox_AllRolls_panel)
	S:HandleCheckBox(RaidRollCheckBox_ExtraRolls_panel)

	S:HandleCheckBox(RR_RollCheckBox_GuildAnnounce)
	S:HandleCheckBox(RR_RollCheckBox_GuildAnnounce_Officer)
	S:HandleCheckBox(RR_RollCheckBox_Auto_Announce)
	S:HandleCheckBox(RR_RollCheckBox_Auto_Close)
	S:HandleCheckBox(RR_RollCheckBox_No_countdown)
	S:HandleCheckBox(RR_RollCheckBox_Multi_Rollers)
	S:HandleCheckBox(RR_RollCheckBox_SilenceLootReason)

	S:HandleCheckBox(RaidRollCheckBox_ShowRanks_panel)
	S:HandleCheckBox(RR_RollCheckBox_ShowGroupNumber_panel)
	S:HandleCheckBox(RR_RollCheckBox_ShowClassColors_panel)
	S:HandleCheckBox(RR_RollCheckBox_EPGPMode_panel)
	S:HandleCheckBox(RR_RollCheckBox_EPGPThreshold_panel)
	S:HandleCheckBox(RR_RollCheckBox_Enable_Alt_Mode)
	S:HandleCheckBox(RR_RollCheckBox_Track_Bids)
	S:HandleCheckBox(RR_RollCheckBox_Num_Not_Req)
	S:HandleCheckBox(RR_RollCheckBox_Track_EPGPSays)

	S:HandleSliderFrame(RaidRoll_Scale_Slider)
	S:HandleSliderFrame(RaidRoll_ExtraWidth_Slider)
	S:HandleSliderFrame(RaidRoll_Rolling_Time_Slider)

	RR_Panel_GuildRankFrame:SetTemplate("Transparent")

	S:HandleCheckBox(RaidRollCheckBox_RankPrio_panel)

	for i = 1, 11 do
		local button = _G["Raid_Roll_GuildPriority"..i]

		S:HandleButton(button)
		button:Size(15)
	end
end

local function LootTrackerSkin()
	if not E.private.addOnSkins.RaidRoll then return end

	RR_LOOT_FRAME:SetTemplate("Transparent")

	S:HandleSliderFrame(RaidRoll_Loot_Slider_ID)

	S:HandleButton(RR_Loot_LinkLootButton)
	S:HandleButton(RR_Loot_ButtonClear)
	S:HandleButton(RR_Loot_ButtonFirst)
	S:HandleButton(RR_Loot_ButtonPrev)
	S:HandleButton(RR_Loot_ButtonNext)
	S:HandleButton(RR_Loot_ButtonLast)

	for i = 1, 4 do
		local raidRollButton = _G["RR_Loot_RaidRollButton_"..i]

		raidRollButton:Show()
		S:HandleButton(raidRollButton)
		
		for j = 1, 3 do
			local announceButton = _G["RR_Loot_Announce_"..j.."_Button_"..i]

			announceButton:Show()
			S:HandleButton(announceButton)
		end
	end

	for i = 1, RR_LOOT_FRAME:GetNumChildren() do
		local child = select(i, RR_LOOT_FRAME:GetChildren())
		if child and child:IsObjectType("Button") and child:GetName() == "Close_Button" then
			S:HandleCloseButton(child)
		end
	end

	-- Interface Options
	for i = 1, 3 do
		_G["RR_Msg"..i.."_FRAME"]:StripTextures()
		S:HandleEditBox(_G["Raid_Roll_SetMsg"..i.."_EditBox"])
	end

	S:HandleCheckBox(RR_AutoOpenLootWindow)
	S:HandleCheckBox(RR_ReceiveGuildMessages)
	S:HandleCheckBox(RR_Enable3Messages)
	S:HandleCheckBox(RR_Frame_WotLK_Dung_Only)
end

S:AddCallbackForAddon("RaidRoll", "RaidRoll", LoadSkin)
S:AddCallbackForAddon("RaidRoll_LootTracker", "RaidRoll_LootTracker", LootTrackerSkin)