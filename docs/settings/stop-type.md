# `StopType`

Controls what happens when `AI.Stop(npc)` is invoked.

| Path | Type | Default |
|---|---|---|
| `config.StopType` | `"CurrentPosition"` \| `"NoStopLogic"` \| `string` | `"CurrentPosition"` |

## Values

### `"CurrentPosition"` (default)
The NPC is told to hold its current position. Movement halts as cleanly as `Humanoid:MoveTo` allows.

### `"NoStopLogic"`
Forbidden does **not** issue any movement instruction on stop. The NPC is allowed to finish whatever `MoveTo` it is currently executing, then idles. Useful when you want the AI's last animation/waypoint to complete naturally.

### Any other string
Treated as a custom marker. Internally the AI will follow the same flow as `NoStopLogic` (no forced stop), but you can branch on the string in your hooks (e.g. inside `Hooks.StopAcknowledged`).

## Example
```lua
local config = AI.GetConfig(npc)
config.StopType = "NoStopLogic"
config:ApplyNow()

AI.Stop(npc) -- the NPC will not be commanded to a halt
```

## Related
- [`Hooks.StopAcknowledged`](./hooks.md) — fires when a stop request is accepted.
- [Request Priorities](../guides/request-priorities.md) — controls whether a stop preempts an in-flight start.
