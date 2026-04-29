# Settings Index

Every page in this folder documents one top-level field of the per-NPC config returned by `AI.GetConfig(NPC)`.

```lua
local AI = require(game:GetService("ReplicatedStorage").Forbidden.AI)
local config = AI.GetConfig(workspace.NPC)

-- Edits are local-first. They are picked up automatically on the next
-- AI.SmartPathfind call, or you can apply them immediately:
config.Tracking.Enabled = true
config:ApplyNow()
```

## Categories

| Category | Description |
|---|---|
| [`StopType`](./stop-type.md) | What the NPC does when `AI.Stop` is called. |
| [`Unstucking`](./unstucking.md) | Stuck detection, retry budget, and stuck hook control. |
| [`RequestPrioritization`](./request-prioritization.md) | How competing pathfind requests are arbitrated. |
| [`AgentInfo`](./agent-info.md) | Mirrors Roblox `PathfindingService.CreatePath` agent parameters. |
| [`Visualization`](./visualization.md) | In-world debug drawing for paths, raycasts, tethers, etc. |
| [`Tracking`](./tracking.md) | Continuous retracking of moving targets, with dynamic retrack timers. |
| [`WaypointSkipping`](./waypoint-skipping.md) | Skip leading waypoints to reduce stutter. |
| [`DirectMoveTo`](./direct-move-to.md) | Short-range straight-line movement optimization (with raycast, floor, jump, and collision-inferencing sub-systems). |
| [`Hooks`](./hooks.md) | Behavior callbacks (goal reached, stuck, pathing started/failed, etc.). |
| [`Debugging`](./debugging.md) | Internal log gating and verbosity. |

## See Also
- [Quick Reference: All Defaults](./ai-config-defaults.md) — flat table of every default value, in one place.
- [Config Presets](../guides/presets.md) — how to save/load named bundles of settings.
- [API Reference](../guides/api-reference.md) — public functions on `AI`.

## Apply Semantics
Every settings page assumes the same lifecycle:

1. `AI.GetConfig(npc)` returns the **local** config (a draft).
2. Edits are not seen by the running pathfinder until either:
   - the next call to `AI.SmartPathfind`, **or**
   - an explicit `config:ApplyNow()`.
3. The internally-active config is a deep copy and is restored with `config:RestoreActiveConfig()`.
4. `config:RestoreDefaults()` reverts the local config to `Defaults.luau`.
