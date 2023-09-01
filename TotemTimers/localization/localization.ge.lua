if( GetLocale() == "deDE" ) then
_G["BINDING_HEADER_TOTEMTIMERSHEADER"] = "TotemTimers"
_G["BINDING_NAME_TOTEMTIMERSAIR"] = "Lufttoem stellen"
_G["BINDING_NAME_TOTEMTIMERSAIRMENU"] = "Öffne Lufttotemmenü"
_G["BINDING_NAME_TOTEMTIMERSEARTH"] = "Erdtotem stellen"
_G["BINDING_NAME_TOTEMTIMERSEARTHMENU"] = "Öffne Erdtotemmenü"
_G["BINDING_NAME_TOTEMTIMERSEARTHSHIELDLEFT"] = "Erdschild-Linksklick"
_G["BINDING_NAME_TOTEMTIMERSEARTHSHIELDMIDDLE"] = "Erdschild-Rechtsklick"
_G["BINDING_NAME_TOTEMTIMERSEARTHSHIELDRIGHT"] = "Erdschild - Mittlere Maustaste"
_G["BINDING_NAME_TOTEMTIMERSFIRE"] = "Feuertotem stellen"
_G["BINDING_NAME_TOTEMTIMERSFIREMENU"] = "Öffne Feuertotemmenü"
_G["BINDING_NAME_TOTEMTIMERSWATER"] = "Wassertotem stellen"
_G["BINDING_NAME_TOTEMTIMERSWATERMENU"] = "Öffne Wassertotemmenü"
_G["BINDING_NAME_TOTEMTIMERSWEAPONBUFF1"] = "Waffen-Buff 1"
_G["BINDING_NAME_TOTEMTIMERSWEAPONBUFF2"] = "Waffen-Buff 2"

end


local L = LibStub("AceLocale-3.0"):NewLocale("TotemTimers", "deDE")
if not L then return end

L["Air Button"] = "Luftbutton"
L["Ctrl-Leftclick to remove weapon buffs"] = "Strg-Linksklick um Waffenbuffs zu entfernen"
L["Delete Set"] = "Totemset %u löschen?"
L["Earth Button"] = "Erdbutton"
L["Fire Button"] = "Feuerbutton"
L["Leftclick to cast %s"] = "Linksklick um %s zu zaubern"
L["Leftclick to cast spell"] = "Linksklick um Spruch zu zaubern"
L["Leftclick to load totem set to %s"] = "Linksklick um Totemset für %s zu laden."
L["Leftclick to open totem set menu"] = "Linksklick um Totemsetmenü zu öffnen"
L["Maelstrom Notifier"] = "Mahlstrom bereit!"
L["Middleclick to cast %s"] = "Mittelklick um %s zu zaubern"
L["Next leftclick casts %s"] = "Nächster Linksklick zaubert %s"
L["Reset"] = "TotemTimers wurde zurückgesetzt!"
L["Rightclick to assign both %s and %s to leftclick"] = "Rechtsklick um %s und %s Linksklick zuzuweisen"
L["Rightclick to assign spell to leftclick"] = "Rechtsklick um Zauber Linksklick zuzuweisen"
L["Rightclick to cast %s"] = "Rechtsklick um %s zu zaubern"
L["Rightclick to delete totem set"] = "Rechtsklick um Totemset zu löschen"
L["Rightclick to save active totem configuration as set"] = "Rechtsklick um Totemkonfiguration als Set zu speichern"
L["Rightclick to set %s as active multicast spell"] = "Rechtsklick um %s als aktiven Multicast-Zauber zu setzen"
L["Shield removed"] = "%s entfernt"
L["Shift-Rightclick to assign spell to middleclick"] = "Shift-Rechtsklick um Zauber Mittelklick zuzuweisen"
L["Shift-Rightclick to assign spell to rightclick"] = "Shift-Rechtsklick um Zauber Rechtsklick zuzuweisen"
L["Totem Destroyed"] = "%s ist zerstört."
L["Totem Expired"] = "%s ist ausgelaufen"
L["Totem Expiring"] = "%s läuft aus"
L["Water Button"] = "Wasserbutton"
