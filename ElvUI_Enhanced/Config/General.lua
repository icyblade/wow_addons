local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)
local EE = E:GetModule("ElvUI_Enhanced")
local M = E:GetModule("Enhanced_Misc")
local ETA = E:GetModule("Enhanced_TrainAll")
local EUB = E:GetModule("Enhanced_UndressButtons")
local EAL = E:GetModule("Enhanced_AlreadyKnown")

function EE:GeneralOptions()
	local config = {
		type = "group",
		name = L["General"],
		args = {
			pvpAutoRelease = {
				order = 1,
				type = "toggle",
				name = L["PvP Autorelease"],
				desc = L["Automatically release body when killed inside a battleground."],
				get = function(info) return E.db.enhanced.general.pvpAutoRelease end,
				set = function(info, value)
					E.db.enhanced.general.pvpAutoRelease = value
					M:AutoRelease()
				end
			},
			showQuestLevel = {
				order = 2,
				type = "toggle",
				name = L["Show Quest Level"],
				desc = L["Display quest levels at Quest Log."],
				get = function(info) return E.db.enhanced.general.showQuestLevel end,
				set = function(info, value)
					E.db.enhanced.general.showQuestLevel = value
					M:QuestLevelToggle()
				end
			},
			selectQuestReward = {
				order = 3,
				type = "toggle",
				name = L["Select Quest Reward"],
				desc = L["Automatically select the quest reward with the highest vendor sell value."],
				get = function(info) return E.db.enhanced.general.selectQuestReward end,
				set = function(info, value) E.db.enhanced.general.selectQuestReward = value end
			},
			declineDuel = {
				order = 4,
				type = "toggle",
				name = L["Decline Duel"],
				desc = L["Auto decline all duels"],
				get = function(info) return E.db.enhanced.general.declineDuel end,
				set = function(info, value)
					E.db.enhanced.general.declineDuel = value
					M:DeclineDuel()
				end
			},
			declineParty = {
				order = 5,
				type = "toggle",
				name = L["Decline Party"],
				desc = L["Auto decline party invites"],
				get = function(info) return E.db.enhanced.general.declineParty end,
				set = function(info, value)
					E.db.enhanced.general.declineParty = value
					M:DeclineParty()
				end
			},
			hideZoneText = {
				order = 6,
				type = "toggle",
				name = L["Hide Zone Text"],
				get = function(info) return E.db.enhanced.general.hideZoneText end,
				set = function(info, value)
					E.db.enhanced.general.hideZoneText = value
					M:HideZone()
				end
			},
			trainAllButton = {
 				order = 7,
 				type = "toggle",
				name = L["Train All Button"],
				desc = L["Add button to Trainer frame with ability to train all available skills in one click."],
				get = function(info) return E.db.enhanced.general.trainAllButton end,
				set = function(info, value)
					E.db.enhanced.general.trainAllButton = value
					ETA:ToggleState()
				end
			},
			undressButton = {
				order = 8,
				type = "toggle",
				name = L["Undress Button"],
				desc = L["Add button to Dressing Room frame with ability to undress model."],
				get = function(info) return E.db.enhanced.general.undressButton end,
				set = function(info, value)
					E.db.enhanced.general.undressButton = value
					EUB:ToggleState()
				end
			},
			alreadyKnown = {
				order = 9,
				type = "toggle",
				name = L["Already Known"],
				desc = L["Colorizes recipes, mounts & pets that are already known"],
				get = function(info) return E.db.enhanced.general.alreadyKnown end,
				set = function(info, value)
					E.db.enhanced.general.alreadyKnown = value
					EAL:ToggleState()
				end
			},
			altBuyMaxStack = {
				order = 10,
				type = "toggle",
				name = L["Alt-Click Merchant"],
				desc = L["Holding Alt key while buying something from vendor will now buy an entire stack."],
				get = function(info) return E.db.enhanced.general.altBuyMaxStack end,
				set = function(info, value)
					E.db.enhanced.general.altBuyMaxStack = value
					M:BuyStackToggle()
				end
			},
			merchantItemLevel = {
				order = 11,
				type = "toggle",
				name = L["Merchant ItemLevel"],
				desc = L["Display the item level on the MerchantFrame, to change the font you have to set it in ElvUI - Bags - ItemLevel"],
				get = function(info) return E.db.enhanced.general.merchantItemLevel end,
				set = function(info, value)
					E.db.enhanced.general.merchantItemLevel = value
					M:MerchantItemLevel()
				end
			},
			questItemLevel = {
				order = 12,
				type = "toggle",
				name = L["Quest ItemLevel"],
				desc = L["Display the item level on the Quest frames, to change the font you have to set it in ElvUI - Bags - ItemLevel"],
				get = function(info) return E.db.enhanced.general.questItemLevel end,
				set = function(info, value)
					E.db.enhanced.general.questItemLevel = value
					M:QuestItemLevel()
					E:StaticPopup_Show("PRIVATE_RL")
				end
			}
		}
	}

	return config
end