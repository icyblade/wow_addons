local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs

local function LoadSkin()
	if not E.private.addOnSkins.Overachiever then return end

	for i = 4, 6 do
		S:HandleTab(_G["AchievementFrameTab"..i])
	end

	local leftFrame = _G["Overachiever_LeftFrame"]
	for _, childFrame in pairs({leftFrame:GetChildren()}) do
		for _, component in pairs({childFrame:GetChildren()}) do
			local buttonType = component:GetObjectType()

			if buttonType == "Button" then
				S:HandleButton(component)
			elseif buttonType == "EditBox" then
				S:HandleEditBox(component)
			elseif buttonType == "CheckButton" then
				S:HandleCheckBox(component)
			elseif buttonType == "Frame" and strfind(component:GetName(), "Drop") then
				S:HandleDropDownBox(component)
			end
		end
	end

	local containers = {
		"Overachiever_SearchFrame",
		"Overachiever_SuggestionsFrame",
		"Overachiever_WatchFrame"
	}

	for _, name in pairs(containers) do
		local container = _G[name]
		local frameBorder, scrollFrame = container:GetChildren()
		local scrollBar = _G[scrollFrame:GetName().."ScrollBar"]

		container:StripTextures()
		frameBorder:StripTextures()

		scrollFrame:CreateBackdrop("Default")
		scrollFrame.backdrop:Point("TOPLEFT", 0, 2)
		scrollFrame.backdrop:Point("BOTTOMRIGHT", -3, -3)

		S:HandleScrollBar(scrollBar)
	end
end

S:AddCallbackForAddon("Overachiever_Tabs", "Overachiever", LoadSkin)