local L = LibStub("AceLocale-3.0"):GetLocale("DeathNote")

local announced_deaths = {}
local skipped_deaths = 0
local skip_timer

function DeathNote:AnnounceDeath(death)
	if not self.settings.announce.enable then
		return
	end

	local now = GetTime()
	local tensecs = now - 10

	for i = #announced_deaths, 1, -1 do
		if announced_deaths[i] < tensecs then
			table.remove(announced_deaths, i)
		end
	end

	if #announced_deaths >= self.settings.announce.limit then
		skipped_deaths = skipped_deaths + 1
		self:CancelTimer(skip_timer, true)
		skip_timer = self:ScheduleTimer("SkipAnnounce", 10)
		return
	end

	local entry, damage, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing =  DeathNote:GetKillingBlow(death)

	local isoutputchat = self:O_IsChatOutput(self.settings.announce.channel)
	local iswhisper = self.settings.announce.channel == "WHISPER"

	local text

	if not entry then
		if self.settings.announce.announce_unknown then
			text = string.format(L["%s|r has died of a heart attack"], self:FormatUnit(death.GUID, death.name, death.flags, death.raidFlags))
		else
			return
		end
	else
		if self.settings.announce.style == "COMBAT_LOG" then
			text = self:FormatCombatLog(entry)
		elseif self.settings.announce.style == "FORMATTED" then
			local source = self:FormatUnit(entry.sourceGUID, entry.sourceName, entry.sourceFlags, entry.sourceRaidFlags)
			local spell = self:FormatEntrySpell(entry)

			if iswhisper then
				text = L["You were killed by"] .. " "
			else
				text = string.format(L["%s|r was killed by"] .. " ", self:FormatUnit(death.GUID, death.name, death.flags, death.raidFlags))
			end

			if source ~= "" then
				text = text .. string.format(L["%s's|r %s"], source, spell)
			else
				text = text .. spell
			end

			if self.settings.announce.format_damage and damage > 0 then
				text = text .. string.format(" (%i %s", damage, DAMAGE)
			end

			if self.settings.announce.format_hittype then
				if critical then
					text = text .. " " .. TEXT_MODE_A_STRING_RESULT_CRITICAL
				end
				if glancing then
					text = text .. " " .. TEXT_MODE_A_STRING_RESULT_GLANCING
				end
				if crushing then
					text = text .. " " .. TEXT_MODE_A_STRING_RESULT_CRUSHING
				end
			end

			if self.settings.announce.format_damage and damage > 0 then
				text = text .. ") "
			end

			if self.settings.announce.format_resist then
				if resisted and resisted > 0 then
					text = text .. string.format(TEXT_MODE_A_STRING_RESULT_RESIST, resisted) .. " "
				end
				if blocked and blocked > 0 then
					text = text .. string.format(TEXT_MODE_A_STRING_RESULT_BLOCK, blocked) .. " "
				end
				if absorbed and absorbed > 0 then
					text = text .. string.format(TEXT_MODE_A_STRING_RESULT_ABSORB, absorbed) .. " "
				end
			end

			if self.settings.announce.format_overkill then
				if overkill and overkill > 0 then
					text = text .. string.format(TEXT_MODE_A_STRING_RESULT_OVERKILLING, overkill)
				end
			end

			text = string.gsub(text, "^%s*(.-)%s*$", "%1") -- trim spaces
		end
	end

	if isoutputchat then
		text = self:CleanForChat(text)
	else
		-- add the icon borders back again
		text = text:gsub("|T(.-):.-|t", "|T%1:0|t")
	end

	if iswhisper then
		text = { death.name, text }
	end

	self:O_Send(self.settings.announce.channel, text)

	table.insert(announced_deaths, now)
end

function DeathNote:SkipAnnounce()
	self:Print(string.format(L["%i more deaths were not announced"], skipped_deaths))
	skipped_deaths = 0
end