local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.Overachiever then return end

	for i = 4, 6 do
		S:HandleTab(_G["AchievementFrameTab"..i])
	end

	for _, childFrame in pairs({_G["Overachiever_LeftFrame"]:GetChildren()}) do
		for _, component in pairs({childFrame:GetChildren()}) do
			local type = component:GetObjectType()
			if type == "Button" then
				S:HandleButton(component)
			elseif type == "EditBox" then
				S:HandleEditBox(component)
			elseif type == "CheckButton" then
				S:HandleCheckBox(component)
			elseif type == "Frame" and strfind(component:GetName(), "Drop") then
				S:HandleDropDownBox(component, 200)
			end
		end
	end

	for _, name in pairs({"Overachiever_SearchFrame", "Overachiever_SuggestionsFrame", "Overachiever_WatchFrame"}) do
		local container = _G[name]
		local frameBorder, scrollFrame = container:GetChildren()
		local scrollBar = _G[scrollFrame:GetName().."ScrollBar"]

		container:StripTextures()
		frameBorder:StripTextures()

		scrollFrame:CreateBackdrop()
		scrollFrame.backdrop:Point("TOPLEFT", 0, 2)
		scrollFrame.backdrop:Point("BOTTOMRIGHT", -3, -3)

		S:HandleScrollBar(scrollBar)
	end
end

S:AddCallbackForAddon("Overachiever_Tabs", "Overachiever", LoadSkin)