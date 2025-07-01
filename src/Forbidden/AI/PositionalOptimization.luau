--[[
Developer History
    > @crit-dev (@rman501), initial commit
        o7 to future devs

]]--

-- == Services == --
local rs                    = game:GetService("ReplicatedStorage")
local PathfindingService    = game:GetService("Pathfinding")


-- == Libraries == --
local RBLXStateMachineLib = require(rs.Forbidden.Packages.robloxstatemachine)


-- == Forbidden Modules & Architecture == --
local ConfigHandler = require(script.Parent.ConfigHandler)

-- == Types == --


-- == Setup == --
local API = {}


-- == API Functions == --
--[=[
    Returns the closest position on the ground beneath a position, cannot exceed a height limit.
    
    @param Position <strong>Vector3</strong> Origin position of the raycast.
    @param HeightLimit <strong>number?</strong> The limit of the distance the raycast can be grounded by. (default: 3 studs)
    
    @return <strong>Vector3?</strong> Returns the grounded position or <strong>nil</strong> if not possible.
]=]
API.GetGroundedPosition = function(Position: Vector3, PartsToFilter: {BasePart}, HeightLimit: number?): Vector3?

    -- 10/24/24 @rman501, added adjustedTargetPos.
    local raycastParams = RaycastParams.new()
    local filterTable = {PartsToFilter}
    
    raycastParams.FilterDescendantsInstances = filterTable
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.RespectCanCollide = true
    -- raycastParams:AddToFilter(???) -- can be table or instance

    local range = 3
    if HeightLimit then range = HeightLimit end

    local result = workspace:Raycast(Position, Vector3.new(0, -1, 0) * range, raycastParams)

    if result == nil then return nil end -- 10/26/24 @rman501, edge case.
    if result.Instance then
        --print(part.CFrame.Position - hitPoint)
        return result.Position + Vector3.new(0,2,0) -- 8/31/24 add slight y offset
    end

    return Position
end

-- these todos in ComputePath
-- TODO:// use dir between 2 wps and dist ??? (for offsetting a pf (no track, or maybe even w/ track))
-- TODO:// if dist < offset then return cur pos?
--[=[
    Returns a position in the direction of <code>Origin</code> from Target, the magnitude of which is determined by Offset.
    
    @param Position <strong>Vector3</strong> Origin position of the raycast.
    @param HeightLimit <strong>number?</strong> The limit of the distance the raycast can be grounded by. (default: 3 studs)
    
    @return <strong>Vector3?</strong> Returns the grounded position or <strong>nil</strong> if not possible.
]=]
API.GetCollinearTargetPositionOffset = function(Origin: Vector3, Target: Vector3, Offset: number): Vector3
    local delta: Vector3 = Origin - Target
    if delta.Magnitude == 0 then
        return Target -- or some sensible fallback
    end

    return Target + (delta.Unit * Offset)
end