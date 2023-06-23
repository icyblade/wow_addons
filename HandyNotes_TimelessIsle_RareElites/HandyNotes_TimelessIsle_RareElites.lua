TimelessIsle_RareElites = LibStub("AceAddon-3.0"):NewAddon("TimelessIsle_RareElites", "AceBucket-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
if not HandyNotes then return end

--TimelessIsle_RareElites = HandyNotes:NewModule("TimelessIsle_RareElites", "AceConsole-3.0", "AceEvent-3.0")
local db
local iconDefault = "Interface\\AddOns\\HandyNotes_TimelessIsle_RareElites\\Artwork\\0skull.tga"

TimelessIsle_RareElites.nodes = { }
local nodes = TimelessIsle_RareElites.nodes

nodes["TimelessIsle"] = { }

nodes["TimelessIsle"][35005200] = { "35170", HandyNotes.Locals.EmeralGander.." \124cff1eff00\124Hitem:104287:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.EmeralGanderDrop.."]\124h\124r\n"..HandyNotes.Locals.IronfurSteelhorn.." \124cff1eff00\124Hitem:89770:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.IronfurSteelhornDrop.."]\124h\124r\n"..HandyNotes.Locals.ImperialPython.." \124cff0070dd\124Hitem:104161:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.ImperialPythonDrop.."]\124h\124r\n", HandyNotes.Locals.EmeralGanderInfo}
nodes["TimelessIsle"][24805500] = { "35171", HandyNotes.Locals.GreatTurtleFuryshell.." \124cff0070dd\124Hitem:86584:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.GreatTurtleFuryshellDrop.."]\124h\124r\n", HandyNotes.Locals.GreatTurtleFuryshellInfo }
nodes["TimelessIsle"][38007500] = { "35172", HandyNotes.Locals.GuchiSwarmbringer.." \124cff0070dd\124Hitem:104291:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.GuchiSwarmbringerDrop.."]\124h\124r\n", HandyNotes.Locals.GuchiSwarmbringerInfo }
nodes["TimelessIsle"][47008700] = { "35173", HandyNotes.Locals.Zesqua.." \124cff0070dd\124Hitem:104303:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.ZesquaDrop.."]\124h\124r\n", HandyNotes.Locals.ZesquaInfo }
nodes["TimelessIsle"][37557731] = { "35174", HandyNotes.Locals.ZhuGonSour.." \124cff0070dd\124Hitem:104167:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.ZhuGonSourDrop.."]\124h\124r\n", HandyNotes.Locals.ZhuGonSourInfo }
nodes["TimelessIsle"][34088384] = { "35175", HandyNotes.Locals.Karkanos.." \124cffffffff\124Hitem:104035:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.KarkanosDrop.."]\124h\124r\n", HandyNotes.Locals.KarkanosInfo }
nodes["TimelessIsle"][25063598] = { "35176", HandyNotes.Locals.Chelon.." \124cff0070dd\124Hitem:86584:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.ChelonDrop.."]\124h\124r\n", HandyNotes.Locals.ChelonInfo }
nodes["TimelessIsle"][59004880] = { "35177", HandyNotes.Locals.Spelurk.." \124cff1eff00\124Hitem:104320:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.SpelurkDrop.."]\124h\124r\n", HandyNotes.Locals.SpelurkInfo }
nodes["TimelessIsle"][43896989] = { "35178", HandyNotes.Locals.Cranegnasher.." \124cff0070dd\124Hitem:104268:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.CranegnasherDrop.."]\124h\124r\n", HandyNotes.Locals.CranegnasherInfo }
nodes["TimelessIsle"][54094240] = { "35179", HandyNotes.Locals.Rattleskew.." \124cffa335ee\124Hitem:104321:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.RattleskewDrop.."]\124h\124r\n", HandyNotes.Locals.RattleskewInfo }
nodes["TimelessIsle"][50008700] = { "35180", HandyNotes.Locals.MonstrousSpineclaw.." \124cff0070dd\124Hitem:104168:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.MonstrousSpineclawDrop.."]\124h\124r\n", HandyNotes.Locals.MonstrousSpineclawInfo }
nodes["TimelessIsle"][44003900] = { "35181", HandyNotes.Locals.SpiritJadefire.." \124cff0070dd\124Hitem:104258:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.SpiritJadefireDrop.."]\124h\124r\n \124cff0070dd\124Hitem:104307:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.SpiritJadefireDrop2.."]\124h\124r\n", HandyNotes.Locals.SpiritJadefireInfo }
nodes["TimelessIsle"][67004300] = { "35182", HandyNotes.Locals.Leafmender.." \124cff0070dd\124Hitem:104156:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.LeafmenderDrop.."]\124h\124r\n", HandyNotes.Locals.LeafmenderInfo }
nodes["TimelessIsle"][65006500] = { "35183", HandyNotes.Locals.Bufo.." \124cff0070dd\124Hitem:104169:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.BufoDrop.."]\124h\124r\n", HandyNotes.Locals.BufoInfo }
nodes["TimelessIsle"][64002700] = { "35204", HandyNotes.Locals.Garnia.." \124cff0070dd\124Hitem:104159:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.GarniaDrop.."]\124h\124r\n", HandyNotes.Locals.GarniaInfo } 
nodes["TimelessIsle"][54094240] = { "35205", HandyNotes.Locals.Tsavoka.." \124cff0070dd\124Hitem:104268:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.TsavokaDrop.."]\124h\124r\n", HandyNotes.Locals.TsavokaInfo }
nodes["TimelessIsle"][71588185] = { "35207", HandyNotes.Locals.Stinkbraid, HandyNotes.Locals.StinkbraidInfo }
nodes["TimelessIsle"][46003100] = { "35208", HandyNotes.Locals.RockMoss.." \124cff0070dd\124Hitem:104313:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.RockMossDrop.."]\124h\124r\n", HandyNotes.Locals.RockMossInfo }
nodes["TimelessIsle"][57007200] = { "35209", HandyNotes.Locals.WatcherOsu.." \124cff0070dd\124Hitem:104305:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.WatcherOsuDrop.."]\124h\124r\n", HandyNotes.Locals.WatcherOsuInfo }
nodes["TimelessIsle"][52008100] = { "35210", HandyNotes.Locals.JakurOrdon.." \124cff0070dd\124Hitem:104331:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.JakurOrdonDrop.."]\124h\124r\n", HandyNotes.Locals.JakurOrdonInfo }
nodes["TimelessIsle"][66204050] = { "35211", HandyNotes.Locals.ChampionBlackFlame.." \124cff0070dd\124Hitem:104302:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.ChampionBlackFlameDrop.."]\124h\124r\n \124cff0070dd\124Hitem:87219:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.ChampionBlackFlameDrop2.."]\124h\124r\n", HandyNotes.Locals.ChampionBlackFlameInfo } 
nodes["TimelessIsle"][53005200] = { "35212", HandyNotes.Locals.Cinderfall.." \124cff0070dd\124Hitem:104299:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.CinderfallDrop.."]\124h\124r\n", HandyNotes.Locals.CinderfallInfo } 
nodes["TimelessIsle"][43002500] = { "35213", HandyNotes.Locals.UrdurCauterizer.." \124cff0070dd\124Hitem:104306:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.UrdurCauterizerDrop.."]\124h\124r\n", HandyNotes.Locals.UrdurCauterizerInfo }
nodes["TimelessIsle"][44003400] = { "35214", HandyNotes.Locals.FlintlordGairan.." \124cffa335ee\124Hitem:104298:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.FlintlordGairanDrop.."]\124h\124r\n", HandyNotes.Locals.FlintlordGairanInfo } 
nodes["TimelessIsle"][64106390] = { "35215", HandyNotes.Locals.Huolon.." \124cffa335ee\124Hitem:104269:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.HuolonDrop.."]\124h\124r\n", HandyNotes.Locals.HuolonInfo } 
nodes["TimelessIsle"][62506350] = { "35216", HandyNotes.Locals.Golganarr.." \124cff0070dd\124Hitem:104262:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.GolganarrDrop.."]\124h\124r\n \124cff0070dd\124Hitem:104263:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.GolganarrDrop2.."]\124h\124r\n", HandyNotes.Locals.GolganarrInfo } 
nodes["TimelessIsle"][19005800] = { "35217", HandyNotes.Locals.Evermaw.." \124cffffffff\124Hitem:104115:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.EvermawDrop.."]\124h\124r\n", HandyNotes.Locals.EvermawInfo } 
nodes["TimelessIsle"][28802450] = { "35218", HandyNotes.Locals.DreadShipVazuvius.." \124cff0070dd\124Hitem:104294:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.DreadShipVazuviusDrop.."]\124h\124r\n", HandyNotes.Locals.DreadShipVazuviusInfo } 
nodes["TimelessIsle"][34403250] = { "35219", HandyNotes.Locals.ArchiereusFlame.."\124cff0070dd\124Hitem:86574:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.ArchiereusFlameDrop.."]\124h\124r\n", HandyNotes.Locals.ArchiereusFlameInfo } 
nodes["TimelessIsle"][61008860] = { "35219", HandyNotes.Locals.Rattleskew.."\n\124cffa335ee\124Hitem:104321:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.RattleskewDrop.."]\124h\124r\n\124cff1eff00\124Hitem:104219:0:0:0:0:0:0:0:0:0:0\124h["..HandyNotes.Locals.RattleskewDrop2.."]\124h\124r\n", HandyNotes.Locals.RattleskewInfo } 


--[[ function TimelessIsle_RareElites:OnEnable()
end

function TimelessIsle_RareElites:OnDisable()
end ]]--

--local handler = {}


function TimelessIsle_RareElites:OnEnter(mapFile, coord) -- Copied from handynotes
    if (not nodes[mapFile][coord]) then return end
	
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
	if ( self:GetCenter() > UIParent:GetCenter() ) then -- compare X coordinate
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	tooltip:SetText(nodes[mapFile][coord][2])
	if (nodes[mapFile][coord][3] ~= nil) then
	 tooltip:AddLine(nodes[mapFile][coord][3], nil, nil, nil, true)
	end
	tooltip:Show()
end

function TimelessIsle_RareElites:OnLeave(mapFile, coord)
	if self:GetParent() == WorldMapButton then
		WorldMapTooltip:Hide()
	else
		GameTooltip:Hide()
	end
end

local options = {
 type = "group",
 name = "TimelessIsle_RareElites",
 desc = HandyNotes.Locals.OptionsDescription,
 get = function(info) return db[info.arg] end,
 set = function(info, v) db[info.arg] = v; TimelessIsle_RareElites:Refresh() end,
 args = {
  desc = {
   name = HandyNotes.Locals.OptionsArgsDescription,
   type = "description",
   order = 0,
  },
  icon_scale = {
   type = "range",
   name = HandyNotes.Locals.OptionsIconScaleName,
   desc = HandyNotes.Locals.OptionsIconScaleDescription,
   min = 0.25, max = 2, step = 0.01,
   arg = "icon_scale",
   order = 10,
  },
  icon_alpha = {
   type = "range",
   name = HandyNotes.Locals.OptionsIconAlphaName,
   desc = HandyNotes.Locals.OptionsIconAlphaDescription,
   min = 0, max = 1, step = 0.01,
   arg = "icon_alpha",
   order = 20,
  },

 },
}

function TimelessIsle_RareElites:OnInitialize()
 local defaults = {
  profile = {
   icon_scale = 1.0,
   icon_alpha = 1.0,
   alwaysshow = false,
  },
 }

 db = LibStub("AceDB-3.0"):New("TimelessIsle_RareElitesDB", defaults, true).profile
 self:RegisterEvent("PLAYER_ENTERING_WORLD", "WorldEnter")
end

function TimelessIsle_RareElites:WorldEnter()
 self:UnregisterEvent("PLAYER_ENTERING_WORLD")

 --self:RegisterEvent("WORLD_MAP_UPDATE", "Refresh")
 --self:RegisterEvent("LOOT_CLOSED", "Refresh")

 --self:Refresh()
 self:ScheduleTimer("RegisterWithHandyNotes", 10)
end

function TimelessIsle_RareElites:RegisterWithHandyNotes()
do
	local function iter(t, prestate)
		if not t then return nil end
		local state, value = next(t, prestate)
		while state do
			    -- questid, chest type, quest name, icon
			    if (value[1] and (not IsQuestFlaggedCompleted(value[1]) or db.alwaysshow)) then
				 --print(state)
				 local icon = value[4] or iconDefault
				 return state, nil, icon, db.icon_scale, db.icon_alpha
				end
			state, value = next(t, state)
		end
	end
	function TimelessIsle_RareElites:GetNodes(mapFile, isMinimapUpdate, dungeonLevel)
		return iter, nodes[mapFile], nil
	end
end
 HandyNotes:RegisterPluginDB("TimelessIsle_RareElites", self, options)
 self:RegisterBucketEvent({ "LOOT_CLOSED" }, 2, "Refresh")
 self:Refresh()
end
 

function TimelessIsle_RareElites:Refresh()
 self:SendMessage("HandyNotes_NotifyUpdate", "TimelessIsle_RareElites")
end