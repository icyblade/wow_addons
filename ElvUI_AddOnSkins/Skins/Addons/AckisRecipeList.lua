local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local TT = E:GetModule("Tooltip")

local ipairs, select, unpack = ipairs, select, unpack
local find = string.find

local hooksecurefunc = hooksecurefunc

-- AckisRecipeList v3.0.5

local function LoadSkin()
	if not E.private.addOnSkins.AckisRecipeList then return end

	local ARL = LibStub("AceAddon-3.0"):GetAddon("Ackis Recipe List", true)
	if not ARL then return end

	local function HandleScrollBar(frame)
		local UpButton = select(1, frame:GetChildren())
		local DownButton = select(2, frame:GetChildren())

		S:HandleNextPrevButton(UpButton)
		UpButton:Size(20, 18)

		S:HandleNextPrevButton(DownButton)
		DownButton:Size(20, 18)

		frame.trackbg = CreateFrame("Frame", nil, frame)
		frame.trackbg:Point("TOPLEFT", UpButton, "BOTTOMLEFT", 0, -1)
		frame.trackbg:Point("BOTTOMRIGHT", DownButton, "TOPRIGHT", 0, 1)
		frame.trackbg:SetTemplate()

		local thumb = frame:GetThumbTexture()
		thumb:SetAlpha(0)

		frame.thumbbg = CreateFrame("Frame", nil, frame)
		frame.thumbbg:Point("TOPLEFT", thumb, 8, -7)
		frame.thumbbg:Point("BOTTOMRIGHT", thumb, -8, 7)
		frame.thumbbg:SetTemplate("Default", true, true)
		frame.thumbbg.backdropTexture:SetVertexColor(0.6, 0.6, 0.6)
		frame.thumbbg:SetFrameLevel(frame.trackbg:GetFrameLevel() + 1)

		frame:Show()
		frame.Hide = E.noop
	end

	local function SkinButton(button, strip)
		S:HandleButton(button, strip)

		button.SetNormalTexture = E.noop
		button.SetHighlightTexture = E.noop
		button.SetPushedTexture = E.noop
		button.SetDisabledTexture = E.noop
	end

	local function ExpansionButton(button)
		select(1, button:GetRegions()):SetDesaturated(true)

		button:GetPushedTexture():SetTexture("")
		button:GetHighlightTexture():SetTexture("")
		button:GetCheckedTexture():SetTexture("")

		hooksecurefunc(button, "SetChecked", function(self, state)
			select(1, self:GetRegions()):SetDesaturated(state)
		end)
	end

	hooksecurefunc(ARL, "TRADE_SKILL_SHOW", function(self)
		if self.scan_button and not self.scan_button.isSkinned then 
			S:HandleButton(self.scan_button)
			self.scan_button:Size(40, 16)

			self.scan_button.isSkinned = true
		end
		if self.scan_button:GetParent() == TradeSkillFrame then
			self.scan_button:SetFrameLevel(TradeSkillFrame:GetFrameLevel() + 10)
		end
	end)

	hooksecurefunc(ARL, "Scan", function(self)
		if not ARL_MainPanel.isSkinned then
			ARL_MainPanel:CreateBackdrop("Transparent")
			ARL_MainPanel.backdrop:Point("TOPLEFT", 10, -12)
			ARL_MainPanel.backdrop:Point("BOTTOMRIGHT", -35, 74)

			ARL_MainPanel.BG = CreateFrame("Frame", nil, ARL_MainPanel)
			ARL_MainPanel.BG:CreateBackdrop("Transparent")
			ARL_MainPanel.BG:Point("TOPLEFT", 349, -76)
			ARL_MainPanel.BG:Point("BOTTOMRIGHT", -93, 104)
			ARL_MainPanel.BG:Hide()

			hooksecurefunc(ARL_MainPanel, "ToggleState", function(self)
				if self.is_expanded then
					self.backdrop:ClearAllPoints()
					self.backdrop:Point("TOPLEFT", 10, -12)
					self.backdrop:Point("BOTTOMRIGHT", -88, 74)
					self.BG:Show()
				else
					self.backdrop:ClearAllPoints()
					self.backdrop:Point("TOPLEFT", 10, -12)
					self.backdrop:Point("BOTTOMRIGHT", -35, 74)
					self.BG:Hide()
				end
			end)

			ARL_MainPanel.title_bar:Hide()

			ARL_MainPanel.top_left:Kill()
			ARL_MainPanel.top_right:Kill()
			ARL_MainPanel.bottom_left:Kill()
			ARL_MainPanel.bottom_right:Kill()

			ARL_MainPanel.progress_bar:StripTextures()
			ARL_MainPanel.progress_bar:CreateBackdrop()
			ARL_MainPanel.progress_bar:Height(20)
			ARL_MainPanel.progress_bar:Point("BOTTOMLEFT", ARL_MainPanel, 15, 79)
			ARL_MainPanel.progress_bar:SetStatusBarTexture(E.media.normTex)
			ARL_MainPanel.progress_bar:SetStatusBarColor(0.22, 0.39, 0.84)
			E:RegisterStatusBar(ARL_MainPanel.progress_bar)

			ARL_MainPanel.prof_button:CreateBackdrop(nil, true)
			ARL_MainPanel.prof_button:Size(36)
			ARL_MainPanel.prof_button:Point("TOPLEFT", ARL_MainPanel, 14, -16)

			ARL_MainPanel.prof_button:GetHighlightTexture():SetInside(ARL_MainPanel.prof_button.backdrop)
			ARL_MainPanel.prof_button:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)

			ARL_MainPanel.profession_texture:SetInside(ARL_MainPanel.prof_button.backdrop)
			ARL_MainPanel.profession_texture:SetTexCoord(0.22, 0.78, 0.22, 0.78)

			hooksecurefunc(ARL_MainPanel.prof_button, "SetTexture", function(self)
				ARL_MainPanel.profession_texture:SetInside(ARL_MainPanel.prof_button.backdrop)
				ARL_MainPanel.profession_texture:SetTexCoord(0.22, 0.78, 0.22, 0.78)
			end)

			ARL_MainPanel.list_frame:SetBackdrop(nil)
			ARL_MainPanel.list_frame:CreateBackdrop("Transparent")
			ARL_MainPanel.list_frame.backdrop:Point("TOPLEFT", -8, 0)
			ARL_MainPanel.list_frame.backdrop:Point("BOTTOMRIGHT", 1, 1)

			select(2, ARL_MainPanel.expand_button:GetPoint()):GetParent():Hide()

			S:HandleEditBox(ARL_MainPanel.search_editbox)
			ARL_MainPanel.search_editbox.backdrop:Point("TOPLEFT", -2, 0)
			ARL_MainPanel.search_editbox:Point("TOPLEFT", ARL_MainPanel, 60, -30)
			ARL_MainPanel.search_editbox:DisableDrawLayer("BACKGROUND")
			ARL_MainPanel.search_editbox:Size(140, 19)

			HandleScrollBar(ARL_MainPanel.list_frame.scroll_bar)
			ARL_MainPanel.list_frame.scroll_bar:Point("TOPLEFT", ARL_MainPanel.list_frame, "TOPRIGHT", 4, -14)
			ARL_MainPanel.list_frame.scroll_bar:Point("BOTTOMLEFT", ARL_MainPanel.list_frame, "BOTTOMRIGHT", 0, 15)

			S:HandleCloseButton(ARL_MainPanel.xclose_button, ARL_MainPanel.backdrop)

			S:HandleNextPrevButton(ARL_MainPanel.filter_toggle, "right", nil, true)
			ARL_MainPanel.filter_toggle:Point("TOPLEFT", ARL_MainPanel, 323, -41)
			ARL_MainPanel.filter_toggle:Size(28)

			ARL_MainPanel.filter_toggle.SetTextures = function(self)
				local normal = self:GetNormalTexture()
				local rotation = ARL_MainPanel.is_expanded and 1.57 or -1.57

				normal:SetRotation(rotation)
				self:GetNormalTexture():SetRotation(rotation)

				self:HookScript("OnEnter", function() normal:SetVertexColor(unpack(E.media.rgbvaluecolor)) end)
				self:HookScript("OnLeave", function() normal:SetVertexColor(1, 1, 1) end)
			end

			ARL_MainPanel.close_button:Size(109, 22)
			ARL_MainPanel.close_button:Point("LEFT", ARL_MainPanel.progress_bar, "RIGHT", 3, 0)
			SkinButton(ARL_MainPanel.close_button, true)

			ARL_MainPanel.expand_button:ClearAllPoints()
			ARL_MainPanel.expand_button:Point("BOTTOMRIGHT", ARL_MainPanel.search_editbox, "BOTTOMLEFT", -28, -23)

			S:HandleNextPrevButton(ARL_MainPanel.sort_button, "down", nil, true)
			ARL_MainPanel.sort_button:Size(22)
			ARL_MainPanel.sort_button:ClearAllPoints()
			ARL_MainPanel.sort_button:Point("LEFT", ARL_MainPanel.expand_button, "RIGHT", 20, 1)

			ARL_MainPanel.sort_button.SetTextures = function(self)
				local normal, pushed = self:GetNormalTexture(), self:GetPushedTexture()

				if ARL.db.profile.sorting == "Ascending" then
					normal:SetRotation(3.14)
					pushed:SetRotation(3.14)
				else
					normal:SetRotation(0)
					pushed:SetRotation(0)
				end

				self:HookScript("OnEnter", function() normal:SetVertexColor(unpack(E.media.rgbvaluecolor)) end)
				self:HookScript("OnLeave", function() normal:SetVertexColor(1, 1, 1) end)
			end

			for i = 1, ARL_MainPanel:GetNumChildren() do
				local p1, frame, p2, x, y
				local child = select(i, ARL_MainPanel:GetChildren())

				if child and child:IsObjectType("CheckButton") and child.text then
					S:HandleCheckBox(child, true)
					child:Size(20)

					p1, frame, p2, x, y = child:GetPoint()
					child:Point(p1, frame, p2, x + 4, y)

					p1, frame, p2, x, y = child.text:GetPoint()
					child.text:Point(p1, frame, p2, x + 4, y)
				end
			end

			for i = 0, 25 do
				local state = ARL_MainPanel.list_frame.state_buttons[i]
				if i == 0 then state = ARL_MainPanel.expand_button end
				local entry = ARL_MainPanel.list_frame.entry_buttons[i]

				if entry then
					S:HandleButtonHighlight(entry)
					entry.handledHighlight:Point("TOPLEFT", -20, -1)
					entry.handledHighlight:Point("BOTTOMRIGHT", 2, 2)

					entry.selected_texture:SetTexture(E.Media.Textures.Highlight)
					entry.selected_texture:SetVertexColor(1, 0.80, 0.10)
					entry.selected_texture:SetAlpha(0.45)
					entry.selected_texture:SetTexCoord(0, 1, 0, 1)
					entry.selected_texture:Point("TOPLEFT", -20, -1)
					entry.selected_texture:Point("BOTTOMRIGHT", 2, 2)

					entry.emphasis_texture:SetTexture(E.Media.Textures.Highlight)
					entry.emphasis_texture:SetVertexColor(0.10, 0.80, 0.10)
					entry.emphasis_texture:SetAlpha(0.45)
					entry.emphasis_texture:Point("TOPLEFT", -20, -1)
					entry.emphasis_texture:Point("BOTTOMRIGHT", 2, 2)
				end

				state:SetNormalTexture(E.Media.Textures.Plus)
				state.SetNormalTexture = E.noop

				local normal = state:GetNormalTexture()
				normal:Size(14)
				normal:Point("LEFT", 15, 3)
				normal.SetPoint = E.noop

				state:SetPushedTexture(E.Media.Textures.Plus)
				state.SetPushedTexture = E.noop

				local pushed = state:GetPushedTexture()
				pushed:Size(14)
				pushed:Point("LEFT", 15, 3)
				pushed.SetPoint = E.noop

				state:SetDisabledTexture(E.Media.Textures.Plus)
				state.SetDisabledTexture = E.noop

				local disabled = state:GetDisabledTexture()
				disabled:Size(14)
				disabled:Point("LEFT", 15, 3)
				disabledSetPoint = E.noop
				disabled:SetVertexColor(0.6, 0.6, 0.6)

				state:SetHighlightTexture("")
				state.SetHighlightTexture = E.noop

				hooksecurefunc(state, "SetNormalTexture", function(_, texture)
					if find(texture, "MinusButton") or find(texture, "ZoomOutButton") then
						normal:SetTexture(E.Media.Textures.Minus)
						pushed:SetTexture(E.Media.Textures.Minus)
					elseif find(texture, "PlusButton") or find(texture, "ZoomInButton") then
						normal:SetTexture(E.Media.Textures.Plus)
						pushed:SetTexture(E.Media.Textures.Plus)
					end
				end)
			end

			for i, tab in ipairs(ARL_MainPanel.tabs) do
				tab:StripTextures()
				tab.left:Kill()
				tab.middle:Kill()
				tab.right:Kill()

				tab.backdrop = CreateFrame("Frame", nil, tab)
				tab.backdrop:SetTemplate()
				tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
				tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
				tab.backdrop:Point("BOTTOMRIGHT", -10, 3)

				if i == 1 then
					local p1, frame, p2, x, y = tab:GetPoint()
					tab:Point(p1, frame, p2, x, y - 5)
				end
			end

			if not (TipTac and TipTac.AddModifiedTip) then
				AckisRecipeList_SpellTooltip:HookScript("OnShow", function(self)
					TT:SetStyle(self)
				end)

				local LQT = LibStub("LibQTip-1.0")
				if LQT then
					hooksecurefunc(LQT, "Acquire", function(self, key)
						local tooltip = self.activeTooltips[key]
						if tooltip then
							TT:SetStyle(tooltip)

							if not tooltip.isSkinned then
								for i = 1, tooltip:GetNumChildren() do
									local child = select(i, tooltip:GetChildren())
									if child.IsObjectType and child:IsObjectType("Slider") then
										S:HandleSliderFrame(child)
									end
								end
							end
						end
					end)

					hooksecurefunc(LQT.LabelPrototype, "SetupCell", function(self)
						self.fontString:FontTemplate(E.Libs.LSM:Fetch("font", E.db.tooltip.font), E.db.tooltip.fontOutline, E.db.tooltip.textFontSize)
					end)
				end
			end

			ARL_MainPanel.isSkinned = true
		end

		ARL_MainPanel.filter_toggle:HookScript("OnClick", function(self)
			if not self.IsSkinned then
				ARL_MainPanel.filter_menu:Point("TOPRIGHT", ARL_MainPanel, "TOPRIGHT", -115, -75)

				ARL_MainPanel.filter_reset:Point("BOTTOMRIGHT", ARL_MainPanel, "BOTTOMRIGHT", -92, 78)
				SkinButton(ARL_MainPanel.filter_reset, true)

				for i, menuIcon in ipairs({"general", "obtain", "binding", "item", "quality", "player", "rep", "misc"}) do
					local iconEntry = ARL_MainPanel["menu_toggle_"..menuIcon]

					if i == 1 then
						iconEntry:Point("LEFT", self, "RIGHT", 21, 0)
					end

					iconEntry:SetTemplate()
					iconEntry:StyleButton()
					iconEntry:DisableDrawLayer("BACKGROUND")

					local region = select(2, iconEntry:GetRegions())
					region:SetInside()
					region:SetTexCoord(unpack(E.TexCoords))
				end

				for _, menu in ipairs({"general", "obtain", "binding", "quality", "player", "rep", "misc"}) do
					local menuEntry = ARL_MainPanel.filter_menu[menu]

					if menu == "misc" then
						for i = 1, menuEntry:GetNumChildren() do
							local child = select(i, menuEntry:GetChildren())

							if child and child:IsObjectType("Button") then
								S:HandleNextPrevButton(child)
								select(2, child:GetPoint()):SetTextColor(1, 1, 1)
							end
						end
					elseif menu == "rep" then
						for expNum = 0, 4 do
							local expEntry = menuEntry["expansion"..expNum]

							for i = 1, expEntry:GetNumChildren() do
								local child = select(i, expEntry:GetChildren())

								if child and (child:IsObjectType("Button") and not child:IsObjectType("CheckButton")) then
									local normal = child:GetNormalFontObject()
									normal:SetTextColor(1, 0.8, 0.1)

									child:SetNormalFontObject(normal)
									child:SetHighlightFontObject(normal)
								elseif child and child:IsObjectType("CheckButton") and child.text then
									S:HandleCheckBox(child)
									child.text:SetTextColor(1, 1, 1)
								end
							end

							ExpansionButton(menuEntry["toggle_expansion"..expNum])
						end
					else
						for i = 1, menuEntry:GetNumChildren() do
							local child = select(i, menuEntry:GetChildren())

							if child and (child:IsObjectType("Button") and not child:IsObjectType("CheckButton")) then
								local normal = child:GetNormalFontObject()
								normal:SetTextColor(1, 0.8, 0.1)

								child:SetNormalFontObject(normal)
								child:SetHighlightFontObject(normal)
							elseif child and child:IsObjectType("CheckButton") and child.text then
								S:HandleCheckBox(child)
								child.text:SetTextColor(1, 1, 1)
							end
						end
					end
				end

				self.IsSkinned = true
			end
		end)

		local professions = {
			"items_alchemy",
			"items_blacksmithing",
			"items_cooking",
			"items_enchanting",
			"items_engineering",
			"items_firstaid",
			"items_inscription",
			"items_jewelcrafting",
			"items_leatherworking",
			"items_runeforging",
			"items_smelting",
			"items_tailoring"
		}

		ARL_MainPanel.filter_menu.item:HookScript("OnShow", function(item)
			local panelName = professions[ARL_MainPanel.current_profession]
			if not panelName then return end

			for i = 1, item[panelName]:GetNumChildren() do
				local child = select(i, item[panelName]:GetChildren())

				if child and (child:IsObjectType("Button") and not child:IsObjectType("CheckButton")) then
					if not child.isSkinned then
						local normal = child:GetNormalFontObject()

						if normal then
							normal:SetTextColor(1, 0.8, 0.1)

							child:SetNormalFontObject(normal)
							child:SetHighlightFontObject(normal)
						end

						child.IsSkinned = true
					end
				elseif child and child:IsObjectType("CheckButton") and child.text then
					if not child.isSkinned then
						S:HandleCheckBox(child)
						child.text:SetTextColor(1, 1, 1)

						child.IsSkinned = true
					end
				end
			end
		end)
	end)
end

S:AddCallbackForAddon("AckisRecipeList", "AckisRecipeList", LoadSkin)