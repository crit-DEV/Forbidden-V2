--[[
Handles the efficient pathfind bypassing of Forbidden. Instead of pathfinding, if decided, it will use th

Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs

]]--


-- == Forbidden Modules & Architecture == --
local ConfigHandler = require(script.Parent.ConfigHandler)
local Common        = require(script.Parent.Parent.Common)
local MathModule    = require(script.Parent.Parent.Math)


-- == External Types == --
local AIT = require(script.Parent.Types)

-- == Setup == --
local API = {}

-- target has to be instance at this point.
-- which means computing fake point elsewhere.
-- needs to be fore raycast.
API.DoDirectMoveTo = function(NPC: Instance, Target: Instance): boolean

    -- If not an instance, then it is a position, which means it is non-tracking, which means we do not need this setting.
    if typeof(Target) ~= "Instance" then return false end

    local Config: AIT.Config = ConfigHandler.GetActiveConfig(NPC)
    -- if not Config.Tracking.Enabled then return false end     -- maybe use this if path does not compute ?
        -- either way it would not be here.


    local npc_part: BasePart? = Common.GetBasePart(Target)
    if npc_part == nil then error("NO NPC BASE") end

    local target_part: BasePart? = Common.GetBasePart(Target, true, NPC)
    if target_part == nil then error("NO NPC BASE") end

    local npc_pos = npc_part.CFrame.Position
    local target_pos = target_part.CFrame.Position

    local dist = (npc_part - target_pos).Magnitude
    if Config.DirectMoveTo.ActivationDistance < dist then return false end

    local yDist = npc_pos.Y - target_pos.Y
    if Config.DirectMoveTo.HeightLimit < yDist then return false end

    if Config.DirectMoveTo.DoRaycast then
        -- TODO:// update math module and settings to be config handler based ?
        local RaycastSettings: MathModule.RaycastSettings = {
            range = Config.DirectMoveTo.ActivationDistance + 10, 
            SeeThroughTransparentParts = false, 
            SeeThroughNonCollidable = true
        } :: MathModule.RaycastSettings

        if not MathModule.LineOfSight(NPC, Target, RaycastSettings) then return false end
    end

    return true

end

return API