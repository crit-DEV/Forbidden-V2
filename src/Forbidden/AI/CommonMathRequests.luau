--[[
Common Math & LOS Pre-Written Here
/!\ Forbidden Use Only /!\
Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs

]]--

-- == Setup == --
local API = {}


-- == Forbidden Modules & Architecture == --
local root = script.Parent.Parent
local Common        = require(root.Common)
local MathModule    = require(root.Math)
local ConfigHandler = require(root.AI.ConfigHandler)
local ForbiddenDebugging = require(root.AI.Debugging)

-- == API Functions == --
-- Target should be best of class (i.e. if char should be the model,   if part should be a part,   if pos should be the Common.GetBasePart)
API.CanMoveToRaycast = function(NPC: Instance, Target: Instance): boolean

    -- == Config == --
    local config = ConfigHandler.GetActiveConfig(NPC)
    if not config.DirectMoveTo.Raycast.Enabled then return true end

    local RaycastSettings: MathModule.RaycastSettings = config.DirectMoveTo.Raycast :: any


    return MathModule.LineOfSight(NPC, Target, RaycastSettings)
end

-- Checks if the floor is crossable (heuristic)
API.CanCrossFloorRaycast = function(NPC: Instance, Target: any): boolean
    
    local config = ConfigHandler.GetActiveConfig(NPC)
    
    -- Get parts
    local npc_main      = Common.GetBasePart(NPC, true, NPC)
    local target_main   = Common.GetBasePart(Target, true, NPC)

    if npc_main == nil then error("Cannot get BasePart in NPC: " .. NPC:GetFullName()) end
    if target_main == nil then error("Cannot get BasePart in Target: " .. Target:GetFullName()) end

    -- Information
    local subv3 = (target_main.CFrame.Position - npc_main.CFrame.Position)
    local dist  = subv3.Magnitude
    local dir   = subv3.Unit

    -- Helpful Functions
    local function ValidRaycastToGround(Position: Vector3)
        
        local raycastParams = RaycastParams.new()
        local filterTable = {NPC}
        if typeof(Target) == "Instance" then raycastParams:AddToFilter(Target) else raycastParams:AddToFilter(target_main) end
        raycastParams.FilterDescendantsInstances = filterTable
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.RespectCanCollide = true

        local result = workspace:Raycast(Position, Vector3.new(0, -1, 0) * config.DirectMoveTo.CheckFloor.FailHeight, raycastParams)
        -- ForbiddenDebugging.LogWithVerbosity(NPC, 5, "Distance To Ground: " .. tostring(result.Distance) .. " | Position: (" .. string.format("%.3f", result.Position.X) .. ", ", string.format("%.3f", result.Position.Y) .. ", " .. string.format("%.3f", result.Position.Z) .. ")")
        return result ~= nil
    end

    -- AlwaysRaycastThisDistance proc
    local function FirstRaycastValid()
        if config.DirectMoveTo.CheckFloor.AlwaysRaycastThisDistance ~= 0 then -- check if feature enabled.
            if dist > config.DirectMoveTo.CheckFloor.AlwaysRaycastThisDistance then return true end -- if too close return true.
            return ValidRaycastToGround(npc_main.CFrame.Position + dir * config.DirectMoveTo.CheckFloor.AlwaysRaycastThisDistance)
        end

        return true
    end

    -- Check if valid
    if not FirstRaycastValid() then return false end
    
    -- Check, starting from target, if the ground is valid every 5 places
    local distRemaining = dist
    while distRemaining - config.DirectMoveTo.CheckFloor.RaycastSpacing > config.DirectMoveTo.CheckFloor.AlwaysRaycastThisDistance do
        distRemaining -= config.DirectMoveTo.CheckFloor.RaycastSpacing
        if not ValidRaycastToGround(npc_main.CFrame.Position + distRemaining * dir) then return false end
    end

    return true
end

return API