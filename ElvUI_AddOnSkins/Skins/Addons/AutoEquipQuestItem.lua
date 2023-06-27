local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function LoadSkin()
	if not E.private.addOnSkins.AutoEquipQuestItem then return end

	for i = 1, QuestFrameRewardPanel:GetNumChildren() do
		local Region = select(i, QuestFrameRewardPanel:GetChildren())
		if Region:IsObjectType('Button') and Region:GetName() == nil then
			Region:StripTextures()
			S:HandleButton(Region)
		end
	end
end

S:AddCallbackForAddon("AutoEquipQuestItem", "AutoEquipQuestItem", LoadSkin)