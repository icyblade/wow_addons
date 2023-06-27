local E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule("UnitFrames")
local LSM = E.Libs.LSM

local pairs = pairs

function UF:Configure_CustomTexts(frame)
	local frameDB = frame.db

	--Make sure CustomTexts are hidden if they don't exist in current profile
	if frame.customTexts then
		for name, object in pairs(frame.customTexts) do
			if not frameDB.customTexts or not frameDB.customTexts[name] then
				object:Hide()
			end
		end
	end

	if frameDB.customTexts then
		local font = LSM:Fetch("font", UF.db.font)
		for name in pairs(frameDB.customTexts) do
			local object = frame.customTexts[name]
			if not object then
				object = frame:CreateFontString(nil, "OVERLAY")
			end

			local db, tagFont = frameDB.customTexts[name]
			if db.font then
				tagFont = LSM:Fetch("font", db.font)
			end

			local attachPoint = self:GetObjectAnchorPoint(frame, db.attachTextTo)
			object:FontTemplate(tagFont or font, db.size or UF.db.fontSize, db.fontOutline or UF.db.fontOutline)
			object:SetJustifyH(db.justifyH or "CENTER")
			object:ClearAllPoints()
			object:Point(db.justifyH or "CENTER", attachPoint, db.justifyH or "CENTER", db.xOffset, db.yOffset)

			if db.attachTextTo == "Power" and frame.Power then
				object:SetParent(frame.Power.RaisedElementParent)
			elseif db.attachTextTo == "EclipseBar" and frame.EclipseBar then
				object:SetParent(frame.EclipseBar.RaisedElementParent)
			elseif db.attachTextTo == "AdditionalPower" and frame.AdditionalPower then
				object:SetParent(frame.AdditionalPower.RaisedElementParent)
			else
				object:SetParent(frame.RaisedElementParent)
			end

			--This takes care of custom texts that were added before the enable option was added.
			if db.enable == nil then
				db.enable = true
			end

			if db.enable then
				frame:Tag(object, db.text_format or "")
				object:Show()
			else
				frame:Untag(object)
				object:Hide()
			end

			if not frame.customTexts[name] then
				frame.customTexts[name] = object
			end
		end
	end
end