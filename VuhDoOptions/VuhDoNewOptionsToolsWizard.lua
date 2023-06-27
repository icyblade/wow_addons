local tAktPanel;
local function VUHDO_wizardInitMainPanelGrouped(aPanelNum)
	tAktPanel = VUHDO_PANEL_SETUP[aPanelNum];

	tAktPanel["MODEL"].ordering = VUHDO_ORDERING_STRICT;
	tAktPanel["MODEL"].sort = VUHDO_SORT_RAID_NAME;

--	tAktPanel["SCALING"].showManaBars = true;
--	tAktPanel["SCALING"].showRageBars = false;
--	tAktPanel["SCALING"].manaBarHeight = 3;

	tAktPanel["SCALING"].showHeaders = true;

	tAktPanel["SCALING"].maxColumnsWhenStructured = 8;
	tAktPanel["SCALING"].maxRowsWhenLoose = 6;
	tAktPanel["SCALING"].ommitEmptyWhenStructured = true;

	tAktPanel["SCALING"].showTarget = false;

	tAktPanel["SCALING"].barWidth = 75;
	tAktPanel["SCALING"].barHeight = 25;

	tAktPanel["SCALING"].scale = 1;

	tAktPanel["ID_TEXT"].showName = true;
	tAktPanel["ID_TEXT"].showClass = false;
end



--
local tAktPanel;
local function VUHDO_wizardInitMainPanelLoose(aPanelNum)
	tAktPanel = VUHDO_PANEL_SETUP[aPanelNum];

	tAktPanel["MODEL"].ordering = VUHDO_ORDERING_LOOSE;
	tAktPanel["MODEL"].sort = VUHDO_SORT_RAID_NAME;

--	tAktPanel["SCALING"].showManaBars = true;
--	tAktPanel["SCALING"].showRageBars = false;
--	tAktPanel["SCALING"].manaBarHeight = 3;

	tAktPanel["SCALING"].showHeaders = true;

	tAktPanel["SCALING"].maxColumnsWhenStructured = 8;
	tAktPanel["SCALING"].maxRowsWhenLoose = 8;
	tAktPanel["SCALING"].ommitEmptyWhenStructured = true;

	tAktPanel["SCALING"].showTarget = false;

	tAktPanel["SCALING"].barWidth = 75;
	tAktPanel["SCALING"].barHeight = 25;

	tAktPanel["SCALING"].scale = 1;

	tAktPanel["ID_TEXT"].showName = true;
	tAktPanel["ID_TEXT"].showClass = false;
end



--
function VUHDO_panelWizardInitVarsGroups(aPanelNum)
	VUHDO_wizardInitMainPanelGrouped(aPanelNum);
end



--
function VUHDO_panelWizardInitVarsClasses(aPanelNum)
	VUHDO_wizardInitMainPanelGrouped(aPanelNum);
end



--
function VUHDO_panelWizardInitVarsRoles(aPanelNum)
	VUHDO_wizardInitMainPanelGrouped(aPanelNum);
end



--
function VUHDO_panelWizardInitVarsUnsort(aPanelNum)
	VUHDO_wizardInitMainPanelLoose(aPanelNum);
end







--
local tAktPanel;
function VUHDO_panelWizardInitVarsMainTanks(aPanelNum)
	tAktPanel = VUHDO_PANEL_SETUP[aPanelNum];

	tAktPanel["MODEL"].ordering = VUHDO_ORDERING_STRICT;
	tAktPanel["MODEL"].sort = VUHDO_SORT_RAID_NAME;

--	tAktPanel["SCALING"].showManaBars = false;
--	tAktPanel["SCALING"].showRageBars = false;
--	tAktPanel["SCALING"].manaBarHeight = 0;

	tAktPanel["SCALING"].showHeaders = true;

	tAktPanel["SCALING"].maxColumnsWhenStructured = 8;
	tAktPanel["SCALING"].maxRowsWhenLoose = 8;
	tAktPanel["SCALING"].ommitEmptyWhenStructured = false;

	tAktPanel["SCALING"].showTarget = true;

	tAktPanel["SCALING"].barWidth = 100;
	tAktPanel["SCALING"].barHeight = 30;

	tAktPanel["SCALING"].scale = 1;

	tAktPanel["ID_TEXT"].showName = true;
	tAktPanel["ID_TEXT"].showClass = false;
end



--
local tAktPanel;
function VUHDO_panelWizardInitVarsPlayerTargets(aPanelNum)
	tAktPanel = VUHDO_PANEL_SETUP[aPanelNum];

	tAktPanel["MODEL"].ordering = VUHDO_ORDERING_STRICT;
	tAktPanel["MODEL"].sort = VUHDO_SORT_RAID_NAME;


--	tAktPanel["SCALING"].showManaBars = false;
--	tAktPanel["SCALING"].showRageBars = false;
--	tAktPanel["SCALING"].manaBarHeight = 0;

	tAktPanel["SCALING"].showHeaders = true;

	tAktPanel["SCALING"].maxColumnsWhenStructured = 8;
	tAktPanel["SCALING"].maxRowsWhenLoose = 8;
	tAktPanel["SCALING"].ommitEmptyWhenStructured = false;

	tAktPanel["SCALING"].showTarget = true;

	tAktPanel["SCALING"].barWidth = 75;
	tAktPanel["SCALING"].barHeight = 25;

	tAktPanel["SCALING"].scale = 1;

	tAktPanel["ID_TEXT"].showName = true;
	tAktPanel["ID_TEXT"].showClass = false;
end



--
function VUHDO_panelWizardInitVarsPets(aPanelNum)
	VUHDO_wizardInitMainPanelLoose(aPanelNum);
end



--
function VUHDO_panelWizardInitVehicles(aPanelNum)
	VUHDO_wizardInitMainPanelLoose(aPanelNum);
end





VUHDO_WIZARD_MAIN_MODELS = {
	["GROUPS"] = {
		["MODEL"] = { VUHDO_ID_GROUP_1, VUHDO_ID_GROUP_2, VUHDO_ID_GROUP_3, VUHDO_ID_GROUP_4, VUHDO_ID_GROUP_5, VUHDO_ID_GROUP_6, VUHDO_ID_GROUP_7, VUHDO_ID_GROUP_8 },
		["INIT_FUNC"] = VUHDO_panelWizardInitVarsGroups,
	},
	["CLASSES"] = {
		["MODEL"] = { VUHDO_ID_WARRIORS, VUHDO_ID_ROGUES, VUHDO_ID_HUNTERS, VUHDO_ID_PALADINS, VUHDO_ID_MAGES, VUHDO_ID_WARLOCKS, VUHDO_ID_SHAMANS, VUHDO_ID_DRUIDS, VUHDO_ID_PRIESTS, VUHDO_ID_DEATH_KNIGHT },
		["INIT_FUNC"] = VUHDO_panelWizardInitVarsClasses,
	},
	["ROLES"] = {
		["MODEL"] = { VUHDO_ID_MELEE_TANK, VUHDO_ID_MELEE_DAMAGE, VUHDO_ID_RANGED_DAMAGE, VUHDO_ID_RANGED_HEAL },
		["INIT_FUNC"] = VUHDO_panelWizardInitVarsRoles,
	},
	["UNSORT"] = {
		["MODEL"] = { VUHDO_ID_GROUP_1, VUHDO_ID_GROUP_2, VUHDO_ID_GROUP_3, VUHDO_ID_GROUP_4, VUHDO_ID_GROUP_5, VUHDO_ID_GROUP_6, VUHDO_ID_GROUP_7, VUHDO_ID_GROUP_8 },
		["INIT_FUNC"] = VUHDO_panelWizardInitVarsUnsort,
	},
};



VUHDO_WIZARD_ADDITIONAL_MODELS = {
	["MAIN_TANKS"] = {
		["MODEL"] = { VUHDO_ID_MAINTANKS },
		["INIT_FUNC"] = VUHDO_panelWizardInitVarsMainTanks,
	},
	["PLAYER_TARGETS"] = {
		["MODEL"] = { VUHDO_ID_PRIVATE_TANKS },
		["INIT_FUNC"] = VUHDO_panelWizardInitVarsPlayerTargets,
	},
	["PETS"] = {
		["MODEL"] = { VUHDO_ID_PETS },
		["INIT_FUNC"] = VUHDO_panelWizardInitVarsPets,
	},
	["VEHICLES"] = {
		["MODEL"] = { VUHDO_ID_VEHICLES },
		["INIT_FUNC"] = VUHDO_panelWizardInitVehicles,
	},
};





--------------------------------------------------------------------------------------------




VUHDO_WIZARD_MAIN_PANEL_VAL = "GROUPS";
VUHDO_WIZARD_IS_MTS = false;
VUHDO_WIZARD_IS_PTS = false;
VUHDO_WIZARD_IS_PETS = false;
VUHDO_WIZARD_IS_VEHICLES = false;




local tNumPanels;



--
local function VUHDO_addPanel(aModelInfo)
	if (aModelInfo ~= nil) then
		VUHDO_PANEL_SETUP[tNumPanels]["MODEL"].groups = VUHDO_deepCopyTable(aModelInfo["MODEL"]);
		aModelInfo["INIT_FUNC"](tNumPanels);
	end
end



--
local tCnt;
function VUHDO_panelWizardApplyCallback(aDecision)
	if (VUHDO_YES == aDecision) then
		tNumPanels = 0;

		tNumPanels = tNumPanels + 1;
		VUHDO_addPanel(VUHDO_WIZARD_MAIN_MODELS[VUHDO_WIZARD_MAIN_PANEL_VAL]);

		tNumPanels = tNumPanels + 1;
		if (VUHDO_WIZARD_IS_MTS) then
			VUHDO_addPanel(VUHDO_WIZARD_ADDITIONAL_MODELS["MAIN_TANKS"]);
		else
			VUHDO_PANEL_SETUP[tNumPanels]["MODEL"].groups = nil;
		end

		tNumPanels = tNumPanels + 1;
		if (VUHDO_WIZARD_IS_PTS) then
			VUHDO_addPanel(VUHDO_WIZARD_ADDITIONAL_MODELS["PLAYER_TARGETS"]);
		else
			VUHDO_PANEL_SETUP[tNumPanels]["MODEL"].groups = nil;
		end

		tNumPanels = tNumPanels + 1;
		if (VUHDO_WIZARD_IS_PETS) then
			VUHDO_addPanel(VUHDO_WIZARD_ADDITIONAL_MODELS["PETS"]);
		else
			VUHDO_PANEL_SETUP[tNumPanels]["MODEL"].groups = nil;
		end

		tNumPanels = tNumPanels + 1;
		if (VUHDO_WIZARD_IS_VEHICLES) then
			VUHDO_addPanel(VUHDO_WIZARD_ADDITIONAL_MODELS["VEHICLES"]);
		else
			VUHDO_PANEL_SETUP[tNumPanels]["MODEL"].groups = nil;
		end

		for tCnt = tNumPanels + 1, VUHDO_MAX_PANELS do
			VUHDO_PANEL_SETUP[tCnt]["MODEL"].groups = nil;
		end

		VUHDO_initPanelModels();
		VUHDO_initDynamicPanelModels();
		VUHDO_reloadUI();
	end
end



--
function VUHDO_newOptionsApplyWizardOnClick()
	VuhDoYesNoFrameText:SetText("This will overwrite parts of your\ncurrent configuration. Proceed?");
	VuhDoYesNoFrame:SetAttribute("callback", VUHDO_panelWizardApplyCallback);
	VuhDoYesNoFrame:Show();
end

