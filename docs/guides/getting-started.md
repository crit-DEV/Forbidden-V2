# Getting Started

This guide walks through installing Forbidden, wiring it into a Rojo project, and getting an NPC to pathfind.

## Requirements
- A Roblox project using **Rojo**.
- An NPC `Model` with a `Humanoid` (or any rig that responds to `Humanoid:MoveTo(Vector3)`).
- **Wally** for dependency management (or you can sync the source directly).

## Install With Wally
Add Forbidden to your `wally.toml`:

```toml
[dependencies]
forbidden = "crit-dev/forbidden-v2@2.0.1"
```

Then install:

```bash
wally install
```

## Rojo Layout
Forbidden expects to be reachable as `ReplicatedStorage.Forbidden`. The repo's `default.project.json` shows the canonical mount:

```json
"ReplicatedStorage": {
  "Forbidden": {
    "$path": "src/Forbidden",
    "Packages": {
      "$path": "Packages"
    }
  }
}
```

## Hello, NPC

```lua
local rs = game:GetService("ReplicatedStorage")
local Forbidden = require(rs.Forbidden)
local AI = Forbidden.AI

local npc = workspace.NPC
local destination = Vector3.new(0, 5, 0)

AI.SmartPathfind(npc, destination)
```

## Critical Warnings

> **Always insert anti-lag.** Without it, NPCs stutter as they get close to a player due to network ownership churn.

```lua
AI.InsertAntiLag(npc)
```

> **The NPC needs a `Humanoid`.** Anything that cannot respond to `Humanoid:MoveTo(Vector3)` will not work.

## Next Steps
- [API Reference](./api-reference.md) — every public function on `AI`.
- [Settings Index](../settings/README.md) — every per-NPC config field.
- [Config Presets](./presets.md) — save and load named config bundles.
- [Hook Callbacks](./hooks.md) — react to lifecycle events.
