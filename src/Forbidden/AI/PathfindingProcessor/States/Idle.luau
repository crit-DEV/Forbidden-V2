--[[ 6/26/25
Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs


TODO: Trigger check for new op in this file?
]]--

-- == Services == --
local rs = game:GetService("ReplicatedStorage")


-- == References == --
local ForbiddenDir = script.Parent.Parent.Parent.Parent


-- == Packages == --
local RBLXStateMachineLib = require(rs.Forbidden.Packages.robloxstatemachine)


-- == Forbidden Types == --
local AIT                   = require(ForbiddenDir.AI.Types)


-- == Forbidden Modules & Architecture == --
local ForbiddenDebugging    = require(ForbiddenDir.AI.Debugging)
local MessageQueue          = require(ForbiddenDir.AI.MessageQueue)
local Common                = require(ForbiddenDir.Common)
local WaypointLooper        = require(ForbiddenDir.AI.PathfindingProcessor.WaypointLooper)


-- == Setup == --
local Idle = RBLXStateMachineLib.State.new("Idle") -- The name of our state


-- == Assisting Functions == --
local function StopNPCByStopType(data)
    -- Key: LastPathfind, Value: {CurrentIndex: number, Waypoints: {PathWaypoint} }
    local config: AIT.Config = data.Config
    

    -- Same Position
    if config.StopType == "CurrentPosition" then
        local ActualNPC = Common.GetBasePart(config.NPC)
        local NPCHuman = config.NPC:FindFirstChildOfClass("Humanoid")
        if ActualNPC and NPCHuman then
            NPCHuman:MoveTo(ActualNPC.CFrame.Position)
            ActualNPC.CFrame = ActualNPC.CFrame -- maybe not necessary 
        else
            ForbiddenDebugging.Log(config.NPC, "StopNPCByStopType: No ActualNPC or NPCHuman found.")
        end
    end


    -- Next Waypoint
    if config.StopType == "NoStopLogic" then
        -- ! /|\ Developer using Forbidden could code their own here ig. but its intended to be done right after the AI.Stop call. 
    end
end

local function NewRequestHandler(data)

    local config: AIT.Config = data.Config
    
    -- If the state was entered by a Stop Request (or there is an extraneous stop request / none), then acknowledge & return.
    local NextRequest = MessageQueue.GetNewRequest(config.NPC)
    if NextRequest == nil then return end
    if NextRequest.RequestType == "Stop" then 
        if data.Target ~= nil then
            -- stop the NPC.
            StopNPCByStopType(config)
            Idle:ChangeData("Target", nil)
        end
        MessageQueue.SetActiveRequest(config.NPC, NextRequest)
        NextRequest.ProcessingState = "Processed"
        WaypointLooper.EndContinuity(config.NPC)
        task.spawn(config.Hooks.StopAcknowledged, config.NPC, NextRequest.Target)
        -- stop acknowledged hook could go here.
        return 
    end

    -- Acknowledge that the request is being worked on.
    MessageQueue.SetActiveRequest(config.NPC, NextRequest)
    NextRequest.ProcessingState = "Processing"
    
    -- Update Data
    Idle:ChangeData("Request", NextRequest)
    Idle:ChangeData("Target", NextRequest.Target)


    -- Change State
    if NextRequest.Target then
        task.spawn(config.Hooks.StartAcknowledged,config.NPC, NextRequest.Target)
        if config.Tracking.Enabled then
            Idle:ChangeState("Tracking")
        else
            Idle:ChangeState("Pathing")
        end
    else
        ForbiddenDebugging.Log(config.NPC, "No target set for Idle state, cannot change to Pathing or Tracking.")
    end

end


-- == Methods == --
function Idle:OnInit() -- This gets called as soon as the state machine is created
    -- state machine created
end

-- important to have this as it allows an instant recast of another state. (i.e. Tracking -> Idle -> Tracking in 1 hb) (theory)
function Idle:OnEnter(data) -- Called whenever the state changes into "Blue"

    if not data.NPC then error("No NPC in data!") end

    ForbiddenDebugging.Log(data.NPC, "Idle: " .. data.NPC:GetFullName())
    -- Could also write: self.Data.part.Color
    
    -- If another request, then continue.
    NewRequestHandler(data)
end

function Idle:OnHeartbeat(data) -- Called every heartbeat

    -- Get next request
    -- If stop request, acknowledge it.
    -- If a real request, it will continue
    NewRequestHandler(data)
end

function Idle:OnLeave() -- Called whenever the state is left even if target gets destroyed
    local config: AIT.Config = self.Data.Config
    ForbiddenDebugging.Log(config.NPC, "Leaving Idle State for ", config.NPC:GetFullName())
end

return Idle