--[[ 7/24/25
Cleanups up the API.
This is used to remove any visualizations, waypoints, or other data that was created for the NPC.
This is called when the NPC is removed from the game or when the AI is no longer needed
Prevents memory leaks.

Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs
]]--

-- == Module Declaration ==
local root                  = script.Parent.Parent.Parent
local ConfigHandler             = require(root.AI.ConfigHandler)
local DirectMoveTo              = require(root.AI.DirectMoveTo)
local WaypointLooper            = require(root.AI.PathfindingProcessor.WaypointLooper)
local WaypointsVisualization    = require(root.AI.Visualization.WaypointsVisualization)
local Common                    = require(root.Common)


-- == Initialization ==
local API = {}

API.TriggerCleanup = function(NPC: Instance)

    WaypointsVisualization.DeleteVisualization(NPC)
    
    ConfigHandler.TriggerCleanup(NPC)

    WaypointLooper.TriggerCleanup(NPC)

    DirectMoveTo.TriggerCleanup(NPC)

    Common.TriggerCleanupTypeHelp(NPC)
    
end
