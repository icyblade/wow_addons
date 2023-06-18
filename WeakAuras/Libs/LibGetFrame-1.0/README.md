# LibGetFrame

Return unit frame for a given unit

## Usage

```Lua
local LGF = LibStub("LibGetFrame-1.0")
local frame = LGF.GetUnitFrame(unit , options)
```

## Options

- framePriorities : array, default :

```Lua
{
    -- raid frames
    [1] = "^Vd1", -- vuhdo
    [2] = "^Vd2", -- vuhdo
    [3] = "^Vd3", -- vuhdo
    [4] = "^Vd4", -- vuhdo
    [5] = "^Vd5", -- vuhdo
    [6] = "^Vd", -- vuhdo
    [7] = "^HealBot", -- healbot
    [8] = "^GridLayout", -- grid
    [9] = "^Grid2Layout", -- grid2
    [10] = "^PlexusLayout", -- plexus
    [11] = "^ElvUF_RaidGroup", -- elv
    [12] = "^oUF_bdGrid", -- bdgrid
    [13] = "^oUF_.-Raid", -- generic oUF
    [14] = "^LimeGroup", -- lime
    [15] = "^SUFHeaderraid", -- suf
    -- party frames
    [16] = "^AleaUI_GroupHeader", -- Alea
    [17] = "^SUFHeaderparty", --suf
    [18] = "^ElvUF_PartyGroup", -- elv
    [19] = "^oUF_.-Party", -- generic oUF
    [20] = "^PitBull4_Groups_Party", -- pitbull4
    [21] = "^CompactRaid", -- blizz
    [22] = "^CompactParty", -- blizz
    -- player frame
    [23] = "^SUFUnitplayer",
    [24] = "^PitBull4_Frames_Player",
    [25] = "^ElvUF_Player",
    [26] = "^oUF_.-Player",
    [27] = "^PlayerFrame",
}
```

- ignorePlayerFrame : boolean (default true)
- ignoreTargetFrame : boolean (default true)
- ignoreTargettargetFrame : boolean (default true)
- ignorePartyTargetFrame : boolean (default true)
- playerFrames : array, default :

```Lua
{
    "SUFUnitplayer",
    "PitBull4_Frames_Player",
    "ElvUF_Player",
    "oUF_.-Player",
    "oUF_PlayerPlate",
    "PlayerFrame",
}
```

- targetFrames : array, default :

```Lua
{
    "SUFUnittarget",
    "PitBull4_Frames_Target",
    "ElvUF_Target",
    "oUF_.-Target",
    "TargetFrame",
}
```

- targettargetFrames : array, default :

```Lua
{
    "SUFUnittargetarget",
    "PitBull4_Frames_Target's target",
    "ElvUF_TargetTarget",
    "oUF_.-TargetTarget",
    "oUF_ToT",
    "TargetTargetFrame",
}
```

- ignorePartyTargetFrame : array, default :

```Lua
{
    "SUFChildpartytarget",
}
```

- ignoreFrames : array, default :

```Lua
{
        "PitBull4_Frames_Target's target's target",
        "ElvUF_PartyGroup%dUnitButton%dTarget",
        "ElvUF_FocusTarget",
        "RavenButton"
}
```

- returnAll : boolean (default false)

## Examples

### Glow player frame

```Lua
local LGF = LibStub("LibGetFrame-1.0")
local LCG = LibStub("LibCustomGlow-1.0")
local frame = LGF.GetUnitFrame("player")

if frame then
  LCG.ButtonGlow_Start(frame)
  -- LCG.ButtonGlow_Stop(frame)
end
```

### Glow every frames for your target

```Lua
local LGF = LibStub("LibGetFrame-1.0")
local LCG = LibStub("LibCustomGlow-1.0")

local frames = LGF.GetUnitFrame("target", {
      ignorePlayerFrame = false,
      ignoreTargetFrame = false,
      ignoreTargettargetFrame = false,
      returnAll = true,
})

for _, frame in pairs(frames) do
   LCG.ButtonGlow_Start(frame)
   --LCG.ButtonGlow_Stop(frame)
end
```

### Ignore Vuhdo panel 2 and 3

```Lua
local frame = LGF.GetUnitFrame("player", {
      ignoreFrames = { "Vd2.*", "Vd3.*" }
})
```

[GitHub Project](https://github.com/mrbuds/LibGetFrame)
