--[[ 6/26/25
Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs


TODO: Trigger check for new op in this file?
]]--

-- == Services == --
local rs = game:GetService("ReplicatedStorage")


-- == Packages == --
local RBLXStateMachineLib = require(rs.Forbidden.Packages.robloxstatemachine)


-- == References == --
local ForbiddenDir = script.Parent.Parent.Parent.Parent


-- == Forbidden Modules & Architecture == --
local ForbiddenDebugging     = require(ForbiddenDir.AI.Debugging)
local MessageQueue           = require(ForbiddenDir.AI.MessageQueue)
local PathfindingProcessor   = require(ForbiddenDir.AI.PathfindingProcessor)
local WaypointLooper         = require(ForbiddenDir.AI.PathfindingProcessor.WaypointLooper)
local RetrackingOptimization = require(ForbiddenDir.AI.RetrackingOptimization) 
local Common                 = require(ForbiddenDir.Common)


-- == Forbidden Types == --
local AIT = require(ForbiddenDir.AI.Types)


-- == Setup == --
local Tracking = RBLXStateMachineLib.State.new("Tracking") -- The name of our state


local function NewRequestHandler(data)

    local config: AIT.Config = data.Config
    
    -- If the state was entered by a Stop Request (or there is an extraneous stop request / none), then acknowledge & return.
    local NextRequest = MessageQueue.GetNewRequest(config.NPC)
    if NextRequest == nil then return end
    
    -- Update State
    Tracking:ChangeState("Idle")

end

-- == Methods == --
function Tracking:OnInit() -- This gets called as soon as the state machine is created
    -- state machine created
end

function Tracking:Pathfind(): boolean
    -- Compute the path to the target.
    print("this might not work!")
    local config: AIT.Config = self.Data.config
    local target: Instance? = self.Data.Target
    if not target then
        ForbiddenDebugging.Log(config.NPC, "No target set for Tracking state, cannot compute path.")
        return false
    end

    local waypoints = PathfindingProcessor.ComputePath(config.NPC, target)
    if not waypoints then
        ForbiddenDebugging.Log(config.NPC, "Failed to compute path for Tracking state.")
        return false
    end

    -- Set the waypoints in the state data.
    Tracking:ChangeData("Waypoints", waypoints)
    Tracking:ChangeData("LastTrackingRecall", os.clock())
    if #waypoints > 1 then
        Tracking:ChangeData("RecallType", "Pathfind")
    else
        Tracking:ChangeData("RecallType", "DirectMoveTo")
    end

    -- Start the waypoint looper.
    local function completedSignal()
        -- This function is called when the waypoint looper completes.
        -- not needed for tracking.
    end

    WaypointLooper.StartContinuity(config.NPC, target, waypoints, completedSignal)
    return true
end

function Tracking:OnEnter(data) -- Called whenever the state changes into "Blue"

    if not data.NPC then error("No NPC in data!") end

    print("Tracking: " .. data.NPC:GetFullName())
    -- Could also write: self.Data.part.Color
    Tracking:ChangeData("LastTrackingRecall", 0)
end

function Tracking:OnHeartbeat(data) -- Called every heartbeat
    NewRequestHandler(data)

    local config: AIT.Config = data.Config
    local NPC: Instance = config.NPC

    local NextRecallTime = data.LastTrackingRecall + RetrackingOptimization.GetDynamicRetrackTimer(NPC, data.Target, data.RecallType)
    if os.clock() < NextRecallTime then return end -- not time to recall yet.

    ForbiddenDebugging.Log("Recalling!")
    local success = Tracking:Pathfind()
    if not success then ForbiddenDebugging.Log(NPC, "Recall failed! Target: ", data.Target) end
end

function Tracking:OnLeave() -- Called whenever the state is left even if target gets destroyed
    local config: AIT.Config = self.Data.Config
    ForbiddenDebugging.Log(config.NPC, "Leaving Tracking State for ", config.NPC:GetFullName())
end

return Tracking