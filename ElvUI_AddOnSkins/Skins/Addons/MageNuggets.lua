local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack

-- MageNuggets 2.39

local function LoadSkin()
	if not E.private.addOnSkins.MageNuggets then return end

	local function HandleFrame(frame, icon, bar, text, textSize, text2, text2Size)
		frame:SetTemplate()
		frame:SetClampedToScreen(true)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()
		icon:SetDrawLayer("ARTWORK")

		if bar then
			bar:CreateBackdrop()
			bar:SetStatusBarTexture(E.media.normTex)
			bar:Width(34 - E.Spacing * 2)
			bar:Point("TOP", frame, "BOTTOM", 0, -E.Spacing*3)
			E:RegisterStatusBar(bar)
		end

		if text then
			local fontSize = textSize or 12

			text:FontTemplate(nil, fontSize)
		end

		if text2 then
			local fontSize = text2Size or 12

			text2:FontTemplate(nil, fontSize)
			text2:ClearAllPoints()
			text2:Point("CENTER", bar, "CENTER", 0, -11)
		end
	end

	HandleFrame(MNTorment_Frame, MNTorment_FrameTexture)
	HandleFrame(MNPyromaniac_Frame, MNPyromaniac_FrameTexture)
	HandleFrame(MNimpGem_Frame, MNimpGem_FrameTexture)
	HandleFrame(MNicyveins_Frame, MNicyveins_FrameTexture, nil, MNicyveins_FrameText)
	HandleFrame(MNcombust_Frame, MNcombust_FrameTexture, nil, MNcombust_FrameText)
	HandleFrame(MNcritMass_Frame, MNcritMass_FrameTexture, nil, MNcritMass_FrameText)
	HandleFrame(MNarcanepower_Frame, MNarcanepower_FrameTexture, nil, MNarcanepower_FrameText)
	HandleFrame(MNlust_Frame, MNlust_FrameTexture, nil, MNlust_FrameText)
	HandleFrame(MNmoonFire_Frame, MNmoonFire_FrameTexture, nil, MNmoonFire_FrameText)
	HandleFrame(MNinsectSwarm_Frame, MNinsectSwarm_FrameTexture, nil, MNinsectSwarm_FrameText)
	HandleFrame(MNstarSurge_Frame, MNstarSurge_FrameTexture, nil, MNstarSurge_FrameText)
	HandleFrame(MageNugLB_Frame, MageNugLB_FrameTexture, nil, MageNugLB_Frame_Text, 20)
	HandleFrame(MageNugClearcast_Frame, MageNugClearcast_FrameTexture, MageNugClearcast_Frame_Bar, nil, nil, MageNugClearcast_FrameText2)
	HandleFrame(MageNugIgnite_Frame, MageNugIgnite_FrameTexture, MageNugIgnite_Frame_Bar, MageNugIgnite_FrameText, 20, MageNugIgnite_FrameText2)
	HandleFrame(MageNugManaGem_Frame, MageNugManaGem_FrameTexture, MageNugManaGem_Frame_Bar, MageNugManaGem_Frame_Text, 20, MageNugManaGem_Frame_Text2)
	HandleFrame(MageNugAB_Frame, MageNugAB_FrameTexture, MageNugAB_Frame_ABBar, MageNugAB_FrameText, 20, MageNugAB_FrameText2)

	MageNugPolyFrame:SetBackdrop(nil)
	MageNugPolyFrame:CreateBackdrop()
	MageNugPolyFrame.backdrop:SetOutside(MageNugPolyFrameTexture)
	MageNugPolyFrame:SetClampedToScreen(true)
	MageNugPolyFrameTexture:SetTexCoord(unpack(E.TexCoords))
	MageNugPolyFrameTexture:Size(26)
	MageNugPolyFrame_Bar:CreateBackdrop()
	MageNugPolyFrame_Bar:SetStatusBarTexture(E.media.normTex)
	MageNugPolyFrame_Bar:ClearAllPoints()
	MageNugPolyFrame_Bar:Point("LEFT", MageNugPolyFrame.backdrop, "RIGHT", E.Spacing * 3, -11)
	MageNugPolyFrameText:FontTemplate(nil, 14)
	MageNugPolyFrameTimerText:FontTemplate(nil, 12)

	MageNugMI_Frame:CreateBackdrop()
	MageNugMI_Frame.backdrop:SetOutside(MageNugMI_FrameTexture1)
	MageNugMI_Frame:SetClampedToScreen(true)
	MageNugMI_FrameTexture1:SetTexCoord(unpack(E.TexCoords))
	MageNugMI_Frame_MiBar:CreateBackdrop()
	MageNugMI_Frame_MiBar:SetStatusBarTexture(E.media.normTex)
	MageNugMI_Frame_MiBar:Point("LEFT", MageNugMI_Frame.backdrop, "RIGHT", E.Spacing * 3, 0)
	E:RegisterStatusBar(MageNugMI_Frame_MiBar)
	MageNugMI_Frame_MIText:FontTemplate(nil, 12)
	MageNugMI_Frame_MIText1:FontTemplate(nil, 12)
	MageNugMI_Frame_MIText1:SetTextColor(1, 1, 1)

	MageNugWE_Frame:CreateBackdrop()
	MageNugWE_Frame.backdrop:SetOutside(MageNugWE_FrameTexture1)
	MageNugWE_Frame:SetClampedToScreen(true)
	MageNugWE_FrameTexture1:SetTexCoord(unpack(E.TexCoords))
	MageNugWE_Frame_WeBar:CreateBackdrop()
	MageNugWE_Frame_WeBar:SetStatusBarTexture(E.media.normTex)
	MageNugWE_Frame_WeBar:Point("LEFT", MageNugWE_Frame.backdrop, "RIGHT", E.Spacing * 3, 0)
	E:RegisterStatusBar(MageNugWE_Frame_WeBar)
	MageNugWE_Frame_MIText:FontTemplate()
	MageNugWE_Frame_WEText1:FontTemplate()

	MageNugCauterize_Frame:CreateBackdrop()
	MageNugCauterize_Frame.backdrop:SetOutside(MageNugCauterize_FrameTexture1)
	MageNugCauterize_Frame:SetClampedToScreen(true)
	MageNugCauterize_FrameTexture1:SetTexCoord(unpack(E.TexCoords))
	MageNugCauterize_Frame_Bar:CreateBackdrop()
	MageNugCauterize_Frame_Bar:SetStatusBarTexture(E.media.normTex)
	MageNugCauterize_Frame_Bar:Point("LEFT", MageNugCauterize_Frame.backdrop, "RIGHT", E.Spacing * 3, 0)
	E:RegisterStatusBar(MageNugCauterize_Frame_Bar)
	MageNugCauterize_Frame_Text:FontTemplate(nil, 12)
	MageNugCauterize_Frame_Text1:FontTemplate(nil, 12)
	MageNugCauterize_Frame_Text1:SetTextColor(1, 1, 1)

	MageNugSP_Frame:SetTemplate("Transparent")
	MageNugSP_Frame:SetClampedToScreen(true)
	MageNugSP_Frame:Size(85, 80)
	MageNugSP_FrameText:FontTemplate(nil, 12)
	S:HandleButton(MageNugSP_FrameButtonShowOptions)
	MageNugSP_FrameButtonShowOptions:Size(6)

	MNabCast_Frame:StripTextures()
	MNabCast_Frame:SetClampedToScreen(true)
	MNabCast_Frame:Point("BOTTOM", MageNugAB_Frame, "TOP", 0, E.Spacing)
	MNabCast_FrameText:FontTemplate(nil, 12)

	MageNugCauterizeFrame:SetTemplate("Transparent")
	MageNugCauterizeFrame:SetClampedToScreen(true)
	MageNugCauterizeFrameTexture:SetTexCoord(unpack(E.TexCoords))

	-- Spellsteal
	MNSpellSteal_Frame:SetTemplate("Transparent")
	MNSpellSteal_Frame:Width(175)
	MNSpellSteal_Frame:SetClampedToScreen(true)
	MNSpellSteal_FrameTitleText:FontTemplate()
	MNSpellSteal_FrameBuffText:FontTemplate()

	-- Focus Spellsteal
	MNSpellStealFocus_Frame:SetTemplate("Transparent")
	MNSpellStealFocus_Frame:Width(175)
	MNSpellStealFocus_Frame:SetClampedToScreen(true)
	MNSpellStealFocus_FrameTitleText:FontTemplate()
	MNSpellStealFocus_FrameBuffText:FontTemplate()

	-- LB Frames
	for i = 1, 4 do
		local frame = _G["MageNugLB"..i.."_Frame"]
		local bar = _G["MageNugLB"..i.."_Frame_Bar"]
		local text = _G["MageNugLB"..i.."_Frame_Text"] 
		local text2 = _G["MageNugLB"..i.."_Frame_Text2"]

		frame:SetBackdrop(nil)
		frame:ClearAllPoints()
		frame:SetClampedToScreen(true)

		bar:CreateBackdrop()
		bar:SetStatusBarTexture(E.media.normTex)

		text:FontTemplate()
		text:SetDrawLayer("OVERLAY", 8)

		text2:SetDrawLayer("OVERLAY", 8)
		text2:FontTemplate()
	end

	MageNugLB1_Frame:Point("BOTTOMLEFT", MageNugLB_Frame, "BOTTOMRIGHT", 6, -1)
	MageNugLB2_Frame:Point("BOTTOM", MageNugLB1_Frame, "TOP", 0, 4)
	MageNugLB3_Frame:Point("BOTTOM", MageNugLB2_Frame, "TOP", 0, 4)
	MageNugLB4_Frame:Point("BOTTOM", MageNugLB3_Frame, "TOP", 0, 4)

	-- CD Frames
	for i = 1, 6 do
		local frame = _G["MageNugCD"..i.."_Frame"]
		local bar = _G["MageNugCD"..i.."_Frame_Bar"]
		local icon = _G["MageNugCD"..i.."_Frame_Texture"]
		local text = _G["MageNugCD"..i.."_Frame_Text"]
		local text2 = _G["MageNugCD"..i.."_Frame_Text2"]

		frame:CreateBackdrop()
		frame.backdrop:SetOutside(icon)
		frame:ClearAllPoints()
		frame:SetClampedToScreen(true)

		icon:SetTexCoord(unpack(E.TexCoords))

		bar:CreateBackdrop()
		bar.backdrop:SetOutside()
		bar:Point("LEFT", frame.backdrop, "RIGHT", E.Spacing*3, 0)
		bar:SetStatusBarTexture(E.media.normTex)
		E:RegisterStatusBar(bar)

		text:FontTemplate(nil, 12, "OUTLINE")

		text2:FontTemplate(nil, 12, "OUTLINE")
	end

	MageNugCD1_Frame:Point("BOTTOMLEFT", MageNugCD_Frame, "BOTTOMRIGHT", 6, -1)
	MageNugCD2_Frame:Point("BOTTOM", MageNugCD1_Frame, "TOP", 0, 4)
	MageNugCD3_Frame:Point("BOTTOM", MageNugCD2_Frame, "TOP", 0, 4)
	MageNugCD4_Frame:Point("BOTTOM", MageNugCD3_Frame, "TOP", 0, 4)

	-- Proc Frames
	local procFrames = {"MageNugProcFrame", "MageNugImpactProcFrame", "MageNugBFProcFrame", "MageNugMBProcFrame", "MageNugFoFProcFrame"}
	for _, frame in pairs(procFrames) do
		local Frame = _G[frame]
		local Icon = _G[frame.."Texture"]
		local Bar = _G[frame.."_ProcBar"]
		local Text = _G[frame.."Text"]
		local Text2 = _G[frame.."Text2"]

		Frame:SetBackdrop(nil)
		Frame:CreateBackdrop()
		Frame.backdrop:SetOutside(Icon)
		Frame:SetClampedToScreen(true)

		Icon:SetTexCoord(unpack(E.TexCoords))

		Bar:CreateBackdrop()
		Bar:Size(120, 10)
		Bar:SetStatusBarTexture(E.media.normTex)
		Bar:Point("LEFT", Frame.backdrop, "RIGHT", E.Spacing*3, 0)
		E:RegisterStatusBar(Bar)

		Text:FontTemplate(nil, 12, "OUTLINE")

		Text2:FontTemplate(nil, 10, "OUTLINE")
		Text2:Point("BOTTOMRIGHT", Bar, 0, 0)
		Text2:SetParent(Bar)
	end

	-- Horde Frame
	MageNugHordeFrame:SetTemplate("Transparent")
	MageNugHordeFrame:SetFrameLevel(35)
	MageNugHordeFrame:SetClampedToScreen(true)

	MageNugHordeFrameText:FontTemplate()
	MageNugHordeFrameText2:Point("TOP", 0, -6)

	MageNugHordeFrameText2:FontTemplate()
	MageNugHordeFrameText2:Point("TOP", 0, -47)

	S:HandleButton(MageNugHordeFrameClose)
	S:HandleButton(MageNugHordeFrameShowOptions)

	local hordeButtons = {"PortDal", "PortShat", "PortOrg", "PortUC", "PortTB", "PortSMC", "PortStonard", "PortTol", "TeleDal", "TeleShat", "TeleOrg", "TeleUC", "TeleTB", "TeleSMC", "TeleStonard", "TeleTol", "Hearth"}
	for _, frame in pairs(hordeButtons) do
		local button = _G["MageNugHordeFrame"..frame]
		local icon = _G["MageNugHordeFrame"..frame.."TelDalTexture"]

		button:SetTemplate()
		button:StyleButton()
		button:CreateBackdrop()
		button.backdrop:SetOutside(icon)

		icon:SetDrawLayer("ARTWORK")
		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()
	end

	-- Alliance Frame
	MageNugAlliFrame:SetTemplate("Transparent")
	MageNugAlliFrame:SetFrameLevel(35)
	MageNugAlliFrame:SetClampedToScreen(true)

	MageNugAlliFrameText:FontTemplate()
	MageNugAlliFrameText:Point("TOP", 0, -6)

	MageNugAlliFrameText2:FontTemplate()
	MageNugAlliFrameText2:Point("TOP", 0, -47)

	S:HandleButton(MageNugAlliFrameClose)
	S:HandleButton(MageNugAlliFrameShowOptions)

	local alliButtons = {"PortDal", "PortShat", "PortIF", "PortSW", "PortDarn", "PortExo", "PortTheramore", "PortTol", "TeleDal", "TeleShat", "TeleIF", "TeleSW", "TeleDarn", "TeleExo", "TeleTheramore", "TeleTol", "Hearth"}
	for _, frame in pairs(alliButtons) do
		local button = _G["MageNugAlliFrame"..frame]
		local icon = _G["MageNugAlliFrame"..frame.."TelDalTexture"]

		button:SetTemplate()
		button:StyleButton()
		button:CreateBackdrop()
		button.backdrop:SetOutside(icon)

		icon:SetDrawLayer("ARTWORK")
		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()
	end

	-- Options
	S:HandleButton(MageNugStatMonOptionFrameBlackBackdropButton)
	S:HandleButton(MageNugMoonkinOptionFrame_Button)
	S:HandleButton(MageNugOption2FrameButton1)
	S:HandleButton(MageNugOption2FrameButton2)

	local nugEditBox = {
		"SlowFallMsgEditBox",
		"SlowFallMsgEditBox2",
		"SlowFallMsgEditBox3",
		"FocMagNotifyEditBox",
		"FocMagNotifyEditBox2",
		"FocMagNotifyEditBox3",
		"FocMagThankEditBox",
		"FocMagThankEditBox2",
		"InnervThankEditBox",
		"InnervThankEditBox2",
		"PowerInfusionEditBox",
		"DarkIntentEditBox",
		"MageNugSoundOptionFrame_MISoundEditBox",
		"MageNugSoundOptionFrame_ProcSoundEditBox",
		"MageNugSoundOptionFrame_PolySoundEditBox",
		"MageNugSoundOptionFrame_HotStreakSoundEditBox",
		"MageNugSoundOptionFrame_ImpactSoundEditBox",
		"MageNugSoundOptionFrame_FoFSoundEditBox",
		"MageNugSoundOptionFrame_BrainFreezeSoundEditBox",
		"MageNugSoundOptionFrame_CauterizeSoundEditBox",
		"MageNugSoundOptionFrame_TimeWarpSoundEditBox",
		"MageNugPriestOptionFrame_EditBox3",
		"MageNugPriestOptionFrame_EditBox2",
		"MageNugPriestOptionFrame_EditBox1",
		"MageNugMoonkinOptionFrame_SoundEditBox",
		"MageNugMoonkinOptionFrame_InnervateEditBox"
	}

	for i = 1, #nugEditBox do
		local box = _G[nugEditBox[i]]

		S:HandleEditBox(box)
		box:Size(200, 20)
	end

	local nugSliders = {
		"MageNugOptionsFrame_Slider1",
		"MageNugOptionsFrame_Slider2",
		"MageNugOptionsFrame_Slider3",
		"MageNugOptionsFrame_Slider4",
		"MageNugOptionsFrame_Slider5",
		"MageNugStatMonOptionFrame_SPSizeSlider",
		"MageNugStatMonOptionFrame_BorderSlider",
		"MageNugStatMonOptionFrame_TransparencySlider",
		"MageNugMoonkinOptionFrame_Slider",
		"MageNugMoonkinOptionFrame_Slider1",
		"MageNugCooldownFrame_Slider1"
	}

	for i = 1, #nugSliders do
		S:HandleSliderFrame(_G[nugSliders[i]])
	end

	local nugCheckBox = {
		"MageNugOptionsFrame_CheckButton2",
		"MageNugOptionsFrame_CheckButton3",
		"MageNugOptionsFrame_CheckButton6",
		"MageNugOptionsFrame_CheckButton7",
		"MageNugOptionsFrame_CheckButton8",
		"MageNugOptionsFrame_CheckButton9",
		"MageNugOptionsFrame_CheckButton11",
		"MageNugOptionsFrame_CheckButton13",
		"MageNugOptionsFrame_CheckButton14",
		"CauterizeCheckButton",
		"MageNugOptionsFrame_CheckButtonCC",
		"MageNugOptionsFrame_CheckButtonMG",
		"MageNugOptionsFrame_CheckButtonMGcombat",
		"MageNugOptionsFrame_IgniteCheckButton",
		"MageNugOptionsFrame_ABcastCheckButton",
		"MageNugStatMonOptionFrame_CheckButton0",
		"MageNugStatMonOptionFrame_CheckButton1",
		"MageNugStatMonOptionFrame_CheckButton2",
		"MageNugMsgOptionFrame_CheckButton",
		"MageNugMsgOptionFrame_CheckButton2",
		"MageNugMsgOptionFrame_CheckButton3",
		"MageNugMsgOptionFrame_CheckButton4",
		"MageNugMsgOptionFrame_CheckButton5",
		"MageNugMsgOptionFrame_CheckButton6",
		"MageNugSoundOptionFrame_MICheckButton",
		"MageNugSoundOptionFrame_ProcCheckButton",
		"MageNugSoundOptionFrame_PolyCheckButton",
		"MageNugSoundOptionFrame_HotStreakCheckButton",
		"MageNugSoundOptionFrame_ImpactCheckButton",
		"MageNugSoundOptionFrame_FoFCheckButton",
		"MageNugSoundOptionFrame_BrainFreezeCheckButton",
		"MageNugSoundOptionFrame_CauterizeCheckButton",
		"MageNugSoundOptionFrame_TimeWarpCheckButton",
		"MageNugPriestOptionFrame_CheckButton3",
		"MageNugPriestOptionFrame_CheckButton2",
		"MageNugPriestOptionFrame_CheckButton0",
		"MageNugMoonkinOptionFrame_CheckButton",
		"MageNugMoonkinOptionFrame_CheckButton0",
		"MageNugMoonkinOptionFrame_CheckButton1",
		"MageNugMoonkinOptionFrame_CheckButton2",
		"MageNugMoonkinOptionFrame_CheckButton3",
		"MageNugMoonkinOptionFrame_CheckButtonMin",
		"MageNugMoonkinOptionFrame_ProcCheckButton",
		"MageNugMoonkinOptionFrame_CastCheckButton",
		"MageNugMoonkinOptionFrame_CheckButtonAnchor",
		"MageNugOption2Frame_MinimapCheckButton",
		"MageNugOption2Frame_CameraCheckButton",
		"MageNugOption2Frame_ConsoleTextCheckButton",
		"MageNugOption2Frame_LockFramesCheckButton",
		"MageNugOption2Frame_CheckButtonTT",
		"MageNugOption2Frame_ClickThruCheckButton",
		"MageNugCooldownFrame_apButton",
		"MageNugCooldownFrame_bwButton",
		"MageNugCooldownFrame_cbButton",
		"MageNugCooldownFrame_csButton",
		"MageNugCooldownFrame_dfButton",
		"MageNugCooldownFrame_dbButton",
		"MageNugCooldownFrame_mwButton",
		"MageNugCooldownFrame_frzButton",
		"MageNugCooldownFrame_msButton",
		"MageNugCooldownFrame_ibrButton",
		"MageNugCooldownFrame_evoButton",
		"MageNugCooldownFrame_ivButton",
		"MageNugCooldownFrame_cdButton",
		"MageNugCooldownFrame_starfallButton",
		"MageNugCooldownFrame_treantButton",
		"MageNugCooldownFrame_miButton"
	}

	for i = 1, #nugCheckBox do
		S:HandleCheckBox(_G[nugCheckBox[i]])
	end
end

S:AddCallbackForAddon("MageNuggets", "MageNuggets", LoadSkin)