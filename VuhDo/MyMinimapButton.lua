
VuhDoMinimap = {

	["Create"] = function(self, someModSettings, someInitSettings)

		if VuhDoMinimapButton then return; end

		local tFrame = CreateFrame("Button", "VuhDoMinimapButton", Minimap);

		tFrame:SetWidth(31);
		tFrame:SetHeight(31);
		tFrame:SetFrameStrata("LOW");
		tFrame:SetToplevel(true);
		tFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight");
		tFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT");

		local tIcon = tFrame:CreateTexture("VuhDoMinimapButtonIcon", "BACKGROUND");
		tIcon:SetTexture(VUHDO_STANDARD_ICON);
		tIcon:SetWidth(20);
		tIcon:SetHeight(20);
		tIcon:SetPoint("TOPLEFT", tFrame, "TOPLEFT", 7, -5);

		local tOverlay = tFrame:CreateTexture("VuhDoMinimapButtonOverlay", "OVERLAY");
		tOverlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder");
		tOverlay:SetWidth(53);
		tOverlay:SetHeight(53);
		tOverlay:SetPoint("TOPLEFT", tFrame, "TOPLEFT")

		tFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		tFrame:SetScript("OnClick", self.OnClick);

		tFrame:SetScript("OnMouseDown", self.OnMouseDown);
		tFrame:SetScript("OnMouseUp", self.OnMouseUp);
		tFrame:SetScript("OnEnter", self.OnEnter);
		tFrame:SetScript("OnLeave", self.OnLeave);

		tFrame:RegisterForDrag("LeftButton");
		tFrame:SetScript("OnDragStart", self.OnDragStart);
		tFrame:SetScript("OnDragStop", self.OnDragStop);

		if not someModSettings["position"] then
			someModSettings["drag"] = someInitSettings["drag"];
			someModSettings["position"] = someInitSettings["position"];
		end

		tFrame["modSettings"] = someModSettings;
		self:Move();
	end,


	["Move"] = function(self)
		local tXPos, tYPos;
		local tAngle = VuhDoMinimapButton["modSettings"]["position"];
		--[[if (VuhDoMinimapButton["modSettings"]["drag"] == "SQUARE") then
			tXPos = 110 * cos(tAngle);
			tYPos = 110 * sin(tAngle);
			tXPos = math.max(-82, math.min(tXPos, 84));
			tYPos = math.max(-86, math.min(tYPos, 82));
		else]]
			tXPos = 80 * cos(tAngle);
			tYPos = 80 * sin(tAngle);
		--end
		VuhDoMinimapButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 54 - tXPos, tYPos - 54);
	end,

	-- Internal functions: do not call anything below here

	["OnMouseDown"] = function(self)
		_G[self:GetName().."Icon"]:SetTexCoord(0, 1, 0, 1);
	end,


	["OnMouseUp"] = function(self)
		_G[self:GetName().."Icon"]:SetTexCoord(0.05, 0.95, 0.05, 0.95);
	end,


	["OnEnter"] = function(self)
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
		GameTooltip:AddLine("VuhDo");
		GameTooltip:AddLine(VUHDO_I18N_MM_TOOLTIP, 0.8, 0.8, 0.8, 1);
		GameTooltip:Show();
	end,


	["OnLeave"] = function(self)
		GameTooltip:Hide()
	end,


	["OnDragStart"] = function(self)
		self:LockHighlight();
		self:SetScript("OnUpdate", VuhDoMinimap.OnUpdate);
	end,


	["OnDragStop"] = function(self)
		self:SetScript("OnUpdate", nil);
		self:UnlockHighlight();
	end,


	["OnUpdate"] = function(self)
		local tXPos, tYPos = GetCursorPosition();
		local tXMin, tYMin = Minimap:GetLeft(), Minimap:GetBottom();

		tXPos = tXMin - tXPos / Minimap:GetEffectiveScale() + 70;
		tYPos = tYPos / Minimap:GetEffectiveScale() - tYMin - 70;

		self["modSettings"]["position"] = math.deg(math.atan2(tYPos, tXPos));
		VuhDoMinimap:Move();
	end,


	["OnClick"] = function(self, aButtonName)
		if "LeftButton" == aButtonName then
			VUHDO_slashCmd("opt");
		elseif "RightButton" == aButtonName then
			ToggleDropDownMenu(1, nil, VuhDoMinimapDropDown, "VuhDoMinimapButton", 0, -5);
		end
	end

}
