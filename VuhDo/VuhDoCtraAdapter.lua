--local _;


--
function VUHDO_sendCtraMessage(aMessage)
	SendAddonMessage("CTRA", aMessage, VUHDO_getAddOnDistribution());
end



-- return the ordinality of aUnits main tank entry, returns nil if unit is no main tank
local function VUHDO_getMainTankNumber(aUnit)
	for tMTNumber, tMTName in pairs(VUHDO_MAINTANK_NAMES) do
		if tMTName == VUHDO_RAID[aUnit]["name"] then return tMTNumber; end
	end

	return nil;
end



--
function VUHDO_ctraBroadCastMaintanks()
	local tMtNumber;
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		tMtNumber = VUHDO_getMainTankNumber(tUnit);
		VUHDO_sendCtraMessage(tMtNumber	and format("SET %d %s", tMtNumber, tInfo["name"])	or ("R " .. tInfo["name"]));
	end
end



--
function VUHDO_parseCtraMessage(_, aMessage)

	-- Setting main tanks
	if "SET " == strsub(aMessage, 1, 4) then
		local _, _, tNum, tName = strfind(aMessage, "^SET (%d+) (.+)$");
		if tNum and tName then
			for tKey, _ in pairs(VUHDO_MAINTANK_NAMES) do
				if VUHDO_MAINTANK_NAMES[tKey] == tName then
					VUHDO_MAINTANK_NAMES[tKey] = nil;
				end
			end
			VUHDO_MAINTANK_NAMES[tonumber(tNum)] = tName;
			VUHDO_normalRaidReload();
		end
	-- Removing main tanks
	elseif "R " == strsub(aMessage, 1, 2) then
		local _, _, tName = strfind(aMessage, "^R (.+)$");
		if tName then
			for tKey, _ in pairs(VUHDO_MAINTANK_NAMES) do
				if VUHDO_MAINTANK_NAMES[tKey] == tName then
					VUHDO_MAINTANK_NAMES[tKey] = nil;
					break;
				end
			end
			VUHDO_normalRaidReload();
		end
	end
end
