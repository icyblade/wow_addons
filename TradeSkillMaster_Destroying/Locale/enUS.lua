-- ------------------------------------------------------------------------------ --
--                           TradeSkillMaster_Destroying                          --
--           http://www.curse.com/addons/wow/tradeskillmaster_destroying          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- TradeSkillMaster_Destroying Locale - enUS
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/tradeskillmaster_destroying/localization/

local isDebug = false
--[===[@debug@
isDebug = true
--@end-debug@]===]
local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Destroying", "enUS", true, isDebug)
if not L then return end

L["Above Custom Price ('0c' to disable)"] = true
L["Above Vendor Sell Price"] = true
L["Average Result (per Destroy)"] = true
L["Averages"] = true
L["Combine Partial Stacks"] = true
L["Days of Log Data"] = true
L["Destroyed Item"] = true
L["Destroying Log"] = true
L["Destroying will not list any items above this quality for disenchanting."] = true
L["Destroy Next"] = true
L["Disenchanting Options"] = true
L["Enable Automatic Stack Combination"] = true
L["General Options"] = true
L["Here you can view all items in your bags which can be destroyed (disenchanted, milled, or prospected). They will be destroyed in the order they are listed (top to bottom)."] = true
L["Hiding frame for the remainder of this session. Typing '/tsm destroy' will open the frame again."] = true
L["_ Hr _ Min ago"] = true
L["If checked, Only disenchantable items which have a disenchant value above the vendor sell price will be displayed in the destroying window."] = true
L["If checked, partial stacks of herbs/ore will automatically be combined."] = true
L["If checked, soulbound items can be destroyed by TSM_Destroying. USE THIS WITH EXTREME CAUTION!"] = true
L["If checked, the Destroying window will automatically be shown when there's items to destroy in your bags. Otherwise, you can open it up by typing '/tsm destroy'."] = true
L["Ignored Item"] = true
L["Ignored Items"] = true
L["Ignoring all %s permanently. You can undo this in the Destroying options."] = true
L["Ignoring all %s this session (until your UI is reloaded)."] = true
L["Include Soulbound Items"] = true
L["Item"] = true
L["Make sure not to press any modifier keys when clicking the 'Destroy Next' button!"] = true
L["Maximum Disenchant Quality"] = true
L["now"] = true
L["Only disenchantable items which have a disenchant value ABOVE this custom price will be displayed in the destroying window."] = true
L["Opens the Destroying frame if there's stuff in your bags to be destroyed."] = true
L["Removed %s from the permanent ignore list."] = true
L["Result"] = true
L["Right click on this row to remove this item from the permanent ignore list."] = true
L["Select what format Destroying should use to display times in the Destroying log."] = true
L["Show Destroying Frame Automatically"] = true
L[ [=[%sLeft-Click|r to ignore an item for this session.
%sShift-Left-Click|r to ignore an item permanently. You can remove items from permanent ignore in the Destroying options.]=] ] = true
L["Spell"] = true
L["Stack Size"] = true
L["The destroying log will throw out any data that is older than this many days."] = true
L["This button will combine stacks to allow for maximum milling / prospecting."] = true
L["This button will destroy (disenchant, mill, or prospect) the next item in the list."] = true
L["Time"] = true
L["Time Format"] = true
L["Times Destroyed"] = true
