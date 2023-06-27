local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local EE = E:GetModule("ElvUI_Enhanced")

if E.myclass ~= "SHAMAN" then return end

local format, join = string.format, string.join
local floor = math.floor

local GetTime = GetTime
local IsSpellKnown = IsSpellKnown
local GetSpellCooldown = GetSpellCooldown
local IsInInstance = IsInInstance

local SPELL_FAILED_NOT_KNOWN = SPELL_FAILED_NOT_KNOWN
local TIME_REMAINING = TIME_REMAINING
local READY = READY

local iconString = "|T%s:14:14:0:0:64:64:4:55:4:55|t"
local tex = GetSpellTexture(20608)
local displayString = ""

local lastPanel

local function OnUpdate(self)
	if not IsSpellKnown(20608) then return end

	local start, duration = GetSpellCooldown(20608)
	if start > 0 and duration > 0 then 
		self.text:SetFormattedText(displayString, format(iconString, tex), format("%d:%02d", floor((duration - (GetTime() - start)) / 60), floor((duration - (GetTime() - start)) % 60)))
	else
		self.text:SetFormattedText(displayString, format(iconString, tex), READY.."!")
	end
end

local function OnEvent(self, event)
	if not IsSpellKnown(20608) then
		self.text:SetFormattedText(displayString, format(iconString, tex), SPELL_FAILED_NOT_KNOWN)
	else
		if event == "SPELL_UPDATE_COOLDOWN" then
			self:SetScript("OnUpdate", OnUpdate)
		elseif not self.text:GetText() then
			local start, duration = GetSpellCooldown(20608)
			if start > 0 and duration > 0 then 
				self.text:SetFormattedText(displayString, format(iconString, tex), format("%d:%02d", floor((duration - (GetTime() - start)) / 60), floor((duration - (GetTime() - start)) % 60)))
			else
				self.text:SetFormattedText(displayString, format(iconString, tex), READY.."!")
			end
		end
	end

	lastPanel = self
end

local function OnClick(self)
	if not IsSpellKnown(20608) then return end

	local _, instanceType = IsInInstance()
	local start, duration = GetSpellCooldown(20608)
	local message = L["Reincarnation"].." - "..TIME_REMAINING.." "..format("%d:%02d", floor((duration - (GetTime() - start)) / 60), floor((duration - (GetTime() - start)) % 60))
	local message2 = L["Reincarnation"].." - "..READY.."!"

	if start > 0 and duration > 0 then
		if instanceType == "raid" then
			SendChatMessage(message , "RAID", nil, nil)
		elseif instanceType == "party" then
			SendChatMessage(message , "PARTY", nil, nil)
		end
	else
		if instanceType == "raid" then
			SendChatMessage(message2 , "RAID", nil, nil)
		elseif instanceType == "party" then
			SendChatMessage(message2 , "PARTY", nil, nil)
		end
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	DT.tooltip:AddLine(L["Reincarnation"])
	DT.tooltip:AddLine(" ")

	local name, _, _, _, _, _, _, _, _, texture = GetItemInfo(17030)
	local count = GetItemCount(17030)

	if name then
		DT.tooltip:AddDoubleLine(join("", format(iconString, texture), " ", name), count, 1, 1, 1)
	end

	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayString = join("", "%s ", hex, "%s|r")

	if lastPanel ~= nil
		then OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Reincarnation", {"PLAYER_ENTERING_WORLD", "SPELL_UPDATE_COOLDOWN"}, OnEvent, OnUpdate, OnClick, OnEnter, nil, EE:ColorizeSettingName(L["Reincarnation"]))