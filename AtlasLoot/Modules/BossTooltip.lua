-- $Id: BossTooltip.lua 3697 2012-01-31 15:17:37Z lag123 $
function AtlasLoot_hook(tooltip)
	if not ALtooltipName then
		ALtooltipName = tooltip:GetUnit()
		local ALGUID = UnitGUID("mouseover")
		if ALGUID then
			ALunitID = tonumber((ALGUID):sub(-12, -9), 16)
		end
	end

	if not UnitIsPlayer(ALtooltipName) and not UnitAffectingCombat("player") and AtlasLoot_Data and AtlasLoot.db.profile.ShowBossTooltip then

		if AtlasLoot_BossTooltipMatch[ALunitID] then
			ALtooltipName = AtlasLoot_BossTooltipMatch[ALunitID]
		elseif AtlasLoot_BossTooltipMatch[ALtooltipName] then
			ALtooltipName = AtlasLoot_BossTooltipMatch[ALtooltipName]
		end

		for ALindexBoss,ALvalueBoss in pairs(AtlasLoot_Data) do
			if ALvalueBoss.info then
				if ALvalueBoss.info.name == ALtooltipName then
					for ALindexWishlist,ALvalueWishlist in pairs(AtlasLootDB["namespaces"]["WishList"]["global"]["data"]["Normal"][GetRealmName()][GetUnitName("player")]) do
						local ALwishlistName = ALvalueWishlist["info"]["name"]
						if ALwishlistName == "" then
							ALwishlistName = "Default"
						end
						for ALindexWishlistItem,ALvalueWishlistItem in pairs(ALvalueWishlist[1]) do
							local ALbossHandle, ALitemDifficulty = strsplit("#", ALvalueWishlistItem[6])
							local _, _, ALdifficultyIndex, _, ALmaxPlayers = GetInstanceInfo()
							local ALinstanceDifficulty = "Normal"
							if (ALmaxPlayers == 5 and ALdifficultyIndex == 2) or (ALmaxPlayers == 10 and ALdifficultyIndex == 3) or (ALmaxPlayers == 25 and ALdifficultyIndex == 4) then
								ALinstanceDifficulty = "Heroic"
							----------------------------------------------------------------------------
							-- Fix to detect LFR till Blizzard adds that difficulty to GetInstanceInfo()
							----------------------------------------------------------------------------
							else
								if ALmaxPlayers == 25 then
									for i=1,25 do
										local _, ALrealm = UnitName("raid"..i)
										if ALrealm then
											ALinstanceDifficulty = "RaidFinder"
											break
										end
									end
								end
							----------------------------------------------------------------------------
							-- End fix
							----------------------------------------------------------------------------
							end
							if ALindexBoss == ALbossHandle and ALinstanceDifficulty == ALitemDifficulty then
								local ALitemName, _, ALitemQuality, _, _, _, _, _, ALequipSlot = GetItemInfo(ALvalueWishlistItem[2])
								if ALitemName and ALitemQuality and ALequipSlot then
									local _, _, _, ALhex = GetItemQualityColor(ALitemQuality)
									if ALequipSlot == "" then
										tooltip:AddLine(string.format("%s: |c%s%s|r", ALwishlistName, ALhex, ALitemName))
									else
										tooltip:AddLine(string.format("%s: |c%s%s|r (%s)", ALwishlistName, ALhex, ALitemName, _G[ALequipSlot]))
									end
								else
									tooltip:AddLine("|cffff0000Item not cached, try again|r")
								end
							end
						end
					end
					tooltip:Show()
					break
				end
			end
		end
	end
end


function AtlasLoot_update(tooltip)
	if not tooltip:GetUnit() and not tooltip:GetSpell() and not tooltip:GetItem() then
		local ALobjectName = getfenv(0)[tooltip:GetName()..'TextLeft1']:GetText()
		if ALlastTooltip == ALobjectName then
			ALtooltipName = nil
			return
		end
		ALlastTooltip = ALobjectName

		if AtlasLoot_BossTooltipMatch[ALobjectName] then
			ALtooltipName = AtlasLoot_BossTooltipMatch[ALobjectName]
			AtlasLoot_hook(tooltip)
		end
	end
end


function AtlasLoot_show(tooltip)
	ALlastTooltip = nil
	ALtooltipName = nil
end


if GameTooltip:GetScript("OnTooltipSetUnit") then
	GameTooltip:HookScript("OnTooltipSetUnit", AtlasLoot_hook)
	GameTooltip:HookScript("OnUpdate", AtlasLoot_update)
	GameTooltip:HookScript("OnShow", AtlasLoot_show)
	ALlastTooltip = nil
	ALtooltipName = nil
else
	GameTooltip:SetScript("OnTooltipSetUnit", AtlasLoot_hook)
	GameTooltip:SetScript("OnUpdate", AtlasLoot_update)
	GameTooltip:SetScript("OnUpdate", AtlasLoot_show)
	ALlastTooltip = nil
	ALtooltipName = nil
end
