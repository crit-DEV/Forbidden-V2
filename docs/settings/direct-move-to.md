# `DirectMoveTo`

`DirectMoveTo` is a short-range optimization. Before computing a full path, Forbidden checks whether it can simply call `Humanoid:MoveTo(targetPos)` in a straight line. When it can, that's faster, smoother, and avoids the cost of `PathfindingService:CreatePath`.

This category has the most subsystems of any setting because each subsystem polices a different failure mode of "just walk in a straight line":

- [Top-level toggles](#top-level)
- [`DirectMoveTo.Raycast`](#directmovetoraycast) — line-of-sight check
- [`DirectMoveTo.CollisionInferencing`](#directmovetocollisioninferencing) — swept collider check
- [`DirectMoveTo.JumpHandler`](#directmovetojumphandler) — auto-jump while direct-moving
- [`DirectMoveTo.CheckFloor`](#directmovetocheckfloor) — floor/void safety check

---

## Top-level

| Setting | Type | Default | Description |
|---|---|---|---|
| `DirectMoveTo.Enabled` | `boolean` | `true` | **Master switch.** When `false`, Forbidden always pathfinds. |
| `DirectMoveTo.ActivationDistance` | `number` (studs) | `60` | Maximum NPC↔target distance for `DirectMoveTo` to be considered. |
| `DirectMoveTo.HeightLimit` | `number` (studs) | `10` | Maximum vertical (Y) difference between NPC and target before `DirectMoveTo` is rejected. |
| `DirectMoveTo.TrackingOnly` | `boolean` | `true` | If `true`, `DirectMoveTo` is only used while [`Tracking.Enabled`](./tracking.md) is `true`. |
| `DirectMoveTo.AvoidUseHook` | `() -> boolean` | `nullbind` (no-op) | Veto hook called every time `DirectMoveTo` could be used. Return `true` to forbid the optimization. |

---

## `DirectMoveTo.Raycast`

A raycast must reach (or nearly reach) the target with no blocker for `DirectMoveTo` to be allowed.

| Setting | Type | Default | Description |
|---|---|---|---|
| `Raycast.Enabled` | `boolean` | `true` | Require a clear raycast. |
| `Raycast.Range` | `number` (studs) | `ActivationDistance + 10` (`70`) | Max raycast length. |
| `Raycast.SeeThroughTransparentParts` | `boolean` | `false` | If `true`, parts whose `Transparency >= MinimumTransparency` are ignored. |
| `Raycast.SeeThroughNonCollidable` | `boolean` | `true` | Non-collidable parts are ignored. |
| `Raycast.MinimumTransparency` | `number` | `0.001` | Threshold used by `SeeThroughTransparentParts`. |
| `Raycast.FilterAttempts` | `number` | `10` | Maximum number of re-raycast attempts when filtering hits via `FilterFunction`. |
| `Raycast.OffsetFromOrigin` | `Vector3` | `Vector3.zero` | Offset added to the ray origin (NPC position). |
| `Raycast.OffsetFromTarget` | `Vector3` | `Vector3.zero` | Offset added to the ray endpoint (target position). |
| `Raycast.FilterFunction` | `(hit: BasePart) -> boolean` | `return false` | Per-hit exclusion. Return `true` to ignore this hit and re-raycast (up to `FilterAttempts`). |
| `Raycast.FilterTable` | `{Instance}` | *(unset by default)* | Optional explicit instance filter applied in addition to the NPC. Declared in `TConfig.luau`; not assigned in `Defaults.luau`. |
| `Raycast.OutputCollision` | `boolean` | *(unset by default)* | When implemented, prints what the raycast hit. Declared in `TConfig.luau`; not assigned in `Defaults.luau`. |

### Examples

Ignore glass/windows:
```lua
config.DirectMoveTo.Raycast.SeeThroughTransparentParts = true
config.DirectMoveTo.Raycast.MinimumTransparency = 0.5
```

Skip foliage by name:
```lua
config.DirectMoveTo.Raycast.FilterFunction = function(hit)
    return hit.Name == "Leaves"
end
```

---

## `DirectMoveTo.CollisionInferencing`

A swept collider check between the NPC and target. Catches obstacles a single raycast would miss (thin pillars, narrow gaps).

| Setting | Type | Default | Description |
|---|---|---|---|
| `CollisionInferencing.Enabled` | `boolean` | `true` | Run swept collider checks. |
| `CollisionInferencing.MinColliderRange` | `number` | `max(Tracking.CollinearTargetPositionOffset, AgentInfo.AgentRadius / 2)` (`2`) | Lower bound for the inferred collider's range. |
| `CollisionInferencing.MaxColliderRange` | `number` | `3` | Upper bound for the inferred collider's range. |
| `CollisionInferencing.YOffsetFromGround` | `number` (studs) | `3` | Vertical offset from the ground for the swept volume. |
| `CollisionInferencing.YSizeOfCollider` | `number` (studs) | `1` | Height of the swept volume. Recommend enabling [`Visualization.CollisionInferencing`](./visualization.md) when tuning. |

---

## `DirectMoveTo.JumpHandler`

Triggers `Humanoid.Jump` while a `DirectMoveTo` is in flight if the NPC has been hovering near a target point without making progress (a "soft stuck"). Disabled by default.

| Setting | Type | Default | Description |
|---|---|---|---|
| `JumpHandler.Enabled` | `boolean` | `false` | Enable auto-jump during `DirectMoveTo`. |
| `JumpHandler.MinConditionReachedTime` | `number` (s) | `0.25` | Time the stuck-condition must persist before a jump can fire. |
| `JumpHandler.NextJumpMinTime` | `number` (s) | `1` | Cooldown between jumps. |
| `JumpHandler.DistanceFromMoveToPoint` | `number` (studs) | `2` | NPC must be within this radius of the target point for a jump to fire. |
| `JumpHandler.CustomJumpFunction` | `((NPC, Target) -> boolean)?` | `nil` | Optional override. Return `true` to force a jump immediately, ignoring all other conditions. |

---

## `DirectMoveTo.CheckFloor`

Raycasts the floor along the planned direct-move line. If the floor disappears (a void or a cliff), `DirectMoveTo` is blocked for `BlockDirectMoveToTimer` seconds and a normal pathfind runs instead.

| Setting | Type | Default | Description |
|---|---|---|---|
| `CheckFloor.Enabled` | `boolean` | `true` | Run void/floor safety checks before `DirectMoveTo`. |
| `CheckFloor.FailHeight` | `number` (studs) | `12` | If the ground is farther below than this, the check fails. |
| `CheckFloor.RaycastSpacing` | `number` (studs) | `5` | Spacing between floor probes along the path. |
| `CheckFloor.AlwaysRaycastThisDistance` | `number` (studs) | `2` | Always probe the floor at this distance from the NPC. |
| `CheckFloor.CheckFrequencyTimer` | `number` (s) | `1` | Soft cap on how often the check runs. |
| `CheckFloor.BlockDirectMoveToTimer` | `number` (s) | `3` | Cooldown after a failed floor check. |
| `CheckFloor.DisableIfDistanceIsLessThan` | `number` (studs) | `AgentInfo.AgentRadius * 3` (`7.5`) | Skip floor checks when the target is very close — at point-blank range, false positives are more likely than real voids. |

---

## Putting it together

```lua
local config = AI.GetConfig(npc)

-- Use DirectMoveTo even outside tracking
config.DirectMoveTo.TrackingOnly = false

-- Tighten activation distance
config.DirectMoveTo.ActivationDistance = 30
config.DirectMoveTo.Raycast.Range = 40

-- Enable auto-jumping for short ledges
config.DirectMoveTo.JumpHandler.Enabled = true

-- Block DirectMoveTo via game state
config.DirectMoveTo.AvoidUseHook = function()
    return GameState.RoundEnded
end

config:ApplyNow()
```

## Related
- [`Tracking`](./tracking.md) — works closely with `DirectMoveTo`.
- [`Visualization`](./visualization.md) — `MovetoRaycast` and `CollisionInferencing` toggles are essential when tuning.
