--[[
	logToggle.lua
		A guild log toggle widget
--]]

local L = LibStub('AceLocale-3.0'):GetLocale('Bagnon-GuildBank')
local LogToggle = Bagnon:NewClass('LogToggle', 'CheckButton')
LogToggle.Icons = {
	[[Interface\Icons\INV_Crate_03]],
	[[Interface\Icons\INV_Misc_Coin_01]],
	[[Interface\Icons\INV_Letter_20]]
}


--[[ Constructor ]]--

function LogToggle:New(parent, type)
	local b = self:Bind(CreateFrame('CheckButton', nil, parent))
	b:SetSize(20, 20)
	b:RegisterForClicks('anyUp')

	local nt = b:CreateTexture()
	nt:SetTexture([[Interface\Buttons\UI-Quickslot2]])
	nt:SetSize(35, 35)
	nt:SetPoint('CENTER', 0, -1)
	b:SetNormalTexture(nt)

	local pt = b:CreateTexture()
	pt:SetTexture([[Interface\Buttons\UI-Quickslot-Depress]])
	pt:SetAllPoints(b)
	b:SetPushedTexture(pt)

	local ht = b:CreateTexture()
	ht:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
	ht:SetAllPoints(b)
	b:SetHighlightTexture(ht)

	local ct = b:CreateTexture()
	ct:SetTexture([[Interface\Buttons\CheckButtonHilight]])
	ct:SetAllPoints(b)
	ct:SetBlendMode('ADD')
	b:SetCheckedTexture(ct)

	local icon = b:CreateTexture()
	icon:SetTexture(self.Icons[type])
	icon:SetAllPoints(b)

	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnHide', b.OnHide)
	b.type = type
	
	return b
end


--[[ Interaction ]]--

function LogToggle:OnClick()
	self:GetParent():ShowPanel(self:GetChecked() and self.type)
end

function LogToggle:OnEnter()
	if self:GetRight() > (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end
	
	GameTooltip:SetText(L['Log' .. self.type])
end

function LogToggle:OnLeave()
	GameTooltip:Hide()
end

function LogToggle:OnHide()
	self:SetChecked(false)
end