# `Visualization`

In-world debug drawing for paths, raycasts, tethers, and inferred collisions. **Disabled by default** — enable per-feature when debugging.

| Setting | Type | Default | Description |
|---|---|---|---|
| `Visualization.Enabled` | `boolean` | `false` | **Master switch.** All sub-flags are no-ops while this is `false`. |
| `Visualization.Path` | `boolean` | `true` | Draw the computed path. |
| `Visualization.PathColor` | `Color3` | `Color3.fromRGB(98, 87, 255)` | Color for the path line. |
| `Visualization.Celling` | `boolean` | `false` | Draw the ceiling/offset probes used to avoid overhead obstacles. (Field name preserved as in source.) |
| `Visualization.CellingColor` | `Color3` | `Color3.fromRGB(0, 255, 0)` | Color for the ceiling probes. |
| `Visualization.MovetoRaycast` | `boolean` | `false` | Draw the raycasts performed by [`DirectMoveTo`](./direct-move-to.md). |
| `Visualization.MovetoRaycastColor` | `Color3` | `Color3.fromRGB(0, 0, 255)` | Color for direct-move raycasts. |
| `Visualization.Tether` | `boolean` | `false` | Draw the tether line between the NPC and its target. |
| `Visualization.TetherColor` | `Color3` | `Color3.fromRGB(255, 255, 0)` | Color for the tether. |
| `Visualization.CollisionInferencing` | `boolean` | `false` | Draw the inferred collider sweeps used by [`DirectMoveTo.CollisionInferencing`](./direct-move-to.md). |

## Master switch
`Visualization.Enabled` gates everything. To turn on individual visuals you must enable the master switch **and** the per-feature flag.

```lua
local config = AI.GetConfig(npc)
config.Visualization.Enabled = true
config.Visualization.MovetoRaycast = true
config.Visualization.CollisionInferencing = true
config:ApplyNow()
```

## Recommended debugging combo

| Symptom | Turn on |
|---|---|
| NPC weaves around invisible obstacles | `Path`, `MovetoRaycast`, `CollisionInferencing` |
| NPC clips through floors / falls into voids | `MovetoRaycast`, `Celling` |
| Tracking jumps badly | `Tether`, `Path` |

## Notes
- Visualization is intended for development use. Leave it off in production builds.
- The drawing is performed by `src/Forbidden/AI/Visualization` and uses Roblox's drawing primitives (lines/parts) under the hood.
