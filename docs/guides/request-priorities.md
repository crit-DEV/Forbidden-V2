# Request Priorities

> **Most users never need to touch this.** The defaults work. This page exists for the rare case when you do.

When `AI.SmartPathfind` and `AI.Stop` are called, each request is tagged with a priority. Forbidden uses these values to arbitrate between competing requests for the same NPC.

Source: `src/Forbidden/AI/Types/TRequestPriority.luau`.

## String Priorities

| Name | Numeric Equivalent | Notes |
|---|---|---|
| `"Low"` | `0` | Below all defaults. |
| `"DefaultStart"` | `1` | Default for `AI.SmartPathfind`. |
| `"Normal"` | `1` | Same numeric weight as `DefaultStart`. |
| `"DefaultStop"` | `2` | Default for `AI.Stop`. By default, stops outrank starts. |
| `"High"` | `2` | Same numeric weight as `DefaultStop`. |
| `"Critical"` | `3` | Above everything. |

## Numeric Priorities
You can pass a number instead. It is normalized to the table above:

| Input | Resolved To |
|---|---|
| `<= 0` | `"Low"` |
| `1` | `"Normal"` |
| `2` | `"High"` |
| `>= 3` | `"Critical"` |

## Time vs Priority
By default, **newer requests win over older higher-priority requests**. This is controlled by [`RequestPrioritization.PreferTimeOverPriority`](../settings/request-prioritization.md). If you flip that flag off, classic priority arbitration applies.

## Examples

Force a stop ahead of any pending start:
```lua
AI.Stop(npc) -- defaults to "DefaultStop", which already outranks DefaultStart
```

Boost a chase request:
```lua
AI.SmartPathfind(npc, target, false, "High")
```

Use a number:
```lua
AI.SmartPathfind(npc, target, false, 3) -- Critical
```
