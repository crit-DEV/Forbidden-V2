# `Tracking`

Continuous retracking of a moving target. When `Tracking.Enabled` is `true` and the target passed to `AI.SmartPathfind` is an `Instance`, Forbidden will keep refreshing the path while the target moves.

| Setting | Type | Default | Description |
|---|---|---|---|
| `Tracking.Enabled` | `boolean` | `false` | **Master switch.** When `false`, `SmartPathfind` runs as a one-shot path. |
| `Tracking.PredictionMagnitude` | `number` (studs) | `2` | How far ahead, along the target's velocity vector, the NPC aims. Higher values → the NPC anticipates motion more aggressively. |
| `Tracking.CollinearTargetPositionOffset` | `number` (studs) | `2` | Offsets the planning target along the line from NPC to target. Used by `MoveTo` operations to avoid head-on collisions / standing inside the target. |
| `Tracking.DistanceMovedThreshold` | `number` (studs) | `1` | Minimum distance the target must move before a retrack is considered. |

## Sub-objects
- [`Tracking.DynamicRetrack.MoveTo`](#trackingdynamicretrackmoveto) — retrack timing after a `DirectMoveTo`.
- [`Tracking.DynamicRetrack.Pathfind`](#trackingdynamicretrackpathfind) — retrack timing after a full pathfind.

---

## `Tracking.DynamicRetrack.MoveTo`
Controls how soon Forbidden may retrack after the most recent operation was a [`DirectMoveTo`](./direct-move-to.md).

| Setting | Type | Default | Description |
|---|---|---|---|
| `MinTimer` | `number` (s) | `0` | Minimum delay between retracks. |
| `MaxTimer` | `number` (s) | `1` | Maximum delay between retracks. |
| `GetRetrackTimeFunction` | `(NPC, Target) -> number` | `max(distance - 20, 0) / 40` | Returns the desired retrack delay. The default returns `0` for the first ~20 studs, then scales by 1s per 40 studs. The result is clamped to `[MinTimer, MaxTimer]`. |
| `ShouldRetrackFunction` | `(NPC, Target) -> boolean` | `return true` | Veto hook. Return `false` to skip a retrack. |

## `Tracking.DynamicRetrack.Pathfind`
Controls how soon Forbidden may retrack after the most recent operation was a full pathfind.

| Setting | Type | Default | Description |
|---|---|---|---|
| `MinTimer` | `number` (s) | `0.5` | Minimum delay between pathfind retracks. |
| `MaxTimer` | `number` (s) | `3` | Maximum delay between pathfind retracks. |
| `GetRetrackTimeFunction` | `(NPC, Target) -> number` | `distance / 80` | Returns the desired retrack delay (~1s per 80 studs). Clamped to `[MinTimer, MaxTimer]`. |
| `ShouldRetrackFunction` | `(NPC, Target) -> boolean` | `return true` | Veto hook. Return `false` to skip a retrack. |

> **Caveat from source:** because of how the config snapshot is taken, replacing only the *value* a function reads will not affect already-bound retrack functions. To change behavior, replace the function itself.

---

## Examples

### Chase a player
```lua
local config = AI.GetConfig(npc)
config.Tracking.Enabled = true
config.Tracking.DistanceMovedThreshold = 1
config.DirectMoveTo.Enabled = true
config:ApplyNow()

AI.SmartPathfind(npc, targetPlayer, false, "High")
```

### Slow, deliberate retrack
```lua
config.Tracking.Enabled = true
config.Tracking.DynamicRetrack.Pathfind.MinTimer = 1.0
config.Tracking.DynamicRetrack.Pathfind.MaxTimer = 5.0
config.Tracking.DynamicRetrack.Pathfind.GetRetrackTimeFunction =
    function(npc, target) return 2 end
```

### Conditional retrack
```lua
config.Tracking.DynamicRetrack.MoveTo.ShouldRetrackFunction =
    function(npc, target)
        return target:IsA("Player") and target.Character ~= nil
    end
```

## Related
- [`WaypointSkipping.TrackingPathfindSkip`](./waypoint-skipping.md) — leading-waypoint skipping in tracking mode.
- [`DirectMoveTo`](./direct-move-to.md) — short-range optimization invoked between retracks.
