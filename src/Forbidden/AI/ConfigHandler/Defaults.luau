--[[
Contains the default configuration for the ConfigHandler when you request an NPC's config that isn't already initialized.

Recommended not to modify this file, instead use the ConfigHandler to create a preset before loading it.

Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs

]]--

local AIT = require(script.Parent.Parent.Types)

-- == Setup == --
local Defaults: AIT.Config = {} :: any
local function nullbind() end

-- == Stop Configuration == --
Defaults.StopType = "CurrentPosition" -- Default stop type is CurrentPosition


-- == Request Prioritization == --
Defaults.RequestPrioritization.PreferTimeOverPriority.Enabled               = true -- if true, the AI will prioritize the latest request over a request with a higher priority
Defaults.RequestPrioritization.PreferTimeOverPriority.ResetOlderRequests    = true -- if true, the AI will ignore older requests when a new request is made, even after the latest request is processed


-- == Agent Info == --
-- look at link below for in-depth explanation.
-- resource link: https://create.roblox.com/docs/characters/pathfinding#create-paths:~:text=Default-,AgentRadius,-Agent%20radius%2C%20in
Defaults.AgentInfo.AgentRadius      = 2.5
Defaults.AgentInfo.AgentHeight      = 5
Defaults.AgentInfo.AgentCanJump     = true
Defaults.AgentInfo.AgentCanClimb    = false
Defaults.AgentInfo.WaypointSpacing  = 4
Defaults.AgentInfo.Costs            = {} -- {Water = 20, myPFLink = 10, etc...}


-- == Visualization Configuration == --
Defaults.Visualization.Enabled              = false -- Master control for visualization
Defaults.Visualization.Path                 = true -- Show the path the NPC will take
Defaults.Visualization.PathColor            = Color3.fromRGB(255, 0, 0) -- (RED) Color of the path visualization
Defaults.Visualization.Celling              = false -- celling visualization, if true, the NPC will visualize the offset of the path to avoid obstacles around it.
Defaults.Visualization.CellingColor         = Color3.fromRGB(0, 255, 0) -- (GREEN) Color of the celling visualization
Defaults.Visualization.MovetoRaycast        = false -- Show the raycast used for MoveTo
Defaults.Visualization.MovetoRaycastColor   = Color3.fromRGB(0, 0, 255) -- (BLUE) Color of the raycast visualization
Defaults.Visualization.Tether               = false -- Show the tether between the NPCs if they are tethered together
Defaults.Visualization.TetherColor          = Color3.fromRGB(255, 255, 0) -- (YELLOW) Color of the tether visualization

-- == Tracking Configuration == --
Defaults.Tracking.Enabled                           = false -- Master control for tracking
Defaults.Tracking.CollinearTargetPositionOffset     = 1 -- If set, the NPC will offset the target's position by this amount when calculating the path (only when using Moveto ops)
Defaults.Tracking.PredictionMagnitude               = 1 -- If true, the NPC will predict the target's movement and adjust its path accordingly

-- == Direct MoveTo Configuration == --
Defaults.DirectMoveTo.ActivationDistance    = 20    -- If the distance between the NPC & Target is less than this setting, it will be possible to use DirectMoveTo.
Defaults.DirectMoveTo.HeightLimit           = 5     -- If the difference between the Y position of the NPC & Target is less than this setting, it will be possible to use DirectMoveTo
Defaults.DirectMoveTo.JumpHandler           = true  -- Allows Forbidden to make use of the JumpHandler when using DirectMoveTo
Defaults.DirectMoveTo.DoRaycast             = true  -- Enables raycasting that must return a positive result ot use the DirectMoveTo method.
Defaults.DirectMoveTo.TrackingOnly          = true
Defaults.DirectMoveTo.AvoidUseHook          = nullbind  -- Allows the user to add a custom function which is called every time DirectMoveTo could potentially be used, if a value of TRUE is returned, the system will NOT use DirectMoveTo.
-- == Visualization Configuration == --
Defaults.Debugging.Enabled = false -- Master control for debugging
Defaults.Debugging.OutputToConsole = true
Defaults.Debugging.StateTransitioning = true
-- Defaults.Debugging.LogToScript = true -- prints all outputs from Forbidden AI to a file.

return Defaults

-- TODO:// Add more default values as needed (and we need xD)