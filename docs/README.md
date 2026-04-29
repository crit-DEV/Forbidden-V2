# Forbidden V2 — Documentation

The repository-backed wiki for **Forbidden**, a pathfinding library built on top of Roblox's `PathfindingService`.

> Originally developed by [@crit-dev](https://github.com/crit-dev) (a.k.a. `@rman501`).

This wiki documents every public API surface and every setting available on the per-NPC `Config` object returned by `AI.GetConfig(NPC)`.

---

## Table Of Contents

### Guides
- [Getting Started](./guides/getting-started.md)
- [API Reference](./guides/api-reference.md)
- [Request Priorities](./guides/request-priorities.md)
- [Config Presets](./guides/presets.md)
- [Hook Callbacks](./guides/hooks.md)
- [Anti-Lag Helper](./guides/anti-lag.md)

### Settings (per-NPC `Config`)
Top-level fields on the object returned by `AI.GetConfig(NPC)`.

- [Settings Index](./settings/README.md)
- [Quick Reference: All Defaults](./settings/ai-config-defaults.md)
- [`StopType`](./settings/stop-type.md)
- [`Unstucking`](./settings/unstucking.md)
- [`RequestPrioritization`](./settings/request-prioritization.md)
- [`AgentInfo`](./settings/agent-info.md)
- [`Visualization`](./settings/visualization.md)
- [`Tracking`](./settings/tracking.md)
- [`WaypointSkipping`](./settings/waypoint-skipping.md)
- [`DirectMoveTo`](./settings/direct-move-to.md)
- [`Hooks`](./settings/hooks.md)
- [`Debugging`](./settings/debugging.md)

---

## Source Of Truth
Whenever the wiki and the code disagree, the code wins. The authoritative locations are:

| Topic | File |
|---|---|
| Public AI API | `src/Forbidden/AI/init.luau` |
| Config types  | `src/Forbidden/AI/Types/TConfig.luau` |
| Config defaults | `src/Forbidden/AI/ConfigHandler/Defaults.luau` |
| Config handler | `src/Forbidden/AI/ConfigHandler/init.luau` |
| Request priority | `src/Forbidden/AI/Types/TRequestPriority.luau` |

## Contributing To These Docs
- Each settings page documents one top-level config field.
- When you add a new setting in `Defaults.luau` or `TConfig.luau`, update the matching page in `docs/settings/` and the [quick reference](./settings/ai-config-defaults.md).
- Keep page structure consistent: **Overview → Settings table → Notes/Examples**.
