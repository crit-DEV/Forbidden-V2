--[[
@rman501, initial implementation - 6/23/25

Contains the default configuration for the ConfigHandler when you request an NPC's config that isn't already initialized.

Recommended not to modify this file, instead use the ConfigHandler to create a preset before loading it.

]]--

local AIT = require(script.Parent.Parent.Types)

local Defaults: AIT.Config = {} :: any

-- == Stop Configuration == --
Defaults.StopType = "CurrentPosition" -- Default stop type is CurrentPosition


-- == Request Prioritization == --
Defaults.RequestPrioritization.PreferTimeOverPriority.Enabled               = true -- if true, the AI will prioritize the latest request over a request with a higher priority
Defaults.RequestPrioritization.PreferTimeOverPriority.ResetOlderRequests    = true -- if true, the AI will ignore older requests when a new request is made, even after the latest request is processed


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

return Defaults

-- TODO:// Add more default values as needed (and we need xD)