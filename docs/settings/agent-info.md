# `AgentInfo`

Mirrors the parameters Roblox's `PathfindingService:CreatePath(agentParameters)` accepts. Forbidden passes these straight through when building paths. See the upstream Roblox reference for the canonical semantics:

> https://create.roblox.com/docs/characters/pathfinding

| Setting | Type | Default | Description |
|---|---|---|---|
| `AgentInfo.AgentRadius` | `number` (studs) | `2.5` | Minimum gap the agent considers traversable. Increase for wider rigs. |
| `AgentInfo.AgentHeight` | `number` (studs) | `5` | Minimum vertical clearance the agent requires. |
| `AgentInfo.AgentCanJump` | `boolean` | `true` | Allow paths that include jump links. |
| `AgentInfo.AgentCanClimb` | `boolean` | `false` | Allow paths that traverse `TrussPart` ladders. |
| `AgentInfo.WaypointSpacing` | `number` (studs) | `4` | Distance between path waypoints. Smaller = smoother but more waypoints. |
| `AgentInfo.Costs` | `{[string]: number}` | `{Obstacle = math.huge}` | Material/`PathfindingModifier` cost map. Keys are material names or `PathfindingModifier.Label` values. |

## How `Costs` works
Each entry biases the planner toward (low cost) or away from (high cost) labeled regions. Use `math.huge` to make a label effectively impassable.

```lua
config.AgentInfo.Costs = {
    Obstacle = math.huge,   -- never path through Obstacle-labeled regions
    Water = 20,             -- discouraged but allowed
    JumpLink = 10,          -- mild preference penalty
}
config:ApplyNow()
```

## Tuning notes
- **Big agents** (e.g. boss rigs): bump `AgentRadius` so the planner doesn't squeeze the NPC through gaps it physically can't fit through.
- **Smoother paths**: drop `WaypointSpacing` to `2`–`3`. Costs more to compute, but less zig-zag.
- **No jumping AI**: set `AgentCanJump = false`. The planner will route around vertical gaps instead of routing over them.

## Related
- [`WaypointSkipping`](./waypoint-skipping.md) — skip leading waypoints (different from `WaypointSpacing`).
- [`DirectMoveTo`](./direct-move-to.md) — short-range movement that bypasses the planner.
