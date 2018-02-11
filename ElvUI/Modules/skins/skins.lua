local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:NewModule('Skins', 'AceTimer-3.0', 'AceHook-3.0', 'AceEvent-3.0')

--Cache global variables
--Lua functions
local _G = _G
local unpack, assert, pairs, ipairs, select, type, pcall = unpack, assert, pairs, ipairs, select, type, pcall
local tinsert, wipe, next = table.insert, table.wipe, next
--WoW API / Variables
local CreateFrame = CreateFrame
local SetDesaturation = SetDesaturation
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = IsAddOnLoaded
local GetCVarBool = GetCVarBool

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: SquareButton_SetIcon, ScriptErrorsFrame

E.Skins = S
S.addonsToLoad = {}
S.nonAddonsToLoad = {}
S.allowBypass = {}
S.addonCallbacks = {}
S.nonAddonCallbacks = {["CallPriority"] = {}}

local find = string.find

function S:SetModifiedBackdrop()
	if self.backdrop then self = self.backdrop end
	self:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
end

function S:SetOriginalBackdrop()
	if self.backdrop then self = self.backdrop end
	self:SetBackdropBorderColor(unpack(E["media"].bordercolor))
end

-- function to handle the recap button script
function S:UpdateRecapButton()
	-- when UpdateRecapButton runs and enables the button, it unsets OnEnter
	-- we need to reset it with ours. blizzard will replace it when the button
	-- is disabled. so, we don't have to worry about anything else.
	if self and self.button4 and self.button4:IsEnabled() then
		self.button4:SetScript("OnEnter", S.SetModifiedBackdrop)
		self.button4:SetScript("OnLeave", S.SetOriginalBackdrop)
	end
end

S.PVPHonorXPBarFrames = {}
S.PVPHonorXPBarSkinned = false
function S:SkinPVPHonorXPBar(frame)
	S.PVPHonorXPBarFrames[frame] = true

	if S.PVPHonorXPBarSkinned then return end
	S.PVPHonorXPBarSkinned = true

	hooksecurefunc('PVPHonorXPBar_SetNextAvailable', function(XPBar)
		if not S.PVPHonorXPBarFrames[XPBar:GetParent():GetName()] then return end
		XPBar:StripTextures() --XPBar

		if XPBar.Bar and not XPBar.Bar.backdrop then
			XPBar.Bar:CreateBackdrop("Default")
			if XPBar.Bar.Spark then
				XPBar.Bar.Spark:SetAlpha(0)
			end
			if XPBar.Bar.OverlayFrame and XPBar.Bar.OverlayFrame.Text then
				XPBar.Bar.OverlayFrame.Text:ClearAllPoints()
				XPBar.Bar.OverlayFrame.Text:Point("CENTER", XPBar.Bar)
			end
		end

		if XPBar.PrestigeReward and XPBar.PrestigeReward.Accept then
			XPBar.PrestigeReward.Accept:ClearAllPoints()
			XPBar.PrestigeReward.Accept:SetPoint("TOP", XPBar.PrestigeReward, "BOTTOM", 0, 0)
			if not XPBar.PrestigeReward.Accept.template then
				S:HandleButton(XPBar.PrestigeReward.Accept)
			end
		end

		if XPBar.NextAvailable then
			if XPBar.Bar then
				XPBar.NextAvailable:ClearAllPoints()
				XPBar.NextAvailable:SetPoint("LEFT", XPBar.Bar, "RIGHT", 0, -2)
			end

			if not XPBar.NextAvailable.backdrop then
				XPBar.NextAvailable:StripTextures()
				XPBar.NextAvailable:CreateBackdrop("Default")
				if XPBar.NextAvailable.Icon then
					XPBar.NextAvailable.backdrop:SetPoint("TOPLEFT", XPBar.NextAvailable.Icon, -(E.PixelMode and 1 or 2), (E.PixelMode and 1 or 2))
					XPBar.NextAvailable.backdrop:SetPoint("BOTTOMRIGHT", XPBar.NextAvailable.Icon, (E.PixelMode and 1 or 2), -(E.PixelMode and 1 or 2))
				end
			end

			if XPBar.NextAvailable.Icon then
				XPBar.NextAvailable.Icon:SetDrawLayer("ARTWORK")
				XPBar.NextAvailable.Icon:SetTexCoord(unpack(E.TexCoords))
			end
		end
	end)
end

function S:StatusBarColorGradient(bar, value, max, backdrop)
	local current = (not max and value) or (value and max and max ~= 0 and value/max)
	if not (bar and current) then return end
	local r, g, b = E:ColorGradient(current, 0.8,0,0, 0.8,0.8,0, 0,0.8,0)
	local bg = backdrop or bar.backdrop
	if bg then bg:SetBackdropColor(r*0.25, g*0.25, b*0.25) end
	bar:SetStatusBarColor(r, g, b)
end

function S:HandleButton(f, strip)
	assert(f, "doesn't exist!")

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end

	if f.TopLeft then f.TopLeft:SetAlpha(0) end
	if f.TopMiddle then f.TopMiddle:SetAlpha(0) end
	if f.TopRight then f.TopRight:SetAlpha(0) end
	if f.MiddleLeft then f.MiddleLeft:SetAlpha(0) end
	if f.MiddleMiddle then f.MiddleMiddle:SetAlpha(0) end
	if f.MiddleRight then f.MiddleRight:SetAlpha(0) end
	if f.BottomLeft then f.BottomLeft:SetAlpha(0) end
	if f.BottomMiddle then f.BottomMiddle:SetAlpha(0) end
	if f.BottomRight then f.BottomRight:SetAlpha(0) end

	if f.LeftSeparator then f.LeftSeparator:SetAlpha(0) end
	if f.RightSeparator then f.RightSeparator:SetAlpha(0) end

	if f.SetNormalTexture then f:SetNormalTexture("") end
	if f.SetHighlightTexture then f:SetHighlightTexture("") end
	if f.SetPushedTexture then f:SetPushedTexture("") end
	if f.SetDisabledTexture then f:SetDisabledTexture("") end

	if strip then f:StripTextures() end

	f:SetTemplate("Default", true)
	f:HookScript("OnEnter", S.SetModifiedBackdrop)
	f:HookScript("OnLeave", S.SetOriginalBackdrop)
end

function S:HandleScrollBar(frame, thumbTrim)
	if frame:GetName() then
		if frame.Background then frame.Background:SetTexture(nil) end
		if frame.trackBG then frame.trackBG:SetTexture(nil) end
		if frame.Middle then frame.Middle:SetTexture(nil) end
		if frame.Top then frame.Top:SetTexture(nil) end
		if frame.Bottom then frame.Bottom:SetTexture(nil) end
		if frame.ScrollBarTop then frame.ScrollBarTop:SetTexture(nil) end
		if frame.ScrollBarBottom then frame.ScrollBarBottom:SetTexture(nil) end
		if frame.ScrollBarMiddle then frame.ScrollBarMiddle:SetTexture(nil) end

		if _G[frame:GetName().."BG"] then _G[frame:GetName().."BG"]:SetTexture(nil) end
		if _G[frame:GetName().."Track"] then _G[frame:GetName().."Track"]:SetTexture(nil) end

		if _G[frame:GetName().."Top"] then
			_G[frame:GetName().."Top"]:SetTexture(nil)
		end

		if _G[frame:GetName().."Bottom"] then
			_G[frame:GetName().."Bottom"]:SetTexture(nil)
		end

		if _G[frame:GetName().."Middle"] then
			_G[frame:GetName().."Middle"]:SetTexture(nil)
		end

		if _G[frame:GetName().."ScrollUpButton"] and _G[frame:GetName().."ScrollDownButton"] then
			_G[frame:GetName().."ScrollUpButton"]:StripTextures()
			if not _G[frame:GetName().."ScrollUpButton"].icon then
				S:HandleNextPrevButton(_G[frame:GetName().."ScrollUpButton"])
				SquareButton_SetIcon(_G[frame:GetName().."ScrollUpButton"], 'UP')
				_G[frame:GetName().."ScrollUpButton"]:Size(_G[frame:GetName().."ScrollUpButton"]:GetWidth() + 7, _G[frame:GetName().."ScrollUpButton"]:GetHeight() + 7)
			end

			_G[frame:GetName().."ScrollDownButton"]:StripTextures()
			if not _G[frame:GetName().."ScrollDownButton"].icon then
				S:HandleNextPrevButton(_G[frame:GetName().."ScrollDownButton"])
				SquareButton_SetIcon(_G[frame:GetName().."ScrollDownButton"], 'DOWN')
				_G[frame:GetName().."ScrollDownButton"]:Size(_G[frame:GetName().."ScrollDownButton"]:GetWidth() + 7, _G[frame:GetName().."ScrollDownButton"]:GetHeight() + 7)
			end

			if not frame.trackbg then
				frame.trackbg = CreateFrame("Frame", nil, frame)
				frame.trackbg:Point("TOPLEFT", _G[frame:GetName().."ScrollUpButton"], "BOTTOMLEFT", 0, -1)
				frame.trackbg:Point("BOTTOMRIGHT", _G[frame:GetName().."ScrollDownButton"], "TOPRIGHT", 0, 1)
				frame.trackbg:SetTemplate("Transparent")
			end

			if frame:GetThumbTexture() then
				if not thumbTrim then thumbTrim = 3 end
				frame:GetThumbTexture():SetTexture(nil)
				if not frame.thumbbg then
					frame.thumbbg = CreateFrame("Frame", nil, frame)
					frame.thumbbg:Point("TOPLEFT", frame:GetThumbTexture(), "TOPLEFT", 2, -thumbTrim)
					frame.thumbbg:Point("BOTTOMRIGHT", frame:GetThumbTexture(), "BOTTOMRIGHT", -2, thumbTrim)
					frame.thumbbg:SetTemplate("Default", true, true)
					frame.thumbbg.backdropTexture:SetVertexColor(0.6, 0.6, 0.6)
					if frame.trackbg then
						frame.thumbbg:SetFrameLevel(frame.trackbg:GetFrameLevel()+1)
					end
				end
			end
		end
	else
		if frame.Background then frame.Background:SetTexture(nil) end
		if frame.trackBG then frame.trackBG:SetTexture(nil) end
		if frame.Middle then frame.Middle:SetTexture(nil) end
		if frame.Top then frame.Top:SetTexture(nil) end
		if frame.Bottom then frame.Bottom:SetTexture(nil) end
		if frame.ScrollBarTop then frame.ScrollBarTop:SetTexture(nil) end
		if frame.ScrollBarBottom then frame.ScrollBarBottom:SetTexture(nil) end
		if frame.ScrollBarMiddle then frame.ScrollBarMiddle:SetTexture(nil) end

		if frame.ScrollUpButton and frame.ScrollDownButton then
			if not frame.ScrollUpButton.icon then
				S:HandleNextPrevButton(frame.ScrollUpButton, true, true)
				frame.ScrollUpButton:Size(frame.ScrollUpButton:GetWidth() + 7, frame.ScrollUpButton:GetHeight() + 7)
			end

			if not frame.ScrollDownButton.icon then
				S:HandleNextPrevButton(frame.ScrollDownButton, true)
				frame.ScrollDownButton:Size(frame.ScrollDownButton:GetWidth() + 7, frame.ScrollDownButton:GetHeight() + 7)
			end

			if not frame.trackbg then
				frame.trackbg = CreateFrame("Frame", nil, frame)
				frame.trackbg:Point("TOPLEFT", frame.ScrollUpButton, "BOTTOMLEFT", 0, -1)
				frame.trackbg:Point("BOTTOMRIGHT", frame.ScrollDownButton, "TOPRIGHT", 0, 1)
				frame.trackbg:SetTemplate("Transparent")
			end

			if frame.thumbTexture then
				if not thumbTrim then thumbTrim = 3 end
				frame.thumbTexture:SetTexture(nil)
				if not frame.thumbbg then
					frame.thumbbg = CreateFrame("Frame", nil, frame)
					frame.thumbbg:Point("TOPLEFT", frame.thumbTexture, "TOPLEFT", 2, -thumbTrim)
					frame.thumbbg:Point("BOTTOMRIGHT", frame.thumbTexture, "BOTTOMRIGHT", -2, thumbTrim)
					frame.thumbbg:SetTemplate("Default", true, true)
					frame.thumbbg.backdropTexture:SetVertexColor(0.6, 0.6, 0.6)
					if frame.trackbg then
						frame.thumbbg:SetFrameLevel(frame.trackbg:GetFrameLevel()+1)
					end
				end
			end
		end
	end
end

--Tab Regions
local tabs = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right",
}

function S:HandleTab(tab)
	if not tab then return end
	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		if tex then
			tex:SetTexture(nil)
		end
	end

	if tab.GetHighlightTexture and tab:GetHighlightTexture() then
		tab:GetHighlightTexture():SetTexture(nil)
	else
		tab:StripTextures()
	end

	tab.backdrop = CreateFrame("Frame", nil, tab)
	tab.backdrop:SetTemplate("Default")
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
	tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
end

function S:HandleNextPrevButton(btn, useVertical, inverseDirection)
	inverseDirection = inverseDirection or btn:GetName() and (find(btn:GetName():lower(), 'left') or find(btn:GetName():lower(), 'prev') or find(btn:GetName():lower(), 'decrement') or find(btn:GetName():lower(), 'back'))

	btn:StripTextures()
	btn:SetNormalTexture(nil)
	btn:SetPushedTexture(nil)
	btn:SetHighlightTexture(nil)
	btn:SetDisabledTexture(nil)

	if not btn.icon then
		btn.icon = btn:CreateTexture(nil, 'ARTWORK')
		btn.icon:Size(13)
		btn.icon:Point('CENTER')
		btn.icon:SetTexture([[Interface\Buttons\SquareButtonTextures]])
		btn.icon:SetTexCoord(0.01562500, 0.20312500, 0.01562500, 0.20312500)

		btn:HookScript('OnMouseDown', function(self)
			if self:IsEnabled() then
				self.icon:Point("CENTER", -1, -1);
			end
		end)

		btn:HookScript('OnMouseUp', function(self)
			self.icon:Point("CENTER", 0, 0);
		end)

		btn:HookScript('OnDisable', function(self)
			SetDesaturation(self.icon, true);
			self.icon:SetAlpha(0.5);
		end)

		btn:HookScript('OnEnable', function(self)
			SetDesaturation(self.icon, false);
			self.icon:SetAlpha(1.0);
		end)

		if not btn:IsEnabled() then
			btn:GetScript('OnDisable')(btn)
		end
	end

	if useVertical then
		if inverseDirection then
			SquareButton_SetIcon(btn, 'UP')
		else
			SquareButton_SetIcon(btn, 'DOWN')
		end
	else
		if inverseDirection then
			SquareButton_SetIcon(btn, 'LEFT')
		else
			SquareButton_SetIcon(btn, 'RIGHT')
		end
	end

	S:HandleButton(btn)
	btn:Size(btn:GetWidth() - 7, btn:GetHeight() - 7)
end

function S:HandleRotateButton(btn)
	btn:SetTemplate("Default")
	btn:Size(btn:GetWidth() - 14, btn:GetHeight() - 14)

	btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	btn:GetPushedTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)

	btn:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.3)

	btn:GetNormalTexture():SetInside()
	btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end

-- Introduced in 7.3
function S:HandleMaxMinFrame(frame)
	assert(frame, "does not exist.")

	frame:StripTextures()

	for _, name in next, {"MaximizeButton", "MinimizeButton"} do
		local button = frame[name]
		if button then
			button:SetSize(18, 18)
			button:ClearAllPoints()
			button:SetPoint("CENTER")

			button:SetNormalTexture("Interface\\AddOns\\ElvUI\\media\\textures\\vehicleexit")
			button:SetPushedTexture("Interface\\AddOns\\ElvUI\\media\\textures\\vehicleexit")
			button:SetHighlightTexture("Interface\\AddOns\\ElvUI\\media\\textures\\vehicleexit")

			if not button.backdrop then
				button:CreateBackdrop("Default", true)
				button.backdrop:Point("TOPLEFT", button, 1, -1)
				button.backdrop:Point("BOTTOMRIGHT", button, -1, 1)
				button:HookScript('OnEnter', S.SetModifiedBackdrop)
				button:HookScript('OnLeave', S.SetOriginalBackdrop)
				button:SetHitRectInsets(1, 1, 1, 1)
			end

			if name == "MaximizeButton" then
				button:GetNormalTexture():SetTexCoord(1, 1, 1, -1.2246467991474e-016, 1.1102230246252e-016, 1, 0, -1.144237745222e-017)
				button:GetPushedTexture():SetTexCoord(1, 1, 1, -1.2246467991474e-016, 1.1102230246252e-016, 1, 0, -1.144237745222e-017)
				button:GetHighlightTexture():SetTexCoord(1, 1, 1, -1.2246467991474e-016, 1.1102230246252e-016, 1, 0, -1.144237745222e-017)
			end
		end
	end
end

function S:HandleEditBox(frame)
	frame:CreateBackdrop("Default")

	if frame.TopLeftTex then frame.TopLeftTex:Kill() end
	if frame.TopRightTex then frame.TopRightTex:Kill() end
	if frame.TopTex then frame.TopTex:Kill() end
	if frame.BottomLeftTex then frame.BottomLeftTex:Kill() end
	if frame.BottomRightTex then frame.BottomRightTex:Kill() end
	if frame.BottomTex then frame.BottomTex:Kill() end
	if frame.LeftTex then frame.LeftTex:Kill() end
	if frame.RightTex then frame.RightTex:Kill() end
	if frame.MiddleTex then frame.MiddleTex:Kill() end

	if frame:GetName() then
		if _G[frame:GetName().."Left"] then _G[frame:GetName().."Left"]:Kill() end
		if _G[frame:GetName().."Middle"] then _G[frame:GetName().."Middle"]:Kill() end
		if _G[frame:GetName().."Right"] then _G[frame:GetName().."Right"]:Kill() end
		if _G[frame:GetName().."Mid"] then _G[frame:GetName().."Mid"]:Kill() end

		if frame:GetName():find("Silver") or frame:GetName():find("Copper") then
			frame.backdrop:Point("BOTTOMRIGHT", -12, -2)
		end
	end

	if(frame.Left) then
		frame.Left:Kill()
	end

	if(frame.Right) then
		frame.Right:Kill()
	end

	if(frame.Middle) then
		frame.Middle:Kill()
	end
end

function S:HandleDropDownBox(frame, width)
	local button = _G[frame:GetName().."Button"]
	if not button then return end

	if not width then width = 155 end

	frame:StripTextures()
	frame:Width(width)

	if(_G[frame:GetName().."Text"]) then
		_G[frame:GetName().."Text"]:ClearAllPoints()
		_G[frame:GetName().."Text"]:Point("RIGHT", button, "LEFT", -2, 0)
	end

	if(button) then
		button:ClearAllPoints()
		button:Point("RIGHT", frame, "RIGHT", -10, 3)
		hooksecurefunc(button, "SetPoint", function(self, _, _, _, _, _, noReset)
			if not noReset then
				self:ClearAllPoints()
				self:SetPoint("RIGHT", frame, "RIGHT", E:Scale(-10), E:Scale(3), true)
			end
		end)

		self:HandleNextPrevButton(button, true)
	end
	frame:CreateBackdrop("Default")
	frame.backdrop:Point("TOPLEFT", 20, -2)
	frame.backdrop:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
end

function S:HandleCheckBox(frame, noBackdrop, noReplaceTextures)
	assert(frame, 'does not exist.')
	frame:StripTextures()
	if noBackdrop then
		frame:SetTemplate("Default")
		frame:Size(16)
	else
		frame:CreateBackdrop('Default')
		frame.backdrop:SetInside(nil, 4, 4)
	end

	if not noReplaceTextures then
		if frame.SetCheckedTexture then
			frame:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
			if noBackdrop then
				frame:GetCheckedTexture():SetInside(nil, -4, -4)
			end
		end

		if frame.SetDisabledTexture then
			frame:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
			if noBackdrop then
				frame:GetDisabledTexture():SetInside(nil, -4, -4)
			end
		end

		frame:HookScript('OnDisable', function(self)
			if not self.SetDisabledTexture then return; end
			if self:GetChecked() then
				self:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
			else
				self:SetDisabledTexture("")
			end
		end)

		hooksecurefunc(frame, "SetNormalTexture", function(self, texPath)
			if texPath ~= "" then
				self:SetNormalTexture("");
			end
		end)

		hooksecurefunc(frame, "SetPushedTexture", function(self, texPath)
			if texPath ~= "" then
				self:SetPushedTexture("");
			end
		end)

		hooksecurefunc(frame, "SetHighlightTexture", function(self, texPath)
			if texPath ~= "" then
				self:SetHighlightTexture("");
			end
		end)
	end
end

function S:HandleIcon(icon, parent)
	parent = parent or icon:GetParent();

	icon:SetTexCoord(unpack(E.TexCoords))
	parent:CreateBackdrop('Default')
	icon:SetParent(parent.backdrop)
	parent.backdrop:SetOutside(icon)
end

function S:HandleItemButton(b, shrinkIcon)
	if b.isSkinned then return; end

	local icon = b.icon or b.Icon or b.IconTexture or b.iconTexture
	local texture
	if b:GetName() and _G[b:GetName()..'IconTexture'] then
		icon = _G[b:GetName()..'IconTexture']
	elseif b:GetName() and _G[b:GetName()..'Icon'] then
		icon = _G[b:GetName()..'Icon']
	end

	if(icon and icon:GetTexture()) then
		texture = icon:GetTexture()
	end

	b:StripTextures()
	b:CreateBackdrop('Default', true)
	b:StyleButton()

	if icon then
		icon:SetTexCoord(unpack(E.TexCoords))

		-- create a backdrop around the icon

		if shrinkIcon then
			b.backdrop:SetAllPoints()
			icon:SetInside(b)
		else
			b.backdrop:SetOutside(icon)
		end
		icon:SetParent(b.backdrop)

		if(texture) then
			icon:SetTexture(texture)
		end
	end
	b.isSkinned = true
end

function S:HandleCloseButton(f, point, text)
	f:StripTextures()

	if not f.backdrop then
		f:CreateBackdrop('Default', true)
		f.backdrop:Point('TOPLEFT', 7, -8)
		f.backdrop:Point('BOTTOMRIGHT', -8, 8)
		f:HookScript('OnEnter', S.SetModifiedBackdrop)
		f:HookScript('OnLeave', S.SetOriginalBackdrop)
		f:SetHitRectInsets(6, 6, 7, 7)
	end
	if not text then text = 'x' end
	if not f.text then
		f.text = f:CreateFontString(nil, 'OVERLAY')
		f.text:SetFont([[Interface\AddOns\ElvUI\media\fonts\PT_Sans_Narrow.ttf]], 16, 'OUTLINE')
		f.text:SetText(text)
		f.text:SetJustifyH('CENTER')
		f.text:Point('CENTER', f, 'CENTER')
	end

	if point then
		f:Point("TOPRIGHT", point, "TOPRIGHT", 2, 2)
	end
end

function S:HandleSliderFrame(frame)
	assert(frame)
	local orientation = frame:GetOrientation()
	local SIZE = 12
	frame:StripTextures()
	frame:CreateBackdrop('Default')
	frame.backdrop:SetAllPoints()
	hooksecurefunc(frame, "SetBackdrop", function(self, backdrop)
		if backdrop ~= nil then
			frame:SetBackdrop(nil)
		end
	end)
	frame:SetThumbTexture(E["media"].blankTex)
	frame:GetThumbTexture():SetVertexColor(0.3, 0.3, 0.3)
	frame:GetThumbTexture():Size(SIZE-2,SIZE-2)
	if orientation == 'VERTICAL' then
		frame:Width(SIZE)
	else
		frame:Height(SIZE)

		for i=1, frame:GetNumRegions() do
			local region = select(i, frame:GetRegions())
			if region and region:GetObjectType() == 'FontString' then
				local point, anchor, anchorPoint, x, y = region:GetPoint()
				if anchorPoint:find('BOTTOM') then
					region:Point(point, anchor, anchorPoint, x, y - 4)
				end
			end
		end
	end
end

function S:HandleFollowerPage(follower, hasItems, hasEquipment)
	local abilities = follower.followerTab.AbilitiesFrame.Abilities
	if follower.numAbilitiesStyled == nil then
		follower.numAbilitiesStyled = 1
	end
	local numAbilitiesStyled = follower.numAbilitiesStyled
	local ability = abilities[numAbilitiesStyled]
	while ability do
		local icon = ability.IconButton.Icon
		S:HandleIcon(icon, ability.IconButton)
		icon:SetDrawLayer("BORDER", 0)
		numAbilitiesStyled = numAbilitiesStyled + 1
		ability = abilities[numAbilitiesStyled]
	end
	follower.numAbilitiesStyled = numAbilitiesStyled

	if hasItems then
		local weapon = follower.followerTab.ItemWeapon
		local armor = follower.followerTab.ItemArmor
		if not weapon.backdrop then
			S:HandleIcon(weapon.Icon, weapon)
			weapon.Border:SetTexture(nil)
			weapon.backdrop:SetFrameLevel(weapon:GetFrameLevel())
		end
		if not armor.backdrop then
			S:HandleIcon(armor.Icon, armor)
			armor.Border:SetTexture(nil)
			armor.backdrop:SetFrameLevel(armor:GetFrameLevel())
		end
	end

	local xpbar = follower.followerTab.XPBar
	if not xpbar.backdrop then
		xpbar:StripTextures()
		xpbar:SetStatusBarTexture(E["media"].normTex)
		xpbar:CreateBackdrop("Transparent")
	end

	-- only OrderHall
	if hasEquipment then
		local btn
		local equipment = follower.followerTab.AbilitiesFrame.Equipment
		if equipment and not equipment.backdrop then
			for i = 1, #equipment do
				btn = equipment[i]
				btn.Border:SetTexture(nil)
				btn.BG:SetTexture(nil)
				btn.Icon:SetTexCoord(unpack(E.TexCoords))
				if not btn.backdop then
					btn:CreateBackdrop("Default")
					btn.backdrop:SetPoint("TOPLEFT", btn.Icon, "TOPLEFT", -2, 2)
					btn.backdrop:SetPoint("BOTTOMRIGHT", btn.Icon, "BOTTOMRIGHT", 2, -2)
				end
			end
		end
		btn = nil
	end
end

function S:HandleShipFollowerPage(followerTab)
	local traits = followerTab.Traits
	for i = 1, #traits do
		local icon = traits[i].Portrait
		local border = traits[i].Border
		border:SetTexture(nil) -- I think the default border looks nice, not sure if we want to replace that
		-- The landing page icons display inner borders
		if followerTab.isLandingPage then
			icon:SetTexCoord(unpack(E.TexCoords))
		end
	end

	local equipment = followerTab.EquipmentFrame.Equipment
	for i = 1, #equipment do
		local icon = equipment[i].Icon
		local border = equipment[i].Border
		border:SetAtlas("ShipMission_ShipFollower-TypeFrame") -- This border is ugly though, use the traits border instead
		-- The landing page icons display inner borders
		if followerTab.isLandingPage then
			icon:SetTexCoord(unpack(E.TexCoords))
		end
	end
end

function S:HandleIconSelectionFrame(frame, numIcons, buttonNameTemplate, frameNameOverride)
	assert(frame, "HandleIconSelectionFrame: frame argument missing")
	assert(numIcons and type(numIcons) == "number", "HandleIconSelectionFrame: numIcons argument missing or not a number")
	assert(buttonNameTemplate and type(buttonNameTemplate) == "string", "HandleIconSelectionFrame: buttonNameTemplate argument missing or not a string")

	local frameName = frameNameOverride or frame:GetName() --We need override in case Blizzard fucks up the naming (guild bank)
	local scrollFrame = _G[frameName.."ScrollFrame"]
	local editBox = _G[frameName.."EditBox"]
	local okayButton = _G[frameName.."OkayButton"] or _G[frameName.."Okay"]
	local cancelButton = _G[frameName.."CancelButton"] or _G[frameName.."Cancel"]

	frame:StripTextures()
	frame.BorderBox:StripTextures()
	scrollFrame:StripTextures()
	editBox:DisableDrawLayer("BACKGROUND") --Removes textures around it

	frame:SetTemplate("Transparent")
	frame:Height(frame:GetHeight() + 10)
	scrollFrame:Height(scrollFrame:GetHeight() + 10)

	S:HandleButton(okayButton)
	S:HandleButton(cancelButton)
	S:HandleEditBox(editBox)

	cancelButton:ClearAllPoints()
	cancelButton:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)

	for i = 1, numIcons do
		local button = _G[buttonNameTemplate..i]
		local icon = _G[button:GetName().."Icon"]
		button:StripTextures()
		button:SetTemplate("Default")
		button:StyleButton(true)
		icon:SetInside()
		icon:SetTexCoord(unpack(E.TexCoords))
	end
end

function S:ADDON_LOADED(_, addon)
	if self.allowBypass[addon] then
		if self.addonsToLoad[addon] then
			--Load addons using the old deprecated register method
			self.addonsToLoad[addon]()
			self.addonsToLoad[addon] = nil
		elseif self.addonCallbacks[addon] then
			--Fire events to the skins that rely on this addon
			for index, event in ipairs(self.addonCallbacks[addon]["CallPriority"]) do
				self.addonCallbacks[addon][event] = nil;
				self.addonCallbacks[addon]["CallPriority"][index] = nil
				E.callbacks:Fire(event)
			end
		end
		return
	end

	if not E.initialized then return end

	if self.addonsToLoad[addon] then
		self.addonsToLoad[addon]()
		self.addonsToLoad[addon] = nil
	elseif self.addonCallbacks[addon] then
		for index, event in ipairs(self.addonCallbacks[addon]["CallPriority"]) do
			self.addonCallbacks[addon][event] = nil;
			self.addonCallbacks[addon]["CallPriority"][index] = nil
			E.callbacks:Fire(event)
		end
	end
end

--Old deprecated register function. Keep it for the time being for any plugins that may need it.
function S:RegisterSkin(name, loadFunc, forceLoad, bypass)
	if bypass then
		self.allowBypass[name] = true;
	end

	if forceLoad then
		loadFunc()
		self.addonsToLoad[name] = nil;
	elseif name == 'ElvUI' then
		tinsert(self.nonAddonsToLoad, loadFunc)
	else
		self.addonsToLoad[name] = loadFunc;
	end
end

--Add callback for skin that relies on another addon.
--These events will be fired when the addon is loaded.
function S:AddCallbackForAddon(addonName, eventName, loadFunc, forceLoad, bypass)
	if not addonName or type(addonName) ~= "string" then
		E:Print("Invalid argument #1 to S:AddCallbackForAddon (string expected)")
		return
	elseif not eventName or type(eventName) ~= "string" then
		E:Print("Invalid argument #2 to S:AddCallbackForAddon (string expected)")
		return
	elseif not loadFunc or type(loadFunc) ~= "function" then
		E:Print("Invalid argument #3 to S:AddCallbackForAddon (function expected)")
		return
	end

	if bypass then
		self.allowBypass[addonName] = true;
	end

	--Create an event registry for this addon, so that we can fire multiple events when this addon is loaded
	if not self.addonCallbacks[addonName] then
		self.addonCallbacks[addonName] = {["CallPriority"] = {}}
	end

	if self.addonCallbacks[addonName][eventName] or E.ModuleCallbacks[eventName] or E.InitialModuleCallbacks[eventName] then
		--Don't allow a registered callback to be overwritten
		E:Print("Invalid argument #2 to S:AddCallbackForAddon (event name:", eventName, "is already registered, please use a unique event name)")
		return
	end

	--Register loadFunc to be called when event is fired
	E.RegisterCallback(E, eventName, loadFunc)

	if forceLoad then
		E.callbacks:Fire(eventName)
	else
		--Insert eventName in this addons' registry
		self.addonCallbacks[addonName][eventName] = true
		self.addonCallbacks[addonName]["CallPriority"][#self.addonCallbacks[addonName]["CallPriority"] + 1] = eventName
	end
end

--Add callback for skin that does not rely on a another addon.
--These events will be fired when the Skins module is initialized.
function S:AddCallback(eventName, loadFunc)
	if not eventName or type(eventName) ~= "string" then
		E:Print("Invalid argument #1 to S:AddCallback (string expected)")
		return
	elseif not loadFunc or type(loadFunc) ~= "function" then
		E:Print("Invalid argument #2 to S:AddCallback (function expected)")
		return
	end

	if self.nonAddonCallbacks[eventName] or E.ModuleCallbacks[eventName] or E.InitialModuleCallbacks[eventName] then
		--Don't allow a registered callback to be overwritten
		E:Print("Invalid argument #1 to S:AddCallback (event name:", eventName, "is already registered, please use a unique event name)")
		return
	end

	--Add event name to registry
	self.nonAddonCallbacks[eventName] = true
	self.nonAddonCallbacks["CallPriority"][#self.nonAddonCallbacks["CallPriority"] + 1] = eventName

	--Register loadFunc to be called when event is fired
	E.RegisterCallback(E, eventName, loadFunc)
end

function S:Initialize()
	self.db = E.private.skins

	--Fire events for Blizzard addons that are already loaded
	for addon in pairs(self.addonCallbacks) do
		if IsAddOnLoaded(addon) then
			for index, event in ipairs(S.addonCallbacks[addon]["CallPriority"]) do
				self.addonCallbacks[addon][event] = nil;
				self.addonCallbacks[addon]["CallPriority"][index] = nil
				E.callbacks:Fire(event)
			end
		end
	end
	--Fire event for all skins that doesn't rely on a Blizzard addon
	for index, event in ipairs(self.nonAddonCallbacks["CallPriority"]) do
		self.nonAddonCallbacks[event] = nil;
		self.nonAddonCallbacks["CallPriority"][index] = nil
		E.callbacks:Fire(event)
	end

	--Old deprecated load functions. We keep this for the time being in case plugins make use of it.
	for addon, loadFunc in pairs(self.addonsToLoad) do
		if IsAddOnLoaded(addon) then
			self.addonsToLoad[addon] = nil;
			local _, catch = pcall(loadFunc)
			if(catch and GetCVarBool('scriptErrors') == true) then
				ScriptErrorsFrame:OnError(catch, false, false)
			end
		end
	end

	for _, loadFunc in pairs(self.nonAddonsToLoad) do
		local _, catch = pcall(loadFunc)
		if(catch and GetCVarBool('scriptErrors') == true) then
			ScriptErrorsFrame:OnError(catch, false, false)
		end
	end
	wipe(self.nonAddonsToLoad)
end

S:RegisterEvent('ADDON_LOADED')

local function InitializeCallback()
	S:Initialize()
end

E:RegisterModule(S:GetName(), InitializeCallback)