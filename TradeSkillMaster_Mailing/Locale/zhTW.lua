-- ------------------------------------------------------------------------------ --
--                            TradeSkillMaster_Mailing                            --
--            http://www.curse.com/addons/wow/tradeskillmaster_mailing            --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- TradeSkillMaster_Mailing Locale - zhTW
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/tradeskillmaster_mailing/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Mailing", "zhTW")
if not L then return end

-- L["AH Mail:"] = ""
L[ [=[Automatically rechecks mail every 60 seconds when you have too much mail.

If you loot all mail with this enabled, it will wait and recheck then keep auto looting.]=] ] = [=[當你有過多郵件時,將每60秒複查郵件.

當開啟此項時若你正在拾取全部郵件,程式將等待並複查郵件但保持自動拾取。]=]
L["Auto Recheck Mail"] = "自動重新檢查郵件"
L["BE SURE TO SPELL THE NAME CORRECTLY!"] = "請務必保證收件人姓名拼寫的正確性！"
-- L["Bought %sx%d for %s from %s"] = ""
-- L["Buys"] = ""
L["Buy: %s (%d) | %s | %s"] = "購買: %s (%d) | %s | %s"
-- L["Cancelled auction of %sx%d"] = ""
-- L["Cancels"] = ""
L["Cannot finish auto looting, inventory is full or too many unique items."] = "無法完成自動拾取郵件,行囊已滿或者擁有過多唯一物品."
--[==[ L[ [=[|cff99ffffShift-Click|r to automatically re-send after the amount of time specified in the TSM_Mailing options.
|cff99ffffCtrl-Click|r to perform a dry-run where Mailing doesn't send anything, but prints out what it would send (useful for testing your operations).]=] ] = "" ]==]
L["Clear"] = "清除"
-- L["Clicking this button clears the item box."] = ""
-- L["Click this button to automatically mail items in the groups which you have selected."] = ""
-- L["Click this button to mail the item to the specified character."] = ""
-- L["Click this button to send all disenchantable items in your bags to the specified character. You can set the maximum quality to be sent in the options."] = ""
-- L["Click this button to send excess gold to the specified character (Maximum of 200k per mail)."] = ""
L["COD Amount (per Item):"] = "貨到付款金額（每件）："
-- L["COD: %s | %s | (%s) | %s | %s"] = ""
L["Could not loot item from mail because your bags are full."] = "由於你的背包已滿，無法再收取郵件。"
L["Could not send mail due to not having free bag space available to split a stack of items."] = "由於你的背包沒有拆開堆疊的空間，無法發送出郵件。"
-- L["Default Mailing Page"] = ""
-- L["Delete Empty NPC Mail"] = ""
L["Display Total Money Received"] = "顯示收取金幣總額"
-- L["Done sending mail."] = ""
L["Drag (or place) the item that you want to send into this editbox."] = "將你想要郵寄物品拖進編輯框。"
L["Enable Inbox Chat Messages"] = "開啟對話框收件信息"
L["Enable Sending Chat Messages"] = "開啟對話框發件信息"
-- L["Enter name of the character disenchantable items should be sent to."] = ""
L["Enter the desired COD amount (per item) to send this item with. Setting this to '0c' will result in no COD being set."] = "輸入你希望的該物品郵寄時收取的費用（單件）。設置為‘0c’將不會收取費用。"
L["Enter the name of the player you want to send excess gold to."] = "輸入收取額外金幣的收件人姓名。"
L["Enter the name of the player you want to send this item to."] = "輸入收取這個件物品的收件人姓名。"
L["Expired: %s | %s"] = "過期的: %s | %s"
-- L["Expires"] = ""
-- L["Failed to send mail:"] = ""
L["General"] = "綜述"
L["General Settings"] = "常規設置"
-- L["Here you can select groups with TSM_Mailing operations to be automatically mailed to other characters."] = ""
-- L["If checked, a maximum quantity to send to the target can be set. Otherwise, Mailing will send as many as it can."] = ""
-- L["If checked, a 'Reload UI' button will be shown while waiting for the inbox to refresh. Reloading will cause the mailbox to refresh and may be faster than waiting for the next refresh."] = ""
L["If checked, information on mails collected by TSM_Mailing will be printed out to chat."] = "如果勾選此項，通過TSM_Mailing收取的郵件信息將會在聊天框裡顯示。"
L["If checked, information on mails sent by TSM_Mailing will be printed out to chat."] = "如果勾選此項，通過TSM_Mailing發送的郵件信息將會在聊天框裡顯示。"
-- L["If checked, mail from NPCs which have no attachments will automatically be deleted."] = ""
L["If checked, the Mailing tab of the mailbox will be the default tab."] = "如果勾選此項，郵寄標籤的將被設定為郵箱的默認標籤。"
L["If checked, the target's current inventory will be taken into account when determing how many to send. For example, if the max quantity is set to 10, and the target already has 3, Mailing will send at most 7 items."] = "如果勾選此項，當決定發送多少時，收件人當前的庫存將被考慮進來。例如，如果最大的數量設置為10件，目標已經有3件，郵件將發送最多7件。"
L["If checked, the total amount of gold received will be shown at the end of automatically collecting mail."] = "如果勾選此項，收取的金幣總數會顯示在自動收件的最後。"
-- L["Inbox Settings"] = ""
-- L["Inbox update in %d seconds."] = ""
L["Item (Drag Into Box):"] = "物品（拖進列表）："
-- L["Keep Free Bag Space"] = ""
L["Keep Quantity"] = "保持數量"
-- L["Lastly, click this button to send the mail."] = ""
L["Limit (In Gold):"] = "限制（金）："
-- L["Lists the groups with mailing operations. Left click to select/deselect the group, Right click to expand/collapse the group."] = ""
-- L["Mail Disenchantables"] = ""
-- L["Mail Disenchantables Maximum Quality"] = ""
L["Mailing all to %s."] = "全部郵寄至 %s。"
L["Mailing operations contain settings for easy mailing of items to other characters."] = "Mailing操作的設置郵寄使郵寄更加便捷。"
L["Mailing up to %d to %s."] = "郵寄了 %d 給 %s。"
L["Mailing will keep this number of items in the current player's bags and not mail them to the target."] = "這是該物品的背包內最低保有量, 保有的物品不會被郵寄出去。"
-- L["Mailing will not send any disenchantable items above this quality to the target player."] = ""
-- L["Mailing would send the following items to %s:"] = ""
L["Mail Selected Groups"] = "郵寄選定分組"
L["Mail Send Delay"] = "郵寄時間間隔"
L["Make Mailing Default Mail Tab"] = "將Mailing設置為默認標籤"
-- L["Maximum Quantity"] = ""
L["Max Quantity:"] = "最大數量:"
-- L["Move Group To Bags"] = ""
-- L["Move Group to Bank"] = ""
-- L["Move Non Group Items to Bank"] = ""
-- L["Move Target Shortfall To Bags"] = ""
L["Multiple Items"] = "多件物品"
L["No Item Specified"] = "没有指定物品"
L["No Target Player"] = "沒有目標角色"
L["No Target Specified"] = "無指定目標"
-- L["Nothing to Move"] = ""
-- L["Not sending any gold as you either did not enter a limit or did not press enter to store the limit."] = ""
L["Not sending any gold as you have less than the specified limit."] = "沒有郵寄金幣,因為您的金幣數量低於最低設定值。"
L["Not Target Specified"] = "沒有指定目標"
-- L["Open All Mail"] = ""
-- L["Open Mail Complete Sound"] = ""
-- L["Opens all mail containing canceled auctions."] = ""
-- L["Opens all mail containing expired auctions."] = ""
-- L["Opens all mail containing gold from sales."] = ""
-- L["Opens all mail containing items you have bought."] = ""
-- L["Opens all mail in your inbox. If you have more than 50 items in your inbox, the opening will automatically continue when the inbox refreshes."] = ""
L["Operation Settings"] = "操作設置"
-- L["Optionally specify a per-item COD amount."] = ""
-- L["Play the selected sound when Mailing is done opening all mail."] = ""
-- L["Preparing to Move"] = ""
L["Quick Send"] = "快速發送"
L["Restart Delay (minutes)"] = "自動郵件重啟延遲（分鐘）"
L["Restock Target to Max Quantity"] = "對目標最大數量補貨"
-- L["Sales"] = ""
L["Sale: %s (%d) | %s | %s"] = "出售: %s (%d) | %s | %s"
-- L["Send all %s to %s - No COD"] = ""
-- L["Send all %s to %s - %s per Item COD"] = ""
-- L["Send Disenchantable Items to %s"] = ""
-- L["Send Excess Gold to Banker"] = ""
L["Send Excess Gold to %s"] = "郵寄超額金幣給 %s"
L["Sending..."] = "發送中..."
-- L["Sending Settings"] = ""
L["Send Items Individually"] = "單獨郵寄物品"
L["Sends each unique item in a seperate mail."] = "使用單獨的郵件發送每個唯一物品"
L["Send %sx%d to %s - No COD"] = "郵寄 %sx%d 給 %s - 不收費"
L["Send %sx%d to %s - %s per Item COD"] = "郵寄 %sx%d 給 %s - 單件收費 %s"
-- L["Sent all disenchantable items to %s."] = ""
L["Sent %s to %s."] = "郵寄 %s 至 %s."
L["Sent %s to %s with a COD of %s."] = "郵寄 %s 給 %s 附帶收費 %s。"
L["Set Max Quantity"] = "設置最大數量"
L["Sets the maximum quantity of each unique item to send to the target at a time."] = "設置單次郵寄的每種物品的最大郵寄量。"
-- L["Shift-Click|r to leave mail with gold."] = ""
-- L["Shift-Click|r to leave the fields populated after sending."] = ""
L["Showing all %d mail."] = "顯示所有%d郵件。"
L["Showing %d of %d mail."] = "顯示 %d of %d 郵件。"
-- L["Show Reload UI Button"] = ""
L["Skipping operation '%s' because there is no target."] = "由於沒有目標,跳過操作 '%s' 。"
-- L["Sold [%s]x%d for %s to %s"] = ""
-- L["Sources to Include in Restock"] = ""
-- L["Sources to Include in Restock:"] = ""
-- L["Specifies the default page that'll show when you select the TSM_Mailing tab."] = ""
-- L["Specify the item to be mailed here."] = ""
-- L["Specify the target player and the maximum quantity to send."] = ""
-- L["%s sent you a COD of %s for %s"] = ""
-- L["%s sent you a message: %s"] = ""
-- L["%s sent you %s"] = ""
-- L["%s sent you %s and %s"] = ""
-- L["%sShift-Click|r to continue opening after an inbox refresh if you have more than 50 items in your inbox."] = ""
L["%s to collect."] = "%s 收取"
-- L["Stopped opening mail to keep %d slots free."] = ""
L["Target:"] = "收件人："
L["Target is Current Player"] = "收件人是當前玩家"
L["Target Player"] = "收件人"
L["Target Player:"] = "收件人："
-- L["Test Selected Sound"] = ""
L["The name of the player you want to mail items to."] = "您所希望的收件角色的姓名。"
-- L["The 'Open All Mail' button will open all mail in your inbox (including beyond the 50-mail limit). The AH mail buttons below that will open specific types of mail from your inbox."] = ""
-- L["These buttons change what is shown in the mailbox frame. You can view your inbox, automatically mail items in groups, quickly send items to other characters, and more in the various tabs."] = ""
-- L["These will toggle between the module specific tabs."] = ""
-- L["This button will de-select all groups."] = ""
-- L["This button will move all items in the selected groups using the restock target settings from the bank to your bags."] = ""
-- L["This button will move items in the selected groups from the bank to your bags."] = ""
-- L["This button will move items in the selected groups from your bags to the bank."] = ""
-- L["This button will move items NOT in the selected groups from your bags to the bank."] = ""
-- L["This button will select all groups."] = ""
-- L["This feature makes it easy to mail all of your disenchantable items to a specific character. You can change the maximum quality of items to be sent in the options."] = ""
-- L["This feature makes it easy to maintain a specific amount of gold on the current character."] = ""
L["This is maximum amount of gold you want to keep on the current player. Any amount over this limit will be send to the specified character."] = "這是您希望的當前角色金幣最大持有量。多餘的金幣會被郵寄到指定角色(金庫角色)。"
-- L["This is the maximum number of the specified item to send when you click the button below. Setting this to 0 will send ALL items."] = ""
-- L["This is where the items in your inbox are listed in an information and easy to read format."] = ""
L["This slider controls how long the mail sending code waits between consecutive mails. If this is set too low, you will run into internal mailbox errors."] = "此滑動條控制著連續發送郵件的間隔時間。若設置數值太低，會出現內部郵箱錯誤。"
-- L["This slider controls how much free space to keep in your bags when looting from the mailbox. This only applies to bags that any item can go in."] = ""
L["This tab allows you to quickly send any quantity of an item to another character. You can also specify a COD to set on the mail (per item)."] = "此標籤允許您快速發送任何數量的物品給另一個角色。您也可以通過設置發送收費郵件(單件計費)。"
-- L["Total Gold Collected: %s"] = ""
L["TSM Groups"] = "TSM分組"
L["TSM_Mailing Excess Gold"] = "TSM_Mailing 超額金幣"
L["When you shift-click a send mail button, after the initial send, it will check for new items to send at this interval."] = "當你shift+左鍵點擊發送按鈕, 初次郵寄後，將在設置的分鐘數後檢查新專案。"
-- L["Your auction of %s expired"] = ""