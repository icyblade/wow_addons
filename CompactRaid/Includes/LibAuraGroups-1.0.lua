------------------------------------------------------------
-- LibAuraGroups-1.0.lua
--
-- A library for maintaining "aura groups", that is, buffs/debuffs those provide similar
-- effects, for example, Druid spell "Mark of the Wild" and Paladin spell "Blessing of Kings"
-- both provide "+5% to all stats", so they belong to the same aura group called "STATS".
--
-- Abin
-- 2012/9/08
--
------------------------------------------------------------
-- API documentation:
------------------------------------------------------------

-- lib = _G["LibAuraGroups"]
--
-- Get an object handle of the library.
------------------------------------------------------------

-- lib:GetGroupLocalName("group")
--
-- Returns localized name of the group.
------------------------------------------------------------

-- lib:GetAuraGroup("aura")
--
-- Returns name of the group to which the given aura belongs, if one exists.
------------------------------------------------------------

-- lib:GetGroupAuras("group")
--
-- Returns a table contains all auras belong to the given group, in format of { ["aura"] = spellId, ... },
-- or nil if the group does not exist.
------------------------------------------------------------

-- lib:UnitAura("unit", "aura" [, "group"])
--
-- Find the first aura that belongs to the same group with the given aura, if "group" is not
-- specified, the function searches for all groups until a match is found. Return values are:
-- name, icon, count, dispelType, duration, expires, caster, harmful.
------------------------------------------------------------

-- lib:AuraSameGroup("aura1", "aura2")
--
-- Returns name of the group to which both of the 2 given auras belong to.

------------------------------------------------------------
-- Group names & contents:
------------------------------------------------------------
--
-- STATS
-- STAMINA
-- ATTACK_POWER
-- SPELL_POWER
-- VERSATILITY
-- HASTE
-- CRITICAL_STRIKE
-- MULTISTRIKE
-- MASTERY
-- BLOODLUST
-- ICE_BLOCK
-- DEVINE_SHIELD
-- POWERWORD_SHIELD

------------------------------------------------------------

local AURA_GROUPS = {

	["STATS"] = {		-- 属性

		1126,		-- 德鲁伊：野性印记
		115921,		-- 武僧：帝王传承
		116781,		-- 武僧：白虎传承
		20217,		-- 圣骑士：王者祝福
		90363,		-- 页岩蛛：页岩蛛之拥
		159988,		-- 狗：野性嚎叫
		160017,		-- 猩猩：金刚之力
		160077,		-- 虫：大地之力
		160206,		-- 独来独往：巨猿之力
	},

	["STAMINA"] = {		-- 耐力

		21562,		-- 牧师：真言术：韧
		166928,		-- 术士：血之契印
		469,		-- 战士：命令怒吼
		160003,		-- 双头飞龙：野性活力
		160014,		-- 山羊：坚韧
		90364,		-- 异种虫：其拉虫群坚韧
		160199,		-- 独来独往：巨熊之韧
	},

	["ATTACK_POWER"] = {	-- 攻击强度

		57330,		-- 死亡骑士：寒冬号角
		19506,		-- 猎人：强击光环
		6673,		-- 战士：战斗怒吼
	},

	["SPELL_POWER"] = {	-- 法术强度

		1459,		-- 法师：奥术光辉
		61316,		-- 法师：达拉然光辉
		109773,		-- 术士：黑暗意图
		90364,		-- 异种虫：其拉虫群坚韧
		126309,		-- 水黾：静水
		160205,		-- 独来独往：神龙之智
	},

	["VERSATILITY"] = {	-- 全能

		55610,		-- 死亡骑士：邪恶光环
		1126,		-- 德鲁伊：野性印记
		167187,		-- 圣骑士：圣洁光环
		167188,		-- 战士：英姿勃发
		159735,		-- 猛禽：坚韧
		35290,		-- 野猪：不屈
		160045,		-- 箭猪：防御鬃毛
		50518,		-- 掠食者：角质护甲
		57386,		-- 裂蹄牛：狂野之力
		160077,		-- 虫：大地之力
		172967,		-- 独来独往：掠食者之力
	},

	["HASTE"] = {		-- 急速

		55610,		-- 死亡骑士：邪恶光环
		49868,		-- 牧师：思维加速
		113742,		-- 潜行者：狡诈迅刃
		116956,		-- 萨满祭司：风之优雅
		160003,		-- 双头飞龙：野性活力
		135678,		-- 孢子蝠：充能孢子
		160074,		-- 黄蜂：虫群之速
		160203,		-- 独来独往：土狼之速
	},

	["CRITICAL_STRIKE"] = {	-- 爆击

		17007,		-- 德鲁伊：兽群领袖
		1459,		-- 法师：奥术光辉
		61316,		-- 法师：达拉然光辉
		116781,		-- 武僧：白虎传承
		90309,		-- 魔暴龙：惊人咆哮
		126373,		-- 魁麟：无畏之嚎
		160052,		-- 迅猛龙：兽群之力
		90363,		-- 页岩蛛：页岩蛛之拥
		126309,		-- 水黾：静水
		24604,		-- 狼：狂怒之嚎
		160200,		-- 独来独往：迅猛龙之恶
	},

	["MULTISTRIKE"] = {	-- 溅射

		166916,		-- 武僧：狂风骤雨
		49868,		-- 牧师：思维加速
		113742,		-- 潜行者：狡诈迅刃
		109773,		-- 术士：黑暗意图
		159733,		-- 蜥蜴：怨毒凝视
		54644,		-- 奇美拉：冰霜吐息
		58604,		-- 熔岩犬：狂暴撕咬
		34889,		-- 龙鹰：迅捷打擊
		160011,		-- 狐狸：矫健身姿
		57386,		-- 裂蹄牛：狂野之力
		24844,		-- 风蛇：狂风呼啸
		172968,		-- 独来独往：龙鹰之速
	},

	["MASTERY"] = {		-- 精通

		155522,		-- 死亡骑士：幽冥之力
		24907,		-- 德鲁伊：枭兽光环
		19740,		-- 圣骑士：力量祝福
		16956,		-- 萨满祭司：风之优雅
		93435,		-- 猫科：勇气咆哮
		160039,		-- 多头蛇：敏锐感知
		128997,		-- 灵魂兽：灵魂兽祝福
		160073,		-- 陆行鸟：平步青云
		160198,		-- 独来独往：猫之优雅
	},

	["BLOODLUST"] = {	-- 嗜血加速

		2825,		-- 萨满祭司：嗜血
		32182,		-- 萨满祭司：英勇
		80353,		-- 法师：时间扭曲
		160452,		-- 虚空鳐：虚空之风
		90355,		-- 熔岩犬：远古狂乱
		57723,		-- 精疲力尽
		57724,		-- 心满意足
		80354,		-- 时空错位
	},

	["ICE_BLOCK"] = {	-- 法师

		27619,		-- 寒冰屏障
		41425,		-- 低温
	},

	["DEVINE_SHIELD"] = {	-- 圣骑士

		642,		-- 圣盾术
		1022,		-- 保护之手
		25771,		-- 自律
	},

	["POWERWORD_SHIELD"] = {-- 牧师

		17,		-- 真言术：盾
		6788,		-- 虚弱灵魂
	},
}

local type = type
local select = select
local GetSpellInfo = GetSpellInfo
local pairs = pairs
local ipairs = ipairs
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff

local LIBNAME = "LibBuffGroups-1.0"
local VERSION = 1.21

local lib = _G[LIBNAME]
if lib and lib.version >= VERSION then return end

if not lib then
	lib = {}
	_G[LIBNAME] = lib
end
lib.version = VERSION
_G.LibBuffGroups = lib

lib.auraGroupList = {}

local function AddGroup(groupList, group, ...)
	if type(group) ~= "string" then
		return
	end

	local count = select("#", ...)
	if count < 1 then
		return
	end

	local list = groupList[group]
	if not list then
		list = {}
		groupList[group] = list
	end

	local i
	for i = 1, count do
		local id = select(i, ...)
		local name = GetSpellInfo(id)
		if name then
			list[name] = id
		end
	end
end

function lib:GetAuraGroup(aura)
	if not aura then
		return
	end

	local group
	for group, list in pairs(lib.auraGroupList) do
		if list[aura] then
			return group
		end
	end
end

local function InternalGetGroupAuras(group)
	return lib.auraGroupList[group]
end

function lib:GetGroupAuras(group)
	local list = InternalGetGroupAuras(group)
	if not list then
		return
	end

	local temp = {}
	local k, v
	for k, v in pairs(list) do
		temp[k] = v
	end
	return temp
end

local function FindAura(list, unit, exclude)
	if not list then
		return
	end

	local _, aura, name, icon, count, dispelType, duration, expires, caster
	for aura in pairs(list) do
		if aura ~= exclude then
			name, _, icon, count, dispelType, duration, expires, caster = UnitBuff(unit, aura)
			if name then
				return name, icon, count, dispelType, duration, expires, caster
			end

			name, _, icon, count, dispelType, duration, expires, caster = UnitDebuff(unit, aura)
			if name then
				return name, icon, count, dispelType, duration, expires, caster, 1
			end
		end
	end
end

function lib:UnitAura(unit, aura, group)
	if type(unit) ~= "string" then
		return
	end

	if type(aura) ~= "string" then
		return FindAura(InternalGetGroupAuras(group), unit)
	end

	local name, _, icon, count, dispelType, duration, expires, caster = UnitBuff(unit, aura)
	if name then
		return name, icon, count, dispelType, duration, expires, caster
	end

	name, _, icon, count, dispelType, duration, expires, caster = UnitDebuff(unit, aura)
	if name then
		return name, icon, count, dispelType, duration, expires, caster, 1
	end

	local list = InternalGetGroupAuras(group)
	if not list then
		local _, v
		for _, v in pairs(lib.auraGroupList) do
			if v[aura] then
				list = v
				break
			end
		end
	end

	return FindAura(list, unit, aura)
end

function lib:AuraSameGroup(aura1, aura2)
	if aura1 and aura2 and aura1 ~= aura2 then
		local group, list
		for group, list in pairs(lib.auraGroupList) do
			if list[aura1] and list[aura2] then
				return group
			end
		end
	end
end

local GROUP_NAMES = {
	STATS = STAT_CATEGORY_ATTRIBUTES,
	STAMINA = SPELL_STAT3_NAME,
	ATTACK_POWER = STAT_CATEGORY_ATTRIBUTES,
	SPELL_POWER = STAT_SPELLPOWER,
	VERSATILITY = STAT_VERSATILITY,
	HASTE = STAT_HASTE,
	CRITICAL_STRIKE = STAT_CRITICAL_STRIKE,
	MULTISTRIKE = STAT_MULTISTRIKE,
	MASTERY = STAT_MASTERY,
	BLOODLUST = GetSpellInfo(2825),
	ICE_BLOCK = GetSpellInfo(27691),
	DEVINE_SHIELD = GetSpellInfo(642),
	POWERWORD_SHIELD = GetSpellInfo(17),
}

function lib:GetGroupLocalName(group)
	return GROUP_NAMES[group]
end

do
	local group, data
	for group, data in pairs(AURA_GROUPS) do
		local list = {}
		lib.auraGroupList[group] = list

		local _, id
		for _, id in ipairs(data) do
			local name = GetSpellInfo(id)
			if name then
				list[name] = id
			end
		end
	end
end