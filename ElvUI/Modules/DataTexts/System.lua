local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local select, collectgarbage = select, collectgarbage
local sort, wipe = table.sort, wipe
local floor = math.floor
local format, join = string.format, string.join

local GetAddOnCPUUsage = GetAddOnCPUUsage
local GetAddOnInfo = GetAddOnInfo
local GetAddOnMemoryUsage = GetAddOnMemoryUsage
local GetAvailableBandwidth = GetAvailableBandwidth
local SetCVar = SetCVar
local GetCVar = GetCVar
local GetCVarBool = GetCVarBool
local GetDownloadedPercentage = GetDownloadedPercentage
local GetFramerate = GetFramerate
local GetNetIpTypes = GetNetIpTypes
local GetNetStats = GetNetStats
local GetNumAddOns = GetNumAddOns
local IsAddOnLoaded = IsAddOnLoaded
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local ResetCPUUsage = ResetCPUUsage
local UpdateAddOnCPUUsage = UpdateAddOnCPUUsage
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
local UNKNOWN = UNKNOWN

-- initial delay for update (let the ui load)
local int, int2 = 6, 5
local statusColors = {
	"|cff0CD809",
	"|cffE8DA0F",
	"|cffFF9000",
	"|cffD80909"
}

local enteredFrame = false
local bandwidthString = "%.2f Mbps"
local percentageString = "%.2f%%"
local homeLatencyString = "%d ms"
local kiloByteString = "%d kb"
local megaByteString = "%.2f mb"

local function formatMem(memory)
	local mult = 10 ^ 1
	if memory > 999 then
		local mem = ((memory / 1024) * mult) / mult
		return format(megaByteString, mem)
	else
		local mem = (memory * mult) / mult
		return format(kiloByteString, mem)
	end
end

local function sortByMemoryOrCPU(a, b)
	if a and b then
		return (a[3] == b[3] and a[2] < b[2]) or a[3] > b[3]
	end
end

local memoryTable = {}
local cpuTable = {}
local function RebuildAddonList()
	local addOnCount = GetNumAddOns()
	if (addOnCount == #memoryTable) then return end

	-- Number of loaded addons changed, create new memoryTable for all addons
	wipe(memoryTable)
	wipe(cpuTable)

	for i = 1, addOnCount do
		memoryTable[i] = {i, select(2, GetAddOnInfo(i)), 0}
		cpuTable[i] = {i, select(2, GetAddOnInfo(i)), 0}
	end
end

local function UpdateMemory()
	-- Update the memory usages of the addons
	UpdateAddOnMemoryUsage()
	-- Load memory usage in table
	local totalMemory = 0
	for i = 1, #memoryTable do
		memoryTable[i][3] = GetAddOnMemoryUsage(memoryTable[i][1])
		totalMemory = totalMemory + memoryTable[i][3]
	end

	-- Sort the table to put the largest addon on top
	sort(memoryTable, sortByMemoryOrCPU)

	return totalMemory
end

local function UpdateCPU()
	--Update the CPU usages of the addons
	UpdateAddOnCPUUsage()
	-- Load cpu usage in table
	local totalCPU = 0
	for i = 1, #cpuTable do
		local addonCPU = GetAddOnCPUUsage(cpuTable[i][1])
		cpuTable[i][3] = addonCPU
		totalCPU = totalCPU + addonCPU
	end

	-- Sort the table to put the largest addon on top
	sort(cpuTable, sortByMemoryOrCPU)

	return totalCPU
end

local function ToggleGameMenuFrame()
	if GameMenuFrame:IsShown() then
		PlaySound("igMainMenuQuit")
		HideUIPanel(GameMenuFrame)
	else
		PlaySound("igMainMenuOpen")
		ShowUIPanel(GameMenuFrame)
	end
end

local function OnClick()
	if IsShiftKeyDown() and IsControlKeyDown() and not InCombatLockdown() then
		SetCVar("scriptProfile", GetCVarBool("scriptProfile") and 0 or 1)
		ReloadUI()
	elseif IsShiftKeyDown() then
		collectgarbage("collect")
		ResetCPUUsage()
	else
		ToggleGameMenuFrame()
	end
end

local ipTypes = {"IPv4", "IPv6"}
local function OnEnter(self)
	enteredFrame = true
	local cpuProfiling = GetCVar("scriptProfile") == "1"
	DT:SetupTooltip(self)

	local totalMemory = UpdateMemory()
	local bandwidth = GetAvailableBandwidth()
	local _, _, homePing, worldPing = GetNetStats()

	DT.tooltip:AddDoubleLine(L["Home Latency:"], format(homeLatencyString, homePing), 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
	DT.tooltip:AddDoubleLine(L["World Latency:"], format(homeLatencyString, worldPing), 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)

	if GetCVarBool("useIPv6") then
		local ipTypeHome, ipTypeWorld = GetNetIpTypes()
		DT.tooltip:AddDoubleLine(L["Home Protocol:"], ipTypes[ipTypeHome or 0] or UNKNOWN, 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
		DT.tooltip:AddDoubleLine(L["World Protocol:"], ipTypes[ipTypeWorld or 0] or UNKNOWN, 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
	end

	if bandwidth ~= 0 then
		DT.tooltip:AddDoubleLine(L["Bandwidth"] , format(bandwidthString, bandwidth), 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
		DT.tooltip:AddDoubleLine(L["Download"] , format(percentageString, GetDownloadedPercentage() * 100), 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
		DT.tooltip:AddLine(" ")
	end

	local totalCPU
	DT.tooltip:AddDoubleLine(L["Total Memory:"], formatMem(totalMemory), 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
	if cpuProfiling then
		totalCPU = UpdateCPU()
		DT.tooltip:AddDoubleLine(L["Total CPU:"], format(homeLatencyString, totalCPU), 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
	end

	DT.tooltip:AddLine(" ")
	if IsShiftKeyDown() or not cpuProfiling then
		for i = 1, #memoryTable do
			local ele = memoryTable[i]
			if ele and IsAddOnLoaded(ele[1]) then
				local red = ele[3] / totalMemory
				local green = 1 - red
				DT.tooltip:AddDoubleLine(ele[2], formatMem(ele[3]), 1, 1, 1, red, green + .5, 0)
			end
		end

		DT.tooltip:AddLine(" ")
	else
		for i = 1, #cpuTable do
			local ele = cpuTable[i]
			if ele and IsAddOnLoaded(ele[1]) then
				local red = ele[3] / totalCPU
				local green = 1 - red
				DT.tooltip:AddDoubleLine(ele[2], format(homeLatencyString, ele[3]), 1, 1, 1, red, green + .5, 0)
			end
		end

		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(join("", "|cffaaaaaa", L["(Hold Shift) Memory Usage"], "|r"))
	end

	DT.tooltip:AddLine(join("", "|cffaaaaaa", L["(Shift Click) Collect Garbage"], "|r"))
	DT.tooltip:AddLine(join("", "|cffaaaaaa", L["(Ctrl & Shift Click) Toggle CPU Profiling"], "|r"))

	DT.tooltip:Show()
end

local function OnLeave()
	enteredFrame = false
	DT.tooltip:Hide()
end

local function OnUpdate(self, t)
	int = int - t
	int2 = int2 - t

	if int < 0 then
		RebuildAddonList()
		int = 10
	end

	if int2 < 0 then
		local framerate = floor(GetFramerate())
		local latency = select(3, GetNetStats())

		self.text:SetFormattedText("FPS: %s%d|r MS: %s%d|r",
			statusColors[framerate >= 30 and 1 or (framerate >= 20 and framerate < 30) and 2 or (framerate >= 10 and framerate < 20) and 3 or 4],
			framerate,
			statusColors[latency < 150 and 1 or (latency >= 150 and latency < 300) and 2 or (latency >= 300 and latency < 500) and 3 or 4],
			latency)
		int2 = 1
		if enteredFrame then
			OnEnter(self)
		end
	end
end

DT:RegisterDatatext("System", nil, nil, OnUpdate, OnClick, OnEnter, OnLeave, L["System"])