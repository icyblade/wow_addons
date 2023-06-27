﻿if GetLocale() ~= "esES" and GetLocale() ~= "esMX" then return end

local L

------------
--  Omen  --
------------
L = DBM:GetModLocalization("Omen")

L:SetGeneralLocalization({
	name = "Omen"
})

-----------------------
--  Apothecary Trio  --
-----------------------
L = DBM:GetModLocalization("ApothecaryTrio")

L:SetGeneralLocalization({
	name = "Los Tres Boticarios"
})

L:SetTimerLocalization{
	HummelActive	= "Hummel se activa",
	BaxterActive	= "Baxter se activa",
	FryeActive		= "Frye se activa"
}

L:SetOptionLocalization({
	TrioActiveTimer		= "Mostrar tiempo para que los Boticarios se activen"
})

L:SetMiscLocalization({
	SayCombatStart		= "¿Se han molestado en decirte quién soy y por qué estoy haciendo esto?"
})

-----------------------
--  Lord Ahune  --
-----------------------
L = DBM:GetModLocalization("Ahune")

L:SetGeneralLocalization({
	name = "Ahune"
})

L:SetWarningLocalization({
	Submerged		= "Ahune se sumerge",
	Emerged			= "Ahune emerge",
	specWarnAttack	= "Ahune es vulnerable ¡Ataca ahora!"
})

L:SetTimerLocalization{
	SubmergTimer	= "Se sumerge",
	EmergeTimer		= "Emerge",
	TimerCombat		= "Inicio del combate"
}

L:SetOptionLocalization({
	Submerged		= "Mostrar aviso cuando Ahune se sumerge",
	Emerged			= "Mostrar aviso cuando Ahune emerge",
	specWarnAttack	= "Mostrar aviso especial cuando Ahune es vulnerable",
	SubmergTimer	= "Mostrar tiempo para sumersión",
	EmergeTimer		= "Mostrar tiempo para emersión",
	TimerCombat		= "Mostrar tiempo para inicio del combate",
})

L:SetMiscLocalization({
	Pull			= "¡La piedra de hielo se ha derretido!"
})

-------------------
-- Coren Direbrew --
-------------------
L = DBM:GetModLocalization("CorenDirebrew")

L:SetGeneralLocalization({
	name = "Coren Cerveza Temible"
})

L:SetWarningLocalization({
	specWarnBrew		= "¡Bebete la cerveza antes de que lanze otra!",
	specWarnBrewStun		= "SUGERENCIA: ¡Te han dado! ¡Acuerdate de beber la cerveza si te han lanzado!"
})

L:SetOptionLocalization({
	specWarnBrew		= "Mostrar aviso especial para $spell:47376",
	specWarnBrewStun		= "Mostrar aviso especial para $spell:47340",
	YellOnBarrel	= "Avisar si $spell:51413"
})

L:SetMiscLocalization({
	YellBarrel		= "¡Tengo el Barril!"
})

-------------------
-- Headless Horseman --
-------------------
L = DBM:GetModLocalization("HeadlessHorseman")

L:SetGeneralLocalization({
	name = "El Jinete decapitado"
})

L:SetWarningLocalization({
	WarnPhase				= "Fase %d",
	warnHorsemanSoldiers	= "Salen las Calabazas con pulso",
	warnHorsemanHead		= "¡Torbellino! ¡Mata a la cabeza!"
})

L:SetTimerLocalization{
	TimerCombatStart		= "Empieza el combate"
}

L:SetOptionLocalization({
	WarnPhase				= "Mostrar un aviso para cada cambio de fase",
	TimerCombatStart		= "Mostrar tiempo para inicio del combate",	
	warnHorsemanSoldiers	= "Mostrar aviso a la llegada de Calabazas con pulso",
	warnHorsemanHead		= "Mostrar un aviso para torbellino (2ª i posteriores apariciones de cabeza)"
})

L:SetMiscLocalization({
	HorsemanSummon				= "Jinete álzate...",
	HorsemanSoldiers			= "Soldados, alzaos y luchad, tomad vuestro acero. Dad la victoria a este deshonrado caballero."
})

------------------------------
--  The Abominable Greench  --
------------------------------
L = DBM:GetModLocalization("Greench")

L:SetGeneralLocalization({
	name = "The Abominable Greench"
})

--------------------------
--  Blastenheimer 5000  --
--------------------------
L = DBM:GetModLocalization("Cannon")

L:SetGeneralLocalization({
	name = "Ultracañón Pimpampum 5000"
})

-------------
--  Gnoll  --
-------------
L = DBM:GetModLocalization("Gnoll")

L:SetGeneralLocalization({
	name = "Golpea al gnoll"
})

L:SetWarningLocalization({
	warnGameOverQuest	= "Has ganado %d puntos de %d puntos posibles",
	warnGameOverNoQuest	= "El juego terminó con un total de %d puntos posibles",
	warnGnoll		= "Sale un Gnoll",
	warnHogger		= "Sale Hogger",
	specWarnHogger	= "¡Sale Hogger!"
})

L:SetOptionLocalization({
	warnGameOver	= "Anunciar total de puntos posibles al terminar el juego",
	warnGnoll		= "Anunciar cuando sale un Gnoll",
	warnHogger		= "Anunciar cuando sale un Hogger",
	specWarnHogger	= "Mostrar aviso especial cuando sale un Hogger"
})

------------------------
--  Shooting Gallery  --
------------------------
L = DBM:GetModLocalization("Shot")

L:SetGeneralLocalization({
	name = "Galería de tiro"
})

L:SetOptionLocalization({
	SetBubbles			= "Desactiva los bocadillos de chat durante $spell:101871\n(se restauran una vez finalizada la partida)"
})

----------------------
--  Tonk Challenge  --
----------------------
L = DBM:GetModLocalization("Tonks")

L:SetGeneralLocalization({
	name = "Combate de tonques"
})
