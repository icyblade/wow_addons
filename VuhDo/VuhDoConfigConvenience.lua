


--
function VUHDO_isShowGcd()
	return VUHDO_CONFIG["IS_SHOW_GCD"];
end



--
function VUHDO_isShowDirectionArrow()
	return VUHDO_CONFIG["DIRECTION"]["enable"];
end



--
function VUHDO_getPlayerClassBuffs()
	return VUHDO_CLASS_BUFFS[VUHDO_PLAYER_CLASS];
end