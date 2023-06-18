


--
function VUHDO_importBlizzClassColors(aButton)
	VuhDoYesNoFrameText:SetText("Overwrite class colors with\ndefault Blizz class colors?");
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				for tClassId, tVuhDoColor in pairs(VUHDO_USER_CLASS_COLORS) do
					local tClassName = VUHDO_ID_CLASSES[tClassId];

					if (RAID_CLASS_COLORS[tClassName] ~= nil) then
						tVuhDoColor["R"] = RAID_CLASS_COLORS[tClassName]["r"] or 0;
						tVuhDoColor["G"] = RAID_CLASS_COLORS[tClassName]["g"] or 0;
						tVuhDoColor["B"] = RAID_CLASS_COLORS[tClassName]["b"] or 0;

						tVuhDoColor["TR"] = RAID_CLASS_COLORS[tClassName]["r"] or 0;
						tVuhDoColor["TG"] = RAID_CLASS_COLORS[tClassName]["g"] or 0;
						tVuhDoColor["TB"] = RAID_CLASS_COLORS[tClassName]["b"] or 0;

						tVuhDoColor["O"] = 1;
						tVuhDoColor["TO"] = 1;
					end
				end
			end
		end
	);
	VuhDoYesNoFrame:Show();

end