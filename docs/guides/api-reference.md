# API Reference

The `AI` table is Forbidden's public surface. Acquire it via:

```lua
local AI = require(game:GetService("ReplicatedStorage").Forbidden.AI)
```

Source: `src/Forbidden/AI/init.luau`.

---

## `AI.SmartPathfind(NPC, Target, Yields?, Priority?)`

Starts a pathfind (or, when `config.Tracking.Enabled` is true and `Target` is an `Instance`, continuous tracking) toward `Target`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `NPC` | `Instance` | — | The NPC model. Must have a `Humanoid`. |
| `Target` | `Player` \| `Model` \| `BasePart` \| `Vector3` \| `CFrame` | — | Where to go. Tracking only works when `Target` is an `Instance`. |
| `Yields` | `boolean?` | `false` | If `true`, the call waits until the request is acknowledged/finished before returning. |
| `Priority` | [`RequestPriority`](./request-priorities.md) \| `number?` | `"DefaultStart"` | Priority of this request relative to others queued for the same NPC. |

**Behavior**
- The state machine for the NPC is initialized lazily on first call.
- The request is dispatched through the message queue, so prior pending start requests may be discarded depending on [`RequestPrioritization`](../settings/request-prioritization.md).

---

## `AI.Stop(NPC, Yields?, Priority?)`

Asks the NPC to stop. The exact behavior is governed by [`config.StopType`](../settings/stop-type.md).

| Parameter | Type | Default | Description |
|---|---|---|---|
| `NPC` | `Instance` | — | The NPC model. |
| `Yields` | `boolean?` | `false` | If `true`, waits for the stop to be acknowledged. |
| `Priority` | [`RequestPriority`](./request-priorities.md) \| `number?` | `"DefaultStop"` | Default stop priority is higher than default start priority. |

> **Note:** If you intend to immediately re-issue another `SmartPathfind`, **do not** call `Stop` first. Re-calling `SmartPathfind` transitions more cleanly than a stop-then-start.

---

## `AI.GetConfig(NPC) -> Config`

Returns the editable per-NPC config. Edits are **local-first**:

- They are applied automatically the next time `AI.SmartPathfind` is called for that NPC.
- To apply mid-operation, call `config:ApplyNow()`.

```lua
local config = AI.GetConfig(npc)
config.Tracking.Enabled = true
config:ApplyNow()
```

The full set of fields is documented under [Settings](../settings/README.md). Methods on the `Config` object:

| Method | Purpose | More |
|---|---|---|
| `config:ApplyNow()` | Force the local config to be visible to the running pathfinder. | [Presets](./presets.md) |
| `config:RestoreDefaults()` | Reset local config to `Defaults.luau`. | [Presets](./presets.md) |
| `config:RestoreActiveConfig()` | Reset local config to the snapshot the pathfinder is currently using. | [Presets](./presets.md) |
| `config:SavePreset(name, saveGlobally?)` | Save a snapshot under a name. | [Presets](./presets.md) |
| `config:LoadPreset(name, useGlobalIfBothFound?)` | Replace local config with a saved preset. | [Presets](./presets.md) |

---

## `AI.InsertAntiLag(NPC, UseExtremeCase?, IgnoreHumanoidCheck?)`

Inserts the anti-lag helper into the NPC. **You should call this on every NPC.**

| Parameter | Type | Default | Description |
|---|---|---|---|
| `NPC` | `Instance` | — | NPC to attach the helper to. Errors if `nil`. |
| `UseExtremeCase` | `boolean?` | `false` | Reserved for a more aggressive loop-based variant intended to keep the server as the network owner in extreme cases. (Currently the same path as default.) |
| `IgnoreHumanoidCheck` | `boolean?` | `false` | Skip the `Humanoid` validity check. Useful when the rig is exotic. |

See [Anti-Lag Helper](./anti-lag.md) for more.

---

## Exported Types
Forbidden re-exports these from `AI`:

```lua
type Config = AI.Config             -- the per-NPC config object
type StopType = AI.StopType         -- "CurrentPosition" | "NoStopLogic" | string
type RequestPriority = AI.RequestPriority
```

The full `Config` shape is in `src/Forbidden/AI/Types/TConfig.luau`.

---

## Cleanup
There is no public deinit; cleanup is internal. Configs and active state are removed when the NPC's pathfinding system is torn down (e.g. on death). If you need to wipe state manually:

```lua
local ConfigHandler = require(rs.Forbidden.AI.ConfigHandler)
ConfigHandler.TriggerCleanup(npc)
```

This is considered an internal escape hatch.
