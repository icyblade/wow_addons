local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Blizzard")
local S = E:GetModule("Skins")

local format, strlen, strjoin, gsub = format, strlen, strjoin, gsub
local tonumber, floor, strsub, wipe = tonumber, floor, strsub, wipe

local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local CALENDAR_COPY_EVENT, CALENDAR_PASTE_EVENT = CALENDAR_COPY_EVENT, CALENDAR_PASTE_EVENT
local CLASS, DEFAULT = CLASS, DEFAULT

local colorBuffer = {}
local function alphaValue(num)
	return num and floor(((1 - num) * 100) + .05) or 0
end

local function UpdateAlphaText(alpha)
	if not alpha then alpha = alphaValue(OpacitySliderFrame:GetValue()) end

	ColorPPBoxA:SetText(alpha)
end

local function UpdateAlpha(tbox)
	local num = tbox:GetNumber()
	if num > 100 then
		tbox:SetText(100)
		num = 100
	end

	OpacitySliderFrame:SetValue(1 - (num / 100))
end

local function expandFromThree(r, g, b)
	return strjoin("", r, r, g, g, b, b)
end

local function extendToSix(str)
	for _ = 1, 6 - strlen(str) do str = str..0 end
	return str
end

local function GetHexColor(box)
	local rgb, rgbSize = box:GetText(), box:GetNumLetters()
	if rgbSize == 3 then
		rgb = gsub(rgb, "(%x)(%x)(%x)$", expandFromThree)
	elseif rgbSize < 6 then
		rgb = gsub(rgb, "(.+)$", extendToSix)
	end

	local r, g, b = tonumber(strsub(rgb, 0, 2), 16) or 0, tonumber(strsub(rgb, 3, 4), 16) or 0, tonumber(strsub(rgb, 5, 6), 16) or 0

	return r/255, g/255, b/255
end

local function UpdateColorTexts(r, g, b, box)
	if not (r and g and b) then
		r, g, b = ColorPickerFrame:GetColorRGB()

		if box then
			if box == ColorPPBoxH then
				r, g, b = GetHexColor(box)
			else
				local num = box:GetNumber()
				if num > 255 then num = 255 end
				local c = num/255
				if box == ColorPPBoxR then
					r = c
				elseif box == ColorPPBoxG then
					g = c
				elseif box == ColorPPBoxB then
					b = c
				end
			end
		end
	end

	-- we want those /255 values
	r, g, b = r*255, g*255, b*255

	ColorPPBoxH:SetText(format("%.2x%.2x%.2x", r, g, b))
	ColorPPBoxR:SetText(r)
	ColorPPBoxG:SetText(g)
	ColorPPBoxB:SetText(b)
end

local function UpdateColor(box)
	if box:GetID() == 4 and box:GetNumLetters() ~= 6 then return else UpdateColorTexts(nil, nil, nil, box) end

	local r, g, b = GetHexColor(ColorPPBoxH)
	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorSwatch:SetTexture(r, g, b)
end

local function ColorPPBoxA_SetFocus()
	ColorPPBoxA:SetFocus()
end

local function ColorPPBoxR_SetFocus()
	ColorPPBoxR:SetFocus()
end

local delayWait, delayFunc = 0.15
local function delayCall()
	if delayFunc then
		delayFunc()
		delayFunc = nil
	end
end
local function onColorSelect(frame, r, g, b)
	if frame.noColorCallback then return end

	ColorSwatch:SetTexture(r, g, b)
	UpdateColorTexts(r, g, b)

	if not frame:IsVisible() then
		delayCall()
	elseif not delayFunc then
		delayFunc = ColorPickerFrame.func
		E:Delay(delayWait, delayCall)
	end
end

local function onValueChanged(frame, value)
	local alpha = alphaValue(value)
	if frame.lastAlpha ~= alpha then
		frame.lastAlpha = alpha

		UpdateAlphaText(alpha)

		if not ColorPickerFrame:IsVisible() then
			delayCall()
		else
			local opacityFunc = ColorPickerFrame.opacityFunc
			if delayFunc and (delayFunc ~= opacityFunc) then
				delayFunc = opacityFunc
			elseif not delayFunc then
				delayFunc = opacityFunc
				E:Delay(delayWait, delayCall)
			end
		end
	end
end

function B:EnhanceColorPicker()
	if IsAddOnLoaded("ColorPickerPlus") then return end

	--Skin the default frame, move default buttons into place
	ColorPickerFrame:SetTemplate("Transparent")
	ColorPickerFrame:SetClampedToScreen(true)

	ColorPickerFrameHeader:SetTexture()
	ColorPickerFrameHeader:ClearAllPoints()
	ColorPickerFrameHeader:Point("TOP", ColorPickerFrame, 0, 0)

	S:HandleButton(ColorPickerCancelButton)
	ColorPickerCancelButton:ClearAllPoints()
	ColorPickerCancelButton:Point("BOTTOMRIGHT", ColorPickerFrame, "BOTTOMRIGHT", -6, 6)
	ColorPickerCancelButton:Point("BOTTOMLEFT", ColorPickerFrame, "BOTTOM", 0, 6)

	S:HandleButton(ColorPickerOkayButton)
	ColorPickerOkayButton:ClearAllPoints()
	ColorPickerOkayButton:Point("BOTTOMLEFT", ColorPickerFrame, "BOTTOMLEFT", 6, 6)
	ColorPickerOkayButton:Point("RIGHT", ColorPickerCancelButton, "LEFT", -4, 0)

	S:HandleSliderFrame(OpacitySliderFrame)

	ColorPickerFrame:HookScript("OnShow", function(frame)
		-- get color that will be replaced
		local r, g, b = frame:GetColorRGB()
		ColorPPOldColorSwatch:SetTexture(r, g, b)

		-- show/hide the alpha box
		if frame.hasOpacity then
			ColorPPBoxA:Show()
			ColorPPBoxLabelA:Show()
			ColorPPBoxH:SetScript("OnTabPressed", ColorPPBoxA_SetFocus)
			UpdateAlphaText()
			UpdateColorTexts()
			frame:Width(405)
		else
			ColorPPBoxA:Hide()
			ColorPPBoxLabelA:Hide()
			ColorPPBoxH:SetScript("OnTabPressed", ColorPPBoxR_SetFocus)
			UpdateColorTexts()
			frame:Width(345)
		end

		-- Memory Fix, Colorpicker will call the self.func() 100x per second, causing fps/memory issues,
		-- We overwrite these two scripts and set a limit on how often we allow a call their update functions
		OpacitySliderFrame:SetScript("OnValueChanged", onValueChanged)
		frame:SetScript("OnColorSelect", onColorSelect)
	end)

	-- make the Color Picker dialog a bit taller, to make room for edit boxes
	ColorPickerFrame:Height(ColorPickerFrame:GetHeight() + 40)

	-- move the Color Swatch
	ColorSwatch:ClearAllPoints()
	ColorSwatch:Point("TOPLEFT", ColorPickerFrame, "TOPLEFT", 215, -45)

	-- add Color Swatch for original color
	local t = ColorPickerFrame:CreateTexture("ColorPPOldColorSwatch")
	local w, h = ColorSwatch:GetSize()
	t:Size(w * 0.75, h * 0.75)
	t:SetTexture(0, 0, 0)
	-- OldColorSwatch to appear beneath ColorSwatch
	t:SetDrawLayer("BORDER")
	t:Point("BOTTOMLEFT", ColorSwatch, "TOPRIGHT", -(w / 2), -(h / 3))

	-- add Color Swatch for the copied color
	t = ColorPickerFrame:CreateTexture("ColorPPCopyColorSwatch")
	t:SetTexture(0, 0, 0)
	t:Size(w, h)
	t:Hide()

	-- add copy button to the ColorPickerFrame
	local b = CreateFrame("Button", "ColorPPCopy", ColorPickerFrame, "UIPanelButtonTemplate")
	S:HandleButton(b)
	b:SetText(CALENDAR_COPY_EVENT)
	b:Width(60)
	b:Height(22)
	b:Point("TOPLEFT", ColorSwatch, "BOTTOMLEFT", 0, -5)

	-- copy color into buffer on button click
	b:SetScript("OnClick", function()
		-- copy current dialog colors into buffer
		colorBuffer.r, colorBuffer.g, colorBuffer.b = ColorPickerFrame:GetColorRGB()

		-- enable Paste button and display copied color into swatch
		ColorPPPaste:Enable()
		ColorPPCopyColorSwatch:SetTexture(colorBuffer.r, colorBuffer.g, colorBuffer.b)
		ColorPPCopyColorSwatch:Show()

		colorBuffer.a = (ColorPickerFrame.hasOpacity and OpacitySliderFrame:GetValue()) or nil
	end)

	--class color button
	b = CreateFrame("Button", "ColorPPClass", ColorPickerFrame, "UIPanelButtonTemplate")
	b:SetText(CLASS)
	S:HandleButton(b)
	b:Width(80)
	b:Height(22)
	b:Point("TOP", ColorPPCopy, "BOTTOMRIGHT", 0, -7)

	b:SetScript("OnClick", function()
		local color = E:ClassColor(E.myclass, true)
		ColorPickerFrame:SetColorRGB(color.r, color.g, color.b)
		ColorSwatch:SetTexture(color.r, color.g, color.b)
		if ColorPickerFrame.hasOpacity then
			OpacitySliderFrame:SetValue(0)
		end
	end)

	-- add paste button to the ColorPickerFrame
	b = CreateFrame("Button", "ColorPPPaste", ColorPickerFrame, "UIPanelButtonTemplate")
	b:SetText(CALENDAR_PASTE_EVENT)
	S:HandleButton(b)
	b:Width(60)
	b:Height(22)
	b:Point("TOPLEFT", ColorPPCopy, "TOPRIGHT", 2, 0)
	b:Disable() -- enable when something has been copied

	-- paste color on button click, updating frame components
	b:SetScript("OnClick", function()
		ColorPickerFrame:SetColorRGB(colorBuffer.r, colorBuffer.g, colorBuffer.b)
		ColorSwatch:SetTexture(colorBuffer.r, colorBuffer.g, colorBuffer.b)
		if ColorPickerFrame.hasOpacity then
			if colorBuffer.a then --color copied had an alpha value
				OpacitySliderFrame:SetValue(colorBuffer.a)
			end
		end
	end)

	-- add defaults button to the ColorPickerFrame
	b = CreateFrame("Button", "ColorPPDefault", ColorPickerFrame, "UIPanelButtonTemplate")
	b:SetText(DEFAULT)
	S:HandleButton(b)
	b:Width(80)
	b:Height(22)
	b:Point("TOPLEFT", ColorPPClass, "BOTTOMLEFT", 0, -7)
	b:Disable() -- enable when something has been copied
	b:SetScript("OnHide", function(btn)
		if btn.colors then
			wipe(btn.colors)
		end
	end)
	b:SetScript("OnShow", function(btn)
		if btn.colors then
			btn:Enable()
		else
			btn:Disable()
		end
	end)

	-- paste color on button click, updating frame components
	b:SetScript("OnClick", function(btn)
		local colors = btn.colors
		ColorPickerFrame:SetColorRGB(colors.r, colors.g, colors.b)
		ColorSwatch:SetTexture(colors.r, colors.g, colors.b)
		if ColorPickerFrame.hasOpacity then
			if colors.a then
				OpacitySliderFrame:SetValue(colors.a)
			end
		end
	end)

	-- position Color Swatch for copy color
	ColorPPCopyColorSwatch:Point("BOTTOM", ColorPPPaste, "TOP", 0, 10)

	-- move the Opacity Slider Frame to align with bottom of Copy ColorSwatch
	OpacitySliderFrame:ClearAllPoints()
	OpacitySliderFrame:Point("BOTTOM", ColorPPDefault, "BOTTOM", 0, 0)
	OpacitySliderFrame:Point("RIGHT", ColorPickerFrame, "RIGHT", -35, 18)

	-- set up edit box frames and interior label and text areas
	local boxes = {"R", "G", "B", "H", "A"}
	for i = 1, #boxes do
		local rgb = boxes[i]
		local box = CreateFrame("EditBox", "ColorPPBox"..rgb, ColorPickerFrame, "InputBoxTemplate")
		box:Point("TOP", ColorPickerWheel, "BOTTOM", 0, -15)
		box:SetFrameStrata("DIALOG")
		box:SetAutoFocus(false)
		box:SetTextInsets(0, 7, 0, 0)
		box:SetJustifyH("RIGHT")
		box:Height(24)
		box:SetID(i)
		S:HandleEditBox(box)

		-- hex entry box
		if i == 4 then
			box:SetMaxLetters(6)
			box:Width(56)
			box:SetNumeric(false)
		else
			box:SetMaxLetters(3)
			box:Width(40)
			box:SetNumeric(true)
		end

		-- label
		local label = box:CreateFontString("ColorPPBoxLabel"..rgb, "ARTWORK", "GameFontNormalSmall")
		label:Point("RIGHT", box, "LEFT", -5, 0)
		label:SetText(i == 4 and "#" or rgb)
		label:SetTextColor(1, 1, 1)

		-- set up scripts to handle event appropriately
		if i == 5 then
			box:SetScript("OnEscapePressed", function(self)	self:ClearFocus() UpdateAlphaText() end)
			box:SetScript("OnEnterPressed", function(self) self:ClearFocus() UpdateAlphaText() end)
			box:SetScript("OnTextChanged", UpdateAlpha)
		else
			box:SetScript("OnEscapePressed", function(self)	self:ClearFocus() UpdateColorTexts() end)
			box:SetScript("OnEnterPressed", function(self) self:ClearFocus() UpdateColorTexts() end)
			box:SetScript("OnTextChanged", UpdateColor)
		end

		box:SetScript("OnEditFocusGained", function(eb) eb:SetCursorPosition(0) eb:HighlightText() end)
		box:SetScript("OnEditFocusLost", function(eb) eb:HighlightText(0,0) end)
		box:SetScript("OnTextSet", box.ClearFocus)
		box:Show()
	end

	-- finish up with placement
	ColorPPBoxA:Point("RIGHT", OpacitySliderFrame, "RIGHT", 10, 0)
	ColorPPBoxH:Point("RIGHT", ColorPPDefault, "RIGHT", -10, 0)
	ColorPPBoxB:Point("RIGHT", ColorPPDefault, "LEFT", -40, 0)
	ColorPPBoxG:Point("RIGHT", ColorPPBoxB, "LEFT", -25, 0)
	ColorPPBoxR:Point("RIGHT", ColorPPBoxG, "LEFT", -25, 0)

	-- define the order of tab cursor movement
	ColorPPBoxR:SetScript("OnTabPressed", function() ColorPPBoxG:SetFocus() end)
	ColorPPBoxG:SetScript("OnTabPressed", function() ColorPPBoxB:SetFocus() end)
	ColorPPBoxB:SetScript("OnTabPressed", function() ColorPPBoxH:SetFocus() end)
	ColorPPBoxA:SetScript("OnTabPressed", function() ColorPPBoxR:SetFocus() end)

	-- make the color picker movable.
	local mover = CreateFrame("Frame", nil, ColorPickerFrame)
	mover:Point("TOPLEFT", ColorPickerFrame, "TOP", -60, 0)
	mover:Point("BOTTOMRIGHT", ColorPickerFrame, "TOP", 60, -15)
	mover:SetScript("OnMouseDown", function() ColorPickerFrame:StartMoving() end)
	mover:SetScript("OnMouseUp", function() ColorPickerFrame:StopMovingOrSizing() end)
	mover:EnableMouse(true)
	ColorPickerFrame:SetUserPlaced(true)
	ColorPickerFrame:EnableKeyboard(false)
end