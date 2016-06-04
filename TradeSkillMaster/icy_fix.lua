function GetAuctionItemClasses()
    --[[
    return {
        [1]  = AUCTION_CATEGORY_WEAPONS, -- 第一个必须是武器
        [2]  = AUCTION_CATEGORY_ARMOR, -- 第二个必须是护甲
        [3]  = AUCTION_CATEGORY_CONTAINER,
        [4]  = AUCTION_CATEGORY_CONSUMABLES,
        [5]  = AUCTION_CATEGORY_GLYPHS,
        [6]  = AUCTION_CATEGORY_TRADE_GOODS,
        [7]  = AUCTION_CATEGORY_RECIPES,
        [8]  = AUCTION_CATEGORY_GEMS,
        [9]  = AUCTION_CATEGORY_MISCELLANEOUS,
        [10] = AUCTION_CATEGORY_QUEST_ITEMS,
        [11] = AUCTION_CATEGORY_BATTLE_PETS,
        [12] = AUCTION_CATEGORY_ITEM_ENHANCEMENT,
    }]]
    return AUCTION_CATEGORY_WEAPONS,AUCTION_CATEGORY_ARMOR,AUCTION_CATEGORY_CONTAINER,AUCTION_CATEGORY_CONSUMABLES,AUCTION_CATEGORY_GLYPHS,AUCTION_CATEGORY_TRADE_GOODS,AUCTION_CATEGORY_RECIPES,AUCTION_CATEGORY_GEMS,AUCTION_CATEGORY_MISCELLANEOUS,AUCTION_CATEGORY_QUEST_ITEMS,AUCTION_CATEGORY_BATTLE_PETS,AUCTION_CATEGORY_ITEM_ENHANCEMENT
end

function GetAuctionInvTypes(classIndex, subClassIndex)
    if classIndex == 2 and subClassIndex == 1 then
        return 'INVTYPE_HEAD', true, 'INVTYPE_NECK', true, 'INVTYPE_SHOULDER', false, 'INVTYPE_BODY', true, 'INVTYPE_CHEST', false, 'INVTYPE_WAIST', false, 'INVTYPE_LEGS', false, 'INVTYPE_FEET', false, 'INVTYPE_WRIST', false, 'INVTYPE_HAND', false, 'INVTYPE_FINGER', true, 'INVTYPE_TRINKET', true, 'INVTYPE_CLOAK', true, 'INVTYPE_HOLDABLE', true
    else
        print('Not implemented yet')
    end
end

function GetTradeSkillLine()
    -- local tradeskillName, currentLevel, maxLevel = GetTradeSkillLine();
    local id, tradeskillName, currentLevel, maxLevel = C_TradeSkillUI.GetTradeSkillLine()
    if tradeskillName ~= nil then
        return tradeskillName, currentLevel, maxLevel
    else
        return 'UNKNOWN', 0, 0
    end
end

function IsNPCCrafting()
    return C_TradeSkillUI.IsNPCCrafting()
end

function GetNumTradeSkills()
    return #C_TradeSkillUI.GetFilteredRecipeIDs()
end

function IsTradeSkillLinked()
    return C_TradeSkillUI.IsTradeSkillLinked()
end

function IsTradeSkillGuild()
    return C_TradeSkillUI.IsTradeSkillGuild()
end

function TradeSkillOnlyShowMakeable()
    return C_TradeSkillUI.SetOnlyShowMakeableRecipes(not C_TradeSkillUI.GetOnlyShowMakeableRecipes())
end

function TradeSkillOnlyShowSkillUps()
    return C_TradeSkillUI.SetOnlyShowSkillUpRecipes(not C_TradeSkillUI.GetOnlyShowSkillUpRecipes())
end

function TradeSkillSetFilter(subclass, slot, subName, slotName, subclassCategory)
	C_TradeSkillUI.ClearInventorySlotFilter()
	C_TradeSkillUI.ClearRecipeCategoryFilter()

    if categoryID or subCategoryID then
        C_TradeSkillUI.SetRecipeCategoryFilter(subclass, subclassCategory);
    end
    
    if inventorySlotIndex then
        C_TradeSkillUI.SetInventorySlotFilter(slot, true, true)
    end
end

function SetTradeSkillItemNameFilter(text)
    C_TradeSkillUI.SetRecipeItemNameFilter(text)
end

function TradeSkillFrame_Update()
    --TradeSkillUIMixin.RecipeList:Refresh()
    --TradeSkillUIMixin.DetailsFrame:Refresh()
    return 1
end

TradeSkillCollapseAllButton = {}
TradeSkillCollapseAllButton.collapsed = false
function TradeSkillCollapseAllButton:Click()
    return 1
end

function GetTradeSkillListLink()
    return C_TradeSkillUI.GetTradeSkillListLink()
end

function GetTradeSkillItemLink(index)
    return C_TradeSkillUI.GetRecipeItemLink(index)
end

function GetTradeSkillRecipeLink(index)
    return C_TradeSkillUI.GetRecipeLink(index)
end

function GetTradeSkillInfo(index)
    local info = C_TradeSkillUI.GetRecipeInfo(index)
    -- skillName, skillType, numAvailable, isExpanded, altVerb, numSkillUps, indentLevel, showProgressBar, currentRank, maxRank, startingRank
    if info then
        return info.name, info.difficulty, info.numAvailable, false, info.alternateVerb, info.numSkillUps, info.numIndents, false, nil, nil, nil
    end
end

function GetTradeSkillCooldown(index)
    return C_TradeSkillUI.GetRecipeCooldown(index)
end

function GetTradeSkillSelectionIndex()
    return TradeSkillRecipeListMixin.selectedRecipeID or 0
end

function GetFirstTradeSkill()
    local recipeIDs = C_TradeSkillUI.GetFilteredRecipeIDs()
    for i, recipeID in ipairs(recipeIDs) do
        return recipeID
    end
end

function GetTradeSkillNumMade(skillIndex)
    return C_TradeSkillUI.GetRecipeNumItemsProduced(skillIndex)
end

function GetTradeSkillIcon(skillIndex)
    return C_TradeSkillUI.GetRecipeInfo(skillIndex).icon
end

function GetTradeSkillDescription(skillIndex)
    return C_TradeSkillUI.GetRecipeDescription(skillIndex)
end

function GetTradeSkillTools(skillIndex)
    return C_TradeSkillUI.GetRecipeTools(skillIndex)
end

function GetTradeSkillReagentInfo(skillIndex, i)
    return C_TradeSkillUI.GetRecipeReagentInfo(skillIndex, i)
end

function GetTradeSkillReagentItemLink(skillIndex, i)
    return C_TradeSkillUI.GetRecipeReagentItemLink(skillIndex, i)
end









