VUHDO_IS_PANEL_CONFIG = false;
VUHDO_CONFIG_SHOW_RAID = false;

local VUHDO_DRAG_MAX_DISTANCE = 60;

VUHDO_PANEL_MODEL_GUESSED = { };


local sqrt = sqrt;

--
function VUHDO_setGuessedModel(aPanelNum, aSlotNum, aValue)
	if (VUHDO_PANEL_MODEL_GUESSED[aPanelNum] == nil) then
		VUHDO_PANEL_MODEL_GUESSED[aPanelNum] = { };
	end

	VUHDO_PANEL_MODEL_GUESSED[aPanelNum][aSlotNum] = aValue;
end



--
local function VUHDO_getGuessedModel(aPanelNum, aSlotNum)
	if (VUHDO_PANEL_MODEL_GUESSED[aPanelNum] == nil) then
		return false;
	end

	if (VUHDO_PANEL_MODEL_GUESSED[aPanelNum][aSlotNum] == nil) then
		return false;
	end

	return VUHDO_PANEL_MODEL_GUESSED[aPanelNum][aSlotNum];
end



--
local tCnt;
local tXPos, tYPos;
local tPanel;
local tModel;
local tIsShowOrder;
local tAnzModels;
local tModelArray;
local tScale;
local tParentPanel;
local tButton;
function VUHDO_positionAllGroupConfigPanels(aPanelNum)
	for _, tButton in pairs(VUHDO_getPanelButtons(aPanelNum)) do
		tButton:Hide();
	end

	tModelArray = VUHDO_PANEL_MODELS[aPanelNum];
	tScale =  VUHDO_getHealButtonWidth(aPanelNum) / VUHDO_getOrCreateGroupOrderPanel(aPanelNum, 1):GetWidth();

	if (tModelArray == nil) then
		return;
	end

	tParentPanel = VUHDO_getActionPanel(aPanelNum);
	tAnzModels = #tModelArray;

	for tCnt = 1, tAnzModels do
		VUHDO_getOrCreateGroupOrderPanel(aPanelNum, tCnt):SetScale(tScale);
		VUHDO_getOrCreateGroupSelectPanel(aPanelNum, tCnt):SetScale(tScale);

		tXPos, tYPos = VUHDO_getHealButtonPos(tCnt, 1, aPanelNum);

		 tModel = VUHDO_PANEL_MODELS[aPanelNum][tCnt];
		 tIsShowOrder = (tModel ~= VUHDO_ID_UNDEFINED)
			and not VUHDO_getGuessedModel(aPanelNum, tCnt);

		 tPanel = VUHDO_getGroupOrderPanel(aPanelNum, tCnt);
		 tPanel:ClearAllPoints();
		 tPanel:SetPoint("TOPLEFT", tParentPanel:GetName(), "TOPLEFT", tXPos / tScale, -tYPos / tScale);
		 if (tIsShowOrder) then
			 tPanel:Hide();
			 tPanel:Show();
		 else
			 tPanel:Hide();
		 end

		 tPanel = VUHDO_getGroupSelectPanel(aPanelNum, tCnt);
		 tPanel:ClearAllPoints();
		 tPanel:SetPoint("TOPLEFT", tParentPanel:GetName(), "TOPLEFT", tXPos / tScale, -tYPos / tScale);
		 if (not tIsShowOrder) then
			 tPanel:Hide();
			 tPanel:Show();
		 else
			 tPanel:Hide();
		 end

		 VUHDO_getConfigOrderBarLeft(aPanelNum, tCnt):Hide();
		 VUHDO_getConfigOrderBarRight(aPanelNum, tCnt):Hide();
	end

	for tCnt = tAnzModels + 1, 15 do -- VUHDO_MAX_GROUPS_PER_PANEL
 		tPanel = VUHDO_getOrCreateGroupOrderPanel(aPanelNum, tCnt);
		tPanel:Hide();

		tPanel = VUHDO_getOrCreateGroupSelectPanel(aPanelNum, tCnt);
		tPanel:Hide();
	end
end



--
local tDeltaX, tDeltaY;
local tDistance;
local function VUHDO_determineDistance(aXPos, aYPos, anotherXPos, anotherYPos)
	tDeltaX = aXPos - anotherXPos;
	tDeltaY = aYPos - anotherYPos;

	tDistance = sqrt(tDeltaX * tDeltaX + tDeltaY * tDeltaY); -- (<-- Pythagoras, woot!, I'm sophisticated)

	return tDistance;
end



--
local tDragSweetY;
local tTargetSweetY;
local function VUHDO_GetDragTargetSweetY(aDraggedPanel, aDragTargetPanel)
	tDragSweetY = aDraggedPanel:GetTop() * aDraggedPanel:GetScale() - (aDraggedPanel:GetHeight() * aDraggedPanel:GetScale() * 0.5);
	if (tDragSweetY > aDragTargetPanel:GetTop() * aDragTargetPanel:GetScale()) then
		tTargetSweetY = aDragTargetPanel:GetTop() * aDragTargetPanel:GetScale();
	elseif (tDragSweetY < aDragTargetPanel:GetBottom() * aDragTargetPanel:GetScale()) then
		tTargetSweetY = aDragTargetPanel:GetBottom() * aDragTargetPanel:GetScale();
	else
		tTargetSweetY = tDragSweetY;
	end

	return tTargetSweetY;
end



--
local tDragSweetX, tDragSweetY;
local tTargetSweetX, tTargetSweetY;
local tDistance;
local function VUHDO_determineDragDistance(aDraggedPanel, aDragTargetPanel, anIsLeftOf)

	tDragSweetX = aDraggedPanel:GetLeft() * aDraggedPanel:GetScale() + (aDraggedPanel:GetWidth() * aDraggedPanel:GetScale() * 0.5);
	tDragSweetY = aDraggedPanel:GetTop() * aDraggedPanel:GetScale() - (aDraggedPanel:GetHeight() * aDraggedPanel:GetScale() * 0.5);

	if (anIsLeftOf) then
		tTargetSweetX = aDragTargetPanel:GetLeft() * aDragTargetPanel:GetScale();
	else
		tTargetSweetX = aDragTargetPanel:GetRight() * aDragTargetPanel:GetScale();
	end

	tTargetSweetY = VUHDO_GetDragTargetSweetY(aDraggedPanel, aDragTargetPanel);

	tDistance = VUHDO_determineDistance(tDragSweetX, tDragSweetY, tTargetSweetX, tTargetSweetY);
	return tDistance;
end



--
local tPanelNum, tOrderNum;
local tLeftBarOrderNum;
local tRightBarOrderNum;
local tBarLeft, tBarRight;
local function VUHDO_refreshDragTargetBars(aPanelNum, anOrderPanelNum, anIsLeft, aDraggedPanel)
	tLeftBarOrderNum = nil;
	tRightBarOrderNum = nil;

	if (anOrderPanelNum ~= nil) then
		if (anIsLeft) then
			tLeftBarOrderNum = anOrderPanelNum;

			if (anOrderPanelNum > 1) then
				tRightBarOrderNum = anOrderPanelNum - 1;
			end
		else
			tRightBarOrderNum = anOrderPanelNum;

			if (VUHDO_PANEL_MODELS[aPanelNum] ~= nil
				and anOrderPanelNum < #VUHDO_PANEL_MODELS[aPanelNum]) then
				tLeftBarOrderNum = anOrderPanelNum + 1;
			end
		end
	end

	for tPanelNum = 1, VUHDO_MAX_PANELS do
		for tOrderNum = 1, 15 do -- VUHDO_MAX_GROUPS_PER_PANEL
			tBarLeft = VUHDO_getConfigOrderBarLeft(tPanelNum, tOrderNum);
			tBarRight = VUHDO_getConfigOrderBarRight(tPanelNum, tOrderNum);

			if (aPanelNum == tPanelNum) then
				if (tLeftBarOrderNum ~= nil
					and tLeftBarOrderNum == tOrderNum
					and tBarLeft:GetParent() ~= aDraggedPanel) then
					tBarLeft:Show();
				else
					tBarLeft:Hide();
				end

				if (tRightBarOrderNum ~= nil
					and tRightBarOrderNum == tOrderNum
					and tBarLeft:GetParent() ~= aDraggedPanel) then
					tBarRight:Show();
				else
					tBarRight:Hide();
				end
			else
				tBarLeft:Hide();
				tBarRight:Hide();
			end
		end
	end

end



--
local tPanelNum, tConfigNum;
local tOrderPanel;
local tCurrentDistance, tLowestDistance;
local tLowPanelNum, tLowOrderNum;
local tIsLeft;
local tMaxOrderPanels;
local tPanel;
local tPanelX;
local tPanelY;
local tDragX;
local tDragY;
function VUHDO_determineDragTarget(aDraggedPanel)

	tLowestDistance = 999999;
	for tPanelNum = 1, VUHDO_MAX_PANELS do
		tPanel = VUHDO_getActionPanel(tPanelNum);
		if (tPanel:IsVisible()) then
			tMaxOrderPanels = #VUHDO_PANEL_MODELS[tPanelNum];
			for tConfigNum = 1, tMaxOrderPanels do
				tOrderPanel = VUHDO_getGroupOrderPanel(tPanelNum, tConfigNum);

				if (tOrderPanel ~= aDraggedPanel) then

					tCurrentDistance = VUHDO_determineDragDistance(aDraggedPanel, tOrderPanel, true);
					if (tCurrentDistance < tLowestDistance) then
						tLowestDistance = tCurrentDistance;
						tLowPanelNum = tPanelNum;
						tLowOrderNum = tConfigNum;
						tIsLeft = true;
					end

					tCurrentDistance = VUHDO_determineDragDistance(aDraggedPanel, tOrderPanel, false);
					if (tCurrentDistance < tLowestDistance) then
						tLowestDistance = tCurrentDistance;
						tLowPanelNum = tPanelNum;
						tLowOrderNum = tConfigNum;
						tIsLeft = false;
					end
				end
			end
			-- Test for dragging into an empty Panel
			if (tMaxOrderPanels == 0) then

				tPanelX = tPanel:GetLeft() + (tPanel:GetWidth() * 0.5);
				tPanelY = tPanel:GetTop() - (tPanel:GetHeight()  * 0.5);
				tDragX = aDraggedPanel:GetLeft() * aDraggedPanel:GetScale() + (aDraggedPanel:GetWidth() * aDraggedPanel:GetScale() * 0.5);
				tDragY = aDraggedPanel:GetTop() * aDraggedPanel:GetScale() - (aDraggedPanel:GetHeight() * aDraggedPanel:GetScale() * 0.5);
				tCurrentDistance = VUHDO_determineDistance(tPanelX, tPanelY, tDragX, tDragY);

				if (tCurrentDistance < tLowestDistance) then
					tLowestDistance = tCurrentDistance;
					tLowPanelNum = tPanelNum;
					tLowOrderNum = 1;
					tIsLeft = true;
				end
			end
		end
	end

	if (tLowestDistance > VUHDO_DRAG_MAX_DISTANCE) then
		return nil, nil, nil;
	else
		return tLowPanelNum, tLowOrderNum, tIsLeft;
	end
end



--
local tPanelNum, tOrderNum, tIsLeft;
function VUHDO_refreshDragTarget(aDraggedPanel)
	tPanelNum, tOrderNum, tIsLeft = VUHDO_determineDragTarget(aDraggedPanel);
	VUHDO_refreshDragTargetBars(tPanelNum, tOrderNum, tIsLeft, aDraggedPanel);
end



--
local tNumbers;
function VUHDO_getComponentPanelNumModelNum(aComponent)
	tNumbers = VUHDO_getNumbersFromString(aComponent:GetName(), 2);
	return tNumbers[1], tNumbers[2];
end



--
local tPanelNum, tOrderNum, tIsLeft;
local tSourcePanelNum, tSourceGroupOrderNum;
local tModelId;
function VUHDO_reorderGroupsAfterDragged(aDraggedPanel)
	tPanelNum, tOrderNum, tIsLeft = VUHDO_determineDragTarget(aDraggedPanel);

	if (tOrderNum ~= nil) then
		tSourcePanelNum, tSourceGroupOrderNum = VUHDO_getComponentPanelNumModelNum(aDraggedPanel);
		tModelId = VUHDO_PANEL_MODELS[tSourcePanelNum][tSourceGroupOrderNum];
		VUHDO_removeFromModel(tSourcePanelNum, tSourceGroupOrderNum);

		if (tSourcePanelNum == tPanelNum and tSourceGroupOrderNum < tOrderNum and tOrderNum > 1) then
			tOrderNum = tOrderNum - 1;
		end

		VUHDO_insertIntoModel(tPanelNum, tOrderNum, tIsLeft, tModelId);
		VUHDO_PANEL_MODEL_GUESSED[tPanelNum] = { };
	end

	VUHDO_redrawAllPanels();
end



--
local tCheckId, tModelId;
local tTypeMembers;
local tModels;
local tIsUsed;
function VUHDO_guessModelIdForType(aPanelNum, aType)
	tTypeMembers = VUHDO_ID_TYPE_MEMBERS[aType];
	tModels = VUHDO_PANEL_MODELS[aPanelNum];

	for _, tCheckId in ipairs(tTypeMembers) do
		tIsUsed = false;
		for _, tModelId in pairs(tModels) do
			if (tCheckId == tModelId) then
				tIsUsed = true;
				break;
			end
		end

		if (not tIsUsed) then
			return tCheckId;
		end
	end

	return nil;
end



--
local tModelId;
local tModelType;
local tTupel;
local tIndex;
local tGuessId;
local tTypeCount = { };
function VUHDO_guessUndefinedEntries(aPanelNum)

	table.wipe(tTypeCount);
	tTypeCount = {
		[VUHDO_ID_TYPE_GROUP] = { VUHDO_ID_TYPE_GROUP, 0 },
		[VUHDO_ID_TYPE_CLASS] = { VUHDO_ID_TYPE_CLASS, 0 },
		[VUHDO_ID_TYPE_SPECIAL] = { VUHDO_ID_TYPE_SPECIAL, 0 }
	};

	for tIndex, tModelId in ipairs(VUHDO_PANEL_MODELS[aPanelNum]) do
		tModelType = VUHDO_getModelType(tModelId);

		if (tTypeCount[tModelType] ~= nil and not VUHDO_getGuessedModel(aPanelNum, tIndex)) then
			tTypeCount[tModelType][2] = tTypeCount[tModelType][2] + 1;
		else
			VUHDO_PANEL_MODELS[aPanelNum][tIndex] = VUHDO_ID_TYPE_UNDEFINED;
		end
	end

	table.sort(tTypeCount,
		function(aTupel, anotherTupel)
			return aTupel[2] > anotherTupel[2];
		end
	);

	for tIndex, tModelId in ipairs(VUHDO_PANEL_MODELS[aPanelNum]) do
		if (tModelId == VUHDO_ID_TYPE_UNDEFINED) then
			for _, tTupel in ipairs(tTypeCount) do
				if (tTupel[2] == 0) then
					return;
				end

				tGuessId = VUHDO_guessModelIdForType(aPanelNum, tTupel[1]);
				if (tGuessId ~= nil) then
					VUHDO_PANEL_MODELS[aPanelNum][tIndex] = tGuessId;
					VUHDO_setGuessedModel(aPanelNum, tIndex, true);
					break;
				end
			end
		end
	end
end


