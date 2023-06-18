local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local unpack = unpack
local find, format, gsub = string.find, string.format, string.gsub

local function LoadSkin()
	if not E.private.addOnSkins.DBM then return end

	local db = E.db.addOnSkins.dbm
	local function SkinBars(self)
		if not db then return end
		for bar in self:GetBarIterator() do
			if not bar.injected then
				hooksecurefunc(bar, "ApplyStyle", function()
					local frame = bar.frame
					local tbar = _G[frame:GetName().."Bar"]
					local icon1 = _G[frame:GetName().."BarIcon1"]
					local icon2 = _G[frame:GetName().."BarIcon2"]
					local name = _G[frame:GetName().."BarName"]
					local timer = _G[frame:GetName().."BarTimer"]
					local spark = _G[frame:GetName().."BarSpark"]

					spark:Kill()

					if not icon1.overlay then
						icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
						icon1.overlay:SetTemplate()
						icon1.overlay:SetFrameLevel(1)
						icon1.overlay:Point("BOTTOMRIGHT", frame, "BOTTOMLEFT", -(E.Border + E.Spacing), 0)

						local backdroptex = icon1.overlay:CreateTexture(nil, "BORDER")
						backdroptex:SetTexture([=[Interface\Icons\Spell_Nature_WispSplode]=])
						backdroptex:SetInside(icon1.overlay)
						backdroptex:SetTexCoord(unpack(E.TexCoords))
					end

					if not icon2.overlay then
						icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
						icon2.overlay:SetTemplate()
						icon2.overlay:SetFrameLevel(1)
						icon2.overlay:Point("BOTTOMLEFT", frame, "BOTTOMRIGHT", (E.Border + E.Spacing), 0)
						
						local backdroptex = icon2.overlay:CreateTexture(nil, "BORDER")
						backdroptex:SetTexture([=[Interface\Icons\Spell_Nature_WispSplode]=])
						backdroptex:SetInside(icon2.overlay)
						backdroptex:SetTexCoord(unpack(E.TexCoords))
					end

					if icon1.overlay then
						icon1.overlay:Size(db.barHeight)
						icon1:SetTexCoord(unpack(E.TexCoords))
						icon1:ClearAllPoints()
						icon1:SetInside(icon1.overlay)
					end

					if icon2.overlay then
						icon2.overlay:Size(db.barHeight)
						icon2:SetTexCoord(unpack(E.TexCoords))
						icon2:ClearAllPoints()
						icon2:SetInside(icon2.overlay)
					end

					tbar:SetInside(frame)

					frame:Height(db.barHeight)
					frame:SetTemplate()

					name:ClearAllPoints()
					name:Point("LEFT", frame, "LEFT", 4, 0.5)
					name:SetFont(E.LSM:Fetch("font", db.font), db.fontSize, db.fontOutline)

					timer:ClearAllPoints()
					timer:Point("RIGHT", frame, "RIGHT", -4, 0.5)
					timer:SetFont(E.LSM:Fetch("font", db.font), db.fontSize, db.fontOutline)

					if bar.owner.options.IconLeft then icon1.overlay:Show() else icon1.overlay:Hide() end
					if bar.owner.options.IconRight then icon2.overlay:Show() else icon2.overlay:Hide() end

					bar.injected = true
				end)
				bar:ApplyStyle()
			end
		end
	end

	local SkinBoss = function()
		local count = 1
		while (_G[format("DBM_BossHealth_Bar_%d", count)]) do
			local bar = _G[format("DBM_BossHealth_Bar_%d", count)]
			local barname = bar:GetName()
			local progress = _G[barname.."Bar"]
			local name = _G[barname.."BarName"]
			local timer = _G[barname.."BarTimer"]
			local background = _G[barname.."BarBorder"]
			local pointa, anchor, pointb, _, _ = bar:GetPoint()

			if not pointa then return end
			bar:ClearAllPoints()

			bar:Height(db.barHeight)
			bar:SetTemplate("Transparent")

			background:SetNormalTexture(nil)

			progress:SetStatusBarTexture(E.media.normTex)
			progress:ClearAllPoints()
			progress:SetInside(bar)

			name:ClearAllPoints()
			name:Point("LEFT", bar, "LEFT", 4, 0)
			name:SetFont(E.LSM:Fetch("font", db.dbmFont), db.dbmFontSize, db.dbmFontOutline)

			timer:ClearAllPoints()
			timer:Point("RIGHT", bar, "RIGHT", -4, 0)
			timer:SetFont(E.LSM:Fetch("font", db.dbmFont), db.dbmFontSize, db.dbmFontOutline)

			if DBM.Options.HealthFrameGrowUp then
				bar:Point(pointa, anchor, pointb, 0, count == 1 and 8 or 4)
			else
				bar:Point(pointa, anchor, pointb, 0, -(count == 1 and 8 or 4))
			end
			count = count + 1
		end
	end

	local function SkinRange()
		DBMRangeCheck:SetTemplate("Transparent")
	end

	hooksecurefunc(DBT, "CreateBar", SkinBars)
	hooksecurefunc(DBM.BossHealth, "Show", SkinBoss)
	hooksecurefunc(DBM.BossHealth, "AddBoss", SkinBoss)
	hooksecurefunc(DBM.BossHealth, "UpdateSettings", SkinBoss)
	hooksecurefunc(DBM.RangeCheck, "Show", SkinRange)

	S:RawHook("RaidNotice_AddMessage", function(noticeFrame, textString, colorInfo)
		if find(textString, " |T") then
			textString = gsub(textString, "(:12:12)", ":18:18:0:0:64:64:5:59:5:59")
		end

		return S.hooks.RaidNotice_AddMessage(noticeFrame, textString, colorInfo)
	end, true)
end

S:AddCallbackForAddon("DBM-Core", "DBM-Core", LoadSkin)

local function LoadSkin2()
	if not E.private.addOnSkins.DBM then return end

	DBM_GUI_OptionsFrame:HookScript("OnShow", function(self)
		self:StripTextures()
		self:SetTemplate("Transparent")
		DBM_GUI_OptionsFrameBossMods:StripTextures()
		DBM_GUI_OptionsFrameBossMods:SetTemplate("Transparent")
		DBM_GUI_OptionsFrameDBMOptions:StripTextures()
		DBM_GUI_OptionsFrameDBMOptions:SetTemplate("Transparent")
		DBM_GUI_OptionsFramePanelContainer:SetTemplate("Transparent")
		DBM_GUI_Option_2:StripTextures()
	end)

	S:HandleButton(DBM_GUI_OptionsFrameOkay)
	S:HandleButton(DBM_GUI_OptionsFrameWebsiteButton)
	S:HandleScrollBar(DBM_GUI_OptionsFramePanelContainerFOVScrollBar)

	S:HandleTab(DBM_GUI_OptionsFrameTab1)
	S:HandleTab(DBM_GUI_OptionsFrameTab2)
end

S:AddCallbackForAddon("DBM-GUI", "DBM-GUI", LoadSkin2)