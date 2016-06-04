-- ------------------------------------------------------------------------------ --
--                            TradeSkillMaster_Mailing                            --
--            http://www.curse.com/addons/wow/tradeskillmaster_mailing            --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- TradeSkillMaster_Mailing Locale - koKR
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/tradeskillmaster_mailing/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Mailing", "koKR")
if not L then return end

-- L["AH Mail:"] = ""
L[ [=[Automatically rechecks mail every 60 seconds when you have too much mail.

If you loot all mail with this enabled, it will wait and recheck then keep auto looting.]=] ] = "보유 한도를 초과해 메일을 받았을 때 60초 주기로 메일을 재검색합니다.\\n\\n이 기능이 활성화되어 있으면 60초 대기후 초과한 메일을 재검색해 자동으로 모두 받을 수 있습니다." -- Needs review
L["Auto Recheck Mail"] = "메일 자동 재검색"
L["BE SURE TO SPELL THE NAME CORRECTLY!"] = "이름의 철자가 맞는지 다시 한 번 확인하세요!" -- Needs review
-- L["Bought %sx%d for %s from %s"] = ""
-- L["Buys"] = ""
L["Buy: %s (%d) | %s | %s"] = "구매: %s (%d) | %s | %s" -- Needs review
-- L["Cancelled auction of %sx%d"] = ""
-- L["Cancels"] = ""
L["Cannot finish auto looting, inventory is full or too many unique items."] = "자동 메일 받기를 완료할 수 없습니다. 가방이 다 찼거나 고유아이템이 너무 많습니다."
--[==[ L[ [=[|cff99ffffShift-Click|r to automatically re-send after the amount of time specified in the TSM_Mailing options.
|cff99ffffCtrl-Click|r to perform a dry-run where Mailing doesn't send anything, but prints out what it would send (useful for testing your operations).]=] ] = "" ]==]
L["Clear"] = "지우기" -- Needs review
-- L["Clicking this button clears the item box."] = ""
-- L["Click this button to automatically mail items in the groups which you have selected."] = ""
-- L["Click this button to mail the item to the specified character."] = ""
-- L["Click this button to send all disenchantable items in your bags to the specified character. You can set the maximum quality to be sent in the options."] = ""
-- L["Click this button to send excess gold to the specified character (Maximum of 200k per mail)."] = ""
L["COD Amount (per Item):"] = "대금 청구 금액 (개당)" -- Needs review
-- L["COD: %s | %s | (%s) | %s | %s"] = ""
L["Could not loot item from mail because your bags are full."] = "가방이 가득 차 있어서 우편함으로부터 아이템을 루팅할 수 없습니다." -- Needs review
L["Could not send mail due to not having free bag space available to split a stack of items."] = "묶음 아이템을 분할 할 수 있는 가방 공간이 부족하여 아이템을 발송하지 못했습니다." -- Needs review
-- L["Default Mailing Page"] = ""
-- L["Delete Empty NPC Mail"] = ""
L["Display Total Money Received"] = "받은 총 금액 표시" -- Needs review
-- L["Done sending mail."] = ""
L["Drag (or place) the item that you want to send into this editbox."] = "발송할 아이템을 이 상자 안으로 드래그하세요." -- Needs review
L["Enable Inbox Chat Messages"] = "받은 우편 메시지 표시" -- Needs review
L["Enable Sending Chat Messages"] = "보낸 우편 메시지 표시" -- Needs review
-- L["Enter name of the character disenchantable items should be sent to."] = ""
L["Enter the desired COD amount (per item) to send this item with. Setting this to '0c' will result in no COD being set."] = "원하는 대금 청구 금액(개당)을 입력하세요. '0c'로 설정하면 대금 청구를 하지 않습니다." -- Needs review
L["Enter the name of the player you want to send excess gold to."] = "초과 골드를 보낼 플레이어의 이름을 입력하세요." -- Needs review
L["Enter the name of the player you want to send this item to."] = "아이템을 보낼 플레이어의 이름을 입력하세요." -- Needs review
L["Expired: %s | %s"] = "만료: %s | %s" -- Needs review
-- L["Expires"] = ""
-- L["Failed to send mail:"] = ""
L["General"] = "일반" -- Needs review
L["General Settings"] = "일반 설정" -- Needs review
-- L["Here you can select groups with TSM_Mailing operations to be automatically mailed to other characters."] = ""
-- L["If checked, a maximum quantity to send to the target can be set. Otherwise, Mailing will send as many as it can."] = ""
-- L["If checked, a 'Reload UI' button will be shown while waiting for the inbox to refresh. Reloading will cause the mailbox to refresh and may be faster than waiting for the next refresh."] = ""
L["If checked, information on mails collected by TSM_Mailing will be printed out to chat."] = "선택하면, TSM 우편에 의해 수집된 우편에 대한 정보를 채팅창에 출력합니다." -- Needs review
L["If checked, information on mails sent by TSM_Mailing will be printed out to chat."] = "선택하면, TSM 우편에 의해 발송된 우편에 대한 정보를 채팅창에 출력합니다." -- Needs review
-- L["If checked, mail from NPCs which have no attachments will automatically be deleted."] = ""
L["If checked, the Mailing tab of the mailbox will be the default tab."] = "선택하면, TSM 우편탭을 우편함의 기본 탭으로 지정합니다." -- Needs review
L["If checked, the target's current inventory will be taken into account when determing how many to send. For example, if the max quantity is set to 10, and the target already has 3, Mailing will send at most 7 items."] = "선택하면, 발송할 수량을 결정할 때 수신자의 현재 인벤토리 수량이 고려됩니다. 예를 들면, 최대 수량이 10으로 설정되어있고 수신자가 이미 3개를 가지고 있다면 최대 7개의 아이템만 발송합니다." -- Needs review
L["If checked, the total amount of gold received will be shown at the end of automatically collecting mail."] = "선택하면, 자동으로 받은 우편을 통해 수집된 총 골드 량을 표시합니다." -- Needs review
-- L["Inbox Settings"] = ""
-- L["Inbox update in %d seconds."] = ""
L["Item (Drag Into Box):"] = "아이템:" -- Needs review
-- L["Keep Free Bag Space"] = ""
L["Keep Quantity"] = "수량 유지" -- Needs review
-- L["Lastly, click this button to send the mail."] = ""
L["Limit (In Gold):"] = "한도 (골드):" -- Needs review
-- L["Lists the groups with mailing operations. Left click to select/deselect the group, Right click to expand/collapse the group."] = ""
-- L["Mail Disenchantables"] = ""
-- L["Mail Disenchantables Maximum Quality"] = ""
L["Mailing all to %s."] = "모두 %s에게 발송합니다." -- Needs review
L["Mailing operations contain settings for easy mailing of items to other characters."] = "우편 작업은 다른 캐릭터에서 쉽게 아이템을 발송할 수 있도록 하는 설정을 가지고 있습니다." -- Needs review
L["Mailing up to %d to %s."] = "최대 %d개를 %s에게 발송합니다." -- Needs review
L["Mailing will keep this number of items in the current player's bags and not mail them to the target."] = "대상에게 우편을 발송하지 않고 현재 플레이어 가방 안의 아이템 개수를 유지합니다." -- Needs review
-- L["Mailing will not send any disenchantable items above this quality to the target player."] = ""
-- L["Mailing would send the following items to %s:"] = ""
L["Mail Selected Groups"] = "선택된 그룹 메일 발송" -- Needs review
L["Mail Send Delay"] = "우편 발송 지연" -- Needs review
L["Make Mailing Default Mail Tab"] = "TSM 우편을 기본 탭으로 지정" -- Needs review
-- L["Maximum Quantity"] = ""
L["Max Quantity:"] = "최대 수량:" -- Needs review
-- L["Move Group To Bags"] = ""
-- L["Move Group to Bank"] = ""
-- L["Move Non Group Items to Bank"] = ""
-- L["Move Target Shortfall To Bags"] = ""
L["Multiple Items"] = "다중 아이템" -- Needs review
L["No Item Specified"] = "지정된 아이템 없음" -- Needs review
L["No Target Player"] = "대상 없음" -- Needs review
L["No Target Specified"] = "지정된 대상 없음" -- Needs review
-- L["Nothing to Move"] = ""
-- L["Not sending any gold as you either did not enter a limit or did not press enter to store the limit."] = ""
L["Not sending any gold as you have less than the specified limit."] = "보유량이 지정된 제한보다 적으므로 골드를 발송하지 않습니다." -- Needs review
L["Not Target Specified"] = "지정된 대상 없음" -- Needs review
-- L["Open All Mail"] = ""
-- L["Open Mail Complete Sound"] = ""
-- L["Opens all mail containing canceled auctions."] = ""
-- L["Opens all mail containing expired auctions."] = ""
-- L["Opens all mail containing gold from sales."] = ""
-- L["Opens all mail containing items you have bought."] = ""
-- L["Opens all mail in your inbox. If you have more than 50 items in your inbox, the opening will automatically continue when the inbox refreshes."] = ""
L["Operation Settings"] = "작업 설정" -- Needs review
-- L["Optionally specify a per-item COD amount."] = ""
-- L["Play the selected sound when Mailing is done opening all mail."] = ""
-- L["Preparing to Move"] = ""
L["Quick Send"] = "빠른 발송" -- Needs review
L["Restart Delay (minutes)"] = "재시작 지연 (분)" -- Needs review
L["Restock Target to Max Quantity"] = "재보충 대상 최대 수량" -- Needs review
-- L["Sales"] = ""
L["Sale: %s (%d) | %s | %s"] = "판매: %s (%d) | %s | %s" -- Needs review
-- L["Send all %s to %s - No COD"] = ""
-- L["Send all %s to %s - %s per Item COD"] = ""
-- L["Send Disenchantable Items to %s"] = ""
-- L["Send Excess Gold to Banker"] = ""
L["Send Excess Gold to %s"] = "초과 골드를 %s에게 발송" -- Needs review
L["Sending..."] = "발송 중..." -- Needs review
-- L["Sending Settings"] = ""
L["Send Items Individually"] = "아이템 개별 발송"
L["Sends each unique item in a seperate mail."] = "한 개의 메일에 여러 종류의 아이템을 첨부하지 않고, 아이템별로 별도의 메일로 발송합니다."
L["Send %sx%d to %s - No COD"] = "%sx%d개를 %s에게 발송 - 대금 청구 없음" -- Needs review
L["Send %sx%d to %s - %s per Item COD"] = "%sx%d개를 %s에게 발송 - 개당 %s 청구" -- Needs review
-- L["Sent all disenchantable items to %s."] = ""
L["Sent %s to %s."] = "%s개를 %s에게 보냈습니다." -- Needs review
L["Sent %s to %s with a COD of %s."] = "%s개를 %s에게 %s의 대금 청구 우편으로 보냈습니다." -- Needs review
L["Set Max Quantity"] = "최대 수량 설정" -- Needs review
L["Sets the maximum quantity of each unique item to send to the target at a time."] = "한번에 대상에게 보낼 수 있는 고유 아이템의 최대 수량을 설정합니다." -- Needs review
-- L["Shift-Click|r to leave mail with gold."] = ""
-- L["Shift-Click|r to leave the fields populated after sending."] = ""
L["Showing all %d mail."] = "모든 %d 우편 표시" -- Needs review
L["Showing %d of %d mail."] = "%d of %d 우편 표시" -- Needs review
-- L["Show Reload UI Button"] = ""
L["Skipping operation '%s' because there is no target."] = "대상이 없으므로 '%s' 작업을 건너뜁니다." -- Needs review
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
L["%s to collect."] = "%s을(를) 회수하였습니다." -- Needs review
-- L["Stopped opening mail to keep %d slots free."] = ""
L["Target:"] = "대상:" -- Needs review
L["Target is Current Player"] = "대상은 현재 플레이어입니다." -- Needs review
L["Target Player"] = "대상 플레이어" -- Needs review
L["Target Player:"] = "대상 플레이어:" -- Needs review
-- L["Test Selected Sound"] = ""
L["The name of the player you want to mail items to."] = "아이템을 보낼 플레이어의 이름." -- Needs review
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
L["This is maximum amount of gold you want to keep on the current player. Any amount over this limit will be send to the specified character."] = "현재 플레이어가 보유할 최대 골드입니다. 이 한도를 초과하는 골드는 지정된 캐릭터에게 보냅니다." -- Needs review
-- L["This is the maximum number of the specified item to send when you click the button below. Setting this to 0 will send ALL items."] = ""
-- L["This is where the items in your inbox are listed in an information and easy to read format."] = ""
L["This slider controls how long the mail sending code waits between consecutive mails. If this is set too low, you will run into internal mailbox errors."] = "여러 개의 메일을 연속해서 보낼 때 개별메일 발송 후 다음 메일을 보내기 전 대기하는 시간을 설정합니다. 만일 너무 짧은 시간으로 설정하면 에러가 발생할 수 있습니다." -- Needs review
-- L["This slider controls how much free space to keep in your bags when looting from the mailbox. This only applies to bags that any item can go in."] = ""
L["This tab allows you to quickly send any quantity of an item to another character. You can also specify a COD to set on the mail (per item)."] = "이 탭에서는 다른 캐릭터에게 원하는 수량의 아이템을 빠르게 발송할 수 있습니다. 또한, 대금 청구 우편도 지정할 수 있습니다. (아이템별)" -- Needs review
-- L["Total Gold Collected: %s"] = ""
L["TSM Groups"] = "TSM 그룹" -- Needs review
L["TSM_Mailing Excess Gold"] = "TSM 우편 초과 골드" -- Needs review
L["When you shift-click a send mail button, after the initial send, it will check for new items to send at this interval."] = "우편 발송 버튼을 Shift-Click 하면, 초기 발송 후 여기서 지정한 지연시간이 지난 후 발송할 새 아이템을 확인합니다." -- Needs review
-- L["Your auction of %s expired"] = ""
