# `Hooks`

Per-NPC behavior callbacks. The conceptual lifecycle and signatures are documented in [Hook Callbacks](../guides/hooks.md); this page is the **defaults table**.

| Hook | Signature | Default | Returns |
|---|---|---|---|
| `Hooks.PathfindingLinkReached` | `(NPC, Waypoint)` | Snaps the NPC's primary part to `Waypoint.Position` and returns `true`. | `boolean` |
| `Hooks.MovingToWaypoint` | `(NPC, Waypoint, MoveType)` | `nullbind` (no-op) | — |
| `Hooks.Stuck` | `(NPC, Target)` | Picks a random horizontal direction, calls `Humanoid:MoveTo(NPCPos + dir*10)`, sets `Humanoid.Jump = true`, waits `1` second, returns `true`. Bails out (returns `false`) if the NPC has no `Humanoid`, the humanoid is dead, the primary part is missing, or the random direction is degenerate. | `boolean` |
| `Hooks.GoalReached` | `(NPC, Target)` | `nullbind` | — |
| `Hooks.StartAcknowledged` | `(NPC, Target)` | `nullbind` | — |
| `Hooks.StopAcknowledged` | `(NPC, Target)` | `nullbind` | — |
| `Hooks.PathingStarted` | `(NPC, Waypoints)` | `nullbind` | — |
| `Hooks.PathingFailed` | `(NPC, Reason)` | `nullbind` | — |

`MoveType` is one of `"DirectMoveTo"`, `"Pathing"`, `"PathfindingLink"`, or any custom string. `Reason` is `"Stuck Limit Reached"`, `"Path Not Found"`, or any custom string.

## Replacing a hook

```lua
local config = AI.GetConfig(npc)

config.Hooks.GoalReached = function(npc, target)
    print(npc, "arrived at", target)
end

config:ApplyNow()
```

## Notes
- Returning the wrong type from a `boolean`-returning hook (`PathfindingLinkReached`, `Stuck`) will be treated as `false`.
- The `Stuck` default is intentionally minimal — it works as a safety net, not as a real recovery strategy. Replace it if you have a better routine.
- The `PathfindingLinkReached` default uses `Common.GetBasePart(NPC)` to locate the rig's primary part. If your rig stores its primary in an unusual place, override this hook.

## Related
- Conceptual guide: [Hook Callbacks](../guides/hooks.md)
- [`Unstucking`](./unstucking.md) — controls how often `Hooks.Stuck` is invoked and when failure fires.
