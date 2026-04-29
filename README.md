# Forbidden V2
> Originally developed by @crit-dev (@rman501)

Forbidden is a pathfinding library built on top of Roblox's `PathfindingService` to enhance functionality, simplicity, and reliability.

## Important Warnings
- You should call `AI.InsertAntiLag(NPC)` to avoid stuttering when the AI gets close to a player.
- Your NPC must have a `Humanoid` and be compatible with `Humanoid:MoveTo(Vector3)`.

## What Forbidden Adds
- A higher-level AI API over raw `PathfindingService`
- Built-in request queueing (`Start` vs `Stop`) with priorities
- Optional tracking/retracking for moving targets
- Optional direct movement optimization before full path recomputes
- Config system with presets and live apply support
- Hook system for custom behavior (goal reached, stuck handling, etc.)
- Easy PathfindingLink implementation for custom paths.
- Optional path/debug visualization

## Installation
### Wally
Add Forbidden to your `wally.toml`:

```toml
[dependencies]
forbidden = "crit-dev/forbidden-v2@2.0.1"
```

Then install dependencies:

```bash
wally install
```

### Rojo Project Layout
Forbidden expects a `ReplicatedStorage.Forbidden` tree. In this repo that is wired in `default.project.json`:

```json
"ReplicatedStorage": {
  "Forbidden": {
    "$path": "src/Forbidden",
    "Packages": {
      "$path": "Packages"
    }
  }
}
```

## Quick Start
```lua
local rs = game:GetService("ReplicatedStorage")
local Forbidden = require(rs.Forbidden)
local AI = Forbidden.AI

local npc = workspace.NPC
local target = game.Players:GetPlayers()[1] -- Player / Model / BasePart / Vector3 / CFrame

local config = AI.GetConfig(npc)
config.Tracking.Enabled = true
config:ApplyNow()

AI.SmartPathfind(npc, target, false, "Normal")
```

## API Reference
### `AI.SmartPathfind(NPC, Target, Yields?, Priority?)`
Starts pathfinding (or tracking when enabled and target is an `Instance`).

- `NPC`: NPC model/instance
- `Target`: `Player`, `Model`, `BasePart`, `Vector3`, `CFrame`
- `Yields` (optional): if `true`, waits until the current request is acknowledged/finished
- `Priority` (optional): request priority string or number

### `AI.Stop(NPC, Yields?, Priority?)`
Requests stopping behavior for the NPC.

- Default stop priority is higher than default start priority
- Stop behavior is controlled by `config.StopType`

### `AI.GetConfig(NPC): Config`
Returns the NPC's editable config object.

Important behavior:
- Config edits are local first
- Edits become active automatically on the next `SmartPathfind` call
- Use `config:ApplyNow()` to force changes immediately mid-operation

### `AI.InsertAntiLag(NPC, UseExtremeCase?, IgnoreHumanoidCheck?)`
Inserts the anti-lag helper script into the NPC.

## Request Priorities
Never use these. They are here for the 0.01% chance someone actually needs them.

String priorities:
- `"Low"`
- `"DefaultStart"`
- `"Normal"`
- `"DefaultStop"`
- `"High"`
- `"Critical"`

Number priorities:
- `<= 0` -> `"Low"`
- `1` -> `"Normal"`
- `2` -> `"High"`
- `>= 3` -> `"Critical"`

## Config Highlights
Common settings from `AI.GetConfig(npc)`:

- `StopType`: `"CurrentPosition"` or `"NoStopLogic"`
- `Tracking.Enabled`: continuously retrack target
- `Tracking.DynamicRetrack`: min/max timer + custom retrack functions
- `DirectMoveTo.Enabled`: short-range optimization before full pathing
- `WaypointSkipping.RegularPathfindSkip` / `TrackingPathfindSkip`
- `Unstucking`: stuck retry behavior and limit
- `RequestPrioritization.PreferTimeOverPriority`
- `Hooks`: behavior callbacks
- `Visualization`: path/raycast/tether visualization
- `Debugging`: internal logs and verbosity

For a full list of settings and defaults, check:
- `Forbidden.AI.ConfigHandler.Defaults`
- The full wiki under [`docs/`](./docs/README.md), including:
  - [Getting Started](./docs/guides/getting-started.md)
  - [API Reference](./docs/guides/api-reference.md)
  - [Settings Index](./docs/settings/README.md) (one page per config category)
  - [Quick Reference: All Defaults](./docs/settings/ai-config-defaults.md)

## Config Presets
Each config supports:
- `config:SavePreset(name, saveGlobally?)`
- `config:LoadPreset(name, useGlobalIfBothFound?)`
- `config:RestoreDefaults()`
- `config:RestoreActiveConfig()`

## Hook Callbacks
Useful hooks include:
- `Hooks.GoalReached(NPC, Target)`
- `Hooks.StartAcknowledged(NPC, Target)`
- `Hooks.StopAcknowledged(NPC, Target)`
- `Hooks.PathingStarted(NPC, Waypoints)`
- `Hooks.PathingFailed(NPC, Reason)`
- `Hooks.Stuck(NPC, Target)` -> return `true` if handled
- `Hooks.MovingToWaypoint(NPC, Waypoint, MoveType)`
- `Hooks.PathfindingLinkReached(NPC, Waypoint)` -> return `true` if handled

## Example: One-Shot Path
```lua
local AI = require(game:GetService("ReplicatedStorage").Forbidden.AI)
local npc = workspace.NPC
local destination = Vector3.new(0, 5, 0)

AI.SmartPathfind(npc, destination)
```

## Example: Moving Target Chase
```lua
local AI = require(game:GetService("ReplicatedStorage").Forbidden.AI)
local npc = workspace.NPC
local targetPlayer = game.Players:FindFirstChild("TargetName")

local config = AI.GetConfig(npc)
config.Tracking.Enabled = true
config.Tracking.DistanceMovedThreshold = 1
config.DirectMoveTo.Enabled = true
config:ApplyNow()

AI.SmartPathfind(npc, targetPlayer, false, "High")
```

## Testcases In This Repo
The repository includes ready-made test places in [`Testcases`](./Testcases), including:
- `Movement`
- `NPC Logic`
- `LoadTesting`
- `Doors`
- `LineOfSightOperations`
- `PathfindingLogic`
- `RandomCrashing`

## Frameworks & Starting Points
In the discord

## License
MIT (see [`LICENSE`](./LICENSE))
