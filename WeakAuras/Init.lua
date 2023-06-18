local AddonName, Private = ...
WeakAuras = {}
WeakAuras.L = {}
WeakAuras.frames = {}

WeakAuras.normalWidth = 1.3
WeakAuras.halfWidth = WeakAuras.normalWidth / 2
WeakAuras.doubleWidth = WeakAuras.normalWidth * 2

local versionStringFromToc = GetAddOnMetadata("WeakAuras", "Version")
local versionString = "@project-version-lua@"
local buildTime = "@build-time@"

--@debug@
if versionStringFromToc == "@project-version@" then
  versionStringFromToc = "Dev"
  buildTime = "Dev"
end
--@end-debug@

WeakAuras.versionString = versionStringFromToc
WeakAuras.buildTime = buildTime
WeakAuras.newFeatureString = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0|t"
WeakAuras.BuildInfo = select(4, GetBuildInfo())

function WeakAuras.IsClassic()
  return false
end

function WeakAuras.IsBCC()
  return false
end

function WeakAuras.IsRetail()
  return true
end

function WeakAuras.IsCorrectVersion()
  return true
end

WeakAuras.prettyPrint = function(...)
  print("|cff9900ffWeakAuras:|r ", ...)
end

-- Force enable WeakAurasCompanion and Archive because some addon managers interfere with it
EnableAddOn("WeakAurasCompanion")
EnableAddOn("WeakAurasArchive")

-- These function stubs are defined here to reduce the number of errors that occur if WeakAuras.lua fails to compile
function WeakAuras.RegisterRegionType()
end

function WeakAuras.RegisterRegionOptions()
end

function Private.StartProfileSystem()
end

function Private.StartProfileAura()
end

function Private.StopProfileSystem()
end

function Private.StopProfileAura()
end

function Private.StartProfileUID()
end

function Private.StopProfileUID()
end

-- If WeakAuras shuts down due to being installed on the wrong target, keep the bindings from erroring
function WeakAuras.StartProfile()
end

function WeakAuras.StopProfile()
end

function WeakAuras.PrintProfile()
end

function WeakAuras.CountWagoUpdates()
  -- XXX this is to work around the Companion app trying to use our stuff!
  return 0
end
