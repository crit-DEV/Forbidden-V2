-- All Type Files have a T Prefix
-- Makes it easier to identify types in the codebase
-- Makes it so that its easier to locate windows in the codebase

export type Config = {
    -- Config Metadata
    NPC: Instance,
    RestoreDefaults: (self: Config) -> (),
    RestoreActiveConfig: (self: Config) -> (),
    SavePreset: (self: Config, PresetName: string, SaveGlobally: boolean?) -> (),
    LoadPreset: (self: Config, PresetName: string, UseGlobalIfBothFound: boolean?) -> (),
    ApplyNow: (self: Config) -> (),
    -- Actual Settings
    StopType: StopType,
    Visualization: Visualization,
    Debugging: Debugging,
    AgentInfo: AgentInfo,
    RequestPrioritization: RequestPrioritization, -- if true, the AI will ignore the stop operation and continue moving to the next target
    ResetOlderRequests: boolean, -- if true, the AI will ignore older requests when a new request is made
    Tracking: Tracking,
    DirectMoveTo: DirectMoveTo,
    Hooks: Hooks
}

type Hooks = {
    PathfindingLinkReached: (NPC: Instance, Waypoint: PathWaypoint) -> (boolean),
    MovingToWaypoint: (NPC: Instance, Waypoint: PathWaypoint, MoveType: "DirectMoveTo" | "Pathing" | "PathfindingLink") -> (),
    Stuck: (NPC: Instance, Target: Instance) -> (boolean),
    GoalReached: (NPC: Instance, Target: any) -> (),
    StopAcknowledged: (NPC: Instance, Target: any) -> (),
    StartAcknowledged: (NPC: Instance, Target: any) -> ()
}


type DirectMoveTo = {
    Enabled: boolean,
    ActivationDistance: number,
    DoRaycast: boolean,
    JumpHandler: boolean,
    CheckFloor: CheckFloor,
    TrackingOnly: boolean,
    HeightLimit: number, -- if it exceeds this height limit, it will not use DirectMoveTo
    AvoidUseHook: () -> boolean -- if this returns true, DirectMoveTo will not be used.
}

type CheckFloor = {
    Enabled: boolean,
    DisableIfDistanceIsLessThan: number, -- if the distance to the target is less than this, it will not check the floor
    BlockDirectMoveToTimer: number, -- if the floor is missing, block another attempt for `x` seconds.
    CheckFrequencyTimer: number,
    RaycastSpacing: number,
    AlwaysRaycastThisDistance: number,
    FailHeight: number
}


type RequestPrioritization = {
    PreferTimeOverPriority: {
        Enabled: boolean, -- if true, the AI will prioritize the latest request over a request with a higher priority
        ResetOlderRequests: boolean, -- if true, the AI will ignore older requests when a new request is made, even after the latest request is processed
    },
}

-- TODO:// research how to use roblox doc's to show defaults etc...
export type StopType = "CurrentPosition" | "NoStopLogic"
type Visualization = {
    Enabled: boolean, -- Master control for visualization
    Path: boolean,
    PathColor: Color3,
    Celling: boolean,
    CellingColor: Color3,
    MovetoRaycast: boolean,
    MovetoRaycastColor: Color3,
    Tether: boolean,
    TetherColor: Color3
}

type Debugging = {
    Enabled: boolean,
    StateTransitioning: boolean,
    OutputToConsole: boolean,
    -- LogToScript: boolean
}

export type AgentInfo = {
    AgentRadius: number,
    AgentHeight: number,
    AgentCanJump: boolean,
    AgentCanClimb: boolean,
    WaypointSpacing: number,
    Costs: {[string]: number}
}

type Tracking = {
    Enabled: boolean, -- Master control for tracking
    PredictionMagnitude: number, -- The amount of studs ahead the NPC predicts the target's movement (in direction of the target's movement)
    CollinearTargetPositionOffset: number, -- If set, the NPC will offset the target's position by this amount when calculating the path 
    DynamicRetrack: {
        MoveTo: BaseDynamicRetrackTimerConfig,
        Pathfind: BaseDynamicRetrackTimerConfig
    },
    SkipToWaypoint: number -- skips to x waypoint
}

type BaseDynamicRetrackTimerConfig = {
    MinTimer: number,
    MaxTimer: number,
    GetRetrackTimeFunction: (NPC: Instance, Target: any) -> (number),
    ShouldRetrackFunction: (NPC: Instance, Target: any) -> (boolean)
}

return {}