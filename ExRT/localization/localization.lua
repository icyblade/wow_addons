local GlobalAddonName, ExRT = ...

local localization = ExRT.L

ExRT.L = setmetatable({}, {__index=function (t, k)
	return localization[k] or k
end})

--[[
deDE
enGB
enUS
esES
esMX
frFR
itIT
koKR
ptBR
ruRU
zhCN
zhTW
]]