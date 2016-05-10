-- ICY: big changes for Legion
local Version = "3.00"

local tplayerClass; --= string.upper(select(2, UnitClass('player')))
local tnumTabs; --= GetNumTalentTabs();
local tmaintalent=1;
local tname1, tname2;
local tRank={}
local tTalentText={}
local tStance, Tclass
local mediaFolder = "Interface\\AddOns\\StatusInfo\\"	--..
local NameFont = GameTooltipTextLeft1:GetFont()
local NumbFont = mediaFolder.."impact.ttf"	
local NameFS = 17
local NumbFS = 14 
local FontF = "THINOUTLINE" 
local StatuPoint, StatuRelay, StatuX, StatuY
local StatusToggle=false
local Language=1
local FrameScale=1
local Threshold=0.2

local ConfigData={}

--local LowValue=0
local StandardValue={}
function Monitor(name, value)
    if StandardValue[name] then
    else
        StandardValue[name] =0
    end

    if  StandardValue[name]> value and UnitAffectingCombat("player")  or StandardValue[name]==0 then 
        StandardValue[name]=value
    end
    if (value-StandardValue[name])/StandardValue[name] >=tonumber(Threshold) then 

        if value%1 ~=0 then value =  format("%.2f", value) end

        return "|r|cffff0000!>"..value
    else
        if value%1 ~=0 then value =  format("%.2f", value) end
        return value
    end


end

local backdrop = { --
bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = true, tileSize = 16, 
insets = {left = -1, right = -1, top = -1, bottom = -1}, 
                }
                local PlayAs=2--1Melee DPS, 2:spellsDPS, 3:healer, 4 tanker5 , hunter

                local enUS={
                    ["AttactPower"]="AttactPower", 
                    ["Mastery"]="Mastery", 
                    ["Crit"]="Crit", 
                    ["AttackSpeed"]="AttactSpeed", 
                    ["SpellPower"]="SpellPower", 
                    ["Haste"]="Haste", 
                    ["ManaRegen"]="ManaRegen", 
                    ["Dodge"]="Dodge", 
                    ["Parry"]="Parry", 
                    ["Block"]="Block", 
                    ["Armor"]="Armor", 
                    ["Hit"]="Hit", 
                    ["OK"]="OK", 
                    ["Threshold"]="Threshold", 
                    ["Versatility"] = "Versatility",
                }
                local zhCN={
                    ["AttactPower"]="攻击强度", 
                    ["Mastery"]="精通", 
                    ["Crit"]="暴击", 
                    ["AttackSpeed"]="攻击速度", 
                    ["SpellPower"]="法术强度", 
                    ["Haste"]="急速", 
                    ["ManaRegen"]="法力回复", 
                    ["Dodge"]="闪避", 
                    ["Parry"]="招架", 
                    ["Block"]="格挡", 
                    ["Armor"]="护甲", 
                    ["Hit"]="命中", 
                    ["OK"]="确定", 
                    ["Threshold"]="阈值", 
                    ["Versatility"] = "全能",
                }
                local zhTW={
                    ["AttactPower"]="攻擊強度", 
                    ["Mastery"]="精通", 
                    ["Crit"]="暴擊", 
                    ["AttackSpeed"]="攻擊速度", 
                    ["SpellPower"]="法術強度", 
                    ["Haste"]="急速", 
                    ["ManaRegen"]="法力恢復", 
                    ["Dodge"]="躲閃", 
                    ["Parry"]="招架", 
                    ["Block"]="格擋", 
                    ["Armor"]="護甲", 
                    ["Hit"]="命中", 
                    ["OK"]="確定", 
                    ["Threshold"]="閾值", 
                    ["Versatility"] = "臨機應變",
                }
                local L=zhCN
                local function GetCurrentInfo()
                    --print("Geting")
                    tmaintalent=0
                    tnumTabs = GetNumSpecializations();
                    Stance=GetShapeshiftForm();
                    tplayerClass = string.upper(select(2, UnitClass('player')));
                    
                    tmaintalent=GetSpecialization();
                    if tplayerClass== "DRUID" then
                        StatuFrame:RegisterEvent("UNIT_AURA")
                        --德鲁伊，法系DPS和治疗以天赋判定。当天赋为野性时，熊形态判定为坦克，猫形态判定为物理DPS，人形态请打酱油
                        --Druid , spell dps and healer according to talent. feral combat druid are tanks when they are in bear form. cat form are melle dps/
                        if tmaintalent==1 then
                            PlayAs=2
                        elseif tmaintalent==2 then
                            PlayAs = 1
                        elseif tmaintalent==3 then
                            PlayAs=4
                        elseif tmaintalent==4 then
                            PlayAs=3
                        end			
                    elseif tplayerClass=="PALADIN" then
                        --圣骑士不好说……因为有防惩的存在……还是以天赋判定吧
                        --Paladin according to talent
                        if tmaintalent==1 then
                            PlayAs=3
                        elseif tmaintalent==2 then
                            PlayAs=4
                        elseif tmaintalent==3 then
                            PlayAs=1
                        end			
                        --1, 2, 同时能做3样的, can play as 3
                    elseif tplayerClass=="SHAMAN" then
                        --萨满，根据天赋判定了……
                        --shaman according to talent
                        if tmaintalent==1 then
                            PlayAs=2
                        elseif tmaintalent==2 then
                            PlayAs=1
                        elseif tmaintalent==3 then
                            PlayAs=3
                        end			
                    elseif tplayerClass=="PRIEST" then
                        --牧师，当天赋为暗影时被认为是法系DPS，否则被认为治疗
                        --Priest, talent
                        if tmaintalent==3 then
                            PlayAs=2
                        else
                            PlayAs=3
                        end								
                        --3, 4 can play as 能做DPS和治疗的, can play as DD and healer
                    elseif tplayerClass== "DEATHKNIGHT" then
                        if Stance== 1 then PlayAs=4 
                        else PlayAs=1 end--DK以开冰脸来判断是否是坦克……DK is according to shapeshift
                    elseif tplayerClass=="WARRIOR" then
                        --WARRIOR.according to stance.
                        if Stance== 2 then 
                            PlayAs=4
                        else
                            PlayAs=1
                        end
                        --5, 6 can play as 能做DPS和坦克的
                    elseif tplayerClass=="ROGUE" then
                        PlayAs=1
                    elseif tplayerClass=="HUNTER" then
                        PlayAs=5--猎人要看远程的，所以单独.Hunter is lonely
                        --7 to 8 :只能做物理DPS
                    elseif tplayerClass=="MAGE" then
                        PlayAs=2
                    elseif tplayerClass=="WARLOCK" then
                        PlayAs=2
                        --9 to 10:只能做法系DPS
                    elseif tplayerClass == "DEMONHUNTER" then
                        if tmaintalent==1 then
                            PlayAs=1
                        elseif tmaintalent==2 then
                            PlayAs=4
                        end
                    end
                    -- print("StatuInfo Loaded   "..tplayerClass..", "..PlayAs..", "..tmaintalent)

                end
                function updateStatu(playas)
                    -- AP
                    local base, posBuff, negBuff = UnitAttackPower("player");
                    local effective = base + posBuff + negBuff;
                    -- 近远攻速
                    local speed, lowDmg, hiDmg, posBuff, negBuff, percent = UnitRangedDamage("player")
                    local mainSpeed, offSpeed = UnitAttackSpeed("player");
                    -- SP
                    local holySchool = 2;
                    -- Start at 2 to skip physical damage
                    local sp = GetSpellBonusDamage(holySchool);
                    for i=(holySchool+1), MAX_SPELL_SCHOOLS do
                        local bonusDamage = GetSpellBonusDamage(i);
                        sp = min(sp, bonusDamage);
                    end
                    -- 绿字
                    local crit = GetCritChance()
                    local haste = GetHaste()
                    local mastery = GetMasteryEffect()
                    local versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)
                    -- 回蓝
                    local base, casting = GetManaRegen()
                    
                    if PlayAs==1 then
                        --"Melee DPS")
                        statuMain:SetText("|cffff3333"..Monitor(L["AttactPower"], effective))
                        statuMainDes:SetText(L["AttactPower"])
                        statu2:SetText("|cffffffcc "..Monitor(L["Crit"], crit))
                        statu2Des:SetText(L["Crit"])
                        statu3:SetText("|cff00ff00 "..Monitor(L["Haste"], haste))
                        statu3Des:SetText(L["Haste"])
                        statu4:SetText("|cff00ffff"..Monitor(L["Mastery"], mastery))
                        statu4Des:SetText(L["Mastery"])
                        statu5:SetText("|cffffff00"..Monitor(L["Versatility"], versatility))
                        statu5Des:SetText(L["Versatility"])
                        if offSpeed then
                            statu6:SetText(format("|cffffff66 %.2f/%.2f", mainSpeed, offSpeed))
                        else
                            statu6:SetText(format("|cffffff66 %.2f", mainSpeed))
                        end
                        statu6Des:SetText(L["AttackSpeed"])
                    elseif PlayAs==2 then
                        --"Cast DPS")
                        statuMain:SetText("|cffff3333"..Monitor(L["SpellPower"], sp))
                        statuMainDes:SetText(L["SpellPower"])
                        statu2:SetText("|cffffffcc "..Monitor(L["Crit"], crit))
                        statu2Des:SetText(L["Crit"])
                        statu3:SetText("|cff00ff00 "..Monitor(L["Haste"], haste))
                        statu3Des:SetText(L["Haste"])
                        statu4:SetText("|cff00ffff"..Monitor(L["Mastery"], mastery))
                        statu4Des:SetText(L["Mastery"])
                        statu5:SetText("|cffffff00"..Monitor(L["Versatility"], versatility))
                        statu5Des:SetText(L["Versatility"])
                    elseif PlayAs==3 then
                        --"Healer")
                        statuMain:SetText("|cff00ff00"..Monitor(L["SpellPower"], GetSpellBonusHealing()))
                        statuMainDes:SetText(L["SpellPower"])
                        statu2:SetText("|cffffffcc "..Monitor(L["Crit"], crit))
                        statu2Des:SetText(L["Crit"])
                        statu3:SetText("|cff00ff00 "..Monitor(L["Haste"], haste))
                        statu3Des:SetText(L["Haste"])
                        statu4:SetText("|cff00ffff"..Monitor(L["Mastery"], mastery))
                        statu4Des:SetText(L["Mastery"])
                        statu5:SetText("|cffffff00"..Monitor(L["Versatility"], versatility))
                        statu5Des:SetText(L["Versatility"])
                        statu6:SetText(format("|cff0066cc %d/%d", base*5, casting*5))
                        statu6Des:SetText(L["ManaRegen"])
                    elseif PlayAs==4 then
                        --"Tank")
                        local baseArmor , effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");
                        statuMain:SetFont(NumbFont, NumbFS*2, FontF)
                        statuMain:SetText("|cff0066cc"..Monitor(L["Armor"], effectiveArmor))
                        statuMainDes:SetText(L["Armor"])
                        statu2:SetText("|cffffffcc "..Monitor(L["Crit"], crit))
                        statu2Des:SetText(L["Crit"])
                        statu3:SetText("|cff00ff00 "..Monitor(L["Haste"], haste))
                        statu3Des:SetText(L["Haste"])
                        statu4:SetText("|cff00ffff"..Monitor(L["Mastery"], mastery))
                        statu4Des:SetText(L["Mastery"])
                        statu5:SetText("|cffffff00"..Monitor(L["Versatility"], versatility))
                        statu5Des:SetText(L["Versatility"])
                        statu6:SetText("|cffff3333"..Monitor(L["AttactPower"], effective))
                        statu6Des:SetText(L["AttactPower"])
                    elseif PlayAs==5 then
                        statuMain:SetText("|cffff3333"..effective)
                        statuMainDes:SetText(L["AttactPower"])
                        statu2:SetText("|cffffffcc "..Monitor(L["Crit"], crit))
                        statu2Des:SetText(L["Crit"])
                        statu3:SetText("|cff00ff00 "..Monitor(L["Haste"], haste))
                        statu3Des:SetText(L["Haste"])
                        statu4:SetText("|cff00ffff"..Monitor(L["Mastery"], mastery))
                        statu4Des:SetText(L["Mastery"])
                        statu5:SetText("|cffffff00"..Monitor(L["Versatility"], versatility))
                        statu5Des:SetText(L["Versatility"])
                        statu6:SetText(format("|cffffff66 %.2f", speed))
                        statu6Des:SetText(L["AttackSpeed"])
                    end
                end
                StatusSave_Default={
                    ["Point"]="CENTER", 
                    ["Relay"]="CENTER", 
                    ["Xpos"]="-260", 
                    ["Ypos"]="0", 
                    ["language"]="1", 
                    ["Scale"]="1", 
                    ["Threshold"]="0.2", 
                    ["Version"]=Version, 
                }

                local StatuFrame=CreateFrame("Frame", "StatuFrame", UIParent)
                StatuFrame:SetWidth(100)
                StatuFrame:SetHeight(60)
                StatuFrame:SetAlpha(0.2)

                --StatuFrame:SetPoint("CENTER", -260, 0)
                --StatuFrame:SetBackdrop(backdrop)
                --StatuFrame:SetBackdropColor(0, 0, 0, 1)
                StatuFrame:Show()
                StatuFrame:SetScale(1)
                statuMain=StatuFrame:CreateFontString(nil, 'OVERLAY')
                statuMain:SetFont(NameFont, NumbFS*2, FontF)
                statuMain:SetPoint('TOPRIGHT', StatuFrame, 'BOTTOMRIGHT', 10, 90)
                statuMain:SetJustifyH('RIGHT')
                statu2=StatuFrame:CreateFontString(nil, 'OVERLAY')
                statu2:SetFont(NameFont, NumbFS*1.2, FontF)
                statu2:SetPoint('TOPRIGHT', StatuFrame, 'BOTTOMRIGHT', 10, 60)
                statu2:SetJustifyH('RIGHT')
                statu3=StatuFrame:CreateFontString(nil, 'OVERLAY')
                statu3:SetFont(NameFont, NumbFS*1.2, FontF)
                statu3:SetPoint('TOPRIGHT', StatuFrame, 'BOTTOMRIGHT', 10, 45)
                statu3:SetJustifyH('RIGHT')
                statu4=StatuFrame:CreateFontString(nil, 'OVERLAY')
                statu4:SetFont(NameFont, NumbFS*1.2, FontF)
                statu4:SetPoint('TOPRIGHT', StatuFrame, 'BOTTOMRIGHT', 10, 30)
                statu4:SetJustifyH('RIGHT')
                statu5=StatuFrame:CreateFontString(nil, 'OVERLAY')
                statu5:SetFont(NameFont, NumbFS*1.2, FontF)
                statu5:SetPoint('TOPRIGHT', StatuFrame, 'BOTTOMRIGHT', 10, 15)
                statu5:SetJustifyH('RIGHT')
                statu6=StatuFrame:CreateFontString(nil, 'OVERLAY')
                statu6:SetFont(NameFont, NumbFS*1.2, FontF)
                statu6:SetPoint('TOPRIGHT', StatuFrame, 'BOTTOMRIGHT', 10, 0)
                statu6:SetJustifyH('RIGHT')
                --Describe--
                statuMainDes=StatuFrame:CreateFontString(nil, 'OVERLAY')
                statuMainDes:SetFont(NameFont, NumbFS, FontF)
                statuMainDes:SetPoint('BOTTOMLEFT', statuMain, 'BOTTOMRIGHT', 0, 5)
                statuMainDes:SetJustifyH('LEFT')
                statu2Des=StatuFrame:CreateFontString(nil, 'OVERLAY')
                statu2Des:SetFont(NameFont, NumbFS*0.8, FontF)
                statu2Des:SetPoint('BOTTOMLEFT', statu2, 'BOTTOMRIGHT', 0, 0)
                statu2Des:SetJustifyH('LEFT')
                statu3Des=StatuFrame:CreateFontString(nil, 'OVERLAY')
                statu3Des:SetFont(NameFont, NumbFS*1, FontF)
                statu3Des:SetPoint('BOTTOMLEFT', statu3, 'BOTTOMRIGHT', 0, 0)
                statu3Des:SetJustifyH('LEFT')
                statu4Des=StatuFrame:CreateFontString(nil, 'OVERLAY')
                statu4Des:SetFont(NameFont, NumbFS*1, FontF)
                statu4Des:SetPoint('BOTTOMLEFT', statu4, 'BOTTOMRIGHT', 0, 0)
                statu4Des:SetJustifyH('LEFT')
                statu5Des=StatuFrame:CreateFontString(nil, 'OVERLAY')
                statu5Des:SetFont(NameFont, NumbFS*1, FontF)
                statu5Des:SetPoint('BOTTOMLEFT', statu5, 'BOTTOMRIGHT', 0, 0)
                statu5Des:SetJustifyH('LEFT')
                statu6Des=StatuFrame:CreateFontString(nil, 'OVERLAY')
                statu6Des:SetFont(NameFont, NumbFS*1, FontF)
                statu6Des:SetPoint('BOTTOMLEFT', statu6, 'BOTTOMRIGHT', 0, 0)
                statu6Des:SetJustifyH('LEFT')
                --StatuFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", GetCurrentInfo())
                --StatuFrame:RegisterEvent("PLAYER_TALENT_UPDATE", GetCurrentInfo())
                StatuFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
                StatuFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
                StatuFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
                StatuFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
                StatuFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
                StatuFrame:RegisterEvent("ADDON_LOADED")
                StatuFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
                StatuFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
                --StatuFrame:RegisterEvent("UNIT_AURA")
                StatuFrame:SetScript("OnEvent", function(self, event)
                    if  event=="UNIT_AURA" or event == "PLAYER_ENTERING_WORLD"then
                        if  not StatusSave or not StatusSave["Version"] or StatusSave["Version"]~= Version then 
                            StatusSave=StatusSave_Default; 
                            for i =1, 5 do
                                StatusSave[i]={}
                                for j = 1, 5 do
                                    StatusSave[i][j]=1;
                                end
                            end
                        end
                        GetCurrentInfo()
                    elseif event=="ACTIVE_TALENT_GROUP_CHANGED" or event=="PLAYER_TALENT_UPDATE"or event=="PLAYER_EQUIPMENT_CHANGED" or event=="UPDATE_SHAPESHIFT_FORM"   then

                        for k, v in pairs(StandardValue) do
                            StandardValue[k]=0
                        end
                        GetCurrentInfo()
                        FreshStatuLine()

                    elseif event=="PLAYER_REGEN_DISABLED" then
                        UIFrameFadeOut(StatuFrame, 1, 0.2, 0.8)
                    elseif event=="PLAYER_REGEN_ENABLED" then
                        UIFrameFadeOut(StatuFrame, 1, 0.8, 0.2)
                    elseif event=="ADDON_LOADED" then
                        if  not StatusSave or not StatusSave["Version"] or StatusSave["Version"]~= Version then 
                            StatusSave=StatusSave_Default; 
                            for i =1, 5 do
                                StatusSave[i]={}
                                for j = 1, 5 do
                                    StatusSave[i][j]=1;
                                end
                            end
                        end
                        StatuPoint=StatusSave["Point"]
                        StatuRelay=StatusSave["Relay"]
                        StatuX=StatusSave["Xpos"]
                        StatuY=StatusSave["Ypos"]
                        Lang=StatusSave["language"]
                        FrameScale=StatusSave["Scale"]
                        Threshold=StatusSave["Threshold"]
                        if Lang=="1" then
                            L=enUS
                        elseif Lang=="2" then
                            L=zhCN
                        elseif Lang=="3" then
                            L=zhTW
                        else L=enUS
                            --GetCurrentInfo()
                        end
                        --print(StatuPoint, StatuRelay, StatuX, StatuY)
                        StatuFrame:SetPoint(StatuPoint, nil, StatuRelay, StatuX, StatuY)
                        StatuFrame:SetScale(FrameScale)
                        StatuFrame:Show()
                    end
                end);
                local TimeSinceLastUpdate=0;
                local f = CreateFrame("frame", nil, UIParent); 
                f:SetScript("OnUpdate", function(self, elapsed)
                    TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
                    if (TimeSinceLastUpdate > 0.5) then
                        if tnumTabs==0 then GetCurrentInfo() end
                        updateStatu(PlayAs or 1)
                        TimeSinceLastUpdate = 0;
                    end
                end);
                --GetCurrentInfo()
                SLASH_STATUSMOVE1 = "/status"
                SlashCmdList["STATUSMOVE"] = function(msg)

                    msg = strtrim(msg or "")
                    if msg=="1" then
                        L=enUS
                        StatusSave["language"]="1"
                    elseif msg=="2" then
                        L=zhCN
                        StatusSave["language"]="2"
                    elseif msg=="3" then
                        L=zhTW
                        StatusSave["language"]="3"
                    elseif msg=="config"  then
                        if (not Status_ConfigDialog) then ConfigDialog() end Status_ConfigDialog:Show()  FreshOptionDialog() 
                    else
                        if StatusToggle then


                            StatuPoint, relativeTo, StatuRelay, StatuX, StatuY	=StatuFrame:GetPoint()
                            StatusSave["Point"]=StatuPoint
                            StatusSave["Relay"]=StatuRelay
                            StatusSave["Xpos"]=StatuX
                            StatusSave["Ypos"]=StatuY
                            StatusSave["Scale"]=FrameScale
                            StatuFrame:EnableMouse(false)
                            StatuFrame:SetMovable(false)
                            StatuFrame:SetBackdropColor(0, 0, 0, 0)
                            UIFrameFadeOut(StatuFrame, 1, 0.8, 0.2)
                            StatusToggle=false
                            StatuFrame:EnableMouseWheel(false);
                            StatuFrame:SetScript("OnMouseWheel", nil);
                        else

                            StatuFrame:EnableMouse(true)
                            StatuFrame:SetMovable(true)
                            StatuFrame:SetBackdrop(backdrop)
                            StatuFrame:SetBackdropColor(0, 0, 0, 1)
                            UIFrameFadeOut(StatuFrame, 1, 0.2, 1)
                            StatuFrame:SetScript("OnMouseDown", StatuFrame.StartMoving)
                            StatuFrame:SetScript("OnMouseUp", StatuFrame.StopMovingOrSizing)
                            StatusToggle=true
                            StatuFrame:EnableMouseWheel();
                            StatuFrame:SetScript("OnMouseWheel", function(self, direction)
                                if(direction > 0) then
                                    FrameScale=FrameScale+0.05
                                    StatuFrame:SetScale(FrameScale)
                                else
                                    FrameScale=FrameScale-0.05
                                    StatuFrame:SetScale(FrameScale)
                                end
                            end);
                        end
                    end
                end

                function FreshOptionDialog()

                    for i=1, 5 do
                        if i == 1 then
                            getglobal("OptionsButton"..i).Des:SetText(statuMainDes:GetText())
                            getglobal("OptionsButton"..i):SetPoint("TOPLEFT", Status_ConfigDialog, "TOPLEFT", 20, -40)
                            getglobal("OptionsButton"..i):SetChecked(statuMainDes:GetAlpha())
                        else
                            getglobal("OptionsButton"..i).Des:SetText(getglobal("statu"..i.."Des"):GetText())
                            getglobal("OptionsButton"..i):SetPoint("TOP", getglobal("OptionsButton"..(i-1)), "BOTTOM", 0, 0)
                            getglobal("OptionsButton"..i):SetChecked(getglobal("statu"..i.."Des"):GetAlpha())
                        end
                    end
                end
                function FreshStatuLine()
                    --print(PlayAs)
                    --print(StatusSave[PlayAs][1])

                    statuMain:SetAlpha(tonumber(StatusSave[PlayAs][1]) or 1)
                    for i =2, 6 do
                        getglobal("statu"..i):SetAlpha(tonumber(StatusSave[PlayAs][i]) or 1)
                        getglobal("statu"..i.."Des"):SetAlpha(tonumber(StatusSave[PlayAs][i]) or 1)
                    end
                end
                function ConfigDialog()
                    local optionsframe = CreateFrame("frame", "DCP_OptionsFrame", UIParent)
                    optionsframe:SetBackdrop({
                        bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", 
                        edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", 
                        tile=1, tileSize=32, edgeSize=32, 
                        insets={left=11, right=12, top=12, bottom=11}
                    })
                    optionsframe:SetWidth(300)
                    optionsframe:SetHeight(300)
                    optionsframe:SetPoint("CENTER", UIParent)
                    optionsframe:EnableMouse(true)
                    optionsframe:SetMovable(true)
                    optionsframe:RegisterForDrag("LeftButton")
                    optionsframe:SetScript("OnDragStart", function(self) self:StartMoving() end)
                    optionsframe:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
                    optionsframe:SetFrameStrata("FULLSCREEN_DIALOG")
                    -- optionsframe:SetScript("OnHide", function() RefreshLocals() end)
                    --tinsert(UISpecialFrames, "DCP_OptionsFrame")
                    Status_ConfigDialog=optionsframe
                    local header = optionsframe:CreateTexture(nil, "ARTWORK")
                    header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header.blp")
                    header:SetWidth(350)
                    header:SetHeight(68)
                    header:SetPoint("TOP", optionsframe, "TOP", 0, 12)

                    local headertext = optionsframe:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                    headertext:SetPoint("TOP", header, "TOP", 0, -14)
                    headertext:SetText("StatusInfo Settings")
                    local buttonOK = CreateFrame("Button", "optionsframeButton", optionsframe, "UIPanelButtonTemplate")
                    buttonOK:SetWidth(75)
                    buttonOK:SetHeight(30)
                    buttonOK:SetPoint("BOTTOM", 0, 15)
                    buttonOK:SetText(L["OK"])
                    buttonOK:SetScript("OnClick", function(self)
                        FreshStatuLine()
                        optionsframe:Hide()
                    end)

                    local slider = CreateFrame("slider", "optionsFrameSlider", optionsframe, "OptionsSliderTemplate")
                    slider:SetMinMaxValues(0.5, 1.5)
                    slider:SetValueStep(0.05)
                    slider:SetPoint("BOTTOM", buttonOK, "TOP")
                    local valuetext = slider:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
                    valuetext:SetPoint("BOTTOM", slider, "TOP", 0, 1)
                    valuetext:SetText(format("Scale:%.2f", StatusSave["Scale"]))
                    slider:SetValue(StatusSave["Scale"])
                    slider:SetScript("OnValueChanged", function() 
                        local val=slider:GetValue()
                        valuetext:SetText(format("Scale:%.2f", val)) 
                        StatusSave["Scale"]=val
                        StatuFrame:SetScale(val)
                    end)

                    local slider2 = CreateFrame("slider", "optionsFrameSlider2", optionsframe, "OptionsSliderTemplate")
                    slider2:SetMinMaxValues(0.1, 0.5)
                    slider2:SetValueStep(0.05)
                    slider2:SetPoint("BOTTOM", slider, "TOP", 0, 20)
                    local valuetext = slider2:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
                    valuetext:SetPoint("BOTTOM", slider2, "TOP", 0, 1)
                    if not StatusSave["Threshold"] then StatusSave["Threshold"]=0.2 end
                    valuetext:SetText(format("%s:%.2f", L["Threshold"], StatusSave["Threshold"]))
                    slider2:SetValue(StatusSave["Threshold"])
                    slider2:SetScript("OnValueChanged", function() 
                        local val=slider2:GetValue()
                        valuetext:SetText(format("%s:%.2f", L["Threshold"], val))
                        StatusSave["Threshold"]=val
                        Threshold=val
                    end)


                    for i=1, 5 do
                        Options=CreateFrame("CHECKBUTTON", "OptionsButton"..i, optionsframe, "OptionsCheckButtonTemplate")
                        Des =  Options:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                        Des:SetPoint("LEFT", Options, "RIGHT")
                        getglobal("OptionsButton"..i).Des=Des
                        getglobal("OptionsButton"..i):SetScript("OnClick", function(self)
                            if not StatusSave[PlayAs] then StatusSave[PlayAs]={} end
                            if getglobal("OptionsButton"..i):GetChecked() == 1 then
                                --print("StatusSave[", PlayAs, i, "]=1")
                                StatusSave[PlayAs][i]=1;
                            else
                                --print("StatusSave[", PlayAs, i, "]=0")
                                StatusSave[PlayAs][i]=0;
                            end
                            FreshStatuLine()
                        end)
                        if i == 1 then
                            Des:SetText(statuMainDes:GetText())
                            Options:SetPoint("TOPLEFT", optionsframe, "TOPLEFT", 20, -40)
                            Options:SetChecked(statuMainDes:GetAlpha())
                        else
                            Des:SetText(getglobal("statu"..i.."Des"):GetText())
                            Options:SetPoint("TOP", getglobal("OptionsButton"..(i-1)), "BOTTOM", 0, 0)
                            Options:SetChecked(getglobal("statu"..i.."Des"):GetAlpha())
                        end
                    end

                end
