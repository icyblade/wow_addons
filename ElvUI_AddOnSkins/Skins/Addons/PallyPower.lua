local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack
local find = string.find

local function LoadSkin()
	if not E.private.addOnSkins.PallyPower then return end

	local _applyskin = PallyPower.ApplySkin
	function PallyPower:ApplySkin(skinname)
		local needSkinning = {PallyPowerAutoBtn, PallyPowerRFBtn, PallyPowerAuraBtn}

		for _, frame in pairs(needSkinning) do
			frame:SetBackdrop({
				bgFile = E.noop,
				insets = {left = 2, right = 2, top = 2, bottom = 2}
			})

			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, frame)
				frame.bg:SetAllPoints(frame)
				frame.bg:SetFrameLevel(frame:GetFrameLevel() - 1)
				frame.bg:SetTemplate("Transparent")
			end

			local fname = frame:GetName()
			for _, fontstring in pairs({"Time", "Text", "TimeSeal"}) do
				local fs = _G[fname..fontstring]
				if fs then
					local _, size = fs:GetFont()
					fs:FontTemplate()
					if not find(fname, "PowerC%d+P%d+$") then
						if fontstring == "Text" then
							fs:ClearAllPoints()
							fs:SetJustifyH("LEFT")
							fs:SetWidth(999)
							fs:SetPoint("TOPLEFT", 33, 0)
						else
							fs:ClearAllPoints()
							fs:SetWidth(999)
							fs:SetJustifyH("RIGHT")
							fs:SetPoint("RIGHT", frame, "RIGHT", -4, 0)
						end
					end
				end
			end
			for _, tex in pairs({"Icon", "IconAura", "BuffIcon", "IconSeal", "IconRF"}) do
				if _G[fname..tex] and not _G[fname.."New"..tex] then
					local oldicon = _G[fname..tex]
					oldicon:SetAlpha(0)
					oldicon:ClearAllPoints()

					if fname == "PallyPowerAuraBtn" then
						if tex == "IconSeal" then
							oldicon:SetPoint("LEFT", 4, 0)
						else
							oldicon:SetPoint("LEFT", 34, 0)
						end
					elseif find(fname, "(Au[rt][ao])$") then
						oldicon:SetPoint("LEFT", 4, 0)
					else
						oldicon:SetPoint("TOPLEFT", 4, -4)
					end

					local panel = CreateFrame("Frame", fname.."New"..tex, frame)
					panel:SetAllPoints(oldicon)
					panel:SetTemplate("Default")

					local icon = panel:CreateTexture()
					panel.icon = panel

					icon:SetPoint("TOPLEFT", panel, 2, -2)
					icon:SetPoint("BOTTOMRIGHT", panel, -2, 2)
					icon:SetTexCoord(unpack(E.TexCoords))
					icon:SetTexture(oldicon:GetTexture())

					oldicon.SetTexture = function(tex, texstring)
						icon:SetTexture(texstring)
						if not texstring then
							panel:SetAlpha(0)
						else
							panel:SetAlpha(1)
						end
					end

					oldicon.SetVertexColor = function(self, ...)
						icon:SetVertexColor(...)
					end
				end
			end
		end
	end

	local _updatelayout = PallyPower.UpdateLayout
	function PallyPower:UpdateLayout()
		_updatelayout(self)

		for _, button in pairs({PallyPowerAutoBtn, PallyPowerRFBtn, PallyPowerAuraBtn}) do
			if not UnitAffectingCombat("player") then
				local a, p, b, x, y = button:GetPoint()
				button:SetPoint(a, p, b, x, y + 3)
			end
		end
	end

	PallyPower:ApplySkin()
	PallyPower:UpdateLayout()
end

S:AddCallbackForAddon("PallyPower", "PallyPower", LoadSkin)