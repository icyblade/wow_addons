

--
local function VUHDO_hideAllPanels()
	VuhDoNewOptionsSpellMouse:Hide();
	VuhDoNewOptionsSpellKeysLocal:Hide();
	VuhDoNewOptionsSpellKeys:Hide();
	VuhDoNewOptionsSpellFire:Hide();
	VuhDoNewOptionsSpellHostile:Hide();
	VuhDoNewOptionsSpellSmartCast:Hide();
	VuhDoNewOptionsSpellKeysLocalMacroEdit:Hide();
	collectgarbage('collect');
end



--
function VUHDO_newOptionsSpellMouseClicked(self)
	VUHDO_hideAllPanels();
	VuhDoNewOptionsSpellMouse:Show();
end


--
function VUHDO_newOptionsSpellKeysClicked(self)
	VUHDO_hideAllPanels();
	VuhDoNewOptionsSpellKeys:Show();
end



--
function VUHDO_newOptionsSpellFireClicked(self)
	VUHDO_hideAllPanels();
	VuhDoNewOptionsSpellFire:Show();
end



--
function VUHDO_newOptionsSpellHostileClicked(self)
	VUHDO_hideAllPanels();
	VuhDoNewOptionsSpellHostile:Show();
end



--
function VUHDO_newOptionsSpellSmartCastClicked(self)
	VUHDO_hideAllPanels();
	VuhDoNewOptionsSpellSmartCast:Show();
end



--
function VUHDO_newOptionsSpellLocalKeysClicked(self)
	VUHDO_hideAllPanels();
	VuhDoNewOptionsSpellKeysLocal:Show();
end
