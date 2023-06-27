

--[[

Monitor Combat Log for Healing and Role Specific spells


- Store Per-Match Data, When the match ends, Clear all data

- Recently Cast Heal
- Look at Player's Maximum Health

If the heal is less than...

118k
2k or greater


Minimum Percents...  (1.4 to 2 percent for HoTs)


1700

PlayerGUID, Healing from Spells

1. Look at Internal Data
	- COMBAT_LOG_EVENT_UNFILTERED 
		- Spell Cast Events
		- Aura events
	- Mouseover & Target
		- Aura
	
2. Look at BG Scores


Need to make a warning glow for Graphite


Indicators
	- Role Icon on Plate
	- Scale Spotlight: By Healer Role
	- Opacity Spotlight: By Healer Role
	- Color: By Role  (Healer, Damage, Tank; Blue/Cyan, Red/Magenta, Yellow)
	- Warning Glow: By Healer (Blue/Cyan/Light Blue)
	
	-- Healer:				Blue
	-- Possible Healer: 	Green
--]]

---------------------------------------------------------------------------

local WhiteListSpells = {

        -- Priest
		----------
        [47540] = "PRIEST", -- Penance
        [88625] = "PRIEST", -- Holy Word: Chastise
        [88684] = "PRIEST", -- Holy Word: Serenity
        [88685] = "PRIEST", -- Holy Word: Sanctuary
        [89485] = "PRIEST", -- Inner Focus
        [10060] = "PRIEST", -- Power Infusion
        [33206] = "PRIEST", -- Pain Suppression
        [62618] = "PRIEST", -- Power Word: Barrier
        [724]   = "PRIEST",   -- Lightwell
        [14751] = "PRIEST", -- Chakra
        [34861] = "PRIEST", -- Circle of Healing
        [47788] = "PRIEST", -- Guardian Spirit

        -- Druid
        ---------
		[18562] = "DRUID", -- Swiftmend
        [17116] = "DRUID", -- Nature's Swiftness
        [48438] = "DRUID", -- Wild Growth
        [33891] = "DRUID", -- Tree of Life
        --[774] = "DRUID", -- Rejuvenation (Only For Testing)
		-- Rejuvenation, Lifebloom, Nourish

        -- Shaman
		---------
        [974]   = "SHAMAN", -- Earth Shield
        [17116] = "SHAMAN", -- Nature's Swiftness
        [16190] = "SHAMAN", -- Mana Tide Totem
        [61295] = "SHAMAN", -- Riptide
		

        -- Paladin
		----------
        [20473] = "PALADIN", -- Holy Shock
        [31842] = "PALADIN", -- Divine Favor
        [53563] = "PALADIN", -- Beacon of Light
        [31821] = "PALADIN", -- Aura Mastery
        [85222] = "PALADIN", -- Light of Dawn
}

local BlackListSpells = {
	-- Druid, Non-Healing Talents
	[24858] = "DRUID",	-- Moonkin Form
	[33917] = "DRUID",	-- Mangle
	[49376] = "DRUID",	-- Feral Charge (Cat)
	[16979] = "DRUID",	-- Feral Charge (Bear)
	[50516] = "DRUID",	-- Typhoon
	[48505] = "DRUID",	-- Starfall
	
	-- Paladin
	[31935] = "PALADIN", -- Avenger's Shield
	[85256] = "PALADIN", -- Templar's Verdict
	[20066] = "PALADIN", -- Repentance
	[53385] = "PALADIN", -- Divine Storm
	
	-- Priest
	[34914] = "PRIEST", -- Vampiric Touch
	[15487] = "PRIEST", -- Silence
	[15407] = "PRIEST", -- Mind Flay
	
	-- Shaman
	[51490] = "SHAMAN", -- Thunder Storm
	[51528] = "SHAMAN", -- Maelstrom Weapon
	[17364] = "SHAMAN", -- Stormstrike
	[60103] = "SHAMAN", -- Lava Lash
	[60103] = "SHAMAN", -- Lava Lash
}

local SpellEvents = { 
	["SPELL_HEAL"] = true, 
	["SPELL_AURA_APPLIED"] = true, 
	["SPELL_CAST_START"] = true, 
	["SPELL_CAST_SUCCESS"] = true, 
	["SPELL_PERIODIC_HEAL"] = true,
}

local function IsEnemyPlayer(flags)
	if (bit.band(flags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0) and (bit.band(flags, COMBATLOG_OBJECT_CONTROL_PLAYER) > 0) then
		return true
	end
end

local HealerListByGUID = {}
local HealerListByName = {}

local function WipeLists() 
		HealerListByGUID = wipe(HealerListByGUID)
		HealerListByName = wipe(HealerListByName)
		--HealerListByName["Zhevra Runner"] = "Just for Testing"
end

local function CombatEventHandler(frame, event, ...)	
	if event == "PLAYER_ENTERING_WORLD" then 
		--print(event)
		WipeLists() 
		return
	end
	
	-- Combat Log Unfiltered
	local timestamp, combatevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlag, spellid  = ...		-- WoW 4.2
	
	--print(sourceName, IsEnemyPlayer(sourceFlags), SpellEvents[combatevent], WhiteListSpells[spellid])
	if IsEnemyPlayer(sourceFlags) and sourceGUID then					-- Filter for Enemy PvP
		if SpellEvents[combatevent] then
			if WhiteListSpells[spellid] then
				local rawName = strsplit("-", sourceName)		-- Strip server name
				if HealerListByGUID[sourceGUID] ~= rawName then
					--print("Healer Detected:", rawName)
					HealerListByGUID[sourceGUID] = rawName
					HealerListByName[rawName] = sourceGUID
					TidyPlates:RequestDelegateUpdate()
				end
			--elseif BlackListSpells[spellid] then
				
			end
			
			
		end
	end
end

TidyPlatesCache = TidyPlatesCache or {}
TidyPlatesCache.HealerListByGUID = HealerListByGUID
TidyPlatesCache.HealerListByName = HealerListByName

local HealerTrackWatcher = CreateFrame("Frame")	
	
local function Enable()
	HealerTrackWatcher:SetScript("OnEvent", CombatEventHandler)
	HealerTrackWatcher:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	HealerTrackWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")
	WipeLists() 
end

local function Disable() 
	HealerTrackWatcher:SetScript("OnEvent", nil)
	HealerTrackWatcher:UnregisterAllEvents()
	WipeLists() 
end

TidyPlatesUtility.EnableHealerTrack = Enable
TidyPlatesUtility.DisableHealerTrack = Disable



			