# Config Presets

Presets are named snapshots of a config. They are useful when an NPC needs to swap between distinct behavioral profiles (idle, chasing, fleeing, etc.) at runtime.

Source: `src/Forbidden/AI/ConfigHandler/init.luau`.

## Local vs Global Presets
- **Local** presets live on a single NPC's config and are not visible to other NPCs.
- **Global** presets are shared across every NPC. Save with `SaveGlobally = true`.

When loading a preset, both stores are checked. By default the local preset wins; pass `UseGlobalIfBothFound = true` to flip that.

## Methods

| Method | Description |
|---|---|
| `config:SavePreset(name, saveGlobally?)` | Save the current local config under `name`. The internal `NPC` reference is stripped before saving. |
| `config:LoadPreset(name, useGlobalIfBothFound?)` | Replace the local config with a previously saved preset. **Does not auto-apply.** Call `config:ApplyNow()` if mid-cycle. |
| `config:RestoreDefaults()` | Restore the local config to `Defaults.luau`. |
| `config:RestoreActiveConfig()` | Restore the local config to whatever the running pathfinder is currently using. |
| `config:ApplyNow()` | Make the local config visible to the running pathfinder immediately. |

## Lifecycle
1. `AI.GetConfig(npc)` returns the **local** config (a draft).
2. Edits to it sit in the draft until either:
   - the next `AI.SmartPathfind`, **or**
   - `config:ApplyNow()`.
3. The pathfinder reads from the **active** config — a deep copy of the local config taken at apply time.

## Examples

### Save and reload a profile
```lua
local config = AI.GetConfig(npc)
config.Tracking.Enabled = true
config:SavePreset("Chasing")

config.Tracking.Enabled = false
config:LoadPreset("Chasing")
print(config.Tracking.Enabled) -- true
```

### Share a profile across all NPCs
```lua
local config = AI.GetConfig(npc)
config.Visualization.Enabled = true
config:SavePreset("Debug", true) -- global

-- elsewhere, on a different NPC:
local otherCfg = AI.GetConfig(otherNpc)
otherCfg:LoadPreset("Debug", true) -- prefer global
otherCfg:ApplyNow()
```

### Discard mid-cycle edits
```lua
local config = AI.GetConfig(npc)
config.Tracking.CollinearTargetPositionOffset = 1
AI.SmartPathfind(npc, target)             -- snapshot taken at offset = 1
config.Tracking.CollinearTargetPositionOffset = 3
config:RestoreActiveConfig()              -- offset reverts to 1
```

## Internal API
Available, but not part of the public contract:

```lua
local ConfigHandler = require(rs.Forbidden.AI.ConfigHandler)

ConfigHandler.SaveGlobalPreset("Chasing", config) -- equivalent to config:SavePreset("Chasing", true)
ConfigHandler.GetActiveConfig(npc)                -- read the currently-active snapshot
ConfigHandler.TriggerCleanup(npc)                 -- drop all stored configs/presets for the NPC
```
