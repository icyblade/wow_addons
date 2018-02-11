local E, L, P, G = unpack(select(2, ...)); --Inport: Engine, Locales, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')

--Cache global variables
--Lua functions
local pairs = pairs
local join = string.join
--WoW API / Variables
local IsLoggedIn = IsLoggedIn
local GetMoney = GetMoney
local IsShiftKeyDown = IsShiftKeyDown
local GetBackpackCurrencyInfo = GetBackpackCurrencyInfo

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: ElvDB, ToggleAllBags

local MAX_WATCHED_TOKENS = MAX_WATCHED_TOKENS
local CURRENCY = CURRENCY

local Profit	= 0
local Spent		= 0
local resetCountersFormatter = join("", "|cffaaaaaa", L["Reset Counters: Hold Shift + Left Click"], "|r")
local resetInfoFormatter = join("", "|cffaaaaaa", L["Reset Data: Hold Shift + Right Click"], "|r")

local function OnEvent(self)
	if not IsLoggedIn() then return end
	local NewMoney = GetMoney();
	ElvDB = ElvDB or { };
	ElvDB['gold'] = ElvDB['gold'] or {};
	ElvDB['gold'][E.myrealm] = ElvDB['gold'][E.myrealm] or {};
	ElvDB['gold'][E.myrealm][E.myname] = ElvDB['gold'][E.myrealm][E.myname] or NewMoney;

	local OldMoney = ElvDB['gold'][E.myrealm][E.myname] or NewMoney

	local Change = NewMoney-OldMoney -- Positive if we gain money
	if OldMoney>NewMoney then		-- Lost Money
		Spent = Spent - Change
	else							-- Gained Moeny
		Profit = Profit + Change
	end

	self.text:SetText(E:FormatMoney(NewMoney, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins))

	ElvDB['gold'][E.myrealm][E.myname] = NewMoney
end

local function Click(self, btn)
	if IsShiftKeyDown() then
		if btn == "LeftButton" then
			Profit = 0
			Spent = 0
			DT.tooltip:Hide();
		elseif btn == "RightButton" then
			ElvDB.gold = nil;
			OnEvent(self)
			DT.tooltip:Hide();
		end
	else
		ToggleAllBags()
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	local textOnly = not E.db.datatexts.goldCoins and true or false
	local style = E.db.datatexts.goldFormat or "BLIZZARD"

	DT.tooltip:AddLine(L["Session:"])
	DT.tooltip:AddDoubleLine(L["Earned:"], E:FormatMoney(Profit, style, textOnly), 1, 1, 1, 1, 1, 1)
	DT.tooltip:AddDoubleLine(L["Spent:"], E:FormatMoney(Spent, style, textOnly), 1, 1, 1, 1, 1, 1)
	if Profit < Spent then
		DT.tooltip:AddDoubleLine(L["Deficit:"], E:FormatMoney(Profit-Spent, style, textOnly), 1, 0, 0, 1, 1, 1)
	elseif (Profit-Spent)>0 then
		DT.tooltip:AddDoubleLine(L["Profit:"], E:FormatMoney(Profit-Spent, style, textOnly), 0, 1, 0, 1, 1, 1)
	end
	DT.tooltip:AddLine' '

	local totalGold = 0
	DT.tooltip:AddLine(L["Character: "])

	for k,_ in pairs(ElvDB['gold'][E.myrealm]) do
		if ElvDB['gold'][E.myrealm][k] then
			DT.tooltip:AddDoubleLine(k, E:FormatMoney(ElvDB['gold'][E.myrealm][k], style, textOnly), 1, 1, 1, 1, 1, 1)
			totalGold=totalGold+ElvDB['gold'][E.myrealm][k]
		end
	end

	DT.tooltip:AddLine' '
	DT.tooltip:AddLine(L["Server: "])
	DT.tooltip:AddDoubleLine(L["Total: "], E:FormatMoney(totalGold, style, textOnly), 1, 1, 1, 1, 1, 1)

	for i = 1, MAX_WATCHED_TOKENS do
		local name, count = GetBackpackCurrencyInfo(i)
		if name and i == 1 then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(CURRENCY)
		end
		if name and count then DT.tooltip:AddDoubleLine(name, count, 1, 1, 1) end
	end

	DT.tooltip:AddLine' '
	DT.tooltip:AddLine(resetCountersFormatter)
	DT.tooltip:AddLine(resetInfoFormatter)

	DT.tooltip:Show()
end

DT:RegisterDatatext('Gold', {'PLAYER_ENTERING_WORLD', 'PLAYER_MONEY', 'SEND_MAIL_MONEY_CHANGED', 'SEND_MAIL_COD_CHANGED', 'PLAYER_TRADE_MONEY', 'TRADE_MONEY_CHANGED'}, OnEvent, nil, Click, OnEnter, nil, L["Gold"])
