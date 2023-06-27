local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack
local find = string.find

local function LoadSkin()
	if not E.private.addOnSkins.TradeskillInfo then return end

	TradeskillInfoFrame:SetTemplate("Transparent")

	S:HandleCloseButton(TradeskillInfoFrameCloseButton)

	S:HandleButton(TradeskillInfoResetButton)
	S:HandleButton(TradeskillInfoOpposingButton)
	S:HandleButton(TradeskillInfoNameButton)
	S:HandleButton(TradeskillInfoReagentButton)
	S:HandleButton(TradeskillInfoSearchButton)

	S:HandleDropDownBox(TradeskillInfoSortDropDown)
	S:HandleDropDownBox(TradeskillInfoTradeskillsDropDown)
	S:HandleDropDownBox(TradeskillInfoAvailabilityDropDown)

	TradeskillInfoListScrollFrame:StripTextures()
	S:HandleScrollBar(TradeskillInfoListScrollFrameScrollBar)

	TradeskillInfoDetailScrollFrame:StripTextures()
	S:HandleScrollBar(TradeskillInfoDetailScrollFrameScrollBar)

	S:HandleEditBox(TradeskillInfoInputBox)

	TradeskillInfoDetailScrollChildFrame:StripTextures()

	TradeskillInfoSkillIcon:StyleButton(nil, true)
	TradeskillInfoSkillIcon:SetTemplate("Default")

	S:SecureHook(TradeskillInfoSkillIcon, "SetNormalTexture", function(self)
		self:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		self:GetNormalTexture():SetInside()

		S:Unhook(TradeskillInfoSkillIcon, "SetNormalTexture")
	end)

	for i = 1, 8 do
		local reagent = _G["TradeskillInfoReagent"..i]
		local icon = _G["TradeskillInfoReagent"..i.."IconTexture"]
		local count = _G["TradeskillInfoReagent"..i.."Count"]
		local nameFrame = _G["TradeskillInfoReagent"..i.."NameFrame"]

		icon.backdrop = CreateFrame("Frame", nil, reagent)
		icon.backdrop:SetFrameLevel(reagent:GetFrameLevel() - 1)
		icon.backdrop:SetTemplate("Default")
		icon.backdrop:SetOutside(icon)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetParent(icon.backdrop)
		icon:SetDrawLayer("OVERLAY")

		count:SetParent(icon.backdrop)
		count:SetDrawLayer("OVERLAY")

		nameFrame:Kill()
	end

	hooksecurefunc(TradeskillInfoUI, "DoFrameUpdate", function(self)
		for i = 0, self.vars.numSkillButtons do
			local button = _G["TradeskillInfoSkill"..i]

			if i == 0 then
				button = TradeskillInfoCollapseAllButton
			end

			if not button.isHooked then
				button:SetNormalTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")
				button.SetNormalTexture = E.noop
				button:GetNormalTexture():Size(11)

				button:SetPushedTexture("")
				button.SetPushedTexture = E.noop

				button:SetHighlightTexture("")
				button.SetHighlightTexture = E.noop

				button:SetDisabledTexture("")
				button.SetDisabledTexture = E.noop

				hooksecurefunc(button, "SetNormalTexture", function(self, texture)
					if find(texture, "MinusButton") then
						self:GetNormalTexture():SetTexCoord(0.5625, 1, 0, 0.4375)
					elseif find(texture, "PlusButton") then
						self:GetNormalTexture():SetTexCoord(0, 0.4375, 0, 0.4375)
					else
						self:GetNormalTexture():SetTexCoord(0, 0, 0, 0)
 					end
				end)

				button.isHooked = true
			end
		end
	end)
end

S:AddCallbackForAddon("TradeskillInfoUI", "TradeskillInfoUI", LoadSkin)