-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
local _G = getfenv(0)

-- Functions
local error = _G.error
local pairs = _G.pairs

-- Libraries
local table = _G.table

-----------------------------------------------------------------------
-- Library namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local MAJOR = "LibToast-1.0"

_G.assert(LibStub, MAJOR .. " requires LibStub")

local MINOR = 1 -- Should be manually increased
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then
    return
end -- No upgrade needed

-----------------------------------------------------------------------
-- Migrations.
-----------------------------------------------------------------------
lib.templates = lib.templates or {}
lib.unique_templates = lib.unique_templates or {}
lib.active_toasts = lib.active_toasts or {}

lib.toast_heap = lib.toast_heap or {}
lib.button_heap = lib.button_heap or {}

-----------------------------------------------------------------------
-- Variables.
-----------------------------------------------------------------------
local current_toast

-----------------------------------------------------------------------
-- Constants.
-----------------------------------------------------------------------
local active_toasts = lib.active_toasts
local toast_heap = lib.toast_heap
local button_heap = lib.button_heap

local toast_proxy = {}

local METHOD_USAGE_FORMAT = MAJOR .. ":%s() - %s."

local DEFAULT_FADE_HOLD_TIME = 5
local DEFAULT_FADE_IN_TIME = 0.5
local DEFAULT_FADE_OUT_TIME = 1
local DEFAULT_TOAST_WIDTH = 250
local DEFAULT_TOAST_HEIGHT = 50
local DEFAULT_ICON_SIZE = 30

local DEFAULT_TOAST_BACKDROP = {
    bgFile = [[Interface\CHATFRAME\CHATFRAMEBACKGROUND]],
    edgeFile = [[Interface\FriendsFrame\UI-Toast-Border]],
    tile = true,
    tileSize = 12,
    edgeSize = 12,
    insets = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5,
    },
}

local DEFAULT_BACKGROUND_COLORS = {
    r = 0,
    g = 0,
    b = 0,
}

local DEFAULT_TITLE_COLORS = {
    r = 0.510,
    g = 0.773,
    b = 1,
}

local DEFAULT_TEXT_COLORS = {
    r = 0.486,
    g = 0.518,
    b = 0.541
}
local TOAST_BUTTONS = {
    primary_button = true,
    secondary_button = true,
    tertiary_button = true,
}
local TOAST_BUTTON_HEIGHT = 18

local SIBLING_ANCHORS = {
    TOPRIGHT = "BOTTOMRIGHT",
    TOPLEFT = "BOTTOMLEFT",
    BOTTOMRIGHT = "TOPRIGHT",
    BOTTOMLEFT = "TOPLEFT",
}

local OFFSET_X = {
    TOPRIGHT = -20,
    TOPLEFT = 20,
    BOTTOMRIGHT = -20,
    BOTTOMLEFT = 20,
}

local OFFSET_Y = {
    TOPRIGHT = -30,
    TOPLEFT = -30,
    BOTTOMRIGHT = 30,
    BOTTOMLEFT = 30,
}

local SIBLING_OFFSET_Y = {
    TOPRIGHT = -10,
    TOPLEFT = -10,
    BOTTOMRIGHT = 10,
    BOTTOMLEFT = 10,
}

-----------------------------------------------------------------------
-- Settings functions.
-----------------------------------------------------------------------
local function ToastSpawnPoint()
    return _G.Toaster and _G.Toaster:SpawnPoint() or "BOTTOMRIGHT"
end

local function ToastTitleColors(urgency)
    if _G.Toaster then
        return _G.Toaster:TitleColors(urgency)
    else
        return DEFAULT_TITLE_COLORS.r, DEFAULT_TITLE_COLORS.g, DEFAULT_TITLE_COLORS.b
    end
end

local function ToastTextColors(urgency)
    if _G.Toaster then
        return _G.Toaster:TextColors(urgency)
    else
        return DEFAULT_TEXT_COLORS.r, DEFAULT_TEXT_COLORS.g, DEFAULT_TEXT_COLORS.b
    end
end

local function ToastBackgroundColors(urgency)
    if _G.Toaster then
        return _G.Toaster:BackgroundColors(urgency)
    else
        return DEFAULT_BACKGROUND_COLORS.r, DEFAULT_BACKGROUND_COLORS.g, DEFAULT_BACKGROUND_COLORS.b
    end
end

local function ToastDuration()
    return _G.Toaster and _G.Toaster:Duration() or DEFAULT_FADE_HOLD_TIME
end

local function ToastOpacity()
    return _G.Toaster and _G.Toaster:Opacity() or 0.75
end

local function ToastHasFloatingIcon()
    return _G.Toaster and _G.Toaster:FloatingIcon()
end

local function ToastsAreSuppressed()
    return _G.Toaster and _G.Toaster:HideToasts()
end

-----------------------------------------------------------------------
-- Helper functions.
-----------------------------------------------------------------------
local function _reclaimButton(button)
    button:Hide()
    button:ClearAllPoints()
    button:SetParent(nil)
    button:SetText(nil)
    table.insert(button_heap, button)
end

local function _reclaimToast(toast)
    for button_name in pairs(TOAST_BUTTONS) do
        local button = toast[button_name]

        if button then
            toast[button_name] = nil
            _reclaimButton(button)
        end
    end
    toast.is_persistent = nil
    toast.template_name = nil
    toast.payload = nil
    toast:Hide()

    _G.UIFrameFadeRemoveFrame(toast)
    table.insert(toast_heap, toast)

    local remove_index
    for index = 1, #active_toasts do
        if active_toasts[index] == toast then
            remove_index = index
            break
        end
    end

    if remove_index then
        table.remove(active_toasts, remove_index):ClearAllPoints()
    end
    local spawn_point = ToastSpawnPoint()
    local lower_point = spawn_point:lower()
    local floating_icon = ToastHasFloatingIcon()

    for index = 1, #active_toasts do
        local indexed_toast = active_toasts[index]
        indexed_toast:ClearAllPoints()
        indexed_toast.icon:ClearAllPoints()

        if floating_icon then
            if lower_point:find("right") then
                indexed_toast.icon:SetPoint("TOPRIGHT", indexed_toast, "TOPLEFT", -5, -10)
            elseif lower_point:find("left") then
                indexed_toast.icon:SetPoint("TOPLEFT", indexed_toast, "TOPRIGHT", 5, -10)
            end
        else
            indexed_toast.icon:SetPoint("TOPLEFT", indexed_toast, "TOPLEFT", 5, -10)
        end

        if index == 1 then
            indexed_toast:SetPoint(spawn_point, _G.UIParent, spawn_point, OFFSET_X[spawn_point], OFFSET_Y[spawn_point])
        else
            indexed_toast:SetPoint(spawn_point, active_toasts[index - 1], SIBLING_ANCHORS[spawn_point], 0, SIBLING_OFFSET_Y[spawn_point])
        end
    end
end

local function _finishToastDisplay(toast)
    local fade_info = toast.fade_out_info
    fade_info.fadeTimer = 0
    fade_info.finishedFunc = _reclaimToast
    fade_info.finishedArg1 = toast

    _G.UIFrameFade(toast, fade_info)
end

local function _showDismissButton(frame, motion)
    frame.dismiss_button:Show()
end

local function _hideDismissButton(frame, motion)
    if not frame.dismiss_button:IsMouseOver() then
        frame.dismiss_button:Hide()
    end
end

local function _dismissToast(frame, button, down)
    _reclaimToast(frame:GetParent())
end

local function _acquireToast()
    local toast = table.remove(toast_heap)

    if not toast then
        toast = _G.CreateFrame("Button", nil, _G.UIParent)
        toast:SetFrameStrata("DIALOG")
        toast:Hide()

        local toast_icon = toast:CreateTexture(nil, "BORDER")
        toast_icon:SetWidth(DEFAULT_ICON_SIZE)
        toast_icon:SetHeight(DEFAULT_ICON_SIZE)
        toast.icon = toast_icon

        local title = toast:CreateFontString(nil, "BORDER", "FriendsFont_Normal")
        title:SetJustifyH("LEFT")
        title:SetJustifyV("MIDDLE")
        title:SetWordWrap(true)
        title:SetPoint("TOPLEFT", toast, "TOPLEFT", 44, -10)
        title:SetPoint("RIGHT", toast, "RIGHT", -20, 10)
        toast.title = title

        local focus = _G.CreateFrame("Frame", nil, toast)
        focus:SetAllPoints(toast)
        focus:SetScript("OnEnter", _showDismissButton)
        focus:SetScript("OnLeave", _hideDismissButton)
        focus:SetScript("OnShow", _hideDismissButton)

        local dismiss_button = _G.CreateFrame("Button", nil, toast)
        dismiss_button:SetWidth(18)
        dismiss_button:SetHeight(18)
        dismiss_button:SetPoint("TOPRIGHT", toast, "TOPRIGHT", -4, -4)
        dismiss_button:SetFrameStrata("DIALOG")
        dismiss_button:SetFrameLevel(toast:GetFrameLevel() + 2)
        dismiss_button:SetNormalTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Up]])
        dismiss_button:SetPushedTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Down]])
        dismiss_button:SetHighlightTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Highlight]])
        dismiss_button:Hide()
        dismiss_button:SetScript("OnClick", _dismissToast)

        focus.dismiss_button = dismiss_button

        local text = toast:CreateFontString(nil, "BORDER", "FriendsFont_Normal")
        text:SetJustifyH("LEFT")
        text:SetJustifyV("MIDDLE")
        text:SetWordWrap(true)
        text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
        toast.text = text

        toast.fade_in_info = {
            timeToFade = DEFAULT_FADE_IN_TIME,
            startAlpha = 0,
            endAlpha = 1,
        }

        toast.fade_out_info = {
            timeToFade = DEFAULT_FADE_OUT_TIME,
            finishedFunc = _reclaimToast,
            finishedArg1 = toast,
            startAlpha = 1,
            endAlpha = 0,
        }
    end
    toast:SetWidth(DEFAULT_TOAST_WIDTH)
    toast:SetHeight(DEFAULT_TOAST_HEIGHT)
    toast:SetBackdrop(DEFAULT_TOAST_BACKDROP)
    return toast
end

-----------------------------------------------------------------------
-- Library methods.
-----------------------------------------------------------------------
function lib:Register(template_name, constructor, is_unique)
    if _G.type(template_name) ~= "string" or template_name == "" then
        error(METHOD_USAGE_FORMAT:format("Register", "template_name must be a non-empty string"), 2)
    end

    if _G.type(constructor) ~= "function" then
        error(METHOD_USAGE_FORMAT:format("Register", "constructor must be a function"), 2)
    end
    self.templates[template_name] = constructor
    self.unique_templates[template_name] = is_unique or nil
end

function lib:Spawn(template_name, ...)
    if not template_name or _G.type(template_name) ~= "string" or template_name == "" then
        error(METHOD_USAGE_FORMAT:format("Spawn", "template_name must be a non-empty string"), 2)
    end

    if not self.templates[template_name] then
        error(METHOD_USAGE_FORMAT:format("Spawn", ("\"%s\" does not match a registered template"):format(template_name)), 2)
    end

    if ToastsAreSuppressed() then
        return
    end

    if self.unique_templates[template_name] then
        for index = 1, #active_toasts do
            if active_toasts[index].template_name == template_name then
                return
            end
        end
    end
    current_toast = _acquireToast()
    current_toast.template_name = template_name

    -----------------------------------------------------------------------
    -- Reset defaults.
    -----------------------------------------------------------------------
    current_toast.title:SetText(nil)
    current_toast.text:SetText(nil)
    current_toast.icon:SetTexture(nil)

    -----------------------------------------------------------------------
    -- Run constructor.
    -----------------------------------------------------------------------
    self.templates[template_name](toast_proxy, ...)

    if not current_toast.title:GetText() and not current_toast.text:GetText() and not current_toast.icon:GetTexture() then
        _reclaimToast(current_toast)
        return
    end

    -----------------------------------------------------------------------
    -- Finalize layout.
    -----------------------------------------------------------------------
    local urgency = current_toast.urgency_level
    current_toast.title:SetTextColor(ToastTitleColors(urgency))
    current_toast.text:SetTextColor(ToastTextColors(urgency))

    local opacity = ToastOpacity()
    local r, g, b = ToastBackgroundColors(urgency)
    current_toast:SetBackdropColor(r, g, b, opacity)

    r, g, b = current_toast:GetBackdropBorderColor()
    current_toast:SetBackdropBorderColor(r, g, b, opacity)

    local fade_in_info = current_toast.fade_in_info
    fade_in_info.fadeTimer = 0
    fade_in_info.fadeHoldTime = current_toast.is_persistent and 0 or ToastDuration()

    if fade_in_info.fadeHoldTime > 0 then
        fade_in_info.finishedFunc = _finishToastDisplay
        fade_in_info.finishedArg1 = current_toast
    else
        fade_in_info.finishedFunc = nil
        fade_in_info.finishedArg1 = nil
    end
    local spawn_point = ToastSpawnPoint()
    local lower_point = spawn_point:lower()
    local floating_icon = ToastHasFloatingIcon()

    current_toast.icon:ClearAllPoints()

    if floating_icon then
        if lower_point:find("right") then
            current_toast.icon:SetPoint("TOPRIGHT", current_toast, "TOPLEFT", -5, -10)
        elseif lower_point:find("left") then
            current_toast.icon:SetPoint("TOPLEFT", current_toast, "TOPRIGHT", 5, -10)
        end
    else
        current_toast.icon:SetPoint("TOPLEFT", current_toast, "TOPLEFT", 5, -10)
    end

    if floating_icon or not current_toast.icon:GetTexture() then
        current_toast.title:SetPoint("TOPLEFT", current_toast, "TOPLEFT", 10, -10)
    else
        current_toast.title:SetPoint("TOPLEFT", current_toast, "TOPLEFT", current_toast.icon:GetWidth() + 15, -10)
    end

    if current_toast.title:GetText() then
        current_toast.title:SetWidth(current_toast:GetWidth() - current_toast.icon:GetWidth() - 20)
        current_toast.title:Show()
    else
        current_toast.title:Hide()
    end

    if current_toast.text:GetText() then
        current_toast.text:SetWidth(current_toast:GetWidth() - current_toast.icon:GetWidth() - 20)

        current_toast.text:Show()
    else
        current_toast.text:Hide()
    end
    local button_height = (current_toast.primary_button or current_toast.secondary_button or current_toast.tertiary_button) and TOAST_BUTTON_HEIGHT or 0
    current_toast:SetHeight(current_toast.text:GetStringHeight() + current_toast.title:GetStringHeight() + button_height + 25)

    -----------------------------------------------------------------------
    -- Anchor and spawn.
    -----------------------------------------------------------------------
    if #active_toasts > 0 then
        current_toast:SetPoint(spawn_point, active_toasts[#active_toasts], SIBLING_ANCHORS[spawn_point], 0, SIBLING_OFFSET_Y[spawn_point])
    else
        current_toast:SetPoint(spawn_point, _G.UIParent, spawn_point, OFFSET_X[spawn_point], OFFSET_Y[spawn_point])
    end
    active_toasts[#active_toasts + 1] = current_toast
    _G.UIFrameFade(current_toast, fade_in_info)
end

-----------------------------------------------------------------------
-- Proxy methods.
-----------------------------------------------------------------------
local TOAST_URGENCIES = {
    very_low = true,
    moderate = true,
    normal = true,
    high = true,
    emergency = true,
}

function toast_proxy:SetUrgencyLevel(urgency)
    urgency = urgency:gsub(" ", "_"):lower()

    if not TOAST_URGENCIES[urgency] then
        error(("\"%s\" is not a valid toast urgency level"):format(urgency), 2)
    end
    current_toast.urgency_level = urgency
end

function toast_proxy:UrgencyLevel()
    return current_toast.urgency_level
end

function toast_proxy:SetTitle(title)
    current_toast.title:SetText(title)
end

function toast_proxy:SetFormattedTitle(title, ...)
    current_toast.title:SetFormattedText(title, ...)
end

function toast_proxy:SetText(text)
    current_toast.text:SetText(text)
end

function toast_proxy:SetFormattedText(text, ...)
    current_toast.text:SetFormattedText(text, ...)
end

function toast_proxy:SetIconTexture(texture)
    current_toast.icon:SetTexture(texture)
end

local _initializedToastButton
do
    local BUTTON_NAME_FORMAT = "LibToast_Button%d"
    local button_count = 0

    local function _buttonCallbackHandler(button, mouse_button, is_down)
        button.handler(button.id, mouse_button, is_down, button.toast.payload)
        _reclaimToast(button.toast)
    end

    local function _acquireToastButton(toast)
        local button = table.remove(button_heap)

        if not button then
            button_count = button_count + 1

            button = _G.CreateFrame("Button", BUTTON_NAME_FORMAT:format(button_count), toast, "UIMenuButtonStretchTemplate")
            button:SetHeight(TOAST_BUTTON_HEIGHT)
            button:SetFrameStrata("DIALOG")
            button:SetScript("OnClick", _buttonCallbackHandler)

            local font_string = button:GetFontString()
            font_string:SetJustifyH("CENTER")
            font_string:SetJustifyV("CENTER")
        end
        button:SetParent(toast)
        button:SetFrameLevel(toast:GetFrameLevel() + 2)
        return button
    end

    function _initializedToastButton(button_id, label, handler)
        if not label or not handler then
            error("label and handler are required", 3)
            return
        end
        local button = current_toast[button_id]

        if not button then
            button = _acquireToastButton(current_toast)
            current_toast[button_id] = button
        end
        button.id = button_id:gsub("_button", "")
        button.handler = handler
        button.toast = current_toast

        button:Show()
        button:SetText(label)
        button:SetWidth(button:GetFontString():GetStringWidth() + 15)

        return button
    end
end -- do-block

function toast_proxy:SetPrimaryCallback(label, handler)
    local button = _initializedToastButton("primary_button", label, handler)
    button:SetPoint("BOTTOMLEFT", current_toast, "BOTTOMLEFT", 3, 4)
    button:SetPoint("BOTTOMRIGHT", current_toast, "BOTTOMRIGHT", -3, 4)

    current_toast:SetHeight(current_toast:GetHeight() + button:GetHeight() + 5)

    if button:GetWidth() > current_toast:GetWidth() then
        current_toast:SetWidth(button:GetWidth() + 5)
    end
end

function toast_proxy:SetSecondaryCallback(label, handler)
    if not current_toast.primary_button then
        error("primary button must be defined first", 2)
    end
    current_toast.primary_button:ClearAllPoints()
    current_toast.primary_button:SetPoint("BOTTOMLEFT", current_toast, "BOTTOMLEFT", 3, 4)

    local button = _initializedToastButton("secondary_button", label, handler)
    button:SetPoint("BOTTOMRIGHT", current_toast, "BOTTOMRIGHT", -3, 4)

    if button:GetWidth() + current_toast.primary_button:GetWidth() > current_toast:GetWidth() then
        current_toast:SetWidth(button:GetWidth() + current_toast.primary_button:GetWidth() + 5)
    end
end

function toast_proxy:SetTertiaryCallback(label, handler)
    if not current_toast.primary_button or not current_toast.secondary_button then
        error("primary and secondary buttons must be defined first", 2)
    end
    current_toast.secondary_button:ClearAllPoints()
    current_toast.secondary_button:SetPoint("LEFT", current_toast.primary_button, "RIGHT", 0, 0)

    local button = _initializedToastButton("tertiary_button", label, handler)
    button:SetPoint("LEFT", current_toast.secondary_button, "RIGHT", 0, 0)

    if button:GetWidth() + current_toast.primary_button:GetWidth() + current_toast.secondary_button:GetWidth() > current_toast:GetWidth() then
        current_toast:SetWidth(button:GetWidth() + current_toast.primary_button:GetWidth() + current_toast.secondary_button:GetWidth() + 5)
    end
end

function toast_proxy:SetPayload(...)
    current_toast.payload = { ... }
end

function toast_proxy:Payload()
    return _G.unpack(current_toast.payload)
end

function toast_proxy:MakePersistent()
    current_toast.is_persistent = true
end
