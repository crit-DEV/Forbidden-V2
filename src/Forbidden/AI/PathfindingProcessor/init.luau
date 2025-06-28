--[[ 6/26/25
Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs


TODO://
    states?
]]--

-- == Services == --
local rs = game:GetService("ReplicatedStorage")


-- == Libraries == --
local RBLXStateMachineLib = require(rs.Forbidden.Packages.robloxstatemachine)


-- == Forbidden Modules & Architecture == --
local ConfigHandler = require(script.Parent.ConfigHandler)
local MessageQueue  = require(script.Parent.MessageQueue)


-- == Types == --
local AIT = require(script.Parent.Types)


-- == Internal Functions



-- == Setup == --
local API = {}
local StateMachines: {[Instance]: "StateMachine"}


-- == API Functions == --
local function InitializeStateMachine(NPC: Instance)
    if StateMachines[NPC] then return end

    local thisStateMachine = RBLXStateMachineLib.new(
        "Idle", -- Initial State
        RBLXStateMachineLib:LoadDirectory(
            script.States, 
            {"Idle", "Paused", "Paused", "Tracking"}), -- States to load
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
API.ComputePath = function(NPC: Instance, Target: any): {PathWaypoint}
    
end