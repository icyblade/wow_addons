SendAddonMessage = C_ChatInfo.SendAddonMessage
RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix

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
