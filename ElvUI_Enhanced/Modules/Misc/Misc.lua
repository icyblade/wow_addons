local E, L, V, P, G = unpack(ElvUI)
local M = E:NewModule("Enhanced_Misc", "AceHook-3.0", "AceEvent-3.0")

local CancelDuel = CancelDuel
local IsInInstance = IsInInstance
local RepopMe = RepopMe

local C_PetBattles_CancelPVPDuel = C_PetBattles.CancelPVPDuel

local soulstone
function M:PLAYER_DEAD()
	local inInstance, instanceType = IsInInstance()
	if inInstance and (instanceType == "pvp") then
		if not soulstone then
			soulstone = GetSpellInfo(20707)
		end

		if E.myclass ~= "SHAMAN" and not (soulstone and UnitBuff("player", soulstone)) then
			RepopMe()
		end
	end
end

function M:AutoRelease()
	if E.db.enhanced.general.pvpAutoRelease then
		self:RegisterEvent("PLAYER_DEAD")
	else
		self:UnregisterEvent("PLAYER_DEAD")
	end
end

function M:DUEL_REQUESTED(_, name)
	StaticPopup_Hide("DUEL_REQUESTED")
	CancelDuel()
	E:Print(L["Declined duel request from "]..name..".")
end

function M:DeclineDuel()
	if E.db.enhanced.general.declineDuel then
		self:RegisterEvent("DUEL_REQUESTED")
	else
		self:UnregisterEvent("DUEL_REQUESTED")
	end
end

function M:PET_BATTLE_PVP_DUEL_REQUESTED(_, name)
	StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED")
	C_PetBattles_CancelPVPDuel()
	E:Print(L["Declined pet duel request from "]..name..".")
end

function M:DeclinePetDuel()
	if E.db.enhanced.general.declinePetDuel then
		self:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED")
	else
		self:UnregisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED")
	end
end

function M:PARTY_INVITE_REQUEST(_, name)
	StaticPopup_Hide("PARTY_INVITE")
	DeclineGroup()
	E:Print(L["Declined party request from "]..name..".")
end

function M:DeclineParty()
	if E.db.enhanced.general.declineParty then
		self:RegisterEvent("PARTY_INVITE_REQUEST")
	else
		self:UnregisterEvent("PARTY_INVITE_REQUEST")
	end
end

function M:HideZone()
	if E.db.enhanced.general.hideZoneText then
		ZoneTextFrame:UnregisterAllEvents()
	else
		ZoneTextFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		ZoneTextFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
		ZoneTextFrame:RegisterEvent("ZONE_CHANGED")
	end
end

function M:Initialize()
	self:AutoRelease()
	self:DeclineDuel()
	self:HideZone()
	self:DeclinePetDuel()
	self:QuestItemLevel()
	self:ToggleQuestReward()
	self:QuestLevelToggle()
	self:BuyStackToggle()
	self:MerchantItemLevel()
	self:DeclineParty()
end

local function InitializeCallback()
	M:Initialize()
end

E:RegisterModule(M:GetName(), InitializeCallback)