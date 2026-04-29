# Anti-Lag Helper

Roblox transfers network ownership of nearby physics-driven objects (including NPCs) to the closest player. When this happens to an NPC mid-movement, you'll see stutter, rubber-banding, or outright desync.

`AI.InsertAntiLag` parents a small server script into the NPC that pins network ownership to the server. **You should call it on every NPC you intend to pathfind.**

## Usage
```lua
AI.InsertAntiLag(npc)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `NPC` | `Instance` | — | NPC to attach the helper to. Errors if `nil`. |
| `UseExtremeCase` | `boolean?` | `false` | Reserved switch for a more aggressive loop-based variant. Currently behaves like the default. |
| `IgnoreHumanoidCheck` | `boolean?` | `false` | Skip the `Humanoid` validity check. Useful for exotic rigs. |

## When to call it
Call it once per NPC, as early as possible — typically right after the NPC is spawned/cloned and before any `SmartPathfind` call.

```lua
local npc = npcTemplate:Clone()
npc.Parent = workspace
AI.InsertAntiLag(npc)
AI.SmartPathfind(npc, target)
```

## What it does
- Clones the bundled `antilag` server script into the NPC.
- Enables it (the bundled script is disabled by default).
- The script keeps the NPC's parts owned by the server, preventing the network-ownership-induced stutter near players.

## Errors
- Passing `NPC == nil` raises an error.
- A missing `Humanoid` raises an error unless `IgnoreHumanoidCheck` is `true`.

> If you're using a fully custom rig with no `Humanoid` and your own movement layer, you probably don't need anti-lag — but you also probably can't use Forbidden, since `SmartPathfind` requires `Humanoid:MoveTo`.
