local E, L, V, P, G = unpack(ElvUI)
local AK = E:NewModule("Enhanced_AlreadyKnown", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local match = string.match
local ceil, fmod = math.ceil, math.fmod

local FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
local GetAuctionItemInfo = GetAuctionItemInfo
local GetAuctionItemLink = GetAuctionItemLink
local GetCurrentGuildBankTab = GetCurrentGuildBankTab
local GetGuildBankItemInfo = GetGuildBankItemInfo
local GetGuildBankItemLink = GetGuildBankItemLink
local GetInboxItem = GetInboxItem
local GetItemInfo = GetItemInfo
local GetNumQuestLogRewards = GetNumQuestLogRewards
local GetNumQuestRewards = GetNumQuestRewards
local GetNumQuestLogChoices = GetNumQuestLogChoices
local GetNumQuestChoices = GetNumQuestChoices
local GetQuestLogRewardSpell = GetQuestLogRewardSpell
local GetRewardSpell = GetRewardSpell
local GetQuestLogItemLink = GetQuestLogItemLink
local GetQuestItemLink = GetQuestItemLink
local GetQuestLogChoiceInfo = GetQuestLogChoiceInfo
local GetQuestItemInfo = GetQuestItemInfo
local GetMerchantNumItems = GetMerchantNumItems
local GetNumAuctionItems = GetNumAuctionItems
local GetAuctionItemClasses = GetAuctionItemClasses
local GetNumBuybackItems = GetNumBuybackItems
local GetMerchantItemInfo = GetMerchantItemInfo
local GetBuybackItemInfo = GetBuybackItemInfo
local GetBuybackItemLink = GetBuybackItemLink
local IsAddOnLoaded = IsAddOnLoaded
local SetItemButtonTextureVertexColor = SetItemButtonTextureVertexColor

local C_PetJournal_GetNumCollectedInfo = C_PetJournal.GetNumCollectedInfo

local BUYBACK_ITEMS_PER_PAGE = BUYBACK_ITEMS_PER_PAGE
local ITEM_PET_KNOWN = ITEM_PET_KNOWN
local ITEM_SPELL_KNOWN = ITEM_SPELL_KNOWN
local MERCHANT_ITEMS_PER_PAGE = MERCHANT_ITEMS_PER_PAGE

local battlePetString = gsub(gsub(ITEM_PET_KNOWN, "%(", "%%("), "%)", "%%)")

local knownColor = {r = 0.1, g = 1.0, b = 0.2}

local function MerchantFrame_UpdateMerchantInfo()
	local numItems = GetMerchantNumItems()

	for i = 1, BUYBACK_ITEMS_PER_PAGE do
		local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
		if index > numItems then return end

		local button = _G["MerchantItem"..i.."ItemButton"]

		if button and button:IsShown() then
			local _, _, _, _, numAvailable, isUsable = GetMerchantItemInfo(index)

			if isUsable and AK:IsAlreadyKnown(GetMerchantItemLink(index)) then
				local r, g, b = knownColor.r, knownColor.g, knownColor.b

				if numAvailable == 0 then
					r, g, b = r * 0.5, g * 0.5, b * 0.5
				end

				SetItemButtonTextureVertexColor(button, r, g, b)
			end
		end
	end
end

local function MerchantFrame_UpdateBuybackInfo()
	local numItems = GetNumBuybackItems()

	for i = 1, BUYBACK_ITEMS_PER_PAGE do
		if i > numItems then return end

		local button = _G["MerchantItem"..i.."ItemButton"]

		if button and button:IsShown() then
			local _, _, _, _, _, isUsable = GetBuybackItemInfo(i)

			if isUsable and AK:IsAlreadyKnown(GetBuybackItemLink(i)) then
				SetItemButtonTextureVertexColor(button, knownColor.r, knownColor.g, knownColor.b)
			end
		end
	end
end

local function AuctionFrameBrowse_Update()
	local numItems = GetNumAuctionItems("list")
	local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)

	for i = 1, NUM_BROWSE_TO_DISPLAY do
		local index = offset + i
		if index > numItems then return end

		local texture = _G["BrowseButton"..i.."ItemIconTexture"]

		if texture and texture:IsShown() then
			local _, _, _, _, canUse = GetAuctionItemInfo("list", index)

			if canUse and AK:IsAlreadyKnown(GetAuctionItemLink("list", index)) then
				texture:SetVertexColor(knownColor.r, knownColor.g, knownColor.b)
			end
		end
	end
end

local function AuctionFrameBid_Update()
	local numItems = GetNumAuctionItems("bidder")
	local offset = FauxScrollFrame_GetOffset(BidScrollFrame)

	for i = 1, NUM_BIDS_TO_DISPLAY do
		local index = offset + i
		if index > numItems then return end

		local texture = _G["BidButton"..i.."ItemIconTexture"]

		if texture and texture:IsShown() then
			local _, _, _, _, canUse = GetAuctionItemInfo("bidder", index)

			if canUse and AK:IsAlreadyKnown(GetAuctionItemLink("bidder", index)) then
				texture:SetVertexColor(knownColor.r, knownColor.g, knownColor.b)
			end
		end
	end
end

local function AuctionFrameAuctions_Update()
	local numItems = GetNumAuctionItems("owner")
	local offset = FauxScrollFrame_GetOffset(AuctionsScrollFrame)

	for i = 1, NUM_AUCTIONS_TO_DISPLAY do
		local index = offset + i
		if index > numItems then return end

		local texture = _G["AuctionsButton"..i.."ItemIconTexture"]

		if texture and texture:IsShown() then
			local _, _, _, _, canUse, _, _, _, _, _, _, _, saleStatus = GetAuctionItemInfo("owner", index)

			if canUse and AK:IsAlreadyKnown(GetAuctionItemLink("owner", index)) then
				local r, g, b = knownColor.r, knownColor.g, knownColor.b
				if saleStatus == 1 then
					r, g, b = r * 0.5, g * 0.5, b * 0.5
				end

				texture:SetVertexColor(r, g, b)
			end
		end
	end
end

local function GuildBankFrame_Update()
	if GuildBankFrame.mode ~= "bank" then return end

	local tab = GetCurrentGuildBankTab()

	for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
		local button = _G["GuildBankColumn"..ceil((i - 0.5) / NUM_SLOTS_PER_GUILDBANK_GROUP).."Button"..fmod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)]

		if button and button:IsShown() then
			local texture, _, locked = GetGuildBankItemInfo(tab, i)

			if texture and not locked then
				if AK:IsAlreadyKnown(GetGuildBankItemLink(tab, i)) then
					SetItemButtonTextureVertexColor(button, knownColor.r, knownColor.g, knownColor.b)
				else
					SetItemButtonTextureVertexColor(button, 1, 1, 1)
				end
			end
		end
	end
end

local function OpenMailFrame_UpdateButtonPositions()
	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		local button = _G["OpenMailAttachmentButton"..i]

		if button then
			local name, _, _, _, canUse = GetInboxItem(InboxFrame.openMailID, i)

			if name and canUse and AK:IsAlreadyKnown(GetInboxItemLink(InboxFrame.openMailID, i)) then
				SetItemButtonTextureVertexColor(button, knownColor.r, knownColor.g, knownColor.b)
			end
		end
	end
end

local function QuestInfo_Display()
	local numQuestRewards = QuestInfoFrame.questLog and GetNumQuestLogRewards() or GetNumQuestRewards()
	local numQuestChoices = QuestInfoFrame.questLog and GetNumQuestLogChoices() or GetNumQuestChoices()
	local numQuestSpellRewards = QuestInfoFrame.questLog and GetQuestLogRewardSpell() or GetRewardSpell()
	local rewardsCount = numQuestChoices + numQuestRewards + (numQuestSpellRewards and 1 or 0)

	if rewardsCount > 0 then
		for i = 1, rewardsCount do
			local item = _G["QuestInfoItem"..i]
			if item.objectType ~= "item" then return end

			local link = item.type and (QuestInfoFrame.questLog and GetQuestLogItemLink or GetQuestItemLink)(item.type, item:GetID())
			local _, _, _, _, isUsable = (QuestInfoFrame.questLog and GetQuestLogChoiceInfo or GetQuestItemInfo)(QuestInfoFrame.questLog and i or item.type, i)

			if isUsable and AK:IsAlreadyKnown(link) then
				SetItemButtonTextureVertexColor(item, knownColor.r, knownColor.g, knownColor.b)
			end
		end
	end
end

function AK:IsAlreadyKnown(itemLink)
	if not itemLink then return end

	local speciesID = match(itemLink, "battlepet:(%d+):")
	if speciesID then return C_PetJournal_GetNumCollectedInfo(speciesID) > 0 and true end

	local itemID = match(itemLink, "item:(%d+):")
	if self.knownTable[itemID] then return true end

	local _, _, _, _, _, itemType, itemSubType = GetItemInfo(itemLink)
	if not (self.knowableTypes[itemType] or self.knowableTypes[itemSubType]) then return end

	E.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	E.ScanTooltip:ClearLines()
	E.ScanTooltip:SetHyperlink(itemLink)
	E.ScanTooltip:Show()

	for i = 2, E.ScanTooltip:NumLines() do
		local line = _G["ElvUI_ScanTooltipTextLeft"..i]:GetText()

		if line == ITEM_SPELL_KNOWN or match(line, battlePetString) then
			self.knownTable[itemID] = true

			return true
		end
	end

	E.ScanTooltip:Hide()
end

function AK:ADDON_LOADED(_, addon)
	if addon == "Blizzard_AuctionUI" and not self.auctionHooked then
		self:SetHooks()
	elseif addon == "Blizzard_GuildBankUI" and not self.guildBankHooked then
		self:SetHooks()
	end

	if self.auctionHooked and self.guildBankHooked then
		self:UnregisterEvent("ADDON_LOADED")
	end
end

function AK:SetHooks()
	if not self:IsHooked("MerchantFrame_UpdateMerchantInfo") then
		self:SecureHook("MerchantFrame_UpdateMerchantInfo", MerchantFrame_UpdateMerchantInfo)
	end
	if not self:IsHooked("MerchantFrame_UpdateBuybackInfo") then
		self:SecureHook("MerchantFrame_UpdateBuybackInfo", MerchantFrame_UpdateBuybackInfo)
	end
	if not self:IsHooked("OpenMailFrame_UpdateButtonPositions") then
		self:SecureHook("OpenMailFrame_UpdateButtonPositions", OpenMailFrame_UpdateButtonPositions)
	end
	if not self:IsHooked("QuestInfo_Display") then
		self:SecureHook("QuestInfo_Display", QuestInfo_Display)
	end

	if not self.auctionHooked and IsAddOnLoaded("Blizzard_AuctionUI") then
		if not self:IsHooked("AuctionFrameBrowse_Update") then
			self:SecureHook("AuctionFrameBrowse_Update", AuctionFrameBrowse_Update)
		end
		if not self:IsHooked("AuctionFrameBid_Update") then
			self:SecureHook("AuctionFrameBid_Update", AuctionFrameBid_Update)
		end
		if not self:IsHooked("AuctionFrameAuctions_Update") then
			self:SecureHook("AuctionFrameAuctions_Update", AuctionFrameAuctions_Update)
		end

		self.auctionHooked = true
	end

	if not self.guildBankHooked and IsAddOnLoaded("Blizzard_GuildBankUI") then
		if not self:IsHooked("GuildBankFrame_Update") then
			self:SecureHook("GuildBankFrame_Update", GuildBankFrame_Update)
		end

		self.guildBankHooked = true
	end
end

function AK:IsLoadeble()
	return not (IsAddOnLoaded("RecipeKnown") or IsAddOnLoaded("AlreadyKnown"))
end

function AK:ToggleState()
	if not self:IsLoadeble() then return end

	if not self.initialized then
		self.knownTable = {}

		local _, _, _, consumable, glyph, _, recipe, _, miscallaneous = GetAuctionItemClasses()
		local _, _, pet, _, _, mount = GetAuctionItemSubClasses(9)
		self.knowableTypes = {
			[consumable] = true,
			[glyph] = true,
			[recipe] = true,
			[miscallaneous] = true,
			[pet] = true,
			[mount] = true
		}

		self.initialized = true
	end

	if E.db.enhanced.general.alreadyKnown then
		self:SetHooks()

		if not (IsAddOnLoaded("Blizzard_AuctionUI") and IsAddOnLoaded("Blizzard_GuildBankUI")) then
			self:RegisterEvent("ADDON_LOADED")
		end
	else
		self:UnhookAll()

		self.auctionHooked = nil
		self.guildBankHooked = nil
	end
end

function AK:Initialize()
	if not E.db.enhanced.general.alreadyKnown then return end

	self:ToggleState()
end

local function InitializeCallback()
	AK:Initialize()
end

E:RegisterModule(AK:GetName(), InitializeCallback)