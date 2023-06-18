local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.RCLootCouncil then return end

	MainFrame:StripTextures()
	MainFrame:SetTemplate("Transparent")

	S:HandleButton(BtClose)
	S:HandleButton(BtAward)
	S:HandleButton(BtRemove)
	S:HandleButton(BtClear)

	for _, frame in pairs({"CurrentItem", "CurrentSelection"}) do
		local hover = _G[frame.."Hover"]
		local texture = _G[frame.."Texture"]
		local label = _G[frame.."Label"]

		hover:SetOutside(texture)
		hover:CreateBackdrop()
		hover.backdrop:SetOutside(texture)
		S:HandleFrameHighlight(hover)

		texture:SetTexCoord(unpack(E.TexCoords))
		texture:SetParent(hover.backdrop)

		label:FontTemplate(nil, 18, "NONE")
		label.SetFont = E.noop
	end

	for i = 1, 2 do
		local selection = _G["DualItemSelection"..i]
		local texture = _G["DualItemTexture"..i]
		local label = _G["DualItemLabel"..i]

		selection:SetOutside(texture)
		selection:CreateBackdrop()
		selection.backdrop:SetOutside(texture)
		S:HandleFrameHighlight(selection)

		texture:SetTexCoord(unpack(E.TexCoords))
		texture:SetParent(selection.backdrop)

		label:FontTemplate(nil, 18, "NONE")
		label.SetFont = E.noop
	end

	S:HandleCheckBox(MainFrameFilterPasses)
	MainFrameFilterPasses:Point("TOPLEFT", 729, -232)

	MainFrameFilterPassesText:FontTemplate(nil, 12, "NONE")
	MainFrameFilterPassesText:Point("TOPLEFT", 669, -386)

	PeopleToRollString:FontTemplate(nil, 12, "NONE")
	PeopleToRollString:Width(110)

	PeopleToRollLabel:FontTemplate(nil, 12, "NONE")
	PeopleToRollLabel:ClearAllPoints()
	PeopleToRollLabel:Point("LEFT", PeopleToRollString, "RIGHT", 4, 0)

	MasterlooterString:FontTemplate(nil, 12, "NONE")
	MasterlooterString:Width(76)
	MasterlooterString:Point("TOPLEFT", 18, -387)

	MasterlooterLabel:FontTemplate(nil, 12, "NONE")
	MasterlooterLabel:ClearAllPoints()
	MasterlooterLabel:Point("LEFT", MasterlooterString, "RIGHT", 4, 0)

	-- Scroll Frame
	ContentFrame:StripTextures()
	ContentFrame:SetTemplate("Transparent")

	S:HandleScrollBar(ContentFrameScrollBar)
	ContentFrameScrollBar:ClearAllPoints()
	ContentFrameScrollBar:Point("TOPRIGHT", ContentFrame, 22, -18)
	ContentFrameScrollBar:Point("BOTTOMRIGHT", ContentFrame, 0, 18)

	for i = 1, 11 do
		local bg = _G["ContentFrameEntry"..i.."BG"]
		local note = _G["ContentFrameEntry"..i.."NoteButton"]

		bg:SetTexture(E.Media.Textures.Highlight)
		bg:SetVertexColor(1, 0.8, 0.1, 0.35)

		S:HandleButton(_G["ContentFrameEntry"..i.."BtVote"])

		note:SetNormalTexture(E.Media.Textures.Copy)
		note.SetNormalTexture = E.noop

		for j = 1, 2 do
			_G["ContentFrameEntry"..i.."CurrentGear"..j.."HoverCurrentGear"..j]:SetTexCoord(unpack(E.TexCoords))
		end
	end

	for i = 1, 20 do
		local button = _G["RCLootCouncil_SessionButton"..i]
		local texture = _G["RCLootCouncil_SessionButton"..i.."NormalTexture"]

		button:StripTextures()
		button:SetTemplate()
		button:StyleButton(nil, true, true)

		texture:SetTexCoord(unpack(E.TexCoords))
	end

	-- Loot Frame
	RCLootFrame:StripTextures()
	RCLootFrame:HookScript("OnShow", function()
		for i = 1, 5 do
			local entry = _G["RCLootFrameEntry"..i]

			if entry then
				if i ~= 1 then
					entry:Point("TOPLEFT", _G["RCLootFrameEntry"..i - 1], "BOTTOMLEFT", 0, -2)
				end

				if not entry.isSkinned then
					local hover = _G["RCLootFrameEntry"..i.."Hover1"]
					local texture = _G["RCLootFrameEntry"..i.."Texture"]
					local label = _G["RCLootFrameEntry"..i.."ItemLabel"]

					entry:SetTemplate("Transparent")

					hover:CreateBackdrop()
					hover.backdrop:SetOutside(texture)
					S:HandleFrameHighlight(hover, hover.backdrop)

					texture:SetTexCoord(unpack(E.TexCoords))

					label:FontTemplate(nil, 18, "NONE")
					label.SetFont = E.noop

					_G["RCLootFrameEntry"..i.."Ilvl"]:FontTemplate(nil, 12, "NONE")

					_G["RCLootFrameEntry"..i.."Hover2"]:Hide()

					entry.noteButton:StripTextures()
					entry.noteButton:SetNormalTexture(E.Media.Textures.Copy)
					entry.noteButton.SetNormalTexture = E.noop
					entry.noteButton:SetAlpha(0.7)

					for j = 1, 8 do
						local button = _G["RCLootFrameEntry"..i.."Button"..j]

						if button then
							S:HandleButton(button)
						end
					end

					entry.isSkinned = true
				end
			end
		end
	end)

	-- History Frame
	RCLootHistoryFrame:StripTextures()
	RCLootHistoryFrame:SetTemplate("Transparent")

	RCLootHistoryFrameScrollFrame:StripTextures()
	RCLootHistoryFrameScrollFrame:CreateBackdrop("Transparent")

	S:HandleScrollBar(RCLootHistoryFrameScrollFrameScrollBar)
	RCLootHistoryFrameScrollFrameScrollBar:ClearAllPoints()
	RCLootHistoryFrameScrollFrameScrollBar:Point("TOPRIGHT", RCLootHistoryFrameScrollFrame, 24, -17)
	RCLootHistoryFrameScrollFrameScrollBar:Point("BOTTOMRIGHT", RCLootHistoryFrameScrollFrame, 0, 17)

	for i = 1, 3 do
		_G["RCLootHistoryFrameString"..i]:FontTemplate(nil, 12, "NONE")
	end

	for i = 1, 13 do
		local bg = _G["RCLootHistoryFrameScrollFrameEntry"..i.."BG"]

		bg:SetTexture(E.Media.Textures.Highlight)
		bg:SetVertexColor(1, 0.8, 0.1, 0.35)
	end

	S:HandleCheckBox(RCLootHistoryFrameFilterPasses)

	S:HandleButton(RCLootHistoryFrameButtonClose)

	-- Rank Frame
	RCRankFrame:StripTextures()
	RCRankFrame:SetTemplate("Transparent")

	S:HandleButton(RankAcceptButton)
	S:HandleButton(RankCancelButton)

	S:HandleDropDownBox(RankDropDown)

	-- Version Check
	RCVersionFrame:StripTextures()
	RCVersionFrame:SetTemplate("Transparent")

	RCVersionFrameContentFrame:StripTextures()
	RCVersionFrameContentFrame:CreateBackdrop("Transparent")

	S:HandleScrollBar(RCVersionFrameContentFrameScrollBar)
	RCVersionFrameContentFrameScrollBar:ClearAllPoints()
	RCVersionFrameContentFrameScrollBar:Point("TOPRIGHT", RCVersionFrameContentFrame, 22, -17)
	RCVersionFrameContentFrameScrollBar:Point("BOTTOMRIGHT", RCVersionFrameContentFrame, 0, 17)

	RCVersionFrame:HookScript("OnShow", function()
		for i = 1, 13 do
			local entry = _G["RCVersionFrameContentFrameEntry"..i]

			if entry and not entry.isSkinned then
				local bg = _G["RCVersionFrameContentFrameEntry"..i.."BG"]

				bg:SetTexture(E.Media.Textures.Highlight)
				bg:SetVertexColor(1, 0.8, 0.1, 0.35)

				entry.isSkinned = true
			end
		end
	end)

	S:HandleButton(ButtonGuild)
	S:HandleButton(RaidButton)
	S:HandleButton(CloseButton)
end

S:AddCallbackForAddon("RCLootCouncil", "RCLootCouncil", LoadSkin)