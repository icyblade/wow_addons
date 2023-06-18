local E, L, V, P, G = unpack(ElvUI)
local AS = E:NewModule("AddOnSkins")
local EP = E.Libs.EP

local AddOnName = ...

local lower = string.lower

local GetAddOnInfo = GetAddOnInfo
local GetNumAddOns = GetNumAddOns

AS.addOns = {}

for i = 1, GetNumAddOns() do
	local name, _, _, enabled = GetAddOnInfo(i)
	AS.addOns[lower(name)] = enabled ~= nil
end

function AS:CheckAddOn(addon)
	return AS.addOns[lower(addon)] or false
end

function AS:DBConversions()
	-- Embed
	if E.db.addOnSkins.embed.left then
		E.db.addOnSkins.embed.leftWindow = E.db.addOnSkins.embed.left
		E.db.addOnSkins.embed.left = nil
	end
	if E.db.addOnSkins.embed.right then
		E.db.addOnSkins.embed.rightWindow = E.db.addOnSkins.embed.right
		E.db.addOnSkins.embed.right = nil
	end
	if E.db.addOnSkins.embed.leftWidth then
		E.db.addOnSkins.embed.leftWindowWidth = E.db.addOnSkins.embed.leftWidth
		E.db.addOnSkins.embed.leftWidth = nil
	end
	if type(E.db.addOnSkins.embed.rightChat) == "boolean" then
		E.db.addOnSkins.embed.rightChatPanel = E.db.addOnSkins.embed.rightChat
		E.db.addOnSkins.embed.rightChat = nil
	end
	if type(E.db.addOnSkins.embed.belowTop) == "boolean" then
		E.db.addOnSkins.embed.belowTopTab = E.db.addOnSkins.embed.belowTop
		E.db.addOnSkins.embed.belowTop = nil
	end
	E.db.addOnSkins.embed.isShow = nil

	-- Skada
	if E.db.addOnSkins.skadaBackdrop then
		E.db.addOnSkins.skada.backdrop = E.db.addOnSkins.skadaBackdrop
		E.db.addOnSkins.skadaBackdrop = nil
	end
	if E.db.addOnSkins.skadaTemplate then
		E.db.addOnSkins.skada.template = E.db.addOnSkins.skadaTemplate
		E.db.addOnSkins.skadaTemplate = nil
	end
	if E.db.addOnSkins.skadaTemplateGloss then
		E.db.addOnSkins.skada.templateGloss = E.db.addOnSkins.skadaTemplateGloss
		E.db.addOnSkins.skadaTemplateGloss = nil
	end
	if E.db.addOnSkins.skadaTitleBackdrop then
		E.db.addOnSkins.skada.titleBackdrop = E.db.addOnSkins.skadaTitleBackdrop
		E.db.addOnSkins.skadaTitleBackdrop = nil
	end
	if E.db.addOnSkins.skadaTitleTemplate then
		E.db.addOnSkins.skada.titleTemplate = E.db.addOnSkins.skadaTitleTemplate
		E.db.addOnSkins.skadaTitleTemplate = nil
	end
	if E.db.addOnSkins.skadaTitleTemplateGloss then
		E.db.addOnSkins.skada.titleTemplateGloss = E.db.addOnSkins.skadaTitleTemplateGloss
		E.db.addOnSkins.skadaTitleTemplateGloss = nil
	end

	-- DBM
	if E.db.addOnSkins.dbmBarHeight then
		E.db.addOnSkins.dbm.barHeight = E.db.addOnSkins.dbmBarHeight
		E.db.addOnSkins.dbmBarHeight = nil
	end
	if E.db.addOnSkins.dbmFont then
		E.db.addOnSkins.dbm.font = E.db.addOnSkins.dbmFont
		E.db.addOnSkins.dbmFont = nil
	end
	if E.db.addOnSkins.dbmFontSize then
		E.db.addOnSkins.dbm.fontSize = E.db.addOnSkins.dbmFontSize
		E.db.addOnSkins.dbmFontSize = nil
	end
	if E.db.addOnSkins.dbmFontOutline then
		E.db.addOnSkins.dbm.fontOutline = E.db.addOnSkins.dbmFontOutline
		E.db.addOnSkins.dbmFontOutline = nil
	end

	-- Weak Auras
	if E.db.addOnSkins.weakAuraAuraBar then
		E.db.addOnSkins.weakAura.auraBar = E.db.addOnSkins.weakAuraAuraBar
		E.db.addOnSkins.weakAuraAuraBar = nil
	end
	if E.db.addOnSkins.weakAuraIconCooldown then
		E.db.addOnSkins.weakAura.iconCooldown = E.db.addOnSkins.weakAuraIconCooldown
		E.db.addOnSkins.weakAuraIconCooldown = nil
	end
end

function AS:Initialize()
	EP:RegisterPlugin(AddOnName, AS.InsertOptions)

	AS:DBConversions()
end

local function InitializeCallback()
	AS:Initialize()
end

E:RegisterModule(AS:GetName(), InitializeCallback) 