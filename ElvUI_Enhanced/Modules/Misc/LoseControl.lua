local E, L, V, P, G = unpack(ElvUI)
local LC = E:NewModule("Enhanced_LoseControl", "AceEvent-3.0")

local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local UnitDebuff = UnitDebuff

local spellNameList = {}
local spellIDList = {
	-- Death Knight
	[47481]	= "CC",			-- Gnaw (Ghoul)
	[49203]	= "CC",			-- Hungering Cold
	[91797]	= "CC",			-- Monstrous Blow (Super ghoul)
	[47476]	= "Silence",	-- Strangulate
	[45524]	= "Snare",		-- Chains of Ice
	[55666]	= "Snare",		-- Desecration
	[50040]	= "Snare",		-- Chilblains
	-- Druid
	[5211]	= "CC",			-- Bash (also Shaman Spirit Wolf ability)
	[33786]	= "CC",			-- Cyclone
	[2637]	= "CC",			-- Hibernate
	[22570]	= "CC",			-- Maim
	[9005]	= "CC",			-- Pounce
	[81261]	= "Silence",	-- Solar Beam
	[339]	= "Root",		-- Entangling Roots
	[45334]	= "Root",		-- Feral Charge Effect
	[58179]	= "Snare",		-- Infected Wounds
	[61391]	= "Snare",		-- Typhoon
	-- Hunter
	[3355]	= "CC",			-- Freezing Trap Effect
	[24394]	= "CC",			-- Intimidation
	[1513]	= "CC",			-- Scare Beast
	[19503]	= "CC",			-- Scatter Shot
	[19386]	= "CC",			-- Wyvern Sting
	[34490]	= "Silence",	-- Silencing Shot
	[19306]	= "Root",		-- Counterattack
	[19185]	= "Root",		-- Entrapment
	[35101]	= "Snare",		-- Concussive Barrage
	[5116]	= "Snare",		-- Concussive Shot
	[13810]	= "Snare",		-- Frost Trap Aura
	[61394]	= "Snare",		-- Glyph of Freezing Trap
	[2974]	= "Snare",		-- Wing Clip
	-- Hunter Pets
	[50519]	= "CC",			-- Sonic Blast (Bat)
	[90337]	= "CC",			-- Bad Manner (Monkey)
	[50541]	= "Disarm",		-- Snatch (Bird of Prey)
	[54706]	= "Root",		-- Venom Web Spray (Silithid)
	[4167]	= "Root",		-- Web (Spider)
	[50245]	= "Root",		-- Pin (Crab)
	[54644]	= "Snare",		-- Froststorm Breath (Chimera)
	[50271]	= "Snare",		-- Tendon Rip (Hyena)
	-- Mage
	[44572]	= "CC",			-- Deep Freeze
	[31661]	= "CC",			-- Dragon"s Breath
	[12355]	= "CC",			-- Impact
	[83047]	= "CC",			-- Improved Polymorph
	[118]	= "CC",			-- Polymorph
	[82691]	= "CC",			-- Ring of Frost
	[18469]	= "Silence",	-- Silenced - Improved Counterspell
	[64346]	= "Disarm",		-- Fiery Payback
	[33395]	= "Root",		-- Freeze (Water Elemental)
	[122]	= "Root",		-- Frost Nova
	[83302]	= "Root",		-- Improved Cone of Cold
	[55080]	= "Root",		-- Shattered Barrier
	[11113]	= "Snare",		-- Blast Wave
	[6136]	= "Snare",		-- Chilled (generic effect, used by lots of spells [looks weird on Improved Blizzard, might want to comment out])
	[120]	= "Snare",		-- Cone of Cold
	[116]	= "Snare",		-- Frostbolt
	[44614]	= "Snare",		-- Frostfire Bolt
	[31589]	= "Snare",		-- Slow
	-- Paladin
	[853]	= "CC",			-- Hammer of Justice
	[2812]	= "CC",			-- Holy Wrath
	[20066]	= "CC",			-- Repentance
	[10326]	= "CC",			-- Turn Evil
	[31935]	= "Silence",	-- Avenger's Shield
	[63529]	= "Snare",		-- Dazed - Avenger's Shield
	[20170]	= "Snare",		-- Seal of Justice (100% movement snare druids and shamans might want this though)
	-- Priest
	[605]	= "CC",			-- Mind Control
	[64044]	= "CC",			-- Psychic Horror
	[8122]	= "CC",			-- Psychic Scream
	[9484]	= "CC",			-- Shackle Undead
	[87204]	= "CC",			-- Sin and Punishment
	[15487]	= "Silence",	-- Silence
	[64058]	= "Disarm",		-- Psychic Horror
	[87194]	= "Root",		-- Paralysis
	[15407]	= "Snare",		-- Mind Flay
	-- Rogue
	[2094]	= "CC",			-- Blind
	[1833]	= "CC",			-- Cheap Shot
	[1776]	= "CC",			-- Gouge
	[408]	= "CC",			-- Kidney Shot
	[6770]	= "CC",			-- Sap
	[76577]	= "CC",			-- Smoke Bomb
	[1330]	= "Silence",	-- Garrote - Silence
	[18425]	= "Silence",	-- Silenced - Improved Kick
	[51722]	= "Disarm",		-- Dismantle
	[31125]	= "Snare",		-- Blade Twisting
	[3409]	= "Snare",		-- Crippling Poison
	[26679]	= "Snare",		-- Deadly Throw
	-- Shaman
	[76780]	= "CC",			-- Bind Elemental
	[61882]	= "CC",			-- Earthquake
	[51514]	= "CC",			-- Hex
	[39796]	= "CC",			-- Stoneclaw Stun
	[64695]	= "Root",		-- Earthgrab (Earth"s Grasp)
	[63685]	= "Root",		-- Freeze (Frozen Power)
	[3600]	= "Snare",		-- Earthbind (5 second duration per pulse, but will keep re-applying the debuff as long as you stand within the pulse radius)
	[8056]	= "Snare",		-- Frost Shock
	[8034]	= "Snare",		-- Frostbrand Attack
	-- Warlock
	[93986]	= "CC",			-- Aura of Foreboding
	[89766]	= "CC",			-- Axe Toss (Felguard)
	[710]	= "CC",			-- Banish
	[6789]	= "CC",			-- Death Coil
	[54786]	= "CC",			-- Demon Leap
	[5782]	= "CC",			-- Fear
	[5484]	= "CC",			-- Howl of Terror
	[6358]	= "CC",			-- Seduction (Succubus)
	[30283]	= "CC",			-- Shadowfury
	[24259]	= "Silence",	-- Spell Lock (Felhunter)
	[31117]	= "Silence",	-- Unstable Affliction
	[93974]	= "Root",		-- Aura of Foreboding
	[18118]	= "Snare",		-- Aftermath
	[18223]	= "Snare",		-- Curse of Exhaustion
	[63311]	= "Snare",		-- Shadowsnare (Glyph of Shadowflame)
	-- Warrior
	[7922]	= "CC",			-- Charge Stun
	[12809]	= "CC",			-- Concussion Blow
	[6544]	= "CC",			-- Heroic Leap
	[20253]	= "CC",			-- Intercept
	[5246]	= "CC",			-- Intimidating Shout
	[46968]	= "CC",			-- Shockwave
	[85388]	= "CC",			-- Throwdown
	[18498]	= "Silence",	-- Silenced - Gag Order
	[676] 	= "Disarm",		-- Disarm
	[23694]	= "Root",		-- Improved Hamstring
	[1715]	= "Snare",		-- Hamstring
	[12323]	= "Snare",		-- Piercing Howl
	-- Other
	[30217]	= "CC",			-- Adamantite Grenade
	[67769]	= "CC",			-- Cobalt Frag Bomb
	[30216]	= "CC",			-- Fel Iron Bomb
	[13327]	= "CC",			-- Reckless Charge
	[56]	= "CC",			-- Stun
	[20549]	= "CC",			-- War Stomp
	[25046]	= "Silence",	-- Arcane Torrent
	[39965]	= "Root",		-- Frost Grenade
	[55536]	= "Root",		-- Frostweave Net
	[13099]	= "Root",		-- Net-o-Matic
	[29703]	= "Snare",		-- Dazed
	-- PvE
	[11428]	= "PvE",		-- Knockdown (generic)
}

local priorities = {
	["CC"]		= 60,
	["PvE"]		= 50,
	["Silence"]	= 40,
	["Disarm"]	= 30,
	["Root"]	= 20,
	["Snare"]	= 10
}

function LC:OnUpdate(elapsed)
	self.timeLeft = self.timeLeft - elapsed

	if self.timeLeft > 10 then
		self.cooldownTime:SetFormattedText("%d", self.timeLeft)
	elseif self.timeLeft > 0 then
		self.cooldownTime:SetFormattedText("%.1f", self.timeLeft)
	else
		self:SetScript("OnUpdate", nil)
		self.timeLeft = nil
		self.cooldownTime:SetText("0")
	end
end

local function CheckPriority(priority, ccPriority, expirationTime, ccExpirationTime)
	if not ccPriority then
		return true
	end

	if priorities[priority] > priorities[ccPriority] then
		return true
	elseif priorities[priority] == priorities[ccPriority] and expirationTime > ccExpirationTime then
		return true
	end
end

function LC:UNIT_AURA(event, unit)
	if unit ~= "player" then return end

	local ccExpirationTime = 0
	local ccName, ccIcon, ccDuration, ccPriority, wyvernSting
	local _, name, icon, duration, expirationTime, spellID, priority

	for i = 1, 40 do
		name, _, icon, _, _, duration, expirationTime = UnitDebuff("player", i)
		if not name then break end

		if name == self.wyvernStingName then
			wyvernSting = 1

			if not self.wyvernSting then
				self.wyvernSting = 1
			elseif expirationTime > self.wyvernStingExpirationTime then
				self.wyvernSting = 2
			end

			self.wyvernStingExpirationTime = expirationTime

			if self.wyvernSting == 2 then
				name = nil
			end
		elseif name == self.psychicHorrorName and icon ~= "Interface\\Icons\\Ability_Warrior_Disarm" then
			name = nil
		end

		priority = self.db[spellNameList[name]]

		if priority and CheckPriority(priority, ccPriority, expirationTime, ccExpirationTime) then
			ccName = name
			ccIcon = icon
			ccDuration = duration
			ccExpirationTime = expirationTime
			ccPriority = priorities[priority]
		end
	end

	if self.wyvernSting == 2 and not wyvernSting then
		self.wyvernSting = nil
	end

	if ccExpirationTime == 0 then
		if self.ccExpirationTime ~= 0 then
			self.ccExpirationTime = 0
			self.frame.timeLeft = nil
			self.frame:SetScript("OnUpdate", nil)
			self.frame:Hide()
		end
	elseif ccExpirationTime ~= self.ccExpirationTime then
		self.ccExpirationTime = ccExpirationTime

		self.frame.icon:SetTexture(ccIcon)
		self.frame.spellName:SetText(ccName)

		if ccDuration > 0 then
			self.frame.cooldown:SetCooldown(ccExpirationTime - ccDuration, ccDuration)

			local timeLeft = ccExpirationTime - GetTime()

			if self.frame.timeLeft then
				self.frame.timeLeft = timeLeft
			else
				self.frame.timeLeft = timeLeft
				self.frame:SetScript("OnUpdate", self.OnUpdate)
			end
		end

		self.frame:Show()
	end
end

function LC:UpdateSpellNames()
	local spellName
	for spellID, ccType in pairs(spellIDList) do
		spellName = GetSpellInfo(spellID)

		if spellName then
			spellNameList[spellName] = ccType
		end
	end
end

function LC:ToggleState()
	if E.private.enhanced.loseControl.enable then
		if not self.initialized then
			self:Initialize()
			return
		end

		E:EnableMover(self.frame.mover:GetName())
		self:RegisterEvent("UNIT_AURA")
	else
		self.ccExpirationTime = 0
		self.frame.timeLeft = nil
		self.frame:SetScript("OnUpdate", nil)
		self.frame:Hide()

		E:DisableMover(self.frame.mover:GetName())
		self:UnregisterEvent("UNIT_AURA")
	end
end

function LC:UpdateSettings()
	if not self.db then return end

	self.frame:Size(self.db.iconSize)

	if self.db.compactMode then
		self.frame.cooldownTime:FontTemplate(E.media.normFont, E:Round(self.db.iconSize / 3), "OUTLINE")
		self.frame.cooldownTime:ClearAllPoints()
		self.frame.cooldownTime:SetPoint("CENTER")
		self.frame.spellName:Hide()
		self.frame.secondsText:Hide()
	else
		self.frame.cooldownTime:FontTemplate(E.media.normFont, 20, "OUTLINE")
		self.frame.cooldownTime:SetPoint("BOTTOM", 0, -50)
		self.frame.spellName:Show()
		self.frame.secondsText:Show()
	end
end

function LC:Initialize()
	if not E.private.enhanced.loseControl.enable then return end

	self.db = E.db.enhanced.loseControl

	self.frame = CreateFrame("Frame", "ElvUI_LoseControl", UIParent)
	self.frame:SetPoint("CENTER")
	self.frame:SetTemplate()
	self.frame:Hide()

	self.frame.icon = self.frame:CreateTexture(nil, "ARTWORK")
	self.frame.icon:SetInside()
	self.frame.icon:SetTexCoord(unpack(E.TexCoords))

	self.frame.cooldown = CreateFrame("Cooldown", "$parent_Cooldown", self.frame, "CooldownFrameTemplate")
	self.frame.cooldown:SetInside()

	self.frame.spellName = self.frame:CreateFontString(nil, "OVERLAY")
	self.frame.spellName:FontTemplate(E.media.normFont, 20, "OUTLINE")
	self.frame.spellName:SetPoint("BOTTOM", 0, -25)

	self.frame.cooldownTime = self.frame.cooldown:CreateFontString(nil, "OVERLAY")

	self.frame.secondsText = self.frame.cooldown:CreateFontString(nil, "OVERLAY")
	self.frame.secondsText:FontTemplate(E.media.normFont, 20, "OUTLINE")
	self.frame.secondsText:SetPoint("BOTTOM", 0, -75)
	self.frame.secondsText:SetText(L["seconds"])

	self:UpdateSettings()

	E:CreateMover(self.frame, "LossControlMover", L["Loss Control Icon"], nil, nil, nil, "ALL,ARENA", nil, "elvuiPlugins,enhanced,miscGroup,loseControl")

	self:UpdateSpellNames()

	self.wyvernStingName = GetSpellInfo(19386)
	self.psychicHorrorName = GetSpellInfo(64058)

	self:RegisterEvent("UNIT_AURA")

	self.initialized = true
end

local function InitializeCallback()
	LC:Initialize()
end

E:RegisterModule(LC:GetName(), InitializeCallback)