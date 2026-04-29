# `Unstucking`

Stuck-detection and recovery. When the NPC stops making progress along its path, Forbidden invokes a recovery hook before declaring the path failed.

| Setting | Type | Default | Description |
|---|---|---|---|
| `Unstucking.Enabled` | `boolean` | `true` | Master switch for stuck-detection and recovery. |
| `Unstucking.FireStuckHook` | `boolean` | `true` | If `true`, [`Hooks.Stuck`](./hooks.md) is called before declaring failure, giving you a chance to recover. |
| `Unstucking.MaxStuckCount` | `number` | `2` | Maximum stuck events tolerated before [`Hooks.PathingFailed`](./hooks.md) is fired with reason `"Stuck Limit Reached"`. |

## Lifecycle

```
NPC stuck
   │
   ├── Unstucking.Enabled == false ──► (stuck events ignored)
   │
   ├── FireStuckHook == true ──► Hooks.Stuck(NPC, Target)
   │                                ├── returns true ──► continue, increment stuck count
   │                                └── returns false ──► increment stuck count
   │
   └── stuck count >= MaxStuckCount ──► Hooks.PathingFailed(NPC, "Stuck Limit Reached")
```

## Default `Hooks.Stuck`
Forbidden ships a default recovery that picks a random horizontal direction, issues a small `MoveTo`, sets `Humanoid.Jump = true`, and waits one second. It returns `true` on success.

If you replace it, return `true` if your routine recovered, or `false` to let Forbidden record the stuck event without further effort.

## Examples

### Be more forgiving
```lua
local config = AI.GetConfig(npc)
config.Unstucking.MaxStuckCount = 5
config:ApplyNow()
```

### Disable stuck detection entirely
```lua
config.Unstucking.Enabled = false
config:ApplyNow()
```

### Custom stuck recovery
```lua
config.Hooks.Stuck = function(npc, target)
    -- attempt to teleport-snap to nearest navmesh point, etc.
    return true -- handled
end
config:ApplyNow()
```

## Related
- [`Hooks.Stuck`](./hooks.md) — recovery callback.
- [`Hooks.PathingFailed`](./hooks.md) — terminal failure callback.
- [`DirectMoveTo.JumpHandler`](./direct-move-to.md) — independent jump-to-unstick during direct movement.
