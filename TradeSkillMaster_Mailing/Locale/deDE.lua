-- ------------------------------------------------------------------------------ --
--                            TradeSkillMaster_Mailing                            --
--            http://www.curse.com/addons/wow/tradeskillmaster_mailing            --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- TradeSkillMaster_Mailing Locale - deDE
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/tradeskillmaster_mailing/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_Mailing", "deDE")
if not L then return end

-- L["AH Mail:"] = ""
L[ [=[Automatically rechecks mail every 60 seconds when you have too much mail.

If you loot all mail with this enabled, it will wait and recheck then keep auto looting.]=] ] = [=[Briefkasten automatisch alle 60 Sekunden aktualisieren, wenn Ihr zuviel Post im Briefkasten habt.

Wenn Ihr alle Posts öffnet, während diese Option aktiviert ist, wird auf neue Post zum Öffnen gewartet.]=]
L["Auto Recheck Mail"] = "Briefkasten automatisch aktualisieren"
L["BE SURE TO SPELL THE NAME CORRECTLY!"] = "ACHTET DARAUF, DASS DER NAME RICHTIG GESCHRIEBEN IST!"
-- L["Bought %sx%d for %s from %s"] = ""
-- L["Buys"] = ""
L["Buy: %s (%d) | %s | %s"] = "Kauf: %s (%d) | %s | %s" -- Needs review
-- L["Cancelled auction of %sx%d"] = ""
-- L["Cancels"] = ""
L["Cannot finish auto looting, inventory is full or too many unique items."] = "Automatisches Plündern kann nicht beendet werden. Inventar ist voll oder zu viele \"einzigartige\" Gegenstände vorhanden."
--[==[ L[ [=[|cff99ffffShift-Click|r to automatically re-send after the amount of time specified in the TSM_Mailing options.
|cff99ffffCtrl-Click|r to perform a dry-run where Mailing doesn't send anything, but prints out what it would send (useful for testing your operations).]=] ] = "" ]==]
L["Clear"] = "Leeren"
-- L["Clicking this button clears the item box."] = ""
-- L["Click this button to automatically mail items in the groups which you have selected."] = ""
-- L["Click this button to mail the item to the specified character."] = ""
-- L["Click this button to send all disenchantable items in your bags to the specified character. You can set the maximum quality to be sent in the options."] = ""
-- L["Click this button to send excess gold to the specified character (Maximum of 200k per mail)."] = ""
L["COD Amount (per Item):"] = "Nachnahmegebühr (je Gegenstand):" -- Needs review
-- L["COD: %s | %s | (%s) | %s | %s"] = ""
L["Could not loot item from mail because your bags are full."] = "Gegenstand konnte aus der Post nicht entnommen werden, weil Eure Taschen voll sind."
L["Could not send mail due to not having free bag space available to split a stack of items."] = "Kann keine Post verschicken, da kein freier Taschenplatz vorhanden ist um Gegenstandstapel aufzuteilen." -- Needs review
-- L["Default Mailing Page"] = ""
-- L["Delete Empty NPC Mail"] = ""
L["Display Total Money Received"] = "Zeige die Gesamtsumme des erhaltenen Goldes"
-- L["Done sending mail."] = ""
L["Drag (or place) the item that you want to send into this editbox."] = "Zieht (oder platziert) den Gegenstand, den Ihr verschicken wollt, in dieses Eingabefeld."
L["Enable Inbox Chat Messages"] = "Aktiviere Posteingangsmitteilungen"
L["Enable Sending Chat Messages"] = "Aktiviere Postausgangsmitteilungen"
-- L["Enter name of the character disenchantable items should be sent to."] = ""
L["Enter the desired COD amount (per item) to send this item with. Setting this to '0c' will result in no COD being set."] = "Tragt die gewünschte Nachnahmegebühr (pro Gegenstand) ein, mit der Ihr den Gegenstand verschicken wollt. Bei einem Betrag von '0c' wird der Gegenstand ohne Nachnahmegebühr verschickt."
L["Enter the name of the player you want to send excess gold to."] = "Tragt den Charakternamen ein, an den überschüssiges Gold geschickt werden soll."
L["Enter the name of the player you want to send this item to."] = "Tragt den Charakternamen ein, an den der Gegenstand geschickt werden soll."
L["Expired: %s | %s"] = "Abgelaufen: %s | %s" -- Needs review
-- L["Expires"] = ""
-- L["Failed to send mail:"] = ""
L["General"] = "Allgemein" -- Needs review
L["General Settings"] = "Allgemeine Einstellungen" -- Needs review
-- L["Here you can select groups with TSM_Mailing operations to be automatically mailed to other characters."] = ""
-- L["If checked, a maximum quantity to send to the target can be set. Otherwise, Mailing will send as many as it can."] = ""
-- L["If checked, a 'Reload UI' button will be shown while waiting for the inbox to refresh. Reloading will cause the mailbox to refresh and may be faster than waiting for the next refresh."] = ""
L["If checked, information on mails collected by TSM_Mailing will be printed out to chat."] = "Wenn aktiviert, werden Informationen über Posts, die von TSM_Mailing eingesammelt werden, im Chat angezeigt."
L["If checked, information on mails sent by TSM_Mailing will be printed out to chat."] = "Wenn aktiviert, werden Informationen über Posts, die von TSM_Mailing gesendet werden, im Chat angezeigt."
-- L["If checked, mail from NPCs which have no attachments will automatically be deleted."] = ""
L["If checked, the Mailing tab of the mailbox will be the default tab."] = "Wenn aktiviert, wird Mailing zum Standard-Tab im Briefkasten gemacht."
L["If checked, the target's current inventory will be taken into account when determing how many to send. For example, if the max quantity is set to 10, and the target already has 3, Mailing will send at most 7 items."] = "Wenn aktiviert, wird das aktuelle Inventar des Ziels beim Bestimmen der zu sendenden Posts berücksichtigt. Zum Beispiel wird Mailing, wenn die Maximalmenge auf 10 gesetzt ist und das Ziel bereits 3 Einheiten hat, maximal 7 Einheiten versenden."
L["If checked, the total amount of gold received will be shown at the end of automatically collecting mail."] = "Wenn aktiviert, wird der gesamte erhaltene Goldbetrag angezeigt, nachdem alle Nachrichten automatisch eingesammelt wurden."
-- L["Inbox Settings"] = ""
-- L["Inbox update in %d seconds."] = ""
L["Item (Drag Into Box):"] = "Gegenstand (ins Feld ziehen):"
-- L["Keep Free Bag Space"] = ""
L["Keep Quantity"] = "Zu behaltende Menge" -- Needs review
-- L["Lastly, click this button to send the mail."] = ""
L["Limit (In Gold):"] = "Limit (in Gold):" -- Needs review
-- L["Lists the groups with mailing operations. Left click to select/deselect the group, Right click to expand/collapse the group."] = ""
-- L["Mail Disenchantables"] = ""
-- L["Mail Disenchantables Maximum Quality"] = ""
L["Mailing all to %s."] = "Alles an %s geschickt." -- Needs review
L["Mailing operations contain settings for easy mailing of items to other characters."] = "Mailing-Operationen enthalten Einstellungen zum einfachen Versenden von Gegenständen an anderen Charakteren."
L["Mailing up to %d to %s."] = "Schicke maximal %d an %s." -- Needs review
L["Mailing will keep this number of items in the current player's bags and not mail them to the target."] = "Mailing wird diese Anzahl von Gegenständen in den Taschen des aktuellen Spielers behalten, ohne sie ans Ziel zu schicken."
-- L["Mailing will not send any disenchantable items above this quality to the target player."] = ""
-- L["Mailing would send the following items to %s:"] = ""
L["Mail Selected Groups"] = "Ausgewählte Gruppen versenden" -- Needs review
L["Mail Send Delay"] = "Verzögerung beim Senden von Post"
L["Make Mailing Default Mail Tab"] = "Mache Mailing zum Standard-Briefkasten-Tab"
-- L["Maximum Quantity"] = ""
L["Max Quantity:"] = "Max. Anzahl:" -- Needs review
-- L["Move Group To Bags"] = ""
-- L["Move Group to Bank"] = ""
-- L["Move Non Group Items to Bank"] = ""
-- L["Move Target Shortfall To Bags"] = ""
L["Multiple Items"] = "Mehrere Gegenstände" -- Needs review
L["No Item Specified"] = "Kein Gegenstand angegeben" -- Needs review
L["No Target Player"] = "Kein Zielcharakter" -- Needs review
L["No Target Specified"] = "Kein Ziel angegeben" -- Needs review
-- L["Nothing to Move"] = ""
-- L["Not sending any gold as you either did not enter a limit or did not press enter to store the limit."] = ""
L["Not sending any gold as you have less than the specified limit."] = "Gold wird nicht gesendet, weil Ihr weniger als den angegebenen Betrag besitzt."
L["Not Target Specified"] = "Kein Ziel angegeben" -- Needs review
-- L["Open All Mail"] = ""
-- L["Open Mail Complete Sound"] = ""
-- L["Opens all mail containing canceled auctions."] = ""
-- L["Opens all mail containing expired auctions."] = ""
-- L["Opens all mail containing gold from sales."] = ""
-- L["Opens all mail containing items you have bought."] = ""
-- L["Opens all mail in your inbox. If you have more than 50 items in your inbox, the opening will automatically continue when the inbox refreshes."] = ""
L["Operation Settings"] = "Operationseinstellungen" -- Needs review
-- L["Optionally specify a per-item COD amount."] = ""
-- L["Play the selected sound when Mailing is done opening all mail."] = ""
-- L["Preparing to Move"] = ""
L["Quick Send"] = "Schnellsendung"
L["Restart Delay (minutes)"] = "Neustart-Verzögerung (in Minuten)"
L["Restock Target to Max Quantity"] = "Fülle Ziel bis zur max. Menge auf"
-- L["Sales"] = ""
L["Sale: %s (%d) | %s | %s"] = "Verkauf: %s (%d) | %s | %s" -- Needs review
-- L["Send all %s to %s - No COD"] = ""
-- L["Send all %s to %s - %s per Item COD"] = ""
-- L["Send Disenchantable Items to %s"] = ""
-- L["Send Excess Gold to Banker"] = ""
L["Send Excess Gold to %s"] = "Sende überschüssiges Gold an %s." -- Needs review
L["Sending..."] = "Sende..."
-- L["Sending Settings"] = ""
L["Send Items Individually"] = "Sende Gegenstände einzeln"
L["Sends each unique item in a seperate mail."] = "Sende jeden einzigartigen Gegenstand in einer separaten Post."
L["Send %sx%d to %s - No COD"] = "Sende %sx%d an %s - Keine Nachnahme" -- Needs review
L["Send %sx%d to %s - %s per Item COD"] = "Sende %sx%d an %s - %s Nachnahme je Gegenstand" -- Needs review
-- L["Sent all disenchantable items to %s."] = ""
L["Sent %s to %s."] = "%s an %s verschickt." -- Needs review
L["Sent %s to %s with a COD of %s."] = "%s an %s mit Nachnahme von %s verschickt." -- Needs review
L["Set Max Quantity"] = "Setze maximale Menge"
L["Sets the maximum quantity of each unique item to send to the target at a time."] = "Setzt die maximale Menge jeden einzigartigen Gegenstandes, das an das Ziel gesendet werden soll."
-- L["Shift-Click|r to leave mail with gold."] = ""
-- L["Shift-Click|r to leave the fields populated after sending."] = ""
L["Showing all %d mail."] = "Zeige alle %d Nachrichten." -- Needs review
L["Showing %d of %d mail."] = "Zeige %d von %d Nachrichten." -- Needs review
-- L["Show Reload UI Button"] = ""
L["Skipping operation '%s' because there is no target."] = "Überspringe Operation '%s', weil es kein Ziel gibt."
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
L["%s to collect."] = "%s zum Einsammeln."
-- L["Stopped opening mail to keep %d slots free."] = ""
L["Target:"] = "Ziel:" -- Needs review
L["Target is Current Player"] = "Ziel ist aktueller Spieler"
L["Target Player"] = "Zielspieler"
L["Target Player:"] = "Zielspieler:"
-- L["Test Selected Sound"] = ""
L["The name of the player you want to mail items to."] = "Name des Spielers, an den Ihr Gegenstände schicken wollt."
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
L["This is maximum amount of gold you want to keep on the current player. Any amount over this limit will be send to the specified character."] = "Dies ist der maximale Goldbetrag den der aktuelle Charakter behalten soll. Alles Gold darüber wird an den angegebenen Charakter geschickt." -- Needs review
-- L["This is the maximum number of the specified item to send when you click the button below. Setting this to 0 will send ALL items."] = ""
-- L["This is where the items in your inbox are listed in an information and easy to read format."] = ""
L["This slider controls how long the mail sending code waits between consecutive mails. If this is set too low, you will run into internal mailbox errors."] = "Dieser Regler kontrolliert, wie lange zwischen dem Versenden von aufeinanderfolgenden Posts gewartet werden soll. Wenn dieser Wert zu niedrig ist, können interne Briefkasten-Fehler auftreten."
-- L["This slider controls how much free space to keep in your bags when looting from the mailbox. This only applies to bags that any item can go in."] = ""
L["This tab allows you to quickly send any quantity of an item to another character. You can also specify a COD to set on the mail (per item)."] = "Dieser Tab erlaubt es Euch, beliebige Mengen eines Gegenstandes an einen anderen Charakter zu senden. Ihr könnt auch eine Nachnahmegebühr (je Gegenstand) angeben."
-- L["Total Gold Collected: %s"] = ""
L["TSM Groups"] = "TSM-Gruppen" -- Needs review
L["TSM_Mailing Excess Gold"] = "TSM_Mailing überschüssiges Gold" -- Needs review
L["When you shift-click a send mail button, after the initial send, it will check for new items to send at this interval."] = "Wenn Ihr einen Umschalt-Klick auf einen Senden-Button macht, wird nach dem ersten Senden nach neuen Gegenständen gesucht, die in diesem Intervall gesendet werden sollen." -- Needs review
-- L["Your auction of %s expired"] = ""
