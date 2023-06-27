﻿if GetLocale() ~= "deDE" then return end
local L

--------------------------
--  General BG Options  --
--------------------------
L = DBM:GetModLocalization("Battlegrounds")

L:SetGeneralLocalization({
	name = "Allgemeine Einstellungen"
})

L:SetTimerLocalization({
	TimerInvite = "%s"
})

L:SetOptionLocalization({
	ColorByClass	= "Einfärbung der Spielernamen nach Klasse in der Schlachtfeld-Punktetafel",
	ShowInviteTimer	= "Zeige Zeit für Schlachtfeld-Beitrittsmöglichkeit",
	AutoSpirit		= "Automatisch Geist freilassen",
	HideBossEmoteFrame	= "Verberge das Schlachtzugsboss-Emote-Fenster ('RaidBossEmoteFrame')"
})

L:SetMiscLocalization({
	ArenaInvite	= "Arena-Einladung"
})

--------------
--  Arenas  --
--------------
L = DBM:GetModLocalization("Arenas")

L:SetGeneralLocalization({
	name = "Arenas"
})

L:SetTimerLocalization({
	TimerShadow	= "Schattensicht"
})

L:SetOptionLocalization({
	TimerShadow = "Zeige Zeit bis $spell:34709 verfügbar"
})

L:SetMiscLocalization({
	Start15 = "Noch fünfzehn Sekunden bis der Arenakampf beginnt!"
})

----------------------
--  Alterac Valley  --
----------------------
L = DBM:GetModLocalization("AlteracValley")

L:SetGeneralLocalization({
	name = "Alteractal"
})

L:SetTimerLocalization({
	TimerTower	= "%s",
	TimerGY		= "%s"
})

L:SetOptionLocalization({
	TimerTower	= "Zeige Zerstörungsdauer für Türme",
	TimerGY		= "Zeige Eroberungsdauer für Friedhofe",
	AutoTurnIn	= "Automatisches Abgeben der Quests im Alteractal"
})

--------------------
--  Arathi Basin  --
--------------------
L = DBM:GetModLocalization("ArathiBasin")

L:SetGeneralLocalization({
	name = "Arathibecken"
})

L:SetMiscLocalization({
	ScoreExpr	= "(%d+)/1600",
	Alliance	= "Allianz",
	Horde		= "Horde",
	WinBarText	= "%s gewinnt",
	BasesToWin	= "benötigte Basen für Sieg: %d",
	Flag		= "Flagge"
})

L:SetTimerLocalization({
	TimerCap	= "%s",
})

L:SetOptionLocalization({
	TimerWin				= "Zeige Zeit bis eine Fraktion gewinnt",
	TimerCap				= "Zeige Eroberungsdauer für Basen",
	ShowAbEstimatedPoints	= "Zeige geschätzten Endpunktestand",
	ShowAbBasesToWin		= "Zeige benötigte Anzahl von Basen zum Sieg"
})

------------------------
--  Eye of the Storm  --
------------------------
L = DBM:GetModLocalization("EyeoftheStorm")

L:SetGeneralLocalization({
	name = "Auge des Sturms"
})

L:SetMiscLocalization({
	ZoneName		= "Auge des Sturms",
	ScoreExpr		= "(%d+)/1600",
	Alliance 		= "Allianz",
	Horde 			= "Horde",
	WinBarText 		= "%s gewinnt",
	FlagReset 		= "Die Flagge wurde zurückgesetzt.",
	FlagTaken 		= "(.+) hat die Flagge aufgenommen.",
	FlagCaptured	= "Die %w+ hat die Flagge erobert!",
	FlagDropped		= "Die Flagge wurde fallengelassen."

})

L:SetTimerLocalization({
	TimerFlag	= "Flaggen-Respawn"
})

L:SetOptionLocalization({
	TimerWin 		= "Zeige Zeit bis eine Fraktion gewinnt",
	TimerFlag 		= "Zeige Zeit bis zum Respawn der Flagge",
	ShowPointFrame	= "Zeige Flaggenträger und geschätzten Endpunktestand"
})

---------------------
--  Warsong Gulch  --
---------------------
L = DBM:GetModLocalization("WarsongGulch")

L:SetGeneralLocalization({
	name = "Kriegshymnenschlucht"
})

L:SetMiscLocalization({
	BgStart60 			= "Die Schlacht beginnt in 1 Minute.",
	BgStart30 			= "Die Schlacht beginnt in 30 Sekunden. Macht Euch bereit!",
	Alliance 			= "Allianz",
	Horde 				= "Horde",	
	InfoErrorText		= "Die Zielauswahlfunktion für den Flaggenträger wird bei Kampfende wiederhergestellt.",
	ExprFlagPickUp		= "(.+) hat die Flagge der (%w+) aufgenommen!", -- code is aware of the switched match groups for deDE
	ExprFlagCaptured	= "(.+) hat die Flagge der (%w+) errungen!", 
	ExprFlagReturn		= "Die Flagge der (%w+) wurde von (.+) zu ihrem Stützpunkt zurückgebracht!",
	FlagAlliance		= "Allianz-Flagge: ",
	FlagHorde			= "Horde-Flagge: ",
	FlagBase			= "Basis"
})

L:SetTimerLocalization({
	TimerStart	= "Kampfbeginn", 
	TimerFlag	= "Flaggen-Respawn"
})

L:SetOptionLocalization({
	TimerStart					= "Zeige Zeit bis Kampfbeginn",
	TimerFlag					= "Zeige Zeit bis zum Respawn der Flaggen",
	ShowFlagCarrier				= "Zeige Flaggenträger",
	ShowFlagCarrierErrorNote	= "Zeige Fehlermeldung, wenn Flaggenträger-Zielauswahl nicht gesetzt werden kann"
})

------------------------
--  Isle of Conquest  --
------------------------
L = DBM:GetModLocalization("IsleofConquest")

L:SetGeneralLocalization({
	name = "Insel der Eroberung"
})

L:SetWarningLocalization({
	WarnSiegeEngine		= "Belagerungsmaschine bereit!",
	WarnSiegeEngineSoon	= "Belagerungsmaschine in ~10 Sekunden",
})

L:SetTimerLocalization({
	TimerPOI			= "%s",
	TimerSiegeEngine	= "Belagerungsmaschine"
})

L:SetOptionLocalization({
	TimerPOI			= "Zeige Eroberungsdauer",
	TimerSiegeEngine	= "Zeige Zeit bis Belagerungsmaschine bereit ist",
	WarnSiegeEngine		= "Zeige Warnung, wenn Belagerungsmaschine bereit ist",
	WarnSiegeEngineSoon	= "Zeige Warnung, wenn Belagerungsmaschine fast bereit ist",
	ShowGatesHealth		= "Zeige Erhaltungsgrad beschädigter Tore (kann nach dem Beitritt\nzu einem bereits laufenden Schlachtfeld falsche Werte liefern!)"
})

L:SetMiscLocalization({
	GatesHealthFrame		= "Beschädigte Tore",
	SiegeEngine				= "Belagerungsmaschine",
	GoblinStartAlliance		= "Seht Ihr diese Zephyriumbomben? Benutzt sie an den Toren, während ich die Belagerungsmaschine repariere!",
	GoblinStartHorde		= "Ich arbeite an der Belagerungsmaschine. Haltet mir einfach nur den Rücken frei. Benutzt diese Zephyriumbomben an den Toren, solltet Ihr sie brauchen!",
	GoblinHalfwayAlliance	= "Ich hab's gleich! Haltet die Horde von hier fern. Kämpfen stand in der Ingenieursschule nicht auf dem Lehrplan!",
	GoblinHalfwayHorde		= "Ich hab's gleich! Haltet mir die Allianz vom Leib. Kämpfen steht nicht in meinem Vertrag!",
	GoblinFinishedAlliance	= "Meine beste Arbeit bisher! Diese Belagerungsmaschine ist bereit, ein bisschen Aktion zu sehen!",
	GoblinFinishedHorde		= "Die Belagerungsmaschine ist bereit, loszurollen!",
	GoblinBrokenAlliance	= "Es ist schon kaputt?! Ach, keine Sorge, nichts, was ich nicht reparieren kann.",
	GoblinBrokenHorde		= "Schon wieder kaputt?! Ich werde es richten... Ihr solltet allerdings nicht davon ausgehen, dass das noch unter die Garantie fällt."
})

------------------
--  Twin Peaks  --
------------------
L = DBM:GetModLocalization("TwinPeaks")

L:SetGeneralLocalization({
	name = "Zwillingsgipfel"
})

L:SetMiscLocalization({
	BgStart60 			= "Die Schlacht beginnt in 1 Minute.",
	BgStart30 			= "Die Schlacht beginnt in 30 Sekunden. Macht Euch bereit!",
	ZoneName 			= "Zwillingsgipfel",
	Alliance 			= "Allianz",
	Horde 				= "Horde",	
	InfoErrorText		= "Die Zielauswahlfunktion für den Flaggenträger wird bei Kampfende wiederhergestellt.",
	ExprFlagPickUp		= "(.+) hat die Flagge der (%w+) aufgenommen!", -- code is aware of the switched match groups for deDE
	ExprFlagCaptured	= "(.+) hat die Flagge der (%w+) errungen!",
	ExprFlagReturn		= "Die Flagge der (%w+) wurde von (.+) zu ihrem Stützpunkt zurückgebracht!",
	FlagAlliance		= "Allianz-Flagge: ",
	FlagHorde			= "Horde-Flagge: ",
	FlagBase			= "Basis",
	Vulnerable1		= "Eure Angriffe verursachen nun schwerere Verletzungen bei Flaggenträgern!",
	Vulnerable2		= "Eure Angriffe verursachen nun sehr schwere Verletzungen bei Flaggenträgern!"
})

L:SetTimerLocalization({
	TimerStart	= "Kampfbeginn", 
	TimerFlag	= "Flaggen-Respawn"
})

L:SetOptionLocalization({
	TimerStart					= "Zeige Zeit bis Kampfbeginn",
	TimerFlag					= "Zeige Zeit bis zum Respawn der Flaggen",
	ShowFlagCarrier				= "Zeige Flaggenträger",
	ShowFlagCarrierErrorNote	= "Zeige Fehlermeldung, wenn Flaggenträger-Zielauswahl nicht gesetzt werden kann"
})


-------------------------
--  Battle of Gilneas  --
-------------------------
L = DBM:GetModLocalization("Gilneas")

L:SetGeneralLocalization({
	name = "Schlacht um Gilneas"
})

L:SetMiscLocalization({
	ScoreExpr	= "(%d+)/2000",
	Alliance	= "Allianz",
	Horde		= "Horde",
	WinBarText	= "%s gewinnt",
	BasesToWin	= "benötigte Basen für Sieg: %d",
	Flag		= "Flagge"
})

L:SetTimerLocalization({
	TimerCap	= "%s"
})

L:SetOptionLocalization({
	TimerWin				= "Zeige Zeit bis eine Fraktion gewinnt",
	TimerCap				= "Zeige Eroberungsdauer für Basen",
	ShowGilneasEstimatedPoints		= "Zeige geschätzten Endpunktestand",
	ShowGilneasBasesToWin			= "Zeige benötigte Anzahl von Basen zum Sieg"
})