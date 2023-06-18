

local addonName = ...
local _detalhes	= 	_G._detalhes
local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

local CreateFrame, pairs, UIParent, UnitGUID, tonumber, LoggingCombat, UnitName, strlen, IsInRaid = CreateFrame, pairs, UIParent, UnitGUID, tonumber, LoggingCombat, UnitName, strlen, IsInRaid

function _detalhes:InitializeSlashCommands()
	for k, v in pairs({ addonName:lower(), "dt", "de" }) do
		_G["SLASH_"..addonName:upper()..k] = "/" .. v
	end
	SlashCmdList[addonName:upper()] = function(...) self:ParseParameters(...) end
end

function _detalhes:ParseParameters(msg, editbox)
	local command, rest = msg:match("^(%S*)%s*(.-)$")
	command = string.lower (command)

	if (command == Loc ["STRING_SLASH_WIPE"] or command == "wipe") then

	elseif (command == "api") then
		self.OpenAPI()

	elseif (command == Loc ["STRING_SLASH_NEW"] or command == "new") then
		self:CriarInstancia (nil, true)

	elseif (command == Loc ["STRING_SLASH_HISTORY"] or command == "history" or command == "score" or command == "rank" or command == "ranking" or command == "statistics" or command == "stats") then
		self:OpenRaidHistoryWindow()

	elseif (command == Loc ["STRING_SLASH_TOGGLE"] or command == "toggle") then

		local instance = rest:match ("^(%S*)%s*(.-)$")
		instance = tonumber (instance)
		if (instance) then
			self:ToggleWindow (instance)
		else
			self:ToggleWindows()
		end

	elseif (command == Loc ["STRING_SLASH_HIDE"] or command == Loc ["STRING_SLASH_HIDE_ALIAS1"] or command == "hide") then

		local instance = rest:match ("^(%S*)%s*(.-)$")
		instance = tonumber (instance)
		if (instance) then
			local this_instance = self:GetInstance (instance)
			if (not this_instance) then
				return self:Msg (Loc ["STRING_WINDOW_NOTFOUND"])
			end
			if (this_instance:IsEnabled() and this_instance.baseframe) then
				this_instance:ShutDown()
			end
		else
			self:ShutDownAllInstances()
		end

	elseif (command == "softhide") then
		for instanceID, instance in self:ListInstances() do
			if (instance:IsEnabled()) then
				if (instance.hide_in_combat_type > 1) then
					instance:SetWindowAlphaForCombat (true)
				end
			end
		end

	elseif (command == "softshow") then
		for instanceID, instance in self:ListInstances() do
			if (instance:IsEnabled()) then
				if (instance.hide_in_combat_type > 1) then
					instance:SetWindowAlphaForCombat (false)
				end
			end
		end

	elseif (command == "softtoggle") then
		for instanceID, instance in self:ListInstances() do
			if (instance:IsEnabled()) then
				if (instance.hide_in_combat_type > 1) then
					if (instance.baseframe:GetAlpha() > 0.1) then
						--show
						instance:SetWindowAlphaForCombat (true)
					else
						--hide
						instance:SetWindowAlphaForCombat (false)
					end
				end
			end
		end

	elseif (command == Loc ["STRING_SLASH_SHOW"] or command == Loc ["STRING_SLASH_SHOW_ALIAS1"] or command == "show") then

		self.LastShowCommand = GetTime()
		local instance = rest:match ("^(%S*)%s*(.-)$")
		instance = tonumber (instance)
		if (instance) then
			local this_instance = self:GetInstance (instance)
			if (not this_instance) then
				return self:Msg (Loc ["STRING_WINDOW_NOTFOUND"])
			end
			if (not this_instance:IsEnabled() and this_instance.baseframe) then
				this_instance:EnableInstance()
			end
		else
			self:ReabrirTodasInstancias()
		end

	elseif (command == Loc ["STRING_SLASH_WIPECONFIG"] or command == "reinstall") then
		self:WipeConfig()

	elseif (command == Loc ["STRING_SLASH_RESET"] or command == Loc ["STRING_SLASH_RESET_ALIAS1"] or command == "reset") then
		self.tabela_historico:resetar()

	elseif (command == Loc ["STRING_SLASH_DISABLE"] or command == "disable") then

		self:CaptureSet (false, "damage", true)
		self:CaptureSet (false, "heal", true)
		self:CaptureSet (false, "energy", true)
		self:CaptureSet (false, "miscdata", true)
		self:CaptureSet (false, "aura", true)
		self:CaptureSet (false, "spellcast", true)

		self:print(Loc ["STRING_SLASH_CAPTUREOFF"])

	elseif (command == Loc ["STRING_SLASH_ENABLE"] or command == "enable") then

		self:CaptureSet (true, "damage", true)
		self:CaptureSet (true, "heal", true)
		self:CaptureSet (true, "energy", true)
		self:CaptureSet (true, "miscdata", true)
		self:CaptureSet (true, "aura", true)
		self:CaptureSet (true, "spellcast", true)

		self:print(Loc ["STRING_SLASH_CAPTUREON"])

	elseif (command == Loc ["STRING_SLASH_OPTIONS"] or command == "options" or command == "config") then

		if (rest and tonumber (rest)) then
			local instanceN = tonumber (rest)
			if (instanceN > 0 and instanceN <= #self.tabela_instancias) then
				local instance = self:GetInstance (instanceN)
				self:OpenOptionsWindow (instance)
			end
		else
			local lower_instance = self:GetLowerInstanceNumber()
			if (not lower_instance) then
				local instance = self:GetInstance (1)
				self.CriarInstancia (nil, nil, 1)
				self:OpenOptionsWindow (instance)
			else
				self:OpenOptionsWindow (self:GetInstance (lower_instance))
			end

		end

	elseif (command == Loc ["STRING_SLASH_WORLDBOSS"] or command == "worldboss") then

		local bossInfo = { [691] = 32099, [725] = 32098 }
		for encounterId, questId in pairs (bossInfo) do
			local boss = DetailsFramework.EncounterJournal.EJ_GetEncounterInfo(encounterId)
			self:print (format ("%s: \124cff%s\124r", boss, IsQuestFlaggedCompleted (questId) and "ff0000"..Loc ["STRING_KILLED"] or "00ff00"..Loc ["STRING_ALIVE"]))
		end

	elseif (command == Loc ["STRING_SLASH_CHANGES"] or command == Loc ["STRING_SLASH_CHANGES_ALIAS1"] or command == Loc ["STRING_SLASH_CHANGES_ALIAS2"] or command == "news" or command == "updates") then
		self:OpenNewsWindow()

	elseif (command == "discord") then
		self:CopyPaste ("https://discord.gg/UXSc7nt")

	elseif (command == "debugwindow") then

		local window1 = self:GetWindow(1)
		if (window1) then
			local state = {
				ParentName = window1.baseframe:GetParent():GetName(),
				Alpha = window1.baseframe:GetAlpha(),
				IsShown = window1.baseframe:IsShown(),
				IsOpen = window1:IsEnabled() and true or false,
				NumPoints = window1.baseframe:GetNumPoints(),
			}

			for i = 1, window1.baseframe:GetNumPoints() do
				state ["Point" .. i] = {window1.baseframe:GetPoint (i)}
			end

			local parent = window1.baseframe:GetParent()

			state ["ParentInfo"] = {
				Alpha = parent:GetAlpha(),
				IsShown = parent:IsShown(),
				NumPoints = parent:GetNumPoints(),
			}

			self:Dump (state)
		else
			self:Msg ("Window 1 not found.")
		end

	elseif (command == "spells") then
		self.OpenForge()
		DetailsForgePanel.SelectModule (nil, nil, 1)

	elseif (command == "feedback") then
		self.OpenFeedbackWindow()

	elseif (command == "profile") then
		if (rest and rest ~= "") then

			local profile = self:GetProfile (rest)
			if (not profile) then
				return self:Msg ("Profile Not Found.")
			end

			if (not self:ApplyProfile (rest)) then
				return
			end

			self:Msg (Loc ["STRING_OPTIONS_PROFILE_LOADED"], rest)
			if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
				_G.DetailsOptionsWindow:Hide()
				GameCooltip:Close()
			end
		else
			self:Msg ("/details profile <profile name>")
		end

-------- debug ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	elseif (msg == "exitlog") then

		local exitlog = _detalhes_global.exit_log
		local exiterrors = _detalhes_global.exit_errors

		print ("EXIT LOG:")
		for index, text in ipairs (exitlog) do
			print (text)
		end
		print ("ERRORS:")
		if (exiterrors) then
			for index, text in ipairs (exiterrors) do
				print (text)
			end
		else
			print ("|cFF00FF00No error occured!|r")
		end

	elseif (msg == "tr") then

		local f = CreateFrame ("Frame", nil, UIParent)
		f:SetSize (300, 300)
		f:SetPoint ("CENTER")

--		/run TTT:SetTexture ("Interface\\1024.tga")
		local texture = f:CreateTexture ("TTT", "background")
		texture:SetAllPoints()
		texture:SetTexture ("Interface\\1023.tga")

		local A = DetailsFramework:CreateAnimationHub (texture)

		local b = DetailsFramework:CreateAnimation (A, "ROTATION", 1, 40, 360)
--		b:SetTarget (texture) -- TEMP
		A:Play()

		C_Timer.NewTicker (1, function()
			texture:SetTexCoord (math.random(), math.random(), math.random(), math.random(), math.random(), math.random(), math.random(), math.random())
		end)


	elseif (msg == "realmsync") then
		if not DETAILS_REALM_SYNC_ENABLED then
			self:print("The realm sync feature is not available.")
			return
		end
		self.realm_sync = not self.realm_sync
		self:Msg ("Realm Sync: ", self.realm_sync and "Enabled" or "Disabled")

		if (not self.realm_sync) then
			LeaveChannelByName ("Details")
		else
			self:CheckChatOnZoneChange()
		end

	elseif (msg == "load") then

		print (DetailsDataStorage)

		local loaded, reason = LoadAddOn ("Details_DataStorage")
		print (loaded, reason, DetailsDataStorage)


	elseif (msg == "owner2") then

		local tip = CreateFrame('GameTooltip', 'GuardianOwnerTooltip', nil, 'GameTooltipTemplate')
		function GetGuardianOwner(guid)
			tip:SetOwner(WorldFrame, 'ANCHOR_NONE')
			tip:SetHyperlink('unit:' .. guid or '')
			local text = GuardianOwnerTooltipTextLeft2
			--return strmatch(text and text:GetText() or '', "^([^%s']+)'")
			return text:GetText()
		end

		print (GetGuardianOwner(UnitGUID ("target")))

	elseif (msg == "chat") then


	elseif (msg == "chaticon") then
		self:Msg ([[|TInterface\AddOns\Details\images\icones_barra:]] .. 14 .. ":" .. 14 .. ":0:0:256:32:0:32:0:32|tteste")

	elseif (msg == "align") then
		local c = RightChatPanel
		local w,h = c:GetSize()
		print (w,h)

		local instance1 = self.tabela_instancias [1]
		local instance2 = self.tabela_instancias [2]

		instance1.baseframe:ClearAllPoints()
		instance2.baseframe:ClearAllPoints()

		instance1.baseframe:SetSize (w/2 - 4, h-20-21-8)
		instance2.baseframe:SetSize (w/2 - 4, h-20-21-8)

		instance1.baseframe:SetPoint ("BOTTOMLEFT", RightChatDataPanel, "TOPLEFT", 1, 1)
		instance2.baseframe:SetPoint ("BOTTOMRIGHT", RightChatToggleButton, "TOPRIGHT", -1, 1)

	elseif (msg == "addcombat") then

		local combat = self.combate:NovaTabela (true, self.tabela_overall, 1)
		local self = combat[1]:PegarCombatente (self.playerserial, self.playername, 1297, true)
		self.total = 100000
		self.total_without_pet = 100000

		if (not self.um___) then
			self.um___ = 0
			self.next_um = 3
		end

		local cima = true

		self.um___ = self.um___ + 1

		if (self.um___ == self.next_um) then
			self.next_um = self.next_um + 3
			cima = false
		end

		if (cima) then
			local frostbolt = self.spells:PegaHabilidade (116, true, "SPELL_DAMAGE")
			local frostfirebolt = self.spells:PegaHabilidade (44614, true, "SPELL_DAMAGE")
			local icelance = self.spells:PegaHabilidade (30455, true, "SPELL_DAMAGE")

			self.spells._ActorTable [116].total = 50000
			self.spells._ActorTable [44614].total = 25000
			self.spells._ActorTable [30455].total = 25000
		else
			local frostbolt = self.spells:PegaHabilidade (84721, true, "SPELL_DAMAGE")
			local frostfirebolt = self.spells:PegaHabilidade (113092, true, "SPELL_DAMAGE")
			local icelance = self.spells:PegaHabilidade (122, true, "SPELL_DAMAGE")

			self.spells._ActorTable [84721].total = 50000
			self.spells._ActorTable [113092].total = 25000
			self.spells._ActorTable [122].total = 25000
		end

		combat.start_time = GetTime()-30
		combat.end_time = GetTime()

		combat.totals_grupo [1] = 100000
		combat.totals [1] = 100000

		--combat.instance_type = "raid"
		--combat.is_trash = true

		self.tabela_vigente = combat

		self.tabela_historico:adicionar (combat)

		self:InstanciaCallFunction (self.gump.Fade, "in", nil, "barras")
		self:InstanciaCallFunction (self.AtualizaSegmentos) -- atualiza o instancia.showing para as novas tabelas criadas
		self:InstanciaCallFunction (self.AtualizaSoloMode_AfertReset) -- verifica se precisa zerar as tabela da janela solo mode
		self:InstanciaCallFunction (self.ResetaGump) --self:ResetaGump ("de todas as instancias")
		self:AtualizaGumpPrincipal (-1, true) --atualiza todas as instancias



	elseif (msg == "pets") then
		local f = self:CreateListPanel()

		local i = 1
		for k, v in pairs (self.tabela_pets.pets) do
			if (v[6] == "Guardian of Ancient Kings") then
				self.ListPanel:add ( k.. ": " ..  v[1] .. " | " .. v[2] .. " | " .. v[3] .. " | " .. v[6], i)
				i = i + 1
			end
		end

		f:Show()

	elseif (msg == "savepets") then

		self.tabela_vigente.saved_pets = {}

		for k, v in pairs (self.tabela_pets.pets) do
			self.tabela_vigente.saved_pets [k] = {v[1], v[2], v[3]}
		end

		self:Msg ("pet table has been saved on current combat.")

	elseif (msg == "move") then

		print ("moving...")

		local instance = self.tabela_instancias [1]
		instance.baseframe:ClearAllPoints()
		--instance.baseframe:SetPoint ("CENTER", UIParent, "CENTER", 300, 100)
		instance.baseframe:SetPoint ("LEFT", DetailsWelcomeWindow, "RIGHT", 10, 0)

	elseif (msg == "model") then
		local frame = CreateFrame ("PlayerModel");
		frame:SetPoint("CENTER",UIParent,"CENTER");
		frame:SetHeight(600);
		frame:SetWidth(300);
		frame:SetDisplayInfo (49585);

	elseif (msg == "time") then
		print ("GetTime()", GetTime())
		print ("time()", time())

	elseif (msg == "copy") then
		_G.DetailsCopy:Show()
		_G.DetailsCopy.MyObject.text:HighlightText()
		_G.DetailsCopy.MyObject.text:SetFocus()

	elseif (msg == "garbage") then
		local a = {}
		for i = 1, 10000 do
			a [i] = {math.random (50000)}
		end
		table.wipe (a)

	elseif (msg == "unitname") then

		local nome, realm = UnitName ("target")
		if (realm) then
			nome = nome.."-"..realm
		end
		print (nome)

	elseif (msg == "raid") then
		local unitType = (IsInRaid() and "raid" or "party")
		for i = 1, GetNumGroupMembers() do
			local name, realm = UnitName (unitType..i)
			if name and name ~= self.playername then
				local guid = UnitGUID (unitType..i)
				if realm and strlen(realm) > 0 then
					name = name.."-"..realm
				end
				self:print (name, guid)
			end
		end

	elseif (msg == "cacheparser") then
		self:PrintParserCacheIndexes()
	elseif (msg == "parsercache") then
		self:PrintParserCacheIndexes()

	elseif (msg == "captures") then
		for k, v in pairs (self.capture_real) do
			print ("real -",k,":",v)
		end
		for k, v in pairs (self.capture_current) do
			print ("current -",k,":",v)
		end

	elseif (msg == "slider") then

		local f = CreateFrame ("Frame", "TESTEDESCROLL", UIParent)
		f:SetPoint ("CENTER", UIParent, "CENTER", 200, -2)
		f:SetWidth (300)
		f:SetHeight (150)
		f:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		f:SetBackdropColor (0, 0, 0, 1)
		f:EnableMouseWheel (true)

		local rows = {}
		for i = 1, 7 do
			local row = CreateFrame ("Frame", nil, UIParent)
			row:SetPoint ("TOPLEFT", f, "TOPLEFT", 10, -(i-1)*21)
			row:SetWidth (200)
			row:SetHeight (20)
			row:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
			local t = row:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			t:SetPoint ("LEFT", row, "LEFT")
			row.text = t
			rows [#rows+1] = row
		end

		local data = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}



	elseif (msg == "bcollor") then

		--local instancia = self.tabela_instancias [1]
		self.ResetButton.Middle:SetVertexColor (1, 1, 0, 1)

		--print (self.ResetButton:GetHighlightTexture())

		local t = self.ResetButton:GetHighlightTexture()
		t:SetVertexColor (0, 1, 0, 1)
		--print (t:GetObjectType())
		--self.ResetButton:SetHighlightTexture (t)
		self.ResetButton:SetNormalTexture (t)

		print ("backdrop", self.ResetButton:GetBackdrop())

		self.ResetButton:SetBackdropColor (0, 0, 1, 1)

		--vardump (self.ResetButton)

	elseif (command == "mini") then
		local instance = self.tabela_instancias [1]
		--vardump ()
		--print (instance, instance.StatusBar.options, instance.StatusBar.left)
		print (instance.StatusBar.options [instance.StatusBar.left.mainPlugin.real_name].textSize)
		print (instance.StatusBar.left.options.textSize)

	elseif (command == "owner") then

		if not self.scanTool then
			self.scanTool = CreateFrame("GameTooltip", "DetailsScanTooltip", nil, "GameTooltipTemplate")
			self.scanTool:SetOwner(WorldFrame, "ANCHOR_NONE")
		end

		self.scanTool:ClearLines()

		self.scanTool:SetUnit("target")

		local scanText = _G[self.scanTool:GetName().."TextLeft2"]
		local ownerText = scanText and scanText:GetText()
		if ownerText then
			local owner, _ = string.split ("'", ownerText)
			self:print(UnitName("target").."'s owner:", owner)
		end

		self.scanTool:ClearLines()


	elseif (command == "buffsof") then

		local playername, segment = rest:match("^(%S*)%s*(.-)$")
		segment = tonumber (segment or 0)
		print ("dumping buffs of ", playername, segment)

		local c = self:GetCombat ("current")
		if (c) then

			local playerActor

			if (segment and segment ~= 0) then
				local c = self:GetCombat (segment)
				playerActor = c (4, playername)
				print ("using segment", segment, c, "player actor:", playerActor)
			else
				playerActor = c (4, playername)
			end

			print ("actor table: ", playerActor)

			if (not playerActor) then
				print ("actor table not found")
				return
			end

			if (playerActor and playerActor.buff_uptime_spells and playerActor.buff_uptime_spells._ActorTable) then
				for spellid, spellTable in pairs (playerActor.buff_uptime_spells._ActorTable) do
					local spellname = GetSpellInfo (spellid)
					if (spellname) then
						print (spellid, spellname, spellTable.uptime)
					end
				end
			end
		end

	elseif (msg == "comm") then

		local test_plugin = TESTPLUGIN
		if (not test_plugin) then
			local p = self:NewPluginObject ("DetailsTestPlugin", nil, "STATUSBAR")
			self:InstallPlugin ("STATUSBAR", "Plugin Test", [[Interface\COMMON\StreamCircle]], p, "TESTPLUGIN", 1, "Details!", "v1.0")
			test_plugin = TESTPLUGIN

			function test_plugin:ReceiveAA (a, b, c, d, e, f, g)
				print ("working 1", a, b, c, d, e, f, g)
			end

			function test_plugin:ReceiveAB (a, b, c, d, e, f, g)
				print ("working 2", a, b, c, d, e, f, g)
			end

			test_plugin:RegisterPluginComm ("PTAA", "ReceiveAA")
			test_plugin:RegisterPluginComm ("PTAB", "ReceiveAB")
		end

		test_plugin:SendPluginCommMessage ("PTAA", nil, "teste 1", "teste 2", "teste3")


	elseif (msg == "teste") then

		local a, b = self:GetEncounterEnd (1098, 3)
		print (a, unpack (b))

	elseif (msg == "yesno") then
		--self:Show()

	elseif (msg == "imageedit") then

		local callback = function (width, height, overlayColor, alpha, texCoords)
			print (width, height, alpha)
			print ("overlay: ", unpack (overlayColor))
			print ("crop: ", unpack (texCoords))
		end

		self.gump:ImageEditor (callback, [[Interface\EncounterJournal\UI-EJ-BACKGROUND-DragonSoul]], nil, {1, 1, 1, 1}) -- {0.25, 0.25, 0.25, 0.25}

	elseif (msg == "chat") then

		local name, fontSize, r, g, b, a, shown, locked = FCF_GetChatWindowInfo (1);
		print (name,"|",fontSize,"|", r,"|", g,"|", b,"|", a,"|", shown,"|", locked)

		--local fontFile, unused, fontFlags = self:GetFont();
		--self:SetFont(fontFile, fontSize, fontFlags);

	elseif (msg == "error") then
		local a = nil + 1

	--> debug
	elseif (command == "resetcapture") then
		self.capture_real = {
			["damage"] = true,
			["heal"] = true,
			["energy"] = true,
			["miscdata"] = true,
			["aura"] = true,
		}
		self.capture_current = self.capture_real
		self:CaptureRefresh()
		self:print("capture has been reseted.")

	--> debug
	elseif (command == "barra") then

		local qual_barra = rest and tonumber (rest) or 1

		local instancia = self.tabela_instancias [1]
		local barra = instancia.barras [qual_barra]

		for i = 1, barra:GetNumPoints() do
			local point, relativeTo, relativePoint, xOfs, yOfs = barra:GetPoint (i)
			print (point, relativeTo, relativePoint, xOfs, yOfs)
		end

	elseif (msg == "opened") then
		print ("Instances opened: " .. self.opened_windows)

	--> debug, get a guid of something
	elseif (command == "backdrop") then --> localize-me
		local f = MacroFrameTextBackground
		if not f then
			ShowMacroFrame()
			f = MacroFrameTextBackground
			HideUIPanel(MacroFrame)
		end
		local backdrop = f:GetBackdrop()

		vardump (backdrop)
		vardump (backdrop.insets)

		print ("bgcolor:",f:GetBackdropColor())
		print ("bordercolor",f:GetBackdropBorderColor())

	elseif (command == "myguid") then --> localize-me

		local g = self.playerserial
		print (type (g))
		print (g)
		print (string.len (g))
		local serial = g:sub (12, 18)
		serial = tonumber ("0x"..serial)
		print (serial)

		--tonumber((UnitGUID("target")):sub(-12, -9), 16))

	elseif (command == "callfunction") then

		self:InstanceCall (self.SetCombatAlpha, nil, nil, true)

	elseif (command == "guid") then --> localize-me

		local pass_guid = rest:match("^(%S*)%s*(.-)$")

		if (not self.id_frame) then

			local backdrop = {
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
			tile = true, edgeSize = 1, tileSize = 5,
			}

			self.id_frame = CreateFrame ("Frame", "DetailsID", UIParent)
			self.id_frame:SetHeight(14)
			self.id_frame:SetWidth(120)
			self.id_frame:SetPoint ("CENTER", UIParent, "CENTER")
			self.id_frame:SetBackdrop(backdrop)

			tinsert (UISpecialFrames, "DetailsID")

			self.id_frame.texto = CreateFrame ("editbox", nil, self.id_frame)
			self.id_frame.texto:SetPoint ("TOPLEFT", self.id_frame, "TOPLEFT")
			self.id_frame.texto:SetAutoFocus(false)
			self.id_frame.texto:SetFontObject (GameFontHighlightSmall)
			self.id_frame.texto:SetHeight(14)
			self.id_frame.texto:SetWidth(120)
			self.id_frame.texto:SetJustifyH("CENTER")
			self.id_frame.texto:EnableMouse(true)
			self.id_frame.texto:SetBackdrop(ManualBackdrop)
			self.id_frame.texto:SetBackdropColor(0, 0, 0, 0.5)
			self.id_frame.texto:SetBackdropBorderColor(0.3, 0.3, 0.30, 0.80)
			self.id_frame.texto:SetText ("") --localize-me
			self.id_frame.texto.perdeu_foco = nil

			self.id_frame.texto:SetScript ("OnEnterPressed", function ()
				self.id_frame.texto:ClearFocus()
				self.id_frame:Hide()
			end)

			self.id_frame.texto:SetScript ("OnEscapePressed", function()
				self.id_frame.texto:ClearFocus()
				self.id_frame:Hide()
			end)

		end

		self.id_frame:Show()
		self.id_frame.texto:SetFocus()

		if (pass_guid == "-") then
			local guid = UnitGUID ("target")
			if (guid) then
				local g = self:GetNpcIdFromGuid (guid)
				self.id_frame.texto:SetText ("" .. g)
				self.id_frame.texto:HighlightText()
			end

		else
			print (pass_guid.. " -> " .. tonumber (pass_guid:sub(6, 10), 16))
			self.id_frame.texto:SetText (""..tonumber (pass_guid:sub(6, 10), 16))
			self.id_frame.texto:HighlightText()
		end

	--> debug

	elseif (msg == "auras") then
		if (IsInRaid()) then
			for raidIndex = 1, GetNumGroupMembers() do
				for buffIndex = 1, 41 do
					local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitAura ("raid"..raidIndex, buffIndex, nil, "HELPFUL")
					print (name, unitCaster, "==", "raid"..raidIndex)
					if (name and unitCaster == "raid"..raidIndex) then

						local playerName, realmName = UnitName ("raid"..raidIndex)
						if (realmName and realmName ~= "") then
							playerName = playerName .. "-" .. realmName
						end

						self.parser:add_buff_uptime (nil, GetTime(), nil, UnitGUID ("raid"..raidIndex), playerName, 0x00000417, nil, UnitGUID ("raid"..raidIndex), playerName, nil, spellid, name, in_or_out)

					else
						--break
					end
				end
			end
		end

	elseif (command == "profile") then

		local profile = rest:match("^(%S*)%s*(.-)$")

		print ("Force apply profile: ", profile)

		self:ApplyProfile (profile, false)

	elseif (msg == "users" or msg == "version" or msg == "versioncheck") then
		self.users = {{UnitName("player"), GetRealmName(), (self.userversion or "") .. " (" .. self.APIVersion .. ")"}}
		self.sent_highfive = GetTime()
		self:SendRaidData (self.network.ids.HIGHFIVE_REQUEST)

		self:print ("highfive sent, HI!")

		for k,v in ipairs({0.3, 0.6, 0.9, 1.3, 1.6, 3, 4, 5, 8}) do
			C_Timer.After (v, function() Details.RefreshUserList(k>1) end)
		end

	elseif (command == "names") then
		local t, filter = rest:match("^(%S*)%s*(.-)$")

		t = tonumber (t)
		if (not t) then
			return print ("not T found.")
		end

		local f = self.ListPanel
		if (not f) then
			f = self:CreateListPanel()
		end

		local container = self.tabela_vigente [t]._NameIndexTable

		local i = 0
		for name, _ in pairs (container) do
			i = i + 1
			f:add (name, i)
		end

		print (i, "names found.")

		f:Show()

	elseif (command == "actors") then

		local t, filter = rest:match("^(%S*)%s*(.-)$")

		t = tonumber (t)
		if (not t) then
			return print ("not T found.")
		end

		local f = self.ListPanel
		if (not f) then
			f = self:CreateListPanel()
		end

		local container = self.tabela_vigente [t]._ActorTable
		print (#container, "actors found.")
		for index, actor in ipairs (container) do
			f:add (actor.nome, index, filter)
		end

		f:Show()

	--> debug
	elseif (msg == "save") then
		print ("running... this is a debug command, details wont work until next /reload.")
		self:PrepareTablesForSave()

	elseif (msg == "buffs") then
		local unitId = (UnitExists("target") and not UnitIsUnit("player", "target")) and "target" or "player"
		local unitName = UnitName(unitId)
		self:print(unitName, "buffs:")
		for i = 1, 40 do
			local name, rank, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellid = UnitBuff (unitId, i)
			if (not name) then
				return
			end
			self:print (spellid, name)
		end

	elseif (msg == "id") then
		local one, two = rest:match("^(%S*)%s*(.-)$")
		if (one ~= "") then
			print("NPC ID:", one:sub(-12, -9), 16)
			print("NPC ID:", tonumber((one):sub(-12, -9), 16))
		else
			print("NPC ID:", tonumber((UnitGUID("target")):sub(-12, -9), 16) )
		end

	--> debug
	elseif (command == "debug") then
		_detalhes_database.debug = not _detalhes_database.debug and 1 or nil
		self.debug = _detalhes_database.debug
		if not self.debug then
			self:print ("diagnostic mode has been turned off.")
			return
		else
			self:print ("diagnostic mode has been turned on.")

			if (rest and rest ~= "") then
				if (rest == "-clear") then
					_detalhes_global.debug_chr_log = ""
					self:print ("log for characters has been wiped.")
					return
				end
				self.debug_chr = rest
				_detalhes_global.debug_chr_log = _detalhes_global.debug_chr_log or ""
				self:print ("diagnostic for character " .. rest .. " turned on.")
				return
			end

			local current_combat = self.tabela_vigente

			if (not self.DebugWindow) then
				self.DebugWindow = self.gump:CreateSimplePanel (UIParent, 800, 600, "Details! Debug", "DetailsDebugPanel")
				local TextBox = self.gump:NewSpecialLuaEditorEntry (self.DebugWindow, 760, 560, "text", "$parentTextEntry", true)
				TextBox:SetPoint ("CENTER", self.DebugWindow, "CENTER", 0, -10)
				TextBox:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				TextBox:SetBackdropColor (0, 0, 0, 0.9)
				TextBox:SetBackdropBorderColor (0, 0, 0, 1)
				self.DebugWindow.TextBox = TextBox
			end

			local text = [[
Hello World!
Details! Damage Meter Debug
Release Version: @VERSION Core Version: @CORE

Update Thread Status:
Tick Rate: @TICKRATE
Threat Health: @TICKHEALTH
Last Tick: @TICKLAST
Next Tick In: @TICKNEXT

Current Combat Status:
ID: @COMBATID
Container Status: @COMBATCONTAINERS
Damage Container Actors: @COMBATDAMAGEACTORS actors found

Parser Status:
Parser Health: @PARSERHEALTH
Parser Capture Status: @PARSERCAPTURE

Lower Instance Status (window 1):
Is Shown: @INSTANCESHOWN
Segment Status: @INSTANCESEGMENT
Damage Update Status: @INSTANCEDAMAGESTATUS

]]

			text = text:gsub ([[@VERSION]], self.userversion)
			text = text:gsub ([[@CORE]], self.realversion)

			text = text:gsub ([[@TICKRATE]], self.update_speed)
			text = text:gsub ([[@TICKHEALTH]], self:TimeLeft (self.atualizador) ~= 0 and "|cFF22FF22good|r" or "|cFFFF2222bad|r")
			text = text:gsub ([[@TICKLAST]], self.LastUpdateTick .. " (" .. self._tempo - self.LastUpdateTick .. " seconds ago)")
			text = text:gsub ([[@TICKNEXT]], self:TimeLeft (self.atualizador))

			text = text:gsub ([[@COMBATID]], self.combat_id)
			text = text:gsub ([[@COMBATCONTAINERS]], self.tabela_vigente[1] and self.tabela_vigente[2] and self.tabela_vigente[3] and self.tabela_vigente[4] and "|cFF22FF22good|r" or "|cFFFF2222bad|r")
			text = text:gsub ([[@COMBATDAMAGEACTORS]], #self.tabela_vigente[1] and self.tabela_vigente[1]._ActorTable and #self.tabela_vigente[1]._ActorTable)

			text = text:gsub ([[@PARSERHEALTH]], self.parser_frame:GetScript ("OnEvent") == self.OnParserEvent and "|cFF22FF22good|r" or "|cFFFF2222bad|r")

			local captureStr = ""
			for _ , captureName in ipairs (self.capture_types) do
				if (self.capture_current [captureName]) then
					captureStr = captureStr .. " " .. captureName .. ": |cFF22FF22okay|r"
				else
					captureStr = captureStr .. " " .. captureName .. ": |cFFFF2222X|r"
				end
			end
			text = text:gsub ([[@PARSERCAPTURE]], captureStr)

			local instance = self:GetLowerInstanceNumber()
			if (instance) then
				instance = self:GetInstance (instance)
			end

			if (instance) then
				if (instance:IsEnabled()) then
					text = text:gsub ([[@INSTANCESHOWN]], "|cFF22FF22good|r")
				else
					text = text:gsub ([[@INSTANCESHOWN]], "|cFFFFFF22not visible|r")
				end

				text = text:gsub ([[@INSTANCESEGMENT]], (instance.showing == self.tabela_vigente and "|cFF22FF22good|r" or "|cFFFFFF22isn't the current combat object|r") .. (" window segment: " .. instance:GetSegment()))

				text = text:gsub ([[@INSTANCEDAMAGESTATUS]], (self._tempo - (self.LastFullDamageUpdate or 0)) < 3 and "|cFF22FF22good|r" or "|cFFFF2222last update registered is > than 3 seconds, is there actors to show?|r")
			else
				text = text:gsub ([[@INSTANCESHOWN]], "|cFFFFFF22not found|r")
				text = text:gsub ([[@INSTANCESEGMENT]], "|cFFFFFF22not found|r")
				text = text:gsub ([[@INSTANCEDAMAGESTATUS]], "|cFFFFFF22not found|r")

			end

			self.DebugWindow.TextBox:SetText (text)

			self.DebugWindow:Show()
		end

	--> debug combat log
	elseif (msg == "combatlog") then
		if (self.isLoggingCombat) then
			LoggingCombat (false)
			print ("Wow combatlog record turned OFF.")
			self.isLoggingCombat = nil
		else
			LoggingCombat (true)
			print ("Wow combatlog record turned ON.")
			self.isLoggingCombat = true
		end

	elseif (msg == "gs") then
		self:teste_grayscale()

	elseif (msg == "bwload") then
		if not BigWigs then LoadAddOn("BigWigs_Core") end
		BigWigs:Enable()

		LoadAddOn ("BigWigs_Highmaul")

		local mod = BigWigs:GetBossModule("Imperator Mar'gok")
		mod:Enable()

	elseif (msg == "bwsend") then
		local mod = BigWigs:GetBossModule("Imperator Mar'gok")
		mod:Message("stages", "Neutral", "Long", "Phase 2", false)

	elseif (msg == "bwregister") then

		local addon = {}
		BigWigs.RegisterMessage(addon, "BigWigs_Message")
		function addon:BigWigs_Message(event, module, key, text)
		  if module.journalId  == 1197 and text:match("^Phase %d$") then -- 1197 = Margok
		   print ("Phase Changed!", event, module, key, text)
		  end
		end

	elseif (msg == "pos") then
		local x, y = GetPlayerMapPosition ("player")

		if (not DetailsPosBox) then
			self.gump:CreateTextEntry (UIParent, function()end, 200, 20, nil, "DetailsPosBox")
			DetailsPosBox:SetPoint ("CENTER", UIParent, "CENTER")
		end

		local one, two = rest:match("^(%S*)%s*(.-)$")
		if (one == "2") then
			DetailsPosBox.MyObject.text = "{x2 = " .. x .. ", y2 = " .. y .. "}"
		else
			DetailsPosBox.MyObject.text = "{x1 = " .. x .. ", y1 = " .. y .. "}"
		end
		DetailsPosBox.MyObject:SetFocus()
		DetailsPosBox.MyObject:HighlightText()

	elseif (msg == "outline") then

		local instancia = self.tabela_instancias [1]
		for _, barra in ipairs (instancia.barras) do
			local _, _, flags = barra.texto_esquerdo:GetFont()
			print ("outline:",flags)
		end

	elseif (msg == "sell") then

		--sell gray
		local c, i, n, v = 0
		for b = 0, 4 do
			for s = 1, GetContainerNumSlots(b) do
				i = {GetContainerItemInfo (b, s)}
				n = i[7]
				if n and string.find(n,"9d9d9d") then
					v = {GetItemInfo(n)}
					q = i[2]
					c = c+v[11]*q
					UseContainerItem (b, s)
					print (n, q)
				end
			end
		end
		if c > 0 then
			self:print(GetMoneyString(c))
		end

		--sell green equip
		local c, i, n, v = 0
		for b = 0, 4 do
			for s = 1, GetContainerNumSlots(b) do
				local texture, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo (b, s)
				if (quality == 2) then --a green item
					local itemName, itemLink, itemRarity, itemLevel, _, itemType, itemSubType = GetItemInfo (itemLink)
					if (itemType == ARMOR or itemType == ENCHSLOT_WEAPON) then --a weapon or armor
						if (itemLevel < 272) then
							self:print ("Selling", itemLink, itemType)
							UseContainerItem (b, s)
						end
					end
				end
			end
		end

	elseif (msg == "forge") then
		self:OpenForge()

	elseif (msg == "parser") then

		self:OnParserEvent (
			"COMBAT_LOG_EVENT_UNFILTERED", --evento =
			1548754114, --time =
			"SPELL_DAMAGE", --token =
			false, --hide_caster
			"0000000000000000", --who_serial =
			nil, --who_name =
			0x514, --who_flags =
			0, --who_flags2
			"Player-3676-06F3C3FA", --alvo_serial =
			"Icybluefur-Area52", --alvo_name =
			0x514, --alvo_flags =
			0, --alvo_flags2
			157247, --spellid =
			"Reverberations", --spellname =
			0x1, --spelltype =
			4846, --amount =
			-1, --overkill =
			1 --school =
		)

	elseif (msg == "ejloot") then
		DetailsFramework.EncounterJournal.EJ_SelectInstance (669) -- hellfire citadel
		DetailsFramework.EncounterJournal.EJ_SetDifficulty (16)

		local r = {}
		local total = 0

		for i = 1, 100 do
			local name, description, encounterID, rootSectionID, link = DetailsFramework.EncounterJournal.EJ_GetEncounterInfoByIndex (i, 669)
			if (name) then
				DetailsFramework.EncounterJournal.EJ_SelectEncounter (encounterID)
				print (name, encounterID, DetailsFramework.EncounterJournal.EJ_GetNumLoot())

				for o = 1, DetailsFramework.EncounterJournal.EJ_GetNumLoot() do
					local name, icon, slot, armorType, itemID, link, encounterID = DetailsFramework.EncounterJournal.EJ_GetLootInfoByIndex (o)
					r[slot] = r[slot] or {}
					tinsert (r[slot], {itemID, encounterID})
					total = total + 1
				end
			end
		end

		print ("total loot", total)
		_detalhes_global.ALOOT  = r

	elseif (msg == "ilvl" or msg == "itemlevel" or msg == "ilevel") then

		local avgItemLevel, avgItemLevelEquipped = GetAverageItemLevel()
		self:Msg ("average ilvl: " .. avgItemLevel, "| average equipped ilvl:", avgItemLevelEquipped)

		self.ilevel:CalcItemLevel (nil, nil, true)

	elseif (msg == "score") then

		self:OpenRaidHistoryWindow ("Dragon Soul", 1800, 2, "DAMAGER", "Bad", 2, "Brues")

	elseif (msg == "bar") then
		local bar = _G.DetailsTestBar
		if (not bar) then
			bar = Details.gump:CreateBar (UIParent, nil, 600, 200, 100, nil, "DetailsTestBar")
			_G.DetailsTestBar = bar
			bar:SetPoint ("CENTER", 0, 0)
			bar.RightTextIsTimer = true
			bar.BarIsInverse = true
		end

		bar.color = "HUNTER"

		local start = GetTime()-45
		local fim = GetTime()+5

		bar:SetTimer (start, fim)

		--C_Timer.After (5, function() bar:CancelTimerBar() end)

	elseif (msg == "alert") then
		--local instancia = self.tabela_instancias [1]
		local f = function (a, b, c, d, e, f, g) print (a, b, c, d, e, f, g) end
		--instancia:InstanceAlert (Loc ["STRING_PLEASE_WAIT"], {[[Interface\COMMON\StreamCircle]], 22, 22, true}, 5, {f, 1, 2, 3, 4, 5})

		local lower_instance = self:GetLowerInstanceNumber()
		if (lower_instance) then
			local instance = self:GetInstance (lower_instance)
			if (instance) then
				local func = {self.OpenRaidHistoryWindow, self, "Dragon Soul", 1800, 15, "DAMAGER", "Bad", 2, "Brues"}
				instance:InstanceAlert ("Boss Defeated, Open History! ", {[[Interface\AddOns\Details\images\icons]], 16, 16, false, 434/512, 466/512, 243/512, 273/512}, 40, func, true)
			end
		end

	elseif (msg == "teste1") then	-- /de teste1
		self:OpenRaidHistoryWindow (1530, 1886, 15, "damage", "Bad", 2, "Brues") --, _role, _guild, _player_base, _player_name)

	elseif (msg == "qq") then
		local my_role = "DAMAGER"
		local raid_name = "Dragon Soul"
		local guildName = "Bad"
		local func = {self.OpenRaidHistoryWindow, self, raid_name, 2050, 15, my_role, guildName} --, 2, UnitName ("player")
		local icon = {[[Interface\PvPRankBadges\PvPRank08]], 16, 16, false, 0, 1, 0, 1}

		local lower_instance = self:GetLowerInstanceNumber()
		local instance = self:GetInstance (lower_instance)

		instance:InstanceAlert ("Boss Defeated! Show Ranking", icon, 10, func, true)

	elseif (msg == "scroll" or msg == "scrolldamage" or msg == "scrolling") then
		self:ScrollDamage()

	elseif (msg == "spec") then

	local spec = DetailsFramework.GetSpecialization()
	if (spec) then
		local specID = DetailsFramework.GetSpecializationInfo (spec)
		if (specID and specID ~= 0) then
			local _, specName = DetailsFramework.GetSpecializationInfoByID(specID)
			self:print(specName, "SpecID:", specID)
		end
	end


	elseif (msg == "senditemlevel") then
		self:SendCharacterData()
		self:print ("Item level dispatched.")

	elseif (msg == "talents") then
		self:print ("name", "texture", "tier", "column", "rank", "maxRank", "meetsPrereq", "previewRank", "meetsPreviewPreq")
		local isInspect = (not UnitIsUnit("player", "target")) and UnitIsPlayer("target") and CheckInteractDistance("target", 1)
		for i = 1, GetNumTalentTabs() do
			for j = 1, GetNumTalents(i) do
				local rank = select(5,GetTalentInfo(i, j,isInspect))
				if rank > 0 then
					self:print(GetTalentInfo(i, j,isInspect))
				end
			end
		end

	elseif (msg == "merge") then

		--> at this point, details! should not be in combat
		if (self.in_combat) then
			self:Msg ("already in combat, closing current segment.")
			self:SairDoCombate()
		end

		--> create a new combat to be the overall for the mythic run
		self:EntrarEmCombate()

		--> get the current combat just created and the table with all past segments
		local newCombat = self:GetCurrentCombat()
		local segmentHistory = self:GetCombatSegments()
		local totalTime = 0
		local startDate, endDate = "", ""
		local lastSegment
		local segmentsAdded = 0

		--> add all boss segments from this run to this new segment
		for i = 1, 25 do
			local pastCombat = segmentHistory [i]
			if (pastCombat and pastCombat ~= newCombat) then
				newCombat = newCombat + pastCombat
				totalTime = totalTime + pastCombat:GetCombatTime()
				if (i == 1) then
					local _, endedDate = pastCombat:GetDate()
					endDate = endedDate
				end
				lastSegment = pastCombat
				segmentsAdded = segmentsAdded + 1
			end
		end

		if (lastSegment) then
			startDate = lastSegment:GetDate()
		end

		newCombat.is_trash = false
		self:Msg ("done merging, segments: " .. segmentsAdded .. ", total time: " .. DetailsFramework:IntegerToTimer (totalTime))

		--> set some data
		newCombat:SetStartTime (GetTime() - totalTime)
		newCombat:SetEndTime (GetTime())

		newCombat.data_inicio = startDate
		newCombat.data_fim = endDate

		--> immediatly finishes the segment just started
		self:SairDoCombate()

		--> cleanup the past segments table
		for i = 25, 1, -1 do
			local pastCombat = segmentHistory [i]
			if (pastCombat and pastCombat ~= newCombat) then
				wipe (pastCombat)
				segmentHistory [i] = nil
			end
		end

		--> clear memory
		collectgarbage()

		self:InstanciaCallFunction (self.gump.Fade, "in", nil, "barras")
		self:InstanciaCallFunction (self.AtualizaSegmentos)
		self:InstanciaCallFunction (self.AtualizaSoloMode_AfertReset)
		self:InstanciaCallFunction (self.ResetaGump)
		self:AtualizaGumpPrincipal (-1, true)

	elseif (msg == "ej") then

		local result = {}
		local spellIDs = {}

		--uldir
		DetailsFramework.EncounterJournal.EJ_SelectInstance (1031)

		-- pega o root section id do boss
		local name, description, encounterID, rootSectionID, link = DetailsFramework.EncounterJournal.EJ_GetEncounterInfo (2168) --taloc (primeiro boss de Uldir)

		--overview
		local sectionInfo = C_EncounterJournal.GetSectionInfo (rootSectionID)
		local nextID = {sectionInfo.siblingSectionID}

		while (nextID [1]) do
			--> get the deepest section in the hierarchy
			local ID = tremove (nextID)
			local sectionInfo = C_EncounterJournal.GetSectionInfo (ID)

			if (sectionInfo) then
				tinsert (result, sectionInfo)

				if (sectionInfo.spellID and type (sectionInfo.spellID) == "number" and sectionInfo.spellID ~= 0) then
					tinsert (spellIDs, sectionInfo.spellID)
				end

				local nextChild, nextSibling = sectionInfo.firstChildSectionID, sectionInfo.siblingSectionID
				if (nextSibling) then
					tinsert (nextID, nextSibling)
				end
				if (nextChild) then
					tinsert (nextID, nextChild)
				end
			else
				break
			end
		end

		Details:DumpTable (result)

	elseif (msg == "record") then


			self.ScheduleLoadStorage()
			self.TellDamageRecord = C_Timer.NewTicker (0.6, self.PrintEncounterRecord, 1)
			self.TellDamageRecord.Boss = 2032
			self.TellDamageRecord.Diff = 16

	elseif (msg == "recordtest") then

		local f = DetailsRecordFrameAnimation
		if (not f) then
			f = CreateFrame ("Frame", "DetailsRecordFrameAnimation", UIParent)

			--estrela no inicio dando um giro
			--Interface\Cooldown\star4
			--efeito de batida?
			--Interface\Artifacts\ArtifactAnim2
			local animationHub = DetailsFramework:CreateAnimationHub (f, function() f:Show() end)

			DetailsFramework:CreateAnimation (animationHub, "Scale", 1, .10, .9, .9, 1.1, 1.1)
			DetailsFramework:CreateAnimation (animationHub, "Scale", 2, .10, 1.2, 1.2, 1, 1)
		end

	--BFA BETA
	elseif (msg == "update") then
		self:CopyPaste ([[https://github.com/SushiWoW/MoP-Details]])


	elseif (msg == "share") then

		local f = {}

		local elapsed = GetTime()

		local ignoredKeys = {
			minha_barra = true,
			__index = true,
			shadow = true,
			links = true,
			__call = true,
			_combat_table = true,
			previous_combat = true,
			owner = true,
		}

		local keys = {}

		--> copy from table2 to table1 overwriting values
		function f.copy (t1, t2)
			if (t1.Timer) then
				t1, t2 = t1.t1, t1.t2
			end
			for key, value in pairs (t2) do
				if (not ignoredKeys [key] and type (value) ~= "function") then
					if (key == "targets") then
						t1 [key] = {}

					elseif (type (value) == "table") then
						t1 [key] = t1 [key] or {}

						--print (key, value)
						--local d = C_Timer.NewTicker (1, f.copy, 1)
						--d.t1 = t1 [key]
						--d.t2 = t2 [key]
						--d.Timer = true

						keys [key] = true

						f.copy (t1 [key], t2 [key])
					else
						t1 [key] = value
					end
				end
			end
			return t1
		end

		--local copySegment = f.copy ({}, self.tabela_vigente)
		local copySegment = f.copy ({}, self.tabela_historico.tabelas [#self.tabela_historico.tabelas])

		--the segment received is raw and does not have metatables, need to refresh them
		local zipData = Details:CompressData (copySegment, "print")

		--print (zipData)
		--Details:Dump (keys)
		Details:Dump ({zipData})
	else

		--if (self.opened_windows < 1) then
		--	self:CriarInstancia()
		--end

		if (command) then
			--> check if the line passed is a parameters in the default profile
			if (self.default_profile [command]) then
				if (rest and (rest ~= "" and rest ~= " ")) then
					local whichType = type (self.default_profile [command])

					--> attempt to cast the passed value to the same value as the type in the profile
					if (whichType == "number") then
						rest = tonumber (rest)
						if (rest) then
							self [command] = rest
							self:print("config '" .. command .. "' set to " .. rest)
						else
							self:print("config '" .. command .. "' expects a number")
						end

					elseif (whichType == "string") then
						rest = tostring (rest)
						if (rest) then
							self [command] = rest
							self:print ("config '" .. command .. "' set to " .. rest)
						else
							self:print ("config '" .. command .. "' expects a string")
						end

					elseif (whichType == "boolean") then
						if (rest == "true") then
							self [command] = true
							self:print ("config '" .. command .. "' set to true")

						elseif (rest == "false") then
							self [command] = false
							self:print ("config '" .. command .. "' set to false")

						else
							self:print ("config '" .. command .. "' expects true or false")
						end
					end

				else
					local value = self [command]
					if (type (value) == "boolean") then
						value = value and "true" or "false"
					end
					self:print ("config '" .. command .. "' current value is: " .. value)
				end

				return
			end

		end

		print (" ")
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_NEW"] .. "|r: " .. Loc ["STRING_SLASH_NEW_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_SHOW"] .. " " .. Loc ["STRING_SLASH_HIDE"] .. " " .. Loc ["STRING_SLASH_TOGGLE"] .. "|r|cfffcffb0 <" .. Loc ["STRING_WINDOW_NUMBER"] .. ">|r: " .. Loc ["STRING_SLASH_SHOWHIDETOGGLE_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_ENABLE"] .. " " .. Loc ["STRING_SLASH_DISABLE"] .. "|r: " .. Loc ["STRING_SLASH_CAPTURE_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_RESET"] .. "|r: " .. Loc ["STRING_SLASH_RESET_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_OPTIONS"] .. "|r|cfffcffb0 <" .. Loc ["STRING_WINDOW_NUMBER"] .. ">|r: " .. Loc ["STRING_SLASH_OPTIONS_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. "API" .. "|r: " .. Loc ["STRING_SLASH_API_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_CHANGES"] .. "|r: " .. Loc ["STRING_SLASH_CHANGES_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_WIPECONFIG"] .. "|r: " .. Loc ["STRING_SLASH_WIPECONFIG_DESC"])

		print ("|cffffaeae/details " .. Loc ["STRING_SLASH_WORLDBOSS"] .. "|r: " .. Loc ["STRING_SLASH_WORLDBOSS_DESC"])
		print (" ")

		local v = (self.build_counter >= self.alpha_build_counter and self.build_counter or self.alpha_build_counter)
		self:print("|cFFFFFF00DETAILS! VERSION|r: |cFFFFAA00R" .. v)
		self:print("|cFFFFFF00GAME VERSION|r: |cFFFFAA00" .. self.game_version)

	end
end

function Details.RefreshUserList (ignoreIfHidden)

	if (ignoreIfHidden and DetailsUserPanel and not DetailsUserPanel:IsShown()) then
		return
	end

	local newList = DetailsFramework.table.copy ({}, _detalhes.users or {})

	table.sort (newList, function(t1, t2)
		return t1[3] > t2[3]
	end)

	--search for people that didn't answered
	if (IsInRaid()) then
		for i = 1, GetNumGroupMembers() do
			local playerName = UnitName ("raid" .. i)
			local foundPlayer

			for o = 1, #newList do
				if (newList[o][1]:find (playerName)) then
					foundPlayer = true
					break
				end
			end

			if (not foundPlayer) then
				tinsert (newList, {playerName, "--", "--"})
			end
		end
	end

	Details:UpdateUserPanel (newList)
end

function Details:UpdateUserPanel (usersTable)

	if (not Details.UserPanel) then
		DetailsUserPanel = DetailsFramework:CreateSimplePanel (UIParent)
		DetailsUserPanel:SetSize (707, 505)
		DetailsUserPanel:SetTitle ("Details! Version Check")
		DetailsUserPanel.Data = {}
		DetailsUserPanel:ClearAllPoints()
		DetailsUserPanel:SetPoint ("LEFT", UIParent, "LEFT", 10, 0)
		DetailsUserPanel:Hide()

		Details.UserPanel = DetailsUserPanel

		local scroll_width = 675
		local scroll_height = 450
		local scroll_lines = 21
		local scroll_line_height = 20

		local backdrop_color = {.2, .2, .2, 0.2}
		local backdrop_color_on_enter = {.8, .8, .8, 0.4}
		local backdrop_color_is_critical = {.4, .4, .2, 0.2}
		local backdrop_color_is_critical_on_enter = {1, 1, .8, 0.4}

		local y = -15
		local headerY = y - 15
		local scrollY = headerY - 20

		--header
		local headerTable = {
			{text = "User Name", width = 200},
			{text = "Realm", width = 200},
			{text = "Version", width = 200},
		}

		local headerOptions = {
			padding = 2,
		}

		DetailsUserPanel.Header = DetailsFramework:CreateHeader (DetailsUserPanel, headerTable, headerOptions)
		DetailsUserPanel.Header:SetPoint ("TOPLEFT", DetailsUserPanel, "TOPLEFT", 5, headerY)

		local scroll_refresh = function (self, data, offset, total_lines)
			for i = 1, total_lines do
				local index = i + offset
				local userTable = data [index]

				if (userTable) then

					local line = self:GetLine (i)
					local userName, userRealm, userVersion = unpack (userTable)

					line.UserNameText.text = userName
					line.RealmText.text = userRealm
					line.VersionText.text = userVersion
				end
			end
		end

		local lineOnEnter = function (self)
			if (self.IsCritical) then
				self:SetBackdropColor (unpack (backdrop_color_is_critical_on_enter))
			else
				self:SetBackdropColor (unpack (backdrop_color_on_enter))
			end
		end

		local lineOnLeave = function (self)
			if (self.IsCritical) then
				self:SetBackdropColor (unpack (backdrop_color_is_critical))
			else
				self:SetBackdropColor (unpack (backdrop_color))
			end

			GameTooltip:Hide()
		end

		local scroll_createline = function (self, index)
			local line = CreateFrame ("button", "$parentLine" .. index, self)
			line:SetPoint ("TOPLEFT", self, "TOPLEFT", 3, -((index-1)*(scroll_line_height+1)) - 1)
			line:SetSize (scroll_width - 2, scroll_line_height)

			line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
			line:SetBackdropColor (unpack (backdrop_color))

			DetailsFramework:Mixin (line, DetailsFramework.HeaderFunctions)

			line:SetScript ("OnEnter", lineOnEnter)
			line:SetScript ("OnLeave", lineOnLeave)

			--username
			local userNameText = DetailsFramework:CreateLabel (line)

			--realm
			local realmText = DetailsFramework:CreateLabel (line)

			--version
			local versionText = DetailsFramework:CreateLabel (line)

			line:AddFrameToHeaderAlignment (userNameText)
			line:AddFrameToHeaderAlignment (realmText)
			line:AddFrameToHeaderAlignment (versionText)

			line:AlignWithHeader (DetailsUserPanel.Header, "left")

			line.UserNameText = userNameText
			line.RealmText = realmText
			line.VersionText = versionText

			return line
		end

		local usersScroll = DetailsFramework:CreateScrollBox (DetailsUserPanel, "$parentUsersScroll", scroll_refresh, DetailsUserPanel.Data, scroll_width, scroll_height, scroll_lines, scroll_line_height)
		DetailsFramework:ReskinSlider (usersScroll)
		usersScroll:SetPoint ("TOPLEFT", DetailsUserPanel, "TOPLEFT", 5, scrollY)
		Details.UserPanel.ScrollBox = usersScroll

		--create lines
		for i = 1, scroll_lines do
			usersScroll:CreateLine (scroll_createline)
		end

		DetailsUserPanel:SetScript ("OnShow", function()
		end)

		DetailsUserPanel:SetScript ("OnHide", function()
		end)
	end

	Details.UserPanel.ScrollBox:SetData (usersTable)
	Details.UserPanel.ScrollBox:Refresh()
	DetailsUserPanel:Show()
end

function _detalhes:CreateListPanel()

	self.ListPanel = self.gump:NewPanel (UIParent, nil, "DetailsActorsFrame", nil, 300, 600)
	self.ListPanel:SetPoint ("CENTER", UIParent, "CENTER", 300, 0)
	self.ListPanel.barras = {}

	tinsert (UISpecialFrames, "DetailsActorsFrame")
	self.ListPanel.close_with_right = true

	local container_barras_window = CreateFrame ("ScrollFrame", "Details_ActorsBarrasScroll", self.ListPanel.widget)
	local container_barras = CreateFrame ("Frame", "Details_ActorsBarras", container_barras_window)
	self.ListPanel.container = container_barras

	self.ListPanel.width = 500
	self.ListPanel.locked = false

	container_barras_window:SetBackdrop({
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-gold-Border", tile = true, tileSize = 16, edgeSize = 5,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})
	container_barras_window:SetBackdropBorderColor (0, 0, 0, 0)

	container_barras:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})
	container_barras:SetBackdropColor (0, 0, 0, 0)

	container_barras:SetAllPoints (container_barras_window)
	container_barras:SetWidth (500)
	container_barras:SetHeight (150)
	container_barras:EnableMouse (true)
	container_barras:SetResizable (false)
	container_barras:SetMovable (true)

	container_barras_window:SetWidth (460)
	container_barras_window:SetHeight (550)
	container_barras_window:SetScrollChild (container_barras)
	container_barras_window:SetPoint ("TOPLEFT", self.ListPanel.widget, "TOPLEFT", 21, -10)

	self.gump:NewScrollBar (container_barras_window, container_barras, -10, -17)
	container_barras_window.slider:Altura (560)
	container_barras_window.slider:cimaPoint (0, 1)
	container_barras_window.slider:baixoPoint (0, -3)
	container_barras_window.slider:SetFrameLevel (10)

	container_barras_window.ultimo = 0

	container_barras_window.gump = container_barras

	function self.ListPanel:add (text, index, filter)
		local row = self.barras [index]
		if (not row) then
			row = {text = self.container:CreateFontString (nil, "overlay", "GameFontNormal")}
			self.barras [index] = row
			row.text:SetPoint ("TOPLEFT", self.container, "TOPLEFT", 0, -index * 15)
		end

		if (filter and text:find (filter)) then
			row.text:SetTextColor (1, 1, 0)
		else
			row.text:SetTextColor (1, 1, 1)
		end

		row.text:SetText (text)
	end

	return self.ListPanel
end

--doe
--endd elsee
