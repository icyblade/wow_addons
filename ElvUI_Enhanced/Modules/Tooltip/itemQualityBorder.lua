local E, L, V, P, G = unpack(ElvUI)
local IBC = E:NewModule("Enhanced_ItemBorderColor", "AceHook-3.0")
local TT = E:GetModule("Tooltip")

local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor

function IBC:SetBorderColor(_, tt)
	if not tt.GetItem then return end

	local _, link = tt:GetItem()
	if link then
		local _, _, quality = GetItemInfo(link)
		if quality then
			tt:SetBackdropBorderColor(GetItemQualityColor(quality))
		end
	end
end

function IBC:ToggleState()
	if E.db.enhanced.tooltip.itemQualityBorderColor then
		if not self:IsHooked(TT, "SetStyle", "SetBorderColor") then
			self:SecureHook(TT, "SetStyle", "SetBorderColor")
		end
	else
		self:UnhookAll()
	end
end

function IBC:Initialize()
	if not E.db.enhanced.tooltip.itemQualityBorderColor then return end

	self:ToggleState()
end

local function InitializeCallback()
	IBC:Initialize()
end

E:RegisterModule(IBC:GetName(), InitializeCallback)