# `WaypointSkipping`

Skip the first N waypoints of every computed path. Useful because `PathfindingService` often emits a few back-tracking waypoints near the start of a path that produce a visible jitter when the NPC tries to walk them.

| Setting | Type | Default | Description |
|---|---|---|---|
| `WaypointSkipping.RegularPathfindSkip` | `number` | `2` | Number of leading waypoints to skip in normal (one-shot) pathing. Set to `1` (or below) to disable skipping. |
| `WaypointSkipping.TrackingPathfindSkip` | `number` | `3` | Number of leading waypoints to skip when running in tracking mode. |

## Why this exists
The first computed waypoint is often very close to (or behind) the NPC's current position. Walking to it produces a brief stutter. Skipping a couple of waypoints lets the NPC commit to forward motion immediately.

## How to disable
Set the value to `1` or `0`:

```lua
local config = AI.GetConfig(npc)
config.WaypointSkipping.RegularPathfindSkip = 1
config.WaypointSkipping.TrackingPathfindSkip = 1
config:ApplyNow()
```

> **Don't skip too aggressively.** If you skip more waypoints than the path contains, the NPC walks straight to the goal and ignores intermediate corners — which can cause it to clip walls or fall.

## Related
- [`AgentInfo.WaypointSpacing`](./agent-info.md) — distance *between* waypoints (different concern).
- [`Tracking`](./tracking.md) — uses the tracking-specific skip count.
