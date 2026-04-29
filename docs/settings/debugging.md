# `Debugging`

Internal log gating and verbosity. Disabled by default; turn it on when chasing a bug.

| Setting | Type | Default | Description |
|---|---|---|---|
| `Debugging.Enabled` | `boolean` | `false` | **Master switch.** All other debug flags are no-ops while this is `false`. |
| `Debugging.OutputToConsole` | `boolean` | `true` | When debugging is enabled, route output to the developer console. |
| `Debugging.StateTransitioning` | `boolean` | `true` | Log state-machine transitions inside the pathfinding processor. |
| `Debugging.MovingToWaypoint` | `boolean` | `false` | Log every time the NPC starts moving to a waypoint. Verbose; use sparingly. |
| `Debugging.Verbosity` | `number` | `3` | Verbosity level for general internal logs. Higher = noisier. |
| `Debugging.LogToScript` | `boolean` | *(unset by default)* | Declared in source but commented out. Reserved for future "log to a `Script` in-game" support. |

## Enabling debug output

```lua
local config = AI.GetConfig(npc)
config.Debugging.Enabled = true
config.Debugging.MovingToWaypoint = true
config.Debugging.Verbosity = 5
config:ApplyNow()
```

## Tips
- **`StateTransitioning` first.** When something feels off, transitions usually tell you whether the AI is even getting the requests you think it is.
- **`MovingToWaypoint` is firehose-grade.** Combine with [`Visualization.Path`](./visualization.md) instead of staring at the console.
- Pair with [`Hooks.PathingFailed`](./hooks.md) to log the *why* of failures even when debug output is off in production.

## Related
- [`Visualization`](./visualization.md) — visual counterpart to text-based debug output.
- [`Hooks`](./hooks.md) — programmatic counterpart for reacting to lifecycle events.
