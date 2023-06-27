local E, L, V, P, G = unpack(ElvUI)
local FC = E:NewModule("Enhanced_FogClear", "AceHook-3.0")

local _G = _G
local pairs = pairs
local ceil, fmod, floor = math.ceil, math.fmod, math.floor
local format, len, lower, sub = string.format, string.len, string.lower, string.sub
local tinsert, twipe = table.insert, table.wipe

local GetMapInfo = GetMapInfo
local GetMapOverlayInfo = GetMapOverlayInfo
local GetNumMapOverlays = GetNumMapOverlays

local worldMapCache = {}
local discoveredOverlays = {}

local errata = {
	-- Eastern Kingdoms
	["Arathi"] = {
		["NorthfoldManor"] = 112881578211,
		["CircleofInnerBinding"] = 335218445540,
		["BoulderfistHall"] = 394406398204,
		["FaldirsCove"] = 429577744657,
		["GoShekFarm"] = 267812856114,
		["DabyriesFarmstead"] = 155042680018,
		["StromgardeKeep"] = 288858884380,
		["RefugePoint"] = 156000073924,
		["CirecleofOuterBinding"] = 293479837911,
		["CircleofWestBinding"] = 25859226844,
		["ThandolSpan"] = 446950535405,
		["WitherbarkVillage"] = 385972662532,
		["CircleofEastBinding"] = 135822293175,
		["Hammerfall"] = 127311035662,
		["GalensFall"] = 154619135188,
		["Bouldergor"] = 132249835769,
	},
	["Badlands"] = {
		["DeathwingScar"] = 191309866312,
		["CampCagg"] = 301721808211,
		["AgmondsEnd"] = 338470208854,
		["Uldaman"] = 352536842,
		["CampKosh"] = 20929843436,
		["HammertoesDigsite"] = 124985217233,
		["ApocryphansRest"] = 70867322108,
		["AngorFortress"] = 73255845149,
		["CampBoff"] = 236650430738,
		["LethlorRavine"] = 59615319509,
		["TheDustbowl"] = 106451727574,
	},
	["BlastedLands"] = {
		["RiseoftheDefiler"] = 109915056296,
		["TheRedReaches"] = 288322062604,
		["DreadmaulPost"] = 195764089067,
		["TheTaintedScar"] = 188056045876,
		["NethergardeSupplyCamps"] = 457383107,
		["DreadmaulHold"] = 270743824,
		["Shattershore"] = 98316859632,
		["Surwich"] = 509302996167,
		["SunveilExcursion"] = 401984465129,
		["TheDarkPortal"] = 192585967986,
		["SerpentsCoil"] = 104634440922,
		["AltarofStorms"] = 118347730158,
		["NethergardeKeep"] = 6998406439,
		["TheTaintedForest"] = 334072485212,
	},
	["BurningSteppes"] = {
		["MorgansVigil"] = 274449462655,
		["DreadmaulRock"] = 162730876178,
		["Dracodar"] = 254477253994,
		["BlackrockStronghold"] = 246809920,
		["AltarofStorms"] = 368822,
		["BlackrockPass"] = 277465164074,
		["RuinsofThaurissan"] = 441813316,
		["BlackrockMountain"] = 83235097,
		["PillarofAsh"] = 274069878034,
		["TerrorWingPath"] = 8193922398,
	},
	["DeadwindPass"] = {
		["TheVice"] = 223792792926,
		["DeadmansCrossing"] = 87566953,
		["Karazhan"] = 332956801537,
	},
	["DunMorogh"] = {
		["NorthGateOutpost"] = 46973434093,
		["IronforgeAirfield"] = 660946228,
		["HelmsBedLake"] = 288559966426,
		["ShimmerRidge"] = 142150445227,
		["TheGrizzledDen"] = 308556234963,
		["Ironforge"] = 417688952,
		["ColdridgeValley"] = 393094674830,
		["TheShimmeringDeep"] = 142150445227,
		["ColdridgePass"] = 365449990369,
		["TheTundridHills"] = 329172378798,
		["Gnomeregan"] = 28991355289,
		["IceFlowLake"] = 276142316,
		["FrostmaneHold"] = 243792078261,
		["Kharanos"] = 236694204600,
		["GolBolarQuarry"] = 309933108422,
		["FrostmaneFront"] = 275370032354,
		["AmberstillRanch"] = 242216000761,
	},
	["Duskwood"] = {
		["AddlesStead"] = 373696012587,
		["RavenHillCemetary"] = 141829657923,
		["BrightwoodGrove"] = 120780635415,
		["TheHushedBank"] = 163209071805,
		["Darkshire"] = 138110363977,
		["RacenHill"] = 313633436877,
		["TheTwilightGrove"] = 108777574720,
		["VulGolOgreMound"] = 381417711884,
		["ManorMistmantle"] = 131689797851,
		["TheDarkenedBank"] = 27991977891,
		["TheRottingOrchard"] = 395702443299,
		["TheYorgenFarmstead"] = 425622495465,
		["TheTranquilGardensCemetary"] = 370024894755,
	},
	["EasternPlaguelands"] = {
		["LightsHopeChapel"] = 291704631492,
		["TheInfectisScar"] = 283018274993,
		["EastwallTower"] = 198135955637,
		["TheNoxiousGlade"] = 59737681193,
		["Northdale"] = 66096177417,
		["TheUndercroft"] = 490758950168,
		["LightsShieldTower"] = 291394193651,
		["ZulMashar"] = 553828638,
		["Acherus"] = 110333543652,
		["QuelLithienLodge"] = 368229653,
		["BlackwoodLake"] = 162535808238,
		["NorthpassTower"] = 74508861690,
		["TheMarrisStead"] = 359843178698,
		["Darrowshire"] = 496290183416,
		["CrownGuardTower"] = 377154108618,
		["Stratholme"] = 123914550,
		["ThondorilRiver"] = 107374721286,
		["RuinsOfTheScarletEnclave"] = 317528069384,
		["Plaguewood"] = 43100927304,
		["Tyrshand"] = 445211998422,
		["TheFungalVale"] = 226751635730,
		["Terrordale"] = 10737746178,
		["LakeMereldar"] = 458972448010,
		["CorinsCrossing"] = 310828553402,
		["ThePestilentScar"] = 374064087222,
	},
	["Elwynn"] = {
		["EastvaleLoggingCamp"] = 314270010662,
		["StonecairnLake"] = 200295072084,
		["Goldshire"] = 315939331348,
		["WestbrookGarrison"] = 381300303117,
		["NorthshireValley"] = 148548919591,
		["FargodeepMine"] = 451223478541,
		["TowerofAzora"] = 308718847246,
		["Stromwind"] = 432640,
		["RidgepointTower"] = 475336476957,
		["BrackwellPumpkinPatch"] = 455824597279,
		["JerodsLanding"] = 462124431590,
		["CrystalLake"] = 351551044828,
	},
	["EversongWoods"] = {
		["Zebwatha"] = 510608475264,
		["ThuronsLivery"] = 328056570112,
		["WestSanctum"] = 342830088320,
		["TheGoldenStrand"] = 445795005568,
		["GoldenboughPass"] = 503839850752,
		["LakeElrendar"] = 506344969344,
		["AzurebreezeCoast"] = 245514895616,
		["StillwhisperPond"] = 337652220160,
		["FarstriderRetreat"] = 386022899968,
		["EastSanctum"] = 400988307712,
		["SilvermoonCity"] = 93877436928,
		["DuskwitherGrounds"] = 272291332352,
		["TranquilShore"] = 320200769792,
		["TheScortchedGrove"] = 544654622976,
		["TheLivingWood"] = 451507642496,
		["NorthSanctum"] = 320353861888,
		["FairbreezeVilliage"] = 414869356800,
		["SunstriderIsle"] = 5573706240,
		["SunsailAnchorage"] = 434034049280,
		["TorWatha"] = 338908513536,
		["RuinsofSilvermoon"] = 146351063296,
		["RunestoneFalithas"] = 532972482816,
		["SatherilsHaven"] = 412656861440,
		["RunestoneShandor"] = 530915178752,
		["ElrendarFalls"] = 429031424128,
	},
	["Ghostlands"] = {
		["GoldenmistVillage"] = 46662144,
		["ZebNowa"] = 254965890560,
		["HowlingZiggurat"] = 235506435328,
		["FarstriderEnclave"] = 146629984685,
		["DawnstarSpire"] = 603193771,
		["WindrunnerVillage"] = 125691232512,
		["Deatholme"] = 402753099264,
		["SanctumoftheSun"] = 161531560192,
		["IsleofTribulations"] = 613679360,
		["AmaniPass"] = 249735598484,
		["SanctumoftheMoon"] = 135511933184,
		["Tranquillien"] = 2530738432,
		["ElrendarCrossing"] = 342098432,
		["BleedingZiggurat"] = 255743754496,
		["SuncrownVillage"] = 482607616,
		["WindrunnerSpire"] = 308206108928,
		["ThalassiaPass"] = 436321130752,
	},
	["HillsbradFoothills"] = {
		["DandredsFold"] = 357680386,
		["Strahnbrad"] = 47774369043,
		["PurgationIsle"] = 542449478800,
		["RuinsOfAlterac"] = 91632096445,
		["DarrowHill"] = 300019777683,
		["GavinsNaze"] = 273091265652,
		["TheHeadland"] = 274213261417,
		["HillsbradFields"] = 324470488366,
		["GrowlessCave"] = 205461266603,
		["MistyShore"] = 45433922718,
		["SouthpointTower"] = 332922091832,
		["GallowsCorner"] = 150796913819,
		["CorrahnsDagger"] = 240965025927,
		["LordamereInternmentCamp"] = 232131828986,
		["DalaranCrater"] = 147209828668,
		["ChillwindPoint"] = 73596673471,
		["NethanderSteed"] = 401032335564,
		["TarrenMill"] = 243183856805,
		["CrushridgeHold"] = 108933542022,
		["DunGarok"] = 440802740493,
		["AzurelodeMine"] = 428724115636,
		["SoferasNaze"] = 178748803220,
		["DurnholdeKeep"] = 233594883509,
		["SlaughterHollow"] = 59488985236,
		["Southshore"] = 378358951141,
		["TheUplands"] = 462586068,
	},
	["Hinterlands"] = {
		["TheCreepingRuin"] = 270992088263,
		["ValorwindLake"] = 289136660679,
		["Agolwatha"] = 171109986512,
		["QuelDanilLodge"] = 194578173169,
		["Shaolwatha"] = 223931012377,
		["Zunwatha"] = 305102292194,
		["TheOverlookCliffs"] = 287399363828,
		["ShadraAlor"] = 407179038960,
		["Seradane"] = 5867101487,
		["SkulkRock"] = 209893698736,
		["TheAltarofZul"] = 368667988193,
		["JinthaAlor"] = 359140721951,
		["PlaguemistRavine"] = 112882636991,
		["AeriePeak"] = 253403344110,
	},
	["LochModan"] = {
		["MogroshStronghold"] = 56410498342,
		["Thelsamar"] = 156766608839,
		["IronbandsExcavationSite"] = 318332243341,
		["GrizzlepawRidge"] = 348149487889,
		["SilverStreamMine"] = 231993569,
		["TheFarstriderLodge"] = 225010028893,
		["NorthgatePass"] = 17073471,
		["StonesplinterValley"] = 370626828561,
		["StronewroughtDam"] = 355672397,
		["TheLoch"] = 87330089290,
		["ValleyofKings"] = 333934060854,
	},
	["Redridge"] = {
		["StonewatchFalls"] = 324820719932,
		["LakeEverstill"] = 229865941456,
		["StonewatchKeep"] = 503746788,
		["ThreeCorners"] = 274878323011,
		["GalardellValley"] = 602357164,
		["RedridgeCanyons"] = 39096733,
		["Lakeshire"] = 118111863194,
		["RendersValley"] = 405273873835,
		["CampEverstill"] = 307556975805,
		["AlthersMill"] = 149617368292,
		["ShalewindCanyon"] = 304590688562,
		["LakeridgeHighway"] = 339457966472,
		["RendersCamp"] = 224647525,
	},
	["RuinsofGilneas"] = {
		["GilneasPuzzle"] = 685034,
	},
	["SearingGorge"] = {
		["ThoriumPoint"] = 41069884845,
		["BlackrockMountain"] = 455521587504,
		["BlackcharCave"] = 387621113207,
		["GrimsiltWorksite"] = 259328846265,
		["TheCauldron"] = 183853490657,
		["TannerCamp"] = 386980434491,
		["FirewatchRidge"] = 80531039597,
		["DustfireValley"] = 616926600,
	},
	["Silverpine"] = {
		["TheDecrepitFields"] = 167997759664,
		["DeepElemMine"] = 228139931865,
		["TheGreymaneWall"] = 543646976409,
		["Ambermill"] = 268969430299,
		["TheSepulcher"] = 168935235802,
		["TheBattlefront"] = 461001380095,
		["NorthTidesBeachhead"] = 73353338030,
		["ValgansField"] = 83161690274,
		["OlsensFarthing"] = 267689041147,
		["ShadowfangKeep"] = 362204533939,
		["FenrisIsle"] = 16715659616,
		["ForsakenHighCommand"] = 466795881,
		["BerensPeril"] = 435395239230,
		["TheSkitteringDark"] = 247640291,
		["ForsakenRearGuard"] = 387168442,
		["NorthTidesRun"] = 154494233,
		["TheForsakenFront"] = 351567803544,
	},
	["StranglethornJungle"] = {
		["RuinsOfZulKunda"] = 165946596,
		["BaliaMahRuins"] = 261335758063,
		["MoshOggOgreMound"] = 272226269418,
		["GromGolBaseCamp"] = 245125794983,
		["KurzensCompound"] = 523483380,
		["KalAiRuins"] = 197939845259,
		["BalAlRuins"] = 180668736671,
		["MizjahRuins"] = 264546464925,
		["RebelCamp"] = 321034542,
		["NesingwarysExpedition"] = 67966793955,
		["Mazthoril"] = 391353994590,
		["Bambala"] = 176687333566,
		["ZuuldalaRuins"] = 23632026948,
		["TheVileReef"] = 223485329644,
		["ZulGurub"] = 656982392,
		["LakeNazferiti"] = 102438768880,
		["FortLivingston"] = 403070691558,
	},
	["Sunwell"] = {
		["SunsReachHarbor"] = 270847607296,
		["SunsReachSanctum"] = 4558684672,
	},
	["SwampOfSorrows"] = {
		["MistyreedStrand"] = 629830034,
		["PoolOfTears"] = 256153720065,
		["IthariusCave"] = 259853185292,
		["SplinterspearJunction"] = 253606845678,
		["TheShiftingMire"] = 26117251364,
		["Sorrowmurk"] = 86636923109,
		["TheHarborage"] = 84994715914,
		["Bogpaddle"] = 629343494,
		["Stagalbog"] = 387113598299,
		["Stonard"] = 277337133413,
		["MarshtideWatch"] = 501569866,
		["MistyValley"] = 85899638028,
	},
	["TheCapeOfStranglethorn"] = {
		["WildShore"] = 421263593708,
		["RuinsofAboraz"] = 194906341560,
		["JagueroIsle"] = 434285846768,
		["MistvaleValley"] = 266716039421,
		["BootyBay"] = 366449261793,
		["HardwrenchHideaway"] = 124772382052,
		["NekmaniWellspring"] = 229013419254,
		["RuinsofJubuwal"] = 128266237083,
		["CrystalveinMine"] = 78937010447,
		["GurubashiArena"] = 362025198,
		["TheSundering"] = 474170612,
	},
	["Tirisfal"] = {
		["CrusaderOutpost"] = 249827641519,
		["VenomwebVale"] = 161850088698,
		["GarrensHaunt"] = 139013085374,
		["Brill"] = 271086442695,
		["AgamandMills"] = 96976769309,
		["BalnirFarmstead"] = 348515388658,
		["ColdHearthManor"] = 340814644436,
		["ScarletMonastery"] = 51242080518,
		["BrightwaterLake"] = 131597635794,
		["NightmareVale"] = 349330236641,
		["ScarletWatchPost"] = 107026294945,
		["SollidenFarmstead"] = 206369424670,
		["Deathknell"] = 222274411951,
		["RuinsofLorderon"] = 385917136262,
		["CalstonEstate"] = 274212234419,
		["TheBulwark"] = 355078588709,
	},
	["TwilightHighlands"] = {
		["DragonmawPass"] = 128928921883,
		["TheTwilightCitadel"] = 337313630569,
		["CrucibleOfCarnage"] = 288168820939,
		["Thundermar"] = 100250391790,
		["TheKrazzworks"] = 686006498,
		["DragonmawPort"] = 263728610555,
		["Kirthaven"] = 505687348,
		["TwilightShore"] = 371080767748,
		["FirebeardsPatrol"] = 285065008343,
		["TheTwilightGate"] = 382595177637,
		["TheBlackBreach"] = 130445166803,
		["GrimBatol"] = 239531741414,
		["VermillionRedoubt"] = 17254588740,
		["ObsidianForest"] = 408479367510,
		["DunwaldRuins"] = 394477660357,
		["GlopgutsHollow"] = 95868352686,
		["VictoryPoint"] = 328881831089,
		["WyrmsBend"] = 249323264191,
		["GorshakWarCamp"] = 236792752322,
		["HighlandForest"] = 354840453359,
		["HumboldtConflaguration"] = 95923877007,
		["Highbank"] = 433449045212,
		["WeepingWound"] = 375584982,
		["SlitheringCove"] = 182114788550,
		["TheGullet"] = 192482037935,
		["Bloodgulch"] = 220553442519,
		["RuinsOfDrakgor"] = 310565070,
		["Crushblow"] = 480350768310,
		["TheTwilightBreach"] = 206485803207,
	},
	["VashjirDepths"] = {
		["FireplumeTrench"] = 118442159402,
		["ColdlightChasm"] = 300927015179,
		["AbyssalBreach"] = 521624043,
		["LGhorek"] = 225655952690,
		["Seabrush"] = 196930169057,
		["DeepfinRidge"] = 34648365419,
		["KorthunsEnd"] = 304301344114,
		["AbandonedReef"] = 282446932339,
	},
	["VashjirKelpForest"] = {
		["DarkwhisperGorge"] = 245366977756,
		["GnawsBoneyard"] = 349439223095,
		["GubogglesLedge"] = 301066304739,
		["TheAccursedReef"] = 174329136468,
		["LegionsFate"] = 37801487638,
		["HonorsTomb"] = 46569568547,
		["HoldingPens"] = 431048895804,
	},
	["VashjirRuins"] = {
		["Nespirah"] = 280729236766,
		["RuinsOfTherseral"] = 188485958853,
		["ShimmeringGrotto"] = 419715411,
		["GlimmeringdeepGorge"] = 238653985040,
		["BethMoraRidge"] = 478242110799,
		["SilverTideHollow"] = 34517351904,
		["RuinsOfVashjir"] = 287990719837,
	},
	["WesternPlaguelands"] = {
		["DarrowmereLake"] = 380639701484,
		["Hearthglen"] = 246693296,
		["GahrronsWithering"] = 229226311921,
		["Andorhal"] = 368394442192,
		["CaerDarrow"] = 419389718722,
		["FelstoneField"] = 245053477105,
		["TheWrithingHaunt"] = 356977413289,
		["TheWeepingCave"] = 162713016505,
		["RedpineDell"] = 226859554082,
		["DalsonsFarm"] = 249422872901,
		["SorrowHill"] = 481310241136,
		["NorthridgeLumberCamp"] = 132312652135,
		["ThondrorilRiver"] = 559337783,
		["TheBulwark"] = 252379984188,
	},
	["Westfall"] = {
		["GoldCoastQuarry"] = 85034584299,
		["TheJansenStead"] = 497208522,
		["SaldeansFarm"] = 87446238452,
		["DemontsPlace"] = 403939986633,
		["JangoloadMine"] = 326341828,
		["FurlbrowsPumpkinFarm"] = 413357253,
		["AlexstonFarmstead"] = 282569439578,
		["TheDeadAcre"] = 215305438401,
		["TheGapingChasm"] = 180697130168,
		["SentinelHill"] = 243089548517,
		["TheMolsenFarm"] = 127066669258,
		["TheDustPlains"] = 406377993533,
		["Moonbrook"] = 349289272552,
		["WestfallLighthouse"] = 512406756563,
		["TheDaggerHills"] = 424446018852,
	},
	["Wetlands"] = {
		["AngerfangEncampment"] = 216198807788,
		["IronbeardsTomb"] = 81994678457,
		["SundownMarsh"] = 67772861716,
		["WhelgarsExcavationSite"] = 209574100266,
		["MosshideFen"] = 249638923633,
		["RaptorRidge"] = 132698592512,
		["BlackChannelMarsh"] = 257737072941,
		["ThelganRock"] = 360092744962,
		["DunModr"] = 7889675521,
		["MenethilHarbor"] = 318901693765,
		["BluegillMarsh"] = 109554426177,
		["DireforgeHills"] = 37038035273,
		["Satlspray"] = 228878586,
		["GreenwardensGrove"] = 110004286714,
		["DunAlgaz"] = 450260852010,
		["SlabchiselsSurvey"] = 378515288364,
	},

	-- Kalimdor
	["AhnQirajTheFallenKingdom"] = {
		["AQKingdom"] = 121271159,
	},
	["Ashenvale"] = {
		["MaelstrasPost"] = 197502198,
		["Satyrnaar"] = 166086291691,
		["TheRuinsofStardust"] = 355629022444,
		["SilverwindRefuge"] = 360058245467,
		["BoughShadow"] = 159790615718,
		["OrendilsRetreat"] = 150203636,
		["WarsongLumberCamp"] = 285350264039,
		["LakeFalathim"] = 159031468216,
		["TheHowlingVale"] = 104649178437,
		["TheZoramStrand"] = 399622,
		["FallenSkyLake"] = 413945581855,
		["NightRun"] = 272280847581,
		["RaynewoodRetreat"] = 237801570535,
		["ThunderPeak"] = 130318391499,
		["Astranaar"] = 176361323771,
		["FelfireHill"] = 341125182741,
		["TheShrineofAssenia"] = 295321234738,
		["ThistlefurVillage"] = 84019496250,
	},
	["Aszhara"] = {
		["RavencrestMonument"] = 431069867303,
		["TheShatteredStrand"] = 180720313550,
		["DarnassianBaseCamp"] = 3581155571,
		["StormCliffs"] = 433144963279,
		["BitterReaches"] = 500424001,
		["TheSecretLab"] = 425572127928,
		["RuinsofArkkoran"] = 130525889755,
		["LakeMennar"] = 405057806546,
		["RuinsofEldarath"] = 246126195930,
		["OrgimmarRearGate"] = 369390537056,
		["GallywixPleasurePalace"] = 238444321018,
		["TowerofEldara"] = 24339891506,
		["BlackmawHold"] = 57122499844,
		["BearsHead"] = 151516315904,
		["BilgewaterHarbor"] = 136779789899,
	},
	["AzuremystIsle"] = {
		["AzureWatch"] = 267763581184,
		["MoongrazeWoods"] = 196965826816,
		["StillpineHold"] = 52996342016,
		["BristlelimbVillage"] = 389950996736,
		["OdesyusLanding"] = 406243770624,
		["WrathscalePoint"] = 452276247808,
		["PodWreckage"] = 375220600960,
		["PodCluster"] = 327786168576,
		["AmmenFord"] = 300114247936,
		["SiltingShore"] = 3526623488,
		["Emberglade"] = 26281771264,
		["TheExodar"] = 91346174464,
		["ValaarsBerth"] = 325528584448,
		["SilvermystIsle"] = 478913198336,
		["GreezlesCamp"] = 376341528832,
		["FairbridgeStrand"] = 373424384,
		["AmmenVale"] = 112222274011,
	},
	["Barrens"] = {
		["BoulderLodeMine"] = 8052229398,
		["MorshanRampart"] = 6713204997,
		["DreadmistPeak"] = 111973436657,
		["TheWailingCaverns"] = 341609616761,
		["Ratchet"] = 407521901787,
		["GroldomFarm"] = 136835196147,
		["TheForgottenPools"] = 223443419582,
		["ThornHill"] = 273235025135,
		["TheDryHills"] = 61325195547,
		["TheCrossroads"] = 295658783977,
		["TheStagnantOasis"] = 407309157712,
		["TheMerchantCoast"] = 490209497403,
		["TheSludgeFen"] = 6865282305,
		["FarWatchPost"] = 139094995151,
	},
	["BloodmystIsle"] = {
		["RuinsofLorethAran"] = 232511504640,
		["TheBloodcursedReef"] = 58746732800,
		["VeridianPoint"] = 668205312,
		["TheCryoCore"] = 306323915008,
		["RagefeatherRidge"] = 126132420864,
		["KesselsCrossing"] = 566404199909,
		["Axxarien"] = 146340577536,
		["AmberwebPass"] = 66618654976,
		["WyrmscarIsland"] = 88689869056,
		["WrathscaleLair"] = 363552047360,
		["VindicatorsRest"] = 260089053440,
		["TheBloodwash"] = 29307961600,
		["Middenvale"] = 436373553408,
		["Nazzivian"] = 434054103296,
		["TheVectorCoil"] = 255596083712,
		["TheFoulPool"] = 146260885760,
		["TheHiddenReef"] = 42091151616,
		["BloodWatch"] = 277483880704,
		["BlacksiltShore"] = 457599863296,
		["TalonStand"] = 84441039104,
		["TheLostFold"] = 505186294016,
		["BloodscaleIsle"] = 275678232815,
		["TheCrimsonReach"] = 93997760768,
		["TheWarpPiston"] = 31611683072,
		["Bladewood"] = 224797131008,
		["TelathionsCamp"] = 232117108864,
		["BristlelimbEnclave"] = 440806932736,
		["Mystwood"] = 518941500672,
	},
	["Darkshore"] = {
		["Lordanel"] = 58392339733,
		["Nazjvel"] = 501654693108,
		["AmethAran"] = 354643232070,
		["RuinsofMathystra"] = 30607154376,
		["ShatterspearVale"] = 17805067514,
		["EyeoftheVortex"] = 256939065674,
		["TheMastersGlaive"] = 518907946287,
		["WitheringThicket"] = 127021607240,
		["WildbendRiver"] = 406168208698,
		["ShatterspearWarcamp"] = 592596213,
		["RuinsofAuberdine"] = 195714812107,
	},
	["Desolace"] = {
		["ThargadsCamp"] = 404015474900,
		["SlitherbladeShore"] = 25988258130,
		["GelkisVillage"] = 507023397138,
		["ShokThokar"] = 343141610805,
		["RanzjarIsle"] = 220345505,
		["MannorocCoven"] = 383725657414,
		["NijelsPoint"] = 601097447,
		["MagramTerritory"] = 183179137313,
		["ValleyofSpears"] = 210631937345,
		["TethrisAran"] = 418530578,
		["ThunderAxeFortress"] = 53074932956,
		["KodoGraveyard"] = 293509225722,
		["CenarionWildlands"] = 167939175736,
		["Sargeron"] = 687117629,
		["ShadowbreakRavine"] = 432312428836,
		["ShadowpreyVillage"] = 396359937246,
	},
	["Durotar"] = {
		["ValleyOfTrials"] = 335326480638,
		["ThunderRidge"] = 51849160924,
		["RazorHill"] = 169029635296,
		["TiragardeKeep"] = 320459710674,
		["SouthfuryWatershed"] = 187127003380,
		["RazormaneGrounds"] = 283784673528,
		["EchoIsles"] = 443905473866,
		["SenjinVillage"] = 436418568384,
		["DrygulchRavine"] = 64859869420,
		["NorthwatchFoothold"] = 472864945314,
		["SkullRock"] = 459437264,
		["Orgrimmar"] = 324179203,
	},
	["Dustwallow"] = {
		["BrackenwllVillage"] = 63490483584,
		["WitchHill"] = 449152270,
		["DirehornPost"] = 181838066967,
		["ShadyRestInn"] = 202007353661,
		["TheWyrmbog"] = 396587478452,
		["AlcazIsland"] = 23236649166,
		["TheramoreIsle"] = 240013008177,
		["Mudsprocket"] = 336195845553,
		["BlackhoofVillage"] = 208854360,
	},
	["Felwood"] = {
		["BloodvenomFalls"] = 248265245017,
		["JadefireGlen"] = 492075960549,
		["RuinsofConstellas"] = 385765038348,
		["Jaedenar"] = 340621705535,
		["DeadwoodVillage"] = 542669704365,
		["MorlosAran"] = 520190345403,
		["TalonbranchGlade"] = 61760309457,
		["EmeraldSanctuary"] = 410582733074,
		["ShatterScarVale"] = 115145435479,
		["JadefireRun"] = 9981598983,
		["IrontreeWoods"] = 59481801989,
		["FelpawVillage"] = 494044467,
	},
	["Feralas"] = {
		["GrimtotemCompund"] = 183172819103,
		["CampMojache"] = 195051090094,
		["DireMaul"] = 108956774665,
		["LowerWilds"] = 205877626063,
		["FeathermoonStronghold"] = 254856593625,
		["FeralScar"] = 302200835263,
		["TheTwinColossals"] = 284506462,
		["WrithingDeep"] = 320658946280,
		["GordunniOutpost"] = 125249418432,
		["DarkmistRuins"] = 308759697580,
		["RuinsofIsildien"] = 380594533582,
		["RuinsofFeathermoon"] = 246082121936,
		["TheForgottenCoast"] = 368686973122,
	},
	["Hyjal"] = {
		["AshenLake"] = 83758582042,
		["Nordrassil"] = 411373081,
		["DireforgeHill"] = 211845035278,
		["DarkwhisperGorge"] = 138154564928,
		["ArchimondesVengeance"] = 5704560910,
		["TheThroneOfFlame"] = 406208154019,
		["TheScorchedPlain"] = 232359469421,
		["TheRegrowth"] = 271711534521,
		["ShrineOfGoldrinn"] = 18375574819,
		["SethriasRoost"] = 468297425173,
		["GatesOfSothann"] = 344249940240,
	},
	["Moonglade"] = {
		["StormrageBarrowDens"] = 226054465811,
		["Nighthaven"] = 145343369562,
		["ShrineofRemulos"] = 97929961743,
		["LakeEluneara"] = 293361483183,
	},
	["Mulgore"] = {
		["WildmaneWaterWell"] = 347254974,
		["WindfuryRidge"] = 419637470,
		["TheRollingPlains"] = 313011719428,
		["BaeldunDigsite"] = 236460376282,
		["PalemaneRock"] = 344931382444,
		["ThunderBluff"] = 66790362485,
		["StonetalonPass"] = 210952429,
		["RavagedCaravan"] = 240974468283,
		["BloodhoofVillage"] = 293466242350,
		["ThunderhornWaterWell"] = 217245195465,
		["WinterhoofWaterWell"] = 365543220398,
		["TheGoldenPlains"] = 108917907642,
		["TheVentureCoMine"] = 148732424400,
		["RedRocks"] = 46710056122,
		["RedCloudMesa"] = 430870634942,
	},
	["Silithus"] = {
		["HiveAshi"] = 4656999829,
		["ValorsRest"] = 644117819,
		["HiveZora"] = 221191192094,
		["HiveRegal"] = 333258791401,
		["TwilightBaseCamp"] = 162240110002,
		["SouthwindVillage"] = 194924236085,
		["CenarionHold"] = 153993089316,
		["TheCrystalVale"] = 132372809,
		["TheScarabWall"] = 488552748612,
	},
	["SouthernBarrens"] = {
		["ForwardCommand"] = 269952921816,
		["HonorsStand"] = 210938171,
		["RuinsofTaurajo"] = 307346189597,
		["BaelModan"] = 491117563149,
		["HuntersHill"] = 69034232026,
		["RazorfenKraul"] = 567222087894,
		["Battlescar"] = 329926304128,
		["FrazzlecrazMotherload"] = 468433702130,
		["NorthwatchHold"] = 158414953752,
		["VendettaPoint"] = 210733586686,
		["TheOvergrowth"] = 125931063651,
	},
	["StonetalonMountains"] = {
		["BoulderslideRavine"] = 550313816258,
		["ThaldarahOverlook"] = 130187195602,
		["WebwinderHollow"] = 431073003684,
		["StonetalonPeak"] = 278122801,
		["CliffwalkerPost"] = 102389448945,
		["RuinsofEldrethar"] = 441692957917,
		["WebwinderPath"] = 282885193995,
		["UnearthedGrounds"] = 396896712969,
		["SunRockRetreat"] = 306386794718,
		["WindshearCrag"] = 192758971766,
		["WindshearHold"] = 310852646064,
		["BattlescarValley"] = 203168195874,
		["Malakajin"] = 577247513811,
		["GreatwoodVale"] = 481667805506,
		["TheCharredVale"] = 395345938709,
		["MirkfallonLake"] = 153982590196,
		["KromgarFortress"] = 366762725559,
	},
	["Tanaris"] = {
		["LostRiggerCover"] = 216467229874,
		["LandsEndBeach"] = 485783462112,
		["DunemaulCompound"] = 276271645927,
		["TheGapingChasm"] = 391311977697,
		["BrokenPillar"] = 226992753859,
		["CavernsofTime"] = 256082359509,
		["TheNoxiousLair"] = 226830252211,
		["EastmoonRuins"] = 366544587949,
		["Gadgetzan"] = 99216445629,
		["AbyssalSands"] = 159225415935,
		["ValleryoftheWatchers"] = 463050307853,
		["SouthbreakShore"] = 310769805586,
		["ThistleshrubValley"] = 300841997533,
		["GadgetzanBay"] = 10166293758,
		["ZulFarrak"] = 193132859,
		["SandsorrowWatch"] = 106607826134,
		["SouthmoonRuins"] = 375051734248,
	},
	["Teldrassil"] = {
		["Shadowglen"] = 112173737201,
		["Darnassus"] = 194503853354,
		["GnarlpineHold"] = 381542388934,
		["LakeAlameth"] = 333302671649,
		["GalardellValley"] = 254965639346,
		["TheCleft"] = 117491075216,
		["TheOracleGlade"] = 96926421186,
		["RutheranVillage"] = 481381544253,
		["WellspringLake"] = 89521382565,
		["BanethilHollow"] = 237689351343,
		["StarbreezeVillage"] = 233572602043,
		["PoolsofArlithrien"] = 261281237132,
	},
	["ThousandNeedles"] = {
		["DarkcloudPinnacle"] = 124731519293,
		["RustmaulDiveSite"] = 499842755818,
		["WestreachSummit"] = 333080,
		["TheShimmeringDeep"] = 276571778459,
		["SplithoofHeights"] = 53212506543,
		["TwilightBulwark"] = 258903279974,
		["Highperch"] = 143881793782,
		["RazorfenDowns"] = 312797545,
		["TheTwilightWithering"] = 353625263478,
		["FreewindPost"] = 200005664180,
		["TheGreatLift"] = 142844176,
		["SouthseaHoldfast"] = 443174617334,
	},
	["Uldum"] = {
		["ThroneOfTheFourWinds"] = 465170568462,
		["RuinsOfAmmon"] = 310539183307,
		["Orsis"] = 146305961209,
		["TahretGrounds"] = 207803808918,
		["Nahom"] = 174557694189,
		["Ramkahen"] = 72371899620,
		["RuinsOfAhmtul"] = 382907670,
		["ObeliskOfTheMoon"] = 115573136,
		["AkhenetFields"] = 297920554148,
		["KhartutsTomb"] = 568548555,
		["ObeliskOfTheSun"] = 303151918349,
		["TheGateofUnendingCycles"] = 16784797857,
		["TheVortexPinnacle"] = 508567948501,
		["VirnaalDam"] = 231356907671,
		["CradelOfTheAncient"] = 432001950922,
		["Marat"] = 187256997024,
		["HallsOfOrigination"] = 198196840717,
		["ObeliskOfTheStars"] = 130500700356,
		["LostCityOfTheTolVir"] = 313011799273,
		["TempleofUldum"] = 136503837992,
		["TheCursedlanding"] = 183324963053,
		["Neferset"] = 412743891153,
		["TheTrailOfDevestation"] = 375425020110,
		["Schnottzslanding"] = 237326599480,
	},
	["UngoroCrater"] = {
		["IronstonePlateau"] = 216562628805,
		["FirePlumeRidge"] = 206532018497,
		["TheScreamingReaches"] = 164966732,
		["LakkariTarPits"] = 320117168,
		["MossyPile"] = 192543909050,
		["TerrorRun"] = 383496000828,
		["TheMarshlands"] = 275479163143,
		["TheRollingGarden"] = 42468705617,
		["FungalRock"] = 584252640,
		["MarshalsStand"] = 354819418316,
		["GolakkaHotSprings"] = 242817979701,
		["TheSlitheringScar"] = 412668414333,
	},
	["Winterspring"] = {
		["WinterfallVillage"] = 194964047069,
		["FrostsaberRock"] = 319041868,
		["FrostwhisperGorge"] = 509398408509,
		["TimbermawPost"] = 324366758250,
		["IceThistleHills"] = 337764377849,
		["TheHiddenGrove"] = 18778160461,
		["StarfallVillage"] = 35673952623,
		["FrostfireHotSprings"] = 126799349112,
		["Everlook"] = 209885304002,
		["LakeKeltheril"] = 288153143567,
		["Mazthoril"] = 365490845953,
		["OwlWingThicket"] = 471955822846,
	},

	-- Outland
	["BladesEdgeMountains"] = {
		["BashirLanding"] = 442761472,
		["BladedGulch"] = 158493573376,
		["BladesipreHold"] = 173202205952,
		["BloodmaulCamp"] = 102437748992,
		["BloodmaulOutpost"] = 398717134080,
		["BrokenWilds"] = 117806727424,
		["CircleofWrath"] = 225946370304,
		["DeathsDoor"] = 267899014400,
		["ForgeCampAnger"] = 158454776224,
		["ForgeCampTerror"] = 446827852288,
		["ForgeCampWrath"] = 189245161728,
		["Grishnath"] = 30364926208,
		["GruulsLayer"] = 87525949696,
		["JaggedRidge"] = 444997040384,
		["MokNathalVillage"] = 319591547136,
		["RavensWood"] = 59280458240,
		["RazorRidge"] = 357041520896,
		["RidgeofMadness"] = 277606721792,
		["RuuanWeald"] = 105729491200,
		["Skald"] = 76941623552,
		["Sylvanaar"] = 376113002752,
		["TheCrystalpine"] = 613679360,
		["ThunderlordStronghold"] = 292482855168,
		["VeilLashh"] = 459845910784,
		["VeilRuuan"] = 162725495040,
		["VekhaarStand"] = 436598997248,
		["VortexPinnacle"] = 221365352704,
	},
	["Hellfire"] = {
		["DenofHaalesh"] = 442572734720,
		["ExpeditionArmory"] = 443729313280,
		["FalconWatch"] = 350232074752,
		["FallenSkyRidge"] = 152507252992,
		["ForgeCampRage"] = 27345289728,
		["HellfireCitadel"] = 225840670976,
		["HonorHold"] = 320467108096,
		["MagharPost"] = 118327869696,
		["PoolsofAggonar"] = 48660742400,
		["RuinsofShanaar"] = 311411730688,
		["TempleofTelhamat"] = 163249127936,
		["TheLegionFront"] = 138046603520,
		["TheStairofDestiny"] = 168277049600,
		["Thrallmar"] = 165846188288,
		["ThroneofKiljaeden"] = 6942884352,
		["VoidRidge"] = 395876499712,
		["WarpFields"] = 438409892096,
		["ZethGor"] = 462317402534,
	},
	["Nagrand"] = {
		["BurningBladeRUins"] = 359322171648,
		["ClanWatch"] = 390326386944,
		["ForgeCampFear"] = 266326151680,
		["ForgeCampHate"] = 165526372608,
		["Garadar"] = 153997279488,
		["Halaa"] = 207583707392,
		["KilsorrowFortress"] = 459073111296,
		["LaughingSkullRuins"] = 56202887424,
		["OshuGun"] = 358806272512,
		["RingofTrials"] = 287248220416,
		["SouthwindCleft"] = 277435646208,
		["SunspringPost"] = 213904523520,
		["Telaar"] = 419165372672,
		["ThroneoftheElements"] = 57437061376,
		["TwilightRidge"] = 114901385472,
		["WarmaulHill"] = 34524627200,
		["WindyreedPass"] = 85452914944,
		["WindyreedVillage"] = 250880459008,
		["ZangarRidge"] = 58272776448,
	},
	["Netherstorm"] = {
		["Area52"] = 416864665856,
		["ArklonRuins"] = 426619699456,
		["CelestialRidge"] = 186432880896,
		["EcoDomeFarfield"] = 11152916736,
		["EtheriumStagingGrounds"] = 223842926848,
		["ForgeBaseOG"] = 23871095040,
		["KirinVarVillage"] = 562080924928,
		["ManaforgeBanar"] = 301875989760,
		["ManaforgeCoruu"] = 525434277120,
		["ManaforgeDuro"] = 361265103104,
		["ManafrogeAra"] = 166609551616,
		["Netherstone"] = 21906063616,
		["NetherstormBridge"] = 315818770688,
		["RuinedManaforge"] = 148714553600,
		["RuinsofEnkaat"] = 323461841152,
		["RuinsofFarahlon"] = 52984807936,
		["SocretharsSeat"] = 41042575616,
		["SunfuryHold"] = 484733838592,
		["TempestKeep"] = 305564877209,
		["TheHeap"] = 488803357952,
		["TheScrapField"] = 280620171520,
		["TheStormspire"] = 144194142464,
	},
	["ShadowmoonValley"] = {
		["AltarofShatar"] = 100403511552,
		["CoilskarPoint"] = 8955363840,
		["EclipsePoint"] = 333219994112,
		["IlladarPoint"] = 275028115712,
		["LegionHold"] = 166539559424,
		["NetherwingCliffs"] = 331293655296,
		["NetherwingLedge"] = 478350114284,
		["ShadowmoonVilliage"] = 37703123456,
		["TheBlackTemple"] = 135927431564,
		["TheDeathForge"] = 138817306880,
		["TheHandofGuldan"] = 97050427904,
		["TheWardensCage"] = 277517593088,
		["WildhammerStronghold"] = 246063488512,
	},
	["TerokkarForest"] = {
		["AllerianStronghold"] = 297930064128,
		["AuchenaiGrounds"] = 466263189760,
		["BleedingHollowClanRuins"] = 323304668416,
		["BonechewerRuins"] = 295825572096,
		["CarrionHill"] = 292453351680,
		["CenarionThicket"] = 329515264,
		["FirewingPoint"] = 160635027841,
		["GrangolvarVilliage"] = 183760060928,
		["RaastokGlade"] = 165886034176,
		["RazorthornShelf"] = 20902576384,
		["RefugeCaravan"] = 288094421120,
		["RingofObservance"] = 370766250240,
		["SethekkTomb"] = 310568550656,
		["ShattrathCity"] = 4404544000,
		["SkethylMountains"] = 374133293568,
		["SmolderingCaravan"] = 494258045184,
		["StonebreakerHold"] = 177583948032,
		["TheBarrierHills"] = 4416864512,
		["Tuurem"] = 36984848640,
		["VeilRhaze"] = 388927586560,
		["WrithingMound"] = 351551095040,
	},
	["Zangarmarsh"] = {
		["AngoroshGrounds"] = 53779628288,
		["AngoroshStronghold"] = 130154752,
		["BloodscaleEnclave"] = 443006845184,
		["CenarionRefuge"] = 345399099700,
		["CoilfangReservoir"] = 97121730816,
		["FeralfenVillage"] = 356811883008,
		["MarshlightLake"] = 163293954304,
		["OreborHarborage"] = 27189051648,
		["QuaggRidge"] = 349114293504,
		["Sporeggar"] = 216917082624,
		["Telredor"] = 120856248576,
		["TheDeadMire"] = 138190258462,
		["TheHewnBog"] = 54990995712,
		["TheLagoon"] = 325880905984,
		["TheSpawningGlen"] = 364031246592,
		["TwinspireRuins"] = 267720589568,
		["UmbrafenVillage"] = 495750167808,
		["ZabraJin"] = 249291866368,
	},

	-- Northrend
	["BoreanTundra"] = {
		["AmberLedge"] = 150664861940,
		["BorGorokOutpost"] = 329461132,
		["Coldarra"] = 52819404,
		["DeathsStand"] = 195088899361,
		["GarroshsLanding"] = 255711373579,
		["Kaskala"] = 230314799489,
		["RiplashStrand"] = 411550615934,
		["SteeljawsCaravan"] = 71283571956,
		["TempleCityOfEnKilah"] = 16853012770,
		["TheDensOfDying"] = 12505531595,
		["TheGeyserFields"] = 503667063,
		["TorpsFarm"] = 254762307770,
		["ValianceKeep"] = 283947350275,
		["WarsongStronghold"] = 254822078724,
	},
	["CrystalsongForest"] = {
		["ForlornWoods"] = 135950880,
		["SunreaversCommand"] = 43512087998,
		["TheAzureFront"] = 261993439648,
		["TheDecrepitFlow"] = 227616,
		["TheGreatTree"] = 97710772476,
		["TheUnboundThicket"] = 113267668470,
		["VioletStand"] = 188978871560,
		["WindrunnersOverlook"] = 411708978734,
	},
	["Dragonblight"] = {
		["AgmarsHammer"] = 218240346348,
		["Angrathar"] = 220449074,
		["ColdwindHeights"] = 422800597,
		["EmeraldDragonshrine"] = 389264140484,
		["GalakrondsRest"] = 127155799298,
		["IcemistVillage"] = 177308255467,
		["LakeIndule"] = 336309039460,
		["LightsRest"] = 8253626667,
		["Naxxramas"] = 172523536695,
		["NewHearthglen"] = 385043666134,
		["ObsidianDragonshrine"] = 111937793328,
		["RubyDragonshrine"] = 223730683068,
		["ScarletPoint"] = 8113195243,
		["TheCrystalVice"] = 510921957,
		["TheForgottenShore"] = 357214484781,
		["VenomSpite"] = 284161167586,
		["WestwindRefugeeCamp"] = 200834067685,
		["WyrmrestTemple"] = 235624826173,
	},
	["GrizzlyHills"] = {
		["AmberpineLodge"] = 262220843286,
		["BlueSkyLoggingGrounds"] = 138756205817,
		["CampOneqwah"] = 147677521220,
		["ConquestHold"] = 329656867148,
		["DrakTheronKeep"] = 49392416126,
		["DrakilJinRuins"] = 44660191583,
		["DunArgol"] = 276525629895,
		["GraniteSprings"] = 222272127332,
		["GrizzleMaw"] = 201165344038,
		["RageFangShrine"] = 316007623131,
		["ThorModan"] = 533977417,
		["UrsocsDen"] = 34707083592,
		["VentureBay"] = 495014067474,
		["Voldrune"] = 452230110491,
	},
	["HowlingFjord"] = {
		["AncientLift"] = 377242188977,
		["ApothecaryCamp"] = 39832528135,
		["BaelgunsExcavationSite"] = 351765054708,
		["Baleheim"] = 183140267182,
		["CampWinterHoof"] = 371410143,
		["CauldrosIsle"] = 173386418357,
		["EmberClutch"] = 218266599637,
		["ExplorersLeagueOutpost"] = 361390891240,
		["FortWildervar"] = 513999099,
		["GiantsRun"] = 600099114,
		["Gjalerbron"] = 236123378,
		["Halgrind"] = 223754853563,
		["IvaldsRuin"] = 240145081537,
		["Kamagua"] = 298604307789,
		["NewAgamand"] = 386982531356,
		["Nifflevar"] = 258322153650,
		["ScalawagPoint"] = 440410573150,
		["Skorn"] = 116324016366,
		["SteelGate"] = 107607138526,
		["TheTwistedGlade"] = 61643901194,
		["UtgardeKeep"] = 232428796152,
		["VengeanceLanding"] = 27540146399,
		["WestguardKeep"] = 193368125787,
	},
	["IcecrownGlacier"] = {
		["Aldurthar"] = 40101076341,
		["ArgentTournamentGround"] = 32858407226,
		["Corprethar"] = 421265625396,
		["IcecrownCitadel"] = 500774938932,
		["Jotunheim"] = 131020056969,
		["OnslaughtHarbor"] = 179315159244,
		["Scourgeholme"] = 287412829429,
		["SindragosasFall"] = 33942756652,
		["TheBombardment"] = 194911653112,
		["TheBrokenFront"] = 353846402331,
		["TheConflagration"] = 327834355939,
		["TheFleshwerks"] = 312687750363,
		["TheShadowVault"] = 16443129055,
		["Valhalas"] = 53914878190,
		["ValleyofEchoes"] = 419509265677,
		["Ymirheim"] = 296818523359,
	},
	["SholazarBasin"] = {
		["KartaksHold"] = 402733176137,
		["RainspeakerCanopy"] = 262440987855,
		["RiversHeart"] = 364375254484,
		["TheAvalanche"] = 99409470786,
		["TheGlimmeringPillar"] = 36830518566,
		["TheLifebloodPillar"] = 144407119160,
		["TheMakersOverlook"] = 254142609641,
		["TheMakersPerch"] = 145135755513,
		["TheMosslightPillar"] = 381456540911,
		["TheSavageThicket"] = 55176303909,
		["TheStormwrightsShelf"] = 62422024460,
		["TheSuntouchedPillar"] = 199802286535,
	},
	["TheStormPeaks"] = {
		["BorsBreath"] = 402767678786,
		["BrunnhildarVillage"] = 397640247601,
		["DunNiffelem"] = 306521177397,
		["EngineoftheMakers"] = 318159113426,
		["Frosthold"] = 460775977204,
		["GarmsBane"] = 505073040568,
		["NarvirsCradle"] = 154843462836,
		["Nidavelir"] = 221304266973,
		["SnowdriftPlains"] = 153715187917,
		["SparksocketMinefield"] = 502765134075,
		["TempleofLife"] = 121930791094,
		["TempleofStorms"] = 323447066793,
		["TerraceoftheMakers"] = 131303036267,
		["Thunderfall"] = 192857739570,
		["Ulduar"] = 228861297,
		["Valkyrion"] = 341552822500,
	},
	["ZulDrak"] = {
		["AltarOfHarKoa"] = 371000083721,
		["AltarOfMamToth"] = 95092536631,
		["AltarOfQuetzLun"] = 270145978629,
		["AltarOfRhunok"] = 136817459447,
		["AltarOfSseratus"] = 180690870509,
		["AmphitheaterOfAnguish"] = 308467202314,
		["DrakSotraFields"] = 384741680414,
		["GunDrak"] = 659858768,
		["Kolramas"] = 469623872814,
		["LightsBreach"] = 389958387009,
		["ThrymsEnd"] = 265214505232,
		["Voltarus"] = 205267438810,
		["Zeramas"] = 442389233971,
		["ZimTorga"] = 259274311929,
	},

	-- The Maelstrom
	["Deepholm"] = {
		["NeedlerockSlag"] = 156766598514,
		["DeathwingsFall"] = 319477341638,
		["StoneHearth"] = 337155295603,
		["TwilightTerrace"] = 412628490477,
		["NeedlerockChasm"] = 21339514,
		["ThePaleRoost"] = 89408979,
		["StormsFuryWreckage"] = 411723658532,
		["TwilightOverlook"] = 451569508763,
		["CrimsonExpanse"] = 13451542990,
		["ScouredReach"] = 470056452,
		["TherazanesThrone"] = 455242002,
		["TheShatteredField"] = 470447004078,
		["TempleOfEarth"] = 190353597795
	},
	["Kezan"] = {
		["TheSlick"] = 116193962576,
		["KTCHeadquarters"] = 287143511361,
		["KajaroField"] = 279574793466,
		["Drudgetown"] = 394252301663,
		["BilgewaterPort"] = 159085005494,
		["GallywixsVilla"] = 44023877935,
		["Kajamine"] = 331327316322,
		["FirstbankofKezan"] = 349069204856,
		["SwindleStreet"] = 249440720040
	},
	["TheLostIsles"] = {
		["RuinsOfVashelan"] = 485792899284,
		["Alliancebeachhead"] = 373797597361,
		["ShipwreckShore"] = 438285024428,
		["HordeBaseCamp"] = 492029802718,
		["SkyFalls"] = 141096577214,
		["WarchiefsLookout"] = 154895882399,
		["KTCOilPlatform"] = 12265339036,
		["ScorchedGully"] = 198981222705,
		["Lostpeak"] = 23158330718,
		["Oostan"] = 173388597458,
		["RaptorRise"] = 395573408936,
		["TheSlavePits"] = 73307194580,
		["GallywixDocks"] = 22916812973,
		["BilgewaterLumberyard"] = 46655554808,
		["TheSavageGlen"] = 349189660903,
		["OoomlotVillage"] = 370973822173,
		["landingSite"] = 385868764302
	},

	["*"] = {}
}

errata.Hyjal_terrain1 = errata.Hyjal
errata.Uldum_terrain1 = errata.Uldum
errata.Gilneas_terrain1 = errata.Gilneas
errata.Gilneas_terrain2 = errata.Gilneas
errata.TheLostIsles_terrain1 = errata.TheLostIsles
errata.TheLostIsles_terrain2 = errata.TheLostIsles
errata.TwilightHighlands_terrain1 = errata.TwilightHighlands
errata.BlastedLands_terrain1 = errata.BlastedLands

local function UpdateOverlayTextures(frame, frameName, textureCache, scale, r, g, b, alpha)
	local mapFileName = GetMapInfo()

	if not mapFileName then
		for i = 1, #textureCache do
			textureCache[i]:Hide()
		end

		return
	end

	local pathPrefix = "Interface\\WorldMap\\"..mapFileName.."\\"
	local overlayMap = errata[mapFileName]
	local numOverlays = GetNumMapOverlays()
	local pathLen = len(pathPrefix) + 1

	if not overlayMap then
		overlayMap = {}
	end

	for i = 1, numOverlays do
		local texName, texWidth, texHeight, offsetX, offsetY = GetMapOverlayInfo(i)

		if texName then
			texName = sub(texName, pathLen)

			if lower(texName) ~= "pixelfix" then
				discoveredOverlays[texName] = true

				if not overlayMap[texName] then
					local texID = texWidth + texHeight * 2^10 + offsetX * 2^20 + offsetY * 2^30

					if texID ~= 0 and texID ~= 131200 then
						overlayMap[texName] = texID
					end
				end
			end
		end
	end

	local textureCount = 0
	local numOverlays = #textureCache

	for texName, texID in pairs(overlayMap) do
		local textureName = pathPrefix .. texName
		local textureWidth, textureHeight, offsetX, offsetY = fmod(texID, 2^10), fmod(floor(texID / 2^10), 2^10), fmod(floor(texID / 2^20), 2^10), floor(texID / 2^30)

		local numTexturesWide = ceil(textureWidth / 256)
		local numTexturesTall = ceil(textureHeight / 256)

		local neededTextures = textureCount + (numTexturesWide * numTexturesTall)

		if neededTextures > numOverlays then
			for j = numOverlays + 1, neededTextures do
				tinsert(textureCache, (frame:CreateTexture(format(frameName, j), "ARTWORK")))
			end

			numOverlays = neededTextures
			FC.NUM_WORLDMAP_OVERLAYS = numOverlays
			NUM_WORLDMAP_OVERLAYS = numOverlays
		end

		local texture, texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight

		for j = 1, numTexturesTall do
			if j < numTexturesTall then
				texturePixelHeight = 256
				textureFileHeight = 256
			else
				texturePixelHeight = fmod(textureHeight, 256)
				textureFileHeight = 16

				if texturePixelHeight == 0 then
					texturePixelHeight = 256
				end

				while textureFileHeight < texturePixelHeight do
					textureFileHeight = textureFileHeight * 2
				end
			end

			for k = 1, numTexturesWide do
				textureCount = textureCount + 1
				texture = textureCache[textureCount]

				if k < numTexturesWide then
					texturePixelWidth = 256
					textureFileWidth = 256
				else
					texturePixelWidth = fmod(textureWidth, 256)
					textureFileWidth = 16

					if texturePixelWidth == 0 then
						texturePixelWidth = 256
					end

					while textureFileWidth < texturePixelWidth do
						textureFileWidth = textureFileWidth * 2
					end
				end

				texture:Size(texturePixelWidth * scale, texturePixelHeight * scale)
				texture:Point("TOPLEFT", (offsetX + (256 * (k - 1))) * scale, -(offsetY + (256 * (j - 1))) * scale)
				texture:SetTexCoord(0, texturePixelWidth / textureFileWidth, 0, texturePixelHeight / textureFileHeight)
				texture:SetTexture(format("%s%d", textureName, ((j - 1) * numTexturesWide) + k))

				if discoveredOverlays[texName] then
					texture:SetDrawLayer("ARTWORK")
					texture:SetVertexColor(1, 1, 1)
					texture:SetAlpha(1)
				else
					texture:SetDrawLayer("BORDER")
					texture:SetVertexColor(r, g, b)
					texture:SetAlpha(alpha * 1)
				end

				texture:Show()
			end
		end
	end

	for i = textureCount + 1, numOverlays do
		textureCache[i]:Hide()
	end

	twipe(discoveredOverlays)
end

function FC:UpdateWorldMapOverlays()
	if not WorldMapFrame:IsShown() then return end

	if NUM_WORLDMAP_OVERLAYS > self.NUM_WORLDMAP_OVERLAYS then
		for i = self.NUM_WORLDMAP_OVERLAYS + 1, NUM_WORLDMAP_OVERLAYS do
			tinsert(worldMapCache, i, _G[format("WorldMapOverlay%d", i)])
		end

		self.NUM_WORLDMAP_OVERLAYS = NUM_WORLDMAP_OVERLAYS
	end

	local color = E.db.enhanced.map.fogClear.color
	UpdateOverlayTextures(WorldMapDetailFrame, "WorldMapOverlay%d", worldMapCache, 1, color.r, color.g, color.b, color.a)
end

function FC:UpdateFog()
	if E.db.enhanced.map.fogClear.enable then
		self:SecureHook("WorldMapFrame_Update", "UpdateWorldMapOverlays")

		twipe(worldMapCache)
		self.NUM_WORLDMAP_OVERLAYS = 0

		if WorldMapFrame:IsShown() then
			self:UpdateWorldMapOverlays()
		end
	else
		self:UnhookAll()

		for i = 1, NUM_WORLDMAP_OVERLAYS do
			local tex = _G[format("WorldMapOverlay%d", i)]
			tex:SetDrawLayer("ARTWORK")
			tex:SetVertexColor(1, 1, 1)
			tex:SetAlpha(1)
		end

		for i = 1, #worldMapCache do
			worldMapCache[i]:Hide()
		end

		if WorldMapFrame:IsShown() then
			WorldMapFrame_Update()
		end
	end
end

function FC:Initialize()
	local _, _, _, enabled, _, reason = GetAddOnInfo("Mapster")
	if reason ~= "MISSED" and enabled then return end

	if not E.db.enhanced.map.fogClear.enable then return end

	self:UpdateFog()
end

local function InitializeCallback()
	FC:Initialize()
end

E:RegisterModule(FC:GetName(), InitializeCallback)