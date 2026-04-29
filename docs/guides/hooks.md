# Hook Callbacks

Hooks are user-supplied functions that Forbidden calls at lifecycle events. They live under `config.Hooks` and are reassignable per-NPC.

For default implementations and the matching settings table, see [`Hooks` settings](../settings/hooks.md).

```lua
local config = AI.GetConfig(npc)

config.Hooks.GoalReached = function(NPC, Target)
    print(NPC.Name, "arrived at", Target)
end

config:ApplyNow()
```

## Available Hooks

| Hook | Signature | Returns | Purpose |
|---|---|---|---|
| `PathfindingLinkReached` | `(NPC, Waypoint)` | `boolean` | Called when the NPC reaches a `PathfindingLink` waypoint. Return `true` if you handled it. The default teleports the NPC's primary part to the waypoint's position and returns `true`. |
| `MovingToWaypoint` | `(NPC, Waypoint, MoveType)` | — | Fires every time the NPC starts moving toward a waypoint. `MoveType` is `"DirectMoveTo"`, `"Pathing"`, `"PathfindingLink"`, or any custom string. |
| `Stuck` | `(NPC, Target)` | `boolean` | Fires once when stuck-detection trips, before the failure path. Return `true` if you recovered. The default does a small random hop. |
| `GoalReached` | `(NPC, Target)` | — | Fires when the NPC has finished traveling to the target. |
| `StartAcknowledged` | `(NPC, Target)` | — | Fires when a `SmartPathfind` request was accepted by the queue. |
| `StopAcknowledged` | `(NPC, Target)` | — | Fires when a `Stop` request was accepted by the queue. |
| `PathingStarted` | `(NPC, Waypoints)` | — | Fires when a path has been computed and walking is about to begin. |
| `PathingFailed` | `(NPC, Reason)` | — | Fires when the pathfinder has given up. `Reason` is `"Stuck Limit Reached"`, `"Path Not Found"`, or any custom string from internal code. |

## Stuck vs PathingFailed
Don't confuse the two:

- **`Stuck`** is your last-chance recovery hook. It fires **before** the system gives up. If it returns `true`, the system continues.
- **`PathingFailed`** is terminal. It fires after `MaxStuckCount` is exhausted, or when no path could be found.

See [`Unstucking`](../settings/unstucking.md) for the stuck retry budget.

## Example: full callback set
```lua
local config = AI.GetConfig(npc)

config.Hooks.PathingStarted = function(_, waypoints)
    print("Path has", #waypoints, "waypoints")
end

config.Hooks.MovingToWaypoint = function(_, waypoint, moveType)
    print("Moving to", waypoint.Position, "via", moveType)
end

config.Hooks.GoalReached = function(npc, target)
    print(npc.Name, "reached the goal")
end

config.Hooks.Stuck = function(npc, target)
    -- Your custom recovery; return true if you handled it.
    return false
end

config.Hooks.PathingFailed = function(npc, reason)
    warn(npc.Name, "gave up:", reason)
end

config:ApplyNow()
```
