local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Pr = SLE:GetModule("Professions")
local B = E:GetModule("Bags")
local lib = LibStub("LibProcessable")
--GLOBALS: hooksecurefunc, CreateFrame
local _G = _G
local VIDEO_OPTIONS_ENABLED, VIDEO_OPTIONS_DISABLED = VIDEO_OPTIONS_ENABLED, VIDEO_OPTIONS_DISABLED
local LOCKED = LOCKED
local ActionButton_ShowOverlayGlow, ActionButton_HideOverlayGlow = ActionButton_ShowOverlayGlow, ActionButton_HideOverlayGlow
local AutoCastShine_AutoCastStart, AutoCastShine_AutoCastStop = AutoCastShine_AutoCastStart, AutoCastShine_AutoCastStop

Pr.DeconstructMode = false
local relicItemTypeLocalized, relicItemSubTypeLocalized
Pr.ItemTable = {
	--Various lockboxes
	["Pick"]={
		["4632"]=1,["4633"]=25,["4634"]=70,["4636"]=125,["4637"]=175,["4638"]=225,
		["5758"]=225,["5759"]=225,["5760"]=225,["6354"]=1,["6355"]=70,
		["12033"]=275,["13875"]=175,["13918"]=250,["16882"]=1,["16883"]=70,
		["16884"]=175,["16885"]=250,["29569"]=300,["31952"]=325,["43575"]=350,
		["43622"]=375,["43624"]=400,["45986"]=400,["63349"]=425,["68729"]=425,
		["88165"]=450,["88567"]=450,
		["116920"] = 500,["121331"] = 550,
	},
	--Stuff that can't be DEed or should not be by default
	["DoNotDE"]={
		["49715"] = true, --Rose helm
		["44731"] = true, --Rose offhand
		["21524"] = true, --Red winter veil hat
		["51525"] = true, --Green winter vail hat
		["70923"] = true, --Sweater
		["34486"] = true, --Orgri achieve fish
		["11287"] = true, --Lesser Magic Wand
		["11288"] = true, --Greater Magic Wand
		["116985"] = true, --Archeology Mail Hat
		["136629"] = true, --Eng reagent rifle
		["136630"] = true, --Eng reagent rifle 2
	},
	--Bnet bound treasures in Pandaria
	["PandariaBoA"] = {
		["85776"] = true,["85777"] = true,["86124"] = true,["86196"] = true,["86198"] = true,
		["86199"] = true,["86218"] = true,["86394"] = true,["86518"] = true,["86519"] = true,
		["86520"] = true,["86521"] = true,["86522"] = true,["86523"] = true,["86524"] = true,
		["86527"] = true,["86529"] = true,["88723"] = true,
		["86525"] = true, --Not really a BoA but still a powerful shit
		["86526"] = true, --Not really a BoA but still a powerful shit
	},
	--Stuff with cooking bonus
	["Cooking"] = {
		["46349"] = true, --Chef's Hat
		["86559"] = true, --Frying Pan
		["86558"] = true, --Rolling Pin
		["86468"] = true, --Apron
	},
	--Stuff for fishing
	["Fishing"] = {
		["33820"] = true, --Weather-Beaten Fishing Hat
		["118393"] = true, --Tentacled Hat
		["19022"] = true, --Nat Pagle's Extreme Angler FC-5000
		["19970"] = true, --Arcanite Fishing Pole
		["25978"] = true, --Seth's Graphite Fishing Pole
		["44050"] = true, --Mastercraft Kalu'ak Fishing Pole
		["45858"] = true, --Nat's Lucky Fishing Pole
		["45991"] = true, --Bone Fishing Pole
		["45992"] = true, --Jeweled Fishing Pole
	},
	--Quest dis
	["Quest"] = {
		["137195"] = true, --Highmountain armor
		["137221"] = true, --Ravencrest sigil
		["137286"] = true, --Demon runes
	},
}
Pr.Keys = {
	[T.GetSpell(195809)] = true, -- jeweled lockpick
	[T.GetSpell(130100)] = true, -- Ghostly Skeleton Key
	[T.GetSpell(94574)] = true, -- Obsidium Skeleton Key
	[T.GetSpell(59403)] = true, -- Titanium Skeleton Key
	[T.GetSpell(59404)] = true, -- Colbat Skeleton Key
	[T.GetSpell(20709)] = true, -- Arcanite Skeleton Key
	[T.GetSpell(19651)] = true, -- Truesilver Skeleton Key
	[T.GetSpell(19649)] = true, -- Golden Skeleton Key
	[T.GetSpell(19646)] = true, -- Silver Skeleton Key
}
Pr.BlacklistDE = {}
Pr.BlacklistLOCK = {}

local function HaveKey()
	for key in T.pairs(Pr.Keys) do
		if(T.GetItemCount(key) > 0) then
			return key
		end
	end
end

function Pr:Blacklisting(skill)
	local ignoreItems = E.global.sle[skill].Blacklist
	ignoreItems = T.gsub(ignoreItems, ',%s', ',') --remove spaces that follow a comma
	Pr["BuildBlacklist"..skill](self, T.split(",", ignoreItems))
end

function Pr:BuildBlacklistDE(...)
	T.twipe(Pr.BlacklistDE)
	for index = 1, T.select('#', ...) do
		local name = T.select(index, ...)
		local isLink = T.GetItemInfo(name)
		if isLink then
			Pr.BlacklistDE[isLink] = true
		end
	end
end

function Pr:BuildBlacklistLOCK(...)
	T.twipe(Pr.BlacklistLOCK)
	for index = 1, T.select('#', ...) do
		local name = T.select(index, ...)
		local isLink = T.GetItemInfo(name)
		if isLink then
			Pr.BlacklistLOCK[isLink] = true
		end
	end
end

function Pr:ApplyDeconstruct(itemLink, spell, spellType, r, g, b)
	local slot = T.GetMouseFocus()
	local bag = slot:GetParent():GetID()
	if not _G["ElvUI_ContainerFrame"].Bags[bag] then return end
	Pr.DeconstructionReal.Bag = bag
	Pr.DeconstructionReal.Slot = slot:GetID()
	if (E.global.sle.LOCK.TradeOpen and T.GetTradeTargetItemLink(7) == itemLink and _G["GameTooltip"]:GetOwner():GetName() == "TradeRecipientItem7ItemButton") then
			Pr.DeconstructionReal.ID = T.match(itemLink, 'item:(%d+):')
			Pr.DeconstructionReal:SetAttribute('type1', 'macro')
			Pr.DeconstructionReal:SetAttribute('macrotext', T.format('/cast %s\n/run ClickTargetTradeButton(7)', spell))
			Pr.DeconstructionReal:SetAllPoints(_G["TradeRecipientItem7ItemButton"])
			Pr.DeconstructionReal:Show()
			
			if E.private.sle.professions.deconButton.style == "BIG" then
				ActionButton_ShowOverlayGlow(Pr.DeconstructionReal)
			elseif E.private.sle.professions.deconButton.style == "SMALL" then
				AutoCastShine_AutoCastStart(Pr.DeconstructionReal, r, g, b)
			end
		-- end
	elseif (T.GetContainerItemLink(bag, slot:GetID()) == itemLink) then
		Pr.DeconstructionReal.ID = T.match(itemLink, 'item:(%d+):')
		Pr.DeconstructionReal:SetAttribute("type1",spellType)
		Pr.DeconstructionReal:SetAttribute(spellType, spell)
		Pr.DeconstructionReal:SetAttribute('target-bag', bag)
		Pr.DeconstructionReal:SetAttribute('target-slot', slot:GetID())
		Pr.DeconstructionReal:SetAllPoints(slot)
		Pr.DeconstructionReal:Show()

		if E.private.sle.professions.deconButton.style == "BIG" then
			ActionButton_ShowOverlayGlow(Pr.DeconstructionReal)
		elseif E.private.sle.professions.deconButton.style == "SMALL" then
			AutoCastShine_AutoCastStart(Pr.DeconstructionReal, r, g, b)
		end
	end
end

function Pr:IsBreakable(link)
	if not link then return false end
	local name, _, quality, ilvl,_,_,_,_,equipSlot = T.GetItemInfo(link)
	local item = T.match(link, 'item:(%d+):')
	if(T.IsEquippableItem(link) and quality and quality > 1 and quality < 5 and equipSlot ~= "INVTYPE_BAG") then
		if E.global.sle.DE.IgnoreTabards and equipSlot == "INVTYPE_TABARD" then return false end
		if Pr.ItemTable["DoNotDE"][item] then return false end
		if Pr.ItemTable["PandariaBoA"][item] and E.global.sle.DE.IgnorePanda then return false end
		if Pr.ItemTable["Cooking"][item] and E.global.sle.DE.IgnoreCooking then return false end
		if Pr.ItemTable["Fishing"][item] and E.global.sle.DE.IgnoreFishing then return false end
		if Pr.BlacklistDE[name] then return false end
		return true
	end 
	return false
end

--[[function Pr:LockSkill(id)
	if E.myclass == "ROGUE" then
		if Pr.ItemTable["Pick"][id] <= (T.UnitLevel("player") * 5) then return true end
	end
	return false
end

function Pr:IsLocked(link)
	local name = T.GetItemInfo(link)
	local id = T.match(link, 'item:(%d+)')
	if (Pr.ItemTable["Pick"][id] and not Pr.BlacklistLOCK[name] and Pr:LockSkill(id)) then return true end
	return false
end]]

function Pr:IsUnlockable(itemLink)
	local slot = T.GetMouseFocus()
	local bag = slot:GetParent():GetID()
	local item = _G["TradeFrame"]:IsShown() and T.GetTradeTargetItemLink(7) or T.select(7, T.GetContainerItemInfo(bag, slot:GetID()))
	if(item == itemLink) then
		for index = 2, _G["GameTooltip"]:NumLines() do
			local info = _G['GameTooltipTextLeft' .. index]:GetText()
			if info == LOCKED then
				return true
			end
		end
	end
	return false
end

function Pr:DeconstructParser(tt)
	if not Pr.DeconstructMode then return end
	local item, link = tt:GetItem()
	if not link then return end
	local itemString = T.match(link, "item[%-?%d:]+")
	if not itemString then return end
	local _, id = T.split(":", itemString)
	if not id or id == "" then return end
	if(item and not T.InCombatLockdown()) and (Pr.DeconstructMode == true or (E.global.sle.LOCK.TradeOpen and self:GetOwner():GetName() == "TradeRecipientItem7ItemButton")) then
		local r, g, b
		if lib:IsOpenable(id) and Pr:IsUnlockable(link) then
			r, g, b = 0, 1, 1
			Pr:ApplyDeconstruct(link, Pr.LOCKname, "spell", r, g, b)
		elseif lib:IsOpenableProfession(id) and Pr:IsUnlockable(link) then
			r, g, b = 0, 1, 1
			local hasKey = HaveKey()
			Pr:ApplyDeconstruct(link, hasKey, "item", r, g, b)
		elseif lib:IsProspectable(id) then
			r, g, b = 1, 0, 0
			Pr:ApplyDeconstruct(link, Pr.PROSPECTname, "spell", r, g, b)
		elseif lib:IsMillable(id) then
			r, g, b = 1, 0, 0
			Pr:ApplyDeconstruct(link, Pr.MILLname, "spell", r, g, b)
		elseif Pr.DEname then
			local isArtRelic, class, subclass
			local normalItem = (lib:IsDisenchantable(id) and Pr:IsBreakable(link))
			if not normalItem then
				class, subclass = T.select(6, T.GetItemInfo(item))
				isArtRelic = (class == relicItemTypeLocalized and subclass == relicItemSubTypeLocalized)
			end
			if normalItem or Pr.ItemTable["Quest"][id] or isArtRelic then
				r, g, b = 1, 0, 0
				Pr:ApplyDeconstruct(link, Pr.DEname, "spell", r, g, b)
			end
		end
	end
end

function Pr:GetDeconMode()
	local text = ""
	if Pr.DeconstructMode then
		text = "|cff00FF00 "..VIDEO_OPTIONS_ENABLED.."|r"
	else
		text = "|cffFF0000 "..VIDEO_OPTIONS_DISABLED.."|r"
	end
	return text
end

function Pr:Construct_BagButton()
	Pr.DeconstructButton = CreateFrame("Button", "SLE_DeconButton", _G["ElvUI_ContainerFrame"])
	Pr.DeconstructButton:SetSize(16 + E.Border, 16 + E.Border)
	Pr.DeconstructButton:SetTemplate()
	Pr.DeconstructButton.ttText = L["Deconstruct Mode"]
	Pr.DeconstructButton.ttText2 = T.format(L["Allow you to disenchant/mill/prospect/unlock items.\nClick to toggle.\nCurrent state: %s."], Pr:GetDeconMode())
	Pr.DeconstructButton:SetScript("OnEnter", B.Tooltip_Show)
	Pr.DeconstructButton:SetScript("OnLeave", B.Tooltip_Hide)
	Pr.DeconstructButton:SetPoint("RIGHT", _G["ElvUI_ContainerFrame"].bagsButton, "LEFT", -5, 0)
	Pr.DeconstructButton:SetNormalTexture("Interface\\ICONS\\INV_Rod_Cobalt")
	Pr.DeconstructButton:GetNormalTexture():SetTexCoord(T.unpack(E.TexCoords))
	Pr.DeconstructButton:GetNormalTexture():SetInside()

	Pr.DeconstructButton:StyleButton(nil, true)
	Pr.DeconstructButton:SetScript("OnClick", function(self,...)
		Pr.DeconstructMode = not Pr.DeconstructMode
		if Pr.DeconstructMode then
			Pr.DeconstructButton:SetNormalTexture("Interface\\ICONS\\INV_Rod_EnchantedCobalt")
			if E.private.sle.professions.deconButton.buttonGlow then ActionButton_ShowOverlayGlow(Pr.DeconstructButton) end
		else
			Pr.DeconstructButton:SetNormalTexture("Interface\\ICONS\\INV_Rod_Cobalt")
			ActionButton_HideOverlayGlow(Pr.DeconstructButton)
		end
		Pr.DeconstructButton.ttText2 = T.format(L["Allow you to disenchant/mill/prospect/unlock items.\nClick to toggle.\nCurrent state: %s."], Pr:GetDeconMode())
		B.Tooltip_Show(self)
	end)
	--Moving Elv's stuff
	_G["ElvUI_ContainerFrame"].vendorGraysButton:SetPoint("RIGHT", Pr.DeconstructButton, "LEFT", -5, 0)
end

function Pr:ConstructRealDecButton()
	Pr.DeconstructionReal = CreateFrame('Button', "SLE_DeconReal", E.UIParent, 'SecureActionButtonTemplate, AutoCastShineTemplate')
	Pr.DeconstructionReal:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
	Pr.DeconstructionReal:RegisterForClicks('AnyUp')
	Pr.DeconstructionReal:SetFrameStrata("TOOLTIP")
	Pr.DeconstructionReal.TipLines = {}

	Pr.DeconstructionReal.OnLeave = function(self)
		if(T.InCombatLockdown()) then
			self:SetAlpha(0)
			self:RegisterEvent('PLAYER_REGEN_ENABLED')
		else
			self:ClearAllPoints()
			self:SetAlpha(1)
			if _G["GameTooltip"] then _G["GameTooltip"]:Hide() end
			self:Hide()
			AutoCastShine_AutoCastStop(self)
			ActionButton_HideOverlayGlow(self)
		end
	end

	Pr.DeconstructionReal.SetTip = function(self)
		_G["GameTooltip"]:SetOwner(self,"ANCHOR_LEFT",0,4)
		_G["GameTooltip"]:ClearLines()
		_G["GameTooltip"]:SetBagItem(self.Bag, self.Slot)
	end

	Pr.DeconstructionReal:SetScript("OnEnter", Pr.DeconstructionReal.SetTip)
	Pr.DeconstructionReal:SetScript("OnLeave", function() Pr.DeconstructionReal:OnLeave() end)
	Pr.DeconstructionReal:Hide()

	function Pr.DeconstructionReal:PLAYER_REGEN_ENABLED()
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		Pr.DeconstructionReal:OnLeave()
	end
end

local function Get_ArtRelic()
	local noItem = false
	if T.select(2, T.GetItemInfo(132342)) == nil then noItem = true end
	if noItem then
		E:Delay(5, Get_ArtRelic)
	else
		relicItemTypeLocalized, relicItemSubTypeLocalized = select(6, GetItemInfo(132342))
	end
end

function Pr:InitializeDeconstruct()
	if not E.private.bags.enable then return end
	Pr:Construct_BagButton()
	Pr:ConstructRealDecButton()

	local function Hiding()
		Pr.DeconstructMode = false
		Pr.DeconstructButton:SetNormalTexture("Interface\\ICONS\\INV_Rod_Cobalt")
		ActionButton_HideOverlayGlow(Pr.DeconstructButton)
		Pr.DeconstructionReal:OnLeave()
	end

	_G["ElvUI_ContainerFrame"]:HookScript("OnHide", Hiding)

	self:SecureHookScript(GameTooltip, "OnTooltipSetItem", "DeconstructParser")

	Pr:Blacklisting("DE")
	Pr:Blacklisting("LOCK")

	Get_ArtRelic()
end
