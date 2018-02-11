if not(GetLocale() == "frFR") then
  return
end

local L = WeakAuras.L

-- WeakAuras/Options
	L["-- Do not remove this comment, it is part of this trigger: "] = "-- Ne retirez pas ce commentaire, il fait partie de ce déclencheur : "
	L["% of Progress"] = "% de progression"
	L["%i Matches"] = "%i Correspondances"
	--Translation missing 
	-- L["%s Color"] = ""
	--Translation missing 
	-- L["%s total auras"] = ""
	L["1 Match"] = "1 Correspondance"
	L["1. Text"] = "1. Texte"
	L["1. Text Settings"] = "1. Paramètres du Texte"
	L["2. Text"] = "2. Texte"
	L["2. Text Settings"] = "2. Paramètres du Texte"
	L["A 20x20 pixels icon"] = "Une icône de 20x20 pixels."
	L["A 32x32 pixels icon"] = "Une icône de 32x32 pixels."
	L["A 40x40 pixels icon"] = "Une icône de 40x40 pixels."
	L["A 48x48 pixels icon"] = "Une icône de 48x48 pixels."
	L["A 64x64 pixels icon"] = "Une icône de 64x64 pixels."
	L["A group that dynamically controls the positioning of its children"] = "Un groupe qui contrôle dynamiquement le positionnement de ses enfants"
	L["Actions"] = "Actions"
	L["Activate when the given aura(s) |cFFFF0000can't|r be found"] = "Activer quand l'aura |cFFFF0000ne peut|r être trouvée"
	--Translation missing 
	-- L["Add a new display"] = ""
	--Translation missing 
	-- L["Add Condition"] = ""
	--Translation missing 
	-- L["Add Overlay"] = ""
	--Translation missing 
	-- L["Add Property Change"] = ""
	--Translation missing 
	-- L["Add to group %s"] = ""
	L["Add to new Dynamic Group"] = "Ajouter à un nouveau groupe dynamique"
	L["Add to new Group"] = "Ajouter à un nouveau groupe"
	L["Add Trigger"] = "Ajouter un déclencheur"
	L["Addon"] = "Addon"
	L["Addons"] = "Addons"
	L["Align"] = "Aligner"
	L["Allow Full Rotation"] = "Permettre une rotation complète"
	L["Alpha"] = "Alpha"
	L["Anchor"] = "Ancrage"
	L["Anchor Point"] = "Point d'ancrage"
	L["anchored to"] = "accrocher à"
	L["Anchored To"] = "Accrocher à"
	--Translation missing 
	-- L["And "] = ""
	L["Angle"] = "Angle"
	L["Animate"] = "Animer"
	L["Animated Expand and Collapse"] = "Expansion et réduction animés"
	--Translation missing 
	-- L["Animates progress changes"] = ""
	L["Animation relative duration description"] = [=[La durée de l'animation par rapport à la durée du graphique, exprimée en fraction (1/2), pourcentage (50%), ou décimal (0.5).
|cFFFF0000Note :|r si un graphique n'a pas de progression (déclencheur d'événement sans durée définie, aura sans durée, etc), l'animation ne jouera pas.

|cFF4444FFPar exemple :|r
Si la durée de l'animation est définie à |cFF00CC0010%|r, et le déclencheur du graphique est une amélioration qui dure 20 secondes, l'animation de début jouera pendant 2 secondes.
Si la durée de l'animation est définie à |cFF00CC0010%|r, et le déclencheur du graphique n'a pas de durée définie, aucune d'animation de début ne jouera (mais elle jouerait si vous aviez spécifié une durée en secondes).
]=]
	L["Animation Sequence"] = "Séquence d'animation"
	L["Animations"] = "Animations"
	L["Apply Template"] = "Appliquer le modèle"
	L["Arcane Orb"] = "Orbe d'arcane"
	L["At a position a bit left of Left HUD position."] = "Une position à gauche de la Position ATH Gauche."
	L["At a position a bit left of Right HUD position"] = "Une position à droite de la Position ATH Droite."
	L["At the same position as Blizzard's spell alert"] = "À la même position que l'alerte de sort de Blizzard."
	L["Aura Name"] = "Nom de l'aura"
	L["Aura Type"] = "Type de l'aura"
	L["Aura(s)"] = "Aura(s)"
	--Translation missing 
	-- L["Aura:"] = ""
	--Translation missing 
	-- L["Auras:"] = ""
	L["Auto"] = "Auto"
	--Translation missing 
	-- L["Auto-cloning enabled"] = ""
	L["Automatic Icon"] = "Icône automatique"
	L["Backdrop Color"] = "Couleur de Fond"
	--Translation missing 
	-- L["Backdrop in Front"] = ""
	L["Backdrop Style"] = "Style de Fond"
	L["Background"] = "Arrière-plan"
	L["Background Color"] = "Couleur de fond"
	L["Background Inset"] = "Encart d'arrière-plan"
	L["Background Offset"] = "Décalage du Fond "
	L["Background Texture"] = "Texture du Fond"
	L["Bar Alpha"] = "Alpha de la Barre"
	L["Bar Color"] = "Couleur de barre"
	L["Bar Color Settings"] = "Réglages Couleur de Barre"
	L["Bar in Front"] = "Barre devant"
	L["Bar Texture"] = "Texture de barre"
	L["Big Icon"] = "Grande icône"
	L["Blend Mode"] = "Mode du fusion"
	L["Blue Rune"] = "Rune bleue"
	L["Blue Sparkle Orb"] = "Orbe pétillant bleu"
	L["Border"] = "Bordure"
	L["Border Color"] = "Couleur de Bordure"
	--Translation missing 
	-- L["Border in Front"] = ""
	L["Border Inset"] = "Encart Fond"
	L["Border Offset"] = "Décalage Bordure"
	L["Border Settings"] = "Réglages de Bordure"
	L["Border Size"] = "Taille de Bordure"
	L["Border Style"] = "Style de Bordure"
	L["Bottom Text"] = "Texte du bas"
	--Translation missing 
	-- L["Bracket Matching"] = ""
	L["Button Glow"] = "Bouton en surbrillance"
	--Translation missing 
	-- L["Can be a name or a UID (e.g., party1). A name only works on friendly players in your group."] = ""
	L["Can be a name or a UID (e.g., party1). Only works on friendly players in your group."] = "Peut être un nom ou un UID (par ex. party1). Fonctionne uniquement pour les joueurs amicaux de votre groupe."
	L["Cancel"] = "Annuler"
	L["Channel Number"] = "Numéro de canal"
	L["Chat Message"] = "Message dans le chat"
	L["Check On..."] = "Vérifier sur..."
	L["Children:"] = "Enfant :"
	L["Choose"] = "Choisir"
	L["Choose Trigger"] = "Choisir un déclencheur"
	L["Choose whether the displayed icon is automatic or defined manually"] = "Choisir si l'icône affichée est automatique ou définie manuellement"
	L["Clone option enabled dialog"] = [=[
Vous avez activé une option qui utilise l'|cFFFF0000Auto-clonage|r.

L'|cFFFF0000Auto-clonage|r permet à un graphique d'être automatiquement dupliqué pour afficher plusieurs sources d'information.
A moins que vous mettiez ce graphique dans un |cFF22AA22Groupe Dynamique|r, tous les clones seront affichés en tas l'un sur l'autre.

Souhaitez-vous que ce graphiques soit placé dans un nouveau |cFF22AA22Groupe Dynamique|r ?]=]
	L["Close"] = "Fermer"
	--Translation missing 
	-- L["Collapse"] = ""
	L["Collapse all loaded displays"] = "Réduire tous les graphiques chargés"
	L["Collapse all non-loaded displays"] = "Réduire tous les graphiques non-chargés"
	L["Color"] = "Couleur"
	--Translation missing 
	-- L["color"] = ""
	L["Compress"] = "Compresser"
	L["Conditions"] = "Conditions"
	L["Constant Factor"] = "Facteur constant"
	--Translation missing 
	-- L["Control-click to select multiple displays"] = ""
	L["Controls the positioning and configuration of multiple displays at the same time"] = "Contrôle la position et la configuration de plusieurs graphiques en même temps"
	--Translation missing 
	-- L["Convert to..."] = ""
	L["Cooldown"] = "Recharge"
	--Translation missing 
	-- L["Copy settings from %s"] = ""
	--Translation missing 
	-- L["Copy settings from..."] = ""
	--Translation missing 
	-- L["Copy to all auras"] = ""
	--Translation missing 
	-- L["Copy URL"] = ""
	L["Count"] = "Compte"
	L["Creating buttons: "] = "Création de boutons :"
	L["Creating options: "] = "Création d'options :"
	L["Crop"] = "Couper"
	L["Crop X"] = "Couper X"
	L["Crop Y"] = "Couper Y"
	L["Custom"] = "Personnalisé"
	L["Custom Code"] = "Code personnalisé"
	L["Custom Function"] = "Fonction personnalisée"
	L["Custom Trigger"] = "Déclencheur personnalisé"
	L["Custom trigger event tooltip"] = [=[
Choisissez quels évènements peuvent activer le déclencheur.
Plusieurs évènements peuvent être spécifiés avec des virgules ou des espaces.

|cFF4444FFPar exemple:|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED
]=]
	L["Custom trigger status tooltip"] = [=[
Choisissez quels évènements peuvent activer le déclencheur.
Comme c'est un déclencheur de type statut, les évènements spécifiés peuvent être appelés par WeakAuras sans les arguments attendus.
Plusieurs évènements peuvent être spécifiés avec des virgules ou des espaces.

|cFF4444FFPar exemple:|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED
]=]
	L["Custom Untrigger"] = "Désactivation personnalisée"
	L["Debuff Type"] = "Type d'affaiblissement"
	L["Default"] = "Par défaut"
	--Translation missing 
	-- L["Delete"] = ""
	L["Delete all"] = "Supprimer tout"
	--Translation missing 
	-- L["Delete children and group"] = ""
	L["Delete Trigger"] = "Supprimer le déclencheur"
	L["Desaturate"] = "Dé-saturer"
	--Translation missing 
	-- L["Differences"] = ""
	--Translation missing 
	-- L["Disable Import"] = ""
	L["Disabled"] = "Désactivé"
	L["Discrete Rotation"] = "Rotation individuelle"
	L["Display"] = "Graphique"
	L["Display Icon"] = "Icône du graphique"
	L["Display Text"] = "Texte du graphique"
	L["Displays a text, works best in combination with other displays"] = "Affiche du texte. Marche le mieux en le combinant à d'autres graphiques."
	L["Distribute Horizontally"] = "Distribuer horizontalement"
	L["Distribute Vertically"] = "Distribuer verticalement"
	--Translation missing 
	-- L["Do not copy any settings"] = ""
	--Translation missing 
	-- L["Do not group this display"] = ""
	L["Done"] = "Terminé"
	--Translation missing 
	-- L["Drag to move"] = ""
	--Translation missing 
	-- L["Duplicate"] = ""
	--Translation missing 
	-- L["Duplicate All"] = ""
	L["Duration (s)"] = "Durée (s)"
	L["Duration Info"] = "Info de durée"
	L["Dynamic Group"] = "Groupe Dynamique"
	L["Dynamic information"] = "Information dynamique"
	--Translation missing 
	-- L["Dynamic Information"] = ""
	--Translation missing 
	-- L["Dynamic information from first active trigger"] = ""
	L["Dynamic information from first Active Trigger"] = "Information dynamique du premier Déclencheur activé"
	L["Dynamic information from Trigger %i"] = "Information dynamique du Déclencheur %i"
	L["Dynamic text tooltip"] = [=[Il y a plusieurs codes spéciaux disponibles pour rendre ce texte dynamique :

|cFFFF0000%p|r - Progression - Le temps restant sur un compteur, ou une valeur autre
|cFFFF0000%t|r - Total - La durée maximum d'un compteur, ou le maximum d'une valeur autre
|cFFFF0000%n|r - Nom - Le nom du graphique (souvent le nom d'une aura), ou l'ID du graphique s'il n'y a pas de nom dynamique
|cFFFF0000%i|r - Icône - L'icône associée à l'affichage
|cFFFF0000%s|r - Pile - La taille de la pile d'une aura (généralement)
|cFFFF0000%c|r - Personnalisé - Vous permet de définir une fonction Lua personnalisée qui donne un texte à afficher]=]
	L["Enabled"] = "Activé"
	L["End Angle"] = "Angle de fin"
	L["Enter an aura name, partial aura name, or spell id"] = "Entrez un nom d'aura, nom d'aura partiel ou ID de sort"
	L["Event"] = "Évènement"
	L["Event Type"] = "Type d'évènement"
	L["Event(s)"] = "Évènement(s)"
	--Translation missing 
	-- L["Expand"] = ""
	L["Expand all loaded displays"] = "Agrandir tous graphiques chargés"
	L["Expand all non-loaded displays"] = "Agrandir tous graphiques non-chargés"
	L["Expand Text Editor"] = "Agrandir éditeur de texte"
	--Translation missing 
	-- L["Expansion is disabled because this group has no children"] = ""
	--Translation missing 
	-- L["Export to Lua table..."] = ""
	--Translation missing 
	-- L["Export to string..."] = ""
	L["Fade"] = "Fondu"
	L["Fade In"] = "Fondu entrant"
	L["Fade Out"] = "Fondu sortant"
	--Translation missing 
	-- L["False"] = ""
	L["Finish"] = "Finir"
	L["Fire Orb"] = "Orbe de feu"
	L["Font"] = "Police"
	L["Font Flags"] = "Style de Police"
	L["Font Size"] = "Taille de Police"
	L["Font Type"] = "Type de police"
	L["Foreground Color"] = "Couleur premier-plan"
	L["Foreground Texture"] = "Texture premier-plan"
	L["Frame"] = "Cadre"
	L["Frame Strata"] = "Strate du cadre"
	--Translation missing 
	-- L["frame's"] = ""
	L["From Template"] = "D'après un modèle"
	--Translation missing 
	-- L["Full Scan"] = ""
	--Translation missing 
	-- L["General Text Settings"] = ""
	L["Glow"] = "Surbrillance"
	L["Glow Action"] = "Action de l'éclat"
	L["Green Rune"] = "Rune verte"
	L["Group"] = "Groupe"
	--Translation missing 
	-- L["Group (verb)"] = ""
	L["Group aura count description"] = [=[Le nombre de membres du %s qui doivent être affectés par une ou plusieurs des auras sélectionnées pour que l'affichage soit déclenché.
Si le nombre entré est un entier (ex. 5), le nombre de membres du raid affectés sera comparé au nombre entré.
Si le nombre entré est decimal (ex. 0.5), une fraction (ex. 1/2), ou un pourcentage (ex. 50%%), alors cette fraction du %s doit être affectée.

|cFF4444FFPar exemple :|r
|cFF00CC00> 0|r se déclenchera quand n'importe quel membre du %s est affecté
|cFF00CC00= 100%%|r se déclenchera quand tous les membres du %s sont affectés
|cFF00CC00!= 2|r se déclenchera quand le nombre de membres du %s affectés est différent de 2
|cFF00CC00<= 0.8|r se déclenchera quand moins de 80%% du %s est affecté (4 des 5 membres du groupe, 8 des 10 ou 20 des 25 membres du raid )
|cFF00CC00> 1/2|r se déclenchera quand plus de la moitié du %s est affecté
|cFF00CC00>= 0|r se déclenchera toujours, quoi qu'il arrive
]=]
	L["Group Member Count"] = "Nombre de membres du groupe"
	L["Grow"] = "Grandir"
	L["Hawk"] = "Faucon"
	L["Height"] = "Hauteur"
	L["Hide"] = "Cacher"
	L["Hide on"] = "Cacher à"
	--Translation missing 
	-- L["Hide this group's children"] = ""
	L["Hide When Not In Group"] = "Cacher hors d'un groupe"
	L["Horizontal Align"] = "Aligner horizontalement"
	L["Horizontal Bar"] = "Barre horizontale"
	L["Horizontal Blizzard Raid Bar"] = "Barre de raid horizontale de Blizzard"
	L["Huge Icon"] = "Énorme icône"
	L["Hybrid Position"] = "Position hybride"
	L["Hybrid Sort Mode"] = "Mode de tri hybride"
	L["Icon"] = "Icône"
	L["Icon Color"] = "Couleur d'icône"
	L["Icon Info"] = "Info d'icône"
	L["Icon Inset"] = "Objet inséré"
	--Translation missing 
	-- L["If"] = ""
	--Translation missing 
	-- L["If this option is enabled, you are no longer able to import auras."] = ""
	--Translation missing 
	-- L["If Trigger %s"] = ""
	L["Ignored"] = "Ignoré"
	L["Import"] = "Importer"
	L["Import a display from an encoded string"] = "Importer un graphique d'un texte encodé"
	L["Inverse"] = "Inverser"
	L["Justify"] = "Justification"
	--Translation missing 
	-- L["Keep Aspect Ratio"] = ""
	L["Leaf"] = "Feuille"
	L["Left 2 HUD position"] = "Position ATH Gauche 2"
	L["Left HUD position"] = "Position ATH Gauche"
	L["Left Text"] = "Texte de gauche"
	L["Load"] = "Charger"
	L["Loaded"] = "Chargé"
	--Translation missing 
	-- L["Loop"] = ""
	L["Low Mana"] = "Mana bas"
	L["Main"] = "Principal"
	L["Manage displays defined by Addons"] = "Gérer graphiques définis par addons"
	L["Medium Icon"] = "Icône moyenne"
	L["Message"] = "Message"
	L["Message Prefix"] = "Préfixe du message"
	L["Message Suffix"] = "Suffixe du message"
	L["Message Type"] = "Type de message"
	--Translation missing 
	-- L["Message type:"] = ""
	L["Mirror"] = "Miroir"
	L["Model"] = "Modèle"
	--Translation missing 
	-- L["Move Down"] = ""
	--Translation missing 
	-- L["Move this display down in its group's order"] = ""
	--Translation missing 
	-- L["Move this display up in its group's order"] = ""
	--Translation missing 
	-- L["Move Up"] = ""
	L["Multiple Displays"] = "Graphiques multiples"
	L["Multiple Triggers"] = "Déclencheur multiples"
	L["Multiselect ignored tooltip"] = [=[
|cFFFF0000Ignoré|r - |cFF777777Unique|r - |cFF777777Multiple|r
Cette option ne sera pas utilisée pour déterminer quand ce graphique doit être chargé]=]
	L["Multiselect multiple tooltip"] = [=[
|cFF777777Ignoré|r - |cFF777777Unique|r - |cFF00FF00Multiple|r
Plusieurs valeurs peuvent être choisies]=]
	L["Multiselect single tooltip"] = [=[
|cFF777777Ignoré|r - |cFF00FF00Unique|r - |cFF777777Multiple|r
Seule une unique valeur peut être choisie]=]
	L["Name Info"] = "Info du nom"
	L["Negator"] = "Pas"
	L["Never"] = "Jamais"
	L["New"] = "Nouveau"
	L["No"] = "Non"
	--Translation missing 
	-- L["No Children"] = ""
	L["No tooltip text"] = "Pas d'infobulle"
	L["None"] = "Aucun"
	L["Not all children have the same value for this option"] = "Tous les enfants n'ont pas la même valeur pour cette option"
	L["Not Loaded"] = "Non chargé"
	L["Offer a guided way to create auras for your class"] = "Un guide pour aider à créer des auras pour votre classe."
	L["Okay"] = "Okay"
	L["On Hide"] = "Au masquage"
	L["On Init"] = "À l'initialisation"
	L["On Show"] = "A l'affichage"
	L["Only match auras cast by people other than the player"] = "Ne considérer que les auras lancées par d'autres que le joueur"
	L["Only match auras cast by the player"] = "Ne considérer que les auras lancées par le joueur"
	L["Operator"] = "Opérateur"
	L["or"] = "ou"
	L["Orange Rune"] = "Rune orange"
	L["Orientation"] = "Orientation"
	L["Outline"] = "Contour"
	--Translation missing 
	-- L["Overflow"] = ""
	--Translation missing 
	-- L["Overlay %s Info"] = ""
	--Translation missing 
	-- L["Overlays"] = ""
	L["Own Only"] = "Le mien uniquement"
	L["Paste text below"] = "Coller le texte ci-dessous"
	L["Play Sound"] = "Jouer un son"
	L["Portrait Zoom"] = "Zoom Portrait"
	L["Preset"] = "Preset"
	L["Prevents duration information from decreasing when an aura refreshes. May cause problems if used with multiple auras with different durations."] = "Empêche l'info de durée de décroitre quand une aura est rafraichie. Peut causer des problèmes si utilisé avec plusieurs auras de différentes durées."
	L["Processed %i chars"] = "Traité %i caractères"
	L["Progress Bar"] = "Barre de progression"
	L["Progress Texture"] = "Texture de progression"
	L["Purple Rune"] = "Rune violette"
	--Translation missing 
	-- L["Put this display in a group"] = ""
	L["Radius"] = "Rayon"
	L["Re-center X"] = "Recentrer X"
	L["Re-center Y"] = "Recentrer Y"
	L["Remaining Time"] = "Temps restant"
	L["Remaining Time Precision"] = "Précision du temps restant"
	--Translation missing 
	-- L["Remove"] = ""
	--Translation missing 
	-- L["Remove this condition"] = ""
	--Translation missing 
	-- L["Remove this display from its group"] = ""
	--Translation missing 
	-- L["Remove this property"] = ""
	--Translation missing 
	-- L["Rename"] = ""
	--Translation missing 
	-- L["Repeat After"] = ""
	--Translation missing 
	-- L["Repeat every"] = ""
	L["Required for Activation"] = "Requis pour l'activation"
	L["Required For Activation"] = "Requis pour l'activation"
	L["Right 2 HUD position"] = "Position ATH Droite 2"
	L["Right HUD position"] = "Position ATH Droite"
	L["Right Text"] = "Texte de droite"
	L["Right-click for more options"] = "Clic-droit pour plus d'options"
	L["Rotate"] = "Tourner"
	L["Rotate In"] = "Rotation entrante"
	L["Rotate Out"] = "Rotation sortante"
	L["Rotate Text"] = "Tourner le texte"
	L["Rotation"] = "Rotation"
	L["Rotation Mode"] = "Mode de rotation"
	L["Same"] = "Le même"
	L["Scale"] = "Échelle"
	L["Search"] = "Chrecher"
	L["Select the auras you always want to be listed first"] = "Choisissez les auras que vous voulez toujours voir apparaître en premier dans la liste"
	L["Send To"] = "Envoyer vers"
	--Translation missing 
	-- L["Set Parent to Anchor"] = ""
	--Translation missing 
	-- L["Set tooltip description"] = ""
	--Translation missing 
	-- L["Settings"] = ""
	--Translation missing 
	-- L["Shift-click to create chat link"] = ""
	L["Show all matches (Auto-clone)"] = "Montrer toutes correspondances (Auto-Clone)"
	--Translation missing 
	-- L["Show Cooldown Text"] = ""
	--Translation missing 
	-- L["Show If Unit Is Invalid"] = ""
	L["Show model of unit "] = "Montrer le modèle de l'unité"
	--Translation missing 
	-- L["Show On"] = ""
	L["Show players that are |cFFFF0000not affected"] = "Montrer les joueurs |cFFFF0000non-affectés"
	--Translation missing 
	-- L["Show this group's children"] = ""
	L["Shows a 3D model from the game files"] = "Montre un modèle 3D tiré du jeu"
	L["Shows a custom texture"] = "Montre une texture personnalisée"
	L["Shows a progress bar with name, timer, and icon"] = "Affiche une barre de progression avec nom, temps, icône"
	L["Shows a spell icon with an optional cooldown overlay"] = "Affiche une icône de sort avec optionnellement la recharge sur-imprimée"
	L["Shows a texture that changes based on duration"] = "Affiche une texture qui change selon la durée"
	L["Shows one or more lines of text, which can include dynamic information such as progress or stacks"] = "Affiche une ligne de texte ou plus, qui peut inclure des infos dynamiques telles que progression ou piles."
	L["Size"] = "Taille"
	L["Slide"] = "Glisser"
	L["Slide In"] = "Glisser entrant"
	L["Slide Out"] = "Glisser sortant"
	L["Small Icon"] = "Petite icône"
	--Translation missing 
	-- L["Smooth Progress"] = ""
	L["Sort"] = "Trier"
	L["Sound"] = "Son"
	L["Sound Channel"] = "Canal sonore"
	L["Sound File Path"] = "Chemin fichier son"
	L["Sound Kit ID"] = "ID Kit Son"
	L["Space"] = "Espacer"
	L["Space Horizontally"] = "Espacer horizontalement"
	L["Space Vertically"] = "Espacer verticalement"
	L["Spark"] = "Étincelle"
	L["Spark Settings"] = "Réglage Étincelle"
	L["Spark Texture"] = "Texture Étincelle"
	L["Specific Unit"] = "Unité spécifique"
	L["Spell ID"] = "ID de sort"
	L["Spell ID dialog"] = [=[Vous avez spécifié une aura par |cFFFF0000ID de sort|r.

Par défaut, |cFF8800FFWeakAuras|r ne peut distinguer entre des auras de même nom mais d'|cFFFF0000ID de sort|r différents.
Cependant, si l'option Scan Complet est activée, |cFF8800FFWeakAuras|r peut chercher des |cFFFF0000ID de sorts|r spécifiques.

Voulez-vous activer le Scan Complet pour chercher cet |cFFFF0000ID de sort|r ?]=]
	L["Stack Count"] = "Nombre de Piles"
	L["Stack Info"] = "Info de Piles"
	L["Stacks"] = "Piles"
	L["Stacks Settings"] = "Réglages de Piles"
	L["Stagger"] = "Report"
	L["Star"] = "Étoile"
	L["Start"] = "Début"
	L["Start Angle"] = "Angle de départ"
	L["Status"] = "Statut"
	L["Stealable"] = "Volable"
	L["Sticky Duration"] = "Durée épinglée"
	--Translation missing 
	-- L["Stop Sound"] = ""
	L["Symbol Settings"] = "Réglages de symbole"
	L["Temporary Group"] = "Groupe temporaire"
	L["Text"] = "Texte"
	L["Text Color"] = "Couleur Texte"
	L["Text Position"] = "Position du Texte"
	L["Texture"] = "Texture"
	L["Texture Info"] = "Info Texture"
	--Translation missing 
	-- L["Texture Wrap"] = ""
	L["The children of this group have different display types, so their display options cannot be set as a group."] = "Les enfants de ce groupe ont différent types de graphiques, leurs options de graphique ne peuvent donc pas être changées en groupe."
	L["The duration of the animation in seconds."] = "La durée de l'animation en secondes."
	--Translation missing 
	-- L["The duration of the animation in seconds. The finish animation does not start playing until after the display would normally be hidden."] = ""
	L["The type of trigger"] = "Le type de déclencheur"
	--Translation missing 
	-- L["Then "] = ""
	--Translation missing 
	-- L["This display is currently loaded"] = ""
	--Translation missing 
	-- L["This display is not currently loaded"] = ""
	L["This region of type \"%s\" is not supported."] = "Cette région de type \"%s\" n'est pas supportée."
	L["Time in"] = "Temps entrant"
	L["Tiny Icon"] = "Très petite icône"
	--Translation missing 
	-- L["To Frame's"] = ""
	L["to group's"] = "au groupe..."
	--Translation missing 
	-- L["To Personal Ressource Display's"] = ""
	--Translation missing 
	-- L["to Personal Ressource Display's"] = ""
	--Translation missing 
	-- L["To Screen's"] = ""
	L["to screen's"] = "à l'écran..."
	L["Toggle the visibility of all loaded displays"] = "Change la visibilité de tous les graphiques chargés"
	L["Toggle the visibility of all non-loaded displays"] = "Change la visibilité de tous les graphiques non-chargés"
	--Translation missing 
	-- L["Toggle the visibility of this display"] = ""
	L["Tooltip"] = "Infobulle"
	L["Tooltip on Mouseover"] = "Infobulle à la souris"
	L["Top HUD position"] = "Position ATH Haute"
	L["Top Text"] = "Texte du Haut"
	L["Total Time Precision"] = "Précision Temps total"
	L["Trigger"] = "Déclencheur"
	L["Trigger %d"] = "Déclencheur %d"
	--Translation missing 
	-- L["Trigger:"] = ""
	--Translation missing 
	-- L["True"] = ""
	L["Type"] = "Type"
	--Translation missing 
	-- L["Undefined"] = ""
	--Translation missing 
	-- L["Ungroup"] = ""
	L["Unit"] = "Unité"
	L["Unlike the start or finish animations, the main animation will loop over and over until the display is hidden."] = "Contrairement aux animations de début et de fin, l'animation principale bouclera tant que le graphique est visible."
	L["Update Custom Text On..."] = "Mettre à jour Texte Perso sur..."
	L["Use Full Scan (High CPU)"] = "Utiliser Scan Complet (CPU élevé)"
	--Translation missing 
	-- L["Use SetTransform (will change behaviour in 7.3)"] = ""
	L["Use SetTransform api"] = "Utiliser l'api SetTransform"
	L["Use tooltip \"size\" instead of stacks"] = "Utiliser la \"taille\" de l'infobulle plutôt que la pile"
	--Translation missing 
	-- L["Used in auras:"] = ""
	--Translation missing 
	-- L["Version: "] = ""
	L["Vertical Align"] = "Aligner verticalement"
	L["Vertical Bar"] = "Barre verticale"
	--Translation missing 
	-- L["View"] = ""
	L["WeakAurasOptions"] = "Options WeakAuras"
	L["Width"] = "Largeur"
	L["X Offset"] = "Décalage X"
	L["X Rotation"] = "Rotation X"
	L["X Scale"] = "Echelle X"
	L["Y Offset"] = "Décalage Y"
	L["Y Rotation"] = "Rotation Y"
	L["Y Scale"] = "Echelle Y"
	L["Yellow Rune"] = "Rune jaune"
	L["Yes"] = "Oui"
	L["Z Offset"] = "Décalage Z"
	L["Z Rotation"] = "Rotation Z"
	L["Zoom"] = "Zoom"
	L["Zoom In"] = "Zoom entrant"
	L["Zoom Out"] = "Zoom sortant"

