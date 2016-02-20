--[[
	moneyFrame.lua
		A money frame object
--]]

local MoneyFrame = Bagnon:NewClass('GuildMoneyFrame', 'Frame', Bagnon.MoneyFrame)
local L = LibStub('AceLocale-3.0'):GetLocale('Bagnon-GuildBank')


--[[ Interaction ]]--

function MoneyFrame:OnClick(button)
	local money = GetCursorMoney() or 0
	if money > 0 then
		DepositGuildBankMoney(money)
		DropCursorMoney()

	elseif button == 'LeftButton' and not IsShiftKeyDown() then
		PlaySound('igMainMenuOption')
		StaticPopup_Hide('GUILDBANK_WITHDRAW')

		if StaticPopup_Visible('GUILDBANK_DEPOSIT') then
			StaticPopup_Hide('GUILDBANK_DEPOSIT')
		else
			StaticPopup_Show('GUILDBANK_DEPOSIT')
		end
	else
		if CanWithdrawGuildBankMoney() then
			PlaySound('igMainMenuOption')
			StaticPopup_Hide('GUILDBANK_DEPOSIT')
			
			if StaticPopup_Visible('GUILDBANK_WITHDRAW') then
				StaticPopup_Hide('GUILDBANK_WITHDRAW')
			else
				StaticPopup_Show('GUILDBANK_WITHDRAW')
			end
		end
	end
end

function MoneyFrame:OnEnter()
	GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT')
	GameTooltip:SetText(L.TipFunds)
	GameTooltip:AddLine(L.TipDeposit, 1, 1, 1)

	if CanWithdrawGuildBankMoney() then
		local withdrawMoney = min(GetGuildBankWithdrawMoney(), GetGuildBankMoney())
		if withdrawMoney > 0 then
			GameTooltip:AddLine(format(L.TipWithdrawRemaining, self:GetCoinsText(withdrawMoney)), 1,1,1)
		else
			GameTooltip:AddLine(L.TipWithdraw, 1,1,1)
		end
	end

	GameTooltip:Show()
end

function MoneyFrame:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end


--[[ Update ]]--

function MoneyFrame:RegisterEvents()
	self:RegisterEvent('GUILDBANK_UPDATE_MONEY', 'Update')
	self:Update()
end

function MoneyFrame:GetMoney()
	return GetGuildBankMoney()
end