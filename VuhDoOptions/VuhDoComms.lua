VUHDO_COMMS_VERSION = 1;

local sReceiveMode = 1;
local sLastCmd = nil;

local sMaxPacketSize = 254;
local sPacketSendInterval = 0.1;
local sTrivialTimeout = 3;
local sUserDialogTimeout = 15;
local sMaxReceiveSize = 100000;

local sFieldSeparator = "!";
local sCommandSeparator = "§";

local sPrefixCommand = "cmd";
local sPrefixRequest = "rqu";
local sPrefixReply   = "rpy";

local sCmdAbortComms = sPrefixCommand .. "ABORT";

local sCmdVersionRequest = sPrefixRequest .. "VERSION";
local sCmdVersionReply   = sPrefixReply   .. "VERSION"; -- CommsVersion, VuhDo version, locale

local sCmdUserYesNoRequest = sPrefixRequest .. "YESNO";
local sCmdUserYesNoReply   = sPrefixReply   .. "YESNO";

sCmdProfileDataChunk = sPrefixCommand .. "P_DAT";
sCmdProfileDataEnd   = sPrefixCommand .. "P_END";

sCmdKeyLayoutDataChunk = sPrefixCommand .. "K_DAT";
sCmdKeyLayoutDataEnd   = sPrefixCommand .. "K_END";

local sRequestsInProgress = { --[[ [unitName][replyType] = { endTime, aResumable } ]] };
local sRepliesReceived = { --[[ [unitName][replyType] = replyString ]] };
local sUserData = { --[[ [unitName][requestType] = userData ]] };
local sBlockedSenders = { --[[ [unitName] = true ]] };

local sBusyUnitName = nil;
local sNumChunks = 0;

local sCurrentChunkTag = nil;
local sCurrentEndTag = nil;
local sCurrentQuestionText = nil;

--
function VUHDO_commsSetReceiveModeEnabled(aFlag)
	sReceiveMode = aFlag and -1 or 1;
end



--
local function VUHDO_setUserData(aUnitName, aTag, someData)
	if (sUserData[aUnitName] == nil) then
		sUserData[aUnitName] = {};
	end

	sUserData[aUnitName][aTag] = someData;
end



--
local function VUHDO_getUserData(aUnitName, aTag)
	return (sUserData[aUnitName] or {})[aTag];
end



--
local function VUHDO_setRequestInfo(aUnitName, aReplyType, aTimeout, aResumable)
	if (sRequestsInProgress[aUnitName] == nil) then
		sRequestsInProgress[aUnitName] = {};
	end

	if ((aTimeout or 0) > 0) then
		sRequestsInProgress[aUnitName][aReplyType] = { GetTime() + aTimeout, aResumable };
	else
		sRequestsInProgress[aUnitName][aReplyType] = nil;
	end
end



--
local function VUHDO_setReplyData(aUnitName, aReplyType, someData)
	if (sRepliesReceived[aUnitName] == nil) then
		sRepliesReceived[aUnitName] = { };
	end

	sRepliesReceived[aUnitName][aReplyType] = someData;
end



--
local function VUHDO_getReplyData(aUnitName, aReplyType)
	if (sRepliesReceived[aUnitName] == nil) then
		return nil;
	end

	return sRepliesReceived[aUnitName][aReplyType];
end



--
function VUHDO_removeCommsData(aUnitName)
	if (aUnitName ~= nil) then
		sUserData[aUnitName] = nil;
		sRequestsInProgress[aUnitName] = nil;
		sRepliesReceived[aUnitName] = nil;
		if (sBusyUnitName == aUnitName) then
			sBusyUnitName = nil;
			sNumChunks = 0;
		end
	else
		table.wipe(sUserData);
		table.wipe(sRequestsInProgress);
		table.wipe(sRepliesReceived);
		sBusyUnitName = nil;
		sNumChunks = 0;
	end
end



--
local function VUHDO_getFieldsFromReply(aUnitName, aReplyType)
	local tUnitReplies = sRepliesReceived[aUnitName];

	if (tUnitReplies == nil) then
		return nil;
	end

	local tReply = tUnitReplies[aReplyType];
	if (tReply == nil) then
		return nil;
	end

	return strsplit(sFieldSeparator, tReply);
end



--
local function VUHDO_sendMessage(aUnitName, aMessage, aCallbackFn, aCallbackArg)
	ChatThrottleLib:SendAddonMessage("BULK", VUHDO_COMMS_PREFIX, aMessage, "WHISPER", aUnitName, nil, aCallbackFn, aCallbackArg);
end



--
local function VUHDO_sendDirectMessage(aUnitName, aMessage)
	SendAddonMessage(VUHDO_COMMS_PREFIX, aMessage, "WHISPER", aUnitName);
end



--
function VUHDO_sendAbortMessage(aUnitName)
	VUHDO_sendDirectMessage(aUnitName, sCmdAbortComms);
end



--
local function VUHDO_trivialRequest(aUnitName, aRequest, aReplyType, aTimeout, aResumable)
	VUHDO_sendMessage(aUnitName, aRequest, nil);
	VUHDO_setRequestInfo(aUnitName, aReplyType, aTimeout, aResumable);
end



--
local function VUHDO_buildMessage(aCommand, ...)
	local tData = aCommand .. sCommandSeparator;
	local tCnt;

	for tCnt = 1, select('#', ...) do
		tData = tData .. select(tCnt, ...) .. (tCnt < select('#', ...) and sFieldSeparator or "");
	end

	return tData;
end



--
local function VUHDO_allDataSentCallback()
	VUHDO_Msg("Done. You may now send again to this player.");
	VuhDoLnfShareDialog:Hide();
end



--
local function VUHDO_dataChunkCallback(aProgress)
	VuhDoLnfShareDialogTransmitPaneProgressBar:SetProgress(aProgress[1], aProgress[2]);
end



--
local function VUHDO_sendPacketedMessage(aUnitName, someData, aDataCommand, anEndCommand)
	local tIndex = 0;
	local tChunk;
	local tLength;
	local tPackets;
	local tCurPacket = 0;
	local tMaxLength = sMaxPacketSize - strlen(VUHDO_COMMS_PREFIX) - strlen(aDataCommand) - strlen(sCommandSeparator);

	tPackets = floor(strlen(someData) / (tMaxLength + 1));
	VUHDO_Msg("Sending " .. tPackets .. " packets to " .. aUnitName .. ".");

	while (tIndex < strlen(someData)) do
		if (tIndex + tMaxLength < strlen(someData)) then
			tLength = tMaxLength;
		else
			tLength = strlen(someData) - tIndex;
		end

		tChunk = strsub(someData, tIndex + 1, tIndex + tLength);
		VUHDO_sendMessage(aUnitName, VUHDO_buildMessage(aDataCommand, tChunk), VUHDO_dataChunkCallback, { tCurPacket, tPackets });
		tIndex = tIndex + tLength;
		tCurPacket = tCurPacket + 1;
	end

	VUHDO_sendMessage(aUnitName, anEndCommand, VUHDO_allDataSentCallback);
end



--
local function VUHDO_requestVuhdoVersion(aUnitName, aResumable)
	VUHDO_trivialRequest(aUnitName, sCmdVersionRequest, sCmdVersionReply, sTrivialTimeout, aResumable);
end



--
local function VUHDO_isVersionCompatible(aUnitName)
	local tIsCompatible = true;
	local tCommsVersion, tVuhDoVersion, tLocale = VUHDO_getFieldsFromReply(aUnitName, sCmdVersionReply);

	if (tCommsVersion == nil or tVuhDoVersion == nil or tLocale == nil) then
		VUHDO_Msg("Aborting: Version check failed.", 1, 0.4, 0.4);
		return false;
	end

	if (VUHDO_COMMS_VERSION < tonumber(tCommsVersion)) then
		VUHDO_Msg("Aborting: VuhDo comms version too low. Please update VuhDo.", 1, 0.4, 0.4);
		tIsCompatible = false;
	end

	if (tonumber(VUHDO_VERSION) < tonumber(tVuhDoVersion)) then
		VUHDO_Msg("Aborting: VuhDo version too low. Please update VuhDo to at least " .. tVuhDoVersion, 1, 0.4, 0.4);
		tIsCompatible = false;
	end

	if (GetLocale() ~= tLocale) then
		VUHDO_Msg("Aborting: Language mismatch. Sender has locale " .. tLocale, 1, 0.4, 0.4);
		tIsCompatible = false;
	end

	if (tIsCompatible) then
		VUHDO_Msg("-- VuhDo Version of " .. aUnitName .. " is compatible.");
	else
		VuhDoLnfShareDialog:Hide();
	end

	return tIsCompatible;
end



--
local function VUHDO_requestUserYesNoQuestion(aUnitName, aQuestion, aResumable)
	local tRequest = VUHDO_buildMessage(sCmdUserYesNoRequest, aQuestion);
	VUHDO_trivialRequest(aUnitName, tRequest, sCmdUserYesNoReply, sUserDialogTimeout, aResumable);
end



--
local function VUHDO_confirmedUserYesNoQuestion(aUnitName)
	local tAnswer = VUHDO_getFieldsFromReply(aUnitName, sCmdUserYesNoReply);
	if (tostring(VUHDO_YES) == tAnswer) then
		VUHDO_Msg("-- User " .. aUnitName .. " confirmed transaction.");
		return true;
	else
		VUHDO_Msg("Aborting: User " .. aUnitName .. " declined transaction.", 1, 0.4, 0.4);
		VuhDoLnfShareDialog:Hide();
		return false;
	end
end



--
local function VUHDO_compressForSending(aTable)
	return VUHDO_compressTable(aTable);
end



--
local function VUHDO_decompressFromSending(aString)
	return VUHDO_decompressIfCompressed(aString);
end



--
local function VUHDO_doShareResumeAcceptQuestion(aUnitName)
	if (not VUHDO_confirmedUserYesNoQuestion(aUnitName)) then
		VUHDO_removeCommsData(aUnitName);
		return;
	end

	local tData = VUHDO_getUserData(aUnitName, sCurrentChunkTag);
	VUHDO_sendPacketedMessage(aUnitName, VUHDO_compressForSending(tData), sCurrentChunkTag, sCurrentEndTag);
end



--
local function VUHDO_doShareResumeVersion(aUnitName)
	if (not VUHDO_isVersionCompatible(aUnitName)) then
		VUHDO_removeCommsData(aUnitName);
		return;
	end

	VUHDO_requestUserYesNoQuestion(aUnitName, sCurrentQuestionText, VUHDO_doShareResumeAcceptQuestion);
end




--
function VUHDO_startShare(aUnitName, aTable, aChunkTag, anEndTag, aQuestionText)
	sCurrentChunkTag = aChunkTag;
	sCurrentEndTag = anEndTag;
	sCurrentQuestionText = aQuestionText;

	VUHDO_setUserData(aUnitName, aChunkTag, aTable);
	VUHDO_requestVuhdoVersion(aUnitName, VUHDO_doShareResumeVersion);
end



--
local function VUHDO_addReplyData(aUnitName, aType, someNewData)
	local tReplyData = VUHDO_getReplyData(aUnitName, aType) or "";

	tReplyData = tReplyData .. someNewData;

	if (strlen(tReplyData) > sMaxReceiveSize) then
		VUHDO_Msg("Aborting: Received amount of data from " .. aUnitName .. " exceeds max allowed!", 1, 0.4, 0.4);
		sBlockedSenders[aUnitName] = true;
		VUHDO_sendMessage(aUnitName, sCmdAbortComms, nil);
		VUHDO_removeCommsData(aUnitName);
		return;
	end

	VUHDO_setReplyData(aUnitName, aType, tReplyData);
end


--
local function VUHDO_handleCommandReceived(aSenderName, aCommand)
	local tCommandType, tData = strsplit(sCommandSeparator, aCommand, 2);

	if (sCmdAbortComms == tCommandType) then
		VUHDO_removeCommsData(aSenderName);
		VuhDoYesNoFrame:Hide();
		VUHDO_Msg("Transaction aborted by " .. aSenderName);
	else
		-- @TODO @UGLY
		--[[if (VUHDO_getReplyData(aSenderName, sCmdUserYesNoReply) == nil) then
			return;
		end]]

		if(sCmdProfileDataChunk == tCommandType) then
			VUHDO_addReplyData(aSenderName, sCmdProfileDataChunk, tData);
			if (sNumChunks % 20 == 0) then
				VUHDO_Msg("Receiving profile data: " .. strrep(".", sNumChunks / 20 + 1));
			end
			sNumChunks = sNumChunks + 1;

		elseif(sCmdProfileDataEnd == tCommandType) then
			local tProfile = VUHDO_decompressFromSending(VUHDO_getReplyData(aSenderName, sCmdProfileDataChunk));

			local tName = tProfile["NAME"];
			if (VUHDO_getProfileNamedCompressed(tName) ~= nil) then
				local tPos = strfind(tName, ": ", 1, true);
				if (tPos ~= nil) then
					tName = strsub(tName, tPos + 2);
				end

				tProfile["NAME"] = VUHDO_createNewProfileName(tName, aSenderName);
			end
			tinsert(VUHDO_PROFILES, tProfile);

			VUHDO_Msg("Transmission complete. Profile \"" .. tProfile["NAME"] .. "\" has been added.");
			VUHDO_removeCommsData(aSenderName);

		elseif(sCmdKeyLayoutDataChunk == tCommandType) then
			VUHDO_addReplyData(aSenderName, sCmdKeyLayoutDataChunk, tData);
		elseif(sCmdKeyLayoutDataEnd == tCommandType) then
			local tKeyLayout = VUHDO_decompressFromSending(VUHDO_getReplyData(aSenderName, sCmdKeyLayoutDataChunk));
			while (VUHDO_SPELL_LAYOUTS[tKeyLayout[1]] ~= nil) do
				tKeyLayout[1] = aSenderName .. ": " .. tKeyLayout[1];
			end
			VUHDO_Msg("Transmission complete. Key Layout \"" .. tKeyLayout[1] .. "\" has been added.");
			VUHDO_SPELL_LAYOUTS[tKeyLayout[1]] = tKeyLayout[2];
			VUHDO_removeCommsData(aSenderName);
		else
			VUHDO_Msg("Invalid VuhDo command received from " .. aSenderName .. ". Blocking.");
			sBlockedSenders[aSenderName] = true;
		end
	end
end



--
local function VUHDO_yesNoCommsCallback(aDecision)
	local tMessage = VUHDO_buildMessage(sCmdUserYesNoReply, aDecision);
	VUHDO_sendMessage(VuhDoYesNoFrame:GetAttribute("senderName"), tMessage, nil);
end



--
local function VUHDO_handleRequestReceived(aSenderName, aRequest)
	local tRequestType, tData = strsplit(sCommandSeparator, aRequest, 2);

	if (sCmdVersionRequest == tRequestType) then
		local tMessage = VUHDO_buildMessage(sCmdVersionReply, VUHDO_COMMS_VERSION, VUHDO_VERSION, GetLocale());
		VUHDO_sendMessage(aSenderName, tMessage, nil);
	elseif(sCmdUserYesNoRequest == tRequestType) then
		VuhDoYesNoFrameText:SetText(tData);
		VuhDoYesNoFrame:SetAttribute("callback", VUHDO_yesNoCommsCallback);
		VuhDoYesNoFrame:SetAttribute("senderName", aSenderName);
		VuhDoYesNoFrame:Show();
	else
		VUHDO_xMsg("Unknown request ", aRequest, "from", aSenderName);
	end
end



--
local function VUHDO_handleReplyReceived(aSenderName, aMessage)
	local tReplyType, tData = strsplit(sCommandSeparator, aMessage, 2);

	if (tReplyType == nil or tData == nil) then
		VUHDO_xMsg("3. Invalid VuhDo message received from", aSenderName, aMessage);
		return;
	end

	if (sRequestsInProgress[aSenderName] == nil or sRequestsInProgress[aSenderName][tReplyType] == nil) then
		VUHDO_xMsg("No such reply expected from ", aSenderName, aMessage);
		return;
	end

	VUHDO_setReplyData(aSenderName, tReplyType, tData);
	local tResumable = sRequestsInProgress[aSenderName][tReplyType][2];
	sRequestsInProgress[aSenderName][tReplyType] = nil;
	if (tResumable ~= nil) then
		tResumable(aSenderName);
	end
end



--
function VUHDO_parseVuhDoMessage(aSenderName, aMessage)

	if (sBlockedSenders[aSenderName]) then
		if (sReceiveMode < 4) then
			VUHDO_Msg("Blocking comms from " .. aSenderName .. ". /reload to reset.", 1, 0.4, 0.4);
			sReceiveMode = 4;
		end

		return;
	end

	if (not VUHDO_CONFIG["IS_SHARE"]) then
		if (sReceiveMode > 0 and sReceiveMode < 4) then
			VUHDO_Msg("Blocked comms from " .. aSenderName .. ". VuhDo options => Tools => Share is disabled.");
			sReceiveMode = sReceiveMode + 1;
		end

		return;
	end

	if (sReceiveMode > 0 and sReceiveMode < 4) then
		VUHDO_Msg("Blocked comms from " .. aSenderName .. ". VuhDo options screen must be opened.");
		sReceiveMode = sReceiveMode + 1;
		return;
	elseif(sReceiveMode > 0) then
	  return; -- Silently fail, no spamming
	end

	if (strlen(aMessage or "") < 4) then
		VUHDO_xMsg("1. Invalid VuhDo message received from", aSenderName, aMessage);
		return;
	end
	local tPrefix = strsub(aMessage, 1, 3);

	if ((sBusyUnitName or aSenderName) ~= aSenderName) then
		return;
	end

	sBusyUnitName = aSenderName;

	if (sPrefixCommand == tPrefix) then
		VUHDO_handleCommandReceived(aSenderName, aMessage);
	elseif(sPrefixRequest == tPrefix) then
		VUHDO_handleRequestReceived(aSenderName, aMessage);
	elseif(sPrefixReply == tPrefix) then
		VUHDO_handleReplyReceived(aSenderName, aMessage);
	else
		VUHDO_xMsg("2. Invalid VuhDo message received from", aSenderName, aMessage);
	end
end



--
function VUHDO_updateRequestsInProgress()
	for tReceiverName, tSomeUnitRequests in pairs(sRequestsInProgress) do
		for tReplyType, tSomeReplyInfos in pairs(tSomeUnitRequests) do
			if (GetTime() > tSomeReplyInfos[1]) then
				VUHDO_sendMessage(tReceiverName, sCmdAbortComms, nil);
				VUHDO_removeCommsData(tReceiverName);
				VUHDO_Msg("Aborting: Request to " .. tReceiverName .. " timed out.", 1, 0.4, 0.4);
				VuhDoLnfShareDialog:Hide();
			end
		end
	end
end
