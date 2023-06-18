local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")
local EMB = E:GetModule("EmbedSystem")

local function LoadSkin()
	if not E.private.addOnSkins.Skada then return end

	local db = E.db.addOnSkins.skada

	hooksecurefunc(Skada.displays.bar, "AddDisplayOptions", function(_, _, options)
		options.titleoptions.args.texture = nil
		options.titleoptions.args.bordertexture = nil
		options.titleoptions.args.thickness = nil
		options.titleoptions.args.margin = nil
		options.titleoptions.args.color = nil
		options.windowoptions = nil
	end)

	hooksecurefunc(Skada.displays.bar, "ApplySettings", function(_, win)
		local skada = win.bargroup

		-- Skada Title Frame
		if win.db.enabletitle then
			skada.button:SetBackdrop(nil)

			if not skada.button.backdrop then
				skada.button:CreateBackdrop()
			end

			if skada.button.backdrop then
				skada.button.backdrop:SetFrameLevel(skada.button:GetFrameLevel())
				skada.button.backdrop:SetTemplate(db.titleTemplate, db.titleTemplate == "Default" and db.titleTemplateGloss or false)
				skada.button.backdrop:ClearAllPoints()

				if win.db.reversegrowth then
					skada.button.backdrop:Point("TOPLEFT", skada.button, "TOPLEFT", -E.Border, -2)
					skada.button.backdrop:Point("BOTTOMRIGHT", skada.button, "BOTTOMRIGHT", E.Border, -1)
				else
					skada.button.backdrop:Point("TOPLEFT", skada.button, "TOPLEFT", -E.Border, 1)
					skada.button.backdrop:Point("BOTTOMRIGHT", skada.button, "BOTTOMRIGHT", E.Border, 2)
				end

				if not db.titleBackdrop then
					skada.button.backdrop:Hide()
				else
					skada.button.backdrop:Show()
				end
			end
		end

		-- Skada Frame
		skada:SetBackdrop(nil)
		if not skada.backdrop then
			skada:CreateBackdrop()
		end

		if skada.backdrop then
			skada.backdrop:SetTemplate(db.template, db.template == "Default" and db.templateGloss or false)
			skada.backdrop:ClearAllPoints()

			if win.db.reversegrowth then
				skada.backdrop:Point("TOPLEFT", skada, "TOPLEFT", -E.Border, 0)
				skada.backdrop:Point("BOTTOMRIGHT", skada, "BOTTOMRIGHT", E.Border, -1)
			else
				skada.backdrop:Point("TOPLEFT", skada, "TOPLEFT", -E.Border, E.Border)
				skada.backdrop:Point("BOTTOMRIGHT", skada, "BOTTOMRIGHT", E.Border, 0)
			end

			if not db.backdrop then
				skada.backdrop:Hide()
			else
				skada.backdrop:Show()
			end
		end

		for i, data in ipairs(win.dataset) do
			if data.id then
				local barid = data.id
				local bar = win.bargroup:GetBar(barid)

				if data.class and win.db.classicons and CLASS_ICON_TCOORDS[data.class] then
					bar:SetIconWithCoord("Interface\\WorldStateFrame\\Icons-Classes", CLASS_ICON_TCOORDS[data.class])
				end
			end
		end
	end)


	hooksecurefunc(Skada, "CreateWindow", function()
		if AS:CheckAddOn("Skada") then EMB:EmbedSkada() end
	end)

	hooksecurefunc(Skada, "DeleteWindow", function()
		if AS:CheckAddOn("Skada") then EMB:EmbedSkada() end
	end)
	hooksecurefunc(Skada, "UpdateDisplay", function()
		if AS:CheckAddOn("Skada") and not InCombatLockdown() then EMB:EmbedSkada() end
	end)

	hooksecurefunc(Skada, "SetTooltipPosition", function(self, tt)
		if self.db.profile.tooltippos == "default" then
			if not E:HasMoverBeenMoved("TooltipMover") then
				if ElvUI_ContainerFrame and ElvUI_ContainerFrame:IsShown() then
					tt:Point("BOTTOMRIGHT", ElvUI_ContainerFrame, "TOPRIGHT", 0, 18)
				elseif RightChatPanel:GetAlpha() == 1 and RightChatPanel:IsShown() then
					tt:Point("BOTTOMRIGHT", RightChatPanel, "TOPRIGHT", 0, 18)
				else
					tt:Point("BOTTOMRIGHT", RightChatPanel, "BOTTOMRIGHT", 0, 18)
				end
			else
				local point = E:GetScreenQuadrant(TooltipMover)
				if point == "TOPLEFT" then
					tt:Point("TOPLEFT", TooltipMover)
				elseif point == "TOPRIGHT" then
					tt:Point("TOPRIGHT", TooltipMover)
				elseif point == "BOTTOMLEFT" or point == "LEFT" then
					tt:Point("BOTTOMLEFT", TooltipMover)
				else
					tt:Point("BOTTOMRIGHT", TooltipMover)
				end
			end
	   end
	end)
end

S:AddCallbackForAddon("Skada", "Skada", LoadSkin)