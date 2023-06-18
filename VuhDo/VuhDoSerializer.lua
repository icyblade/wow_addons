local pairs = pairs;
local type = type;
local tostring = tostring;
local tonumber = tonumber;
local strsub = strsub;
local strfind = strfind;
local strbyte = strbyte;
local floor = floor;
local format = format;
local twipe = table.wipe;
local tinsert = tinsert;
local tsort = table.sort;
local strchar = strchar;
local bor = bit.bor;
local band = bit.band;
local tconcat = table.concat;
local lshift = bit.lshift;
local rshift = bit.rshift;
local tremove = tremove;
local next = next;

-- Sabc=S5+abcde
-- Sabc=N3+1.3
-- Sabc=0
-- Sabc=1
-- Sabc=T1234+...

-- Nabc=S1+x


local VUHDO_KEY_TO_ABBREV = {
	["isFullDuration"] = "*a",
	["useBackground"] = "*b",
	["color"] = "*c",
	["isStacks"] = "*d",
	["isIcon"] = "*e",
	["isColor"] = "*f",
	["bright"] = "*g",
	["others"] = "*h",
	["icon"] = "*i",
	["timer"] = "*j",
	["animate"] = "*k",
	["isClock"] = "*l",
	["mine"] = "*m",
	["name"] = "*n",
	["useOpacity"] = "*o",
	["countdownMode"] = "*p",
	["radio"] = "*r",
	["isManuallySet"] = "*s",
	["useText"] = "*t",
	["custom"] = "*u",
};


local VUHDO_ABBREV_TO_KEY = {
	["*a"] = "isFullDuration",
	["*b"] = "useBackground",
	["*c"] = "color",
	["*d"] = "isStacks",
	["*e"] = "isIcon",
	["*f"] = "isColor",
	["*g"] = "bright",
	["*h"] = "others",
	["*i"] = "icon",
	["*j"] = "timer",
	["*k"] = "animate",
	["*l"] = "isClock",
	["*m"] = "mine",
	["*n"] = "name",
	["*o"] = "useOpacity",
	["*p"] = "countdownMode",
	["*r"] = "radio",
	["*s"] = "isManuallySet",
	["*t"] = "useText",
	["*u"] = "custom",
};



--
local tStrValue; -- Mustn't be reused after recursion finished
function VUHDO_serializeTable(aTable)
	local tString = "";

	for tKey, tValue in pairs(aTable) do
		tString = "number" == type(tKey)
			and format("%sN%d=", tString, tKey) or format("%sS%s=", tString, VUHDO_KEY_TO_ABBREV[tKey] or tKey);

		if "string" == type(tValue) then
			tString = format("%sS%d+%s", tString, #tValue, tValue);
		elseif "number" == type(tValue) then
			tStrValue = tostring(floor(tValue * 10000) * 0.0001);
			tString = format("%sN%d+%s", tString, #tStrValue, tStrValue);
		elseif "boolean" == type(tValue) then
			tString = tString .. (tValue and "1" or "0");
		elseif "table" == type(tValue) then
			local tNewString = VUHDO_serializeTable(tValue);
			tString = format("%sT%d+%s", tString, #tNewString, tNewString);
		end
	end

	return tString;
end



--
local tEndPos;
local tNumBytes;
local tValue;
local function VUHDO_getValueByLength(aString, aGleichPos)
	tEndPos = strfind(aString, "+", aGleichPos + 2, true);
	if not tEndPos then return nil, nil; end

	tNumBytes = tonumber(strsub(aString, aGleichPos + 2, tEndPos - 1));
	tValue = strsub(aString, tEndPos + 1, tEndPos + tNumBytes);
	return tEndPos + tNumBytes + 1, tValue;
end



--
function VUHDO_deserializeTable(aString)
	local tTable = { };
	local tIndex = 1;
	local tValueType;
	local tGleichPos;
	local tKey, tValue;

	while tIndex <= #aString do
		tGleichPos = strfind(aString, "=", tIndex + 1, true);

		if tGleichPos then
			tKey = strsub(aString, tIndex + 1, tGleichPos - 1);

			if 78 == strbyte(aString, tIndex) then -- N
				tKey = tonumber(tKey);
			else -- S
				tKey = VUHDO_ABBREV_TO_KEY[tKey] or tKey;
			end

			tValueType = strbyte(aString, tGleichPos + 1);
			if 83 == tValueType then -- S
				tIndex, tValue = VUHDO_getValueByLength(aString, tGleichPos);
			elseif 78 == tValueType then -- N
				tIndex, tValue = VUHDO_getValueByLength(aString, tGleichPos);
				tValue = tonumber(tValue);
			elseif 48 == tValueType then -- 0
				tValue = false;
				tIndex = tGleichPos + 2;
			elseif 49 == tValueType then -- 1
				tValue = true;
				tIndex = tGleichPos + 2;
			elseif 84 == tValueType then -- T
				tIndex, tValue = VUHDO_getValueByLength(aString, tGleichPos);
				tValue = VUHDO_deserializeTable(tValue);
			else
				return tTable;
			end
		else
			return tTable;
		end

		if tKey and tValue ~= nil then
			tTable[tKey] = tValue;
		end
	end

	return tTable;
end
