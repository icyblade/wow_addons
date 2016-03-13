local GlobalAddonName, ExRT = ...

-- RELOAD UI short command
SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = ReloadUI


-- Beta enUS & cyrillic fix
if ExRT.alwaysRU and ExRT.locale:find("^en") then
	GameFontHighlightSmall:SetFont("Fonts\\FRIZQT___CYR.TTF",select(2,GameFontHighlightSmall:GetFont()))
	GameFontNormalSmall:SetFont("Fonts\\FRIZQT___CYR.TTF",select(2,GameFontNormalSmall:GetFont()))
	GameFontNormal:SetFont("Fonts\\FRIZQT___CYR.TTF",select(2,GameFontNormalSmall:GetFont()))
	ChatFontNormal:SetFont("Fonts\\FRIZQT___CYR.TTF",select(2,ChatFontNormal:GetFont()))
end

-- SetTexture doesnt work for numbers vaules, use SetColorTexture instead. Check builds when it will be fixed or rewrite addon
---- Quick alpha build fix
if ExRT.is7 and false then
	local type = type
	local TempFrame = CreateFrame'Frame'
	local TempRegion = TempFrame:CreateTexture()
	local metatable = getmetatable(TempRegion).__index
	local old_SetTexture = metatable.SetTexture
	local function fixed_SetTexture(self,arg1,arg2,...)
		if arg2 and type(arg2)=='number' and arg2 <= 1 then	--GetSpellTexture now return spellid (number) with more than 1 arg
			return self:SetColorTexture(arg1,arg2,...)
		else
			return old_SetTexture(self,arg1,arg2,...)
		end
	end
	metatable.SetTexture = fixed_SetTexture
end