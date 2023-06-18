

--
function VUHDO_newOptionsSpellEditBoxSpellId(anEditBox)
	if (VUHDO_isSpellKnown(anEditBox:GetText())) then
		anEditBox:SetTextColor(1, 1, 1, 1);
	else
		anEditBox:SetTextColor(0.8, 0.8, 1, 1);
	end
end

