-- ------------------------------------------------------------------------------ --
--                            TradeSkillMaster_Mailing                            --
--            http://www.curse.com/addons/wow/tradeskillmaster_mailing            --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- TradeSkillMaster_Mailing Locale - enUS
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/tradeskillmaster_mailing/localization/

local isDebug = false
--[===[@debug@
isDebug = true
--@end-debug@]===]
local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Mailing", "enUS", true, isDebug)
if not L then return end

L["AH Mail:"] = true
L[ [=[Automatically rechecks mail every 60 seconds when you have too much mail.

If you loot all mail with this enabled, it will wait and recheck then keep auto looting.]=] ] = true
L["Auto Recheck Mail"] = true
L["BE SURE TO SPELL THE NAME CORRECTLY!"] = true
L["Bought %sx%d for %s from %s"] = true
L["Buys"] = true
L["Buy: %s (%d) | %s | %s"] = true
L["Cancelled auction of %sx%d"] = true
L["Cancels"] = true
L["Cannot finish auto looting, inventory is full or too many unique items."] = true
L[ [=[|cff99ffffShift-Click|r to automatically re-send after the amount of time specified in the TSM_Mailing options.
|cff99ffffCtrl-Click|r to perform a dry-run where Mailing doesn't send anything, but prints out what it would send (useful for testing your operations).]=] ] = true
L["Clear"] = true
L["Clicking this button clears the item box."] = true
L["Click this button to automatically mail items in the groups which you have selected."] = true
L["Click this button to mail the item to the specified character."] = true
L["Click this button to send all disenchantable items in your bags to the specified character. You can set the maximum quality to be sent in the options."] = true
L["Click this button to send excess gold to the specified character (Maximum of 200k per mail)."] = true
L["COD Amount (per Item):"] = true
L["COD: %s | %s | (%s) | %s | %s"] = true
L["Could not loot item from mail because your bags are full."] = true
L["Could not send mail due to not having free bag space available to split a stack of items."] = true
L["Default Mailing Page"] = true
L["Delete Empty NPC Mail"] = true
L["Display Total Money Received"] = true
L["Done sending mail."] = true
L["Drag (or place) the item that you want to send into this editbox."] = true
L["Enable Inbox Chat Messages"] = true
L["Enable Sending Chat Messages"] = true
L["Enter name of the character disenchantable items should be sent to."] = true
L["Enter the desired COD amount (per item) to send this item with. Setting this to '0c' will result in no COD being set."] = true
L["Enter the name of the player you want to send excess gold to."] = true
L["Enter the name of the player you want to send this item to."] = true
L["Expired: %s | %s"] = true
L["Expires"] = true
L["Failed to send mail:"] = true
L["General"] = true
L["General Settings"] = true
L["Here you can select groups with TSM_Mailing operations to be automatically mailed to other characters."] = true
L["If checked, a maximum quantity to send to the target can be set. Otherwise, Mailing will send as many as it can."] = true
L["If checked, a 'Reload UI' button will be shown while waiting for the inbox to refresh. Reloading will cause the mailbox to refresh and may be faster than waiting for the next refresh."] = true
L["If checked, information on mails collected by TSM_Mailing will be printed out to chat."] = true
L["If checked, information on mails sent by TSM_Mailing will be printed out to chat."] = true
L["If checked, mail from NPCs which have no attachments will automatically be deleted."] = true
L["If checked, the Mailing tab of the mailbox will be the default tab."] = true
L["If checked, the target's current inventory will be taken into account when determing how many to send. For example, if the max quantity is set to 10, and the target already has 3, Mailing will send at most 7 items."] = true
L["If checked, the total amount of gold received will be shown at the end of automatically collecting mail."] = true
L["Inbox Settings"] = true
L["Inbox update in %d seconds."] = true
L["Item (Drag Into Box):"] = true
L["Keep Free Bag Space"] = true
L["Keep Quantity"] = true
L["Lastly, click this button to send the mail."] = true
L["Limit (In Gold):"] = true
L["Lists the groups with mailing operations. Left click to select/deselect the group, Right click to expand/collapse the group."] = true
L["Mail Disenchantables"] = true
L["Mail Disenchantables Maximum Quality"] = true
L["Mailing all to %s."] = true
L["Mailing operations contain settings for easy mailing of items to other characters."] = true
L["Mailing up to %d to %s."] = true
L["Mailing will keep this number of items in the current player's bags and not mail them to the target."] = true
L["Mailing will not send any disenchantable items above this quality to the target player."] = true
L["Mailing would send the following items to %s:"] = true
L["Mail Selected Groups"] = true
L["Mail Send Delay"] = true
L["Make Mailing Default Mail Tab"] = true
L["Maximum Quantity"] = true
L["Max Quantity:"] = true
L["Move Group To Bags"] = true
L["Move Group to Bank"] = true
L["Move Non Group Items to Bank"] = true
L["Move Target Shortfall To Bags"] = true
L["Multiple Items"] = true
L["No Item Specified"] = true
L["No Target Player"] = true
L["No Target Specified"] = true
L["Nothing to Move"] = true
L["Not sending any gold as you either did not enter a limit or did not press enter to store the limit."] = true
L["Not sending any gold as you have less than the specified limit."] = true
L["Not Target Specified"] = true
L["Open All Mail"] = true
L["Open Mail Complete Sound"] = true
L["Opens all mail containing canceled auctions."] = true
L["Opens all mail containing expired auctions."] = true
L["Opens all mail containing gold from sales."] = true
L["Opens all mail containing items you have bought."] = true
L["Opens all mail in your inbox. If you have more than 50 items in your inbox, the opening will automatically continue when the inbox refreshes."] = true
L["Operation Settings"] = true
L["Optionally specify a per-item COD amount."] = true
L["Play the selected sound when Mailing is done opening all mail."] = true
L["Preparing to Move"] = true
L["Quick Send"] = true
L["Restart Delay (minutes)"] = true
L["Restock Target to Max Quantity"] = true
L["Sales"] = true
L["Sale: %s (%d) | %s | %s"] = true
L["Send all %s to %s - No COD"] = true
L["Send all %s to %s - %s per Item COD"] = true
L["Send Disenchantable Items to %s"] = true
L["Send Excess Gold to Banker"] = true
L["Send Excess Gold to %s"] = true
L["Sending..."] = true
L["Sending Settings"] = true
L["Send Items Individually"] = true
L["Sends each unique item in a seperate mail."] = true
L["Send %sx%d to %s - No COD"] = true
L["Send %sx%d to %s - %s per Item COD"] = true
L["Sent all disenchantable items to %s."] = true
L["Sent %s to %s."] = true
L["Sent %s to %s with a COD of %s."] = true
L["Set Max Quantity"] = true
L["Sets the maximum quantity of each unique item to send to the target at a time."] = true
L["Shift-Click|r to leave mail with gold."] = true
L["Shift-Click|r to leave the fields populated after sending."] = true
L["Showing all %d mail."] = true
L["Showing %d of %d mail."] = true
L["Show Reload UI Button"] = true
L["Skipping operation '%s' because there is no target."] = true
L["Sold [%s]x%d for %s to %s"] = true
L["Sources to Include in Restock"] = true
L["Sources to Include in Restock:"] = true
L["Specifies the default page that'll show when you select the TSM_Mailing tab."] = true
L["Specify the item to be mailed here."] = true
L["Specify the target player and the maximum quantity to send."] = true
L["%s sent you a COD of %s for %s"] = true
L["%s sent you a message: %s"] = true
L["%s sent you %s"] = true
L["%s sent you %s and %s"] = true
L["%sShift-Click|r to continue opening after an inbox refresh if you have more than 50 items in your inbox."] = true
L["%s to collect."] = true
L["Stopped opening mail to keep %d slots free."] = true
L["Target:"] = true
L["Target is Current Player"] = true
L["Target Player"] = true
L["Target Player:"] = true
L["Test Selected Sound"] = true
L["The name of the player you want to mail items to."] = true
L["The 'Open All Mail' button will open all mail in your inbox (including beyond the 50-mail limit). The AH mail buttons below that will open specific types of mail from your inbox."] = true
L["These buttons change what is shown in the mailbox frame. You can view your inbox, automatically mail items in groups, quickly send items to other characters, and more in the various tabs."] = true
L["These will toggle between the module specific tabs."] = true
L["This button will de-select all groups."] = true
L["This button will move all items in the selected groups using the restock target settings from the bank to your bags."] = true
L["This button will move items in the selected groups from the bank to your bags."] = true
L["This button will move items in the selected groups from your bags to the bank."] = true
L["This button will move items NOT in the selected groups from your bags to the bank."] = true
L["This button will select all groups."] = true
L["This feature makes it easy to mail all of your disenchantable items to a specific character. You can change the maximum quality of items to be sent in the options."] = true
L["This feature makes it easy to maintain a specific amount of gold on the current character."] = true
L["This is maximum amount of gold you want to keep on the current player. Any amount over this limit will be send to the specified character."] = true
L["This is the maximum number of the specified item to send when you click the button below. Setting this to 0 will send ALL items."] = true
L["This is where the items in your inbox are listed in an information and easy to read format."] = true
L["This slider controls how long the mail sending code waits between consecutive mails. If this is set too low, you will run into internal mailbox errors."] = true
L["This slider controls how much free space to keep in your bags when looting from the mailbox. This only applies to bags that any item can go in."] = true
L["This tab allows you to quickly send any quantity of an item to another character. You can also specify a COD to set on the mail (per item)."] = true
L["Total Gold Collected: %s"] = true
L["TSM Groups"] = true
L["TSM_Mailing Excess Gold"] = true
L["When you shift-click a send mail button, after the initial send, it will check for new items to send at this interval."] = true
L["Your auction of %s expired"] = true
