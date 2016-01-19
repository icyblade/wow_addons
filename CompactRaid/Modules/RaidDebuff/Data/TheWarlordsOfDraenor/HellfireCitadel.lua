------------------------------------------------------------
-- HellfireCitadel.lua
--
-- Abin
-- 2015/7/04
------------------------------------------------------------

local module = CompactRaid:FindModule("RaidDebuff")
if not module then return end

local TIER = 6 -- The Warlords of Draenor
local INSTANCE = 669 -- Hellfire Citadel
local BOSS

-- Hellfire Assault
BOSS = 1426
module:RegisterDebuff(TIER, INSTANCE, BOSS, 184243)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 187052)

-- Iron Reaver
BOSS = 1425
module:RegisterDebuff(TIER, INSTANCE, BOSS, 182075)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 187172)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 179889)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 182523)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 182280, 5)

-- Kormrok
BOSS = 1392
module:RegisterDebuff(TIER, INSTANCE, BOSS, 181321)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 187112, 4)

-- Hellfire High Council
BOSS = 1432
module:RegisterDebuff(TIER, INSTANCE, BOSS, 184449, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 184355)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 184847, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 154992)

-- Kilrogg Deadeye
BOSS = 1396
module:RegisterDebuff(TIER, INSTANCE, BOSS, 184817, 1)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 180313, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 180200)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 180389)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 180224)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 180718)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 185563)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 187089)

-- Gorefiend
BOSS = 1372
--module:RegisterDebuff(TIER, INSTANCE, BOSS, 181295)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 179864)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 179977)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 179907)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 185189)


-- Shadow-Lord Iskar
BOSS = 1433
module:RegisterDebuff(TIER, INSTANCE, BOSS, 182325)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 185510)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 181824)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 179219)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 181753)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 185239, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 185752, 5)

-- Socrethar the Eternal
BOSS = 1427
module:RegisterDebuff(TIER, INSTANCE, BOSS, 182038)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 180415)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 190776)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 184124, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 184239)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 182900)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 182992, 5)

-- Fel Lord Zakuun
BOSS = 1391
module:RegisterDebuff(TIER, INSTANCE, BOSS, 179407)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 188998)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 189260)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 179711)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 181501)

-- Xhul'horac
BOSS = 1447
module:RegisterDebuff(TIER, INSTANCE, BOSS, 186134)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 186135)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 186073)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 186063)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 186448)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 186490)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 188208)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 186333)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 186785)

-- Tyrant Velhari
BOSS = 1394
module:RegisterDebuff(TIER, INSTANCE, BOSS, 185241)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 180164, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 180000, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 180526, 5)

-- Mannoroth
BOSS = 1395
module:RegisterDebuff(TIER, INSTANCE, BOSS, 181275)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 181116)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 181099)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 184252)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 181359)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 181597, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 186350)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 181841)

-- Archimonde
BOSS = 1438
module:RegisterDebuff(TIER, INSTANCE, BOSS, 182826)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 183828)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 183864)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 184931)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 186123)

-- Common
module:RegisterDebuff(TIER, INSTANCE, 0, 190735)
module:RegisterDebuff(TIER, INSTANCE, 0, 188189)
module:RegisterDebuff(TIER, INSTANCE, 0, 188282, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 188287)
module:RegisterDebuff(TIER, INSTANCE, 0, 178064)
module:RegisterDebuff(TIER, INSTANCE, 0, 187130, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 176670, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 187819)
module:RegisterDebuff(TIER, INSTANCE, 0, 189533)
module:RegisterDebuff(TIER, INSTANCE, 0, 189551, 4)