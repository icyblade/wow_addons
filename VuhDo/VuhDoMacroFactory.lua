VUHDO_IS_SFX_ENABLED = true;

local VUHDO_RAID;
local VUHDO_RAID_NAMES;
local VUHDO_SPELL_CONFIG;
local VUHDO_SPELLS;
local VUHDO_SPELL_CONFIG;

local GetMacroIndexByName = GetMacroIndexByName;
local GetMacroInfo = GetMacroInfo;
local GetSpellBookItemTexture = GetSpellBookItemTexture;
local VUHDO_replaceMacroTemplates;
local strlen = strlen;
local gsub = gsub;
local twipe = table.wipe;
local format = format;
local sEmpty = { };

CreateFrame("Button", "VDSTB", nil, "SecureActionButtonTemplate");
VDSTB:SetAttribute("type", "stop"); -- Calls SpellStopTargeting
local sStopTargetText = "/click VDSTB\n";


function VUHDO_macroFactoryInitBurst()
	VUHDO_RAID = VUHDO_GLOBAL["VUHDO_RAID"];
	VUHDO_RAID_NAMES = VUHDO_GLOBAL["VUHDO_RAID_NAMES"];
	VUHDO_SPELL_CONFIG = VUHDO_GLOBAL["VUHDO_SPELL_CONFIG"];
	VUHDO_SPELLS = VUHDO_GLOBAL["VUHDO_SPELLS"];
	VUHDO_SPELL_CONFIG = VUHDO_GLOBAL["VUHDO_SPELL_CONFIG"];

	VUHDO_replaceMacroTemplates = VUHDO_GLOBAL["VUHDO_replaceMacroTemplates"];
end



local VUHDO_RAID_MACRO_CACHE = { };
local VUHDO_TARGET_MACRO_CACHE = { };
local sFireText = nil;



--
function VUHDO_resetMacroCaches()
	twipe(VUHDO_RAID_MACRO_CACHE);
	twipe(VUHDO_TARGET_MACRO_CACHE);
	sFireText = nil;
end



--
local function VUHDO_isFireSomething(anAction)
	if (not VUHDO_SPELL_CONFIG["IS_AUTO_FIRE"]
		or ((VUHDO_SPELLS[anAction] or sEmpty)["isHot"] and not VUHDO_SPELL_CONFIG["IS_FIRE_HOT"])) then -- VUHDO_SPELL_TYPE_HOT
		return false;
	end

	return VUHDO_SPELL_CONFIG["IS_FIRE_TRINKET_1"]
		or VUHDO_SPELL_CONFIG["IS_FIRE_TRINKET_2"]
		or VUHDO_SPELL_CONFIG["IS_FIRE_GLOVES"]
		or (VUHDO_SPELL_CONFIG["IS_FIRE_CUSTOM_1"] and not VUHDO_strempty(VUHDO_SPELL_CONFIG["FIRE_CUSTOM_1_SPELL"]))
		or (VUHDO_SPELL_CONFIG["IS_FIRE_CUSTOM_2"] and not VUHDO_strempty(VUHDO_SPELL_CONFIG["FIRE_CUSTOM_2_SPELL"]));
end



--
local tInstant, tModi2;
local function VUHDO_getInstantFireText(aSlotNum)
	tInstant = VUHDO_SPELL_CONFIG["FIRE_CUSTOM_" .. aSlotNum .. "_SPELL"];
	if (VUHDO_SPELL_CONFIG["IS_FIRE_CUSTOM_" .. aSlotNum] and not VUHDO_strempty(tInstant)) then

		if (VUHDO_SPELL_CONFIG["IS_FIRE_OUT_FIGHT"]) then
			if ((VUHDO_SPELLS[tInstant] or sEmpty)["noselftarget"]) then
				tModi2 = " ";
			else
				tModi2 = " [@player] ";
			end
		else
			if ((VUHDO_SPELLS[tInstant] or sEmpty)["noselftarget"]) then
				tModi2 = " [combat] ";
			else
				tModi2 = " [combat,@player] ";
			end
		end

		return "/use" .. tModi2 .. tInstant .. "\n";
	else
		return "";
	end
end



--
local tModi;
local function VUHDO_getFireText(anAction)

	if (VUHDO_isFireSomething(anAction)) then
		if (sFireText == nil) then
			sFireText = "";
			if (VUHDO_IS_SFX_ENABLED) then
				sFireText = sFireText .. "/console Sound_EnableSFX 0\n";
			end

			if (VUHDO_SPELL_CONFIG["IS_FIRE_OUT_FIGHT"]) then
				tModi = " ";
			else
				tModi = " [combat] ";
			end

			if (VUHDO_SPELL_CONFIG["IS_FIRE_GLOVES"]) then
				sFireText = sFireText .. "/use".. tModi .."10\n";
			end

			if (VUHDO_SPELL_CONFIG["IS_FIRE_TRINKET_1"]) then
				sFireText = sFireText .. "/use".. tModi .."13\n";
			end

			if (VUHDO_SPELL_CONFIG["IS_FIRE_TRINKET_2"]) then
				sFireText = sFireText .. "/use".. tModi .."14\n";
			end

			-- Instant 1
			sFireText = sFireText .. VUHDO_getInstantFireText(1);
			-- Instant 2
			sFireText = sFireText .. VUHDO_getInstantFireText(2);

			-- Ton wieder an
			if (VUHDO_IS_SFX_ENABLED) then
				sFireText = sFireText .. "/console Sound_EnableSFX 1\n";
			end

			sFireText = sFireText .. "/run UIErrorsFrame:Clear()\n";
		end

		return sFireText;
	else
		return "";
	end

end



--
local function VUHDO_getMacroPetUnit(aTarget)
	if (VUHDO_RAID[aTarget] ~= nil and not VUHDO_RAID[aTarget]["isPet"]) then
		return VUHDO_RAID[aTarget]["petUnit"];
	else
		return nil;
	end
end



--
local tFriendText;
local tEnemyText;
local tModiSpell;
local tMacroId, tMacroText;
local tLowerFriendly, tLowerHostile, tStopText;
local tIsNoHelp;
local function VUHDO_generateTargetMacroText(aTarget, aFriendlyAction, aHostileAction)
	if (aFriendlyAction == nil or aHostileAction == nil) then
		return "";
	end

	tMacroId = GetMacroIndexByName(aHostileAction);
	if (tMacroId == 0) then
		tMacroId = GetMacroIndexByName(aFriendlyAction);
	end

	if (tMacroId ~= 0) then
		_, _, tMacroText = GetMacroInfo(tMacroId);
		return tMacroText;
	end

	if (VUHDO_SPELL_CONFIG["IS_CANCEL_CURRENT"]) then
		tStopText = "/stopcasting\n";
	else
		tStopText = "";
	end

	tLowerFriendly = strlower(aFriendlyAction);
	tIsNoHelp = false;

	if ("target" == tLowerFriendly) then
		tFriendText = "/tar [noharm,@vuhdo]\n";
	elseif ("focus" == tLowerFriendly) then
		tFriendText = "/focus [noharm,@vuhdo]\n";
	elseif ("assist" == tLowerFriendly) then
		tFriendText = "/assist [noharm,@vuhdo]\n";
	elseif (strlen(aFriendlyAction) > 0 and GetSpellBookItemTexture(aFriendlyAction) ~= nil) then
		if ((VUHDO_SPELLS[aFriendlyAction] or sEmpty)["nohelp"]) then
			tModiSpell = "[@vuhdo";
			tIsNoHelp = true;
		else
			tModiSpell = "[noharm,@vuhdo";
		end

		if (VUHDO_SPELL_CONFIG["IS_KEEP_STANCE"]) then
			if ("DRUID" == VUHDO_PLAYER_CLASS) then
				tModiSpell = tModiSpell .. ",noform:1/3";
			end

			if ("PRIEST" == VUHDO_PLAYER_CLASS) then
				tModiSpell = tModiSpell .. ",noform:1";
			end
		end
		tModiSpell = tModiSpell .. "] ";

		tFriendText = "/use " .. tModiSpell .. aFriendlyAction .. "\n";
		if (VUHDO_SPELL_CONFIG["IS_AUTO_TARGET"]) then
			tFriendText = tFriendText .. "/tar [@vuhdo]\n";
		end
	else
		tFriendText = "";
	end

	tLowerHostile = strlower(aHostileAction);
	if (tIsNoHelp) then
		tEnemyText = "";
	elseif ("target" == tLowerHostile) then
		tEnemyText = "/tar [harm,@vuhdo]";
	elseif ("focus" == tLowerHostile) then
		tEnemyText = "/focus [harm,@vuhdo]";
	elseif ("assist" == tLowerHostile) then
		tEnemyText = "/assist [harm,@vuhdo]";
	elseif (strlen(aHostileAction) > 0 and GetSpellBookItemTexture(aHostileAction) ~= nil) then
		tEnemyText = "/use [harm,@vuhdo] " .. aHostileAction;
	else
		tEnemyText = "";
	end

	return sStopTargetText .. tStopText .. VUHDO_getFireText(aFriendlyAction) .. tFriendText .. tEnemyText;
end



--
local tIndex, tText;
function VUHDO_buildTargetButtonMacroText(aTarget, aFriendlyAction, aHostileAction)
	tIndex = aFriendlyAction .. "*" .. aHostileAction;

	if (VUHDO_TARGET_MACRO_CACHE[tIndex] == nil) then
		VUHDO_TARGET_MACRO_CACHE[tIndex] = VUHDO_generateTargetMacroText(aTarget, aFriendlyAction, aHostileAction);
	end

	tText = VUHDO_replaceMacroTemplates(VUHDO_TARGET_MACRO_CACHE[tIndex], aTarget);
	return tText;
end



--
local tPet;
function VUHDO_buildFocusMacroText(aTarget)
	tPet = VUHDO_getMacroPetUnit(aTarget);

	if (tPet ~= nil) then
		return format("/focus [@%s,help][@%s,help][@%s]", aTarget, tPet, aTarget);
	else
		return "/focus [@" .. aTarget .. "]";
	end
end



--
local tPet;
function VUHDO_buildTargetMacroText(aTarget)
	tPet = VUHDO_getMacroPetUnit(aTarget);

	if (tPet ~= nil) then
		return format("/tar [@%s,help][@%s,help][@%s]", aTarget, tPet, aTarget);
	else
		return "/tar [@" .. aTarget .. "]";
	end
end



--
local tPet;
function VUHDO_buildAssistMacroText(aTarget)
	tPet = VUHDO_getMacroPetUnit(aTarget);

	if (tPet ~= nil) then
		return format("/assist [@%s,help][@%s,help][@%s]", aTarget, tPet, aTarget);
	else
		return "/assist [@" .. aTarget .. "]";
	end
end




local VUHDO_PROHIBIT_HELP = {
	[VUHDO_SPELL_ID.REBIRTH] = true,
	[VUHDO_SPELL_ID.REDEMPTION] = true,
	[VUHDO_SPELL_ID.ANCESTRAL_SPIRIT] = true,
	[VUHDO_SPELL_ID.REVIVE] = true,
	[VUHDO_SPELL_ID.RESURRECTION] = true,
	[VUHDO_SPELL_ID.RAISE_ALLY] = true,
}



--
local tText;
local tModiSpell;
local tSpellPost;
local tVehicleCond;
local tStopText;
local function VUHDO_generateRaidMacroTemplate(anAction, anIsKeyboard, aTarget, aPet)
	if (VUHDO_SPELL_CONFIG["IS_CANCEL_CURRENT"]) then
		tStopText = "/stopcasting\n";
	else
		tStopText = "";
	end

	tText = sStopTargetText .. tStopText .. VUHDO_getFireText(anAction);

	if ((VUHDO_SPELLS[anAction] or sEmpty)["nohelp"] or VUHDO_PROHIBIT_HELP[anAction]) then
		tModiSpell = "";
	else
		tModiSpell = "help,nodead,";
	end

	tSpellPost = "";
	if ("DRUID" == VUHDO_PLAYER_CLASS and VUHDO_SPELL_CONFIG["autoBattleRez"]) then
		tSpellPost = "/use [dead,nobonusbar:5,combat,";
		if (VUHDO_SPELL_CONFIG["smartCastModi"] ~= "all") then
			tSpellPost = tSpellPost .. "mod:" .. VUHDO_SPELL_CONFIG["smartCastModi"] .. ",";
		end
		tSpellPost =  tSpellPost .. "@mouseover] " .. VUHDO_SPELL_ID.REBIRTH .. "\n";
	end

	if (VUHDO_SPELL_CONFIG["IS_KEEP_STANCE"] and VUHDO_SPELL_ID.REBIRTH ~= anAction
		and VUHDO_SPELLS[anAction] ~= nil and not VUHDO_SPELLS[anAction]["nostance"]) then

		if ("DRUID" == VUHDO_PLAYER_CLASS) then
			tModiSpell = tModiSpell .. "noform:1/3,";
			tSpellPost = tSpellPost .. "/tar [form:1/3,nobonusbar:5,@" .. (anIsKeyboard and "mouseover]\n" or "vuhdo]\n");
		end

		if ("PRIEST" == VUHDO_PLAYER_CLASS) then
			tModiSpell = tModiSpell .. "noform:1,";
			tSpellPost = "/tar [form:1,nobonusbar:5,@" .. (anIsKeyboard and "mouseover]\n" or "vuhdo]\n");
		end
	end

	if (anIsKeyboard) then
		tText = tText .. "/use [" .. tModiSpell .. "@mouseover] " .. anAction .. "\n";
		tText = tText .. tSpellPost;
	else
		if (aPet ~= nil and VUHDO_SPELL_ID.REBIRTH ~= anAction) then
			tVehicleCond = "[nodead,help,nobonusbar:5,@vdpet]";
		else
			tVehicleCond = "";
		end
		tText = tText .. "/use [" .. tModiSpell .. "nobonusbar:5,@vuhdo]" .. tVehicleCond .. " " .. anAction .. "\n";
		tText = tText .. tSpellPost;
		if (aPet ~= nil) then
			tText = tText .. "/tar [bonusbar:5,@vdpet]\n";
		end

		if (VUHDO_SPELL_CONFIG["IS_AUTO_TARGET"]) then
			tText = tText .. "/tar [@vuhdo]\n";
		else
			tText = tText .. "/tar [harm,@vuhdo]\n";
		end
	end

	--VUHDO_Msg(tText);
	return tText;
end



--
local tIndex;
local tPet;
local tText;
function VUHDO_buildMacroText(anAction, anIsKeyboard, aTarget)
	tPet = VUHDO_getMacroPetUnit(aTarget);

	if (anIsKeyboard) then
		tIndex = anAction .. (tPet ~= nil and (anAction .. "X") or (anAction .. "K"));
	else
		tIndex = anAction .. (tPet ~= nil and (anAction .. "P") or anAction);
	end

	if (VUHDO_RAID_MACRO_CACHE[tIndex] == nil) then
		VUHDO_RAID_MACRO_CACHE[tIndex] = VUHDO_generateRaidMacroTemplate(anAction, anIsKeyboard, aTarget, tPet);
	end

	tText = VUHDO_replaceMacroTemplates(VUHDO_RAID_MACRO_CACHE[tIndex], aTarget);
	if (anIsKeyboard and strlen(tText) > 256) then
		VUHDO_Msg(VUHDO_I18N_MACRO_KEY_ERR_1 .. anAction .. " (" .. strlen(tText) .. VUHDO_I18N_MACRO_KEY_ERR_2, 1, 0.3, 0.3);
	end
	return tText;
end



--
local tText;
function VUHDO_buildPurgeMacroText(anAction, aTarget)
	tText = format("/use [@%s] %s\n", aTarget, anAction);

	if (VUHDO_SPELL_CONFIG["IS_AUTO_TARGET"]) then
		tText = format("%s/tar [@%s]\n", tText, aTarget);
	end
	return tText;
end



-- Catch players who have released spirit
local tText;
function VUHDO_buildRezMacroText(anAction, aTarget)
	tText = format("/tar [@%s]\n", aTarget);
	tText = format("%s/use %s\n", tText, anAction);
	if (not VUHDO_SPELL_CONFIG["IS_AUTO_TARGET"]) then
		tText = format("%s/targetlasttarget\n", tText);
	end

	return tText;
end



--
local tName;
local tIndex;
local tNumLocal;
local function VUHDO_createOrUpdateMacro(aMacroNum, aMacroText, aSpell)
	tName = "VuhDoAuto" .. aMacroNum;
	tIndex = GetMacroIndexByName(tName);
	if (tIndex == 0) then
		_, tNumLocal = GetNumMacros();
		if (tNumLocal >= 18) then
			VUHDO_Msg(VUHDO_I18N_MACRO_NUM_ERR .. aSpell, 1, 0.4, 0.4);
			return nil;
		end
		return CreateMacro(tName, 1, aMacroText, true, nil);
	else
		return EditMacro(tIndex, tName, 1, aMacroText, true, nil)
	end
end



--
function VUHDO_initKeyboardMacros()
	local tBindingName;
	local tMacroId;
	local tSpell;
	local tCnt;
	local tBody;
	local tKey1, tKey2;
	local tBindPrefix = "VUHDO_KEY_ASSIGN_";

	VUHDO_IS_SFX_ENABLED = tonumber(GetCVar("Sound_EnableSFX")) == 1;

	if (VUHDO_SPELLS_KEYBOARD == nil) then
		return;
	end

	ClearOverrideBindings(VuhDo);
	for tCnt = 1, 16 do
		tSpell = VUHDO_SPELLS_KEYBOARD[format("SPELL%d", tCnt)];
		tBindingName = format("%s %d", VUHDO_I18N_MOUSE_OVER_BINDING, tCnt);

		if (strlen(tSpell or "") == 0) then
			tBindingName = format("%s\n|cff505050%s|r", tBindingName, VUHDO_I18N_UNASSIGNED);
		else
			if (VUHDO_isSpellKnown(tSpell)) then
				tBindingName = format("%s\n(|cff00ff00%s|r)", tBindingName, tSpell);
			else
				tBindingName = format("%s\n(|cffff0000%s|r)", tBindingName, tSpell);
			end
		end

		VUHDO_GLOBAL[format("BINDING_NAME_%s%d", tBindPrefix, tCnt)] = tBindingName;

		tKey1, tKey2 = GetBindingKey(tBindPrefix .. tCnt);
		if (strlen(tSpell or "") > 0 and (tKey1 ~= nil or tKey2 ~= nil)) then
			tBody = VUHDO_buildMacroText(tSpell, true, nil);
			tMacroId = VUHDO_createOrUpdateMacro(tCnt, tBody, tSpell);
			if (tMacroId ~= nil) then
				if (tKey1 ~= nil) then
					SetOverrideBindingMacro(VuhDo, true, tKey1, tMacroId);
				end

				if (tKey2 ~= nil) then
					SetOverrideBindingMacro(VuhDo, true, tKey2, tMacroId);
				end
			end
		else
			DeleteMacro(format("VuhDoAuto%d", tCnt));
		end
	end

	-- Buff watch smart cast binding
	tKey1, tKey2 = GetBindingKey(tBindPrefix .. "SMART_BUFF");
	if (tKey1 ~= nil) then
		SetOverrideBindingClick(VuhDo, true, tKey1, "VuhDoSmartCastGlassButton", "LeftButton");
	end
	if (tKey2 ~= nil) then
		SetOverrideBindingClick(VuhDo, true, tKey2, "VuhDoSmartCastGlassButton", "LeftButton");
	end
end
