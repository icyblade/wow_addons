local L = BigWigs:NewBossLocale("Beth'tilac", "esES") or BigWigs:NewBossLocale("Beth'tilac", "esMX")
if not L then return end
if L then
	L.flare = GetSpellInfo(100936)
	L.flare_desc = "Show a timer bar for AoE flare."
	L.devastate_message = "Devastación #%d"
	L.drone_bar = "Zángano"
	L.drone_message = "¡Zángano aparece!"
	L.kiss_message = "Beso"
	L.spinner_warn = "Hiladoras #%d"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "esES") or BigWigs:NewBossLocale("Lord Rhyolith", "esMX")
if L then
	L.armor = "Armadura obsidiana"
	L.armor_desc = "Avisar cuando los stacs de armadura estén desapareciendo de Piroclaso."
	L.armor_message = "%d%% armadura restante"
	L.armor_gone_message = "¡Armadura destruida!"

	L.adds_header = "Adds"
	L.big_add_message = "¡Aparece una Chispa!"
	L.small_adds_message = "¡Aparecen fragmentos pequeños!"

	L.phase2_warning = "Fase 2 inminente!"

	L.molten_message = "%dx stacks en el jefe!"

	L.stomp_message = "¡Pisotón! ¡Pisotón! ¡Pisotón!"
	L.stomp = "Pisotón"
end

L = BigWigs:NewBossLocale("Alysrazor", "esES") or BigWigs:NewBossLocale("Alysrazor", "esMX")
if L then
	L.claw_message = "%2$dx Garra en %1$s"
	L.fullpower_soon_message = "¡Poder máximo inminente!"
	L.halfpower_soon_message = "¡Fase 4 inminente!"
	L.encounter_restart = "Aquí vamos otra vez ..."
	L.no_stacks_message = "No sé si te importa, pero no tienes plumas"
	L.moonkin_message = "Deja de fingir y consigue plumas de verdad"
	L.molt_bar = "Siguiente Muda"

	L.meteor = "Meteorito"
	L.meteor_desc = "Avisa cuando un meteorito de lava es invocado."
	L.meteor_message = "¡Meteorito!"

	L.stage_message = "Fase %d"
	L.kill_message = "Ahora o nunca - ¡Mátalo!"
	L.engage_message = "Alysrazor activado - Fase 2 en ~%d min"

	L.worm_emote = "¡Gusanos de lava ígneos surgen del suelo!"
	L.phase2_soon_emote = "Alysrazor empieza a volar rápido en círculos."

	L.flight = "Asistente de vuelo"
	L.flight_desc = "Muestra una barra con la duración de 'Alas de llamas' en ti, es ideal usarlo con la opción de Super Enfatizar."

	L.initiate = "Iniciado aparece"
	L.initiate_desc = "Muestra contadores para reaparición de iniciados."
	L.initiate_both = "Ambos iniciados"
	L.initiate_west = "Iniciado al Oeste"
	L.initiate_east = "Iniciado al Este"
end

L = BigWigs:NewBossLocale("Shannox", "esES") or BigWigs:NewBossLocale("Shannox", "esMX")
if L then
	L.safe = "%s a salvo"
	L.wary_dog = "¡%s es cauteloso!"
	L.crystal_trap = "Prisión de cristal"

	L.traps_header = "Trampas"
	L.immolation = "Trampa de inmolación en Perro"
	L.immolation_desc = "Alerta cuando Rostrofuria o Desmembrador pisen una trampa de inmolación, ganando el bufo 'Cautela'."
	L.immolationyou = "Trampa de inmolación debajo de TI"
	L.immolationyou_desc = "Alerta cuando una trampa de inmolación aparezca debajo de ti."
	L.immolationyou_message = "Trampa de inmolación"
	L.crystal = "Trampa de cristal"
	L.crystal_desc = "Avisa a quien Shannox lance una trampa de cristal debajo."
end

L = BigWigs:NewBossLocale("Baleroc", "esES") or BigWigs:NewBossLocale("Baleroc", "esMX")
if L then
	L.torment = "Stacs de Tormento en Foco"
	L.torment_desc = "Avisa cuando tu /focus gana otro stac de Tormento."

	L.blade_bar = "~Siguiente Hoja"
	L.shard_message = "¡Fragmento morado (%d)!"
	L.focus_message = "¡Tu foco tiene %d stacks!"
	L.link_message = "Enlazado"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "esES") or BigWigs:NewBossLocale("Majordomo Staghelm", "esMX")
if L then
	L.seed_explosion = "¡Explotarás pronto!"
	L.seed_bar = "¡Explotas!"
	L.adrenaline_message = "¡Adrenalina x%d!"
	L.leap_say = "¡Salto en MI!"
end

L = BigWigs:NewBossLocale("Ragnaros", "esES") or BigWigs:NewBossLocale("Ragnaros", "esMX")
if L then
	L.intermission_end_trigger1 = "Sulfuras será vuestro fin."
	L.intermission_end_trigger2 = "¡De rodillas, mortales! Esto termina ahora."
	L.intermission_end_trigger3 = "¡Basta! Yo terminaré esto."
	L.phase4_trigger = "¡Pronto!... Habéis venido demasiado pronto..." --verificar
	L.seed_explosion = "¡Explosión de semillas!"
	L.intermission_bar = "¡Intermisión!"
	L.intermission_message = "Intermisión... ¿Tienes galletas?"
	L.sons_left = "%d |4hijo restante:hijos restantes;"
	L.engulfing_close = "¡Sección cercana sumergida!"
	L.engulfing_middle = "¡Sección central sumergida!"
	L.engulfing_far = "¡Sección lejana sumergida"
	L.hand_bar = "Rebote"
	L.ragnaros_back_message = "¡Raggy ha vuelto, fiesta!"

	L.wound = "Herida ardiente"
	L.wound_desc = "Alerta solo para tanques. Cuenta los stacs de herida ardiente y muestra una barra con su duración."
	L.wound_message = "%2$dx Herida en %1$s"
end

