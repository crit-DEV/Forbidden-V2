# `RequestPrioritization`

Controls how Forbidden arbitrates between competing requests for the same NPC. Most users only ever interact with this through the [`Priority`](../guides/request-priorities.md) parameter on `SmartPathfind` / `Stop`.

| Setting | Type | Default | Description |
|---|---|---|---|
| `RequestPrioritization.PreferTimeOverPriority.Enabled` | `boolean` | `true` | If `true`, the **most recent** request wins, even when an earlier request had a higher priority. |
| `RequestPrioritization.PreferTimeOverPriority.ResetOlderRequests` | `boolean` | `true` | If `true`, when a newer request preempts an older one, the older one is marked processed (and will not be revisited). |

## Default behavior — "newest wins"
With both flags at their defaults, Forbidden treats the message queue as a "latest intent" buffer. Issuing `SmartPathfind` then issuing `Stop` immediately replaces the start; the start never runs.

This matches how most game logic actually wants AI to behave (the latest order is the order).

## Strict-priority behavior
Flip `PreferTimeOverPriority.Enabled` off to use classic priority arbitration: a higher-priority older request beats a newer lower-priority one.

```lua
local config = AI.GetConfig(npc)
config.RequestPrioritization.PreferTimeOverPriority.Enabled = false
config:ApplyNow()
```

## Keeping old requests pending
Set `ResetOlderRequests = false` if you want preempted requests to remain in the queue (so they can run after the newer one completes). With it `true` (default), preempted requests are discarded.

## Related
- [Request Priorities](../guides/request-priorities.md) — string/numeric priority levels.
- `AI.SmartPathfind(NPC, Target, Yields?, Priority?)`
- `AI.Stop(NPC, Yields?, Priority?)`
