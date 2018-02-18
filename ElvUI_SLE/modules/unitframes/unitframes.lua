local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local UF = E:GetModule('UnitFrames');
local SUF = SLE:NewModule("UnitFrames", "AceEvent-3.0")
local RC = LibStub("LibRangeCheck-2.0")
--GLOBALS: hooksecurefunc, CreateFrame
local _G = _G
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs

function SUF:NewTags()
	_G["ElvUF"].Tags.Events['health:current:sl-rehok'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
	_G["ElvUF"].Tags.Methods['health:current:sl-rehok'] = function(unit)
		local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

		if (status) then
			return status
		else
			local curHealth = UnitHealth(unit)
			local perHealth = (UnitHealth(unit)/UnitHealthMax(unit))*100

			if curHealth >= 1e9 then
				return format("%.2fB", curHealth / 1e9) .. " | " .. format("%.0f", perHealth)
			elseif curHealth >= 1e6 then
				return format("%.2fM", curHealth / 1e6) .. " | " .. format("%.0f", perHealth)
			elseif curHealth >= 1e3 then
				return format("%.0fk", curHealth / 1e3) .. " | " .. format("%.0f", perHealth)
			else
				return format("%d", curHealth) .. " | " .. format("%.1f", perHealth)
			end
		end
	end

	_G["ElvUF"].Tags.Methods["range:sl"] = function(unit)
		local name, server = T.UnitName(unit)
		local rangeText = ''
		local min, max = RC:GetRange(unit)
		local curMin = min
		local curMax = max

		if(server and server ~= "") then
			name = T.format("%s-%s", name, server)
		end

		if min and max and (name ~= T.UnitName('player')) then
			rangeText = curMin.."-"..curMax
		end
		return rangeText
	end

	_G["ElvUF"].Tags.Events['absorbs:sl-short'] = 'UNIT_ABSORB_AMOUNT_CHANGED'
	_G["ElvUF"].Tags.Methods['absorbs:sl-short'] = function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb == 0 then
			return 0
		else
			return E:ShortValue(absorb)
		end
	end

	_G["ElvUF"].Tags.Events['absorbs:sl-full'] = 'UNIT_ABSORB_AMOUNT_CHANGED'
	_G["ElvUF"].Tags.Methods['absorbs:sl-full'] = function(unit)
		local absorb = UnitGetTotalAbsorbs(unit) or 0
		if absorb == 0 then
			return 0
		else
			return absorb
		end
	end

	_G["ElvUF"].Tags.Methods['sl:pvptimer'] = function(unit)
		if (UnitIsPVPFreeForAll(unit) or UnitIsPVP(unit)) then
			local timer = GetPVPTimer()

			if timer ~= 301000 and timer ~= -1 then
				local mins = floor((timer / 1000) / 60)
				local secs = floor((timer / 1000) - (mins * 60))
				return ("%01.f:%02.f"):format(mins, secs)
			else
				return ""
			end
		else
			return ""
		end
	end
end

function SUF:ConfiguePortrait(frame, dontHide)
	local db = E.db.sle.unitframes.unit
	local portrait = frame.Portrait
	if portrait.SLEHooked or not db[frame.unitframeType] then return end
	hooksecurefunc(portrait, "PostUpdate", SUF.PortraitUpdate)
	portrait.SLEHooked = true
end

function SUF:PortraitUpdate(unit, ...)
	local frame = self:GetParent()
	local dbElv = frame.db
	if not dbElv then return end
	local db = E.db.sle.unitframes.unit
	local portrait = dbElv.portrait
	if db[frame.unitframeType] and portrait.enable and self:GetParent().USE_PORTRAIT_OVERLAY then
		self:SetAlpha(0);
		self:SetAlpha(db[frame.unitframeType].portraitAlpha);
	end
	if (db[frame.unitframeType] and db[frame.unitframeType].higherPortrait) and frame.USE_PORTRAIT_OVERLAY then
		if not frame.Health.HigherPortrait then
			frame.Health.HigherPortrait = CreateFrame("Frame", frame:GetName().."HigherPortrait", frame)
			frame.Health.HigherPortrait:SetFrameLevel(frame.Health:GetFrameLevel() + 4)
			frame.Health.HigherPortrait:SetPoint("TOPLEFT", frame.Health, "TOPLEFT")
			frame.Health.HigherPortrait:SetPoint("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", 0, 0.5)
		end
		self:ClearAllPoints()
		if frame.db.portrait.style == '3D' then self:SetFrameLevel(frame.Health.HigherPortrait:GetFrameLevel()) end
		self:SetAllPoints(frame.Health.HigherPortrait)
		frame.Health.bg:SetParent(frame.Health)
	end
end

function SUF:UpdateHealComm(unit, myIncomingHeal, allIncomingHeal, totalAbsorb, healAbsorb)
	local frame = self.parent
	local previousTexture = frame.Health:GetStatusBarTexture();

	UF:UpdateFillBar(frame, previousTexture, self.healAbsorbBar, healAbsorb, true);
	previousTexture = UF:UpdateFillBar(frame, previousTexture, self.myBar, myIncomingHeal);
	previousTexture = UF:UpdateFillBar(frame, previousTexture, self.otherBar, allIncomingHeal);
	previousTexture = UF:UpdateFillBar(frame, previousTexture, self.absorbBar, totalAbsorb);
end

function SUF:HealthPredictUpdate(frame)
	if frame.HealthPrediction and (not frame.HealthPrediction.SLEPredictHook and frame.HealthPrediction.PostUpdate) then
		hooksecurefunc(frame.HealthPrediction, "PostUpdate", SUF.UpdateHealComm)
		frame.HealthPrediction.SLEPredictHook = true
	end
end

local function UpdateAuraTimer(self, elapsed)
	local timervalue, formatid
	local unitID = self:GetParent():GetParent().unitframeType
	local auraType = self:GetParent().type
	if unitID and E.db.sle.unitframes.unit[unitID] and E.db.sle.unitframes.unit[unitID].auras then
		timervalue, formatid, self.nextupdate = E:GetTimeInfo(self.expirationSaved, E.db.sle.unitframes.unit[unitID].auras[auraType].threshold)
	else
		timervalue, formatid, self.nextupdate = E:GetTimeInfo(self.expirationSaved, 4)
	end
	if self.text:GetFont() then
		self.text:SetFormattedText(("%s%s|r"):format(E.TimeColors[formatid], E.TimeFormats[formatid][2]), timervalue)
	elseif self:GetParent():GetParent().db then
		self.text:FontTemplate(LSM:Fetch("font", E.db['unitframe'].font), self:GetParent():GetParent().db[auraType].fontSize, E.db['unitframe'].fontOutline)
		self.text:SetFormattedText(("%s%s|r"):format(E.TimeColors[formatid], E.TimeFormats[formatid][2]), timervalue)
	end
end

function SUF:Initialize()
	if not SLE.initialized or not E.private.unitframe.enable then return end
	SUF:NewTags()
	-- SUF:InitPlayer()

	--Raid stuff
	SUF.specNameToRole = {}
	for i = 1, T.GetNumClasses() do
		local _, class, classID = T.GetClassInfo(i)
		SUF.specNameToRole[class] = {}
		for j = 1, T.GetNumSpecializationsForClassID(classID) do
			local _, spec, _, _, role = T.GetSpecializationInfoForClassID(classID, j)
			SUF.specNameToRole[class][spec] = role
		end
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		SUF:SetRoleIcons()
		if E.private.sle.unitframe.statusbarTextures.cast then SUF:CastBarHook() end
	end)

	--Hooking to group frames
	hooksecurefunc(UF, "Update_PartyFrames", SUF.Update_GroupFrames)
	hooksecurefunc(UF, "Update_RaidFrames", SUF.Update_GroupFrames)
	hooksecurefunc(UF, "Update_Raid40Frames", SUF.Update_GroupFrames)
	--Portrait overlay
	hooksecurefunc(UF, "Configure_Portrait", SUF.ConfiguePortrait)
	if E.private.sle.unitframe.resizeHealthPrediction then
		hooksecurefunc(UF, "Configure_HealthBar", SUF.HealthPredictUpdate)
	end

	--Hook pvp icons
	SUF:UpgradePvPIcon()

	SUF:InitStatus()
	
	hooksecurefunc(UF, "UpdateAuraTimer", UpdateAuraTimer)

	function SUF:ForUpdateAll()
		SUF:SetRoleIcons()
		if E.private.sle.unitframe.statusbarTextures.power then SUF:BuildStatusTable() end
	end
end

SLE:RegisterModule(SUF:GetName())
