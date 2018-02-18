local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local M = SLE:NewModule("Misc", 'AceHook-3.0', 'AceEvent-3.0')
local Tr = E:GetModule('Threat');
--GLOBALS: hooksecurefunc, UIParent
local _G = _G
local ShowUIPanel, HideUIPanel = ShowUIPanel, HideUIPanel
local find = string.find

function M:RUReset()
	local a = E.db.sle.blizzard.rumouseover and 0 or 1
	_G["RaidUtility_ShowButton"]:SetAlpha(a)
end

function M:UpdateThreatPosition()
	if not E.db.general.threat.enable or not M.db.threat or not M.db.threat.enable then return end

	Tr.bar:SetInside(M.db.threat.position)
	Tr.bar:SetParent(M.db.threat.position)

	Tr.bar.text:FontTemplate(nil, E.db.general.threat.textSize, E.db.general.threat.textOutline)
	Tr.bar:SetFrameStrata('MEDIUM')
	Tr.bar:SetAlpha(1)
end

function M:UpdateThreatConfig()
	if T.IsAddOnLoaded("ElvUI_Config") then
		if M.db.threat.enable then
			E.Options.args.general.args.threatGroup.args.threatPosition = {
				order = 42,
				name = L["Position"],
				desc = L["This option have been disabled by Shadow & Light. To return it you need to disable S&L's option. Click here to see it's location."],
				type = "execute",
				func = function() SLE.ACD:SelectGroup("ElvUI", "sle") end,
			}
		else
			E.Options.args.general.args.threatGroup.args.threatPosition = {
				order = 42,
				type = 'select',
				name = L["Position"],
				desc = L["Adjust the position of the threat bar to either the left or right datatext panels."],
				values = {
					['LEFTCHAT'] = L["Left Chat"],
					['RIGHTCHAT'] = L["Right Chat"],
				},
				get = function(info) return E.db.general.threat.position end,
				set = function(info, value) E.db.general.threat.position = value; Tr:UpdatePosition() end,
			}
		end
	end
end

function M:LoadConfig(event, addon)
	if addon ~= "ElvUI_Config" then return end

	M:UpdateThreatConfig()
	M:UnregisterEvent("ADDON_LOADED")
end

function M:SetViewport()
	local scale = 768 / UIParent:GetHeight()
	_G["WorldFrame"]:SetPoint("TOPLEFT", ( M.db.viewport.left * scale ), -( M.db.viewport.top * scale ) )
	_G["WorldFrame"]:SetPoint("BOTTOMRIGHT", -( M.db.viewport.right * scale ), ( M.db.viewport.bottom * scale ) )
end

function M:Initialize()
	if not SLE.initialized then return end
	M.db = E.db.sle.misc
	E:CreateMover(_G["UIErrorsFrame"], "UIErrorsFrameMover", L["Error Frame"], nil, nil, nil, "ALL,S&L,S&L MISC")

	--GhostFrame Mover.
	ShowUIPanel(_G["GhostFrame"])
	E:CreateMover(_G["GhostFrame"], "GhostFrameMover", L["Ghost Frame"], nil, nil, nil, "ALL,S&L,S&L MISC")
	HideUIPanel(_G["GhostFrame"])

	--Raid Utility
	if _G["RaidUtility_ShowButton"] then
		E:CreateMover(_G["RaidUtility_ShowButton"], "RaidUtility_Mover", L["Raid Utility"], nil, nil, nil, "ALL,S&L,S&L MISC")
		local mover = _G["RaidUtility_Mover"]
		local frame = _G["RaidUtility_ShowButton"]
		if E.db.movers == nil then E.db.movers = {} end

		mover:HookScript("OnDragStart", function(self) 
			frame:ClearAllPoints()
			frame:SetPoint("CENTER", self)
		end)

		local function Enter(self)
			if not E.db.sle.blizzard.rumouseover then return end
			self:SetAlpha(1)
		end

		local function Leave(self)
			if not E.db.sle.blizzard.rumouseover then return end
			self:SetAlpha(0)
		end

		local function dropfix()
			local point, anchor, point2, x, y = mover:GetPoint()
			frame:ClearAllPoints()
			if find(point, "BOTTOM") then
				frame:SetPoint(point, anchor, point2, x, y)
			else
				frame:SetPoint(point, anchor, point2, x, y)
			end
		end

		mover:HookScript("OnDragStop", dropfix)

		if E.db.movers.RaidUtility_Mover == nil then
			frame:ClearAllPoints()
			frame:SetPoint("TOP", E.UIParent, "TOP", -400, E.Border)
		else
			dropfix()
		end
		frame:RegisterForDrag("")
		frame:HookScript("OnEnter", Enter)
		frame:HookScript("OnLeave", Leave)
		Leave(frame)
	end

	hooksecurefunc(Tr, 'UpdatePosition', M.UpdateThreatPosition)
	M:RegisterEvent("ADDON_LOADED", "LoadConfig")
	M:UpdateThreatPosition()

	M:SetViewport()

	function M:ForUpdateAll()
		M.db = E.db.sle.misc
		M:UpdateThreatConfig()
		M:UpdateThreatPosition()
		M:SetViewport()
	end
end

SLE:RegisterModule(M:GetName())
