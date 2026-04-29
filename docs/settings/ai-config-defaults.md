# AI Config Defaults

This page documents the default values defined in:
- `src/Forbidden/AI/ConfigHandler/Defaults.luau`

Use this as the baseline when writing full wiki pages for each config area.

## Stop Configuration
| Setting | Default | Notes |
|---|---|---|
| `StopType` | `"CurrentPosition"` | On stop, NPC is told to hold position by default. |

## Unstucking
| Setting | Default | Notes |
|---|---|---|
| `Unstucking.Enabled` | `true` | Enables stuck recovery behavior. |
| `Unstucking.FireStuckHook` | `true` | Calls `Hooks.Stuck` before hard failure. |
| `Unstucking.MaxStuckCount` | `2` | Fails path after repeated stuck events. |

## Request Prioritization
| Setting | Default | Notes |
|---|---|---|
| `RequestPrioritization.PreferTimeOverPriority.Enabled` | `true` | Newer requests are preferred over higher-priority older ones. |
| `RequestPrioritization.PreferTimeOverPriority.ResetOlderRequests` | `true` | Older pending request is marked processed when a newer one wins. |

## AgentInfo (PathfindingService)
| Setting | Default |
|---|---|
| `AgentInfo.AgentRadius` | `2.5` |
| `AgentInfo.AgentHeight` | `5` |
| `AgentInfo.AgentCanJump` | `true` |
| `AgentInfo.AgentCanClimb` | `false` |
| `AgentInfo.WaypointSpacing` | `4` |
| `AgentInfo.Costs` | `{Obstacle = math.huge}` |

## Visualization
| Setting | Default | Notes |
|---|---|---|
| `Visualization.Enabled` | `false` | Master visualization switch. |
| `Visualization.Path` | `true` | Draw computed path. |
| `Visualization.PathColor` | `Color3.fromRGB(98, 87, 255)` | Path color. |
| `Visualization.Celling` | `false` | Ceiling offset debug draw. |
| `Visualization.CellingColor` | `Color3.fromRGB(0, 255, 0)` | Ceiling color. |
| `Visualization.MovetoRaycast` | `false` | Draw MoveTo raycasts. |
| `Visualization.MovetoRaycastColor` | `Color3.fromRGB(0, 0, 255)` | Raycast color. |
| `Visualization.Tether` | `false` | Draw tether line. |
| `Visualization.TetherColor` | `Color3.fromRGB(255, 255, 0)` | Tether color. |
| `Visualization.CollisionInferencing` | `false` | Draw inferred collision checks. |

## Tracking
| Setting | Default | Notes |
|---|---|---|
| `Tracking.Enabled` | `false` | Master tracking switch. |
| `Tracking.CollinearTargetPositionOffset` | `2` | Offset target along line in MoveTo ops. |
| `Tracking.PredictionMagnitude` | `2` | Target movement prediction amount. |
| `Tracking.DistanceMovedThreshold` | `1` | Minimum moved studs before retrack. |

## WaypointSkipping
| Setting | Default | Notes |
|---|---|---|
| `WaypointSkipping.RegularPathfindSkip` | `2` | Skip early waypoints in normal pathing. |
| `WaypointSkipping.TrackingPathfindSkip` | `3` | Skip early waypoints in tracking pathing. |

## Tracking.DynamicRetrack.MoveTo
| Setting | Default | Notes |
|---|---|---|
| `Tracking.DynamicRetrack.MoveTo.MinTimer` | `0` | Minimum retrack delay after DirectMoveTo. |
| `Tracking.DynamicRetrack.MoveTo.MaxTimer` | `1` | Maximum retrack delay after DirectMoveTo. |
| `Tracking.DynamicRetrack.MoveTo.GetRetrackTimeFunction` | `max(distance - 20, 0) / 40` | 0s for first ~20 studs, then scales. |
| `Tracking.DynamicRetrack.MoveTo.ShouldRetrackFunction` | `return true` | Always allows retrack by default. |

## Tracking.DynamicRetrack.Pathfind
| Setting | Default | Notes |
|---|---|---|
| `Tracking.DynamicRetrack.Pathfind.MinTimer` | `0.5` | Minimum retrack delay after pathfind. |
| `Tracking.DynamicRetrack.Pathfind.MaxTimer` | `3` | Maximum retrack delay after pathfind. |
| `Tracking.DynamicRetrack.Pathfind.GetRetrackTimeFunction` | `distance / 80` | About 1 second per 80 studs. |
| `Tracking.DynamicRetrack.Pathfind.ShouldRetrackFunction` | `return true` | Always allows retrack by default. |

## DirectMoveTo
| Setting | Default | Notes |
|---|---|---|
| `DirectMoveTo.Enabled` | `true` | Enables direct movement optimization. |
| `DirectMoveTo.ActivationDistance` | `60` | Max target distance to allow DirectMoveTo attempt. |
| `DirectMoveTo.HeightLimit` | `10` | Max Y difference for DirectMoveTo. |
| `DirectMoveTo.TrackingOnly` | `true` | Use DirectMoveTo only in tracking mode by default. |
| `DirectMoveTo.AvoidUseHook` | `nullbind` | Override hook; returning true blocks DirectMoveTo. |

## DirectMoveTo.Raycast
| Setting | Default | Notes |
|---|---|---|
| `DirectMoveTo.Raycast.Enabled` | `true` | Requires line/path clearance checks. |
| `DirectMoveTo.Raycast.Range` | `DirectMoveTo.ActivationDistance + 10` (`70`) | Max raycast range. |
| `DirectMoveTo.Raycast.SeeThroughTransparentParts` | `false` | Transparent parts block by default. |
| `DirectMoveTo.Raycast.SeeThroughNonCollidable` | `true` | Non-collidable parts are ignored. |
| `DirectMoveTo.Raycast.MinimumTransparency` | `0.001` | Transparency threshold if transparency filtering is enabled. |
| `DirectMoveTo.Raycast.FilterAttempts` | `10` | Max re-raycast attempts when filtering hits. |
| `DirectMoveTo.Raycast.OffsetFromOrigin` | `Vector3.new(0, 0, 0)` | Origin offset. |
| `DirectMoveTo.Raycast.OffsetFromTarget` | `Vector3.new(0, 0, 0)` | Target offset. |
| `DirectMoveTo.Raycast.FilterFunction` | `function(hit) return false end` | Custom exclusion function. |

## DirectMoveTo.CollisionInferencing
| Setting | Default | Notes |
|---|---|---|
| `DirectMoveTo.CollisionInferencing.Enabled` | `true` | Enables collider sweep checks. |
| `DirectMoveTo.CollisionInferencing.MinColliderRange` | `max(Tracking.CollinearTargetPositionOffset, AgentInfo.AgentRadius / 2)` (`2`) | Minimum collider size/range basis. |
| `DirectMoveTo.CollisionInferencing.MaxColliderRange` | `3` | Max collider range. |
| `DirectMoveTo.CollisionInferencing.YOffsetFromGround` | `3` | Vertical offset from ground. |
| `DirectMoveTo.CollisionInferencing.YSizeOfCollider` | `1` | Collider Y size. |

## DirectMoveTo.JumpHandler
| Setting | Default | Notes |
|---|---|---|
| `DirectMoveTo.JumpHandler.Enabled` | `false` | Disabled by default. |
| `DirectMoveTo.JumpHandler.MinConditionReachedTime` | `0.25` | Time stuck before jump can trigger. |
| `DirectMoveTo.JumpHandler.NextJumpMinTime` | `1` | Minimum time between jumps. |
| `DirectMoveTo.JumpHandler.DistanceFromMoveToPoint` | `2` | Position threshold around MoveTo point. |
| `DirectMoveTo.JumpHandler.CustomJumpFunction` | `nil` | Optional override jump function. |

## DirectMoveTo.CheckFloor
| Setting | Default | Notes |
|---|---|---|
| `DirectMoveTo.CheckFloor.Enabled` | `true` | Enables floor/void safety checks. |
| `DirectMoveTo.CheckFloor.FailHeight` | `12` | Ground farther than this fails check. |
| `DirectMoveTo.CheckFloor.RaycastSpacing` | `5` | Spacing between floor probes. |
| `DirectMoveTo.CheckFloor.AlwaysRaycastThisDistance` | `2` | Always sample near-NPC floor. |
| `DirectMoveTo.CheckFloor.CheckFrequencyTimer` | `1` | Seconds between floor checks (when possible). |
| `DirectMoveTo.CheckFloor.BlockDirectMoveToTimer` | `3` | Cooldown after floor failure. |
| `DirectMoveTo.CheckFloor.DisableIfDistanceIsLessThan` | `AgentInfo.AgentRadius * 3` (`7.5`) | Near-target floor checks can be skipped. |

## Hooks
| Hook | Default | Notes |
|---|---|---|
| `Hooks.PathfindingLinkReached` | Teleport NPC basepart to waypoint and `return true` | Default implementation handles link position directly. |
| `Hooks.MovingToWaypoint` | `nullbind` | No-op. |
| `Hooks.Stuck` | Random small move + jump + 1s wait | Attempts self-recovery; returns boolean success. |
| `Hooks.GoalReached` | `nullbind` | No-op. |
| `Hooks.StartAcknowledged` | `nullbind` | No-op. |
| `Hooks.StopAcknowledged` | `nullbind` | No-op. |
| `Hooks.PathingFailed` | `nullbind` | No-op. |
| `Hooks.PathingStarted` | `nullbind` | No-op. |

## Debugging
| Setting | Default | Notes |
|---|---|---|
| `Debugging.Enabled` | `false` | Master debugging switch. |
| `Debugging.OutputToConsole` | `true` | Enables console output when debugging is on. |
| `Debugging.StateTransitioning` | `true` | Logs state transitions. |
| `Debugging.MovingToWaypoint` | `false` | Optional move logging. |
| `Debugging.Verbosity` | `3` | Debug log verbosity level. |

## Known Optional Fields In Types
These exist in types but are not explicitly assigned in `Defaults.luau`:
- `DirectMoveTo.Raycast.FilterTable`
- `DirectMoveTo.Raycast.OutputCollision`
- `Debugging.LogToScript`

