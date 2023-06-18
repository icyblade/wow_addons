local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local select, unpack = select, unpack
local split = string.split

local C_PetJournal_GetPetStats = C_PetJournal.GetPetStats

local function SkinAbilities()
	for i = 1, 51 do
		local button = _G["PetTrackerAbilityButton"..i]
		if button then
			if not button.isSkinned then
				button:SetTemplate()
				button:StyleButton()
				button:ClearAllPoints()

				for j = 1, 6 do
					local parent = button:GetParent()

					if parent then
						if parent == _G["PetTrackerJournalSlot"..j] then
							if i == 1 or i == 7 or i == 13 or i == 19 or i == 25 or i == 31 or i == 37 or i == 43 or i == 49 then
								button:Point("CENTER", -45, -15)
							elseif i == 2 or i == 8 or i == 14 or i == 20 or i == 26 or i == 32 or i == 38 or i == 44 or i == 50 then
								button:Point("CENTER", -7, -15)
							else
								button:Point("CENTER", 30, -15)
							end
						elseif parent == _G["PetTrackerBattleSlot"..j] then
							if i == 1 or i == 7 or i == 13 or i == 19 or i == 25 or i == 31 or i == 37 or i == 43 or i == 49 then
								button:Point("CENTER", -28, -15)
							elseif i == 2 or i == 8 or i == 14 or i == 20 or i == 26 or i == 32 or i == 38 or i == 44 or i == 50 then
								button:Point("CENTER", 8, -15)
							else
								button:Point("CENTER", 44, -15)
							end
						end
					end
				end

				button.Icon:SetTexCoord(unpack(E.TexCoords))
				button.Icon:SetInside()

				button.Type:Size(20)
				button.Type:SetTexCoord(0, 1, 0, 1)
				button.Type:ClearAllPoints()
				button.Type:Point("TOP", button, 0, 24)

				for j = 1, button:GetNumRegions() do
					local region = select(j, button:GetRegions())
					if region and region.IsObjectType and region:IsObjectType("Texture") then
						local texture = region:GetTexture()
						if texture == "Interface\\Spellbook\\Spellbook-Parts" or texture == "Interface\\PetBattles\\PetBattleHud" then
							region:SetTexture()
						end
					end
				end

				button.isSkinned = true
			end

			local iconPath = button.Type:GetTexture()
			if iconPath then
				local _, petType = split("-", iconPath, 2)
				button.Type:SetTexture(E.Media.BattlePetTypes[petType])
			end
		end
	end
end

local function LoadSkin()
	if not E.private.addOnSkins.PetTracker then return end

	-- World Map
	S:HandleEditBox(PetTrackerMapFilter)

	PetTrackerMapFilterSuggestions:HookScript("OnShow", function(frame)
		if not frame.isSkinned then
			frame:SetBackdrop(nil)
			frame.SetBackdrop = E.noop
			frame:CreateBackdrop("Transparent")

			frame.isSkinned = true
		end

		for i = 1, frame:GetNumChildren() do
			local button = select(i, frame:GetChildren())
			local frameLevel = frame:GetFrameLevel()

			if frameLevel <= button:GetFrameLevel() then
				button:SetFrameLevel(frameLevel + 2)
			end
		end
	end)

	WorldMapShowDropDownButton:HookScript("OnClick", function(btn)
		SushiDropdownFrame1:ClearAllPoints()
		SushiDropdownFrame1:Point("BOTTOMRIGHT", btn, "TOPRIGHT", 0, 4)

		if SushiDropdownFrame1.isSkinned then return end

		for i = 1, SushiDropdownFrame1:GetNumChildren() do
			local child = select(i, SushiDropdownFrame1:GetChildren())

			if child.IsObjectType and child:IsObjectType("Frame") then
				child:SetBackdrop(nil)
				child.SetBackdrop = E.noop

				SushiDropdownFrame1:CreateBackdrop("Transparent")

				SushiDropdownFrame1.isSkinned = true
			end
		end
	end)

	for i = 1, 2 do
		local mapTip = _G["PetTrackerMapTip"..i]
		if not mapTip then return end

		mapTip:HookScript("OnShow", function(tip)
			tip:SetTemplate("Transparent")
			tip:SetFrameStrata("TOOLTIP")

			for i = 1, tip:NumLines() do
				local line = tip:GetLine(i)
				local texture, text = strmatch(line:GetText(), "^|T(.-)|t(.+)")

				if texture and not strmatch(texture, "PetIcon") then
					texture = split(":", texture)

					tip:GetLine(i):SetFormattedText("|T%s:22:22:0:0:64:64:4:60:4:60|t %s", texture, text)
				end
			end
		end)
	end

	-- Objective List
	hooksecurefunc(PetTracker.List, "NewLine", function()
		if not PetTrackerProgressBar1.isSkinned then
			PetTrackerProgressBar1.Overlay:StripTextures()
			PetTrackerProgressBar1.Overlay:CreateBackdrop("Transparent")

			for i = 1, PetTracker.MaxQuality do
				PetTrackerProgressBar1[i]:SetStatusBarTexture(E.media.normTex)
			end

			PetTrackerProgressBar1.isSkinned = true
		end

		for i = 1, 30 do
			local line = _G["PetTrackerLine"..i]
			if line and not line.isSkinned then
				line.icon:SetTexCoord(unpack(E.TexCoords))
				line.icon:Size(16)

				line.isSkinned = true
			end
		end
	end)

	-- Enemy Cooldowns
	for i = 1, 6 do
		local button = _G["PetTrackerAbilityAction"..i]

		button:StripTextures()
		button:CreateBackdrop()
		button.Icon:SetTexCoord(unpack(E.TexCoords))
	end
end
S:AddCallbackForAddon("PetTracker", "PetTracker", LoadSkin)

local function LoadSkin2()
	if not E.private.addOnSkins.PetTracker then return end

	PetTrackerSwap:StripTextures()
	PetTrackerSwap:SetTemplate("Transparent")

	PetTrackerSwapInset:StripTextures()

	S:HandleCloseButton(PetTrackerSwapCloseButton)

	hooksecurefunc(PetTrackerSwap, "Update", function()
		for i = 1, 6 do
			local slot = _G["PetTrackerBattleSlot"..i]
			if not slot.isSkinned then
				slot:SetTemplate("Transparent")
				slot:CreateBackdrop()
				slot.backdrop:SetOutside(slot.Icon)
				slot.backdrop:SetFrameLevel(slot.backdrop:GetFrameLevel() + 2)
				slot:SetHitRectInsets(1, 1, 1, 1)

				slot:HookScript("OnEnter", function(frame)
					frame:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
				end)
				slot:HookScript("OnLeave", function(frame)
					frame:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end)

				slot.Icon:Point("TOPLEFT", 4, -4)
				slot.Icon:SetTexCoord(unpack(E.TexCoords))
				slot.Icon:SetParent(slot.backdrop)

				slot.Level:FontTemplate(nil, 12, "OUTLINE")
				slot.Level:SetTextColor(1, 1, 1)
				slot.Level:SetParent(slot.backdrop)
				slot.Level:Point("BOTTOMRIGHT", -2, 2)

				slot.Health:StripTextures()
				slot.Health:CreateBackdrop()
				slot.Health:Width(100)
				slot.Health:SetStatusBarTexture(E.media.normTex)
				slot.Health:Point("BOTTOMLEFT", 50, 40)

				slot.Xp:StripTextures()
				slot.Xp:CreateBackdrop()
				slot.Xp:Width(100)
				slot.Xp:SetStatusBarTexture(E.media.normTex)
				slot.Xp:SetStatusBarColor(0.22, 0.39, 0.84)
				slot.Xp:ClearAllPoints()
				slot.Xp:Point("TOP", slot.Health, "BOTTOM", 0, -4)

				slot.Type:Size(30)
				slot.Type:Point("TOPRIGHT", -6, -4)
				slot.Type.Icon:SetTexCoord(0, 1, 0, 1)
				slot.Type.Icon:SetAlpha(0.7)

				slot.Model:Point("TOPRIGHT", -5, -5)

				slot.IsEmpty:SetInside()
				slot.IsDead:SetInside()

				for i = 1, slot.IsDead:GetNumRegions() do
					local region = select(i, slot.IsDead:GetRegions())
					if region.IsObjectType and region:IsObjectType("Texture") and region:GetTexture() then
						if region:GetTexture() == "Interface\\PetBattles\\DeadPetIcon" then
							region:SetInside(slot.Icon)
						end
					end
				end

				slot.Highlight:StripTextures()
				slot.Bg:Hide()
				slot.Quality:Hide()
				slot.LevelBG:Hide()
				slot.IconBorder:Hide()
				slot.Hover:Kill()
				slot.Shadows:Hide()

				slot.isSkinned = true
			end

			local r, g, b = slot.Quality:GetVertexColor()
			slot.backdrop:SetBackdropBorderColor(r, g, b)

			local iconPath = slot.Type.Icon:GetTexture()
			if iconPath then
				local _, petType = split("-", iconPath, 2)
				slot.Type.Icon:SetTexture(E.Media.BattlePetTypes[petType])
			end
		end

		if not PetTrackerSwap.isSkinned then
			for i = 1, PetTrackerSwap:GetNumChildren() do
				local region = select(i, PetTrackerSwap:GetChildren())

				if region and region:IsObjectType("Frame") then
					local a, _, c, d, e = region:GetPoint()

					if a == "TOP" and c == "TOP" and d == 0 and e == 2 then
						region:SetAlpha(0)
					end
				end
			end

			PetTrackerSwap.isSkinned = true
		end

		SkinAbilities()
	end)
end
S:AddCallbackForAddon("PetTracker_Switcher", "PetTracker_Switcher", LoadSkin2)

local function LoadSkin3()
	if not E.private.addOnSkins.PetTracker then return end

	S:HandleCheckBox(PetTracker_JournalTrackToggle)

	hooksecurefunc("PetJournalParent_UpdateSelectedTab", function()
		if PetJournalParentTab3 and not PetJournalParentTab3.isSkinned then
			S:HandleTab(PetJournalParentTab3)
		end
	end)

	hooksecurefunc(PetTrackerTamerJournal, "Update", function()
		if PetTrackerTamerJournal.isSkinned then return end

		PetTrackerTamerJournalCard:StripTextures()
		PetTrackerTamerJournalCard:CreateBackdrop("Transparent")
		PetTrackerTamerJournalCard.backdrop:Point("TOPLEFT", 3, -3)
		PetTrackerTamerJournalCard.backdrop:Point("BOTTOMRIGHT", -2, 0)

		PetTrackerTamerJournal.Count:StripTextures()
		PetTrackerTamerJournal.Count:SetTemplate("Transparent")
		PetTrackerTamerJournal.Count:Point("TOPLEFT", 4, -25)

		S:HandleEditBox(PetTrackerTamerJournalSearchBox)
		PetTrackerTamerJournalSearchBox:Width(256)
		PetTrackerTamerJournalSearchBox:Point("TOPLEFT", MountJournal.LeftInset, 1, -9)

		PetTrackerTamerJournalCard.quest.ring:Kill()
		PetTrackerTamerJournalCard.quest.icon:SetTexCoord(unpack(E.TexCoords))

		PetTrackerTamerJournal.Team:StripTextures()
		PetTrackerTamerJournal.Team.Border:StripTextures()
		PetTrackerTamerJournal.Team:DisableDrawLayer("BORDER")

		PetTrackerTamerJournal.Team.Border.Text:ClearAllPoints()
		PetTrackerTamerJournal.Team.Border.Text:Point("TOP", PetTrackerJournalSlot1, 0, 32)

		PetTrackerTamerJournalMap:CreateBackdrop()
		PetTrackerTamerJournalMap:Point("BOTTOMLEFT", PetTrackerTamerJournalListInset, "BOTTOMRIGHT", 26, 4)

		PetTrackerTamerJournalMapBorder:Kill()
		PetTrackerTamerJournalMapShadow:Kill()

		-- Tabs
		for i = 1, 3 do
			local tab = PetTrackerTamerJournal["Tab"..i]

			if tab then
				tab:SetTemplate(nil, true)

				tab.Icon:SetTexCoord(unpack(E.TexCoords))
				tab.Icon:SetInside()

				tab.Highlight:SetTexture(1, 1, 1, 0.30)
				tab.Highlight:SetInside()

				tab.Hider:SetTexture(0, 0, 0, 0.8)
				tab.Hider:SetInside()

				tab.TabBg:Kill()

				tab:ClearAllPoints()
				if i == 3 then
					tab:Point("BOTTOM", PetTrackerTamerJournalCard, "TOPRIGHT", -20, 2)
				elseif i == 2 then
					tab:Point("RIGHT", PetTrackerTamerJournal.Tab3, "LEFT", -5, 0)
				else
					tab:Point("RIGHT", PetTrackerTamerJournal.Tab2, "LEFT", -5, 0)
				end
			end
		end

		PetTrackerTamerJournal.isSkinned = true
	end)

	-- Scroll Frame
	hooksecurefunc(PetTrackerTamerJournal.List, "update", function()
		if not PetTrackerTamerJournal.List.isSkinned then
			PetTrackerTamerJournal.ListInset:StripTextures()

			PetTrackerTamerJournalList:CreateBackdrop("Transparent")
			PetTrackerTamerJournalList.backdrop:Point("TOPLEFT", -3, 1)
			PetTrackerTamerJournalList.backdrop:Point("BOTTOMRIGHT", 0, -2)

			S:HandleScrollBar(PetTrackerTamerJournalListScrollBar)
			PetTrackerTamerJournalListScrollBar:ClearAllPoints()
			PetTrackerTamerJournalListScrollBar:Point("TOPRIGHT", PetTrackerTamerJournalList, 23, -15)
			PetTrackerTamerJournalListScrollBar:Point("BOTTOMRIGHT", PetTrackerTamerJournalList, 0, 14)

			PetTrackerTamerJournal.List.isSkinned = true
		end

		for i = 1, 12 do
			local button = _G["PetTrackerTamerJournalListButton"..i]
			if not button then return end

			if not button.isSkinned then
				S:HandleItemButton(button)
				button.pushed:SetInside(button.backdrop)

				button.icon:Size(40)

				button.model:SetParent(button.backdrop)
				button.model:Point("TOPLEFT", button.backdrop, 2, -2)
				button.model:Point("BOTTOMRIGHT", button.backdrop, -2, 2)

				button.model.level:SetTextColor(1, 1, 1)
				button.model.level:FontTemplate(nil, 12, "OUTLINE")

				button.model.quality:Hide()
				button.model.levelRing:SetAlpha(0)

				S:HandleButtonHighlight(button)
				button.handledHighlight:SetInside()

				button.selectedTexture:SetTexture(E.Media.Textures.Highlight)
				button.selectedTexture:SetAlpha(0.35)
				button.selectedTexture:SetInside()
				button.selectedTexture:SetTexCoord(0, 1, 0, 1)

				button.petTypeIcon:SetTexCoord(0, 1, 0, 1)
				button.petTypeIcon:SetAlpha(0.2)
				button.petTypeIcon:Size(46, 40)
				button.petTypeIcon:Point("BOTTOMRIGHT", 0, 3)

				hooksecurefunc(button.model.quality, "SetVertexColor", function(_, r, g, b)
					button.name:SetTextColor(r, g, b)
					button.backdrop:SetBackdropBorderColor(r, g, b)
					button.selectedTexture:SetVertexColor(r, g, b)
					button.handledHighlight:SetVertexColor(r, g, b)
				end)

				button.isSkinned = true
			end

			if button.tamer then
				local iconPath = PetTracker:GetTypeIcon(button.tamer:GetType())
				if iconPath then
					local _, petType = split("-", iconPath, 2)
					button.petTypeIcon:SetTexture(E.Media.BattlePetTypes[petType])
				end
			end
		end
	end)

	hooksecurefunc(PetTrackerTamerJournal, "Update", function()
		-- Loot
		for i = 1, 4 do
			local button = _G["PetTrackerTamerJournalCardLoot"..i]

			if button and not button.isSkinned then
				S:HandleItemButton(button)
				button.hover:SetAllPoints()
				button.pushed:SetAllPoints()

				button.isSkinned = true
			end
		end

		-- Pet Slots
		for i = 1, 3 do
			local slot = _G["PetTrackerJournalSlot"..i]
			if not slot then return end

			if not slot.isSkinned then
				slot:SetTemplate("Transparent")
				slot:Size(406, 106)
				slot:CreateBackdrop()
				slot.backdrop:SetOutside(slot.Icon)
				slot.backdrop:SetFrameLevel(slot.backdrop:GetFrameLevel() + 2)

				if i == 1 then
					slot:Point("TOP", PetTrackerTamerJournalTeam, 2, 3)
				elseif i == 2 then
					slot:Point("TOP", PetTrackerTamerJournalTeam, 2, -108)
				elseif i == 3 then
					slot:Point("TOP", PetTrackerTamerJournalTeam, 2, -219)
				end

				slot.Icon:SetTexCoord(unpack(E.TexCoords))
				slot.Icon:SetParent(slot.backdrop)
				slot.Icon:Point("TOPLEFT", slot, 4, -4)

				slot.Level:FontTemplate(nil, 12, "OUTLINE")
				slot.Level:SetTextColor(1, 1, 1)
				slot.Level:SetParent(slot.backdrop)
				slot.Level:Point("BOTTOMRIGHT", -2, 1)

				slot.Type:Size(36)
				slot.Type:SetAlpha(0.8)
				slot.Type:ClearAllPoints()
				slot.Type:Point("BOTTOMLEFT", slot, 6, 12)

				slot.Type.Icon:SetTexCoord(0, 1, 0, 1)

				slot.Model:Point("TOPRIGHT", -5, -5)

				slot.IsEmpty:SetInside()

				hooksecurefunc(slot.Quality, "SetVertexColor", function(_, r, g, b)
					slot.backdrop:SetBackdropBorderColor(r, g, b)
				end)

				slot.PowerIcon:Point("TOPLEFT", slot.Icon, "BOTTOMLEFT", 46, -7)

				slot.HealthIcon:ClearAllPoints()
				slot.HealthIcon:Point("TOPLEFT", slot.SpeedIcon, "BOTTOMLEFT", 0, -2)

				slot.Bg:Hide()
				slot.Quality:Hide()
				slot.Hover:Kill()
				slot.IconBorder:Hide()
				slot.LevelBG:Hide()
				slot.Shadows:Hide()

				slot.isSkinned = true
			end

			local iconPath = slot.Type.Icon:GetTexture()
			if iconPath then
				local _, petType = split("-", iconPath, 2)
				slot.Type.Icon:SetTexture(E.Media.BattlePetTypes[petType])
			end
		end

		SkinAbilities()
	end)

	hooksecurefunc(PetTrackerBattleSlot, "OnCreate", function() SkinAbilities() end)
	hooksecurefunc(PetTrackerJournalSlot, "OnCreate", function() SkinAbilities() end)

	-- History
	hooksecurefunc(PetTrackerTamerJournal.History, "Display", function()
		if not PetTrackerTamerJournal.History.isSkinned then
			select(1, PetTrackerTamerJournal.History:GetChildren()):Kill()

			PetTrackerTamerJournal.History:StripTextures()
			PetTrackerTamerJournal.History:CreateBackdrop("Transparent")
			PetTrackerTamerJournal.History.backdrop:Point("TOPLEFT", 5, -3)
			PetTrackerTamerJournal.History.backdrop:Point("BOTTOMRIGHT", -2, 3)

			S:HandleButton(PetTrackerTamerJournal.History.LoadButton)
			PetTrackerTamerJournal.History.LoadButton:Point("BOTTOMRIGHT", PetTrackerTamerJournal, -9, 4)

			PetTrackerTamerJournal.History.isSkinned = true
		end
	end)

	hooksecurefunc(PetTracker.Record, "Display", function(self)
		if not self.isSkinned then
			self:StripTextures()
			self:CreateBackdrop("Transparent")
			self.backdrop:Point("BOTTOMRIGHT", 4, 0)

			self.bgTex = self:CreateTexture(nil, "ARTWORK")
			self.bgTex:SetTexture(E.Media.Textures.Highlight)
			self.bgTex:SetAlpha(0.35)
			self.bgTex:SetInside(self.backdrop)

			self.Selected:SetTexture(E.Media.Textures.Highlight)
			self.Selected:SetTexCoord(0, 1, 0, 1)
			self.Selected:SetVertexColor(1, 1, 1, 0.35)
			self.Selected:SetInside(self.backdrop)
			self:Height(48)

			self.Content.When:SetTextColor(1, 1, 1)

			self.isSkinned = true
		end

		if self.won then
			self.bgTex:SetVertexColor(0.1, 1, 0.1)
		else
			self.bgTex:SetVertexColor(1, 0.1, 0.1)
		end

		for i in ipairs(self.pets) do
			local button = self.Content["Pet"..i]

			if button then
				if not button.isSkinned then
					button:SetTemplate()
					button:StyleButton(nil, true)
					button:Size(32)
					button:SetScale(1)
					button:ClearAllPoints()

					if i == 3 then
						button:Point("RIGHT", -10, 4)
					else
						button:Point("RIGHT", self.Content["Pet"..i + 1], "LEFT", -20, 0)
					end

					local icon = button:GetNormalTexture()
					icon:SetTexCoord(unpack(E.TexCoords))
					icon:SetInside()

					button:CreateBackdrop()
					button.backdrop:Point("TOPLEFT", button.Health, -1, 1)
					button.backdrop:Point("BOTTOMRIGHT", button, 8, -9)

					button.Health:ClearAllPoints()
					button.Health:Point("BOTTOMLEFT", -4, -8)
					button.Health:SetTexture(E.media.normTex)
					button.Health:SetVertexColor(0.1, 1, 0.1)
					button.Health:Height(5)

					button.Dead:SetTexture("Interface\\PetBattles\\DeadPetIcon")
					button.Dead:SetTexCoord(0, 1, 0, 1)
					button.Dead:SetInside()

					button.IconBorder:SetAlpha(0)
					button.HealthBorder:SetAlpha(0)
					button.HealthBg:SetAlpha(0)

					button.isSkinned = true
				end

				if button.id then
					local quality = select(5, C_PetJournal_GetPetStats(button.id))
					local color = ITEM_QUALITY_COLORS[quality - 1]
					button:SetBackdropBorderColor(color.r, color.g, color.b)
				end
			end
		end
	end)
end
S:AddCallbackForAddon("PetTracker_Journal", "PetTracker_Journal", LoadSkin3)