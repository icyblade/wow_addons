SendAddonMessage = C_ChatInfo.SendAddonMessage
RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix

-- patch LoadOnDemand
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, ...)
    DEFAULT_CHAT_FRAME:AddMessage("Trying to patch AddOns")
	for index = 1, GetNumAddOns() do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(index)
		if (loadable) then
			DEFAULT_CHAT_FRAME:AddMessage("Patching "..title)
			LoadAddOn(index)
		end
	end
end)


-- patch /script, /run, /dump
RunScript=function(a) loadstring(a)() end
SlashCmdList["SCRIPT"] = function(msg)
    loadstring(msg)()
end
SlashCmdList["RUN"] = function(msg)
    loadstring(msg)()
end
SlashCmdList["DUMP"] = function(msg)
    loadstring("DevTools_Dump({"..msg.."})")()
end
