local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.trade ~= true then return end

	local TradeFrame = _G["TradeFrame"]
	TradeFrame:StripTextures(true)
	TradeFrame:CreateBackdrop("Transparent")
	TradeFrame.backdrop:SetAllPoints()
	TradeFrameInset:Kill()
	S:HandleButton(TradeFrameTradeButton, true)
	S:HandleButton(TradeFrameCancelButton, true)
	S:HandleCloseButton(TradeFrameCloseButton, TradeFrame.backdrop)

	S:HandleEditBox(TradePlayerInputMoneyFrameGold)
	S:HandleEditBox(TradePlayerInputMoneyFrameSilver)
	S:HandleEditBox(TradePlayerInputMoneyFrameCopper)
	TradeRecipientItemsInset:Kill()
	TradePlayerItemsInset:Kill()
	TradePlayerInputMoneyInset:Kill()
	TradePlayerEnchantInset:Kill()
	TradeRecipientEnchantInset:Kill()
	TradeRecipientMoneyInset:Kill()
	TradeRecipientMoneyBg:Kill()

	for i=1, 7 do
		local player = _G["TradePlayerItem"..i]
		local recipient = _G["TradeRecipientItem"..i]
		local player_button = _G["TradePlayerItem"..i.."ItemButton"]
		local recipient_button = _G["TradeRecipientItem"..i.."ItemButton"]
		local player_button_icon = _G["TradePlayerItem"..i.."ItemButtonIconTexture"]
		local recipient_button_icon = _G["TradeRecipientItem"..i.."ItemButtonIconTexture"]

		if player_button and recipient_button then
			player:StripTextures()
			recipient:StripTextures()
			player_button:StripTextures()
			recipient_button:StripTextures()

			player_button_icon:SetInside(player_button)
			player_button_icon:SetTexCoord(unpack(E.TexCoords))
			player_button:SetTemplate("Default", true)
			player_button:StyleButton()
			player_button.IconBorder:SetAlpha(0)
			player_button.bg = CreateFrame("Frame", nil, player_button)
			player_button.bg:SetTemplate("Default")
			player_button.bg:Point("TOPLEFT", player_button, "TOPRIGHT", 4, 0)
			player_button.bg:Point("BOTTOMRIGHT", _G["TradePlayerItem"..i.."NameFrame"], "BOTTOMRIGHT", 0, 14)
			player_button.bg:SetFrameLevel(player_button:GetFrameLevel() - 3)
			player_button:SetFrameLevel(player_button:GetFrameLevel() - 1)

			recipient_button_icon:SetInside(recipient_button)
			recipient_button_icon:SetTexCoord(unpack(E.TexCoords))
			recipient_button:SetTemplate("Default", true)
			recipient_button:StyleButton()
			recipient_button.IconBorder:SetAlpha(0)
			recipient_button.bg = CreateFrame("Frame", nil, recipient_button)
			recipient_button.bg:SetTemplate("Default")
			recipient_button.bg:Point("TOPLEFT", recipient_button, "TOPRIGHT", 4, 0)
			recipient_button.bg:Point("BOTTOMRIGHT", _G["TradeRecipientItem"..i.."NameFrame"], "BOTTOMRIGHT", 0, 14)
			recipient_button.bg:SetFrameLevel(recipient_button:GetFrameLevel() - 3)
			recipient_button:SetFrameLevel(recipient_button:GetFrameLevel() - 1)

			-- Player Icon Border
			hooksecurefunc(player_button.IconBorder, 'SetVertexColor', function(self, r, g, b)
				self:GetParent():SetBackdropBorderColor(r, g, b)
				self:SetTexture("")
			end)
			hooksecurefunc(player_button.IconBorder, 'Hide', function(self)
				self:GetParent():SetBackdropBorderColor(unpack(E.media.bordercolor))
			end)
			-- Recipient Icon Border
			hooksecurefunc(recipient_button.IconBorder, 'SetVertexColor', function(self, r, g, b)
				self:GetParent():SetBackdropBorderColor(r, g, b)
				self:SetTexture("")
			end)
			hooksecurefunc(recipient_button.IconBorder, 'Hide', function(self)
				self:GetParent():SetBackdropBorderColor(unpack(E.media.bordercolor))
			end)
		end
	end

	TradeHighlightPlayerTop:SetColorTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerBottom:SetColorTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerMiddle:SetColorTexture(0, 1, 0, 0.2)
	TradeHighlightPlayer:SetFrameStrata("HIGH")

	TradeHighlightPlayerEnchantTop:SetColorTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerEnchantBottom:SetColorTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerEnchantMiddle:SetColorTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerEnchant:SetFrameStrata("HIGH")

	TradeHighlightRecipientTop:SetColorTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientBottom:SetColorTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientMiddle:SetColorTexture(0, 1, 0, 0.2)
	TradeHighlightRecipient:SetFrameStrata("HIGH")

	TradeHighlightRecipientEnchantTop:SetColorTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientEnchantBottom:SetColorTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientEnchantMiddle:SetColorTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientEnchant:SetFrameStrata("HIGH")
end

S:AddCallback("Trade", LoadSkin)