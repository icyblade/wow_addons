local lbf

function TotemTimers.SkinCallback(arg, Group, SkinID, Gloss, Backdrop, Colors, Fonts)
	local skins = lbf:GetSkins()
	if skins[SkinID].Icon then
        TotemTimers.ApplySkin(skins[SkinID])
	end
	if SkinID == "Blizzard" then
		for k,v in pairs(XiTimers.timers) do
			v.button:SetNormalTexture(nil)
            v.Animation.button:SetNormalTexture(nil)
		end
	end
end

local metatable = nil

function TotemTimers_InitButtonFacade()
	if not LibStub then return end
	lbf = LibStub("Masque", true)
	if lbf then
		local group = lbf:Group("TotemTimers")
		for k,v in pairs(XiTimers.timers) do
            group:AddButton(v.button)
            group:AddButton(v.Animation.button)
        end 
        for i = 1,#TTActionBars.bars do
            for j = 1,#TTActionBars.bars[i].buttons do
                group:AddButton(TTActionBars.bars[i].buttons[j])
            end
        end
        group:AddButton(TotemTimers_MultiSpell)
        
        if tonumber(strsub(GetAddOnMetadata("Masque", "Version"),1,3)) >= 4.3 then
            lbf:Register("TotemTimers", TotemTimers.SkinCallback,nil)
        else        
            InterfaceOptionsFrame:HookScript("OnHide", function() TotemTimers.ApplySkin() end)
            TotemTimers.ApplySkin()
        end
        group:ReSkin()
	end
end

