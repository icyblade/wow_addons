local E, L, V, P, G = unpack(select(2, ...))
local B = E:GetModule("Blizzard")

local _G = _G

function B:WorldStateAlwaysUpFrame_Update()
	local captureBar
	for i = 1, NUM_EXTENDED_UI_FRAMES do
		captureBar = _G["WorldStateCaptureBar"..i]

		if captureBar and captureBar:IsShown() then
			captureBar:ClearAllPoints()
			captureBar:Point("TOP", PvPHolder, "BOTTOM", 0, -75)
		end
	end

	for i = 1, NUM_ALWAYS_UP_UI_FRAMES do
		local frame = _G["AlwaysUpFrame"..i]

		if frame then
			local text = _G["AlwaysUpFrame"..i.."Text"]
			local icon = _G["AlwaysUpFrame"..i.."Icon"]
			local dynamic = _G["AlwaysUpFrame"..i.."DynamicIconButton"]

			if i == 1 then
				frame:ClearAllPoints()
				frame:Point("CENTER", PvPHolder, "CENTER", 0, 5)
			end

			text:ClearAllPoints()
			text:Point("CENTER", frame, "CENTER", 0, 0)

			icon:ClearAllPoints()
			icon:Point("CENTER", text, "LEFT", -10, -9)

			dynamic:ClearAllPoints()
			dynamic:Point("LEFT", text, "RIGHT", 5, 0)
		end
	end
end

function B:PositionCaptureBar()
	local PvPHolder = CreateFrame("Frame", "PvPHolder", E.UIParent)
	PvPHolder:Size(30, 70)
	PvPHolder:Point("TOP", E.UIParent, "TOP", 0, -4)

	E:CreateMover(PvPHolder, "PvPMover", L["PvP"], nil, nil, nil, "ALL")
	PvPHolder:SetAllPoints(PvPMover)

	self:SecureHook("WorldStateAlwaysUpFrame_Update")
end