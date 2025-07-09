--[[ 6/26/25
Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs


TODO://
    states?
]]--

-- == Services == --
local rs                    = game:GetService("ReplicatedStorage")
local PathfindingService    = game:GetService("Pathfinding")


-- == Libraries == --
local RBLXStateMachineLib = require(rs.Forbidden.Packages.robloxstatemachine)


-- == Forbidden Modules & Architecture == --
local root          = script.Parent.Parent
local ConfigHandler = require(root.AI.ConfigHandler)
local MessageQueue  = require(root.AI.MessageQueue)
local DirectMoveTo  = require(root.AI.DirectMoveTo)
local MathModule    = require(root.Math)


-- == External Types == --
local AIT = require(root.AI.Types)


-- == Internal Functions == --



-- == Setup == --
local API = {}
local StateMachines: {[Instance]: {
    Data: {
            time: number,
            Config: AIT.Config
        }
    }?
} = {}
local PathRBXConnections: {[Instance]: {Blocked: RBXScriptConnection?, Unblocked: RBXScriptConnection?, BlockedWaypointIndices: {number}}} = {}


-- == API Functions == --
local function InitializeStateMachine(NPC: Instance)
    if StateMachines[NPC] then return end

    local thisStateMachine = RBLXStateMachineLib.new(
        "Idle", -- Initial State
        RBLXStateMachineLib:LoadDirectory(script.States),
        { -- data
            time = tick(), -- Sends the current tick
            Config = ConfigHandler.GetActiveConfig(NPC)
        }
    )

    StateMachines[NPC] = thisStateMachine
end


--[=[
Computes a path with the current configuration settings for the NPC.

@param NPC <strong>Instance</strong> The NPC to compute the path from. a.k.a. Origin
@param Target <strong>any</strong> The location or instance to compute the path to. a.k.a. Destination

@return <strong>{ PathWaypoint } A table of PathWaypoints to the destination.
]=]

local function onPathBlocked(NPC: Instance, WaypointIndexNumber: number)
    -- do stuff here.
    if StateMachines[NPC].State.Name == "Idle" then return end -- not active path.
end

local function onPathUnblocked(NPC: Instance, WaypointIndexNumber: number)

end

local function DisconnectSignals(NPC: Instance)
    
    -- Initialize
    if not PathRBXConnections[NPC] then 
        PathRBXConnections[NPC] = {Blocked = nil, Unblocked = nil, BlockedWaypointIndices = {}}
        return
    end

    -- Disconnect and cleanup signals
    PathRBXConnections[NPC].Blocked:Disconnect()
    PathRBXConnections[NPC].Unblocked:Disconnect()
    PathRBXConnections[NPC].Blocked = nil
    PathRBXConnections[NPC].Unblocked = nil

    -- Reset blocked wp indices
    PathRBXConnections[NPC].BlockedWaypointIndices = {}

end


local function ConnectSignals(NPC: Instance, Path: Path)

    -- Initialize (I do not believe this is necessary but it does not matter)
    if not PathRBXConnections[NPC] then 
        PathRBXConnections[NPC] = {Blocked = nil, Unblocked = nil, BlockedWaypointIndices = {}}
        return
    end

    PathRBXConnections[NPC].Blocked     = Path.Blocked:Connect(function(wpi: number) onPathBlocked(NPC, wpi) end)
    PathRBXConnections[NPC].Unblocked   = Path.Unblocked:Connect(function(wpi: number) onPathUnblocked(NPC, wpi) end)
    PathRBXConnections[NPC].BlockedWaypointIndices = {} -- technically not necessary
end

-- local LastPathSuccesful: {[Instance]: boolean} = {} 
API.ComputePath = function(NPC: Instance, Target: any): {PathWaypoint}?
    
    -- Get the !active! config for the NPC
    local Config: AIT.Config = ConfigHandler.GetActiveConfig(NPC)


    -- Direct move to stuff.
    DirectMoveTo.


    -- Get the path
    local Path: Path = PathfindingService:CreatePath(Config.AgentInfo)
    


    -- Disconnect current signals and destroy them
    -- This should be done after a successful path compute.
    DisconnectSignals(NPC)
    ConnectSignals(NPC, Path)

    -- default, no path
    return nil
end