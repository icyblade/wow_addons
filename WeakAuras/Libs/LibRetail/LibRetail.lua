local MAJOR_VERSION = "LibRetail"
local MINOR_VERSION = 2
if not LibStub then error(MAJOR_VERSION .. " requires LibStub.") end
local lib, oldversion = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end

LibStub("AceTimer-3.0"):Embed(lib)

-- Lua APIs
local pairs, ipairs, next, select, CreateFrame, pcall, print = pairs, ipairs, next, select, CreateFrame, pcall, print

local math_abs, math_ceil, math_floor = math.abs, math.ceil, math.floor

-------------------------------------
local _, tbl = ...;
if tbl then
	tbl.SecureCapsuleGet = SecureCapsuleGet;

	local function Import(name)
		tbl[name] = tbl.SecureCapsuleGet(name);
	end

	setfenv(1, tbl);

	function lib.Mixin(object, ...)
		for i = 1, select("#", ...) do
			local mixin = select(i, ...);
			for k, v in pairs(mixin) do
				object[k] = v;
			end
		end

		return object;
	end

	function lib.CreateFromMixins(...)
		return lib.Mixin({}, ...)
	end

	Import("math");
	Import("GetTickTime");
end

lib.ObjectPoolMixin = {};
function lib.ObjectPoolMixin:OnLoad(creationFunc, resetterFunc)
	self.creationFunc = creationFunc;
	self.resetterFunc = resetterFunc;

	self.activeObjects = {};
	self.inactiveObjects = {};

	self.numActiveObjects = 0;
end

function lib.ObjectPoolMixin:Acquire()
	local numInactiveObjects = #self.inactiveObjects;
	if numInactiveObjects > 0 then
		local obj = self.inactiveObjects[numInactiveObjects];
		self.activeObjects[obj] = true;
		self.numActiveObjects = self.numActiveObjects + 1;
		self.inactiveObjects[numInactiveObjects] = nil;
		return obj, false;
	end

	local newObj = self.creationFunc(self);
	if self.resetterFunc then
		self.resetterFunc(self, newObj);
	end
	self.activeObjects[newObj] = true;
	self.numActiveObjects = self.numActiveObjects + 1;
	return newObj, true;
end

function lib.ObjectPoolMixin:Release(obj)
	if self:IsActive(obj) then
		self.inactiveObjects[#self.inactiveObjects + 1] = obj;
		self.activeObjects[obj] = nil;
		self.numActiveObjects = self.numActiveObjects - 1;
		if self.resetterFunc then
			self.resetterFunc(self, obj);
		end

		return true;
	end

	return false;
end

function lib.ObjectPoolMixin:ReleaseAll()
	for obj in pairs(self.activeObjects) do
		self:Release(obj);
	end
end

function lib.ObjectPoolMixin:EnumerateActive()
	return pairs(self.activeObjects);
end

function lib.ObjectPoolMixin:GetNextActive(current)
	return (next(self.activeObjects, current));
end

function lib.ObjectPoolMixin:IsActive(object)
	return (self.activeObjects[object] ~= nil);
end

function lib.ObjectPoolMixin:GetNumActive()
	return self.numActiveObjects;
end

function lib.ObjectPoolMixin:EnumerateInactive()
	return ipairs(self.inactiveObjects);
end

function lib.CreateObjectPool(creationFunc, resetterFunc)
	local objectPool = lib.CreateFromMixins(lib.ObjectPoolMixin);
	objectPool:OnLoad(creationFunc, resetterFunc);
	return objectPool;
end

lib.FramePoolMixin = lib.CreateFromMixins(lib.ObjectPoolMixin);

local function FramePoolFactory(framePool)
	return CreateFrame(framePool.frameType, nil, framePool.parent, framePool.frameTemplate);
end

local function ForbiddenFramePoolFactory(framePool)
	return CreateForbiddenFrame(framePool.frameType, nil, framePool.parent, framePool.frameTemplate);
end

function lib.FramePoolMixin:OnLoad(frameType, parent, frameTemplate, resetterFunc, forbidden)
	if forbidden then
		lib.ObjectPoolMixin.OnLoad(self, ForbiddenFramePoolFactory, resetterFunc);
	else
		lib.ObjectPoolMixin.OnLoad(self, FramePoolFactory, resetterFunc);
	end
	self.frameType = frameType;
	self.parent = parent;
	self.frameTemplate = frameTemplate;
end

function lib.FramePoolMixin:GetTemplate()
	return self.frameTemplate;
end

function lib.FramePool_Hide(framePool, frame)
	frame:Hide();
end

function lib.FramePool_HideAndClearAnchors(framePool, frame)
	frame:Hide();
	frame:ClearAllPoints();
end

function lib.CreateFramePool(frameType, parent, frameTemplate, resetterFunc, forbidden)
	local framePool = lib.CreateFromMixins(lib.FramePoolMixin);
	framePool:OnLoad(frameType, parent, frameTemplate, resetterFunc or lib.FramePool_HideAndClearAnchors, forbidden);
	return framePool;
end

lib.TexturePoolMixin = lib.CreateFromMixins(lib.ObjectPoolMixin);

local function TexturePoolFactory(texturePool)
	return texturePool.parent:CreateTexture(nil, texturePool.layer, texturePool.textureTemplate, texturePool.subLayer);
end

function lib.TexturePoolMixin:OnLoad(parent, layer, subLayer, textureTemplate, resetterFunc)
	lib.ObjectPoolMixin.OnLoad(self, TexturePoolFactory, resetterFunc);
	self.parent = parent;
	self.layer = layer;
	self.subLayer = subLayer;
	self.textureTemplate = textureTemplate;
end

lib.TexturePool_Hide = lib.FramePool_Hide;
lib.TexturePool_HideAndClearAnchors = lib.FramePool_HideAndClearAnchors;

function lib.CreateTexturePool(parent, layer, subLayer, textureTemplate, resetterFunc)
	local texturePool = lib.CreateFromMixins(lib.TexturePoolMixin);
	texturePool:OnLoad(parent, layer, subLayer, textureTemplate, resetterFunc or lib.TexturePool_HideAndClearAnchors);
	return texturePool;
end

lib.FontStringPoolMixin = lib.CreateFromMixins(lib.ObjectPoolMixin);

local function FontStringPoolFactory(fontStringPool)
	return fontStringPool.parent:CreateFontString(nil, fontStringPool.layer, fontStringPool.fontStringTemplate, fontStringPool.subLayer);
end

function lib.FontStringPoolMixin:OnLoad(parent, layer, subLayer, fontStringTemplate, resetterFunc)
	lib.ObjectPoolMixin.OnLoad(self, FontStringPoolFactory, resetterFunc);
	self.parent = parent;
	self.layer = layer;
	self.subLayer = subLayer;
	self.fontStringTemplate = fontStringTemplate;
end

lib.FontStringPool_Hide = lib.FramePool_Hide;
lib.FontStringPool_HideAndClearAnchors = lib.FramePool_HideAndClearAnchors;

function lib.CreateFontStringPool(parent, layer, subLayer, fontStringTemplate, resetterFunc)
	local fontStringPool = lib.CreateFromMixins(lib.FontStringPoolMixin);
	fontStringPool:OnLoad(parent, layer, subLayer, fontStringTemplate, resetterFunc or lib.FontStringPool_HideAndClearAnchors);
	return fontStringPool;
end

lib.ActorPoolMixin = lib.CreateFromMixins(lib.ObjectPoolMixin);

local function ActorPoolFactory(actorPool)
	return actorPool.parent:CreateActor(nil, actorPool.actorTemplate);
end

function lib.ActorPoolMixin:OnLoad(parent, actorTemplate, resetterFunc)
	lib.ObjectPoolMixin.OnLoad(self, ActorPoolFactory, resetterFunc);
	self.parent = parent;
	self.actorTemplate = actorTemplate;
end

lib.ActorPool_Hide = lib.FramePool_Hide;
function lib.ActorPool_HideAndClearModel(actorPool, actor)
	actor:ClearModel();
	actor:Hide();
end

function lib.CreateActorPool(parent, actorTemplate, resetterFunc)
	local actorPool = lib.CreateFromMixins(lib.ActorPoolMixin);
	actorPool:OnLoad(parent, actorTemplate, resetterFunc or lib.ActorPool_HideAndClearModel);
	return actorPool;
end

lib.FramePoolCollectionMixin = {};

function lib.CreateFramePoolCollection()
	local poolCollection = lib.CreateFromMixins(lib.FramePoolCollectionMixin);
	poolCollection:OnLoad();
	return poolCollection;
end

function lib.FramePoolCollectionMixin:OnLoad()
	self.pools = {};
end

function lib.FramePoolCollectionMixin:CreatePool(frameType, parent, template, resetterFunc, forbidden)
	assert(self:GetPool(template) == nil);
	local pool = lib.CreateFramePool(frameType, parent, template, resetterFunc, forbidden);
	self.pools[template] = pool;
	return pool;
end

function lib.FramePoolCollectionMixin:GetPool(template)
	return self.pools[template];
end

function lib.FramePoolCollectionMixin:Acquire(template)
	local pool = self:GetPool(template);
	assert(pool);
	return pool:Acquire();
end

function lib.FramePoolCollectionMixin:Release(object)
	for _, pool in pairs(self.pools) do
		if pool:Release(object) then
			-- Found it! Just return
			return;
		end
	end

	-- Huh, we didn't find that object
	assert(false);
end

function lib.FramePoolCollectionMixin:ReleaseAllByTemplate(template)
	local pool = self:GetPool(template);
	if pool then
		pool:ReleaseAll();
	end
end

function lib.FramePoolCollectionMixin:ReleaseAll()
	for key, pool in pairs(self.pools) do
		pool:ReleaseAll();
	end
end

function lib.FramePoolCollectionMixin:EnumerateActiveByTemplate(template)
	local pool = self:GetPool(template);
	if pool then
		return pool:EnumerateActive();
	end

	return nop;
end

function lib.FramePoolCollectionMixin:EnumerateActive()
	local currentPoolKey, currentPool = next(self.pools, nil);
	local currentObject = nil;
	return function()
		if currentPool then
			currentObject = currentPool:GetNextActive(currentObject);
			while not currentObject do
				currentPoolKey, currentPool = next(self.pools, currentPoolKey);
				if currentPool then
					currentObject = currentPool:GetNextActive();
				else
					break;
				end
			end
		end

		return currentObject;
	end, nil;
end

lib.FixedSizeFramePoolCollectionMixin = lib.CreateFromMixins(lib.FramePoolCollectionMixin);

function lib.CreateFixedSizeFramePoolCollection()
	local poolCollection = lib.CreateFromMixins(lib.FixedSizeFramePoolCollectionMixin);
	poolCollection:OnLoad();
	return poolCollection;
end

function lib.FixedSizeFramePoolCollectionMixin:OnLoad()
	lib.FramePoolCollectionMixin.OnLoad(self);
	self.sizes = {};
end

function lib.FixedSizeFramePoolCollectionMixin:CreatePool(frameType, parent, template, resetterFunc, forbidden, maxPoolSize, preallocate)
	local pool = lib.FramePoolCollectionMixin.CreatePool(self, frameType, parent, template, resetterFunc, forbidden);

	if preallocate then
		for i = 1, maxPoolSize do
			pool:Acquire();
		end
		pool:ReleaseAll();
	end

	self.sizes[template] = maxPoolSize;

	return pool;
end

function lib.FixedSizeFramePoolCollectionMixin:Acquire(template)
	local pool = self:GetPool(template);
	assert(pool);

	if pool:GetNumActive() < self.sizes[template] then
		return pool:Acquire();
	end
	return nil;
end

function lib.tIndexOf(tbl, item)
	for i, v in ipairs(tbl) do
		if item == v then
			return i;
		end
	end
end

function lib.tInvert(tbl)
	local inverted = {};
	for k, v in pairs(tbl) do
		inverted[v] = k;
	end
	return inverted;
end

function lib.xpcall(func, errorHandler, ...)
	-- errorHandler();
	return pcall(func, ...)
end

function lib.Round(value)
	if value < 0.0 then
		return math_ceil(value - .5);
	end
	return math_floor(value + .5);
end
