if GetLocale() ~= 'ruRU' then return end
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
local L = HandyNotes.Locals

L.OptionsDescription = "Местоположение редких монстров на Вневременном острове."
L.OptionsArgsDescription = "Эти настройки определяют внешний вид иконки."
L.OptionsIconScaleName = "Масштаб иконки"
L.OptionsIconScaleDescription = "Масштаб иконки"
L.OptionsIconAlphaName = "Прозрачность иконки"
L.OptionsIconAlphaDescription = "Прозрачность иконки"

L.EmeralGander = "Изумрудный гусак"
L.EmeralGanderDrop = "Ветроперый плюмаж"
L.EmeralGanderInfo = "появляется в разным местах вокруг двора Небожителей."

L.IronfurSteelhorn = "Твердорогий сталемех"
L.IronfurSteelhornDrop = "Стеганая шкура яка"

L.ImperialPython = "Императорский питон"
L.ImperialPythonDrop = "Детеныш смертолаза"

L.GreatTurtleFuryshell = "Большая черепаха Гневный Панцирь"
L.GreatTurtleFuryshellDrop = "Укрепленный панцирь"
L.GreatTurtleFuryshellInfo = "прогуливается среди черепах на западном берегу острова."

L.GuchiSwarmbringer = "Гу'чи Зовущий Рой"
L.GuchiSwarmbringerDrop = "Роевик Гу'чи"
L.GuchiSwarmbringerInfo = "появляется вокруг деревни Пи'джоу"

L.Zesqua = "Зесква"
L.ZesquaDrop = "Дождевой камень"
L.ZesquaInfo = "появляется вдоль берега Пи'джоу, немного восточнее."

L.ZhuGonSour = "Чжу-Гонь Прокисший"
L.ZhuGonSourDrop = "Прокисший хмелементаль"
L.ZhuGonSourInfo = "появляется после завершения мини-события Прокисшее Пиво."

L.Karkanos = "Карканос"
L.KarkanosDrop = "Огромный кошелек с вневременными монетами"
L.KarkanosInfo = "призывается после разговора с рыбаком Финем Длинной Лапой. Рыбак приходит на пристань каждый час."

L.Chelon = "Шелон"
L.ChelonDrop = "Укрепленный панцирь"
L.ChelonInfo = "появляется после исследования панцыря."

L.Spelurk = "Чароброд"
L.SpelurkDrop = "Проклятый талисман"
L.SpelurkInfo = "может быть вызван после разрушения обвала в пещере Таинственное логово. Для того, чтобы попасть внутрь необходимо разрушить обвал камней с помощью абилок от пандаренских артефактов из достижения Легенды вне времени. Альтернативный способ маг может блинкануться через камни и использовать Молот камнетеса."

L.Cranegnasher = "Журавлецап"
L.CranegnasherDrop = "Нетронутая шкура охотника"
L.CranegnasherInfo = "Этот редкий тигр не появляется сам, его нужно выманивать. Нужно найти окровавленный труп Журавля-рыбоеда. Труп можно обыскать и прочитать подсказку о том, что эти журавли служат кое-кому пищей. Заагрите одного из Журавлей-рыбоедов, находящихся южнее на берегу океана. Приведите его к трупу — Журавлецап появится и атакует вас."

L.Rattleskew = "Косохрип"
L.RattleskewDrop = "Утраченная нога капитана Звездана"
L.RattleskewInfo = "Ивент, в финале которого спавнится рарник Косохрип, стартует НПС Капитан Звездан."

L.MonstrousSpineclaw = "Огромный хребтохват"
L.MonstrousSpineclawDrop = "Краб-хребтохват"
L.MonstrousSpineclawInfo = "прогуливается под водой у южного побережья острова."

L.SpiritJadefire = "Дух Нефритового Пламени"
L.SpiritJadefireDrop = "Мерцающий зеленый пепел"
L.SpiritJadefireDrop2 = "Дух нефритового пламени"
L.SpiritJadefireInfo = "появляется в пещере Заблудших Духов."

L.Leafmender = "Целитель листвы"
L.LeafmenderDrop = "Малый дух ясеневого листа"
L.LeafmenderInfo = "появляется в Сверкающем Пути, около дерева."

L.Bufo = "Буфо"
L.BufoDrop = "Юная хваткая лягушка"
L.BufoInfo = "появляется в области обитания Хватких лягушек."

L.Garnia = "Гарния"
L.GarniaDrop = "Рубиновая капля"
L.GarniaInfo = "появляется в Красном озере."

L.Tsavoka = "Тсаво'ка"
L.TsavokaDrop = "Нетронутая шкура охотника"
L.TsavokaInfo = "появляется в пещере."

L.Stinkbraid = "Вонекос"
L.StinkbraidInfo = "появляется на палубе пиратского корабля."

L.RockMoss = "Пещерный Мох"
L.RockMossDrop = "Золотой мох"
L.RockMossInfo = "появляется в низу пещеры Заблудших Духов."

L.WatcherOsu = "Смотритель Осу"
L.WatcherOsuDrop = "Пепельный камень"
L.WatcherOsuInfo = "появляется в Руинах Огнеходов."

L.JakurOrdon = "Якур Ордосский"
L.JakurOrdonDrop = "Предупредительный знак"
L.JakurOrdonInfo = "появляется девее Руин Огнеходов."

L.ChampionBlackFlame = "Защитник Черного Пламени"
L.ChampionBlackFlameDrop = "Кинжалы Черного Пламени"
L.ChampionBlackFlameDrop2 = "Большой мешок трав"
L.ChampionBlackFlameInfo = "прогуливается между двумя мостами Сверкающего Пути."

L.Cinderfall = "Пеплопад"
L.CinderfallDrop = "Падающее пламя"
L.CinderfallInfo = "появляется на разрушенном мосту."

L.UrdurCauterizer = "Урдур Прижигатель"
L.UrdurCauterizerDrop = "Закатный камень"
L.UrdurCauterizerInfo = "появляется в западной части Святилища Ордоса."

L.FlintlordGairan = "Повелитель кремня Гайран"
L.FlintlordGairanDrop = "Ордосский смертный колокол"
L.FlintlordGairanInfo = "появляется в разным местах около Святилища Ордоса."

L.Huolon = "Холон"
L.HuolonDrop = "Поводья грозового ониксового облачного змея"
L.HuolonInfo = "летает около Сверкающего Пути и Руин Огнеходов."

L.Golganarr = "Голганарр"
L.GolganarrDrop = "Странный отполированный камень"
L.GolganarrDrop2 = "Блестящая груда камней"
L.GolganarrInfo = "появляется в этом месте."

L.Evermaw = "Вечножор"
L.EvermawDrop = "Затуманенный фонарь духов"
L.EvermawInfo = "плывёт по часовой стрелке вокруг острова к Проклятому кораблю 'Вазувию'."

L.DreadShipVazuvius = "Проклятый корабль 'Вазувий'"
L.DreadShipVazuviusDrop = "Сказание о затерянном во времени мореходе"
L.DreadShipVazuviusInfo = "призывается с помощью Затуманенного фонаря духов (дроп с Вечножор)."

L.ArchiereusFlame = "Архиерей пламени"
L.ArchiereusFlameDrop = "Эликсир древнего знания"
L.ArchiereusFlameInfo = "появляется внутри Святилища Ордоса. Игроки не имеющий легендарного плащя могут призвать его с помощью Свитка вызова у камня испытаний."

L.Rattleskew ="Косохрип"
L.RattleskewDrop ="Утраченная нога капитана Звездана"
L.RattleskewDrop2 ="Техника: символ скелета"
L.RattleskewInfo ="появляется по заверщению события, которое начинает Капитан Звездан, находящийся на затонувшем разрущеном карабле в этом месте."